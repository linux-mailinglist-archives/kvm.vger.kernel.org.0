Return-Path: <kvm+bounces-47450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BE1AC1906
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE562A27E5D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9551F4165;
	Fri, 23 May 2025 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfEoEcbp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64BC1F1524
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962013; cv=none; b=s2IOFYWkVl8fRmIQ/gBj+GJlLdsIMLepIpyF2OzvQldbHYqDzDNMy3HYwIswDX/4OSHjj7osFwSRVZ5ocCtTSSxzDm0fwJsneZ7P0ErHzHS1VoTqqq9aJ+GjfWhh330a3zMd++bOBRYypk+W+xP+KUsH8GTMNEZt8LP5wlQ5W5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962013; c=relaxed/simple;
	bh=biSP/RElUvnB1P1L6qHmpOQ1N71dp2oSy6pxd4IxXLY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PvT3cMpZ8H5nRHc5KWapselFmjpS2uRpUDpSqna3kRbYJYPGCc1ArgDuIVIxIb1DqGJe1NuhY4UKbRkmd6vg0Hvf4K8Q9b1lRPvJGduUzrnVE6v/xjrA4waT1xvJV4+N2J8oT6LbIy9w7SQBIJZHAalifv/VOj2liu1tI/VoO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfEoEcbp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af59547f55bso5190656a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962011; x=1748566811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWmLXJzC9mxFkQYj92kdzkjh5kkvtzBuQ9m+OSqSfeU=;
        b=mfEoEcbpdlTCwGSaGqG8eVwjyEc4GFr8teTtSNlzbMViO0gOjGuXqMGJ8+RXWtJycq
         8irBugSbjRQboTSXsauauu1czLlvFT06TsLxlMdHhDPdZ4wZUBDSQENo79cOSw4EDXmK
         Tc7rD6E8nq+jwdIL21rtZAPr8GFz5Q2QW2gVs30SSYv/IdOrC4NWjcRgeI6i6bzda1Vs
         OOaxEs8U3pwzX1/SZfSXp1p1tHWetzdjR7yp7U2bT+5S8w9oXZ4z4QvMU5itGgyjMf7M
         mHOJXf2Acs7tGZqQfTrRnpfrcmPCFFs/c88z8W2gHB17aHB3Ip+j3dUd+ELieUoG/BdN
         v2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962011; x=1748566811;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWmLXJzC9mxFkQYj92kdzkjh5kkvtzBuQ9m+OSqSfeU=;
        b=Q3Khw+NEgMxZ+gmJwzEvLXp9tgOy9s4X+KgoL8JTTNDIDX8VJjaRwAoIGj/xIWpQMi
         /6iVzhUfDk7EY3qxwXVBk0HijMEAN3dLSW9oeM2MkgzWe1DGRdbXj7F2n8d2vtqP8JPq
         kNUpi1Py+bLR4NoL4/UXvbeZVfeOY1X22eie2X1gUW3TGJk9Vmq9KPhSrE+cMvkUbTfv
         eISbaGEH2HInvX5NEFRoi+AlxyqXLDb1sCTzM2BdMvb9WCYV0fUzpDtNwIred1eNvZ8Q
         WDTKmEyuLnXXoxBpdTugEgnFhZdwjB6M0sgPuR911k32wDuI4DSWh32Kd8P/WCIRH8LS
         vfeg==
X-Gm-Message-State: AOJu0YyFDqxYmRL4CcbSqFmXw2ru1mqSSkjZQ16HG3U/MWHbzepi+nG/
	+MLZlT17uPe/UwkyFw1oMmUya4WWMPYGFr7zqgH7ypC3C6TNS2A9XI70T2KtVEkENaKhJUJf3Lo
	hMivLJg==
X-Google-Smtp-Source: AGHT+IGOgLpofs6bAdGinxnH4Es1IEAINUEcE+ZxHgfQ8A0l+jmCduN+XjF7ckQz21BAe1IxauoQZPltAZw=
X-Received: from pjbqj8.prod.google.com ([2002:a17:90b:28c8:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d85:b0:2f9:d9fe:e72e
 with SMTP id 98e67ed59e1d1-30e8312dcd2mr50071317a91.16.1747962010923; Thu, 22
 May 2025 18:00:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-1-seanjc@google.com>
Subject: [PATCH v2 00/59] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
       general.

This applies on the series to add CONFIG_KVM_IOAPIC (and to kill irq_comm.c):

  https://lore.kernel.org/all/20250519232808.2745331-1-seanjc@google.com

Fix a variety of bugs related to device posted IRQs, especially on the
AMD side, and clean up KVM's implementation (this series actually removes
more code than it adds).

Stating the obvious, this series is comically large.  Though it's smaller than
v1! (Ignoring that I cheated by moving 15 patches to a prep series, and that
Paolo already grabbed several patches).

Sairaj, I applied your Tested-by somewhat sparingly, as some of the patches
changed (most notably "Consolidate IRTE update when toggling AVIC on/off").
Please holler if you want me to remove/add any tags.  And when you get time,
I'd greatly appreciate a sanity check!

Batch #1 is mostly SVM specific:

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

v2:
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

Sean Christopherson (57):
  KVM: x86: Pass new routing entries and irqfd when updating IRTEs
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

 arch/x86/include/asm/irq_remapping.h |  17 +-
 arch/x86/include/asm/kvm-x86-ops.h   |   2 +-
 arch/x86/include/asm/kvm_host.h      |  20 +-
 arch/x86/include/asm/svm.h           |  13 +-
 arch/x86/kvm/irq.c                   | 140 ++++++
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
 include/linux/amd-iommu.h            |  25 +-
 include/linux/kvm_host.h             |   9 +-
 include/linux/kvm_irqfd.h            |   4 +
 virt/kvm/eventfd.c                   |  22 +-
 22 files changed, 672 insertions(+), 718 deletions(-)


base-commit: 3debd5461fba1dcb33e732b16153da0cf5d0c251
-- 
2.49.0.1151.ga128411c76-goog


