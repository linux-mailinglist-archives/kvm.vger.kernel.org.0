Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210DD732091
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjFOUCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 16:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFOUCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 16:02:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C451FEF
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686859321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8IbbP+x6BA+CbR8PuWf9bFHgUN9aUhHhdqxdWI7RMB0=;
        b=ciaUcNHBZMPex1yIX0SJiBJHY5Ct4f3QtgKbp39ny0+maif1STs9znDsttrrOI3uN0IQaX
        aMKEOHilkve7P7RG6Xmr2IY6CZNy4ISz/7Lp+0jQOCddy+ali1/JJEkRUUNFjqPl/BP/ID
        AKPxBSI/NYsR9laCHjIKtbWTvNXzePg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-oRPqnIVSOwiDS_c57lEuzA-1; Thu, 15 Jun 2023 16:01:52 -0400
X-MC-Unique: oRPqnIVSOwiDS_c57lEuzA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62fea7a5de9so158866d6.0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 13:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686859311; x=1689451311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IbbP+x6BA+CbR8PuWf9bFHgUN9aUhHhdqxdWI7RMB0=;
        b=TTc3vWYgepQmFrQZS8FMKVymUO6Se+qGAEoAPH9A+K6shbyMpkO16fO0wwfOP8BS1I
         sNQYnmNCK1SZ8fRQpKLeTBJwB3isgFw4qeI+OQgW4aebDYzwUq4aQIIYwoqcLYiRs0mp
         7ZzMYDKnxSVBMX78mDoN7Nllw+isJRuQODxNQLnbKNG4Sg9/f4JPjx71KwfCRBOpe5Hv
         Rtjkl8l0kLd1aycQ73BRq/iX+dJIFsEs8kbcbkXMELKxyDyt1rpl7tpFkKu5DbEbqfUu
         /uUwNKl66ZfPIKkTWDIJBek55op5EyWsqPJuVXrrhLV3CG2JSeYWdDNW0uxr9dVttTa1
         S13Q==
X-Gm-Message-State: AC+VfDxTGJJxK1hC4H7xajn5aTB4GYSoEfvDPqB34ZT142OUD1680jZK
        pUzWPMQoaPSN5xLb0/ISvroFyCGwwzSkc1RV3ZFiDfpBunoEUcNzX7ypeXjFmwC6G+BMMdI0gxx
        yPA1+f19jPZ4y
X-Received: by 2002:ad4:5de8:0:b0:626:2305:6073 with SMTP id jn8-20020ad45de8000000b0062623056073mr13821qvb.4.1686859311724;
        Thu, 15 Jun 2023 13:01:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4RMNRmKAg6OyzyvKUac88wdq6WG114AHscBN3XdznQNbojY/IbUhU0k7xX72rv1YrIiRdnew==
X-Received: by 2002:ad4:5de8:0:b0:626:2305:6073 with SMTP id jn8-20020ad45de8000000b0062623056073mr13790qvb.4.1686859311408;
        Thu, 15 Jun 2023 13:01:51 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id hr6-20020a05621423c600b006263735a9adsm6122536qvb.112.2023.06.15.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 13:01:50 -0700 (PDT)
Date:   Thu, 15 Jun 2023 16:01:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, mtosatti@redhat.com, maz@kernel.org,
        will@kernel.org, c.dall@virtualopensystems.com, david@redhat.com,
        aarcange@redhat.com, shahuang@redhat.com, hshuai@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Message-ID: <ZItuLYyDt10U/ytb@x1n>
References: <20230615054259.14911-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 03:42:59PM +1000, Gavin Shan wrote:
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
>   CPU-A                    CPU-B
>   -----                    -----
>                            ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                            kvm_vm_ioctl_set_memory_region
>                            kvm_set_memory_region
>                            __kvm_set_memory_region
>                            kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                              kvm_invalidate_memslot
>                                kvm_copy_memslot
>                                kvm_replace_memslot
>                                kvm_swap_active_memslots        (A)
>                                kvm_arch_flush_shadow_memslot   (B)
>   same page sharing by KSM
>   kvm_mmu_notifier_invalidate_range_start
>         :
>   kvm_mmu_notifier_change_pte
>     kvm_handle_hva_range
>     __kvm_handle_hva_range
>     kvm_set_spte_gfn            (C)
>         :
>   kvm_mmu_notifier_invalidate_range_end
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
> ---
> v3: Skip the invalid memory slots in change_pte() MMU notifier only,
>     suggested by Sean. Improved changelog to describe how the fixes
>     tag is given.

True.. FWIW:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

