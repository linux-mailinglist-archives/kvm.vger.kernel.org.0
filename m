Return-Path: <kvm+bounces-20716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6199D91C9CC
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E14861F231F4
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5927615A8;
	Sat, 29 Jun 2024 00:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QazDbcR8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35A3368
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719621591; cv=none; b=Ozp2HJCaAojRla825FLrPc7YVWCJKk8sMVPhEsJ4VolZX5mSnP27Fcsee+8JTOVYVHFOHztedxsbcPjnEyHjrsl23B00eqdqukrco7shgwhuyN/dTYScXC3YMeM9CTzbu8QxbcuVmVE51/6iKD9cMc1VC7Efw6ghCjZoaf9u+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719621591; c=relaxed/simple;
	bh=Pz1g6G51mK00H5AnS6wutafS0Fk3njl56e8LnVQCYEg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XFduGTs48C4gIAFVnvldOYWNe/eSMFZUcWPUTypEUzjBgAsujAu6hQ/MeS8riwnzn6BSES7jaZo2KpvMZq/h9m7qHF7pCnd8QX7Y8ddOA549PT9SrRy8Xbts6hSHB2syDVZePbz+H0gpozXvJHLSKLld/2db4qAs5D8+PA3mLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QazDbcR8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f9c3c61dc9so8161735ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 17:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719621589; x=1720226389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kd3C0sxfCNKdrD+Sbh/WadBLxxHhTCxArwWdu5Y0sb8=;
        b=QazDbcR8Tr8V7rvoVIDkvCJ1vkf4C/q70yf4o31o4pntaZV+gTqwNcEIk9Wc7IQays
         MOh9znsjRis8VhmPzSLrsm5p5Nc0VWjTqC1O4JJop/4447HlXLcBAeEhW07dy8BpDjyq
         2iu76Kd184MOL0KA3i7lHMx+974WMHRVh9LeSufELa+CjAxyOaAEsXbLqmKVY9g9XH6O
         YhYfQfZmh3ZBjMptePuF6tUJW+7tvXS5VqZyarVCWOpRm5f2CbxuReD1EtvQIJxuxjz2
         +5oYcW4F63NssvhlS2JfAom5ynSJj5TZS2Yo9tK02IboQkIQW9AuiCCiu8PW0+EIFNSw
         M+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719621589; x=1720226389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kd3C0sxfCNKdrD+Sbh/WadBLxxHhTCxArwWdu5Y0sb8=;
        b=jh6yOQAdIbJRjIVNvOgILPMIiLGe46sUNVWvOJbw0iuAiNeFqr4CJXKp3bZBGMdpPY
         lKOgfsrpJXDJM84yhM7iRaIwl2lLMUtzkX3Hc7sDadu42gWrMXKL2Jjn+0U4kkBhHWiF
         LJMq97jQ6vIMR8BdFDupcqrJYyKRD8aQPWRHwlR8scgy4cZbWhtqpVQshzIZQHF6lCc8
         sbqH5QAfdQT+ZFmQFwIK36l6xMFaFr/XEw6xJEUkA2u8lruLp0xEDl5nNpviCE/5mbX5
         YLRmlxDS7KpEBMI62ZMtW3dfEgtjOl9tB50VlEp39yT2/KgbZMRS4YK85KprQA2mjNL+
         NUkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWr5iUdAXplsnOXySSS/WlBjz32Ddao6VUib9Sy2mfQf2mPWjtFPS9hfitp5wahKE5P1O0dH7PWDcnrDrf5tiaTzm2z
X-Gm-Message-State: AOJu0YxEMEFZg5awOWgiZetkkCCbgUuaTBDx3JBwcCs8oHaSIpDhIHzQ
	EYTLOLWgMwqhb4UCps9xU5VKs3+SjFVMeB6CJkk9P75SgGvbKcYrF5D6BJe5osNtxEp0GFyY8gu
	Jrg==
X-Google-Smtp-Source: AGHT+IH5WTUkkd8iv6KEo2gRcH1NiuxVcmzirqhZXKgqjKBjtRlrKsDdROzmt+BiaVDpGkl18D1t3Aq7D48=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40a:b0:1fa:2984:3d32 with SMTP id
 d9443c01a7336-1fa29843ebdmr20431675ad.0.1719621589051; Fri, 28 Jun 2024
 17:39:49 -0700 (PDT)
Date: Fri, 28 Jun 2024 17:39:47 -0700
In-Reply-To: <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718214999.git.reinette.chatre@intel.com> <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
Message-ID: <Zn9X0yFxZi_Mrlnt@google.com>
Subject: VMX Preemption Timer appears to be buggy on SKX, CLX, and ICX
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; charset="UTF-8"; boundary="FoqhM4pZbXonoqbf"


--FoqhM4pZbXonoqbf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Forking this off to try and avoid confusion...

On Wed, Jun 12, 2024, Reinette Chatre wrote:
> +/*
> + * Possible TDCR values with matching divide count. Used to modify APIC
> + * timer frequency.
> + */
> +static struct {
> +	uint32_t tdcr;
> +	uint32_t divide_count;
> +} tdcrs[] = {
> +	{0x0, 2},
> +	{0x1, 4},
> +	{0x2, 8},
> +	{0x3, 16},
> +	{0x8, 32},
> +	{0x9, 64},
> +	{0xa, 128},
> +	{0xb, 1},
> +};

...

> +static void apic_guest_code(void)
> +{
> +	uint64_t tsc_hz = (uint64_t)tsc_khz * 1000;
> +	const uint32_t tmict = ~0u;
> +	uint64_t tsc0, tsc1, freq;
> +	uint32_t tmcct;
> +	int i;
> +
> +	apic_enable();
> +
> +	/*
> +	 * Setup one-shot timer.  The vector does not matter because the
> +	 * interrupt should not fire.
> +	 */
> +	apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
> +
> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
> +
> +		apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
> +		apic_write_reg(APIC_TMICT, tmict);
> +
> +		tsc0 = rdtsc();
> +		udelay(delay_ms * 1000);
> +		tmcct = apic_read_reg(APIC_TMCCT);
> +		tsc1 = rdtsc();
> +
> +		/*
> +		 * Stop the timer _after_ reading the current, final count, as
> +		 * writing the initial counter also modifies the current count.
> +		 */
> +		apic_write_reg(APIC_TMICT, 0);
> +
> +		freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
> +		/* Check if measured frequency is within 1% of configured frequency. */
> +		GUEST_ASSERT(freq < apic_hz * 101 / 100);
> +		GUEST_ASSERT(freq > apic_hz * 99 / 100);
> +	}

This test fails on our SKX, CLX, and ICX systems due to what appears to be a CPU
bug.  It looks like something APICv related is clobbering internal VMX timer state?
Or maybe there's a tearing or truncation issue?

As mentioned ad nauseum at this point, I'm offline all of next week, so hopefully
there's enough info here to get a root cause...


A spurious VM-Exit will occur after programming a vmcs.PREEMPTION_TIMER_VALUE that
shouldn't exit.  Every observed failure occurs when bits 27:16 are zero, with a
small value in bits 15:0, e.g. VM-Enter with a timer value of 0xe0003bf7 or
0xa0006db6 will cause a near-immediate VM-Exit.

Weirdly, it doesn't always happen, e.g. I've observed rollover from 0xa000xxxx
to 0x9fffxxxx without failure.  However, the *test* failure is 100% reproducible,
i.e. it's not _that_ rare of a failure.  So maybe there's state build-up required?
E.g. in the failing cases, there are 10s of entries with a slightly larger timer
value, with no preemption timer exit (the host's tick IRQ interrupts the guest,
and then KVM reprograms the VMX timer).

Even more sketchy, the failure only occurs if APICv is enabled.  Turning off APICv
makes the problem go away (I initially suspected KVM was somehow botching the TMCCT
emulation).  I am 99.9% certain there is no KVM APICv bug that is causing problems.
Our IVB servers don't fail (even with APICv enabled), nor does my Raptor Lake client
box (with APICv enabled).  And I confirmed that the VMX timer is still getting
programmed with the same sequence that fails when APICv is enabled.

(Before I realized the pattern of values), I sanity checked the VMCS field just
before VM-Enter, and again after VM-Exit (KVM runs without the CPU save
vmcs.PREEMPTION_TIMER_VALUE on exit).

I also verified the CPU thinks the timer has expired by enabling "save on exit"
and verifying vmcs.PREEMPTION_TIMER_VALUE is indeed '0', and that KVM really did
get a PREEMPTION_TIMER exit.

Attached is the debug patch I used to get the below data (sort of; one of the
post-exit prints is without saving vmcs.PREEMPTION_TIMER_VALUE on exit).

In kvm_hypercall (ignore the name, I piggybacked a tracepoint because trying to
log to dmesg was too slow, guest literally couldn't make forward progress), a1 is
the VMX timer value programmed by KVM (0xe0003bf7).
 
 apic_bus_clock_-11419   [056] d..2.   146.771179: kvm_hypercall: nr 0x2c8a9e9cc6703c a0 0x2c8b0e9ce46c37 a1 0xe0003bf7 a2 0xe0003bf7 a3 0x7  
 apic_bus_clock_-11419   [056] d..2.   146.771242: kvm_exit: vcpu 0 reason PREEMPTION_TIMER rip 0x402065 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 VMX timer exit, VMCS = e0003bf7, delta = e0003690

and the post-exit print with the attached patch:

  kvm_intel: VMX timer exit, EXIT_REASON = 34, VMCS = 0, delta = e00037e9

And I've been fiddling with the below hack to coerce KVM into programming VMX
timer values.  Had I more time, I would have booted kernels with the ability to
properly fuzz the timer values.

Note, with TMICT=-1, only divide_count=1 will fail, because larger divide counts
result in a timeout that doesn't fit into the 32-bit VMX timer field (don't ask
me how long it took me to realize the divide count affects the time frequency,
not the actual count, *sigh*).

diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
index f8916bb34405..4eb49e20ff9c 100644
--- a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -22,13 +22,13 @@ static const struct {
        const uint32_t tdcr;
        const uint32_t divide_count;
 } tdcrs[] = {
-       {0x0, 2},
-       {0x1, 4},
-       {0x2, 8},
-       {0x3, 16},
-       {0x8, 32},
-       {0x9, 64},
-       {0xa, 128},
+       // {0x0, 2},
+       // {0x1, 4},
+       // {0x2, 8},
+       // {0x3, 16},
+       // {0x8, 32},
+       // {0x9, 64},
+       // {0xa, 128},
        {0xb, 1},
 };
 
@@ -55,10 +55,11 @@ static void apic_write_reg(unsigned int reg, uint32_t val)
                xapic_write_reg(reg, val);
 }
 
+uint32_t tmict = ~0u;
+
 static void apic_guest_code(uint64_t apic_hz, uint64_t delay_ms)
 {
        uint64_t tsc_hz = guest_tsc_khz * 1000;
-       const uint32_t tmict = ~0u;
        uint64_t tsc0, tsc1, freq;
        uint32_t tmcct;
        int i;
@@ -133,6 +134,7 @@ static void run_apic_bus_clock_test(uint64_t apic_hz, uint64_t delay_ms,
        vm = vm_create(1);
 
        sync_global_to_guest(vm, is_x2apic);
+       sync_global_to_guest(vm, tmict);
 
        vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
                      NSEC_PER_SEC / apic_hz);
@@ -174,7 +176,7 @@ int main(int argc, char *argv[])
 
        TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
 
-       while ((opt = getopt(argc, argv, "d:f:h")) != -1) {
+       while ((opt = getopt(argc, argv, "d:f:i:h")) != -1) {
                switch (opt) {
                case 'f':
                        apic_hz = atoi_positive("APIC bus frequency", optarg) * 1000 * 1000;
@@ -182,6 +184,9 @@ int main(int argc, char *argv[])
                case 'd':
                        delay_ms = atoi_positive("Delay in milliseconds", optarg);
                        break;
+               case 'i':
+                       tmict = ~0u - atoi_positive("offset", optarg);
+                       break;
                case 'h':
                default:
                        help(argv[0]);

--FoqhM4pZbXonoqbf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-debug.patch"

From 42da584d5e4e2dfaf4296f2ea666f3a04c82052f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jun 2024 16:33:32 -0700
Subject: [PATCH] debug

---
 arch/x86/kvm/vmx/vmx.c | 33 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h |  1 +
 arch/x86/kvm/x86.c     |  1 +
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..e83351c690d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4431,8 +4431,7 @@ static u32 vmx_vmexit_ctrl(void)
 	 * Not used by KVM and never set in vmcs01 or vmcs02, but emulated for
 	 * nested virtualization and thus allowed to be set in vmcs12.
 	 */
-	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER |
-			 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
+	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER);
 
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
@@ -5997,6 +5996,8 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu,
 						   bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 delta_tsc;
+	u64 tscl;
 
 	/*
 	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
@@ -6020,6 +6021,16 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu,
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
+	tscl = rdtsc();
+	if (vmx->hv_deadline_tsc > tscl)
+		delta_tsc = (u32)((vmx->hv_deadline_tsc - tscl) >> cpu_preemption_timer_multi);
+	else
+		delta_tsc = 0;
+
+	pr_warn("VMX timer exit, EXIT_REASON = %x, VMCS = %x, delta = %x\n",
+		vmcs_read32(VM_EXIT_REASON),
+		vmcs_read32(VMX_PREEMPTION_TIMER_VALUE), delta_tsc);
+
 	kvm_lapic_expired_hv_timer(vcpu);
 	return EXIT_FASTPATH_REENTER_GUEST;
 }
@@ -7197,6 +7208,8 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit
 	u32 delta_tsc;
 
 	if (force_immediate_exit) {
+		trace_kvm_hypercall(0, 0, 0, 0, 0);
+		vmx->preemption_timer = 0;
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (vmx->hv_deadline_tsc != -1) {
@@ -7208,9 +7221,14 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit
 		else
 			delta_tsc = 0;
 
+		trace_kvm_hypercall(tscl, vmx->hv_deadline_tsc, delta_tsc,
+				    ((vmx->hv_deadline_tsc - tscl) >> cpu_preemption_timer_multi),
+				    cpu_preemption_timer_multi);
+		vmx->preemption_timer = delta_tsc;
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (!vmx->loaded_vmcs->hv_timer_soft_disabled) {
+		trace_kvm_hypercall(-1, -1, -1, -1, -1);
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, -1);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = true;
 	}
@@ -7218,6 +7236,8 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit
 
 void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 {
+	WARN_ON(!vmx->loaded_vmcs->hv_timer_soft_disabled &&
+		vmcs_read32(VMX_PREEMPTION_TIMER_VALUE) != vmx->preemption_timer);
 	if (unlikely(host_rsp != vmx->loaded_vmcs->host_state.rsp)) {
 		vmx->loaded_vmcs->host_state.rsp = host_rsp;
 		vmcs_writel(HOST_RSP, host_rsp);
@@ -8128,7 +8148,7 @@ int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	    delta_tsc && u64_shl_div_u64(delta_tsc,
 				kvm_caps.tsc_scaling_ratio_frac_bits,
 				vcpu->arch.l1_tsc_scaling_ratio, &delta_tsc))
-		return -ERANGE;
+		goto out_of_range;
 
 	/*
 	 * If the delta tsc can't fit in the 32 bit after the multi shift,
@@ -8137,11 +8157,16 @@ int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	 * on every vmentry is costly so we just use an hrtimer.
 	 */
 	if (delta_tsc >> (cpu_preemption_timer_multi + 32))
-		return -ERANGE;
+		goto out_of_range;
 
+	trace_kvm_hypercall(tscl, vmx->hv_deadline_tsc, delta_tsc, -1, -1);
 	vmx->hv_deadline_tsc = tscl + delta_tsc;
 	*expired = !delta_tsc;
 	return 0;
+
+out_of_range:
+	vmx->hv_deadline_tsc = -1;
+	return -ERANGE;
 }
 
 void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 42498fa63abb..ecafbb11519d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -341,6 +341,7 @@ struct vcpu_vmx {
 
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
+	u32 preemption_timer;
 
 	unsigned long host_debugctlmsr;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..00847259bcc4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14024,6 +14024,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_hypercall);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);

base-commit: 128c71b7f489d8115d29a487367c648f8acc8374
-- 
2.45.2.803.g4e1b14247a-goog


--FoqhM4pZbXonoqbf--

