Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF7209E19
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 14:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404486AbgFYMGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 08:06:46 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33004 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404222AbgFYMGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 08:06:46 -0400
Received: by mail-ot1-f65.google.com with SMTP id n6so5033395otl.0;
        Thu, 25 Jun 2020 05:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rD/XDnXIKX8gNhT/DuKyWWpCmsBD1jr7T2XgYaQBYJQ=;
        b=H+hiF3xg+yVjD5dVHOyzq6oMDavu21+adZp52vIq4/e9ER0Adx6yXhN6s+a3TeFUSs
         2Bjsa0q1obKSn9fckL0V2qdFYOkOl/wow1tkdFyaCDETMZrahuOFa18ffXIMkuFzW2c+
         aS04dAe3J5l7t1B0qO58jv/8w2oVguXMfo8c0hwttq2QQ+nZA7AZv0B3Jm50C5f3Amkt
         YPgi9dvZ/eAHvoJPQbttFJTXqbJPl2rWHi8/4jZ/6JgYQyXQemuXh+pxuXQ1lIq718cq
         SgfXLJ9L5FFW4E09f3Hg/nJs7y3b/beXQRZSgvGPyVx2NcaRsRCXQ6a0+if3w6321lhA
         O0aw==
X-Gm-Message-State: AOAM533LaEYkY4xFebpI2b3blXIIRIOzMVBaixFMcguyfMZHtL+tN5Kc
        Aa0LezSo1iwguU0NH8Wq5G/h65+/bbmB22P6VFD2hnJ0
X-Google-Smtp-Source: ABdhPJxZ5HE61KmrZClwMlPjhbYjedR8tZFyYwac2mmi23TtFNeN3JzwcImgSG9LuPFH0jGfiufbraqmXRuh6M68dPI=
X-Received: by 2002:a9d:7d15:: with SMTP id v21mr25614213otn.118.1593086804897;
 Thu, 25 Jun 2020 05:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200608174134.11157-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200608174134.11157-1-sean.j.christopherson@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 25 Jun 2020 14:06:33 +0200
Message-ID: <CAJZ5v0inhpW1vbYJYPqWgkekK7hKhgO_fE5JmemT+p2qh7RFaw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 8, 2020 at 7:49 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
> where firmware doesn't initialize or save/restore across S3.  This fixes
> a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
> taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.
>
> Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
> with the case where the MSR is locked, and because APs already redo
> init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
> used to reinitialize APs upon wakeup.  Do the call in the early wakeup
> flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
> a resume hook is not guaranteed to work, as KVM does VMXON in its own
> resume hook, kvm_resume(), when KVM has active guests.
>
> Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
> Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org # v5.6
> Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Given the regression fix nature of this patch, is it being taken care
of by anyone (tip in particular) already?

> ---
>
> v2:
>   - Collect Reviewed/Tested tags. [Brad, Liam, Maxim].
>   - Include asm/cpu.h to fix Zhaoxin and Centaur builds. [Brad, LKP]
>   - Add Cc to stable. [Liam]
>
>  arch/x86/include/asm/cpu.h    | 5 +++++
>  arch/x86/kernel/cpu/centaur.c | 1 +
>  arch/x86/kernel/cpu/cpu.h     | 4 ----
>  arch/x86/kernel/cpu/zhaoxin.c | 1 +
>  arch/x86/power/cpu.c          | 6 ++++++
>  5 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index dd17c2da1af5..da78ccbd493b 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -58,4 +58,9 @@ static inline bool handle_guest_split_lock(unsigned long ip)
>         return false;
>  }
>  #endif
> +#ifdef CONFIG_IA32_FEAT_CTL
> +void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> +#else
> +static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
> +#endif
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
> index 426792565d86..c5cf336e5077 100644
> --- a/arch/x86/kernel/cpu/centaur.c
> +++ b/arch/x86/kernel/cpu/centaur.c
> @@ -3,6 +3,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/clock.h>
>
> +#include <asm/cpu.h>
>  #include <asm/cpufeature.h>
>  #include <asm/e820/api.h>
>  #include <asm/mtrr.h>
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index 37fdefd14f28..38ab6e115eac 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -80,8 +80,4 @@ extern void x86_spec_ctrl_setup_ap(void);
>
>  extern u64 x86_read_arch_cap_msr(void);
>
> -#ifdef CONFIG_IA32_FEAT_CTL
> -void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> -#endif
> -
>  #endif /* ARCH_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
> index df1358ba622b..05fa4ef63490 100644
> --- a/arch/x86/kernel/cpu/zhaoxin.c
> +++ b/arch/x86/kernel/cpu/zhaoxin.c
> @@ -2,6 +2,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/clock.h>
>
> +#include <asm/cpu.h>
>  #include <asm/cpufeature.h>
>
>  #include "cpu.h"
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index aaff9ed7ff45..b0d3c5ca6d80 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -193,6 +193,8 @@ static void fix_processor_context(void)
>   */
>  static void notrace __restore_processor_state(struct saved_context *ctxt)
>  {
> +       struct cpuinfo_x86 *c;
> +
>         if (ctxt->misc_enable_saved)
>                 wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
>         /*
> @@ -263,6 +265,10 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
>         mtrr_bp_restore();
>         perf_restore_debug_store();
>         msr_restore_context(ctxt);
> +
> +       c = &cpu_data(smp_processor_id());
> +       if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
> +               init_ia32_feat_ctl(c);
>  }
>
>  /* Needed by apm.c */
> --
> 2.26.0
>
