Return-Path: <kvm+bounces-19737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFD4909D2D
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77BF2B20DFC
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83469187548;
	Sun, 16 Jun 2024 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMK/Ig3B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18816A008;
	Sun, 16 Jun 2024 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539304; cv=none; b=hQ1bq/jfx4Plbdupw7I8RgOCU7XnPq6mjzdqyI7D0sy7ArJTc0vMWbfgQtB6wFuXZLuXR6sLq/YKAb2+xywUSVa13uAQqn75ZfYlOaFWlJW3rVkoqH++CW9Uv73XK6cUvBZL1AU5v1lHR5QbPGxtlPVJz/hoxOF2rbk80OuLnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539304; c=relaxed/simple;
	bh=THbV1C03OMWmYKmsNsRVLP81qz63umkNBZkRRw8wkmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VffxQH18bvl270BG7OZP6jMP5UVI6M3rMQYVe1urugSZ/gE+UeDvb/YN90GGo/LppbSI7Hzej+YwoSSac9kCuNCgHLeFnje33lxHVVWwuy2HE+BPtxOk/nHOygshxYgcDrK/Q0khjkdDQSpJ4wjiKs6dpAEeNdCFl30gPFJwQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMK/Ig3B; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539303; x=1750075303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=THbV1C03OMWmYKmsNsRVLP81qz63umkNBZkRRw8wkmg=;
  b=PMK/Ig3BXWKKIwBN6TezypG085JReNuIIUkC+sMfaKoQSJFNgPsNZZ1t
   rsIS4CPtDuAaW+clzaWAIyW0bNz7gahnijbSML+TRvBk14OA4x6yfV1Pc
   MwPIdTQGN4+cbayeW9MIhMBv8J7w9wb8n5EblTEzIm3d474ybFsOSQr1b
   H567f2ELU+Hv0RCgKNeEBPMPbXgFq2AE9oxo3bB0ADIiM6Q19CqWFUR5+
   qnX6UI87FTHQJNpjzcCMSYMNgUbHFVwwWo5Duf4ZO7s9dkGko/hydU2E9
   htXjs35Dijv3qSaRqYkfv5dkb9QQkdmZtr/C73GuE0YMpthbrM/rhVhCx
   w==;
X-CSE-ConnectionGUID: XNxmWiN/TamsqX3FIqCB5A==
X-CSE-MsgGUID: NzvDB9lXQqWRTzbeg6vFYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26799982"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26799982"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:42 -0700
X-CSE-ConnectionGUID: khxsiZxYTaOEgt6V2TQDUA==
X-CSE-MsgGUID: di5pjKUnSMqT+ssLkYGvDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055791"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:38 -0700
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH 0/9] TDX host: metadata reading tweaks, bug fix and info dump
Date: Mon, 17 Jun 2024 00:01:10 +1200
Message-ID: <cover.1718538552.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
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

Hi Dave, Dan, Rick,

The "reading CMRs" part is a new (related) issue that I got received
last week so I also included in this patchset.

=== More info ===

TDX module provides a set of "global metadata fields" for software to
query.  They report things like TDX module version, supported features
fields required for creating TDX guests and so on.

Today the TDX host code already reads "TD Memory Region" (TDMR) related
metadata fields for module initialization.  There are immediate needs
that require TDX host code to read more metadata fields:

 - Dump basic TDX module info [1];
 - Reject module with no NO_RBP_MOD feature support [2];
 - Read CMR info to fix a module initialization failure bug [3].

Also, the upstreaming-on-going KVM TDX support [4] requires to read more
global metadata fields.  In the longer term, the TDX Connect [5] (which
supports assigning trusted IO devices to TDX guest) may also require
other kernel components (e.g., pci/vt-d) to access more metadata.

To meet all of those, the idea is the TDX host core-kernel to provide a
centralized, canonical, and read-only structure to contain all global
metadata that comes out of TDX module for all kernel components to use.

There is an "alternative option to manage global metadata" (see below)
but it is not as straightforward as this.

This series starts to track all global metadata fields into a single
'struct tdx_sysinfo', and reads more metadata fields to that structure
to address the immediate needs as mentioned above.

More fields will be added in the near future to support KVM TDX, and the
actual sharing/export the "read-only" global metadata for KVM will also
be sent out in the near future when that becomes immediate (also see
"Share global metadata to KVM" below).

Note, the first couple of patches in this series were from the old
patchset "TDX host: Provide TDX module metadata reading APIs" [6].

=== Further read ===

1) Altertive option to manage global metadata

The TDX host core-kernel could also expose/export APIs for reading
metadata out of TDX module directly, and all in-kernel TDX users use
these APIs and manage their own metadata fields.

However this isn't as straightforward as exposing/exporting structure,
because the API to read multi fields to a structure requires the caller
to build a "mapping table" between field ID to structure member:

	struct kvm_used_metadata {
		u64 member1;
		...
	};

	#define TD_SYSINFO_KVM_MAP(_field_id, _member)	\
		TD_SYSINFO_MAP(_field_id, struct kvm_used_metadata, \
				_member)

	struct tdx_metadata_field_mapping fields[] = {
		TD_SYSINFO_KVM_MAP(FIELD_ID1, member1),
		...
	};

	ret = tdx_sysmd_read_multi(fields, ARRAY_SIZE(fields), buf);

Another problem is some metadata field may be accessed by multiple
kernel components, e.g., the one reports TDX module features, in which
case there will be duplicated code comparing to exposing structure
directly.

2) Share global metadata to KVM

To achieve "read-only" centralized global metadata structure, the idea
way is to use __ro_after_init.  However currently all global metadata
are read by tdx_enable(), which is supposed to be called at any time at
runtime thus isn't annotated with __init.

The __ro_after_init can be done eventually, but it can only be done
after moving VMXON out of KVM to the core-kernel: after that we can
read all metadata during kernel boot (thus __ro_after_init), but
doesn't necessarily have to do it in tdx_enable().

However moving VMXON out of KVM is NOT considered as dependency for the
initial KVM TDX support [7].  Thus for the initial support, the idea is
TDX host to export a function which returns a "const struct pointer" so
KVM won't be able to modify any global metadata.

Whether to export the 'const struct tdx_sysinfo *' (which points to all
metadata), or the pointer to a smaller set of metadata can be discussed
in the future.

Adding new fields to 'struct tdx_sysinfo' for KVM is similiar to the
patch 7 ("x86/virt/tdx: Print TDX module basic information").

3) TDH.SYS.RD vs TDH.SYS.RDALL

The kernel can use two SEAMCALLs to read global metadata: TDH.SYS.RD and
TDH.SYS.RDALL.  The former simply reads one metadata field to a 'u64'.
The latter tries to read all fields to a 4KB buffer.

Currently the kernel only uses the former to read metadata, and this
series doesn't choose to use TDH.SYS.RDALL.

The main reason is the "layout of all fields in the 4KB buffer" that
returned by TDH.SYS.RDALL isn't architectural consistent among different
TDX module versions.

E.g., some metadata fields may not be supported by the old module, thus
they may or may not be in the 4KB buffer depending on module version.
And it is impractical to know whether those fields are in the buffer or
not.

TDH.SYS.RDALL may be useful to read one small set of metadata fields,
e.g., fields in one "Class" (TDX categories all global metadata fields
in different "Class"es).  But this is only an optimization even if
TDH.SYS.RDALL can be used, so leave this to future consideration.


[1] https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355
[2] https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef
[3] https://github.com/canonical/tdx/issues/135#issuecomment-2151570238
[4] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/T/
[5] https://cdrdv2.intel.com/v1/dl/getContent/773614
[6] https://lore.kernel.org/lkml/cover.1709288433.git.kai.huang@intel.com/T/
[7] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/T/#me0c081438074341ad70d3525f6cf3472d7d81b0e




Kai Huang (9):
  x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
  x86/virt/tdx: Unbind global metadata read with 'struct
    tdx_tdmr_sysinfo'
  x86/virt/tdx: Support global metadata read for all element sizes
  x86/virt/tdx: Abstract reading multiple global metadata fields as a
    helper
  x86/virt/tdx: Move field mapping table of getting TDMR info to
    function local
  x86/virt/tdx: Start to track all global metadata in one structure
  x86/virt/tdx: Print TDX module basic information
  x86/virt/tdx: Exclude memory region hole within CMR as TDMR's reserved
    area
  x86/virt/tdx: Don't initialize module that doesn't support NO_RBP_MOD
    feature

 arch/x86/virt/vmx/tdx/tdx.c | 315 ++++++++++++++++++++++++++++++------
 arch/x86/virt/vmx/tdx/tdx.h |  80 ++++++++-
 2 files changed, 338 insertions(+), 57 deletions(-)


base-commit: 281f8331020e339b607154455faec6ebf5861a2c
-- 
2.43.2


