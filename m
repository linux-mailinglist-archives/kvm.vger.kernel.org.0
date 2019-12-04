Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A60C11385D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 00:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfLDXtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 18:49:52 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37900 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLDXtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 18:49:52 -0500
Received: by mail-il1-f194.google.com with SMTP id u17so1279482ilq.5
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 15:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5X4f/AmLuxg/+orpbQ8vNVjOBBpqULuDh6/v91vlCw=;
        b=Ni5bNSDFaGBs291vzHt85pwFJADVa/O6oYLrtdNMUO5SDSZTZ6zOtF3YoeVPYc2O5H
         t0ajMLuauJ5myzsSZWGyhIoj70+PtfrXh0EeDyAWaz9TOFsvMkKApJ2Ys6FWOVK/Rq4g
         ANqJxch4RSQy4dkK2bvugSwofH2GSn2XQ02d8fcXPcGOg+wwA/rR78Nl3D/9nebyHOQd
         UIi8+QnKMHt39CS8GzQcNzcgY7g/9OxBMRulJuUBaJesF8mUprIIdvXQvfj8I/zxwbEs
         wGbIrb+aKC/UaOhEyahbc9mAeFQrpnEiJKyVfRZggN08jyYDDqefdCZx1iVH4p+gUez2
         urbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5X4f/AmLuxg/+orpbQ8vNVjOBBpqULuDh6/v91vlCw=;
        b=Zn6KadFpknTcC2An7gX2Gc66C/0C5dw1gqKQSsGVhRWwBljHwgxKUznH8fxk0OGm0o
         a9+lQzk2VKoZkIX09ELGRINH3nPqKlm6iCNm2mIn5oHMhsisnheCZPumGrU4woWIXpdm
         O8M+thQujTYLXovGk+EORik8SrgwyWpLWdDW7GBpl6c141CqcKX6A1O0h2Jgp8xgkqrv
         BIskJkfhkZoDo8PpA3O50j6lODByBmGfcD6W7/5fkSV9SiBVM2/HoArspVbKe7mDhzg8
         4wcNEtn+PzedEB9vgSKJ8uWH061aVhod+9NGkTOxVO5IiKkEo6lnB/YaDf8ciz37t3qM
         XyMg==
X-Gm-Message-State: APjAAAXxcCLlwVNJ9W+MtPyXMijCenO84KDyrKiGX7EFjbJfx0+UqozF
        b5n1jcwOLYVOcjHvT5/pOGOL/0d7xiWigYYgA9uisEuqm7U=
X-Google-Smtp-Source: APXvYqyUDfNhYgze0SOXXeC77kbbQ3925dDTt7baEElbwCJs4ZcpDLSv5wVcJfRDgbe4SUyY8UTdtmb3PCESziZc6ac=
X-Received: by 2002:a92:8141:: with SMTP id e62mr5916069ild.119.1575503390644;
 Wed, 04 Dec 2019 15:49:50 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-5-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-5-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Dec 2019 15:49:39 -0800
Message-ID: <CALMp9eTKMzg2pNEZxhqAejAquFg8NxKRrBzzNUKRY78JLGjS5A@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The current guest mitigation of TAA is both too heavy and not really
> sufficient.  It is too heavy because it will cause some affected CPUs
> (those that have MDS_NO but lack TAA_NO) to fall back to VERW and
> get the corresponding slowdown.  It is not really sufficient because
> it will cause the MDS_NO bit to disappear upon microcode update, so
> that VMs started before the microcode update will not be runnable
> anymore afterwards, even with tsx=on.
>
> Instead, if tsx=on on the host, we can emulate MSR_IA32_TSX_CTRL for
> the guest and let it run without the VERW mitigation.  Even though
> MSR_IA32_TSX_CTRL is quite heavyweight, and we do not want to write
> it on every vmentry, we can use the shared MSR functionality because
> the host kernel need not protect itself from TSX-based side-channels.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 34 +++++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c     | 23 +++++------------------
>  2 files changed, 36 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 04a8212704c1..ed25fe7d5234 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -450,6 +450,7 @@ noinline void invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
>         MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
>  #endif
>         MSR_EFER, MSR_TSC_AUX, MSR_STAR,
> +       MSR_IA32_TSX_CTRL,
>  };
>
>  #if IS_ENABLED(CONFIG_HYPERV)
> @@ -1683,6 +1684,9 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>         index = __find_msr_index(vmx, MSR_TSC_AUX);
>         if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
>                 move_msr_up(vmx, index, save_nmsrs++);
> +       index = __find_msr_index(vmx, MSR_IA32_TSX_CTRL);
> +       if (index >= 0)
> +               move_msr_up(vmx, index, save_nmsrs++);
>
>         vmx->save_nmsrs = save_nmsrs;
>         vmx->guest_msrs_ready = false;
> @@ -1782,6 +1786,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  #endif
>         case MSR_EFER:
>                 return kvm_get_msr_common(vcpu, msr_info);
> +       case MSR_IA32_TSX_CTRL:
> +               if (!msr_info->host_initiated &&
> +                   !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
> +                       return 1;
> +               goto find_shared_msr;
>         case MSR_IA32_UMWAIT_CONTROL:
>                 if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>                         return 1;
> @@ -1884,8 +1893,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 if (!msr_info->host_initiated &&
>                     !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>                         return 1;
> -               /* Else, falls through */
> +               goto find_shared_msr;
>         default:
> +       find_shared_msr:
>                 msr = find_msr_entry(vmx, msr_info->index);
>                 if (msr) {
>                         msr_info->data = msr->data;
> @@ -2001,6 +2011,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                                               MSR_IA32_SPEC_CTRL,
>                                               MSR_TYPE_RW);
>                 break;
> +       case MSR_IA32_TSX_CTRL:
> +               if (!msr_info->host_initiated &&
> +                   !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
> +                       return 1;
> +               if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
> +                       return 1;
> +               goto find_shared_msr;
>         case MSR_IA32_PRED_CMD:
>                 if (!msr_info->host_initiated &&
>                     !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> @@ -2152,8 +2169,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 /* Check reserved bit, higher 32 bits should be zero */
>                 if ((data >> 32) != 0)
>                         return 1;
> -               /* Else, falls through */
> +               goto find_shared_msr;
> +
>         default:
> +       find_shared_msr:
>                 msr = find_msr_entry(vmx, msr_index);
>                 if (msr) {
>                         u64 old_msr_data = msr->data;
> @@ -4234,7 +4253,16 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>                         continue;
>                 vmx->guest_msrs[j].index = i;
>                 vmx->guest_msrs[j].data = 0;
> -               vmx->guest_msrs[j].mask = -1ull;
> +
> +               switch (index) {
> +               case MSR_IA32_TSX_CTRL:
> +                       /* No need to pass TSX_CTRL_CPUID_CLEAR through.  */
> +                       vmx->guest_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +                       break;
> +               default:
> +                       vmx->guest_msrs[j].mask = -1ull;
> +                       break;
> +               }
>                 ++vmx->nmsrs;
>         }
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 648e84e728fc..fc54e3905fe3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1314,29 +1314,16 @@ static u64 kvm_get_arch_capabilities(void)
>                 data |= ARCH_CAP_MDS_NO;
>
>         /*
> -        * On TAA affected systems, export MDS_NO=0 when:
> -        *      - TSX is enabled on the host, i.e. X86_FEATURE_RTM=1.
> -        *      - Updated microcode is present. This is detected by
> -        *        the presence of ARCH_CAP_TSX_CTRL_MSR and ensures
> -        *        that VERW clears CPU buffers.
> -        *
> -        * When MDS_NO=0 is exported, guests deploy clear CPU buffer
> -        * mitigation and don't complain:
> -        *
> -        *      "Vulnerable: Clear CPU buffers attempted, no microcode"
> -        *
> -        * If TSX is disabled on the system, guests are also mitigated against
> -        * TAA and clear CPU buffer mitigation is not required for guests.
> +        * On TAA affected systems:
> +        *      - nothing to do if TSX is disabled on the host.
> +        *      - we emulate TSX_CTRL if present on the host.
> +        *        This lets the guest use VERW to clear CPU buffers.
>          */
>         if (!boot_cpu_has(X86_FEATURE_RTM))
> -               data &= ~ARCH_CAP_TAA_NO;
> +               data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
>         else if (!boot_cpu_has_bug(X86_BUG_TAA))
>                 data |= ARCH_CAP_TAA_NO;
> -       else if (data & ARCH_CAP_TSX_CTRL_MSR)
> -               data &= ~ARCH_CAP_MDS_NO;
>
> -       /* KVM does not emulate MSR_IA32_TSX_CTRL.  */
> -       data &= ~ARCH_CAP_TSX_CTRL_MSR;

Shouldn't kvm be masking off any bits that it doesn't know about here?
Who knows what future features we may claim to support?

>         return data;
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
> --
> 1.8.3.1
>
>
