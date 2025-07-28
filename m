Return-Path: <kvm+bounces-53533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F8FB13A79
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAB747A1B4E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 12:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E550D264FB5;
	Mon, 28 Jul 2025 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iG0QowX7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EAD22ACEF;
	Mon, 28 Jul 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753705738; cv=none; b=ob2oFlhnSCWbwnOiheuA6uJwtaM978W8qnDsZ6+70rUPNit3RI+yO0lPEeHVEVlxIDthRfRnp+HfbHkAe0kXKsdiqMQQUZGyGalrNboE+gHSe30s2TPEsvj1Qm1ME/VGOgRVqfn/nWnoOwkYo/VnUClLsPE0+XS6BRgIq4WgzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753705738; c=relaxed/simple;
	bh=dSKxfIgED9OMF4Xs9BI2aCemE44jhNpsDsXqhweUVWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n5P4kJrwUH0k8DwmVz1vdGOjyipHtySkThpILRbh8myKgBMY5GYcLFkj+gkb9hgoLT8Rqx2TYJuUJ44qfyMP9Qrflm3BisAwLlxm0oqGC2VHLFLWeCmNymXHa3fAiKJxenN2ahigN5U4GeQldrHYbXNnw5MM3nbsvRHklxyVYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iG0QowX7; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753705737; x=1785241737;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dSKxfIgED9OMF4Xs9BI2aCemE44jhNpsDsXqhweUVWk=;
  b=iG0QowX7UVNNG0IDC06jZ93w5SW/PrYj8YQV0ujlKCIbjAHbbeQ57De0
   +XH+sOF35yVwtglMfiROdGb8XJQM4lVGCUvXFf2KrmlyCYDhqyQtSvFWO
   7KWTXuCr/HQfGroSjNBlVR3CA/+SFYTz4EZx7YcUMAKUqBEpwtmwveDDM
   MLsmglMMqS6IQ0q4OjkIwx6D2QwVMibmyt4SvUhL2ItnFpm3iRz+X9A5Q
   IyuMJXWd13BdfK0yn8NM7GLT715U2JJIwbD5rm8+oq3l2R6pcvFArlioP
   YcV4wm1Sp/m2EwSxYgW5fVR1iRv0jfnQ7y4ZvMJ7pmVPt89bowkJ4TiqR
   g==;
X-CSE-ConnectionGUID: kTMAKUVEQyG3AH60LgxUsA==
X-CSE-MsgGUID: Vc1WAqRGTCCK51U5H7CWcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="56043285"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56043285"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:28:56 -0700
X-CSE-ConnectionGUID: nYWpw3cQRlWkHIAfMKgWRQ==
X-CSE-MsgGUID: g3MU9jNvRvKdUDeHGGc+Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="193375583"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.205])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:28:51 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com
Subject: [PATCH v5 0/7] TDX host: kexec/kdump support
Date: Tue, 29 Jul 2025 00:28:34 +1200
Message-ID: <cover.1753679792.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
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

Hi Tom/Boris,

I addressed Tom's comments in v4, I appreciate if you can review again.

v4 -> v5:
 - Address comments from Tom, Hpa and Chao (nothing major)
   - RELOC_KERNEL_HOST_MEM_ACTIVE -> RELOC_KERNEL_HOST_MEM_ENC_ACTIVE
     in patch 1 (Tom)
   - Add a comment to explain only RELOC_KERNEL_PRESERVE_CONTEXT is
     restored after jumping back from peer kernel for preserved_context
     kexec in patch 1.
   - Use testb instead of testq to save 3 bytes in patch 1 (Hpa)
   - Remove the unneeded 'ret' local variable in do_seamcall() (Chao)

v4: https://lore.kernel.org/kvm/cover.1752730040.git.kai.huang@intel.com/

v3 -> v4:
 - Rebase to latest tip/master.
 - Add a cleanup patch to consolidate relocate_kernel()'s last two
   function parameters -- Boris.
 - Address comments received -- please see individual patches.
 - Collect tags (Tom, Rick, binbin).

 v3: https://lore.kernel.org/kvm/cover.1750934177.git.kai.huang@intel.com/

(For more history please see v3 coverletter.)

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


Kai Huang (7):
  x86/kexec: Consolidate relocate_kernel() function parameters
  x86/sme: Use percpu boolean to control WBINVD during kexec
  x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
  x86/kexec: Disable kexec/kdump on platforms with TDX partial write
    erratum
  x86/virt/tdx: Remove the !KEXEC_CORE dependency
  x86/virt/tdx: Update the kexec section in the TDX documentation
  KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs

 Documentation/arch/x86/tdx.rst       | 14 ++++-----
 arch/x86/Kconfig                     |  1 -
 arch/x86/include/asm/kexec.h         | 12 ++++++--
 arch/x86/include/asm/processor.h     |  2 ++
 arch/x86/include/asm/tdx.h           | 27 ++++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 44 ++++++++++++++++++++++------
 arch/x86/kernel/process.c            | 24 +++++++--------
 arch/x86/kernel/relocate_kernel_64.S | 36 +++++++++++++++--------
 arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c          | 16 ++++++++--
 11 files changed, 158 insertions(+), 47 deletions(-)


base-commit: 7ec401d5b972171735754ba4c475bc674108f066
-- 
2.50.1


