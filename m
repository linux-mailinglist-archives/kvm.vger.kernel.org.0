Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9B6344B4
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiKVTh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiKVThz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:37:55 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0D721E11
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:37:54 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id bp15so25037068lfb.13
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9AgAZ70TrtdzOoBdfiah///XbtqvmKlASUxc0HY4vfg=;
        b=PPusKsb75SMY/Pl8RNjMt0TEs608oGnvVRmD1no7NYu9GmKsxFm1Hn0YGi0sCT2SDT
         4Iws8zh5UkoPU8t989AySG8Kb4Ziki8ppBI2gYsrUEuNmViGo5t4GeIkEw50+MrAAaAe
         UshKght/wjdAKP2K324GTWMCkYfnzJPYs9QedYivQ+vzEcdVswjuMDNcCaDz85XxU/qO
         wXuCziS3KuhCeAgzmfsHI+3wc8gsPaXwMU8St4YT3SYpbsq2O53V6SfgCH0ExSaEQHxy
         1gM+KPnryXNI6ceg0obzRNJROLuOkKAZOBMUbKjgG6nq2XZVihiQ9sRyVsUHzm/k0+So
         JsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9AgAZ70TrtdzOoBdfiah///XbtqvmKlASUxc0HY4vfg=;
        b=yJo2bw+6bnanmp4YJ2/YRDWyn7dvszBykq9uXMecz/5etjetFjZ7cIiQBZKNEU5E1P
         QWBOWouPSJBJQRMzUdJ8PEJnTJ+W7Wv6labBCje8Vr5aYtsGEtkBsP6SIQW/wmNbVT5f
         jk6H2t1uDoMIuUu3DR/ZQxLBFJH7hVlEN3v9Ww18Wc41CEP1B/i5Ic0Kyv4pZ/9cfvy+
         pGMCN3/qqCorPQmazQ94ms09UmCQOjXNCSu9YL3Msu9JschlpsmFGFK2F7YtmFCZrbcx
         5xP44IyEYmuzj9YcDsT9PJTXrxKX5IsQUMSQnzYYsfEYzE/S9HATRFkoYX3nTTHiOqZC
         ZVYg==
X-Gm-Message-State: ANoB5pnij6Al6p6vtz/mO9cN5dHqBP2eDX/tg6TVggerVh35ymXAe8ZH
        JXr89Ity323tTbX3hhvatgEP3fhecU4Wm23siU1fYw==
X-Google-Smtp-Source: AA0mqf6lJbsg3Mf7sHEAxAHI68jovsObt9+78eaUvEuy5xlubIQAjvmFRd8VQdqJoWKfaqIqgG9D7QYeKRcddA3QBJk=
X-Received: by 2002:a19:384c:0:b0:494:7055:b085 with SMTP id
 d12-20020a19384c000000b004947055b085mr4857802lfj.109.1669145872368; Tue, 22
 Nov 2022 11:37:52 -0800 (PST)
MIME-Version: 1.0
From:   Ackerley Tng <ackerleytng@google.com>
Date:   Tue, 22 Nov 2022 11:37:41 -0800
Message-ID: <CAEvNRgG0u_DoaTYntu18cSb=ceDDeKKNZdfTPuqp6Q_dmJLiVg@mail.gmail.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To:     isaku.yamahata@intel.com
Cc:     David Matlack <dmatlack@google.com>,
        Erdem Aktas <erdemaktas@google.com>, isaku.yamahata@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, Sagi Shahar <sagis@google.com>,
        sean.j.christopherson@intel.com,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private
pages for unsupported cases

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX supports only write-back(WB) memory type for private memory
> architecturally so that (virtualized) memory type change doesn't make sense
> for private memory.  Also currently, page migration isn't supported for TDX
> yet. (TDX architecturally supports page migration. it's KVM and kernel
> implementation issue.)
>
> Regarding memory type change (mtrr virtualization and lapic page mapping
> change), pages are zapped by kvm_zap_gfn_range().  On the next KVM page
> fault, the SPTE entry with a new memory type for the page is populated.
> Regarding page migration, pages are zapped by the mmu notifier. On the next
> KVM page fault, the new migrated page is populated.  Don't zap private
> pages on unmapping for those two cases.
>
> When deleting/moving a KVM memory slot, zap private pages. Typically
> tearing down VM.  Don't invalidate private page tables. i.e. zap only leaf
> SPTEs for KVM mmu that has a shared bit mask. The existing
> kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-lock
> of mmu_lock so that other vcpu can operate on KVM mmu concurrently.  It
> marks the root page table invalid and zaps SPTEs of the root page
> tables. The TDX module doesn't allow to unlink a protected root page table
> from the hardware and then allocate a new one for it. i.e. replacing a
> protected root page table.  Instead, zap only leaf SPTEs for KVM mmu with a
> shared bit mask set.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 85 ++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.h |  5 ++-
>  3 files changed, 103 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index faf69774c7ce..0237e143299c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1577,8 +1577,38 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  if (kvm_memslots_have_rmaps(kvm))
>  flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
>
> - if (is_tdp_mmu_enabled(kvm))
> - flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> + if (is_tdp_mmu_enabled(kvm)) {
> + bool zap_private;

We should initialize zap_private to true, otherwise zap_private is
uninitialized in call

    kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private)

if the condition

    if (kvm_slot_can_be_private(range->slot)) {

evaluates to false.

> +
> + if (kvm_slot_can_be_private(range->slot)) {
> + if (range->flags & KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM)
> + /*
> + * For private slot, the callback is triggered
> + * via falloc.  Mode can be allocation or punch
> + * hole.  Because the private-shared conversion
> + * is done via
> + * KVM_MEMORY_ENCRYPT_REG/UNREG_REGION, we can
> + * ignore the request from restrictedmem.
> + */
> + return flush;
> + else if (range->flags & KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR) {
> + if (range->attr == KVM_MEM_ATTR_SHARED)
> + zap_private = true;
> + else {
> + WARN_ON_ONCE(range->attr != KVM_MEM_ATTR_PRIVATE);
> + zap_private = false;
> + }
> + } else
> + /*
> + * kvm_unmap_gfn_range() is called via mmu
> + * notifier.  For now page migration for private
> + * page isn't supported yet, don't zap private
> + * pages.
> + */
> + zap_private = false;
> + }
> + flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private);
> + }
>
>  return flush;
>  }
