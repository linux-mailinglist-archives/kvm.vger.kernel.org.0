Return-Path: <kvm+bounces-31964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 583499CF5F7
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC8E01F2526E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784ED1E3799;
	Fri, 15 Nov 2024 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="muER5QqR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422F41E32CC;
	Fri, 15 Nov 2024 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702041; cv=none; b=ofel3Y5CbXNaedG7rPiw4iazhtLTi6G26Jm5PnXQ4vEX/anzIAkhsNTuVORELM6J1fXCdiy/KGarGuVscpFTG1jZDkK+WDKok7PL6v+yNFdJDu5p0RVkxHTcCgT9tVTRRVQeLrOownbpTPNlGPoI18L+3Lz6vx6crwLJl5VHCkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702041; c=relaxed/simple;
	bh=s65poLiuDz62CRLOs68ECur5fUUiqVtlnSqM0XtBTJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cLbxmg3tky09gt1B5GMaDqDfwBQCrzewfNWy6rlF6tb70v9BCZleK0AkVMr6Ia77Z5g1c3Q1LtTnjc1lOrbmhTVYQq6+eAVXEBXh4/c9ErW4J9JKder7lKCZHgZ379sEJ0JpYvIxIHCexwY4xDkyj9Q3WK0ZkruvSGWNab7p96U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=muER5QqR; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702040; x=1763238040;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s65poLiuDz62CRLOs68ECur5fUUiqVtlnSqM0XtBTJk=;
  b=muER5QqRnlx7FA+tUQ2+eTjSy8XCx8sEE6rVP3UiWY4t282LCqyNoJut
   EhOMGRV6sWjxS+wBy5k7EElyrERkjHz92AwhE4i0njW5o19QgZP47C33C
   bGFo5rPXAgGjjW9U60mDG2yKwWMChZqeud95j0heFbmDUs+926dsSNJfg
   Rju+wTmAY06LSROquWCnYxpdXboSfRivxtuA8NPC1ocP0XQS7gyXOW6Hh
   LF2QSIHEwTj9tMKOWy6WrVIokVz0ATt+Xw0004QVZtH9Vs9sWmnMrM7NS
   vQAamUWosUHJsEMIROejXwULqzHMzV8HvfnWfHgMkjLv0TUsNc5Zc+OKE
   Q==;
X-CSE-ConnectionGUID: HvE3rASRSeOvUHvhZnQIRg==
X-CSE-MsgGUID: 9UY06ZrFQC2JA/LEjmqwEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228326"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228326"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:39 -0800
X-CSE-ConnectionGUID: oJm1fsdhTs20/RW2cyzdNw==
X-CSE-MsgGUID: uYCNpBDaTG2HBOiRbh83YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599389"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:38 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@intel.com
Cc: isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	x86@kernel.org,
	adrian.hunter@intel.com
Subject: [RFC PATCH 0/6] SEAMCALL Wrappers
Date: Fri, 15 Nov 2024 12:20:21 -0800
Message-ID: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is a quick followup to Dave’s comments on the SEAMCALL wrappers in 
the “TDX vCPU/VM creation” series [0]. To try to summarize Dave’s 
comments, he noted that the SEAMCALL wrappers were very thin, not even 
using proper types for things where types exist, like pages. There were a 
couple directions discussed for passing the pages that are handed to TDX 
module for it to use to manage a TD state:
 - Using virtual addresses to host mappings for the page
 - Using structs for each type of physical page, such that there could be
   type checking on all of the similar tdXYZ TDX page types.
 - Pulling in “linux/kvm_types.h” in arch/x86 code to handle types 
   (especially since the later MMU SEAMCALLs take GFN arguments)

There was also some repeated points made that the argument names could use 
some semantic clarity, including possible creating enums for out args.

But overall, I interpreted there to be a wish for the wrappers to do 
something a little more useful than use the EXPORT infrastructure as an 
allow list for approved SEAMCALLs.

I first played around with basically keeping the existing design and using 
KVM’s hpa_t, etc for the types. This really didn’t add much improvement. 
Using virtual addresses simplified some of the code on the KVM side, but 
contrasted with KVM code style that is used to handling physical addresses 
for most things. It also was weird considering that these pages are 
encrypted and can’t be used from the kernel.

The solution in this RFC
------------------------
As we discussed on that series, the SEAMCALL wrappers used to take the KVM 
defined structs that represent TDs and vCPUs, instead of raw tdXYZ page 
references. This was pretty handy and good for avoiding passing the wrong 
type of TDX tdXYZ page, but these structs have a bunch of other stuff that 
is specific to KVM. We don’t want to leak that stuff outside of KVM. But I 
think it is ok for the arch/x86 code to know about TDX arch specific things
that VMMs are generally required to have to manage. So this RFC creates
two structs that represent TDs and vCPUs. They hold references to the tdXYZ
pages that are provided to the TDX module and associated with there 
respective architectural concept (TD and vCPU):
	struct tdx_td {
		hpa_t tdr;
		hpa_t *tdcs;
	};

	struct tdx_vp {
		hpa_t tdvpr;
		hpa_t *tdcx;
	};

I used hpa_t based on that it is commonly used to hold physical addresses 
in KVM, including similar kernel allocated memory like TDP root pages. So 
I thought it fit KVM better, stylistically. It was my best attempt at 
guessing what KVM maintainers would like. Other options could be 
kvm_pfn_t. Or just struct page.

They are passed into the SEAMCALL wrappers like:
	u64 tdh_mng_vpflushdone(struct tdx_td *td)

These new structs are then placed inside KVM’s structs that track TDX 
state for the same concept, where previously those KVM structs held the 
references to the pages directly, like:
struct kvm_tdx {
	struct kvm kvm;

-	u64 tdr;
-	u64 *tdcs;
+	struct tdx_td td;
	...
};

It does get a bit nested though, for example:
	kvm->kvm_arch->(container_of)kvm_tdx->tdx_td->tdr
...but the actual final dereferences in the code don’t need to go that
deep, and look like:
	err = tdh_mng_vpflushdone(&kvm_tdx->td);

Overall, it's not a huge change, but does give the arch/x86 a little more
purpose. Please let me know what you think.

There also was a suggestion from Dave to create a helper to hold a comment 
on the “CLFLUSH_BEFORE_ALLOC” reasoning. This is implemented in this RFC.

Separate from discussions with Dave on the SEAMCALLs, there was some some 
suggestions on how we might remove or combine specific SEAMCALLs. I didn’t 
try this here, because this RFC is more about exploring in general how we 
want to distribute things between KVM and arch/x86 for these SEAMCALL 
wrappers.

So in summary the RFC only has:
 - Use structs to hold tdXYZ fields for TD and vCPUs
 - Make helper to hold CLFLUSH_BEFORE_ALLOC comments
 - Use semantic names for out args
 - (Add Kai's sign-off that should have been in the last version)
  
Patches 1 and 3 contain new commit log verbiage justifying specific design
choices behind the struct definitions.

I didn’t create enums for the out args. Just using proper names for the 
args seemed like a good balance between code clarity and not 
over-engineering. But please correct if this was the wrong judgment.

Here is a branch for seeing the callers. I didn’t squash the caller 
changes into the patches yet either, the caller changes are all just in the
HEAD commit. I also only converted the “VM/vCPU creation” SEAMCALLs to the
approach described above:
https://github.com/intel/tdx/tree/seamcall-rfc

[0] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com/


Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

 arch/x86/include/asm/tdx.h  |  29 +++++
 arch/x86/virt/vmx/tdx/tdx.c | 224 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  38 ++++--
 3 files changed, 284 insertions(+), 7 deletions(-)

-- 
2.47.0


