Return-Path: <kvm+bounces-56335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4ABAB3BF59
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86EEE17C8CC
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2304333436D;
	Fri, 29 Aug 2025 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RdPPdEZI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F39131E0E4;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481590; cv=none; b=U+J8MEhDvGzo5QIweSZMxTCGatvvu+pdAUGjEHd4vXjRifTy6VhMvNdhPYQH8PV4LT0T01R2I7U78JMpdX797XCwjAjjFYUqA0+4Znv23llcMPduq5bvwsxAqClKxkcQS3JKVBNIy3h27IkXYS6IhT5pSRiRkUMgAQNmiYrt8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481590; c=relaxed/simple;
	bh=R6dJYQNyCZgQmuOZCcl6E7Yabdtd4949LSnMdTe8Xfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VnX6GHiEngMgj6Qkpg1+sNuIj7uLLvSztIcXUCAZoPausG3+WuqjkwJUcEHp3SyQgSiJT6MkgGvZn4XqIW4IiUgA7dy70xpPR+9sf9E/HdQbk9XbW7HgxZWVWqgpY0g2tZPc01QL16Yq5khryi1ML6ZH498DJslRHDbuioPVNYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RdPPdEZI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo462871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo462871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481532;
	bh=Lt/AL9+w/YxIfphx8onU3dlrkxpO05roZVHgni87qvI=;
	h=From:To:Cc:Subject:Date:From;
	b=RdPPdEZIfiludynwfntUN24DwoIWV9KjvowxfhTFKb+r9zMG8u4ngKxnjP0xio9h7
	 GKJbOA3lP6Dd8SNey0bT8lAR2lCZFGHaEv2AedmPmtEnO1JOv6UwYsAXHuvpgqHaii
	 0Oa18Kfq1fLv0MsEb9MNZ49bNQSkN0K/Nz0a7KKxcYTFdZc2mnThUp2NL/lhYOdQ35
	 YMB3LBavukxMLbsz//05n+Hi5q/EvmUI5kuiGTywIq++qmunlN48xFf85FxoTG1oPv
	 Nwa/V56eSaCIPSfQvi7g66EEHC2e2a8Qh+nyBEAVUnYKMXPk/XVr40SON9taLaP2kP
	 rWLT+4v5NfTNQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 00/21] Enable FRED with KVM VMX
Date: Fri, 29 Aug 2025 08:31:28 -0700
Message-ID: <20250829153149.2871901-1-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
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


Although FRED and CET supervisor shadow stacks are independent CPU
features, FRED unconditionally includes FRED shadow stack pointer
MSRs IA32_FRED_SSP[0123], and IA32_FRED_SSP0 is just an alias of the
CET MSR IA32_PL0_SSP.  IOW, the state management of MSR IA32_PL0_SSP
becomes an overlap area, and Sean requested that FRED virtualization
to land after CET virtualization [1].


Following is the link to v6 of this patch set:
https://lore.kernel.org/lkml/20250821223630.984383-1-xin@zytor.com/


This v7 patch set is based on the kvm-x86-next-2025.08.21 tag of the
kvm-x86 repo + v13 of the KVM CET patch set
https://lore.kernel.org/lkml/20250821133132.72322-1-chao.gao@intel.com/,
and also available at
https://github.com/xinli-intel/linux-fred-public.git fred-kvm-v7


Changes in v7:
* Intercept accesses to FRED SSP0, i.e., IA32_PL0_SSP, which remains
  accessible when FRED but !CET (Sean).
* Remove Suggested-bys in patch 4 of v6 (Dave Hansen).
* Fix a vertical alignment in patch 4 of v6 (Dave Hansen).
* Move rename code into a new separate patch (Dave Hansen).
* Access cea_exception_stacks using array indexing (Dave Hansen).
* Use BUILD_BUG_ON(ESTACK_DF != 0) to ensure the starting index is 0
  (Dave Hansen).


[1]: https://lore.kernel.org/kvm/ZvQaNRhrsSJTYji3@google.com/


Xin Li (18):
  KVM: VMX: Add support for the secondary VM exit controls
  KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
  KVM: VMX: Disable FRED if FRED consistency checks fail
  KVM: VMX: Initialize VMCS FRED fields
  KVM: VMX: Set FRED MSR intercepts
  KVM: VMX: Save/restore guest FRED RSP0
  KVM: VMX: Add support for saving and restoring FRED MSRs
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

Xin Li (Intel) (3):
  x86/cea: Prefix event stack names with ESTACK_
  x86/cea: Export API for per-CPU exception stacks for KVM
  KVM: x86: Save/restore the nested flag of an exception

 Documentation/virt/kvm/api.rst            |  21 +-
 Documentation/virt/kvm/x86/nested-vmx.rst |  19 ++
 arch/x86/coco/sev/sev-nmi.c               |   4 +-
 arch/x86/coco/sev/vc-handle.c             |   2 +-
 arch/x86/include/asm/cpu_entry_area.h     |  75 +++--
 arch/x86/include/asm/kvm_host.h           |  13 +-
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/vmx.h                |  48 ++-
 arch/x86/include/uapi/asm/kvm.h           |   4 +-
 arch/x86/kernel/cpu/common.c              |  10 +-
 arch/x86/kernel/dumpstack_64.c            |  14 +-
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
 arch/x86/kvm/vmx/vmx.c                    | 247 +++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                    |  54 +++-
 arch/x86/kvm/x86.c                        | 148 +++++++++-
 arch/x86/kvm/x86.h                        |   8 +-
 arch/x86/mm/cpu_entry_area.c              |  37 ++-
 arch/x86/mm/fault.c                       |   2 +-
 include/uapi/linux/kvm.h                  |   1 +
 30 files changed, 1070 insertions(+), 144 deletions(-)

-- 
2.51.0


