Return-Path: <kvm+bounces-49322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE27AD7DC3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D2203A1A78
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698A62DECA3;
	Thu, 12 Jun 2025 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C8jRJYOS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5952D1AAE17;
	Thu, 12 Jun 2025 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765028; cv=none; b=BRUvxXSOZ2u3USkiZK5uGpH0nCAPDr2LlMkzRY9s3+T37rvMKXOgdJzDr8CPQgWnCvRWPESzdCBEFGxtTx0xmHyhxpBoEHkUG3ExGm5859G1NjPCoUmgs/lPDnl3imp9AwKqjjFefmHxu6uVRi5G1tcEx8UWdGIN6Y7p0UoY22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765028; c=relaxed/simple;
	bh=/raPSIZSWZZj4n+fwc8niF30vvTlX7BXAu0879ygFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KNEjxSyrdcB4IL2TcllDCUcoLfl6194g82Ajpe8A1cE5wXTONXjmdavEfRjY/iSkv5vjcG0ixczWlOf/n+QsGQ9O0EEKYSvAOdZ8gvGuNHiRpgHRczwthybV+eINqx3olpaEhQtE8WUaObe2dsmiU+QdDFb+b4XLm67W3ztBgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C8jRJYOS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765026; x=1781301026;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/raPSIZSWZZj4n+fwc8niF30vvTlX7BXAu0879ygFwg=;
  b=C8jRJYOSoI1RcF6CfgBZGvGgw4fiDgKiEeHG2my7ivx20kGJoLCaYeaN
   79RYQzhf3AULZuQFk0EHpVl8Mityo1VJ1KBpzptGkcU3em2Tcb47x6GGg
   QKpATvIsIip00r/uzBtuJGiR0j0gDRj3T/VoPpKvgRC4fHb3xTpXQ/9SJ
   Gb3wyll3vs1OUEMbNOIo1QrFvLC0PeHvezNonnsrE1SCq8upMqYI1lGXO
   S9pjaOreC9gmeFoIUfOmZvo6g+++qnY+Y/HLa1xbcpEO/JwvGdIJi5s/L
   8vz2/ubyUhgGMfskVVuIUQb/St8jXnuXGQJzJ1NdRE4d06/CVChB5pE7+
   Q==;
X-CSE-ConnectionGUID: KO9Tb3+tQH+6nIn0/+YtwA==
X-CSE-MsgGUID: Ee9q89g+SySxyyS+qWyxvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065282"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065282"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:25 -0700
X-CSE-ConnectionGUID: uNxYaw0STgevhIIGnpvmjA==
X-CSE-MsgGUID: OHAXHIIIRlqcKT46b9Xztw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881931"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:24 -0700
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
Subject: [PATCH v7 00/10] x86: Add support for NMI-source reporting with FRED
Date: Thu, 12 Jun 2025 14:48:39 -0700
Message-ID: <20250612214849.3950094-1-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v6
================
This series is a minor update from v6, with the following changes:

 * Includes a pre-patch to provide separate KVM IRQ and NMI entry
   wrappers for FRED (Sean).
 * Uses an enum to allocate NMI-source vectors (DaveH).
 * Picks up review tags from Xin.
 * Rebased on top of 6.16-rc1.

The patchset seems to be maturing, so while reviewing this version, please 
consider providing Acks and Review tags if the patches look okay.

v6: https://lore.kernel.org/lkml/20250513203803.2636561-1-sohil.mehta@intel.com/

Background
==========
NMI-source reporting with FRED [1] provides a new mechanism for
identifying the source of NMIs. As part of the FRED event delivery
framework, a 16-bit vector bitmap is provided that identifies one or
more sources that caused the NMI.

Using the source bitmap, the kernel can precisely run the relevant NMI
handlers instead of polling the entire NMI handler list. Additionally,
the source information would be invaluable for debugging misbehaving
handlers and unknown NMIs.

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
Patch 1-3: Prepare FRED/KVM and enumerate NMI-source reporting
Patch 4-6: Register and handle NMI-source vectors 
Patch 7-9: APIC changes to generate NMIs with vectors
Patch  10: Improve debug print with NMI-source information

Many thanks to Sean Christopherson, Xin Li, H. Peter Anvin, Andi Kleen,
Tony Luck, Kan Liang, Jacob Pan Jun, Zeng Guang, Peter Zijlstra,
Sandipan Das, Steven Rostedt, Dave Hansen and others for their
contributions, reviews and feedback.

Future work
===========
I am considering a few additional changes related to debugging and
tracing, as well as KVM support, that would be valuable for enhancing
NMI handling in the kernel.

Refer the v6 cover letter for more details:
v6: https://lore.kernel.org/lkml/20250513203803.2636561-1-sohil.mehta@intel.com/

Links
=====
[1]: Chapter 9, https://www.intel.com/content/www/us/en/content-details/819481/flexible-return-and-event-delivery-fred-specification.html

Jacob Pan (1):
  perf/x86: Enable NMI-source reporting for perfmon

Sean Christopherson (1):
  x86/fred: Provide separate IRQ vs. NMI wrappers for entry from KVM

Sohil Mehta (8):
  x86/fred: Pass event data to the NMI entry point from KVM
  x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
  x86/nmi: Extend the registration interface to include the NMI-source
    vector
  x86/nmi: Assign and register NMI-source vectors
  x86/nmi: Add support to handle NMIs with source information
  x86/nmi: Prepare for the new NMI-source vector encoding
  x86/nmi: Enable NMI-source for IPIs delivered as NMIs
  x86/nmi: Print source information with the unknown NMI console message

 arch/x86/entry/entry_64_fred.S      |  2 +-
 arch/x86/events/amd/ibs.c           |  2 +-
 arch/x86/events/core.c              |  6 +--
 arch/x86/events/intel/core.c        |  6 +--
 arch/x86/include/asm/apic.h         | 39 ++++++++++++++++++
 arch/x86/include/asm/apicdef.h      |  2 +-
 arch/x86/include/asm/cpufeatures.h  |  1 +
 arch/x86/include/asm/fred.h         | 35 +++++++++++-----
 arch/x86/include/asm/nmi.h          | 62 ++++++++++++++++++++++++++++-
 arch/x86/kernel/apic/hw_nmi.c       |  5 +--
 arch/x86/kernel/apic/ipi.c          |  4 +-
 arch/x86/kernel/apic/local.h        | 24 ++++++-----
 arch/x86/kernel/cpu/cpuid-deps.c    |  1 +
 arch/x86/kernel/cpu/mce/inject.c    |  4 +-
 arch/x86/kernel/cpu/mshyperv.c      |  2 +-
 arch/x86/kernel/kgdb.c              |  8 ++--
 arch/x86/kernel/kvm.c               |  9 +----
 arch/x86/kernel/nmi.c               | 40 +++++++++++++++++++
 arch/x86/kernel/nmi_selftest.c      |  8 ++--
 arch/x86/kernel/smp.c               |  6 +--
 arch/x86/kvm/vmx/vmx.c              |  4 +-
 arch/x86/platform/uv/uv_nmi.c       |  4 +-
 drivers/acpi/apei/ghes.c            |  2 +-
 drivers/char/ipmi/ipmi_watchdog.c   |  3 +-
 drivers/edac/igen6_edac.c           |  3 +-
 drivers/thermal/intel/therm_throt.c |  2 +-
 drivers/watchdog/hpwdt.c            |  6 +--
 27 files changed, 218 insertions(+), 72 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.43.0


