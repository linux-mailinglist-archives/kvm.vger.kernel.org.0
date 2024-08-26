Return-Path: <kvm+bounces-25071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2475C95F94B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 21:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44AD01C21D77
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269401991C6;
	Mon, 26 Aug 2024 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbExIk32"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584B47DA92
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698883; cv=none; b=nMfTXUUvXy5O7GLz5i3ji6IfecmEKX08Vx31UNgEdYQZqvZo/+lFRg8za1PXOpVJRll/B/cgvvaVFV7KvLtGegsA4nLr5F4zsceWUfw/C4QI5cMNmsNJV4jQ2v/sR9Zmx72PHxXHWXM1NZNuz2YWIuP/sOdKp3OTj5ZX1Q/XLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698883; c=relaxed/simple;
	bh=VSB6RQdarh8mg7yhpMkFbgzIUDdwvVkabQiHxUnHV8s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uvJt99cBN5WAK79IaZvXkf1XkL6fKEVuVxgpod/4PTl/ewrEiy13TZGiQu51NMMou+bQZSpNXasuQKDF9t97PA5tKO8i5i9EB0+6gYCUTitK0jFlDzpaLF5iW4h9/WGoAzLQ0oElVxiO3HrWH5ONVbGcF75J5AMqO+msXdA4YRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbExIk32; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso3752515a12.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 12:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724698881; x=1725303681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ol6yqovvKJzaojHYI1Lewa82yQkAODdCYXZVH3J2eVg=;
        b=TbExIk32KjwEYPgBeK2BqMmklDZcjmA0dLW5Il2ndXIV2/t+nLn2pAvMNfPey94YfX
         NyUz7du1kOSbmQWvYQ9ZZ5qKKincg1Qeft005TiRuosmCVsxy6+f2kpEWZpKsDqdE8Qp
         6MqvrHCorvtN6kZWGZAfCHO9pNTAToF4g48J9VmWd1ig3JubL80d4kXOmIuObiFt0qVd
         dA9IV2GfsjqlGCWf+WZuOFZW0I2MuE8/NfR5sJ4a2Da++Fn559eqAu2DiYVDU2KdsiNd
         ATDLnK9Xpk5kfZBYV8CaAqKvk3LM09Jc6Vwq7rniCO+EoP15WI6kzLb3TeCyzRSnBBSB
         bGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724698881; x=1725303681;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol6yqovvKJzaojHYI1Lewa82yQkAODdCYXZVH3J2eVg=;
        b=Qw0UeDi7r2sjrs1bizCr2kNPQO3AMmd3cUFwis2/zPaQxTYaZ3S8DyyVsmVD9jvOjf
         7ZrpbARnr/3iOYI5kIjfYdoZiSwlyH6WLlGisa39Nx+YEiH+oyySEpeoXfz7khE0pMz2
         TXOK8JVji0ei8jxC7m0ASkxY0E8l6WMc/R/8z5nclCupM5auWFFJ6+/eTI9Fdn95GaOU
         EdBuNSk4ZlxlNMsFLDWM2o7ANMZFqnvB+QcLZ0SBC2uA/S5PjYUTytcaeFywGzZEbCwq
         h+TwLSKp/cYYlf79QMusTaUXQIPVugnC3MDRazNYdL9jm5TGddqm2FmhdtuOdirSGOwC
         1TOA==
X-Gm-Message-State: AOJu0YzDgi/94drTEBmTXJ0g+scSoltR+Nck45b+Z4jSXL8YUgNMcXig
	R6rQPosfx1rJO9BU2iUt0MwE6oeTTMETTLO87EDZEQsbvk1DW4t/FCHgAFzN68gz4+lQg9GplwR
	2bA==
X-Google-Smtp-Source: AGHT+IHZnh61FM4HqhByHwEIjBp8QvMtzNsr1hpE8ea79ucKwMYBDRFhHxUbxCt/VJQqsakjR3G9UZawpiQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:669a:0:b0:7b6:c922:4827 with SMTP id
 41be03b00d2f7-7d214d64ad2mr1255a12.1.1724698880494; Mon, 26 Aug 2024 12:01:20
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 26 Aug 2024 12:01:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826190116.145945-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: selftests: Fix unsupported $(ARCH) builds
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

Play nice with treewrite builds of unsupported architectures, e.g. arm
(32-bit), as KVM selftests' Makefile doesn't do anything to ensure the
target architecture is actually one KVM selftests supports.

Patches 2-3 are opportunistic changes (since the above Makefile change
will generate conflicts) to switch to using $(ARCH) instead of the target
triple for arch specific directories, e.g. arm64 instead of aarch64,
mainly so as not to be different from the rest of the kernel.

Compile tested on all architectures.

My thinking for applying this is to send a v2 just before (or even during)
the 6.12 merge window and bribe Paolo into applying it directly, i.e. make
this series deal with any conflicts.

Sean Christopherson (3):
  KVM: selftests: Provide empty 'all' and 'clean' targets for
    unsupported ARCHs
  KVM: selftests: Use canonical $(ARCH) paths for KVM selftests
    directories
  KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR

 MAINTAINERS                                   |  12 +-
 tools/testing/selftests/kvm/Makefile          | 333 +-----------------
 tools/testing/selftests/kvm/Makefile.kvm      | 315 +++++++++++++++++
 .../kvm/{aarch64 => arm64}/aarch32_id_regs.c  |   0
 .../kvm/{aarch64 => arm64}/arch_timer.c       |   0
 .../kvm/{aarch64 => arm64}/debug-exceptions.c |   0
 .../kvm/{aarch64 => arm64}/get-reg-list.c     |   0
 .../kvm/{aarch64 => arm64}/hypercalls.c       |   0
 .../kvm/{aarch64 => arm64}/page_fault_test.c  |   0
 .../kvm/{aarch64 => arm64}/psci_test.c        |   0
 .../kvm/{aarch64 => arm64}/set_id_regs.c      |   0
 .../kvm/{aarch64 => arm64}/smccc_filter.c     |   0
 .../{aarch64 => arm64}/vcpu_width_config.c    |   0
 .../kvm/{aarch64 => arm64}/vgic_init.c        |   0
 .../kvm/{aarch64 => arm64}/vgic_irq.c         |   0
 .../kvm/{aarch64 => arm64}/vgic_lpi_stress.c  |   0
 .../{aarch64 => arm64}/vpmu_counter_access.c  |   0
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
 .../{s390x => s390}/diag318_test_handler.h    |   0
 .../include/{s390x => s390}/kvm_util_arch.h   |   0
 .../kvm/include/{s390x => s390}/processor.h   |   0
 .../kvm/include/{s390x => s390}/ucall.h       |   0
 .../kvm/include/{x86_64 => x86}/apic.h        |   0
 .../kvm/include/{x86_64 => x86}/evmcs.h       |   0
 .../kvm/include/{x86_64 => x86}/hyperv.h      |   0
 .../include/{x86_64 => x86}/kvm_util_arch.h   |   0
 .../kvm/include/{x86_64 => x86}/mce.h         |   0
 .../kvm/include/{x86_64 => x86}/pmu.h         |   0
 .../kvm/include/{x86_64 => x86}/processor.h   |   0
 .../kvm/include/{x86_64 => x86}/sev.h         |   0
 .../kvm/include/{x86_64 => x86}/svm.h         |   0
 .../kvm/include/{x86_64 => x86}/svm_util.h    |   0
 .../kvm/include/{x86_64 => x86}/ucall.h       |   0
 .../kvm/include/{x86_64 => x86}/vmx.h         |   0
 .../kvm/lib/{aarch64 => arm64}/gic.c          |   0
 .../kvm/lib/{aarch64 => arm64}/gic_private.h  |   0
 .../kvm/lib/{aarch64 => arm64}/gic_v3.c       |   0
 .../kvm/lib/{aarch64 => arm64}/gic_v3_its.c   |   0
 .../kvm/lib/{aarch64 => arm64}/handlers.S     |   0
 .../kvm/lib/{aarch64 => arm64}/processor.c    |   0
 .../kvm/lib/{aarch64 => arm64}/spinlock.c     |   0
 .../kvm/lib/{aarch64 => arm64}/ucall.c        |   0
 .../kvm/lib/{aarch64 => arm64}/vgic.c         |   0
 .../{s390x => s390}/diag318_test_handler.c    |   0
 .../kvm/lib/{s390x => s390}/processor.c       |   0
 .../selftests/kvm/lib/{s390x => s390}/ucall.c |   0
 .../selftests/kvm/lib/{x86_64 => x86}/apic.c  |   0
 .../kvm/lib/{x86_64 => x86}/handlers.S        |   0
 .../kvm/lib/{x86_64 => x86}/hyperv.c          |   0
 .../kvm/lib/{x86_64 => x86}/memstress.c       |   0
 .../selftests/kvm/lib/{x86_64 => x86}/pmu.c   |   0
 .../kvm/lib/{x86_64 => x86}/processor.c       |   0
 .../selftests/kvm/lib/{x86_64 => x86}/sev.c   |   0
 .../selftests/kvm/lib/{x86_64 => x86}/svm.c   |   0
 .../selftests/kvm/lib/{x86_64 => x86}/ucall.c |   0
 .../selftests/kvm/lib/{x86_64 => x86}/vmx.c   |   0
 .../selftests/kvm/{s390x => s390}/cmma_test.c |   0
 .../kvm/{s390x => s390}/debug_test.c          |   0
 .../selftests/kvm/{s390x => s390}/memop.c     |   0
 .../selftests/kvm/{s390x => s390}/resets.c    |   0
 .../{s390x => s390}/shared_zeropage_test.c    |   0
 .../kvm/{s390x => s390}/sync_regs_test.c      |   0
 .../selftests/kvm/{s390x => s390}/tprot.c     |   0
 .../selftests/kvm/{x86_64 => x86}/amx_test.c  |   0
 .../kvm/{x86_64 => x86}/apic_bus_clock_test.c |   0
 .../kvm/{x86_64 => x86}/cpuid_test.c          |   0
 .../kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c |   0
 .../kvm/{x86_64 => x86}/debug_regs.c          |   0
 .../dirty_log_page_splitting_test.c           |   0
 .../exit_on_emulation_failure_test.c          |   0
 .../kvm/{x86_64 => x86}/fix_hypercall_test.c  |   0
 .../kvm/{x86_64 => x86}/flds_emulation.h      |   0
 .../{x86_64 => x86}/get_msr_index_features.c  |   0
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
 141 files changed, 330 insertions(+), 332 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/Makefile.kvm
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/aarch32_id_regs.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/arch_timer.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/debug-exceptions.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/get-reg-list.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/hypercalls.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/page_fault_test.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/psci_test.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/set_id_regs.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/smccc_filter.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vcpu_width_config.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_init.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_irq.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vgic_lpi_stress.c (100%)
 rename tools/testing/selftests/kvm/{aarch64 => arm64}/vpmu_counter_access.c (100%)
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
 rename tools/testing/selftests/kvm/include/{s390x => s390}/diag318_test_handler.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{s390x => s390}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/apic.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/evmcs.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/hyperv.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/kvm_util_arch.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/mce.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/pmu.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/processor.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/sev.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/svm_util.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/ucall.h (100%)
 rename tools/testing/selftests/kvm/include/{x86_64 => x86}/vmx.h (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_private.h (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/gic_v3_its.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/processor.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/spinlock.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{aarch64 => arm64}/vgic.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/diag318_test_handler.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/processor.c (100%)
 rename tools/testing/selftests/kvm/lib/{s390x => s390}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/apic.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/handlers.S (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/hyperv.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/memstress.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/pmu.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/processor.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/sev.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/svm.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/ucall.c (100%)
 rename tools/testing/selftests/kvm/lib/{x86_64 => x86}/vmx.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/cmma_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/debug_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/memop.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/resets.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/shared_zeropage_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/sync_regs_test.c (100%)
 rename tools/testing/selftests/kvm/{s390x => s390}/tprot.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/amx_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/apic_bus_clock_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cpuid_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/cr4_cpuid_sync_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/debug_regs.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/dirty_log_page_splitting_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/exit_on_emulation_failure_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/fix_hypercall_test.c (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/flds_emulation.h (100%)
 rename tools/testing/selftests/kvm/{x86_64 => x86}/get_msr_index_features.c (100%)
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


base-commit: 15e1c3d65975524c5c792fcd59f7d89f00402261
-- 
2.46.0.295.g3b9ea8a38a-goog


