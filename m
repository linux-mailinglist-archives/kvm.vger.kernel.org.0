Return-Path: <kvm+bounces-48679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E68AD0A78
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 341143A11B1
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5659124113C;
	Fri,  6 Jun 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEkC2XZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868601F098F
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254194; cv=none; b=DQpApRrUAHKLgkfm36a5RcGCPkXFzVDn6es1sFK8GMyFPMyvAoOxO+jfXvlmt8mb1nqJ1qF0NYIvG5grBS8rOcB+85+4KF0GAIv+9H4T4WTkxVE23CemBQfKn2+rwSVFr5Le5YuC8gs9ZXMuhekGQypVOZTxZrDmO7XQG7Ij3XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254194; c=relaxed/simple;
	bh=N7S2+CLCYjOjY2CmYJNFgAFhWoAxyxNsFSGqCabg1pM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mlVwKkfjxjeV/cyjM4+wajp1rofxleOzJNmYR7LZ5mOkhOXsINpn7QkDqs+G/dRMqZn9jjNlZfcZbUZ0HSvp1/ZFgmtvJj7pHK2BYeY9IQk/D9XQFLoHdIDjf2KcrvnZVsE6PxipNqaZIbVaiGrE92SNK63GcZRf+BFBpTE6slE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qEkC2XZd; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso2752747b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254192; x=1749858992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XN0VAsCT1CWdgagP9CPqT2NYJ16ltbDcNqmn3oGzFBA=;
        b=qEkC2XZdsRXVIEHOoQfELrmu0lQNt8vHW1StrJGhefEhrcObRuqGVrFPeQ7CycQWzq
         xGHzVLTlAplZNywE54rJfLSMLdqK20TY2GSU5+X1WrXeUD0qhou1Ew3Bkco1pammLHtX
         vYihb5+z0IVDu12krijVOXdjyONZjiLVFW6aDD9sTyO1CTIuz1Iln4uia5wBlohbyRhn
         PtV4xaBIi5dPdBP2nQ09XU55LloDB21utlXlwdJD9SFTsEIwXA9BnDuIe9DgCLQVMdWe
         Ps7m8gA9q0dLsXHFE+H9JWqxzYP1IKAzn1OReADAV8rnVBDioWG/J+Jn3Jr7chd3d0IW
         ezuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254192; x=1749858992;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XN0VAsCT1CWdgagP9CPqT2NYJ16ltbDcNqmn3oGzFBA=;
        b=uwnIwMJXxBFliqG33LntGAEpy2rWAS55ywdQr2aTVkeTGbfG7ZS5DWxfVxPgCXuirC
         zwVmWL6CMrYbYfKtdodAk8VsJrwdI4lJeFHaUh/es5mvdBl9sORp8KXlpeW09jAUq3BF
         Z58uy4JH7LCNNxSur5maf5gCob0k/iYoUWTiP4VHJMdtalHygKXth2emMvpNYSETWIJP
         iu822/LTiVIopGSAYgnb5s6qOMAtk976kPOk+gZDstT3L7gb3Cx7Op5lPwqnd+3r5ngS
         aeWsniUNqvvdL4TR1yc5n5uNWDor3ajNGnCvtadTvoOxTHJgaxQZDOE/rA+MXqP1U7nx
         fdEg==
X-Gm-Message-State: AOJu0Yxjz8sybq+WEuRBJxHiPXaX6ngUmt8+aIMeD19uAL3nnb56XgfN
	x9FaMpswF2CkpIBEjr2TcKnKGVnF2LkqZw2HL5ZV/aorcAa2zAllmLXwuwiFssc/5eKXHGy3hzm
	ao8envLiWkS/CzgNVU5jm+xMHoZP26PS5/nlLUxWuNs1KGzkjd2euYplAKIzLVflnXa9z+8Lc3I
	UkC75Awk5mQJ2+i/JmweBU7jfdMr1lLHm2P8wnJQ==
X-Google-Smtp-Source: AGHT+IHeEVfH9wv5FWIJzUeYXcQ/zi0u5Uf0vhP1yOhYLsqyKUu35wm23VvWwVGse0eCH5m6iscBFYWFXqXu
X-Received: from pfgs41.prod.google.com ([2002:a05:6a00:17a9:b0:747:9faf:ed39])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6494:b0:215:d41d:9183
 with SMTP id adf61e73a8af0-21ee2559addmr6535389637.1.1749254191550; Fri, 06
 Jun 2025 16:56:31 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-1-vipinsh@google.com>
Subject: [PATCH v2 00/15] Add KVM Selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

Create KVM Selftest Runner which allows running KVM selftests with added
features not present in default selftest runner provided by selftests
framework.

This Runner has two broad goals:
1. Make it easier for contributors and maintainers to run various
   configuration of tests with features like preserving output,
   controlling output verbosity, parallelism, different combinations of
   command line arguments.
2. Provide common place to write interesting and useful combinations of
   tests command line arguments to improve KVM test coverage. Default
   selftests runner provide little to no control over this.

Patch 1 adds a very basic sefltest runner.
Patches 2-10 add various features to runner.
Patch 11 provides a way to auto generate test files.
Patch 12-15 commits the generated files for each architecture supported
by KVM selftests.

This version doesn't have all of the features envisioned in RFC and v1.
Future patches will add features like:

- Print process id of the test in execution.
- Skip other platform tests. Currently, runner expects test binary will
  not be available and it marks that test as it didn't run in the
  output. This can be handled by either hardcoding paths in runner or
  extending *.test schema. I will work on it in the next version.
- CTRL+C currently spits out lots of warning (depending on --job value).
  This will be fixed in the next version.
- Add more tests configurations.
- Provide a way to set the environment in which runner will start tests. For
  example, setting huge pages, stress testing based on resources
  available on host.


v2:
- Automatic default test generation.
- Command line flag to provide executables location
- Dump output to filesystem with timestamp
- Accept absolute path of *.test files/directory location
- Sticky status at bottom for the current state of runner.
- Knobs to control output verbosity
- Colored output for terminals.

v1: https://lore.kernel.org/kvm/20250222005943.3348627-1-vipinsh@google.com/
- Parallel test execution.
- Dumping separate output for each test.
- Timeout for test execution
- Specify single test or a test directory.

RFC: https://lore.kernel.org/kvm/20240821223012.3757828-1-vipinsh@google.com/

Vipin Sharma (15):
  KVM: selftest: Create KVM selftest runner
  KVM: selftests: Enable selftests runner to find executables in
    different path
  KVM: selftests: Add timeout option in selftests runner
  KVM: selftests: Add option to save selftest runner output to a
    directory
  KVM: selftests: Run tests concurrently in KVM selftests runner
  KVM: selftests: Add a flag to print only test status in KVM Selftests
    run
  KVM: selftests: Add various print flags to KVM Selftest Runner
  KVM: selftests: Print sticky KVM Selftests Runner status at bottom
  KVM: selftests: Add a flag to print only sticky summary in the
    selftests runner
  KVM: selftests: Add flag to suppress all output from Selftest KVM
    Runner
  KVM: selftests: Auto generate default tests for KVM Selftests Runner
  KVM: selftests: Add x86 auto generated test files for KVM Selftests
    Runner
  KVM: selftests: Add arm64 auto generated test files for KVM Selftests
    Runner
  KVM: selftests: Add s390 auto generated test files for KVM Selftests
    Runner
  KVM: selftests: Add riscv auto generated test files for KVM Selftests
    Runner

 tools/testing/selftests/kvm/.gitignore        |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   8 +
 .../testing/selftests/kvm/runner/__main__.py  | 271 ++++++++++++++++++
 tools/testing/selftests/kvm/runner/command.py |  53 ++++
 .../testing/selftests/kvm/runner/selftest.py  |  66 +++++
 .../selftests/kvm/runner/test_runner.py       |  88 ++++++
 .../access_tracking_perf_test/default.test    |   1 +
 .../kvm/tests/arch_timer/default.test         |   1 +
 .../tests/arm64/aarch32_id_regs/default.test  |   1 +
 .../arm64/arch_timer_edge_cases/default.test  |   1 +
 .../tests/arm64/debug-exceptions/default.test |   1 +
 .../kvm/tests/arm64/hypercalls/default.test   |   1 +
 .../kvm/tests/arm64/mmio_abort/default.test   |   1 +
 .../kvm/tests/arm64/no-vgic-v3/default.test   |   1 +
 .../tests/arm64/page_fault_test/default.test  |   1 +
 .../kvm/tests/arm64/psci_test/default.test    |   1 +
 .../kvm/tests/arm64/set_id_regs/default.test  |   1 +
 .../kvm/tests/arm64/smccc_filter/default.test |   1 +
 .../arm64/vcpu_width_config/default.test      |   1 +
 .../kvm/tests/arm64/vgic_init/default.test    |   1 +
 .../kvm/tests/arm64/vgic_irq/default.test     |   1 +
 .../tests/arm64/vgic_lpi_stress/default.test  |   1 +
 .../arm64/vpmu_counter_access/default.test    |   1 +
 .../kvm/tests/coalesced_io_test/default.test  |   1 +
 .../kvm/tests/demand_paging_test/default.test |   1 +
 .../2slot_5vcpu_10iter.test                   |   1 +
 .../tests/dirty_log_perf_test/default.test    |   1 +
 .../no_dirty_log_protect.test                 |   1 +
 .../kvm/tests/dirty_log_test/default.test     |   1 +
 .../kvm/tests/get-reg-list/default.test       |   1 +
 .../kvm/tests/guest_memfd_test/default.test   |   1 +
 .../kvm/tests/guest_print_test/default.test   |   1 +
 .../tests/hardware_disable_test/default.test  |   1 +
 .../tests/kvm_binary_stats_test/default.test  |   1 +
 .../tests/kvm_create_max_vcpus/default.test   |   1 +
 .../tests/kvm_page_table_test/default.test    |   1 +
 .../default.test                              |   1 +
 .../kvm/tests/memslot_perf_test/default.test  |   1 +
 .../kvm/tests/mmu_stress_test/default.test    |   1 +
 .../tests/pre_fault_memory_test/default.test  |   1 +
 .../kvm/tests/riscv/ebreak_test/default.test  |   1 +
 .../kvm/tests/riscv/sbi_pmu_test/default.test |   1 +
 .../kvm/tests/rseq_test/default.test          |   1 +
 .../kvm/tests/s390/cmma_test/default.test     |   1 +
 .../s390/cpumodel_subfuncs_test/default.test  |   1 +
 .../kvm/tests/s390/debug_test/default.test    |   1 +
 .../kvm/tests/s390/memop/default.test         |   1 +
 .../kvm/tests/s390/resets/default.test        |   1 +
 .../s390/shared_zeropage_test/default.test    |   1 +
 .../tests/s390/sync_regs_test/default.test    |   1 +
 .../kvm/tests/s390/tprot/default.test         |   1 +
 .../kvm/tests/s390/ucontrol_test/default.test |   1 +
 .../tests/set_memory_region_test/default.test |   1 +
 .../kvm/tests/steal_time/default.test         |   1 +
 .../system_counter_offset_test/default.test   |   1 +
 .../kvm/tests/x86/amx_test/default.test       |   1 +
 .../x86/apic_bus_clock_test/default.test      |   1 +
 .../kvm/tests/x86/cpuid_test/default.test     |   1 +
 .../x86/cr4_cpuid_sync_test/default.test      |   1 +
 .../kvm/tests/x86/debug_regs/default.test     |   1 +
 .../default.test                              |   1 +
 .../default.test                              |   1 +
 .../kvm/tests/x86/fastops_test/default.test   |   1 +
 .../tests/x86/feature_msrs_test/default.test  |   1 +
 .../tests/x86/fix_hypercall_test/default.test |   1 +
 .../kvm/tests/x86/hwcr_msr_test/default.test  |   1 +
 .../kvm/tests/x86/hyperv_clock/default.test   |   1 +
 .../kvm/tests/x86/hyperv_cpuid/default.test   |   1 +
 .../kvm/tests/x86/hyperv_evmcs/default.test   |   1 +
 .../hyperv_extended_hypercalls/default.test   |   1 +
 .../tests/x86/hyperv_features/default.test    |   1 +
 .../kvm/tests/x86/hyperv_ipi/default.test     |   1 +
 .../tests/x86/hyperv_svm_test/default.test    |   1 +
 .../tests/x86/hyperv_tlb_flush/default.test   |   1 +
 .../tests/x86/kvm_buslock_test/default.test   |   1 +
 .../kvm/tests/x86/kvm_clock_test/default.test |   1 +
 .../kvm/tests/x86/kvm_pv_test/default.test    |   1 +
 .../x86/max_vcpuid_cap_test/default.test      |   1 +
 .../tests/x86/monitor_mwait_test/default.test |   1 +
 .../x86/nested_emulation_test/default.test    |   1 +
 .../x86/nested_exceptions_test/default.test   |   1 +
 .../tests/x86/nx_huge_pages_test/default.test |   1 +
 .../tests/x86/platform_info_test/default.test |   1 +
 .../tests/x86/pmu_counters_test/default.test  |   1 +
 .../x86/pmu_event_filter_test/default.test    |   1 +
 .../private_mem_conversions_test/default.test |   1 +
 .../private_mem_kvm_exits_test/default.test   |   1 +
 .../x86/recalc_apic_map_test/default.test     |   1 +
 .../tests/x86/set_boot_cpu_id/default.test    |   1 +
 .../kvm/tests/x86/set_sregs_test/default.test |   1 +
 .../tests/x86/sev_init2_tests/default.test    |   1 +
 .../tests/x86/sev_migrate_tests/default.test  |   1 +
 .../kvm/tests/x86/sev_smoke_test/default.test |   1 +
 .../default.test                              |   1 +
 .../kvm/tests/x86/smm_test/default.test       |   1 +
 .../kvm/tests/x86/state_test/default.test     |   1 +
 .../tests/x86/svm_int_ctl_test/default.test   |   1 +
 .../x86/svm_nested_shutdown_test/default.test |   1 +
 .../svm_nested_soft_inject_test/default.test  |   1 +
 .../tests/x86/svm_vmcall_test/default.test    |   1 +
 .../kvm/tests/x86/sync_regs_test/default.test |   1 +
 .../x86/triple_fault_event_test/default.test  |   1 +
 .../kvm/tests/x86/tsc_msrs_test/default.test  |   1 +
 .../tests/x86/tsc_scaling_sync/default.test   |   1 +
 .../x86/ucna_injection_test/default.test      |   1 +
 .../tests/x86/userspace_io_test/default.test  |   1 +
 .../x86/userspace_msr_exit_test/default.test  |   1 +
 .../x86/vmx_apic_access_test/default.test     |   1 +
 .../vmx_close_while_nested_test/default.test  |   1 +
 .../tests/x86/vmx_dirty_log_test/default.test |   1 +
 .../default.test                              |   1 +
 .../default.test                              |   1 +
 .../kvm/tests/x86/vmx_msrs_test/default.test  |   1 +
 .../vmx_nested_tsc_scaling_test/default.test  |   1 +
 .../tests/x86/vmx_pmu_caps_test/default.test  |   1 +
 .../vmx_preemption_timer_test/default.test    |   1 +
 .../vmx_set_nested_state_test/default.test    |   1 +
 .../x86/vmx_tsc_adjust_test/default.test      |   1 +
 .../kvm/tests/x86/xapic_ipi_test/default.test |   1 +
 .../tests/x86/xapic_state_test/default.test   |   1 +
 .../tests/x86/xcr0_cpuid_test/default.test    |   1 +
 .../tests/x86/xen_shinfo_test/default.test    |   1 +
 .../tests/x86/xen_vmcall_test/default.test    |   1 +
 .../kvm/tests/x86/xss_msr_test/default.test   |   1 +
 124 files changed, 607 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/command.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/access_tracking_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/coalesced_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/demand_paging_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/get-reg-list/default.test
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
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/rseq_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/debug_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/memop/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/resets/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/tprot/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test
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


base-commit: 3f7b307757ecffc1c18ede9ee3cf9ce8101f3cc9
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


