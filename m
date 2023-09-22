Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319AB7ABC2A
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 01:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjIVXIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 19:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjIVXIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 19:08:34 -0400
Received: from out-206.mta0.migadu.com (out-206.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ce])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDD198
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 16:08:28 -0700 (PDT)
Date:   Fri, 22 Sep 2023 23:08:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695424106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xpFIobQExILClkKTeW/cYTjEqv/q/JhNQ5dNQFV+wwI=;
        b=kuu5l9LqbKERXQkbxSoPFZr+vhTqJo0n9KLjbOq+Bw8pI2bWwNuniOOFNrY0pPgXTDHw3V
        72w3I8obqdyQTx8tLoPTjhE27dMtLWYQx+tP/Z1N4xBa/Jh8q/Zj505aw6lIbnKoJqH+Jq
        f9RQc0JPWIG5DIG2gUIZHPZOfyByFi4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Vipin Sharma <vipinsh@google.com>,
        Jing Zhang <jingzhangos@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always invalidate TLB for stage-2 permission
 faults
Message-ID: <ZQ4eZcWRO/nHnGc4@linux.dev>
References: <20230922223229.1608155-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922223229.1608155-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 10:32:29PM +0000, Oliver Upton wrote:
> It is possible for multiple vCPUs to fault on the same IPA and attempt
> to resolve the fault. One of the page table walks will actually update
> the PTE and the rest will return -EAGAIN per our race detection scheme.
> KVM elides the TLB invalidation on the racing threads as the return
> value is nonzero.
> 
> Before commit a12ab1378a88 ("KVM: arm64: Use local TLBI on permission
> relaxation") KVM always used broadcast TLB invalidations when handling
> permission faults, which had the convenient property of making the
> stage-2 updates visible to all CPUs in the system. However now we do a
> local invalidation, and TLBI elision leads to vCPUs getting stuck in a
> permission fault loop. Remember that the architecture permits the TLB to
> cache translations that precipitate a permission fault.

The effects of this are slightly overstated (got ahead of myself).
EAGAIN only crops up if the cmpxchg() fails, we return 0 if the PTE
didn't need to be updated.

On the subsequent permission fault we'll do the right thing and
invalidate the TLB, so this change is purely an optimization rather than
a correctness issue.

> Invalidate the TLB entry responsible for the permission fault if the
> stage-2 descriptor has been relaxed, regardless of which thread actually
> did the job.
> 
> Cc: stable@vger.kernel.org
> Fixes: a12ab1378a88 ("KVM: arm64: Use local TLBI on permission relaxation")

I'll drop the stable tag.

> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f155b8c9e98c..286888751793 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1314,7 +1314,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
>  				       KVM_PGTABLE_WALK_HANDLE_FAULT |
>  				       KVM_PGTABLE_WALK_SHARED);
> -	if (!ret)
> +	if (!ret || ret == -EAGAIN)
>  		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
>  	return ret;
>  }
> 
> base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
> -- 
> 2.42.0.515.g380fc7ccd1-goog
> 

-- 
Thanks,
Oliver
