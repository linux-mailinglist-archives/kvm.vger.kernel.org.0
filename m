Return-Path: <kvm+bounces-46386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A7EAB5DBD
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42149467298
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC201F4C90;
	Tue, 13 May 2025 20:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFO1h/ZY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBE81BC3F;
	Tue, 13 May 2025 20:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168678; cv=none; b=eF7gNDCaOLpqKmiQlHINCORzjKhxOwLSCgFNEMFL5p919O89WzWdaOx8p1wQ54gxIthxinBdZSInMewJ7mCinQQbxcjZcaciUOzzxOm7C3p8u2Tx3jJWCqDUxHHS7zDLeTPOo5zJ6rNA+pSArwjxkDRxgN0nk/H29UR4NNvI9vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168678; c=relaxed/simple;
	bh=iledouXHe57iRPBcypmDJ7inmxqQ1E9J+7ME0uM8qbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MmkTFV1tjx+mW2slg3ep1mRiR5yembWpLdPlRRxAiMags5m06tKgJ1jrv8UjhKZoBP2UYkr8PyLOD7/Ha+hF6NZpSGk4JfYUHKjaVAY2s5K4SS2ROuMp5iClaZwpVyPqec3qiOqVvqrJaFHiq1YkJd6MNHif37dTMae6S6F7RGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFO1h/ZY; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168677; x=1778704677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iledouXHe57iRPBcypmDJ7inmxqQ1E9J+7ME0uM8qbM=;
  b=VFO1h/ZY2SFe6aKfe/aJDYQuoiLbsepLyrkcpxclmZafYKUnQuFHpkSY
   g2YF6xDLtOujjlT8eSVc1+dL+U0TZUoTQiAd0DAicMlofdaowcgSiBLSc
   L9kjiHbUv6GuFNlO0/aZho75BCp0TNy7C3f5nfzfvWBI7scXGNEhG6EDX
   PCcrSWdmeme2SQ1JeuI8jgLKf8915FqYOE4DNYq+b5pOp3oJs1aLUGP9w
   AXMUc7Fy4becNhtN6RCAsxHiODDW6EB5PeQNu9AvhlSjFvRdYPSDdm9xQ
   mV43W369N2nJabuwxDsJhtbEdwG1Q5fgSMMGE2aWRSIM1xVbA9Q8oNpR2
   Q==;
X-CSE-ConnectionGUID: 2hGg2gNqRn+oMu/z1gjRLw==
X-CSE-MsgGUID: weNzSQ0nR9Sw72LRSU3Axw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160385"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160385"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:37:56 -0700
X-CSE-ConnectionGUID: lKSujK11Tuqza5QWUjLgyA==
X-CSE-MsgGUID: cyraYM2EQ8K8c1BLePI4EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241709"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:55 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v6 0/9] x86: Add support for NMI-source reporting with FRED
Date: Tue, 13 May 2025 13:37:54 -0700
Message-ID: <20250513203803.2636561-1-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduction
============
NMI-source reporting with FRED [1] provides a new mechanism for
identifying the source of NMIs. As part of the FRED event delivery
framework, a 16-bit vector bitmap is provided that identifies one or
more sources that caused the NMI.

Using the source bitmap, the kernel can precisely run the relevant NMI
handlers instead of polling the entire NMI handler list. Additionally,
the source information would be invaluable for debugging misbehaving
handlers and unknown NMIs.

Changes since v5
================
This series mainly implements PeterZ's suggestions in patches 4,5,6:

 * Simplify NMI handling by always setting and using the source bitmap.
 * Add runtime warnings for unexpected values.
 * Fix a compile issue in apic.h with a specific config.
 * Drop the tracepoint changes for now (include it with the DebugFS series).
 * Pick-up Sandipan's tested-by for the perf patch.

The previous posting included a major simplification compared to the
series posted last year[2]. Refer the v5 cover letter for details.
v5: https://lore.kernel.org/lkml/20250507012145.2998143-1-sohil.mehta@intel.com/

Overview of NMI-source usage
============================
Code snippets:

// Allocate a static source vector at compile time
#define NMIS_VECTOR_TEST	1

// Register an NMI handler with the vector
register_nmi_handler(NMI_LOCAL, test_handler, 0, "nmi_test", NMIS_VECTOR_TEST);

// Generate an NMI with the source vector using NMI encoded delivery
__apic_send_IPI_mask(cpumask, APIC_DM_NMI | NMIS_VECTOR_TEST);

// Handle an NMI with or without the source information (oversimplified)
source_bitmap = fred_event_data(regs);
if (!source_bitmap || (source_bitmap & BIT(NMIS_VECTOR_TEST)))
        test_handler();

// Unregister handler along with the vector
unregister_nmi_handler(NMI_LOCAL, "nmi_test");

Patch structure
===============
The patches are based on tip:x86/nmi because they depend on the NMI
cleanup series merged earlier [3].

Patch 1-2: Prepare FRED/KVM and enumerate NMI-source reporting
Patch 3-5: Register and handle NMI-source vectors 
Patch 6-8: APIC changes to generate NMIs with vectors
Patch   9: Improve debug print with NMI-source information

Many thanks to Sean Christopherson, Xin Li, H. Peter Anvin, Andi Kleen,
Tony Luck, Kan Liang, Jacob Pan Jun, Zeng Guang, Peter Zijlstra,
Sandipan Das, Steven Rostedt and others for their contributions, reviews
and feedback.

Future work / Opens
===================
I am considering a few additional changes that would be valuable for
enhancing NMI handling support. Any feedback, preferences or suggestions
on the following would be helpful.

Assigning more NMI-source vectors
---------------------------------
The current patches assign NMI vectors to a limited number of sources.
The microcode rendezvous and crash reboot code use NMI but do not go
through the typical register_nmi_handler() path. Their handling is
special-cased in exc_nmi(). To isolate blame and improve debugging, it
would be useful to assign vectors to them, even if the vectors are
ignored during handling.

Other NMI sources, such as GHES and Platform NMIs, can also be assigned
vectors to speed up their NMI handling and improve isolation. However,
this would require a software/hardware agreement on vector reservation
and usage. Such an endeavor is likely not worth the effort.

Explicitly enabling NMIs
------------------------
HPA brought up the idea [4] of explicitly enabling NMIs only when the
kernel is ready to take them. With FRED, if we enter the kernel with
NMIs disabled, they could remain disabled until returning back to
userspace. I am evaluating the request and related code changes.

Debug support (Tracing and DebugFS)
-----------------------
NMI-source information can help identify issues when multiple NMIs occur
simultaneously or if certain NMI handlers consistently misbehave. Based
on feedback from Steven Rostedt[5], the plan is to move the trace event
to arch/x86 and then add source_bitmap to the nmi_handler() trace event.

Currently, the kernel has counters for unknown NMIs, swallowed NMIs and
other NMI handling data. However, there is no easy way to access that.
To identify issues that happen over a longer timeframe, it might be
useful to add DebugFS support for NMI statistics.

KVM support
-----------
The NMI-source feature can be useful for perf users and other NMI use
cases in guest VMs. Exposing NMI-source to guests once FRED support is
in place should be relatively easier. The prototype code for this is
under evaluation.

Links
=====
[1]: Chapter 9, https://www.intel.com/content/www/us/en/content-details/819481/flexible-return-and-event-delivery-fred-specification.html
[2]: https://lore.kernel.org/lkml/20240709143906.1040477-1-jacob.jun.pan@linux.intel.com/
[3]: https://lore.kernel.org/lkml/20250327234629.3953536-1-sohil.mehta@intel.com/
[4]: https://lore.kernel.org/lkml/F5D36889-A868-46D2-A678-8EE26E28556D@zytor.com/
[5]: https://lore.kernel.org/lkml/20250507174809.10cfc5ac@gandalf.local.home/

Jacob Pan (1):
  perf/x86: Enable NMI-source reporting for perfmon

Sohil Mehta (7):
  x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
  x86/nmi: Extend the registration interface to include the NMI-source
    vector
  x86/nmi: Assign and register NMI-source vectors
  x86/nmi: Add support to handle NMIs with source information
  x86/nmi: Prepare for the new NMI-source vector encoding
  x86/nmi: Enable NMI-source for IPIs delivered as NMIs
  x86/nmi: Print source information with the unknown NMI console message

Zeng Guang (1):
  x86/fred, KVM: VMX: Pass event data to the FRED entry point from KVM

 arch/x86/entry/entry_64_fred.S      |  2 +-
 arch/x86/events/amd/ibs.c           |  2 +-
 arch/x86/events/core.c              |  6 ++---
 arch/x86/events/intel/core.c        |  6 ++---
 arch/x86/include/asm/apic.h         | 39 +++++++++++++++++++++++++++++
 arch/x86/include/asm/apicdef.h      |  2 +-
 arch/x86/include/asm/cpufeatures.h  |  1 +
 arch/x86/include/asm/fred.h         |  9 ++++---
 arch/x86/include/asm/nmi.h          | 37 ++++++++++++++++++++++++++-
 arch/x86/kernel/apic/hw_nmi.c       |  5 ++--
 arch/x86/kernel/apic/ipi.c          |  4 +--
 arch/x86/kernel/apic/local.h        | 24 ++++++++++--------
 arch/x86/kernel/cpu/cpuid-deps.c    |  1 +
 arch/x86/kernel/cpu/mce/inject.c    |  4 +--
 arch/x86/kernel/cpu/mshyperv.c      |  3 +--
 arch/x86/kernel/kgdb.c              |  8 +++---
 arch/x86/kernel/kvm.c               |  9 +------
 arch/x86/kernel/nmi.c               | 37 +++++++++++++++++++++++++++
 arch/x86/kernel/nmi_selftest.c      |  9 +++----
 arch/x86/kernel/smp.c               |  6 ++---
 arch/x86/kvm/vmx/vmx.c              |  5 ++--
 arch/x86/platform/uv/uv_nmi.c       |  4 +--
 drivers/acpi/apei/ghes.c            |  2 +-
 drivers/char/ipmi/ipmi_watchdog.c   |  3 +--
 drivers/edac/igen6_edac.c           |  3 +--
 drivers/thermal/intel/therm_throt.c |  2 +-
 drivers/watchdog/hpwdt.c            |  6 ++---
 27 files changed, 171 insertions(+), 68 deletions(-)


base-commit: f2e01dcf6df2d12e86c363ea9c37d53994d89dd6
-- 
2.43.0


