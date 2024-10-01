Return-Path: <kvm+bounces-27722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 198DD98B353
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2748284176
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EA01BDA9C;
	Tue,  1 Oct 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WH9cmggB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80788191F8D;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=OX1tacmnlnnIoz2VyJfv+LgI8jWjAVHjky+eX0op2OgkLKnua+nigERPPnehvUYAgO/yukQfWhY76vHQrxNZEB73wnSqCfAEVmLVrdB05x/SImusjAwj7SnCWUooj8Uv4aQ2B7x4lP+xdkhpUChnopUvvQDKdNhHn/rXpiML7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=U7EmXCkYhk+0D2z/ABSBBVPD3dz44DJtR3mhNRJtEpU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gDyjgNPelG6503HcU3Hf+uFvAbRg2TRjI633gjzUNfhVVOGRx4PezdGmm4KGWKpzSZm9BA3HzHl+NbhfjZmbG1blf05jYg2LDJMqtI8gK1QBm5wwu7UIusZqFUp+1xmPFO2a7R8oBBQHLUbl0B4rBLJ6nd2NThYZerRjm2Ksj8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WH9cmggB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7P3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7P3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758876;
	bh=ySJL6936WxkCzK3GYA0yow9swO+GvxRvS+6BpZdApcM=;
	h=From:To:Cc:Subject:Date:From;
	b=WH9cmggBQZBWV0QFzUo3SfhUErsHuiV0Q68lhSeG9pqKeRUAkB7fg75Rhp8zLFGHE
	 fmeAVNR8YSnO0LRYEvBEAqGU+8clWZEcI8YGA7AJrF2gYjJU3yT5RYnavgcGn+FzLX
	 GcisfceOd2DAm4SKVtSoazMkOkBZqMFa7v8vCKI7H0F5lEosytgJ+fu9AkHC1xFgLS
	 V9xphBxYQxxOvnnoLOg+NFsOKT/5gWUKG0meBCBOrAALdbQU4KEql3PQUY6Z6iiF6d
	 ftCcQXBpVUX6bO8cJfV8AzouxREy6PWg9tEQjN2RZeKVW/V8kmUdrGziQ/dVYT+uDI
	 7S/gIWSgahS0w==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 00/27] Enable FRED with KVM VMX
Date: Mon, 30 Sep 2024 22:00:43 -0700
Message-ID: <20241001050110.3643764-1-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The first 20 patches add FRED support to VMX, and the rest 7 patches
add FRED support to nested VMX.


Following is the link to the v2 of this patch set:
https://lore.kernel.org/kvm/20240207172646.3981-1-xin3.li@intel.com/

Sean Christopherson (3):
  KVM: x86: Use a dedicated flow for queueing re-injected exceptions
  KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
  KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM

Xin Li (21):
  KVM: VMX: Add support for the secondary VM exit controls
  KVM: VMX: Initialize FRED VM entry/exit controls in vmcs_config
  KVM: VMX: Disable FRED if FRED consistency checks fail
  KVM: VMX: Initialize VMCS FRED fields
  KVM: x86: Use KVM-governed feature framework to track "FRED enabled"
  KVM: VMX: Set FRED MSR interception
  KVM: VMX: Save/restore guest FRED RSP0
  KVM: VMX: Add support for FRED context save/restore
  KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
  KVM: VMX: Virtualize FRED event_data
  KVM: VMX: Virtualize FRED nested exception tracking
  KVM: x86: Mark CR4.FRED as not reserved when guest can use FRED
  KVM: VMX: Dump FRED context in dump_vmcs()
  KVM: x86: Allow FRED/LKGS to be advertised to guests
  KVM: x86: Allow WRMSRNS to be advertised to guests
  KVM: VMX: Invoke vmx_set_cpu_caps() before nested setup
  KVM: nVMX: Add support for the secondary VM exit controls
  KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros
  KVM: nVMX: Add FRED VMCS fields
  KVM: nVMX: Add VMCS FRED states checking
  KVM: nVMX: Allow VMX FRED controls

Xin Li (Intel) (3):
  x86/cea: Export per CPU variable cea_exception_stacks
  KVM: VMX: Do not use MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
  KVM: nVMX: Add a prerequisite to existence of VMCS fields

 Documentation/virt/kvm/x86/nested-vmx.rst |  19 ++
 arch/x86/include/asm/kvm_host.h           |   9 +-
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/vmx.h                |  32 ++-
 arch/x86/kvm/cpuid.c                      |   4 +-
 arch/x86/kvm/governed_features.h          |   1 +
 arch/x86/kvm/kvm_cache_regs.h             |  15 ++
 arch/x86/kvm/svm/svm.c                    |  15 +-
 arch/x86/kvm/vmx/capabilities.h           |  17 +-
 arch/x86/kvm/vmx/nested.c                 | 291 ++++++++++++++++----
 arch/x86/kvm/vmx/nested.h                 |   8 +
 arch/x86/kvm/vmx/nested_vmcs_fields.h     |  25 ++
 arch/x86/kvm/vmx/vmcs.h                   |   1 +
 arch/x86/kvm/vmx/vmcs12.c                 |  19 ++
 arch/x86/kvm/vmx/vmcs12.h                 |  38 +++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h     |  37 ++-
 arch/x86/kvm/vmx/vmx.c                    | 308 +++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h                    |  15 +-
 arch/x86/kvm/x86.c                        | 140 ++++++----
 arch/x86/kvm/x86.h                        |   8 +-
 arch/x86/mm/cpu_entry_area.c              |   1 +
 21 files changed, 846 insertions(+), 158 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/nested_vmcs_fields.h


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.46.2


