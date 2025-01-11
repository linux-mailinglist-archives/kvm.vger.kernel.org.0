Return-Path: <kvm+bounces-35183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2E3A09FC0
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14EB3188F58B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF35168B1;
	Sat, 11 Jan 2025 00:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ST0edF3d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1315F3FF
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556669; cv=none; b=sFuQi0JMFC85Q9uI5ZMAj7B3PxsWcflDZfWHqG51+DQk8FsIYRaZLILjt5CuGxaQVRebNM+svdAjNr0ZRUdHtHGgnLB2JI7/pA12Gt6CniDeVW6bIK3rZsyzrnsr3wSh5NjozSWgL+86IwnmPziuusB6F1Burev+iFP2SkQx2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556669; c=relaxed/simple;
	bh=WTSPSxJ9acPV9cYjYBvN8akkgrsAOJkvqpDny9WUy0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rwdJ4vjggR4GyHOeicSA3aCszqifo3ufcnMvhFoO61RJZa2CdO5Xu5yORdUH0AE5Jz7iHmJuBY42BxMmhhqZFuOcmpdZFNsdC7saD0DA4PgJzat3ZdfsYc6DsHehQhSjli6DlX01M0j9C+bMX4HDwCnfzJq7+DkOD9UtCuQ1fhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ST0edF3d; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso7424925a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556667; x=1737161467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+d9N3KJHkNXRjOZutdW8pQt5lh1Ed4rA4mypMg2qOMY=;
        b=ST0edF3dlKET614rM6Va4oI3x5dwib5BeSTnRgfmzJ6kvL9GR1tgOm296EWUmlUtI1
         DdrtLStFeUs5jaK6hiHc1tOvvIXLLwBHw4QK5ksYN35QQjXjwntnZT1VAr4frbNZo+k2
         vWlVSsI2x6Tzawr6cDSTScm7agt6csvf1/3VynHZ5nD575F3m50FYPT3B8JqTy8RmVV7
         jsA/uW69x16Ln3zXuwGMH9nXE3M4qITEqACZCxBqJAMesT+p3ypcXn94kePTqVlnT/9k
         ytIEGphxH7ImdghJT1flacJEJE+ixMJ9aGodMCwa1GM7ywhcqMy+8atDsftAulLUV6N+
         tiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556667; x=1737161467;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+d9N3KJHkNXRjOZutdW8pQt5lh1Ed4rA4mypMg2qOMY=;
        b=h9QIxQ0i4IckqUlYjgSDtN+tcHp54G8mJK0CXMNXL8tKo92MEdgqH+5jog3mOFKFVz
         2LyD+CMseXBbUXwF1v6c9eRy0ogB8eaVdbDW681C7yLjqEJErOeJHU2VG0tLJ2LnYUbE
         JFr1tnVG/HeELeAG/ofQnumlXfPuzr8hOTQes4M13foQfSiNegZ1VCDRnrXzewnhN6W2
         HPmh9BnsJD2/dtW0GmhY1G2YgnqvUXWGsaPJrpuB3iPLMo0OOooPH+NQ+wnPDWqVxHLQ
         Tfi1u4AWkAZ9wZdIE01oJKSIxgvD2dh57qCt390ewIuNHxr2V5LBnPuGfj3b0wf4ge9Y
         878Q==
X-Forwarded-Encrypted: i=1; AJvYcCVax6kvhGwkUFG8qQpS3Y8q74Qhh3SsS0A8nQkEhxS63I3YQNRYOxpuRFMoMTPXrU3XNPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYGGGiOw9IBZtXXsklP9XpM0q9eHlovz60/tFoHTEqaLQziiCc
	VBa9UTrjta8sn9amzQcGFwyyMVAOHmXvqQdxHBNQVJFwmo+G9awC7LSU++C/kORfwZJ+ct5B2WJ
	Czw==
X-Google-Smtp-Source: AGHT+IG4ZDxN55fz763KYhU4ygCt6fNKcRVhx7HviNi6kdOkpJz+b/vIZA/QjwyAghwU09pB3HIzfMoXqiw=
X-Received: from pjbee12.prod.google.com ([2002:a17:90a:fc4c:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8f:b0:2ef:2d9f:8e58
 with SMTP id 98e67ed59e1d1-2f5490dbe3fmr16185263a91.34.1736556667051; Fri, 10
 Jan 2025 16:51:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:49 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-10-seanjc@google.com>
Subject: [PATCH v2 9/9] KVM: selftests: Add compile-time assertions to guard
 against stats typos
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add compile-time assertions to the main binary stats accessor to verify
the stat is a known KVM stat of the appropriate scope, and "add" all
known stats for all architectures.

To build the set of known stats, define enums for each stat, with a
completely arbitrary magic value to specify the scope of the stat.  With
the assert in place, misuse of stat (or usage of a new stat) generates
error like so:

  In file included from include/x86/kvm_util_arch.h:8,
                   from include/kvm_util.h:23,
                   from x86/dirty_log_page_splitting_test.c:16:
   x86/dirty_log_page_splitting_test.c: In function =E2=80=98get_page_stats=
=E2=80=99:
  include/kvm_util.h:563:42: error: =E2=80=98VM_STAT_pages_4m=E2=80=99 unde=
clared
    (first use in this function); did you mean =E2=80=98VM_STAT_pages_2m=E2=
=80=99?
    563 | #define vm_get_stat(vm, stat) __get_stat(VM, &(vm)->stats, stat)
        |                                          ^~

  ...
  x86/dirty_log_page_splitting_test.c:45:27: note: in expansion of macro =
=E2=80=98vm_get_stat=E2=80=99
     45 |         stats->pages_2m =3D vm_get_stat(vm, pages_4m);
        |                           ^~~~~~~~~~~

Using pre-defined lists of stats doesn't completely eliminate human error,
e.g. it's obviously possible to make a typo when adding a state.  And
while there is also a non-zero cost to maintaining the set of stats,
adding stats in KVM is relatively uncommon, and removing stats is extremely
rare.  On the flip side, providing a list of known stats should make it
easier to use stats in test, at which point detecting goofs at compile-time
will also be more valuable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/include/arm64/kvm_util_arch.h         |  12 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  24 +++-
 .../selftests/kvm/include/kvm_util_types.h    |   6 +
 .../kvm/include/riscv/kvm_util_arch.h         |  14 +++
 .../kvm/include/s390/kvm_util_arch.h          | 113 ++++++++++++++++++
 .../selftests/kvm/include/x86/kvm_util_arch.h |  52 ++++++++
 6 files changed, 218 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h b/to=
ols/testing/selftests/kvm/include/arm64/kvm_util_arch.h
index e43a57d99b56..12097262f585 100644
--- a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
@@ -2,6 +2,18 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
=20
+#include "kvm_util_types.h"
+
 struct kvm_vm_arch {};
=20
+enum kvm_arm64_stats {
+	VCPU_STAT(hvc_exit_stat),
+	VCPU_STAT(wfe_exit_stat),
+	VCPU_STAT(wfi_exit_stat),
+	VCPU_STAT(mmio_exit_user),
+	VCPU_STAT(mmio_exit_kernel),
+	VCPU_STAT(signal_exits),
+	VCPU_STAT(exits),
+};
+
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h
index 373912464fb4..de2dfbb07071 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -535,19 +535,37 @@ void read_stat_data(int stats_fd, struct kvm_stats_he=
ader *header,
 		    struct kvm_stats_desc *desc, uint64_t *data,
 		    size_t max_elements);
=20
+enum kvm_common_stats {
+	VM_STAT(remote_tlb_flush),
+	VM_STAT(remote_tlb_flush_requests),
+
+	VCPU_STAT(halt_successfull_poll),
+	VCPU_STAT(halt_attempted_poll),
+	VCPU_STAT(halt_poll_invalid),
+	VCPU_STAT(halt_wakeup),
+	VCPU_STAT(halt_poll_success_ns),
+	VCPU_STAT(halt_poll_fail_ns),
+	VCPU_STAT(halt_wait_ns),
+	VCPU_STAT(halt_poll_success_hist),
+	VCPU_STAT(halt_poll_fail_hist),
+	VCPU_STAT(halt_wait_hist),
+	VCPU_STAT(blocking),
+};
+
 void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
 		  uint64_t *data, size_t max_elements);
=20
-#define __get_stat(stats, stat)							\
+#define __get_stat(type, stats, stat)						\
 ({										\
 	uint64_t data;								\
 										\
+	kvm_static_assert(type##_STAT_##stat =3D=3D type##_STAT_MAGIC_NUMBER);	\
 	kvm_get_stat(stats, #stat, &data, 1);					\
 	data;									\
 })
=20
-#define vm_get_stat(vm, stat) __get_stat(&(vm)->stats, stat)
-#define vcpu_get_stat(vcpu, stat) __get_stat(&(vcpu)->stats, stat)
+#define vm_get_stat(vm, stat) __get_stat(VM, &(vm)->stats, stat)
+#define vcpu_get_stat(vcpu, stat) __get_stat(VCPU, &(vcpu)->stats, stat)
=20
 void vm_create_irqchip(struct kvm_vm *vm);
=20
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/t=
esting/selftests/kvm/include/kvm_util_types.h
index ec787b97cf18..20e6717a0d24 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -17,4 +17,10 @@
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address *=
/
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
=20
+#define VM_STAT_MAGIC_NUMBER   1
+#define VM_STAT(stat)  VM_STAT_##stat =3D VM_STAT_MAGIC_NUMBER
+
+#define VCPU_STAT_MAGIC_NUMBER   2
+#define VCPU_STAT(stat) VCPU_STAT_##stat =3D VCPU_STAT_MAGIC_NUMBER
+
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/to=
ols/testing/selftests/kvm/include/riscv/kvm_util_arch.h
index e43a57d99b56..ea53d6aeb693 100644
--- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -2,6 +2,20 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
=20
+#include "kvm_util_types.h"
+
 struct kvm_vm_arch {};
=20
+enum kvm_riscv_stats {
+	VCPU_STAT(ecall_exit_stat),
+	VCPU_STAT(wfi_exit_stat),
+	VCPU_STAT(wrs_exit_stat),
+	VCPU_STAT(mmio_exit_user),
+	VCPU_STAT(mmio_exit_kernel),
+	VCPU_STAT(csr_exit_user),
+	VCPU_STAT(csr_exit_kernel),
+	VCPU_STAT(signal_exits),
+	VCPU_STAT(exits),
+};
+
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h b/too=
ls/testing/selftests/kvm/include/s390/kvm_util_arch.h
index e43a57d99b56..64d4de333e09 100644
--- a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
@@ -2,6 +2,119 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
=20
+#include "kvm_util_types.h"
+
 struct kvm_vm_arch {};
=20
+enum kvm_s390_stats {
+	VM_STAT(inject_io),
+	VM_STAT(inject_float_mchk),
+	VM_STAT(inject_pfault_done),
+	VM_STAT(inject_service_signal),
+	VM_STAT(inject_virtio),
+	VM_STAT(aen_forward),
+	VM_STAT(gmap_shadow_reuse),
+	VM_STAT(gmap_shadow_create),
+	VM_STAT(gmap_shadow_r1_entry),
+	VM_STAT(gmap_shadow_r2_entry),
+	VM_STAT(gmap_shadow_r3_entry),
+	VM_STAT(gmap_shadow_sg_entry),
+	VM_STAT(gmap_shadow_pg_entry),
+
+	VCPU_STAT(exit_userspace),
+	VCPU_STAT(exit_null),
+	VCPU_STAT(exit_external_request),
+	VCPU_STAT(exit_io_request),
+	VCPU_STAT(exit_external_interrupt),
+	VCPU_STAT(exit_stop_request),
+	VCPU_STAT(exit_validity),
+	VCPU_STAT(exit_instruction),
+	VCPU_STAT(exit_pei),
+	VCPU_STAT(halt_no_poll_steal),
+	VCPU_STAT(instruction_lctl),
+	VCPU_STAT(instruction_lctlg),
+	VCPU_STAT(instruction_stctl),
+	VCPU_STAT(instruction_stctg),
+	VCPU_STAT(exit_program_interruption),
+	VCPU_STAT(exit_instr_and_program),
+	VCPU_STAT(exit_operation_exception),
+	VCPU_STAT(deliver_ckc),
+	VCPU_STAT(deliver_cputm),
+	VCPU_STAT(deliver_external_call),
+	VCPU_STAT(deliver_emergency_signal),
+	VCPU_STAT(deliver_service_signal),
+	VCPU_STAT(deliver_virtio),
+	VCPU_STAT(deliver_stop_signal),
+	VCPU_STAT(deliver_prefix_signal),
+	VCPU_STAT(deliver_restart_signal),
+	VCPU_STAT(deliver_program),
+	VCPU_STAT(deliver_io),
+	VCPU_STAT(deliver_machine_check),
+	VCPU_STAT(exit_wait_state),
+	VCPU_STAT(inject_ckc),
+	VCPU_STAT(inject_cputm),
+	VCPU_STAT(inject_external_call),
+	VCPU_STAT(inject_emergency_signal),
+	VCPU_STAT(inject_mchk),
+	VCPU_STAT(inject_pfault_init),
+	VCPU_STAT(inject_program),
+	VCPU_STAT(inject_restart),
+	VCPU_STAT(inject_set_prefix),
+	VCPU_STAT(inject_stop_signal),
+	VCPU_STAT(instruction_epsw),
+	VCPU_STAT(instruction_gs),
+	VCPU_STAT(instruction_io_other),
+	VCPU_STAT(instruction_lpsw),
+	VCPU_STAT(instruction_lpswe),
+	VCPU_STAT(instruction_lpswey),
+	VCPU_STAT(instruction_pfmf),
+	VCPU_STAT(instruction_ptff),
+	VCPU_STAT(instruction_sck),
+	VCPU_STAT(instruction_sckpf),
+	VCPU_STAT(instruction_stidp),
+	VCPU_STAT(instruction_spx),
+	VCPU_STAT(instruction_stpx),
+	VCPU_STAT(instruction_stap),
+	VCPU_STAT(instruction_iske),
+	VCPU_STAT(instruction_ri),
+	VCPU_STAT(instruction_rrbe),
+	VCPU_STAT(instruction_sske),
+	VCPU_STAT(instruction_ipte_interlock),
+	VCPU_STAT(instruction_stsi),
+	VCPU_STAT(instruction_stfl),
+	VCPU_STAT(instruction_tb),
+	VCPU_STAT(instruction_tpi),
+	VCPU_STAT(instruction_tprot),
+	VCPU_STAT(instruction_tsch),
+	VCPU_STAT(instruction_sie),
+	VCPU_STAT(instruction_essa),
+	VCPU_STAT(instruction_sthyi),
+	VCPU_STAT(instruction_sigp_sense),
+	VCPU_STAT(instruction_sigp_sense_running),
+	VCPU_STAT(instruction_sigp_external_call),
+	VCPU_STAT(instruction_sigp_emergency),
+	VCPU_STAT(instruction_sigp_cond_emergency),
+	VCPU_STAT(instruction_sigp_start),
+	VCPU_STAT(instruction_sigp_stop),
+	VCPU_STAT(instruction_sigp_stop_store_status),
+	VCPU_STAT(instruction_sigp_store_status),
+	VCPU_STAT(instruction_sigp_store_adtl_status),
+	VCPU_STAT(instruction_sigp_arch),
+	VCPU_STAT(instruction_sigp_prefix),
+	VCPU_STAT(instruction_sigp_restart),
+	VCPU_STAT(instruction_sigp_init_cpu_reset),
+	VCPU_STAT(instruction_sigp_cpu_reset),
+	VCPU_STAT(instruction_sigp_unknown),
+	VCPU_STAT(instruction_diagnose_10),
+	VCPU_STAT(instruction_diagnose_44),
+	VCPU_STAT(instruction_diagnose_9c),
+	VCPU_STAT(diag_9c_ignored),
+	VCPU_STAT(diag_9c_forward),
+	VCPU_STAT(instruction_diagnose_258),
+	VCPU_STAT(instruction_diagnose_308),
+	VCPU_STAT(instruction_diagnose_500),
+	VCPU_STAT(instruction_diagnose_other),
+	VCPU_STAT(pfault_sync),
+};
+
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tool=
s/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 972bb1c4ab4c..f9c4aedddbd0 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -48,4 +48,56 @@ do {											\
 	}										\
 } while (0)
=20
+enum kvm_x86_stats {
+	VM_STAT(mmu_shadow_zapped),
+	VM_STAT(mmu_pte_write),
+	VM_STAT(mmu_pde_zapped),
+	VM_STAT(mmu_flooded),
+	VM_STAT(mmu_recycled),
+	VM_STAT(mmu_cache_miss),
+	VM_STAT(mmu_unsync),
+	VM_STAT(pages_4k),
+	VM_STAT(pages_2m),
+	VM_STAT(pages_1g),
+	VM_STAT(pages),
+	VM_STAT(nx_lpage_splits),
+	VM_STAT(max_mmu_page_hash_collisions),
+	VM_STAT(max_mmu_rmap_size),
+
+	VCPU_STAT(pf_taken),
+	VCPU_STAT(pf_fixed),
+	VCPU_STAT(pf_emulate),
+	VCPU_STAT(pf_spurious),
+	VCPU_STAT(pf_fast),
+	VCPU_STAT(pf_mmio_spte_created),
+	VCPU_STAT(pf_guest),
+	VCPU_STAT(tlb_flush),
+	VCPU_STAT(invlpg),
+	VCPU_STAT(exits),
+	VCPU_STAT(io_exits),
+	VCPU_STAT(mmio_exits),
+	VCPU_STAT(signal_exits),
+	VCPU_STAT(irq_window_exits),
+	VCPU_STAT(nmi_window_exits),
+	VCPU_STAT(l1d_flush),
+	VCPU_STAT(halt_exits),
+	VCPU_STAT(request_irq_exits),
+	VCPU_STAT(irq_exits),
+	VCPU_STAT(host_state_reload),
+	VCPU_STAT(fpu_reload),
+	VCPU_STAT(insn_emulation),
+	VCPU_STAT(insn_emulation_fail),
+	VCPU_STAT(hypercalls),
+	VCPU_STAT(irq_injections),
+	VCPU_STAT(nmi_injections),
+	VCPU_STAT(req_event),
+	VCPU_STAT(nested_run),
+	VCPU_STAT(directed_yield_attempted),
+	VCPU_STAT(directed_yield_successful),
+	VCPU_STAT(preemption_reported),
+	VCPU_STAT(preemption_other),
+	VCPU_STAT(guest_mode),
+	VCPU_STAT(notify_window_exits),
+};
+
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
--=20
2.47.1.613.gc27f4b7a9f-goog


