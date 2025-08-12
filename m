Return-Path: <kvm+bounces-54518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94161B226C9
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 14:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B3695087BC
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB09621638A;
	Tue, 12 Aug 2025 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K3HHyj/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236FF1F1517;
	Tue, 12 Aug 2025 12:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755001765; cv=none; b=QTUAW3jEPAqg+UqIHGg4BsH4vf4Z6+iR6LQqWke92Oh8gGIcCK3ksOSzqbjv/vfDEYCVn5LmvDN+RfffDZ22oZ+OvMqE9LR3Tn0n+FGbfFvv2PTnJ97Qsqx8lTahvX9aOo8upqIlX2JLDzYsEA9zqfkSunL4iFx3NTuNECp5oWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755001765; c=relaxed/simple;
	bh=wUMFXw1ikUbmB37qJt2ibITa/9ZqIPjHsM1j5azCU4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WSpCj6JUxnERm6KWfYqwCUc7kJofErw/h9tgUa1PYd1MUcKU0MEV0CiDd1hu6iTAE7mFE+7dbj+3zjJIX4AZibfKwoVirSTK+UkV8LJLLrncWT52AYoNl3kHPeKbUo/bmszIArVVOkjx6wVyhTpj5Qyf2J97ImmF+LkfSFKa2dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K3HHyj/M; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755001763; x=1786537763;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wUMFXw1ikUbmB37qJt2ibITa/9ZqIPjHsM1j5azCU4k=;
  b=K3HHyj/MoiO2UtDd5BVCqG25nxI+FcpkK95EZTixD/sz22frXRuWm5Cm
   9NmHqPP88ZPL4YIKv2HKXKA/2NbFigZkqIqctjG3svJWXT6Zky+RWVItN
   PjDeFYjuNruxWP8hPiiOG76f6zHp/NtPdlNFoJ2uNcXUrjQZqcfauTtCL
   EZwW8IdPq2iGPBFVFOoBxK7X2G0h4JtR4R2yLLuLt961rVc0s3RoBnXU6
   qP2KNM+o59IGZT6pS0IaxXo1IpLIlxPO/ppA60+4O8OfDvGqYzvcP+Inl
   O05W90/y8Jc3gNO7BMdCQ7ThG8FDVOTopX/j2DTEbVTICrG5PxOI1kTz8
   w==;
X-CSE-ConnectionGUID: G5vw6UOhRC2kipZbNldp3Q==
X-CSE-MsgGUID: stSrHMSATC6QMAfktfrL+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68648841"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="68648841"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 05:29:22 -0700
X-CSE-ConnectionGUID: Hmi5Ss0UTnSxAFam/bOv3Q==
X-CSE-MsgGUID: K1CC5QUVQ2SjuvmdX2Eueg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166548316"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 05:29:16 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 0/2] Fixes for recovery for machine check in TDX/SEAM non-root mode
Date: Tue, 12 Aug 2025 15:28:57 +0300
Message-ID: <20250812122859.70911-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi


Here is V2 of a small fix related to recovery for machine check in TDX/SEAM
non-root mode, and a small tidy-up.


Changes in V2:

    x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM
    non-root mode
      Mask address when it is read
      Amend struct mce addr description

    KVM: TDX: Do not clear poisoned pages
      Patch dropped

    x86/mce: Remove MCI_ADDR_PHYSADDR
      New patch


The issue was noticed as part of work to determine the conditions under
which TDX private memory needs to be cleared after being reclaimed.
For guests with a large amount of memory, clearing all private pages during
VM shutdown can take minutes, so we are looking at when that can be
skipped.  A future patch will deal with that.

One thing that was investigated was the effect of deliberately corrupting a
TDX guest private page by writing to it on the host, and then reading it
on the guest, which results in a machine check as expected, but revealed
the issue addressed in patch 1.

There are 2 outstanding issues:

1. It is assumed that once the TDX VM is shutdown that the memory is
returned to the allocator.  That is true at present, but may not be in the
future.  Consider, for example, patch set "New KVM ioctl to link a gmem
inode to a new gmem file" :

      https://lore.kernel.org/r/cover.1747368092.git.afranji@google.com/

2. Currently, KVM TDX does not cater for the TDX VM to enter a FATAL error
state, where the only operation permitted is to tear down the VM.  KVM just
carries on, hitting various errors, but in particular, memory reclaim fails
because it is not following the teardown procedure, and all guest private
memory is leaked.


Adrian Hunter (2):
      x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM non-root mode
      x86/mce: Remove MCI_ADDR_PHYSADDR

 arch/x86/include/asm/mce.h      | 3 ---
 arch/x86/include/uapi/asm/mce.h | 2 +-
 arch/x86/kernel/cpu/mce/core.c  | 9 ++++++---
 drivers/cxl/core/mce.c          | 2 +-
 drivers/edac/skx_common.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)


Regards
Adrian

