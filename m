Return-Path: <kvm+bounces-53483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E070DB12675
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C983C1CC4B92
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C038425B1E0;
	Fri, 25 Jul 2025 22:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QXd3HsWa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB6425E828
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481246; cv=none; b=ul6y14dis4KVRntpuGcu4EsE/VIqZT6Yrkyd6+OPGFvgliJR21UEHsahGIPuYWfmWrQPnZibu/LjFrTpB9wVxmpq4O0BDRaFUnJsG7xETMitE6O2r5kDvuwPq9n3CujVtLFPGrFHuC7WzcE5P7EG2prntpqSbe99ydpXopv9ypY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481246; c=relaxed/simple;
	bh=Hz15ATEuyQh6i/jlaTWq6uBwW70Sjt72wkZraeXPX8I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ja6N5t2bwKl24yPdYMelqQfKdkIDRcWpaQD79vkm/fJcG8fC/VsNySI2xaI/PH9A5RhBhMrztkqH7X6X1op3o8yWHHkNp1p8jXgPK3j7P/csfZDuJe+HBW1R7/A7i1OyEc5ixlBJVHjJ//z2oOhxe2EFlHqd77mcl2Fy0KPUK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QXd3HsWa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2349fe994a9so20528475ad.1
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481243; x=1754086043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T2Y23w66/ElFH29Utu1HzDA/bJVL2SwgO2yn/9NaSNE=;
        b=QXd3HsWa7jYtrIVDk0cNJEmxVdzH7WMNOUoASEbgmTp6BtHaoslkktjJHAqITTq9Um
         iIsRgGObyxWM9PgMveJHAFMPn37gxDSnHfeivPxNriqJa6b1a7aagxqn+T4vbj4Ooor1
         r8g4eWFtfF5PqnUIFt3kYTzV0HKGzI52ScKSRJA5xLSOopjWQRIFGYvTEbaP2lJ8p9SU
         Wcafj3sQNI8cPpBH0eSJc1ZMQS/KAIICuMBxeBQGxAHlui4QLlclntXPZtpzrEXltnet
         oxgfuc7y6u+L8J6OQbLH+tZhmJjLHVRXoFi3dYyarSsrmENC5rp6OmmEZIh2FZOGKjjV
         5HtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481243; x=1754086043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2Y23w66/ElFH29Utu1HzDA/bJVL2SwgO2yn/9NaSNE=;
        b=wZvSFnZuoCYbYeJzN4Blc0CoFYB5k4eKk7mv215zIoTg34NEEKCmeDV82OUoW6dgCn
         XoebtSVjLCB4zM0x/4XKipiG8yQu8Zw6skJJot2Cb7UsGrejqsNI88wFaJt9mWCWbKO/
         iPAO47GKX7vHbIQbTeRXGxyFB+cXmgWlvD6aZCayduO0qxUkUCA772yENVRkiiDJqGUD
         pgWTBt2vLnmBQjg+4ml6bRg7D6EikLjA+kX9g2DNSDYNdOuG3DaB4qw0n0eQEyRFM3TG
         OYFd5xe1EVwLYz0YJhx1l1iXtMPXClb7p6N+mmqRjzYu5oR2Ym/Xaa1NXgg6luVBKlRU
         SLww==
X-Gm-Message-State: AOJu0Yyh3F9w/ppLXhnmMwL7rRveMJg0RcCxK9KrOT5UYGhoVyiF2rdR
	HY0kCIGmpqh5d1pWSlFAPFulWV9v+BfUeObFfCEXO7no/lbRG6CEgRuM2NR9kTfM0OBdD8OK6Bu
	6gCR2hw==
X-Google-Smtp-Source: AGHT+IF12jLpGDCPgddO4NYHVL6M47SNbNlavricdFqR4Ib6uaolfd/1ZykNWP4+J5W74ex9jgumSb8olJo=
X-Received: from plxd4.prod.google.com ([2002:a17:902:ef04:b0:23f:c14e:ff62])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da2d:b0:23f:adba:fc5b
 with SMTP id d9443c01a7336-23fb317bf0cmr62497725ad.49.1753481243461; Fri, 25
 Jul 2025 15:07:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:04 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-5-seanjc@google.com>
Subject: [GIT PULL] KVM: IRQ changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Pretty please, with a cherry on top and a pile of cash (or crypto) buried
underneath if need be, pull a pile of IRQ related changes.  The general theme
is to clean up, harden, and improve documentation for all things related to
device posted IRQs.

All non-KVM changes (irqbypass, AMD IOMMU, and sched/wait) have been acked
and/or reviewed by their respective owners (some of the IOMMU changes lack
explicit tags, but unless I grossly misread things, they're good to go).

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-irqs-6.17

for you to fetch changes up to 81bf24f1ac77029bf858c0da081088eb62b1b230:

  KVM: selftests: Add CONFIG_EVENTFD for irqfd selftest (2025-07-10 06:20:20 -0700)

----------------------------------------------------------------
KVM IRQ changes for 6.17

 - Rework irqbypass to track/match producers and consumers via an xarray
   instead of a linked list.  Using a linked list leads to O(n^2) insertion
   times, which is hugely problematic for use cases that create large numbers
   of VMs.  Such use cases typically don't actually use irqbypass, but
   eliminating the pointless registration is a future problem to solve as it
   likely requires new uAPI.

 - Track irqbypass's "token" as "struct eventfd_ctx *" instead of a "void *",
   to avoid making a simple concept unnecessarily difficult to understand.

 - Add CONFIG_KVM_IOAPIC for x86 to allow disabling support for I/O APIC, PIC,
   and PIT emulation at compile time.

 - Drop x86's irq_comm.c, and move a pile of IRQ related code into irq.c.

 - Fix a variety of flaws and bugs in the AVIC device posted IRQ code.

 - Inhibited AVIC if a vCPU's ID is too big (relative to what hardware
   supports) instead of rejecting vCPU creation.

 - Extend enable_ipiv module param support to SVM, by simply leaving IsRunning
   clear in the vCPU's physical ID table entry.

 - Disable IPI virtualization, via enable_ipiv, if the CPU is affected by
   erratum #1235, to allow (safely) enabling AVIC on such CPUs.

 - Dedup x86's device posted IRQ code, as the vast majority of functionality
   can be shared verbatime between SVM and VMX.

 - Harden the device posted IRQ code against bugs and runtime errors.

 - Use vcpu_idx, not vcpu_id, for GA log tag/metadata, to make lookups O(1)
   instead of O(n).

 - Generate GA Log interrupts if and only if the target vCPU is blocking, i.e.
   only if KVM needs a notification in order to wake the vCPU.

 - Decouple device posted IRQs from VFIO device assignment, as binding a VM to
   a VFIO group is not a requirement for enabling device posted IRQs.

 - Clean up and document/comment the irqfd assignment code.

 - Disallow binding multiple irqfds to an eventfd with a priority waiter, i.e.
   ensure an eventfd is bound to at most one irqfd through the entire host,
   and add a selftest to verify eventfd:irqfd bindings are globally unique.

----------------------------------------------------------------
Mark Brown (1):
      KVM: selftests: Add CONFIG_EVENTFD for irqfd selftest

Maxim Levitsky (2):
      KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
      KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235

Sean Christopherson (98):
      KVM: arm64: WARN if unmapping a vLPI fails in any path
      irqbypass: Drop pointless and misleading THIS_MODULE get/put
      irqbypass: Drop superfluous might_sleep() annotations
      irqbypass: Take ownership of producer/consumer token tracking
      irqbypass: Explicitly track producer and consumer bindings
      irqbypass: Use paired consumer/producer to disconnect during unregister
      irqbypass: Use guard(mutex) in lieu of manual lock+unlock
      irqbypass: Use xarray to track producers and consumers
      irqbypass: Require producers to pass in Linux IRQ number during registration
      KVM: x86: Trigger I/O APIC route rescan in kvm_arch_irq_routing_update()
      KVM: x86: Drop superfluous kvm_set_pic_irq() => kvm_pic_set_irq() wrapper
      KVM: x86: Drop superfluous kvm_set_ioapic_irq() => kvm_ioapic_set_irq() wrapper
      KVM: x86: Drop superfluous kvm_hv_set_sint() => kvm_hv_synic_set_irq() wrapper
      KVM: x86: Move PIT ioctl helpers to i8254.c
      KVM: x86: Move KVM_{GET,SET}_IRQCHIP ioctl helpers to irq.c
      KVM: x86: Rename irqchip_kernel() to irqchip_full()
      KVM: x86: Move kvm_setup_default_irq_routing() into irq.c
      KVM: x86: Move kvm_{request,free}_irq_source_id() to i8254.c (PIT)
      KVM: x86: Hardcode the PIT IRQ source ID to '2'
      KVM: x86: Don't clear PIT's IRQ line status when destroying PIT
      KVM: x86: Explicitly check for in-kernel PIC when getting ExtINT
      KVM: Move x86-only tracepoints to x86's trace.h
      KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling in-kernel I/O APIC
      KVM: Squash two CONFIG_HAVE_KVM_IRQCHIP #ifdefs into one
      KVM: selftests: Fall back to split IRQ chip if full in-kernel chip is unsupported
      KVM: x86: Move IRQ mask notifier infrastructure to I/O APIC emulation
      KVM: x86: Fold irq_comm.c into irq.c
      KVM: Pass new routing entries and irqfd when updating IRTEs
      KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
      KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
      iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
      KVM: SVM: Delete IRTE link from previous vCPU irrespective of new routing
      KVM: SVM: Drop pointless masking of default APIC base when setting V_APIC_BAR
      KVM: SVM: Drop pointless masking of kernel page pa's with AVIC HPA masks
      KVM: SVM: Add helper to deduplicate code for getting AVIC backing page
      KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
      KVM: SVM: Inhibit AVIC if ID is too big instead of rejecting vCPU creation
      KVM: SVM: Drop redundant check in AVIC code on ID during vCPU creation
      KVM: SVM: Track AVIC tables as natively sized pointers, not "struct pages"
      KVM: SVM: Drop superfluous "cache" of AVIC Physical ID entry pointer
      KVM: VMX: Move enable_ipiv knob to common x86
      KVM: VMX: Suppress PI notifications whenever the vCPU is put
      KVM: SVM: Add a comment to explain why avic_vcpu_blocking() ignores IRQ blocking
      iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
      iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
      KVM: SVM: Stop walking list of routing table entries when updating IRTE
      KVM: VMX: Stop walking list of routing table entries when updating IRTE
      KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
      KVM: x86: Move IRQ routing/delivery APIs from x86.c => irq.c
      KVM: x86: Nullify irqfd->producer after updating IRTEs
      KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU
      KVM: x86: Move posted interrupt tracepoint to common code
      KVM: SVM: Clean up return handling in avic_pi_update_irte()
      iommu: KVM: Split "struct vcpu_data" into separate AMD vs. Intel structs
      KVM: Don't WARN if updating IRQ bypass route fails
      KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
      KVM: x86: Track irq_bypass_vcpu in common x86 code
      KVM: x86: Skip IOMMU IRTE updates if there's no old or new vCPU being targeted
      KVM: x86: Don't update IRTE entries when old and new routes were !MSI
      KVM: SVM: Revert IRTE to legacy mode if IOMMU doesn't provide IR metadata
      KVM: SVM: Take and hold ir_list_lock across IRTE updates in IOMMU
      iommu/amd: Document which IRTE fields amd_iommu_update_ga() can modify
      iommu/amd: KVM: SVM: Infer IsRun from validity of pCPU destination
      iommu/amd: Factor out helper for manipulating IRTE GA/CPU info
      iommu/amd: KVM: SVM: Set pCPU info in IRTE when setting vCPU affinity
      iommu/amd: KVM: SVM: Add IRTE metadata to affined vCPU's list if AVIC is inhibited
      KVM: SVM: Don't check for assigned device(s) when updating affinity
      KVM: SVM: Don't check for assigned device(s) when activating AVIC
      KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
      KVM: SVM: Process all IRTEs on affinity change even if one update fails
      KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
      KVM: x86: Drop superfluous "has assigned device" check in kvm_pi_update_irte()
      KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
      KVM: x86: WARN if IRQ bypass routing is updated without in-kernel local APIC
      KVM: SVM: WARN if ir_list is non-empty at vCPU free
      KVM: x86: Decouple device assignment from IRQ bypass
      KVM: VMX: WARN if VT-d Posted IRQs aren't possible when starting IRQ bypass
      KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
      iommu/amd: WARN if KVM calls GA IRTE helpers without virtual APIC support
      KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
      KVM: SVM: Don't check vCPU's blocking status when toggling AVIC on/off
      KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
      iommu/amd: KVM: SVM: Allow KVM to control need for GA log interrupts
      KVM: SVM: Generate GA log IRQs only if the associated vCPUs is blocking
      KVM: x86: Rename kvm_set_msi_irq() => kvm_msi_to_lapic_irq()
      KVM: Use a local struct to do the initial vfs_poll() on an irqfd
      KVM: Acquire SCRU lock outside of irqfds.lock during assignment
      KVM: Initialize irqfd waitqueue callback when adding to the queue
      KVM: Add irqfd to KVM's list via the vfs_poll() callback
      KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
      sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
      xen: privcmd: Don't mark eventfd waiter as EXCLUSIVE
      sched/wait: Add a waitqueue helper for fully exclusive priority waiters
      KVM: Disallow binding multiple irqfds to an eventfd with a priority waiter
      KVM: Drop sanity check that per-VM list of irqfds is unique
      KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
      KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
      KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements

 arch/arm64/kvm/arm.c                              |  20 +-
 arch/arm64/kvm/vgic/vgic-its.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic-v4.c                     |  10 +-
 arch/x86/include/asm/irq_remapping.h              |  17 +-
 arch/x86/include/asm/kvm-x86-ops.h                |   2 +-
 arch/x86/include/asm/kvm_host.h                   |  45 +-
 arch/x86/include/asm/svm.h                        |  13 +-
 arch/x86/kvm/Kconfig                              |  10 +
 arch/x86/kvm/Makefile                             |   7 +-
 arch/x86/kvm/hyperv.c                             |  10 +-
 arch/x86/kvm/hyperv.h                             |   3 +-
 arch/x86/kvm/i8254.c                              |  90 ++-
 arch/x86/kvm/i8254.h                              |  17 +-
 arch/x86/kvm/i8259.c                              |  17 +-
 arch/x86/kvm/ioapic.c                             |  55 +-
 arch/x86/kvm/ioapic.h                             |  24 +-
 arch/x86/kvm/irq.c                                | 567 ++++++++++++++++-
 arch/x86/kvm/irq.h                                |  35 +-
 arch/x86/kvm/irq_comm.c                           | 469 ---------------
 arch/x86/kvm/lapic.c                              |   7 +-
 arch/x86/kvm/svm/avic.c                           | 702 ++++++++++------------
 arch/x86/kvm/svm/svm.c                            |   4 +
 arch/x86/kvm/svm/svm.h                            |  32 +-
 arch/x86/kvm/trace.h                              |  99 ++-
 arch/x86/kvm/vmx/capabilities.h                   |   1 -
 arch/x86/kvm/vmx/main.c                           |   2 +-
 arch/x86/kvm/vmx/posted_intr.c                    | 140 ++---
 arch/x86/kvm/vmx/posted_intr.h                    |  10 +-
 arch/x86/kvm/vmx/vmx.c                            |   2 -
 arch/x86/kvm/x86.c                                | 254 +-------
 drivers/hv/mshv_eventfd.c                         |   8 +
 drivers/iommu/amd/amd_iommu_types.h               |   1 -
 drivers/iommu/amd/iommu.c                         | 125 ++--
 drivers/iommu/intel/irq_remapping.c               |  10 +-
 drivers/irqchip/irq-gic-v4.c                      |   4 +-
 drivers/vfio/pci/vfio_pci_intrs.c                 |  10 +-
 drivers/vhost/vdpa.c                              |  10 +-
 include/kvm/arm_vgic.h                            |   2 +-
 include/linux/amd-iommu.h                         |  25 +-
 include/linux/irqbypass.h                         |  46 +-
 include/linux/irqchip/arm-gic-v4.h                |   2 +-
 include/linux/kvm_host.h                          |  18 +-
 include/linux/kvm_irqfd.h                         |   5 +-
 include/linux/wait.h                              |   2 +
 include/trace/events/kvm.h                        |  84 +--
 kernel/sched/wait.c                               |  22 +-
 tools/testing/selftests/kvm/Makefile.kvm          |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c      |  12 +-
 tools/testing/selftests/kvm/config                |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h    |  40 ++
 tools/testing/selftests/kvm/irqfd_test.c          | 135 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c        |  13 +-
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c |  21 +-
 virt/kvm/eventfd.c                                | 159 +++--
 virt/kvm/irqchip.c                                |   2 -
 virt/lib/irqbypass.c                              | 190 +++---
 56 files changed, 1848 insertions(+), 1766 deletions(-)
 delete mode 100644 arch/x86/kvm/irq_comm.c
 create mode 100644 tools/testing/selftests/kvm/irqfd_test.c

