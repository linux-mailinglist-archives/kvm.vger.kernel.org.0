Return-Path: <kvm+bounces-71374-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJ56F9Kul2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71374-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FF9163F7F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ABFF3019530
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9F521C175;
	Fri, 20 Feb 2026 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sf3Mv/y0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DD10F1
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548157; cv=none; b=nEc7LNqFOP94vRSxTAuyTlFyEra31EjNi3v+l53fdg+kxtrLAacg+DHB+7Lo6NyHKNGV2rCQFPYu5H0dpR/wT7sTdVJ8goXdkMBJka/bKw1t65bs+K4T5vS+0roQp9Nzew3y7MKUb8Q+HQPO+lPvQu0v3IX+pFXpx8UWKX/1cr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548157; c=relaxed/simple;
	bh=Ud4lqyOYJxLqwMF4L6RwgtA92lV9p1IYKw7lMroz3mw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wc5WlXRpK577ykyjwef/tEruA/l/CIM/KZkjmwJDxfe6xtesO2oXxp52Mtq8LC91UUln2EJAaC9s9Z8wus9dVF1mKpSxxriQQaIBzIGp9miFzUjCnq213rYWszI8cZ4Q4X2IZNZ6Wk8d9IFOd7hidqvXFvm1tLNDx/X4geYGpes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sf3Mv/y0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ab0b2e804cso17962765ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548154; x=1772152954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dg8JwpDSolSLBMhrmXm5uOOceqMFfere5VVKNjBSeNo=;
        b=Sf3Mv/y0bzkthFRVzY+IO27t7ytQQhH1hDac9Xuyomd17XSwfyYpq2a5JQM5Waq+sM
         iLU4vn9I1PXdpapnKjlgZIxMYXuYnUadc+XMlj/9iQX01H8XCfI5pGAuMkHErTq7QSC2
         SykYGKRi/UKrisNKDfOY/jEyMYaD8pONg7zUXj7QuilLcGbky90kPyo3OHoSLkGpDzJO
         w0ZP/z15thoB4OkbfoDuqeYIll1vVMtqnEi+Phh1PZclQhAgxyWC7A3rxi8VvDTYFG8j
         wAEL/v6uxmgX7L1djof/grOAKxO8PWq5lari8iOQ//zstqgk3G5H2SV7tJNO9pWij/S9
         sYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548154; x=1772152954;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dg8JwpDSolSLBMhrmXm5uOOceqMFfere5VVKNjBSeNo=;
        b=KeaH4w5sUBBcbf9l32VFPntRBzkWUsukWmsaIyiTH/+IsIItPXDMED1V5gi71oAMIm
         2MCjPyf9vopXMMp57I5CSOz0JU1pD87hvbIdTQV3+XbczQQobewf3ev3Bt7eLfJFf1fc
         RYvfmsbNyjz7hAkFY2+ggl285x+OcRDQZ/zdeX6r8rh/p+t8G8NKL5NQ2xNzdDm2hrx7
         aIJxJy4l+BGixKI8nu0qI2g6r6OhXf9FTkeRA26wO3gxRGAPySm/CdlhOfHuDRbhNI/c
         G+bjQ8KGHA6ku5reaQE07x7pwYAvk3lV5R5ZSrSZ3hyGRV5FFR/8spReFHDxMyrxkLq/
         z+5A==
X-Forwarded-Encrypted: i=1; AJvYcCUIvf4oIFLG/zo2HfRczvt8ARe3j7xA7p35dwxkU9Ux0o/fIa5Gh2Kzq3yGyhKQNHzPf9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAMEUF2/P9tRlRb3skDeZNPZL84YVn5TWe8mmkadlNDoG8R6wC
	ZtJcVdsbc/65fZqsU+CtqNMrC0/HnKjUZLPcgW2tnxvo00cXy1cFwWXu4o+3Ib8Yfwc86RjQgv4
	KOHed/Q0onv9t6A==
X-Received: from pjbsz4.prod.google.com ([2002:a17:90b:2d44:b0:354:aa76:8270])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:190d:b0:29e:c2de:4ad with SMTP id d9443c01a7336-2ad5b03d9eamr38042765ad.24.1771548154020;
 Thu, 19 Feb 2026 16:42:34 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-1-dmatlack@google.com>
Subject: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71374-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,redhat.com,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 06FF9163F7F
X-Rspamd-Action: no action

This series renames types across all KVM selftests to more align with
types used in the kernel:

  vm_vaddr_t -> gva_t
  vm_paddr_t -> gpa_t

  uint64_t -> u64
  uint32_t -> u32
  uint16_t -> u16
  uint8_t  -> u8

  int64_t -> s64
  int32_t -> s32
  int16_t -> s16
  int8_t  -> s8

The goal of this series is to make the KVM selftests code more concise
(the new type names are shorter) and more similar to the kernel, since
selftests are developed by kernel developers.

v2:
 - Reapply the series on top of kvm/queue

v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@google.com/

David Matlack (10):
  KVM: selftests: Use gva_t instead of vm_vaddr_t
  KVM: selftests: Use gpa_t instead of vm_paddr_t
  KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
  KVM: selftests: Use u64 instead of uint64_t
  KVM: selftests: Use s64 instead of int64_t
  KVM: selftests: Use u32 instead of uint32_t
  KVM: selftests: Use s32 instead of int32_t
  KVM: selftests: Use u16 instead of uint16_t
  KVM: selftests: Use s16 instead of int16_t
  KVM: selftests: Use u8 instead of uint8_t

 .../selftests/kvm/access_tracking_perf_test.c |  42 +--
 tools/testing/selftests/kvm/arch_timer.c      |   6 +-
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  14 +-
 .../testing/selftests/kvm/arm64/arch_timer.c  |   8 +-
 .../kvm/arm64/arch_timer_edge_cases.c         | 161 +++++----
 .../selftests/kvm/arm64/debug-exceptions.c    |  72 ++--
 .../testing/selftests/kvm/arm64/hypercalls.c  |  24 +-
 .../testing/selftests/kvm/arm64/idreg-idst.c  |   4 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |   6 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  82 ++---
 tools/testing/selftests/kvm/arm64/psci_test.c |  26 +-
 .../testing/selftests/kvm/arm64/sea_to_user.c |  32 +-
 .../testing/selftests/kvm/arm64/set_id_regs.c |  66 ++--
 .../selftests/kvm/arm64/smccc_filter.c        |  10 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c |  56 +--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  | 137 ++++----
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  20 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |  56 +--
 .../testing/selftests/kvm/coalesced_io_test.c |  38 +-
 .../selftests/kvm/demand_paging_test.c        |  10 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  14 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  82 ++---
 tools/testing/selftests/kvm/get-reg-list.c    |   2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  16 +-
 .../testing/selftests/kvm/guest_print_test.c  |  22 +-
 .../selftests/kvm/hardware_disable_test.c     |   6 +-
 .../selftests/kvm/include/arm64/arch_timer.h  |  30 +-
 .../selftests/kvm/include/arm64/delay.h       |   4 +-
 .../testing/selftests/kvm/include/arm64/gic.h |   8 +-
 .../selftests/kvm/include/arm64/gic_v3_its.h  |   8 +-
 .../selftests/kvm/include/arm64/processor.h   |  22 +-
 .../selftests/kvm/include/arm64/ucall.h       |   4 +-
 .../selftests/kvm/include/arm64/vgic.h        |  22 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 328 +++++++++---------
 .../selftests/kvm/include/kvm_util_types.h    |   4 +-
 .../kvm/include/loongarch/arch_timer.h        |   4 +-
 .../selftests/kvm/include/loongarch/ucall.h   |   4 +-
 .../testing/selftests/kvm/include/memstress.h |  30 +-
 .../selftests/kvm/include/riscv/arch_timer.h  |  22 +-
 .../selftests/kvm/include/riscv/processor.h   |   9 +-
 .../selftests/kvm/include/riscv/ucall.h       |   4 +-
 .../kvm/include/s390/diag318_test_handler.h   |   2 +-
 .../selftests/kvm/include/s390/facility.h     |   4 +-
 .../selftests/kvm/include/s390/ucall.h        |   4 +-
 .../testing/selftests/kvm/include/sparsebit.h |   6 +-
 .../testing/selftests/kvm/include/test_util.h |  40 ++-
 .../selftests/kvm/include/timer_test.h        |  18 +-
 .../selftests/kvm/include/ucall_common.h      |  22 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   6 +-
 .../testing/selftests/kvm/include/x86/apic.h  |  22 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |  22 +-
 .../selftests/kvm/include/x86/hyperv.h        |  28 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |  36 +-
 tools/testing/selftests/kvm/include/x86/pmu.h |   9 +-
 .../selftests/kvm/include/x86/processor.h     | 282 ++++++++-------
 tools/testing/selftests/kvm/include/x86/sev.h |  20 +-
 .../selftests/kvm/include/x86/svm_util.h      |  12 +-
 .../testing/selftests/kvm/include/x86/ucall.h |   2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  70 ++--
 .../selftests/kvm/kvm_page_table_test.c       |  54 +--
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   6 +-
 .../selftests/kvm/lib/arm64/gic_private.h     |  26 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  90 ++---
 .../selftests/kvm/lib/arm64/gic_v3_its.c      |  12 +-
 .../selftests/kvm/lib/arm64/processor.c       | 126 +++----
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  12 +-
 tools/testing/selftests/kvm/lib/arm64/vgic.c  |  40 +--
 tools/testing/selftests/kvm/lib/elf.c         |   8 +-
 tools/testing/selftests/kvm/lib/guest_modes.c |   2 +-
 .../testing/selftests/kvm/lib/guest_sprintf.c |  18 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 220 ++++++------
 .../selftests/kvm/lib/loongarch/processor.c   |  79 +++--
 .../selftests/kvm/lib/loongarch/ucall.c       |  12 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  38 +-
 .../selftests/kvm/lib/riscv/processor.c       |  58 ++--
 .../kvm/lib/s390/diag318_test_handler.c       |  12 +-
 .../testing/selftests/kvm/lib/s390/facility.c |   2 +-
 .../selftests/kvm/lib/s390/processor.c        |  42 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  18 +-
 tools/testing/selftests/kvm/lib/test_util.c   |  30 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  30 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  14 +-
 tools/testing/selftests/kvm/lib/x86/apic.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |  14 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |  14 +-
 tools/testing/selftests/kvm/lib/x86/pmu.c     |   8 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 199 ++++++-----
 tools/testing/selftests/kvm/lib/x86/sev.c     |  20 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |  16 +-
 tools/testing/selftests/kvm/lib/x86/ucall.c   |   4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  44 +--
 .../selftests/kvm/loongarch/arch_timer.c      |  28 +-
 .../kvm/memslot_modification_stress_test.c    |  10 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 164 ++++-----
 tools/testing/selftests/kvm/mmu_stress_test.c |  28 +-
 .../selftests/kvm/pre_fault_memory_test.c     |  10 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   8 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   6 +-
 .../selftests/kvm/riscv/get-reg-list.c        |   4 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   8 +-
 tools/testing/selftests/kvm/s390/debug_test.c |   8 +-
 tools/testing/selftests/kvm/s390/memop.c      |  94 ++---
 tools/testing/selftests/kvm/s390/resets.c     |   6 +-
 .../selftests/kvm/s390/shared_zeropage_test.c |   2 +-
 tools/testing/selftests/kvm/s390/tprot.c      |  24 +-
 .../selftests/kvm/s390/ucontrol_test.c        |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |  40 +--
 tools/testing/selftests/kvm/steal_time.c      |  66 ++--
 .../kvm/system_counter_offset_test.c          |  12 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  14 +-
 .../selftests/kvm/x86/aperfmperf_test.c       |  16 +-
 .../selftests/kvm/x86/apic_bus_clock_test.c   |  24 +-
 tools/testing/selftests/kvm/x86/cpuid_test.c  |   6 +-
 tools/testing/selftests/kvm/x86/debug_regs.c  |   4 +-
 .../kvm/x86/dirty_log_page_splitting_test.c   |  16 +-
 .../testing/selftests/kvm/x86/fastops_test.c  |  52 +--
 .../selftests/kvm/x86/feature_msrs_test.c     |  12 +-
 .../selftests/kvm/x86/fix_hypercall_test.c    |  20 +-
 .../selftests/kvm/x86/flds_emulation.h        |   6 +-
 .../testing/selftests/kvm/x86/hwcr_msr_test.c |  10 +-
 .../testing/selftests/kvm/x86/hyperv_clock.c  |   6 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |  10 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  20 +-
 .../selftests/kvm/x86/hyperv_features.c       |  26 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  12 +-
 .../selftests/kvm/x86/hyperv_svm_test.c       |  10 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  36 +-
 .../selftests/kvm/x86/kvm_buslock_test.c      |   2 +-
 .../selftests/kvm/x86/kvm_clock_test.c        |  14 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c |  10 +-
 .../selftests/kvm/x86/monitor_mwait_test.c    |   2 +-
 .../selftests/kvm/x86/nested_close_kvm_test.c |   2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c |  10 +-
 .../selftests/kvm/x86/nested_emulation_test.c |  20 +-
 .../kvm/x86/nested_exceptions_test.c          |   6 +-
 .../kvm/x86/nested_invalid_cr3_test.c         |   2 +-
 .../selftests/kvm/x86/nested_set_state_test.c |   4 +-
 .../kvm/x86/nested_tsc_adjust_test.c          |  12 +-
 .../kvm/x86/nested_tsc_scaling_test.c         |  26 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |   2 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |  18 +-
 .../selftests/kvm/x86/platform_info_test.c    |   6 +-
 .../selftests/kvm/x86/pmu_counters_test.c     | 110 +++---
 .../selftests/kvm/x86/pmu_event_filter_test.c | 102 +++---
 .../kvm/x86/private_mem_conversions_test.c    |  78 ++---
 .../kvm/x86/private_mem_kvm_exits_test.c      |  14 +-
 .../selftests/kvm/x86/set_boot_cpu_id.c       |   6 +-
 .../selftests/kvm/x86/set_sregs_test.c        |   6 +-
 .../selftests/kvm/x86/sev_init2_tests.c       |   6 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  16 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |   8 +-
 tools/testing/selftests/kvm/x86/smm_test.c    |   8 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  14 +-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |   2 +-
 .../kvm/x86/svm_nested_shutdown_test.c        |   2 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  10 +-
 .../selftests/kvm/x86/svm_vmcall_test.c       |   2 +-
 .../selftests/kvm/x86/sync_regs_test.c        |   2 +-
 .../kvm/x86/triple_fault_event_test.c         |   4 +-
 .../testing/selftests/kvm/x86/tsc_msrs_test.c |   2 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/ucna_injection_test.c   |  45 +--
 .../selftests/kvm/x86/userspace_io_test.c     |   4 +-
 .../kvm/x86/userspace_msr_exit_test.c         |  58 ++--
 .../selftests/kvm/x86/vmx_apic_access_test.c  |   4 +-
 .../kvm/x86/vmx_apicv_updates_test.c          |   4 +-
 .../kvm/x86/vmx_invalid_nested_guest_state.c  |   2 +-
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  22 +-
 .../kvm/x86/vmx_nested_la57_state_test.c      |   4 +-
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  12 +-
 .../kvm/x86/vmx_preemption_timer_test.c       |   2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  58 ++--
 .../selftests/kvm/x86/xapic_state_test.c      |  20 +-
 .../selftests/kvm/x86/xapic_tpr_test.c        |  24 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |   8 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  22 +-
 .../testing/selftests/kvm/x86/xss_msr_test.c  |   2 +-
 177 files changed, 2514 insertions(+), 2519 deletions(-)


base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
-- 
2.53.0.414.gf7e9f6c205-goog


