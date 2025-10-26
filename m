Return-Path: <kvm+bounces-61099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712FFC0B20D
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4423B69C6
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1611E2FF157;
	Sun, 26 Oct 2025 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DPPqDugw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0988A263F38;
	Sun, 26 Oct 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510028; cv=none; b=NI9XiGxIJlo26FCJ2aCytUvKVIVJF1eibK4KK13wFuwWUcpSupJf1+UtJvbmo105CK7DuYSdCT6qDxQV4lv88JrYnFNKcSyGMBgAmm4Xs7f6f6XteS5LbFfyJDCoVxQlAhZU3ic8+srW/NBjK3biLQZBGpsf7hmcRyazCA/05XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510028; c=relaxed/simple;
	bh=O2SlNoha1QEAAQXSu7bbcaoAtrDNQRqBbh2zguKTkFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n8dbDENc1CtrGH+WrVyPqouqgf8LxSUXdF9Nwdu0i93eEL6jS3D2eZNqyTFIzXVx4L8rM7fCn+qzdpAy+5yZULMPQi8OU35JYFeni/pIVpQBvoR1sOXp13qPXuJ0Xyrl3S23bvCJ3o/5yQM5h6nMyrrEdS7VeMh+wUP7N3MCBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DPPqDugw; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkH505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:18 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkH505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509959;
	bh=r5tiYtYH9iv5FqtgW+BeCM3vdjiEmXUSTWLIgfYre0g=;
	h=From:To:Cc:Subject:Date:From;
	b=DPPqDugwZ+b9vQQtv2D1JdIgsB6pYHh+6ODowWPrp1sP9/WcXMC6h0ZLqXkcsKHYT
	 iSu4lQQZPFhrqmB+xrhzfj1d0OL0z/fVqe8lW6zZ5eBHHVQOorCYyVIo8/OrKe7CtY
	 5vbgaGw7pnjcgqL6AuulplYbUGSftt4ZGVih0GlKXEvTsnaaiJTJaSR283xAbB8Dpf
	 xi8kY1VJFrLUKwLPzgmVvOX76jo3ufdqrTzdBrO4FcTx2WC9bQIUkLeMWZwZm0Eyfa
	 nVcllQa870GMeU8vKXITcy6YxeIuD5pQFfjvGSR0IAzx/o9nH+O7XcFZtqKd5a5ta9
	 EEbeufuvBjgeQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 00/22] Enable FRED with KVM VMX
Date: Sun, 26 Oct 2025 13:18:48 -0700
Message-ID: <20251026201911.505204-1-xin@zytor.com>
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

With CET virtualization now merged in v6.18, the path is clear to submit
the FRED virtualization patch series :).


Changes in v9:
* Rebased to the latest kvm-x86/next branch, tag kvm-x86-next-2025.10.20-2.
* Guard FRED state save/restore with guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)
  in patch 19 (syzbot & Chao).
* Use array indexing for exception stack access, eliminating the need for
  the ESTACKS_MEMBERS() macro in struct cea_exception_stacks, and then
  exported __this_cpu_ist_top_va() in a subsequent patch (Dave Hansen).
* Rewrote some of the change logs.


Following is the link to v8 of this patch set:
https://lore.kernel.org/lkml/20251014010950.1568389-1-xin@zytor.com/


[1]: https://lore.kernel.org/kvm/ZvQaNRhrsSJTYji3@google.com/


Xin Li (18):
  KVM: VMX: Enable support for secondary VM exit controls
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
  KVM: nVMX: Enable support for secondary VM exit controls
  KVM: nVMX: Handle FRED VMCS fields in nested VMX context
  KVM: nVMX: Validate FRED-related VMCS fields
  KVM: nVMX: Guard SHADOW_FIELD_R[OW] macros with VMX feature checks
  KVM: nVMX: Enable VMX FRED controls

Xin Li (Intel) (4):
  x86/cea: Prefix event stack names with ESTACK_
  x86/cea: Use array indexing to simplify exception stack access
  x86/cea: Export __this_cpu_ist_top_va() to KVM
  KVM: x86: Save/restore the nested flag of an exception

 Documentation/virt/kvm/api.rst        |  21 +-
 arch/x86/coco/sev/noinstr.c           |   4 +-
 arch/x86/coco/sev/vc-handle.c         |   2 +-
 arch/x86/include/asm/cpu_entry_area.h |  70 +++---
 arch/x86/include/asm/kvm_host.h       |  13 +-
 arch/x86/include/asm/msr-index.h      |   1 +
 arch/x86/include/asm/vmx.h            |  48 +++-
 arch/x86/include/uapi/asm/kvm.h       |   4 +-
 arch/x86/kernel/cpu/common.c          |  10 +-
 arch/x86/kernel/dumpstack_64.c        |  18 +-
 arch/x86/kernel/fred.c                |   6 +-
 arch/x86/kernel/traps.c               |   2 +-
 arch/x86/kvm/cpuid.c                  |   1 +
 arch/x86/kvm/kvm_cache_regs.h         |  15 ++
 arch/x86/kvm/svm/svm.c                |   2 +-
 arch/x86/kvm/vmx/capabilities.h       |  25 +-
 arch/x86/kvm/vmx/nested.c             | 343 +++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h             |  22 ++
 arch/x86/kvm/vmx/vmcs.h               |   1 +
 arch/x86/kvm/vmx/vmcs12.c             |  19 ++
 arch/x86/kvm/vmx/vmcs12.h             |  40 ++-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  37 ++-
 arch/x86/kvm/vmx/vmx.c                | 247 +++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h                |  54 +++-
 arch/x86/kvm/x86.c                    | 131 +++++++++-
 arch/x86/kvm/x86.h                    |   8 +-
 arch/x86/mm/cpu_entry_area.c          |  39 ++-
 arch/x86/mm/fault.c                   |   2 +-
 include/uapi/linux/kvm.h              |   1 +
 29 files changed, 1038 insertions(+), 148 deletions(-)


base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
-- 
2.51.0


