Return-Path: <kvm+bounces-50820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 164D7AE9BC7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 976C51C422D3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF7625B2E8;
	Thu, 26 Jun 2025 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKPABNvr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC3237162;
	Thu, 26 Jun 2025 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934968; cv=none; b=XlxxtEnWBNYLBgWG3D/y44rML51l74ALGRhwBwaUo1HbKcjZ5NcJXg6g7s1CmndPqFT95Ab+C/V4u2IDobJAbz7J0ZXNogpQi3DPkIerWPyc9t5yZKlJHOeNn6xj6tXV8mGg68UN+Wk8EXirJGZAHPn7aRoDECSZrHZ9jGNzzJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934968; c=relaxed/simple;
	bh=CUpVLg2gAOKwYuLI1/+EPfNPPOJA5j6p7Mx8UWpHhfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tWYNRDg5Pv5o+gv9wOIL0T0cb6DSBB5YfW/PFYjCdHJv/UI7mTUPvZRwdLQpqSu5i4DmNt46q5oXeZZiIk7LvSZH0hkxZ2ZW5R4c+ggzzi+h3X5p28P5F2bz3wtlDd95x5kTjlPPOyBLX8edzzvj8BZSuUf0OMM7tsvFIz42dYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKPABNvr; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934966; x=1782470966;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CUpVLg2gAOKwYuLI1/+EPfNPPOJA5j6p7Mx8UWpHhfo=;
  b=IKPABNvrptO2wbiODh/vl2OIONzu2gYg4fOOgkyEkZviwFb2vA/23FUs
   bYurS4V2ebrvqjPj04yJmWALs+CY5sqzFBU2yGH5CyxxirxdNWiZJjWhN
   20m/LP2sVUSO7ATcEiMnrMBDxQZ8pLmClwRF6+hMYBagNzlbOJtyqGavL
   kkTf3S12kWwQ/EkzURgoN/7JUeQ+T12MArGZ4+vYu0roMu4kZrfQTThFV
   WY0fH5zV0pBl/CR4tKI6akGnxnxIuIRKPudOXcSBFS/CsDeoMtvcnYkhH
   HrrywlFPtR8NO84SYbrbl6tXiajHFzD2+HL+1QuqgXSC820qnEssArM7Y
   Q==;
X-CSE-ConnectionGUID: 1Ep7WJ6wTamJ/FioxiI2sg==
X-CSE-MsgGUID: gxbrqd9WTxiZnqZJV+/QUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655743"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655743"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:26 -0700
X-CSE-ConnectionGUID: pMnHmCfBTFqrBAdsvRx4mQ==
X-CSE-MsgGUID: h+L3NT6TRj6oy3xgIjfM1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784296"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:20 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	sagis@google.com
Subject: [PATCH v3 0/6] TDX host: kexec/kdump support
Date: Thu, 26 Jun 2025 22:48:46 +1200
Message-ID: <cover.1750934177.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is the latest attempt to support kexec on TDX host following
Dave's suggestion to use a percpu boolean to control WBINVD during
kexec.

Hi Tom,

The first patch touches AMD SME code.  I appreciate if you can help to
review and test.  Please let me know if there's anything I can help in
return. :-)

I've tested on TDX system and it worked as expected.

v2 -> v3 (all trivial changes):

 - Rebase on latest tip/master
   - change to use __always_inline for do_seamcall() in patch 2
 - Update patch 2 (changelog and code comment) to remove the sentence
   which says "not all SEAMCALLs generate dirty cachelines of TDX
   private memory but just treat all of them do."  -- Dave.
 - Add Farrah's Tested-by for all TDX patches.

The v2 had one informal RFC patch appended to show "some optimization"
which can move WBINVD from the kexec phase to an early stage in KVM.
Paolo commented and Acked that patch (thanks!), so this v3 made that
patch as a formal one (patch 6).  But technically it is not absolutely
needed in this series but can be done in the future.

More history info can be found in v2:

 https://lore.kernel.org/lkml/cover.1746874095.git.kai.huang@intel.com/

=== More information ===

TDX private memory is memory that is encrypted with private Host Key IDs
(HKID).  If the kernel has ever enabled TDX, part of system memory
remains TDX private memory when kexec happens.  E.g., the PAMT (Physical
Address Metadata Table) pages used by the TDX module to track each TDX
memory page's state are never freed once the TDX module is initialized.
TDX guests also have guest private memory and secure-EPT pages.

After kexec, the new kernel will have no knowledge of which memory page
was used as TDX private page and can use all memory as regular memory.

1) Cache flush

Per TDX 1.5 base spec "8.6.1.Platforms not Using ACT: Required Cache
Flush and Initialization by the Host VMM", to support kexec for TDX, the
kernel needs to flush cache to make sure there's no dirty cachelines of
TDX private memory left over to the new kernel (when the TDX module
reports TDX_FEATURES.CLFLUSH_BEFORE_ALLOC as 1 in the global metadata for
the platform).  The kernel also needs to make sure there's no more TDX
activity (no SEAMCALL) after cache flush so that no new dirty cachelines
of TDX private memory are generated.

SME has similar requirement.  SME kexec support uses WBINVD to do the
cache flush.  WBINVD is able to flush cachelines associated with any
HKID.  Reuse the WBINVD introduced by SME to flush cache for TDX.

Currently the kernel explicitly checks whether the hardware supports SME
and only does WBINVD if true.  Instead of adding yet another TDX
specific check, this series uses a percpu boolean to indicate whether
WBINVD is needed on that CPU during kexec.

2) Reset TDX private memory using MOVDIR64B

The TDX spec (the aforementioned section) also suggests the kernel
*should* use MOVDIR64B to clear TDX private page before the kernel
reuses it as regular one.

However, in reality the situation can be more flexible.  Per TDX 1.5
base spec ("Table 16.2: Non-ACT Platforms Checks on Memory Reads in Ci
Mode" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
Mode"), the read/write to TDX private memory using shared KeyID without
integrity check enabled will not poison the memory and cause machine
check.

Note on the platforms with ACT (Access Control Table), there's no
integrity check involved thus no machine check is possible to happen due
to memory read/write using different KeyIDs.

KeyID 0 (TME key) doesn't support integrity check.  This series chooses
to NOT reset TDX private memory but leave TDX private memory as-is to the
new kernel.  As mentioned above, in practice it is safe to do so.

3) One limitation

If the kernel has ever enabled TDX, after kexec the new kernel won't be
able to use TDX anymore.  This is because when the new kernel tries to
initialize TDX module it will fail on the first SEAMCALL due to the
module has already been initialized by the old kernel.

More (non-trivial) work will be needed for the new kernel to use TDX,
e.g., one solution is to just reload the TDX module from the location
where BIOS loads the TDX module (/boot/efi/EFI/TDX/).  This series
doesn't cover this, but leave this as future work.

4) Kdump support

This series also enables kdump with TDX, but no special handling is
needed for crash kexec (except turning on the Kconfig option):

 - kdump kernel uses reserved memory from the old kernel as system ram,
   and the old kernel will never use the reserved memory as TDX memory.
 - /proc/vmcore contains TDX private memory pages.  It's meaningless to
   read them, but it doesn't do any harm either.

5) TDX "partial write machine check" erratum

On the platform with TDX erratum, a partial write (a write transaction
of less than a cacheline lands at memory controller) to TDX private
memory poisons that memory, and a subsequent read triggers machine
check.  On those platforms, the kernel needs to reset TDX private memory
before jumping to the new kernel otherwise the new kernel may see
unexpected machine check.

The kernel currently doesn't track which page is TDX private memory.
It's not trivial to reset TDX private memory.  For simplicity, this
series simply disables kexec/kdump for such platforms.  This can be
enhanced in the future.


*** BLURB HERE ***

Kai Huang (6):
  x86/sme: Use percpu boolean to control wbinvd during kexec
  x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
  x86/kexec: Disable kexec/kdump on platforms with TDX partial write
    erratum
  x86/virt/tdx: Remove the !KEXEC_CORE dependency
  x86/virt/tdx: Update the kexec section in the TDX documentation
  KVM: TDX: Explicitly do WBINVD upon reboot notifier

 Documentation/arch/x86/tdx.rst       | 14 ++++-----
 arch/x86/Kconfig                     |  1 -
 arch/x86/include/asm/kexec.h         |  2 +-
 arch/x86/include/asm/processor.h     |  2 ++
 arch/x86/include/asm/tdx.h           | 32 +++++++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 16 ++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 31 +++++++++++++++----
 arch/x86/kernel/process.c            | 16 ++--------
 arch/x86/kernel/relocate_kernel_64.S | 15 +++++++---
 arch/x86/kvm/vmx/tdx.c               | 45 ++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c          |  9 ++++++
 11 files changed, 151 insertions(+), 32 deletions(-)


base-commit: bda8bfc862a1bc1cb2de38145d99ae50ad90b667
-- 
2.49.0


