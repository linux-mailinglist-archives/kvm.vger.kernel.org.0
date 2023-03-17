Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936E96BF091
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCQSSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjCQSSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:18:33 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [IPv6:2001:41d0:1004:224b::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C80D51C9A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:18:32 -0700 (PDT)
Date:   Fri, 17 Mar 2023 18:18:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679077110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVEUtfxXv5RFT8T9AeWwsUB1uiB3mUVqjQaYVU5IIV0=;
        b=U25rQ2DAxqgk816tDALuJ+QXJ9wR5VsI8hN6AEVS4HHwCQUhRvve0htNpbNiTq7E8y9sIo
        f50y76L6XTBeWPvak24nP/c1OoPKgV2dRsGQ48kNa/lLL6/Ap7vwpN74DXGtAaOHuPPUgr
        zkX8VIAMAqVuhi+gLRjkv50npIuWcQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 11/14] KVM: arm64: Allow user_mem_abort to return
 0 to signal a 'normal' exit
Message-ID: <ZBSu8tWAEm5oR2K4@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-12-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-12-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:35AM +0000, Anish Moorthy wrote:
> kvm_handle_guest_abort currently just returns 1 if user_mem_abort
> returns 0. Since 1 is the "resume the guest" code, user_mem_abort is
> essentially incapable of triggering a "normal" exit: it can only trigger
> exits by returning a negative value, which indicates an error.
> 
> Remove the "if (ret == 0) ret = 1;" statement from
> kvm_handle_guest_abort and refactor user_mem_abort slightly to allow it
> to trigger 'normal' exits by returning 0.

You should append '()' to function names, as it makes it abundantly obvious to
the reader that the symbols you describe are indeed functions.

I find the changelog a bit too mechanical and doesn't capture the nuance.

  Generally, in the context of a vCPU exit, a return value of 1 is used
  to indicate KVM should return to the guest and 0 is used to complete a
  'normal' exit to userspace. user_mem_abort() deviates from this
  slightly, using 0 to return to the guest.

  Just return 1 from user_mem_abort() to return to the guest and drop
  the return code conversion from kvm_handle_guest_abort(). It is now
  possible to do a 'normal' exit to userspace from user_mem_abort(),
  which will be used in a later change.

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7113587222ffe..735044859eb25 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1190,7 +1190,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
>  {
> -	int ret = 0;
> +	int ret = 1;
>  	bool write_fault, writable, force_pte = false;
>  	bool exec_fault;
>  	bool device = false;
> @@ -1281,8 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	    (logging_active && write_fault)) {
>  		ret = kvm_mmu_topup_memory_cache(memcache,
>  						 kvm_mmu_cache_min_pages(kvm));
> -		if (ret)
> +		if (ret < 0)

There's no need to change this condition.

>  			return ret;
> +		else
> +			ret = 1;

I'd prefer if you set 'ret' close to where it is actually used, which I
believe is only if mmu_invalidate_retry():

	if (mmu_invalidate_retry(kvm, mmu_seq)) {
		ret = 1;
		goto out_unlock;
	}

Otherwise ret gets written to before exiting.

-- 
Thanks,
Oliver
