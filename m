Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A031CC6EF
	for <lists+kvm@lfdr.de>; Sun, 10 May 2020 07:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgEJFPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 May 2020 01:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgEJFPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 May 2020 01:15:54 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E432495C
        for <kvm@vger.kernel.org>; Sun, 10 May 2020 05:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589087754;
        bh=t7OQLTIXuGL96dx+kNLL3AbQ0katVk2LF5iQG5oESdE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i3eHbpXjw0bJe+9YiwcIjIDdALHuGcSyvHQ1VZFUqLub0EFjw05+GGO8GYJi/oTt8
         1cGg+K/WtpmSdBIAbE83ds8iKnbRO/M0bvTT7OQeiW5Khv5QkZm3CsYgxUBiLblT0T
         xvhF1pSf8DMlpoqf5RvnJxEQaIw5LSWdsDaItFfc=
Received: by mail-wr1-f49.google.com with SMTP id j5so6676067wrq.2
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 22:15:53 -0700 (PDT)
X-Gm-Message-State: AGi0Pub2HkkQexL+mLILQnIGd4fvsOrP3gUAu7JND9wzw6aJ0ru4bkS6
        +CLnsdH+VIJijGIKS/MVKs7rfZ1geZ6m5lesb+ClLQ==
X-Google-Smtp-Source: APiQypI/2IcENdMUlGzuFOkNQBcqpLGrIdvnZu9gpjupdPaPbLc1HLvZZh1HqrthlXt2P8chNZ4GK+Wlpj8/O/fmpB8=
X-Received: by 2002:adf:f446:: with SMTP id f6mr4007350wrp.75.1589087752473;
 Sat, 09 May 2020 22:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200509110542.8159-1-xiaoyao.li@intel.com> <20200509110542.8159-9-xiaoyao.li@intel.com>
In-Reply-To: <20200509110542.8159-9-xiaoyao.li@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 9 May 2020 22:15:41 -0700
X-Gmail-Original-Message-ID: <CALCETrWJGyyyvsgryvro45WNNpnSZ2k_QEjm95-+5rvREztOYA@mail.gmail.com>
Message-ID: <CALCETrWJGyyyvsgryvro45WNNpnSZ2k_QEjm95-+5rvREztOYA@mail.gmail.com>
Subject: Re: [PATCH v9 8/8] x86/split_lock: Enable split lock detection
 initialization when running as an guest on KVM
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 8, 2020 at 8:04 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> When running as guest, enumerating feature split lock detection through
> CPU model is not easy since CPU model is configurable by host VMM.
>
> If running upon KVM, it can be enumerated through
> KVM_FEATURE_SPLIT_LOCK_DETECT,

This needs crystal clear documentation.  What, exactly, is the host
telling the guest if it sets this flag?

> and if KVM_HINTS_SLD_FATAL is set, it
> needs to be set to sld_fatal mode.


This needs much better docs.  Do you mean:

"If KVM_HINTS_SLD_FATAL is set, then the guest will get #AC if it does
a split-lock regardless of what is written to MSR_TEST_CTRL?"


>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  |  2 ++
>  arch/x86/kernel/cpu/intel.c | 12 ++++++++++--
>  arch/x86/kernel/kvm.c       |  3 +++
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index a57f00f1d5b5..5d5b488b4b45 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -42,12 +42,14 @@ unsigned int x86_model(unsigned int sig);
>  unsigned int x86_stepping(unsigned int sig);
>  #ifdef CONFIG_CPU_SUP_INTEL
>  extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
> +extern void __init split_lock_setup(bool fatal);
>  extern void switch_to_sld(unsigned long tifn);
>  extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
>  extern bool handle_guest_split_lock(unsigned long ip);
>  extern bool split_lock_virt_switch(bool on);
>  #else
>  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
> +static inline void __init split_lock_setup(bool fatal) {}
>  static inline void switch_to_sld(unsigned long tifn) {}
>  static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>  {
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1e2a74e8c592..02e24134b9b5 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -996,12 +996,18 @@ static bool split_lock_verify_msr(bool on)
>         return ctrl == tmp;
>  }
>
> -static void __init split_lock_setup(void)
> +void __init split_lock_setup(bool fatal)
>  {
>         enum split_lock_detect_state state = sld_warn;
>         char arg[20];
>         int i, ret;
>
> +       if (fatal) {
> +               state = sld_fatal;
> +               pr_info("forced on, sending SIGBUS on user-space split_locks\n");
> +               goto set_cap;
> +       }
> +
>         if (!split_lock_verify_msr(false)) {
>                 pr_info("MSR access failed: Disabled\n");
>                 return;
> @@ -1037,6 +1043,7 @@ static void __init split_lock_setup(void)
>                 return;
>         }
>
> +set_cap:
>         setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
>         if (state == sld_fatal)
>                 setup_force_cpu_cap(X86_FEATURE_SLD_FATAL);
> @@ -1161,6 +1168,7 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
>         const struct x86_cpu_id *m;
>         u64 ia32_core_caps;
>
> +       /* Note, paravirt support can enable SLD, e.g., see kvm_guest_init(). */
>         if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
>                 return;
>
> @@ -1182,5 +1190,5 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
>                 return;
>         }
>
> -       split_lock_setup();
> +       split_lock_setup(false);
>  }
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb72..489ea89e2e8e 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -670,6 +670,9 @@ static void __init kvm_guest_init(void)
>          * overcommitted.
>          */
>         hardlockup_detector_disable();
> +
> +       if (kvm_para_has_feature(KVM_FEATURE_SPLIT_LOCK_DETECT))
> +               split_lock_setup(kvm_para_has_hint(KVM_HINTS_SLD_FATAL));
>  }
>
>  static noinline uint32_t __kvm_cpuid_base(void)
> --
> 2.18.2
>
