Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0628021A593
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGIRND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgGIRNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:13:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63746C08C5CE
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 10:13:02 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a11so2698900ilk.0
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QO9IvrvbdFbIKVhCbtd7ASpLnMxeM4m98MgJitQIbbM=;
        b=gSQofJDz/xtC3LY7CHzehbvYXFf8x2QKBUjKyVSTLKCjJLkgB0FkC7RWx2bpt7S9yF
         nZRhB1Sf/zjf4V4rI0AgecBncWsepMGOCtF2RkK7eYiTfmVY63TuujpmbHzfWwoC8K2Q
         slRXybq4eTpBGXaGeRP1mF/pKXKK4hCQby2KJYK51GTq8PxDflwr1419KwYCSL5R2M+t
         3BX73E/XD/fheLb7KhX9lvzGwqnPnoUXZXaFFmpHXA0VF+knCT9MlLeZBsPqRN0x4Wug
         FXzoGeD1e3r2Px6IoEhBniy9/bkBGVB01lLqKuLwb4iAd6s2JzmCfGel8wtU9H1GNGBQ
         0dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QO9IvrvbdFbIKVhCbtd7ASpLnMxeM4m98MgJitQIbbM=;
        b=AguQCaOyKk/JN7CgjAwWGB+sFZk6F+u17LOypjVKFwCXqlD8zgndWnSl7aWfgqgbSL
         I9GY8lHAaVrAbY47RPly0eD2crkEF4PeXgU3whDje0FiQDeQzyFlpvDAoq6w26z7+O75
         3rNRI3Oo6Cm2IVn+HWJ4h/gyXIbkGQilaBSyA7XcON+7lU1cYpstMR9Raw9HbPl1jG9J
         GjhGvHuCOmjdtdBEPyxwdSGqkgHdjGtXcYQIRPU2azDphtD0lJ+K55ZvFRL9q05rC5d7
         dC95FMyuvG4r4dWimyg+zjE320aAAmdhHs4kFuWoz2R+sfqDz75yRM65fRFqnweocG/N
         kz1A==
X-Gm-Message-State: AOAM533rS2xqA5i9XY39vZPvf7tZflaQy7amKb9N8md1NRr2D68PqznG
        tTr0/3ZvpiPGQ8kL1e2doB09RUK319no0Th4rBViT7c4kbQHVQ==
X-Google-Smtp-Source: ABdhPJxa4dFEbhQpI8FUCI9c4RTZ/KqESl+J/S5E5+jrfkm0yt9foFGwK9W9gn7Ks2MUKg5pWO1OYTddy9xukrw/XGo=
X-Received: by 2002:a05:6e02:de6:: with SMTP id m6mr47104980ilj.296.1594314781244;
 Thu, 09 Jul 2020 10:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200709095525.907771-1-pbonzini@redhat.com>
In-Reply-To: <20200709095525.907771-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jul 2020 10:12:50 -0700
Message-ID: <CALMp9eREY4e7kb22CxReNV83HwR7D_tBkn2i5LUbGLGe_yw5nQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly RFLAGS.VM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 9, 2020 at 2:55 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> AMD doesn't specify (unlike Intel) that EFER.LME, CR0.PG and
> EFER.LMA must be consistent, and for SMM state restore they say that
> "The EFER.LMA register bit is set to the value obtained by logically
> ANDing the SMRAM values of EFER.LME, CR0.PG, and CR4.PAE".  It turns
> out that this is also true for vmentry: the EFER.LMA value in the VMCB
> is completely ignored, and so is EFLAGS.VM if the processor is in
> long mode or real mode.
>
> Implement these quirks; the EFER.LMA part is needed because svm_set_efer
> looks at the LMA bit in order to support EFER.NX=0, while the EFLAGS.VM
> part is just because we can.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 402ea5b412f0..1c82a1789e0e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -337,6 +337,24 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
>
>  static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
>  {
> +       u64 efer = nested_vmcb->save.efer;
> +
> +       /* The processor ignores EFER.LMA, but svm_set_efer needs it.  */
> +       efer &= ~EFER_LMA;
> +       if ((nested_vmcb->save.cr0 & X86_CR0_PG)
> +           && (nested_vmcb->save.cr4 & X86_CR4_PAE)
> +           && (efer & EFER_LME))
> +               efer |= EFER_LMA;

The CR4.PAE check is unnecessary, isn't it? The combination CR0.PG=1,
EFER.LMA=1, and CR4.PAE=0 is not a legal processor state.

According to the SDM,

* IA32_EFER.LME cannot be modified while paging is enabled (CR0.PG =
1). Attempts to do so using WRMSR cause a general-protection exception
(#GP(0)).
* Paging cannot be enabled (by setting CR0.PG to 1) while CR4.PAE = 0
and IA32_EFER.LME = 1. Attempts to do so using MOV to CR0 cause a
general-protection exception (#GP(0)).
* CR4.PAE and CR4.LA57 cannot be modified while either 4-level paging
or 5-level paging is in use (when CR0.PG = 1 and IA32_EFER.LME = 1).
Attempts to do so using MOV to CR4 cause a general-protection
exception (#GP(0)).

> +
> +       /*
> +        * Likewise RFLAGS.VM is cleared if inconsistent with other processor
> +        * state.  This is sort-of documented in "10.4 Leaving SMM" but applies
> +        * to SVM as well.
> +        */
> +       if (!(nested_vmcb->save.cr0 & X86_CR0_PE)
> +           || (efer & EFER_LMA))
> +               nested_vmcb->save.rflags &= ~X86_EFLAGS_VM;
> +
>         /* Load the nested guest state */
>         svm->vmcb->save.es = nested_vmcb->save.es;
>         svm->vmcb->save.cs = nested_vmcb->save.cs;
> @@ -345,7 +363,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
>         svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
>         svm->vmcb->save.idtr = nested_vmcb->save.idtr;
>         kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
> -       svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
> +       svm_set_efer(&svm->vcpu, efer);
>         svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>         svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
>         (void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> --
> 2.26.2
>
