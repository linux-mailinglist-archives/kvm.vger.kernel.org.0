Return-Path: <kvm+bounces-73193-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GB/MH5F5q2nsdQEAu9opvQ
	(envelope-from <kvm+bounces-73193-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:04:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E937D229368
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3108830269C4
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E0B2877E5;
	Sat,  7 Mar 2026 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpM9qtE2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2A276049;
	Sat,  7 Mar 2026 01:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845451; cv=none; b=FERnpU/VhSqZ3A8DFo5fKTf02Zxngm+U80FryqMa2S0Ezj85iFjLeUlfB84j5loSBKk8sb8crc+WMGKfwWwxaEGFsAaXfk/0VvllMqqkTfaf5rY6wOHBWUwdp1vkdRdLcoZPaE9JiJXy9gUOHVulIFPyxGhQK+u6KRP4KVSIAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845451; c=relaxed/simple;
	bh=4XM2ff2ThEtFsRqrd+G00jyxfY1SSgfjR0UuWwVgjtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qosn0x9aVe/SRBoFVOa5auZVLDd7oWknrKMoCE2qPCB910UbLutwD7bmTZv3FRGz9ZfI4rOWeKXUpuMYsA67WybjNZGe4y5GtHd34pJwqr9vgyMbZDwtD62oPLfMTYFl3IoZrkj6dmqzXhRiNcSeFjU3ovMSuELIrc6CK20XXMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpM9qtE2; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772845449; x=1804381449;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4XM2ff2ThEtFsRqrd+G00jyxfY1SSgfjR0UuWwVgjtk=;
  b=bpM9qtE2+fywsf/Wk0YbdHe4EWrOlyrtW0s8qa6Hf7tZI6KBxQbZlJ31
   OuQcyvIuxR3tt7ESXv2L1rV+eB264TeCiITk4pC5SLLpz60FgJ3C4U3LG
   Bz5BYd5oj3qW8fnY0Pks+XbEFctXagadv1wTrYmS4LXbkkYGGXkcFrclQ
   eigp9limvdQk4mkGN9pD2pKQPgvZ0yKaOC9Y0p9SbB3wry/by31hx+t8w
   HJbmsBqHq5/4J57jPvA0qvPGSIcsldz40btpSulF5BOQvawOoXk8k4tYC
   dcFFA6+BUIXT1Gx9+haOd9Rdx8CvP77L/ITaLZyWXng+eNgXGugN3puiq
   A==;
X-CSE-ConnectionGUID: sNbd6D2PRRqcPvoATZ6v+A==
X-CSE-MsgGUID: 73syY9OaRQ2Ozhn5YdZd1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="76565933"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="76565933"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
X-CSE-ConnectionGUID: n/LpENf/QiubY3rvigVfHw==
X-CSE-MsgGUID: JkdgngmCS4Ss9B8MIWm8Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="218329614"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:07 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	dave.hansen@intel.com,
	hpa@zytor.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@kernel.org,
	x86@kernel.org,
	chao.gao@intel.com,
	kai.huang@intel.com,
	ackerleytng@google.com
Cc: rick.p.edgecombe@intel.com,
	vishal.l.verma@intel.com
Subject: [PATCH 0/4] Fuller TDX kexec support
Date: Fri,  6 Mar 2026 17:03:54 -0800
Message-ID: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E937D229368
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73193-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.990];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:url,intel.com:mid]
X-Rspamd-Action: no action

Hi,

This series adds a couple of cool things -
 1. Allow kexec and kdump on systems with the partial write errata
 2. Allow using TDX in the second (kexec'ed) kernel
 
It has been waiting for VMXON refactor to land because the implementation 
is much cleaner on top of that. The series was mostly done by Vishal, 
however for scheduling reasons I'm posting it on his behalf. I can handle 
all questions/comments for the time being. So it's ready for review.

KVM folks, just a few deletions on your side and the long discussed moving 
of tdx_errno.h. Tip folks and reviewers, the changes here are pretty small. 
Optimistically, I'm hoping we can iterate this quickly and see it off the
list in the next few weeks.

Background
==========
Some early TDX-capable platforms have an erratum where a partial write
to TDX private memory can cause a machine check on a subsequent read.
Currently, kexec and kdump are disabled on these platforms because the
new (or kdump) kernel may trip over these, causing a machine check.

Future TDX modules will support TDH.SYS.DISABLE SEAMCALL, which disables
the TDX module and reclaims all memory resources allocated to TDX, and
cleans up any poison. After this SEAMCALL succeeds, the new kernel
can also re-initialize the TDX module from scratch via the normal bring-up
sequence.

It is probably worth mentioning that this is a different kind of cleanup 
than the WBINVD stuff that was the cause of all the fuss in the earlier 
kexec enabling. The WBINVD is flushing private keyid cachelines so they 
are not later written back over the new kernels memory. It needs to happen 
after the last SEAMCALL that might have produced them. So this new 
SEAMCALL is for something else, but also needs to be slotted with respect 
to WBINVD.

Implementation
==============
The series adds:

 1. A pre-requisite patch to move TDX error code definitions to a
    shared location so that TDX_INTERRUPTED_RESUMABLE etc. are
    accessible from arch/x86/virt/vmx/tdx/. This comes from the Dynamic
    PAMT series [0], but is also needed by some other series, and can
    benefit them all from an early merge.

 2. A preparatory patch to move some straggling stuff into arch/x86 in the
    wake of the VMXON series.

 3. A tdx_sys_disable() helper that wraps calls TDH.SYS.DISABLE with a
    retry loop to handle TDX_INTERRUPTED_RESUMABLE.

 4. Integration into the kexec path: Remove the check for partial write
    errata platforms as this is addressed by the SEAMCALL clearing any
    poisoned memory locations. Call tdx_sys_disable() in tdx_shutdown
    which is called via syscore ops in the kexec path. Call
    tdx_sys_disable() in native_machine_crash_shutdown() to cover the
    crash (kdump) path.

Testing
=======
The new SEAMCALL has NOT been implemented in a TDX module yet. The
implementation is based on the draft TDX module spec available at [1].

Testing was limited to the TDX CI, and a basic kexec test. The code needs 
to be robust to the TDX module not containing the feature, so this 
effectively serves as regression test. During development further testing 
was done by mocking up the new SEAMCALL to introduce delays and exercise 
the retry loops, combined with kexec, kdump, reboot and shutdown flows.

Base
====
This series is based on the vmxon branch Sean pushed to kvm_x86, 
kvm-x86-vmxon-2026.03.05.

[0]: https://lore.kernel.org/kvm/20260129011517.3545883-11-seanjc@google.com/
[1]: https://cdrdv2.intel.com/v1/dl/getContent/871617

Kiryl Shutsemau (1):
  x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>

Rick Edgecombe (1):
  x86/virt/tdx: Pull kexec cache flush logic into arch/x86

Vishal Verma (2):
  x86/virt/tdx: Add SEAMCALL wrapper for TDH.SYS.DISABLE
  KVM: x86: Disable the TDX module during kexec and kdump

 arch/x86/include/asm/shared/tdx.h             |  1 +
 .../vmx => include/asm/shared}/tdx_errno.h    | 27 +++++++++--
 arch/x86/include/asm/tdx.h                    | 29 ++----------
 arch/x86/kernel/crash.c                       |  2 +
 arch/x86/kernel/machine_kexec_64.c            | 16 -------
 arch/x86/kvm/vmx/tdx.c                        | 10 ----
 arch/x86/kvm/vmx/tdx.h                        |  1 -
 arch/x86/virt/vmx/tdx/tdx.c                   | 46 +++++++++++++------
 arch/x86/virt/vmx/tdx/tdx.h                   |  1 +
 9 files changed, 62 insertions(+), 71 deletions(-)
 rename arch/x86/{kvm/vmx => include/asm/shared}/tdx_errno.h (65%)

-- 
2.53.0


