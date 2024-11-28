Return-Path: <kvm+bounces-32633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD769DB06A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48BA3165A66
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AC4134BD;
	Thu, 28 Nov 2024 00:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J9TFxZuN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48DAC8FF
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755353; cv=none; b=HiHCQMxiPyJqUOhsCPFeJiUC6zt0x7hScP6qjlizQ10Y+RLC8equDZjFPt/H09BjOMJ8ZvIYh+njRZXsrvwSih4X34RlLVEb9kWsYm74F6umfySYymFUVcXSrjXCwMD0fqG3uuKDLqXKfokUCDfz1VulU82DkHMUiRREyKTwytI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755353; c=relaxed/simple;
	bh=P4grW7gquq8R9VrWF9+MmmfW+pL0Qx8xPOq1de4HzRM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rcI6ALktTLQ23lBMxxhzbzykT4/xIkKt3InuLz6kPy/TSGyJeRn6zSj6aaVge3iR1oJk9pZ1586v91hfVWfrNWKxdsIyNTuzCXTIfjAAPky2a3Q98EdWdkEjt2I/r3OCDv9ieaxMQCfbXGkQWxkR5AvMGqx7EENDEHZaodH7SfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J9TFxZuN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea50590a43so472347a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755350; x=1733360150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9uOIcefGzB9TJLnf+byngHoM0tW92UJmLMn3MQxItc=;
        b=J9TFxZuN4eqqSMjQWaFMI9lYI1uJzCSlpvhZqFjAJZ1sqk1w3f2Jh7X/pL2FrjBmim
         nJEQju/GscInymbRGMa8DcDQzD69ed7N2ya8m0WJAN5rQ65fmJDHU1b/0D+PSsjrMSrI
         ousQ7UdywuwWs9tliETW72bMHMCb+Lv8Fa1FJPf9WrTFPfgTG+BsAMKyPTVGBZ5sZFSy
         argSYegoWGqv4a8MamMErWSyOh7jetXADSGIl/1cpjUt2i5NqkEYMBApCRJNbMh/RJ5a
         hZwU1jB4jjBMcaAlUlaGMiAcNYNx3s2xt+Swo6mnCXOVdHMIy/ftzZM9Ud6xu/OxNGGa
         Ridw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755350; x=1733360150;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9uOIcefGzB9TJLnf+byngHoM0tW92UJmLMn3MQxItc=;
        b=qYP6LWl0KilCixnyZ2zxEk+gUKqrZPtaYri8sYeQgvxvW/oE50/7AElXXQdJuasPVu
         r7tj3Gm/+hQLxqceSwhJVbNc2zEumJ1OQ5enjXuRt/neVLLjMv/S9U04rlvji8cgbUv2
         AlCtlpMjz+ItFD0bKqTJEzhorb8ip3rxPAvJ8lpZAGtOMJRIugYs1gjGjWDXvcfPPsug
         EeT6j0ROvnU1/faaAD+L22KOKDwNv2LywU1aA5Bccsr0OlBBJlB2fg7gBw2Mp3GYJeJn
         h/u/5xlMQcRYRP3nDkGr9rMs2cE3cOqUjTJPKDBT61X/on9p8PdI5DkI2a5HFu0sN/Oe
         5GHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq6vyzGJNshgpW9+gBWgxJ2GYJpVyT5SzAjQJqzqU0mGz3/Ca2zTNT9sM2zEC68pezqN4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9fgbuV7L1uhAyWqKUYYJhS/PwpNM7oU0RgD3lZ3rzluynAj8l
	3qFefD91XXOXgRFq2u6V5SWEvxeDi7PAXE719p5d7Y7FafLqOLuExqFnM8YwjP5DoBTd2GRE5AT
	zTg==
X-Google-Smtp-Source: AGHT+IE23NadWH10rxgZrKIo0Meu75Z9uiIhhXyN7Jgs8FhBFLGmtywZPafifZyrfoOUc59rHUvsRLHBSGY=
X-Received: from pjbsj13.prod.google.com ([2002:a17:90b:2d8d:b0:2d3:ba90:93e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2690:b0:2ea:7755:a0fa
 with SMTP id 98e67ed59e1d1-2ee08e9d433mr6863204a91.7.1732755350346; Wed, 27
 Nov 2024 16:55:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-1-seanjc@google.com>
Subject: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
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

Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
avoid unpleasant conflicts, and because I hope to land both in kvm/next
shortly after 6.12-rc1 since they impact all of KVM selftests.

mmu_stress_test
---------------
Convert the max_guest_memory_test into a more generic mmu_stress_test.
The basic gist of the "conversion" is to have the test do mprotect() on
guest memory while vCPUs are accessing said memory, e.g. to verify KVM
and mmu_notifiers are working as intended.

The original plan was that patch 3 would be a single patch, but things
snowballed in order to rework vcpu_get_reg() to return a value instead
of using an out-param.  Having to define a variable just to bump the
program counter on arm64 annoyed me.

$ARCH
-----
Play nice with treewrite builds of unsupported architectures, e.g. arm
(32-bit), as KVM selftests' Makefile doesn't do anything to ensure the
target architecture is actually one KVM selftests supports.

The last two patches are opportunistic changes (since the above Makefile
change will generate conflicts everywhere) to switch to using $(ARCH)
instead of the target triple for arch specific directories, e.g. arm64
instead of aarch64, mainly so as not to be different from the rest of
the kernel.

Compile tested on all architectures, runtime tested on x86 and arm64.

v4:
 - Rebase and squash the series.
 - Exclude Makefile.kvm from .gitignore. [kernel test bot]

v3 (of mmu_stress_test):
 - Rebased onto v6.12-rc2.
 - Disable strict aliasing to fix the PMCR snafu.
 - Collect reviews. [Drew]
 - Minor changelog fixes. [Drew]
 - Include ucall_common.h to prep for RISC-V. [Drew]

v2:
 - Rebase onto kvm/next.
 - Add the aforementioned vcpu_get_reg() changes/disaster.
 - Actually add arm64 support for the fancy mprotect() testcase (I did this
   before v1, but managed to forget to include the changes when posting).
 - Emit "mov %rax, (%rax)" on x86. [James]
 - Add a comment to explain the fancy mprotect() vs. vCPUs logic.
 - Drop the KVM x86 patches (applied and/or will be handled separately).

v1: https://lore.kernel.org/all/20240809194335.1726916-1-seanjc@google.com

[1] https://lore.kernel.org/all/20241009154953.1073471-1-seanjc@google.com
[2] https://lore.kernel.org/all/20240826190116.145945-1-seanjc@google.com

Sean Christopherson (16):
  KVM: Move KVM_REG_SIZE() definition to common uAPI header
  KVM: selftests: Return a value from vcpu_get_reg() instead of using an
    out-param
  KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
  KVM: selftests: Check for a potential unhandled exception iff KVM_RUN
    succeeded
  KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
  KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
  KVM: selftests: Compute number of extra pages needed in
    mmu_stress_test
  KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
  KVM: selftests: Enable mmu_stress_test on arm64
  KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
  KVM: selftests: Precisely limit the number of guest loops in
    mmu_stress_test
  KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
  KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
  KVM: selftests: Provide empty 'all' and 'clean' targets for
    unsupported ARCHs
  KVM: selftests: Use canonical $(ARCH) paths for KVM selftests
    directories
  KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR

 MAINTAINERS                                   |  12 +-
 arch/arm64/include/uapi/asm/kvm.h             |   3 -
 arch/riscv/include/uapi/asm/kvm.h             |   3 -
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          | 345 +-----------------
 tools/testing/selftests/kvm/Makefile.kvm      | 330 +++++++++++++++++
 .../kvm/{aarch64 => arm64}/aarch32_id_regs.c  |  10 +-
 .../kvm/{aarch64 => arm64}/arch_timer.c       |   0
 .../arch_timer_edge_cases.c                   |   0
 .../kvm/{aarch64 => arm64}/debug-exceptions.c |   4 +-
 .../kvm/{aarch64 => arm64}/get-reg-list.c     |   0
 .../kvm/{aarch64 => arm64}/hypercalls.c       |   6 +-
 .../kvm/{aarch64 => arm64}/mmio_abort.c       |   0
 .../kvm/{aarch64 => arm64}/no-vgic-v3.c       |   2 +-
 .../kvm/{aarch64 => arm64}/page_fault_test.c  |   0
 .../kvm/{aarch64 => arm64}/psci_test.c        |   6 +-
 .../kvm/{aarch64 => arm64}/set_id_regs.c      |  18 +-
 .../kvm/{aarch64 => arm64}/smccc_filter.c     |   0
 .../{aarch64 => arm64}/vcpu_width_config.c    |   0
 .../kvm/{aarch64 => arm64}/vgic_init.c        |   0
 .../kvm/{aarch64 => arm64}/vgic_irq.c         |   0
 .../kvm/{aarch64 => arm64}/vgic_lpi_stress.c  |   0
 .../{aarch64 => arm64}/vpmu_counter_access.c  |  19 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../include/{aarch64 => arm64}/arch_timer.h   |   0
 .../kvm/include/{aarch64 => arm64}/delay.h    |   0
 .../kvm/include/{aarch64 => arm64}/gic.h      |   0
 .../kvm/include/{aarch64 => arm64}/gic_v3.h   |   0
 .../include/{aarch64 => arm64}/gic_v3_its.h   |   0
 .../{aarch64 => arm64}/kvm_util_arch.h        |   0
 .../include/{aarch64 => arm64}/processor.h    |   0
 .../kvm/include/{aarch64 => arm64}/spinlock.h |   0
 .../kvm/include/{aarch64 => arm64}/ucall.h    |   0
 .../kvm/include/{aarch64 => arm64}/vgic.h     |   0
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +-
 .../kvm/include/{s390x => s390}/debug_print.h |   0
 .../{s390x => s390}/diag318_test_handler.h    |   0
 .../kvm/include/{s390x => s390}/facility.h    |   0
 .../include/{s390x => s390}/kvm_util_arch.h   |   0
 .../kvm/include/{s390x => s390}/processor.h   |   0
 .../kvm/include/{s390x => s390}/sie.h         |   0
 .../kvm/include/{s390x => s390}/ucall.h       |   0
 .../kvm/include/{x86_64 => x86}/apic.h        |   2 -
 .../kvm/include/{x86_64 => x86}/evmcs.h       |   3 -
 .../kvm/include/{x86_64 => x86}/hyperv.h      |   3 -
 .../include/{x86_64 => x86}/kvm_util_arch.h   |   0
 .../kvm/include/{x86_64 => x86}/mce.h         |   2 -
 .../kvm/include/{x86_64 => x86}/pmu.h         |   0
 .../kvm/include/{x86_64 => x86}/processor.h   |   2 -
 .../kvm/include/{x86_64 => x86}/sev.h         |   0
 .../kvm/include/{x86_64 => x86}/svm.h         |   6 -
 .../kvm/include/{x86_64 => x86}/svm_util.h    |   3 -
 .../kvm/include/{x86_64 => x86}/ucall.h       |   0
 .../kvm/include/{x86_64 => x86}/vmx.h         |   2 -
 .../kvm/lib/{aarch64 => arm64}/gic.c          |   0
 .../kvm/lib/{aarch64 => arm64}/gic_private.h  |   0
 .../kvm/lib/{aarch64 => arm64}/gic_v3.c       |   0
 .../kvm/lib/{aarch64 => arm64}/gic_v3_its.c   |   0
 .../kvm/lib/{aarch64 => arm64}/handlers.S     |   0
 .../kvm/lib/{aarch64 => arm64}/processor.c    |   8 +-
 .../kvm/lib/{aarch64 => arm64}/spinlock.c     |   0
 .../kvm/lib/{aarch64 => arm64}/ucall.c        |   0
 .../kvm/lib/{aarch64 => arm64}/vgic.c         |   0
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 .../selftests/kvm/lib/riscv/processor.c       |  66 ++--
 .../{s390x => s390}/diag318_test_handler.c    |   0
 .../kvm/lib/{s390x => s390}/facility.c        |   0
 .../kvm/lib/{s390x => s390}/processor.c       |   0
 .../selftests/kvm/lib/{s390x => s390}/ucall.c |   0
 .../selftests/kvm/lib/{x86_64 => x86}/apic.c  |   0
 .../kvm/lib/{x86_64 => x86}/handlers.S        |   0
 .../kvm/lib/{x86_64 => x86}/hyperv.c          |   0
 .../kvm/lib/{x86_64 => x86}/memstress.c       |   2 +-
 .../selftests/kvm/lib/{x86_64 => x86}/pmu.c   |   0
 .../kvm/lib/{x86_64 => x86}/processor.c       |   2 -
 .../selftests/kvm/lib/{x86_64 => x86}/sev.c   |   0
 .../selftests/kvm/lib/{x86_64 => x86}/svm.c   |   1 -
 .../selftests/kvm/lib/{x86_64 => x86}/ucall.c |   0
 .../selftests/kvm/lib/{x86_64 => x86}/vmx.c   |   2 -
 ..._guest_memory_test.c => mmu_stress_test.c} | 162 +++++++-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   2 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   2 +-
 .../selftests/kvm/{s390x => s390}/cmma_test.c |   0
 .../selftests/kvm/{s390x => s390}/config      |   0
 .../{s390x => s390}/cpumodel_subfuncs_test.c  |   0
 .../kvm/{s390x => s390}/debug_test.c          |   0
 .../selftests/kvm/{s390x => s390}/memop.c     |   0
 .../selftests/kvm/{s390x => s390}/resets.c    |   2 +-
 .../{s390x => s390}/shared_zeropage_test.c    |   0
 .../kvm/{s390x => s390}/sync_regs_test.c      |   0
 .../selftests/kvm/{s390x => s390}/tprot.c     |   0
 .../kvm/{s390x => s390}/ucontrol_test.c       |   0
 .../selftests/kvm/set_memory_region_test.c    |   6 +-
 tools/testing/selftests/kvm/steal_time.c      |   3 +-
 .../selftests/kvm/{x86_64 => x86}/amx_test.c  |   0
 .../kvm/{x86_64 => x86}/apic_bus_clock_test.c |   0
 .../kvm/{x86_64 => x86}/cpuid_test.c          |   0
 .../kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c |   0
 .../kvm/{x86_64 => x86}/debug_regs.c          |   0
 .../dirty_log_page_splitting_test.c           |   0
 .../exit_on_emulation_failure_test.c          |   0
 .../kvm/{x86_64 => x86}/feature_msrs_test.c   |   0
 .../kvm/{x86_64 => x86}/fix_hypercall_test.c  |   0
 .../kvm/{x86_64 => x86}/flds_emulation.h      |   0
 .../kvm/{x86_64 => x86}/hwcr_msr_test.c       |   0
 .../kvm/{x86_64 => x86}/hyperv_clock.c        |   0
 .../kvm/{x86_64 => x86}/hyperv_cpuid.c        |   0
 .../kvm/{x86_64 => x86}/hyperv_evmcs.c        |   0
 .../hyperv_extended_hypercalls.c              |   0
 .../kvm/{x86_64 => x86}/hyperv_features.c     |   0
 .../kvm/{x86_64 => x86}/hyperv_ipi.c          |   0
 .../kvm/{x86_64 => x86}/hyperv_svm_test.c     |   0
 .../kvm/{x86_64 => x86}/hyperv_tlb_flush.c    |   0
 .../kvm/{x86_64 => x86}/kvm_clock_test.c      |   0
 .../kvm/{x86_64 => x86}/kvm_pv_test.c         |   0
 .../kvm/{x86_64 => x86}/max_vcpuid_cap_test.c |   0
 .../kvm/{x86_64 => x86}/monitor_mwait_test.c  |   0
 .../{x86_64 => x86}/nested_exceptions_test.c  |   0
 .../kvm/{x86_64 => x86}/nx_huge_pages_test.c  |   0
 .../kvm/{x86_64 => x86}/nx_huge_pages_test.sh |   0
 .../kvm/{x86_64 => x86}/platform_info_test.c  |   0
 .../kvm/{x86_64 => x86}/pmu_counters_test.c   |   0
 .../{x86_64 => x86}/pmu_event_filter_test.c   |   0
 .../private_mem_conversions_test.c            |   0
 .../private_mem_kvm_exits_test.c              |   0
 .../{x86_64 => x86}/recalc_apic_map_test.c    |   0
 .../kvm/{x86_64 => x86}/set_boot_cpu_id.c     |   0
 .../kvm/{x86_64 => x86}/set_sregs_test.c      |   0
 .../kvm/{x86_64 => x86}/sev_init2_tests.c     |   0
 .../kvm/{x86_64 => x86}/sev_migrate_tests.c   |   0
 .../kvm/{x86_64 => x86}/sev_smoke_test.c      |   0
 .../smaller_maxphyaddr_emulation_test.c       |   0
 .../selftests/kvm/{x86_64 => x86}/smm_test.c  |   0
 .../kvm/{x86_64 => x86}/state_test.c          |   0
 .../kvm/{x86_64 => x86}/svm_int_ctl_test.c    |   0
 .../svm_nested_shutdown_test.c                |   0
 .../svm_nested_soft_inject_test.c             |   0
 .../kvm/{x86_64 => x86}/svm_vmcall_test.c     |   0
 .../kvm/{x86_64 => x86}/sync_regs_test.c      |   0
 .../{x86_64 => x86}/triple_fault_event_test.c |   0
 .../kvm/{x86_64 => x86}/tsc_msrs_test.c       |   0
 .../kvm/{x86_64 => x86}/tsc_scaling_sync.c    |   0
 .../kvm/{x86_64 => x86}/ucna_injection_test.c |   0
 .../kvm/{x86_64 => x86}/userspace_io_test.c   |   0
 .../{x86_64 => x86}/userspace_msr_exit_test.c |   0
 .../{x86_64 => x86}/vmx_apic_access_test.c    |   0
 .../vmx_close_while_nested_test.c             |   0
 .../kvm/{x86_64 => x86}/vmx_dirty_log_test.c  |   0
 .../vmx_exception_with_invalid_guest_state.c  |   0
 .../vmx_invalid_nested_guest_state.c          |   0
 .../kvm/{x86_64 => x86}/vmx_msrs_test.c       |   0
 .../vmx_nested_tsc_scaling_test.c             |   0
 .../kvm/{x86_64 => x86}/vmx_pmu_caps_test.c   |   0
 .../vmx_preemption_timer_test.c               |   0
 .../vmx_set_nested_state_test.c               |   0
 .../kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c |   0
 .../kvm/{x86_64 => x86}/xapic_ipi_test.c      |   0
 .../kvm/{x86_64 => x86}/xapic_state_test.c    |   0
 .../kvm/{x86_64 => x86}/xcr0_cpuid_test.c     |   0
 .../kvm/{x86_64 => x86}/xen_shinfo_test.c     |   0
 .../kvm/{x86_64 => x86}/xen_vmcall_test.c     |   0
 .../kvm/{x86_64 => x86}/xss_msr_test.c        |   0
 164 files changed, 584 insertions(+), 477 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/Makefile.kvm
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/aarch32_id_regs.c (95%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer_edge_cases.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/debug-exceptions.c (99%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/get-reg-list.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/hypercalls.c (98%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/mmio_abort.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/no-vgic-v3.c (98%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/page_fault_test.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/psci_test.c (97%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/set_id_regs.c (97%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/smccc_filter.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vcpu_width_config.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_init.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_irq.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_lpi_stress.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vpmu_counter_access.c (97%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/arch_timer.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/delay.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/gic_v3_its.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/spinlock.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{aarch64 => arm64}/vgic.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/debug_print.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/diag318_test_handler.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/facility.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/sie.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/apic.h (98%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/evmcs.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/hyperv.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/mce.h (94%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/pmu.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/processor.h (99%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/sev.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm.h (98%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm_util.h (94%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/vmx.h (99%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_private.h (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3_its.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/processor.c (98%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/spinlock.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/vgic.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/diag318_test_handler.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/facility.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/processor.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/apic.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/hyperv.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/memstress.c (98%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/pmu.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/processor.c (99%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/sev.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/svm.c (99%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/vmx.c (99%)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (60%)
 rename tools/testing/selftests/kvm/{s390x => s390}/cmma_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/config (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/cpumodel_subfuncs_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/debug_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/memop.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/resets.c (99%)
 rename tools/testing/selftests/kvm/{s390x => s390}/shared_zeropage_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/sync_regs_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/tprot.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/ucontrol_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/amx_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/apic_bus_clock_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cpuid_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/debug_regs.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/dirty_log_page_splitting_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/exit_on_emulation_failure_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/feature_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/fix_hypercall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/flds_emulation.h (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hwcr_msr_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_clock.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_cpuid.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_evmcs.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_extended_hypercalls.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_features.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_ipi.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_svm_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/hyperv_tlb_flush.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_clock_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/kvm_pv_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/max_vcpuid_cap_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/monitor_mwait_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nested_exceptions_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/nx_huge_pages_test.sh (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/platform_info_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_counters_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/pmu_event_filter_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_conversions_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/private_mem_kvm_exits_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/recalc_apic_map_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/set_boot_cpu_id.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/set_sregs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_init2_tests.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_migrate_tests.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sev_smoke_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/smaller_maxphyaddr_emulation_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/smm_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_int_ctl_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_shutdown_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_nested_soft_inject_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/svm_vmcall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/sync_regs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/triple_fault_event_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/tsc_scaling_sync.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/ucna_injection_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_io_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/userspace_msr_exit_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_apic_access_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_close_while_nested_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_dirty_log_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_exception_with_invalid_guest_state.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_invalid_nested_guest_state.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_msrs_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_nested_tsc_scaling_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_pmu_caps_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_preemption_timer_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_set_nested_state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/vmx_tsc_adjust_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_ipi_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xapic_state_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xcr0_cpuid_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_shinfo_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xen_vmcall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/xss_msr_test.c (100%)


base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


