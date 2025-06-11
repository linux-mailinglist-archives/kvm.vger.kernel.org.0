Return-Path: <kvm+bounces-49146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF19BAD62FA
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D571E201D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FDC2571B2;
	Wed, 11 Jun 2025 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NB+6yLdL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2F324DD07
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682019; cv=none; b=k7JDHli+suC4jwgm4FNnj1nojRv6hBEXzAqhTdmBodoz1n2Ds5AZuTHS3ZjaBopu/qdXZsGF4smDja53ebREoo+Tun/feZ14c+0hzScCzxl46LfM5mrG8pQnCdYMx4cNKUsf4eK02oTAsP7j0Cn9NqRI+1ODYif52M1iBQxXXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682019; c=relaxed/simple;
	bh=vBnIq5pOWsjohn7+v57cT5BpsFB4ytz7OF7cElux4JU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WhOsrCc7AcyzEGZRsGT270Nmzg62RUErDi2m2o+POcuWwYycO888ptapGHjlX/ZeDef0ZoKQWVATOkpyHv7tO/hig9Y0tj+7uO/ZQ39gfBlfMe7lQ7FrlO4ke/nY1L2ZCbsykH07HEByjtuNh6NfjpXgwWnSe8ts68ZUhJ/62gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NB+6yLdL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31202bbaafaso279094a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682015; x=1750286815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuHtXaj1Biz1nUMcTjF2zl2xw7uUrRWD5AKPktJzapU=;
        b=NB+6yLdLw3gfe6hFqY21mcJfpCLXn3A4a+5jjzSUS146yQsjLMG8uoZPX6714Mvp+v
         2wTEsPREPP5elx0ZMSzUuA8i0CSu18eUYedR95ftRrho7QxTfR5uKFmYmuYyWfckFa95
         lh5RS7PUYDIK+YLh218tfj6W/IApMma8j44qIgOhhT1eyz73EJidqwO8ocP4I1clbaa4
         ZAuXJnXI3bHJsaHE70uPFg6maMfD6WQi3KTsPg+tf4gfq3hD4iitxWuiETW2t8pT8qWM
         EGNTMdE3Uz7oczmKc7usJ6tX1DCGin9XP1Rn51HgW82VN7/oq9PsO+eGi6kG2TZXSI6B
         5/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682015; x=1750286815;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JuHtXaj1Biz1nUMcTjF2zl2xw7uUrRWD5AKPktJzapU=;
        b=g8T9+jokrs6kmiLtgpeRaUVF77PHnimjnw4zlWhDOA3Z4PMO5Y4rC1OX/prFypo4Zs
         ZTqG4rXD7svwzvdg4dzWJqtNGheWt0A6iplYrGyEsqfvOPtcTr+ws+JyFPJft9od8jgr
         Nl7P90Pd/98Syn8GI6+5BnYdYW7LautIurdNCHWNl4VbCLCVP+AGsf7qo1Be1ZUx0eRW
         AmswxbuZnLUdwHJJtPRptqKvtxK7VkqUAl1Vxnxmmap9RhaOqkG+iMEyYprYbt2o03IJ
         D6694lOl9c8pwcPgV/yXVAJGv3Zlm4p3KrTcMWeFJM/gtvYguly/5MmwuGm33ym/8tis
         WJQw==
X-Forwarded-Encrypted: i=1; AJvYcCVdHZQwiDJnR1rOuBIlSI2umizQc8VJ6164D9HK6dbII90qprUo4t/cRo4OqOFmRZjhRLg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv6mckTmWroYg1g20YQLhUCvTgkkV+tNTWXQUH3hRfYVY5hCWU
	kgVcvyULuvyWkkQvxt4+/SOZhpzG+uzoibAijzBnOWo/27mvFIhankZexRbgivaygXRQhTzhFcz
	ZzzlZjw==
X-Google-Smtp-Source: AGHT+IGScfhk9tXXQjQ5gd+DYVe69xOrENw6SUmp7AYJ+hW5WmHJfBnXO4CQhyqOWjviuMvO72zZmRDIqrc=
X-Received: from pjwx3.prod.google.com ([2002:a17:90a:c2c3:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288c:b0:311:ae39:3dad
 with SMTP id 98e67ed59e1d1-313c08d2311mr1006186a91.30.1749682015616; Wed, 11
 Jun 2025 15:46:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-2-seanjc@google.com>
Subject: [PATCH v3 00/62] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Marc/Oliver,

Patch 1 is an arm64 fix that I'm guessing you'll want to grab for 6.16.
Assuming that's the case, I'll make sure this series lands on top of
kvm/master (or maybe an -rc?) at the appropriate point in time.  Though if you
can grab the patch sooner than later, that'd be super helpful :-)

Oh, and the other patches are of interest to arm64 are:

  [PATCH v3 32/62] KVM: Don't WARN if updating IRQ bypass route fails
  [PATCH v3 33/62] KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()

In theory, I _think_ those could be moved earlier so that there aren't
multi-arch patches buried in a massive x86-centric series, but I really don't
want to try and re-disentangle x86's posted interrupt mess at this point.


TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
       general.

This applies on the series to add CONFIG_KVM_IOAPIC (and to kill irq_comm.c):

  https://lore.kernel.org/all/20250611213557.294358-1-seanjc@google.com

Fix a variety of bugs related to device posted IRQs, especially on the
AMD side, and clean up KVM's implementation (this series actually removes
more code than it adds).

Batch #1 is new in this version, and consists of two aforementioned arm64
changes.

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
fixes (I don't want to add the WARNs earlier; I don't see any point in adding
WARNs in code that's known to be broken).

Batch #6 is yet more SVM/AVIC cleanups, with the specific goal of configuring
IRTEs to generate GA log interrupts if and only if KVM actually needs a wake
event.

v3:
 - Rebase on kvm/next to pick up relevant arm64 irqfd routing changes, and
   account for arm64 as appropriate.
 - Fix a suspiciously similar bug in arm64's version of
   kvm_arch_irqfd_route_changed().
 - Add a patch to rename kvm_set_msi_irq() to kvm_msi_to_lapic_irq().

v2:
 - https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com
 - Drop patches that were already merged.
 - Move code into irq.c, not x86.c. [Paolo]
 - Collect review/testing tags. [Sairaj, Vasant]
 - Sqaush fixup for a comment that was added in the prior patch. [Sairaj]
 - Rewrote the changelog for "Delete IRTE link from previous vCPU irrespective
   of new routing". [Sairaj]
 - Actually drop "struct amd_svm_iommu_ir" and all usage in "Track per-vCPU
   IRTEs using kvm_kernel_irqfd structure" (the previous version was getting
   hilarious lucky with struct offsets). [Sairaj]
 - Drop unused params from kvm_pi_update_irte() and pi_update_irte(). [Sairaj]
 - Document the rules and behavior of amd_iommu_update_ga(). [Joerg]
 - Fix a changelog typo. [Paolo]
 - Document that GALogIntr isn't cached, i.e. can be safely updated without
   an invalidation. [Joao, Vasant]
 - Rework avic_vcpu_{load,put}() to use an enumerated parameter instead of a
   series of booleans. [Paolo]
 - Drop a redundant "&& new". [Francesco]
 - Drop the *** DO NOT MERGE *** testing hack patches.

v1: https://lore.kernel.org/all/20250404193923.1413163-1-seanjc@google.com

Maxim Levitsky (2):
  KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
  KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235

Sean Christopherson (60):
  KVM: arm64: Explicitly treat routing entry type changes as changes
  KVM: arm64: WARN if unmapping vLPI fails
  KVM: Pass new routing entries and irqfd when updating IRTEs
  KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
  KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
  iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
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
  iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
  KVM: SVM: Stop walking list of routing table entries when updating
    IRTE
  KVM: VMX: Stop walking list of routing table entries when updating
    IRTE
  KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
  KVM: x86: Move IRQ routing/delivery APIs from x86.c => irq.c
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
  iommu/amd: Document which IRTE fields amd_iommu_update_ga() can modify
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
  KVM: x86: Rename kvm_set_msi_irq() => kvm_msi_to_lapic_irq()

 arch/arm64/kvm/arm.c                 |  19 +-
 arch/arm64/kvm/vgic/vgic-v4.c        |  10 +-
 arch/x86/include/asm/irq_remapping.h |  17 +-
 arch/x86/include/asm/kvm-x86-ops.h   |   2 +-
 arch/x86/include/asm/kvm_host.h      |  23 +-
 arch/x86/include/asm/svm.h           |  13 +-
 arch/x86/kvm/irq.c                   | 152 +++++-
 arch/x86/kvm/svm/avic.c              | 702 ++++++++++++---------------
 arch/x86/kvm/svm/svm.c               |   4 +
 arch/x86/kvm/svm/svm.h               |  32 +-
 arch/x86/kvm/trace.h                 |  19 +-
 arch/x86/kvm/vmx/capabilities.h      |   1 -
 arch/x86/kvm/vmx/main.c              |   2 +-
 arch/x86/kvm/vmx/posted_intr.c       | 140 ++----
 arch/x86/kvm/vmx/posted_intr.h       |  10 +-
 arch/x86/kvm/vmx/vmx.c               |   2 -
 arch/x86/kvm/x86.c                   |  90 +---
 drivers/iommu/amd/amd_iommu_types.h  |   1 -
 drivers/iommu/amd/iommu.c            | 125 +++--
 drivers/iommu/intel/irq_remapping.c  |  10 +-
 include/kvm/arm_vgic.h               |   2 +-
 include/linux/amd-iommu.h            |  25 +-
 include/linux/kvm_host.h             |   9 +-
 include/linux/kvm_irqfd.h            |   4 +
 virt/kvm/eventfd.c                   |  22 +-
 25 files changed, 691 insertions(+), 745 deletions(-)


base-commit: 06880162469d702d052e5d51b49a24e43f182af8
-- 
2.50.0.rc1.591.g9c95f17f64-goog


