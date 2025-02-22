Return-Path: <kvm+bounces-38924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F20F2A40479
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF148422502
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353441386B4;
	Sat, 22 Feb 2025 00:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vAUupspu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05A78F32
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 00:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185994; cv=none; b=E9Z9DpUC6qQ+cAbRq4hfWssPFKSxxMsvWKRYmiCx4xhlj0LfS/GKsTEAS9NcgX2QEjBwnk93BrA7vwtq78eox2wmfB0nVmxSqjemhKEuBtQ4fiaQG9sMb69MszC2LYmXCcNWRzllMZMx+/YbumuddYLyo6CETcjqE3dSvGjLL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185994; c=relaxed/simple;
	bh=FvqStzAiaVwU2F7DNsUjBqjlZnMdxJC/snePuO2CLyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQq+FoO3Ixb6Cow3zDQyFmwvpbxZ9gCNspVxYhsQNWcza0/UKfstOX6fduB6hPuou/milshuL4JKwBiEmMfdTYWyXLoIBkc5a4PrS0ubaXokqFGlbeevwzDzJD1q6K76NhZBwck4+FJ5xIAu8mlE63MESFtYZUEdHTM0cYGi2JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vAUupspu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc46431885so8751655a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740185990; x=1740790790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rwc5UgLSNB0rCKaTqIsv//Y8qy92qRjDNyJOu6eJkJo=;
        b=vAUupspuhYxTW00lkpC3MABkglodlBtin+v5VW9iwuB1GYMqA9qHaKMlEjUMV+Qh4v
         IsyTypjwa/81gyrSayWN26UAscsxdRjmeDb5hES4rAkBOo8duRPzjQCASKN7thylAhRo
         Ep76ed/bWoldUanu2wFx0L0NWKuGXMiw/LKQLyEixyBHVJy1hW6f2zQqzWJVOTWv/LMJ
         73Xg5gNlbk+/Hr2DAwEmmzf2qBPfc7+xmP+8oNhvhC0i4tx5RPdginm1ZJ72CVDFNoMy
         RN0liDawbp7zIY8O8+HkLDaUcoU3kQlDS7T9cFetpD9GCumxVpYcs5xZJ3iBfnZWsouf
         Y5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740185990; x=1740790790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rwc5UgLSNB0rCKaTqIsv//Y8qy92qRjDNyJOu6eJkJo=;
        b=wQmPpCAqiXa9Ij24ZUcKbMied73orsSlx0pS/BCLdc/C60I4E3qHy8wx8MS7zjqARx
         q7c7F7qmTZMvc5MIt1fnXpYKPVUIJ0xJqrE0TEPTVNyuIuvwh8GqW85XRNL976PuAxlY
         uXrxeAdf4nAOuwBdCjZMCrK4+SUgmKLzxtNFtyMhpl1nL3tEy+PHbXi5dO7dGVOfXz0F
         ODhuV6z8GZShZf0/e3FzKpoej92EKtKqgLScbabg70Z2D/+DZTOtT6m0NOuQIGiU3gWr
         dFYA1O5DVbEJstQZvHOU19te8msDDXUF/yzUVjepNP/Ffo0NIj/GmQmeoONzJY3YOpi0
         whAA==
X-Gm-Message-State: AOJu0Ywn52h8sLeKkqtvoVSlmE8yiq8aGbZQAyEnSb8jdlanDyTsQ0Re
	kHQtTd2IyAwx6dzgTQf1mZb/xq5K1/L4DIeZPhIeCG/4++CJ1Zz3GzCIjMSaiVfXYQcLvs7zmtR
	OXSoBRouAPDZSglbHq+lsn/m8vxBgbolm4IeJJRw73vvVnuR1cZGp81Tech94+laWDvWAtMhE5S
	ev6KspYh/BtuEZpegWpirwJUBn4Pm/4+o8CA==
X-Google-Smtp-Source: AGHT+IGNw3vBtvKGAnXqQcACuCpStqcQs8o6tpm+/7wavPlua4cZR0oxD3jZeJsnU1fVIuj0SFAwv9f8LXZK
X-Received: from pjg16.prod.google.com ([2002:a17:90b:3f50:b0:2e0:915d:d594])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c84:b0:2fc:c262:ef4b
 with SMTP id 98e67ed59e1d1-2fce86cf0e0mr9177588a91.18.1740185989582; Fri, 21
 Feb 2025 16:59:49 -0800 (PST)
Date: Fri, 21 Feb 2025 16:59:29 -0800
In-Reply-To: <20250222005943.3348627-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250222005943.3348627-2-vipinsh@google.com>
Subject: [PATCH 1/2] KVM: selftests: Add default testfiles for KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create a root "testcases" folder in KVM selftests directory. Add test
files for all of the KVM selftests across all of the supported
platforms.  Write only default test execution command in the test files.
Commands written in the test files will be ran by KVM selftest runner.

Test files are organized based following rules:
1. All test files resides in "testcases" directory.
2. Test files should have .test extension. This is needed so that
   git doesn't ignore the test file changes.
3. Each KVM selftest resides in a folder in "testcases" directory.
   It follows the path of KVM selftests directory. For example,
   kvm/x86_64/vmx_msrs_test.c will be in
   kvm/testcases/x86_64/vmx_msrs_tests directory.
4. default.test name is reserved for the default command to execute the
   test.
5. Different configuration of the tests should reside in their own test
   files under the same test directory. For example dirty_log_perf_test
   can have:
   - testcases/dirty_log_perf_test/default.test
   - testcases/dirty_log_perf_test/hugetlb1g.test
   - testcases/dirty_log_perf_test/disable_dirty_log_manual.test
6. If there is an arch specific option of a common test then it should
   be specified under an arch name directory in the test directory. This
   will avoid test runner to execute the common test or its option on
   unsupported machine. For example:
   testcases/memslot_modification_stress_test/x86_64/disable_slot_zap_quirk.test

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore                         | 3 ++-
 .../kvm/testcases/aarch64/aarch32_id_regs/default.test         | 1 +
 .../selftests/kvm/testcases/aarch64/arch_timer/default.test    | 1 +
 .../kvm/testcases/aarch64/arch_timer_edge_cases/default.test   | 1 +
 .../kvm/testcases/aarch64/debug-exceptions/default.test        | 1 +
 .../selftests/kvm/testcases/aarch64/get-reg-list/default.test  | 1 +
 .../selftests/kvm/testcases/aarch64/hypercalls/default.test    | 1 +
 .../selftests/kvm/testcases/aarch64/no-vgic-v3/default.test    | 1 +
 .../kvm/testcases/aarch64/page_fault_test/default.test         | 1 +
 .../selftests/kvm/testcases/aarch64/psci_test/default.test     | 1 +
 .../selftests/kvm/testcases/aarch64/set_id_regs/default.test   | 1 +
 .../selftests/kvm/testcases/aarch64/smccc_filter/default.test  | 1 +
 .../kvm/testcases/aarch64/vcpu_width_config/default.test       | 1 +
 .../selftests/kvm/testcases/aarch64/vgic_init/default.test     | 1 +
 .../selftests/kvm/testcases/aarch64/vgic_irq/default.test      | 1 +
 .../kvm/testcases/aarch64/vgic_lpi_stress/default.test         | 1 +
 .../kvm/testcases/aarch64/vpmu_counter_access/default.test     | 1 +
 .../kvm/testcases/access_tracking_perf_test/default.test       | 1 +
 .../selftests/kvm/testcases/coalesced_io_test/default.test     | 1 +
 .../selftests/kvm/testcases/demand_paging_test/default.test    | 1 +
 .../selftests/kvm/testcases/dirty_log_perf_test/default.test   | 1 +
 .../selftests/kvm/testcases/dirty_log_test/default.test        | 1 +
 .../selftests/kvm/testcases/guest_memfd_test/default.test      | 1 +
 .../selftests/kvm/testcases/guest_print_test/default.test      | 1 +
 .../selftests/kvm/testcases/hardware_disable_test/default.test | 1 +
 .../selftests/kvm/testcases/kvm_binary_stats_test/default.test | 1 +
 .../selftests/kvm/testcases/kvm_create_max_vcpus/default.test  | 1 +
 .../selftests/kvm/testcases/kvm_page_table_test/default.test   | 1 +
 .../selftests/kvm/testcases/max_guest_memory_test/default.test | 1 +
 .../testcases/memslot_modification_stress_test/default.test    | 1 +
 .../selftests/kvm/testcases/memslot_perf_test/default.test     | 1 +
 .../selftests/kvm/testcases/pre_fault_memory_test/default.test | 1 +
 .../selftests/kvm/testcases/riscv/arch_timer/default.test      | 1 +
 .../selftests/kvm/testcases/riscv/ebreak_test/default.test     | 1 +
 .../selftests/kvm/testcases/riscv/get-reg-list/default.test    | 1 +
 .../selftests/kvm/testcases/riscv/sbi_pmu_test/default.test    | 1 +
 tools/testing/selftests/kvm/testcases/rseq_test/default.test   | 1 +
 .../selftests/kvm/testcases/s390x/cmma_test/default.test       | 1 +
 .../selftests/kvm/testcases/s390x/debug_test/default.test      | 1 +
 tools/testing/selftests/kvm/testcases/s390x/memop/default.test | 1 +
 .../testing/selftests/kvm/testcases/s390x/resets/default.test  | 1 +
 .../kvm/testcases/s390x/shared_zeropage_test/default.test      | 1 +
 .../selftests/kvm/testcases/s390x/sync_regs_test/default.test  | 1 +
 tools/testing/selftests/kvm/testcases/s390x/tprot/default.test | 1 +
 .../selftests/kvm/testcases/s390x/ucontrol_test/default.test   | 1 +
 .../kvm/testcases/set_memory_region_test/default.test          | 1 +
 tools/testing/selftests/kvm/testcases/steal_time/default.test  | 1 +
 .../kvm/testcases/system_counter_offset_test/default.test      | 1 +
 .../selftests/kvm/testcases/x86_64/amx_test/default.test       | 1 +
 .../kvm/testcases/x86_64/apic_bus_clock_test/default.test      | 1 +
 .../selftests/kvm/testcases/x86_64/cpuid_test/default.test     | 1 +
 .../kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test      | 1 +
 .../selftests/kvm/testcases/x86_64/debug_regs/default.test     | 1 +
 .../x86_64/dirty_log_page_splitting_test/default.test          | 1 +
 .../x86_64/exit_on_emulation_failure_test/default.test         | 1 +
 .../kvm/testcases/x86_64/feature_msrs_test/default.test        | 1 +
 .../kvm/testcases/x86_64/fix_hypercall_test/default.test       | 1 +
 .../selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test  | 1 +
 .../selftests/kvm/testcases/x86_64/hyperv_clock/default.test   | 1 +
 .../selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test   | 1 +
 .../selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test   | 1 +
 .../testcases/x86_64/hyperv_extended_hypercalls/default.test   | 1 +
 .../kvm/testcases/x86_64/hyperv_features/default.test          | 1 +
 .../selftests/kvm/testcases/x86_64/hyperv_ipi/default.test     | 1 +
 .../kvm/testcases/x86_64/hyperv_svm_test/default.test          | 1 +
 .../kvm/testcases/x86_64/hyperv_tlb_flush/default.test         | 1 +
 .../selftests/kvm/testcases/x86_64/kvm_clock_test/default.test | 1 +
 .../selftests/kvm/testcases/x86_64/kvm_pv_test/default.test    | 1 +
 .../kvm/testcases/x86_64/max_vcpuid_cap_test/default.test      | 1 +
 .../kvm/testcases/x86_64/monitor_mwait_test/default.test       | 1 +
 .../kvm/testcases/x86_64/nested_exceptions_test/default.test   | 1 +
 .../kvm/testcases/x86_64/nx_huge_pages_test/default.test       | 1 +
 .../kvm/testcases/x86_64/platform_info_test/default.test       | 1 +
 .../kvm/testcases/x86_64/pmu_counters_test/default.test        | 1 +
 .../kvm/testcases/x86_64/pmu_event_filter_test/default.test    | 1 +
 .../testcases/x86_64/private_mem_conversions_test/default.test | 1 +
 .../testcases/x86_64/private_mem_kvm_exits_test/default.test   | 1 +
 .../kvm/testcases/x86_64/recalc_apic_map_test/default.test     | 1 +
 .../kvm/testcases/x86_64/set_boot_cpu_id/default.test          | 1 +
 .../selftests/kvm/testcases/x86_64/set_sregs_test/default.test | 1 +
 .../kvm/testcases/x86_64/sev_init2_tests/default.test          | 1 +
 .../kvm/testcases/x86_64/sev_migrate_tests/default.test        | 1 +
 .../selftests/kvm/testcases/x86_64/sev_smoke_test/default.test | 1 +
 .../x86_64/smaller_maxphyaddr_emulation_test/default.test      | 1 +
 .../selftests/kvm/testcases/x86_64/smm_test/default.test       | 1 +
 .../selftests/kvm/testcases/x86_64/state_test/default.test     | 1 +
 .../kvm/testcases/x86_64/svm_int_ctl_test/default.test         | 1 +
 .../kvm/testcases/x86_64/svm_nested_shutdown_test/default.test | 1 +
 .../testcases/x86_64/svm_nested_soft_inject_test/default.test  | 1 +
 .../kvm/testcases/x86_64/svm_vmcall_test/default.test          | 1 +
 .../selftests/kvm/testcases/x86_64/sync_regs_test/default.test | 1 +
 .../kvm/testcases/x86_64/triple_fault_event_test/default.test  | 1 +
 .../selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test  | 1 +
 .../kvm/testcases/x86_64/tsc_scaling_sync/default.test         | 1 +
 .../kvm/testcases/x86_64/ucna_injection_test/default.test      | 1 +
 .../kvm/testcases/x86_64/userspace_io_test/default.test        | 1 +
 .../kvm/testcases/x86_64/userspace_msr_exit_test/default.test  | 1 +
 .../kvm/testcases/x86_64/vmx_apic_access_test/default.test     | 1 +
 .../testcases/x86_64/vmx_close_while_nested_test/default.test  | 1 +
 .../kvm/testcases/x86_64/vmx_dirty_log_test/default.test       | 1 +
 .../x86_64/vmx_exception_with_invalid_guest_state/default.test | 1 +
 .../x86_64/vmx_invalid_nested_guest_state/default.test         | 1 +
 .../selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test  | 1 +
 .../testcases/x86_64/vmx_nested_tsc_scaling_test/default.test  | 1 +
 .../kvm/testcases/x86_64/vmx_pmu_caps_test/default.test        | 1 +
 .../testcases/x86_64/vmx_preemption_timer_test/default.test    | 1 +
 .../testcases/x86_64/vmx_set_nested_state_test/default.test    | 1 +
 .../kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test      | 1 +
 .../selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test | 1 +
 .../kvm/testcases/x86_64/xapic_state_test/default.test         | 1 +
 .../kvm/testcases/x86_64/xcr0_cpuid_test/default.test          | 1 +
 .../kvm/testcases/x86_64/xen_shinfo_test/default.test          | 1 +
 .../kvm/testcases/x86_64/xen_vmcall_test/default.test          | 1 +
 .../selftests/kvm/testcases/x86_64/xss_msr_test/default.test   | 1 +
 114 files changed, 115 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/arch_timer_edge_cases/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/debug-exceptions/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/get-reg-list/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/no-vgic-v3/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/page_fault_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/psci_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/set_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/smccc_filter/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vcpu_width_config/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_init/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_irq/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_lpi_stress/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vpmu_counter_access/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/access_tracking_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/coalesced_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/demand_paging_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/dirty_log_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/guest_memfd_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/guest_print_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/hardware_disable_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_binary_stats_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_create_max_vcpus/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_page_table_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/max_guest_memory_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/memslot_modification_stress_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/memslot_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/pre_fault_memory_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/ebreak_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/get-reg-list/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/sbi_pmu_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/rseq_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/cmma_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/debug_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/memop/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/resets/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/shared_zeropage_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/tprot/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/ucontrol_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/set_memory_region_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/steal_time/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/system_counter_offset_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/amx_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/apic_bus_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/debug_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/dirty_log_page_splitting_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/exit_on_emulation_failure_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/feature_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/fix_hypercall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_clock/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_extended_hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_features/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_ipi/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_svm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_tlb_flush/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/kvm_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/kvm_pv_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/max_vcpuid_cap_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/monitor_mwait_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/nested_exceptions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/nx_huge_pages_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/platform_info_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/pmu_counters_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/pmu_event_filter_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/private_mem_conversions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/private_mem_kvm_exits_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/recalc_apic_map_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/set_boot_cpu_id/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/set_sregs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_init2_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_migrate_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_smoke_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/smaller_maxphyaddr_emulation_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/smm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_int_ctl_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_nested_shutdown_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_nested_soft_inject_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/triple_fault_event_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/tsc_scaling_sync/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/ucna_injection_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/userspace_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/userspace_msr_exit_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_apic_access_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_close_while_nested_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_exception_with_invalid_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_invalid_nested_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_nested_tsc_scaling_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_pmu_caps_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_preemption_timer_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_set_nested_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xapic_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xcr0_cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xen_shinfo_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xen_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xss_msr_test/default.test

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1d41a046a7bf..550b7c2b4a0c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -9,4 +9,5 @@
 !config
 !settings
 !Makefile
-!Makefile.kvm
\ No newline at end of file
+!Makefile.kvm
+!*.test
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
new file mode 100644
index 000000000000..5db8723f554f
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
@@ -0,0 +1 @@
+./aarch64/aarch32_id_regs
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/arch_timer/default.test b/tools/testing/selftests/kvm/testcases/aarch64/arch_timer/default.test
new file mode 100644
index 000000000000..4eabd25b1c88
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/arch_timer/default.test
@@ -0,0 +1 @@
+./aarch64/arch_timer
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/arch_timer_edge_cases/default.test b/tools/testing/selftests/kvm/testcases/aarch64/arch_timer_edge_cases/default.test
new file mode 100644
index 000000000000..c2c17884d6ff
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/arch_timer_edge_cases/default.test
@@ -0,0 +1 @@
+./aarch64/arch_timer_edge_cases
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/debug-exceptions/default.test b/tools/testing/selftests/kvm/testcases/aarch64/debug-exceptions/default.test
new file mode 100644
index 000000000000..3dd50672ea2a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/debug-exceptions/default.test
@@ -0,0 +1 @@
+./aarch64/debug-exceptions
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/get-reg-list/default.test b/tools/testing/selftests/kvm/testcases/aarch64/get-reg-list/default.test
new file mode 100644
index 000000000000..a7656ab23faa
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/get-reg-list/default.test
@@ -0,0 +1 @@
+./aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/hypercalls/default.test b/tools/testing/selftests/kvm/testcases/aarch64/hypercalls/default.test
new file mode 100644
index 000000000000..c206440ad0e4
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/hypercalls/default.test
@@ -0,0 +1 @@
+./aarch64/hypercalls
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/no-vgic-v3/default.test b/tools/testing/selftests/kvm/testcases/aarch64/no-vgic-v3/default.test
new file mode 100644
index 000000000000..2dc6002ec63b
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/no-vgic-v3/default.test
@@ -0,0 +1 @@
+./aarch64/no-vgic-v3
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/page_fault_test/default.test b/tools/testing/selftests/kvm/testcases/aarch64/page_fault_test/default.test
new file mode 100644
index 000000000000..90d59bf94b53
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/page_fault_test/default.test
@@ -0,0 +1 @@
+./aarch64/page_fault_test
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/psci_test/default.test b/tools/testing/selftests/kvm/testcases/aarch64/psci_test/default.test
new file mode 100644
index 000000000000..55342f569e9e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/psci_test/default.test
@@ -0,0 +1 @@
+./aarch64/psci_test
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/set_id_regs/default.test b/tools/testing/selftests/kvm/testcases/aarch64/set_id_regs/default.test
new file mode 100644
index 000000000000..ffabfceae569
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/set_id_regs/default.test
@@ -0,0 +1 @@
+./aarch64/set_id_regs
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/smccc_filter/default.test b/tools/testing/selftests/kvm/testcases/aarch64/smccc_filter/default.test
new file mode 100644
index 000000000000..e4ae3145f15e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/smccc_filter/default.test
@@ -0,0 +1 @@
+./aarch64/smccc_filter
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/vcpu_width_config/default.test b/tools/testing/selftests/kvm/testcases/aarch64/vcpu_width_config/default.test
new file mode 100644
index 000000000000..489c20dc6cf0
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/vcpu_width_config/default.test
@@ -0,0 +1 @@
+./aarch64/vcpu_width_config
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/vgic_init/default.test b/tools/testing/selftests/kvm/testcases/aarch64/vgic_init/default.test
new file mode 100644
index 000000000000..b8e1a8a7cfb6
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/vgic_init/default.test
@@ -0,0 +1 @@
+./aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/vgic_irq/default.test b/tools/testing/selftests/kvm/testcases/aarch64/vgic_irq/default.test
new file mode 100644
index 000000000000..308c12aa5f13
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/vgic_irq/default.test
@@ -0,0 +1 @@
+./aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/vgic_lpi_stress/default.test b/tools/testing/selftests/kvm/testcases/aarch64/vgic_lpi_stress/default.test
new file mode 100644
index 000000000000..b33c45fb8998
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/vgic_lpi_stress/default.test
@@ -0,0 +1 @@
+./aarch64/vgic_lpi_stress
diff --git a/tools/testing/selftests/kvm/testcases/aarch64/vpmu_counter_access/default.test b/tools/testing/selftests/kvm/testcases/aarch64/vpmu_counter_access/default.test
new file mode 100644
index 000000000000..cd3ef4c21274
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/aarch64/vpmu_counter_access/default.test
@@ -0,0 +1 @@
+./aarch64/vpmu_counter_access
diff --git a/tools/testing/selftests/kvm/testcases/access_tracking_perf_test/default.test b/tools/testing/selftests/kvm/testcases/access_tracking_perf_test/default.test
new file mode 100644
index 000000000000..e940543be193
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/access_tracking_perf_test/default.test
@@ -0,0 +1 @@
+./access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/testcases/coalesced_io_test/default.test b/tools/testing/selftests/kvm/testcases/coalesced_io_test/default.test
new file mode 100644
index 000000000000..08dfcbb4fcd0
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/coalesced_io_test/default.test
@@ -0,0 +1 @@
+./coalesced_io_test
diff --git a/tools/testing/selftests/kvm/testcases/demand_paging_test/default.test b/tools/testing/selftests/kvm/testcases/demand_paging_test/default.test
new file mode 100644
index 000000000000..26043696d095
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/demand_paging_test/default.test
@@ -0,0 +1 @@
+./demand_paging_test
diff --git a/tools/testing/selftests/kvm/testcases/dirty_log_perf_test/default.test b/tools/testing/selftests/kvm/testcases/dirty_log_perf_test/default.test
new file mode 100644
index 000000000000..8968bf6eb881
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/dirty_log_perf_test/default.test
@@ -0,0 +1 @@
+./dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/testcases/dirty_log_test/default.test b/tools/testing/selftests/kvm/testcases/dirty_log_test/default.test
new file mode 100644
index 000000000000..87bc10443ff9
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/dirty_log_test/default.test
@@ -0,0 +1 @@
+./dirty_log_test
diff --git a/tools/testing/selftests/kvm/testcases/guest_memfd_test/default.test b/tools/testing/selftests/kvm/testcases/guest_memfd_test/default.test
new file mode 100644
index 000000000000..4bba43fcca8d
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/guest_memfd_test/default.test
@@ -0,0 +1 @@
+./guest_memfd_test
diff --git a/tools/testing/selftests/kvm/testcases/guest_print_test/default.test b/tools/testing/selftests/kvm/testcases/guest_print_test/default.test
new file mode 100644
index 000000000000..2b7d376d6b09
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/guest_print_test/default.test
@@ -0,0 +1 @@
+./guest_print_test
diff --git a/tools/testing/selftests/kvm/testcases/hardware_disable_test/default.test b/tools/testing/selftests/kvm/testcases/hardware_disable_test/default.test
new file mode 100644
index 000000000000..e960b290d00a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/hardware_disable_test/default.test
@@ -0,0 +1 @@
+./hardware_disable_test
diff --git a/tools/testing/selftests/kvm/testcases/kvm_binary_stats_test/default.test b/tools/testing/selftests/kvm/testcases/kvm_binary_stats_test/default.test
new file mode 100644
index 000000000000..a8c0240251ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/kvm_binary_stats_test/default.test
@@ -0,0 +1 @@
+./kvm_binary_stats_test
diff --git a/tools/testing/selftests/kvm/testcases/kvm_create_max_vcpus/default.test b/tools/testing/selftests/kvm/testcases/kvm_create_max_vcpus/default.test
new file mode 100644
index 000000000000..a23226454cdc
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/kvm_create_max_vcpus/default.test
@@ -0,0 +1 @@
+./kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/testcases/kvm_page_table_test/default.test b/tools/testing/selftests/kvm/testcases/kvm_page_table_test/default.test
new file mode 100644
index 000000000000..0efb9a150562
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/kvm_page_table_test/default.test
@@ -0,0 +1 @@
+./kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/testcases/max_guest_memory_test/default.test b/tools/testing/selftests/kvm/testcases/max_guest_memory_test/default.test
new file mode 100644
index 000000000000..85c43b0a0f74
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/max_guest_memory_test/default.test
@@ -0,0 +1 @@
+./max_guest_memory_test
diff --git a/tools/testing/selftests/kvm/testcases/memslot_modification_stress_test/default.test b/tools/testing/selftests/kvm/testcases/memslot_modification_stress_test/default.test
new file mode 100644
index 000000000000..4a4bb75db039
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/memslot_modification_stress_test/default.test
@@ -0,0 +1 @@
+./memslot_modification_stress_test
diff --git a/tools/testing/selftests/kvm/testcases/memslot_perf_test/default.test b/tools/testing/selftests/kvm/testcases/memslot_perf_test/default.test
new file mode 100644
index 000000000000..70889328cea3
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/memslot_perf_test/default.test
@@ -0,0 +1 @@
+./memslot_perf_test
diff --git a/tools/testing/selftests/kvm/testcases/pre_fault_memory_test/default.test b/tools/testing/selftests/kvm/testcases/pre_fault_memory_test/default.test
new file mode 100644
index 000000000000..2b7c896d7c54
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/pre_fault_memory_test/default.test
@@ -0,0 +1 @@
+./pre_fault_memory_test
diff --git a/tools/testing/selftests/kvm/testcases/riscv/arch_timer/default.test b/tools/testing/selftests/kvm/testcases/riscv/arch_timer/default.test
new file mode 100644
index 000000000000..c16ee2797869
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/riscv/arch_timer/default.test
@@ -0,0 +1 @@
+./riscv/arch_timer
diff --git a/tools/testing/selftests/kvm/testcases/riscv/ebreak_test/default.test b/tools/testing/selftests/kvm/testcases/riscv/ebreak_test/default.test
new file mode 100644
index 000000000000..8415f42d391a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/riscv/ebreak_test/default.test
@@ -0,0 +1 @@
+./riscv/ebreak_test
diff --git a/tools/testing/selftests/kvm/testcases/riscv/get-reg-list/default.test b/tools/testing/selftests/kvm/testcases/riscv/get-reg-list/default.test
new file mode 100644
index 000000000000..0238b91deecd
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/riscv/get-reg-list/default.test
@@ -0,0 +1 @@
+./riscv/get-reg-list
diff --git a/tools/testing/selftests/kvm/testcases/riscv/sbi_pmu_test/default.test b/tools/testing/selftests/kvm/testcases/riscv/sbi_pmu_test/default.test
new file mode 100644
index 000000000000..efa41caabe3e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/riscv/sbi_pmu_test/default.test
@@ -0,0 +1 @@
+./riscv/sbi_pmu_test
diff --git a/tools/testing/selftests/kvm/testcases/rseq_test/default.test b/tools/testing/selftests/kvm/testcases/rseq_test/default.test
new file mode 100644
index 000000000000..6098cd71bd56
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/rseq_test/default.test
@@ -0,0 +1 @@
+./rseq_test
diff --git a/tools/testing/selftests/kvm/testcases/s390x/cmma_test/default.test b/tools/testing/selftests/kvm/testcases/s390x/cmma_test/default.test
new file mode 100644
index 000000000000..b36736b053dc
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/cmma_test/default.test
@@ -0,0 +1 @@
+./s390x/cmma_test
diff --git a/tools/testing/selftests/kvm/testcases/s390x/debug_test/default.test b/tools/testing/selftests/kvm/testcases/s390x/debug_test/default.test
new file mode 100644
index 000000000000..56eadb53ff96
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/debug_test/default.test
@@ -0,0 +1 @@
+./s390x/debug_test
diff --git a/tools/testing/selftests/kvm/testcases/s390x/memop/default.test b/tools/testing/selftests/kvm/testcases/s390x/memop/default.test
new file mode 100644
index 000000000000..b80932431521
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/memop/default.test
@@ -0,0 +1 @@
+./s390x/memop
diff --git a/tools/testing/selftests/kvm/testcases/s390x/resets/default.test b/tools/testing/selftests/kvm/testcases/s390x/resets/default.test
new file mode 100644
index 000000000000..7e116efaf6e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/resets/default.test
@@ -0,0 +1 @@
+./s390x/resets
diff --git a/tools/testing/selftests/kvm/testcases/s390x/shared_zeropage_test/default.test b/tools/testing/selftests/kvm/testcases/s390x/shared_zeropage_test/default.test
new file mode 100644
index 000000000000..d7ed954a5d87
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/shared_zeropage_test/default.test
@@ -0,0 +1 @@
+./s390x/shared_zeropage_test
diff --git a/tools/testing/selftests/kvm/testcases/s390x/sync_regs_test/default.test b/tools/testing/selftests/kvm/testcases/s390x/sync_regs_test/default.test
new file mode 100644
index 000000000000..fb5a97dc1a60
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/sync_regs_test/default.test
@@ -0,0 +1 @@
+./s390x/sync_regs_test
diff --git a/tools/testing/selftests/kvm/testcases/s390x/tprot/default.test b/tools/testing/selftests/kvm/testcases/s390x/tprot/default.test
new file mode 100644
index 000000000000..16476e6f7fe7
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/tprot/default.test
@@ -0,0 +1 @@
+./s390x/tprot
diff --git a/tools/testing/selftests/kvm/testcases/s390x/ucontrol_test/default.test b/tools/testing/selftests/kvm/testcases/s390x/ucontrol_test/default.test
new file mode 100644
index 000000000000..1a9a32db0d99
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/s390x/ucontrol_test/default.test
@@ -0,0 +1 @@
+./s390x/ucontrol_test
diff --git a/tools/testing/selftests/kvm/testcases/set_memory_region_test/default.test b/tools/testing/selftests/kvm/testcases/set_memory_region_test/default.test
new file mode 100644
index 000000000000..356c31e88471
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/set_memory_region_test/default.test
@@ -0,0 +1 @@
+./set_memory_region_test
diff --git a/tools/testing/selftests/kvm/testcases/steal_time/default.test b/tools/testing/selftests/kvm/testcases/steal_time/default.test
new file mode 100644
index 000000000000..10a490246d2d
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/steal_time/default.test
@@ -0,0 +1 @@
+./steal_time
diff --git a/tools/testing/selftests/kvm/testcases/system_counter_offset_test/default.test b/tools/testing/selftests/kvm/testcases/system_counter_offset_test/default.test
new file mode 100644
index 000000000000..a35557a85f79
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/system_counter_offset_test/default.test
@@ -0,0 +1 @@
+./system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/amx_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/amx_test/default.test
new file mode 100644
index 000000000000..9328a4997849
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/amx_test/default.test
@@ -0,0 +1 @@
+./x86_64/amx_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/apic_bus_clock_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/apic_bus_clock_test/default.test
new file mode 100644
index 000000000000..71dc5be7a4de
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/apic_bus_clock_test/default.test
@@ -0,0 +1 @@
+./x86_64/apic_bus_clock_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/cpuid_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/cpuid_test/default.test
new file mode 100644
index 000000000000..f9f518c76732
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/cpuid_test/default.test
@@ -0,0 +1 @@
+./x86_64/cpuid_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test
new file mode 100644
index 000000000000..a7ebd6d37523
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test
@@ -0,0 +1 @@
+./x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/debug_regs/default.test b/tools/testing/selftests/kvm/testcases/x86_64/debug_regs/default.test
new file mode 100644
index 000000000000..972e16d8ae80
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/debug_regs/default.test
@@ -0,0 +1 @@
+./x86_64/debug_regs
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/dirty_log_page_splitting_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/dirty_log_page_splitting_test/default.test
new file mode 100644
index 000000000000..5e5eedb125fb
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/dirty_log_page_splitting_test/default.test
@@ -0,0 +1 @@
+./x86_64/dirty_log_page_splitting_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/exit_on_emulation_failure_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/exit_on_emulation_failure_test/default.test
new file mode 100644
index 000000000000..5e8d932a985a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/exit_on_emulation_failure_test/default.test
@@ -0,0 +1 @@
+./x86_64/exit_on_emulation_failure_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/feature_msrs_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/feature_msrs_test/default.test
new file mode 100644
index 000000000000..a7f2bbf4bf56
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/feature_msrs_test/default.test
@@ -0,0 +1 @@
+./x86_64/feature_msrs_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/fix_hypercall_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/fix_hypercall_test/default.test
new file mode 100644
index 000000000000..e14c80fa8f45
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/fix_hypercall_test/default.test
@@ -0,0 +1 @@
+./x86_64/fix_hypercall_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test
new file mode 100644
index 000000000000..62edde1e311d
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test
@@ -0,0 +1 @@
+./x86_64/hwcr_msr_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_clock/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_clock/default.test
new file mode 100644
index 000000000000..f636d01c1c04
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_clock/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_clock
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test
new file mode 100644
index 000000000000..eafad0b1579e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test
new file mode 100644
index 000000000000..851add3c6e81
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_evmcs
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_extended_hypercalls/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_extended_hypercalls/default.test
new file mode 100644
index 000000000000..f66c5faa362b
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_extended_hypercalls/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_extended_hypercalls
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_features/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_features/default.test
new file mode 100644
index 000000000000..fbf677334f30
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_features/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_features
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_ipi/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_ipi/default.test
new file mode 100644
index 000000000000..5e080d57c89a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_ipi/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_ipi
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_svm_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_svm_test/default.test
new file mode 100644
index 000000000000..4d10b12513cb
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_svm_test/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_svm_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/hyperv_tlb_flush/default.test b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_tlb_flush/default.test
new file mode 100644
index 000000000000..0eb679f846e7
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/hyperv_tlb_flush/default.test
@@ -0,0 +1 @@
+./x86_64/hyperv_tlb_flush
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/kvm_clock_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/kvm_clock_test/default.test
new file mode 100644
index 000000000000..7d448d089a65
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/kvm_clock_test/default.test
@@ -0,0 +1 @@
+./x86_64/kvm_clock_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/kvm_pv_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/kvm_pv_test/default.test
new file mode 100644
index 000000000000..fb71a5fd8544
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/kvm_pv_test/default.test
@@ -0,0 +1 @@
+./x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/max_vcpuid_cap_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/max_vcpuid_cap_test/default.test
new file mode 100644
index 000000000000..cc83f9b0224a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/max_vcpuid_cap_test/default.test
@@ -0,0 +1 @@
+./x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/monitor_mwait_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/monitor_mwait_test/default.test
new file mode 100644
index 000000000000..b863c909f6c6
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/monitor_mwait_test/default.test
@@ -0,0 +1 @@
+./x86_64/monitor_mwait_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/nested_exceptions_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/nested_exceptions_test/default.test
new file mode 100644
index 000000000000..bc326f0a4607
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/nested_exceptions_test/default.test
@@ -0,0 +1 @@
+./x86_64/nested_exceptions_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/nx_huge_pages_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/nx_huge_pages_test/default.test
new file mode 100644
index 000000000000..7195b59fe8a5
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/nx_huge_pages_test/default.test
@@ -0,0 +1 @@
+./x86_64/nx_huge_pages_test.sh
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/platform_info_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/platform_info_test/default.test
new file mode 100644
index 000000000000..d8e9803516ae
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/platform_info_test/default.test
@@ -0,0 +1 @@
+./x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/pmu_counters_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/pmu_counters_test/default.test
new file mode 100644
index 000000000000..08f30fffe000
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/pmu_counters_test/default.test
@@ -0,0 +1 @@
+./x86_64/pmu_counters_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/pmu_event_filter_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/pmu_event_filter_test/default.test
new file mode 100644
index 000000000000..58f0afe0af50
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/pmu_event_filter_test/default.test
@@ -0,0 +1 @@
+./x86_64/pmu_event_filter_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/private_mem_conversions_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/private_mem_conversions_test/default.test
new file mode 100644
index 000000000000..8bb591b63967
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/private_mem_conversions_test/default.test
@@ -0,0 +1 @@
+./x86_64/private_mem_conversions_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/private_mem_kvm_exits_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/private_mem_kvm_exits_test/default.test
new file mode 100644
index 000000000000..9c624949de95
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/private_mem_kvm_exits_test/default.test
@@ -0,0 +1 @@
+./x86_64/private_mem_kvm_exits_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/recalc_apic_map_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/recalc_apic_map_test/default.test
new file mode 100644
index 000000000000..441e3bea8b71
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/recalc_apic_map_test/default.test
@@ -0,0 +1 @@
+./x86_64/recalc_apic_map_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/set_boot_cpu_id/default.test b/tools/testing/selftests/kvm/testcases/x86_64/set_boot_cpu_id/default.test
new file mode 100644
index 000000000000..80d5156f0623
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/set_boot_cpu_id/default.test
@@ -0,0 +1 @@
+./x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/set_sregs_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/set_sregs_test/default.test
new file mode 100644
index 000000000000..83531913d381
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/set_sregs_test/default.test
@@ -0,0 +1 @@
+./x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/sev_init2_tests/default.test b/tools/testing/selftests/kvm/testcases/x86_64/sev_init2_tests/default.test
new file mode 100644
index 000000000000..9c356b1d7717
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/sev_init2_tests/default.test
@@ -0,0 +1 @@
+./x86_64/sev_init2_tests
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/sev_migrate_tests/default.test b/tools/testing/selftests/kvm/testcases/x86_64/sev_migrate_tests/default.test
new file mode 100644
index 000000000000..f0e2742cf6b4
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/sev_migrate_tests/default.test
@@ -0,0 +1 @@
+./x86_64/sev_migrate_tests
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/sev_smoke_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/sev_smoke_test/default.test
new file mode 100644
index 000000000000..56733d3d47d5
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/sev_smoke_test/default.test
@@ -0,0 +1 @@
+./x86_64/sev_smoke_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/smaller_maxphyaddr_emulation_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/smaller_maxphyaddr_emulation_test/default.test
new file mode 100644
index 000000000000..52f6dcebe18e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/smaller_maxphyaddr_emulation_test/default.test
@@ -0,0 +1 @@
+./x86_64/smaller_maxphyaddr_emulation_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/smm_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/smm_test/default.test
new file mode 100644
index 000000000000..bd50d1fe0e39
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/smm_test/default.test
@@ -0,0 +1 @@
+./x86_64/smm_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/state_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/state_test/default.test
new file mode 100644
index 000000000000..e2f261ecb141
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/state_test/default.test
@@ -0,0 +1 @@
+./x86_64/state_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/svm_int_ctl_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/svm_int_ctl_test/default.test
new file mode 100644
index 000000000000..51c2b1a4d7ea
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/svm_int_ctl_test/default.test
@@ -0,0 +1 @@
+./x86_64/svm_int_ctl_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_shutdown_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_shutdown_test/default.test
new file mode 100644
index 000000000000..aa1320afb235
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_shutdown_test/default.test
@@ -0,0 +1 @@
+./x86_64/svm_nested_shutdown_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_soft_inject_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_soft_inject_test/default.test
new file mode 100644
index 000000000000..75ffe38b0246
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/svm_nested_soft_inject_test/default.test
@@ -0,0 +1 @@
+./x86_64/svm_nested_soft_inject_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/svm_vmcall_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/svm_vmcall_test/default.test
new file mode 100644
index 000000000000..415f8112e873
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/svm_vmcall_test/default.test
@@ -0,0 +1 @@
+./x86_64/svm_vmcall_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/sync_regs_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/sync_regs_test/default.test
new file mode 100644
index 000000000000..26f1e3c00208
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/sync_regs_test/default.test
@@ -0,0 +1 @@
+./x86_64/sync_regs_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/triple_fault_event_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/triple_fault_event_test/default.test
new file mode 100644
index 000000000000..86709ec1af57
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/triple_fault_event_test/default.test
@@ -0,0 +1 @@
+./x86_64/triple_fault_event_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test
new file mode 100644
index 000000000000..e7eca5c5425b
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test
@@ -0,0 +1 @@
+./x86_64/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/tsc_scaling_sync/default.test b/tools/testing/selftests/kvm/testcases/x86_64/tsc_scaling_sync/default.test
new file mode 100644
index 000000000000..75cec395980e
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/tsc_scaling_sync/default.test
@@ -0,0 +1 @@
+./x86_64/tsc_scaling_sync
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/ucna_injection_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/ucna_injection_test/default.test
new file mode 100644
index 000000000000..991ab4b35376
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/ucna_injection_test/default.test
@@ -0,0 +1 @@
+./x86_64/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/userspace_io_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/userspace_io_test/default.test
new file mode 100644
index 000000000000..3401aa68ec4f
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/userspace_io_test/default.test
@@ -0,0 +1 @@
+./x86_64/userspace_io_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/userspace_msr_exit_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/userspace_msr_exit_test/default.test
new file mode 100644
index 000000000000..25d34dbb542d
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/userspace_msr_exit_test/default.test
@@ -0,0 +1 @@
+./x86_64/userspace_msr_exit_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_apic_access_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_apic_access_test/default.test
new file mode 100644
index 000000000000..970ce4a87b69
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_apic_access_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_apic_access_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_close_while_nested_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_close_while_nested_test/default.test
new file mode 100644
index 000000000000..97b5c9bc2385
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_close_while_nested_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_dirty_log_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_dirty_log_test/default.test
new file mode 100644
index 000000000000..dbbc6771830d
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_dirty_log_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_dirty_log_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_exception_with_invalid_guest_state/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_exception_with_invalid_guest_state/default.test
new file mode 100644
index 000000000000..d9cb4e720d2b
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_exception_with_invalid_guest_state/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_invalid_nested_guest_state/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_invalid_nested_guest_state/default.test
new file mode 100644
index 000000000000..396253417646
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_invalid_nested_guest_state/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test
new file mode 100644
index 000000000000..5eb96a67bc3a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_msrs_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_nested_tsc_scaling_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_nested_tsc_scaling_test/default.test
new file mode 100644
index 000000000000..9ffd06d52cce
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_nested_tsc_scaling_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_pmu_caps_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_pmu_caps_test/default.test
new file mode 100644
index 000000000000..e7bbc34d0d98
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_pmu_caps_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_pmu_caps_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_preemption_timer_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_preemption_timer_test/default.test
new file mode 100644
index 000000000000..08432fd3071a
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_preemption_timer_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_preemption_timer_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_set_nested_state_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_set_nested_state_test/default.test
new file mode 100644
index 000000000000..58b2bc65f767
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_set_nested_state_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test
new file mode 100644
index 000000000000..3ec7560cab11
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test
@@ -0,0 +1 @@
+./x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test
new file mode 100644
index 000000000000..2cbd6b12f6e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test
@@ -0,0 +1 @@
+./x86_64/xapic_ipi_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xapic_state_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xapic_state_test/default.test
new file mode 100644
index 000000000000..649e0268d6fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xapic_state_test/default.test
@@ -0,0 +1 @@
+./x86_64/xapic_state_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xcr0_cpuid_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xcr0_cpuid_test/default.test
new file mode 100644
index 000000000000..d5ea6a4e2b20
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xcr0_cpuid_test/default.test
@@ -0,0 +1 @@
+./x86_64/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xen_shinfo_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xen_shinfo_test/default.test
new file mode 100644
index 000000000000..79423b5a11e1
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xen_shinfo_test/default.test
@@ -0,0 +1 @@
+./x86_64/xen_shinfo_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xen_vmcall_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xen_vmcall_test/default.test
new file mode 100644
index 000000000000..32ba7eb9d7e9
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xen_vmcall_test/default.test
@@ -0,0 +1 @@
+./x86_64/xen_vmcall_test
diff --git a/tools/testing/selftests/kvm/testcases/x86_64/xss_msr_test/default.test b/tools/testing/selftests/kvm/testcases/x86_64/xss_msr_test/default.test
new file mode 100644
index 000000000000..c61ac639825b
--- /dev/null
+++ b/tools/testing/selftests/kvm/testcases/x86_64/xss_msr_test/default.test
@@ -0,0 +1 @@
+./x86_64/xss_msr_test
-- 
2.48.1.601.g30ceb7b040-goog


