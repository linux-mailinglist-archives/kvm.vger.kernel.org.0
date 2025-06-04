Return-Path: <kvm+bounces-48362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD5FACD75A
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 07:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 846ED18982E0
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 05:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F6C262FD7;
	Wed,  4 Jun 2025 05:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkYH/epC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65265148830
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 05:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749013748; cv=none; b=tSyEX7jipt1AezA0h9wkAMBNi0Myt53BmKWVST7ATcT6+dIJm0pay477CKd4BATjPg0CXaJY+xp7/tNC/ynBacQ53wO96oTMhSm4t89HhZPekC5XfvWTHrTDXmxgYRCHs7qGxhu9vZu5K5uvvzMqFuef8DIt/z/0VsL7x3bumSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749013748; c=relaxed/simple;
	bh=bXYb3Fv57WgD098ckyuMFMuLy5/rfO9F4rSK52NJVXg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kOm+VMf3DeQey+lBrRgq9wQkPfWn3njg6oTufLDv/jRe8QSTL7+JqyezkgDTK4iZ2qAcjvCwGQ9HSTbvOymph8o9hjOZiVfZ5Np1BNq6VbtOyvVuc26UPKiPsRxb69yY9yUEIF5EF8h2b1tB/A4/VW3jB3BbhpzUq+IQiNjGO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkYH/epC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747dd44048cso2806789b3a.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 22:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749013745; x=1749618545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NrHVO1JlSwACRF1JM0S/mT4335rXAQlO0tShDIgF4kg=;
        b=OkYH/epChKHPPZlfS6IyUjrdvLMKQLJK/RyuLYoK96W2E+E3txL6+LRnjMAxfCWzgm
         1jQXEesJgnVbkT7bZCw1PDculuyhLrRyXWl+Z6BzfMrzC3qXqe/gRtuc0qpSldk2JQqs
         C+Etgb17ZSJtd0/NdlLwI7EpyErRcEjYnE1QkPs6R73saUIfNW7yXqPamz/xGwNP5z/i
         H7zFEBudGw1w2lNVHotFtsr4B/G5yNFKnr3oHmHND2nZbiais0inya1MymC1AGKtfaOY
         h7bIWzcnx7vnTkHOy0hnsJPeglPMHkwM6NrqnbuFEbdWzhgFM+1zePMcRwfK85T+N3wc
         83Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749013745; x=1749618545;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrHVO1JlSwACRF1JM0S/mT4335rXAQlO0tShDIgF4kg=;
        b=qrT2heEMEEEwWkdx24WFeGrCQ87KqFTDodaE2HhHiYtcE+M1aiYgdKm6rFF7mK9TCL
         u0PzkMA+d+PC1zcpOABoLasUE8Sff9dJxrumiG6q+Hz87SKfy4w02DavCTdQKpeIE121
         40do01AJlWV5DjM914KW20HMaOKfq9ujjCOsrRCK6wAKqzxlJQKr7mmNt49ro+fT1Tzr
         ktG5jkrjuUKDjBYC8bYSkYf7XFqOc9aMSzCV0fI6hqtL9HSVW0uyCij3PcVxPziVo3VL
         n8F3USaedojDTfrK9t4ZNRdemeOEpva+nOtNP07WR+g0kHQUePAFon8mqMtOoUoNsLQk
         IVQg==
X-Forwarded-Encrypted: i=1; AJvYcCUIIVLsAkOmslOR43sgphrmWysFzgsncCBJA8OueyWG+DpcSibR1tehnVo2c+8aFP6aU88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3zx+AinPSQGDuupkk2hmniZieXnY9OTbh9JSOlL59bMvv00QP
	4wxzlNPmy8139HSBAEz/GQN1khZjr7sbDrjdwzKz1n8mmo4u6TGB3WnCKB0r/Ml1BBO47RrCdaW
	Fa9U7FLSgUJygvA==
X-Google-Smtp-Source: AGHT+IEABKtEFFU5liXpEXSptkYGDpsy283hDhs01hedhxVkwnKMuF3CclWqZbgRuZmc+jHI4P4dRe8JCJ2ZzQ==
X-Received: from pgbcq2.prod.google.com ([2002:a05:6a02:4082:b0:b2d:249f:ea07])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1586:b0:1f5:8e94:2e81 with SMTP id adf61e73a8af0-21d22a6ca78mr2158789637.9.1749013744670;
 Tue, 03 Jun 2025 22:09:04 -0700 (PDT)
Date: Wed,  4 Jun 2025 05:08:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250604050902.3944054-1-jiaqiyan@google.com>
Subject: [PATCH v2 0/6] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Problem
=======

When host APEI is unable to claim synchronous external abort (SEA)
during stage-2 guest abort, today KVM directly injects an async SError
into the VCPU then resumes it. The injected SError usually results in
unpleasant guest kernel panic.

One of the major situation of guest SEA is when VCPU consumes recoverable
uncorrected memory error (UER), which is not uncommon at all in modern
datacenter servers with large amounts of physical memory. Although SError
and guest panic is sufficient to stop the propagation of corrupted memory
there is room to recover from an UER in a more graceful manner.

Proposed Solution
=================

Alternatively KVM can replay the SEA to the faulting VCPU, via existing
KVM_SET_VCPU_EVENTS API. If the memory poison consumption or the fault
that cause SEA is not from guest kernel, the blast radius can be limited
to the consuming or faulting guest userspace process, so the VM can keep
running.

In addition, instead of doing under the hood without involving userspace,
there are benefits to redirect the SEA to VMM:

- VM customers care about the disruptions caused by memory errors, and
  VMM usually has the responsibility to start the process of notifying
  the customers of memory error events in their VMs. For example some
  cloud provider emits a critical log in their observability UI [1], and
  provides playbook for customers on how to mitigate disruptions to
  their workloads.

- VMM can protect future memory error consumption by unmapping the poisoned
  pages from stage-2 page table with KVM userfault, or by splitting the
  memslot that contains the poisoned guest pages [2].

- VMM can keep track of SEA events in the VM. When VMM thinks the status
  on the host or the VM is bad enough, e.g. number of distinct SEAs
  exceeds a threshold, it can restart the VM on another healthy host.

- Behavior parity with x86 architecture. When machine check exception
  (MCE) is caused by VCPU, kernel or KVM signals userspace SIGBUS to
  let VMM either recover from the MCE, or terminate itself with VM.
  The prior RFC proposes to implement SIGBUS on arm64 as well, but
  Marc preferred VCPU exit over signal [3]. However, implementation
  aside, returning SEA to VMM is on par with returning MCE to VMM.

Once SEA is redirected to VMM, among other actions, VMM is encouraged
to inject external aborts into the faulting VCPU, which is already
supported by KVM on arm64. We notice injecting instruction abort is not
fully supported by KVM_SET_VCPU_EVENTS. Complement it in the patchset.

New UAPIs
=========

This patchset introduces following userspace-visiable changes to empower
VMM to control what happens next for SEA on guest memory:

- KVM_CAP_ARM_SEA_TO_USER. While taking SEA, if userspace has enabled
  this new capability at VM creation, and the SEA is not caused by
  memory allocated for stage-2 translation table, instead of injecting
  SError, return KVM_EXIT_ARM_SEA to userspace.

- KVM_EXIT_ARM_SEA. This is the VM exit reason VMM gets. The details
  about the SEA is provided in arm_sea as much as possible, including
  sanitized ESR value at EL2, if guest virtual and physical addresses
  (GPA and GVA) are available and the values if available.

- KVM_CAP_ARM_INJECT_EXT_IABT. VMM today can inject external data abort
  to VCPU via KVM_SET_VCPU_EVENTS API. However, in case of instruction
  abort, VMM cannot inject it via KVM_SET_VCPU_EVENTS.
  KVM_CAP_ARM_INJECT_EXT_IABT is just a natural extend to
  KVM_CAP_ARM_INJECT_EXT_DABT that tells VMM KVM_SET_VCPU_EVENTS now
  supports external instruction abort.


* From v1 [4]:
  - Rebased on commit 4d62121ce9b5 ("KVM: arm64: vgic-debug: Avoid
    dereferencing NULL ITE pointer").
  - Sanitize ESR_EL2 before reporting it to userspace.
  - Do not do KVM_EXIT_ARM_SEA when SEA is caused by memory allocated to
    stage-2 translation table.

[1] https://cloud.google.com/solutions/sap/docs/manage-host-errors
[2] https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@google.com
[3] https://lore.kernel.org/kvm/86pljbqqh0.wl-maz@kernel.org
[4] https://lore.kernel.org/kvm/20250505161412.1926643-1-jiaqiyan@google.com

Jiaqi Yan (5):
  KVM: arm64: VM exit to userspace to handle SEA
  KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
  KVM: selftests: Test for KVM_EXIT_ARM_SEA and KVM_CAP_ARM_SEA_TO_USER
  KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
  Documentation: kvm: new uAPI for handling SEA

Raghavendra Rao Ananta (1):
  KVM: arm64: Allow userspace to inject external instruction aborts

 Documentation/virt/kvm/api.rst                | 128 ++++++-
 arch/arm64/include/asm/kvm_emulate.h          |  67 ++++
 arch/arm64/include/asm/kvm_host.h             |   8 +
 arch/arm64/include/asm/kvm_ras.h              |   2 +-
 arch/arm64/include/uapi/asm/kvm.h             |   3 +-
 arch/arm64/kvm/arm.c                          |   6 +
 arch/arm64/kvm/guest.c                        |  13 +-
 arch/arm64/kvm/inject_fault.c                 |   3 +
 arch/arm64/kvm/mmu.c                          |  59 ++-
 include/uapi/linux/kvm.h                      |  12 +
 tools/arch/arm64/include/asm/esr.h            |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/arm64/inject_iabt.c |  98 +++++
 .../testing/selftests/kvm/arm64/sea_to_user.c | 340 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 16 files changed, 718 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c

-- 
2.49.0.1266.g31b7d2e469-goog


