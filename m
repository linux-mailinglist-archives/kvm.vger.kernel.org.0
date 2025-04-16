Return-Path: <kvm+bounces-43393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66682A8AFDE
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6AEF189F154
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 05:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887E622B8BC;
	Wed, 16 Apr 2025 05:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVbutvkW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DF5229B29;
	Wed, 16 Apr 2025 05:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744782801; cv=none; b=E/BTXC2dKB2QGfIC2tjP+Edsi+N8JwsgEeSb5hYzxtdqajROwzXVpYgYfwwpJyqOQsKXZLbUx6sO9/sD9LKiBfYNynLiVaVCYaZUJz56CEF2sd/XtcQI0OiEmyypc/wwOnj54YSgJusbZeZoAe7BoMRmya7nSj+1KCmBPCjsyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744782801; c=relaxed/simple;
	bh=rHpycp+BtAtplH1umX1V2eYN0pjW7kOMVKZxOx2x8wE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=utJ1wSWSv8E+pRDF20czmu05ULL70aQEL9WqiN39t0qWDQL8HLIH6KWC8cZIPIQQE1nrw+9VyuAy2a81RoPEI0ljYFXpl90S1dvgnyNQdSA7PBY8HfLWfGMdImYK0X5JXx+d/C1S0eN3XneTMe3E8eIDqkKUGrndPyuDbJfZzYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVbutvkW; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744782800; x=1776318800;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rHpycp+BtAtplH1umX1V2eYN0pjW7kOMVKZxOx2x8wE=;
  b=nVbutvkW7qNrLIru900/t4dK00byuicXykPa0OOlS2fmP2Fy7VNaLK+D
   vb+7oR1SzPlAPJAdOvOG20g9mkvbopzy+wa9VJ317rARQOzVkMKF4/8N0
   1wZDkXEa8WorSzI7nd8bgQVKNC//kv/ccx6p3Keek5ygeIiytHF9kTVvY
   KccrcGMfNCHATG7rJVFy+Y3pyYoRmCDyPij4s8vMKst9kH5g+fkb8FrvQ
   PAqywdoN+MV9BQRsDkvhX0/WoaQI7Pi3UfDCKZwcq8tG9WW3z9WWkUbvT
   fMqhlIVR/L2vVEnafnX0NThVxAC1qZ8P23rpSuYHPl4HaIc0TmOcukXnw
   w==;
X-CSE-ConnectionGUID: gEfxioPqRqGXfaq1OAQavw==
X-CSE-MsgGUID: 1nkRNc5LS1CHw/Qd7IzjSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="45449738"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="45449738"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 22:53:19 -0700
X-CSE-ConnectionGUID: 1E2YpoKbR1+8cdWGnVbmPA==
X-CSE-MsgGUID: RrSvcdAXTl6aE07Sz9aI4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="130874814"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 22:53:15 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 0/1] TDX attestation support
Date: Wed, 16 Apr 2025 13:54:31 +0800
Message-ID: <20250416055433.2980510-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Paolo mentioned possibly wanting to include attestation in the initial TDX
support. Please consider it with that as the tentative plan. If it is not
included in the initial support, it would require an opt-in when the
support is added.

Notable changes since v1 [0]
============================
- KVM only checks the SHARED bit of the GPA from TDX guests and drops it
  before exiting to userspace to avoid bleeding the SHARED bit into its
  exit ABI [1].  Other sanity checks are skipped.
- Dropped the patch for TDG.VP.VMCALL<SetupEventNotifyInterrupt>, which has
  no users.
- Use number 40 for KVM_EXIT_TDX_GET_QUOTE since this could probably win the
  race upstream with AMD's SNP certificate-fetching patch [2].

Overview
========
TDX Guest-Host Communication Interface (GHCI) [3] spec defines two
TDVMCALLs for TDX attestation mechanism.

- TDG.VP.VMCALL<GetQuote>
  GetQuote is a doorbell-like interface used by TDX guests to request VMM
  to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
  operating on the host.
- TDG.VP.VMCALL<SetupEventNotifyInterrupt>
  SetupEventNotifyInterrupt can be used by TDX guests to specify an
  interrupt vector as an event-notify vector for GetQuote operation, which
  may take several seconds. If a TDX guest has setup the event-notify
  vector, the host VMM injects an interrupt with the specified vector to
  the TDX guest on completion of the operation.

TDG.VP.VMCALL<SetupEventNotifyInterrupt> is optional and is not used by TDX
guests, this patch series adds only the support for TDG.VP.VMCALL<GetQuote>
to enable TDX attestation on KVM side. KVM forwards the requests to
userspace VMM.  Instead of using a single KVM_EXIT_TDX, it's preferred that
each TDVMCALL that KVM wants to forward needs a dedicated KVM_EXIT_<reason>
and associated struct in the exit union [4].  The TDVMCALLs supported in [5]
reuse the existing KVM exit reasons.  For TDX attestation support, add a TDX
specific KVM exit reasons based on the discussion in the PUCK meeting on
2025.02.19 [6].  After returning from userspace, KVM sets the return code
specified by userspace before resuming the vCPU.


Base of this series
===================
This series is based on kvm/next or kvm-coco-queue with the commit:
- 'fd02aa45bda6' ("Merge branch 'kvm-tdx-initial' into HEAD").

Repos
=====
The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-04-15

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2025-04-15

It requires TDX module 1.5.06.00.0744 [7], or later.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").


Testing
=======
This patch series has been tested as part of the development branch for the
TDX base series.  The testing consisted of TDX kvm-unit-tests and booting a
Linux TD, and TDX enhanced KVM selftests.  It also passed the TDX related
test cases defined in the LKVS test suite as described in:
https://github.com/intel/lkvs/blob/main/KVM/docs/lkvs_on_avocado.md

The functionality of GetQuote has been tested with the Quote Generation
Service deployed on the host, thanks to Mikko Ylinen.

KVM selftests patch below, which is based on the latest TDX KVM selftests
patch series [8], was used to test the flows of GetQuote as well:
https://github.com/intel/tdx/commit/12b51b65b88ee95c3b0ce8ebc623408ecd8eea49


[0] https://lore.kernel.org/kvm/20250402001557.173586-1-binbin.wu@linux.intel.com
[1] https://lore.kernel.org/kvm/Z_Z61UlNM1vlEdW1@google.com
[2] https://lore.kernel.org/kvm/20250219151505.3538323-2-michael.roth@amd.com
[3] https://cdrdv2.intel.com/v1/dl/getContent/726792
[4] https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com
[5] https://lore.kernel.org/kvm/20250222014225.897298-1-binbin.wu@linux.intel.com
[6] https://drive.google.com/file/d/1fk957DWsyqWk-K-FqhBxdUtgrQYcZrqH/view?usp=drive_link&resourcekey=0-JFJuzmaZIux6_D6lhcxT7Q
[7] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06
[8] https://lore.kernel.org/kvm/20250414214801.2693294-1-sagis@google.com

Binbin Wu (1):
  KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>

 Documentation/virt/kvm/api.rst | 25 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c         | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  7 +++++++
 3 files changed, 62 insertions(+)

-- 
2.46.0


