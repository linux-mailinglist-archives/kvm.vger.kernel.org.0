Return-Path: <kvm+bounces-25073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5EE95F94F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 21:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 263521F2285C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA34199E98;
	Mon, 26 Aug 2024 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJkSWxuE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91F199238
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698889; cv=none; b=pV8X38n7Pwdu4YnOHK61KXDhKAl7cDDRc1fXH4Tf9gkHaGgD0DNS4dzVSsrnZYiMy1Bf2OK6IiUUjtEFRiYuDTgvVY3QxQcDJPP5Y7brvm9jonAufOC/C+a+NPJzooR1ij8/fXEntxOOB97hMDOy+vgcDtHyZYYexJ4SLGex+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698889; c=relaxed/simple;
	bh=5pzh1jnlwwA9Em+Y6wTDnBjl7V6dNef5GUMf7zI1GLE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSkRt/PeXQoSEvl8wug4sA0Y6tsVy2wuAg8xyzJi/C1A0kZahOpA0gzCfFQHivrUG1Y7D/aipr01QqRE2VB7acwLBsabbCz0QKi9hx2UtFowkbS2R8NCXkqFvQgFrympS//y3W9h6cAvCICr/kqpwT1HTqERY5VSbm85Awzwpxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJkSWxuE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7126cd1427bso3439605b3a.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 12:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724698885; x=1725303685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TXnelMr6rrH0phtkUrPGIGDs7CuVBOiscpcXdmibBkw=;
        b=aJkSWxuE4PaX3gTJsfYFswSpVcL1MQ8dt2nqkMLKqgTfqyl5VyUgZX9cHkhJJhkHHU
         iIkuDcn8bj21zWkntGYNiptGsWrv4/jrecSFcHWH64BDc4icI9Uyv0phJVj+Annlw/ds
         uJ8Up/bELZqaCNmvpec4pfYWm70nP/stad0TXWmt4nfHITBfMgoCMJt2+ft81kK19F2E
         RYNkNSoXF3Xz3EgdUaaFxv1kYVBun3Ny2MAO0TZauXrs87DSshVzwKhytcCmTp1jZGrR
         tUzTkkB9F4CLPIx13dtIwYjcTmPgC+ofa64kXso3mk9WyPoHHS8y3POXOoCU7frKWUsz
         uEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724698885; x=1725303685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXnelMr6rrH0phtkUrPGIGDs7CuVBOiscpcXdmibBkw=;
        b=Xov+rRExoZA55ly7EuLM9fV3i6/HcjRco7157BEZEj5BZuKVacfCKeBRkt1j+slDhr
         sqzLoAlByjDV7g5f0wkZZ4Tcs7TwYsbKV0pAkgKuQOZ6wXr82maXFamMTUw1yk/JfkyE
         LXK4IrXtMp7+N96Y8cdFiuqlJjLMfJcH500K67BaG8nFdmQW4Ef5MgWKTXfKJ85R6IwC
         MEkHy5GFliFQ4r4cVHH11mqja7vQzHhEaoWKc3JHnem6/i55X63Ok6MeUJJSjmER3JNf
         gbmjxgHsCr2QH1QIo9+dXdSzKyzkowFP06XLvLPVSkKnBKv3JwtJ4SahEoBP5jC/pysR
         1IYg==
X-Gm-Message-State: AOJu0YxMGMQd111ac0tUgamtkKd3/eb9WlUKpY7/PWqPxJDJMjXw/nSw
	4J5PajA+Wi+29b/YKdKl2WyFCtd+Fi16aJUnXIq0Bc+ju4e9cLE3vkvLgjDy5S/XROUamaiV+ir
	Y8g==
X-Google-Smtp-Source: AGHT+IGb4I7jigmHAiACVzpst0DDpqYAkTDQU+DJyfQKe7DYzYqIro7TguzJgGBRfwkSFKfPUZjAx+0PG0Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9192:b0:714:200c:39a2 with SMTP id
 d2e1a72fcca58-71445b4f5d9mr33897b3a.6.1724698884334; Mon, 26 Aug 2024
 12:01:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 26 Aug 2024 12:01:15 -0700
In-Reply-To: <20240826190116.145945-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826190116.145945-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826190116.145945-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: selftests: Use canonical $(ARCH) paths for KVM
 selftests directories
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

Use the kernel's canonical $(ARCH) paths instead of the raw target triple
for KVM selftests directories.  KVM selftests are quite nearly the only
place in the entire kernel that using the target triple for directories,
tools/testing/selftests/drivers/s390x being the lone holdout.

Using the kernel's preferred nomenclature eliminates the minor, but
annoying, friction of having to translate to KVM's selftests directories,
e.g. for pattern matching, opening files, running selftests, etc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS                                   |  12 +-
 tools/testing/selftests/kvm/Makefile          |  10 +-
 tools/testing/selftests/kvm/Makefile.kvm      | 302 +++++++++---------
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
 141 files changed, 159 insertions(+), 167 deletions(-)
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

diff --git a/MAINTAINERS b/MAINTAINERS
index f328373463b0..74d5ae68509b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12281,8 +12281,8 @@ F:	arch/arm64/include/asm/kvm*
 F:	arch/arm64/include/uapi/asm/kvm*
 F:	arch/arm64/kvm/
 F:	include/kvm/arm_*
-F:	tools/testing/selftests/kvm/*/aarch64/
-F:	tools/testing/selftests/kvm/aarch64/
+F:	tools/testing/selftests/kvm/*/arm64/
+F:	tools/testing/selftests/kvm/arm64/
 
 KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
 M:	Tianrui Zhao <zhaotianrui@loongson.cn>
@@ -12352,8 +12352,8 @@ F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
 F:	drivers/s390/char/uvdevice.c
 F:	tools/testing/selftests/drivers/s390x/uvdevice/
-F:	tools/testing/selftests/kvm/*/s390x/
-F:	tools/testing/selftests/kvm/s390x/
+F:	tools/testing/selftests/kvm/*/s390/
+F:	tools/testing/selftests/kvm/s390/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Sean Christopherson <seanjc@google.com>
@@ -12370,8 +12370,8 @@ F:	arch/x86/include/uapi/asm/svm.h
 F:	arch/x86/include/uapi/asm/vmx.h
 F:	arch/x86/kvm/
 F:	arch/x86/kvm/*/
-F:	tools/testing/selftests/kvm/*/x86_64/
-F:	tools/testing/selftests/kvm/x86_64/
+F:	tools/testing/selftests/kvm/*/x86/
+F:	tools/testing/selftests/kvm/x86/
 
 KERNFS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 787b63b52db7..a9c1d85905d8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -4,16 +4,12 @@ include $(top_srcdir)/scripts/subarch.include
 ARCH            ?= $(SUBARCH)
 
 ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
-ifeq ($(ARCH),x86)
-	ARCH_DIR := x86_64
-else ifeq ($(ARCH),arm64)
-	ARCH_DIR := aarch64
-else ifeq ($(ARCH),s390)
-	ARCH_DIR := s390x
+# Top-level selftests allows ARCH=x86_64 :-(
+ifeq ($(ARCH),x86_64)
+	ARCH_DIR := x86
 else
 	ARCH_DIR := $(ARCH)
 endif
-
 include Makefile.kvm
 else
 # Empty targets for unsupported architectures
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 802d05eee674..27f4e100c6ac 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -18,168 +18,168 @@ LIBKVM += lib/userfaultfd_util.c
 
 LIBKVM_STRING += lib/string_override.c
 
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
+LIBKVM_x86 += lib/x86/apic.c
+LIBKVM_x86 += lib/x86/handlers.S
+LIBKVM_x86 += lib/x86/hyperv.c
+LIBKVM_x86 += lib/x86/memstress.c
+LIBKVM_x86 += lib/x86/pmu.c
+LIBKVM_x86 += lib/x86/processor.c
+LIBKVM_x86 += lib/x86/sev.c
+LIBKVM_x86 += lib/x86/svm.c
+LIBKVM_x86 += lib/x86/ucall.c
+LIBKVM_x86 += lib/x86/vmx.c
 
-LIBKVM_aarch64 += lib/aarch64/gic.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3_its.c
-LIBKVM_aarch64 += lib/aarch64/handlers.S
-LIBKVM_aarch64 += lib/aarch64/processor.c
-LIBKVM_aarch64 += lib/aarch64/spinlock.c
-LIBKVM_aarch64 += lib/aarch64/ucall.c
-LIBKVM_aarch64 += lib/aarch64/vgic.c
+LIBKVM_arm64 += lib/arm64/gic.c
+LIBKVM_arm64 += lib/arm64/gic_v3.c
+LIBKVM_arm64 += lib/arm64/gic_v3_its.c
+LIBKVM_arm64 += lib/arm64/handlers.S
+LIBKVM_arm64 += lib/arm64/processor.c
+LIBKVM_arm64 += lib/arm64/spinlock.c
+LIBKVM_arm64 += lib/arm64/ucall.c
+LIBKVM_arm64 += lib/arm64/vgic.c
 
-LIBKVM_s390x += lib/s390x/diag318_test_handler.c
-LIBKVM_s390x += lib/s390x/processor.c
-LIBKVM_s390x += lib/s390x/ucall.c
+LIBKVM_s390 += lib/s390/diag318_test_handler.c
+LIBKVM_s390 += lib/s390/processor.c
+LIBKVM_s390 += lib/s390/ucall.c
 
 LIBKVM_riscv += lib/riscv/handlers.S
 LIBKVM_riscv += lib/riscv/processor.c
 LIBKVM_riscv += lib/riscv/ucall.c
 
 # Non-compiled test targets
-TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
+TEST_PROGS_x86 += x86/nx_huge_pages_test.sh
 
 # Compiled test targets
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
+TEST_GEN_PROGS_x86 = x86/cpuid_test
+TEST_GEN_PROGS_x86 += x86/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86 += x86/dirty_log_page_splitting_test
+TEST_GEN_PROGS_x86 += x86/get_msr_index_features
+TEST_GEN_PROGS_x86 += x86/exit_on_emulation_failure_test
+TEST_GEN_PROGS_x86 += x86/fix_hypercall_test
+TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
+TEST_GEN_PROGS_x86 += x86/hyperv_clock
+TEST_GEN_PROGS_x86 += x86/hyperv_cpuid
+TEST_GEN_PROGS_x86 += x86/hyperv_evmcs
+TEST_GEN_PROGS_x86 += x86/hyperv_extended_hypercalls
+TEST_GEN_PROGS_x86 += x86/hyperv_features
+TEST_GEN_PROGS_x86 += x86/hyperv_ipi
+TEST_GEN_PROGS_x86 += x86/hyperv_svm_test
+TEST_GEN_PROGS_x86 += x86/hyperv_tlb_flush
+TEST_GEN_PROGS_x86 += x86/kvm_clock_test
+TEST_GEN_PROGS_x86 += x86/kvm_pv_test
+TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
+TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
+TEST_GEN_PROGS_x86 += x86/platform_info_test
+TEST_GEN_PROGS_x86 += x86/pmu_counters_test
+TEST_GEN_PROGS_x86 += x86/pmu_event_filter_test
+TEST_GEN_PROGS_x86 += x86/private_mem_conversions_test
+TEST_GEN_PROGS_x86 += x86/private_mem_kvm_exits_test
+TEST_GEN_PROGS_x86 += x86/set_boot_cpu_id
+TEST_GEN_PROGS_x86 += x86/set_sregs_test
+TEST_GEN_PROGS_x86 += x86/smaller_maxphyaddr_emulation_test
+TEST_GEN_PROGS_x86 += x86/smm_test
+TEST_GEN_PROGS_x86 += x86/state_test
+TEST_GEN_PROGS_x86 += x86/vmx_preemption_timer_test
+TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
+TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
+TEST_GEN_PROGS_x86 += x86/sync_regs_test
+TEST_GEN_PROGS_x86 += x86/ucna_injection_test
+TEST_GEN_PROGS_x86 += x86/userspace_io_test
+TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
+TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
+TEST_GEN_PROGS_x86 += x86/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
+TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
+TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
+TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
+TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
+TEST_GEN_PROGS_x86 += x86/xapic_ipi_test
+TEST_GEN_PROGS_x86 += x86/xapic_state_test
+TEST_GEN_PROGS_x86 += x86/xcr0_cpuid_test
+TEST_GEN_PROGS_x86 += x86/xss_msr_test
+TEST_GEN_PROGS_x86 += x86/debug_regs
+TEST_GEN_PROGS_x86 += x86/tsc_msrs_test
+TEST_GEN_PROGS_x86 += x86/vmx_pmu_caps_test
+TEST_GEN_PROGS_x86 += x86/xen_shinfo_test
+TEST_GEN_PROGS_x86 += x86/xen_vmcall_test
+TEST_GEN_PROGS_x86 += x86/sev_init2_tests
+TEST_GEN_PROGS_x86 += x86/sev_migrate_tests
+TEST_GEN_PROGS_x86 += x86/sev_smoke_test
+TEST_GEN_PROGS_x86 += x86/amx_test
+TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
+TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
+TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
+TEST_GEN_PROGS_x86 += access_tracking_perf_test
+TEST_GEN_PROGS_x86 += demand_paging_test
+TEST_GEN_PROGS_x86 += dirty_log_test
+TEST_GEN_PROGS_x86 += dirty_log_perf_test
+TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_print_test
+TEST_GEN_PROGS_x86 += hardware_disable_test
+TEST_GEN_PROGS_x86 += kvm_create_max_vcpus
+TEST_GEN_PROGS_x86 += kvm_page_table_test
+TEST_GEN_PROGS_x86 += max_guest_memory_test
+TEST_GEN_PROGS_x86 += memslot_modification_stress_test
+TEST_GEN_PROGS_x86 += memslot_perf_test
+TEST_GEN_PROGS_x86 += rseq_test
+TEST_GEN_PROGS_x86 += set_memory_region_test
+TEST_GEN_PROGS_x86 += steal_time
+TEST_GEN_PROGS_x86 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86 += system_counter_offset_test
+TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
-TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
+TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
 
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
+TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
+TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
+TEST_GEN_PROGS_arm64 += arm64/hypercalls
+TEST_GEN_PROGS_arm64 += arm64/page_fault_test
+TEST_GEN_PROGS_arm64 += arm64/psci_test
+TEST_GEN_PROGS_arm64 += arm64/set_id_regs
+TEST_GEN_PROGS_arm64 += arm64/smccc_filter
+TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
+TEST_GEN_PROGS_arm64 += arm64/vgic_init
+TEST_GEN_PROGS_arm64 += arm64/vgic_irq
+TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
+TEST_GEN_PROGS_arm64 += access_tracking_perf_test
+TEST_GEN_PROGS_arm64 += arch_timer
+TEST_GEN_PROGS_arm64 += demand_paging_test
+TEST_GEN_PROGS_arm64 += dirty_log_test
+TEST_GEN_PROGS_arm64 += dirty_log_perf_test
+TEST_GEN_PROGS_arm64 += guest_print_test
+TEST_GEN_PROGS_arm64 += get-reg-list
+TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_arm64 += kvm_page_table_test
+TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
+TEST_GEN_PROGS_arm64 += memslot_perf_test
+TEST_GEN_PROGS_arm64 += rseq_test
+TEST_GEN_PROGS_arm64 += set_memory_region_test
+TEST_GEN_PROGS_arm64 += steal_time
+TEST_GEN_PROGS_arm64 += kvm_binary_stats_test
 
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
+TEST_GEN_PROGS_s390 = s390/memop
+TEST_GEN_PROGS_s390 += s390/resets
+TEST_GEN_PROGS_s390 += s390/sync_regs_test
+TEST_GEN_PROGS_s390 += s390/tprot
+TEST_GEN_PROGS_s390 += s390/cmma_test
+TEST_GEN_PROGS_s390 += s390/debug_test
+TEST_GEN_PROGS_s390 += s390/shared_zeropage_test
+TEST_GEN_PROGS_s390 += demand_paging_test
+TEST_GEN_PROGS_s390 += dirty_log_test
+TEST_GEN_PROGS_s390 += guest_print_test
+TEST_GEN_PROGS_s390 += kvm_create_max_vcpus
+TEST_GEN_PROGS_s390 += kvm_page_table_test
+TEST_GEN_PROGS_s390 += rseq_test
+TEST_GEN_PROGS_s390 += set_memory_region_test
+TEST_GEN_PROGS_s390 += kvm_binary_stats_test
 
 TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
 TEST_GEN_PROGS_riscv += riscv/ebreak_test
@@ -212,11 +212,7 @@ include ../lib.mk
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-ifeq ($(ARCH),x86_64)
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
-else
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
-endif
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH_DIR)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
rename to tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/arch_timer.c
rename to tools/testing/selftests/kvm/arm64/arch_timer.c
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/debug-exceptions.c
rename to tools/testing/selftests/kvm/arm64/debug-exceptions.c
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/get-reg-list.c
rename to tools/testing/selftests/kvm/arm64/get-reg-list.c
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/hypercalls.c
rename to tools/testing/selftests/kvm/arm64/hypercalls.c
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/page_fault_test.c
rename to tools/testing/selftests/kvm/arm64/page_fault_test.c
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_test.c
rename to tools/testing/selftests/kvm/arm64/psci_test.c
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/set_id_regs.c
rename to tools/testing/selftests/kvm/arm64/set_id_regs.c
diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/smccc_filter.c
rename to tools/testing/selftests/kvm/arm64/smccc_filter.c
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/arm64/vcpu_width_config.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
rename to tools/testing/selftests/kvm/arm64/vcpu_width_config.c
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/vgic_init.c
rename to tools/testing/selftests/kvm/arm64/vgic_init.c
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/vgic_irq.c
rename to tools/testing/selftests/kvm/arm64/vgic_irq.c
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
rename to tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
rename to tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 9f24303acb8c..e79817bd0e29 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -21,7 +21,7 @@
 #include "ucall_common.h"
 
 #ifdef __aarch64__
-#include "aarch64/vgic.h"
+#include "arm64/vgic.h"
 
 static int gic_fd;
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/arch_timer.h
rename to tools/testing/selftests/kvm/include/arm64/arch_timer.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/delay.h b/tools/testing/selftests/kvm/include/arm64/delay.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/delay.h
rename to tools/testing/selftests/kvm/include/arm64/delay.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/gic.h
rename to tools/testing/selftests/kvm/include/arm64/gic.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3.h b/tools/testing/selftests/kvm/include/arm64/gic_v3.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/gic_v3.h
rename to tools/testing/selftests/kvm/include/arm64/gic_v3.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
rename to tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
rename to tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/processor.h
rename to tools/testing/selftests/kvm/include/arm64/processor.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/arm64/spinlock.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/spinlock.h
rename to tools/testing/selftests/kvm/include/arm64/spinlock.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/ucall.h b/tools/testing/selftests/kvm/include/arm64/ucall.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/ucall.h
rename to tools/testing/selftests/kvm/include/arm64/ucall.h
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/arm64/vgic.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/aarch64/vgic.h
rename to tools/testing/selftests/kvm/include/arm64/vgic.h
diff --git a/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h b/tools/testing/selftests/kvm/include/s390/diag318_test_handler.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
rename to tools/testing/selftests/kvm/include/s390/diag318_test_handler.h
diff --git a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
rename to tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390/processor.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/s390x/processor.h
rename to tools/testing/selftests/kvm/include/s390/processor.h
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/s390x/ucall.h
rename to tools/testing/selftests/kvm/include/s390/ucall.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/apic.h
rename to tools/testing/selftests/kvm/include/x86/apic.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86/evmcs.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/evmcs.h
rename to tools/testing/selftests/kvm/include/x86/evmcs.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86/hyperv.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/hyperv.h
rename to tools/testing/selftests/kvm/include/x86/hyperv.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
rename to tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/mce.h b/tools/testing/selftests/kvm/include/x86/mce.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/mce.h
rename to tools/testing/selftests/kvm/include/x86/mce.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/pmu.h
rename to tools/testing/selftests/kvm/include/x86/pmu.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/processor.h
rename to tools/testing/selftests/kvm/include/x86/processor.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/sev.h
rename to tools/testing/selftests/kvm/include/x86/sev.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/svm.h
rename to tools/testing/selftests/kvm/include/x86/svm.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/svm_util.h
rename to tools/testing/selftests/kvm/include/x86/svm_util.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/ucall.h b/tools/testing/selftests/kvm/include/x86/ucall.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/ucall.h
rename to tools/testing/selftests/kvm/include/x86/ucall.h
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/x86_64/vmx.h
rename to tools/testing/selftests/kvm/include/x86/vmx.h
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/arm64/gic.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic.c
rename to tools/testing/selftests/kvm/lib/arm64/gic.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic_private.h
rename to tools/testing/selftests/kvm/lib/arm64/gic_private.h
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
rename to tools/testing/selftests/kvm/lib/arm64/gic_v3.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
rename to tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/arm64/handlers.S
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/handlers.S
rename to tools/testing/selftests/kvm/lib/arm64/handlers.S
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/processor.c
rename to tools/testing/selftests/kvm/lib/arm64/processor.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/arm64/spinlock.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/spinlock.c
rename to tools/testing/selftests/kvm/lib/arm64/spinlock.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/ucall.c
rename to tools/testing/selftests/kvm/lib/arm64/ucall.c
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/vgic.c
rename to tools/testing/selftests/kvm/lib/arm64/vgic.c
diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
rename to tools/testing/selftests/kvm/lib/s390/diag318_test_handler.c
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/s390x/processor.c
rename to tools/testing/selftests/kvm/lib/s390/processor.c
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390/ucall.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/s390x/ucall.c
rename to tools/testing/selftests/kvm/lib/s390/ucall.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/apic.c b/tools/testing/selftests/kvm/lib/x86/apic.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/apic.c
rename to tools/testing/selftests/kvm/lib/x86/apic.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/handlers.S b/tools/testing/selftests/kvm/lib/x86/handlers.S
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/handlers.S
rename to tools/testing/selftests/kvm/lib/x86/handlers.S
diff --git a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c b/tools/testing/selftests/kvm/lib/x86/hyperv.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/hyperv.c
rename to tools/testing/selftests/kvm/lib/x86/hyperv.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/memstress.c
rename to tools/testing/selftests/kvm/lib/x86/memstress.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/pmu.c
rename to tools/testing/selftests/kvm/lib/x86/pmu.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/processor.c
rename to tools/testing/selftests/kvm/lib/x86/processor.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/sev.c
rename to tools/testing/selftests/kvm/lib/x86/sev.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/svm.c
rename to tools/testing/selftests/kvm/lib/x86/svm.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86/ucall.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/ucall.c
rename to tools/testing/selftests/kvm/lib/x86/ucall.c
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/x86_64/vmx.c
rename to tools/testing/selftests/kvm/lib/x86/vmx.c
diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390/cmma_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/cmma_test.c
rename to tools/testing/selftests/kvm/s390/cmma_test.c
diff --git a/tools/testing/selftests/kvm/s390x/debug_test.c b/tools/testing/selftests/kvm/s390/debug_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/debug_test.c
rename to tools/testing/selftests/kvm/s390/debug_test.c
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390/memop.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/memop.c
rename to tools/testing/selftests/kvm/s390/memop.c
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390/resets.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/resets.c
rename to tools/testing/selftests/kvm/s390/resets.c
diff --git a/tools/testing/selftests/kvm/s390x/shared_zeropage_test.c b/tools/testing/selftests/kvm/s390/shared_zeropage_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/shared_zeropage_test.c
rename to tools/testing/selftests/kvm/s390/shared_zeropage_test.c
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390/sync_regs_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/sync_regs_test.c
rename to tools/testing/selftests/kvm/s390/sync_regs_test.c
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
similarity index 100%
rename from tools/testing/selftests/kvm/s390x/tprot.c
rename to tools/testing/selftests/kvm/s390/tprot.c
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/amx_test.c
rename to tools/testing/selftests/kvm/x86/amx_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
rename to tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/cpuid_test.c
rename to tools/testing/selftests/kvm/x86/cpuid_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86/cr4_cpuid_sync_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
rename to tools/testing/selftests/kvm/x86/cr4_cpuid_sync_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86/debug_regs.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/debug_regs.c
rename to tools/testing/selftests/kvm/x86/debug_regs.c
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
rename to tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c b/tools/testing/selftests/kvm/x86/exit_on_emulation_failure_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
rename to tools/testing/selftests/kvm/x86/exit_on_emulation_failure_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
rename to tools/testing/selftests/kvm/x86/fix_hypercall_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86/flds_emulation.h
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/flds_emulation.h
rename to tools/testing/selftests/kvm/x86/flds_emulation.h
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86/get_msr_index_features.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
rename to tools/testing/selftests/kvm/x86/get_msr_index_features.c
diff --git a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c b/tools/testing/selftests/kvm/x86/hwcr_msr_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
rename to tools/testing/selftests/kvm/x86/hwcr_msr_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_clock.c
rename to tools/testing/selftests/kvm/x86/hyperv_clock.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86/hyperv_cpuid.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
rename to tools/testing/selftests/kvm/x86/hyperv_cpuid.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
rename to tools/testing/selftests/kvm/x86/hyperv_evmcs.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
rename to tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_features.c
rename to tools/testing/selftests/kvm/x86/hyperv_features.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
rename to tools/testing/selftests/kvm/x86/hyperv_ipi.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
rename to tools/testing/selftests/kvm/x86/hyperv_svm_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
rename to tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
rename to tools/testing/selftests/kvm/x86/kvm_clock_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
rename to tools/testing/selftests/kvm/x86/kvm_pv_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86/max_vcpuid_cap_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
rename to tools/testing/selftests/kvm/x86/max_vcpuid_cap_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
rename to tools/testing/selftests/kvm/x86/monitor_mwait_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
rename to tools/testing/selftests/kvm/x86/nested_exceptions_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
rename to tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.sh
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
rename to tools/testing/selftests/kvm/x86/nx_huge_pages_test.sh
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86/platform_info_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/platform_info_test.c
rename to tools/testing/selftests/kvm/x86/platform_info_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
rename to tools/testing/selftests/kvm/x86/pmu_counters_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
rename to tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
rename to tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
rename to tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c b/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
rename to tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86/set_boot_cpu_id.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
rename to tools/testing/selftests/kvm/x86/set_boot_cpu_id.c
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86/set_sregs_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/set_sregs_test.c
rename to tools/testing/selftests/kvm/x86/set_sregs_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
rename to tools/testing/selftests/kvm/x86/sev_init2_tests.c
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
rename to tools/testing/selftests/kvm/x86/sev_migrate_tests.c
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
rename to tools/testing/selftests/kvm/x86/sev_smoke_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
rename to tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86/smm_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/smm_test.c
rename to tools/testing/selftests/kvm/x86/smm_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/state_test.c
rename to tools/testing/selftests/kvm/x86/state_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
rename to tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
rename to tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
rename to tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
rename to tools/testing/selftests/kvm/x86/svm_vmcall_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86/sync_regs_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/sync_regs_test.c
rename to tools/testing/selftests/kvm/x86/sync_regs_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
rename to tools/testing/selftests/kvm/x86/triple_fault_event_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86/tsc_msrs_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
rename to tools/testing/selftests/kvm/x86/tsc_msrs_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
rename to tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
rename to tools/testing/selftests/kvm/x86/ucna_injection_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86/userspace_io_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/userspace_io_test.c
rename to tools/testing/selftests/kvm/x86/userspace_io_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
rename to tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
rename to tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
rename to tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
rename to tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
rename to tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
rename to tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
rename to tools/testing/selftests/kvm/x86/vmx_msrs_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
rename to tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
rename to tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
rename to tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
rename to tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
rename to tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
rename to tools/testing/selftests/kvm/x86/xapic_ipi_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xapic_state_test.c
rename to tools/testing/selftests/kvm/x86/xapic_state_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
rename to tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
rename to tools/testing/selftests/kvm/x86/xen_shinfo_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86/xen_vmcall_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
rename to tools/testing/selftests/kvm/x86/xen_vmcall_test.c
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86/xss_msr_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/xss_msr_test.c
rename to tools/testing/selftests/kvm/x86/xss_msr_test.c
-- 
2.46.0.295.g3b9ea8a38a-goog


