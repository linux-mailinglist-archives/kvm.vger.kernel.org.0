Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B021D7A2AC4
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 00:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbjIOWyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 18:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbjIOWyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 18:54:16 -0400
Received: from out-226.mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0183483
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 15:54:10 -0700 (PDT)
Date:   Fri, 15 Sep 2023 22:54:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694818449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KidOv9DSZAjEZIZG6nwJqS8LlzxpoGzMBkcO8YHnSf0=;
        b=WpMdNxCJephGV00l0B7yPCHwJbcig2u/mPAQIlQXMhAkBzaV71kc9ZStGjZVb0J8KxbB4H
        wmahZeT7OIkpM11aCJLlk6M1LnDM4sA59JYyM+fE7lzL1PjC8WYDJe3ZPwI4mdCC5r1tZi
        6uhV6toXbUvDDuFW9mRy1Yv/jLvKVlM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Message-ID: <ZQTgi/lsClyM6b1j@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 10:35:24AM +0100, Shameer Kolothum wrote:
> We only set DBM if the page is writeable (S2AP[1] == 1). But once migration
> starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and there
> isn't an easy way to differentiate the writeable pages that gets write
> protected from read-only pages as we only have S2AP[1] bit to check.
> 
> Introduced a ctx->flag KVM_PGTABLE_WALK_WC_HINT to identify the dirty page
> tracking related write-protect page table walk and used one of the "Reserved
> for software use" bit in page descriptor to mark a page as "writeable-clean". 
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index a12add002b89..67bcbc5984f9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -190,6 +190,8 @@ enum kvm_pgtable_prot {
>  #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
>  #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
>  
> +#define KVM_PGTABLE_PROT_WC	KVM_PGTABLE_PROT_SW0  /*write-clean*/
> +
>  #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
>  #define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
>  
> @@ -221,6 +223,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   *					operations required.
>   * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute update is
>   *					HW DBM related.
> + * @KVM_PGTABLE_WALK_WC_HINT:		Update the page as writeable-clean(software attribute)
> + *					if we are write protecting a writeable page.

This really looks like a permission bit, not a walker flag. This should
be defined in kvm_pgtable_prot and converted to the hardware definition
in stage2_set_prot_attr(). Also, the first time I saw 'WC' I read it as
'write-combine', not writable-clean.

As I understand it, the only need for an additional software bit here is
to identify neighboring PTEs that can have DBM set while we're in the
middle of the walk right?

-- 
Thanks,
Oliver
