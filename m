Return-Path: <kvm+bounces-1319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3FC7E69F9
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D2D3B20F8F
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E701CFB9;
	Thu,  9 Nov 2023 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+eVebx9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BAE1C69A
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:56:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4C4211F;
	Thu,  9 Nov 2023 03:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699530984; x=1731066984;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8ZIZgzJ2rRhYRCexD/kh1kIXgtJYrDP82vKbdfntqG8=;
  b=h+eVebx9Jd4S47tzRBaLSL5u56dGpH3sAdIUd33VPlZh5/KuFiPggcgE
   uSDVHMTyjWAt/oQFAiFEG5hnSnArBP5RS+aDG41Rwp+VrjhispkpBFbCu
   ZCUZYw6PAPiKCFE+6Zsfn4pLJwYOWrz91hEn7vvSyxD2d/sE+AF9br8nt
   6yOPsM2MmLEAb60NJgVSfw/v9Y5Bzc/Z6EaMuX4pIJ7zmNPNS1RwV+bbA
   M9BEneinDGhtbXOcaFfw185t9uEEaLxx1APNkuVq7CKQ7ZAEXyR+LhK85
   ii+ZxLhrvGiOITFlIgGZkqMvtDSfP0GpDdxnJJG7PP6C1hEIvUqi1qLiv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936218"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936218"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976558"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976558"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:09 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 00/23] TDX host kernel support
Date: Fri, 10 Nov 2023 00:55:37 +1300
Message-ID: <cover.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

(Again I didn't include the full cover letter here to save people's time.
 The full coverletter can be found in the v13 [1]).

This version mainly addressed one issue that we (Intel people) discussed
internally: to only initialize TDX module 1.5 and later versions.  The
reason is TDX 1.0 has some incompatibility issues to the TDX 1.5 and
later version (for detailed information please see [2]).  There's no
value to support TDX 1.0 when the TDX 1.5 are already out.

Hi Kirill, Dave (and all),

Could you help to review the new patch mentioned in the detailed
changes below (and other minor changes due to rebase to it)?

Appreciate a lot!

The detailed changes:

(please refer to individual patch for specific changes to them.)

 - v14 -> v15:
  - Rebased to latest (today) master branch of Linus's tree.
  - Removed the patch which uses TDH.SYS.INFO to get TDSYSINFO_STRUCT.
  - Added a new patch to use TDH.SYS.RD (which is the new SEAMCALL to read
    TDX module metadata in TDX 1.5) to read essential metadata for module
    initialization and stop initializing TDX 1.0.
  - Put the new patch after the patch to build the TDX-usable memory
    list becaues CMRs are not readed from TDX module anymore.
  - Very minor rebase changes in other couple of patches due to the new
    TDH.SYS.RD patch.
  - Addressed all comments (few) received in v14 (Rafael/Nikolay).
  - Added people's tags -- thanks! (Sathy, Nickolay).

v14: https://lore.kernel.org/lkml/cover.1697532085.git.kai.huang@intel.com/T/

[1] v13: https://lore.kernel.org/lkml/cover.1692962263.git.kai.huang@intel.com/T/
[2] "TDX module ABI incompatibilities" spec:
    https://cdrdv2.intel.com/v1/dl/getContent/773041



Kai Huang (23):
  x86/virt/tdx: Detect TDX during kernel boot
  x86/tdx: Define TDX supported page sizes as macros
  x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
  x86/cpu: Detect TDX partial write machine check erratum
  x86/virt/tdx: Handle SEAMCALL no entropy error in common code
  x86/virt/tdx: Add SEAMCALL error printing for module initialization
  x86/virt/tdx: Add skeleton to enable TDX on demand
  x86/virt/tdx: Use all system memory when initializing TDX module as
    TDX memory
  x86/virt/tdx: Get module global metadata for module initialization
  x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX
    memory regions
  x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Designate reserved areas for all TDMRs
  x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86/kexec: Flush cache of TDX private memory
  x86/virt/tdx: Keep TDMRs when module initialization is successful
  x86/virt/tdx: Improve readability of module initialization error
    handling
  x86/kexec(): Reset TDX private memory on platforms with TDX erratum
  x86/virt/tdx: Handle TDX interaction with ACPI S3 and deeper states
  x86/mce: Improve error log of kernel space TDX #MC due to erratum
  Documentation/x86: Add documentation for TDX host support

 Documentation/arch/x86/tdx.rst     |  222 +++-
 arch/x86/Kconfig                   |    3 +
 arch/x86/coco/tdx/tdx-shared.c     |    6 +-
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/msr-index.h   |    3 +
 arch/x86/include/asm/shared/tdx.h  |    6 +
 arch/x86/include/asm/tdx.h         |   39 +
 arch/x86/kernel/cpu/intel.c        |   17 +
 arch/x86/kernel/cpu/mce/core.c     |   33 +
 arch/x86/kernel/machine_kexec_64.c |   16 +
 arch/x86/kernel/process.c          |    8 +-
 arch/x86/kernel/reboot.c           |   15 +
 arch/x86/kernel/setup.c            |    2 +
 arch/x86/virt/vmx/tdx/Makefile     |    2 +-
 arch/x86/virt/vmx/tdx/tdx.c        | 1555 ++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h        |  121 +++
 16 files changed, 2033 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 6bc986ab839c844e78a2333a02e55f02c9e57935
-- 
2.41.0


