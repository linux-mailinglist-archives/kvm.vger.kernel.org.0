Return-Path: <kvm+bounces-25287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9283C962F90
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B328D1C23ACC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413A01AB51D;
	Wed, 28 Aug 2024 18:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkTOlmYv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83FB1AAE04
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868895; cv=none; b=asQsPMyqtszIjJRKu1aN2jR+hgcngBnKgIUpTgsJjyaEMCcYW68YrtJouRcjbfEuChuxitc+BuqeZh1PomiNxj4nK2wICwU1QZN7c8vDKJI9CG6vljwW9ZUZBL+6owkAymNs+ABCQTivKBSHVS/nIimvYEuw3ZzXNb/QpQJdB7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868895; c=relaxed/simple;
	bh=+2sU+Nm0NW2ugeCvNAwxZGaHnaVSH40XZpgoAy4l9h0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LVrnrBU0dcCiBeU78eSzwttXyQ/S3kFMpwbWJ5AApTlMt0ROyRQYM0MPROxYk9E7VbXan1OJWmFXZZjuTnsf4jB/0xuEFZfDohWzDLrgwUrsqxrX7Pdhg+aSK9ALLlxp937drXi3eOJH6G/YvsXLQs2rN+Jg4QESSme2n1GSDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkTOlmYv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b8f13f2965so149373657b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 11:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724868892; x=1725473692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fxFhdgcdFzSWR4m+hBF4loBsPrOw6jIDc6iaiMd0FSE=;
        b=mkTOlmYvLIkmJfvpp1tWf0yi87Js+vLyFxHxuoTw3bAc5pYff1zweztD6YATSEr+04
         /6aEsmkX59Rv0tAPlpLzAjSa31WuCRNN9lh3DHCI0YiRRfNZCBaxcbySGCRgohslwb2e
         ZtK5Jvab4ccw8rkAJG0Fz4yfXsryiZxPPZ60DSp2yW6sF6GyotvQfxmvBKGril0bBjQK
         quKdIOIWlGYGuAHA/0dALPJrWWrt4+fqwh0sqlS0hF6zohAdGTD/n30HtAReYq4TKXfU
         4FTR2wYLc2m7lSyqn7Qi4ZA21wg6MkHi6lCF2iXR8FpO5OvUViWdF+aOg/VQWQsKrU0b
         CmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724868892; x=1725473692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fxFhdgcdFzSWR4m+hBF4loBsPrOw6jIDc6iaiMd0FSE=;
        b=Ykd4cfDC+ElPBqUP6JW74k4MjSp1CziQx7RPurduOJLM+DTge+Ays0eRYEz1YAXRZv
         3YfjN4Ya2/UvAnqqI3gpK+oGndYXLFfzymqPcNPsEfVnFEZxjvQvs68I9uS2aFouAI9P
         ZLZ8Tf6qHJQtxKZnqTMPmJ1YWYlUWZxg6t/4CO4q4p4cdt2V3j23BXPIIjIuJUuQSgOt
         LcosXT4FHQylE4oexolL+QKVkMyqvi2737qTBXIdtqDovqjFsNCHJMCZNwXk8rZTnd5a
         Z4QAW6IjdntLZjFvkkJ1A5VAuLe8BbEPKQ2WhJ61A/VnEs5R2moWQyv4U4dY51Qv0UtN
         BqKQ==
X-Gm-Message-State: AOJu0Yy+B6HI8cE2X9PSWaZrdTb10JqcV3whSqcy4S/XpM76C2BFOdCP
	g2f/ecAsXrxs/PFsLrd+Td1ewECbxwmALuArF6nUakcOPwMb2uYWqVl10/O3d81f8hFBR010RqH
	nJA==
X-Google-Smtp-Source: AGHT+IEmlOo0JV5Gv21VfsNJKRrpc3tuoQeacy7wwomFgLvY9qyIYMzbads49UyHIYXdJBFWybGMGbjfotA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:885:0:b0:e0b:f684:e972 with SMTP id
 3f1490d57ef6-e1a5af2634cmr1494276.12.1724868891944; Wed, 28 Aug 2024 11:14:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Aug 2024 11:14:45 -0700
In-Reply-To: <20240828181446.652474-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828181446.652474-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240828181446.652474-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Add a test for coalesced MMIO (and PIO
 on x86)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ilias Stamatis <ilstam@amazon.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
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

Lastly, wrap the coalesced I/O ring in a structure to prepare for a
potential future where KVM supports multiple ring buffers beyond KVM's
"default" built-in buffer.

Link: https://lore.kernel.org/all/20240820133333.1724191-1-ilstam@amazon.com
Cc: Ilias Stamatis <ilstam@amazon.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/coalesced_io_test.c | 236 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  26 ++
 3 files changed, 265 insertions(+)
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
index 000000000000..60cb25454899
--- /dev/null
+++ b/tools/testing/selftests/kvm/coalesced_io_test.c
@@ -0,0 +1,236 @@
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
+struct kvm_coalesced_io {
+	struct kvm_coalesced_mmio_ring *ring;
+	uint32_t ring_size;
+	uint64_t mmio_gpa;
+	uint64_t *mmio;
+
+	/*
+	 * x86-only, but define pio_port for all architectures to minimize the
+	 * amount of #ifdeffery and complexity, without having to sacrifice
+	 * verbose error messages.
+	 */
+	uint8_t pio_port;
+};
+
+static struct kvm_coalesced_io kvm_builtin_io_ring;
+
+#ifdef __x86_64__
+static const int has_pio = 1;
+#else
+static const int has_pio = 0;
+#endif
+
+static void guest_code(struct kvm_coalesced_io *io)
+{
+	int i, j;
+
+	for (;;) {
+		for (j = 0; j < 1 + has_pio; j++) {
+			/*
+			 * KVM always leaves one free entry, i.e. exits to
+			 * userspace before the last entry is filled.
+			 */
+			for (i = 0; i < io->ring_size - 1; i++) {
+#ifdef __x86_64__
+				if (i & 1)
+					outl(io->pio_port, io->pio_port + i);
+				else
+#endif
+					WRITE_ONCE(*io->mmio, io->mmio_gpa + i);
+			}
+#ifdef __x86_64__
+			if (j & 1)
+				outl(io->pio_port, io->pio_port + i);
+			else
+#endif
+				WRITE_ONCE(*io->mmio, io->mmio_gpa + i);
+		}
+		GUEST_SYNC(0);
+
+		WRITE_ONCE(*io->mmio, io->mmio_gpa + i);
+#ifdef __x86_64__
+		outl(io->pio_port, io->pio_port + i);
+#endif
+	}
+}
+
+static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
+					struct kvm_coalesced_io *io,
+					uint32_t ring_start,
+					uint32_t expected_exit)
+{
+	const bool want_pio = expected_exit == KVM_EXIT_IO;
+	struct kvm_coalesced_mmio_ring *ring = io->ring;
+	struct kvm_run *run = vcpu->run;
+	uint32_t pio_value;
+
+	WRITE_ONCE(ring->first, ring_start);
+	WRITE_ONCE(ring->last, ring_start);
+
+	vcpu_run(vcpu);
+
+	/*
+	 * Annoyingly, reading PIO data is safe only for PIO exits, otherwise
+	 * data_offset is garbage, e.g. an MMIO gpa.
+	 */
+	if (run->exit_reason == KVM_EXIT_IO)
+		pio_value = *(uint32_t *)((void *)run + run->io.data_offset);
+	else
+		pio_value = 0;
+
+	TEST_ASSERT((!want_pio && (run->exit_reason == KVM_EXIT_MMIO && run->mmio.is_write &&
+				   run->mmio.phys_addr == io->mmio_gpa && run->mmio.len == 8 &&
+				   *(uint64_t *)run->mmio.data == io->mmio_gpa + io->ring_size - 1)) ||
+		    (want_pio  && (run->exit_reason == KVM_EXIT_IO && run->io.port == io->pio_port &&
+				   run->io.direction == KVM_EXIT_IO_OUT && run->io.count == 1 &&
+				   pio_value == io->pio_port + io->ring_size - 1)),
+		    "For start = %u, expected exit on %u-byte %s write 0x%llx = %lx, got exit_reason = %u (%s)\n  "
+		    "(MMIO addr = 0x%llx, write = %u, len = %u, data = %lx)\n  "
+		    "(PIO port = 0x%x, write = %u, len = %u, count = %u, data = %x",
+		    ring_start, want_pio ? 4 : 8, want_pio ? "PIO" : "MMIO",
+		    want_pio ? (unsigned long long)io->pio_port : io->mmio_gpa,
+		    (want_pio ? io->pio_port : io->mmio_gpa) + io->ring_size - 1, run->exit_reason,
+		    run->exit_reason == KVM_EXIT_MMIO ? "MMIO" : run->exit_reason == KVM_EXIT_IO ? "PIO" : "other",
+		    run->mmio.phys_addr, run->mmio.is_write, run->mmio.len, *(uint64_t *)run->mmio.data,
+		    run->io.port, run->io.direction, run->io.size, run->io.count, pio_value);
+}
+
+static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
+					     struct kvm_coalesced_io *io,
+					     uint32_t ring_start,
+					     uint32_t expected_exit)
+{
+	struct kvm_coalesced_mmio_ring *ring = io->ring;
+	int i;
+
+	vcpu_run_and_verify_io_exit(vcpu, io, ring_start, expected_exit);
+
+	TEST_ASSERT((ring->last + 1) % io->ring_size == ring->first,
+		    "Expected ring to be full (minus 1), first = %u, last = %u, max = %u, start = %u",
+		    ring->first, ring->last, io->ring_size, ring_start);
+
+	for (i = 0; i < io->ring_size - 1; i++) {
+		uint32_t idx = (ring->first + i) % io->ring_size;
+		struct kvm_coalesced_mmio *entry = &ring->coalesced_mmio[idx];
+
+#ifdef __x86_64__
+		if (i & 1)
+			TEST_ASSERT(entry->phys_addr == io->pio_port &&
+				    entry->len == 4 && entry->pio &&
+				    *(uint32_t *)entry->data == io->pio_port + i,
+				    "Wanted 4-byte port I/O 0x%x = 0x%x in entry %u, got %u-byte %s 0x%llx = 0x%x",
+				    io->pio_port, io->pio_port + i, i,
+				    entry->len, entry->pio ? "PIO" : "MMIO",
+				    entry->phys_addr, *(uint32_t *)entry->data);
+		else
+#endif
+			TEST_ASSERT(entry->phys_addr == io->mmio_gpa &&
+				    entry->len == 8 && !entry->pio,
+				    "Wanted 8-byte MMIO to 0x%lx = %lx in entry %u, got %u-byte %s 0x%llx = 0x%lx",
+				    io->mmio_gpa, io->mmio_gpa + i, i,
+				    entry->len, entry->pio ? "PIO" : "MMIO",
+				    entry->phys_addr, *(uint64_t *)entry->data);
+	}
+}
+
+static void test_coalesced_io(struct kvm_vcpu *vcpu,
+			      struct kvm_coalesced_io *io, uint32_t ring_start)
+{
+	struct kvm_coalesced_mmio_ring *ring = io->ring;
+
+	kvm_vm_register_coalesced_io(vcpu->vm, io->mmio_gpa, 8, false /* pio */);
+#ifdef __x86_64__
+	kvm_vm_register_coalesced_io(vcpu->vm, io->pio_port, 8, true /* pio */);
+#endif
+
+	vcpu_run_and_verify_coalesced_io(vcpu, io, ring_start, KVM_EXIT_MMIO);
+#ifdef __x86_64__
+	vcpu_run_and_verify_coalesced_io(vcpu, io, ring_start, KVM_EXIT_IO);
+#endif
+
+	/*
+	 * Verify ucall, which may use non-coalesced MMIO or PIO, generates an
+	 * immediate exit.
+	 */
+	WRITE_ONCE(ring->first, ring_start);
+	WRITE_ONCE(ring->last, ring_start);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	TEST_ASSERT_EQ(ring->first, ring_start);
+	TEST_ASSERT_EQ(ring->last, ring_start);
+
+	/* Verify that non-coalesced MMIO/PIO generates an exit to userspace. */
+	kvm_vm_unregister_coalesced_io(vcpu->vm, io->mmio_gpa, 8, false /* pio */);
+	vcpu_run_and_verify_io_exit(vcpu, io, ring_start, KVM_EXIT_MMIO);
+
+#ifdef __x86_64__
+	kvm_vm_unregister_coalesced_io(vcpu->vm, io->pio_port, 8, true /* pio */);
+	vcpu_run_and_verify_io_exit(vcpu, io, ring_start, KVM_EXIT_IO);
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
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	kvm_builtin_io_ring = (struct kvm_coalesced_io) {
+		/*
+		 * The I/O ring is a kernel-allocated page whose address is
+		 * relative to each vCPU's run page, with the page offset
+		 * provided by KVM in the return of KVM_CAP_COALESCED_MMIO.
+		 */
+		.ring = (void *)vcpu->run +
+			(kvm_check_cap(KVM_CAP_COALESCED_MMIO) * getpagesize()),
+
+		/*
+		 * The size of the I/O ring is fixed, but KVM defines the sized
+		 * based on the kernel's PAGE_SIZE.  Thus, userspace must query
+		 * the host's page size at runtime to compute the ring size.
+		 */
+		.ring_size = (getpagesize() - sizeof(struct kvm_coalesced_mmio_ring)) /
+			     sizeof(struct kvm_coalesced_mmio),
+
+		/*
+		 * Arbitrary address+port (MMIO mustn't overlap memslots), with
+		 * the MMIO GPA identity mapped in the guest.
+		 */
+		.mmio_gpa = 4ull * SZ_1G,
+		.mmio = (uint64_t *)(4ull * SZ_1G),
+		.pio_port = 0x80,
+	};
+
+	virt_map(vm, (uint64_t)kvm_builtin_io_ring.mmio, kvm_builtin_io_ring.mmio_gpa, 1);
+
+	sync_global_to_guest(vm, kvm_builtin_io_ring);
+	vcpu_args_set(vcpu, 1, &kvm_builtin_io_ring);
+
+	for (i = 0; i < kvm_builtin_io_ring.ring_size; i++)
+		test_coalesced_io(vcpu, &kvm_builtin_io_ring, i);
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


