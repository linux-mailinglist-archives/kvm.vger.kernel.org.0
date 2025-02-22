Return-Path: <kvm+bounces-38922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D9DA40476
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A491070350E
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 00:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6110382890;
	Sat, 22 Feb 2025 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ATNR+r65"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A075C770E2
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185990; cv=none; b=kCl8r7EaKHN7r6UH9uG7rq+s9tK0KwZhwlAEnZZpRa+0eM01UxW2MXUoKlxDCrPUycwDqWet1Ncx6utf4e2zLbLleFff2wl8tIoGNCA38vNbmzPNrvMoLa77f6BWXZerDPuq3Hc3wQoT9kKYpWhwgUXJJvRWxPP2CbQqCHxKmS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185990; c=relaxed/simple;
	bh=RD/60KEUKHeeAmpP+6lmvBKPq2HiHPkrfTCvHrYEQs0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kX1uFGUnR8GSmhGiE76KV4ia7CT84tIGaEbVkP+D6uzbuUTdFbkId5AaZtesk08ksTXKj3FwwoL4rbuP5oFAT31/h4781GA4LL1fsghyyKfv7cbj/U5UDHVwx1YnpTENAZ6g7OIYaWxqnmNASTjaQGm9HVeqxC9nIZ6S21Zu8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ATNR+r65; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc2b258e82so5910010a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740185988; x=1740790788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kBRd9F+mx4wFt4H+VE0Ydy83ogmyyqX60XghvKixac0=;
        b=ATNR+r65bgUCGLf/NCHISCFBg11qSLEcvEyVFnm7qlSZyK6navfupJCVqC6txoAJsC
         2ZZd1zKWqI5eqJumS1yOQsNPrpmffsOC1+af5uvYWzFx2G6f8Tmsp+ddyWbl4GIv45IT
         yszfCOn9B4nVoj6cWYJ/Ql+vkKq0Z0SRF2HrPTWj/YReGyuwjTU/6S0jWDPsevxv3/gZ
         QoU5D8WgJehfYZWM4QYnbd10EP4Hy4PYVyRAZsO0kArdp7WCLSbhJj9p6C9xA5KzG3YG
         JaPRYeIEvFvAs6adMK9SP7PEQcCJVFBD9rqqGOzHBH0xPVcLOgg8co72YZ3xXWmMvTQx
         N4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740185988; x=1740790788;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBRd9F+mx4wFt4H+VE0Ydy83ogmyyqX60XghvKixac0=;
        b=niLHoYmMD2escTOgv4MECT0FpYJ/7Y56+6/3KwdoVLzqd1uYSzkTV/7/0DwIot9ji2
         yeBhb0hWgS/WHb76ADrAxdsUpYT8pQOfQ+G4F8myrPEZvxqFmLWCCaFxywgkl8zXaOb3
         bPKspZ41BKIONpnyhblX0eWNwIwrptq9MDvabKkMZ4i/mRgUPCX14xyQeIOBq1Ye5Wkv
         FsprGNStad4ZlTGAXpRJ/s+co1XIqlYNhav05Uq285g/TTPhgQGiZW4/Sxk5fBihdWAK
         0RBwqasrq7OB4f0c+di3mR6nRQK8NojLsu7a7YAoi2rrGY2z8LqvMKQW+VQBb1IeyKQP
         jvCA==
X-Gm-Message-State: AOJu0YwUU1Ev5bvN76fOLIYEnxXkkLgYl5GvfD3mKjsvx6DtRfjNVqIY
	v8xR4SvAo6On6tmkoBWBECG1xx2FX9kT7UkfnCCFL6uQ4+GammrB7zzRPPcMBqkjlwOQw1fi4Pm
	TIFPelgopC7Cactelk6VtxXtyVNdo0PcWhh05pKd2rxxICnuOfKeoN/KQ47gqCpmK8gIGF6dALI
	kbaltiIeyVAcCw+X6TY7ZtDD4y4vnja5gHxw==
X-Google-Smtp-Source: AGHT+IHFh+l8vBTEFEs3Y7eqKUizEgDHBm2dD/Rr3VO9twBVXR3MXf6pLXzxMgscxinv8InO1m/NzVZUfvdz
X-Received: from pjbdb16.prod.google.com ([2002:a17:90a:d650:b0:2fa:1b0c:4150])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b83:b0:2f8:b2c:5ef3
 with SMTP id 98e67ed59e1d1-2fce789cedamr10422060a91.14.1740185987890; Fri, 21
 Feb 2025 16:59:47 -0800 (PST)
Date: Fri, 21 Feb 2025 16:59:28 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250222005943.3348627-1-vipinsh@google.com>
Subject: [PATCH 0/2] Add KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This series in continuation of the selftest runner discussion we had
some months ago.
https://lore.kernel.org/kvm/20240821223012.3757828-1-vipinsh@google.com/

Based on the discussion, this is phase 1 implementation of KVM selftest
runner. Patch 1 is providing the testcase files and patch 2 is runner
implementation which uses testcase files.

This version has following features:
- Parallel test execution.
- Dumping separate output for each test.
- Timeout for test execution
- Specify single test or a test directory.

Vipin Sharma (2):
  KVM: selftests: Add default testfiles for KVM selftests runner
  KVM: selftests: Create KVM selftest runner

 tools/testing/selftests/kvm/.gitignore        |  4 +-
 .../testing/selftests/kvm/runner/__main__.py  | 96 +++++++++++++++++++
 tools/testing/selftests/kvm/runner/command.py | 42 ++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 49 ++++++++++
 .../selftests/kvm/runner/test_runner.py       | 40 ++++++++
 .../aarch64/aarch32_id_regs/default.test      |  1 +
 .../testcases/aarch64/arch_timer/default.test |  1 +
 .../arch_timer_edge_cases/default.test        |  1 +
 .../aarch64/debug-exceptions/default.test     |  1 +
 .../aarch64/get-reg-list/default.test         |  1 +
 .../testcases/aarch64/hypercalls/default.test |  1 +
 .../testcases/aarch64/no-vgic-v3/default.test |  1 +
 .../aarch64/page_fault_test/default.test      |  1 +
 .../testcases/aarch64/psci_test/default.test  |  1 +
 .../aarch64/set_id_regs/default.test          |  1 +
 .../aarch64/smccc_filter/default.test         |  1 +
 .../aarch64/vcpu_width_config/default.test    |  1 +
 .../testcases/aarch64/vgic_init/default.test  |  1 +
 .../testcases/aarch64/vgic_irq/default.test   |  1 +
 .../aarch64/vgic_lpi_stress/default.test      |  1 +
 .../aarch64/vpmu_counter_access/default.test  |  1 +
 .../access_tracking_perf_test/default.test    |  1 +
 .../testcases/coalesced_io_test/default.test  |  1 +
 .../testcases/demand_paging_test/default.test |  1 +
 .../dirty_log_perf_test/default.test          |  1 +
 .../kvm/testcases/dirty_log_test/default.test |  1 +
 .../testcases/guest_memfd_test/default.test   |  1 +
 .../testcases/guest_print_test/default.test   |  1 +
 .../hardware_disable_test/default.test        |  1 +
 .../kvm_binary_stats_test/default.test        |  1 +
 .../kvm_create_max_vcpus/default.test         |  1 +
 .../kvm_page_table_test/default.test          |  1 +
 .../max_guest_memory_test/default.test        |  1 +
 .../default.test                              |  1 +
 .../testcases/memslot_perf_test/default.test  |  1 +
 .../pre_fault_memory_test/default.test        |  1 +
 .../testcases/riscv/arch_timer/default.test   |  1 +
 .../testcases/riscv/ebreak_test/default.test  |  1 +
 .../testcases/riscv/get-reg-list/default.test |  1 +
 .../testcases/riscv/sbi_pmu_test/default.test |  1 +
 .../kvm/testcases/rseq_test/default.test      |  1 +
 .../testcases/s390x/cmma_test/default.test    |  1 +
 .../testcases/s390x/debug_test/default.test   |  1 +
 .../kvm/testcases/s390x/memop/default.test    |  1 +
 .../kvm/testcases/s390x/resets/default.test   |  1 +
 .../s390x/shared_zeropage_test/default.test   |  1 +
 .../s390x/sync_regs_test/default.test         |  1 +
 .../kvm/testcases/s390x/tprot/default.test    |  1 +
 .../s390x/ucontrol_test/default.test          |  1 +
 .../set_memory_region_test/default.test       |  1 +
 .../kvm/testcases/steal_time/default.test     |  1 +
 .../system_counter_offset_test/default.test   |  1 +
 .../testcases/x86_64/amx_test/default.test    |  1 +
 .../x86_64/apic_bus_clock_test/default.test   |  1 +
 .../testcases/x86_64/cpuid_test/default.test  |  1 +
 .../x86_64/cr4_cpuid_sync_test/default.test   |  1 +
 .../testcases/x86_64/debug_regs/default.test  |  1 +
 .../default.test                              |  1 +
 .../default.test                              |  1 +
 .../x86_64/feature_msrs_test/default.test     |  1 +
 .../x86_64/fix_hypercall_test/default.test    |  1 +
 .../x86_64/hwcr_msr_test/default.test         |  1 +
 .../x86_64/hyperv_clock/default.test          |  1 +
 .../x86_64/hyperv_cpuid/default.test          |  1 +
 .../x86_64/hyperv_evmcs/default.test          |  1 +
 .../hyperv_extended_hypercalls/default.test   |  1 +
 .../x86_64/hyperv_features/default.test       |  1 +
 .../testcases/x86_64/hyperv_ipi/default.test  |  1 +
 .../x86_64/hyperv_svm_test/default.test       |  1 +
 .../x86_64/hyperv_tlb_flush/default.test      |  1 +
 .../x86_64/kvm_clock_test/default.test        |  1 +
 .../testcases/x86_64/kvm_pv_test/default.test |  1 +
 .../x86_64/max_vcpuid_cap_test/default.test   |  1 +
 .../x86_64/monitor_mwait_test/default.test    |  1 +
 .../nested_exceptions_test/default.test       |  1 +
 .../x86_64/nx_huge_pages_test/default.test    |  1 +
 .../x86_64/platform_info_test/default.test    |  1 +
 .../x86_64/pmu_counters_test/default.test     |  1 +
 .../x86_64/pmu_event_filter_test/default.test |  1 +
 .../private_mem_conversions_test/default.test |  1 +
 .../private_mem_kvm_exits_test/default.test   |  1 +
 .../x86_64/recalc_apic_map_test/default.test  |  1 +
 .../x86_64/set_boot_cpu_id/default.test       |  1 +
 .../x86_64/set_sregs_test/default.test        |  1 +
 .../x86_64/sev_init2_tests/default.test       |  1 +
 .../x86_64/sev_migrate_tests/default.test     |  1 +
 .../x86_64/sev_smoke_test/default.test        |  1 +
 .../default.test                              |  1 +
 .../testcases/x86_64/smm_test/default.test    |  1 +
 .../testcases/x86_64/state_test/default.test  |  1 +
 .../x86_64/svm_int_ctl_test/default.test      |  1 +
 .../svm_nested_shutdown_test/default.test     |  1 +
 .../svm_nested_soft_inject_test/default.test  |  1 +
 .../x86_64/svm_vmcall_test/default.test       |  1 +
 .../x86_64/sync_regs_test/default.test        |  1 +
 .../triple_fault_event_test/default.test      |  1 +
 .../x86_64/tsc_msrs_test/default.test         |  1 +
 .../x86_64/tsc_scaling_sync/default.test      |  1 +
 .../x86_64/ucna_injection_test/default.test   |  1 +
 .../x86_64/userspace_io_test/default.test     |  1 +
 .../userspace_msr_exit_test/default.test      |  1 +
 .../x86_64/vmx_apic_access_test/default.test  |  1 +
 .../vmx_close_while_nested_test/default.test  |  1 +
 .../x86_64/vmx_dirty_log_test/default.test    |  1 +
 .../default.test                              |  1 +
 .../default.test                              |  1 +
 .../x86_64/vmx_msrs_test/default.test         |  1 +
 .../vmx_nested_tsc_scaling_test/default.test  |  1 +
 .../x86_64/vmx_pmu_caps_test/default.test     |  1 +
 .../vmx_preemption_timer_test/default.test    |  1 +
 .../vmx_set_nested_state_test/default.test    |  1 +
 .../x86_64/vmx_tsc_adjust_test/default.test   |  1 +
 .../x86_64/xapic_ipi_test/default.test        |  1 +
 .../x86_64/xapic_state_test/default.test      |  1 +
 .../x86_64/xcr0_cpuid_test/default.test       |  1 +
 .../x86_64/xen_shinfo_test/default.test       |  1 +
 .../x86_64/xen_vmcall_test/default.test       |  1 +
 .../x86_64/xss_msr_test/default.test          |  1 +
 118 files changed, 343 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/command.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
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


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.601.g30ceb7b040-goog


