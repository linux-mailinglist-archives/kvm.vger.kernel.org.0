Return-Path: <kvm+bounces-45156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5A9AA62DA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99241178A5D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE1521C198;
	Thu,  1 May 2025 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VwUjP0WK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B87224AE8
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124413; cv=none; b=QJFteUOR78lXYr5qYy+6n8KevcHmMtvwHJ3tu4tPLD5kWpr4cY0rsTxLYo2lDhBtvRV5+RDgHm8Iu3/fFzv8EulpgaeTCHFhjjBkVkYKRqVTViAkhBawuwcobbcFyxH1+n3akAOtO5afEgitX+5A2+sdLy7nlkGpaFoZTjRhwII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124413; c=relaxed/simple;
	bh=8YtiEF8K/FKwv+g0TSQoD8LI3KRD9ZTvfGPs8Frget0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DQGz4pKVMWYSXiWLBMxq7cmEtCyXki0Kh6LQucGcmb6MqXckUgBEp9JHl5r7MBIFbil5RtsUKTZoaUfMn8xBMWbJcul5vOEZNzPoKpc4+Flyx1GhcamWzy8fFAvCPK8fT5D8mjQIhW4HYi2Ek/Uwtv3r39z6smG5JIW1FOKYSKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VwUjP0WK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00aa1f50d1so730130a12.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124401; x=1746729201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aF2d0tOZ9HAZcvRyWjbqMky2D99fiP24y6rRJ6Ym4i8=;
        b=VwUjP0WKRJswsa6bR8Uj2MtVEsPQg+9J+bLT4uYCIMeNrhhOUGQxqz5nL9AlhT2QPm
         arPg96+RVOljhEs57kqAH9GG6hruNOSJdqU8O90IyODSZhyS1Z6mOaDUUUeZHlpV4bKm
         1zWl7KdE7RN835JqaKjyX8OkPzNN1J9l6vz0xvvZYrcWis/sl+lUBdzQkUiUbNKyp9qu
         oYwXp1XtigAValB0kOoD+uOzB+6TVWURzpfAUUfVWbHRp1f7ZdN2lI/D9tdgSdyuuwuC
         vN50QRWx2o2HQfcJQ8uC6J0pwtQ4pKaX6Znia7Kc9+J8muPscvP+D/nEUeHh/zXdh4gk
         Os8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124401; x=1746729201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aF2d0tOZ9HAZcvRyWjbqMky2D99fiP24y6rRJ6Ym4i8=;
        b=g0fuzRuItg1mUcr6si2fIL7OBtDfpTuHuM1T6S2Yg2u0SNcgXs3SjkbOx7g+OjJPdb
         gZKxBgmH4ZVk/iU6VO4FRv/CpKfSuEuwzUSxDWQ9yF/1ypnkFS2iiLT9VCCtcDkgldKw
         MDBinkbCiljoIabbzQX/TGyEicNdPZePzl4e5JA8MWGCyAD6Yi3lJ5QoCFAxLljdXJS9
         RiBscHKKnlUmtNCQk/xwqBqZ/9lpbemxd/xZ5DvrKo1ez6oFcbVtRpUYJ+ST12GITJ1O
         JNOXfX6Ocjyoi2XuelAldrYXGFwGt+y8ynR9uYHEpiarjCQw/SPbyEqH7YMMyz1tnwMU
         k5pA==
X-Forwarded-Encrypted: i=1; AJvYcCXmkpKP5kERes6uhCmcrZ79o5U7XcCWkFJYmq1v0gF3MoDdMcrUA/oal5qrgLwM4Al0OpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDeXr8KHFH1u0Asw5IXcrOvFqnZQp87iBOjVkBz3ToJnQe5exI
	tAAH7AlOQxV+M00QcSwUWEmNLqTFD52HWLQ+7soWLh/+sXZBbKHT8fMCkMuusI5FRRF11zVmq5s
	Sai9mZlU1uw==
X-Google-Smtp-Source: AGHT+IE5RqoH78lBgsZH5PfHS8DxDrf03IRjDulzMUA+5+4j1OrrtlOFPGqMDd2GdaQxQ8pVxEEeSIIo/gik/A==
X-Received: from pfbfe8.prod.google.com ([2002:a05:6a00:2f08:b0:732:20df:303c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:c78e:b0:1ee:c8e7:203c with SMTP id adf61e73a8af0-20cded4694bmr17573637.24.1746124401180;
 Thu, 01 May 2025 11:33:21 -0700 (PDT)
Date: Thu,  1 May 2025 11:32:58 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-5-dmatlack@google.com>
Subject: [PATCH 04/10] KVM: selftests: Use u64 instead of uint64_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Use u64 instead of uint64_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/uint64_t/u64/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

Also include <linux/types.h> in include/x86/pmu.h to avoid compilation
failure.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  40 ++---
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  14 +-
 .../testing/selftests/kvm/arm64/arch_timer.c  |   2 +-
 .../kvm/arm64/arch_timer_edge_cases.c         | 115 +++++++-------
 .../selftests/kvm/arm64/debug-exceptions.c    |  49 +++---
 .../testing/selftests/kvm/arm64/hypercalls.c  |  18 +--
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |   6 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  74 ++++-----
 tools/testing/selftests/kvm/arm64/psci_test.c |  26 ++--
 .../testing/selftests/kvm/arm64/set_id_regs.c |  44 +++---
 tools/testing/selftests/kvm/arm64/vgic_init.c |  26 ++--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  36 ++---
 .../selftests/kvm/arm64/vpmu_counter_access.c |  60 +++----
 .../testing/selftests/kvm/coalesced_io_test.c |  14 +-
 .../selftests/kvm/demand_paging_test.c        |  10 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  12 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  44 +++---
 .../testing/selftests/kvm/guest_memfd_test.c  |   2 +-
 .../testing/selftests/kvm/guest_print_test.c  |  14 +-
 .../selftests/kvm/include/arm64/arch_timer.h  |  16 +-
 .../selftests/kvm/include/arm64/delay.h       |   4 +-
 .../testing/selftests/kvm/include/arm64/gic.h |   2 +-
 .../selftests/kvm/include/arm64/processor.h   |  14 +-
 .../selftests/kvm/include/arm64/vgic.h        |   6 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 146 +++++++++---------
 .../selftests/kvm/include/kvm_util_types.h    |   4 +-
 .../testing/selftests/kvm/include/memstress.h |  20 +--
 .../selftests/kvm/include/riscv/arch_timer.h  |  20 +--
 .../selftests/kvm/include/riscv/processor.h   |   9 +-
 .../kvm/include/s390/diag318_test_handler.h   |   2 +-
 .../selftests/kvm/include/s390/facility.h     |   4 +-
 .../testing/selftests/kvm/include/sparsebit.h |   6 +-
 .../testing/selftests/kvm/include/test_util.h |  14 +-
 .../selftests/kvm/include/timer_test.h        |   6 +-
 .../selftests/kvm/include/ucall_common.h      |  14 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   6 +-
 .../testing/selftests/kvm/include/x86/apic.h  |   8 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |  18 +--
 .../selftests/kvm/include/x86/hyperv.h        |  14 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |   6 +-
 tools/testing/selftests/kvm/include/x86/pmu.h |   6 +-
 .../selftests/kvm/include/x86/processor.h     | 116 +++++++-------
 tools/testing/selftests/kvm/include/x86/sev.h |   4 +-
 .../selftests/kvm/include/x86/svm_util.h      |   8 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  56 +++----
 .../selftests/kvm/kvm_page_table_test.c       |  48 +++---
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   4 +-
 .../selftests/kvm/lib/arm64/gic_private.h     |   4 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  20 +--
 .../selftests/kvm/lib/arm64/processor.c       |  84 +++++-----
 tools/testing/selftests/kvm/lib/arm64/ucall.c |   4 +-
 tools/testing/selftests/kvm/lib/arm64/vgic.c  |  18 +--
 tools/testing/selftests/kvm/lib/elf.c         |   2 +-
 .../testing/selftests/kvm/lib/guest_sprintf.c |  10 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  92 +++++------
 tools/testing/selftests/kvm/lib/memstress.c   |  32 ++--
 .../selftests/kvm/lib/riscv/processor.c       |  30 ++--
 .../kvm/lib/s390/diag318_test_handler.c       |  12 +-
 .../testing/selftests/kvm/lib/s390/facility.c |   2 +-
 .../selftests/kvm/lib/s390/processor.c        |  22 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  12 +-
 tools/testing/selftests/kvm/lib/test_util.c   |   2 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  16 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  12 +-
 tools/testing/selftests/kvm/lib/x86/apic.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |   4 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |   8 +-
 tools/testing/selftests/kvm/lib/x86/pmu.c     |   4 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 100 ++++++------
 tools/testing/selftests/kvm/lib/x86/sev.c     |   4 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |   6 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  70 ++++-----
 .../kvm/memslot_modification_stress_test.c    |  10 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 114 +++++++-------
 tools/testing/selftests/kvm/mmu_stress_test.c |  26 ++--
 .../selftests/kvm/pre_fault_memory_test.c     |  12 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   2 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   6 +-
 .../selftests/kvm/riscv/get-reg-list.c        |   2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   2 +-
 tools/testing/selftests/kvm/s390/debug_test.c |   8 +-
 tools/testing/selftests/kvm/s390/memop.c      |  32 ++--
 tools/testing/selftests/kvm/s390/resets.c     |   4 +-
 tools/testing/selftests/kvm/s390/tprot.c      |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |  30 ++--
 tools/testing/selftests/kvm/steal_time.c      |  16 +-
 .../kvm/system_counter_offset_test.c          |  12 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |   2 +-
 .../selftests/kvm/x86/apic_bus_clock_test.c   |  12 +-
 tools/testing/selftests/kvm/x86/debug_regs.c  |   2 +-
 .../kvm/x86/dirty_log_page_splitting_test.c   |  16 +-
 .../selftests/kvm/x86/feature_msrs_test.c     |   4 +-
 .../selftests/kvm/x86/fix_hypercall_test.c    |  10 +-
 .../selftests/kvm/x86/flds_emulation.h        |   4 +-
 .../testing/selftests/kvm/x86/hwcr_msr_test.c |  10 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |   8 +-
 .../selftests/kvm/x86/hyperv_features.c       |   6 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |   2 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |   8 +-
 .../selftests/kvm/x86/kvm_clock_test.c        |   4 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c |   6 +-
 .../selftests/kvm/x86/monitor_mwait_test.c    |   2 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |  18 +--
 .../selftests/kvm/x86/platform_info_test.c    |   4 +-
 .../selftests/kvm/x86/pmu_counters_test.c     |  32 ++--
 .../selftests/kvm/x86/pmu_event_filter_test.c |  78 +++++-----
 .../kvm/x86/private_mem_conversions_test.c    |  50 +++---
 .../kvm/x86/private_mem_kvm_exits_test.c      |   8 +-
 .../selftests/kvm/x86/set_sregs_test.c        |   6 +-
 .../selftests/kvm/x86/sev_init2_tests.c       |   4 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |   2 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |  10 +-
 tools/testing/selftests/kvm/x86/smm_test.c    |   4 +-
 tools/testing/selftests/kvm/x86/state_test.c  |   8 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |   4 +-
 .../testing/selftests/kvm/x86/tsc_msrs_test.c |   2 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/ucna_injection_test.c   |  43 +++---
 .../kvm/x86/userspace_msr_exit_test.c         |  24 +--
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |   2 +-
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  18 +--
 .../kvm/x86/vmx_nested_tsc_scaling_test.c     |  20 +--
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  10 +-
 .../selftests/kvm/x86/vmx_tsc_adjust_test.c   |   2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  38 ++---
 .../selftests/kvm/x86/xapic_state_test.c      |  16 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |   8 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  12 +-
 .../testing/selftests/kvm/x86/xss_msr_test.c  |   2 +-
 129 files changed, 1276 insertions(+), 1286 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 447e619cf856..71a52c4e3559 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -70,15 +70,15 @@ struct test_params {
 	enum vm_mem_backing_src_type backing_src;
 
 	/* The amount of memory to allocate for each vCPU. */
-	uint64_t vcpu_memory_bytes;
+	u64 vcpu_memory_bytes;
 
 	/* The number of vCPUs to create in the VM. */
 	int nr_vcpus;
 };
 
-static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
+static u64 pread_uint64(int fd, const char *filename, u64 index)
 {
-	uint64_t value;
+	u64 value;
 	off_t offset = index * sizeof(value);
 
 	TEST_ASSERT(pread(fd, &value, sizeof(value), offset) == sizeof(value),
@@ -92,11 +92,11 @@ static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
 #define PAGEMAP_PRESENT (1ULL << 63)
 #define PAGEMAP_PFN_MASK ((1ULL << 55) - 1)
 
-static uint64_t lookup_pfn(int pagemap_fd, struct kvm_vm *vm, uint64_t gva)
+static u64 lookup_pfn(int pagemap_fd, struct kvm_vm *vm, u64 gva)
 {
-	uint64_t hva = (uint64_t) addr_gva2hva(vm, gva);
-	uint64_t entry;
-	uint64_t pfn;
+	u64 hva = (u64)addr_gva2hva(vm, gva);
+	u64 entry;
+	u64 pfn;
 
 	entry = pread_uint64(pagemap_fd, "pagemap", hva / getpagesize());
 	if (!(entry & PAGEMAP_PRESENT))
@@ -108,16 +108,16 @@ static uint64_t lookup_pfn(int pagemap_fd, struct kvm_vm *vm, uint64_t gva)
 	return pfn;
 }
 
-static bool is_page_idle(int page_idle_fd, uint64_t pfn)
+static bool is_page_idle(int page_idle_fd, u64 pfn)
 {
-	uint64_t bits = pread_uint64(page_idle_fd, "page_idle", pfn / 64);
+	u64 bits = pread_uint64(page_idle_fd, "page_idle", pfn / 64);
 
 	return !!((bits >> (pfn % 64)) & 1);
 }
 
-static void mark_page_idle(int page_idle_fd, uint64_t pfn)
+static void mark_page_idle(int page_idle_fd, u64 pfn)
 {
-	uint64_t bits = 1ULL << (pfn % 64);
+	u64 bits = 1ULL << (pfn % 64);
 
 	TEST_ASSERT(pwrite(page_idle_fd, &bits, 8, 8 * (pfn / 64)) == 8,
 		    "Set page_idle bits for PFN 0x%" PRIx64, pfn);
@@ -127,11 +127,11 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 				  struct memstress_vcpu_args *vcpu_args)
 {
 	int vcpu_idx = vcpu_args->vcpu_idx;
-	uint64_t base_gva = vcpu_args->gva;
-	uint64_t pages = vcpu_args->pages;
-	uint64_t page;
-	uint64_t still_idle = 0;
-	uint64_t no_pfn = 0;
+	u64 base_gva = vcpu_args->gva;
+	u64 pages = vcpu_args->pages;
+	u64 page;
+	u64 still_idle = 0;
+	u64 no_pfn = 0;
 	int page_idle_fd;
 	int pagemap_fd;
 
@@ -146,8 +146,8 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	TEST_ASSERT(pagemap_fd > 0, "Failed to open pagemap.");
 
 	for (page = 0; page < pages; page++) {
-		uint64_t gva = base_gva + page * memstress_args.guest_page_size;
-		uint64_t pfn = lookup_pfn(pagemap_fd, vm, gva);
+		u64 gva = base_gva + page * memstress_args.guest_page_size;
+		u64 pfn = lookup_pfn(pagemap_fd, vm, gva);
 
 		if (!pfn) {
 			no_pfn++;
@@ -198,10 +198,10 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	close(pagemap_fd);
 }
 
-static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
+static void assert_ucall(struct kvm_vcpu *vcpu, u64 expected_ucall)
 {
 	struct ucall uc;
-	uint64_t actual_ucall = get_ucall(vcpu, &uc);
+	u64 actual_ucall = get_ucall(vcpu, &uc);
 
 	TEST_ASSERT(expected_ucall == actual_ucall,
 		    "Guest exited unexpectedly (expected ucall %" PRIu64
diff --git a/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c b/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
index cef8f7323ceb..ea87ae8f7b33 100644
--- a/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
@@ -66,7 +66,7 @@ static void test_guest_raz(struct kvm_vcpu *vcpu)
 	}
 }
 
-static uint64_t raz_wi_reg_ids[] = {
+static u64 raz_wi_reg_ids[] = {
 	KVM_ARM64_SYS_REG(SYS_ID_PFR0_EL1),
 	KVM_ARM64_SYS_REG(SYS_ID_PFR1_EL1),
 	KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1),
@@ -94,8 +94,8 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(raz_wi_reg_ids); i++) {
-		uint64_t reg_id = raz_wi_reg_ids[i];
-		uint64_t val;
+		u64 reg_id = raz_wi_reg_ids[i];
+		u64 val;
 
 		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
@@ -111,7 +111,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 	}
 }
 
-static uint64_t raz_invariant_reg_ids[] = {
+static u64 raz_invariant_reg_ids[] = {
 	KVM_ARM64_SYS_REG(SYS_ID_AFR0_EL1),
 	KVM_ARM64_SYS_REG(sys_reg(3, 0, 0, 3, 3)),
 	KVM_ARM64_SYS_REG(SYS_ID_DFR1_EL1),
@@ -123,8 +123,8 @@ static void test_user_raz_invariant(struct kvm_vcpu *vcpu)
 	int i, r;
 
 	for (i = 0; i < ARRAY_SIZE(raz_invariant_reg_ids); i++) {
-		uint64_t reg_id = raz_invariant_reg_ids[i];
-		uint64_t val;
+		u64 reg_id = raz_invariant_reg_ids[i];
+		u64 val;
 
 		val = vcpu_get_reg(vcpu, reg_id);
 		TEST_ASSERT_EQ(val, 0);
@@ -142,7 +142,7 @@ static void test_user_raz_invariant(struct kvm_vcpu *vcpu)
 
 static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 {
-	uint64_t val, el0;
+	u64 val, el0;
 
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
 
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
index eeba1cc87ff8..68757b55ea98 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer.c
@@ -56,7 +56,7 @@ static void guest_validate_irq(unsigned int intid,
 				struct test_vcpu_shared_data *shared_data)
 {
 	enum guest_stage stage = shared_data->guest_stage;
-	uint64_t xcnt = 0, xcnt_diff_us, cval = 0;
+	u64 xcnt = 0, xcnt_diff_us, cval = 0;
 	unsigned long xctl = 0;
 	unsigned int timer_irq = 0;
 	unsigned int accessor;
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a36a7e2db434..dffdb303a14e 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -22,7 +22,7 @@
 #include "gic.h"
 #include "vgic.h"
 
-static const uint64_t CVAL_MAX = ~0ULL;
+static const u64 CVAL_MAX = ~0ULL;
 /* tval is a signed 32-bit int. */
 static const int32_t TVAL_MAX = INT32_MAX;
 static const int32_t TVAL_MIN = INT32_MIN;
@@ -31,7 +31,7 @@ static const int32_t TVAL_MIN = INT32_MIN;
 static const uint32_t TIMEOUT_NO_IRQ_US = 50000;
 
 /* A nice counter value to use as the starting one for most tests. */
-static const uint64_t DEF_CNT = (CVAL_MAX / 2);
+static const u64 DEF_CNT = (CVAL_MAX / 2);
 
 /* Number of runs. */
 static const uint32_t NR_TEST_ITERS_DEF = 5;
@@ -52,9 +52,9 @@ struct test_args {
 	/* Virtual or physical timer and counter tests. */
 	enum arch_timer timer;
 	/* Delay used for most timer tests. */
-	uint64_t wait_ms;
+	u64 wait_ms;
 	/* Delay used in the test_long_timer_delays test. */
-	uint64_t long_wait_ms;
+	u64 long_wait_ms;
 	/* Number of iterations. */
 	int iterations;
 	/* Whether to test the physical timer. */
@@ -81,12 +81,12 @@ enum sync_cmd {
 	NO_USERSPACE_CMD,
 };
 
-typedef void (*sleep_method_t)(enum arch_timer timer, uint64_t usec);
+typedef void (*sleep_method_t)(enum arch_timer timer, u64 usec);
 
-static void sleep_poll(enum arch_timer timer, uint64_t usec);
-static void sleep_sched_poll(enum arch_timer timer, uint64_t usec);
-static void sleep_in_userspace(enum arch_timer timer, uint64_t usec);
-static void sleep_migrate(enum arch_timer timer, uint64_t usec);
+static void sleep_poll(enum arch_timer timer, u64 usec);
+static void sleep_sched_poll(enum arch_timer timer, u64 usec);
+static void sleep_in_userspace(enum arch_timer timer, u64 usec);
+static void sleep_migrate(enum arch_timer timer, u64 usec);
 
 sleep_method_t sleep_method[] = {
 	sleep_poll,
@@ -121,7 +121,7 @@ static void assert_irqs_handled(uint32_t n)
 	__GUEST_ASSERT(h == n, "Handled %d IRQS but expected %d", h, n);
 }
 
-static void userspace_cmd(uint64_t cmd)
+static void userspace_cmd(u64 cmd)
 {
 	GUEST_SYNC_ARGS(cmd, 0, 0, 0, 0);
 }
@@ -131,12 +131,12 @@ static void userspace_migrate_vcpu(void)
 	userspace_cmd(USERSPACE_MIGRATE_SELF);
 }
 
-static void userspace_sleep(uint64_t usecs)
+static void userspace_sleep(u64 usecs)
 {
 	GUEST_SYNC_ARGS(USERSPACE_USLEEP, usecs, 0, 0, 0);
 }
 
-static void set_counter(enum arch_timer timer, uint64_t counter)
+static void set_counter(enum arch_timer timer, u64 counter)
 {
 	GUEST_SYNC_ARGS(SET_COUNTER_VALUE, counter, timer, 0, 0);
 }
@@ -145,7 +145,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 {
 	unsigned int intid = gic_get_and_ack_irq();
 	enum arch_timer timer;
-	uint64_t cnt, cval;
+	u64 cnt, cval;
 	uint32_t ctl;
 	bool timer_condition, istatus;
 
@@ -177,7 +177,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 	gic_set_eoi(intid);
 }
 
-static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
+static void set_cval_irq(enum arch_timer timer, u64 cval_cycles,
 			 uint32_t ctl)
 {
 	atomic_set(&shared_data.handled, 0);
@@ -186,7 +186,7 @@ static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
 	timer_set_ctl(timer, ctl);
 }
 
-static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
+static void set_tval_irq(enum arch_timer timer, u64 tval_cycles,
 			 uint32_t ctl)
 {
 	atomic_set(&shared_data.handled, 0);
@@ -195,7 +195,7 @@ static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
 	timer_set_tval(timer, tval_cycles);
 }
 
-static void set_xval_irq(enum arch_timer timer, uint64_t xval, uint32_t ctl,
+static void set_xval_irq(enum arch_timer timer, u64 xval, uint32_t ctl,
 			 enum timer_view tv)
 {
 	switch (tv) {
@@ -274,13 +274,13 @@ static void wait_migrate_poll_for_irq(void)
  * Sleep for usec microseconds by polling in the guest or in
  * userspace (e.g. userspace_cmd=USERSPACE_SCHEDULE).
  */
-static void guest_poll(enum arch_timer test_timer, uint64_t usec,
+static void guest_poll(enum arch_timer test_timer, u64 usec,
 		       enum sync_cmd usp_cmd)
 {
-	uint64_t cycles = usec_to_cycles(usec);
+	u64 cycles = usec_to_cycles(usec);
 	/* Whichever timer we are testing with, sleep with the other. */
 	enum arch_timer sleep_timer = 1 - test_timer;
-	uint64_t start = timer_get_cntct(sleep_timer);
+	u64 start = timer_get_cntct(sleep_timer);
 
 	while ((timer_get_cntct(sleep_timer) - start) < cycles) {
 		if (usp_cmd == NO_USERSPACE_CMD)
@@ -290,22 +290,22 @@ static void guest_poll(enum arch_timer test_timer, uint64_t usec,
 	}
 }
 
-static void sleep_poll(enum arch_timer timer, uint64_t usec)
+static void sleep_poll(enum arch_timer timer, u64 usec)
 {
 	guest_poll(timer, usec, NO_USERSPACE_CMD);
 }
 
-static void sleep_sched_poll(enum arch_timer timer, uint64_t usec)
+static void sleep_sched_poll(enum arch_timer timer, u64 usec)
 {
 	guest_poll(timer, usec, USERSPACE_SCHED_YIELD);
 }
 
-static void sleep_migrate(enum arch_timer timer, uint64_t usec)
+static void sleep_migrate(enum arch_timer timer, u64 usec)
 {
 	guest_poll(timer, usec, USERSPACE_MIGRATE_SELF);
 }
 
-static void sleep_in_userspace(enum arch_timer timer, uint64_t usec)
+static void sleep_in_userspace(enum arch_timer timer, u64 usec)
 {
 	userspace_sleep(usec);
 }
@@ -314,15 +314,15 @@ static void sleep_in_userspace(enum arch_timer timer, uint64_t usec)
  * Reset the timer state to some nice values like the counter not being close
  * to the edge, and the control register masked and disabled.
  */
-static void reset_timer_state(enum arch_timer timer, uint64_t cnt)
+static void reset_timer_state(enum arch_timer timer, u64 cnt)
 {
 	set_counter(timer, cnt);
 	timer_set_ctl(timer, CTL_IMASK);
 }
 
-static void test_timer_xval(enum arch_timer timer, uint64_t xval,
+static void test_timer_xval(enum arch_timer timer, u64 xval,
 			    enum timer_view tv, irq_wait_method_t wm, bool reset_state,
-			    uint64_t reset_cnt)
+			    u64 reset_cnt)
 {
 	local_irq_disable();
 
@@ -347,23 +347,23 @@ static void test_timer_xval(enum arch_timer timer, uint64_t xval,
  * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
  */
 
-static void test_timer_cval(enum arch_timer timer, uint64_t cval,
+static void test_timer_cval(enum arch_timer timer, u64 cval,
 			    irq_wait_method_t wm, bool reset_state,
-			    uint64_t reset_cnt)
+			    u64 reset_cnt)
 {
 	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
 }
 
 static void test_timer_tval(enum arch_timer timer, int32_t tval,
 			    irq_wait_method_t wm, bool reset_state,
-			    uint64_t reset_cnt)
+			    u64 reset_cnt)
 {
-	test_timer_xval(timer, (uint64_t) tval, TIMER_TVAL, wm, reset_state,
+	test_timer_xval(timer, (u64)tval, TIMER_TVAL, wm, reset_state,
 			reset_cnt);
 }
 
-static void test_xval_check_no_irq(enum arch_timer timer, uint64_t xval,
-				   uint64_t usec, enum timer_view timer_view,
+static void test_xval_check_no_irq(enum arch_timer timer, u64 xval,
+				   u64 usec, enum timer_view timer_view,
 				   sleep_method_t guest_sleep)
 {
 	local_irq_disable();
@@ -378,17 +378,17 @@ static void test_xval_check_no_irq(enum arch_timer timer, uint64_t xval,
 	assert_irqs_handled(0);
 }
 
-static void test_cval_no_irq(enum arch_timer timer, uint64_t cval,
-			     uint64_t usec, sleep_method_t wm)
+static void test_cval_no_irq(enum arch_timer timer, u64 cval,
+			     u64 usec, sleep_method_t wm)
 {
 	test_xval_check_no_irq(timer, cval, usec, TIMER_CVAL, wm);
 }
 
-static void test_tval_no_irq(enum arch_timer timer, int32_t tval, uint64_t usec,
+static void test_tval_no_irq(enum arch_timer timer, int32_t tval, u64 usec,
 			     sleep_method_t wm)
 {
 	/* tval will be cast to an int32_t in test_xval_check_no_irq */
-	test_xval_check_no_irq(timer, (uint64_t) tval, usec, TIMER_TVAL, wm);
+	test_xval_check_no_irq(timer, (u64)tval, usec, TIMER_TVAL, wm);
 }
 
 /* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
@@ -487,7 +487,7 @@ static void test_reprogramming_timer(enum arch_timer timer, irq_wait_method_t wm
 static void test_reprogram_timers(enum arch_timer timer)
 {
 	int i;
-	uint64_t base_wait = test_args.wait_ms;
+	u64 base_wait = test_args.wait_ms;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
 		/*
@@ -504,7 +504,7 @@ static void test_reprogram_timers(enum arch_timer timer)
 static void test_basic_functionality(enum arch_timer timer)
 {
 	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
-	uint64_t cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
+	u64 cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
@@ -592,7 +592,7 @@ static void test_set_cnt_after_tval_max(enum arch_timer timer, irq_wait_method_t
 	reset_timer_state(timer, DEF_CNT);
 
 	set_cval_irq(timer,
-		     (uint64_t) TVAL_MAX +
+		     (u64)TVAL_MAX +
 		     msec_to_cycles(test_args.wait_ms) / 2, CTL_ENABLE);
 
 	set_counter(timer, TVAL_MAX);
@@ -607,7 +607,7 @@ static void test_set_cnt_after_tval_max(enum arch_timer timer, irq_wait_method_t
 /* Test timers set for: cval = now + TVAL_MAX + wait_ms / 2 */
 static void test_timers_above_tval_max(enum arch_timer timer)
 {
-	uint64_t cval;
+	u64 cval;
 	int i;
 
 	/*
@@ -637,8 +637,8 @@ static void test_timers_above_tval_max(enum arch_timer timer)
  * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
  * then waits for an IRQ.
  */
-static void test_set_cnt_after_xval(enum arch_timer timer, uint64_t cnt_1,
-				    uint64_t xval, uint64_t cnt_2,
+static void test_set_cnt_after_xval(enum arch_timer timer, u64 cnt_1,
+				    u64 xval, u64 cnt_2,
 				    irq_wait_method_t wm, enum timer_view tv)
 {
 	local_irq_disable();
@@ -661,8 +661,8 @@ static void test_set_cnt_after_xval(enum arch_timer timer, uint64_t cnt_1,
  * then waits for an IRQ.
  */
 static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
-					   uint64_t cnt_1, uint64_t xval,
-					   uint64_t cnt_2,
+					   u64 cnt_1, u64 xval,
+					   u64 cnt_2,
 					   sleep_method_t guest_sleep,
 					   enum timer_view tv)
 {
@@ -683,31 +683,31 @@ static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
 	timer_set_ctl(timer, CTL_IMASK);
 }
 
-static void test_set_cnt_after_tval(enum arch_timer timer, uint64_t cnt_1,
-				    int32_t tval, uint64_t cnt_2,
+static void test_set_cnt_after_tval(enum arch_timer timer, u64 cnt_1,
+				    int32_t tval, u64 cnt_2,
 				    irq_wait_method_t wm)
 {
 	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
 }
 
-static void test_set_cnt_after_cval(enum arch_timer timer, uint64_t cnt_1,
-				    uint64_t cval, uint64_t cnt_2,
+static void test_set_cnt_after_cval(enum arch_timer timer, u64 cnt_1,
+				    u64 cval, u64 cnt_2,
 				    irq_wait_method_t wm)
 {
 	test_set_cnt_after_xval(timer, cnt_1, cval, cnt_2, wm, TIMER_CVAL);
 }
 
 static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
-					   uint64_t cnt_1, int32_t tval,
-					   uint64_t cnt_2, sleep_method_t wm)
+					   u64 cnt_1, int32_t tval,
+					   u64 cnt_2, sleep_method_t wm)
 {
 	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
 				       TIMER_TVAL);
 }
 
 static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
-					   uint64_t cnt_1, uint64_t cval,
-					   uint64_t cnt_2, sleep_method_t wm)
+					   u64 cnt_1, u64 cval,
+					   u64 cnt_2, sleep_method_t wm)
 {
 	test_set_cnt_after_xval_no_irq(timer, cnt_1, cval, cnt_2, wm,
 				       TIMER_CVAL);
@@ -729,8 +729,7 @@ static void test_move_counters_ahead_of_timers(enum arch_timer timer)
 		test_set_cnt_after_tval(timer, 0, -1, DEF_CNT + 1, wm);
 		test_set_cnt_after_tval(timer, 0, -1, TVAL_MAX, wm);
 		tval = TVAL_MAX;
-		test_set_cnt_after_tval(timer, 0, tval, (uint64_t) tval + 1,
-					wm);
+		test_set_cnt_after_tval(timer, 0, tval, (u64)tval + 1, wm);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
@@ -760,7 +759,7 @@ static void test_move_counters_behind_timers(enum arch_timer timer)
 static void test_timers_in_the_past(enum arch_timer timer)
 {
 	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
-	uint64_t cval;
+	u64 cval;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
@@ -796,7 +795,7 @@ static void test_timers_in_the_past(enum arch_timer timer)
 static void test_long_timer_delays(enum arch_timer timer)
 {
 	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
-	uint64_t cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
+	u64 cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
@@ -886,7 +885,7 @@ static void migrate_self(uint32_t new_pcpu)
 		    new_pcpu, ret);
 }
 
-static void kvm_set_cntxct(struct kvm_vcpu *vcpu, uint64_t cnt,
+static void kvm_set_cntxct(struct kvm_vcpu *vcpu, u64 cnt,
 			   enum arch_timer timer)
 {
 	if (timer == PHYSICAL)
@@ -898,7 +897,7 @@ static void kvm_set_cntxct(struct kvm_vcpu *vcpu, uint64_t cnt,
 static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 {
 	enum sync_cmd cmd = uc->args[1];
-	uint64_t val = uc->args[2];
+	u64 val = uc->args[2];
 	enum arch_timer timer = uc->args[3];
 
 	switch (cmd) {
diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index c7fb55c9135b..b97d3a183246 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -31,14 +31,14 @@
 
 extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
 extern unsigned char iter_ss_begin, iter_ss_end;
-static volatile uint64_t sw_bp_addr, hw_bp_addr;
-static volatile uint64_t wp_addr, wp_data_addr;
-static volatile uint64_t svc_addr;
-static volatile uint64_t ss_addr[4], ss_idx;
-#define  PC(v)  ((uint64_t)&(v))
+static volatile u64 sw_bp_addr, hw_bp_addr;
+static volatile u64 wp_addr, wp_data_addr;
+static volatile u64 svc_addr;
+static volatile u64 ss_addr[4], ss_idx;
+#define  PC(v)  ((u64)&(v))
 
 #define GEN_DEBUG_WRITE_REG(reg_name)			\
-static void write_##reg_name(int num, uint64_t val)	\
+static void write_##reg_name(int num, u64 val)	\
 {							\
 	switch (num) {					\
 	case 0:						\
@@ -103,7 +103,7 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
 static void reset_debug_state(void)
 {
 	uint8_t brps, wrps, i;
-	uint64_t dfr0;
+	u64 dfr0;
 
 	asm volatile("msr daifset, #8");
 
@@ -149,7 +149,7 @@ static void enable_monitor_debug_exceptions(void)
 	isb();
 }
 
-static void install_wp(uint8_t wpn, uint64_t addr)
+static void install_wp(uint8_t wpn, u64 addr)
 {
 	uint32_t wcr;
 
@@ -162,7 +162,7 @@ static void install_wp(uint8_t wpn, uint64_t addr)
 	enable_monitor_debug_exceptions();
 }
 
-static void install_hw_bp(uint8_t bpn, uint64_t addr)
+static void install_hw_bp(uint8_t bpn, u64 addr)
 {
 	uint32_t bcr;
 
@@ -174,11 +174,11 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_monitor_debug_exceptions();
 }
 
-static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
-			   uint64_t ctx)
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
+			   u64 ctx)
 {
 	uint32_t wcr;
-	uint64_t ctx_bcr;
+	u64 ctx_bcr;
 
 	/* Setup a context-aware breakpoint for Linked Context ID Match */
 	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
@@ -196,8 +196,8 @@ static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
 	enable_monitor_debug_exceptions();
 }
 
-void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
-		       uint64_t ctx)
+void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, u64 addr,
+		       u64 ctx)
 {
 	uint32_t addr_bcr, ctx_bcr;
 
@@ -236,7 +236,7 @@ static volatile char write_data;
 
 static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
-	uint64_t ctx = 0xabcdef;	/* a random context number */
+	u64 ctx = 0xabcdef;	/* a random context number */
 
 	/* Software-breakpoint */
 	reset_debug_state();
@@ -377,8 +377,8 @@ static void guest_svc_handler(struct ex_regs *regs)
 
 static void guest_code_ss(int test_cnt)
 {
-	uint64_t i;
-	uint64_t bvr, wvr, w_bvr, w_wvr;
+	u64 i;
+	u64 bvr, wvr, w_bvr, w_wvr;
 
 	for (i = 0; i < test_cnt; i++) {
 		/* Bits [1:0] of dbg{b,w}vr are RES0 */
@@ -416,7 +416,7 @@ static void guest_code_ss(int test_cnt)
 	GUEST_DONE();
 }
 
-static int debug_version(uint64_t id_aa64dfr0)
+static int debug_version(u64 id_aa64dfr0)
 {
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0);
 }
@@ -468,8 +468,8 @@ void test_single_step_from_userspace(int test_cnt)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	struct kvm_run *run;
-	uint64_t pc, cmd;
-	uint64_t test_pc = 0;
+	u64 pc, cmd;
+	u64 test_pc = 0;
 	bool ss_enable = false;
 	struct kvm_guest_debug debug = {};
 
@@ -506,7 +506,7 @@ void test_single_step_from_userspace(int test_cnt)
 			    "Unexpected pc 0x%lx (expected 0x%lx)",
 			    pc, test_pc);
 
-		if ((pc + 4) == (uint64_t)&iter_ss_end) {
+		if ((pc + 4) == (u64)&iter_ss_end) {
 			test_pc = 0;
 			debug.control = KVM_GUESTDBG_ENABLE;
 			ss_enable = false;
@@ -519,8 +519,7 @@ void test_single_step_from_userspace(int test_cnt)
 		 * iter_ss_end, the pc for the next KVM_EXIT_DEBUG should
 		 * be the current pc + 4.
 		 */
-		if ((pc >= (uint64_t)&iter_ss_begin) &&
-		    (pc < (uint64_t)&iter_ss_end))
+		if (pc >= (u64)&iter_ss_begin && pc < (u64)&iter_ss_end)
 			test_pc = pc + 4;
 		else
 			test_pc = 0;
@@ -533,7 +532,7 @@ void test_single_step_from_userspace(int test_cnt)
  * Run debug testing using the various breakpoint#, watchpoint# and
  * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
  */
-void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
+void test_guest_debug_exceptions_all(u64 aa64dfr0)
 {
 	uint8_t brp_num, wrp_num, ctx_brp_num, normal_brp_num, ctx_brp_base;
 	int b, w, c;
@@ -580,7 +579,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int opt;
 	int ss_iteration = 10000;
-	uint64_t aa64dfr0;
+	u64 aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	aa64dfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 44cfcf8a7f46..53d9d86c06a4 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -29,9 +29,9 @@
 #define KVM_REG_ARM_VENDOR_HYP_BMAP_2_RESET_VAL 0
 
 struct kvm_fw_reg_info {
-	uint64_t reg;		/* Register definition */
-	uint64_t max_feat_bit;	/* Bit that represents the upper limit of the feature-map */
-	uint64_t reset_val;	/* Reset value for the register */
+	u64 reg;		/* Register definition */
+	u64 max_feat_bit;	/* Bit that represents the upper limit of the feature-map */
+	u64 reset_val;	/* Reset value for the register */
 };
 
 #define FW_REG_INFO(r)			\
@@ -60,7 +60,7 @@ static int stage = TEST_STAGE_REG_IFACE;
 
 struct test_hvc_info {
 	uint32_t func_id;
-	uint64_t arg1;
+	u64 arg1;
 };
 
 #define TEST_HVC_INFO(f, a1)	\
@@ -154,7 +154,7 @@ static void guest_code(void)
 struct st_time {
 	uint32_t rev;
 	uint32_t attr;
-	uint64_t st_time;
+	u64 st_time;
 };
 
 #define STEAL_TIME_SIZE		((sizeof(struct st_time) + 63) & ~63)
@@ -162,7 +162,7 @@ struct st_time {
 
 static void steal_time_init(struct kvm_vcpu *vcpu)
 {
-	uint64_t st_ipa = (ulong)ST_GPA_BASE;
+	u64 st_ipa = (ulong)ST_GPA_BASE;
 	unsigned int gpages;
 
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE);
@@ -174,13 +174,13 @@ static void steal_time_init(struct kvm_vcpu *vcpu)
 
 static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 {
-	uint64_t val;
+	u64 val;
 	unsigned int i;
 	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
 		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
-		uint64_t set_val;
+		u64 set_val;
 
 		/* First 'read' should be the reset value for the reg  */
 		val = vcpu_get_reg(vcpu, reg_info->reg);
@@ -229,7 +229,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 
 static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
 {
-	uint64_t val;
+	u64 val;
 	unsigned int i;
 	int ret;
 
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
index ebd70430c89d..883a98dc97e5 100644
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
@@ -11,7 +11,7 @@ static volatile bool handled;
 
 #define __check_sr_read(r)					\
 	({							\
-		uint64_t val;					\
+		u64 val;					\
 								\
 		handled = false;				\
 		dsb(sy);					\
@@ -48,7 +48,7 @@ static volatile bool handled;
 
 static void guest_code(void)
 {
-	uint64_t val;
+	u64 val;
 
 	/*
 	 * Check that we advertise that ID_AA64PFR0_EL1.GIC == 0, having
@@ -161,7 +161,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t pfr0;
+	u64 pfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index dc6559dad9d8..1c04e0f28953 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -23,7 +23,7 @@
 #define TEST_PTE_GVA				0xb0000000
 #define TEST_DATA				0x0123456789ABCDEF
 
-static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
+static u64 *guest_test_memory = (u64 *)TEST_GVA;
 
 #define CMD_NONE				(0)
 #define CMD_SKIP_TEST				(1ULL << 1)
@@ -48,7 +48,7 @@ static struct event_cnt {
 
 struct test_desc {
 	const char *name;
-	uint64_t mem_mark_cmd;
+	u64 mem_mark_cmd;
 	/* Skip the test if any prepare function returns false */
 	bool (*guest_prepare[PREPARE_FN_NR])(void);
 	void (*guest_test)(void);
@@ -70,9 +70,9 @@ struct test_params {
 	struct test_desc *test_desc;
 };
 
-static inline void flush_tlb_page(uint64_t vaddr)
+static inline void flush_tlb_page(u64 vaddr)
 {
-	uint64_t page = vaddr >> 12;
+	u64 page = vaddr >> 12;
 
 	dsb(ishst);
 	asm volatile("tlbi vaae1is, %0" :: "r" (page));
@@ -82,7 +82,7 @@ static inline void flush_tlb_page(uint64_t vaddr)
 
 static void guest_write64(void)
 {
-	uint64_t val;
+	u64 val;
 
 	WRITE_ONCE(*guest_test_memory, TEST_DATA);
 	val = READ_ONCE(*guest_test_memory);
@@ -92,8 +92,8 @@ static void guest_write64(void)
 /* Check the system for atomic instructions. */
 static bool guest_check_lse(void)
 {
-	uint64_t isar0 = read_sysreg(id_aa64isar0_el1);
-	uint64_t atomic;
+	u64 isar0 = read_sysreg(id_aa64isar0_el1);
+	u64 atomic;
 
 	atomic = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_ATOMIC), isar0);
 	return atomic >= 2;
@@ -101,8 +101,8 @@ static bool guest_check_lse(void)
 
 static bool guest_check_dc_zva(void)
 {
-	uint64_t dczid = read_sysreg(dczid_el0);
-	uint64_t dzp = FIELD_GET(ARM64_FEATURE_MASK(DCZID_EL0_DZP), dczid);
+	u64 dczid = read_sysreg(dczid_el0);
+	u64 dzp = FIELD_GET(ARM64_FEATURE_MASK(DCZID_EL0_DZP), dczid);
 
 	return dzp == 0;
 }
@@ -110,7 +110,7 @@ static bool guest_check_dc_zva(void)
 /* Compare and swap instruction. */
 static void guest_cas(void)
 {
-	uint64_t val;
+	u64 val;
 
 	GUEST_ASSERT(guest_check_lse());
 	asm volatile(".arch_extension lse\n"
@@ -122,7 +122,7 @@ static void guest_cas(void)
 
 static void guest_read64(void)
 {
-	uint64_t val;
+	u64 val;
 
 	val = READ_ONCE(*guest_test_memory);
 	GUEST_ASSERT_EQ(val, 0);
@@ -131,7 +131,7 @@ static void guest_read64(void)
 /* Address translation instruction */
 static void guest_at(void)
 {
-	uint64_t par;
+	u64 par;
 
 	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
 	isb();
@@ -164,8 +164,8 @@ static void guest_dc_zva(void)
  */
 static void guest_ld_preidx(void)
 {
-	uint64_t val;
-	uint64_t addr = TEST_GVA - 8;
+	u64 val;
+	u64 addr = TEST_GVA - 8;
 
 	/*
 	 * This ends up accessing "TEST_GVA + 8 - 8", where "TEST_GVA - 8" is
@@ -179,8 +179,8 @@ static void guest_ld_preidx(void)
 
 static void guest_st_preidx(void)
 {
-	uint64_t val = TEST_DATA;
-	uint64_t addr = TEST_GVA - 8;
+	u64 val = TEST_DATA;
+	u64 addr = TEST_GVA - 8;
 
 	asm volatile("str %0, [%1, #8]!"
 		     : "+r" (val), "+r" (addr));
@@ -191,8 +191,8 @@ static void guest_st_preidx(void)
 
 static bool guest_set_ha(void)
 {
-	uint64_t mmfr1 = read_sysreg(id_aa64mmfr1_el1);
-	uint64_t hadbs, tcr;
+	u64 mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+	u64 hadbs, tcr;
 
 	/* Skip if HA is not supported. */
 	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS), mmfr1);
@@ -208,7 +208,7 @@ static bool guest_set_ha(void)
 
 static bool guest_clear_pte_af(void)
 {
-	*((uint64_t *)TEST_PTE_GVA) &= ~PTE_AF;
+	*((u64 *)TEST_PTE_GVA) &= ~PTE_AF;
 	flush_tlb_page(TEST_GVA);
 
 	return true;
@@ -217,7 +217,7 @@ static bool guest_clear_pte_af(void)
 static void guest_check_pte_af(void)
 {
 	dsb(ish);
-	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
+	GUEST_ASSERT_EQ(*((u64 *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
 }
 
 static void guest_check_write_in_dirty_log(void)
@@ -302,26 +302,26 @@ static void no_iabt_handler(struct ex_regs *regs)
 static struct uffd_args {
 	char *copy;
 	void *hva;
-	uint64_t paging_size;
+	u64 paging_size;
 } pt_args, data_args;
 
 /* Returns true to continue the test, and false if it should be skipped. */
 static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
 				struct uffd_args *args)
 {
-	uint64_t addr = msg->arg.pagefault.address;
-	uint64_t flags = msg->arg.pagefault.flags;
+	u64 addr = msg->arg.pagefault.address;
+	u64 flags = msg->arg.pagefault.flags;
 	struct uffdio_copy copy;
 	int ret;
 
 	TEST_ASSERT(uffd_mode == UFFDIO_REGISTER_MODE_MISSING,
 		    "The only expected UFFD mode is MISSING");
-	TEST_ASSERT_EQ(addr, (uint64_t)args->hva);
+	TEST_ASSERT_EQ(addr, (u64)args->hva);
 
 	pr_debug("uffd fault: addr=%p write=%d\n",
 		 (void *)addr, !!(flags & UFFD_PAGEFAULT_FLAG_WRITE));
 
-	copy.src = (uint64_t)args->copy;
+	copy.src = (u64)args->copy;
 	copy.dst = addr;
 	copy.len = args->paging_size;
 	copy.mode = 0;
@@ -407,7 +407,7 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
 					struct userspace_mem_region *region)
 {
 	void *hva = (void *)region->region.userspace_addr;
-	uint64_t paging_size = region->region.memory_size;
+	u64 paging_size = region->region.memory_size;
 	int ret, fd = region->fd;
 
 	if (fd != -1) {
@@ -438,7 +438,7 @@ static void mmio_on_test_gpa_handler(struct kvm_vm *vm, struct kvm_run *run)
 
 static void mmio_no_handler(struct kvm_vm *vm, struct kvm_run *run)
 {
-	uint64_t data;
+	u64 data;
 
 	memcpy(&data, run->mmio.data, sizeof(data));
 	pr_debug("addr=%lld len=%d w=%d data=%lx\n",
@@ -449,11 +449,11 @@ static void mmio_no_handler(struct kvm_vm *vm, struct kvm_run *run)
 
 static bool check_write_in_dirty_log(struct kvm_vm *vm,
 				     struct userspace_mem_region *region,
-				     uint64_t host_pg_nr)
+				     u64 host_pg_nr)
 {
 	unsigned long *bmap;
 	bool first_page_dirty;
-	uint64_t size = region->region.memory_size;
+	u64 size = region->region.memory_size;
 
 	/* getpage_size() is not always equal to vm->page_size */
 	bmap = bitmap_zalloc(size / getpagesize());
@@ -468,7 +468,7 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	struct userspace_mem_region *data_region, *pt_region;
 	bool continue_test = true;
-	uint64_t pte_gpa, pte_pg;
+	u64 pte_gpa, pte_pg;
 
 	data_region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	pt_region = vm_get_mem_region(vm, MEM_REGION_PT);
@@ -525,7 +525,7 @@ noinline void __return_0x77(void)
  */
 static void load_exec_code_for_test(struct kvm_vm *vm)
 {
-	uint64_t *code;
+	u64 *code;
 	struct userspace_mem_region *region;
 	void *hva;
 
@@ -552,7 +552,7 @@ static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 static void setup_gva_maps(struct kvm_vm *vm)
 {
 	struct userspace_mem_region *region;
-	uint64_t pte_gpa;
+	u64 pte_gpa;
 
 	region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	/* Map TEST_GVA first. This will install a new PTE. */
@@ -574,12 +574,12 @@ enum pf_test_memslots {
  */
 static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 {
-	uint64_t backing_src_pagesz = get_backing_src_pagesz(p->src_type);
-	uint64_t guest_page_size = vm->page_size;
-	uint64_t max_gfn = vm_compute_max_gfn(vm);
+	u64 backing_src_pagesz = get_backing_src_pagesz(p->src_type);
+	u64 guest_page_size = vm->page_size;
+	u64 max_gfn = vm_compute_max_gfn(vm);
 	/* Enough for 2M of code when using 4K guest pages. */
-	uint64_t code_npages = 512;
-	uint64_t pt_size, data_size, data_gpa;
+	u64 code_npages = 512;
+	u64 pt_size, data_size, data_gpa;
 
 	/*
 	 * This test requires 1 pgd, 2 pud, 4 pmd, and 6 pte pages when using
diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index ab491ee9e5f7..27aa19a35256 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -22,8 +22,7 @@
 #define CPU_ON_ENTRY_ADDR 0xfeedf00dul
 #define CPU_ON_CONTEXT_ID 0xdeadc0deul
 
-static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
-			    uint64_t context_id)
+static u64 psci_cpu_on(u64 target_cpu, u64 entry_addr, u64 context_id)
 {
 	struct arm_smccc_res res;
 
@@ -33,8 +32,7 @@ static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 	return res.a0;
 }
 
-static uint64_t psci_affinity_info(uint64_t target_affinity,
-				   uint64_t lowest_affinity_level)
+static u64 psci_affinity_info(u64 target_affinity, u64 lowest_affinity_level)
 {
 	struct arm_smccc_res res;
 
@@ -44,7 +42,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
-static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
+static u64 psci_system_suspend(u64 entry_addr, u64 context_id)
 {
 	struct arm_smccc_res res;
 
@@ -54,7 +52,7 @@ static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
 	return res.a0;
 }
 
-static uint64_t psci_system_off2(uint64_t type, uint64_t cookie)
+static u64 psci_system_off2(u64 type, u64 cookie)
 {
 	struct arm_smccc_res res;
 
@@ -63,7 +61,7 @@ static uint64_t psci_system_off2(uint64_t type, uint64_t cookie)
 	return res.a0;
 }
 
-static uint64_t psci_features(uint32_t func_id)
+static u64 psci_features(uint32_t func_id)
 {
 	struct arm_smccc_res res;
 
@@ -109,7 +107,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 
 static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	uint64_t obs_pc, obs_x0;
+	u64 obs_pc, obs_x0;
 
 	obs_pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
 	obs_x0 = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.regs[0]));
@@ -122,9 +120,9 @@ static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
 		    obs_x0, CPU_ON_CONTEXT_ID);
 }
 
-static void guest_test_cpu_on(uint64_t target_cpu)
+static void guest_test_cpu_on(u64 target_cpu)
 {
-	uint64_t target_state;
+	u64 target_state;
 
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
 
@@ -141,7 +139,7 @@ static void guest_test_cpu_on(uint64_t target_cpu)
 static void host_test_cpu_on(void)
 {
 	struct kvm_vcpu *source, *target;
-	uint64_t target_mpidr;
+	u64 target_mpidr;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
@@ -165,7 +163,7 @@ static void host_test_cpu_on(void)
 
 static void guest_test_system_suspend(void)
 {
-	uint64_t ret;
+	u64 ret;
 
 	/* assert that SYSTEM_SUSPEND is discoverable */
 	GUEST_ASSERT(!psci_features(PSCI_1_0_FN_SYSTEM_SUSPEND));
@@ -199,7 +197,7 @@ static void host_test_system_suspend(void)
 
 static void guest_test_system_off2(void)
 {
-	uint64_t ret;
+	u64 ret;
 
 	/* assert that SYSTEM_OFF2 is discoverable */
 	GUEST_ASSERT(psci_features(PSCI_1_3_FN_SYSTEM_OFF2) &
@@ -237,7 +235,7 @@ static void host_test_system_off2(void)
 {
 	struct kvm_vcpu *source, *target;
 	struct kvm_mp_state mps;
-	uint64_t psci_version = 0;
+	u64 psci_version = 0;
 	int nr_shutdowns = 0;
 	struct kvm_run *run;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 322b9d3b0125..d2b689d844ae 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -31,7 +31,7 @@ struct reg_ftr_bits {
 	bool sign;
 	enum ftr_type type;
 	uint8_t shift;
-	uint64_t mask;
+	u64 mask;
 	/*
 	 * For FTR_EXACT, safe_val is used as the exact safe value.
 	 * For FTR_LOWER_SAFE, safe_val is used as the minimal safe value.
@@ -241,9 +241,9 @@ static void guest_code(void)
 }
 
 /* Return a safe value to a given ftr_bits an ftr value */
-uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
+u64 get_safe_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 {
-	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
+	u64 ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
@@ -293,14 +293,14 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 }
 
 /* Return an invalid value to a given ftr_bits an ftr value */
-uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
+u64 get_invalid_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 {
-	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
+	u64 ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
-			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
+			ftr = max((u64)ftr_bits->safe_val + 1, ftr + 1);
 			break;
 		case FTR_LOWER_SAFE:
 			ftr++;
@@ -320,7 +320,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 	} else if (ftr != ftr_max) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
-			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
+			ftr = max((u64)ftr_bits->safe_val + 1, ftr + 1);
 			break;
 		case FTR_LOWER_SAFE:
 			ftr++;
@@ -344,12 +344,12 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 	return ftr;
 }
 
-static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
-				     const struct reg_ftr_bits *ftr_bits)
+static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
+				const struct reg_ftr_bits *ftr_bits)
 {
 	uint8_t shift = ftr_bits->shift;
-	uint64_t mask = ftr_bits->mask;
-	uint64_t val, new_val, ftr;
+	u64 mask = ftr_bits->mask;
+	u64 val, new_val, ftr;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
@@ -367,12 +367,12 @@ static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
 	return new_val;
 }
 
-static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
+static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 			      const struct reg_ftr_bits *ftr_bits)
 {
 	uint8_t shift = ftr_bits->shift;
-	uint64_t mask = ftr_bits->mask;
-	uint64_t val, old_val, ftr;
+	u64 mask = ftr_bits->mask;
+	u64 val, old_val, ftr;
 	int r;
 
 	val = vcpu_get_reg(vcpu, reg);
@@ -393,7 +393,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	TEST_ASSERT_EQ(val, old_val);
 }
 
-static uint64_t test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+static u64 test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
 
 #define encoding_to_range_idx(encoding)							\
 	KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(encoding), sys_reg_Op1(encoding),	\
@@ -403,7 +403,7 @@ static uint64_t test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
 
 static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 {
-	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+	u64 masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
 	struct reg_mask_range range = {
 		.addr = (__u64)masks,
 	};
@@ -421,7 +421,7 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
 		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
 		uint32_t reg_id = test_regs[i].reg;
-		uint64_t reg = KVM_ARM64_SYS_REG(reg_id);
+		u64 reg = KVM_ARM64_SYS_REG(reg_id);
 		int idx;
 
 		/* Get the index to masks array for the idreg */
@@ -451,11 +451,11 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 #define MPAM_IDREG_TEST	6
 static void test_user_set_mpam_reg(struct kvm_vcpu *vcpu)
 {
-	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+	u64 masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
 	struct reg_mask_range range = {
 		.addr = (__u64)masks,
 	};
-	uint64_t val;
+	u64 val;
 	int idx, err;
 
 	/*
@@ -578,7 +578,7 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 
 static void test_clidr(struct kvm_vcpu *vcpu)
 {
-	uint64_t clidr;
+	u64 clidr;
 	int level;
 
 	clidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1));
@@ -646,7 +646,7 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
 static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding)
 {
 	size_t idx = encoding_to_range_idx(encoding);
-	uint64_t observed;
+	u64 observed;
 
 	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
 	TEST_ASSERT_EQ(test_reg_vals[idx], observed);
@@ -678,7 +678,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	bool aarch64_only;
-	uint64_t val, el0;
+	u64 val, el0;
 	int test_cnt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..8f13d4979dc5 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -16,7 +16,7 @@
 
 #define NR_VCPUS		4
 
-#define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
+#define REG_OFFSET(vcpu, offset) (((u64)(vcpu) << 32) | (offset))
 
 #define GICR_TYPER 0x8
 
@@ -29,7 +29,7 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static uint64_t max_phys_size;
+static u64 max_phys_size;
 
 /*
  * Helpers to access a redistributor register and verify the ioctl() failed or
@@ -102,9 +102,9 @@ static void vm_gic_destroy(struct vm_gic *v)
 }
 
 struct vgic_region_attr {
-	uint64_t attr;
-	uint64_t size;
-	uint64_t alignment;
+	u64 attr;
+	u64 size;
+	u64 alignment;
 };
 
 struct vgic_region_attr gic_v3_dist_region = {
@@ -142,7 +142,7 @@ struct vgic_region_attr gic_v2_cpu_region = {
 static void subtest_dist_rdist(struct vm_gic *v)
 {
 	int ret;
-	uint64_t addr;
+	u64 addr;
 	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
 	struct vgic_region_attr dist;
 
@@ -222,7 +222,7 @@ static void subtest_dist_rdist(struct vm_gic *v)
 /* Test the new REDIST region API */
 static void subtest_v3_redist_regions(struct vm_gic *v)
 {
-	uint64_t addr, expected_addr;
+	u64 addr, expected_addr;
 	int ret;
 
 	ret = __kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -407,7 +407,7 @@ static void test_v3_new_redist_regions(void)
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	void *dummy = NULL;
 	struct vm_gic v;
-	uint64_t addr;
+	u64 addr;
 	int ret;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
@@ -459,7 +459,7 @@ static void test_v3_new_redist_regions(void)
 static void test_v3_typer_accesses(void)
 {
 	struct vm_gic v;
-	uint64_t addr;
+	u64 addr;
 	int ret, i;
 
 	v.vm = vm_create(NR_VCPUS);
@@ -545,7 +545,7 @@ static void test_v3_last_bit_redist_regions(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
-	uint64_t addr;
+	u64 addr;
 
 	v = vm_gic_v3_create_with_vcpuids(ARRAY_SIZE(vcpuids), vcpuids);
 
@@ -579,7 +579,7 @@ static void test_v3_last_bit_single_rdist(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
-	uint64_t addr;
+	u64 addr;
 
 	v = vm_gic_v3_create_with_vcpuids(ARRAY_SIZE(vcpuids), vcpuids);
 
@@ -605,7 +605,7 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
 	int ret, i;
-	uint64_t addr;
+	u64 addr;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
 
@@ -637,7 +637,7 @@ static void test_v3_its_region(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	uint64_t addr;
+	u64 addr;
 	int its_fd, ret;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index f6b77da48785..e6f91bb293a6 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -132,7 +132,7 @@ static struct kvm_inject_desc set_active_fns[] = {
 	for_each_supported_inject_fn((args), (t), (f))
 
 /* Shared between the guest main thread and the IRQ handlers. */
-volatile uint64_t irq_handled;
+volatile u64 irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
 
 static void reset_stats(void)
@@ -144,15 +144,15 @@ static void reset_stats(void)
 		irqnr_received[i] = 0;
 }
 
-static uint64_t gic_read_ap1r0(void)
+static u64 gic_read_ap1r0(void)
 {
-	uint64_t reg = read_sysreg_s(SYS_ICC_AP1R0_EL1);
+	u64 reg = read_sysreg_s(SYS_ICC_AP1R0_EL1);
 
 	dsb(sy);
 	return reg;
 }
 
-static void gic_write_ap1r0(uint64_t val)
+static void gic_write_ap1r0(u64 val)
 {
 	write_sysreg_s(val, SYS_ICC_AP1R0_EL1);
 	isb();
@@ -555,12 +555,12 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 {
 	struct kvm_irq_routing *routing;
 	int ret;
-	uint64_t i;
+	u64 i;
 
 	assert(num <= kvm_max_routes && kvm_max_routes <= KVM_MAX_IRQ_ROUTES);
 
 	routing = kvm_gsi_routing_create();
-	for (i = intid; i < (uint64_t)intid + num; i++)
+	for (i = intid; i < (u64)intid + num; i++)
 		kvm_gsi_routing_irqchip_add(routing, i - MIN_SPI, i - MIN_SPI);
 
 	if (!expect_failure) {
@@ -568,7 +568,7 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 	} else {
 		ret = _kvm_gsi_routing_write(vm, routing);
 		/* The kernel only checks e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS */
-		if (((uint64_t)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
+		if (((u64)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
 				"error: rc: %i errno: %i", intid, ret, errno);
@@ -599,9 +599,9 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 		bool expect_failure)
 {
 	int fd[MAX_SPI];
-	uint64_t val;
+	u64 val;
 	int ret, f;
-	uint64_t i;
+	u64 i;
 
 	/*
 	 * There is no way to try injecting an SGI or PPI as the interface
@@ -620,35 +620,35 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 	 * that no actual interrupt was injected for those cases.
 	 */
 
-	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+	for (f = 0, i = intid; i < (u64)intid + num; i++, f++) {
 		fd[f] = eventfd(0, 0);
 		TEST_ASSERT(fd[f] != -1, __KVM_SYSCALL_ERROR("eventfd()", fd[f]));
 	}
 
-	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+	for (f = 0, i = intid; i < (u64)intid + num; i++, f++) {
 		struct kvm_irqfd irqfd = {
 			.fd  = fd[f],
 			.gsi = i - MIN_SPI,
 		};
-		assert(i <= (uint64_t)UINT_MAX);
+		assert(i <= (u64)UINT_MAX);
 		vm_ioctl(vm, KVM_IRQFD, &irqfd);
 	}
 
-	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+	for (f = 0, i = intid; i < (u64)intid + num; i++, f++) {
 		val = 1;
-		ret = write(fd[f], &val, sizeof(uint64_t));
-		TEST_ASSERT(ret == sizeof(uint64_t),
+		ret = write(fd[f], &val, sizeof(u64));
+		TEST_ASSERT(ret == sizeof(u64),
 			    __KVM_SYSCALL_ERROR("write()", ret));
 	}
 
-	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
+	for (f = 0, i = intid; i < (u64)intid + num; i++, f++)
 		close(fd[f]);
 }
 
 /* handles the valid case: intid=0xffffffff num=1 */
 #define for_each_intid(first, num, tmp, i)					\
 	for ((tmp) = (i) = (first);						\
-		(tmp) < (uint64_t)(first) + (uint64_t)(num);			\
+		(tmp) < (u64)(first) + (u64)(num);			\
 		(tmp)++, (i)++)
 
 static void run_guest_cmd(struct kvm_vcpu *vcpu, int gic_fd,
@@ -661,7 +661,7 @@ static void run_guest_cmd(struct kvm_vcpu *vcpu, int gic_fd,
 	int level = inject_args->level;
 	bool expect_failure = inject_args->expect_failure;
 	struct kvm_vm *vm = vcpu->vm;
-	uint64_t tmp;
+	u64 tmp;
 	uint32_t i;
 
 	/* handles the valid case: intid=0xffffffff num=1 */
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32e..986ff950a652 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -34,25 +34,25 @@ struct vpmu_vm {
 static struct vpmu_vm vpmu_vm;
 
 struct pmreg_sets {
-	uint64_t set_reg_id;
-	uint64_t clr_reg_id;
+	u64 set_reg_id;
+	u64 clr_reg_id;
 };
 
 #define PMREG_SET(set, clr) {.set_reg_id = set, .clr_reg_id = clr}
 
-static uint64_t get_pmcr_n(uint64_t pmcr)
+static u64 get_pmcr_n(u64 pmcr)
 {
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
+static void set_pmcr_n(u64 *pmcr, u64 pmcr_n)
 {
 	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
 }
 
-static uint64_t get_counters_mask(uint64_t n)
+static u64 get_counters_mask(u64 n)
 {
-	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
+	u64 mask = BIT(ARMV8_PMU_CYCLE_IDX);
 
 	if (n)
 		mask |= GENMASK(n - 1, 0);
@@ -95,7 +95,7 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 
 static void pmu_disable_reset(void)
 {
-	uint64_t pmcr = read_sysreg(pmcr_el0);
+	u64 pmcr = read_sysreg(pmcr_el0);
 
 	/* Reset all counters, disabling them */
 	pmcr &= ~ARMV8_PMU_PMCR_E;
@@ -175,7 +175,7 @@ struct pmc_accessor pmc_accessors[] = {
 
 #define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)			 \
 {										 \
-	uint64_t _tval = read_sysreg(regname);					 \
+	u64 _tval = read_sysreg(regname);					 \
 										 \
 	if (set_expected)							 \
 		__GUEST_ASSERT((_tval & mask),					 \
@@ -191,7 +191,7 @@ struct pmc_accessor pmc_accessors[] = {
  * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
  * are set or cleared as specified in @set_expected.
  */
-static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
+static void check_bitmap_pmu_regs(u64 mask, bool set_expected)
 {
 	GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
 	GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
@@ -213,7 +213,7 @@ static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
  */
 static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
 {
-	uint64_t pmcr_n, test_bit = BIT(pmc_idx);
+	u64 pmcr_n, test_bit = BIT(pmc_idx);
 	bool set_expected = false;
 
 	if (set_op) {
@@ -238,7 +238,7 @@ static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
  */
 static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 {
-	uint64_t write_data, read_data;
+	u64 write_data, read_data;
 
 	/* Disable all PMCs and reset all PMCs to zero. */
 	pmu_disable_reset();
@@ -293,11 +293,11 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 }
 
 #define INVALID_EC	(-1ul)
-uint64_t expected_ec = INVALID_EC;
+u64 expected_ec = INVALID_EC;
 
 static void guest_sync_handler(struct ex_regs *regs)
 {
-	uint64_t esr, ec;
+	u64 esr, ec;
 
 	esr = read_sysreg(esr_el1);
 	ec = ESR_ELx_EC(esr);
@@ -357,9 +357,9 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
  * if reading/writing PMU registers for implemented or unimplemented
  * counters works as expected.
  */
-static void guest_code(uint64_t expected_pmcr_n)
+static void guest_code(u64 expected_pmcr_n)
 {
-	uint64_t pmcr, pmcr_n, unimp_mask;
+	u64 pmcr, pmcr_n, unimp_mask;
 	int i, pmc;
 
 	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
@@ -409,11 +409,11 @@ static void create_vpmu_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
-	uint64_t dfr0, irq = 23;
+	u64 dfr0, irq = 23;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
 		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
-		.addr = (uint64_t)&irq,
+		.addr = (u64)&irq,
 	};
 	struct kvm_device_attr init_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -457,7 +457,7 @@ static void destroy_vpmu_vm(void)
 	kvm_vm_free(vpmu_vm.vm);
 }
 
-static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
+static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
 {
 	struct ucall uc;
 
@@ -475,10 +475,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
+static void test_create_vpmu_vm_with_pmcr_n(u64 pmcr_n, bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
-	uint64_t pmcr, pmcr_orig;
+	u64 pmcr, pmcr_orig;
 
 	create_vpmu_vm(guest_code);
 	vcpu = vpmu_vm.vcpu;
@@ -508,9 +508,9 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(uint64_t pmcr_n)
+static void run_access_test(u64 pmcr_n)
 {
-	uint64_t sp;
+	u64 sp;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
 
@@ -533,7 +533,7 @@ static void run_access_test(uint64_t pmcr_n)
 	aarch64_vcpu_setup(vcpu, &init);
 	vcpu_init_descriptor_tables(vcpu);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
-	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (u64)guest_code);
 
 	run_vcpu(vcpu, pmcr_n);
 
@@ -550,12 +550,12 @@ static struct pmreg_sets validity_check_reg_sets[] = {
  * Create a VM, and check if KVM handles the userspace accesses of
  * the PMU register sets in @validity_check_reg_sets[] correctly.
  */
-static void run_pmregs_validity_test(uint64_t pmcr_n)
+static void run_pmregs_validity_test(u64 pmcr_n)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
-	uint64_t set_reg_id, clr_reg_id, reg_val;
-	uint64_t valid_counters_mask, max_counters_mask;
+	u64 set_reg_id, clr_reg_id, reg_val;
+	u64 valid_counters_mask, max_counters_mask;
 
 	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
 	vcpu = vpmu_vm.vcpu;
@@ -607,7 +607,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(uint64_t pmcr_n)
+static void run_error_test(u64 pmcr_n)
 {
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
 
@@ -619,9 +619,9 @@ static void run_error_test(uint64_t pmcr_n)
  * Return the default number of implemented PMU event counters excluding
  * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
  */
-static uint64_t get_pmcr_n_limit(void)
+static u64 get_pmcr_n_limit(void)
 {
-	uint64_t pmcr;
+	u64 pmcr;
 
 	create_vpmu_vm(guest_code);
 	pmcr = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
@@ -631,7 +631,7 @@ static uint64_t get_pmcr_n_limit(void)
 
 int main(void)
 {
-	uint64_t i, pmcr_n;
+	u64 i, pmcr_n;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 
diff --git a/tools/testing/selftests/kvm/coalesced_io_test.c b/tools/testing/selftests/kvm/coalesced_io_test.c
index 60cb25454899..ed6a66020b1e 100644
--- a/tools/testing/selftests/kvm/coalesced_io_test.c
+++ b/tools/testing/selftests/kvm/coalesced_io_test.c
@@ -15,8 +15,8 @@
 struct kvm_coalesced_io {
 	struct kvm_coalesced_mmio_ring *ring;
 	uint32_t ring_size;
-	uint64_t mmio_gpa;
-	uint64_t *mmio;
+	u64 mmio_gpa;
+	u64 *mmio;
 
 	/*
 	 * x86-only, but define pio_port for all architectures to minimize the
@@ -94,7 +94,7 @@ static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
 
 	TEST_ASSERT((!want_pio && (run->exit_reason == KVM_EXIT_MMIO && run->mmio.is_write &&
 				   run->mmio.phys_addr == io->mmio_gpa && run->mmio.len == 8 &&
-				   *(uint64_t *)run->mmio.data == io->mmio_gpa + io->ring_size - 1)) ||
+				   *(u64 *)run->mmio.data == io->mmio_gpa + io->ring_size - 1)) ||
 		    (want_pio  && (run->exit_reason == KVM_EXIT_IO && run->io.port == io->pio_port &&
 				   run->io.direction == KVM_EXIT_IO_OUT && run->io.count == 1 &&
 				   pio_value == io->pio_port + io->ring_size - 1)),
@@ -105,7 +105,7 @@ static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
 		    want_pio ? (unsigned long long)io->pio_port : io->mmio_gpa,
 		    (want_pio ? io->pio_port : io->mmio_gpa) + io->ring_size - 1, run->exit_reason,
 		    run->exit_reason == KVM_EXIT_MMIO ? "MMIO" : run->exit_reason == KVM_EXIT_IO ? "PIO" : "other",
-		    run->mmio.phys_addr, run->mmio.is_write, run->mmio.len, *(uint64_t *)run->mmio.data,
+		    run->mmio.phys_addr, run->mmio.is_write, run->mmio.len, *(u64 *)run->mmio.data,
 		    run->io.port, run->io.direction, run->io.size, run->io.count, pio_value);
 }
 
@@ -143,7 +143,7 @@ static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
 				    "Wanted 8-byte MMIO to 0x%lx = %lx in entry %u, got %u-byte %s 0x%llx = 0x%lx",
 				    io->mmio_gpa, io->mmio_gpa + i, i,
 				    entry->len, entry->pio ? "PIO" : "MMIO",
-				    entry->phys_addr, *(uint64_t *)entry->data);
+				    entry->phys_addr, *(u64 *)entry->data);
 	}
 }
 
@@ -219,11 +219,11 @@ int main(int argc, char *argv[])
 		 * the MMIO GPA identity mapped in the guest.
 		 */
 		.mmio_gpa = 4ull * SZ_1G,
-		.mmio = (uint64_t *)(4ull * SZ_1G),
+		.mmio = (u64 *)(4ull * SZ_1G),
 		.pio_port = 0x80,
 	};
 
-	virt_map(vm, (uint64_t)kvm_builtin_io_ring.mmio, kvm_builtin_io_ring.mmio_gpa, 1);
+	virt_map(vm, (u64)kvm_builtin_io_ring.mmio, kvm_builtin_io_ring.mmio_gpa, 1);
 
 	sync_global_to_guest(vm, kvm_builtin_io_ring);
 	vcpu_args_set(vcpu, 1, &kvm_builtin_io_ring);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680..302c4923d093 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -24,7 +24,7 @@
 #ifdef __NR_userfaultfd
 
 static int nr_vcpus = 1;
-static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+static u64 guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static size_t demand_paging_size;
 static char *guest_data_prototype;
@@ -58,7 +58,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		struct uffd_msg *msg)
 {
 	pid_t tid = syscall(__NR_gettid);
-	uint64_t addr = msg->arg.pagefault.address;
+	u64 addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -68,7 +68,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 	if (uffd_mode == UFFDIO_REGISTER_MODE_MISSING) {
 		struct uffdio_copy copy;
 
-		copy.src = (uint64_t)guest_data_prototype;
+		copy.src = (u64)guest_data_prototype;
 		copy.dst = addr;
 		copy.len = demand_paging_size;
 		copy.mode = 0;
@@ -138,7 +138,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 };
 
-static void prefault_mem(void *alias, uint64_t len)
+static void prefault_mem(void *alias, u64 len)
 {
 	size_t p;
 
@@ -154,7 +154,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct memstress_vcpu_args *vcpu_args;
 	struct test_params *p = arg;
 	struct uffd_desc **uffd_descs = NULL;
-	uint64_t uffd_region_size;
+	u64 uffd_region_size;
 	struct timespec start;
 	struct timespec ts_diff;
 	double vcpu_paging_rate;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e79817bd0e29..49b85b3be8d2 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -56,7 +56,7 @@ static void arch_cleanup_vm(struct kvm_vm *vm)
 #define TEST_HOST_LOOP_N		2UL
 
 static int nr_vcpus = 1;
-static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+static u64 guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static bool run_vcpus_while_disabling_dirty_logging;
 
 /* Host variables */
@@ -69,7 +69,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
-	uint64_t pages_count = 0;
+	u64 pages_count = 0;
 	struct kvm_run *run;
 	struct timespec start;
 	struct timespec ts_diff;
@@ -125,7 +125,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 
 struct test_params {
 	unsigned long iterations;
-	uint64_t phys_offset;
+	u64 phys_offset;
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
@@ -138,9 +138,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 	unsigned long **bitmaps;
-	uint64_t guest_num_pages;
-	uint64_t host_num_pages;
-	uint64_t pages_per_slot;
+	u64 guest_num_pages;
+	u64 host_num_pages;
+	u64 pages_per_slot;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct timespec get_dirty_log_total = (struct timespec){0};
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index a7744974663b..0bc76b9439a2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -74,11 +74,11 @@
  * the host. READ/WRITE_ONCE() should also be used with anything
  * that may change.
  */
-static uint64_t host_page_size;
-static uint64_t guest_page_size;
-static uint64_t guest_num_pages;
-static uint64_t iteration;
-static uint64_t nr_writes;
+static u64 host_page_size;
+static u64 guest_page_size;
+static u64 guest_num_pages;
+static u64 iteration;
+static u64 nr_writes;
 static bool vcpu_stop;
 
 /*
@@ -86,13 +86,13 @@ static bool vcpu_stop;
  * This will be set to the topmost valid physical address minus
  * the test memory size.
  */
-static uint64_t guest_test_phys_mem;
+static u64 guest_test_phys_mem;
 
 /*
  * Guest virtual memory offset of the testing memory slot.
  * Must not conflict with identity mapped test code.
  */
-static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+static u64 guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
 /*
  * Continuously write to the first 8 bytes of a random pages within
@@ -100,10 +100,10 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
  */
 static void guest_code(void)
 {
-	uint64_t addr;
+	u64 addr;
 
 #ifdef __s390x__
-	uint64_t i;
+	u64 i;
 
 	/*
 	 * On s390x, all pages of a 1M segment are initially marked as dirty
@@ -113,7 +113,7 @@ static void guest_code(void)
 	 */
 	for (i = 0; i < guest_num_pages; i++) {
 		addr = guest_test_virt_mem + i * guest_page_size;
-		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
+		vcpu_arch_put_guest(*(u64 *)addr, READ_ONCE(iteration));
 		nr_writes++;
 	}
 #endif
@@ -125,7 +125,7 @@ static void guest_code(void)
 				* guest_page_size;
 			addr = align_down(addr, host_page_size);
 
-			vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
+			vcpu_arch_put_guest(*(u64 *)addr, READ_ONCE(iteration));
 			nr_writes++;
 		}
 
@@ -138,11 +138,11 @@ static bool host_quit;
 
 /* Points to the test VM memory region on which we track dirty logs */
 static void *host_test_mem;
-static uint64_t host_num_pages;
+static u64 host_num_pages;
 
 /* For statistics only */
-static uint64_t host_dirty_count;
-static uint64_t host_clear_count;
+static u64 host_dirty_count;
+static u64 host_clear_count;
 
 /* Whether dirty ring reset is requested, or finished */
 static sem_t sem_vcpu_stop;
@@ -169,7 +169,7 @@ static bool dirty_ring_vcpu_ring_full;
  * dirty gfn we've collected, so that if a mismatch of data found later in the
  * verifying process, we let it pass.
  */
-static uint64_t dirty_ring_last_page = -1ULL;
+static u64 dirty_ring_last_page = -1ULL;
 
 /*
  * In addition to the above, it is possible (especially if this
@@ -213,7 +213,7 @@ static uint64_t dirty_ring_last_page = -1ULL;
  * and also don't fail when it is reported in the next iteration, together with
  * an outdated iteration count.
  */
-static uint64_t dirty_ring_prev_iteration_last_page;
+static u64 dirty_ring_prev_iteration_last_page;
 
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
@@ -297,7 +297,7 @@ static bool dirty_ring_supported(void)
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 {
-	uint64_t pages;
+	u64 pages;
 	uint32_t limit;
 
 	/*
@@ -494,11 +494,11 @@ static void *vcpu_worker(void *data)
 
 static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 {
-	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
-	uint64_t step = vm_num_host_pages(mode, 1);
+	u64 page, nr_dirty_pages = 0, nr_clean_pages = 0;
+	u64 step = vm_num_host_pages(mode, 1);
 
 	for (page = 0; page < host_num_pages; page += step) {
-		uint64_t val = *(uint64_t *)(host_test_mem + page * host_page_size);
+		u64 val = *(u64 *)(host_test_mem + page * host_page_size);
 		bool bmap0_dirty = __test_and_clear_bit_le(page, bmap[0]);
 
 		/*
@@ -575,7 +575,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 }
 
 static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
-				uint64_t extra_mem_pages, void *guest_code)
+				u64 extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
 
@@ -591,7 +591,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 struct test_params {
 	unsigned long iterations;
 	unsigned long interval;
-	uint64_t phys_offset;
+	u64 phys_offset;
 };
 
 static void run_test(enum vm_guest_mode mode, void *arg)
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..8b3454d373cc 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -123,7 +123,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	size_t page_size = getpagesize();
-	uint64_t flag;
+	u64 flag;
 	size_t size;
 	int fd;
 
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index bcf582852db9..894ef7d2481e 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -16,9 +16,9 @@
 #include "ucall_common.h"
 
 struct guest_vals {
-	uint64_t a;
-	uint64_t b;
-	uint64_t type;
+	u64 a;
+	u64 b;
+	u64 type;
 };
 
 static struct guest_vals vals;
@@ -26,9 +26,9 @@ static struct guest_vals vals;
 /* GUEST_PRINTF()/GUEST_ASSERT_FMT() does not support float or double. */
 #define TYPE_LIST					\
 TYPE(test_type_i64,  I64,  "%ld",   int64_t)		\
-TYPE(test_type_u64,  U64u, "%lu",   uint64_t)		\
-TYPE(test_type_x64,  U64x, "0x%lx", uint64_t)		\
-TYPE(test_type_X64,  U64X, "0x%lX", uint64_t)		\
+TYPE(test_type_u64,  U64u, "%lu",   u64)		\
+TYPE(test_type_x64,  U64x, "0x%lx", u64)		\
+TYPE(test_type_X64,  U64X, "0x%lX", u64)		\
 TYPE(test_type_u32,  U32u, "%u",    uint32_t)		\
 TYPE(test_type_x32,  U32x, "0x%x",  uint32_t)		\
 TYPE(test_type_X32,  U32X, "0x%X",  uint32_t)		\
@@ -56,7 +56,7 @@ static void fn(struct kvm_vcpu *vcpu, T a, T b)				     \
 									     \
 	snprintf(expected_printf, UCALL_BUFFER_LEN, PRINTF_FMT_##ext, a, b); \
 	snprintf(expected_assert, UCALL_BUFFER_LEN, ASSERT_FMT_##ext, a, b); \
-	vals = (struct guest_vals){ (uint64_t)a, (uint64_t)b, TYPE_##ext };  \
+	vals = (struct guest_vals){ (u64)a, (u64)b, TYPE_##ext };  \
 	sync_global_to_guest(vcpu->vm, vals);				     \
 	run_test(vcpu, expected_printf, expected_assert);		     \
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index bf461de34785..cdb34e8a4416 100644
--- a/tools/testing/selftests/kvm/include/arm64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
@@ -18,20 +18,20 @@ enum arch_timer {
 #define CTL_ISTATUS	(1 << 2)
 
 #define msec_to_cycles(msec)	\
-	(timer_get_cntfrq() * (uint64_t)(msec) / 1000)
+	(timer_get_cntfrq() * (u64)(msec) / 1000)
 
 #define usec_to_cycles(usec)	\
-	(timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
+	(timer_get_cntfrq() * (u64)(usec) / 1000000)
 
 #define cycles_to_usec(cycles) \
-	((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
+	((u64)(cycles) * 1000000 / timer_get_cntfrq())
 
 static inline uint32_t timer_get_cntfrq(void)
 {
 	return read_sysreg(cntfrq_el0);
 }
 
-static inline uint64_t timer_get_cntct(enum arch_timer timer)
+static inline u64 timer_get_cntct(enum arch_timer timer)
 {
 	isb();
 
@@ -48,7 +48,7 @@ static inline uint64_t timer_get_cntct(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
+static inline void timer_set_cval(enum arch_timer timer, u64 cval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -64,7 +64,7 @@ static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
 	isb();
 }
 
-static inline uint64_t timer_get_cval(enum arch_timer timer)
+static inline u64 timer_get_cval(enum arch_timer timer)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -144,8 +144,8 @@ static inline uint32_t timer_get_ctl(enum arch_timer timer)
 
 static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
 {
-	uint64_t now_ct = timer_get_cntct(timer);
-	uint64_t next_ct = now_ct + msec_to_cycles(msec);
+	u64 now_ct = timer_get_cntct(timer);
+	u64 next_ct = now_ct + msec_to_cycles(msec);
 
 	timer_set_cval(timer, next_ct);
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/delay.h b/tools/testing/selftests/kvm/include/arm64/delay.h
index 329e4f5079ea..6a5d4634af2c 100644
--- a/tools/testing/selftests/kvm/include/arm64/delay.h
+++ b/tools/testing/selftests/kvm/include/arm64/delay.h
@@ -8,10 +8,10 @@
 
 #include "arch_timer.h"
 
-static inline void __delay(uint64_t cycles)
+static inline void __delay(u64 cycles)
 {
 	enum arch_timer timer = VIRTUAL;
-	uint64_t start = timer_get_cntct(timer);
+	u64 start = timer_get_cntct(timer);
 
 	while ((timer_get_cntct(timer) - start) < cycles)
 		cpu_relax();
diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index 7dbecc6daa4e..8231cad8554e 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -48,7 +48,7 @@ void gic_set_dir(unsigned int intid);
  * split is true, EOI drops the priority and deactivates the interrupt.
  */
 void gic_set_eoi_split(bool split);
-void gic_set_priority_mask(uint64_t mask);
+void gic_set_priority_mask(u64 mask);
 void gic_set_priority(uint32_t intid, uint32_t prio);
 void gic_irq_set_active(unsigned int intid);
 void gic_irq_clear_active(unsigned int intid);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 68b692e1cc32..4d8144a0e025 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -175,7 +175,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva);
+u64 *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva);
 
 static inline void cpu_relax(void)
 {
@@ -272,9 +272,9 @@ struct arm_smccc_res {
  * @res: pointer to write the return values from registers x0-x3
  *
  */
-void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
-	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
-	       uint64_t arg6, struct arm_smccc_res *res);
+void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
+	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
+	       u64 arg6, struct arm_smccc_res *res);
 
 /**
  * smccc_smc - Invoke a SMCCC function using the smc conduit
@@ -283,9 +283,9 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
  * @res: pointer to write the return values from registers x0-x3
  *
  */
-void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
-	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
-	       uint64_t arg6, struct arm_smccc_res *res);
+void smccc_smc(uint32_t function_id, u64 arg0, u64 arg1,
+	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
+	       u64 arg6, struct arm_smccc_res *res);
 
 /* Execute a Wait For Interrupt instruction. */
 void wfi(void);
diff --git a/tools/testing/selftests/kvm/include/arm64/vgic.h b/tools/testing/selftests/kvm/include/arm64/vgic.h
index c481d0c00a5d..e88190d49c3d 100644
--- a/tools/testing/selftests/kvm/include/arm64/vgic.h
+++ b/tools/testing/selftests/kvm/include/arm64/vgic.h
@@ -11,9 +11,9 @@
 #include "kvm_util.h"
 
 #define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
-	(((uint64_t)(count) << 52) | \
-	((uint64_t)((base) >> 16) << 16) | \
-	((uint64_t)(flags) << 12) | \
+	(((u64)(count) << 52) | \
+	((u64)((base) >> 16) << 16) | \
+	((u64)(flags) << 12) | \
 	index)
 
 int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 67ac59f66b6e..816c4199c168 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -91,7 +91,7 @@ struct kvm_vm {
 	unsigned int page_shift;
 	unsigned int pa_bits;
 	unsigned int va_bits;
-	uint64_t max_gfn;
+	u64 max_gfn;
 	struct list_head vcpus;
 	struct userspace_mem_regions regions;
 	struct sparsebit *vpages_valid;
@@ -102,7 +102,7 @@ struct kvm_vm {
 	gpa_t pgd;
 	gva_t handlers;
 	uint32_t dirty_ring_size;
-	uint64_t gpa_tag_mask;
+	u64 gpa_tag_mask;
 
 	struct kvm_vm_arch arch;
 
@@ -188,7 +188,7 @@ struct vm_shape {
 	uint16_t pad1;
 };
 
-kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
+kvm_static_assert(sizeof(struct vm_shape) == sizeof(u64));
 
 #define VM_TYPE_DEFAULT			0
 
@@ -365,21 +365,22 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
-static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
+static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
 
 	return __vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
-static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
+
+static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
 
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
-static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
-					    uint64_t size, uint64_t attributes)
+static inline void vm_set_memory_attributes(struct kvm_vm *vm, u64 gpa,
+					    u64 size, u64 attributes)
 {
 	struct kvm_memory_attributes attr = {
 		.attributes = attributes,
@@ -399,29 +400,25 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 }
 
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
-				      uint64_t size)
+static inline void vm_mem_set_private(struct kvm_vm *vm, u64 gpa, u64 size)
 {
 	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
-static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
-				     uint64_t size)
+static inline void vm_mem_set_shared(struct kvm_vm *vm, u64 gpa, u64 size)
 {
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
-void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
+void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 gpa, u64 size,
 			    bool punch_hole);
 
-static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, uint64_t gpa,
-					   uint64_t size)
+static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, u64 gpa, u64 size)
 {
 	vm_guest_mem_fallocate(vm, gpa, size, true);
 }
 
-static inline void vm_guest_mem_allocate(struct kvm_vm *vm, uint64_t gpa,
-					 uint64_t size)
+static inline void vm_guest_mem_allocate(struct kvm_vm *vm, u64 gpa, u64 size)
 {
 	vm_guest_mem_fallocate(vm, gpa, size, false);
 }
@@ -445,7 +442,7 @@ static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 }
 
 static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-					  uint64_t first_page, uint32_t num_pages)
+					  u64 first_page, uint32_t num_pages)
 {
 	struct kvm_clear_dirty_log args = {
 		.dirty_bitmap = log,
@@ -463,8 +460,8 @@ static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
 }
 
 static inline void kvm_vm_register_coalesced_io(struct kvm_vm *vm,
-						uint64_t address,
-						uint64_t size, bool pio)
+						u64 address,
+						u64 size, bool pio)
 {
 	struct kvm_coalesced_mmio_zone zone = {
 		.addr = address,
@@ -476,8 +473,8 @@ static inline void kvm_vm_register_coalesced_io(struct kvm_vm *vm,
 }
 
 static inline void kvm_vm_unregister_coalesced_io(struct kvm_vm *vm,
-						  uint64_t address,
-						  uint64_t size, bool pio)
+						  u64 address,
+						  u64 size, bool pio)
 {
 	struct kvm_coalesced_mmio_zone zone = {
 		.addr = address,
@@ -532,15 +529,15 @@ static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc
 }
 
 void read_stat_data(int stats_fd, struct kvm_stats_header *header,
-		    struct kvm_stats_desc *desc, uint64_t *data,
+		    struct kvm_stats_desc *desc, u64 *data,
 		    size_t max_elements);
 
 void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
-		  uint64_t *data, size_t max_elements);
+		  u64 *data, size_t max_elements);
 
 #define __get_stat(stats, stat)							\
 ({										\
-	uint64_t data;								\
+	u64 data;								\
 										\
 	kvm_get_stat(stats, #stat, &data, 1);					\
 	data;									\
@@ -551,8 +548,7 @@ void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
-static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
-					uint64_t flags)
+static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size, u64 flags)
 {
 	struct kvm_create_guest_memfd guest_memfd = {
 		.size = size,
@@ -562,8 +558,7 @@ static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
 	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
 }
 
-static inline int vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
-					uint64_t flags)
+static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size, u64 flags)
 {
 	int fd = __vm_create_guest_memfd(vm, size, flags);
 
@@ -572,23 +567,23 @@ static inline int vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
 }
 
 void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-			       uint64_t gpa, uint64_t size, void *hva);
+			       u64 gpa, u64 size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva);
+				u64 gpa, u64 size, void *hva);
 void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset);
+				u64 gpa, u64 size, void *hva,
+				uint32_t guest_memfd, u64 guest_memfd_offset);
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
+				 u64 gpa, u64 size, void *hva,
+				 uint32_t guest_memfd, u64 guest_memfd_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
-	enum vm_mem_backing_src_type src_type,
-	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-	uint32_t flags);
+				 enum vm_mem_backing_src_type src_type,
+				 u64 guest_paddr, uint32_t slot, u64 npages,
+				 uint32_t flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
+		u64 guest_paddr, uint32_t slot, u64 npages,
+		uint32_t flags, int guest_memfd_fd, u64 guest_memfd_offset);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -598,7 +593,7 @@ static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
 #endif
 
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
+void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, u64 new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
@@ -614,7 +609,7 @@ gva_t __gva_alloc_page(struct kvm_vm *vm,
 		       enum kvm_mem_region_type type);
 gva_t gva_alloc_page(struct kvm_vm *vm);
 
-void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+void virt_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
@@ -642,7 +637,7 @@ void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
 
 static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
-				   uint64_t arg0)
+				   u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
 
@@ -697,31 +692,34 @@ static inline void vcpu_fpu_set(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	vcpu_ioctl(vcpu, KVM_SET_FPU, fpu);
 }
 
-static inline int __vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
+static inline int __vcpu_get_reg(struct kvm_vcpu *vcpu, u64 id, void *addr)
 {
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
+	struct kvm_one_reg reg = { .id = id, .addr = (u64)addr };
 
 	return __vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 }
-static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
+
+static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, u64 id, u64 val)
 {
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
+	struct kvm_one_reg reg = { .id = id, .addr = (u64)&val };
 
 	return __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
-static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
+
+static inline u64 vcpu_get_reg(struct kvm_vcpu *vcpu, u64 id)
 {
-	uint64_t val;
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
+	u64 val;
+	struct kvm_one_reg reg = { .id = id, .addr = (u64)&val };
 
 	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
 
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 	return val;
 }
-static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
+
+static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u64 id, u64 val)
 {
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
+	struct kvm_one_reg reg = { .id = id, .addr = (u64)&val };
 
 	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
 
@@ -766,29 +764,29 @@ static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
-int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
+int __kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr);
 
-static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
+static inline void kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr)
 {
 	int ret = __kvm_has_device_attr(dev_fd, group, attr);
 
 	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 }
 
-int __kvm_device_attr_get(int dev_fd, uint32_t group, uint64_t attr, void *val);
+int __kvm_device_attr_get(int dev_fd, uint32_t group, u64 attr, void *val);
 
 static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
-				       uint64_t attr, void *val)
+				       u64 attr, void *val)
 {
 	int ret = __kvm_device_attr_get(dev_fd, group, attr, val);
 
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
 }
 
-int __kvm_device_attr_set(int dev_fd, uint32_t group, uint64_t attr, void *val);
+int __kvm_device_attr_set(int dev_fd, uint32_t group, u64 attr, void *val);
 
 static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
-				       uint64_t attr, void *val)
+				       u64 attr, void *val)
 {
 	int ret = __kvm_device_attr_set(dev_fd, group, attr, val);
 
@@ -796,45 +794,45 @@ static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
 }
 
 static inline int __vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr)
+					 u64 attr)
 {
 	return __kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
 static inline void vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr)
+					u64 attr)
 {
 	kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
 static inline int __vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr, void *val)
+					 u64 attr, void *val)
 {
 	return __kvm_device_attr_get(vcpu->fd, group, attr, val);
 }
 
 static inline void vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr, void *val)
+					u64 attr, void *val)
 {
 	kvm_device_attr_get(vcpu->fd, group, attr, val);
 }
 
 static inline int __vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr, void *val)
+					 u64 attr, void *val)
 {
 	return __kvm_device_attr_set(vcpu->fd, group, attr, val);
 }
 
 static inline void vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr, void *val)
+					u64 attr, void *val)
 {
 	kvm_device_attr_set(vcpu->fd, group, attr, val);
 }
 
-int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
+int __kvm_test_create_device(struct kvm_vm *vm, u64 type);
+int __kvm_create_device(struct kvm_vm *vm, u64 type);
 
-static inline int kvm_create_device(struct kvm_vm *vm, uint64_t type)
+static inline int kvm_create_device(struct kvm_vm *vm, u64 type)
 {
 	int fd = __kvm_create_device(vm, type);
 
@@ -850,7 +848,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  * Input Args:
  *   vm - Virtual Machine
  *   num - number of arguments
- *   ... - arguments, each of type uint64_t
+ *   ... - arguments, each of type u64
  *
  * Output Args: None
  *
@@ -858,7 +856,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  *
  * Sets the first @num input parameters for the function at @vcpu's entry point,
  * per the C calling convention of the architecture, to the values given as
- * variable args. Each of the variable args is expected to be of type uint64_t.
+ * variable args. Each of the variable args is expected to be of type u64.
  * The maximum @num can be is specific to the architecture.
  */
 void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...);
@@ -902,7 +900,7 @@ static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
  */
 struct kvm_vm *____vm_create(struct vm_shape shape);
 struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
-			   uint64_t nr_extra_pages);
+			   u64 nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
@@ -925,7 +923,7 @@ static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 }
 
 struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages,
+				      u64 extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
 static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
@@ -939,7 +937,7 @@ static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
 
 struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
 					       struct kvm_vcpu **vcpu,
-					       uint64_t extra_mem_pages,
+					       u64 extra_mem_pages,
 					       void *guest_code);
 
 /*
@@ -947,7 +945,7 @@ struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
  * additional pages of guest memory.  Returns the VM and vCPU (via out param).
  */
 static inline struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-						       uint64_t extra_mem_pages,
+						       u64 extra_mem_pages,
 						       void *guest_code)
 {
 	return __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, vcpu,
@@ -1080,9 +1078,9 @@ static inline void virt_pgd_alloc(struct kvm_vm *vm)
  * Within @vm, creates a virtual translation for the page starting
  * at @vaddr to the page starting at @paddr.
  */
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
+void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr);
 
-static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+static inline void virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 {
 	virt_arch_pg_map(vm, vaddr, paddr);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index 224a29cea790..34f610ecd670 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -14,7 +14,7 @@
 #define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
-typedef uint64_t gpa_t; /* Virtual Machine (Guest) physical address */
-typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
+typedef u64 gpa_t; /* Virtual Machine (Guest) physical address */
+typedef u64 gva_t; /* Virtual Machine (Guest) virtual address */
 
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 9071eb6dea60..71296909302c 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -20,9 +20,9 @@
 #define MEMSTRESS_MEM_SLOT_INDEX	1
 
 struct memstress_vcpu_args {
-	uint64_t gpa;
-	uint64_t gva;
-	uint64_t pages;
+	u64 gpa;
+	u64 gva;
+	u64 pages;
 
 	/* Only used by the host userspace part of the vCPU thread */
 	struct kvm_vcpu *vcpu;
@@ -32,9 +32,9 @@ struct memstress_vcpu_args {
 struct memstress_args {
 	struct kvm_vm *vm;
 	/* The starting address and size of the guest test region. */
-	uint64_t gpa;
-	uint64_t size;
-	uint64_t guest_page_size;
+	u64 gpa;
+	u64 size;
+	u64 guest_page_size;
 	uint32_t random_seed;
 	uint32_t write_percent;
 
@@ -56,7 +56,7 @@ struct memstress_args {
 extern struct memstress_args memstress_args;
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   u64 vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
@@ -68,15 +68,15 @@ void memstress_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct memstress_vc
 void memstress_join_vcpu_threads(int vcpus);
 void memstress_guest_code(uint32_t vcpu_id);
 
-uint64_t memstress_nested_pages(int nr_vcpus);
+u64 memstress_nested_pages(int nr_vcpus);
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
 void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots);
 void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots);
 void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots);
 void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
-			       int slots, uint64_t pages_per_slot);
-unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot);
+			       int slots, u64 pages_per_slot);
+unsigned long **memstress_alloc_bitmaps(int slots, u64 pages_per_slot);
 void memstress_free_bitmaps(unsigned long *bitmaps[], int slots);
 
 #endif /* SELFTEST_KVM_MEMSTRESS_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/arch_timer.h b/tools/testing/selftests/kvm/include/riscv/arch_timer.h
index 225d81dad064..66ed7e36a7cb 100644
--- a/tools/testing/selftests/kvm/include/riscv/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/riscv/arch_timer.h
@@ -14,25 +14,25 @@
 static unsigned long timer_freq;
 
 #define msec_to_cycles(msec)	\
-	((timer_freq) * (uint64_t)(msec) / 1000)
+	((timer_freq) * (u64)(msec) / 1000)
 
 #define usec_to_cycles(usec)	\
-	((timer_freq) * (uint64_t)(usec) / 1000000)
+	((timer_freq) * (u64)(usec) / 1000000)
 
 #define cycles_to_usec(cycles) \
-	((uint64_t)(cycles) * 1000000 / (timer_freq))
+	((u64)(cycles) * 1000000 / (timer_freq))
 
-static inline uint64_t timer_get_cycles(void)
+static inline u64 timer_get_cycles(void)
 {
 	return csr_read(CSR_TIME);
 }
 
-static inline void timer_set_cmp(uint64_t cval)
+static inline void timer_set_cmp(u64 cval)
 {
 	csr_write(CSR_STIMECMP, cval);
 }
 
-static inline uint64_t timer_get_cmp(void)
+static inline u64 timer_get_cmp(void)
 {
 	return csr_read(CSR_STIMECMP);
 }
@@ -49,15 +49,15 @@ static inline void timer_irq_disable(void)
 
 static inline void timer_set_next_cmp_ms(uint32_t msec)
 {
-	uint64_t now_ct = timer_get_cycles();
-	uint64_t next_ct = now_ct + msec_to_cycles(msec);
+	u64 now_ct = timer_get_cycles();
+	u64 next_ct = now_ct + msec_to_cycles(msec);
 
 	timer_set_cmp(next_ct);
 }
 
-static inline void __delay(uint64_t cycles)
+static inline void __delay(u64 cycles)
 {
-	uint64_t start = timer_get_cycles();
+	u64 start = timer_get_cycles();
 
 	while ((timer_get_cycles() - start) < cycles)
 		cpu_relax();
diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index 5f389166338c..f877b8b2571e 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -11,8 +11,7 @@
 #include <asm/csr.h>
 #include "kvm_util.h"
 
-static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t subtype,
-				    uint64_t idx, uint64_t size)
+static inline u64 __kvm_reg_id(u64 type, u64 subtype, u64 idx, u64 size)
 {
 	return KVM_REG_RISCV | type | subtype | idx | size;
 }
@@ -48,14 +47,14 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t subtype,
 						     KVM_REG_RISCV_SBI_SINGLE,		\
 						     idx, KVM_REG_SIZE_ULONG)
 
-bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
+bool __vcpu_has_ext(struct kvm_vcpu *vcpu, u64 ext);
 
-static inline bool __vcpu_has_isa_ext(struct kvm_vcpu *vcpu, uint64_t isa_ext)
+static inline bool __vcpu_has_isa_ext(struct kvm_vcpu *vcpu, u64 isa_ext)
 {
 	return __vcpu_has_ext(vcpu, RISCV_ISA_EXT_REG(isa_ext));
 }
 
-static inline bool __vcpu_has_sbi_ext(struct kvm_vcpu *vcpu, uint64_t sbi_ext)
+static inline bool __vcpu_has_sbi_ext(struct kvm_vcpu *vcpu, u64 sbi_ext)
 {
 	return __vcpu_has_ext(vcpu, RISCV_SBI_EXT_REG(sbi_ext));
 }
diff --git a/tools/testing/selftests/kvm/include/s390/diag318_test_handler.h b/tools/testing/selftests/kvm/include/s390/diag318_test_handler.h
index b0ed71302722..6deaf18fec22 100644
--- a/tools/testing/selftests/kvm/include/s390/diag318_test_handler.h
+++ b/tools/testing/selftests/kvm/include/s390/diag318_test_handler.h
@@ -8,6 +8,6 @@
 #ifndef SELFTEST_KVM_DIAG318_TEST_HANDLER
 #define SELFTEST_KVM_DIAG318_TEST_HANDLER
 
-uint64_t get_diag318_info(void);
+u64 get_diag318_info(void);
 
 #endif
diff --git a/tools/testing/selftests/kvm/include/s390/facility.h b/tools/testing/selftests/kvm/include/s390/facility.h
index 00a1ced6538b..41a265742666 100644
--- a/tools/testing/selftests/kvm/include/s390/facility.h
+++ b/tools/testing/selftests/kvm/include/s390/facility.h
@@ -16,7 +16,7 @@
 /* alt_stfle_fac_list[16] + stfle_fac_list[16] */
 #define NB_STFL_DOUBLEWORDS 32
 
-extern uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
+extern u64 stfl_doublewords[NB_STFL_DOUBLEWORDS];
 extern bool stfle_flag;
 
 static inline bool test_bit_inv(unsigned long nr, const unsigned long *ptr)
@@ -24,7 +24,7 @@ static inline bool test_bit_inv(unsigned long nr, const unsigned long *ptr)
 	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
 }
 
-static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
+static inline void stfle(u64 *fac, unsigned int nb_doublewords)
 {
 	register unsigned long r0 asm("0") = nb_doublewords - 1;
 
diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index bc760761e1a3..e027e5790946 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -6,7 +6,7 @@
  *
  * Header file that describes API to the sparsebit library.
  * This library provides a memory efficient means of storing
- * the settings of bits indexed via a uint64_t.  Memory usage
+ * the settings of bits indexed via a u64.  Memory usage
  * is reasonable, significantly less than (2^64 / 8) bytes, as
  * long as bits that are mostly set or mostly cleared are close
  * to each other.  This library is efficient in memory usage
@@ -25,8 +25,8 @@ extern "C" {
 #endif
 
 struct sparsebit;
-typedef uint64_t sparsebit_idx_t;
-typedef uint64_t sparsebit_num_t;
+typedef u64 sparsebit_idx_t;
+typedef u64 sparsebit_num_t;
 
 struct sparsebit *sparsebit_alloc(void);
 void sparsebit_free(struct sparsebit **sbitp);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 77d13d7920cb..7cd539776533 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -20,6 +20,8 @@
 #include <sys/mman.h>
 #include "kselftest.h"
 
+#include <linux/types.h>
+
 #define msecs_to_usecs(msec)    ((msec) * 1000ULL)
 
 static inline __printf(1, 2) int _no_printf(const char *format, ...) { return 0; }
@@ -108,9 +110,9 @@ static inline bool guest_random_bool(struct guest_random_state *state)
 	return __guest_random_bool(state, 50);
 }
 
-static inline uint64_t guest_random_u64(struct guest_random_state *state)
+static inline u64 guest_random_u64(struct guest_random_state *state)
 {
-	return ((uint64_t)guest_random_u32(state) << 32) | guest_random_u32(state);
+	return ((u64)guest_random_u32(state) << 32) | guest_random_u32(state);
 }
 
 enum vm_mem_backing_src_type {
@@ -169,18 +171,18 @@ static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type t)
 }
 
 /* Aligns x up to the next multiple of size. Size must be a power of 2. */
-static inline uint64_t align_up(uint64_t x, uint64_t size)
+static inline u64 align_up(u64 x, u64 size)
 {
-	uint64_t mask = size - 1;
+	u64 mask = size - 1;
 
 	TEST_ASSERT(size != 0 && !(size & (size - 1)),
 		    "size not a power of 2: %lu", size);
 	return ((x + mask) & ~mask);
 }
 
-static inline uint64_t align_down(uint64_t x, uint64_t size)
+static inline u64 align_down(u64 x, u64 size)
 {
-	uint64_t x_aligned_up = align_up(x, size);
+	u64 x_aligned_up = align_up(x, size);
 
 	if (x == x_aligned_up)
 		return x;
diff --git a/tools/testing/selftests/kvm/include/timer_test.h b/tools/testing/selftests/kvm/include/timer_test.h
index 9b6edaafe6d4..9501c6c825e2 100644
--- a/tools/testing/selftests/kvm/include/timer_test.h
+++ b/tools/testing/selftests/kvm/include/timer_test.h
@@ -24,15 +24,15 @@ struct test_args {
 	uint32_t migration_freq_ms;
 	uint32_t timer_err_margin_us;
 	/* Members of struct kvm_arm_counter_offset */
-	uint64_t counter_offset;
-	uint64_t reserved;
+	u64 counter_offset;
+	u64 reserved;
 };
 
 /* Shared variables between host and guest */
 struct test_vcpu_shared_data {
 	uint32_t nr_iter;
 	int guest_stage;
-	uint64_t xcnt;
+	u64 xcnt;
 };
 
 extern struct test_args test_args;
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1db399c00d02..cbdcb0a50c4f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -21,8 +21,8 @@ enum {
 #define UCALL_BUFFER_LEN 1024
 
 struct ucall {
-	uint64_t cmd;
-	uint64_t args[UCALL_MAX_ARGS];
+	u64 cmd;
+	u64 args[UCALL_MAX_ARGS];
 	char buffer[UCALL_BUFFER_LEN];
 
 	/* Host virtual address of this struct. */
@@ -33,14 +33,14 @@ void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
-void ucall(uint64_t cmd, int nargs, ...);
-__printf(2, 3) void ucall_fmt(uint64_t cmd, const char *fmt, ...);
-__printf(5, 6) void ucall_assert(uint64_t cmd, const char *exp,
+void ucall(u64 cmd, int nargs, ...);
+__printf(2, 3) void ucall_fmt(u64 cmd, const char *fmt, ...);
+__printf(5, 6) void ucall_assert(u64 cmd, const char *exp,
 				 const char *file, unsigned int line,
 				 const char *fmt, ...);
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
+u64 get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa);
-int ucall_nr_pages_required(uint64_t page_size);
+int ucall_nr_pages_required(u64 page_size);
 
 /*
  * Perform userspace call without any associated data.  This bare call avoids
diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 60f7f9d435dc..0bc1dc16600e 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -25,7 +25,7 @@ struct uffd_reader_args {
 
 struct uffd_desc {
 	int uffd;
-	uint64_t num_readers;
+	u64 num_readers;
 	/* Holds the write ends of the pipes for killing the readers. */
 	int *pipefds;
 	pthread_t *readers;
@@ -33,8 +33,8 @@ struct uffd_desc {
 };
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
-					   void *hva, uint64_t len,
-					   uint64_t num_readers,
+					   void *hva, u64 len,
+					   u64 num_readers,
 					   uffd_handler_t handler);
 
 void uffd_stop_demand_paging(struct uffd_desc *uffd);
diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 80fe9f69b38d..484e9a234346 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -87,17 +87,17 @@ static inline void xapic_write_reg(unsigned int reg, uint32_t val)
 	((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2] = val;
 }
 
-static inline uint64_t x2apic_read_reg(unsigned int reg)
+static inline u64 x2apic_read_reg(unsigned int reg)
 {
 	return rdmsr(APIC_BASE_MSR + (reg >> 4));
 }
 
-static inline uint8_t x2apic_write_reg_safe(unsigned int reg, uint64_t value)
+static inline uint8_t x2apic_write_reg_safe(unsigned int reg, u64 value)
 {
 	return wrmsr_safe(APIC_BASE_MSR + (reg >> 4), value);
 }
 
-static inline void x2apic_write_reg(unsigned int reg, uint64_t value)
+static inline void x2apic_write_reg(unsigned int reg, u64 value)
 {
 	uint8_t fault = x2apic_write_reg_safe(reg, value);
 
@@ -105,7 +105,7 @@ static inline void x2apic_write_reg(unsigned int reg, uint64_t value)
 		       fault, APIC_BASE_MSR + (reg >> 4), value);
 }
 
-static inline void x2apic_write_reg_fault(unsigned int reg, uint64_t value)
+static inline void x2apic_write_reg_fault(unsigned int reg, u64 value)
 {
 	uint8_t fault = x2apic_write_reg_safe(reg, value);
 
diff --git a/tools/testing/selftests/kvm/include/x86/evmcs.h b/tools/testing/selftests/kvm/include/x86/evmcs.h
index 5a74bb30e2f8..5ec5cca6f9e4 100644
--- a/tools/testing/selftests/kvm/include/x86/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86/evmcs.h
@@ -12,7 +12,7 @@
 
 #define u16 uint16_t
 #define u32 uint32_t
-#define u64 uint64_t
+#define u64 u64
 
 #define EVMCS_VERSION 1
 
@@ -245,7 +245,7 @@ static inline void evmcs_enable(void)
 	enable_evmcs = true;
 }
 
-static inline int evmcs_vmptrld(uint64_t vmcs_pa, void *vmcs)
+static inline int evmcs_vmptrld(u64 vmcs_pa, void *vmcs)
 {
 	current_vp_assist->current_nested_vmcs = vmcs_pa;
 	current_vp_assist->enlighten_vmentry = 1;
@@ -265,7 +265,7 @@ static inline bool load_evmcs(struct hyperv_test_pages *hv)
 	return true;
 }
 
-static inline int evmcs_vmptrst(uint64_t *value)
+static inline int evmcs_vmptrst(u64 *value)
 {
 	*value = current_vp_assist->current_nested_vmcs &
 		~HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
@@ -273,7 +273,7 @@ static inline int evmcs_vmptrst(uint64_t *value)
 	return 0;
 }
 
-static inline int evmcs_vmread(uint64_t encoding, uint64_t *value)
+static inline int evmcs_vmread(u64 encoding, u64 *value)
 {
 	switch (encoding) {
 	case GUEST_RIP:
@@ -672,7 +672,7 @@ static inline int evmcs_vmread(uint64_t encoding, uint64_t *value)
 	return 0;
 }
 
-static inline int evmcs_vmwrite(uint64_t encoding, uint64_t value)
+static inline int evmcs_vmwrite(u64 encoding, u64 value)
 {
 	switch (encoding) {
 	case GUEST_RIP:
@@ -1226,9 +1226,9 @@ static inline int evmcs_vmlaunch(void)
 			     "pop %%rbp;"
 			     : [ret]"=&a"(ret)
 			     : [host_rsp]"r"
-			       ((uint64_t)&current_evmcs->host_rsp),
+			       ((u64)&current_evmcs->host_rsp),
 			       [host_rip]"r"
-			       ((uint64_t)&current_evmcs->host_rip)
+			       ((u64)&current_evmcs->host_rip)
 			     : "memory", "cc", "rbx", "r8", "r9", "r10",
 			       "r11", "r12", "r13", "r14", "r15");
 	return ret;
@@ -1265,9 +1265,9 @@ static inline int evmcs_vmresume(void)
 			     "pop %%rbp;"
 			     : [ret]"=&a"(ret)
 			     : [host_rsp]"r"
-			       ((uint64_t)&current_evmcs->host_rsp),
+			       ((u64)&current_evmcs->host_rsp),
 			       [host_rip]"r"
-			       ((uint64_t)&current_evmcs->host_rip)
+			       ((u64)&current_evmcs->host_rip)
 			     : "memory", "cc", "rbx", "r8", "r9", "r10",
 			       "r11", "r12", "r13", "r14", "r15");
 	return ret;
diff --git a/tools/testing/selftests/kvm/include/x86/hyperv.h b/tools/testing/selftests/kvm/include/x86/hyperv.h
index eedfff3cf102..2add2123e37b 100644
--- a/tools/testing/selftests/kvm/include/x86/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86/hyperv.h
@@ -256,9 +256,9 @@
  */
 static inline uint8_t __hyperv_hypercall(u64 control, gva_t input_address,
 					 gva_t output_address,
-					 uint64_t *hv_status)
+					 u64 *hv_status)
 {
-	uint64_t error_code;
+	u64 error_code;
 	uint8_t vector;
 
 	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
@@ -277,7 +277,7 @@ static inline uint8_t __hyperv_hypercall(u64 control, gva_t input_address,
 static inline void hyperv_hypercall(u64 control, gva_t input_address,
 				    gva_t output_address)
 {
-	uint64_t hv_status;
+	u64 hv_status;
 	uint8_t vector;
 
 	vector = __hyperv_hypercall(control, input_address, output_address, &hv_status);
@@ -327,22 +327,22 @@ struct hv_vp_assist_page {
 
 extern struct hv_vp_assist_page *current_vp_assist;
 
-int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist);
+int enable_vp_assist(u64 vp_assist_pa, void *vp_assist);
 
 struct hyperv_test_pages {
 	/* VP assist page */
 	void *vp_assist_hva;
-	uint64_t vp_assist_gpa;
+	u64 vp_assist_gpa;
 	void *vp_assist;
 
 	/* Partition assist page */
 	void *partition_assist_hva;
-	uint64_t partition_assist_gpa;
+	u64 partition_assist_gpa;
 	void *partition_assist;
 
 	/* Enlightened VMCS */
 	void *enlightened_vmcs_hva;
-	uint64_t enlightened_vmcs_gpa;
+	u64 enlightened_vmcs_gpa;
 	void *enlightened_vmcs;
 };
 
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 36d4b6727cb6..42d125e06114 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -15,8 +15,8 @@ struct kvm_vm_arch {
 	gva_t tss;
 	gva_t idt;
 
-	uint64_t c_bit;
-	uint64_t s_bit;
+	u64 c_bit;
+	u64 s_bit;
 	int sev_fd;
 	bool is_pt_protected;
 };
@@ -40,7 +40,7 @@ do {											\
 				     : "+m" (mem)					\
 				     : "r" (val) : "memory");				\
 	} else {									\
-		uint64_t __old = READ_ONCE(mem);					\
+		u64 __old = READ_ONCE(mem);					\
 											\
 		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchg %[new], %[ptr]"	\
 				     : [ptr] "+m" (mem), [old] "+a" (__old)		\
diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 3c10c4dc0ae8..a7332c4374a3 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -5,7 +5,7 @@
 #ifndef SELFTEST_KVM_PMU_H
 #define SELFTEST_KVM_PMU_H
 
-#include <stdint.h>
+#include <linux/types.h>
 
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS			300
 
@@ -91,7 +91,7 @@ enum amd_pmu_zen_events {
 	NR_AMD_ZEN_EVENTS,
 };
 
-extern const uint64_t intel_pmu_arch_events[];
-extern const uint64_t amd_pmu_zen_events[];
+extern const u64 intel_pmu_arch_events[];
+extern const u64 amd_pmu_zen_events[];
 
 #endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 32ab6ca7ec32..72cadb47cd86 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -21,7 +21,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
-extern uint64_t guest_tsc_khz;
+extern u64 guest_tsc_khz;
 
 #ifndef MAX_NR_CPUID_ENTRIES
 #define MAX_NR_CPUID_ENTRIES 100
@@ -408,7 +408,7 @@ struct desc64 {
 
 struct desc_ptr {
 	uint16_t size;
-	uint64_t address;
+	u64 address;
 } __attribute__((packed));
 
 struct kvm_x86_state {
@@ -426,16 +426,16 @@ struct kvm_x86_state {
 	struct kvm_msrs msrs;
 };
 
-static inline uint64_t get_desc64_base(const struct desc64 *desc)
+static inline u64 get_desc64_base(const struct desc64 *desc)
 {
-	return ((uint64_t)desc->base3 << 32) |
+	return ((u64)desc->base3 << 32) |
 		(desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24));
 }
 
-static inline uint64_t rdtsc(void)
+static inline u64 rdtsc(void)
 {
 	uint32_t eax, edx;
-	uint64_t tsc_val;
+	u64 tsc_val;
 	/*
 	 * The lfence is to wait (on Intel CPUs) until all previous
 	 * instructions have been executed. If software requires RDTSC to be
@@ -443,28 +443,28 @@ static inline uint64_t rdtsc(void)
 	 * execute LFENCE immediately after RDTSC
 	 */
 	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
-	tsc_val = ((uint64_t)edx) << 32 | eax;
+	tsc_val = ((u64)edx) << 32 | eax;
 	return tsc_val;
 }
 
-static inline uint64_t rdtscp(uint32_t *aux)
+static inline u64 rdtscp(uint32_t *aux)
 {
 	uint32_t eax, edx;
 
 	__asm__ __volatile__("rdtscp" : "=a"(eax), "=d"(edx), "=c"(*aux));
-	return ((uint64_t)edx) << 32 | eax;
+	return ((u64)edx) << 32 | eax;
 }
 
-static inline uint64_t rdmsr(uint32_t msr)
+static inline u64 rdmsr(uint32_t msr)
 {
 	uint32_t a, d;
 
 	__asm__ __volatile__("rdmsr" : "=a"(a), "=d"(d) : "c"(msr) : "memory");
 
-	return a | ((uint64_t) d << 32);
+	return a | ((u64)d << 32);
 }
 
-static inline void wrmsr(uint32_t msr, uint64_t value)
+static inline void wrmsr(uint32_t msr, u64 value)
 {
 	uint32_t a = value;
 	uint32_t d = value >> 32;
@@ -547,34 +547,34 @@ static inline uint16_t get_tr(void)
 	return tr;
 }
 
-static inline uint64_t get_cr0(void)
+static inline u64 get_cr0(void)
 {
-	uint64_t cr0;
+	u64 cr0;
 
 	__asm__ __volatile__("mov %%cr0, %[cr0]"
 			     : /* output */ [cr0]"=r"(cr0));
 	return cr0;
 }
 
-static inline uint64_t get_cr3(void)
+static inline u64 get_cr3(void)
 {
-	uint64_t cr3;
+	u64 cr3;
 
 	__asm__ __volatile__("mov %%cr3, %[cr3]"
 			     : /* output */ [cr3]"=r"(cr3));
 	return cr3;
 }
 
-static inline uint64_t get_cr4(void)
+static inline u64 get_cr4(void)
 {
-	uint64_t cr4;
+	u64 cr4;
 
 	__asm__ __volatile__("mov %%cr4, %[cr4]"
 			     : /* output */ [cr4]"=r"(cr4));
 	return cr4;
 }
 
-static inline void set_cr4(uint64_t val)
+static inline void set_cr4(u64 val)
 {
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
@@ -751,13 +751,13 @@ static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 	return nr_bits > feature.f.bit || this_cpu_has(feature.f);
 }
 
-static __always_inline uint64_t this_cpu_supported_xcr0(void)
+static __always_inline u64 this_cpu_supported_xcr0(void)
 {
 	if (!this_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
 		return 0;
 
 	return this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
-	       ((uint64_t)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
+	       ((u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
 }
 
 typedef u32		__attribute__((vector_size(16))) sse128_t;
@@ -836,7 +836,7 @@ static inline void cpu_relax(void)
 
 static inline void udelay(unsigned long usec)
 {
-	uint64_t start, now, cycles;
+	u64 start, now, cycles;
 
 	GUEST_ASSERT(guest_tsc_khz);
 	cycles = guest_tsc_khz / 1000 * usec;
@@ -868,7 +868,7 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 const struct kvm_msr_list *kvm_get_msr_index_list(void);
 const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
 bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
-uint64_t kvm_get_feature_msr(uint64_t msr_index);
+u64 kvm_get_feature_msr(u64 msr_index);
 
 static inline void vcpu_msrs_get(struct kvm_vcpu *vcpu,
 				 struct kvm_msrs *msrs)
@@ -991,13 +991,13 @@ static inline bool kvm_pmu_has(struct kvm_x86_pmu_feature feature)
 	return nr_bits > feature.f.bit || kvm_cpu_has(feature.f);
 }
 
-static __always_inline uint64_t kvm_cpu_supported_xcr0(void)
+static __always_inline u64 kvm_cpu_supported_xcr0(void)
 {
 	if (!kvm_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
 		return 0;
 
 	return kvm_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
-	       ((uint64_t)kvm_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
+	       ((u64)kvm_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
 }
 
 static inline size_t kvm_cpuid2_size(int nr_entries)
@@ -1104,8 +1104,8 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 	vcpu_set_or_clear_cpuid_feature(vcpu, feature, false);
 }
 
-uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
-int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value);
+u64 vcpu_get_msr(struct kvm_vcpu *vcpu, u64 msr_index);
+int _vcpu_set_msr(struct kvm_vcpu *vcpu, u64 msr_index, u64 msr_value);
 
 /*
  * Assert on an MSR access(es) and pretty print the MSR name when possible.
@@ -1137,7 +1137,7 @@ static inline bool is_durable_msr(uint32_t msr)
 
 #define vcpu_set_msr(vcpu, msr, val)							\
 do {											\
-	uint64_t r, v = val;								\
+	u64 r, v = val;								\
 											\
 	TEST_ASSERT_MSR(_vcpu_set_msr(vcpu, msr, v) == 1,				\
 			"KVM_SET_MSRS failed on %s, value = 0x%lx", msr, #msr, v);	\
@@ -1152,15 +1152,15 @@ void kvm_init_vm_address_properties(struct kvm_vm *vm);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
-	uint64_t rax, rcx, rdx, rbx;
-	uint64_t rbp, rsi, rdi;
-	uint64_t r8, r9, r10, r11;
-	uint64_t r12, r13, r14, r15;
-	uint64_t vector;
-	uint64_t error_code;
-	uint64_t rip;
-	uint64_t cs;
-	uint64_t rflags;
+	u64 rax, rcx, rdx, rbx;
+	u64 rbp, rsi, rdi;
+	u64 r8, r9, r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 vector;
+	u64 error_code;
+	u64 rip;
+	u64 cs;
+	u64 rflags;
 };
 
 struct idt_entry {
@@ -1226,7 +1226,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
 #define kvm_asm_safe(insn, inputs...)					\
 ({									\
-	uint64_t ign_error_code;					\
+	u64 ign_error_code;					\
 	uint8_t vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE(insn)					\
@@ -1249,7 +1249,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
 #define kvm_asm_safe_fep(insn, inputs...)				\
 ({									\
-	uint64_t ign_error_code;					\
+	u64 ign_error_code;					\
 	uint8_t vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
@@ -1271,9 +1271,9 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 })
 
 #define BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
-static inline uint8_t insn##_safe ##_fep(uint32_t idx, uint64_t *val)	\
+static inline uint8_t insn##_safe ##_fep(uint32_t idx, u64 *val)	\
 {									\
-	uint64_t error_code;						\
+	u64 error_code;						\
 	uint8_t vector;							\
 	uint32_t a, d;							\
 									\
@@ -1283,7 +1283,7 @@ static inline uint8_t insn##_safe ##_fep(uint32_t idx, uint64_t *val)	\
 		     : "c"(idx)						\
 		     : KVM_ASM_SAFE_CLOBBERS);				\
 									\
-	*val = (uint64_t)a | ((uint64_t)d << 32);			\
+	*val = (u64)a | ((u64)d << 32);			\
 	return vector;							\
 }
 
@@ -1299,12 +1299,12 @@ BUILD_READ_U64_SAFE_HELPERS(rdmsr)
 BUILD_READ_U64_SAFE_HELPERS(rdpmc)
 BUILD_READ_U64_SAFE_HELPERS(xgetbv)
 
-static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
+static inline uint8_t wrmsr_safe(uint32_t msr, u64 val)
 {
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
-static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
+static inline uint8_t xsetbv_safe(uint32_t index, u64 value)
 {
 	u32 eax = value;
 	u32 edx = value >> 32;
@@ -1324,25 +1324,21 @@ static inline bool kvm_is_forced_emulation_enabled(void)
 	return !!get_kvm_param_integer("force_emulation_prefix");
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level);
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
+u64 *__vm_get_page_table_entry(struct kvm_vm *vm, u64 vaddr, int *level);
+u64 *vm_get_page_table_entry(struct kvm_vm *vm, u64 vaddr);
 
-uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
-		       uint64_t a3);
-uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
-void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
+u64 kvm_hypercall(u64 nr, u64 a0, u64 a1, u64 a2, u64 a3);
+u64 __xen_hypercall(u64 nr, u64 a0, void *a1);
+void xen_hypercall(u64 nr, u64 a0, void *a1);
 
-static inline uint64_t __kvm_hypercall_map_gpa_range(uint64_t gpa,
-						     uint64_t size, uint64_t flags)
+static inline u64 __kvm_hypercall_map_gpa_range(u64 gpa, u64 size, u64 flags)
 {
 	return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
 }
 
-static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
-					       uint64_t flags)
+static inline void kvm_hypercall_map_gpa_range(u64 gpa, u64 size, u64 flags)
 {
-	uint64_t ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
+	u64 ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
 
 	GUEST_ASSERT(!ret);
 }
@@ -1387,7 +1383,7 @@ static inline void cli(void)
 	asm volatile ("cli");
 }
 
-void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
+void __vm_xsave_require_permission(u64 xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
 	__vm_xsave_require_permission(xfeature, #xfeature)
@@ -1408,9 +1404,9 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
-void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		    uint64_t nr_bytes, int level);
+void __virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr, int level);
+void virt_map_level(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+		    u64 nr_bytes, int level);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 9aefe83e16b8..02f6324d7e77 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -53,7 +53,7 @@ kvm_static_assert(SEV_RET_SUCCESS == 0);
 		unsigned long raw;					\
 	} sev_cmd = { .c = {						\
 		.id = (cmd),						\
-		.data = (uint64_t)(arg),				\
+		.data = (u64)(arg),				\
 		.sev_fd = (vm)->arch.sev_fd,				\
 	} };								\
 									\
@@ -83,7 +83,7 @@ static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
 }
 
 static inline void sev_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
-					  uint64_t size)
+					  u64 size)
 {
 	struct kvm_sev_launch_update_data update_data = {
 		.uaddr = (unsigned long)addr_gpa2hva(vm, gpa),
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index c2ebb8b61e38..f22784534f6e 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -16,17 +16,17 @@ struct svm_test_data {
 	/* VMCB */
 	struct vmcb *vmcb; /* gva */
 	void *vmcb_hva;
-	uint64_t vmcb_gpa;
+	u64 vmcb_gpa;
 
 	/* host state-save area */
 	struct vmcb_save_area *save_area; /* gva */
 	void *save_area_hva;
-	uint64_t save_area_gpa;
+	u64 save_area_gpa;
 
 	/* MSR-Bitmap */
 	void *msr; /* gva */
 	void *msr_hva;
-	uint64_t msr_gpa;
+	u64 msr_gpa;
 };
 
 static inline void vmmcall(void)
@@ -55,7 +55,7 @@ static inline void vmmcall(void)
 
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
-void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
+void run_guest(struct vmcb *vmcb, u64 vmcb_gpa);
 
 int open_sev_dev_path_or_exit(void);
 
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 16603e8f2006..b5e6931cc979 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -287,12 +287,12 @@ enum vmcs_field {
 struct vmx_msr_entry {
 	uint32_t index;
 	uint32_t reserved;
-	uint64_t value;
+	u64 value;
 } __attribute__ ((aligned(16)));
 
 #include "evmcs.h"
 
-static inline int vmxon(uint64_t phys)
+static inline int vmxon(u64 phys)
 {
 	uint8_t ret;
 
@@ -309,7 +309,7 @@ static inline void vmxoff(void)
 	__asm__ __volatile__("vmxoff");
 }
 
-static inline int vmclear(uint64_t vmcs_pa)
+static inline int vmclear(u64 vmcs_pa)
 {
 	uint8_t ret;
 
@@ -321,7 +321,7 @@ static inline int vmclear(uint64_t vmcs_pa)
 	return ret;
 }
 
-static inline int vmptrld(uint64_t vmcs_pa)
+static inline int vmptrld(u64 vmcs_pa)
 {
 	uint8_t ret;
 
@@ -336,9 +336,9 @@ static inline int vmptrld(uint64_t vmcs_pa)
 	return ret;
 }
 
-static inline int vmptrst(uint64_t *value)
+static inline int vmptrst(u64 *value)
 {
-	uint64_t tmp;
+	u64 tmp;
 	uint8_t ret;
 
 	if (enable_evmcs)
@@ -356,9 +356,9 @@ static inline int vmptrst(uint64_t *value)
  * A wrapper around vmptrst that ignores errors and returns zero if the
  * vmptrst instruction fails.
  */
-static inline uint64_t vmptrstz(void)
+static inline u64 vmptrstz(void)
 {
-	uint64_t value = 0;
+	u64 value = 0;
 	vmptrst(&value);
 	return value;
 }
@@ -391,8 +391,8 @@ static inline int vmlaunch(void)
 			     "pop %%rcx;"
 			     "pop %%rbp;"
 			     : [ret]"=&a"(ret)
-			     : [host_rsp]"r"((uint64_t)HOST_RSP),
-			       [host_rip]"r"((uint64_t)HOST_RIP)
+			     : [host_rsp]"r"((u64)HOST_RSP),
+			       [host_rip]"r"((u64)HOST_RIP)
 			     : "memory", "cc", "rbx", "r8", "r9", "r10",
 			       "r11", "r12", "r13", "r14", "r15");
 	return ret;
@@ -426,8 +426,8 @@ static inline int vmresume(void)
 			     "pop %%rcx;"
 			     "pop %%rbp;"
 			     : [ret]"=&a"(ret)
-			     : [host_rsp]"r"((uint64_t)HOST_RSP),
-			       [host_rip]"r"((uint64_t)HOST_RIP)
+			     : [host_rsp]"r"((u64)HOST_RSP),
+			       [host_rip]"r"((u64)HOST_RIP)
 			     : "memory", "cc", "rbx", "r8", "r9", "r10",
 			       "r11", "r12", "r13", "r14", "r15");
 	return ret;
@@ -447,9 +447,9 @@ static inline void vmcall(void)
 			       "r10", "r11", "r12", "r13", "r14", "r15");
 }
 
-static inline int vmread(uint64_t encoding, uint64_t *value)
+static inline int vmread(u64 encoding, u64 *value)
 {
-	uint64_t tmp;
+	u64 tmp;
 	uint8_t ret;
 
 	if (enable_evmcs)
@@ -468,14 +468,14 @@ static inline int vmread(uint64_t encoding, uint64_t *value)
  * A wrapper around vmread that ignores errors and returns zero if the
  * vmread instruction fails.
  */
-static inline uint64_t vmreadz(uint64_t encoding)
+static inline u64 vmreadz(u64 encoding)
 {
-	uint64_t value = 0;
+	u64 value = 0;
 	vmread(encoding, &value);
 	return value;
 }
 
-static inline int vmwrite(uint64_t encoding, uint64_t value)
+static inline int vmwrite(u64 encoding, u64 value)
 {
 	uint8_t ret;
 
@@ -497,35 +497,35 @@ static inline uint32_t vmcs_revision(void)
 
 struct vmx_pages {
 	void *vmxon_hva;
-	uint64_t vmxon_gpa;
+	u64 vmxon_gpa;
 	void *vmxon;
 
 	void *vmcs_hva;
-	uint64_t vmcs_gpa;
+	u64 vmcs_gpa;
 	void *vmcs;
 
 	void *msr_hva;
-	uint64_t msr_gpa;
+	u64 msr_gpa;
 	void *msr;
 
 	void *shadow_vmcs_hva;
-	uint64_t shadow_vmcs_gpa;
+	u64 shadow_vmcs_gpa;
 	void *shadow_vmcs;
 
 	void *vmread_hva;
-	uint64_t vmread_gpa;
+	u64 vmread_gpa;
 	void *vmread;
 
 	void *vmwrite_hva;
-	uint64_t vmwrite_gpa;
+	u64 vmwrite_gpa;
 	void *vmwrite;
 
 	void *eptp_hva;
-	uint64_t eptp_gpa;
+	u64 eptp_gpa;
 	void *eptp;
 
 	void *apic_access_hva;
-	uint64_t apic_access_gpa;
+	u64 apic_access_gpa;
 	void *apic_access;
 };
 
@@ -560,13 +560,13 @@ bool load_vmcs(struct vmx_pages *vmx);
 bool ept_1g_pages_supported(void);
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr);
+		   u64 nested_paddr, u64 paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+		 u64 nested_paddr, u64 paddr, u64 size);
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size);
+			    u64 addr, u64 size);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 6cf1fa092752..dcd213733604 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -46,12 +46,12 @@ static const char * const test_stage_string[] = {
 
 struct test_args {
 	struct kvm_vm *vm;
-	uint64_t guest_test_virt_mem;
-	uint64_t host_page_size;
-	uint64_t host_num_pages;
-	uint64_t large_page_size;
-	uint64_t large_num_pages;
-	uint64_t host_pages_per_lpage;
+	u64 guest_test_virt_mem;
+	u64 host_page_size;
+	u64 host_num_pages;
+	u64 large_page_size;
+	u64 large_num_pages;
+	u64 host_pages_per_lpage;
 	enum vm_mem_backing_src_type src_type;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 };
@@ -77,19 +77,19 @@ static sem_t test_stage_completed;
  * This will be set to the topmost valid physical address minus
  * the test memory size.
  */
-static uint64_t guest_test_phys_mem;
+static u64 guest_test_phys_mem;
 
 /*
  * Guest virtual memory offset of the testing memory slot.
  * Must not conflict with identity mapped test code.
  */
-static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+static u64 guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
 static void guest_code(bool do_write)
 {
 	struct test_args *p = &test_args;
 	enum test_stage *current_stage = &guest_test_stage;
-	uint64_t addr;
+	u64 addr;
 	int i, j;
 
 	while (true) {
@@ -113,9 +113,9 @@ static void guest_code(bool do_write)
 		case KVM_CREATE_MAPPINGS:
 			for (i = 0; i < p->large_num_pages; i++) {
 				if (do_write)
-					*(uint64_t *)addr = 0x0123456789ABCDEF;
+					*(u64 *)addr = 0x0123456789ABCDEF;
 				else
-					READ_ONCE(*(uint64_t *)addr);
+					READ_ONCE(*(u64 *)addr);
 
 				addr += p->large_page_size;
 			}
@@ -131,7 +131,7 @@ static void guest_code(bool do_write)
 		case KVM_UPDATE_MAPPINGS:
 			if (p->src_type == VM_MEM_SRC_ANONYMOUS) {
 				for (i = 0; i < p->host_num_pages; i++) {
-					*(uint64_t *)addr = 0x0123456789ABCDEF;
+					*(u64 *)addr = 0x0123456789ABCDEF;
 					addr += p->host_page_size;
 				}
 				break;
@@ -142,7 +142,7 @@ static void guest_code(bool do_write)
 				 * Write to the first host page in each large
 				 * page region, and triger break of large pages.
 				 */
-				*(uint64_t *)addr = 0x0123456789ABCDEF;
+				*(u64 *)addr = 0x0123456789ABCDEF;
 
 				/*
 				 * Access the middle host pages in each large
@@ -152,7 +152,7 @@ static void guest_code(bool do_write)
 				 */
 				addr += p->large_page_size / 2;
 				for (j = 0; j < p->host_pages_per_lpage / 2; j++) {
-					READ_ONCE(*(uint64_t *)addr);
+					READ_ONCE(*(u64 *)addr);
 					addr += p->host_page_size;
 				}
 			}
@@ -167,7 +167,7 @@ static void guest_code(bool do_write)
 		 */
 		case KVM_ADJUST_MAPPINGS:
 			for (i = 0; i < p->host_num_pages; i++) {
-				READ_ONCE(*(uint64_t *)addr);
+				READ_ONCE(*(u64 *)addr);
 				addr += p->host_page_size;
 			}
 			break;
@@ -227,8 +227,8 @@ static void *vcpu_worker(void *data)
 }
 
 struct test_params {
-	uint64_t phys_offset;
-	uint64_t test_mem_size;
+	u64 phys_offset;
+	u64 test_mem_size;
 	enum vm_mem_backing_src_type src_type;
 };
 
@@ -237,12 +237,12 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	int ret;
 	struct test_params *p = arg;
 	enum vm_mem_backing_src_type src_type = p->src_type;
-	uint64_t large_page_size = get_backing_src_pagesz(src_type);
-	uint64_t guest_page_size = vm_guest_mode_params[mode].page_size;
-	uint64_t host_page_size = getpagesize();
-	uint64_t test_mem_size = p->test_mem_size;
-	uint64_t guest_num_pages;
-	uint64_t alignment;
+	u64 large_page_size = get_backing_src_pagesz(src_type);
+	u64 guest_page_size = vm_guest_mode_params[mode].page_size;
+	u64 host_page_size = getpagesize();
+	u64 test_mem_size = p->test_mem_size;
+	u64 guest_num_pages;
+	u64 alignment;
 	void *host_test_mem;
 	struct kvm_vm *vm;
 
@@ -307,7 +307,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Guest physical test memory offset: 0x%lx\n",
 		guest_test_phys_mem);
 	pr_info("Host  virtual  test memory offset: 0x%lx\n",
-		(uint64_t)host_test_mem);
+		(u64)host_test_mem);
 	pr_info("Number of testing vCPUs: %d\n", nr_vcpus);
 
 	return vm;
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic.c b/tools/testing/selftests/kvm/lib/arm64/gic.c
index 7abbf8866512..ac3987cdac6d 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic.c
@@ -73,7 +73,7 @@ void gic_irq_disable(unsigned int intid)
 
 unsigned int gic_get_and_ack_irq(void)
 {
-	uint64_t irqstat;
+	u64 irqstat;
 	unsigned int intid;
 
 	GUEST_ASSERT(gic_common_ops);
@@ -102,7 +102,7 @@ void gic_set_eoi_split(bool split)
 	gic_common_ops->gic_set_eoi_split(split);
 }
 
-void gic_set_priority_mask(uint64_t pmr)
+void gic_set_priority_mask(u64 pmr)
 {
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_set_priority_mask(pmr);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_private.h b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
index d24e9ecc96c6..d231bb7594df 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_private.h
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
@@ -12,11 +12,11 @@ struct gic_common_ops {
 	void (*gic_cpu_init)(unsigned int cpu);
 	void (*gic_irq_enable)(unsigned int intid);
 	void (*gic_irq_disable)(unsigned int intid);
-	uint64_t (*gic_read_iar)(void);
+	u64 (*gic_read_iar)(void);
 	void (*gic_write_eoir)(uint32_t irq);
 	void (*gic_write_dir)(uint32_t irq);
 	void (*gic_set_eoi_split)(bool split);
-	void (*gic_set_priority_mask)(uint64_t mask);
+	void (*gic_set_priority_mask)(u64 mask);
 	void (*gic_set_priority)(uint32_t intid, uint32_t prio);
 	void (*gic_irq_set_active)(uint32_t intid);
 	void (*gic_irq_clear_active)(uint32_t intid);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 911650132446..2f5d8a706ce3 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -91,9 +91,9 @@ static enum gicv3_intid_range get_intid_range(unsigned int intid)
 	return INVALID_RANGE;
 }
 
-static uint64_t gicv3_read_iar(void)
+static u64 gicv3_read_iar(void)
 {
-	uint64_t irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
+	u64 irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
 
 	dsb(sy);
 	return irqstat;
@@ -111,7 +111,7 @@ static void gicv3_write_dir(uint32_t irq)
 	isb();
 }
 
-static void gicv3_set_priority_mask(uint64_t mask)
+static void gicv3_set_priority_mask(u64 mask)
 {
 	write_sysreg_s(mask, SYS_ICC_PMR_EL1);
 }
@@ -129,26 +129,26 @@ static void gicv3_set_eoi_split(bool split)
 	isb();
 }
 
-uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
+uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, u64 offset)
 {
 	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
 			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	return readl(base + offset);
 }
 
-void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
+void gicv3_reg_writel(uint32_t cpu_or_dist, u64 offset, uint32_t reg_val)
 {
 	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
 			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	writel(reg_val, base + offset);
 }
 
-uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, uint64_t offset, uint32_t mask)
+uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, u64 offset, uint32_t mask)
 {
 	return gicv3_reg_readl(cpu_or_dist, offset) & mask;
 }
 
-void gicv3_setl_fields(uint32_t cpu_or_dist, uint64_t offset,
+void gicv3_setl_fields(uint32_t cpu_or_dist, u64 offset,
 		uint32_t mask, uint32_t reg_val)
 {
 	uint32_t tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
@@ -165,7 +165,7 @@ void gicv3_setl_fields(uint32_t cpu_or_dist, uint64_t offset,
  * map that doesn't implement it; like GICR_WAKER's offset of 0x0014 being
  * marked as "Reserved" in the Distributor map.
  */
-static void gicv3_access_reg(uint32_t intid, uint64_t offset,
+static void gicv3_access_reg(uint32_t intid, u64 offset,
 		uint32_t reg_bits, uint32_t bits_per_field,
 		bool write, uint32_t *val)
 {
@@ -197,14 +197,14 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	*val = gicv3_getl_fields(cpu_or_dist, offset, mask) >> shift;
 }
 
-static void gicv3_write_reg(uint32_t intid, uint64_t offset,
+static void gicv3_write_reg(uint32_t intid, u64 offset,
 		uint32_t reg_bits, uint32_t bits_per_field, uint32_t val)
 {
 	gicv3_access_reg(intid, offset, reg_bits,
 			bits_per_field, true, &val);
 }
 
-static uint32_t gicv3_read_reg(uint32_t intid, uint64_t offset,
+static uint32_t gicv3_read_reg(uint32_t intid, u64 offset,
 		uint32_t reg_bits, uint32_t bits_per_field)
 {
 	uint32_t val;
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index e57b757b4256..d7cfd8899b97 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -20,23 +20,23 @@
 
 static gva_t exception_handlers;
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
+static u64 page_align(struct kvm_vm *vm, u64 v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
 }
 
-static uint64_t pgd_index(struct kvm_vm *vm, gva_t gva)
+static u64 pgd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
-	uint64_t mask = (1UL << (vm->va_bits - shift)) - 1;
+	u64 mask = (1UL << (vm->va_bits - shift)) - 1;
 
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pud_index(struct kvm_vm *vm, gva_t gva)
+static u64 pud_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = 2 * (vm->page_shift - 3) + vm->page_shift;
-	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
+	u64 mask = (1UL << (vm->page_shift - 3)) - 1;
 
 	TEST_ASSERT(vm->pgtable_levels == 4,
 		"Mode %d does not have 4 page table levels", vm->mode);
@@ -44,10 +44,10 @@ static uint64_t pud_index(struct kvm_vm *vm, gva_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pmd_index(struct kvm_vm *vm, gva_t gva)
+static u64 pmd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->page_shift - 3) + vm->page_shift;
-	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
+	u64 mask = (1UL << (vm->page_shift - 3)) - 1;
 
 	TEST_ASSERT(vm->pgtable_levels >= 3,
 		"Mode %d does not have >= 3 page table levels", vm->mode);
@@ -55,9 +55,9 @@ static uint64_t pmd_index(struct kvm_vm *vm, gva_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pte_index(struct kvm_vm *vm, gva_t gva)
+static u64 pte_index(struct kvm_vm *vm, gva_t gva)
 {
-	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
+	u64 mask = (1UL << (vm->page_shift - 3)) - 1;
 	return (gva >> vm->page_shift) & mask;
 }
 
@@ -67,9 +67,9 @@ static inline bool use_lpa2_pte_format(struct kvm_vm *vm)
 	    (vm->pa_bits > 48 || vm->va_bits > 48);
 }
 
-static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
+static u64 addr_pte(struct kvm_vm *vm, u64 pa, u64 attrs)
 {
-	uint64_t pte;
+	u64 pte;
 
 	if (use_lpa2_pte_format(vm)) {
 		pte = pa & PTE_ADDR_MASK_LPA2(vm->page_shift);
@@ -85,9 +85,9 @@ static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
 	return pte;
 }
 
-static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
+static u64 pte_addr(struct kvm_vm *vm, u64 pte)
 {
-	uint64_t pa;
+	u64 pa;
 
 	if (use_lpa2_pte_format(vm)) {
 		pa = pte & PTE_ADDR_MASK_LPA2(vm->page_shift);
@@ -101,13 +101,13 @@ static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
 	return pa;
 }
 
-static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
+static u64 ptrs_per_pgd(struct kvm_vm *vm)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
 	return 1 << (vm->va_bits - shift);
 }
 
-static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
+static u64 __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 {
 	return 1 << (vm->page_shift - 3);
 }
@@ -125,12 +125,12 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->pgd_created = true;
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-			 uint64_t flags)
+static void _virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+			 u64 flags)
 {
 	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
-	uint64_t pg_attr;
-	uint64_t *ptep;
+	u64 pg_attr;
+	u64 *ptep;
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
 		"Virtual address not on page boundary,\n"
@@ -178,16 +178,16 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 {
-	uint64_t attr_idx = MT_NORMAL;
+	u64 attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
+u64 *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 {
-	uint64_t *ptep;
+	u64 *ptep;
 
 	if (!vm->pgd_created)
 		goto unmapped_gva;
@@ -225,16 +225,16 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 
 gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
-	uint64_t *ptep = virt_get_pte_hva(vm, gva);
+	u64 *ptep = virt_get_pte_hva(vm, gva);
 
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
-static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
+static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, u64 page, int level)
 {
 #ifdef DEBUG
 	static const char * const type[] = { "", "pud", "pmd", "pte" };
-	uint64_t pte, *ptep;
+	u64 pte, *ptep;
 
 	if (level == 4)
 		return;
@@ -252,7 +252,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t p
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int level = 4 - (vm->pgtable_levels - 1);
-	uint64_t pgd, *ptep;
+	u64 pgd, *ptep;
 
 	if (!vm->pgd_created)
 		return;
@@ -270,7 +270,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	struct kvm_vm *vm = vcpu->vm;
-	uint64_t sctlr_el1, tcr_el1, ttbr0_el1;
+	u64 sctlr_el1, tcr_el1, ttbr0_el1;
 
 	if (!init)
 		init = &default_init;
@@ -366,7 +366,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 {
-	uint64_t pstate, pc;
+	u64 pstate, pc;
 
 	pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
 	pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
@@ -377,14 +377,14 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 {
-	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (u64)guest_code);
 }
 
 static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 					   struct kvm_vcpu_init *init)
 {
 	size_t stack_size;
-	uint64_t stack_vaddr;
+	u64 stack_vaddr;
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
@@ -426,13 +426,13 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 
 	for (i = 0; i < num; i++) {
 		vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.regs[i]),
-			     va_arg(ap, uint64_t));
+			     va_arg(ap, u64));
 	}
 
 	va_end(ap);
 }
 
-void kvm_exit_unexpected_exception(int vector, uint64_t ec, bool valid_ec)
+void kvm_exit_unexpected_exception(int vector, u64 ec, bool valid_ec)
 {
 	ucall(UCALL_UNHANDLED, 3, vector, ec, valid_ec);
 	while (1)
@@ -465,7 +465,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 {
 	extern char vectors;
 
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (u64)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
@@ -551,11 +551,11 @@ void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
 {
 	struct kvm_vcpu_init preferred_init;
 	int kvm_fd, vm_fd, vcpu_fd, err;
-	uint64_t val;
+	u64 val;
 	uint32_t gran;
 	struct kvm_one_reg reg = {
 		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
-		.addr	= (uint64_t)&val,
+		.addr	= (u64)&val,
 	};
 
 	kvm_fd = open_kvm_dev_path_or_exit();
@@ -613,17 +613,17 @@ void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
 		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7")
 
 
-void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
-	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
-	       uint64_t arg6, struct arm_smccc_res *res)
+void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
+	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
+	       u64 arg6, struct arm_smccc_res *res)
 {
 	__smccc_call(hvc, function_id, arg0, arg1, arg2, arg3, arg4, arg5,
 		     arg6, res);
 }
 
-void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
-	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
-	       uint64_t arg6, struct arm_smccc_res *res)
+void smccc_smc(uint32_t function_id, u64 arg0, u64 arg1,
+	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
+	       u64 arg6, struct arm_smccc_res *res)
 {
 	__smccc_call(smc, function_id, arg0, arg1, arg2, arg3, arg4, arg5,
 		     arg6, res);
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index 62109407a1ff..270f12f9593f 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -25,9 +25,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
-		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(u64),
 			    "Unexpected ucall exit mmio address access");
-		return (void *)(*((uint64_t *)run->mmio.data));
+		return (void *)(*((u64 *)run->mmio.data));
 	}
 
 	return NULL;
diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
index 4427f43f73ea..63aefbdb1829 100644
--- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
@@ -33,7 +33,7 @@
 int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 {
 	int gic_fd;
-	uint64_t attr;
+	u64 attr;
 	struct list_head *iter;
 	unsigned int nr_gic_pages, nr_vcpus_created = 0;
 
@@ -82,9 +82,9 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 /* should only work for level sensitive interrupts */
 int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 {
-	uint64_t attr = 32 * (intid / 32);
-	uint64_t index = intid % 32;
-	uint64_t val;
+	u64 attr = 32 * (intid / 32);
+	u64 index = intid % 32;
+	u64 val;
 	int ret;
 
 	ret = __kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
@@ -128,12 +128,12 @@ void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 }
 
 static void vgic_poke_irq(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu,
-			  uint64_t reg_off)
+			  u64 reg_off)
 {
-	uint64_t reg = intid / 32;
-	uint64_t index = intid % 32;
-	uint64_t attr = reg_off + reg * 4;
-	uint64_t val;
+	u64 reg = intid / 32;
+	u64 index = intid % 32;
+	u64 attr = reg_off + reg * 4;
+	u64 val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
 	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 6fddebb96a3c..102a778a0ae4 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -156,7 +156,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		TEST_ASSERT(phdr.p_memsz > 0, "Unexpected loadable segment "
 			"memsize of 0,\n"
 			"  phdr index: %u p_memsz: 0x%" PRIx64,
-			n1, (uint64_t) phdr.p_memsz);
+			n1, (u64)phdr.p_memsz);
 		gva_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
 		gva_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
 		seg_vend |= vm->page_size - 1;
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 74627514c4d4..224de8a3f862 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -35,8 +35,8 @@ static int skip_atoi(const char **s)
 ({							\
 	int __res;					\
 							\
-	__res = ((uint64_t) n) % (uint32_t) base;	\
-	n = ((uint64_t) n) / (uint32_t) base;		\
+	__res = ((u64)n) % (uint32_t) base;	\
+	n = ((u64)n) / (uint32_t) base;		\
 	__res;						\
 })
 
@@ -119,7 +119,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 {
 	char *str, *end;
 	const char *s;
-	uint64_t num;
+	u64 num;
 	int i, base;
 	int len;
 
@@ -240,7 +240,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 				flags |= SPECIAL | SMALL | ZEROPAD;
 			}
 			str = number(str, end,
-				     (uint64_t)va_arg(args, void *), 16,
+				     (u64)va_arg(args, void *), 16,
 				     field_width, precision, flags);
 			continue;
 
@@ -284,7 +284,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 			continue;
 		}
 		if (qualifier == 'l')
-			num = va_arg(args, uint64_t);
+			num = va_arg(args, u64);
 		else if (qualifier == 'h') {
 			num = (uint16_t)va_arg(args, int);
 			if (flags & SIGN)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6dd2755fdb7b..1b46de455f2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -373,12 +373,12 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	return vm;
 }
 
-static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
-				     uint32_t nr_runnable_vcpus,
-				     uint64_t extra_mem_pages)
+static u64 vm_nr_pages_required(enum vm_guest_mode mode,
+				uint32_t nr_runnable_vcpus,
+				u64 extra_mem_pages)
 {
-	uint64_t page_size = vm_guest_mode_params[mode].page_size;
-	uint64_t nr_pages;
+	u64 page_size = vm_guest_mode_params[mode].page_size;
+	u64 nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
 		    "Use vm_create_barebones() for VMs that _never_ have vCPUs");
@@ -445,9 +445,9 @@ void kvm_set_files_rlimit(uint32_t nr_vcpus)
 }
 
 struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
-			   uint64_t nr_extra_pages)
+			   u64 nr_extra_pages)
 {
-	uint64_t nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
+	u64 nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
@@ -507,7 +507,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
  * no real memory allocation for non-slot0 memory in this function.
  */
 struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages,
+				      u64 extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
 	struct kvm_vm *vm;
@@ -525,7 +525,7 @@ struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
 
 struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
 					       struct kvm_vcpu **vcpu,
-					       uint64_t extra_mem_pages,
+					       u64 extra_mem_pages,
 					       void *guest_code)
 {
 	struct kvm_vcpu *vcpus[1];
@@ -675,15 +675,15 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
  * region exists.
  */
 static struct userspace_mem_region *
-userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
+userspace_mem_region_find(struct kvm_vm *vm, u64 start, u64 end)
 {
 	struct rb_node *node;
 
 	for (node = vm->regions.gpa_tree.rb_node; node; ) {
 		struct userspace_mem_region *region =
 			container_of(node, struct userspace_mem_region, gpa_node);
-		uint64_t existing_start = region->region.guest_phys_addr;
-		uint64_t existing_end = region->region.guest_phys_addr
+		u64 existing_start = region->region.guest_phys_addr;
+		u64 existing_end = region->region.guest_phys_addr
 			+ region->region.memory_size - 1;
 		if (start <= existing_end && end >= existing_start)
 			return region;
@@ -897,7 +897,7 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
 
 
 int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva)
+				u64 gpa, u64 size, void *hva)
 {
 	struct kvm_userspace_memory_region region = {
 		.slot = slot,
@@ -911,7 +911,7 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 }
 
 void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-			       uint64_t gpa, uint64_t size, void *hva)
+			       u64 gpa, u64 size, void *hva)
 {
 	int ret = __vm_set_user_memory_region(vm, slot, flags, gpa, size, hva);
 
@@ -924,8 +924,8 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				 u64 gpa, u64 size, void *hva,
+				 uint32_t guest_memfd, u64 guest_memfd_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -943,8 +943,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 }
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				u64 gpa, u64 size, void *hva,
+				uint32_t guest_memfd, u64 guest_memfd_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
 					       guest_memfd, guest_memfd_offset);
@@ -956,8 +956,8 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-		uint32_t flags, int guest_memfd, uint64_t guest_memfd_offset)
+		u64 guest_paddr, uint32_t slot, u64 npages,
+		uint32_t flags, int guest_memfd, u64 guest_memfd_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -995,8 +995,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			"page_size: 0x%x\n"
 			"  existing guest_paddr: 0x%lx size: 0x%lx",
 			guest_paddr, npages, vm->page_size,
-			(uint64_t) region->region.guest_phys_addr,
-			(uint64_t) region->region.memory_size);
+			(u64)region->region.guest_phys_addr,
+			(u64)region->region.memory_size);
 
 	/* Confirm no region with the requested slot already exists. */
 	hash_for_each_possible(vm->regions.slot_hash, region, slot_node,
@@ -1010,8 +1010,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			"  existing slot: %u paddr: 0x%lx size: 0x%lx",
 			slot, guest_paddr, npages,
 			region->region.slot,
-			(uint64_t) region->region.guest_phys_addr,
-			(uint64_t) region->region.memory_size);
+			(u64)region->region.guest_phys_addr,
+			(u64)region->region.memory_size);
 	}
 
 	/* Allocate and initialize new mem region structure. */
@@ -1112,7 +1112,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		"  slot: %u flags: 0x%x\n"
 		"  guest_phys_addr: 0x%lx size: 0x%lx guest_memfd: %d",
 		ret, errno, slot, flags,
-		guest_paddr, (uint64_t) region->region.memory_size,
+		guest_paddr, (u64)region->region.memory_size,
 		region->region.guest_memfd);
 
 	/* Add to quick lookup data structures */
@@ -1136,8 +1136,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
-				 uint64_t guest_paddr, uint32_t slot,
-				 uint64_t npages, uint32_t flags)
+				 u64 guest_paddr, uint32_t slot,
+				 u64 npages, uint32_t flags)
 {
 	vm_mem_add(vm, src_type, guest_paddr, slot, npages, flags, -1, 0);
 }
@@ -1219,7 +1219,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
  *
  * Change the gpa of a memory region.
  */
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
+void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, u64 new_gpa)
 {
 	struct userspace_mem_region *region;
 	int ret;
@@ -1258,18 +1258,18 @@ void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 	__vm_mem_region_delete(vm, region);
 }
 
-void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
+void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
 	struct userspace_mem_region *region;
-	uint64_t end = base + size;
-	uint64_t gpa, len;
+	u64 end = base + size;
+	u64 gpa, len;
 	off_t fd_offset;
 	int ret;
 
 	for (gpa = base; gpa < end; gpa += len) {
-		uint64_t offset;
+		u64 offset;
 
 		region = userspace_mem_region_find(vm, gpa, gpa);
 		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
@@ -1277,7 +1277,7 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 
 		offset = gpa - region->region.guest_phys_addr;
 		fd_offset = region->region.guest_memfd_offset + offset;
-		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
+		len = min_t(u64, end - gpa, region->region.memory_size - offset);
 
 		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
 		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
@@ -1375,10 +1375,10 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  */
 gva_t gva_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
-	uint64_t pages = (sz + vm->page_size - 1) >> vm->page_shift;
+	u64 pages = (sz + vm->page_size - 1) >> vm->page_shift;
 
 	/* Determine lowest permitted virtual page index. */
-	uint64_t pgidx_start = (vaddr_min + vm->page_size - 1) >> vm->page_shift;
+	u64 pgidx_start = (vaddr_min + vm->page_size - 1) >> vm->page_shift;
 	if ((pgidx_start * vm->page_size) < vaddr_min)
 		goto no_va_found;
 
@@ -1443,7 +1443,7 @@ static gva_t ____gva_alloc(struct kvm_vm *vm, size_t sz,
 			   enum kvm_mem_region_type type,
 			   bool protected)
 {
-	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
+	u64 pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
 	gpa_t paddr = __vm_phy_pages_alloc(vm, pages,
@@ -1565,7 +1565,7 @@ gva_t gva_alloc_page(struct kvm_vm *vm)
  * Within the VM given by @vm, creates a virtual translation for
  * @npages starting at @vaddr to the page range starting at @paddr.
  */
-void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+void virt_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 	      unsigned int npages)
 {
 	size_t page_size = vm->page_size;
@@ -1790,7 +1790,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
  * Device Ioctl
  */
 
-int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
+int __kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr)
 {
 	struct kvm_device_attr attribute = {
 		.group = group,
@@ -1801,7 +1801,7 @@ int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
 	return ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
 }
 
-int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type)
+int __kvm_test_create_device(struct kvm_vm *vm, u64 type)
 {
 	struct kvm_create_device create_dev = {
 		.type = type,
@@ -1811,7 +1811,7 @@ int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type)
 	return __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
 }
 
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type)
+int __kvm_create_device(struct kvm_vm *vm, u64 type)
 {
 	struct kvm_create_device create_dev = {
 		.type = type,
@@ -1825,7 +1825,7 @@ int __kvm_create_device(struct kvm_vm *vm, uint64_t type)
 	return err ? : create_dev.fd;
 }
 
-int __kvm_device_attr_get(int dev_fd, uint32_t group, uint64_t attr, void *val)
+int __kvm_device_attr_get(int dev_fd, uint32_t group, u64 attr, void *val)
 {
 	struct kvm_device_attr kvmattr = {
 		.group = group,
@@ -1837,7 +1837,7 @@ int __kvm_device_attr_get(int dev_fd, uint32_t group, uint64_t attr, void *val)
 	return __kvm_ioctl(dev_fd, KVM_GET_DEVICE_ATTR, &kvmattr);
 }
 
-int __kvm_device_attr_set(int dev_fd, uint32_t group, uint64_t attr, void *val)
+int __kvm_device_attr_set(int dev_fd, uint32_t group, u64 attr, void *val)
 {
 	struct kvm_device_attr kvmattr = {
 		.group = group,
@@ -1948,8 +1948,8 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
 		fprintf(stream, "%*sguest_phys: 0x%lx size: 0x%lx "
 			"host_virt: %p\n", indent + 2, "",
-			(uint64_t) region->region.guest_phys_addr,
-			(uint64_t) region->region.memory_size,
+			(u64)region->region.guest_phys_addr,
+			(u64)region->region.memory_size,
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
@@ -2236,7 +2236,7 @@ struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
  * Read the data values of a specified stat from the binary stats interface.
  */
 void read_stat_data(int stats_fd, struct kvm_stats_header *header,
-		    struct kvm_stats_desc *desc, uint64_t *data,
+		    struct kvm_stats_desc *desc, u64 *data,
 		    size_t max_elements)
 {
 	size_t nr_elements = min_t(ssize_t, desc->size, max_elements);
@@ -2257,7 +2257,7 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 }
 
 void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
-		  uint64_t *data, size_t max_elements)
+		  u64 *data, size_t max_elements)
 {
 	struct kvm_stats_desc *desc;
 	size_t size_desc;
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d51680509839..f6657bd34b80 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -16,7 +16,7 @@ struct memstress_args memstress_args;
  * Guest virtual memory offset of the testing memory slot.
  * Must not conflict with identity mapped test code.
  */
-static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+static u64 guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
 struct vcpu_thread {
 	/* The index of the vCPU. */
@@ -49,10 +49,10 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	struct guest_random_state rand_state;
-	uint64_t gva;
-	uint64_t pages;
-	uint64_t addr;
-	uint64_t page;
+	u64 gva;
+	u64 pages;
+	u64 addr;
+	u64 page;
 	int i;
 
 	rand_state = new_guest_random_state(guest_random_seed + vcpu_idx);
@@ -76,9 +76,9 @@ void memstress_guest_code(uint32_t vcpu_idx)
 			addr = gva + (page * args->guest_page_size);
 
 			if (__guest_random_bool(&rand_state, args->write_percent))
-				*(uint64_t *)addr = 0x0123456789ABCDEF;
+				*(u64 *)addr = 0x0123456789ABCDEF;
 			else
-				READ_ONCE(*(uint64_t *)addr);
+				READ_ONCE(*(u64 *)addr);
 		}
 
 		GUEST_SYNC(1);
@@ -87,7 +87,7 @@ void memstress_guest_code(uint32_t vcpu_idx)
 
 void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   struct kvm_vcpu *vcpus[],
-			   uint64_t vcpu_memory_bytes,
+			   u64 vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
 	struct memstress_args *args = &memstress_args;
@@ -122,15 +122,15 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   u64 vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
 	struct memstress_args *args = &memstress_args;
 	struct kvm_vm *vm;
-	uint64_t guest_num_pages, slot0_pages = 0;
-	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
-	uint64_t region_end_gfn;
+	u64 guest_num_pages, slot0_pages = 0;
+	u64 backing_src_pagesz = get_backing_src_pagesz(backing_src);
+	u64 region_end_gfn;
 	int i;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
@@ -206,7 +206,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
-		uint64_t region_pages = guest_num_pages / slots;
+		u64 region_pages = guest_num_pages / slots;
 		gpa_t region_start = args->gpa + region_pages * args->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
@@ -248,7 +248,7 @@ void memstress_set_random_access(struct kvm_vm *vm, bool random_access)
 	sync_global_to_guest(vm, memstress_args.random_access);
 }
 
-uint64_t __weak memstress_nested_pages(int nr_vcpus)
+u64 __weak memstress_nested_pages(int nr_vcpus)
 {
 	return 0;
 }
@@ -353,7 +353,7 @@ void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int sl
 }
 
 void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
-			       int slots, uint64_t pages_per_slot)
+			       int slots, u64 pages_per_slot)
 {
 	int i;
 
@@ -364,7 +364,7 @@ void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
 	}
 }
 
-unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot)
+unsigned long **memstress_alloc_bitmaps(int slots, u64 pages_per_slot)
 {
 	unsigned long **bitmaps;
 	int i;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index c4717aad1b3c..df0403adccac 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -16,7 +16,7 @@
 
 static gva_t exception_handlers;
 
-bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
+bool __vcpu_has_ext(struct kvm_vcpu *vcpu, u64 ext)
 {
 	unsigned long value = 0;
 	int ret;
@@ -26,23 +26,23 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 	return !ret && !!value;
 }
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
+static u64 page_align(struct kvm_vm *vm, u64 v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
 }
 
-static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
+static u64 pte_addr(struct kvm_vm *vm, u64 entry)
 {
 	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
 		PGTBL_PAGE_SIZE_SHIFT;
 }
 
-static uint64_t ptrs_per_pte(struct kvm_vm *vm)
+static u64 ptrs_per_pte(struct kvm_vm *vm)
 {
-	return PGTBL_PAGE_SIZE / sizeof(uint64_t);
+	return PGTBL_PAGE_SIZE / sizeof(u64);
 }
 
-static uint64_t pte_index_mask[] = {
+static u64 pte_index_mask[] = {
 	PGTBL_L0_INDEX_MASK,
 	PGTBL_L1_INDEX_MASK,
 	PGTBL_L2_INDEX_MASK,
@@ -56,7 +56,7 @@ static uint32_t pte_index_shift[] = {
 	PGTBL_L3_INDEX_SHIFT,
 };
 
-static uint64_t pte_index(struct kvm_vm *vm, gva_t gva, int level)
+static u64 pte_index(struct kvm_vm *vm, gva_t gva, int level)
 {
 	TEST_ASSERT(level > -1,
 		"Negative page table level (%d) not possible", level);
@@ -79,9 +79,9 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->pgd_created = true;
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 {
-	uint64_t *ptep, next_ppn;
+	u64 *ptep, next_ppn;
 	int level = vm->pgtable_levels - 1;
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
@@ -125,7 +125,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 
 gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
-	uint64_t *ptep;
+	u64 *ptep;
 	int level = vm->pgtable_levels - 1;
 
 	if (!vm->pgd_created)
@@ -153,11 +153,11 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
-		     uint64_t page, int level)
+		     u64 page, int level)
 {
 #ifdef DEBUG
 	static const char *const type[] = { "pte", "pmd", "pud", "p4d"};
-	uint64_t pte, *ptep;
+	u64 pte, *ptep;
 
 	if (level < 0)
 		return;
@@ -177,7 +177,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int level = vm->pgtable_levels - 1;
-	uint64_t pgd, *ptep;
+	u64 pgd, *ptep;
 
 	if (!vm->pgd_created)
 		return;
@@ -342,7 +342,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 {
 	va_list ap;
-	uint64_t id = RISCV_CORE_REG(regs.a0);
+	u64 id = RISCV_CORE_REG(regs.a0);
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
@@ -377,7 +377,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 			id = RISCV_CORE_REG(regs.a7);
 			break;
 		}
-		vcpu_set_reg(vcpu, id, va_arg(ap, uint64_t));
+		vcpu_set_reg(vcpu, id, va_arg(ap, u64));
 	}
 
 	va_end(ap);
diff --git a/tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c
index 2c432fa164f1..f5480473f192 100644
--- a/tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c
+++ b/tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c
@@ -13,7 +13,7 @@
 
 static void guest_code(void)
 {
-	uint64_t diag318_info = 0x12345678;
+	u64 diag318_info = 0x12345678;
 
 	asm volatile ("diag %0,0,0x318\n" : : "d" (diag318_info));
 }
@@ -23,13 +23,13 @@ static void guest_code(void)
  * we create an ad-hoc VM here to handle the instruction then extract the
  * necessary data. It is up to the caller to decide what to do with that data.
  */
-static uint64_t diag318_handler(void)
+static u64 diag318_handler(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
-	uint64_t reg;
-	uint64_t diag318_info;
+	u64 reg;
+	u64 diag318_info;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_run(vcpu);
@@ -51,9 +51,9 @@ static uint64_t diag318_handler(void)
 	return diag318_info;
 }
 
-uint64_t get_diag318_info(void)
+u64 get_diag318_info(void)
 {
-	static uint64_t diag318_info;
+	static u64 diag318_info;
 	static bool printed_skip;
 
 	/*
diff --git a/tools/testing/selftests/kvm/lib/s390/facility.c b/tools/testing/selftests/kvm/lib/s390/facility.c
index d540812d911a..9a778054f07f 100644
--- a/tools/testing/selftests/kvm/lib/s390/facility.c
+++ b/tools/testing/selftests/kvm/lib/s390/facility.c
@@ -10,5 +10,5 @@
 
 #include "facility.h"
 
-uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
+u64 stfl_doublewords[NB_STFL_DOUBLEWORDS];
 bool stfle_flag;
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 2baafbe608ac..96f98cdca15b 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -34,9 +34,9 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
  * a page table (ri == 4). Returns a suitable region/segment table entry
  * which points to the freshly allocated pages.
  */
-static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri)
+static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
 {
-	uint64_t taddr;
+	u64 taddr;
 
 	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
 				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
@@ -47,10 +47,10 @@ static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
+void virt_arch_pg_map(struct kvm_vm *vm, u64 gva, u64 gpa)
 {
 	int ri, idx;
-	uint64_t *entry;
+	u64 *entry;
 
 	TEST_ASSERT((gva % vm->page_size) == 0,
 		"Virtual address not on page boundary,\n"
@@ -89,7 +89,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
-	uint64_t *entry;
+	u64 *entry;
 
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -112,9 +112,9 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 }
 
 static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, uint8_t indent,
-			   uint64_t ptea_start)
+			   u64 ptea_start)
 {
-	uint64_t *pte, ptea;
+	u64 *pte, ptea;
 
 	for (ptea = ptea_start; ptea < ptea_start + 0x100 * 8; ptea += 8) {
 		pte = addr_gpa2hva(vm, ptea);
@@ -126,9 +126,9 @@ static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 }
 
 static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
-			     uint64_t reg_tab_addr)
+			     u64 reg_tab_addr)
 {
-	uint64_t addr, *entry;
+	u64 addr, *entry;
 
 	for (addr = reg_tab_addr; addr < reg_tab_addr + 0x400 * 8; addr += 8) {
 		entry = addr_gpa2hva(vm, addr);
@@ -163,7 +163,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
-	uint64_t stack_vaddr;
+	u64 stack_vaddr;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
@@ -206,7 +206,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	vcpu_regs_get(vcpu, &regs);
 
 	for (i = 0; i < num; i++)
-		regs.gprs[i + 2] = va_arg(ap, uint64_t);
+		regs.gprs[i + 2] = va_arg(ap, u64);
 
 	vcpu_regs_set(vcpu, &regs);
 	va_end(ap);
diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index cfed9d26cc71..df6d888d71e9 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -76,8 +76,8 @@
  * the use of a binary-search tree, where each node contains at least
  * the following members:
  *
- *   typedef uint64_t sparsebit_idx_t;
- *   typedef uint64_t sparsebit_num_t;
+ *   typedef u64 sparsebit_idx_t;
+ *   typedef u64 sparsebit_num_t;
  *
  *   sparsebit_idx_t idx;
  *   uint32_t mask;
@@ -2056,9 +2056,9 @@ unsigned char get8(void)
 	return ch;
 }
 
-uint64_t get64(void)
+u64 get64(void)
 {
-	uint64_t x;
+	u64 x;
 
 	x = get8();
 	x = (x << 8) | get8();
@@ -2075,8 +2075,8 @@ int main(void)
 	s = sparsebit_alloc();
 	for (;;) {
 		uint8_t op = get8() & 0xf;
-		uint64_t first = get64();
-		uint64_t last = get64();
+		u64 first = get64();
+		u64 last = get64();
 
 		operate(op, first, last);
 	}
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8ed0b74ae837..a23dbb796f2e 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -31,7 +31,7 @@ struct guest_random_state new_guest_random_state(uint32_t seed)
 
 uint32_t guest_random_u32(struct guest_random_state *state)
 {
-	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
+	state->seed = (u64)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
 	return state->seed;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 60297819d508..fd7609c83473 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -14,7 +14,7 @@ struct ucall_header {
 	struct ucall ucalls[KVM_MAX_VCPUS];
 };
 
-int ucall_nr_pages_required(uint64_t page_size)
+int ucall_nr_pages_required(u64 page_size)
 {
 	return align_up(sizeof(struct ucall_header), page_size) / page_size;
 }
@@ -79,7 +79,7 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
-void ucall_assert(uint64_t cmd, const char *exp, const char *file,
+void ucall_assert(u64 cmd, const char *exp, const char *file,
 		  unsigned int line, const char *fmt, ...)
 {
 	struct ucall *uc;
@@ -88,8 +88,8 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
 	uc = ucall_alloc();
 	uc->cmd = cmd;
 
-	WRITE_ONCE(uc->args[GUEST_ERROR_STRING], (uint64_t)(exp));
-	WRITE_ONCE(uc->args[GUEST_FILE], (uint64_t)(file));
+	WRITE_ONCE(uc->args[GUEST_ERROR_STRING], (u64)(exp));
+	WRITE_ONCE(uc->args[GUEST_FILE], (u64)(file));
 	WRITE_ONCE(uc->args[GUEST_LINE], line);
 
 	va_start(va, fmt);
@@ -101,7 +101,7 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
 	ucall_free(uc);
 }
 
-void ucall_fmt(uint64_t cmd, const char *fmt, ...)
+void ucall_fmt(u64 cmd, const char *fmt, ...)
 {
 	struct ucall *uc;
 	va_list va;
@@ -118,7 +118,7 @@ void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 	ucall_free(uc);
 }
 
-void ucall(uint64_t cmd, int nargs, ...)
+void ucall(u64 cmd, int nargs, ...)
 {
 	struct ucall *uc;
 	va_list va;
@@ -132,7 +132,7 @@ void ucall(uint64_t cmd, int nargs, ...)
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
+		WRITE_ONCE(uc->args[i], va_arg(va, u64));
 	va_end(va);
 
 	ucall_arch_do_ucall((gva_t)uc->hva);
@@ -140,7 +140,7 @@ void ucall(uint64_t cmd, int nargs, ...)
 	ucall_free(uc);
 }
 
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+u64 get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 {
 	struct ucall ucall;
 	void *addr;
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 5bde176cedd5..516ae5bd7576 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -100,8 +100,8 @@ static void *uffd_handler_thread_fn(void *arg)
 }
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
-					   void *hva, uint64_t len,
-					   uint64_t num_readers,
+					   void *hva, u64 len,
+					   u64 num_readers,
 					   uffd_handler_t handler)
 {
 	struct uffd_desc *uffd_desc;
@@ -109,7 +109,7 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 	int uffd;
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
-	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
+	u64 expected_ioctls = ((u64)1) << _UFFDIO_COPY;
 	int ret, i;
 
 	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
@@ -132,7 +132,7 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 
 	/* In order to get minor faults, prefault via the alias. */
 	if (is_minor)
-		expected_ioctls = ((uint64_t) 1) << _UFFDIO_CONTINUE;
+		expected_ioctls = ((u64) 1) << _UFFDIO_CONTINUE;
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
@@ -141,9 +141,9 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 	uffdio_api.features = 0;
 	TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
 		    "ioctl UFFDIO_API failed: %" PRIu64,
-		    (uint64_t)uffdio_api.api);
+		    (u64)uffdio_api.api);
 
-	uffdio_register.range.start = (uint64_t)hva;
+	uffdio_register.range.start = (u64)hva;
 	uffdio_register.range.len = len;
 	uffdio_register.mode = uffd_mode;
 	TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
diff --git a/tools/testing/selftests/kvm/lib/x86/apic.c b/tools/testing/selftests/kvm/lib/x86/apic.c
index 89153a333e83..5182fd0d6a76 100644
--- a/tools/testing/selftests/kvm/lib/x86/apic.c
+++ b/tools/testing/selftests/kvm/lib/x86/apic.c
@@ -14,7 +14,7 @@ void apic_disable(void)
 
 void xapic_enable(void)
 {
-	uint64_t val = rdmsr(MSR_IA32_APICBASE);
+	u64 val = rdmsr(MSR_IA32_APICBASE);
 
 	/* Per SDM: to enable xAPIC when in x2APIC must first disable APIC */
 	if (val & MSR_IA32_APICBASE_EXTD) {
diff --git a/tools/testing/selftests/kvm/lib/x86/hyperv.c b/tools/testing/selftests/kvm/lib/x86/hyperv.c
index 2284bc936404..2eb3f0d15576 100644
--- a/tools/testing/selftests/kvm/lib/x86/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86/hyperv.c
@@ -100,9 +100,9 @@ struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 	return hv;
 }
 
-int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist)
+int enable_vp_assist(u64 vp_assist_pa, void *vp_assist)
 {
-	uint64_t val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
+	u64 val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
 		HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
 
 	wrmsr(HV_X64_MSR_VP_ASSIST_PAGE, val);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index e5249c442318..4a72cb8e1f94 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -15,7 +15,7 @@
 #include "processor.h"
 #include "vmx.h"
 
-void memstress_l2_guest_code(uint64_t vcpu_id)
+void memstress_l2_guest_code(u64 vcpu_id)
 {
 	memstress_guest_code(vcpu_id);
 	vmcall();
@@ -29,7 +29,7 @@ __asm__(
 "	ud2;"
 );
 
-static void memstress_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
+static void memstress_l1_guest_code(struct vmx_pages *vmx, u64 vcpu_id)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -49,7 +49,7 @@ static void memstress_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
 	GUEST_DONE();
 }
 
-uint64_t memstress_nested_pages(int nr_vcpus)
+u64 memstress_nested_pages(int nr_vcpus)
 {
 	/*
 	 * 513 page tables is enough to identity-map 256 TiB of L2 with 1G
@@ -61,7 +61,7 @@ uint64_t memstress_nested_pages(int nr_vcpus)
 
 void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
-	uint64_t start, end;
+	u64 start, end;
 
 	prepare_eptp(vmx, vm, 0);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index f31f0427c17c..e80e4d46fb29 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -10,7 +10,7 @@
 #include "kvm_util.h"
 #include "pmu.h"
 
-const uint64_t intel_pmu_arch_events[] = {
+const u64 intel_pmu_arch_events[] = {
 	INTEL_ARCH_CPU_CYCLES,
 	INTEL_ARCH_INSTRUCTIONS_RETIRED,
 	INTEL_ARCH_REFERENCE_CYCLES,
@@ -22,7 +22,7 @@ const uint64_t intel_pmu_arch_events[] = {
 };
 kvm_static_assert(ARRAY_SIZE(intel_pmu_arch_events) == NR_INTEL_ARCH_EVENTS);
 
-const uint64_t amd_pmu_zen_events[] = {
+const u64 amd_pmu_zen_events[] = {
 	AMD_ZEN_CORE_CYCLES,
 	AMD_ZEN_INSTRUCTIONS_RETIRED,
 	AMD_ZEN_BRANCHES_RETIRED,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 5a97cf829291..e06dec2fddc2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -21,7 +21,7 @@ gva_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
-uint64_t guest_tsc_khz;
+u64 guest_tsc_khz;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -134,11 +134,11 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level)
+static void *virt_get_pte(struct kvm_vm *vm, u64 *parent_pte,
+			  u64 vaddr, int level)
 {
-	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
-	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
+	u64 pt_gpa = PTE_GET_PA(*parent_pte);
+	u64 *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
 	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->pgd,
@@ -148,14 +148,14 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
 	return &page_table[index];
 }
 
-static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
-				       uint64_t *parent_pte,
-				       uint64_t vaddr,
-				       uint64_t paddr,
-				       int current_level,
-				       int target_level)
+static u64 *virt_create_upper_pte(struct kvm_vm *vm,
+				  u64 *parent_pte,
+				  u64 vaddr,
+				  u64 paddr,
+				  int current_level,
+				  int target_level)
 {
-	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
+	u64 *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
@@ -181,11 +181,11 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+void __virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr, int level)
 {
-	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pml4e, *pdpe, *pde;
-	uint64_t *pte;
+	const u64 pg_size = PG_LEVEL_SIZE(level);
+	u64 *pml4e, *pdpe, *pde;
+	u64 *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
 		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -237,16 +237,16 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		*pte |= vm->arch.s_bit;
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 {
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
-void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		    uint64_t nr_bytes, int level)
+void virt_map_level(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+		    u64 nr_bytes, int level)
 {
-	uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t nr_pages = nr_bytes / pg_size;
+	u64 pg_size = PG_LEVEL_SIZE(level);
+	u64 nr_pages = nr_bytes / pg_size;
 	int i;
 
 	TEST_ASSERT(nr_bytes % pg_size == 0,
@@ -261,7 +261,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+static bool vm_is_target_pte(u64 *pte, int *level, int current_level)
 {
 	if (*pte & PTE_LARGE_MASK) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
@@ -273,10 +273,9 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level)
+u64 *__vm_get_page_table_entry(struct kvm_vm *vm, u64 vaddr, int *level)
 {
-	uint64_t *pml4e, *pdpe, *pde;
+	u64 *pml4e, *pdpe, *pde;
 
 	TEST_ASSERT(!vm->arch.is_pt_protected,
 		    "Walking page tables of protected guests is impossible");
@@ -312,7 +311,7 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 	return virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+u64 *vm_get_page_table_entry(struct kvm_vm *vm, u64 vaddr)
 {
 	int level = PG_LEVEL_4K;
 
@@ -321,10 +320,10 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	uint64_t *pml4e, *pml4e_start;
-	uint64_t *pdpe, *pdpe_start;
-	uint64_t *pde, *pde_start;
-	uint64_t *pte, *pte_start;
+	u64 *pml4e, *pml4e_start;
+	u64 *pdpe, *pdpe_start;
+	u64 *pde, *pde_start;
+	u64 *pte, *pte_start;
 
 	if (!vm->pgd_created)
 		return;
@@ -334,7 +333,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*s      index hvaddr         gpaddr         "
 		"addr         w exec dirty\n",
 		indent, "");
-	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
+	pml4e_start = addr_gpa2hva(vm, vm->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
 		if (!(*pml4e & PTE_PRESENT_MASK))
@@ -386,10 +385,10 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 						!!(*pte & PTE_WRITABLE_MASK),
 						!!(*pte & PTE_NX_MASK),
 						!!(*pte & PTE_DIRTY_MASK),
-						((uint64_t) n1 << 27)
-							| ((uint64_t) n2 << 18)
-							| ((uint64_t) n3 << 9)
-							| ((uint64_t) n4));
+						((u64)n1 << 27)
+							| ((u64)n2 << 18)
+							| ((u64)n3 << 9)
+							| ((u64)n4));
 				}
 			}
 		}
@@ -466,7 +465,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
-	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
+	u64 *pte = __vm_get_page_table_entry(vm, gva, &level);
 
 	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
@@ -782,7 +781,7 @@ uint32_t kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
 			     property.reg, property.lo_bit, property.hi_bit);
 }
 
-uint64_t kvm_get_feature_msr(uint64_t msr_index)
+u64 kvm_get_feature_msr(u64 msr_index)
 {
 	struct {
 		struct kvm_msrs header;
@@ -801,7 +800,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-void __vm_xsave_require_permission(uint64_t xfeature, const char *name)
+void __vm_xsave_require_permission(u64 xfeature, const char *name)
 {
 	int kvm_fd;
 	u64 bitmask;
@@ -902,7 +901,7 @@ void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 	vcpu_set_cpuid(vcpu);
 }
 
-uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
+u64 vcpu_get_msr(struct kvm_vcpu *vcpu, u64 msr_index)
 {
 	struct {
 		struct kvm_msrs header;
@@ -917,7 +916,7 @@ uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value)
+int _vcpu_set_msr(struct kvm_vcpu *vcpu, u64 msr_index, u64 msr_value)
 {
 	struct {
 		struct kvm_msrs header;
@@ -945,22 +944,22 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	vcpu_regs_get(vcpu, &regs);
 
 	if (num >= 1)
-		regs.rdi = va_arg(ap, uint64_t);
+		regs.rdi = va_arg(ap, u64);
 
 	if (num >= 2)
-		regs.rsi = va_arg(ap, uint64_t);
+		regs.rsi = va_arg(ap, u64);
 
 	if (num >= 3)
-		regs.rdx = va_arg(ap, uint64_t);
+		regs.rdx = va_arg(ap, u64);
 
 	if (num >= 4)
-		regs.rcx = va_arg(ap, uint64_t);
+		regs.rcx = va_arg(ap, u64);
 
 	if (num >= 5)
-		regs.r8 = va_arg(ap, uint64_t);
+		regs.r8 = va_arg(ap, u64);
 
 	if (num >= 6)
-		regs.r9 = va_arg(ap, uint64_t);
+		regs.r9 = va_arg(ap, u64);
 
 	vcpu_regs_set(vcpu, &regs);
 	va_end(ap);
@@ -1183,7 +1182,7 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 
 #define X86_HYPERCALL(inputs...)					\
 ({									\
-	uint64_t r;							\
+	u64 r;							\
 									\
 	asm volatile("test %[use_vmmcall], %[use_vmmcall]\n\t"		\
 		     "jnz 1f\n\t"					\
@@ -1197,18 +1196,17 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 	r;								\
 })
 
-uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
-		       uint64_t a3)
+u64 kvm_hypercall(u64 nr, u64 a0, u64 a1, u64 a2, u64 a3)
 {
 	return X86_HYPERCALL("a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 }
 
-uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1)
+u64 __xen_hypercall(u64 nr, u64 a0, void *a1)
 {
 	return X86_HYPERCALL("a"(nr), "D"(a0), "S"(a1));
 }
 
-void xen_hypercall(uint64_t nr, uint64_t a0, void *a1)
+void xen_hypercall(u64 nr, u64 a0, void *a1)
 {
 	GUEST_ASSERT(!__xen_hypercall(nr, a0, a1));
 }
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index 5fcd26ac2def..e677eeeb05f7 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -27,8 +27,8 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 	sev_register_encrypted_memory(vm, region);
 
 	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
-		const uint64_t size = (j - i + 1) * vm->page_size;
-		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
+		const u64 size = (j - i + 1) * vm->page_size;
+		const u64 offset = (i - lowest_page_in_region) * vm->page_size;
 
 		sev_launch_update_data(vm, gpa_base + offset, size);
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 104fe606d7d1..d8ed7f0f8235 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -62,14 +62,14 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
-	uint64_t vmcb_gpa = svm->vmcb_gpa;
+	u64 vmcb_gpa = svm->vmcb_gpa;
 	struct vmcb_save_area *save = &vmcb->save;
 	struct vmcb_control_area *ctrl = &vmcb->control;
 	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
 	      | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
 	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
 		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
-	uint64_t efer;
+	u64 efer;
 
 	efer = rdmsr(MSR_EFER);
 	wrmsr(MSR_EFER, efer | EFER_SVME);
@@ -131,7 +131,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
  * for now. registers involved in LOAD/SAVE_GPR_C are eventually
  * unmodified so they do not need to be in the clobber list.
  */
-void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
+void run_guest(struct vmcb *vmcb, u64 vmcb_gpa)
 {
 	asm volatile (
 		"vmload %[vmcb_gpa]\n\t"
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index ea37261b207c..11f89ffc28bc 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -20,27 +20,27 @@ struct hv_enlightened_vmcs *current_evmcs;
 struct hv_vp_assist_page *current_vp_assist;
 
 struct eptPageTableEntry {
-	uint64_t readable:1;
-	uint64_t writable:1;
-	uint64_t executable:1;
-	uint64_t memory_type:3;
-	uint64_t ignore_pat:1;
-	uint64_t page_size:1;
-	uint64_t accessed:1;
-	uint64_t dirty:1;
-	uint64_t ignored_11_10:2;
-	uint64_t address:40;
-	uint64_t ignored_62_52:11;
-	uint64_t suppress_ve:1;
+	u64 readable:1;
+	u64 writable:1;
+	u64 executable:1;
+	u64 memory_type:3;
+	u64 ignore_pat:1;
+	u64 page_size:1;
+	u64 accessed:1;
+	u64 dirty:1;
+	u64 ignored_11_10:2;
+	u64 address:40;
+	u64 ignored_62_52:11;
+	u64 suppress_ve:1;
 };
 
 struct eptPageTablePointer {
-	uint64_t memory_type:3;
-	uint64_t page_walk_length:3;
-	uint64_t ad_enabled:1;
-	uint64_t reserved_11_07:5;
-	uint64_t address:40;
-	uint64_t reserved_63_52:12;
+	u64 memory_type:3;
+	u64 page_walk_length:3;
+	u64 ad_enabled:1;
+	u64 reserved_11_07:5;
+	u64 address:40;
+	u64 reserved_63_52:12;
 };
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
@@ -113,8 +113,8 @@ vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva)
 
 bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 {
-	uint64_t feature_control;
-	uint64_t required;
+	u64 feature_control;
+	u64 required;
 	unsigned long cr0;
 	unsigned long cr4;
 
@@ -173,7 +173,7 @@ bool load_vmcs(struct vmx_pages *vmx)
 	return true;
 }
 
-static bool ept_vpid_cap_supported(uint64_t mask)
+static bool ept_vpid_cap_supported(u64 mask)
 {
 	return rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & mask;
 }
@@ -196,7 +196,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, rdmsr(MSR_IA32_VMX_TRUE_PINBASED_CTLS));
 
 	if (vmx->eptp_gpa) {
-		uint64_t ept_paddr;
+		u64 ept_paddr;
 		struct eptPageTablePointer eptp = {
 			.memory_type = X86_MEMTYPE_WB,
 			.page_walk_length = 3, /* + 1 */
@@ -347,8 +347,8 @@ static inline void init_vmcs_guest_state(void *rip, void *rsp)
 	vmwrite(GUEST_GDTR_BASE, vmreadz(HOST_GDTR_BASE));
 	vmwrite(GUEST_IDTR_BASE, vmreadz(HOST_IDTR_BASE));
 	vmwrite(GUEST_DR7, 0x400);
-	vmwrite(GUEST_RSP, (uint64_t)rsp);
-	vmwrite(GUEST_RIP, (uint64_t)rip);
+	vmwrite(GUEST_RSP, (u64)rsp);
+	vmwrite(GUEST_RIP, (u64)rip);
 	vmwrite(GUEST_RFLAGS, 2);
 	vmwrite(GUEST_PENDING_DBG_EXCEPTIONS, 0);
 	vmwrite(GUEST_SYSENTER_ESP, vmreadz(HOST_IA32_SYSENTER_ESP));
@@ -364,8 +364,8 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 
 static void nested_create_pte(struct kvm_vm *vm,
 			      struct eptPageTableEntry *pte,
-			      uint64_t nested_paddr,
-			      uint64_t paddr,
+			      u64 nested_paddr,
+			      u64 paddr,
 			      int current_level,
 			      int target_level)
 {
@@ -395,9 +395,9 @@ static void nested_create_pte(struct kvm_vm *vm,
 
 
 void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		     uint64_t nested_paddr, uint64_t paddr, int target_level)
+		     u64 nested_paddr, u64 paddr, int target_level)
 {
-	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
+	const u64 page_size = PG_LEVEL_SIZE(target_level);
 	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
 	uint16_t index;
 
@@ -446,7 +446,7 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 }
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
+		   u64 nested_paddr, u64 paddr)
 {
 	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
@@ -469,7 +469,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * page range starting at nested_paddr to the page range starting at paddr.
  */
 void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+		  u64 nested_paddr, u64 paddr, u64 size,
 		  int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
@@ -486,7 +486,7 @@ void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 }
 
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+		u64 nested_paddr, u64 paddr, u64 size)
 {
 	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
@@ -509,22 +509,22 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			break;
 
 		nested_map(vmx, vm,
-			   (uint64_t)i << vm->page_shift,
-			   (uint64_t)i << vm->page_shift,
+			   (u64)i << vm->page_shift,
+			   (u64)i << vm->page_shift,
 			   1 << vm->page_shift);
 	}
 }
 
 /* Identity map a region with 1GiB Pages. */
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size)
+			    u64 addr, u64 size)
 {
 	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
 {
-	uint64_t ctrl;
+	u64 ctrl;
 
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index c81a84990eab..a0ea83741d4f 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -29,7 +29,7 @@
 
 
 static int nr_vcpus = 1;
-static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+static u64 guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
@@ -54,10 +54,10 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 }
 
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
-			       uint64_t nr_modifications)
+			       u64 nr_modifications)
 {
-	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
-	uint64_t gpa;
+	u64 pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
+	u64 gpa;
 	int i;
 
 	/*
@@ -77,7 +77,7 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 
 struct test_params {
 	useconds_t delay;
-	uint64_t nr_iterations;
+	u64 nr_iterations;
 	bool partition_vcpu_memory_access;
 	bool disable_slot_zap_quirk;
 };
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e3711beff7f3..7ad29c775336 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -85,12 +85,12 @@ struct vm_data {
 	struct kvm_vcpu *vcpu;
 	pthread_t vcpu_thread;
 	uint32_t nslots;
-	uint64_t npages;
-	uint64_t pages_per_slot;
+	u64 npages;
+	u64 pages_per_slot;
 	void **hva_slots;
 	bool mmio_ok;
-	uint64_t mmio_gpa_min;
-	uint64_t mmio_gpa_max;
+	u64 mmio_gpa_min;
+	u64 mmio_gpa_max;
 };
 
 struct sync_area {
@@ -185,9 +185,9 @@ static void wait_for_vcpu(void)
 		    "sem_timedwait() failed: %d", errno);
 }
 
-static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
+static void *vm_gpa2hva(struct vm_data *data, u64 gpa, u64 *rempages)
 {
-	uint64_t gpage, pgoffs;
+	u64 gpage, pgoffs;
 	uint32_t slot, slotoffs;
 	void *base;
 	uint32_t guest_page_size = data->vm->page_size;
@@ -199,11 +199,11 @@ static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
 
 	gpage = gpa / guest_page_size;
 	pgoffs = gpa % guest_page_size;
-	slot = min(gpage / data->pages_per_slot, (uint64_t)data->nslots - 1);
+	slot = min(gpage / data->pages_per_slot, (u64)data->nslots - 1);
 	slotoffs = gpage - (slot * data->pages_per_slot);
 
 	if (rempages) {
-		uint64_t slotpages;
+		u64 slotpages;
 
 		if (slot == data->nslots - 1)
 			slotpages = data->npages - slot * data->pages_per_slot;
@@ -219,7 +219,7 @@ static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
 	return (uint8_t *)base + slotoffs * guest_page_size + pgoffs;
 }
 
-static uint64_t vm_slot2gpa(struct vm_data *data, uint32_t slot)
+static u64 vm_slot2gpa(struct vm_data *data, uint32_t slot)
 {
 	uint32_t guest_page_size = data->vm->page_size;
 
@@ -243,7 +243,7 @@ static struct vm_data *alloc_vm(void)
 }
 
 static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
-			     uint64_t pages_per_slot, uint64_t rempages)
+			     u64 pages_per_slot, u64 rempages)
 {
 	if (!pages_per_slot)
 		return false;
@@ -258,11 +258,11 @@ static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
 }
 
 
-static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
+static u64 get_max_slots(struct vm_data *data, uint32_t host_page_size)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t mempages, pages_per_slot, rempages;
-	uint64_t slots;
+	u64 mempages, pages_per_slot, rempages;
+	u64 slots;
 
 	mempages = data->npages;
 	slots = data->nslots;
@@ -280,12 +280,12 @@ static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
 	return 0;
 }
 
-static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
-		       void *guest_code, uint64_t mem_size,
+static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
+		       void *guest_code, u64 mem_size,
 		       struct timespec *slot_runtime)
 {
-	uint64_t mempages, rempages;
-	uint64_t guest_addr;
+	u64 mempages, rempages;
+	u64 guest_addr;
 	uint32_t slot, host_page_size, guest_page_size;
 	struct timespec tstart;
 	struct sync_area *sync;
@@ -316,7 +316,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 
 	clock_gettime(CLOCK_MONOTONIC, &tstart);
 	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
-		uint64_t npages;
+		u64 npages;
 
 		npages = data->pages_per_slot;
 		if (slot == data->nslots)
@@ -330,8 +330,8 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	*slot_runtime = timespec_elapsed(tstart);
 
 	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
-		uint64_t npages;
-		uint64_t gpa;
+		u64 npages;
+		u64 gpa;
 
 		npages = data->pages_per_slot;
 		if (slot == data->nslots)
@@ -459,7 +459,7 @@ static void guest_code_test_memslot_move(void)
 
 		for (ptr = base; ptr < base + MEM_TEST_MOVE_SIZE;
 		     ptr += page_size)
-			*(uint64_t *)ptr = MEM_TEST_VAL_1;
+			*(u64 *)ptr = MEM_TEST_VAL_1;
 
 		/*
 		 * No host sync here since the MMIO exits are so expensive
@@ -488,7 +488,7 @@ static void guest_code_test_memslot_map(void)
 		for (ptr = MEM_TEST_GPA;
 		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE / 2;
 		     ptr += page_size)
-			*(uint64_t *)ptr = MEM_TEST_VAL_1;
+			*(u64 *)ptr = MEM_TEST_VAL_1;
 
 		if (!guest_perform_sync())
 			break;
@@ -496,7 +496,7 @@ static void guest_code_test_memslot_map(void)
 		for (ptr = MEM_TEST_GPA + MEM_TEST_MAP_SIZE / 2;
 		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE;
 		     ptr += page_size)
-			*(uint64_t *)ptr = MEM_TEST_VAL_2;
+			*(u64 *)ptr = MEM_TEST_VAL_2;
 
 		if (!guest_perform_sync())
 			break;
@@ -525,13 +525,13 @@ static void guest_code_test_memslot_unmap(void)
 		 *
 		 * Just access a single page to be on the safe side.
 		 */
-		*(uint64_t *)ptr = MEM_TEST_VAL_1;
+		*(u64 *)ptr = MEM_TEST_VAL_1;
 
 		if (!guest_perform_sync())
 			break;
 
 		ptr += MEM_TEST_UNMAP_SIZE / 2;
-		*(uint64_t *)ptr = MEM_TEST_VAL_2;
+		*(u64 *)ptr = MEM_TEST_VAL_2;
 
 		if (!guest_perform_sync())
 			break;
@@ -554,17 +554,17 @@ static void guest_code_test_memslot_rw(void)
 
 		for (ptr = MEM_TEST_GPA;
 		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size)
-			*(uint64_t *)ptr = MEM_TEST_VAL_1;
+			*(u64 *)ptr = MEM_TEST_VAL_1;
 
 		if (!guest_perform_sync())
 			break;
 
 		for (ptr = MEM_TEST_GPA + page_size / 2;
 		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size) {
-			uint64_t val = *(uint64_t *)ptr;
+			u64 val = *(u64 *)ptr;
 
 			GUEST_ASSERT_EQ(val, MEM_TEST_VAL_2);
-			*(uint64_t *)ptr = 0;
+			*(u64 *)ptr = 0;
 		}
 
 		if (!guest_perform_sync())
@@ -576,10 +576,10 @@ static void guest_code_test_memslot_rw(void)
 
 static bool test_memslot_move_prepare(struct vm_data *data,
 				      struct sync_area *sync,
-				      uint64_t *maxslots, bool isactive)
+				      u64 *maxslots, bool isactive)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t movesrcgpa, movetestgpa;
+	u64 movesrcgpa, movetestgpa;
 
 #ifdef __x86_64__
 	if (disable_slot_zap_quirk)
@@ -589,7 +589,7 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
 
 	if (isactive) {
-		uint64_t lastpages;
+		u64 lastpages;
 
 		vm_gpa2hva(data, movesrcgpa, &lastpages);
 		if (lastpages * guest_page_size < MEM_TEST_MOVE_SIZE / 2) {
@@ -612,21 +612,21 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 
 static bool test_memslot_move_prepare_active(struct vm_data *data,
 					     struct sync_area *sync,
-					     uint64_t *maxslots)
+					     u64 *maxslots)
 {
 	return test_memslot_move_prepare(data, sync, maxslots, true);
 }
 
 static bool test_memslot_move_prepare_inactive(struct vm_data *data,
 					       struct sync_area *sync,
-					       uint64_t *maxslots)
+					       u64 *maxslots)
 {
 	return test_memslot_move_prepare(data, sync, maxslots, false);
 }
 
 static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
 {
-	uint64_t movesrcgpa;
+	u64 movesrcgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
 	vm_mem_region_move(data->vm, data->nslots - 1 + 1,
@@ -635,13 +635,13 @@ static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
 }
 
 static void test_memslot_do_unmap(struct vm_data *data,
-				  uint64_t offsp, uint64_t count)
+				  u64 offsp, u64 count)
 {
-	uint64_t gpa, ctr;
+	u64 gpa, ctr;
 	uint32_t guest_page_size = data->vm->page_size;
 
 	for (gpa = MEM_TEST_GPA + offsp * guest_page_size, ctr = 0; ctr < count; ) {
-		uint64_t npages;
+		u64 npages;
 		void *hva;
 		int ret;
 
@@ -660,10 +660,10 @@ static void test_memslot_do_unmap(struct vm_data *data,
 }
 
 static void test_memslot_map_unmap_check(struct vm_data *data,
-					 uint64_t offsp, uint64_t valexp)
+					 u64 offsp, u64 valexp)
 {
-	uint64_t gpa;
-	uint64_t *val;
+	u64 gpa;
+	u64 *val;
 	uint32_t guest_page_size = data->vm->page_size;
 
 	if (!map_unmap_verify)
@@ -680,7 +680,7 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t guest_pages = MEM_TEST_MAP_SIZE / guest_page_size;
+	u64 guest_pages = MEM_TEST_MAP_SIZE / guest_page_size;
 
 	/*
 	 * Unmap the second half of the test area while guest writes to (maps)
@@ -717,11 +717,11 @@ static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 
 static void test_memslot_unmap_loop_common(struct vm_data *data,
 					   struct sync_area *sync,
-					   uint64_t chunk)
+					   u64 chunk)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t guest_pages = MEM_TEST_UNMAP_SIZE / guest_page_size;
-	uint64_t ctr;
+	u64 guest_pages = MEM_TEST_UNMAP_SIZE / guest_page_size;
+	u64 ctr;
 
 	/*
 	 * Wait for the guest to finish mapping page(s) in the first half
@@ -747,7 +747,7 @@ static void test_memslot_unmap_loop(struct vm_data *data,
 {
 	uint32_t host_page_size = getpagesize();
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t guest_chunk_pages = guest_page_size >= host_page_size ?
+	u64 guest_chunk_pages = guest_page_size >= host_page_size ?
 					1 : host_page_size / guest_page_size;
 
 	test_memslot_unmap_loop_common(data, sync, guest_chunk_pages);
@@ -757,26 +757,26 @@ static void test_memslot_unmap_loop_chunked(struct vm_data *data,
 					    struct sync_area *sync)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t guest_chunk_pages = MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size;
+	u64 guest_chunk_pages = MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size;
 
 	test_memslot_unmap_loop_common(data, sync, guest_chunk_pages);
 }
 
 static void test_memslot_rw_loop(struct vm_data *data, struct sync_area *sync)
 {
-	uint64_t gptr;
+	u64 gptr;
 	uint32_t guest_page_size = data->vm->page_size;
 
 	for (gptr = MEM_TEST_GPA + guest_page_size / 2;
 	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += guest_page_size)
-		*(uint64_t *)vm_gpa2hva(data, gptr, NULL) = MEM_TEST_VAL_2;
+		*(u64 *)vm_gpa2hva(data, gptr, NULL) = MEM_TEST_VAL_2;
 
 	host_perform_sync(sync);
 
 	for (gptr = MEM_TEST_GPA;
 	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += guest_page_size) {
-		uint64_t *vptr = (typeof(vptr))vm_gpa2hva(data, gptr, NULL);
-		uint64_t val = *vptr;
+		u64 *vptr = (typeof(vptr))vm_gpa2hva(data, gptr, NULL);
+		u64 val = *vptr;
 
 		TEST_ASSERT(val == MEM_TEST_VAL_1,
 			    "Guest written values should read back correctly (is %"PRIu64" @ %"PRIx64")",
@@ -789,21 +789,21 @@ static void test_memslot_rw_loop(struct vm_data *data, struct sync_area *sync)
 
 struct test_data {
 	const char *name;
-	uint64_t mem_size;
+	u64 mem_size;
 	void (*guest_code)(void);
 	bool (*prepare)(struct vm_data *data, struct sync_area *sync,
-			uint64_t *maxslots);
+			u64 *maxslots);
 	void (*loop)(struct vm_data *data, struct sync_area *sync);
 };
 
-static bool test_execute(int nslots, uint64_t *maxslots,
+static bool test_execute(int nslots, u64 *maxslots,
 			 unsigned int maxtime,
 			 const struct test_data *tdata,
-			 uint64_t *nloops,
+			 u64 *nloops,
 			 struct timespec *slot_runtime,
 			 struct timespec *guest_runtime)
 {
-	uint64_t mem_size = tdata->mem_size ? : MEM_SIZE;
+	u64 mem_size = tdata->mem_size ? : MEM_SIZE;
 	struct vm_data *data;
 	struct sync_area *sync;
 	struct timespec tstart;
@@ -1040,7 +1040,7 @@ static bool parse_args(int argc, char *argv[],
 struct test_result {
 	struct timespec slot_runtime, guest_runtime, iter_runtime;
 	int64_t slottimens, runtimens;
-	uint64_t nloops;
+	u64 nloops;
 };
 
 static bool test_loop(const struct test_data *data,
@@ -1048,7 +1048,7 @@ static bool test_loop(const struct test_data *data,
 		      struct test_result *rbestslottime,
 		      struct test_result *rbestruntime)
 {
-	uint64_t maxslots;
+	u64 maxslots;
 	struct test_result result = {};
 
 	if (!test_execute(targs->nslots, &maxslots, targs->seconds, data,
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 6a437d2be9fa..4c3b96dcab21 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -20,19 +20,19 @@
 static bool mprotect_ro_done;
 static bool all_vcpus_hit_ro_fault;
 
-static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
+static void guest_code(u64 start_gpa, u64 end_gpa, u64 stride)
 {
-	uint64_t gpa;
+	u64 gpa;
 	int i;
 
 	for (i = 0; i < 2; i++) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+			vcpu_arch_put_guest(*((volatile u64 *)gpa), gpa);
 		GUEST_SYNC(i);
 	}
 
 	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-		*((volatile uint64_t *)gpa);
+		*((volatile u64 *)gpa);
 	GUEST_SYNC(2);
 
 	/*
@@ -55,7 +55,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 #elif defined(__aarch64__)
 			asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
 #else
-			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+			vcpu_arch_put_guest(*((volatile u64 *)gpa), gpa);
 #endif
 	} while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));
 
@@ -68,7 +68,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 #endif
 
 	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-		vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+		vcpu_arch_put_guest(*((volatile u64 *)gpa), gpa);
 	GUEST_SYNC(4);
 
 	GUEST_ASSERT(0);
@@ -76,8 +76,8 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 struct vcpu_info {
 	struct kvm_vcpu *vcpu;
-	uint64_t start_gpa;
-	uint64_t end_gpa;
+	u64 start_gpa;
+	u64 end_gpa;
 };
 
 static int nr_vcpus;
@@ -203,10 +203,10 @@ static void *vcpu_worker(void *data)
 }
 
 static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
-				uint64_t start_gpa, uint64_t end_gpa)
+				u64 start_gpa, u64 end_gpa)
 {
 	struct vcpu_info *info;
-	uint64_t gpa, nr_bytes;
+	u64 gpa, nr_bytes;
 	pthread_t *threads;
 	int i;
 
@@ -217,7 +217,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
 	TEST_ASSERT(info, "Failed to allocate vCPU gpa ranges");
 
 	nr_bytes = ((end_gpa - start_gpa) / nr_vcpus) &
-			~((uint64_t)vm->page_size - 1);
+			~((u64)vm->page_size - 1);
 	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
 
 	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
@@ -276,11 +276,11 @@ int main(int argc, char *argv[])
 	 * just below the 4gb boundary.  This test could create memory at
 	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
 	 */
-	const uint64_t start_gpa = SZ_4G;
+	const u64 start_gpa = SZ_4G;
 	const int first_slot = 1;
 
 	struct timespec time_start, time_run1, time_reset, time_run2, time_ro, time_rw;
-	uint64_t max_gpa, gpa, slot_size, max_mem, i;
+	u64 max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
 	struct kvm_vcpu **vcpus;
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..4e4a3b483e6e 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -16,13 +16,13 @@
 #define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
 #define TEST_SLOT		10
 
-static void guest_code(uint64_t base_gpa)
+static void guest_code(u64 base_gpa)
 {
-	volatile uint64_t val __used;
+	volatile u64 val __used;
 	int i;
 
 	for (i = 0; i < TEST_NPAGES; i++) {
-		uint64_t *src = (uint64_t *)(base_gpa + i * PAGE_SIZE);
+		u64 *src = (u64 *)(base_gpa + i * PAGE_SIZE);
 
 		val = *src;
 	}
@@ -74,9 +74,9 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	uint64_t guest_test_phys_mem;
-	uint64_t guest_test_virt_mem;
-	uint64_t alignment, guest_page_size;
+	u64 guest_test_phys_mem;
+	u64 guest_test_virt_mem;
+	u64 alignment, guest_page_size;
 
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
index 9e370800a6a2..e8ddb168c13e 100644
--- a/tools/testing/selftests/kvm/riscv/arch_timer.c
+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -17,7 +17,7 @@ static int timer_irq = IRQ_S_TIMER;
 
 static void guest_irq_handler(struct ex_regs *regs)
 {
-	uint64_t xcnt, xcnt_diff_us, cmp;
+	u64 xcnt, xcnt_diff_us, cmp;
 	unsigned int intid = regs->cause & ~CAUSE_IRQ_FLAG;
 	uint32_t cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
index cfed6c727bfc..7fac0dff3b94 100644
--- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
+++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
@@ -8,10 +8,10 @@
 #include "kvm_util.h"
 #include "ucall_common.h"
 
-#define LABEL_ADDRESS(v) ((uint64_t)&(v))
+#define LABEL_ADDRESS(v) ((u64)&(v))
 
 extern unsigned char sw_bp_1, sw_bp_2;
-static uint64_t sw_bp_addr;
+static u64 sw_bp_addr;
 
 static void guest_code(void)
 {
@@ -37,7 +37,7 @@ int main(void)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	uint64_t pc;
+	u64 pc;
 	struct kvm_guest_debug debug = {
 		.control = KVM_GUESTDBG_ENABLE,
 	};
diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 569f2d67c9b8..f8f1ac4b5e5f 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -147,7 +147,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 {
 	unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] = { 0 };
 	struct vcpu_reg_sublist *s;
-	uint64_t feature;
+	u64 feature;
 	int rc;
 
 	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++)
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index c0ec7b284a3d..53ee31d144dc 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -87,7 +87,7 @@ unsigned long pmu_csr_read_num(int csr_num)
 #undef switchcase_csr_read
 }
 
-static inline void dummy_func_loop(uint64_t iter)
+static inline void dummy_func_loop(u64 iter)
 {
 	int i = 0;
 
diff --git a/tools/testing/selftests/kvm/s390/debug_test.c b/tools/testing/selftests/kvm/s390/debug_test.c
index ad8095968601..751c61c0f056 100644
--- a/tools/testing/selftests/kvm/s390/debug_test.c
+++ b/tools/testing/selftests/kvm/s390/debug_test.c
@@ -17,7 +17,7 @@ asm("int_handler:\n"
     "j .\n");
 
 static struct kvm_vm *test_step_int_1(struct kvm_vcpu **vcpu, void *guest_code,
-				      size_t new_psw_off, uint64_t *new_psw)
+				      size_t new_psw_off, u64 *new_psw)
 {
 	struct kvm_guest_debug debug = {};
 	struct kvm_regs regs;
@@ -27,7 +27,7 @@ static struct kvm_vm *test_step_int_1(struct kvm_vcpu **vcpu, void *guest_code,
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 	lowcore = addr_gpa2hva(vm, 0);
 	new_psw[0] = (*vcpu)->run->psw_mask;
-	new_psw[1] = (uint64_t)int_handler;
+	new_psw[1] = (u64)int_handler;
 	memcpy(lowcore + new_psw_off, new_psw, 16);
 	vcpu_regs_get(*vcpu, &regs);
 	regs.gprs[2] = -1;
@@ -42,7 +42,7 @@ static struct kvm_vm *test_step_int_1(struct kvm_vcpu **vcpu, void *guest_code,
 static void test_step_int(void *guest_code, size_t new_psw_off)
 {
 	struct kvm_vcpu *vcpu;
-	uint64_t new_psw[2];
+	u64 new_psw[2];
 	struct kvm_vm *vm;
 
 	vm = test_step_int_1(&vcpu, guest_code, new_psw_off, new_psw);
@@ -79,7 +79,7 @@ static void test_step_pgm_diag(void)
 		.u.pgm.code = PGM_SPECIFICATION,
 	};
 	struct kvm_vcpu *vcpu;
-	uint64_t new_psw[2];
+	u64 new_psw[2];
 	struct kvm_vm *vm;
 
 	vm = test_step_int_1(&vcpu, test_step_pgm_diag_guest_code,
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index a808fb2f6b2c..a6f90821835e 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -34,7 +34,7 @@ enum mop_access_mode {
 struct mop_desc {
 	uintptr_t gaddr;
 	uintptr_t gaddr_v;
-	uint64_t set_flags;
+	u64 set_flags;
 	unsigned int f_check : 1;
 	unsigned int f_inject : 1;
 	unsigned int f_key : 1;
@@ -85,7 +85,7 @@ static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc *desc)
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
 		if (desc->mode == CMPXCHG) {
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_CMPXCHG;
-			ksmo.old_addr = (uint64_t)desc->old;
+			ksmo.old_addr = (u64)desc->old;
 			memcpy(desc->old_value, desc->old, desc->size);
 		}
 		break;
@@ -489,7 +489,7 @@ static __uint128_t cut_to_size(int size, __uint128_t val)
 	case 4:
 		return (uint32_t)val;
 	case 8:
-		return (uint64_t)val;
+		return (u64)val;
 	case 16:
 		return val;
 	}
@@ -501,10 +501,10 @@ static bool popcount_eq(__uint128_t a, __uint128_t b)
 {
 	unsigned int count_a, count_b;
 
-	count_a = __builtin_popcountl((uint64_t)(a >> 64)) +
-		  __builtin_popcountl((uint64_t)a);
-	count_b = __builtin_popcountl((uint64_t)(b >> 64)) +
-		  __builtin_popcountl((uint64_t)b);
+	count_a = __builtin_popcountl((u64)(a >> 64)) +
+		  __builtin_popcountl((u64)a);
+	count_b = __builtin_popcountl((u64)(b >> 64)) +
+		  __builtin_popcountl((u64)b);
 	return count_a == count_b;
 }
 
@@ -598,15 +598,15 @@ static bool _cmpxchg(int size, void *target, __uint128_t *old_addr, __uint128_t
 			return ret;
 		}
 	case 8: {
-			uint64_t old = *old_addr;
+			u64 old = *old_addr;
 
 			asm volatile ("csg %[old],%[new],%[address]"
 			    : [old] "+d" (old),
-			      [address] "+Q" (*(uint64_t *)(target))
-			    : [new] "d" ((uint64_t)new)
+			      [address] "+Q" (*(u64 *)(target))
+			    : [new] "d" ((u64)new)
 			    : "cc"
 			);
-			ret = old == (uint64_t)*old_addr;
+			ret = old == (u64)*old_addr;
 			*old_addr = old;
 			return ret;
 		}
@@ -811,10 +811,10 @@ static void test_errors_cmpxchg_key(void)
 static void test_termination(void)
 {
 	struct test_default t = test_default_init(guest_error_key);
-	uint64_t prefix;
-	uint64_t teid;
-	uint64_t teid_mask = BIT(63 - 56) | BIT(63 - 60) | BIT(63 - 61);
-	uint64_t psw[2];
+	u64 prefix;
+	u64 teid;
+	u64 teid_mask = BIT(63 - 56) | BIT(63 - 60) | BIT(63 - 61);
+	u64 psw[2];
 
 	HOST_SYNC(t.vcpu, STAGE_INITED);
 	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
@@ -855,7 +855,7 @@ static void test_errors_key_storage_prot_override(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
-const uint64_t last_page_addr = -PAGE_SIZE;
+const u64 last_page_addr = -PAGE_SIZE;
 
 static void guest_copy_key_fetch_prot_override(void)
 {
diff --git a/tools/testing/selftests/kvm/s390/resets.c b/tools/testing/selftests/kvm/s390/resets.c
index b58f75b381e5..7a81d07500bd 100644
--- a/tools/testing/selftests/kvm/s390/resets.c
+++ b/tools/testing/selftests/kvm/s390/resets.c
@@ -57,9 +57,9 @@ static void guest_code_initial(void)
 		);
 }
 
-static void test_one_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t value)
+static void test_one_reg(struct kvm_vcpu *vcpu, u64 id, u64 value)
 {
-	uint64_t eval_reg;
+	u64 eval_reg;
 
 	eval_reg = vcpu_get_reg(vcpu, id);
 	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
diff --git a/tools/testing/selftests/kvm/s390/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
index b50209979e10..ffd5d139082a 100644
--- a/tools/testing/selftests/kvm/s390/tprot.c
+++ b/tools/testing/selftests/kvm/s390/tprot.c
@@ -46,7 +46,7 @@ enum permission {
 
 static enum permission test_protection(void *addr, uint8_t key)
 {
-	uint64_t mask;
+	u64 mask;
 
 	asm volatile (
 		       "tprot	%[addr], 0(%[key])\n"
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index bc440d5aba57..6c680fcf07a4 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -30,19 +30,19 @@
 #define MEM_REGION_GPA		0xc0000000
 #define MEM_REGION_SLOT		10
 
-static const uint64_t MMIO_VAL = 0xbeefull;
+static const u64 MMIO_VAL = 0xbeefull;
 
-extern const uint64_t final_rip_start;
-extern const uint64_t final_rip_end;
+extern const u64 final_rip_start;
+extern const u64 final_rip_end;
 
 static sem_t vcpu_ready;
 
-static inline uint64_t guest_spin_on_val(uint64_t spin_val)
+static inline u64 guest_spin_on_val(u64 spin_val)
 {
-	uint64_t val;
+	u64 val;
 
 	do {
-		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
+		val = READ_ONCE(*((u64 *)MEM_REGION_GPA));
 	} while (val == spin_val);
 
 	GUEST_SYNC(0);
@@ -54,7 +54,7 @@ static void *vcpu_worker(void *data)
 	struct kvm_vcpu *vcpu = data;
 	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
-	uint64_t cmd;
+	u64 cmd;
 
 	/*
 	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
@@ -111,8 +111,8 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 			       void *guest_code)
 {
 	struct kvm_vm *vm;
-	uint64_t *hva;
-	uint64_t gpa;
+	u64 *hva;
+	u64 gpa;
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
@@ -144,7 +144,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 
 static void guest_code_move_memory_region(void)
 {
-	uint64_t val;
+	u64 val;
 
 	GUEST_SYNC(0);
 
@@ -180,7 +180,7 @@ static void test_move_memory_region(bool disable_slot_zap_quirk)
 	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t *hva;
+	u64 *hva;
 
 	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_move_memory_region);
 
@@ -224,7 +224,7 @@ static void test_move_memory_region(bool disable_slot_zap_quirk)
 static void guest_code_delete_memory_region(void)
 {
 	struct desc_ptr idt;
-	uint64_t val;
+	u64 val;
 
 	/*
 	 * Clobber the IDT so that a #PF due to the memory region being deleted
@@ -441,9 +441,9 @@ static void test_add_max_memory_regions(void)
 
 	for (slot = 0; slot < max_mem_slots; slot++)
 		vm_set_user_memory_region(vm, slot, 0,
-					  ((uint64_t)slot * MEM_REGION_SIZE),
+					  ((u64)slot * MEM_REGION_SIZE),
 					  MEM_REGION_SIZE,
-					  mem_aligned + (uint64_t)slot * MEM_REGION_SIZE);
+					  mem_aligned + (u64)slot * MEM_REGION_SIZE);
 
 	/* Check it cannot be added memory slots beyond the limit */
 	mem_extra = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
@@ -451,7 +451,7 @@ static void test_add_max_memory_regions(void)
 	TEST_ASSERT(mem_extra != MAP_FAILED, "Failed to mmap() host");
 
 	ret = __vm_set_user_memory_region(vm, max_mem_slots, 0,
-					  (uint64_t)max_mem_slots * MEM_REGION_SIZE,
+					  (u64)max_mem_slots * MEM_REGION_SIZE,
 					  MEM_REGION_SIZE, mem_extra);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Adding one more memory slot should fail with EINVAL");
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fd931243b6ce..3370988bd35b 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -25,7 +25,7 @@
 #define ST_GPA_BASE		(1 << 30)
 
 static void *st_gva[NR_VCPUS];
-static uint64_t guest_stolen_time[NR_VCPUS];
+static u64 guest_stolen_time[NR_VCPUS];
 
 #if defined(__x86_64__)
 
@@ -44,7 +44,7 @@ static void guest_code(int cpu)
 	struct kvm_steal_time *st = st_gva[cpu];
 	uint32_t version;
 
-	GUEST_ASSERT_EQ(rdmsr(MSR_KVM_STEAL_TIME), ((uint64_t)st_gva[cpu] | KVM_MSR_ENABLED));
+	GUEST_ASSERT_EQ(rdmsr(MSR_KVM_STEAL_TIME), ((u64)st_gva[cpu] | KVM_MSR_ENABLED));
 
 	memset(st, 0, sizeof(*st));
 	GUEST_SYNC(0);
@@ -111,10 +111,10 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 struct st_time {
 	uint32_t rev;
 	uint32_t attr;
-	uint64_t st_time;
+	u64 st_time;
 };
 
-static int64_t smccc(uint32_t func, uint64_t arg)
+static int64_t smccc(uint32_t func, u64 arg)
 {
 	struct arm_smccc_res res;
 
@@ -169,13 +169,13 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	struct kvm_vm *vm = vcpu->vm;
-	uint64_t st_ipa;
+	u64 st_ipa;
 	int ret;
 
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
 		.attr = KVM_ARM_VCPU_PVTIME_IPA,
-		.addr = (uint64_t)&st_ipa,
+		.addr = (u64)&st_ipa,
 	};
 
 	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
@@ -215,7 +215,7 @@ static gpa_t st_gpa[NR_VCPUS];
 struct sta_struct {
 	uint32_t sequence;
 	uint32_t flags;
-	uint64_t steal;
+	u64 steal;
 	uint8_t preempted;
 	uint8_t pad[47];
 } __packed;
@@ -268,7 +268,7 @@ static void guest_code(int cpu)
 
 static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 {
-	uint64_t id = RISCV_SBI_EXT_REG(KVM_RISCV_SBI_EXT_STA);
+	u64 id = RISCV_SBI_EXT_REG(KVM_RISCV_SBI_EXT_STA);
 	unsigned long enabled = vcpu_get_reg(vcpu, id);
 
 	TEST_ASSERT(enabled == 0 || enabled == 1, "Expected boolean result");
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 513d421a9bff..dc5e30b7b77f 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -17,7 +17,7 @@
 #ifdef __x86_64__
 
 struct test_case {
-	uint64_t tsc_offset;
+	u64 tsc_offset;
 };
 
 static struct test_case test_cases[] = {
@@ -39,12 +39,12 @@ static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
 			     &test->tsc_offset);
 }
 
-static uint64_t guest_read_system_counter(struct test_case *test)
+static u64 guest_read_system_counter(struct test_case *test)
 {
 	return rdtsc();
 }
 
-static uint64_t host_read_guest_system_counter(struct test_case *test)
+static u64 host_read_guest_system_counter(struct test_case *test)
 {
 	return rdtsc() + test->tsc_offset;
 }
@@ -69,9 +69,9 @@ static void guest_main(void)
 	}
 }
 
-static void handle_sync(struct ucall *uc, uint64_t start, uint64_t end)
+static void handle_sync(struct ucall *uc, u64 start, u64 end)
 {
-	uint64_t obs = uc->args[2];
+	u64 obs = uc->args[2];
 
 	TEST_ASSERT(start <= obs && obs <= end,
 		    "unexpected system counter value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
@@ -88,7 +88,7 @@ static void handle_abort(struct ucall *uc)
 
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
-	uint64_t start, end;
+	u64 start, end;
 	struct ucall uc;
 	int i;
 
diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index d49230ad5caf..b847b1b2d8b9 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -74,7 +74,7 @@ static inline void __tilerelease(void)
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0" ::);
 }
 
-static inline void __xsavec(struct xstate *xstate, uint64_t rfbm)
+static inline void __xsavec(struct xstate *xstate, u64 rfbm)
 {
 	uint32_t rfbm_lo = rfbm;
 	uint32_t rfbm_hi = rfbm >> 32;
diff --git a/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
index f8916bb34405..81f76c7d5621 100644
--- a/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
@@ -55,11 +55,11 @@ static void apic_write_reg(unsigned int reg, uint32_t val)
 		xapic_write_reg(reg, val);
 }
 
-static void apic_guest_code(uint64_t apic_hz, uint64_t delay_ms)
+static void apic_guest_code(u64 apic_hz, u64 delay_ms)
 {
-	uint64_t tsc_hz = guest_tsc_khz * 1000;
+	u64 tsc_hz = guest_tsc_khz * 1000;
 	const uint32_t tmict = ~0u;
-	uint64_t tsc0, tsc1, freq;
+	u64 tsc0, tsc1, freq;
 	uint32_t tmcct;
 	int i;
 
@@ -121,7 +121,7 @@ static void test_apic_bus_clock(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void run_apic_bus_clock_test(uint64_t apic_hz, uint64_t delay_ms,
+static void run_apic_bus_clock_test(u64 apic_hz, u64 delay_ms,
 				    bool x2apic)
 {
 	struct kvm_vcpu *vcpu;
@@ -168,8 +168,8 @@ int main(int argc, char *argv[])
 	 * Arbitrarilty default to 25MHz for the APIC bus frequency, which is
 	 * different enough from the default 1GHz to be interesting.
 	 */
-	uint64_t apic_hz = 25 * 1000 * 1000;
-	uint64_t delay_ms = 100;
+	u64 apic_hz = 25 * 1000 * 1000;
+	u64 delay_ms = 100;
 	int opt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
diff --git a/tools/testing/selftests/kvm/x86/debug_regs.c b/tools/testing/selftests/kvm/x86/debug_regs.c
index 2d814c1d1dc4..542a0eac0f32 100644
--- a/tools/testing/selftests/kvm/x86/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86/debug_regs.c
@@ -86,7 +86,7 @@ int main(void)
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint64_t cmd;
+	u64 cmd;
 	int i;
 	/* Instruction lengths starting at ss_start */
 	int ss_size[6] = {
diff --git a/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
index b0d2b04a7ff2..388ba4101f97 100644
--- a/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
@@ -23,7 +23,7 @@
 #define SLOTS		2
 #define ITERATIONS	2
 
-static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
+static u64 guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static enum vm_mem_backing_src_type backing_src = VM_MEM_SRC_ANONYMOUS_HUGETLB;
 
@@ -33,10 +33,10 @@ static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
 struct kvm_page_stats {
-	uint64_t pages_4k;
-	uint64_t pages_2m;
-	uint64_t pages_1g;
-	uint64_t hugepages;
+	u64 pages_4k;
+	u64 pages_2m;
+	u64 pages_1g;
+	u64 hugepages;
 };
 
 static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
@@ -89,9 +89,9 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 {
 	struct kvm_vm *vm;
 	unsigned long **bitmaps;
-	uint64_t guest_num_pages;
-	uint64_t host_num_pages;
-	uint64_t pages_per_slot;
+	u64 guest_num_pages;
+	u64 host_num_pages;
+	u64 pages_per_slot;
 	int i;
 	struct kvm_page_stats stats_populated;
 	struct kvm_page_stats stats_dirty_logging_enabled;
diff --git a/tools/testing/selftests/kvm/x86/feature_msrs_test.c b/tools/testing/selftests/kvm/x86/feature_msrs_test.c
index a72f13ae2edb..a0e54af60544 100644
--- a/tools/testing/selftests/kvm/x86/feature_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/feature_msrs_test.c
@@ -41,8 +41,8 @@ static bool is_quirked_msr(uint32_t msr)
 
 static void test_feature_msr(uint32_t msr)
 {
-	const uint64_t supported_mask = kvm_get_feature_msr(msr);
-	uint64_t reset_value = is_quirked_msr(msr) ? supported_mask : 0;
+	const u64 supported_mask = kvm_get_feature_msr(msr);
+	u64 reset_value = is_quirked_msr(msr) ? supported_mask : 0;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
index 762628f7d4ba..a2c8202cb80e 100644
--- a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
@@ -30,14 +30,14 @@ static const uint8_t vmx_vmcall[HYPERCALL_INSN_SIZE]  = { 0x0f, 0x01, 0xc1 };
 static const uint8_t svm_vmmcall[HYPERCALL_INSN_SIZE] = { 0x0f, 0x01, 0xd9 };
 
 extern uint8_t hypercall_insn[HYPERCALL_INSN_SIZE];
-static uint64_t do_sched_yield(uint8_t apic_id)
+static u64 do_sched_yield(uint8_t apic_id)
 {
-	uint64_t ret;
+	u64 ret;
 
 	asm volatile("hypercall_insn:\n\t"
 		     ".byte 0xcc,0xcc,0xcc\n\t"
 		     : "=a"(ret)
-		     : "a"((uint64_t)KVM_HC_SCHED_YIELD), "b"((uint64_t)apic_id)
+		     : "a"((u64)KVM_HC_SCHED_YIELD), "b"((u64)apic_id)
 		     : "memory");
 
 	return ret;
@@ -47,7 +47,7 @@ static void guest_main(void)
 {
 	const uint8_t *native_hypercall_insn;
 	const uint8_t *other_hypercall_insn;
-	uint64_t ret;
+	u64 ret;
 
 	if (host_cpu_is_intel) {
 		native_hypercall_insn = vmx_vmcall;
@@ -72,7 +72,7 @@ static void guest_main(void)
 	 * the "right" hypercall.
 	 */
 	if (quirk_disabled) {
-		GUEST_ASSERT(ret == (uint64_t)-EFAULT);
+		GUEST_ASSERT(ret == (u64)-EFAULT);
 		GUEST_ASSERT(!memcmp(other_hypercall_insn, hypercall_insn,
 			     HYPERCALL_INSN_SIZE));
 	} else {
diff --git a/tools/testing/selftests/kvm/x86/flds_emulation.h b/tools/testing/selftests/kvm/x86/flds_emulation.h
index 37b1a9f52864..c7e4f08765fb 100644
--- a/tools/testing/selftests/kvm/x86/flds_emulation.h
+++ b/tools/testing/selftests/kvm/x86/flds_emulation.h
@@ -12,7 +12,7 @@
  * KVM to emulate the instruction (e.g. by providing an MMIO address) to
  * exercise emulation failures.
  */
-static inline void flds(uint64_t address)
+static inline void flds(u64 address)
 {
 	__asm__ __volatile__(FLDS_MEM_EAX :: "a"(address));
 }
@@ -22,7 +22,7 @@ static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	struct kvm_regs regs;
 	uint8_t *insn_bytes;
-	uint64_t flags;
+	u64 flags;
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 
diff --git a/tools/testing/selftests/kvm/x86/hwcr_msr_test.c b/tools/testing/selftests/kvm/x86/hwcr_msr_test.c
index 10b1b0ba374e..8e20a03b3329 100644
--- a/tools/testing/selftests/kvm/x86/hwcr_msr_test.c
+++ b/tools/testing/selftests/kvm/x86/hwcr_msr_test.c
@@ -10,11 +10,11 @@
 
 void test_hwcr_bit(struct kvm_vcpu *vcpu, unsigned int bit)
 {
-	const uint64_t ignored = BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8);
-	const uint64_t valid = BIT_ULL(18) | BIT_ULL(24);
-	const uint64_t legal = ignored | valid;
-	uint64_t val = BIT_ULL(bit);
-	uint64_t actual;
+	const u64 ignored = BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8);
+	const u64 valid = BIT_ULL(18) | BIT_ULL(24);
+	const u64 legal = ignored | valid;
+	u64 val = BIT_ULL(bit);
+	u64 actual;
 	int r;
 
 	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index f2d990ce4e2b..2bad57246fe8 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -18,16 +18,16 @@
 static void guest_code(gpa_t in_pg_gpa, gpa_t out_pg_gpa,
 		       gva_t out_pg_gva)
 {
-	uint64_t *output_gva;
+	u64 *output_gva;
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, in_pg_gpa);
 
-	output_gva = (uint64_t *)out_pg_gva;
+	output_gva = (u64 *)out_pg_gva;
 
 	hyperv_hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, in_pg_gpa, out_pg_gpa);
 
-	/* TLFS states output will be a uint64_t value */
+	/* TLFS states output will be a u64 value */
 	GUEST_ASSERT_EQ(*output_gva, EXT_CAPABILITIES);
 
 	GUEST_DONE();
@@ -40,7 +40,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
-	uint64_t *outval;
+	u64 *outval;
 	struct ucall uc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index b3847b5ea314..c275c6401525 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -29,8 +29,8 @@ struct msr_data {
 };
 
 struct hcall_data {
-	uint64_t control;
-	uint64_t expect;
+	u64 control;
+	u64 expect;
 	bool ud_expected;
 };
 
@@ -42,7 +42,7 @@ static bool is_write_only_msr(uint32_t msr)
 static void guest_msr(struct msr_data *msr)
 {
 	uint8_t vector = 0;
-	uint64_t msr_val = 0;
+	u64 msr_val = 0;
 
 	GUEST_ASSERT(msr->idx);
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 85c2948e5a79..cdc9c6144477 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -18,7 +18,7 @@
 
 #define IPI_VECTOR	 0xfe
 
-static volatile uint64_t ipis_rcvd[RECEIVER_VCPU_ID_2 + 1];
+static volatile u64 ipis_rcvd[RECEIVER_VCPU_ID_2 + 1];
 
 struct hv_vpset {
 	u64 format;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index bc5828ce505e..f2bddd8b5f1f 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -135,10 +135,10 @@ static void set_expected_val(void *addr, u64 val, int vcpu_id)
  */
 static void swap_two_test_pages(gpa_t pte_gva1, gpa_t pte_gva2)
 {
-	uint64_t tmp = *(uint64_t *)pte_gva1;
+	u64 tmp = *(u64 *)pte_gva1;
 
-	*(uint64_t *)pte_gva1 = *(uint64_t *)pte_gva2;
-	*(uint64_t *)pte_gva2 = tmp;
+	*(u64 *)pte_gva1 = *(u64 *)pte_gva2;
+	*(u64 *)pte_gva2 = tmp;
 }
 
 /*
@@ -583,7 +583,7 @@ int main(int argc, char *argv[])
 	pthread_t threads[2];
 	gva_t test_data_page, gva;
 	gpa_t gpa;
-	uint64_t *pte;
+	u64 *pte;
 	struct test_data *data;
 	struct ucall uc;
 	int stage = 1, r, i;
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index ada4b2abf55d..e986d289e19b 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -17,7 +17,7 @@
 #include "processor.h"
 
 struct test_case {
-	uint64_t kvmclock_base;
+	u64 kvmclock_base;
 	int64_t realtime_offset;
 };
 
@@ -52,7 +52,7 @@ static inline void assert_flags(struct kvm_clock_data *data)
 static void handle_sync(struct ucall *uc, struct kvm_clock_data *start,
 			struct kvm_clock_data *end)
 {
-	uint64_t obs, exp_lo, exp_hi;
+	u64 obs, exp_lo, exp_hi;
 
 	obs = uc->args[2];
 	exp_lo = start->clock;
diff --git a/tools/testing/selftests/kvm/x86/kvm_pv_test.c b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
index 1b805cbdb47b..e49ae65f8171 100644
--- a/tools/testing/selftests/kvm/x86/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
@@ -40,7 +40,7 @@ static struct msr_data msrs_to_test[] = {
 
 static void test_msr(struct msr_data *msr)
 {
-	uint64_t ignored;
+	u64 ignored;
 	uint8_t vector;
 
 	PR_MSR(msr);
@@ -53,7 +53,7 @@ static void test_msr(struct msr_data *msr)
 }
 
 struct hcall_data {
-	uint64_t nr;
+	u64 nr;
 	const char *name;
 };
 
@@ -73,7 +73,7 @@ static struct hcall_data hcalls_to_test[] = {
 
 static void test_hcall(struct hcall_data *hc)
 {
-	uint64_t r;
+	u64 r;
 
 	PR_HCALL(hc);
 	r = kvm_hypercall(hc->nr, 0, 0, 0, 0);
diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 390ae2d87493..1e4a9a45c22a 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -67,7 +67,7 @@ static void guest_monitor_wait(void *arg)
 
 int main(int argc, char *argv[])
 {
-	uint64_t disabled_quirks;
+	u64 disabled_quirks;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
index c0d84827f736..70950067b989 100644
--- a/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
@@ -32,7 +32,7 @@
 #define RETURN_OPCODE 0xC3
 
 /* Call the specified memory address. */
-static void guest_do_CALL(uint64_t target)
+static void guest_do_CALL(u64 target)
 {
 	((void (*)(void)) target)();
 }
@@ -46,14 +46,14 @@ static void guest_do_CALL(uint64_t target)
  */
 void guest_code(void)
 {
-	uint64_t hpage_1 = HPAGE_GVA;
-	uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
-	uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
+	u64 hpage_1 = HPAGE_GVA;
+	u64 hpage_2 = hpage_1 + (PAGE_SIZE * 512);
+	u64 hpage_3 = hpage_2 + (PAGE_SIZE * 512);
 
-	READ_ONCE(*(uint64_t *)hpage_1);
+	READ_ONCE(*(u64 *)hpage_1);
 	GUEST_SYNC(1);
 
-	READ_ONCE(*(uint64_t *)hpage_2);
+	READ_ONCE(*(u64 *)hpage_2);
 	GUEST_SYNC(2);
 
 	guest_do_CALL(hpage_1);
@@ -62,10 +62,10 @@ void guest_code(void)
 	guest_do_CALL(hpage_3);
 	GUEST_SYNC(4);
 
-	READ_ONCE(*(uint64_t *)hpage_1);
+	READ_ONCE(*(u64 *)hpage_1);
 	GUEST_SYNC(5);
 
-	READ_ONCE(*(uint64_t *)hpage_3);
+	READ_ONCE(*(u64 *)hpage_3);
 	GUEST_SYNC(6);
 }
 
@@ -107,7 +107,7 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t nr_bytes;
+	u64 nr_bytes;
 	void *hva;
 	int r;
 
diff --git a/tools/testing/selftests/kvm/x86/platform_info_test.c b/tools/testing/selftests/kvm/x86/platform_info_test.c
index 9cbf283ebc55..86d1ab0db1e8 100644
--- a/tools/testing/selftests/kvm/x86/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86/platform_info_test.c
@@ -23,7 +23,7 @@
 
 static void guest_code(void)
 {
-	uint64_t msr_platform_info;
+	u64 msr_platform_info;
 	uint8_t vector;
 
 	GUEST_SYNC(true);
@@ -42,7 +42,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t msr_platform_info;
+	u64 msr_platform_info;
 	struct ucall uc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_MSR_PLATFORM_INFO));
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8aaaf25b6111..ef9ed5edf47b 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -85,7 +85,7 @@ static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code,
 						  uint8_t pmu_version,
-						  uint64_t perf_capabilities)
+						  u64 perf_capabilities)
 {
 	struct kvm_vm *vm;
 
@@ -150,7 +150,7 @@ static uint8_t guest_get_pmu_version(void)
  */
 static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
 {
-	uint64_t count;
+	u64 count;
 
 	count = _rdpmc(pmc);
 	if (!(hardware_pmu_arch_events & BIT(idx)))
@@ -238,7 +238,7 @@ do {										\
 } while (0)
 
 static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pmc_msr,
-				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
+				    uint32_t ctrl_msr, u64 ctrl_msr_value)
 {
 	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
 
@@ -271,7 +271,7 @@ static void guest_test_arch_event(uint8_t idx)
 	GUEST_ASSERT(nr_gp_counters);
 
 	for (i = 0; i < nr_gp_counters; i++) {
-		uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
+		u64 eventsel = ARCH_PERFMON_EVENTSEL_OS |
 				    ARCH_PERFMON_EVENTSEL_ENABLE |
 				    intel_pmu_arch_events[idx];
 
@@ -310,7 +310,7 @@ static void guest_test_arch_events(void)
 	GUEST_DONE();
 }
 
-static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
+static void test_arch_events(uint8_t pmu_version, u64 perf_capabilities,
 			     uint8_t length, uint8_t unavailable_mask)
 {
 	struct kvm_vcpu *vcpu;
@@ -353,10 +353,10 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       msr, expected, val);
 
 static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
-			     uint64_t expected_val)
+			     u64 expected_val)
 {
 	uint8_t vector;
-	uint64_t val;
+	u64 val;
 
 	vector = rdpmc_safe(rdpmc_idx, &val);
 	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
@@ -383,7 +383,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 * TODO: Test a value that validates full-width writes and the
 		 * width of the counters.
 		 */
-		const uint64_t test_val = 0xffff;
+		const u64 test_val = 0xffff;
 		const uint32_t msr = base_msr + i;
 
 		/*
@@ -397,12 +397,12 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
 		 * unsupported, i.e. doesn't #GP and reads back '0'.
 		 */
-		const uint64_t expected_val = expect_success ? test_val : 0;
+		const u64 expected_val = expect_success ? test_val : 0;
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
 		uint32_t rdpmc_idx;
 		uint8_t vector;
-		uint64_t val;
+		u64 val;
 
 		vector = wrmsr_safe(msr, test_val);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
@@ -456,7 +456,7 @@ static void guest_test_gp_counters(void)
 	 * counters, of which there are none.
 	 */
 	if (pmu_version > 1) {
-		uint64_t global_ctrl = rdmsr(MSR_CORE_PERF_GLOBAL_CTRL);
+		u64 global_ctrl = rdmsr(MSR_CORE_PERF_GLOBAL_CTRL);
 
 		if (nr_gp_counters)
 			GUEST_ASSERT_EQ(global_ctrl, GENMASK_ULL(nr_gp_counters - 1, 0));
@@ -474,7 +474,7 @@ static void guest_test_gp_counters(void)
 	GUEST_DONE();
 }
 
-static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+static void test_gp_counters(uint8_t pmu_version, u64 perf_capabilities,
 			     uint8_t nr_gp_counters)
 {
 	struct kvm_vcpu *vcpu;
@@ -493,7 +493,7 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 
 static void guest_test_fixed_counters(void)
 {
-	uint64_t supported_bitmask = 0;
+	u64 supported_bitmask = 0;
 	uint8_t nr_fixed_counters = 0;
 	uint8_t i;
 
@@ -513,7 +513,7 @@ static void guest_test_fixed_counters(void)
 
 	for (i = 0; i < MAX_NR_FIXED_COUNTERS; i++) {
 		uint8_t vector;
-		uint64_t val;
+		u64 val;
 
 		if (i >= nr_fixed_counters && !(supported_bitmask & BIT_ULL(i))) {
 			vector = wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL,
@@ -540,7 +540,7 @@ static void guest_test_fixed_counters(void)
 	GUEST_DONE();
 }
 
-static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+static void test_fixed_counters(uint8_t pmu_version, u64 perf_capabilities,
 				uint8_t nr_fixed_counters,
 				uint32_t supported_bitmask)
 {
@@ -569,7 +569,7 @@ static void test_intel_counters(void)
 	uint8_t v, j;
 	uint32_t k;
 
-	const uint64_t perf_caps[] = {
+	const u64 perf_caps[] = {
 		0,
 		PMU_CAP_FW_WRITES,
 	};
diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index c15513cd74d1..86831c590df8 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -53,11 +53,11 @@ static const struct __kvm_pmu_event_filter base_event_filter = {
 };
 
 struct {
-	uint64_t loads;
-	uint64_t stores;
-	uint64_t loads_stores;
-	uint64_t branches_retired;
-	uint64_t instructions_retired;
+	u64 loads;
+	u64 stores;
+	u64 loads_stores;
+	u64 branches_retired;
+	u64 instructions_retired;
 } pmc_results;
 
 /*
@@ -75,9 +75,9 @@ static void guest_gp_handler(struct ex_regs *regs)
  *
  * Return on success. GUEST_SYNC(0) on error.
  */
-static void check_msr(uint32_t msr, uint64_t bits_to_flip)
+static void check_msr(uint32_t msr, u64 bits_to_flip)
 {
-	uint64_t v = rdmsr(msr) ^ bits_to_flip;
+	u64 v = rdmsr(msr) ^ bits_to_flip;
 
 	wrmsr(msr, v);
 	if (rdmsr(msr) != v)
@@ -91,8 +91,8 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 
 static void run_and_measure_loop(uint32_t msr_base)
 {
-	const uint64_t branches_retired = rdmsr(msr_base + 0);
-	const uint64_t insn_retired = rdmsr(msr_base + 1);
+	const u64 branches_retired = rdmsr(msr_base + 0);
+	const u64 insn_retired = rdmsr(msr_base + 1);
 
 	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 
@@ -147,7 +147,7 @@ static void amd_guest_code(void)
  * Run the VM to the next GUEST_SYNC(value), and return the value passed
  * to the sync. Any other exit from the guest is fatal.
  */
-static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
+static u64 run_vcpu_to_sync(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
@@ -161,7 +161,7 @@ static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
 
 static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
 {
-	uint64_t r;
+	u64 r;
 
 	memset(&pmc_results, 0, sizeof(pmc_results));
 	sync_global_to_guest(vcpu->vm, pmc_results);
@@ -182,7 +182,7 @@ static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
  */
 static bool sanity_check_pmu(struct kvm_vcpu *vcpu)
 {
-	uint64_t r;
+	u64 r;
 
 	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
 	r = run_vcpu_to_sync(vcpu);
@@ -195,7 +195,7 @@ static bool sanity_check_pmu(struct kvm_vcpu *vcpu)
  * Remove the first occurrence of 'event' (if any) from the filter's
  * event list.
  */
-static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
+static void remove_event(struct __kvm_pmu_event_filter *f, u64 event)
 {
 	bool found = false;
 	int i;
@@ -212,8 +212,8 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
 
 #define ASSERT_PMC_COUNTING_INSTRUCTIONS()						\
 do {											\
-	uint64_t br = pmc_results.branches_retired;					\
-	uint64_t ir = pmc_results.instructions_retired;					\
+	u64 br = pmc_results.branches_retired;					\
+	u64 ir = pmc_results.instructions_retired;					\
 											\
 	if (br && br != NUM_BRANCHES)							\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
@@ -226,8 +226,8 @@ do {											\
 
 #define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS()						\
 do {											\
-	uint64_t br = pmc_results.branches_retired;					\
-	uint64_t ir = pmc_results.instructions_retired;					\
+	u64 br = pmc_results.branches_retired;					\
+	u64 ir = pmc_results.instructions_retired;					\
 											\
 	TEST_ASSERT(!br, "%s: Branch instructions retired = %lu (expected 0)",		\
 		    __func__, br);							\
@@ -418,9 +418,9 @@ static void masked_events_guest_test(uint32_t msr_base)
 	 * The actual value of the counters don't determine the outcome of
 	 * the test.  Only that they are zero or non-zero.
 	 */
-	const uint64_t loads = rdmsr(msr_base + 0);
-	const uint64_t stores = rdmsr(msr_base + 1);
-	const uint64_t loads_stores = rdmsr(msr_base + 2);
+	const u64 loads = rdmsr(msr_base + 0);
+	const u64 stores = rdmsr(msr_base + 1);
+	const u64 loads_stores = rdmsr(msr_base + 2);
 	int val;
 
 
@@ -473,7 +473,7 @@ static void amd_masked_events_guest_code(void)
 }
 
 static void run_masked_events_test(struct kvm_vcpu *vcpu,
-				   const uint64_t masked_events[],
+				   const u64 masked_events[],
 				   const int nmasked_events)
 {
 	struct __kvm_pmu_event_filter f = {
@@ -482,7 +482,7 @@ static void run_masked_events_test(struct kvm_vcpu *vcpu,
 		.flags = KVM_PMU_EVENT_FLAG_MASKED_EVENTS,
 	};
 
-	memcpy(f.events, masked_events, sizeof(uint64_t) * nmasked_events);
+	memcpy(f.events, masked_events, sizeof(u64) * nmasked_events);
 	test_with_filter(vcpu, &f);
 }
 
@@ -491,10 +491,10 @@ static void run_masked_events_test(struct kvm_vcpu *vcpu,
 #define ALLOW_LOADS_STORES	BIT(2)
 
 struct masked_events_test {
-	uint64_t intel_events[MAX_TEST_EVENTS];
-	uint64_t intel_event_end;
-	uint64_t amd_events[MAX_TEST_EVENTS];
-	uint64_t amd_event_end;
+	u64 intel_events[MAX_TEST_EVENTS];
+	u64 intel_event_end;
+	u64 amd_events[MAX_TEST_EVENTS];
+	u64 amd_event_end;
 	const char *msg;
 	uint32_t flags;
 };
@@ -579,9 +579,9 @@ const struct masked_events_test test_cases[] = {
 };
 
 static int append_test_events(const struct masked_events_test *test,
-			      uint64_t *events, int nevents)
+			      u64 *events, int nevents)
 {
-	const uint64_t *evts;
+	const u64 *evts;
 	int i;
 
 	evts = use_intel_pmu() ? test->intel_events : test->amd_events;
@@ -600,7 +600,7 @@ static bool bool_eq(bool a, bool b)
 	return a == b;
 }
 
-static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
+static void run_masked_events_tests(struct kvm_vcpu *vcpu, u64 *events,
 				    int nevents)
 {
 	int ntests = ARRAY_SIZE(test_cases);
@@ -627,7 +627,7 @@ static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
 	}
 }
 
-static void add_dummy_events(uint64_t *events, int nevents)
+static void add_dummy_events(u64 *events, int nevents)
 {
 	int i;
 
@@ -647,7 +647,7 @@ static void add_dummy_events(uint64_t *events, int nevents)
 static void test_masked_events(struct kvm_vcpu *vcpu)
 {
 	int nevents = KVM_PMU_EVENT_FILTER_MAX_EVENTS - MAX_TEST_EVENTS;
-	uint64_t events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
+	u64 events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
 
 	/* Run the test cases against a sparse PMU event filter. */
 	run_masked_events_tests(vcpu, events, 0);
@@ -665,7 +665,7 @@ static int set_pmu_event_filter(struct kvm_vcpu *vcpu,
 	return __vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
 }
 
-static int set_pmu_single_event_filter(struct kvm_vcpu *vcpu, uint64_t event,
+static int set_pmu_single_event_filter(struct kvm_vcpu *vcpu, u64 event,
 				       uint32_t flags, uint32_t action)
 {
 	struct __kvm_pmu_event_filter f = {
@@ -684,7 +684,7 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
 {
 	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	struct __kvm_pmu_event_filter f;
-	uint64_t e = ~0ul;
+	u64 e = ~0ul;
 	int r;
 
 	/*
@@ -742,8 +742,8 @@ static void intel_run_fixed_counter_guest_code(uint8_t idx)
 	}
 }
 
-static uint64_t test_with_fixed_counter_filter(struct kvm_vcpu *vcpu,
-					       uint32_t action, uint32_t bitmap)
+static u64 test_with_fixed_counter_filter(struct kvm_vcpu *vcpu,
+					  uint32_t action, uint32_t bitmap)
 {
 	struct __kvm_pmu_event_filter f = {
 		.action = action,
@@ -754,9 +754,9 @@ static uint64_t test_with_fixed_counter_filter(struct kvm_vcpu *vcpu,
 	return run_vcpu_to_sync(vcpu);
 }
 
-static uint64_t test_set_gp_and_fixed_event_filter(struct kvm_vcpu *vcpu,
-						   uint32_t action,
-						   uint32_t bitmap)
+static u64 test_set_gp_and_fixed_event_filter(struct kvm_vcpu *vcpu,
+					      uint32_t action,
+					      uint32_t bitmap)
 {
 	struct __kvm_pmu_event_filter f = base_event_filter;
 
@@ -772,7 +772,7 @@ static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
 {
 	unsigned int i;
 	uint32_t bitmap;
-	uint64_t count;
+	u64 count;
 
 	TEST_ASSERT(nr_fixed_counters < sizeof(bitmap) * 8,
 		    "Invalid nr_fixed_counters");
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 82a8d88b5338..7e650895c96f 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -23,8 +23,8 @@
 #include <processor.h>
 
 #define BASE_DATA_SLOT		10
-#define BASE_DATA_GPA		((uint64_t)(1ull << 32))
-#define PER_CPU_DATA_SIZE	((uint64_t)(SZ_2M + PAGE_SIZE))
+#define BASE_DATA_GPA		((u64)(1ull << 32))
+#define PER_CPU_DATA_SIZE	((u64)(SZ_2M + PAGE_SIZE))
 
 /* Horrific macro so that the line info is captured accurately :-( */
 #define memcmp_g(gpa, pattern,  size)								\
@@ -38,7 +38,7 @@ do {												\
 			       pattern, i, gpa + i, mem[i]);					\
 } while (0)
 
-static void memcmp_h(uint8_t *mem, uint64_t gpa, uint8_t pattern, size_t size)
+static void memcmp_h(uint8_t *mem, u64 gpa, uint8_t pattern, size_t size)
 {
 	size_t i;
 
@@ -70,13 +70,13 @@ enum ucall_syncs {
 	SYNC_PRIVATE,
 };
 
-static void guest_sync_shared(uint64_t gpa, uint64_t size,
+static void guest_sync_shared(u64 gpa, u64 size,
 			      uint8_t current_pattern, uint8_t new_pattern)
 {
 	GUEST_SYNC5(SYNC_SHARED, gpa, size, current_pattern, new_pattern);
 }
 
-static void guest_sync_private(uint64_t gpa, uint64_t size, uint8_t pattern)
+static void guest_sync_private(u64 gpa, u64 size, uint8_t pattern)
 {
 	GUEST_SYNC4(SYNC_PRIVATE, gpa, size, pattern);
 }
@@ -86,10 +86,10 @@ static void guest_sync_private(uint64_t gpa, uint64_t size, uint8_t pattern)
 #define MAP_GPA_SHARED		BIT(1)
 #define MAP_GPA_DO_FALLOCATE	BIT(2)
 
-static void guest_map_mem(uint64_t gpa, uint64_t size, bool map_shared,
+static void guest_map_mem(u64 gpa, u64 size, bool map_shared,
 			  bool do_fallocate)
 {
-	uint64_t flags = MAP_GPA_SET_ATTRIBUTES;
+	u64 flags = MAP_GPA_SET_ATTRIBUTES;
 
 	if (map_shared)
 		flags |= MAP_GPA_SHARED;
@@ -98,19 +98,19 @@ static void guest_map_mem(uint64_t gpa, uint64_t size, bool map_shared,
 	kvm_hypercall_map_gpa_range(gpa, size, flags);
 }
 
-static void guest_map_shared(uint64_t gpa, uint64_t size, bool do_fallocate)
+static void guest_map_shared(u64 gpa, u64 size, bool do_fallocate)
 {
 	guest_map_mem(gpa, size, true, do_fallocate);
 }
 
-static void guest_map_private(uint64_t gpa, uint64_t size, bool do_fallocate)
+static void guest_map_private(u64 gpa, u64 size, bool do_fallocate)
 {
 	guest_map_mem(gpa, size, false, do_fallocate);
 }
 
 struct {
-	uint64_t offset;
-	uint64_t size;
+	u64 offset;
+	u64 size;
 } static const test_ranges[] = {
 	GUEST_STAGE(0, PAGE_SIZE),
 	GUEST_STAGE(0, SZ_2M),
@@ -119,11 +119,11 @@ struct {
 	GUEST_STAGE(SZ_2M, PAGE_SIZE),
 };
 
-static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
+static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 {
 	const uint8_t def_p = 0xaa;
 	const uint8_t init_p = 0xcc;
-	uint64_t j;
+	u64 j;
 	int i;
 
 	/* Memory should be shared by default. */
@@ -134,8 +134,8 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 	memcmp_g(base_gpa, init_p, PER_CPU_DATA_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
-		uint64_t gpa = base_gpa + test_ranges[i].offset;
-		uint64_t size = test_ranges[i].size;
+		u64 gpa = base_gpa + test_ranges[i].offset;
+		u64 size = test_ranges[i].size;
 		uint8_t p1 = 0x11;
 		uint8_t p2 = 0x22;
 		uint8_t p3 = 0x33;
@@ -214,10 +214,10 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 	}
 }
 
-static void guest_punch_hole(uint64_t gpa, uint64_t size)
+static void guest_punch_hole(u64 gpa, u64 size)
 {
 	/* "Mapping" memory shared via fallocate() is done via PUNCH_HOLE. */
-	uint64_t flags = MAP_GPA_SHARED | MAP_GPA_DO_FALLOCATE;
+	u64 flags = MAP_GPA_SHARED | MAP_GPA_DO_FALLOCATE;
 
 	kvm_hypercall_map_gpa_range(gpa, size, flags);
 }
@@ -227,7 +227,7 @@ static void guest_punch_hole(uint64_t gpa, uint64_t size)
  * proper conversion.  Freeing (PUNCH_HOLE) should zap SPTEs, and reallocating
  * (subsequent fault) should zero memory.
  */
-static void guest_test_punch_hole(uint64_t base_gpa, bool precise)
+static void guest_test_punch_hole(u64 base_gpa, bool precise)
 {
 	const uint8_t init_p = 0xcc;
 	int i;
@@ -239,8 +239,8 @@ static void guest_test_punch_hole(uint64_t base_gpa, bool precise)
 	guest_map_private(base_gpa, PER_CPU_DATA_SIZE, false);
 
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
-		uint64_t gpa = base_gpa + test_ranges[i].offset;
-		uint64_t size = test_ranges[i].size;
+		u64 gpa = base_gpa + test_ranges[i].offset;
+		u64 size = test_ranges[i].size;
 
 		/*
 		 * Free all memory before each iteration, even for the !precise
@@ -268,7 +268,7 @@ static void guest_test_punch_hole(uint64_t base_gpa, bool precise)
 	}
 }
 
-static void guest_code(uint64_t base_gpa)
+static void guest_code(u64 base_gpa)
 {
 	/*
 	 * Run the conversion test twice, with and without doing fallocate() on
@@ -289,8 +289,8 @@ static void guest_code(uint64_t base_gpa)
 static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	uint64_t gpa = run->hypercall.args[0];
-	uint64_t size = run->hypercall.args[1] * PAGE_SIZE;
+	u64 gpa = run->hypercall.args[0];
+	u64 size = run->hypercall.args[1] * PAGE_SIZE;
 	bool set_attributes = run->hypercall.args[2] & MAP_GPA_SET_ATTRIBUTES;
 	bool map_shared = run->hypercall.args[2] & MAP_GPA_SHARED;
 	bool do_fallocate = run->hypercall.args[2] & MAP_GPA_DO_FALLOCATE;
@@ -337,7 +337,7 @@ static void *__test_mem_conversions(void *__vcpu)
 		case UCALL_ABORT:
 			REPORT_GUEST_ASSERT(uc);
 		case UCALL_SYNC: {
-			uint64_t gpa  = uc.args[1];
+			u64 gpa  = uc.args[1];
 			size_t size = uc.args[2];
 			size_t i;
 
@@ -402,7 +402,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
 
 	for (i = 0; i < nr_vcpus; i++) {
-		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
+		u64 gpa =  BASE_DATA_GPA + i * per_cpu_size;
 
 		vcpu_args_set(vcpus[i], 1, gpa);
 
diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 13e72fcec8dd..925040f394de 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -17,12 +17,12 @@
 #define EXITS_TEST_SIZE (EXITS_TEST_NPAGES * PAGE_SIZE)
 #define EXITS_TEST_SLOT 10
 
-static uint64_t guest_repeatedly_read(void)
+static u64 guest_repeatedly_read(void)
 {
-	volatile uint64_t value;
+	volatile u64 value;
 
 	while (true)
-		value = *((uint64_t *) EXITS_TEST_GVA);
+		value = *((u64 *)EXITS_TEST_GVA);
 
 	return value;
 }
@@ -72,7 +72,7 @@ static void test_private_access_memslot_deleted(void)
 	vm_mem_region_delete(vm, EXITS_TEST_SLOT);
 
 	pthread_join(vm_thread, &thread_return);
-	exit_reason = (uint32_t)(uint64_t)thread_return;
+	exit_reason = (uint32_t)(u64)thread_return;
 
 	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
 	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
diff --git a/tools/testing/selftests/kvm/x86/set_sregs_test.c b/tools/testing/selftests/kvm/x86/set_sregs_test.c
index f4095a3d1278..8e654cc9ab16 100644
--- a/tools/testing/selftests/kvm/x86/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86/set_sregs_test.c
@@ -46,9 +46,9 @@ do {										\
 				X86_CR4_MCE | X86_CR4_PGE | X86_CR4_PCE |	\
 				X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT)
 
-static uint64_t calc_supported_cr4_feature_bits(void)
+static u64 calc_supported_cr4_feature_bits(void)
 {
-	uint64_t cr4 = KVM_ALWAYS_ALLOWED_CR4;
+	u64 cr4 = KVM_ALWAYS_ALLOWED_CR4;
 
 	if (kvm_cpu_has(X86_FEATURE_UMIP))
 		cr4 |= X86_CR4_UMIP;
@@ -74,7 +74,7 @@ static uint64_t calc_supported_cr4_feature_bits(void)
 	return cr4;
 }
 
-static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
+static void test_cr_bits(struct kvm_vcpu *vcpu, u64 cr4)
 {
 	struct kvm_sregs sregs;
 	int rc, i;
diff --git a/tools/testing/selftests/kvm/x86/sev_init2_tests.c b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
index 3fb967f40c6a..3515b4c0e860 100644
--- a/tools/testing/selftests/kvm/x86/sev_init2_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
@@ -33,7 +33,7 @@ static int __sev_ioctl(int vm_fd, int cmd_id, void *data)
 {
 	struct kvm_sev_cmd cmd = {
 		.id = cmd_id,
-		.data = (uint64_t)data,
+		.data = (u64)data,
 		.sev_fd = open_sev_dev_path_or_exit(),
 	};
 	int ret;
@@ -100,7 +100,7 @@ void test_flags(uint32_t vm_type)
 			"invalid flag");
 }
 
-void test_features(uint32_t vm_type, uint64_t supported_features)
+void test_features(uint32_t vm_type, u64 supported_features)
 {
 	int i;
 
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index dc0734d2973c..7ee7cc1da061 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -108,7 +108,7 @@ static void test_sync_vmsa(uint32_t policy)
 	kvm_vm_free(vm);
 }
 
-static void test_sev(void *guest_code, uint64_t policy)
+static void test_sev(void *guest_code, u64 policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index fabeeaddfb3a..ae4ea5bb1bed 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -20,8 +20,8 @@
 
 static void guest_code(bool tdp_enabled)
 {
-	uint64_t error_code;
-	uint64_t vector;
+	u64 error_code;
+	u64 vector;
 
 	vector = kvm_asm_safe_ec(FLDS_MEM_EAX, error_code, "a"(MEM_REGION_GVA));
 
@@ -47,9 +47,9 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint64_t *pte;
-	uint64_t *hva;
-	uint64_t gpa;
+	u64 *pte;
+	u64 *hva;
+	u64 gpa;
 	int rc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
diff --git a/tools/testing/selftests/kvm/x86/smm_test.c b/tools/testing/selftests/kvm/x86/smm_test.c
index ba64f4e8456d..32f2cdea4c4f 100644
--- a/tools/testing/selftests/kvm/x86/smm_test.c
+++ b/tools/testing/selftests/kvm/x86/smm_test.c
@@ -42,7 +42,7 @@ uint8_t smi_handler[] = {
 	0x0f, 0xaa,           /* rsm */
 };
 
-static inline void sync_with_host(uint64_t phase)
+static inline void sync_with_host(u64 phase)
 {
 	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
 		     : "+a" (phase));
@@ -67,7 +67,7 @@ static void guest_code(void *arg)
 {
 	#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 apicbase = rdmsr(MSR_IA32_APICBASE);
 	struct svm_test_data *svm = arg;
 	struct vmx_pages *vmx_pages = arg;
 
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 062f425db75b..151eead91baf 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -140,7 +140,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 	GUEST_SYNC(1);
 
 	if (this_cpu_has(X86_FEATURE_XSAVE)) {
-		uint64_t supported_xcr0 = this_cpu_supported_xcr0();
+		u64 supported_xcr0 = this_cpu_supported_xcr0();
 		uint8_t buffer[4096];
 
 		memset(buffer, 0xcc, sizeof(buffer));
@@ -168,8 +168,8 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 		}
 
 		if (this_cpu_has(X86_FEATURE_MPX)) {
-			uint64_t bounds[2] = { 10, 0xffffffffull };
-			uint64_t output[2] = { };
+			u64 bounds[2] = { 10, 0xffffffffull };
+			u64 output[2] = { };
 
 			GUEST_ASSERT(supported_xcr0 & XFEATURE_MASK_BNDREGS);
 			GUEST_ASSERT(supported_xcr0 & XFEATURE_MASK_BNDCSR);
@@ -224,7 +224,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 
 int main(int argc, char *argv[])
 {
-	uint64_t *xstate_bv, saved_xstate_bv;
+	u64 *xstate_bv, saved_xstate_bv;
 	gva_t nested_gva = 0;
 	struct kvm_cpuid2 empty_cpuid = {};
 	struct kvm_regs regs1, regs2;
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 5068b2dd8005..36b327c8c7c5 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
@@ -76,7 +76,7 @@ static void l2_guest_code_nmi(void)
 	ud2();
 }
 
-static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t idt_alt)
+static void l1_guest_code(struct svm_test_data *svm, u64 is_nmi, u64 idt_alt)
 {
 	#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -168,7 +168,7 @@ static void run_test(bool is_nmi)
 	} else {
 		idt_alt_vm = 0;
 	}
-	vcpu_args_set(vcpu, 3, svm_gva, (uint64_t)is_nmi, (uint64_t)idt_alt_vm);
+	vcpu_args_set(vcpu, 3, svm_gva, (u64)is_nmi, (u64)idt_alt_vm);
 
 	memset(&debug, 0, sizeof(debug));
 	vcpu_guest_debug_set(vcpu, &debug);
diff --git a/tools/testing/selftests/kvm/x86/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86/tsc_msrs_test.c
index 12b0964f4f13..91583969a14f 100644
--- a/tools/testing/selftests/kvm/x86/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/tsc_msrs_test.c
@@ -95,7 +95,7 @@ int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t val;
+	u64 val;
 
 	ksft_print_header();
 	ksft_set_plan(5);
diff --git a/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
index 59c7304f805e..59da8d4da607 100644
--- a/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
@@ -21,10 +21,10 @@ pthread_spinlock_t create_lock;
 #define TEST_TSC_KHZ    2345678UL
 #define TEST_TSC_OFFSET 200000000
 
-uint64_t tsc_sync;
+u64 tsc_sync;
 static void guest_code(void)
 {
-	uint64_t start_tsc, local_tsc, tmp;
+	u64 start_tsc, local_tsc, tmp;
 
 	start_tsc = rdtsc();
 	do {
diff --git a/tools/testing/selftests/kvm/x86/ucna_injection_test.c b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
index 1e5e564523b3..27aae6c92a38 100644
--- a/tools/testing/selftests/kvm/x86/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
@@ -45,7 +45,7 @@
 
 #define MCI_CTL2_RESERVED_BIT BIT_ULL(29)
 
-static uint64_t supported_mcg_caps;
+static u64 supported_mcg_caps;
 
 /*
  * Record states about the injected UCNA.
@@ -53,30 +53,30 @@ static uint64_t supported_mcg_caps;
  * handler. Variables without the 'i_' prefixes are recorded in guest main
  * execution thread.
  */
-static volatile uint64_t i_ucna_rcvd;
-static volatile uint64_t i_ucna_addr;
-static volatile uint64_t ucna_addr;
-static volatile uint64_t ucna_addr2;
+static volatile u64 i_ucna_rcvd;
+static volatile u64 i_ucna_addr;
+static volatile u64 ucna_addr;
+static volatile u64 ucna_addr2;
 
 struct thread_params {
 	struct kvm_vcpu *vcpu;
-	uint64_t *p_i_ucna_rcvd;
-	uint64_t *p_i_ucna_addr;
-	uint64_t *p_ucna_addr;
-	uint64_t *p_ucna_addr2;
+	u64 *p_i_ucna_rcvd;
+	u64 *p_i_ucna_addr;
+	u64 *p_ucna_addr;
+	u64 *p_ucna_addr2;
 };
 
 static void verify_apic_base_addr(void)
 {
-	uint64_t msr = rdmsr(MSR_IA32_APICBASE);
-	uint64_t base = GET_APIC_BASE(msr);
+	u64 msr = rdmsr(MSR_IA32_APICBASE);
+	u64 base = GET_APIC_BASE(msr);
 
 	GUEST_ASSERT(base == APIC_DEFAULT_GPA);
 }
 
 static void ucna_injection_guest_code(void)
 {
-	uint64_t ctl2;
+	u64 ctl2;
 	verify_apic_base_addr();
 	xapic_enable();
 
@@ -106,7 +106,7 @@ static void ucna_injection_guest_code(void)
 
 static void cmci_disabled_guest_code(void)
 {
-	uint64_t ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
+	u64 ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
 	wrmsr(MSR_IA32_MCx_CTL2(UCNA_BANK), ctl2 | MCI_CTL2_CMCI_EN);
 
 	GUEST_DONE();
@@ -114,7 +114,7 @@ static void cmci_disabled_guest_code(void)
 
 static void cmci_enabled_guest_code(void)
 {
-	uint64_t ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
+	u64 ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
 	wrmsr(MSR_IA32_MCx_CTL2(UCNA_BANK), ctl2 | MCI_CTL2_RESERVED_BIT);
 
 	GUEST_DONE();
@@ -145,14 +145,15 @@ static void run_vcpu_expect_gp(struct kvm_vcpu *vcpu)
 	printf("vCPU received GP in guest.\n");
 }
 
-static void inject_ucna(struct kvm_vcpu *vcpu, uint64_t addr) {
+static void inject_ucna(struct kvm_vcpu *vcpu, u64 addr)
+{
 	/*
 	 * A UCNA error is indicated with VAL=1, UC=1, PCC=0, S=0 and AR=0 in
 	 * the IA32_MCi_STATUS register.
 	 * MSCOD=1 (BIT[16] - MscodDataRdErr).
 	 * MCACOD=0x0090 (Memory controller error format, channel 0)
 	 */
-	uint64_t status = MCI_STATUS_VAL | MCI_STATUS_UC | MCI_STATUS_EN |
+	u64 status = MCI_STATUS_VAL | MCI_STATUS_UC | MCI_STATUS_EN |
 			  MCI_STATUS_MISCV | MCI_STATUS_ADDRV | 0x10090;
 	struct kvm_x86_mce mce = {};
 	mce.status = status;
@@ -216,10 +217,10 @@ static void test_ucna_injection(struct kvm_vcpu *vcpu, struct thread_params *par
 {
 	struct kvm_vm *vm = vcpu->vm;
 	params->vcpu = vcpu;
-	params->p_i_ucna_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&i_ucna_rcvd);
-	params->p_i_ucna_addr = (uint64_t *)addr_gva2hva(vm, (uint64_t)&i_ucna_addr);
-	params->p_ucna_addr = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ucna_addr);
-	params->p_ucna_addr2 = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ucna_addr2);
+	params->p_i_ucna_rcvd = (u64 *)addr_gva2hva(vm, (u64)&i_ucna_rcvd);
+	params->p_i_ucna_addr = (u64 *)addr_gva2hva(vm, (u64)&i_ucna_addr);
+	params->p_ucna_addr = (u64 *)addr_gva2hva(vm, (u64)&ucna_addr);
+	params->p_ucna_addr2 = (u64 *)addr_gva2hva(vm, (u64)&ucna_addr2);
 
 	run_ucna_injection(params);
 
@@ -242,7 +243,7 @@ static void test_ucna_injection(struct kvm_vcpu *vcpu, struct thread_params *par
 
 static void setup_mce_cap(struct kvm_vcpu *vcpu, bool enable_cmci_p)
 {
-	uint64_t mcg_caps = MCG_CTL_P | MCG_SER_P | MCG_LMCE_P | KVM_MAX_MCE_BANKS;
+	u64 mcg_caps = MCG_CTL_P | MCG_SER_P | MCG_LMCE_P | KVM_MAX_MCE_BANKS;
 	if (enable_cmci_p)
 		mcg_caps |= MCG_CMCI_P;
 
diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
index 32b2794b78fe..983d1ae0718f 100644
--- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
@@ -66,7 +66,7 @@ struct kvm_msr_filter filter_gs = {
 	},
 };
 
-static uint64_t msr_non_existent_data;
+static u64 msr_non_existent_data;
 static int guest_exception_count;
 static u32 msr_reads, msr_writes;
 
@@ -142,7 +142,7 @@ struct kvm_msr_filter no_filter_deny = {
  * Note: Force test_rdmsr() to not be inlined to prevent the labels,
  * rdmsr_start and rdmsr_end, from being defined multiple times.
  */
-static noinline uint64_t test_rdmsr(uint32_t msr)
+static noinline u64 test_rdmsr(uint32_t msr)
 {
 	uint32_t a, d;
 
@@ -151,14 +151,14 @@ static noinline uint64_t test_rdmsr(uint32_t msr)
 	__asm__ __volatile__("rdmsr_start: rdmsr; rdmsr_end:" :
 			"=a"(a), "=d"(d) : "c"(msr) : "memory");
 
-	return a | ((uint64_t) d << 32);
+	return a | ((u64)d << 32);
 }
 
 /*
  * Note: Force test_wrmsr() to not be inlined to prevent the labels,
  * wrmsr_start and wrmsr_end, from being defined multiple times.
  */
-static noinline void test_wrmsr(uint32_t msr, uint64_t value)
+static noinline void test_wrmsr(uint32_t msr, u64 value)
 {
 	uint32_t a = value;
 	uint32_t d = value >> 32;
@@ -176,7 +176,7 @@ extern char wrmsr_start, wrmsr_end;
  * Note: Force test_em_rdmsr() to not be inlined to prevent the labels,
  * rdmsr_start and rdmsr_end, from being defined multiple times.
  */
-static noinline uint64_t test_em_rdmsr(uint32_t msr)
+static noinline u64 test_em_rdmsr(uint32_t msr)
 {
 	uint32_t a, d;
 
@@ -185,14 +185,14 @@ static noinline uint64_t test_em_rdmsr(uint32_t msr)
 	__asm__ __volatile__(KVM_FEP "em_rdmsr_start: rdmsr; em_rdmsr_end:" :
 			"=a"(a), "=d"(d) : "c"(msr) : "memory");
 
-	return a | ((uint64_t) d << 32);
+	return a | ((u64)d << 32);
 }
 
 /*
  * Note: Force test_em_wrmsr() to not be inlined to prevent the labels,
  * wrmsr_start and wrmsr_end, from being defined multiple times.
  */
-static noinline void test_em_wrmsr(uint32_t msr, uint64_t value)
+static noinline void test_em_wrmsr(uint32_t msr, u64 value)
 {
 	uint32_t a = value;
 	uint32_t d = value >> 32;
@@ -208,7 +208,7 @@ extern char em_wrmsr_start, em_wrmsr_end;
 
 static void guest_code_filter_allow(void)
 {
-	uint64_t data;
+	u64 data;
 
 	/*
 	 * Test userspace intercepting rdmsr / wrmsr for MSR_IA32_XSS.
@@ -328,7 +328,7 @@ static void guest_code_filter_deny(void)
 
 static void guest_code_permission_bitmap(void)
 {
-	uint64_t data;
+	u64 data;
 
 	data = test_rdmsr(MSR_FS_BASE);
 	GUEST_ASSERT(data == MSR_FS_BASE);
@@ -458,7 +458,7 @@ static void process_ucall_done(struct kvm_vcpu *vcpu)
 		    uc.cmd, UCALL_DONE);
 }
 
-static uint64_t process_ucall(struct kvm_vcpu *vcpu)
+static u64 process_ucall(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc = {};
 
@@ -496,7 +496,7 @@ static void run_guest_then_process_wrmsr(struct kvm_vcpu *vcpu,
 	process_wrmsr(vcpu, msr_index);
 }
 
-static uint64_t run_guest_then_process_ucall(struct kvm_vcpu *vcpu)
+static u64 run_guest_then_process_ucall(struct kvm_vcpu *vcpu)
 {
 	vcpu_run(vcpu);
 	return process_ucall(vcpu);
@@ -513,7 +513,7 @@ KVM_ONE_VCPU_TEST_SUITE(user_msr);
 KVM_ONE_VCPU_TEST(user_msr, msr_filter_allow, guest_code_filter_allow)
 {
 	struct kvm_vm *vm = vcpu->vm;
-	uint64_t cmd;
+	u64 cmd;
 	int rc;
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 9bf08e278ffe..ea521e752f66 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -82,7 +82,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	gva_t vmx_pages_gva = 0;
 	struct vmx_pages *vmx;
 	unsigned long *bmap;
-	uint64_t *host_test_mem;
+	u64 *host_test_mem;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
index 90720b6205f4..d61c8c69ade3 100644
--- a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
@@ -13,10 +13,10 @@
 #include "vmx.h"
 
 static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
-				  uint64_t mask)
+				  u64 mask)
 {
-	uint64_t val = vcpu_get_msr(vcpu, msr_index);
-	uint64_t bit;
+	u64 val = vcpu_get_msr(vcpu, msr_index);
+	u64 bit;
 
 	mask &= val;
 
@@ -27,10 +27,10 @@ static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
 }
 
 static void vmx_fixed0_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
-				uint64_t mask)
+				u64 mask)
 {
-	uint64_t val = vcpu_get_msr(vcpu, msr_index);
-	uint64_t bit;
+	u64 val = vcpu_get_msr(vcpu, msr_index);
+	u64 bit;
 
 	mask = ~mask | val;
 
@@ -68,10 +68,10 @@ static void vmx_save_restore_msrs_test(struct kvm_vcpu *vcpu)
 }
 
 static void __ia32_feature_control_msr_test(struct kvm_vcpu *vcpu,
-					    uint64_t msr_bit,
+					    u64 msr_bit,
 					    struct kvm_x86_cpu_feature feature)
 {
-	uint64_t val;
+	u64 val;
 
 	vcpu_clear_cpuid_feature(vcpu, feature);
 
@@ -90,7 +90,7 @@ static void __ia32_feature_control_msr_test(struct kvm_vcpu *vcpu,
 
 static void ia32_feature_control_msr_test(struct kvm_vcpu *vcpu)
 {
-	uint64_t supported_bits = FEAT_CTL_LOCKED |
+	u64 supported_bits = FEAT_CTL_LOCKED |
 				  FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 				  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX |
 				  FEAT_CTL_SGX_LC_ENABLED |
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
index 530d71b6d6bc..43861b96b5a4 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
@@ -18,7 +18,7 @@
 /* L2 is scaled up (from L1's perspective) by this factor */
 #define L2_SCALE_FACTOR 4ULL
 
-#define TSC_OFFSET_L2 ((uint64_t) -33125236320908)
+#define TSC_OFFSET_L2 ((u64)-33125236320908)
 #define TSC_MULTIPLIER_L2 (L2_SCALE_FACTOR << 48)
 
 #define L2_GUEST_STACK_SIZE 64
@@ -34,9 +34,9 @@ enum { USLEEP, UCHECK_L1, UCHECK_L2 };
  * measurements, a difference of 1% between the actual and the expected value
  * is tolerated.
  */
-static void compare_tsc_freq(uint64_t actual, uint64_t expected)
+static void compare_tsc_freq(u64 actual, u64 expected)
 {
-	uint64_t tolerance, thresh_low, thresh_high;
+	u64 tolerance, thresh_low, thresh_high;
 
 	tolerance = expected / 100;
 	thresh_low = expected - tolerance;
@@ -54,7 +54,7 @@ static void compare_tsc_freq(uint64_t actual, uint64_t expected)
 
 static void check_tsc_freq(int level)
 {
-	uint64_t tsc_start, tsc_end, tsc_freq;
+	u64 tsc_start, tsc_end, tsc_freq;
 
 	/*
 	 * Reading the TSC twice with about a second's difference should give
@@ -122,12 +122,12 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	gva_t vmx_pages_gva;
 
-	uint64_t tsc_start, tsc_end;
-	uint64_t tsc_khz;
-	uint64_t l1_scale_factor;
-	uint64_t l0_tsc_freq = 0;
-	uint64_t l1_tsc_freq = 0;
-	uint64_t l2_tsc_freq = 0;
+	u64 tsc_start, tsc_end;
+	u64 tsc_khz;
+	u64 l1_scale_factor;
+	u64 l0_tsc_freq = 0;
+	u64 l1_tsc_freq = 0;
+	u64 l2_tsc_freq = 0;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index a1f5ff45d518..0563bd20621b 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -51,7 +51,7 @@ static const union perf_capabilities format_caps = {
 	.pebs_format = -1,
 };
 
-static void guest_test_perf_capabilities_gp(uint64_t val)
+static void guest_test_perf_capabilities_gp(u64 val)
 {
 	uint8_t vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
 
@@ -60,7 +60,7 @@ static void guest_test_perf_capabilities_gp(uint64_t val)
 		       val, vector);
 }
 
-static void guest_code(uint64_t current_val)
+static void guest_code(u64 current_val)
 {
 	int i;
 
@@ -128,7 +128,7 @@ KVM_ONE_VCPU_TEST(vmx_pmu_caps, basic_perf_capabilities, guest_code)
 
 KVM_ONE_VCPU_TEST(vmx_pmu_caps, fungible_perf_capabilities, guest_code)
 {
-	const uint64_t fungible_caps = host_cap.capabilities & ~immutable_caps.capabilities;
+	const u64 fungible_caps = host_cap.capabilities & ~immutable_caps.capabilities;
 	int bit;
 
 	for_each_set_bit(bit, &fungible_caps, 64) {
@@ -147,7 +147,7 @@ KVM_ONE_VCPU_TEST(vmx_pmu_caps, fungible_perf_capabilities, guest_code)
  */
 KVM_ONE_VCPU_TEST(vmx_pmu_caps, immutable_perf_capabilities, guest_code)
 {
-	const uint64_t reserved_caps = (~host_cap.capabilities |
+	const u64 reserved_caps = (~host_cap.capabilities |
 					immutable_caps.capabilities) &
 				       ~format_caps.capabilities;
 	union perf_capabilities val = host_cap;
@@ -209,7 +209,7 @@ KVM_ONE_VCPU_TEST(vmx_pmu_caps, lbr_perf_capabilities, guest_code)
 
 KVM_ONE_VCPU_TEST(vmx_pmu_caps, perf_capabilities_unsupported, guest_code)
 {
-	uint64_t val;
+	u64 val;
 	int i, r;
 
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
diff --git a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
index fc294ccc2a7e..ed32522f5644 100644
--- a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
@@ -63,7 +63,7 @@ static void check_ia32_tsc_adjust(int64_t max)
 
 static void l2_guest_code(void)
 {
-	uint64_t l1_tsc = rdtsc() - TSC_OFFSET_VALUE;
+	u64 l1_tsc = rdtsc() - TSC_OFFSET_VALUE;
 
 	wrmsr(MSR_IA32_TSC, l1_tsc - TSC_ADJUST_VALUE);
 	check_ia32_tsc_adjust(-2 * TSC_ADJUST_VALUE);
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 2aa14bd237d9..bd7b51342441 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -48,16 +48,16 @@
  * Incremented in the IPI handler. Provides evidence to the sender that the IPI
  * arrived at the destination
  */
-static volatile uint64_t ipis_rcvd;
+static volatile u64 ipis_rcvd;
 
 /* Data struct shared between host main thread and vCPUs */
 struct test_data_page {
 	uint32_t halter_apic_id;
-	volatile uint64_t hlt_count;
-	volatile uint64_t wake_count;
-	uint64_t ipis_sent;
-	uint64_t migrations_attempted;
-	uint64_t migrations_completed;
+	volatile u64 hlt_count;
+	volatile u64 wake_count;
+	u64 ipis_sent;
+	u64 migrations_attempted;
+	u64 migrations_completed;
 	uint32_t icr;
 	uint32_t icr2;
 	uint32_t halter_tpr;
@@ -75,13 +75,13 @@ struct test_data_page {
 struct thread_params {
 	struct test_data_page *data;
 	struct kvm_vcpu *vcpu;
-	uint64_t *pipis_rcvd; /* host address of ipis_rcvd global */
+	u64 *pipis_rcvd; /* host address of ipis_rcvd global */
 };
 
 void verify_apic_base_addr(void)
 {
-	uint64_t msr = rdmsr(MSR_IA32_APICBASE);
-	uint64_t base = GET_APIC_BASE(msr);
+	u64 msr = rdmsr(MSR_IA32_APICBASE);
+	u64 base = GET_APIC_BASE(msr);
 
 	GUEST_ASSERT(base == APIC_DEFAULT_GPA);
 }
@@ -125,12 +125,12 @@ static void guest_ipi_handler(struct ex_regs *regs)
 
 static void sender_guest_code(struct test_data_page *data)
 {
-	uint64_t last_wake_count;
-	uint64_t last_hlt_count;
-	uint64_t last_ipis_rcvd_count;
+	u64 last_wake_count;
+	u64 last_hlt_count;
+	u64 last_ipis_rcvd_count;
 	uint32_t icr_val;
 	uint32_t icr2_val;
-	uint64_t tsc_start;
+	u64 tsc_start;
 
 	verify_apic_base_addr();
 	xapic_enable();
@@ -248,7 +248,7 @@ static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
 }
 
 void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
-		   uint64_t *pipis_rcvd)
+		   u64 *pipis_rcvd)
 {
 	long pages_not_moved;
 	unsigned long nodemask = 0;
@@ -259,9 +259,9 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 	int i, r;
 	int from, to;
 	unsigned long bit;
-	uint64_t hlt_count;
-	uint64_t wake_count;
-	uint64_t ipis_sent;
+	u64 hlt_count;
+	u64 wake_count;
+	u64 ipis_sent;
 
 	fprintf(stderr, "Calling migrate_pages every %d microseconds\n",
 		delay_usecs);
@@ -399,7 +399,7 @@ int main(int argc, char *argv[])
 	pthread_t threads[2];
 	struct thread_params params[2];
 	struct kvm_vm *vm;
-	uint64_t *pipis_rcvd;
+	u64 *pipis_rcvd;
 
 	get_cmdline_args(argc, argv, &run_secs, &migrate, &delay_usecs);
 	if (run_secs <= 0)
@@ -424,7 +424,7 @@ int main(int argc, char *argv[])
 	vcpu_args_set(params[0].vcpu, 1, test_data_page_vaddr);
 	vcpu_args_set(params[1].vcpu, 1, test_data_page_vaddr);
 
-	pipis_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ipis_rcvd);
+	pipis_rcvd = (u64 *)addr_gva2hva(vm, (u64)&ipis_rcvd);
 	params[0].pipis_rcvd = pipis_rcvd;
 	params[1].pipis_rcvd = pipis_rcvd;
 
diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
index fdebff1165c7..4d610bffbbd2 100644
--- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
@@ -23,7 +23,7 @@ static void xapic_guest_code(void)
 	xapic_enable();
 
 	while (1) {
-		uint64_t val = (u64)xapic_read_reg(APIC_IRR) |
+		u64 val = (u64)xapic_read_reg(APIC_IRR) |
 			       (u64)xapic_read_reg(APIC_IRR + 0x10) << 32;
 
 		xapic_write_reg(APIC_ICR2, val >> 32);
@@ -43,7 +43,7 @@ static void x2apic_guest_code(void)
 	x2apic_enable();
 
 	do {
-		uint64_t val = x2apic_read_reg(APIC_IRR) |
+		u64 val = x2apic_read_reg(APIC_IRR) |
 			       x2apic_read_reg(APIC_IRR + 0x10) << 32;
 
 		if (val & X2APIC_RSVD_BITS_MASK) {
@@ -56,12 +56,12 @@ static void x2apic_guest_code(void)
 	} while (1);
 }
 
-static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
+static void ____test_icr(struct xapic_vcpu *x, u64 val)
 {
 	struct kvm_vcpu *vcpu = x->vcpu;
 	struct kvm_lapic_state xapic;
 	struct ucall uc;
-	uint64_t icr;
+	u64 icr;
 
 	/*
 	 * Tell the guest what ICR value to write.  Use the IRR to pass info,
@@ -93,7 +93,7 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 		TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
-static void __test_icr(struct xapic_vcpu *x, uint64_t val)
+static void __test_icr(struct xapic_vcpu *x, u64 val)
 {
 	/*
 	 * The BUSY bit is reserved on both AMD and Intel, but only AMD treats
@@ -109,7 +109,7 @@ static void __test_icr(struct xapic_vcpu *x, uint64_t val)
 static void test_icr(struct xapic_vcpu *x)
 {
 	struct kvm_vcpu *vcpu = x->vcpu;
-	uint64_t icr, i, j;
+	u64 icr, i, j;
 
 	icr = APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_FIXED;
 	for (i = 0; i <= 0xff; i++)
@@ -142,7 +142,7 @@ static void test_icr(struct xapic_vcpu *x)
 	__test_icr(x, -1ull & ~APIC_DM_FIXED_MASK);
 }
 
-static void __test_apic_id(struct kvm_vcpu *vcpu, uint64_t apic_base)
+static void __test_apic_id(struct kvm_vcpu *vcpu, u64 apic_base)
 {
 	uint32_t apic_id, expected;
 	struct kvm_lapic_state xapic;
@@ -172,7 +172,7 @@ static void test_apic_id(void)
 {
 	const uint32_t NR_VCPUS = 3;
 	struct kvm_vcpu *vcpus[NR_VCPUS];
-	uint64_t apic_base;
+	u64 apic_base;
 	struct kvm_vm *vm;
 	int i;
 
diff --git a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
index c8a5c5e51661..650b18434ec8 100644
--- a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
@@ -21,7 +21,7 @@
  */
 #define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)		\
 do {											\
-	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies));	\
+	u64 __supported = (supported_xcr0) & ((xfeatures) | (dependencies));	\
 											\
 	__GUEST_ASSERT((__supported & (xfeatures)) != (xfeatures) ||			\
 		       __supported == ((xfeatures) | (dependencies)),			\
@@ -39,7 +39,7 @@ do {											\
  */
 #define ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0, xfeatures)		\
 do {									\
-	uint64_t __supported = (supported_xcr0) & (xfeatures);		\
+	u64 __supported = (supported_xcr0) & (xfeatures);		\
 									\
 	__GUEST_ASSERT(!__supported || __supported == (xfeatures),	\
 		       "supported = 0x%lx, xfeatures = 0x%llx",		\
@@ -48,8 +48,8 @@ do {									\
 
 static void guest_code(void)
 {
-	uint64_t initial_xcr0;
-	uint64_t supported_xcr0;
+	u64 initial_xcr0;
+	u64 supported_xcr0;
 	int i, vector;
 
 	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 287829f850f7..77fcf8345342 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -117,14 +117,14 @@ struct pvclock_wall_clock {
 
 struct vcpu_runstate_info {
 	uint32_t state;
-	uint64_t state_entry_time;
-	uint64_t time[5]; /* Extra field for overrun check */
+	u64 state_entry_time;
+	u64 time[5]; /* Extra field for overrun check */
 };
 
 struct compat_vcpu_runstate_info {
 	uint32_t state;
-	uint64_t state_entry_time;
-	uint64_t time[5];
+	u64 state_entry_time;
+	u64 time[5];
 } __attribute__((__packed__));
 
 struct arch_vcpu_info {
@@ -671,7 +671,7 @@ int main(int argc, char *argv[])
 					printf("Testing RUNSTATE_ADJUST\n");
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST;
 				memset(&rst.u, 0, sizeof(rst.u));
-				rst.u.runstate.state = (uint64_t)-1;
+				rst.u.runstate.state = (u64)-1;
 				rst.u.runstate.time_blocked =
 					0x5a - rs->time[RUNSTATE_blocked];
 				rst.u.runstate.time_offline =
@@ -1126,7 +1126,7 @@ int main(int argc, char *argv[])
 			/* Don't change the address, just trigger a write */
 			struct kvm_xen_vcpu_attr adj = {
 				.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST,
-				.u.runstate.state = (uint64_t)-1
+				.u.runstate.state = (u64)-1
 			};
 			vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &adj);
 
diff --git a/tools/testing/selftests/kvm/x86/xss_msr_test.c b/tools/testing/selftests/kvm/x86/xss_msr_test.c
index f331a4e9bae3..12c63df6bbce 100644
--- a/tools/testing/selftests/kvm/x86/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86/xss_msr_test.c
@@ -17,7 +17,7 @@ int main(int argc, char *argv[])
 	bool xss_in_msr_list;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	uint64_t xss_val;
+	u64 xss_val;
 	int i, r;
 
 	/* Create VM */
-- 
2.49.0.906.g1f30a19c02-goog


