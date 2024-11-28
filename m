Return-Path: <kvm+bounces-32647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA2E9DB089
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5491627DB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA12BE4F;
	Thu, 28 Nov 2024 00:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfudlgi2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C519614A614
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755377; cv=none; b=Gtk1N9cnkVgZpdna09lrOcr9RFg9nSxyvDZGxmk42KiXc8jY0/pC9NZgO7P2RzDGr7bwW7arvx9Z8jdunUJWps7pXjdZ5thlb3G+8nARR5z7P2fiRVXmCqA7DFno4TrqwMNLUSN2B4arder26QMKSdV0uIHddCntI3U8Cq4DwBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755377; c=relaxed/simple;
	bh=Iv7I1h9r9iPMkseXi6VtXw4q5lBAEdsZOQRMlipWUW0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aAIQPMsgoysUSzddfais2dCQkf+ykb7BaGhJGMqawxlJNcKCE0si5Tm2BfU5MZV0zpRuhOz44wvoCAfKoSWndL746HBnfH72Lk+rMN5849pJQxFE+NCAPb4aS8yLfBCRV8U47OUnLtu3pgqAm9676FYLkHge2YaEA0gRR+R6q0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfudlgi2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea5bf5354fso320610a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755374; x=1733360174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XhuytzFJxmZiXnZr+Cx3gH9LsZh3rYTr1gj7XdrVAQ0=;
        b=rfudlgi2EkuqGw4rWBA67fRF+2DYNFHZ3YJ65n0gz7Jth8yGqh9enXiSZW6uxHcPmf
         8+2fz0eR6ccsh4o8Mnz0HYPtBLeCuT7mL5ocES8xz+pmd+IOscAtC/7mag9NEIQ5K6Ff
         PjMD5hnhV9jbpcADssbI/bjm8sdnGNIjtGwvHhylcJXnZKtGBZIUEjotBKExBbNswWwp
         xtl3MN+sz372wM8Ybeclsh7k17hXT3NlHMRghMwDKPrz/6eoJTh9jr00dwC6yyzNjJHn
         7j/0IYowxs7+aJCukYyj5QhVhXxcIofVW9vjvwJaYm18AaaezEROR11kL5rgOeZRTlOL
         HOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755374; x=1733360174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XhuytzFJxmZiXnZr+Cx3gH9LsZh3rYTr1gj7XdrVAQ0=;
        b=Wn0jaRxBKO8teHNWjpo7i9psIyph2z9/t8h66r4/XdniJZpxju7ZDM4eBuQJytPx0n
         IduxaZFc8HPqRPBXcOHrTneKYzD04m3hwAZxwloapYLz6gX8oF/rEeVGLGohop81+aF8
         iaZfUU1FsM57XxOAAgO4lIV2wnIegzg2l3mIsdB5x5RrLDSzPsfUXoeH+dEB01WwWyHD
         JxBKnLsmYEvnWIh7QPfdVtrdgiRd9IMmP4GSTQnVwHLI/OPoST4p26U8VW6TjWZoNC+y
         MrXQ/rFk9hXWLT4lWG8M/v1w/Capmr9qmNBdDwSxEGg0Mlbqj+u6Wmzc+hrj7aiqIK3V
         ozKA==
X-Forwarded-Encrypted: i=1; AJvYcCXtV8tARzKRhkV9ofHFo35yEld6j6B+U1e5vdsj7pRQHFbyxAbN/ByUxxDiFR8BNZ2/x/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf1SOZbB7lQBCMV9bjFwDkGU9tMV7l84xVjoN2v6aCxi4ghd57
	FDScyqzTnvjHwqlau7xVpsP0QHKH17zuT7DIWOeQ+5/93bOcA819b9CrkVD+avZfxgd30P5/OfT
	4Rw==
X-Google-Smtp-Source: AGHT+IHUy8OzdApyttdItTpAg4xwFUeu4Y/zt4zaa/RhFSwTqk6FRmwhgtP56GKbkbL+lyHu8tVo76OXOsg=
X-Received: from pjbsn5.prod.google.com ([2002:a17:90b:2e85:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8c:b0:2eb:12df:caab
 with SMTP id 98e67ed59e1d1-2ee08ecd80dmr6738243a91.17.1732755374247; Wed, 27
 Nov 2024 16:56:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:45 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-15-seanjc@google.com>
Subject: [PATCH v4 14/16] KVM: selftests: Provide empty 'all' and 'clean'
 targets for unsupported ARCHs
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

Provide empty targets for KVM selftests if the target architecture is
unsupported to make it obvious which architectures are supported, and so
that various side effects don't fail and/or do weird things, e.g. as is,
"mkdir -p $(sort $(dir $(TEST_GEN_PROGS)))" fails due to a missing operand,
and conversely, "$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) ..." will
create an empty, useless directory for the unsupported architecture.

Move the guts of the Makefile to Makefile.kvm so that it's easier to see
that the if-statement effectively guards all of KVM selftests.

Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore   |   1 +
 tools/testing/selftests/kvm/Makefile     | 336 +----------------------
 tools/testing/selftests/kvm/Makefile.kvm | 334 ++++++++++++++++++++++
 3 files changed, 340 insertions(+), 331 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/Makefile.kvm

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 7f57abf936e7..1d41a046a7bf 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -9,3 +9,4 @@
 !config
 !settings
 !Makefile
+!Makefile.kvm
\ No newline at end of file
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c59a337cd4da..7b33464bf8cc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,12 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
-include ../../../build/Build.include
-
-all:
-
 top_srcdir = ../../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH            ?= $(SUBARCH)
 
+ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
 ifeq ($(ARCH),x86)
 	ARCH_DIR := x86_64
 else ifeq ($(ARCH),arm64)
@@ -17,332 +14,9 @@ else
 	ARCH_DIR := $(ARCH)
 endif
 
-LIBKVM += lib/assert.c
-LIBKVM += lib/elf.c
-LIBKVM += lib/guest_modes.c
-LIBKVM += lib/io.c
-LIBKVM += lib/kvm_util.c
-LIBKVM += lib/memstress.c
-LIBKVM += lib/guest_sprintf.c
-LIBKVM += lib/rbtree.c
-LIBKVM += lib/sparsebit.c
-LIBKVM += lib/test_util.c
-LIBKVM += lib/ucall_common.c
-LIBKVM += lib/userfaultfd_util.c
-
-LIBKVM_STRING += lib/string_override.c
-
-LIBKVM_x86_64 += lib/x86_64/apic.c
-LIBKVM_x86_64 += lib/x86_64/handlers.S
-LIBKVM_x86_64 += lib/x86_64/hyperv.c
-LIBKVM_x86_64 += lib/x86_64/memstress.c
-LIBKVM_x86_64 += lib/x86_64/pmu.c
-LIBKVM_x86_64 += lib/x86_64/processor.c
-LIBKVM_x86_64 += lib/x86_64/sev.c
-LIBKVM_x86_64 += lib/x86_64/svm.c
-LIBKVM_x86_64 += lib/x86_64/ucall.c
-LIBKVM_x86_64 += lib/x86_64/vmx.c
-
-LIBKVM_aarch64 += lib/aarch64/gic.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3_its.c
-LIBKVM_aarch64 += lib/aarch64/handlers.S
-LIBKVM_aarch64 += lib/aarch64/processor.c
-LIBKVM_aarch64 += lib/aarch64/spinlock.c
-LIBKVM_aarch64 += lib/aarch64/ucall.c
-LIBKVM_aarch64 += lib/aarch64/vgic.c
-
-LIBKVM_s390x += lib/s390x/diag318_test_handler.c
-LIBKVM_s390x += lib/s390x/processor.c
-LIBKVM_s390x += lib/s390x/ucall.c
-LIBKVM_s390x += lib/s390x/facility.c
-
-LIBKVM_riscv += lib/riscv/handlers.S
-LIBKVM_riscv += lib/riscv/processor.c
-LIBKVM_riscv += lib/riscv/ucall.c
-
-# Non-compiled test targets
-TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
-
-# Compiled test targets
-TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
-TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
-TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_page_splitting_test
-TEST_GEN_PROGS_x86_64 += x86_64/feature_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
-TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
-TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_evmcs
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hypercalls
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
-TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
-TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
-TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
-TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
-TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
-TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
-TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
-TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
-TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
-TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
-TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
-TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
-TEST_GEN_PROGS_x86_64 += x86_64/smm_test
-TEST_GEN_PROGS_x86_64 += x86_64/state_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_shutdown_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
-TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
-TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
-TEST_GEN_PROGS_x86_64 += x86_64/ucna_injection_test
-TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
-TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
-TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
-TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
-TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
-TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
-TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
-TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
-TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
-TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
-TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
-TEST_GEN_PROGS_x86_64 += x86_64/sev_init2_tests
-TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
-TEST_GEN_PROGS_x86_64 += x86_64/sev_smoke_test
-TEST_GEN_PROGS_x86_64 += x86_64/amx_test
-TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
-TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
-TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
-TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
-TEST_GEN_PROGS_x86_64 += coalesced_io_test
-TEST_GEN_PROGS_x86_64 += demand_paging_test
-TEST_GEN_PROGS_x86_64 += dirty_log_test
-TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
-TEST_GEN_PROGS_x86_64 += guest_memfd_test
-TEST_GEN_PROGS_x86_64 += guest_print_test
-TEST_GEN_PROGS_x86_64 += hardware_disable_test
-TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += mmu_stress_test
-TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
-TEST_GEN_PROGS_x86_64 += memslot_perf_test
-TEST_GEN_PROGS_x86_64 += rseq_test
-TEST_GEN_PROGS_x86_64 += set_memory_region_test
-TEST_GEN_PROGS_x86_64 += steal_time
-TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
-TEST_GEN_PROGS_x86_64 += system_counter_offset_test
-TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
-
-# Compiled outputs used by test targets
-TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
-
-TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
-TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
-TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
-TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
-TEST_GEN_PROGS_aarch64 += aarch64/mmio_abort
-TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
-TEST_GEN_PROGS_aarch64 += aarch64/psci_test
-TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
-TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
-TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
-TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
-TEST_GEN_PROGS_aarch64 += aarch64/no-vgic-v3
-TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
-TEST_GEN_PROGS_aarch64 += arch_timer
-TEST_GEN_PROGS_aarch64 += coalesced_io_test
-TEST_GEN_PROGS_aarch64 += demand_paging_test
-TEST_GEN_PROGS_aarch64 += dirty_log_test
-TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
-TEST_GEN_PROGS_aarch64 += guest_print_test
-TEST_GEN_PROGS_aarch64 += get-reg-list
-TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_aarch64 += kvm_page_table_test
-TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
-TEST_GEN_PROGS_aarch64 += memslot_perf_test
-TEST_GEN_PROGS_aarch64 += mmu_stress_test
-TEST_GEN_PROGS_aarch64 += rseq_test
-TEST_GEN_PROGS_aarch64 += set_memory_region_test
-TEST_GEN_PROGS_aarch64 += steal_time
-TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
-
-TEST_GEN_PROGS_s390x = s390x/memop
-TEST_GEN_PROGS_s390x += s390x/resets
-TEST_GEN_PROGS_s390x += s390x/sync_regs_test
-TEST_GEN_PROGS_s390x += s390x/tprot
-TEST_GEN_PROGS_s390x += s390x/cmma_test
-TEST_GEN_PROGS_s390x += s390x/debug_test
-TEST_GEN_PROGS_s390x += s390x/cpumodel_subfuncs_test
-TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
-TEST_GEN_PROGS_s390x += s390x/ucontrol_test
-TEST_GEN_PROGS_s390x += demand_paging_test
-TEST_GEN_PROGS_s390x += dirty_log_test
-TEST_GEN_PROGS_s390x += guest_print_test
-TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
-TEST_GEN_PROGS_s390x += kvm_page_table_test
-TEST_GEN_PROGS_s390x += rseq_test
-TEST_GEN_PROGS_s390x += set_memory_region_test
-TEST_GEN_PROGS_s390x += kvm_binary_stats_test
-
-TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
-TEST_GEN_PROGS_riscv += riscv/ebreak_test
-TEST_GEN_PROGS_riscv += arch_timer
-TEST_GEN_PROGS_riscv += coalesced_io_test
-TEST_GEN_PROGS_riscv += demand_paging_test
-TEST_GEN_PROGS_riscv += dirty_log_test
-TEST_GEN_PROGS_riscv += get-reg-list
-TEST_GEN_PROGS_riscv += guest_print_test
-TEST_GEN_PROGS_riscv += kvm_binary_stats_test
-TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
-TEST_GEN_PROGS_riscv += kvm_page_table_test
-TEST_GEN_PROGS_riscv += set_memory_region_test
-TEST_GEN_PROGS_riscv += steal_time
-
-SPLIT_TESTS += arch_timer
-SPLIT_TESTS += get-reg-list
-
-TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
-LIBKVM += $(LIBKVM_$(ARCH_DIR))
-
-OVERRIDE_TARGETS = 1
-
-# lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
-# importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
-# which causes the environment variable to override the makefile).
-include ../lib.mk
-
-INSTALL_HDR_PATH = $(top_srcdir)/usr
-LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
-LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-ifeq ($(ARCH),x86_64)
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
+include Makefile.kvm
 else
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+# Empty targets for unsupported architectures
+all:
+clean:
 endif
-CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
-	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
-	-fno-builtin-memcmp -fno-builtin-memcpy \
-	-fno-builtin-memset -fno-builtin-strnlen \
-	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
-	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
-	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
-	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
-ifeq ($(ARCH),s390)
-	CFLAGS += -march=z10
-endif
-ifeq ($(ARCH),x86)
-ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
-	CFLAGS += -march=x86-64-v2
-endif
-endif
-ifeq ($(ARCH),arm64)
-tools_dir := $(top_srcdir)/tools
-arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
-
-ifneq ($(abs_objdir),)
-arm64_hdr_outdir := $(abs_objdir)/tools/
-else
-arm64_hdr_outdir := $(tools_dir)/
-endif
-
-GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
-CFLAGS += -I$(GEN_HDRS)
-
-$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
-	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
-endif
-
-no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
-        $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
-
-# On s390, build the testcases KVM-enabled
-pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
-	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
-
-LDLIBS += -ldl
-LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
-
-LIBKVM_C := $(filter %.c,$(LIBKVM))
-LIBKVM_S := $(filter %.S,$(LIBKVM))
-LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
-LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
-LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
-SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
-SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
-
-TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_OBJ))
-TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
-TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
--include $(TEST_DEP_FILES)
-
-$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
-
-$(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
-$(TEST_GEN_PROGS_EXTENDED): %: %.o
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM_OBJS) $(LDLIBS) -o $@
-$(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
-
-$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
-
-EXTRA_CLEAN += $(GEN_HDRS) \
-	       $(LIBKVM_OBJS) \
-	       $(SPLIT_TEST_GEN_OBJ) \
-	       $(TEST_DEP_FILES) \
-	       $(TEST_GEN_OBJ) \
-	       cscope.*
-
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
-
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
-
-# Compile the string overrides as freestanding to prevent the compiler from
-# generating self-referential code, e.g. without "freestanding" the compiler may
-# "optimize" memcmp() by invoking memcmp(), thus causing infinite recursion.
-$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
-
-$(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-$(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
-$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
-$(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
-$(TEST_GEN_OBJ): $(GEN_HDRS)
-
-cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
-cscope:
-	$(RM) cscope.*
-	(find $(include_paths) -name '*.h' \
-		-exec realpath --relative-base=$(PWD) {} \;; \
-	find . -name '*.c' \
-		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
-	cscope -b
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
new file mode 100644
index 000000000000..e988a72f8c20
--- /dev/null
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -0,0 +1,334 @@
+# SPDX-License-Identifier: GPL-2.0-only
+include ../../../build/Build.include
+
+all:
+
+LIBKVM += lib/assert.c
+LIBKVM += lib/elf.c
+LIBKVM += lib/guest_modes.c
+LIBKVM += lib/io.c
+LIBKVM += lib/kvm_util.c
+LIBKVM += lib/memstress.c
+LIBKVM += lib/guest_sprintf.c
+LIBKVM += lib/rbtree.c
+LIBKVM += lib/sparsebit.c
+LIBKVM += lib/test_util.c
+LIBKVM += lib/ucall_common.c
+LIBKVM += lib/userfaultfd_util.c
+
+LIBKVM_STRING += lib/string_override.c
+
+LIBKVM_x86_64 += lib/x86_64/apic.c
+LIBKVM_x86_64 += lib/x86_64/handlers.S
+LIBKVM_x86_64 += lib/x86_64/hyperv.c
+LIBKVM_x86_64 += lib/x86_64/memstress.c
+LIBKVM_x86_64 += lib/x86_64/pmu.c
+LIBKVM_x86_64 += lib/x86_64/processor.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
+LIBKVM_x86_64 += lib/x86_64/svm.c
+LIBKVM_x86_64 += lib/x86_64/ucall.c
+LIBKVM_x86_64 += lib/x86_64/vmx.c
+
+LIBKVM_aarch64 += lib/aarch64/gic.c
+LIBKVM_aarch64 += lib/aarch64/gic_v3.c
+LIBKVM_aarch64 += lib/aarch64/gic_v3_its.c
+LIBKVM_aarch64 += lib/aarch64/handlers.S
+LIBKVM_aarch64 += lib/aarch64/processor.c
+LIBKVM_aarch64 += lib/aarch64/spinlock.c
+LIBKVM_aarch64 += lib/aarch64/ucall.c
+LIBKVM_aarch64 += lib/aarch64/vgic.c
+
+LIBKVM_s390x += lib/s390x/diag318_test_handler.c
+LIBKVM_s390x += lib/s390x/processor.c
+LIBKVM_s390x += lib/s390x/ucall.c
+LIBKVM_s390x += lib/s390x/facility.c
+
+LIBKVM_riscv += lib/riscv/handlers.S
+LIBKVM_riscv += lib/riscv/processor.c
+LIBKVM_riscv += lib/riscv/ucall.c
+
+# Non-compiled test targets
+TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
+
+# Compiled test targets
+TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_page_splitting_test
+TEST_GEN_PROGS_x86_64 += x86_64/feature_msrs_test
+TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
+TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
+TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_evmcs
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hypercalls
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
+TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
+TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
+TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
+TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
+TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
+TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
+TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
+TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
+TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/state_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_shutdown_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
+TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/ucna_injection_test
+TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
+TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
+TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
+TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
+TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
+TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
+TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_init2_tests
+TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
+TEST_GEN_PROGS_x86_64 += x86_64/sev_smoke_test
+TEST_GEN_PROGS_x86_64 += x86_64/amx_test
+TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
+TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
+TEST_GEN_PROGS_x86_64 += coalesced_io_test
+TEST_GEN_PROGS_x86_64 += demand_paging_test
+TEST_GEN_PROGS_x86_64 += dirty_log_test
+TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_memfd_test
+TEST_GEN_PROGS_x86_64 += guest_print_test
+TEST_GEN_PROGS_x86_64 += hardware_disable_test
+TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_x86_64 += kvm_page_table_test
+TEST_GEN_PROGS_x86_64 += mmu_stress_test
+TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
+TEST_GEN_PROGS_x86_64 += memslot_perf_test
+TEST_GEN_PROGS_x86_64 += rseq_test
+TEST_GEN_PROGS_x86_64 += set_memory_region_test
+TEST_GEN_PROGS_x86_64 += steal_time
+TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
+
+# Compiled outputs used by test targets
+TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
+
+TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
+TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
+TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
+TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
+TEST_GEN_PROGS_aarch64 += aarch64/mmio_abort
+TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
+TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
+TEST_GEN_PROGS_aarch64 += aarch64/no-vgic-v3
+TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
+TEST_GEN_PROGS_aarch64 += arch_timer
+TEST_GEN_PROGS_aarch64 += coalesced_io_test
+TEST_GEN_PROGS_aarch64 += demand_paging_test
+TEST_GEN_PROGS_aarch64 += dirty_log_test
+TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_print_test
+TEST_GEN_PROGS_aarch64 += get-reg-list
+TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_aarch64 += kvm_page_table_test
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
+TEST_GEN_PROGS_aarch64 += rseq_test
+TEST_GEN_PROGS_aarch64 += set_memory_region_test
+TEST_GEN_PROGS_aarch64 += steal_time
+TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+
+TEST_GEN_PROGS_s390x = s390x/memop
+TEST_GEN_PROGS_s390x += s390x/resets
+TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+TEST_GEN_PROGS_s390x += s390x/tprot
+TEST_GEN_PROGS_s390x += s390x/cmma_test
+TEST_GEN_PROGS_s390x += s390x/debug_test
+TEST_GEN_PROGS_s390x += s390x/cpumodel_subfuncs_test
+TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
+TEST_GEN_PROGS_s390x += s390x/ucontrol_test
+TEST_GEN_PROGS_s390x += demand_paging_test
+TEST_GEN_PROGS_s390x += dirty_log_test
+TEST_GEN_PROGS_s390x += guest_print_test
+TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
+TEST_GEN_PROGS_s390x += kvm_page_table_test
+TEST_GEN_PROGS_s390x += rseq_test
+TEST_GEN_PROGS_s390x += set_memory_region_test
+TEST_GEN_PROGS_s390x += kvm_binary_stats_test
+
+TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
+TEST_GEN_PROGS_riscv += riscv/ebreak_test
+TEST_GEN_PROGS_riscv += arch_timer
+TEST_GEN_PROGS_riscv += coalesced_io_test
+TEST_GEN_PROGS_riscv += demand_paging_test
+TEST_GEN_PROGS_riscv += dirty_log_test
+TEST_GEN_PROGS_riscv += get-reg-list
+TEST_GEN_PROGS_riscv += guest_print_test
+TEST_GEN_PROGS_riscv += kvm_binary_stats_test
+TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
+TEST_GEN_PROGS_riscv += kvm_page_table_test
+TEST_GEN_PROGS_riscv += set_memory_region_test
+TEST_GEN_PROGS_riscv += steal_time
+
+SPLIT_TESTS += arch_timer
+SPLIT_TESTS += get-reg-list
+
+TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
+LIBKVM += $(LIBKVM_$(ARCH_DIR))
+
+OVERRIDE_TARGETS = 1
+
+# lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
+# importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
+# which causes the environment variable to override the makefile).
+include ../lib.mk
+
+INSTALL_HDR_PATH = $(top_srcdir)/usr
+LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
+LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
+ifeq ($(ARCH),x86_64)
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
+else
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+endif
+CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
+	-fno-builtin-memcmp -fno-builtin-memcpy \
+	-fno-builtin-memset -fno-builtin-strnlen \
+	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
+	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
+	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
+	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+ifeq ($(ARCH),s390)
+	CFLAGS += -march=z10
+endif
+ifeq ($(ARCH),x86)
+ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
+	CFLAGS += -march=x86-64-v2
+endif
+endif
+ifeq ($(ARCH),arm64)
+tools_dir := $(top_srcdir)/tools
+arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
+
+ifneq ($(abs_objdir),)
+arm64_hdr_outdir := $(abs_objdir)/tools/
+else
+arm64_hdr_outdir := $(tools_dir)/
+endif
+
+GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
+CFLAGS += -I$(GEN_HDRS)
+
+$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
+	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
+endif
+
+no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
+        $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
+
+# On s390, build the testcases KVM-enabled
+pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
+	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
+
+LDLIBS += -ldl
+LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
+
+LIBKVM_C := $(filter %.c,$(LIBKVM))
+LIBKVM_S := $(filter %.S,$(LIBKVM))
+LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
+LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
+LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
+SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
+
+TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_OBJ))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
+-include $(TEST_DEP_FILES)
+
+$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+
+$(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
+$(TEST_GEN_PROGS_EXTENDED): %: %.o
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM_OBJS) $(LDLIBS) -o $@
+$(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
+$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+EXTRA_CLEAN += $(GEN_HDRS) \
+	       $(LIBKVM_OBJS) \
+	       $(SPLIT_TEST_GEN_OBJ) \
+	       $(TEST_DEP_FILES) \
+	       $(TEST_GEN_OBJ) \
+	       cscope.*
+
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+# Compile the string overrides as freestanding to prevent the compiler from
+# generating self-referential code, e.g. without "freestanding" the compiler may
+# "optimize" memcmp() by invoking memcmp(), thus causing infinite recursion.
+$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
+
+$(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
+$(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
+$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
+$(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
+$(TEST_GEN_OBJ): $(GEN_HDRS)
+
+cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
+cscope:
+	$(RM) cscope.*
+	(find $(include_paths) -name '*.h' \
+		-exec realpath --relative-base=$(PWD) {} \;; \
+	find . -name '*.c' \
+		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
+	cscope -b
-- 
2.47.0.338.g60cca15819-goog


