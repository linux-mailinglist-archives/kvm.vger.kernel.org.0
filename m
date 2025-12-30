Return-Path: <kvm+bounces-66871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74674CEAD05
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAA023025A7A
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CCB2D94B2;
	Tue, 30 Dec 2025 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QH0eCWBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD40222560
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135715; cv=none; b=BZmtcF9P6EkdhPrtyP7u5DB9PjchoydxwRM+PI2UTufK80EiRYQXkhI8srJ3gpwJTragirqy+UplA5fIucXTue17X+X7qeSosTybJjQAjDhNx9Xv6Iie2cfk6KOLuzxl53hflxeG6xQeUzCCAZDzSwcNftfms4RxhTRUOC+HG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135715; c=relaxed/simple;
	bh=Kx/fiK6tmrPIcA1iG4moF7Z6llpjtEf+Pn2+HnOib1o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tQVdvfZbqEGSKDbn+/GfYFY29cMqfTbX1KBZ0zwWcE5ryE/Fpu4XO2/jJzDaQQ5tuVeeDFx5E7fiqHrtXQ+YrK7IxCBXa1WB/1OwF/jAnwrDEwX32eaJddGp4ywdorN0Rc3t0JWOvZ+oP3CaD8S3vEn2SbykCtCV+dmOtvPPO4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QH0eCWBS; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b80de683efso19262873b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135713; x=1767740513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DduiMfmTpcy5dWbJfJJBZV4wRgqp4T0woAtqbJ6bKWQ=;
        b=QH0eCWBS2YUK/mUYZDzEDLJTJJifmlPWjThhff0dPuDN1lCcSznrv56pzdu1CcSzSI
         x0KoF0Cdg9Wm7mohBZV0vs3W7wRmZlwqh4QI5aG1tFgXXX4b6ITQlWQ0SeuCc0cEDyv8
         cK0IZLQ1BtLZkkxDo1aZ0qClGElDVzYM8pCOulM5rSzAtw587c55diKWh7mpIzx65HeP
         57bF49dXu8ryIPEd3hO4ZrzA3tEqzNfj361da7EUUNzU29ZnCs+LAoiNiCSc8yHV0u4n
         CIS8CjkLhYDhTyCIjNpjN4MlJ9v52t/A+Bt+lq0Va9dHSjQkz5xPaHu9rqTyWPrekso4
         4KPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135713; x=1767740513;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DduiMfmTpcy5dWbJfJJBZV4wRgqp4T0woAtqbJ6bKWQ=;
        b=MXUhr1Z67S+z7m1ozhRZezbkdYnh+z1Vi+qkkDmI9SwPQCgTTzbW8hRNYlKyVUjFJN
         Vndt1JT8lk06vJP0vJuJVPMrpDkE6E0B1PxskH60zp0ly2iNGbiMHdaeTeHqOu6vLj3s
         SkHB0w8PtHsZSJk+yVMT4NbczPWISd7GIr39pbSAC1eDmtaTMety9W5EzI38woLXWEHb
         gIA+KCoR8QFv7iwy4Jah6b6DhWCmLZXwKvPWWa7MhPQp0q4ojXp8oK6sE5mNZBrFBlBn
         XRoJ1NPtxL56IR5AJ5Vz7xb7iJ2oOu3nTSp3ZGu4Ttjkjl0dK4fxen+mwSHPIrGnRy6q
         i1+g==
X-Gm-Message-State: AOJu0YzFYxWY4sBXWXhOyzlXY6VSQ0DwoualbKWF/eQHCLXJdAbYY0s/
	Up1Dj5v4PNLcd49rNCuIUEIdS92hXzAGuhuF4V1VKvpqktAlfQN7rzMHlaCmOd3ZwlujEqKM5p7
	ogSSehg==
X-Google-Smtp-Source: AGHT+IFl5YLLzZS88Mfh7NFRVwFsdWY7dXmSPWiNHP66M1DsoJkgDWwQHxi6m97nCMs9lyQggVclX+5VgK0=
X-Received: from pjbge24.prod.google.com ([2002:a17:90b:e18:b0:34c:cb46:dad7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e083:b0:361:3bec:fe28
 with SMTP id adf61e73a8af0-376a9de5b35mr35584887637.37.1767135712714; Tue, 30
 Dec 2025 15:01:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-1-seanjc@google.com>
Subject: [PATCH v4 00/21] KVM: selftests: Add Nested NPT support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Yosry's series to add support for nested NPT, and extends vmx_dirty_log_test
and kvm_dirty_log_test (with -n, using memstress) to cover nested SVM.

Note, I'm mildly concerned the last patch to extend nested_dirty_log_test to
validate KVM's handling of READ faults could be flaky, e.g. maybe if someone
is running the test under heavy memory pressure and the to-be-access page is
swapped between the write-from-host and read-from-guest?  But unless someone
knows/shows it'll be flaky, I'm inclined to apply it and hope for the best.

v4:
 - Document the likely reason for setting A/D bits.
 - Put "mmu" structure in common "struct kvm".
 - Make it clear PTE accessors are predicates.
 - Assert that the stage-2 MMU is initialized at most once.
 - Make READABLE a standalone bit (don't overload USER).
 - Don't alias PRESENT => READABLE for EPT.
 - Fix the A/D bit definitions for EPT.
 - Drop the function comment for __tdp_map().
 - Add a patch to extend the nested_dirty_log_test to verify that KVM creates
   writable SPTEs when the gPTEs are writable and dirty.

v3:
 - https://lore.kernel.org/all/20251127013440.3324671-1-yosry.ahmed@linux.dev
 - Dropped the patches that landed in kvm-x86.
 - Reshuffled some patches and cleanups.
 - Introduced kvm_mmu data structures to hold the root, page table
   levels, and page table masks (Sean).
 - Extended memstress as well to cover nested SVM.

v2: https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev

Sean Christopherson (7):
  KVM: selftests: Add "struct kvm_mmu" to track a given MMU instance
  KVM: selftests: Plumb "struct kvm_mmu" into x86's MMU APIs
  KVM: selftests: Add a "struct kvm_mmu_arch arch" member to kvm_mmu
  KVM: selftests: Add a stage-2 MMU instance to kvm_vm
  KVM: selftests: Move TDP mapping functions outside of vmx.c
  KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
  KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU

Yosry Ahmed (14):
  KVM: selftests: Make __vm_get_page_table_entry() static
  KVM: selftests: Stop passing a memslot to nested_map_memslot()
  KVM: selftests: Rename nested TDP mapping functions
  KVM: selftests: Kill eptPageTablePointer
  KVM: selftests: Stop setting A/D bits when creating EPT PTEs
  KVM: selftests: Move PTE bitmasks to kvm_mmu
  KVM: selftests: Use a TDP MMU to share EPT page tables between vCPUs
  KVM: selftests: Stop passing VMX metadata to TDP mapping functions
  KVM: selftests: Reuse virt mapping functions for nested EPTs
  KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
  KVM: selftests: Add support for nested NPTs
  KVM: selftests: Set the user bit on nested NPT PTEs
  KVM: selftests: Extend vmx_dirty_log_test to cover SVM
  KVM: selftests: Extend memstress to run on nested SVM

 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../kvm/include/arm64/kvm_util_arch.h         |   2 +
 .../testing/selftests/kvm/include/kvm_util.h  |  18 +-
 .../kvm/include/loongarch/kvm_util_arch.h     |   1 +
 .../kvm/include/riscv/kvm_util_arch.h         |   1 +
 .../kvm/include/s390/kvm_util_arch.h          |   1 +
 .../selftests/kvm/include/x86/kvm_util_arch.h |  22 ++
 .../selftests/kvm/include/x86/processor.h     |  58 +++-
 .../selftests/kvm/include/x86/svm_util.h      |   9 +
 tools/testing/selftests/kvm/include/x86/vmx.h |  16 +-
 .../selftests/kvm/lib/arm64/processor.c       |  38 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  28 +-
 .../selftests/kvm/lib/loongarch/processor.c   |  28 +-
 .../selftests/kvm/lib/riscv/processor.c       |  31 ++-
 .../selftests/kvm/lib/s390/processor.c        |  16 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |  66 +++--
 .../testing/selftests/kvm/lib/x86/processor.c | 237 ++++++++++++----
 tools/testing/selftests/kvm/lib/x86/svm.c     |  24 ++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 251 ++++-------------
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |   2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c | 259 ++++++++++++++++++
 .../x86/smaller_maxphyaddr_emulation_test.c   |   4 +-
 .../selftests/kvm/x86/vmx_dirty_log_test.c    | 179 ------------
 .../kvm/x86/vmx_nested_la57_state_test.c      |   2 +-
 24 files changed, 726 insertions(+), 569 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


