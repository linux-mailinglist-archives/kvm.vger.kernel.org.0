Return-Path: <kvm+bounces-45424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0884DAA986B
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 631B4172E99
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 16:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAB02676EB;
	Mon,  5 May 2025 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pOpXTd3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7AB26A0FC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746461658; cv=none; b=QHm475A664c54/7H4ExUUtfRJ4jSXOv1cOxdjcZVAA51v79rlT63+t1icMPhiHyTf57AlB8Be13LgpKPbNnVfAIoepdyFKcd9HLMJtv+Y4TKAV75RorPZQLO8oC3zdH/YpNt/BRynxWSpuyQbNwxw/5tvy9ZFRLnEgHAu1xkawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746461658; c=relaxed/simple;
	bh=46u2XlOILqRiuyiqz9Sifgha9tyJxwuBFrgpc1JvSys=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q216fFKpSXkq4zsxaofhmjOWReq/u/FrZJkBXT3FHjXyyLKQAer6wO11thkoympMlGMLQaTGwWkzaojJJFIolSQhu4Q80AOqKdjOwtccW7RYz/4kJIXGJpeiyxMN6SqbGszd9Lgx3iYMU5UatJx659btps9+8PSVagAbqE8t1ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pOpXTd3c; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30872785c3cso6774235a91.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 09:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746461656; x=1747066456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y6KHT1fuAVM+MkXSINIoI6H3OHOwSneU2VxsD+qo2oQ=;
        b=pOpXTd3cAg78NwqFwn7gxfttIE32MQThk/V9q8PNal3ZReh92EENk3rRdgV2A5HCFi
         zVUQWLWR5bg9wD34MuzCWIaG2a2h6bsUGiKfg0WPn3YkpSOVel3wodGL0dsgrnnCSbp1
         1yjogpMy/veRc1fux98x+y7X7RBXM2co87sGLoIA/BWMvcs805n9lcl/WQVKGGSaMW0g
         chUMdArQXj+HTyvsQPSdaC3aay4HCbbSo8mbsmnp0rEfwdN9aoldJKdOpKUYl2p9SjBa
         LZTc51ukqmJJ6Y5feIBOEIQE8IIys/8AT5YMZ9pcaM3TwvejR+vWvEUpMjDnv92Wcik9
         kZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746461656; x=1747066456;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y6KHT1fuAVM+MkXSINIoI6H3OHOwSneU2VxsD+qo2oQ=;
        b=Z7SUusGaY0uav01dKFOLffWuxayLh8qO1TOU9UXr16PNLonritekCGneRMLowJhp/a
         hWDAHcxhSDETMCNGCqsNDM8YUCPd1IZ2rXIQxllmYxlhzLZbqWnMK1O6I7j+EOn+92K3
         VcDtAGuZT24Qv8OFEsGZLxe7mF59N4uCic0wWcCISryv9JnJdzhbHd2EvO5uk4HYoUVe
         57uRBYBiv0daKCx1VDRfSLpWGTKGTVhtKxXdVaUO3q8OlXE5KZLEt8e0MmMlKI14Xxhk
         nd9OalpgTSEQEGdKXaACrl617RwzCUwwLcjEaTbUS13t58xcdTyGTjqekSymKOPUxtjE
         zzvA==
X-Forwarded-Encrypted: i=1; AJvYcCXn+1Ae/tLJpaUGtMcKnZD2vUoVDXTk4d+REArh2zEw5L3q4VL+94ukoT2tbk6xHMcw888=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx/TDmG5ekfiOnXUjwSmJvuQ/RDzhnrOW4hmGCiLvC90J396DX
	UmOuUhQNGJd/NaDTelU9o0mpwZMNu1UvX3PcntShKeMB96fQbuxNWMbyBj/bHlkI/dKKbe1DEbX
	OEYaemUkOvQ==
X-Google-Smtp-Source: AGHT+IFROwVfZzwUrc47gwt10xGllcKawPs6+PzhuOzeHVlfd+NhQ3axCf6K4h719pvA/HvyBR0gDvS7G15Lqw==
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:2fc:2ee0:d38a])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ec7:b0:309:e351:2e3d with SMTP id 98e67ed59e1d1-30a5ae132e5mr18020085a91.12.1746461655808;
 Mon, 05 May 2025 09:14:15 -0700 (PDT)
Date: Mon,  5 May 2025 16:14:06 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505161412.1926643-1-jiaqiyan@google.com>
Subject: [PATCH v1 0/6] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
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
there is still room to recover from memory UER in a more graceful manner.

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

- VMM can protect future memory error consumption or faults by unmapping
  the poisoned pages from stage-2 page table with KVM userfault [2],
  which is more performant than splitting the memslot that contains
  the poisoned guest pages.

- VMM can keep track SEA events in the VM. When VMM thinks the status
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
supported by KVM on arm64, although not fully supported by
KVM_SET_VCPU_EVENTS but complemented in this patchset.

New UAPIs
=========

This patchset introduces following userspace-visiable changes to empower
VMM to control what happens next for guest SEA:

- KVM_CAP_ARM_SEA_TO_USER. If userspace enables this new capability at VM
  creation, KVM will not inject SError while taking SEA, but VM exit to
  userspace.

- KVM_EXIT_ARM_SEA. This is the VM exit reason VMM gets. The details
  about the SEA is provided in arm_sea as much as possible, including
  ESR value at EL2, if guest virtual and physical addresses (GPA and GVA)
  are available and the values if available.

- KVM_CAP_ARM_INJECT_EXT_IABT. VMM today can inject external data abort
  to VCPU via KVM_SET_VCPU_EVENTS API. However, in case of instruction
  abort, VMM cannot inject it via KVM_SET_VCPU_EVENTS.
  KVM_CAP_ARM_INJECT_EXT_IABT is just a natural extend to
  KVM_CAP_ARM_INJECT_EXT_DABT that tells VMM KVM_SET_VCPU_EVENTS now
  supports external instruction abort.

Patchset utilizes commit 26fbdf369227 ("KVM: arm64: Don't translate
FAR if invalid/unsafe") from [4], available already in kvmarm/next.
[4] makes KVM safely do address translation for HPFAR_EL2, including at
the event of SEA, and indicate if HPFAR_EL2 is valid in NS bit.
This patchset depends on [4] to tell userspace if GPA is valid and
its value if valid.

Patchset is based on commit 68ec8b4e84446 ("Merge branch
kvm-arm64/pkvm-6.16 into kvmarm-master/next")

[1] https://cloud.google.com/solutions/sap/docs/manage-host-errors
[2] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/LPC_%20KVM%20Userfault.pdf
[3] https://lore.kernel.org/kvm/86pljbqqh0.wl-maz@kernel.org
[4] https://lore.kernel.org/all/174369514508.3034362.13165690020799838042.b4-ty@linux.dev

Jiaqi Yan (5):
  KVM: arm64: VM exit to userspace to handle SEA
  KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
  KVM: selftests: Test for KVM_EXIT_ARM_SEA and KVM_CAP_ARM_SEA_TO_USER
  KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
  Documentation: kvm: new uAPI for handling SEA

Raghavendra Rao Ananta (1):
  KVM: arm64: Allow userspace to inject external instruction aborts

 Documentation/virt/kvm/api.rst                | 120 ++++++-
 arch/arm64/include/asm/kvm_emulate.h          |  12 +
 arch/arm64/include/asm/kvm_host.h             |   8 +
 arch/arm64/include/asm/kvm_ras.h              |  21 +-
 arch/arm64/include/uapi/asm/kvm.h             |   3 +-
 arch/arm64/kvm/Makefile                       |   3 +-
 arch/arm64/kvm/arm.c                          |   6 +
 arch/arm64/kvm/guest.c                        |  13 +-
 arch/arm64/kvm/inject_fault.c                 |   3 +
 arch/arm64/kvm/kvm_ras.c                      |  54 +++
 arch/arm64/kvm/mmu.c                          |  12 +-
 include/uapi/linux/kvm.h                      |  12 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/arm64/inject_iabt.c | 100 ++++++
 .../testing/selftests/kvm/arm64/sea_to_user.c | 324 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 17 files changed, 654 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c

-- 
2.49.0.967.g6a0df3ecc3-goog


