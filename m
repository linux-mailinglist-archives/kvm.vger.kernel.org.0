Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1FA7329F8
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245178AbjFPIgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244718AbjFPIg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA95630FB
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 01:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686904531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPY8mg0jxuqun1aPaAtNaVksF8bWjZS2YCR1atB3dxE=;
        b=Vp0azCoCUpNmRWgtrIFak2JOroAdMD1/sMVilx8VqWiHuIm2+k4gWh+LRFu+gKdtS1XDZL
        trZqRgAZhivEmj0M5AhK+cTx+WpXU/C9hUXYw+rrNOSO8Lvz25Axvdf880dxqQPbU/JM9Q
        icLL5tsyDN2Luc9EwfLiPEOlV5EPDfs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-mRDTCdEGPxeOYggwGY16og-1; Fri, 16 Jun 2023 04:35:30 -0400
X-MC-Unique: mRDTCdEGPxeOYggwGY16og-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3110acc0042so80779f8f.1
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 01:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686904529; x=1689496529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPY8mg0jxuqun1aPaAtNaVksF8bWjZS2YCR1atB3dxE=;
        b=eQ5q33rvDwBIUKKzEnCriA3kByGGrxwSPBlP2fhXXyY4YW86WKmTQzvOIoLr9Lvi2f
         Ij/NfflI2BOWNCd7tpcSk9QzIlZYWKd6t5RF9HL3YCjoQsjysIyIz2gArCiIOUR82//t
         mRzEEejpWFTPr1UXRs6TReuYCNXOOSFNfMfPfuI7+ibV+QjHTHA7rMdOP9f/6fPATEGD
         0EVnMbrBNUtkiaTZEdufkaPwrcosbI4d/Cb7fMzAvPUdXdjtfGJKx4+71AMeClwg+YYn
         Wk9yfOOF8rKfuY2sEAnVKdoG3owJ9QHHl+IHy+nZIXiNtC3wtl5x5LtmoprzNqWyOxMy
         DL3A==
X-Gm-Message-State: AC+VfDwmL5JyPLFenAT2Je9sUaKxzJGhFMF5X+Zj6g6CDeJtQjq8Oqhf
        P6soaaL5MaYwPRWl0WmdUO+Gb3xc7vK/xPV02mK8YUaLyOUJ833/n5FtwG60xZk2/bv03U4sU2G
        oKxqUA62MB5on
X-Received: by 2002:a5d:4b08:0:b0:307:5561:5eec with SMTP id v8-20020a5d4b08000000b0030755615eecmr993228wrq.0.1686904529246;
        Fri, 16 Jun 2023 01:35:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5kzV+/7/dVCXo13XaZMI6EFcFN2DW5D8H1UUaaDdWD7gjszkEhR6SrO+93PHjRuvl1lmH6dg==
X-Received: by 2002:a5d:4b08:0:b0:307:5561:5eec with SMTP id v8-20020a5d4b08000000b0030755615eecmr993204wrq.0.1686904528906;
        Fri, 16 Jun 2023 01:35:28 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h14-20020adff4ce000000b0030c40e2cf42sm22871904wrp.116.2023.06.16.01.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 01:35:27 -0700 (PDT)
Message-ID: <ea6777df-7bb6-eeb9-645e-548bcbd6c2f6@redhat.com>
Date:   Fri, 16 Jun 2023 16:35:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, mtosatti@redhat.com,
        maz@kernel.org, will@kernel.org, c.dall@virtualopensystems.com,
        peterx@redhat.com, david@redhat.com, aarcange@redhat.com,
        hshuai@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20230615054259.14911-1-gshan@redhat.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/15/23 13:42, Gavin Shan wrote:
> We run into guest hang in edk2 firmware when KSM is kept as running on
> the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
> device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
> buffered write. The status is returned by reading the memory region of
> the pflash device and the read request should have been forwarded to QEMU
> and emulated by it. Unfortunately, the read request is covered by an
> illegal stage2 mapping when the guest hang issue occurs. The read request
> is completed with QEMU bypassed and wrong status is fetched. The edk2
> firmware runs into an infinite loop with the wrong status.
> 
> The illegal stage2 mapping is populated due to same page sharing by KSM
> at (C) even the associated memory slot has been marked as invalid at (B)
> when the memory slot is requested to be deleted. It's notable that the
> active and inactive memory slots can't be swapped when we're in the middle
> of kvm_mmu_notifier_change_pte() because kvm->mn_active_invalidate_count
> is elevated, and kvm_swap_active_memslots() will busy loop until it reaches
> to zero again. Besides, the swapping from the active to the inactive memory
> slots is also avoided by holding &kvm->srcu in __kvm_handle_hva_range(),
> corresponding to synchronize_srcu_expedited() in kvm_swap_active_memslots().
> 
>    CPU-A                    CPU-B
>    -----                    -----
>                             ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                             kvm_vm_ioctl_set_memory_region
>                             kvm_set_memory_region
>                             __kvm_set_memory_region
>                             kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                               kvm_invalidate_memslot
>                                 kvm_copy_memslot
>                                 kvm_replace_memslot
>                                 kvm_swap_active_memslots        (A)
>                                 kvm_arch_flush_shadow_memslot   (B)
>    same page sharing by KSM
>    kvm_mmu_notifier_invalidate_range_start
>          :
>    kvm_mmu_notifier_change_pte
>      kvm_handle_hva_range
>      __kvm_handle_hva_range
>      kvm_set_spte_gfn            (C)
>          :
>    kvm_mmu_notifier_invalidate_range_end
> 
> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping so that the read request for the pflash's status
> is forwarded to QEMU and emulated by it. In this way, the correct pflash's
> status can be returned from QEMU to break the infinite loop in the edk2
> firmware.
> 
> We tried a git-bisect and the first problematic commit is cd4c71835228 ("
> KVM: arm64: Convert to the gfn-based MMU notifier callbacks"). With this,
> clean_dcache_guest_page() is called after the memory slots are iterated
> in kvm_mmu_notifier_change_pte(). clean_dcache_guest_page() is called
> before the iteration on the memory slots before this commit. This change
> literally enlarges the racy window between kvm_mmu_notifier_change_pte()
> and memory slot removal so that we're able to reproduce the issue in a
> practical test case. However, the issue exists since commit d5d8184d35c9
> ("KVM: ARM: Memory virtualization setup").
> 
> Cc: stable@vger.kernel.org # v3.9+
> Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v3: Skip the invalid memory slots in change_pte() MMU notifier only,
>      suggested by Sean. Improved changelog to describe how the fixes
>      tag is given.
> ---
>   virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..65f94f592ff8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -686,6 +686,24 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>   
>   	return __kvm_handle_hva_range(kvm, &range);
>   }
> +
> +static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	/*
> +	 * Skipping invalid memslots is correct if and only change_pte() is
> +	 * surrounded by invalidate_range_{start,end}(), which is currently
> +	 * guaranteed by the primary MMU.  If that ever changes, KVM needs to
> +	 * unmap the memslot instead of skipping the memslot to ensure that KVM
> +	 * doesn't hold references to the old PFN.
> +	 */
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> +
> +	if (range->slot->flags & KVM_MEMSLOT_INVALID)
> +		return false;
> +
> +	return kvm_set_spte_gfn(kvm, range);
> +}
> +
>   static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   					struct mm_struct *mm,
>   					unsigned long address,
> @@ -707,7 +725,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
>   		return;
>   
> -	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
>   }
>   
>   void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,

-- 
Shaoqin

