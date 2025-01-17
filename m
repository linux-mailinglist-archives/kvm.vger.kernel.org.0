Return-Path: <kvm+bounces-35839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 822CAA1557D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35F9D3A454D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A251A257D;
	Fri, 17 Jan 2025 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TKzVcS1h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3751A255C
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133916; cv=none; b=pS6wuhhLmojk3/Bweg2M6It1poQMMPjqGZ9s4n60x1NqXjvxzwYv4VU/BXREjZI44tLu02GK9V9cXSLrywwOZf7s20mwLDMYizojV5ivBPY+x0zwTX6yfHVDk10jC7QkRv6B3/6NO8s5qEeHl7YiNvcBx+c3/ahcpQufULwaxJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133916; c=relaxed/simple;
	bh=KanrjoUJLOdHNPS5gdbVhClozrzbXAVOWudE0SQVLhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f7L2fW6Ljgw2S3iJuUo/SmE5L5JotLpZRfzVgf3mFfgSjX37J15YnG3g9PKFZDB3AcT31MW1RynEPdhzbx2v1IkGfLMusGl1R503hprNa/lJ4a1D5Aje0iJyCbKkf1c1O+vtdGotvMzPwqfJqk6msGI+HDNCprlM5gpFYXJv+TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TKzVcS1h; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so4393994a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 09:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737133914; x=1737738714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AX+0WCcXh8cJ6GecXmZCquxt01hUAK/G4viUXPcZHA=;
        b=TKzVcS1hbB3XJG4dc7WCzImg2L2MTtNrR99Q0m3qz7a8IqaNQFL/k1ccMN/RNlzD4K
         zWuvAJMcqXsassC3v74sNC+bM7kJOYyX/8e70UgqDZQlcWA6SyIJwjjGO2oZwDYVmjoF
         8q7jsbcSFwRsswWu58hE/20aR0fSgsbB3FyohvOu9t5awKpt7HXHI/bvHAezpJrs7Mxj
         y9h2hHtby94bq4v2l82fE1GvtiJGDJPxcc58dqLEqsO8vMHcR5cjrZiaN/qZbsZyngY0
         CGXLq8hxRZQjXY+/xXmmYvXhHC/C6Vap9Qz9cO1/1a84r6yenUXIDQQP+D8oggvdP35b
         /Exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737133914; x=1737738714;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4AX+0WCcXh8cJ6GecXmZCquxt01hUAK/G4viUXPcZHA=;
        b=VXm0/V8DTEDyB3+jbyZQ0l2JvdMtXwmYOreWf3MFhbhe4muip+EbtZe37nKkFoEh+N
         18uuS22biqiDhrByZ9SjO1NHuo2hQ28+Bl1RXu59+PSa5gtuFI8WN8xMEDhoT1XbW/zR
         F1w+iAyuMnyOIGW4Adjfiy4+J1M5jpFOz/MZM9JMUctPUkUpaNHvaC+9uHbwSsGSR5pa
         Yr5imk0Vhu9jsPQXTdkzDNIolM86kTngBKblY82v+7SjVOABn4z2bfRZGZjJ3uNiab/D
         Eucx60LEXEnGYrUQQ8fjJkJ0lUTR0cXkynUbvuA5/7n9IVP6RgP/uC2lLDLzULUyRYkw
         Sczg==
X-Forwarded-Encrypted: i=1; AJvYcCU5S3FZOzHmoM4mNhdinIRVVco9of9RyCQH/wk7d0M8RGX55VwgcKx+aWoM8oRk6DvblYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YySDx5DJB54UicAfkhLFitg/UbqGZ36nAWn4Qts3hfrC2x9X8Ob
	x+d80+PFoiaobgwZNZEz2TX8MyT5MiOqiprpyARWsgUJ50RRc7Z/F6ifNczbqW6egHLElk6wT+Q
	ccQ==
X-Google-Smtp-Source: AGHT+IE77rcv5HrwFrxUynsxMjv0lHMOVyIZyhO9Pfy6UsV9tm9AHlNGCjvnQwG4vmR2r2SmutECV7mkUcs=
X-Received: from pjbsl4.prod.google.com ([2002:a17:90b:2e04:b0:2f5:4762:e778])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f81:b0:2ee:f22a:61dd
 with SMTP id 98e67ed59e1d1-2f782d9a170mr4235938a91.32.1737133913770; Fri, 17
 Jan 2025 09:11:53 -0800 (PST)
Date: Fri, 17 Jan 2025 09:11:52 -0800
In-Reply-To: <6c23d536-484f-4c4b-aa85-3e0b9544611a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202501141009.30c629b4-lkp@intel.com> <Z4a_PmUVVmUtOd4p@google.com>
 <a2adf1b8-c394-4741-a42b-32288657b07e@linux.intel.com> <6c23d536-484f-4c4b-aa85-3e0b9544611a@linux.intel.com>
Message-ID: <Z4qPWNscnU9-b30n@google.com>
Subject: Re: [linux-next:master] [KVM] 7803339fa9: kernel-selftests.kvm.pmu_counters_test.fail
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kernel test robot <oliver.sang@intel.com>, g@google.com, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	xudong.hao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025, Dapeng Mi wrote:
> On 1/15/2025 10:44 AM, Mi, Dapeng wrote:
> > On 1/15/2025 3:47 AM, Sean Christopherson wrote:
> >>> # Testing fixed counters, PMU version 0, perf_caps =3D 2000
> >>> # Testing arch events, PMU version 1, perf_caps =3D 0
> >>> # =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >>> #   x86/pmu_counters_test.c:129: count >=3D (10 * 4 + 5)
> >>> #   pid=3D6278 tid=3D6278 errno=3D4 - Interrupted system call
> >>> #      1	0x0000000000411281: assert_on_unhandled_exception at process=
or.c:625
> >>> #      2	0x00000000004075d4: _vcpu_run at kvm_util.c:1652
> >>> #      3	 (inlined by) vcpu_run at kvm_util.c:1663
> >>> #      4	0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
> >>> #      5	0x0000000000402e4d: test_arch_events at pmu_counters_test.c:=
315
> >>> #      6	0x0000000000402663: test_arch_events at pmu_counters_test.c:=
304
> >>> #      7	 (inlined by) test_intel_counters at pmu_counters_test.c:609
> >>> #      8	 (inlined by) main at pmu_counters_test.c:642
> >>> #      9	0x00007f3b134f9249: ?? ??:0
> >>> #     10	0x00007f3b134f9304: ?? ??:0
> >>> #     11	0x0000000000402900: _start at ??:?
> >>> #   count >=3D NUM_INSNS_RETIRED
> >> The failure is on top-down slots.  I modified the assert to actually p=
rint the
> >> count (I'll make sure to post a patch regardless of where this goes), =
and based
> >> on the count for failing vs. passing, I'm pretty sure the issue is not=
 the extra
> >> instruction, but instead is due to changing the target of the CLFUSH f=
rom the
> >> address of the code to the address of kvm_pmu_version.
> >>
> >> However, I think the blame lies with the assertion itself, i.e. with c=
ommit
> >> 4a447b135e45 ("KVM: selftests: Test top-down slots event in x86's pmu_=
counters_test").
> >> Either that or top-down slots is broken on the Lakes.
> >>
> >> By my rudimentary measurements, tying the number of available slots to=
 the number
> >> of instructions *retired* is fundamentally flawed.  E.g. on the Lakes =
(SKX is more
> >> or less identical to CLX), omitting the CLFLUSHOPT entirely results in=
 *more*
> >> slots being available throughout the lifetime of the measured section.
> >>
> >> My best guess is that flushing the cache line use for the data load ca=
uses the
> >> backend to saturate its slots with prefetching data, and as a result t=
he number
> >> of slots that are available goes down.
> >>
> >>         CLFLUSHOPT .    | CLFLUSHOPT [%m]       | NOP
> >> CLX     350-100         | 20-60[*]              | 135-150 =20
> >> SPR     49000-57000     | 32500-41000           | 6760-6830
> >>
> >> [*] CLX had a few outliers in the 200-400 range, but the majority of r=
uns were
> >>     in the 20-60 range.
> >>
> >> Reading through more (and more and more) of the TMA documentation, I d=
on't think
> >> we can assume anything about the number of available slots, beyond a v=
ery basic
> >> assertion that it's practically impossible for there to never be an av=
ailable
> >> slot.  IIUC, retiring an instruction does NOT require an available slo=
t, rather
> >> it requires the opposite: an occupied slot for the uop(s).
> > I'm not quite sure about this. IIUC, retiring an instruction may not ne=
ed a
> > cycle, but it needs a slot at least except the instruction is macro-fus=
ed.
> > Anyway, let me double check with our micro-architecture and perf expert=
s.
>=20
> Hi Sean,
>=20
> Just double check with our perf experts, the understanding that "retiring
> an instruction needs a slot at least except the instruction is macro-fuse=
d"
> is correct. The reason of this error is that the architectural topdown
> slots event is just introduced from Ice lake platform and it's not
> supported on skylake and cascade lake platforms. On these earlier platfor=
ms
> the event 0x01a4 is another event which counts different thing instead of
> topdown slots. On these earlier platforms, the slots event is derived fro=
m
> 0x3c event.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/a=
rch/x86/events/intel/core.c#n466
>=20
>=20
> I don't understand why current pmu_counters_test code would validate an
> architectural event which KVM (HW) doesn't support, it's not reasonable a=
nd
> could cause misleading.
>=20
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Force iterating over k=
nown arch events regardless of whether or not
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * KVM/hardware supports =
a given event.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr_arch_events =3D max_t(typeo=
f(nr_arch_events), nr_arch_events,
> NR_INTEL_ARCH_EVENTS);

/facepalm

That's hilariously obvious in hindsight.

> I would provide a patch to fix this.

Testing "unsupproted" arch events is intentional.  The idea is to validate =
that
KVM programs the requested event selector irrespective of whether or not th=
e
architectural event is *enumerated* to the guest (old KVM incorrectly "filt=
ered"
such events).

The flaw in the test is that it doesn't check if the architectural event is
supported in *hardware* when validating the count.  But it's still desirabl=
e to
program the event selector in that case, i.e. only the validation of the co=
unt
should be skipped.  Diff at the bottom to address this (needs to be spread
over multiple patches).

> BTW, currently KVM doesn't check if user space sets a valid pmu version i=
n
> kvm_check_cpuid(). The user space could set KVM a PMU version which is
> larger than KVM supported maximum PMU version, just like currently
> pmu_counters_test does. This is not correct.

It's "correct" in the sense that KVM typically doesn't restrict what usersp=
ace
enumerates to the guest through CPUID.  KVM needs to protect the host again=
st
doing bad things based on a funky guest CPUID, e.g. KVM needs t

> I originally intent to fix this with the mediated vPMU patch series, but =
It
> looks we can send the patches just with this fix together, then the issue=
 can
> be fixed earlier.

I suspect that if there's a flaw in KVM, it only affects the mediated PMU. =
 Because
perf manages MSRs/hardware with the current PMU, advertising a bogus PMU ve=
rsion
to the guest is "fine" because even if KVM thinks it's legal for the *guest=
* to
write MSRs that don't exist in hardware, KVM/perf will never try to propaga=
te the
guest values to non-existent hardware.

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/te=
sting/selftests/kvm/x86/pmu_counters_test.c
index accd7ecd3e5f..124051ea50be 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -29,10 +29,60 @@
 /* Total number of instructions retired within the measured section. */
 #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INS=
NS)
=20
+/* Track which architectural events are supported by hardware. */
+static uint32_t hardware_pmu_arch_events;
=20
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
=20
+
+#define X86_PMU_FEATURE_NULL						\
+({									\
+	struct kvm_x86_pmu_feature feature =3D {};			\
+									\
+	feature;							\
+})
+
+static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
+{
+	return !(*(u64 *)&event);
+}
+
+struct kvm_intel_pmu_event {
+	struct kvm_x86_pmu_feature gp_event;
+	struct kvm_x86_pmu_feature fixed_event;
+};
+
+/*
+ * Wrap the array to appease the compiler, as the macros used to construct=
 each
+ * kvm_x86_pmu_feature use syntax that's only valid in function scope, and=
 the
+ * compiler often thinks the feature definitions aren't compile-time const=
ants.
+ */
+static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
+{
+	const struct kvm_intel_pmu_event __intel_event_to_feature[] =3D {
+		[INTEL_ARCH_CPU_CYCLES_INDEX]		 =3D { X86_PMU_FEATURE_CPU_CYCLES, X86_PM=
U_FEATURE_CPU_CYCLES_FIXED },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 =3D { X86_PMU_FEATURE_INSNS_RET=
IRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
+		/*
+		* Note, the fixed counter for reference cycles is NOT the same as the
+		* general purpose architectural event.  The fixed counter explicitly
+		* counts at the same frequency as the TSC, whereas the GP event counts
+		* at a fixed, but uarch specific, frequency.  Bundle them here for
+		* simplicity.
+		*/
+		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 =3D { X86_PMU_FEATURE_REFERENCE_CYC=
LES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
+		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 =3D { X86_PMU_FEATURE_LLC_REFERENCES,=
 X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LLC_MISSES_INDEX]		 =3D { X86_PMU_FEATURE_LLC_MISSES, X86_PM=
U_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 =3D { X86_PMU_FEATURE_BRANCH_INSNS_=
RETIRED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] =3D { X86_PMU_FEATURE_BRANCHES_=
MISPREDICTED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 =3D { X86_PMU_FEATURE_TOPDOWN_SLOTS, X=
86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
+	};
+
+	kvm_static_assert(ARRAY_SIZE(__intel_event_to_feature) =3D=3D NR_INTEL_AR=
CH_EVENTS);
+
+	return __intel_event_to_feature[idx];
+}
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code,
 						  uint8_t pmu_version,
@@ -42,6 +92,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct =
kvm_vcpu **vcpu,
=20
 	vm =3D vm_create_with_one_vcpu(vcpu, guest_code);
 	sync_global_to_guest(vm, kvm_pmu_version);
+	sync_global_to_guest(vm, hardware_pmu_arch_events);
=20
 	/*
 	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
@@ -98,14 +149,12 @@ static uint8_t guest_get_pmu_version(void)
  * Sanity check that in all cases, the event doesn't count when it's disab=
led,
  * and that KVM correctly emulates the write of an arbitrary value.
  */
-static void guest_assert_event_count(uint8_t idx,
-				     struct kvm_x86_pmu_feature event,
-				     uint32_t pmc, uint32_t pmc_msr)
+static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t p=
mc_msr)
 {
 	uint64_t count;
=20
 	count =3D _rdpmc(pmc);
-	if (!this_pmu_has(event))
+	if (!(hardware_pmu_arch_events & BIT(idx)))
 		goto sanity_checks;
=20
 	switch (idx) {
@@ -126,7 +175,9 @@ static void guest_assert_event_count(uint8_t idx,
 		GUEST_ASSERT_NE(count, 0);
 		break;
 	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
-		GUEST_ASSERT(count >=3D NUM_INSNS_RETIRED);
+		__GUEST_ASSERT(count < NUM_INSNS_RETIRED,
+			       "Expected top-down slots >=3D %u, got count =3D %lu",
+			       NUM_INSNS_RETIRED, count);
 		break;
 	default:
 		break;
@@ -173,7 +224,7 @@ do {										\
 	);									\
 } while (0)
=20
-#define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, =
FEP)	\
+#define GUEST_TEST_EVENT(_idx, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)		\
 do {										\
 	wrmsr(_pmc_msr, 0);							\
 										\
@@ -184,54 +235,20 @@ do {										\
 	else									\
 		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
 										\
-	guest_assert_event_count(_idx, _event, _pmc, _pmc_msr);			\
+	guest_assert_event_count(_idx, _pmc, _pmc_msr);				\
 } while (0)
=20
-static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_featur=
e event,
-				    uint32_t pmc, uint32_t pmc_msr,
+static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pm=
c_msr,
 				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
 {
-	GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
+	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
=20
 	if (is_forced_emulation_enabled)
-		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM=
_FEP);
-}
-
-#define X86_PMU_FEATURE_NULL						\
-({									\
-	struct kvm_x86_pmu_feature feature =3D {};			\
-									\
-	feature;							\
-})
-
-static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
-{
-	return !(*(u64 *)&event);
+		GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
 }
=20
 static void guest_test_arch_event(uint8_t idx)
 {
-	const struct {
-		struct kvm_x86_pmu_feature gp_event;
-		struct kvm_x86_pmu_feature fixed_event;
-	} intel_event_to_feature[] =3D {
-		[INTEL_ARCH_CPU_CYCLES_INDEX]		 =3D { X86_PMU_FEATURE_CPU_CYCLES, X86_PM=
U_FEATURE_CPU_CYCLES_FIXED },
-		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 =3D { X86_PMU_FEATURE_INSNS_RET=
IRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
-		/*
-		 * Note, the fixed counter for reference cycles is NOT the same
-		 * as the general purpose architectural event.  The fixed counter
-		 * explicitly counts at the same frequency as the TSC, whereas
-		 * the GP event counts at a fixed, but uarch specific, frequency.
-		 * Bundle them here for simplicity.
-		 */
-		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 =3D { X86_PMU_FEATURE_REFERENCE_CYC=
LES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
-		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 =3D { X86_PMU_FEATURE_LLC_REFERENCES,=
 X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_LLC_MISSES_INDEX]		 =3D { X86_PMU_FEATURE_LLC_MISSES, X86_PM=
U_FEATURE_NULL },
-		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 =3D { X86_PMU_FEATURE_BRANCH_INSNS_=
RETIRED, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] =3D { X86_PMU_FEATURE_BRANCHES_=
MISPREDICTED, X86_PMU_FEATURE_NULL },
-		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 =3D { X86_PMU_FEATURE_TOPDOWN_SLOTS, X=
86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
-	};
-
 	uint32_t nr_gp_counters =3D this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUN=
TERS);
 	uint32_t pmu_version =3D guest_get_pmu_version();
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
@@ -249,7 +266,7 @@ static void guest_test_arch_event(uint8_t idx)
 	else
 		base_pmc_msr =3D MSR_IA32_PERFCTR0;
=20
-	gp_event =3D intel_event_to_feature[idx].gp_event;
+	gp_event =3D intel_event_to_feature(idx).gp_event;
 	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
=20
 	GUEST_ASSERT(nr_gp_counters);
@@ -263,14 +280,14 @@ static void guest_test_arch_event(uint8_t idx)
 		if (guest_has_perf_global_ctrl)
 			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
=20
-		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
+		__guest_test_arch_event(idx, i, base_pmc_msr + i,
 					MSR_P6_EVNTSEL0 + i, eventsel);
 	}
=20
 	if (!guest_has_perf_global_ctrl)
 		return;
=20
-	fixed_event =3D intel_event_to_feature[idx].fixed_event;
+	fixed_event =3D intel_event_to_feature(idx).fixed_event;
 	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
 		return;
=20
@@ -278,7 +295,7 @@ static void guest_test_arch_event(uint8_t idx)
=20
 	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
=20
-	__guest_test_arch_event(idx, fixed_event, i | INTEL_RDPMC_FIXED,
+	__guest_test_arch_event(idx, i | INTEL_RDPMC_FIXED,
 				MSR_CORE_PERF_FIXED_CTR0 + i,
 				MSR_CORE_PERF_GLOBAL_CTRL,
 				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
@@ -546,7 +563,6 @@ static void test_fixed_counters(uint8_t pmu_version, ui=
nt64_t perf_capabilities,
=20
 static void test_intel_counters(void)
 {
-	uint8_t nr_arch_events =3D kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECT=
OR_LENGTH);
 	uint8_t nr_fixed_counters =3D kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_=
COUNTERS);
 	uint8_t nr_gp_counters =3D kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTE=
RS);
 	uint8_t pmu_version =3D kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
@@ -568,18 +584,26 @@ static void test_intel_counters(void)
=20
 	/*
 	 * Detect the existence of events that aren't supported by selftests.
-	 * This will (obviously) fail any time the kernel adds support for a
-	 * new event, but it's worth paying that price to keep the test fresh.
+	 * This will (obviously) fail any time hardware adds support for a new
+	 * event, but it's worth paying that price to keep the test fresh.
 	 */
-	TEST_ASSERT(nr_arch_events <=3D NR_INTEL_ARCH_EVENTS,
+	TEST_ASSERT(this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH) <=
=3D NR_INTEL_ARCH_EVENTS,
 		    "New architectural event(s) detected; please update this test (lengt=
h =3D %u, mask =3D %x)",
-		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
+		    this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH),
+		    this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
=20
 	/*
-	 * Force iterating over known arch events regardless of whether or not
-	 * KVM/hardware supports a given event.
+	 * Iterate over known arch events irrespective of KVM/hardware support
+	 * to verify that KVM doesn't reject programming of events just because
+	 * the *architectural* encoding is unsupported.  Track which events are
+	 * supported in hardware; the guest side will validate supported events
+	 * count correctly, even if *enumeration* of the event is unsupported
+	 * by KVM and/or isn't exposed to the guest.
 	 */
-	nr_arch_events =3D max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL=
_ARCH_EVENTS);
+	for (i =3D 0; i < NR_INTEL_ARCH_EVENTS; i++) {
+		if (this_pmu_has(intel_event_to_feature(i).gp_event))
+			hardware_pmu_arch_events |=3D BIT(i);
+	}
=20
 	for (v =3D 0; v <=3D max_pmu_version; v++) {
 		for (i =3D 0; i < ARRAY_SIZE(perf_caps); i++) {
@@ -595,8 +619,8 @@ static void test_intel_counters(void)
 			 * vector length.
 			 */
 			if (v =3D=3D pmu_version) {
-				for (k =3D 1; k < (BIT(nr_arch_events) - 1); k++)
-					test_arch_events(v, perf_caps[i], nr_arch_events, k);
+				for (k =3D 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
+					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
 			}
 			/*
 			 * Test single bits for all PMU version and lengths up
@@ -605,11 +629,11 @@ static void test_intel_counters(void)
 			 * host length).  Explicitly test a mask of '0' and all
 			 * ones i.e. all events being available and unavailable.
 			 */
-			for (j =3D 0; j <=3D nr_arch_events + 1; j++) {
+			for (j =3D 0; j <=3D NR_INTEL_ARCH_EVENTS + 1; j++) {
 				test_arch_events(v, perf_caps[i], j, 0);
 				test_arch_events(v, perf_caps[i], j, 0xff);
=20
-				for (k =3D 0; k < nr_arch_events; k++)
+				for (k =3D 0; k < NR_INTEL_ARCH_EVENTS; k++)
 					test_arch_events(v, perf_caps[i], j, BIT(k));
 			}


