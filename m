Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03151634935
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 22:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbiKVV0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 16:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiKVV0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 16:26:14 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDE91C12
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 13:26:13 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u7-20020a170902e5c700b0018937578945so1478643plf.10
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 13:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zgimOf2fhkQleYDBm+3WEMJX9iyYgXrpyh87WZyj3iY=;
        b=lVv2mTakLyH0mUQEmNwxYoDh+3DxuzDGtIVYSniYeHvEtMOtdEPVoNfksWen4QT0H0
         6H+2+LjZrO2G2h88rSxZ39aZ/CfY0OGjAs5EHQcpFqTCqSYHCLCig1EK8P3sZQl49ALf
         GB5hn6rrVf3oqbw3wC1vBug2kvL1DcUtnatLFJfLk5JoA4NWjjhtmQllFS/q3Ka0CbhH
         rKjGCIHW3yFzoUJHB2j4HiD2Vg8M2MXcHFbxzCvuEIufeJfbB2jT5YBXs3kOOIcgukES
         XZGYLg62U2fMD2/rIUXsFc6d9o7uDcAUBjoJRL7j4vx4/+Yi4UQUBtUQSR2PqoeWb5oz
         xNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgimOf2fhkQleYDBm+3WEMJX9iyYgXrpyh87WZyj3iY=;
        b=qtLLTtL55latp7g4YdkiEVjYXsj6OQJeyc2+BXXB+Mnf8ZBrX4kCZIj5WpiJuuLaX0
         DKLgODCkgP3rHYcbe1s+TPTZ1naUdvNR2lN9gadTjBlYiX8BsM83/GO5u7R7reSUAwdW
         qiKvGLewko1vRsGcyUVfoLz30qubB2tnBERGDdqMukOa+p3MPpeVPsy6VDhVphv1C54x
         jrOw/+ashS+2GQNqK8CPemV9oevIOmzL6589d+EXe5pJS3WRnr0vs3vKDhCdDITOejHx
         3bkS3m0Cej1CF1vA3yx+3ICFXyNJlTorWDxZ5acu8xYnUVsJzll55L/3aN9+pnkWGBdD
         zgpg==
X-Gm-Message-State: ANoB5pmJ+vW8FOjhLFZ4T3Fu8G7NRxXii1VGm7fZALcpElCKZGHWyye6
        SWIioL2vPdhrqjkM4P0d8Ya2MIjyu4mX/MALEQ==
X-Google-Smtp-Source: AA0mqf6tF7wuZFNnT06MIDxN4K88WuS+gvWo34APH7cHAv8iYvQPOdJIW8aHcfgRyichIBKp9SpUgsF/jBKIFuZIDA==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a63:cd57:0:b0:46e:c9d0:96c with SMTP
 id a23-20020a63cd57000000b0046ec9d0096cmr4913454pgj.586.1669152372521; Tue,
 22 Nov 2022 13:26:12 -0800 (PST)
Date:   Tue, 22 Nov 2022 13:26:10 -0800
In-Reply-To: <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
Message-ID: <diqzedtubs0d.fsf@google.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
From:   Ackerley Tng <ackerleytng@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com,
        sean.j.christopherson@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Sean Christopherson <sean.j.christopherson@intel.com>

> TDX supports only write-back(WB) memory type for private memory
> architecturally so that (virtualized) memory type change doesn't make  
> sense
> for private memory.  Also currently, page migration isn't supported for  
> TDX
> yet. (TDX architecturally supports page migration. it's KVM and kernel
> implementation issue.)

> Regarding memory type change (mtrr virtualization and lapic page mapping
> change), pages are zapped by kvm_zap_gfn_range().  On the next KVM page
> fault, the SPTE entry with a new memory type for the page is populated.
> Regarding page migration, pages are zapped by the mmu notifier. On the  
> next
> KVM page fault, the new migrated page is populated.  Don't zap private
> pages on unmapping for those two cases.

> When deleting/moving a KVM memory slot, zap private pages. Typically
> tearing down VM.  Don't invalidate private page tables. i.e. zap only leaf
> SPTEs for KVM mmu that has a shared bit mask. The existing
> kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-lock
> of mmu_lock so that other vcpu can operate on KVM mmu concurrently.  It
> marks the root page table invalid and zaps SPTEs of the root page
> tables. The TDX module doesn't allow to unlink a protected root page table
> from the hardware and then allocate a new one for it. i.e. replacing a
> protected root page table.  Instead, zap only leaf SPTEs for KVM mmu with  
> a
> shared bit mask set.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 85 ++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++++---
>   arch/x86/kvm/mmu/tdp_mmu.h |  5 ++-
>   3 files changed, 103 insertions(+), 11 deletions(-)

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index faf69774c7ce..0237e143299c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1577,8 +1577,38 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct  
> kvm_gfn_range *range)
>   	if (kvm_memslots_have_rmaps(kvm))
>   		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);

> -	if (is_tdp_mmu_enabled(kvm))
> -		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> +	if (is_tdp_mmu_enabled(kvm)) {
> +		bool zap_private;

We should initialize zap_private to true, otherwise zap_private is
uninitialized in call

     kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private)

if the condition

     if (kvm_slot_can_be_private(range->slot)) {

evaluates to false.

> +
> +		if (kvm_slot_can_be_private(range->slot)) {
> +			if (range->flags & KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM)
> +				/*
> +				 * For private slot, the callback is triggered
> +				 * via falloc.  Mode can be allocation or punch
> +				 * hole.  Because the private-shared conversion
> +				 * is done via
> +				 * KVM_MEMORY_ENCRYPT_REG/UNREG_REGION, we can
> +				 * ignore the request from restrictedmem.
> +				 */
> +				return flush;
> +			else if (range->flags & KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR) {
> +				if (range->attr == KVM_MEM_ATTR_SHARED)
> +					zap_private = true;
> +				else {
> +					WARN_ON_ONCE(range->attr != KVM_MEM_ATTR_PRIVATE);
> +					zap_private = false;
> +				}
> +			} else
> +				/*
> +				 * kvm_unmap_gfn_range() is called via mmu
> +				 * notifier.  For now page migration for private
> +				 * page isn't supported yet, don't zap private
> +				 * pages.
> +				 */
> +				zap_private = false;
> +		}
> +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private);
> +	}

>   	return flush;
>   }
