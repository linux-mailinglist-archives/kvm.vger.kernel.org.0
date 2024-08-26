Return-Path: <kvm+bounces-25072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7EA95F94D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 21:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D8111F22B62
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A24199253;
	Mon, 26 Aug 2024 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RaOHkhZm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF9C1917E0
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698885; cv=none; b=iGkeyVo5dSwylNMj2y5qn2nrkISd5KFX8ef3KGNkks3o3ql2xqa0ziZnmyWcXyPrQqz9laaMSS6JFBaW5JYi78DAFWJSrCx0si2Q2iVJIdr0kojMu4XtPSNmU/i69B/LoGQAYxklD6YxdhaVq6wKEBHJqbunnkmUMFv8iYwemZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698885; c=relaxed/simple;
	bh=rUKRX0YrvlYLQoOXlu/Qahpj1FKWsbwUW8LUExX+Kww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uPfZWp0a/br1ukLJ5jh4RZ90UgqqeWReylf+0pawuQr6VVOX4Wq5W7b3wkn9rzv5/b8KVUkDpI9KxTTZK4GLjCJPlrQVnGXk3Tw+I0mel/lzkjTK9K21xbplDaEOP8l28al+Zuf2h2QtATemlKXlzOmGRMyXxAac3OUgNNW3Sto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RaOHkhZm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7163489149fso4483172a12.3
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 12:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724698883; x=1725303683; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yjp0h9Be3Qh/6DtTSbpe8fCyQ5dWM0lm7oBskSFP/xI=;
        b=RaOHkhZm4qehTyq8DvOdd4g4zPs3zacg3Cwq7YwrkJoVyJib+SJNOGUkB9kgSrHiKU
         GgHLT3ARDXRLmAed4PqoKQVCU49ujU82yxv65vxrZheXMGsVj8fmRhFr718oLysDttmP
         C4WdkPNczkdaM1nTTn+pLazmeQnILFttCVnJb8ziogyGkg56hwNXD4fj5NW20GQKQvTs
         BKMyWJp+TeEdGVcFRzxFmXShJuq5b5Lhq3F/CuwkM4jpK/d4tAKp7E/PqayMlvdF99cC
         tJ7b7E9apaSEX3MRTcWMgcJTgvnv36TLlB+mr3pkz1F89NUiKyGpUxkAbv0BVvQcjTFk
         HR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724698883; x=1725303683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yjp0h9Be3Qh/6DtTSbpe8fCyQ5dWM0lm7oBskSFP/xI=;
        b=teoosOsB6s+M/L2pWBIlPH4QivsXweyYopjSi7pqJAoyy/SNWnDlOcbz6W5YyvAks9
         xRY8Le/iK2HYD/Ra8s34BJSeuyAeQsXEQT4gr+K9UtvGHdNPGKPuRHDV4/crWeFEP8yD
         M4X7aaND8Ln7ZFf/ytDiUU/VjgkqeGNDq+es2yfQI6WIVKcp1he3+8fa8F+5hm+AlLDJ
         9oyKGLHrUi4OUq6+KlxyGaD0FNXWl2WwOtbnsuGMcYMUAPVVKfPZBXXjf1biyQbOylGv
         JyJtaKm0UFRIZTSMPmjDystUCJ8Es2XY4JzmGP9r2TQAU2fRzVQyeoKm4LVxZNaTvZFT
         mLYQ==
X-Gm-Message-State: AOJu0Yyu7LxMQfQ1QyQ/c/ifFqdIK+yjRQVfStL5iPPjP7RCeHpp6gT6
	URDrhfS+MI3zUfRKaxDgzcW34VpXZlj3E/SdOcE/eyVfslF9T08/IyZsjyq/SnRjAOrQ04+RGN/
	wYg==
X-Google-Smtp-Source: AGHT+IFa56At1izibNvH4iO7KCmhZm61HQM4QvjjFU3VIZcTwutstZt4/7NGPtn7uF2ThtSDZjrmu+ZznUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7259:0:b0:75d:16f9:c075 with SMTP id
 41be03b00d2f7-7cf54e9cee3mr19690a12.9.1724698882241; Mon, 26 Aug 2024
 12:01:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 26 Aug 2024 12:01:14 -0700
In-Reply-To: <20240826190116.145945-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826190116.145945-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826190116.145945-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: selftests: Provide empty 'all' and 'clean' targets
 for unsupported ARCHs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
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
 tools/testing/selftests/kvm/Makefile     | 323 +----------------------
 tools/testing/selftests/kvm/Makefile.kvm | 319 ++++++++++++++++++++++
 2 files changed, 325 insertions(+), 317 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/Makefile.kvm

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..787b63b52db7 100644
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
@@ -17,317 +14,9 @@ else
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
-TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
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
-TEST_GEN_PROGS_x86_64 += demand_paging_test
-TEST_GEN_PROGS_x86_64 += dirty_log_test
-TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
-TEST_GEN_PROGS_x86_64 += guest_memfd_test
-TEST_GEN_PROGS_x86_64 += guest_print_test
-TEST_GEN_PROGS_x86_64 += hardware_disable_test
-TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += max_guest_memory_test
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
-TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
-TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
-TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
-TEST_GEN_PROGS_aarch64 += aarch64/psci_test
-TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
-TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
-TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
-TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
-TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
-TEST_GEN_PROGS_aarch64 += arch_timer
-TEST_GEN_PROGS_aarch64 += demand_paging_test
-TEST_GEN_PROGS_aarch64 += dirty_log_test
-TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
-TEST_GEN_PROGS_aarch64 += guest_print_test
-TEST_GEN_PROGS_aarch64 += get-reg-list
-TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_aarch64 += kvm_page_table_test
-TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
-TEST_GEN_PROGS_aarch64 += memslot_perf_test
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
-TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
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
-endif
-CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
-	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
-	-fno-builtin-memcmp -fno-builtin-memcpy \
-	-fno-builtin-memset -fno-builtin-strnlen \
-	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-	$(KHDR_INCLUDES)
-ifeq ($(ARCH),s390)
-	CFLAGS += -march=z10
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
+# Empty targets for unsupported architectures
+all:
+clean:
+endif
\ No newline at end of file
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
new file mode 100644
index 000000000000..802d05eee674
--- /dev/null
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -0,0 +1,319 @@
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
+TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
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
+TEST_GEN_PROGS_x86_64 += demand_paging_test
+TEST_GEN_PROGS_x86_64 += dirty_log_test
+TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_memfd_test
+TEST_GEN_PROGS_x86_64 += guest_print_test
+TEST_GEN_PROGS_x86_64 += hardware_disable_test
+TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_x86_64 += kvm_page_table_test
+TEST_GEN_PROGS_x86_64 += max_guest_memory_test
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
+TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
+TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
+TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
+TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
+TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
+TEST_GEN_PROGS_aarch64 += arch_timer
+TEST_GEN_PROGS_aarch64 += demand_paging_test
+TEST_GEN_PROGS_aarch64 += dirty_log_test
+TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_print_test
+TEST_GEN_PROGS_aarch64 += get-reg-list
+TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_aarch64 += kvm_page_table_test
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
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
+TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
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
+	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
+	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
+	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
+	$(KHDR_INCLUDES)
+ifeq ($(ARCH),s390)
+	CFLAGS += -march=z10
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
2.46.0.295.g3b9ea8a38a-goog


