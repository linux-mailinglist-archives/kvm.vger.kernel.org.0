Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C944C7D7D
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 23:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiB1WjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 17:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiB1WjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 17:39:08 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C4A41327
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:38:28 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id dr20so3080866ejc.6
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F2fi2f0PCqSCYe+tcWhAUpFtNcH0g69LWKCmBIirVWc=;
        b=WOEq1URYcDwyPIE9I17hh3CQNr46AQkStK2aveUEFtiX/oFcmFuN72q+SuX1DBDQAI
         vcHd7DA5kMne/VGCrkB6EFrGW22qY0iG7FbBaqDPTbqFsAfsb/krmvS0kAtv/ZMBDr86
         WoiWI03kprmUiDUr7vQuePMl443QZpFCoNdCT7uUys7VOJ+D5OztXCIUwgN77IU3kUHF
         srSb5zHrKT2XunJHHoE4N648jgGP8M/tJI+KIvEs2lxQKdY5Ys2Qjq429WZRymt128/K
         VGGSSPyijvkGdV67TrxaOUOSXAwzF26JvUr1aAM1P9BsfoMWp/T+Oive7XLnKs1tGDlm
         FaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F2fi2f0PCqSCYe+tcWhAUpFtNcH0g69LWKCmBIirVWc=;
        b=XwdauP59xCcB4Org3YTCdhhASOb4D+Z69h08TUhehKM4DeLgq/b/nXYdiYJ+Cs9qAo
         AQYmdGEGaQHhFvshzmKB/cYbrNPtiPAXRQOlxQ+wdN8Naw5fQxSkR1JhUyDKGGfRgwxw
         rO+fBPEJ5a9UvqzTYj3jP5viJtj+sfxuSYlAQJPXs1V5/0gE+taqOAgN6DcHFBTmmXZ/
         lFjb7bIMbZe/mjHtf7IEZvX5uyHWWOiRUpF6dTGUZSLPm1cGz4BxtzcErg3qlvsW19Pv
         SMP7FS/EuYkO2Q4sTGLxSR4VIr/Nj7dcymEo1ustz26l/4f+WnTSq1un+56HWdSJNwUI
         FcEw==
X-Gm-Message-State: AOAM530UK5qWaU6TNaphaayhkx26G2/8WncdM7TXy1y3qRTl3R0M065F
        weflSh4KC4SU05APeW1hp2iSkOtMHMo6Ck1ksDYn0Q==
X-Google-Smtp-Source: ABdhPJzHVKLU+dscmJvFH5kNt/O0h8NOUq87CSbLUWKDGQZNyh4e7ZZRlVsqCCHSHXWyHeUJliK63gt0GowksuJULxM=
X-Received: by 2002:a17:906:be1:b0:6ce:c3c8:b4b6 with SMTP id
 z1-20020a1709060be100b006cec3c8b4b6mr16410585ejg.617.1646087906409; Mon, 28
 Feb 2022 14:38:26 -0800 (PST)
MIME-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com> <20220225182248.3812651-5-seanjc@google.com>
In-Reply-To: <20220225182248.3812651-5-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 14:38:15 -0800
Message-ID: <CANgfPd8u9CtHBjxjHWKyKNOvq542NA0NwuYmQos5==MfRodksw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 10:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Zap only obsolete roots when responding to zapping a single root shadow
> page.  Because KVM keeps root_count elevated when stuffing a previous
> root into its PGD cache, shadowing a 64-bit guest means that zapping any
> root causes all vCPUs to reload all roots, even if their current root is
> not affected by the zap.
>
> For many kernels, zapping a single root is a frequent operation, e.g. in
> Linux it happens whenever an mm is dropped, e.g. process exits, etc...
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/mmu.h              |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 65 +++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c              |  4 +-
>  4 files changed, 63 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 713e08f62385..343041e892c6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -102,6 +102,8 @@
>  #define KVM_REQ_MSR_FILTER_CHANGED     KVM_ARCH_REQ(29)
>  #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
>         KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
> +       KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>
>  #define CR0_RESERVED_BITS                                               \
>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1d0c1904d69a..bf8dbc4bb12a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -80,6 +80,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>
>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
> +void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 32c6d4b33d03..825996408465 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2310,7 +2310,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>                                        struct list_head *invalid_list,
>                                        int *nr_zapped)
>  {
> -       bool list_unstable;
> +       bool list_unstable, zapped_root = false;
>
>         trace_kvm_mmu_prepare_zap_page(sp);
>         ++kvm->stat.mmu_shadow_zapped;
> @@ -2352,14 +2352,20 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>                  * in kvm_mmu_zap_all_fast().  Note, is_obsolete_sp() also
>                  * treats invalid shadow pages as being obsolete.
>                  */
> -               if (!is_obsolete_sp(kvm, sp))
> -                       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
> +               zapped_root = !is_obsolete_sp(kvm, sp);
>         }
>
>         if (sp->lpage_disallowed)
>                 unaccount_huge_nx_page(kvm, sp);
>
>         sp->role.invalid = 1;
> +
> +       /*
> +        * Make the request to free obsolete roots after marking the root
> +        * invalid, otherwise other vCPUs may not see it as invalid.
> +        */
> +       if (zapped_root)
> +               kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>         return list_unstable;
>  }
>
> @@ -3947,7 +3953,7 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>          * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
>          * to reload even if no vCPU is actively using the root.
>          */
> -       if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
> +       if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
>                 return true;
>
>         return fault->slot &&
> @@ -4180,8 +4186,8 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>         /*
>          * It's possible that the cached previous root page is obsolete because
>          * of a change in the MMU generation number. However, changing the
> -        * generation number is accompanied by KVM_REQ_MMU_RELOAD, which will
> -        * free the root set here and allocate a new one.
> +        * generation number is accompanied by KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
> +        * which will free the root set here and allocate a new one.
>          */
>         kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>
> @@ -5085,6 +5091,51 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>         vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  }
>
> +static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
> +{
> +       struct kvm_mmu_page *sp;
> +
> +       if (!VALID_PAGE(root_hpa))
> +               return false;
> +
> +       /*
> +        * When freeing obsolete roots, treat roots as obsolete if they don't
> +        * have an associated shadow page.  This does mean KVM will get false
> +        * positives and free roots that don't strictly need to be freed, but
> +        * such false positives are relatively rare:
> +        *
> +        *  (a) only PAE paging and nested NPT has roots without shadow pages
> +        *  (b) remote reloads due to a memslot update obsoletes _all_ roots
> +        *  (c) KVM doesn't track previous roots for PAE paging, and the guest
> +        *      is unlikely to zap an in-use PGD.
> +        */
> +       sp = to_shadow_page(root_hpa);
> +       return !sp || is_obsolete_sp(kvm, sp);
> +}
> +
> +static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> +{
> +       unsigned long roots_to_free = 0;
> +       int i;
> +
> +       if (is_obsolete_root(kvm, mmu->root.hpa))
> +               roots_to_free |= KVM_MMU_ROOT_CURRENT;
> +
> +       for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> +               if (is_obsolete_root(kvm, mmu->root.hpa))
> +                       roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> +       }
> +
> +       if (roots_to_free)
> +               kvm_mmu_free_roots(kvm, mmu, roots_to_free);
> +}
> +
> +void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
> +{
> +       __kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.root_mmu);
> +       __kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
> +}
> +
>  static bool need_remote_flush(u64 old, u64 new)
>  {
>         if (!is_shadow_present_pte(old))
> @@ -5656,7 +5707,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          * Note: we need to do this under the protection of mmu_lock,
>          * otherwise, vcpu would purge shadow page but miss tlb flush.
>          */
> -       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
> +       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>
>         kvm_zap_obsolete_pages(kvm);
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 579b26ffc124..d6bf0562c4c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9856,8 +9856,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                                 goto out;
>                         }
>                 }
> -               if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
> -                       kvm_mmu_unload(vcpu);
> +               if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> +                       kvm_mmu_free_obsolete_roots(vcpu);
>                 if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
>                         __kvm_migrate_timers(vcpu);
>                 if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
> --
> 2.35.1.574.g5d30c73bfb-goog
>
