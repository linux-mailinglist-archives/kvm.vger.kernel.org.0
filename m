Return-Path: <kvm+bounces-8829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF01856F63
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 22:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36FD3B257AC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 21:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86C81419B1;
	Thu, 15 Feb 2024 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T57rtz5A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2930913DB92
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 21:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708032832; cv=none; b=Zht6wB8E9B1Pgmi+2QxqP8qprcQRFxkpdXraW/g6Wz7sgrN8U+n/xFCGF6EDFDucyzTDu9dRe/Jmgr905KnTQHQvUbN9j4JmXx5gI6i6isqM+UojHyEKq2PdQuBOx2yJgLw12YbK42kPOr9tzvroOKpU2KBosCPgjPoxUVKCRsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708032832; c=relaxed/simple;
	bh=2UmlXYt8o/1rjCum/92wgAjcMp4ZHvYMHwH5IxaA3YM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OWc5PIkgewWpHkXjimTyQLPRiXPwv6i2wFx2W9vudvqXfvT3zdT2wUSAzyE9yFJt/A2It0364lNJSB5a8vN9kIe/hVk5tA3xfsk8f5LNSL3mMPJipf4krAOiFVklVgRDIEOUqp87Nj/4EEP4mDKULlJbhtd5STN5uxURP+yJhwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T57rtz5A; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so1807913276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 13:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708032830; x=1708637630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AocB5QyyDp1HbztmHNs2CC7MOtPEN+TNVBfTVeVV9Fg=;
        b=T57rtz5Akx1nshIzLI52Q71vlrczBF/l5Xd4g78L4K7ln1RuTzDOTXSdazGWR0sHKP
         Yi/Io+ct/4M9U0uhobA+k1GafxIVEh6w5DIHLhilFeJoRbR9n0h0t0kK7fvVqdf9b8xH
         ur/qfE3tVYoJhkw1JvtxXeiFPLEI+y6xEe9b6XvHYQ83qqu7myCk7nY02NAVmybXDDzE
         tG0BBBNUbtLYObB8HMOlBrlEKyEal5q2bJxQzK6w9+fmsjm1wUfAGYznlP6qcGfeTW/8
         oPkGn+KV+x8gdK9GlgQpXdbPz9FeRVMJFlQQIUGGco1XaiG18+BtvmD41pw4DAPsC/5T
         qHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708032830; x=1708637630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AocB5QyyDp1HbztmHNs2CC7MOtPEN+TNVBfTVeVV9Fg=;
        b=iKB1IgqQKG2JCIB3I4BHLlwbni8hsx3F9Yobifpt+TWofChTgcQ437f+E4wJezncxN
         c1c0x4CSiXLIxDxcVdbUyu1uZNbCmctH87AITnv9tcQXz7b393KGlOMcC/y2I5l3kiIF
         zaYvwBwwQN9Qv5XDZvuKP5Qen987aw7MdfwH/uoopt4JDwm4SnWIPfLxomjFpzHCWYM2
         cWSCvzT6sPwzmjW/oevQ/pObyeRat34lpD6zGOCOsPGNhTTLFHBKKeQH7UGYsyQIfDUM
         Bu3iWnEnEwFB8g5RCjRFXSpEBAQABK1DDYVDZLW3iwyxsuYGhEiCPl+UGs+Ihc0a5S4U
         p+sA==
X-Forwarded-Encrypted: i=1; AJvYcCXiPvlMPUxmQFMeUIelE8mTgiXcdavquDqPe8SQ3HQsC7jct5K3Nfg1mkmmPKcyBW9Em/onFXveD+zVymybrf/fAsj1
X-Gm-Message-State: AOJu0YwZbhSCwTHrm9oOao951T0FOUExMJPq1n3+eAK0OhjQF2/Y+2hM
	aaa5PmOysKB46i296Sxx4zkBNzlaS3UkHRyHJE7YyoCPMKljHDHRdHXj6GMogPt0fTZg4X+1y9f
	JDQ==
X-Google-Smtp-Source: AGHT+IF5FQ3Ln0cnMaR3KbqRLrXioQ8PHYOdNvCYEMOGquKMF+QgPtB6WHvIfmmR1OQXYFMltmywBuxG+E0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1241:b0:dc6:e647:3fae with SMTP id
 t1-20020a056902124100b00dc6e6473faemr122134ybu.2.1708032830246; Thu, 15 Feb
 2024 13:33:50 -0800 (PST)
Date: Thu, 15 Feb 2024 13:33:48 -0800
In-Reply-To: <Zc5wTHuphbg3peZ9@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev> <Zc5c7Af-N71_RYq0@google.com> <Zc5wTHuphbg3peZ9@linux.dev>
Message-ID: <Zc6DPEWcHh-TKCSD@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Oliver Upton wrote:
> On Thu, Feb 15, 2024 at 10:50:20AM -0800, Sean Christopherson wrote:
> > Yeah, the funky flow I concocted was done purely to have the "no emulation" path
> > fall through to the common "*mem = val".  I don't have a strong preference, I
> > mentally flipped a coin on doing that versus what you suggested, and apparently
> > chose poorly :-)
> 
> Oh, I could definitely tell this was intentional :) But really if folks
> are going to add more flavors of emulated instructions to the x86
> implementation (which they should) then it might make sense to just have
> an x86-specific function.

Yeah, best prepare for the onslaught.  And if I base this on the SEV selftests
series that adds kvm_util_arch.h, it's easy to shove the x86 sequence into a
common location outside of dirty_log_test.c.  Then there are no #ifdefs or x86
code in dirty_log_test.c, and other tests can use the helper at will.

It'll require some macro hell to support all four sizes, but that's not hard,
just annoying.

And it's a good excuse to do what I should have done in the first place, and
make is_forced_emulation_enabled be available to all guest code without needing
to manually check it in each test.

Over 2-3 patches...

---
 tools/testing/selftests/kvm/dirty_log_test.c  |  9 ++++++---
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 .../kvm/include/x86_64/kvm_util_arch.h        | 20 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  3 +++
 .../selftests/kvm/x86_64/pmu_counters_test.c  |  3 ---
 .../kvm/x86_64/userspace_msr_exit_test.c      |  9 ++-------
 6 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index babea97b31a4..93c3a51a6d9b 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -114,11 +114,14 @@ static void guest_code(void)
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
+			uint64_t rand = READ_ONCE(random_array[i]);
+			uint64_t val = READ_ONCE(iteration);
+
 			addr = guest_test_virt_mem;
-			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
-				* guest_page_size;
+			addr += (rand % guest_num_pages) * guest_page_size;
 			addr = align_down(addr, host_page_size);
-			*(uint64_t *)addr = READ_ONCE(iteration);
+
+			vcpu_arch_put_guest((u64 *)addr, val, rand);
 		}
 
 		/* Tell the host that we need more random numbers */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4b266dc0c9bd..4b7285f073df 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -610,6 +610,9 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+#ifndef vcpu_arch_put_guest
+#define vcpu_arch_put_guest(mem, val, rand) do { *mem = val; } while (0)
+#endif
 
 static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
 {
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 205ed788aeb8..3f9a44fd4bcb 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -5,6 +5,8 @@
 #include <stdbool.h>
 #include <stdint.h>
 
+extern bool is_forced_emulation_enabled;
+
 struct kvm_vm_arch {
 	uint64_t c_bit;
 	uint64_t s_bit;
@@ -20,4 +22,22 @@ static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 #define vm_arch_has_protected_memory(vm) \
 	__vm_arch_has_protected_memory(&(vm)->arch)
 
+/* TODO: Expand this madness to also support u8, u16, and u32 operands. */
+#define vcpu_arch_put_guest(mem, val, rand) 						\
+do {											\
+	if (!is_forced_emulation_enabled || !(rand & 1)) {				\
+		*mem = val;								\
+	} else if (rand & 2) {								\
+		__asm__ __volatile__(KVM_FEP "movq %1, %0"				\
+				     : "+m" (*mem)					\
+				     : "r" (val) : "memory");				\
+	} else {									\
+		uint64_t __old = READ_ONCE(*mem);					\
+											\
+		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"	\
+				     : [ptr] "+m" (*mem), [old] "+a" (__old)		\
+				     : [new]"r" (val) : "memory", "cc");		\
+	}										\
+} while (0)
+
 #endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index aa92220bf5da..d0a97d5e1ff9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -23,6 +23,7 @@
 vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
+bool is_forced_emulation_enabled;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -577,6 +578,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	vm_create_irqchip(vm);
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
+	sync_global_to_guest(vm, is_forced_emulation_enabled);
 
 	if (vm->subtype == VM_SUBTYPE_SEV)
 		sev_vm_init(vm);
@@ -1337,6 +1339,7 @@ void kvm_selftest_arch_init(void)
 {
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
+	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 }
 
 bool sys_clocksource_is_based_on_tsc(void)
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index ae5f6042f1e8..6b2c1fd551b5 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -21,7 +21,6 @@
 
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
-static bool is_forced_emulation_enabled;
 
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code,
@@ -35,7 +34,6 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	vcpu_init_descriptor_tables(*vcpu);
 
 	sync_global_to_guest(vm, kvm_pmu_version);
-	sync_global_to_guest(vm, is_forced_emulation_enabled);
 
 	/*
 	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
@@ -609,7 +607,6 @@ int main(int argc, char *argv[])
 
 	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
-	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 
 	test_intel_counters();
 
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index ab3a8c4f0b86..a409b796bb18 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -12,8 +12,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-static bool fep_available;
-
 #define MSR_NON_EXISTENT 0x474f4f00
 
 static u64 deny_bits = 0;
@@ -257,7 +255,7 @@ static void guest_code_filter_allow(void)
 	GUEST_ASSERT(data == 2);
 	GUEST_ASSERT(guest_exception_count == 0);
 
-	if (fep_available) {
+	if (is_forced_emulation_enabled) {
 		/* Let userspace know we aren't done. */
 		GUEST_SYNC(0);
 
@@ -519,7 +517,6 @@ static void test_msr_filter_allow(void)
 	int rc;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_filter_allow);
-	sync_global_to_guest(vm, fep_available);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -550,7 +547,7 @@ static void test_msr_filter_allow(void)
 	vcpu_run(vcpu);
 	cmd = process_ucall(vcpu);
 
-	if (fep_available) {
+	if (is_forced_emulation_enabled) {
 		TEST_ASSERT_EQ(cmd, UCALL_SYNC);
 		vm_install_exception_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
@@ -791,8 +788,6 @@ static void test_user_exit_msr_flags(void)
 
 int main(int argc, char *argv[])
 {
-	fep_available = kvm_is_forced_emulation_enabled();
-
 	test_msr_filter_allow();
 
 	test_msr_filter_deny();

base-commit: e072aa6dbd1db64323a407b3eca82dc5107ea0b1
-- 


