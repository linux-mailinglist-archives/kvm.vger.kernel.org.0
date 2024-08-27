Return-Path: <kvm+bounces-25121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2959602BE
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F861C22128
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B6515383F;
	Tue, 27 Aug 2024 07:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzbxDIHz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EA9155725;
	Tue, 27 Aug 2024 07:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742885; cv=none; b=qmGYFOk/IHgxMGTZwNSfK6YuTvzJpMyEdbq4Xa+Kp16avQ7ud6i4y4A3r70wjAs/Rdu+JNhqSzcRh/aZWl5oE7ID6aRFmEBZt1pDpRIzp1aXBA3cT/D1q2lH9mFi5NnfC3bG38OUSy8ttGYHt0hnVYMiPRPzuyUj9jztdhHO+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742885; c=relaxed/simple;
	bh=vlY2ybrsfOx3PRJ3X7f9ZLz1eG13d6E04BthqGXsAxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VcoCa1zGsQQ1nibyEfNjeW/I+Km5O7N4Zg1DjA6NpQ3aQjSUXUo3GlAmmPc0rEtqeCngb4A54RXp+xLEalabeaMsFaVwoO3inlA0pcAXzB7BujcGXnpgHcTIHe3VrKoR1/FUAroqPn3H8xC1gCasrT3PNJj7q7V9edLXVnsdzNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzbxDIHz; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742884; x=1756278884;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vlY2ybrsfOx3PRJ3X7f9ZLz1eG13d6E04BthqGXsAxA=;
  b=mzbxDIHzhf1JRKAliziId8ABVVvr8sEwoEQSPy1vdcKfoqdaWRDmd+NO
   wkXV2nMutsWdw19u0a+P+UTZYyNktBeLR5FlX60hXQs4vBlh+wqYhsEpz
   OWBDzV9BFtIrt0/5mG4dUE88YIm4ph5OLyVUz3eOZrUKA3PMvi8gW4Vkl
   zZAYXYSEPeI7byNa1mjTyYEUgU9EmYofqtF9Wo3EGBEVsjbOKw36+KLhI
   rheO/n6rIMIDwDMMO4MvpFBh3KS1+GABHIa8WSUw03V4+33sGq//Cuyyd
   OhdTI48xw3gT/25eQlw/UTAPOJMFiCyjlcP/sBm9deHDCxzHc8ybWYcwj
   Q==;
X-CSE-ConnectionGUID: Fa5lswUTSU2nN32WQ+oUfA==
X-CSE-MsgGUID: sgOFPSxkQBi5Rnkvyb4Smg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575800"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575800"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:43 -0700
X-CSE-ConnectionGUID: tgNV8VBGQZCeDbH45rLYUw==
X-CSE-MsgGUID: wtvYmBxURTqr/ngc2YMzkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092536"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:39 -0700
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
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	adrian.hunter@intel.com,
	kai.huang@intel.com
Subject: [PATCH v3 0/8] TDX host: metadata reading tweaks, bug fix and info dump
Date: Tue, 27 Aug 2024 19:14:22 +1200
Message-ID: <cover.1724741926.git.kai.huang@intel.com>
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

Dear maintainers,

This series targets x86 tip.  Also add Dan, KVM maintainers and KVM list
so people can also review and comment.

This is a pre-work of the "quite near future" KVM TDX support (see the
kvm-coco-queue branch [2], which already includes all the patches in the
v2 of this series).  I appreciate if you can review, comment and give
tag if the patches look good to you.

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


[1] https://github.com/intel/tdx/commits/kvm-tdxinit-host-metadata-v3/
[2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
[3] https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355
[4] https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef
[5] https://github.com/canonical/tdx/issues/135#issuecomment-2151570238
[6] https://cdrdv2.intel.com/v1/dl/getContent/773614


Kai Huang (8):
  x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec
    better
  x86/virt/tdx: Remove 'struct field_mapping' and implement
    TD_SYSINFO_MAP() macro
  x86/virt/tdx: Prepare to support reading other global metadata fields
  x86/virt/tdx: Refine a comment to reflect the latest TDX spec
  x86/virt/tdx: Start to track all global metadata in one structure
  x86/virt/tdx: Print TDX module basic information
  x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find
    memory holes
  x86/virt/tdx: Don't initialize module that doesn't support NO_RBP_MOD
    feature

 arch/x86/virt/vmx/tdx/tdx.c | 276 +++++++++++++++++++++++++++---------
 arch/x86/virt/vmx/tdx/tdx.h |  89 ++++++++++--
 2 files changed, 292 insertions(+), 73 deletions(-)


base-commit: e77f8f275278886d05ce6dfe9e3bc854e7bf0713
-- 
2.46.0


