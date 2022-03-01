Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B884C7F4B
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 01:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiCAAdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 19:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiCAAdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 19:33:45 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE32A9952
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 16:33:05 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a23so28211014eju.3
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 16:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vcdfbWH6K4PLETg9Ox6HxAoQBntpf1VO+zdcMv9hYs4=;
        b=EBvGtmafFg83T3Kd5ReZCotWRctmRQze6IVulBgy7fg1+j5GaJ0OQTkUasKXblTaBu
         PzcjWJVRheBvTqEadwA/s1TAI5KrxUB9nuREAaq/CMUZe+TqXtHgKWi4chMDBz+o01T3
         7ZRJFNtGyHYEyaLo0r7tO5UF33ma3JcA171uS1pkM473A+Tb0xF1RYzN8s8WWtEWzUya
         8Czpmd3XvBR6XBVuvghcGKYizUtN2p2fHkWAtMpVLx0tsW14JqFdpw5h7eVaMAi/Gs8o
         3EOowA/YhK7iH1odSJjkngAJbSknMQRzqHns3O8T73DJFkoe2qEkacuxh1hgfbPmHDhb
         1nCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vcdfbWH6K4PLETg9Ox6HxAoQBntpf1VO+zdcMv9hYs4=;
        b=ebLhg7PH5psCxBRW9KJviDujUQUvghu71q9dSOHZ0TuHZOfPTg4eyEO6/xBqq78bgq
         +1UcD+rTuViq/8N028WcPFNA3LzH+XSgJ/D/pEpRcFrLjYBZoLd+uqqq0bHR3LRCUI6Q
         5OqG2eGnZphknM3RAfOrO+cr271XSStZF0T2s2sRRux7+dZtmJXwPnbTiBZomOhS6e+U
         1oPDAQgWtNY1Ob1siPR1+JRPwSp3xkt2W1e4yTThtlN9FFiJp2aR9vLEqmjxKdW1kwGf
         4MG+DlDoarsuWxtOMcjUk5VHEcfDX8z4f6NsyLzjK93omoPoqjvfFCE++Mg1Hm5fZ1Ii
         DaNA==
X-Gm-Message-State: AOAM533QPu71jp8O9c1tVXMrpQVIDRTLIDGrseyWXc2TnNhjjCaIWbI4
        R0DE67CYe9rMVQC8FIdrW2VhnCpz02KGYc9S3j5oYQ==
X-Google-Smtp-Source: ABdhPJyrWLl/aGXA1kaWaqOmD/Ot0ugq3mL/mZnSvd9Hzep5h/1hyGWz3kUuPRMHtd6nOZYUyW8+XyEBmaCzSTXz63k=
X-Received: by 2002:a17:907:7618:b0:6cf:5756:26c4 with SMTP id
 jx24-20020a170907761800b006cf575626c4mr16993270ejc.492.1646094783390; Mon, 28
 Feb 2022 16:33:03 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-16-seanjc@google.com>
In-Reply-To: <20220226001546.360188-16-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 16:32:52 -0800
Message-ID: <CANgfPd8FhHC+7Bgc=718hU5uSEK3EStSaAdHxeEu3kxwGsySLQ@mail.gmail.com>
Subject: Re: [PATCH v3 15/28] KVM: x86/mmu: Add dedicated helper to zap TDP
 MMU root shadow page
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Add a dedicated helper for zapping a TDP MMU root, and use it in the three
> flows that do "zap_all" and intentionally do not do a TLB flush if SPTEs
> are zapped (zapping an entire root is safe if and only if it cannot be in
> use by any vCPU).  Because a TLB flush is never required, unconditionally
> pass "false" to tdp_mmu_iter_cond_resched() when potentially yielding.
>
> Opportunistically document why KVM must not yield when zapping roots that
> are being zapped by kvm_tdp_mmu_put_root(), i.e. roots whose refcount has
> reached zero, and further harden the flow to detect improper KVM behavior
> with respect to roots that are supposed to be unreachable.
>
> In addition to hardening zapping of roots, isolating zapping of roots
> will allow future simplification of zap_gfn_range() by having it zap only
> leaf SPTEs, and by removing its tricky "zap all" heuristic.  By having
> all paths that truly need to free _all_ SPs flow through the dedicated
> root zapper, the generic zapper can be freed of those concerns.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Nice!

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 98 +++++++++++++++++++++++++++++++-------
>  1 file changed, 82 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 87706e9cc6f3..c5df9a552470 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -56,10 +56,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>         rcu_barrier();
>  }
>
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -                         gfn_t start, gfn_t end, bool can_yield, bool flush,
> -                         bool shared);
> -
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
>         free_page((unsigned long)sp->spt);
> @@ -82,6 +78,9 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>         tdp_mmu_free_sp(sp);
>  }
>
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                            bool shared);
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                           bool shared)
>  {
> @@ -104,7 +103,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>          * intermediate paging structures, that may be zapped, as such entries
>          * are associated with the ASID on both VMX and SVM.
>          */
> -       (void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> +       tdp_mmu_zap_root(kvm, root, shared);
>
>         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -751,6 +750,76 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
>         return iter->yielded;
>  }
>
> +static inline gfn_t tdp_mmu_max_gfn_host(void)
> +{
> +       /*
> +        * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
> +        * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
> +        * and so KVM will never install a SPTE for such addresses.
> +        */
> +       return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> +}
> +
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                            bool shared)
> +{
> +       bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
> +       struct tdp_iter iter;
> +
> +       gfn_t end = tdp_mmu_max_gfn_host();
> +       gfn_t start = 0;
> +
> +       kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
> +       rcu_read_lock();
> +
> +       /*
> +        * No need to try to step down in the iterator when zapping an entire
> +        * root, zapping an upper-level SPTE will recurse on its children.
> +        */
> +       for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
> +retry:
> +               /*
> +                * Yielding isn't allowed when zapping an unreachable root as
> +                * the root won't be processed by mmu_notifier callbacks.  When
> +                * handling an unmap/release mmu_notifier command, KVM must
> +                * drop all references to relevant pages prior to completing
> +                * the callback.  Dropping mmu_lock can result in zapping SPTEs
> +                * for an unreachable root after a relevant callback completes,
> +                * which leads to use-after-free as zapping a SPTE triggers
> +                * "writeback" of dirty/accessed bits to the SPTE's associated
> +                * struct page.
> +                */
> +               if (!root_is_unreachable &&
> +                   tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> +                       continue;
> +
> +               if (!is_shadow_present_pte(iter.old_spte))
> +                       continue;
> +
> +               if (!shared) {
> +                       tdp_mmu_set_spte(kvm, &iter, 0);
> +               } else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
> +                       /*
> +                        * cmpxchg() shouldn't fail if the root is unreachable.
> +                        * Retry so as not to leak the page and its children.
> +                        */
> +                       WARN_ONCE(root_is_unreachable,
> +                                 "Contended TDP MMU SPTE in unreachable root.");
> +                       goto retry;
> +               }
> +
> +               /*
> +                * WARN if the root is invalid and is unreachable, all SPTEs
> +                * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
> +                * and inserting new SPTEs under an invalid root is a KVM bug.
> +                */
> +               WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
> +       }
> +
> +       rcu_read_unlock();
> +}
> +
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>         u64 old_spte;
> @@ -799,8 +868,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                           gfn_t start, gfn_t end, bool can_yield, bool flush,
>                           bool shared)
>  {
> -       gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> -       bool zap_all = (start == 0 && end >= max_gfn_host);
> +       bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>         struct tdp_iter iter;
>
>         /*
> @@ -809,12 +877,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>          */
>         int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
>
> -       /*
> -        * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> -        * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> -        * and so KVM will never install a SPTE for such addresses.
> -        */
> -       end = min(end, max_gfn_host);
> +       end = min(end, tdp_mmu_max_gfn_host());
>
>         kvm_lockdep_assert_mmu_lock_held(kvm, shared);
>
> @@ -874,6 +937,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  {
> +       struct kvm_mmu_page *root;
>         int i;
>
>         /*
> @@ -881,8 +945,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>          * is being destroyed or the userspace VMM has exited.  In both cases,
>          * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>          */
> -       for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -               (void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
> +       for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +               for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
> +                       tdp_mmu_zap_root(kvm, root, false);
> +       }
>  }
>
>  /*
> @@ -908,7 +974,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                  * will still flush on yield, but that's a minor performance
>                  * blip and not a functional issue.
>                  */
> -               (void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
> +               tdp_mmu_zap_root(kvm, root, true);
>
>                 /*
>                  * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
> --
> 2.35.1.574.g5d30c73bfb-goog
>
