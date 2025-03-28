Return-Path: <kvm+bounces-42192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80792A74EFF
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CA88188DD34
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A241E3785;
	Fri, 28 Mar 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PS/1Qu+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2E71CFEC3;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181995; cv=none; b=XTd3ZXZQ3jYc/VrwBtHrenQPQjpB72gnGd5N92pG0WyEEm5haHHjQPb3CoOi2pD9EALwlrJcb/rnTGb7EOZnKPw0cs7qLWhsgmHXslczuml3YqX3cR+bSC/Rz9NGImR+7or9MIIeaTWWnFg28m+VxSLQsA0cbGefHPU7E9M86Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181995; c=relaxed/simple;
	bh=1UEe2ZUUIwJYZI/Wb2iC/iMXfyJTUBGVP1whccfDJoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E6yupm0ucXh+XNXk2KGmN1SZPG7WQp1neTjVEB4EeXg5FqdmgmejTuMukUdVTIMwUlEi2sQo7F6estehn9VTDgWk7pOSzpKBUdTY6IomcgLaT+7Dm7coC30YNqe7oDPHdQvesKhkn3HbQRHSTnQl3hLzePtjm12YnK7OqU5/Qkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PS/1Qu+2; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vW2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vW2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181934;
	bh=wrTcXCC95mvMn2X0Ty0Tmz2cq/ZeUYBrBQm9agHaZTk=;
	h=From:To:Cc:Subject:Date:From;
	b=PS/1Qu+2ThvTaq9rqP4M3CwiEtiNnoqZfbXkf2A79JxJc1zVMLZPxR+4K+vFfk5Sj
	 3zxqmgtd3Qp/+HG2uGIfOYdWHvzuAiK7KXM5/fh6i4zEu4qo2Vi7JGipvEzKPY9aap
	 QiZ2t0ws5drIBbj8otPem5QfgVjg/H1+JfzojuJO7+w01zrQTKXtkO7Bbkq49Ib5jM
	 ndr2Kjc+R/4GfhxFa3n6P0GmaQ2Byskxs6BtL4XCpC6cMeKrRlyceyXtNwTNJFDcM1
	 P2o0CyGWRed6z/5Vw0QihdbpNOdEnXf5q55EmR8JzWSN2bRID3cGzllI2wi1orN5ZO
	 d59Y0ZnfW3cHw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 00/19] Enable FRED with KVM VMX
Date: Fri, 28 Mar 2025 10:11:46 -0700
Message-ID: <20250328171205.2029296-1-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
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

Following is the link to the v3 of this patch set:
https://lore.kernel.org/lkml/20241001050110.3643764-1-xin@zytor.com/

Since several preparatory patches in v3 have been merged, and Sean
reiterated that it's NOT worth to precisely track which fields are/
aren't supported [1], v4 patch number is reduced to 19.

Although FRED and CET supervisor shadow stacks are independent CPU
features, FRED unconditionally includes FRED shadow stack pointer
MSRs IA32_FRED_SSP[0123], and IA32_FRED_SSP0 is just an alias of the
CET MSR IA32_PL0_SSP.  IOW, the state management of MSR IA32_PL0_SSP
becomes an overlap area, and Sean requested that FRED virtualization
to land after CET virtualization [2].

[1]: https://lore.kernel.org/lkml/Z73uK5IzVoBej3mi@google.com/
[2]: https://lore.kernel.org/kvm/ZvQaNRhrsSJTYji3@google.com/


Xin Li (17):
  KVM: VMX: Add support for the secondary VM exit controls
  KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
  KVM: VMX: Disable FRED if FRED consistency checks fail
  KVM: VMX: Initialize VMCS FRED fields
  KVM: VMX: Set FRED MSR interception
  KVM: VMX: Save/restore guest FRED RSP0
  KVM: VMX: Add support for FRED context save/restore
  KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
  KVM: VMX: Virtualize FRED event_data
  KVM: VMX: Virtualize FRED nested exception tracking
  KVM: x86: Mark CR4.FRED as not reserved
  KVM: VMX: Dump FRED context in dump_vmcs()
  KVM: x86: Allow FRED/LKGS to be advertised to guests
  KVM: nVMX: Add support for the secondary VM exit controls
  KVM: nVMX: Add FRED VMCS fields to nested VMX context management
  KVM: nVMX: Add VMCS FRED states checking
  KVM: nVMX: Allow VMX FRED controls

Xin Li (Intel) (2):
  x86/cea: Export per CPU array 'cea_exception_stacks' for KVM to use
  KVM: x86: Save/restore the nested flag of an exception

 Documentation/virt/kvm/api.rst            |  19 ++
 Documentation/virt/kvm/x86/nested-vmx.rst |  19 ++
 arch/x86/include/asm/kvm_host.h           |   8 +-
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/vmx.h                |  48 ++++-
 arch/x86/include/uapi/asm/kvm.h           |   4 +-
 arch/x86/kvm/cpuid.c                      |   2 +
 arch/x86/kvm/kvm_cache_regs.h             |  15 ++
 arch/x86/kvm/svm/svm.c                    |   2 +-
 arch/x86/kvm/vmx/capabilities.h           |  26 ++-
 arch/x86/kvm/vmx/nested.c                 | 188 ++++++++++++++++-
 arch/x86/kvm/vmx/nested.h                 |  22 ++
 arch/x86/kvm/vmx/vmcs.h                   |   1 +
 arch/x86/kvm/vmx/vmcs12.c                 |  19 ++
 arch/x86/kvm/vmx/vmcs12.h                 |  38 ++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h     |   4 +
 arch/x86/kvm/vmx/vmx.c                    | 237 ++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h                    |  15 +-
 arch/x86/kvm/x86.c                        |  74 ++++++-
 arch/x86/kvm/x86.h                        |   8 +-
 arch/x86/mm/cpu_entry_area.c              |   7 +
 include/uapi/linux/kvm.h                  |   1 +
 22 files changed, 727 insertions(+), 31 deletions(-)


base-commit: acb4f33713b9f6cadb6143f211714c343465411c
-- 
2.48.1


