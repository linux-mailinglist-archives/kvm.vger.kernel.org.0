Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C9A4A8D1E
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 21:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiBCUWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 15:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiBCUWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 15:22:18 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFFAC061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 12:22:18 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q132so3203553pgq.7
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 12:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1SzB+qecFpF7d3ylySoM5Jgfe/KbFf09pYSzNH83hVY=;
        b=Uxbl8Pddg7ptvrCfhGGPT2VCjofSGjHKur3RFnhwTPwe1zAOX7ON0pTVw1avHA/ysE
         w2FRkn3rZ4nrFyU4GkduyWHjF+JQhuwrjr5AoPShnS4asAsT4QEQ3hYFJvnPPq8AEKQu
         rOQgFWh3oBskRswH/Hll7mhOlthuVuM4hKTtnQx6R8H4xkY9nJqtyYzYB1ibvMqfGdvS
         Hpb099AZw7qOD2GQGGyZR6gMho+6aXJyU38mDcUbPfuhCo5lQdVnkXhCPtYsWVYuf9aw
         YKF5OrlshJZxqvlK9t7wwAGyA0PrklvTDMgMuZjyMGZcWgm4zL4qUbhx7v4BaAz5GuYo
         +7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1SzB+qecFpF7d3ylySoM5Jgfe/KbFf09pYSzNH83hVY=;
        b=ra7tbumdJoVN0Pr//hvQb03EGhWnHBUKtJwVH+C3ovqUHQcmKMYr0J+vhbQjfVSsL2
         qWuS1ZQDL/IDU458KLcjNoWF3dLP/ouA5WVU5piTuU2Oul0sH86jSy4+aQZGE9NmoPyA
         7lQ+2xRs1WtOtjrv/FoYM2x2LTyC4Bqa0K1sWTSIpSpCTRWKj2RHpjYZpmjyvuX3WpuB
         sSz2rw8eN394LtgPAGfNzNDcLfdiFYC7YCLaQGTX6XoTa9Wujgn/mPhrHWs3S8zvDtvL
         3awZ2kHu4J+BAHQsc490waHgIOi2jN7RknKBdv3egG2F1DD8LKz83FyPX0zJ5cam1AcZ
         zRgw==
X-Gm-Message-State: AOAM530ed+2/alCmO3eRNKC3vpIP/3U4aQO0LSrc6QyFz0BC1kQG4Rbh
        UGgJV9agvMBLnRjbRjk9J9Xjrg==
X-Google-Smtp-Source: ABdhPJzyIBI7n7Dpi9I6VKoSbl8EMYAVm15Z4sAZV7OAOmKpiswlgK250uZfx9mu9zSsjHVrSSwyEA==
X-Received: by 2002:a05:6a00:793:: with SMTP id g19mr2402889pfu.21.1643919737311;
        Thu, 03 Feb 2022 12:22:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x126sm18177131pgb.85.2022.02.03.12.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 12:22:16 -0800 (PST)
Date:   Thu, 3 Feb 2022 20:22:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
Message-ID: <Yfw5ddGNOnDqxMLs@google.com>
References: <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
 <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
 <YeClaZWM1cM+WLjH@google.com>
 <YfsSjvnoQcfzdo68@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfsSjvnoQcfzdo68@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Sean Christopherson wrote:
> On Thu, Jan 13, 2022, Sean Christopherson wrote:
> > On Tue, Jan 11, 2022, Maxim Levitsky wrote:
> > > Both Intel and AMD's PRM also state that changing APIC ID is implementation
> > > dependent.
> > >  
> > > I vote to forbid changing apic id, at least in the case any APIC acceleration
> > > is used, be that APICv or AVIC.
> > 
> > That has my vote as well.  For IPIv in particular there's not much concern with
> > backwards compability, i.e. we can tie the behavior to enable_ipiv.
> 
> Hrm, it may not be that simple.  There's some crusty (really, really crusty) code
> in Linux's boot code that writes APIC_ID.  IIUC, the intent is to play nice with
> running a UP crash dump kernel on "BSP" that isn't "the BSP", e.g. has a non-zero
> APIC ID.
 
...

> It's entirely possible that this path is unused in a KVM guest, but I don't think
> we can know that with 100% certainty.
> 
> But I also completely agree that attempting to keep the tables up-to-date is ugly
> and a waste of time and effort, e.g. as Maxim pointed out, the current AVIC code
> is comically broken.
> 
> Rather than disallowing the write, what if we add yet another inhibit that disables
> APICv if IPI virtualization is enabled and a vCPU has an APIC ID != vcpu_id?  KVM
> is equipped to handle the emulation, so it just means that a guest that's doing 
> weird things loses a big of performance.

LOL, this is all such a mess.  The x2apic ID is actually indirectly writable on
AMD CPUs.  Per the APM:

  A value previously written by software to the 8-bit APIC_ID register (MMIO offset 30h) is
  converted by hardware into the appropriate format and reflected into the 32-bit x2APIC_ID
  register (MSR 802h).

I confirmed this on hardware (Milan).  That means KVM's handling of the x2APIC ID
in kvm_lapic_set_base() is wrong, at least with respect to AMD.

Intel's SDM is a bit vague.  I _think_ it means Intel CPUs treat the the x2APIC ID
and xAPIC ID as two completely independent assets.  I haven't been able to glean any
info from hardware because writes to the legacy xAPIC ID are ignored on all CPUs
I've tested (Haswell and Cascade lake).

  The x2APIC ID (32 bits) and the legacy local xAPIC ID (8 bits) are preserved
  across this transition.

Given that the xAPIC ID appears to no longer be writable on Intel CPUs, it's
impossible that _generic_ kernel code can rely on xAPIC ID being writable.  That
just leaves the aforementioned amd_numa_init() crud.

Linux's handling of that is:

  void __init x86_numa_init(void)
  {
	if (!numa_off) {
  #ifdef CONFIG_ACPI_NUMA
		if (!numa_init(x86_acpi_numa_init))
			return;
  #endif
  #ifdef CONFIG_AMD_NUMA
		if (!numa_init(amd_numa_init))
			return;
  #endif
	}

	numa_init(dummy_numa_init);
  }

i.e. ACPI_NUMA gets priority and thus amd_numa_init() will never be reached if
the NUMA topology is enumerated in the ACPI tables.  Furthermore, the VMM would
have to actually emulate an old AMD northbridge, which is also extremely unlikely.

The odds of breaking a guest are further diminised given that KVM doesn't emulate
the xAPIC ID => x2APIC ID hilarity on AMD CPUs and no one has complained.

So, rather than tie this to IPI virtualization, I think we should either make
the xAPIC ID read-only across the board, or if we want to hedge in case someone
has a crazy use case, make the xAPIC ID read-only by default, add a module param
to let userspace opt-in to a writable xAPIC ID, and report x2APIC and APICv as
unsupported if the xAPIC ID is writable.  E.g. rougly this, plus your AVIC patches
if we want to hedge.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 28be02adc669..32854ac403a8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -539,8 +539,15 @@ void kvm_set_cpu_caps(void)
                0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
                F(F16C) | F(RDRAND)
        );
-       /* KVM emulates x2apic in software irrespective of host support. */
-       kvm_cpu_cap_set(X86_FEATURE_X2APIC);
+       /*
+        * KVM emulates x2apic in software irrespective of host support.  Due
+        * to architecturally difference between Intel and AMD, x2APIC is not
+        * supported if the xAPIC ID is writable.
+        */
+       if (!xapic_id_writable)
+               kvm_cpu_cap_set(X86_FEATURE_X2APIC);
+       else
+               kvm_cpu_cap_clear(X86_FEATURE_X2APIC);

        kvm_cpu_cap_mask(CPUID_1_EDX,
                F(FPU) | F(VME) | F(DE) | F(PSE) |
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 670361bf1d81..6b42b65e7a42 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2047,10 +2047,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)

        switch (reg) {
        case APIC_ID:           /* Local APIC ID */
-               if (!apic_x2apic_mode(apic))
+               if (apic_x2apic_mode(apic))
+                       ret = 1;
+               else if (xapic_id_writable)
                        kvm_apic_set_xapic_id(apic, val >> 24);
-               else
-                       ret = 1;
                break;

        case APIC_TASKPRI:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9cef8e4598df..71a3bcdb3317 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4743,7 +4743,8 @@ static __init int svm_hardware_setup(void)
                        nrips = false;
        }

-       enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+       enable_apicv = avic = avic && !xapic_id_writable && npt_enabled &&
+                      boot_cpu_has(X86_FEATURE_AVIC);

        if (enable_apicv) {
                pr_info("AVIC enabled\n");
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b135473677b..fad7b36fbb1d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7939,7 +7939,7 @@ static __init int hardware_setup(void)
                ple_window_shrink = 0;
        }

-       if (!cpu_has_vmx_apicv())
+       if (!cpu_has_vmx_apicv() || xapic_id_writable)
                enable_apicv = 0;
        if (!enable_apicv)
                vmx_x86_ops.sync_pir_to_irr = NULL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eaad2f485b64..ef6eba8c832a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -174,6 +174,10 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);

+bool __read_mostly xapic_id_writable;
+module_param(xapic_id_writable, bool, 0444);
+EXPORT_SYMBOL_GPL(xapic_id_writable);
+
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1ebd5a7594da..142663ff9cba 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -346,6 +346,7 @@ static inline bool kvm_mpx_supported(void)

 extern unsigned int min_timer_period_us;

+extern bool xapic_id_writable;
 extern bool enable_vmware_backdoor;

 extern int pi_inject_timer;

