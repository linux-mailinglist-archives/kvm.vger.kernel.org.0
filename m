Return-Path: <kvm+bounces-42686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D306A7C3F6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AFDE3BC741
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C9221D5B6;
	Fri,  4 Apr 2025 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ea4IthJe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE621D3DC
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795589; cv=none; b=gf+f069ygPO6Q3ew4s6nqhojTqUT2vH/JloOE9KoD9HEedtCZxnr19fwuLf3j7B1LGk5vgvysbkejMo5kMSAxANz3fNXr7ZiI6H8yJA/MHh+IYXprKrkMd3+lMxDG1cpwvePXFuHehhMzaGYOwMgp+F9p6PEcGbUK4+6cNjvUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795589; c=relaxed/simple;
	bh=KPToIIQwdCGKbf6sKO4a3iXQPts7CJpwucL7pCIeuVM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fBRLbvrs12bE0mvwMhYMsXJcBnyPUcHRV7i9OKX3uHsPIISSEHNa3pPdFJfMfhCDjbkMYsA5l4e3Z+VTyZNm1El2MHGAIfas/b/mEEffxTgM2WwWkCuTY2qMH4bwkRGfrhmI9XnB49Z2Kvhj+YzMSMsxIL1NBkPcJ5CdkjPBB1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ea4IthJe; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-739731a2c25so1710842b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795587; x=1744400387; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MG5RODVR1/0BqhltSOIbQPcbv3JQ7tKi5SDggCFt5A=;
        b=Ea4IthJeS+5HPKQuzkm2o+i3EEYESNXL2az/2czKLz+FUucoT6BJvMCL4cUtW6xANl
         oWJM9Uj5GRCZqBWTIyVJQNl9zDFJZLvFghlxx3lK9yGNDFjejz4TP6lk8Th19Uew7/ur
         aWgDRVmkIyzXsXa1RQf4IDWG1PnqRv71AJFLkl6S13CrLjRQgidsmcmvF4kUyL9/VmJn
         Wh9naOISYW9UjFhornZPLnJWoATWjQgyeuo9I9K4ox4BPs9H2iCKs5GpxCRuNjsFENFc
         HcKz4ROHBW7yTLpFcQgAHUtQ/WafwQx1wicdWwmf/kVGv9aVxdN3kD+Z/vSPoMlTQUb9
         X7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795587; x=1744400387;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6MG5RODVR1/0BqhltSOIbQPcbv3JQ7tKi5SDggCFt5A=;
        b=qQdGbjjD3P6ivVLB+9UxoQEwHUJIHFpV1zNlRlO91wBxy7InnvoubjQ0Oq/Azf5QXQ
         Q48A67gmLhmIJ/YxCiYikzCkHpVt14nQVk7PW8z+IPHXN4PwZXZMelb1Olhk2iVRBkAX
         uj+wagU94jWNjwyplT9rI+oX3O/wN4Ns+1lyiRoH91yef2RHfpMA3i1tAwE8oQLzdPgb
         Tgta0UUx2+XyOZrA47O1JA28IAvpC3zBq5OaCA6ejV1zQ7GCeHEXaHzhRMJpc3Zw0+aj
         /pQfE7b4at7Z3MiEmNgH32+wivYyM7bHW8Bt9dRhdFKAsjfKZGHi0Wx9RCFLyjY2AgEH
         jxVA==
X-Gm-Message-State: AOJu0YwwVtmnsp6DOYcJOBct8TfL8wIL6gWf5vTwM3LR7RtjTG/XpEAP
	RXQ7XxYcU/a0SOjro1X1HoZqzFjIO4f/hwlzmwy/snVrQS+sKyw14/93CMOwGMZWcMi6dImCK2C
	cnA==
X-Google-Smtp-Source: AGHT+IG1QvrLQHeqQfAhbL403YjCEya9kFNn8liyEq5wqvLWYYspvkCI27/IroT/t3x3HXQhl/yCqTUXI1A=
X-Received: from pfks21.prod.google.com ([2002:a05:6a00:1955:b0:730:848d:a5a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88c8:0:b0:737:9b:582a
 with SMTP id d2e1a72fcca58-739e4c1045fmr6479794b3a.24.1743795587108; Fri, 04
 Apr 2025 12:39:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-1-seanjc@google.com>
Subject: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
       general.  This needs more testing on AMD with device posted IRQs.

This applies on the small series that adds a enable_device_posted_irqs
module param (the prep work for that is also prep work for this):

   https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com

Fix a variety of bugs related to device posted IRQs, especially on the
AMD side, and clean up KVM's implementation, which IMO is in the running
for Most Convoluted Code in KVM.

Stating the obvious, this series is comically large.  I'm posting it as a
single series, at least for the first round of reviews, to build the
(mostly) full picture of the end goal (it's not the true end goal; there's
still more cleanups that can be done).  And because properly testing most
of the code would be futile until almost the end of the series (so. many.
bugs.).

Batch #1 (patches 1-10) fixes bugs of varying severity.

Batch #2 is mostly SVM specific:

 - Cleans up various warts and bugs in the IRTE tracking
 - Fixes AVIC to not reject large VMs (honor KVM's ABI)
 - Wire up AVIC to enable_ipiv to support disabling IPI virtualization while
   still utilizing device posted interrupts, and to workaround erratum #1235.

Batch #3 overhauls the guts of IRQ bypass in KVM, and moves the vast majority
of the logic to common x86; only the code that needs to communicate with the
IOMMU is truly vendor specific.

Batch #4 is more SVM/AVIC cleanups that are made possible by batch #3.

Batch #5 adds WARNs and drops dead code after all the previous cleanups and
fixes (I don't want to add the WARNs earlier; I don't any point in adding
WARNs in code that's known to be broken).

Batch #6 is yet more SVM/AVIC cleanups, with the specific goal of configuring
IRTEs to generate GA log interrupts if and only if KVM actually needs a wake
event.

This series is well tested except for one notable gap: I was not able to
fully test the AMD IOMMU changes.  Long story short, getting upstream
kernels into our full test environments is practically infeasible.  And
exposing a device or VF on systems that are available to developers is a
bit of a mess.

The device the selftest (see the last patch) uses is an internel test VF
that's hosted on a smart NIC using non-production (test-only) firmware.
Unfortunately, only some of our developer systems have the right NIC, and
for unknown reasons I couldn't get the test firmware to install cleanly on
Rome systems.  I was able to get it functional on Milan (and Intel CPUs),
but APIC virtualization is disabled on Milan.  Thanks to KVM's force_avic
I could test the KVM flows, but the IOMMU was having none of my attempts
to force enable APIC virtualization against its will.

Through hackery (see the penultimate patch), I was able to gain a decent
amount of confidence in the IOMMU changes (and the interface between KVM
and the IOMMU).

For initial development of the series, I also cobbled together a "mock"
IRQ bypass device, to allow testing in a VM.

  https://github.com/sean-jc/linux.git x86/mock_irqbypass_producer

Note, the diffstat is misleading due to the last two DO NOT MERGE patches
adding 1k+ LoC.  Without those, this series removes ~80 LoC (substantially
more if comments are ignored).

  21 files changed, 577 insertions(+), 655 deletions(-)

Maxim Levitsky (2):
  KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
  KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235

Sean Christopherson (65):
  KVM: SVM: Allocate IR data using atomic allocation
  KVM: x86: Reset IRTE to host control if *new* route isn't postable
  KVM: x86: Explicitly treat routing entry type changes as changes
  KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
  iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
  iommu/amd: WARN if KVM attempts to set vCPU affinity without posted
    intrrupts
  KVM: SVM: WARN if an invalid posted interrupt IRTE entry is added
  KVM: x86: Pass new routing entries and irqfd when updating IRTEs
  KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
  KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
  KVM: SVM: Delete IRTE link from previous vCPU irrespective of new
    routing
  KVM: SVM: Drop pointless masking of default APIC base when setting
    V_APIC_BAR
  KVM: SVM: Drop pointless masking of kernel page pa's with AVIC HPA
    masks
  KVM: SVM: Add helper to deduplicate code for getting AVIC backing page
  KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
  KVM: SVM: Inhibit AVIC if ID is too big instead of rejecting vCPU
    creation
  KVM: SVM: Drop redundant check in AVIC code on ID during vCPU creation
  KVM: SVM: Track AVIC tables as natively sized pointers, not "struct
    pages"
  KVM: SVM: Drop superfluous "cache" of AVIC Physical ID entry pointer
  KVM: VMX: Move enable_ipiv knob to common x86
  KVM: VMX: Suppress PI notifications whenever the vCPU is put
  KVM: SVM: Add a comment to explain why avic_vcpu_blocking() ignores
    IRQ blocking
  iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
  iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
  iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
  KVM: SVM: Get vCPU info for IRTE using new routing entry
  KVM: SVM: Stop walking list of routing table entries when updating
    IRTE
  KVM: VMX: Stop walking list of routing table entries when updating
    IRTE
  KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
  KVM: x86: Nullify irqfd->producer after updating IRTEs
  KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU
  KVM: x86: Move posted interrupt tracepoint to common code
  KVM: SVM: Clean up return handling in avic_pi_update_irte()
  iommu: KVM: Split "struct vcpu_data" into separate AMD vs. Intel
    structs
  KVM: Don't WARN if updating IRQ bypass route fails
  KVM: Fold kvm_arch_irqfd_route_changed() into
    kvm_arch_update_irqfd_routing()
  KVM: x86: Track irq_bypass_vcpu in common x86 code
  KVM: x86: Skip IOMMU IRTE updates if there's no old or new vCPU being
    targeted
  KVM: x86: Don't update IRTE entries when old and new routes were !MSI
  KVM: SVM: Revert IRTE to legacy mode if IOMMU doesn't provide IR
    metadata
  KVM: SVM: Take and hold ir_list_lock across IRTE updates in IOMMU
  iommu/amd: KVM: SVM: Infer IsRun from validity of pCPU destination
  iommu/amd: Factor out helper for manipulating IRTE GA/CPU info
  iommu/amd: KVM: SVM: Set pCPU info in IRTE when setting vCPU affinity
  iommu/amd: KVM: SVM: Add IRTE metadata to affined vCPU's list if AVIC
    is inhibited
  KVM: SVM: Don't check for assigned device(s) when updating affinity
  KVM: SVM: Don't check for assigned device(s) when activating AVIC
  KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
  KVM: SVM: Process all IRTEs on affinity change even if one update
    fails
  KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
  KVM: x86: Drop superfluous "has assigned device" check in
    kvm_pi_update_irte()
  KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
  KVM: x86: WARN if IRQ bypass routing is updated without in-kernel
    local APIC
  KVM: SVM: WARN if ir_list is non-empty at vCPU free
  KVM: x86: Decouple device assignment from IRQ bypass
  KVM: VMX: WARN if VT-d Posted IRQs aren't possible when starting IRQ
    bypass
  KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
  iommu/amd: WARN if KVM calls GA IRTE helpers without virtual APIC
    support
  KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
  KVM: SVM: Don't check vCPU's blocking status when toggling AVIC on/off
  KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
  iommu/amd: KVM: SVM: Allow KVM to control need for GA log interrupts
  KVM: SVM: Generate GA log IRQs only if the associated vCPUs is
    blocking
  *** DO NOT MERGE *** iommu/amd: Hack to fake IRQ posting support
  *** DO NOT MERGE *** KVM: selftests: WIP posted interrupts test

 arch/x86/include/asm/irq_remapping.h          |  17 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  20 +-
 arch/x86/include/asm/svm.h                    |  13 +-
 arch/x86/kvm/svm/avic.c                       | 707 ++++++++----------
 arch/x86/kvm/svm/svm.c                        |   6 +
 arch/x86/kvm/svm/svm.h                        |  24 +-
 arch/x86/kvm/trace.h                          |  19 +-
 arch/x86/kvm/vmx/capabilities.h               |   1 -
 arch/x86/kvm/vmx/main.c                       |   2 +-
 arch/x86/kvm/vmx/posted_intr.c                | 150 ++--
 arch/x86/kvm/vmx/posted_intr.h                |  11 +-
 arch/x86/kvm/vmx/vmx.c                        |   2 -
 arch/x86/kvm/x86.c                            | 124 ++-
 drivers/iommu/amd/amd_iommu_types.h           |   1 -
 drivers/iommu/amd/init.c                      |   8 +-
 drivers/iommu/amd/iommu.c                     | 171 +++--
 drivers/iommu/intel/irq_remapping.c           |  10 +-
 include/linux/amd-iommu.h                     |  25 +-
 include/linux/kvm_host.h                      |   9 +-
 include/linux/kvm_irqfd.h                     |   4 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/include/vfio_pci_util.h     | 149 ++++
 .../selftests/kvm/include/x86/processor.h     |  21 +
 .../testing/selftests/kvm/lib/vfio_pci_util.c | 201 +++++
 tools/testing/selftests/kvm/mercury_device.h  | 118 +++
 tools/testing/selftests/kvm/vfio_irq_test.c   | 429 +++++++++++
 virt/kvm/eventfd.c                            |  22 +-
 28 files changed, 1610 insertions(+), 658 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/vfio_pci_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/vfio_pci_util.c
 create mode 100644 tools/testing/selftests/kvm/mercury_device.h
 create mode 100644 tools/testing/selftests/kvm/vfio_irq_test.c


base-commit: 5f9f498ea14ffe15390aa46fb85375e7c901bce3
-- 
2.49.0.504.g3bcea36a83-goog


