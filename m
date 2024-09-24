Return-Path: <kvm+bounces-27357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC1A984483
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D9B284211
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5357A1A4F39;
	Tue, 24 Sep 2024 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vi29J1IF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B155481B7;
	Tue, 24 Sep 2024 11:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177352; cv=none; b=Ar3PjcxtkMiX7Hh62lxXjQlQmhkK8mPe/Un8i1A2wLx0ypMVyOWyvZCaBRhbFq6rHPy6/uQChtVHFz6/xFYyliHl6X5VQbsy9BZXgTGqcoTcbIc3dEVEF2TCb0EMQPNBV3/a/glaQYHnAcYRM9rHEeWdS+cxCL/vS/YyDSeMV3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177352; c=relaxed/simple;
	bh=pTY6EiBLAO2sBwhggT/SdJs0KbneImnJpjH7syKs+90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZmLf/X6zqrFKjswt078C+9rBrBTKDHQnOU3FjYITTPkrfgruUXv+8KlUvmVoiAICLkrjpWm1THCQlmWjM6NjvnOjbtoDvz8HvMFur23b4Ipk2wQk2wjWZXLc1cyCeA/XUzfMLkRI1kYMmmk0S8HZwhqhR0qU985snSLjO4LEQ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vi29J1IF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177350; x=1758713350;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pTY6EiBLAO2sBwhggT/SdJs0KbneImnJpjH7syKs+90=;
  b=Vi29J1IFHyygjXLNJtuajQSB9dXPKeHaZhZ5rs6LrgqyYhPNQGTiEuS7
   i5fuLv4azCMmiZXXVRHuwRnhHzPIIZiTMH7LxmwcftDNGOOddhqPldSMd
   rurKghkgV+3nKkM+3sjBfSRf7ipc7M03e4qDwuIYKZL5EOFT9Y7p/cKtQ
   9fy0v3Ri2Vdj5gEiAQ6cfDdoOAArIXz8XIUGm6N7irrwBtR1RH3beMr9y
   HI2UKauJxXXfB9nbGvxrkaLmsQ8lNbuKrkHWlSNtf68qYVmAeLY4vZ9yC
   mRqShWAo5bfmTOzKVxB7hMD8bn2NEPH8lXkzrT4kBsAiBj1QQqVk0OmOS
   Q==;
X-CSE-ConnectionGUID: PP4As7UYQz6GW95ww2455A==
X-CSE-MsgGUID: /qpt6OIFRam7b9CIkweAwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686458"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686458"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:09 -0700
X-CSE-ConnectionGUID: Tm6BfJeXQXynBJ7FVydvgw==
X-CSE-MsgGUID: sOkTD/LXSl6N36p7WQ2Ogg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994542"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:06 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v4 0/8] TDX host: metadata reading tweaks, bug fix and info dump
Date: Tue, 24 Sep 2024 23:28:27 +1200
Message-ID: <cover.1727173372.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TL;DR:

This series does necessary tweaks to TDX host "global metadata" reading
code to fix some immediate issues in the TDX module initialization code,
with intention to also provide a flexible code base to support sharing
global metadata to KVM (and other kernel components) for future needs.

This series, and additional patches to initialize TDX when loading KVM
module and read essential metadata fields for KVM TDX can be found at
[1].

Hi Dave (and maintainers),

This series targets x86 tip.  Also add Dan, KVM maintainers and KVM list
so people can also review and comment.

This is a pre-work of the "quite near future" KVM TDX support (see the
kvm-coco-queue branch [2], which already includes all the patches in the
v2 of this series).  I appreciate if you can review, comment and take
this series if the patches look good to you.

v3 -> v4:
  - Change to add a build_sysmd_read(_size) macro to build one primitive
    for each metadata field element size, similar to build_mmio_read()
    macro -- Dan.

    https://lore.kernel.org/kvm/66db75497a213_22a2294b@dwillia2-xfh.jf.intel.com.notmuch/

  - Replace TD_SYSINFO_MAP() with READ_SYS_INFO() and #undef it after
    use -- Adrian, Dan.

    https://lore.kernel.org/kvm/66db7469dbfdd_22a2294c0@dwillia2-xfh.jf.intel.com.notmuch/

  - Use permalink in the changelog -- Dan.
  - Other comments from Dan, Adrian and Nikolay.  Please see individual
    patches.
  - Collect tags from Dan, Adrian, Nikolay (Thanks!).

 v3: https://lore.kernel.org/kvm/5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com/T/

v2 -> v3 (address comments from Dan):
  - Replace the first couple of "metadata reading tweaks" patches with
    two new patches using a different approach (removin the 'struct
    field_mapping' and reimplement the TD_SYSINFO_MAP()):

    https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m7cfb3c146214d94b24e978eeb8708d92c0b14ac6
    https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#mbe65f0903ff7835bc418a907f0d02d7a9e0b78be
    https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m80cde5e6504b3af74d933ea0cbfc3ca9d24697d3

  - Split out the renaming of 'struct tdx_tdmr_sysinfo' as a separate
    patch and place it at the beginning of this series.

    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b

  - Refine this cover letter ("More info" section)

    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m11868c9f486dcc4cfbbb690c7c18dfa4570e433f

  - Address other comments.  See changelog of individual patches.

 v2: https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/

v1 -> v2:
  - Fix comments from Chao and Nikolay.
  - A new patch to refine an out-dated comment by Nikolay.
  - Collect tags from Nikolay (thanks!).

 v1: https://lore.kernel.org/linux-kernel/cover.1718538552.git.kai.huang@intel.com/T/

=== More info ===

TDX module provides a set of "global metadata fields" for software to
query.  They report things like TDX module version, supported features
fields required for creating TDX guests and so on.

Today the TDX host code already reads "TD Memory Region" (TDMR) related
metadata fields for module initialization.  There are immediate needs
that require TDX host code to read more metadata fields:

 - Dump basic TDX module info [3];
 - Reject module with no NO_RBP_MOD feature support [4];
 - Read CMR info to fix a module initialization failure bug [5].

Also, the "quite near future" KVM TDX support requires to read more
global metadata fields.  In the longer term, the TDX Connect [6] (which
supports assigning trusted IO devices to TDX guest) may also require
other kernel components (e.g., pci/vt-d) to access more metadata.

To meet all of those, the idea is the TDX host core-kernel to provide a
centralized, canonical, and read-only structure to contain all global
metadata that comes out of TDX module for all kernel components to use.

An alternative way is to expose metadata reading API(s) for in-kernel
TDX users to use, but the reasons of choosing to provide a centural
structure are, quoted from Dan:

  The idea that x86 gets to review growth to this structure over time is
  an asset for maintainability and oversight of what is happening in the
  downstream consumers like KVM and TSM (for TDX Connect).

  A dynamic retrieval API removes that natural auditing of data structure
  patches from tip.git.

  Yes, it requires more touches than letting use cases consume new
  metadata fields at will, but that's net positive for maintainence of
  the kernel and the feedback loop to the TDX module.

This series starts to track all global metadata fields into a single
'struct tdx_sys_info', and reads more metadata fields to that structure
to address the immediate needs as mentioned above.

More fields will be added to support KVM TDX.  For the initial support
all metadata fields are populated in this single structure and shared to
KVM via a 'const pointer' to that structure (see last patches in [1]).


[1] https://github.com/intel/tdx/commits/kvm-tdxinit-host-metadata-v4/
[2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
[3] https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/
[4] https://lore.kernel.org/lkml/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/
[5] https://github.com/canonical/tdx/issues/135#issuecomment-2151570238
[6] https://cdrdv2.intel.com/v1/dl/getContent/773614



Kai Huang (8):
  x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec
    better
  x86/virt/tdx: Rework TD_SYSINFO_MAP to support build-time verification
  x86/virt/tdx: Prepare to support reading other global metadata fields
  x86/virt/tdx: Refine a comment to reflect the latest TDX spec
  x86/virt/tdx: Start to track all global metadata in one structure
  x86/virt/tdx: Print TDX module version
  x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD
    mitigation
  x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find
    memory holes

 arch/x86/virt/vmx/tdx/tdx.c | 282 +++++++++++++++++++++++++++---------
 arch/x86/virt/vmx/tdx/tdx.h |  85 ++++++++++-
 2 files changed, 294 insertions(+), 73 deletions(-)


base-commit: a6f489fee2633f8595934a850981bd4284abdbba
-- 
2.46.0


