Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E2324427A
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 02:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHNASp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHNASp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 20:18:45 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA87C061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 17:18:44 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id k12so6347358otr.1
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 17:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hKfJ4LgeNuEVsNPK0fxwjlcUz38msr/6A2je+U6U0Y8=;
        b=m3DhFcC5UztW8hDI3X8qGWqY3h3ItlQv220e38BgtICdknliB2RqzibWjWfQQiME5o
         gNNE1LDU79i9jyeMEL9TsUHnM9j9jlEnEyMLoPgffLJxT3TsQo9qKwsIxyU/UEdEYlQc
         W1rg2c778DF5to3bGgaH0UtUVXWOkIvIdX9T89/SG8EnLjdb5DDHopX6bIFyW7I/lZ0O
         gTaMPDSYZ6CaZDLL1BhXsUc77Wr7Z3zSPoRwmgFC9THPPVkcUvqtg6DL2CV9qGNoL3Qc
         21q6Jssj/sUg7a+lyiFulI8Hxx7ItSrrI0lCaUf8wC9KISaZJcwqESo/2blgrUA71W0M
         7MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hKfJ4LgeNuEVsNPK0fxwjlcUz38msr/6A2je+U6U0Y8=;
        b=U/xFF3mV8CX7tktH2Lwb3EVTLR8VPWGydwS7J+WHjhGbxKYILBqHng0Y3lKtgyz+M7
         1/Usc48a3x+CLoFQkkKpuNGlpeJDafsA2df8sMMPmx1yZBci/47vFAgU4+icdM/9WPvL
         h1FLcYNi3aUIfKluIodA4kLo7bX3ieMQSdLcu3JxC9yqb8UuqrAV6uMHNGhwzQ92O2Yh
         LS+0BxzYMuiaGN//115TwVNsYBl8zr0qEWZbqtSJUsfPnICVSRAxDeDEX4G1T5g1Sobc
         zV/0fEn0bjyVXhAIGLRF01g9cTzoE2OxySQgodzmDV9nYJoUHFk2p10koudTPzr9ZFxu
         erfA==
X-Gm-Message-State: AOAM532cViyH/SKZ0Swjr10neIT66NoxtxXS5+xBUF+GI2JXJSepWuHF
        IUl3Mv+E0KMu71OvXnx5j3su0Kl8BoOG14P02Zg=
X-Google-Smtp-Source: ABdhPJzdMQUX/o4IUi+lPaKaSfsLV8Ucg8IPwUsIcgBSFHkm2jw00pGtxrfikZS8fBDEUPxaobWMGOAr8l79kqH23rc=
X-Received: by 2002:a9d:c44:: with SMTP id 62mr234343otr.185.1597364323235;
 Thu, 13 Aug 2020 17:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com> <20200806151433.2747952-2-oupton@google.com>
In-Reply-To: <20200806151433.2747952-2-oupton@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 14 Aug 2020 08:18:32 +0800
Message-ID: <CANRm+CxmRBWmWOaGTf=miYRFnrH9hXsq2zJN739ZGFiwkSf2Yw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME)
 emulation in helper fn
To:     Oliver Upton <oupton@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Aug 2020 at 01:56, Oliver Upton <oupton@google.com> wrote:
>
> No functional change intended.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/kvm/x86.c | 58 +++++++++++++++++++++++++---------------------
>  1 file changed, 32 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc4370394ab8..5ba713108686 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1822,6 +1822,34 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>         kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
>  }
>
> +static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
> +                                 bool old_msr, bool host_initiated)
> +{
> +       struct kvm_arch *ka = &vcpu->kvm->arch;
> +
> +       if (vcpu->vcpu_id == 0 && !host_initiated) {
> +               if (ka->boot_vcpu_runs_old_kvmclock && old_msr)
> +                       kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> +
> +               ka->boot_vcpu_runs_old_kvmclock = old_msr;
> +       }
> +
> +       vcpu->arch.time = system_time;
> +       kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> +
> +       /* we verify if the enable bit is set... */
> +       vcpu->arch.pv_time_enabled = false;
> +       if (!(system_time & 1))
> +               return;
> +
> +       if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +                                      &vcpu->arch.pv_time, system_time & ~1ULL,
> +                                      sizeof(struct pvclock_vcpu_time_info)))
> +               vcpu->arch.pv_time_enabled = true;
> +
> +       return;
> +}
> +
>  static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
>  {
>         do_shl32_div32(dividend, divisor);
> @@ -2973,33 +3001,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 kvm_write_wall_clock(vcpu->kvm, data);
>                 break;
>         case MSR_KVM_SYSTEM_TIME_NEW:
> -       case MSR_KVM_SYSTEM_TIME: {
> -               struct kvm_arch *ka = &vcpu->kvm->arch;
> -
> -               if (vcpu->vcpu_id == 0 && !msr_info->host_initiated) {
> -                       bool tmp = (msr == MSR_KVM_SYSTEM_TIME);
> -
> -                       if (ka->boot_vcpu_runs_old_kvmclock != tmp)
> -                               kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> -
> -                       ka->boot_vcpu_runs_old_kvmclock = tmp;
> -               }
> -
> -               vcpu->arch.time = data;
> -               kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> -
> -               /* we verify if the enable bit is set... */
> -               vcpu->arch.pv_time_enabled = false;
> -               if (!(data & 1))
> -                       break;
> -
> -               if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
> -                    &vcpu->arch.pv_time, data & ~1ULL,
> -                    sizeof(struct pvclock_vcpu_time_info)))
> -                       vcpu->arch.pv_time_enabled = true;
> -
> +               kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
> +               break;
> +       case MSR_KVM_SYSTEM_TIME:
> +               kvm_write_system_time(vcpu, data, true, msr_info->host_initiated);
>                 break;
> -       }
>         case MSR_KVM_ASYNC_PF_EN:
>                 if (kvm_pv_enable_async_pf(vcpu, data))
>                         return 1;
> --
> 2.28.0.236.gb10cc79966-goog
>
