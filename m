Return-Path: <kvm+bounces-36587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB245A1BF93
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E748D169464
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CC0259C;
	Sat, 25 Jan 2025 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tx9P1eQQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E8800
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 00:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737763955; cv=none; b=uokjBCtedtDXomj2DMxfkdRPIJwNk7KQzReUCGgBgIyduzmno/+Uvj41whaFQf4RmQssPTOSbxMbgI6TFXQNpwoPEm7N7wTEAZtrOP+gMZC0YDnmIqegV+h1bb+aQVnmeIiuxBHv/1x/9WIonbU0kLj1TsYwmjaIB1qRT9IAdJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737763955; c=relaxed/simple;
	bh=899IIrVZJMs7v0BlpxjxJZPZrbqPsl2HbGugOJzsQnE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QpAStZ5bz67zSuMrtSnSwLLSn9RKhf6eGQz4Rx+cDXKyTEOdnzkGzpKl0vxwP5t5lxc8sO/qc4chaAsOXiX90IzcIedaHqlefXFqHzEZsYKbaSZXTV0rV0QY/8Gq/YsRM9gXRsUOHrk4S8h5882/ApGyExnXwm5v14RUnio4B3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tx9P1eQQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so7423975a91.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737763953; x=1738368753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwXxuKVm/AHDPJfujVDPiVbqgkB4LsEOLC015TvKkvM=;
        b=Tx9P1eQQ3lCWLvuRl21PVwoIopRGveZumkMScsnndG1rKFK9CsEJXlaNnpQSiAI3Zs
         pKeILSrHO/PB5BgFcDY4JJ3LXM6g6xOMSO5l/slHNiayV9HS9Bmr4EkmqL4mM9voCLkv
         LdgGf/rmVGR0zPG8sJsDBn/kGFhqC6lEl9YFwJKmgbBXZk0uz6gcXfuZProW3iGoluez
         AeeTRsQwgZ9d1G8iQxLUkuDAlGPVXkVCWF7UKxXNf6njeyAIsM/aTKHfklHwhl/sDKdu
         FpBXRpCE2shAPuBBYWFjzM9666ihBNI59p4N6IwjjO57q0ozdC3GZHE7r+ISo759usu+
         RwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737763953; x=1738368753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwXxuKVm/AHDPJfujVDPiVbqgkB4LsEOLC015TvKkvM=;
        b=rNofKE/P7SW/8Wc3Ch9Xd1DAN3n3C9x6f/1otJDIixvFNWgghUTupga4ldjfvFufLq
         0+Dyoj9K8RkDRkp+viZJjz166Uo8bcq8NSbk5FwoQxttwZzGZUhZecv0vEHj3pEHtpyY
         AZndeGkVcZtG1sYg69j1MTtcLsltCcLVaWD9RFCSzavm6+898DpGpv6k5JExypg1S3EX
         X3VmSI060kfF9P5ExHq3sGGikzYJb9LCZ04ZAQJYaLxEcryztLPDlEeGurf2aTc813lH
         CScU+/piJyYF9QjQpOIahrpqT1cAzXU9rt0WkDBVnp997UCV/pU2CcXvdgRKpcG2VNer
         c9cA==
X-Gm-Message-State: AOJu0YyXFfhSdfQTSSG8D3VC9EqeO/fRfS4s+Ol+V6XpuS1tYfugfXkx
	aWy0JmNaMV0o+IxMqNRwt+f7aDecnDtcVaApv0lFfo0Tkcv4xubvOQH0Sc2FTCORDZxGcBw3aXu
	S0w==
X-Google-Smtp-Source: AGHT+IEWfgFaka0Kw+lzIpQfDJ5QHArEACKAcEqIJStHGVlzR2RhutLVZ7gzUDagx1dNdhnBHtzD45Lo1RE=
X-Received: from pfbcp9.prod.google.com ([2002:a05:6a00:3489:b0:72d:afb3:3a2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ad8a:b0:725:8b00:167e
 with SMTP id d2e1a72fcca58-72dafb714eamr44348419b3a.16.1737763952746; Fri, 24
 Jan 2025 16:12:32 -0800 (PST)
Date: Fri, 24 Jan 2025 16:12:31 -0800
In-Reply-To: <f7b73f3b65377b7fd28f1f4764ea18f98056c51a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
 <Zx-z5sRKCXAXysqv@google.com> <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
 <Z5BDr2mm57F0vfax@google.com> <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
 <Z5Fc4d5bVf5oVlOk@google.com> <f7b73f3b65377b7fd28f1f4764ea18f98056c51a.camel@redhat.com>
Message-ID: <Z5QsbyZNkzi6qdYJ@google.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only LBRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Maxim Levitsky wrote:
> On Wed, 2025-01-22 at 13:02 -0800, Sean Christopherson wrote:
> > > > > Note that I read all msrs using 'rdmsr' userspace tool.
> > > > 
> > > > I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
> > > > assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
> > > > down to confirm (the code I see on inspecition is gated on at least one perf
> > > > event using LBRs).  My guess is that there's a software bug somewhere in the
> > > > perf/KVM exchange.
> > > > 
> > > > I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
> > > > to read/write all LBRs during initialization works with LBRs disabled.
> 
> Hi!
> 
> I finally got to the very bottom of this:
> 
> First of all, your assumption that the kernel resets LBR related msrs on
> context switch after 'wrmsr' program finishes execution is wrong, because the
> kernel will only do this if it *itself* enables the LBR feature (that is when
> something like 'perf', uses a perf counter with a lbr call stack).
> 
> Writes that 'wrmsr' tool does are not something that kernel expects so it
> doesn't do anything in this case.
> 
> What is happening instead, is something completely different: Turns out that
> to shave off something like 50 nanoseconds, off the deep C-state entry/exit
> latency, some Intel CPU don't preserve LBR stack values over these C-state
> entries.

Ugh.

> > Ugh, but it does.  On writes to any LBR, including LBR_TOS, KVM creates a "virtual"
> > LBR perf event.  KVM then relies on perf to context switch LBR MSRs, i.e. relies
> > on perf to load the guest's values into hardware.  At least, I think that's what
> > is supposed to happen.  AFAIK, the perf-based LBR support has never been properly
> > document[*].
> > 
> > Anyways, my understanding of intel_pmu_handle_lbr_msrs_access() is that if the
> > vCPU's LBR perf event is scheduled out or can't be created, the guest's value is
> > effectively lost.  Again, I don't know the "rules" for the LBR perf event, but
> > it wouldn't suprise me if your CI fails because something in the host conflicts
> > with KVM's LBR perf event.
> 
> Actually you are partially wrong here too (although BIOS can be considered
> 'something on the host').
> 
> I was able to prove that the reason why the unit test fails *is* because BIOS
> left LBRs enabled:
> 
> First of all, setting LBR bit manually in DEBUG_CTL does trigger this bug 
> (I use a different machine now, which doesn't have the bios bug):

...

> ==== Test Assertion Failure ====
>   x86_64/vmx_pmu_caps_test.c:202: r == v
>   pid=8415 tid=8415 errno=0 - Success
>      1	0x0000000000404301: __suite_lbr_perf_capabilities at vmx_pmu_caps_test.c:202
>      2	 (inlined by) vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
>      3	 (inlined by) wrapper_vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
>      4	0x000000000040511a: __run_test at kselftest_harness.h:1240
>      5	0x0000000000402b95: test_harness_run at kselftest_harness.h:1310
>      6	 (inlined by) main at vmx_pmu_caps_test.c:246
>      7	0x00007f56ba2295cf: ?? ??:0
>      8	0x00007f56ba22967f: ?? ??:0
>      9	0x0000000000402e44: _start at ??:?
>   Set MSR_LBR_TOS to '0x7', got back '0xc'
> # lbr_perf_capabilities: Test failed
> #          FAIL  vmx_pmu_caps.lbr_perf_capabilities
> not ok 5 vmx_pmu_caps.lbr_perf_capabilities
> #  RUN           vmx_pmu_caps.perf_capabilities_unsupported ...
> #            OK  vmx_pmu_caps.perf_capabilities_unsupported
> ok 6 vmx_pmu_caps.perf_capabilities_unsupported
> # FAILED: 5 / 6 tests passed.
> # Totals: pass:5 fail:1 xfail:0 xpass:0 skip:0 error:0
> 
> Secondary I went over all places in the kernel and all of them take care to
> preserve DEBUG_CTL and only set/clear specific bits.
> 
> __intel_pmu_lbr_enable() and __intel_pmu_lbr_enable() are practically the
> only two places where DEBUGCTLMSR_LBR bit is touched, and the test doesn't
> trigger them. Most likely because the test uses special
> 'INTEL_FIXED_VLBR_EVENT' perf event (see intel_pmu_create_guest_lbr_event)
> which is not enabled while in host mode.
> 
> To double check this I traced all writes to DEBUG_CTL msr during this test
> and the only write is done during 'guest_wrmsr_perf_capabilities' subtest, by
> vmx_vcpu_run() which just restores the value that the msr had prior to VM
> entry.
> 
> So, why the value that BIOS sets survives? Because as I said all code that
> touches DEBUG_CTL takes care to preserve all bits but the bit which is
> changed, LBRs are never enabled on the host, and even the guest entry
> preserves host DEBUG_CTL.  Therefore the value written by BIOS survives.

Well that's rather insane.

> So we end up with the test writing to LBR_TOS while LBRs are unexpectedly
> enabled, so it's not a surprise that when the test reads back the value
> written, it will differ, and the test will rightfully fail.
> 
> Since we have seen this in CI, and you saw it too in your CI,

Gah, that was bad reporting on my end.  The failure we saw was something else
entirely.

> I think this BIOS bug is not that rare, and so I suggest to stick
> 'wrmsrl(MSR_IA32_DEBUGCTLMSR, 0)' somewhere early in a kernel boot code or at
> least clear the DEBUGCTLMSR_LBR bit.
> 
> I haven't found a very good place to put this, in a way that I can be sure
> that x86 maintainers won't reject it, so I am open to your suggestions.

Compile tested only, but perf's CPU online path seems appropriate, especially
since that path also explicitly clears LBRs.  Ensuring LBRs are stopped before
clearing them seems logical.

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 99c590da0ae2..6e898b832d75 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5030,8 +5030,12 @@ static void intel_pmu_cpu_starting(int cpu)
 
        init_debug_store_on_cpu(cpu);
        /*
-        * Deal with CPUs that don't clear their LBRs on power-up.
+        * Deal with CPUs that don't clear their LBRs on power-up, and with
+        * BIOSes that leave LBRs enabled.
         */
+       if (!static_cpu_has(X86_FEATURE_ARCH_LBR) && x86_pmu.lbr_nr)
+               msr_clear_bit(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR_BIT);
+
        intel_pmu_lbr_reset();
 
        cpuc->lbr_sel = NULL;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..bb7dd85aa6f2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -395,7 +395,8 @@
 #define MSR_IA32_PASID_VALID           BIT_ULL(31)
 
 /* DEBUGCTLMSR bits (others vary by model): */
-#define DEBUGCTLMSR_LBR                        (1UL <<  0) /* last branch recording */
+#define DEBUGCTLMSR_LBR_BIT            0
+#define DEBUGCTLMSR_LBR                        (1UL <<  DEBUGCTLMSR_LBR_BIT) /* last branch recording */
 #define DEBUGCTLMSR_BTF_SHIFT          1
 #define DEBUGCTLMSR_BTF                        (1UL <<  1) /* single-step on branches */
 #define DEBUGCTLMSR_BUS_LOCK_DETECT    (1UL <<  2)


