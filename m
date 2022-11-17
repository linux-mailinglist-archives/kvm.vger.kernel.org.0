Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D660362E4B1
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbiKQSoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbiKQSo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:44:29 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CE087573
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:44:25 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b131so2922498yba.11
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vVH7qN35z+Gp4lSnfPExj6/O5lVwmQ0WJYQSp9lILX0=;
        b=EZ0qXH9cATo3Pm6imbyTcbILSaN3P8Jf+w2B2OeAljlGYGWbnxklbjDjB+1BTOh9A+
         Lx2pWK+tDlAdxnVzuBjJ0USgwgC3Yi0K/3XdFi62rcfpTJANW1pQOM9ay9XnDNwsCnu6
         TmMUsm6nit23VyztUineaXhHlYl9qAjzT69a+4bgSOx61qPBasEAn7fqkuF2EqHA7PF9
         4nTZ9jwBSavgaRRKoNKF/qCEAyOAA4JB32xK4/l+K45b9AhN3DX6otZzQGXju/FH55IO
         /GV1auSbah2wRToK6y1aZQtfwDYkgxhYFci6hNkan47adbwK9IIuQVX1NPf7eKhFUqlj
         /sUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVH7qN35z+Gp4lSnfPExj6/O5lVwmQ0WJYQSp9lILX0=;
        b=BJeUprBiEq79oMnW4h/xImIbYcQuvOVjjCQol/nssxqxHF47U56yMVK2jEj24OhDqj
         bs3kSXpuhO+F+leEVJL1H+UP5lUOLhXJttzfaTZDte3rTNKw/LePQHMM4u4DBK078SpR
         21Y2y5D0uQucZrArgzajwrPI6pcLozlptQl1DzefSWY0jA4NRW5MIEuL8N4JpjP4vxnV
         gyPMEmOXJMeGbdMqR1LoANNiJVjrxBtppH0a0HWOFqgfNa1o+63N40SXwUZoNPHSWRW9
         vkWUxLjKNk2ciKer67ksFwPc0vzgjkc4Azf8i7UiYCE8MKiKs2dtg5u/iGw0ttpU2MPe
         rolw==
X-Gm-Message-State: ANoB5pmC4uaPEuZJ2E4njpH0AeuEcV+PApphEuvQ9oPYkxTLu6UUEh5I
        Mn5taXd8DzMLLKZOg5SIiarPrMSaH5wo/gSoNRGy8g==
X-Google-Smtp-Source: AA0mqf7gnOd9qmo7Kr09gdVjgAwHohXvg8+8wAxVSqqIE6Xl9DTc3HqEpgJ3AIYhbVUfM8W5gbKEOp4TcOM3ZYEjtVE=
X-Received: by 2002:a25:ad14:0:b0:6de:8ec8:7342 with SMTP id
 y20-20020a25ad14000000b006de8ec87342mr3023286ybi.607.1668710665122; Thu, 17
 Nov 2022 10:44:25 -0800 (PST)
MIME-Version: 1.0
References: <20221117161449.114086-1-pbonzini@redhat.com>
In-Reply-To: <20221117161449.114086-1-pbonzini@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 17 Nov 2022 10:43:59 -0800
Message-ID: <CALzav=cxtgaVV2tORqDo93AuUW+5BSLdjsah=YASQdPMwnf2iA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest
 has to retry
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Robert Hoo <robert.hu@linux.intel.com>
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

On Thu, Nov 17, 2022 at 8:14 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> A removed SPTE is never present, hence the "if" in kvm_tdp_mmu_map
> only fails in the exact same conditions that the earlier loop
> tested in order to issue a  "break". So, instead of checking twice the
> condition (upper level SPTEs could not be created or was frozen), just
> exit the loop with a goto---the usual poor-man C replacement for RAII
> early returns.
>
> While at it, do not use the "ret" variable for return values of
> functions that do not return a RET_PF_* enum.  This is clearer
> and also makes it possible to initialize ret to RET_PF_RETRY.
>
> Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e08596775427..771210ce5181 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1159,7 +1159,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         struct kvm *kvm = vcpu->kvm;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> -       int ret;
> +       int ret = RET_PF_RETRY;
>
>         kvm_mmu_hugepage_adjust(vcpu, fault);
>
> @@ -1168,23 +1168,25 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         rcu_read_lock();
>
>         tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> +               int r;
> +
>                 if (fault->nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>
>                 if (iter.level == fault->goal_level)
>                         break;
>
> -               /* Step down into the lower level page table if it exists. */
> -               if (is_shadow_present_pte(iter.old_spte) &&
> -                   !is_large_pte(iter.old_spte))
> -                       continue;
> -
>                 /*
>                  * If SPTE has been frozen by another thread, just give up and
>                  * retry, avoiding unnecessary page table allocation and free.
>                  */
>                 if (is_removed_spte(iter.old_spte))
> -                       break;
> +                       goto retry;
> +
> +               /* Step down into the lower level page table if it exists. */
> +               if (is_shadow_present_pte(iter.old_spte) &&
> +                   !is_large_pte(iter.old_spte))
> +                       continue;
>
>                 /*
>                  * The SPTE is either non-present or points to a huge page that
> @@ -1196,13 +1198,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
>
>                 if (is_shadow_present_pte(iter.old_spte))
> -                       ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> +                       r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
>                 else
> -                       ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
> +                       r = tdp_mmu_link_sp(kvm, &iter, sp, true);

Can this fix be squashed into [1]? It seems like a serious enough bug.
If 2 threads race to update the same PTE, KVM will return -EBUSY out
to userspace from KVM_RUN, I think. I'm not sure about QEMU, but that
would be fatal for the VM in Vanadium.

[1] https://lore.kernel.org/kvm/20221109185905.486172-3-dmatlack@google.com/

>
> -               if (ret) {
> +               /*
> +                * Also force the guest to retry the access if the upper level SPTEs
> +                * aren't in place.
> +                */
> +               if (r) {
>                         tdp_mmu_free_sp(sp);
> -                       break;
> +                       goto retry;
>                 }
>
>                 if (fault->huge_page_disallowed &&
> @@ -1213,18 +1219,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 }
>         }
>
> -       /*
> -        * Force the guest to retry the access if the upper level SPTEs aren't
> -        * in place, or if the target leaf SPTE is frozen by another CPU.
> -        */
> -       if (iter.level != fault->goal_level || is_removed_spte(iter.old_spte)) {
> -               rcu_read_unlock();
> -               return RET_PF_RETRY;
> -       }
> -
>         ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
> -       rcu_read_unlock();
>
> +retry:
> +       rcu_read_unlock();
>         return ret;
>  }
>
> --
> 2.31.1
>
