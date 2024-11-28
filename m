Return-Path: <kvm+bounces-32646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B799DB087
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABDDD16140F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1F9150980;
	Thu, 28 Nov 2024 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XkQuy0kh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454314AD1A
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755374; cv=none; b=bzLaeoP3YMo9mxAYsRq9qj6/o1tkeBb6VfsUoV3AM/u84TbrfL5uzgwtDArSoPyuJkdNqctXFSpEYnyLVgSVJPvPgOPfc48r5OUjUv2ZgZaiCdzP2KppRYk57wMWJmivD5P/xgUyufwQueo43GYYJYHxuNa97EOKpyS+7ZdXjVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755374; c=relaxed/simple;
	bh=rMTdRj3Vw0d1aNonE+Ipfnwdfwj/c9K2WwLz124uQAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/Mq4BhkxfQoDJNGs+txYFEf5tUvKriH2tPtYAbQutQk5wLQxUrS7gJGC+7Mky5V4pBQjEEC/pScwG8i6l9Dodks21MSBOJzEhhu5LxVzUR25N4FMx4GmhWl6k9xjXDYYvtriEccPltkixGYnu29GkJppgNy6jhdmI4eaaErvCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XkQuy0kh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea69eeb659so203646a12.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755372; x=1733360172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XPdOPo1b4SKFKQSHegYD/Ajgnk0S0WQ/8A/Yy7v0mTM=;
        b=XkQuy0khpnuzbbo2LepyX0Ydksg4N8iRRMKaf1wELlb3TPMwZJXxRLsvdAYo2H1WeV
         PHFS0UgIlS1GDTSvmK7L6D9LYE1pqrWyM3qtyNSy0T5Do1UA1ugrLmX+Ux4AATMLHHT/
         n02IeLgScjYlT+X44VajbvlzynV/luUFHtqIhgbB7AoyaQt+lRrC6HIB8EFS2RY6LJ8W
         zjcPVX1hfrJbD/6xdKB2NFfDy3+R0eZrtYcqaaTjPxrkgSwevBc8rvnzvSeu4FFaYZvO
         9DmPYuieEwbnpCfcbJO8DfE++QSwRhSzpulhDHKxOkMT+bdxZKsTWdE2S/slQLhsHgoY
         Plgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755372; x=1733360172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XPdOPo1b4SKFKQSHegYD/Ajgnk0S0WQ/8A/Yy7v0mTM=;
        b=Zg68KzUdNDmHy7bOMzmam2aX6CzVD/uOdokET5DozHSUDaDlvi37molleEjFWgRQ1A
         8HzkkPeY6FakChGLUS9xe3mBRXpgV2T2Y46cJvjHVQeQD4jD/iBLc9TPyPfFJwajkt8X
         93QxDGADBv7samJmAmSecI12mDZIxRQLvtLcTzCnwDEADKmow6wdzCBS2zl05Q5oGdTd
         W/eRiUuvkdBt0/dJaIn5dzTxC69Uwsk85gYWKW1ZYLQbGvBWDl2yceuER2m24oEYcCFd
         chQMHCXJ//x8mRBuX/poTOxt5pWjZp1qmk/BW15DlsN4Yugmmz9zhzzbP70f5fzb6Gv2
         CSLA==
X-Forwarded-Encrypted: i=1; AJvYcCV36Loog13Y5py/wuCnwAeqakxMke2YP82IPpLxQMZO14rXpfMDQ37OfvXndgM+T/iXrEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPG/14/n+pUugvtY25ABk9HqBCNVFNzfIkcXMSJ1Ld/seqt7jX
	P7NWkUjRfgY903KQJ3R7VKeEkekCCeh5ZmPZs0UTxYKA1aRCm5R6JMUWttYOzl0Acg6cvzNfkLr
	FUQ==
X-Google-Smtp-Source: AGHT+IF9c9BZlswGZi0etgSQ5KCNJj2OyH3UwmpvQEnlX/diiMpr3XRQbr6nF80wsA0CHS1H0/HXdIsKW9o=
X-Received: from pfbcj22.prod.google.com ([2002:a05:6a00:2996:b0:724:f614:656f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a1:b0:1db:ddba:8795
 with SMTP id adf61e73a8af0-1e0e0b7d919mr7994888637.36.1732755372410; Wed, 27
 Nov 2024 16:56:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:44 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-14-seanjc@google.com>
Subject: [PATCH v4 13/16] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Add two phases to mmu_stress_test to verify that KVM correctly handles
guest memory that was writable, and then made read-only in the primary MMU,
and then made writable again.

Add bonus coverage for x86 and arm64 to verify that all of guest memory was
marked read-only.  Making forward progress (without making memory writable)
requires arch specific code to skip over the faulting instruction, but the
test can at least verify each vCPU's starting page was made read-only for
other architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 104 +++++++++++++++++-
 1 file changed, 101 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 0918fade9267..d9c76b4c0d88 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -17,6 +17,8 @@
 #include "processor.h"
 #include "ucall_common.h"
 
+static bool mprotect_ro_done;
+
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
 	uint64_t gpa;
@@ -32,6 +34,42 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 		*((volatile uint64_t *)gpa);
 	GUEST_SYNC(2);
 
+	/*
+	 * Write to the region while mprotect(PROT_READ) is underway.  Keep
+	 * looping until the memory is guaranteed to be read-only, otherwise
+	 * vCPUs may complete their writes and advance to the next stage
+	 * prematurely.
+	 *
+	 * For architectures that support skipping the faulting instruction,
+	 * generate the store via inline assembly to ensure the exact length
+	 * of the instruction is known and stable (vcpu_arch_put_guest() on
+	 * fixed-length architectures should work, but the cost of paranoia
+	 * is low in this case).  For x86, hand-code the exact opcode so that
+	 * there is no room for variability in the generated instruction.
+	 */
+	do {
+		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+#ifdef __x86_64__
+			asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
+#elif defined(__aarch64__)
+			asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
+#else
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+#endif
+	} while (!READ_ONCE(mprotect_ro_done));
+
+	/*
+	 * Only architectures that write the entire range can explicitly sync,
+	 * as other architectures will be stuck on the write fault.
+	 */
+#if defined(__x86_64__) || defined(__aarch64__)
+	GUEST_SYNC(3);
+#endif
+
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+	GUEST_SYNC(4);
+
 	GUEST_ASSERT(0);
 }
 
@@ -79,6 +117,7 @@ static void *vcpu_worker(void *data)
 	struct vcpu_info *info = data;
 	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
+	int r;
 
 	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
 
@@ -101,6 +140,57 @@ static void *vcpu_worker(void *data)
 
 	/* Stage 2, read all of guest memory, which is now read-only. */
 	run_vcpu(vcpu, 2);
+
+	/*
+	 * Stage 3, write guest memory and verify KVM returns -EFAULT for once
+	 * the mprotect(PROT_READ) lands.  Only architectures that support
+	 * validating *all* of guest memory sync for this stage, as vCPUs will
+	 * be stuck on the faulting instruction for other architectures.  Go to
+	 * stage 3 without a rendezvous
+	 */
+	do {
+		r = _vcpu_run(vcpu);
+	} while (!r);
+	TEST_ASSERT(r == -1 && errno == EFAULT,
+		    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
+
+#if defined(__x86_64__) || defined(__aarch64__)
+	/*
+	 * Verify *all* writes from the guest hit EFAULT due to the VMA now
+	 * being read-only.  x86 and arm64 only at this time as skipping the
+	 * instruction that hits the EFAULT requires advancing the program
+	 * counter, which is arch specific and relies on inline assembly.
+	 */
+#ifdef __x86_64__
+	vcpu->run->kvm_valid_regs = KVM_SYNC_X86_REGS;
+#endif
+	for (;;) {
+		r = _vcpu_run(vcpu);
+		if (!r)
+			break;
+		TEST_ASSERT_EQ(errno, EFAULT);
+#if defined(__x86_64__)
+		WRITE_ONCE(vcpu->run->kvm_dirty_regs, KVM_SYNC_X86_REGS);
+		vcpu->run->s.regs.regs.rip += 3;
+#elif defined(__aarch64__)
+		vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc),
+			     vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc)) + 4);
+#endif
+
+	}
+	assert_sync_stage(vcpu, 3);
+#endif /* __x86_64__ || __aarch64__ */
+	rendezvous_with_boss();
+
+	/*
+	 * Stage 4.  Run to completion, waiting for mprotect(PROT_WRITE) to
+	 * make the memory writable again.
+	 */
+	do {
+		r = _vcpu_run(vcpu);
+	} while (r && errno == EFAULT);
+	TEST_ASSERT_EQ(r, 0);
+	assert_sync_stage(vcpu, 4);
 	rendezvous_with_boss();
 
 	return NULL;
@@ -183,7 +273,7 @@ int main(int argc, char *argv[])
 	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
-	struct timespec time_start, time_run1, time_reset, time_run2, time_ro;
+	struct timespec time_start, time_run1, time_reset, time_run2, time_ro, time_rw;
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
@@ -288,19 +378,27 @@ int main(int argc, char *argv[])
 	rendezvous_with_vcpus(&time_run2, "run 2");
 
 	mprotect(mem, slot_size, PROT_READ);
+	usleep(10);
+	mprotect_ro_done = true;
+	sync_global_to_guest(vm, mprotect_ro_done);
+
 	rendezvous_with_vcpus(&time_ro, "mprotect RO");
+	mprotect(mem, slot_size, PROT_READ | PROT_WRITE);
+	rendezvous_with_vcpus(&time_rw, "mprotect RW");
 
+	time_rw    = timespec_sub(time_rw,     time_ro);
 	time_ro    = timespec_sub(time_ro,     time_run2);
 	time_run2  = timespec_sub(time_run2,   time_reset);
 	time_reset = timespec_sub(time_reset,  time_run1);
 	time_run1  = timespec_sub(time_run1,   time_start);
 
 	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 = %ld.%.9lds, "
-		"ro = %ld.%.9lds\n",
+		"ro = %ld.%.9lds, rw = %ld.%.9lds\n",
 		time_run1.tv_sec, time_run1.tv_nsec,
 		time_reset.tv_sec, time_reset.tv_nsec,
 		time_run2.tv_sec, time_run2.tv_nsec,
-		time_ro.tv_sec, time_ro.tv_nsec);
+		time_ro.tv_sec, time_ro.tv_nsec,
+		time_rw.tv_sec, time_rw.tv_nsec);
 
 	/*
 	 * Delete even numbered slots (arbitrary) and unmap the first half of
-- 
2.47.0.338.g60cca15819-goog


