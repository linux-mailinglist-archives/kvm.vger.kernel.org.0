Return-Path: <kvm+bounces-52798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6141CB09679
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5312D3BAE6B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4BC2356BE;
	Thu, 17 Jul 2025 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mgLVdxQI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119DA12C544;
	Thu, 17 Jul 2025 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788834; cv=none; b=tZ92HhGpQAUh6VPM3th+eySarVIrqlaUfgHOeuLHlaep1UfWr2UwH+s8J9yTSGhjzGfMcPWZmkO2omnLOYMaEni57wRDOiRwOvnooCcqvMCYYRs5fJf/N1PoLQJMohSRtIvlow14EQ2KUL66/VKnlfcOaZ6S8OPRF5snSjizhTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788834; c=relaxed/simple;
	bh=GeBjQgp4CQ51rAjMKKw1UHa/3iVrylWuqhz/SLl9yW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mzpO8YzJD96nEdpq4eP9kXkT3tk2e8I+a3ZFpIW2/yqKZPZcw41/AoN0Bpswj/KGDnCh1jHmPCRqytYOQIg7YvJZYbF424zYxlGPoLGwSPP1m0xDHAw8HDfOQeFZVahKayVEKDRyjSaUZu5mwKjh+2vbQQPU0XZ81fI89S5QAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mgLVdxQI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752788832; x=1784324832;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GeBjQgp4CQ51rAjMKKw1UHa/3iVrylWuqhz/SLl9yW8=;
  b=mgLVdxQItNyld4Rb/gwo0VmGIFJ86xh2UTMn69jowNoM37oJ4ynyVsAA
   uK8T/ZO6Lt+kWOPFxjja1V8WeamJW9FA0vGtMqTAnRJmiuo8/sBlbgeUo
   aRRbexRnx8Y7dnPKlCQMkqq3272J3WBYH4tM4JtGv7Iy1TWr+mEfmnnod
   oCnhyajbwejFBAoggf16xQziysEu4/hg6wmXySAAqbFVaq/8puGyOK8sU
   DVtYVc0aAowPTDO1aXCnFBOgjv+dq8x+MqJTvvMst+lbHnFmjtvvyLDne
   boMfes2T2PRPVm+3vr46N72xI9/zEoPh52p+Cp+ohpsEEml/Hwc8yFVHs
   g==;
X-CSE-ConnectionGUID: 4YkX+8c2Rw69HxEk/p9njw==
X-CSE-MsgGUID: G+2jPjG5R8CP99Uw6eB9qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66527737"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66527737"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:11 -0700
X-CSE-ConnectionGUID: QB0xRGOjTxulF9AV/YJHiw==
X-CSE-MsgGUID: CHggClCeQWqKgbsdbbXIjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="157295485"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:06 -0700
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
Subject: [PATCH v4 0/7] TDX host: kexec/kdump support
Date: Fri, 18 Jul 2025 09:46:37 +1200
Message-ID: <cover.1752730040.git.kai.huang@intel.com>
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

Hi Boris/Tom,

As requested, I added the first patch to cleanup the last two 'unsigned
int' parameters of the relocate_kernel() into one 'unsigned int' and pass
flags instead.  The patch 2 (patch 1 in v3) also gets updated based on
that.  Would you help to review?  Thanks.

I tested that both normal kexec and preserve_context kexec works (using
the tools/testing/selftests/kexec/test_kexec_jump.sh).  But I don't have
SME capable machine to test.

Hi Tom, I added your Reviewed-by and Tested-by in the patch 2 anyway
since I believe the change is trivial and straightforward).  But due to
the cleanup patch, I appreciate if you can help to test the first two
patches again.  Thanks a lot!

v3 -> v4:
 - Rebase to latest tip/master.
 - Add a cleanup patch to consolidate relocate_kernel()'s last two
   function parameters -- Boris.
 - Address comments received -- please see individual patches.
 - Collect tags (Tom, Rick, binbin).

 v3: https://lore.kernel.org/kvm/cover.1750934177.git.kai.huang@intel.com/

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
 arch/x86/include/asm/tdx.h           | 31 +++++++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 43 ++++++++++++++++++++++------
 arch/x86/kernel/process.c            | 24 +++++++---------
 arch/x86/kernel/relocate_kernel_64.S | 30 +++++++++++--------
 arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c          | 16 +++++++++--
 11 files changed, 155 insertions(+), 47 deletions(-)


base-commit: e180b3a224cb519388c2f61ca7bc1eaf94cec1fb
-- 
2.50.0


