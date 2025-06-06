Return-Path: <kvm+bounces-48691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7DAAD0A86
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D28166177
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25252417C2;
	Fri,  6 Jun 2025 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O4sZsHAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55652242D9F
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254214; cv=none; b=EMFJkArORAxZExTFLZDot9wGAT0IQir9ChBVUIrRpWVafi3+wGaX4fG66GVogPrXaYaq03yQHi1JI1rYoxRJqoSvUVAqL8uyQD9UCoQ504HoXCHxqXlTipBTZ/Kb6hTpR9IZhEjPz6ZGTzMh+lUyMToAHC1zGd76WiF+giAxzTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254214; c=relaxed/simple;
	bh=VkOXAw2W8Lg3T66k+N4fVnUGuVDbxmv8Bw+ObVtdfes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/66UVVA/QCxZWjXS5P1OEBFyVrvYeB6KyF91oVIOTV4SI0lRgZxy8XbhxZ7eWgePyKwvcAovUyGcSdZrH7f5jPVs0mTue8hdP8G/W+xP1+75ayDes8F4I38cOjZYpDXcX4nIxm6OmtJr6oejO04AVPSgGI7EHPv0QP6U9PAbgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O4sZsHAQ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742d077bdfaso3612586b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254210; x=1749859010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bI+dCH5hC9M27KLLqOGE5y8W3x/cx8Zy7I+fEhr9Uww=;
        b=O4sZsHAQKQtV6BxkqErYtk+pABjBY6o/aCTSKU0x3dYTF2kKbzhPOi8PUd5eAkVxQf
         +fgQmH9Msj0CNGrvcwTYr0VfMQNsTpG3XzWgGaerOCfHABUYOTZEE2wPDYv7Amg6aTFP
         VY0man8bXrmFJ/bZq3Zxgkb+DoZZ1Wu/qInkUcHLQ5YXHms3yi75YwstFZMyh83AHa9g
         iWUwykmV9YauEG8PjtayQUrP7cDpE+dNISzh1j26nT5Gtf3ExLyW6b4ljBuj89q5jvCe
         usqZ9i9Zx4lBfEN8a6BZ0bKNUtUdjO2nbC2WHyVDu+HkmW5cbOW53Z9kZEBLRI8X5RM3
         HEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254210; x=1749859010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bI+dCH5hC9M27KLLqOGE5y8W3x/cx8Zy7I+fEhr9Uww=;
        b=Ha3H/6EngP7/hi421H5Qp11/4eaNd0b/NMpbXpRWvH2jm/wRAQ1aYBc4vRJWOeKqDb
         P+hR7UH9UZUKIgEOwZWZadT04bF+/cp/gWSWNMhy3AYAShqAE86yipLozccw6V1WuON1
         1r2ZOTmgmaRMb6IZv2KGrAU7v92nccQ7XCT4tUGU0PsIzFFAX7plFOlQK8qD/UTfmXR1
         tLqVZcEBipDVgBYik8S3HJ5guC0QEUUH0nzREpOHXkHQvL9dgOFRV1f4s0AcYaJLtJ8o
         DotjtPqLfFy/zKeKyn5ZzEESQTMTWK7ZTokLpLFmxVBOzdk/JmFQZ0QOc4JNpq1frXOt
         I1JA==
X-Gm-Message-State: AOJu0Yxx1b5NGR24fK5dwEmExQFJXHodjvpOs9Y9zwtCcWUJj4IrQAfX
	0f9gBO5ZT83tbwheS26Cx9wcmkqog/8oc+WEtzIkY9PF0U4o9cIExuDgCFxuBZK1bEQ04Gg1KOq
	l2JALwQPFBms4J+5SAbKgXkjhcZ5IWEXET3as7Mf0+GGxyMq6P1Jvz8aZfXsaFM9tRvfAeXo/kz
	C1l4vqf9A52r2JLuU1VogfCZxDXwi3kMqlr92bQA==
X-Google-Smtp-Source: AGHT+IEcm3TCu/f/rvFUhWHhOnJWkDnm0m8ygPSpPL6JO03WGLuMKDviodzbpYo0sDs2lozYhoSMzQ6GTbYK
X-Received: from pfgt25.prod.google.com ([2002:a05:6a00:1399:b0:747:cffb:bb21])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1910:b0:736:5b85:a911
 with SMTP id d2e1a72fcca58-74827e74748mr8110047b3a.8.1749254210518; Fri, 06
 Jun 2025 16:56:50 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:16 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-13-vipinsh@google.com>
Subject: [PATCH v2 12/15] KVM: selftests: Add x86 auto generated test files
 for KVM Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add auto generated test files for x86 platform.

These files will not show up in git-diff again unless a test is renamed.
In future patches more .test files will be added to run selftests with
their command line arguments.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/tests/access_tracking_perf_test/default.test   | 1 +
 tools/testing/selftests/kvm/tests/coalesced_io_test/default.test | 1 +
 .../testing/selftests/kvm/tests/demand_paging_test/default.test  | 1 +
 tools/testing/selftests/kvm/tests/dirty_log_test/default.test    | 1 +
 tools/testing/selftests/kvm/tests/guest_memfd_test/default.test  | 1 +
 tools/testing/selftests/kvm/tests/guest_print_test/default.test  | 1 +
 .../selftests/kvm/tests/hardware_disable_test/default.test       | 1 +
 .../selftests/kvm/tests/kvm_binary_stats_test/default.test       | 1 +
 .../selftests/kvm/tests/kvm_create_max_vcpus/default.test        | 1 +
 .../testing/selftests/kvm/tests/kvm_page_table_test/default.test | 1 +
 .../kvm/tests/memslot_modification_stress_test/default.test      | 1 +
 tools/testing/selftests/kvm/tests/memslot_perf_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/mmu_stress_test/default.test   | 1 +
 .../selftests/kvm/tests/pre_fault_memory_test/default.test       | 1 +
 tools/testing/selftests/kvm/tests/rseq_test/default.test         | 1 +
 .../selftests/kvm/tests/set_memory_region_test/default.test      | 1 +
 tools/testing/selftests/kvm/tests/steal_time/default.test        | 1 +
 .../selftests/kvm/tests/system_counter_offset_test/default.test  | 1 +
 tools/testing/selftests/kvm/tests/x86/amx_test/default.test      | 1 +
 .../selftests/kvm/tests/x86/apic_bus_clock_test/default.test     | 1 +
 tools/testing/selftests/kvm/tests/x86/cpuid_test/default.test    | 1 +
 .../selftests/kvm/tests/x86/cr4_cpuid_sync_test/default.test     | 1 +
 tools/testing/selftests/kvm/tests/x86/debug_regs/default.test    | 1 +
 .../kvm/tests/x86/dirty_log_page_splitting_test/default.test     | 1 +
 .../kvm/tests/x86/exit_on_emulation_failure_test/default.test    | 1 +
 tools/testing/selftests/kvm/tests/x86/fastops_test/default.test  | 1 +
 .../selftests/kvm/tests/x86/feature_msrs_test/default.test       | 1 +
 .../selftests/kvm/tests/x86/fix_hypercall_test/default.test      | 1 +
 tools/testing/selftests/kvm/tests/x86/hwcr_msr_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/x86/hyperv_clock/default.test  | 1 +
 tools/testing/selftests/kvm/tests/x86/hyperv_cpuid/default.test  | 1 +
 tools/testing/selftests/kvm/tests/x86/hyperv_evmcs/default.test  | 1 +
 .../kvm/tests/x86/hyperv_extended_hypercalls/default.test        | 1 +
 .../testing/selftests/kvm/tests/x86/hyperv_features/default.test | 1 +
 tools/testing/selftests/kvm/tests/x86/hyperv_ipi/default.test    | 1 +
 .../testing/selftests/kvm/tests/x86/hyperv_svm_test/default.test | 1 +
 .../selftests/kvm/tests/x86/hyperv_tlb_flush/default.test        | 1 +
 .../selftests/kvm/tests/x86/kvm_buslock_test/default.test        | 1 +
 .../testing/selftests/kvm/tests/x86/kvm_clock_test/default.test  | 1 +
 tools/testing/selftests/kvm/tests/x86/kvm_pv_test/default.test   | 1 +
 .../selftests/kvm/tests/x86/max_vcpuid_cap_test/default.test     | 1 +
 .../selftests/kvm/tests/x86/monitor_mwait_test/default.test      | 1 +
 .../selftests/kvm/tests/x86/nested_emulation_test/default.test   | 1 +
 .../selftests/kvm/tests/x86/nested_exceptions_test/default.test  | 1 +
 .../selftests/kvm/tests/x86/nx_huge_pages_test/default.test      | 1 +
 .../selftests/kvm/tests/x86/platform_info_test/default.test      | 1 +
 .../selftests/kvm/tests/x86/pmu_counters_test/default.test       | 1 +
 .../selftests/kvm/tests/x86/pmu_event_filter_test/default.test   | 1 +
 .../kvm/tests/x86/private_mem_conversions_test/default.test      | 1 +
 .../kvm/tests/x86/private_mem_kvm_exits_test/default.test        | 1 +
 .../selftests/kvm/tests/x86/recalc_apic_map_test/default.test    | 1 +
 .../testing/selftests/kvm/tests/x86/set_boot_cpu_id/default.test | 1 +
 .../testing/selftests/kvm/tests/x86/set_sregs_test/default.test  | 1 +
 .../testing/selftests/kvm/tests/x86/sev_init2_tests/default.test | 1 +
 .../selftests/kvm/tests/x86/sev_migrate_tests/default.test       | 1 +
 .../testing/selftests/kvm/tests/x86/sev_smoke_test/default.test  | 1 +
 .../kvm/tests/x86/smaller_maxphyaddr_emulation_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/x86/smm_test/default.test      | 1 +
 tools/testing/selftests/kvm/tests/x86/state_test/default.test    | 1 +
 .../selftests/kvm/tests/x86/svm_int_ctl_test/default.test        | 1 +
 .../kvm/tests/x86/svm_nested_shutdown_test/default.test          | 1 +
 .../kvm/tests/x86/svm_nested_soft_inject_test/default.test       | 1 +
 .../testing/selftests/kvm/tests/x86/svm_vmcall_test/default.test | 1 +
 .../testing/selftests/kvm/tests/x86/sync_regs_test/default.test  | 1 +
 .../selftests/kvm/tests/x86/triple_fault_event_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/x86/tsc_msrs_test/default.test | 1 +
 .../selftests/kvm/tests/x86/tsc_scaling_sync/default.test        | 1 +
 .../selftests/kvm/tests/x86/ucna_injection_test/default.test     | 1 +
 .../selftests/kvm/tests/x86/userspace_io_test/default.test       | 1 +
 .../selftests/kvm/tests/x86/userspace_msr_exit_test/default.test | 1 +
 .../selftests/kvm/tests/x86/vmx_apic_access_test/default.test    | 1 +
 .../kvm/tests/x86/vmx_close_while_nested_test/default.test       | 1 +
 .../selftests/kvm/tests/x86/vmx_dirty_log_test/default.test      | 1 +
 .../x86/vmx_exception_with_invalid_guest_state/default.test      | 1 +
 .../kvm/tests/x86/vmx_invalid_nested_guest_state/default.test    | 1 +
 tools/testing/selftests/kvm/tests/x86/vmx_msrs_test/default.test | 1 +
 .../kvm/tests/x86/vmx_nested_tsc_scaling_test/default.test       | 1 +
 .../selftests/kvm/tests/x86/vmx_pmu_caps_test/default.test       | 1 +
 .../kvm/tests/x86/vmx_preemption_timer_test/default.test         | 1 +
 .../kvm/tests/x86/vmx_set_nested_state_test/default.test         | 1 +
 .../selftests/kvm/tests/x86/vmx_tsc_adjust_test/default.test     | 1 +
 .../testing/selftests/kvm/tests/x86/xapic_ipi_test/default.test  | 1 +
 .../selftests/kvm/tests/x86/xapic_state_test/default.test        | 1 +
 .../testing/selftests/kvm/tests/x86/xcr0_cpuid_test/default.test | 1 +
 .../testing/selftests/kvm/tests/x86/xen_shinfo_test/default.test | 1 +
 .../testing/selftests/kvm/tests/x86/xen_vmcall_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/x86/xss_msr_test/default.test  | 1 +
 87 files changed, 87 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/access_tracking_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/coalesced_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/demand_paging_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/guest_memfd_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/guest_print_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/hardware_disable_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/kvm_binary_stats_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/kvm_create_max_vcpus/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/kvm_page_table_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/memslot_modification_stress_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/memslot_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/mmu_stress_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/pre_fault_memory_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/rseq_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/set_memory_region_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/steal_time/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/system_counter_offset_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/amx_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/apic_bus_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/cr4_cpuid_sync_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/debug_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/dirty_log_page_splitting_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/exit_on_emulation_failure_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/fastops_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/feature_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/fix_hypercall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hwcr_msr_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_clock/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_cpuid/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_evmcs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_extended_hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_features/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_ipi/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_svm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/hyperv_tlb_flush/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/kvm_buslock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/kvm_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/kvm_pv_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/max_vcpuid_cap_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/monitor_mwait_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/nested_emulation_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/nested_exceptions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/nx_huge_pages_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/platform_info_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/pmu_counters_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/pmu_event_filter_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/private_mem_conversions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/private_mem_kvm_exits_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/recalc_apic_map_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/set_boot_cpu_id/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/set_sregs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/sev_init2_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/sev_migrate_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/sev_smoke_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/smaller_maxphyaddr_emulation_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/smm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/svm_int_ctl_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/svm_nested_shutdown_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/svm_nested_soft_inject_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/svm_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/triple_fault_event_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/tsc_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/tsc_scaling_sync/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/ucna_injection_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/userspace_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/userspace_msr_exit_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_apic_access_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_close_while_nested_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_exception_with_invalid_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_invalid_nested_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_nested_tsc_scaling_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_pmu_caps_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_preemption_timer_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_set_nested_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/vmx_tsc_adjust_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xapic_ipi_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xapic_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xcr0_cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xen_shinfo_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xen_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/x86/xss_msr_test/default.test

diff --git a/tools/testing/selftests/kvm/tests/access_tracking_perf_test/default.test b/tools/testing/selftests/kvm/tests/access_tracking_perf_test/default.test
new file mode 100644
index 000000000000..93e0f5d35525
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/access_tracking_perf_test/default.test
@@ -0,0 +1 @@
+access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/tests/coalesced_io_test/default.test b/tools/testing/selftests/kvm/tests/coalesced_io_test/default.test
new file mode 100644
index 000000000000..9c3e8fb05142
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/coalesced_io_test/default.test
@@ -0,0 +1 @@
+coalesced_io_test
diff --git a/tools/testing/selftests/kvm/tests/demand_paging_test/default.test b/tools/testing/selftests/kvm/tests/demand_paging_test/default.test
new file mode 100644
index 000000000000..9ce2eaf620e1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/demand_paging_test/default.test
@@ -0,0 +1 @@
+demand_paging_test
diff --git a/tools/testing/selftests/kvm/tests/dirty_log_test/default.test b/tools/testing/selftests/kvm/tests/dirty_log_test/default.test
new file mode 100644
index 000000000000..56a07cffab15
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/dirty_log_test/default.test
@@ -0,0 +1 @@
+dirty_log_test
diff --git a/tools/testing/selftests/kvm/tests/guest_memfd_test/default.test b/tools/testing/selftests/kvm/tests/guest_memfd_test/default.test
new file mode 100644
index 000000000000..1e68140a8a4b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/guest_memfd_test/default.test
@@ -0,0 +1 @@
+guest_memfd_test
diff --git a/tools/testing/selftests/kvm/tests/guest_print_test/default.test b/tools/testing/selftests/kvm/tests/guest_print_test/default.test
new file mode 100644
index 000000000000..9f83cb6e379d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/guest_print_test/default.test
@@ -0,0 +1 @@
+guest_print_test
diff --git a/tools/testing/selftests/kvm/tests/hardware_disable_test/default.test b/tools/testing/selftests/kvm/tests/hardware_disable_test/default.test
new file mode 100644
index 000000000000..bd0aae00519b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/hardware_disable_test/default.test
@@ -0,0 +1 @@
+hardware_disable_test
diff --git a/tools/testing/selftests/kvm/tests/kvm_binary_stats_test/default.test b/tools/testing/selftests/kvm/tests/kvm_binary_stats_test/default.test
new file mode 100644
index 000000000000..fd0f99fe7b94
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/kvm_binary_stats_test/default.test
@@ -0,0 +1 @@
+kvm_binary_stats_test
diff --git a/tools/testing/selftests/kvm/tests/kvm_create_max_vcpus/default.test b/tools/testing/selftests/kvm/tests/kvm_create_max_vcpus/default.test
new file mode 100644
index 000000000000..68e5174fb84d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/kvm_create_max_vcpus/default.test
@@ -0,0 +1 @@
+kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/tests/kvm_page_table_test/default.test b/tools/testing/selftests/kvm/tests/kvm_page_table_test/default.test
new file mode 100644
index 000000000000..4988836740b7
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/kvm_page_table_test/default.test
@@ -0,0 +1 @@
+kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/tests/memslot_modification_stress_test/default.test b/tools/testing/selftests/kvm/tests/memslot_modification_stress_test/default.test
new file mode 100644
index 000000000000..ccb1d45ab009
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/memslot_modification_stress_test/default.test
@@ -0,0 +1 @@
+memslot_modification_stress_test
diff --git a/tools/testing/selftests/kvm/tests/memslot_perf_test/default.test b/tools/testing/selftests/kvm/tests/memslot_perf_test/default.test
new file mode 100644
index 000000000000..2de1264b631b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/memslot_perf_test/default.test
@@ -0,0 +1 @@
+memslot_perf_test
diff --git a/tools/testing/selftests/kvm/tests/mmu_stress_test/default.test b/tools/testing/selftests/kvm/tests/mmu_stress_test/default.test
new file mode 100644
index 000000000000..0e1ed1e3b971
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/mmu_stress_test/default.test
@@ -0,0 +1 @@
+mmu_stress_test
diff --git a/tools/testing/selftests/kvm/tests/pre_fault_memory_test/default.test b/tools/testing/selftests/kvm/tests/pre_fault_memory_test/default.test
new file mode 100644
index 000000000000..4e352e629be5
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/pre_fault_memory_test/default.test
@@ -0,0 +1 @@
+pre_fault_memory_test
diff --git a/tools/testing/selftests/kvm/tests/rseq_test/default.test b/tools/testing/selftests/kvm/tests/rseq_test/default.test
new file mode 100644
index 000000000000..fabc9ae64128
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/rseq_test/default.test
@@ -0,0 +1 @@
+rseq_test
diff --git a/tools/testing/selftests/kvm/tests/set_memory_region_test/default.test b/tools/testing/selftests/kvm/tests/set_memory_region_test/default.test
new file mode 100644
index 000000000000..c3f91720e105
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/set_memory_region_test/default.test
@@ -0,0 +1 @@
+set_memory_region_test
diff --git a/tools/testing/selftests/kvm/tests/steal_time/default.test b/tools/testing/selftests/kvm/tests/steal_time/default.test
new file mode 100644
index 000000000000..5f3e20693d58
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/steal_time/default.test
@@ -0,0 +1 @@
+steal_time
diff --git a/tools/testing/selftests/kvm/tests/system_counter_offset_test/default.test b/tools/testing/selftests/kvm/tests/system_counter_offset_test/default.test
new file mode 100644
index 000000000000..4d76b9f44147
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/system_counter_offset_test/default.test
@@ -0,0 +1 @@
+system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/tests/x86/amx_test/default.test b/tools/testing/selftests/kvm/tests/x86/amx_test/default.test
new file mode 100644
index 000000000000..423ce501efee
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/amx_test/default.test
@@ -0,0 +1 @@
+x86/amx_test
diff --git a/tools/testing/selftests/kvm/tests/x86/apic_bus_clock_test/default.test b/tools/testing/selftests/kvm/tests/x86/apic_bus_clock_test/default.test
new file mode 100644
index 000000000000..e985ff8520f5
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/apic_bus_clock_test/default.test
@@ -0,0 +1 @@
+x86/apic_bus_clock_test
diff --git a/tools/testing/selftests/kvm/tests/x86/cpuid_test/default.test b/tools/testing/selftests/kvm/tests/x86/cpuid_test/default.test
new file mode 100644
index 000000000000..d2b2a48b25af
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/cpuid_test/default.test
@@ -0,0 +1 @@
+x86/cpuid_test
diff --git a/tools/testing/selftests/kvm/tests/x86/cr4_cpuid_sync_test/default.test b/tools/testing/selftests/kvm/tests/x86/cr4_cpuid_sync_test/default.test
new file mode 100644
index 000000000000..0d8e182cd2ca
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/cr4_cpuid_sync_test/default.test
@@ -0,0 +1 @@
+x86/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/tests/x86/debug_regs/default.test b/tools/testing/selftests/kvm/tests/x86/debug_regs/default.test
new file mode 100644
index 000000000000..440eeb9ab33d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/debug_regs/default.test
@@ -0,0 +1 @@
+x86/debug_regs
diff --git a/tools/testing/selftests/kvm/tests/x86/dirty_log_page_splitting_test/default.test b/tools/testing/selftests/kvm/tests/x86/dirty_log_page_splitting_test/default.test
new file mode 100644
index 000000000000..71e98eb3103c
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/dirty_log_page_splitting_test/default.test
@@ -0,0 +1 @@
+x86/dirty_log_page_splitting_test
diff --git a/tools/testing/selftests/kvm/tests/x86/exit_on_emulation_failure_test/default.test b/tools/testing/selftests/kvm/tests/x86/exit_on_emulation_failure_test/default.test
new file mode 100644
index 000000000000..351242070720
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/exit_on_emulation_failure_test/default.test
@@ -0,0 +1 @@
+x86/exit_on_emulation_failure_test
diff --git a/tools/testing/selftests/kvm/tests/x86/fastops_test/default.test b/tools/testing/selftests/kvm/tests/x86/fastops_test/default.test
new file mode 100644
index 000000000000..d51c860be0d9
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/fastops_test/default.test
@@ -0,0 +1 @@
+x86/fastops_test
diff --git a/tools/testing/selftests/kvm/tests/x86/feature_msrs_test/default.test b/tools/testing/selftests/kvm/tests/x86/feature_msrs_test/default.test
new file mode 100644
index 000000000000..57d867b6b94c
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/feature_msrs_test/default.test
@@ -0,0 +1 @@
+x86/feature_msrs_test
diff --git a/tools/testing/selftests/kvm/tests/x86/fix_hypercall_test/default.test b/tools/testing/selftests/kvm/tests/x86/fix_hypercall_test/default.test
new file mode 100644
index 000000000000..f95e114d8241
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/fix_hypercall_test/default.test
@@ -0,0 +1 @@
+x86/fix_hypercall_test
diff --git a/tools/testing/selftests/kvm/tests/x86/hwcr_msr_test/default.test b/tools/testing/selftests/kvm/tests/x86/hwcr_msr_test/default.test
new file mode 100644
index 000000000000..4a957c09db6b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hwcr_msr_test/default.test
@@ -0,0 +1 @@
+x86/hwcr_msr_test
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_clock/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_clock/default.test
new file mode 100644
index 000000000000..a3ff8a689773
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_clock/default.test
@@ -0,0 +1 @@
+x86/hyperv_clock
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_cpuid/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_cpuid/default.test
new file mode 100644
index 000000000000..66b0d85430eb
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_cpuid/default.test
@@ -0,0 +1 @@
+x86/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_evmcs/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_evmcs/default.test
new file mode 100644
index 000000000000..aa34233db0c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_evmcs/default.test
@@ -0,0 +1 @@
+x86/hyperv_evmcs
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_extended_hypercalls/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_extended_hypercalls/default.test
new file mode 100644
index 000000000000..4fdfc3714d54
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_extended_hypercalls/default.test
@@ -0,0 +1 @@
+x86/hyperv_extended_hypercalls
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_features/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_features/default.test
new file mode 100644
index 000000000000..dc486adbe756
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_features/default.test
@@ -0,0 +1 @@
+x86/hyperv_features
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_ipi/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_ipi/default.test
new file mode 100644
index 000000000000..b21cc166efdb
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_ipi/default.test
@@ -0,0 +1 @@
+x86/hyperv_ipi
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_svm_test/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_svm_test/default.test
new file mode 100644
index 000000000000..0e973fbf7e5a
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_svm_test/default.test
@@ -0,0 +1 @@
+x86/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/tests/x86/hyperv_tlb_flush/default.test b/tools/testing/selftests/kvm/tests/x86/hyperv_tlb_flush/default.test
new file mode 100644
index 000000000000..bcbd02d50d68
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/hyperv_tlb_flush/default.test
@@ -0,0 +1 @@
+x86/hyperv_tlb_flush
diff --git a/tools/testing/selftests/kvm/tests/x86/kvm_buslock_test/default.test b/tools/testing/selftests/kvm/tests/x86/kvm_buslock_test/default.test
new file mode 100644
index 000000000000..b9e46fc3ecb8
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/kvm_buslock_test/default.test
@@ -0,0 +1 @@
+x86/kvm_buslock_test
diff --git a/tools/testing/selftests/kvm/tests/x86/kvm_clock_test/default.test b/tools/testing/selftests/kvm/tests/x86/kvm_clock_test/default.test
new file mode 100644
index 000000000000..434a1c13d9e6
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/kvm_clock_test/default.test
@@ -0,0 +1 @@
+x86/kvm_clock_test
diff --git a/tools/testing/selftests/kvm/tests/x86/kvm_pv_test/default.test b/tools/testing/selftests/kvm/tests/x86/kvm_pv_test/default.test
new file mode 100644
index 000000000000..c785934d98a8
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/kvm_pv_test/default.test
@@ -0,0 +1 @@
+x86/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/tests/x86/max_vcpuid_cap_test/default.test b/tools/testing/selftests/kvm/tests/x86/max_vcpuid_cap_test/default.test
new file mode 100644
index 000000000000..3b36b5dcbbb3
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/max_vcpuid_cap_test/default.test
@@ -0,0 +1 @@
+x86/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/tests/x86/monitor_mwait_test/default.test b/tools/testing/selftests/kvm/tests/x86/monitor_mwait_test/default.test
new file mode 100644
index 000000000000..ec31250b319a
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/monitor_mwait_test/default.test
@@ -0,0 +1 @@
+x86/monitor_mwait_test
diff --git a/tools/testing/selftests/kvm/tests/x86/nested_emulation_test/default.test b/tools/testing/selftests/kvm/tests/x86/nested_emulation_test/default.test
new file mode 100644
index 000000000000..68262f28e738
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/nested_emulation_test/default.test
@@ -0,0 +1 @@
+x86/nested_emulation_test
diff --git a/tools/testing/selftests/kvm/tests/x86/nested_exceptions_test/default.test b/tools/testing/selftests/kvm/tests/x86/nested_exceptions_test/default.test
new file mode 100644
index 000000000000..1361448740dd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/nested_exceptions_test/default.test
@@ -0,0 +1 @@
+x86/nested_exceptions_test
diff --git a/tools/testing/selftests/kvm/tests/x86/nx_huge_pages_test/default.test b/tools/testing/selftests/kvm/tests/x86/nx_huge_pages_test/default.test
new file mode 100644
index 000000000000..5229d1f85e2f
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/nx_huge_pages_test/default.test
@@ -0,0 +1 @@
+x86/nx_huge_pages_test.sh
diff --git a/tools/testing/selftests/kvm/tests/x86/platform_info_test/default.test b/tools/testing/selftests/kvm/tests/x86/platform_info_test/default.test
new file mode 100644
index 000000000000..2fe74d5d32bd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/platform_info_test/default.test
@@ -0,0 +1 @@
+x86/platform_info_test
diff --git a/tools/testing/selftests/kvm/tests/x86/pmu_counters_test/default.test b/tools/testing/selftests/kvm/tests/x86/pmu_counters_test/default.test
new file mode 100644
index 000000000000..c94201dbdfb3
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/pmu_counters_test/default.test
@@ -0,0 +1 @@
+x86/pmu_counters_test
diff --git a/tools/testing/selftests/kvm/tests/x86/pmu_event_filter_test/default.test b/tools/testing/selftests/kvm/tests/x86/pmu_event_filter_test/default.test
new file mode 100644
index 000000000000..c64ec1b8fba4
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/pmu_event_filter_test/default.test
@@ -0,0 +1 @@
+x86/pmu_event_filter_test
diff --git a/tools/testing/selftests/kvm/tests/x86/private_mem_conversions_test/default.test b/tools/testing/selftests/kvm/tests/x86/private_mem_conversions_test/default.test
new file mode 100644
index 000000000000..933293725304
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/private_mem_conversions_test/default.test
@@ -0,0 +1 @@
+x86/private_mem_conversions_test
diff --git a/tools/testing/selftests/kvm/tests/x86/private_mem_kvm_exits_test/default.test b/tools/testing/selftests/kvm/tests/x86/private_mem_kvm_exits_test/default.test
new file mode 100644
index 000000000000..a2dd9876cb54
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/private_mem_kvm_exits_test/default.test
@@ -0,0 +1 @@
+x86/private_mem_kvm_exits_test
diff --git a/tools/testing/selftests/kvm/tests/x86/recalc_apic_map_test/default.test b/tools/testing/selftests/kvm/tests/x86/recalc_apic_map_test/default.test
new file mode 100644
index 000000000000..bc01f48e2c3e
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/recalc_apic_map_test/default.test
@@ -0,0 +1 @@
+x86/recalc_apic_map_test
diff --git a/tools/testing/selftests/kvm/tests/x86/set_boot_cpu_id/default.test b/tools/testing/selftests/kvm/tests/x86/set_boot_cpu_id/default.test
new file mode 100644
index 000000000000..79ff27988952
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/set_boot_cpu_id/default.test
@@ -0,0 +1 @@
+x86/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/tests/x86/set_sregs_test/default.test b/tools/testing/selftests/kvm/tests/x86/set_sregs_test/default.test
new file mode 100644
index 000000000000..fc02c20dda19
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/set_sregs_test/default.test
@@ -0,0 +1 @@
+x86/set_sregs_test
diff --git a/tools/testing/selftests/kvm/tests/x86/sev_init2_tests/default.test b/tools/testing/selftests/kvm/tests/x86/sev_init2_tests/default.test
new file mode 100644
index 000000000000..9d839dba35c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/sev_init2_tests/default.test
@@ -0,0 +1 @@
+x86/sev_init2_tests
diff --git a/tools/testing/selftests/kvm/tests/x86/sev_migrate_tests/default.test b/tools/testing/selftests/kvm/tests/x86/sev_migrate_tests/default.test
new file mode 100644
index 000000000000..f0579e499629
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/sev_migrate_tests/default.test
@@ -0,0 +1 @@
+x86/sev_migrate_tests
diff --git a/tools/testing/selftests/kvm/tests/x86/sev_smoke_test/default.test b/tools/testing/selftests/kvm/tests/x86/sev_smoke_test/default.test
new file mode 100644
index 000000000000..2550f6eff2d6
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/sev_smoke_test/default.test
@@ -0,0 +1 @@
+x86/sev_smoke_test
diff --git a/tools/testing/selftests/kvm/tests/x86/smaller_maxphyaddr_emulation_test/default.test b/tools/testing/selftests/kvm/tests/x86/smaller_maxphyaddr_emulation_test/default.test
new file mode 100644
index 000000000000..1382d34b4863
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/smaller_maxphyaddr_emulation_test/default.test
@@ -0,0 +1 @@
+x86/smaller_maxphyaddr_emulation_test
diff --git a/tools/testing/selftests/kvm/tests/x86/smm_test/default.test b/tools/testing/selftests/kvm/tests/x86/smm_test/default.test
new file mode 100644
index 000000000000..4437978a3e77
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/smm_test/default.test
@@ -0,0 +1 @@
+x86/smm_test
diff --git a/tools/testing/selftests/kvm/tests/x86/state_test/default.test b/tools/testing/selftests/kvm/tests/x86/state_test/default.test
new file mode 100644
index 000000000000..9f222c727d7f
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/state_test/default.test
@@ -0,0 +1 @@
+x86/state_test
diff --git a/tools/testing/selftests/kvm/tests/x86/svm_int_ctl_test/default.test b/tools/testing/selftests/kvm/tests/x86/svm_int_ctl_test/default.test
new file mode 100644
index 000000000000..51fe44a36633
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/svm_int_ctl_test/default.test
@@ -0,0 +1 @@
+x86/svm_int_ctl_test
diff --git a/tools/testing/selftests/kvm/tests/x86/svm_nested_shutdown_test/default.test b/tools/testing/selftests/kvm/tests/x86/svm_nested_shutdown_test/default.test
new file mode 100644
index 000000000000..642895b3cb5b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/svm_nested_shutdown_test/default.test
@@ -0,0 +1 @@
+x86/svm_nested_shutdown_test
diff --git a/tools/testing/selftests/kvm/tests/x86/svm_nested_soft_inject_test/default.test b/tools/testing/selftests/kvm/tests/x86/svm_nested_soft_inject_test/default.test
new file mode 100644
index 000000000000..6947cbcb1da5
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/svm_nested_soft_inject_test/default.test
@@ -0,0 +1 @@
+x86/svm_nested_soft_inject_test
diff --git a/tools/testing/selftests/kvm/tests/x86/svm_vmcall_test/default.test b/tools/testing/selftests/kvm/tests/x86/svm_vmcall_test/default.test
new file mode 100644
index 000000000000..68f22e39b1d6
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/svm_vmcall_test/default.test
@@ -0,0 +1 @@
+x86/svm_vmcall_test
diff --git a/tools/testing/selftests/kvm/tests/x86/sync_regs_test/default.test b/tools/testing/selftests/kvm/tests/x86/sync_regs_test/default.test
new file mode 100644
index 000000000000..1c88e7df625a
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/sync_regs_test/default.test
@@ -0,0 +1 @@
+x86/sync_regs_test
diff --git a/tools/testing/selftests/kvm/tests/x86/triple_fault_event_test/default.test b/tools/testing/selftests/kvm/tests/x86/triple_fault_event_test/default.test
new file mode 100644
index 000000000000..868d1d396abd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/triple_fault_event_test/default.test
@@ -0,0 +1 @@
+x86/triple_fault_event_test
diff --git a/tools/testing/selftests/kvm/tests/x86/tsc_msrs_test/default.test b/tools/testing/selftests/kvm/tests/x86/tsc_msrs_test/default.test
new file mode 100644
index 000000000000..b9e8ce298fe8
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/tsc_msrs_test/default.test
@@ -0,0 +1 @@
+x86/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/tests/x86/tsc_scaling_sync/default.test b/tools/testing/selftests/kvm/tests/x86/tsc_scaling_sync/default.test
new file mode 100644
index 000000000000..92dbcfdab5d0
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/tsc_scaling_sync/default.test
@@ -0,0 +1 @@
+x86/tsc_scaling_sync
diff --git a/tools/testing/selftests/kvm/tests/x86/ucna_injection_test/default.test b/tools/testing/selftests/kvm/tests/x86/ucna_injection_test/default.test
new file mode 100644
index 000000000000..135561c81334
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/ucna_injection_test/default.test
@@ -0,0 +1 @@
+x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/tests/x86/userspace_io_test/default.test b/tools/testing/selftests/kvm/tests/x86/userspace_io_test/default.test
new file mode 100644
index 000000000000..9584eb38ca61
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/userspace_io_test/default.test
@@ -0,0 +1 @@
+x86/userspace_io_test
diff --git a/tools/testing/selftests/kvm/tests/x86/userspace_msr_exit_test/default.test b/tools/testing/selftests/kvm/tests/x86/userspace_msr_exit_test/default.test
new file mode 100644
index 000000000000..a2bbdd1a2469
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/userspace_msr_exit_test/default.test
@@ -0,0 +1 @@
+x86/userspace_msr_exit_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_apic_access_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_apic_access_test/default.test
new file mode 100644
index 000000000000..561e8b72a074
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_apic_access_test/default.test
@@ -0,0 +1 @@
+x86/vmx_apic_access_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_close_while_nested_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_close_while_nested_test/default.test
new file mode 100644
index 000000000000..fca3eaff03d4
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_close_while_nested_test/default.test
@@ -0,0 +1 @@
+x86/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_dirty_log_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_dirty_log_test/default.test
new file mode 100644
index 000000000000..0332d8fbfec4
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_dirty_log_test/default.test
@@ -0,0 +1 @@
+x86/vmx_dirty_log_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_exception_with_invalid_guest_state/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_exception_with_invalid_guest_state/default.test
new file mode 100644
index 000000000000..8d89b505f680
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_exception_with_invalid_guest_state/default.test
@@ -0,0 +1 @@
+x86/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_invalid_nested_guest_state/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_invalid_nested_guest_state/default.test
new file mode 100644
index 000000000000..df2df912448b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_invalid_nested_guest_state/default.test
@@ -0,0 +1 @@
+x86/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_msrs_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_msrs_test/default.test
new file mode 100644
index 000000000000..677b1bdda6af
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_msrs_test/default.test
@@ -0,0 +1 @@
+x86/vmx_msrs_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_nested_tsc_scaling_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_nested_tsc_scaling_test/default.test
new file mode 100644
index 000000000000..c8400ea69265
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_nested_tsc_scaling_test/default.test
@@ -0,0 +1 @@
+x86/vmx_nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_pmu_caps_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_pmu_caps_test/default.test
new file mode 100644
index 000000000000..a641daa14081
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_pmu_caps_test/default.test
@@ -0,0 +1 @@
+x86/vmx_pmu_caps_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_preemption_timer_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_preemption_timer_test/default.test
new file mode 100644
index 000000000000..aba7235296f4
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_preemption_timer_test/default.test
@@ -0,0 +1 @@
+x86/vmx_preemption_timer_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_set_nested_state_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_set_nested_state_test/default.test
new file mode 100644
index 000000000000..4ee968527e4a
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_set_nested_state_test/default.test
@@ -0,0 +1 @@
+x86/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/tests/x86/vmx_tsc_adjust_test/default.test b/tools/testing/selftests/kvm/tests/x86/vmx_tsc_adjust_test/default.test
new file mode 100644
index 000000000000..10c93b9145e7
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/vmx_tsc_adjust_test/default.test
@@ -0,0 +1 @@
+x86/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xapic_ipi_test/default.test b/tools/testing/selftests/kvm/tests/x86/xapic_ipi_test/default.test
new file mode 100644
index 000000000000..e1b4250bc93b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xapic_ipi_test/default.test
@@ -0,0 +1 @@
+x86/xapic_ipi_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xapic_state_test/default.test b/tools/testing/selftests/kvm/tests/x86/xapic_state_test/default.test
new file mode 100644
index 000000000000..e700e34638b1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xapic_state_test/default.test
@@ -0,0 +1 @@
+x86/xapic_state_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xcr0_cpuid_test/default.test b/tools/testing/selftests/kvm/tests/x86/xcr0_cpuid_test/default.test
new file mode 100644
index 000000000000..fd8909f37682
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xcr0_cpuid_test/default.test
@@ -0,0 +1 @@
+x86/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xen_shinfo_test/default.test b/tools/testing/selftests/kvm/tests/x86/xen_shinfo_test/default.test
new file mode 100644
index 000000000000..b948bbaed045
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xen_shinfo_test/default.test
@@ -0,0 +1 @@
+x86/xen_shinfo_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xen_vmcall_test/default.test b/tools/testing/selftests/kvm/tests/x86/xen_vmcall_test/default.test
new file mode 100644
index 000000000000..63b943d0544c
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xen_vmcall_test/default.test
@@ -0,0 +1 @@
+x86/xen_vmcall_test
diff --git a/tools/testing/selftests/kvm/tests/x86/xss_msr_test/default.test b/tools/testing/selftests/kvm/tests/x86/xss_msr_test/default.test
new file mode 100644
index 000000000000..f8322c6d0117
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/x86/xss_msr_test/default.test
@@ -0,0 +1 @@
+x86/xss_msr_test
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


