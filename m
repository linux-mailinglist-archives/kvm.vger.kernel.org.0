Return-Path: <kvm+bounces-24938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F197E95D5E9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 222EA1C21A2E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65BC192B9E;
	Fri, 23 Aug 2024 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v2DHM7qP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601D0192599
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724440442; cv=none; b=DocPHqMnvxlD9a8Vy0iHbRNULKC542iUStAZfa5M/4B4+pMbKbAm7RA/DQ20sd/hzZUvc00x2eEY67fTpEvh5FWZuV2k7JcUnFRmzVm59hxUo5YBwpfaopFlVpiPCsoPZUYcJJsjX64OumDsZ0AK7U7Pf49CWQsm2YdPFryXrJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724440442; c=relaxed/simple;
	bh=LWFgMfMtUKNoSEtryDPcR2C4Osq55AdH9xV/evyDVnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHFZs6GMN3RbvbdPGu+5hKrjtKgatiCv1S7WhIJFb7iVCEutsp8o8qzckqOhhjooIGGqtMqHJ32kqqGl+oJ6j1TPBxU+UvBYAB5gdK78NDzgnZyJwFkSQFHDaFnmHUy9tnWFg4H1yc/7o5FPaomS2G7fYZSj/fWTZqEMhZ266QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v2DHM7qP; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1173581259so3983806276.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 12:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724440439; x=1725045239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4pEnT8HlI8Z9QJG94KNxEjTXVNIfHF2AsWW8pgongo4=;
        b=v2DHM7qPK3H1UJ/Ug6ZKYgDXya+53vhFKJw8xkTZCn4uc1H+2dEde9xgok2CjuR4LF
         jjxEdrujzcVTzI3RnkAbe0vMumdAfSrEcX1p4mSzpBAN28DLqA8uDVYLi1X1XUzSH4Pg
         azdeke5G64VmIRTTO/01n1M2ztqOqMrU0gm2HZfLWwY8Y36Cmf5jgprMc6YBuUO/InlW
         cJY2SgXvg8Ug6PtojPoo6SxMhZEjWNuiKG8hAGBBHiEZMCRnk6fXk4a7QN970NUBLSit
         hRqDudeGEpSxysx5XVFYJPaQ3LblgWPeGARpY3wDgjkDoAy2aaVSdhpRvSGVHPmDN4xe
         Ck2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724440439; x=1725045239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4pEnT8HlI8Z9QJG94KNxEjTXVNIfHF2AsWW8pgongo4=;
        b=GlSvTzlSerS/Kir3HMX1It3MFm+2cZGT3+Kd547OLQo4YiqMfiPpRo/75HqwBm+hCm
         YqeSiFFD/WDwCzGXKqTIYXX1FnSaZFGOnxcBHn+vuYvnWBUBm/NVwgurStU+opZw9EJo
         saZ+Zjuk6sV+JHunkMjP/hMhXItfap9d6uSA6CDrN5nTjUYODP2MP99HIbVkgZvLyZ4/
         /9tJHBiWkJsOuKqkC6BVsCFI2QuXB7cgKns3NUMmynH/ikHk5BlW8gvRXg6D4F6+Gn9v
         cUsfglytk6jKi+jiWrwA6W1QYuWoMGMllNGDQWwuH7DHFKzXJS4IhiKsHMv7PtXvNStq
         E8mA==
X-Gm-Message-State: AOJu0Ywd9ECkJWkS48i9Jee6VxPDiyjyEiR/1CXDXjhPTqAsdheCkkn7
	cqnpHraHw42kDAG0FR7K/YqsHShUpvEXTcCsSgEKwbhnoUZifD7Js1+X1T4BoYZH1YKUH9C+iqz
	jcw==
X-Google-Smtp-Source: AGHT+IEk9QCy5Y5Mnpbm2X9PQ+imdevlYLu5zngzH6DjaxPswunvNxKIKGc9fuHKgIgt0FuA3jLp2bA5GD8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bc01:0:b0:e16:68fb:f261 with SMTP id
 3f1490d57ef6-e17a83c9c81mr4995276.5.1724440439417; Fri, 23 Aug 2024 12:13:59
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Aug 2024 12:13:53 -0700
In-Reply-To: <20240823191354.4141950-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823191354.4141950-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823191354.4141950-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilias Stamatis <ilstam@amazon.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Add a test to verify that KVM correctly exits (or not) when a vCPU's
coalesced I/O ring is full (or isn't).  Iterate over all legal starting
points in the ring (with an empty ring), and verify that KVM doesn't exit
until the ring is full.

Opportunistically verify that KVM exits immediately on non-coalesced I/O,
either because the MMIO/PIO region was never registered, or because a
previous region was unregistered.

This is a regression test for a KVM bug where KVM would prematurely exit
due to bad math resulting in a false positive if the first entry in the
ring was before the halfway mark.  See commit 92f6d4130497 ("KVM: Fix
coalesced_mmio_has_room() to avoid premature userspace exit").

Enable the test for x86, arm64, and risc-v, i.e. all architectures except
s390, which doesn't have MMIO.

On x86, which has both MMIO and PIO, interleave MMIO and PIO into the same
ring, as KVM shouldn't exit until a non-coalesced I/O is encountered,
regardless of whether the ring is filled with MMIO, PIO, or both.

Cc: Ilias Stamatis <ilstam@amazon.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/coalesced_io_test.c | 202 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  26 +++
 3 files changed, 231 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/coalesced_io_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..45cb70c048bb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -130,6 +130,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
+TEST_GEN_PROGS_x86_64 += coalesced_io_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
@@ -165,6 +166,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
 TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += arch_timer
+TEST_GEN_PROGS_aarch64 += coalesced_io_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
@@ -198,6 +200,7 @@ TEST_GEN_PROGS_s390x += kvm_binary_stats_test
 TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
 TEST_GEN_PROGS_riscv += riscv/ebreak_test
 TEST_GEN_PROGS_riscv += arch_timer
+TEST_GEN_PROGS_riscv += coalesced_io_test
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
 TEST_GEN_PROGS_riscv += get-reg-list
diff --git a/tools/testing/selftests/kvm/coalesced_io_test.c b/tools/testing/selftests/kvm/coalesced_io_test.c
new file mode 100644
index 000000000000..3d591af63ef0
--- /dev/null
+++ b/tools/testing/selftests/kvm/coalesced_io_test.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include <linux/sizes.h>
+
+#include <kvm_util.h>
+#include <processor.h>
+
+#include "ucall_common.h"
+
+#define MMIO_GPA (4ull * SZ_1G)
+#define PIO_PORT 0x80
+
+/*
+ * KVM's ABI uses the kernel's PAGE_SIZE, thus userspace must query the host's
+ * page size at runtime to compute the real max.
+ */
+static int REAL_KVM_COALESCED_MMIO_MAX;
+static int coalesced_mmio_ring_offset;
+
+#ifdef __x86_64__
+static const int has_pio = 1;
+#else
+static const int has_pio = 0;
+#endif
+
+static void guest_code(void)
+{
+	int i, j;
+
+	for (;;) {
+		for (j = 0; j < 1 + has_pio; j++) {
+			/*
+			 * KVM always leaves one free entry, i.e. exits to
+			 * userspace before the last entry is filled.
+			 */
+			for (i = 0; i < REAL_KVM_COALESCED_MMIO_MAX - 1; i++) {
+#ifdef __x86_64__
+				if (i & 1)
+					outl(PIO_PORT, i);
+				else
+#endif
+					WRITE_ONCE(*((uint64_t *)MMIO_GPA), i);
+			}
+#ifdef __x86_64__
+			if (j & 1)
+				outl(PIO_PORT, i);
+			else
+#endif
+				WRITE_ONCE(*((uint64_t *)MMIO_GPA), i);
+		}
+		GUEST_SYNC(0);
+
+		WRITE_ONCE(*((uint64_t *)MMIO_GPA), i);
+#ifdef __x86_64__
+		outl(PIO_PORT, i);
+#endif
+	}
+}
+
+static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
+					uint32_t ring_start,
+					uint32_t expected_exit)
+{
+	const bool want_pio = expected_exit == KVM_EXIT_IO;
+	struct kvm_coalesced_mmio_ring *ring;
+	struct kvm_run *run = vcpu->run;
+
+	ring = (void *)run + coalesced_mmio_ring_offset;
+
+	WRITE_ONCE(ring->first, ring_start);
+	WRITE_ONCE(ring->last, ring_start);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT((!want_pio && (run->exit_reason == KVM_EXIT_MMIO && run->mmio.is_write &&
+				   run->mmio.phys_addr == MMIO_GPA && run->mmio.len == 8 &&
+				   *(uint64_t *)run->mmio.data == REAL_KVM_COALESCED_MMIO_MAX - 1)) ||
+		    (want_pio  && (run->exit_reason == KVM_EXIT_IO && run->io.port == PIO_PORT &&
+				   run->io.direction == KVM_EXIT_IO_OUT && run->io.count == 1 &&
+				   *(uint32_t *)((void *)run + run->io.data_offset) == REAL_KVM_COALESCED_MMIO_MAX - 1)),
+		    "For start = %u, expected exit on %u-byte %s write 0x%llx = %u, go exit_reason = %u (%s)\n  "
+		    "(MMIO addr = 0x%llx, write = %u, len = %u, data = %lu)\n  "
+		    "(PIO port = 0x%x, write = %u, len = %u, count = %u, data = %u",
+		    ring_start, want_pio ? 4 : 8, want_pio ? "PIO" : "MMIO",
+		    want_pio ? (unsigned long long)PIO_PORT : MMIO_GPA,
+		    REAL_KVM_COALESCED_MMIO_MAX - 1, run->exit_reason,
+		    run->exit_reason == KVM_EXIT_MMIO ? "MMIO" :
+		    run->exit_reason == KVM_EXIT_IO ? "PIO" : "other",
+		    run->mmio.phys_addr, run->mmio.is_write, run->mmio.len, *(uint64_t *)run->mmio.data,
+		    run->io.port, run->io.direction, run->io.size, run->io.count,
+		    *(uint32_t *)((void *)run + run->io.data_offset));
+}
+
+static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
+					     uint32_t ring_start,
+					     uint32_t expected_exit)
+{
+	struct kvm_coalesced_mmio_ring *ring;
+	struct kvm_run *run = vcpu->run;
+	int i;
+
+	vcpu_run_and_verify_io_exit(vcpu, ring_start, expected_exit);
+
+	ring = (void *)run + coalesced_mmio_ring_offset;
+	TEST_ASSERT((ring->last + 1) % REAL_KVM_COALESCED_MMIO_MAX == ring->first,
+		    "Expected ring to be full (minus 1), first = %u, last = %u, max = %u, start = %u",
+		    ring->first, ring->last, REAL_KVM_COALESCED_MMIO_MAX, ring_start);
+
+	for (i = 0; i < REAL_KVM_COALESCED_MMIO_MAX - 1; i++) {
+		uint32_t idx = (ring->first + i) % REAL_KVM_COALESCED_MMIO_MAX;
+		struct kvm_coalesced_mmio *io = &ring->coalesced_mmio[idx];
+
+#ifdef __x86_64__
+		if (i & 1)
+			TEST_ASSERT(io->phys_addr == PIO_PORT &&
+				    io->len == 4 && io->pio,
+				    "Wanted 4-byte port I/O to 0x%x in entry %u, got %u-byte %s to 0x%llx",
+				    PIO_PORT, i, io->len, io->pio ? "PIO" : "MMIO", io->phys_addr);
+		else
+#endif
+			TEST_ASSERT(io->phys_addr == MMIO_GPA &&
+				    io->len == 8 && !io->pio,
+				    "Wanted 8-byte MMIO to 0x%llx in entry %u, got %u-byte %s to 0x%llx",
+				    MMIO_GPA, i, io->len, io->pio ? "PIO" : "MMIO", io->phys_addr);
+
+		TEST_ASSERT_EQ(*(uint64_t *)io->data, i);
+	}
+}
+
+static void test_coalesced_io(struct kvm_vcpu *vcpu, uint32_t ring_start)
+{
+	struct kvm_run *run = vcpu->run;
+	struct kvm_coalesced_mmio_ring *ring;
+
+	kvm_vm_register_coalesced_io(vcpu->vm, MMIO_GPA, 8, false /* pio */);
+#ifdef __x86_64__
+	kvm_vm_register_coalesced_io(vcpu->vm, PIO_PORT, 8, true /* pio */);
+#endif
+
+	vcpu_run_and_verify_coalesced_io(vcpu, ring_start, KVM_EXIT_MMIO);
+#ifdef __x86_64__
+	vcpu_run_and_verify_coalesced_io(vcpu, ring_start, KVM_EXIT_IO);
+#endif
+
+	/*
+	 * Verify ucall, which may use non-coalesced MMIO or PIO, generates an
+	 * immediate exit.
+	 */
+	ring = (void *)run + coalesced_mmio_ring_offset;
+	WRITE_ONCE(ring->first, ring_start);
+	WRITE_ONCE(ring->last, ring_start);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	TEST_ASSERT_EQ(ring->first, ring_start);
+	TEST_ASSERT_EQ(ring->last, ring_start);
+
+	/* Verify that non-coalesced MMIO/PIO generates an exit to userspace. */
+	kvm_vm_unregister_coalesced_io(vcpu->vm, MMIO_GPA, 8, false /* pio */);
+	vcpu_run_and_verify_io_exit(vcpu, ring_start, KVM_EXIT_MMIO);
+
+#ifdef __x86_64__
+	kvm_vm_unregister_coalesced_io(vcpu->vm, PIO_PORT, 8, true /* pio */);
+	vcpu_run_and_verify_io_exit(vcpu, ring_start, KVM_EXIT_IO);
+#endif
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int i;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_COALESCED_MMIO));
+
+#ifdef __x86_64__
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_COALESCED_PIO));
+#endif
+
+	/*
+	 * The I/O ring is a kernel-allocated page whose address is relative
+	 * to each vCPU's run page, with the page offset provided by KVM in the
+	 * return of KVM_CAP_COALESCED_MMIO.
+	 */
+	coalesced_mmio_ring_offset = (kvm_check_cap(KVM_CAP_COALESCED_MMIO) * getpagesize());
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	virt_map(vm, MMIO_GPA, MMIO_GPA, 1);
+
+	REAL_KVM_COALESCED_MMIO_MAX = (getpagesize() - sizeof(struct kvm_coalesced_mmio_ring)) /
+				      sizeof(struct kvm_coalesced_mmio);
+	sync_global_to_guest(vm, REAL_KVM_COALESCED_MMIO_MAX);
+
+	for (i = 0; i < REAL_KVM_COALESCED_MMIO_MAX; i++)
+		test_coalesced_io(vcpu, i);
+
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 63c2aaae51f3..b297a84f7be5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -460,6 +460,32 @@ static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
 	return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
 }
 
+static inline void kvm_vm_register_coalesced_io(struct kvm_vm *vm,
+						uint64_t address,
+						uint64_t size, bool pio)
+{
+	struct kvm_coalesced_mmio_zone zone = {
+		.addr = address,
+		.size = size,
+		.pio  = pio,
+	};
+
+	vm_ioctl(vm, KVM_REGISTER_COALESCED_MMIO, &zone);
+}
+
+static inline void kvm_vm_unregister_coalesced_io(struct kvm_vm *vm,
+						  uint64_t address,
+						  uint64_t size, bool pio)
+{
+	struct kvm_coalesced_mmio_zone zone = {
+		.addr = address,
+		.size = size,
+		.pio  = pio,
+	};
+
+	vm_ioctl(vm, KVM_UNREGISTER_COALESCED_MMIO, &zone);
+}
+
 static inline int vm_get_stats_fd(struct kvm_vm *vm)
 {
 	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
-- 
2.46.0.295.g3b9ea8a38a-goog


