Return-Path: <kvm+bounces-55429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC23B3095C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73035C2E8C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171CB2FC036;
	Thu, 21 Aug 2025 22:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MLoHxnxG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51B02EAB6D;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815883; cv=none; b=na8mBu0mMvoiwkCE6us/yJMUXiY1saZ5xstJrwA4kbtzmE+LNwBGD0C9plqoMb1jlVSOIwlXQWJaRSb7A/Axip6n33tJQawRlYp4Fn2uJKF/l9Ab6kSi/fp4fgfqtPkf1uBkOjZQVC/VspAyfTZqTfea6uCnj3VMXDefTIpAZiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815883; c=relaxed/simple;
	bh=tH0A20LeFVMAcXxRmEq18alfQDdKNelyxd45De45fZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=js/hOHxeKlF39XmJ7xOb8/ulfXhzt6doA8o2v+08NcikPB0noJ+hWM0FdgZAKocx+yXTP03gFSVnkwpVBvX9ojaXSDs2G/oip9lVFrgCZgvD9+StY7tpG7Dy16/gPpYN3s8XvWJsEdfJdWjirXYkRhdJspw5NhlqF9vC9pwkJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MLoHxnxG; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOO984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:40 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOO984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815802;
	bh=ufRlfc+XSZnu+2Vt42wMH77mgBiPp9rxfEBFmv9sSI4=;
	h=From:To:Cc:Subject:Date:From;
	b=MLoHxnxG/DQOGz3ON7sacosIbmSZ/ItYKxScaasfFScOqFNN0xVMdymrrTjGY7HGR
	 ME1sBFvSmLFkK66wkjuxva04wHJ9Xvm1SFRGEnFIUd+VltLkOm8bVTcPqC1ZNSWaz9
	 Z6qN5+rLB7gv5uaZLR+gtYYAwfLEUpwoWc978nIOowN5fMX+vOV+nYo0/fsh9cFP9S
	 sfUx5t+lV9zrQovC/6MNuVe3AbPBG+nnZUoWSsKzg/1QLKz3h9jFh2Pt+gNq/qzSra
	 4cFGFSTuotO1+0aIb269L0dtPIhsSO9Ow/GqQIKjHsjNu1Qk2T6NdkaphrgvUAxRK5
	 PloOOEJQXkjzw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 00/20] Enable FRED with KVM VMX
Date: Thu, 21 Aug 2025 15:36:09 -0700
Message-ID: <20250821223630.984383-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set enables the Intel flexible return and event delivery
(FRED) architecture with KVM VMX to allow guests to utilize FRED.

The FRED architecture defines simple new transitions that change
privilege level (ring transitions). The FRED architecture was
designed with the following goals:

1) Improve overall performance and response time by replacing event
   delivery through the interrupt descriptor table (IDT event
   delivery) and event return by the IRET instruction with lower
   latency transitions.

2) Improve software robustness by ensuring that event delivery
   establishes the full supervisor context and that event return
   establishes the full user context.

The new transitions defined by the FRED architecture are FRED event
delivery and, for returning from events, two FRED return instructions.
FRED event delivery can effect a transition from ring 3 to ring 0, but
it is used also to deliver events incident to ring 0. One FRED
instruction (ERETU) effects a return from ring 0 to ring 3, while the
other (ERETS) returns while remaining in ring 0. Collectively, FRED
event delivery and the FRED return instructions are FRED transitions.

Intel VMX architecture is extended to run FRED guests, and the major
changes are:

1) New VMCS fields for FRED context management, which includes two new
event data VMCS fields, eight new guest FRED context VMCS fields and
eight new host FRED context VMCS fields.

2) VMX nested-exception support for proper virtualization of stack
levels introduced with FRED architecture.

Search for the latest FRED spec in most search engines with this search
pattern:

  site:intel.com FRED (flexible return and event delivery) specification


Following is the link to the v5 of this patch set:
https://lore.kernel.org/lkml/20250723175341.1284463-1-xin@zytor.com/


Although FRED and CET supervisor shadow stacks are independent CPU
features, FRED unconditionally includes FRED shadow stack pointer
MSRs IA32_FRED_SSP[0123], and IA32_FRED_SSP0 is just an alias of the
CET MSR IA32_PL0_SSP.  IOW, the state management of MSR IA32_PL0_SSP
becomes an overlap area, and Sean requested that FRED virtualization
to land after CET virtualization [1].


This v6 patch set is based on the kvm-x86-next-2025.08.20 tag of the
kvm-x86 repo + v13 of the KVM CET patch set, and also available at
https://github.com/xinli-intel/linux-fred-public.git fred-kvm-v6


Changes in v6:
1) Return KVM_MSR_RET_UNSUPPORTED instead of 1 when FRED is not available
   (Chao Gao)
2) Handle MSR_IA32_PL0_SSP when FRED is enumerated but CET not.
3) Handle FRED MSR pre-vmenter save/restore (Chao Gao).
4) Save FRED MSRs of vmcs02 at VM-Exit even an L1 VMM clears
   SECONDARY_VM_EXIT_SAVE_IA32_FRED.
5) Save FRED MSRs in sync_vmcs02_to_vmcs12() instead of its rare version.


[1]: https://lore.kernel.org/kvm/ZvQaNRhrsSJTYji3@google.com/


Xin Li (18):
  KVM: VMX: Add support for the secondary VM exit controls
  KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
  KVM: VMX: Disable FRED if FRED consistency checks fail
  KVM: VMX: Initialize VMCS FRED fields
  KVM: VMX: Set FRED MSR intercepts
  KVM: VMX: Save/restore guest FRED RSP0
  KVM: VMX: Add support for FRED context save/restore
  KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
  KVM: VMX: Virtualize FRED event_data
  KVM: VMX: Virtualize FRED nested exception tracking
  KVM: x86: Mark CR4.FRED as not reserved
  KVM: VMX: Dump FRED context in dump_vmcs()
  KVM: x86: Advertise support for FRED
  KVM: nVMX: Add support for the secondary VM exit controls
  KVM: nVMX: Add FRED VMCS fields to nested VMX context handling
  KVM: nVMX: Add FRED-related VMCS field checks
  KVM: nVMX: Add prerequisites to SHADOW_FIELD_R[OW] macros
  KVM: nVMX: Allow VMX FRED controls

Xin Li (Intel) (2):
  x86/cea: Export an API to get per CPU exception stacks for KVM to use
  KVM: x86: Save/restore the nested flag of an exception

 Documentation/virt/kvm/api.rst            |  21 +-
 Documentation/virt/kvm/x86/nested-vmx.rst |  19 ++
 arch/x86/coco/sev/sev-nmi.c               |   4 +-
 arch/x86/coco/sev/vc-handle.c             |   2 +-
 arch/x86/include/asm/cpu_entry_area.h     |  17 +-
 arch/x86/include/asm/kvm_host.h           |   8 +-
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/vmx.h                |  48 ++-
 arch/x86/include/uapi/asm/kvm.h           |   4 +-
 arch/x86/kernel/cpu/common.c              |  10 +-
 arch/x86/kernel/fred.c                    |   6 +-
 arch/x86/kernel/traps.c                   |   2 +-
 arch/x86/kvm/cpuid.c                      |   1 +
 arch/x86/kvm/kvm_cache_regs.h             |  15 +
 arch/x86/kvm/svm/svm.c                    |   2 +-
 arch/x86/kvm/vmx/capabilities.h           |  25 +-
 arch/x86/kvm/vmx/nested.c                 | 338 +++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h                 |  22 ++
 arch/x86/kvm/vmx/vmcs.h                   |   1 +
 arch/x86/kvm/vmx/vmcs12.c                 |  19 ++
 arch/x86/kvm/vmx/vmcs12.h                 |  38 +++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h     |  37 ++-
 arch/x86/kvm/vmx/vmx.c                    | 240 ++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                    |  54 +++-
 arch/x86/kvm/x86.c                        | 115 +++++++-
 arch/x86/kvm/x86.h                        |   8 +-
 arch/x86/mm/cpu_entry_area.c              |  21 ++
 arch/x86/mm/fault.c                       |   2 +-
 include/uapi/linux/kvm.h                  |   1 +
 29 files changed, 976 insertions(+), 105 deletions(-)

-- 
2.50.1


