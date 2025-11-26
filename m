Return-Path: <kvm+bounces-64641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F64C8933B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A95B4E404F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440FC2FD1D9;
	Wed, 26 Nov 2025 10:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B33Z0CTc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B42F747D;
	Wed, 26 Nov 2025 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764151938; cv=none; b=GYcnJVYHDZnigLmSl0iGaCw/ayRy/L6EFA/4RXTewRRc9qpuuzxUVeOynaf1xcDk9GbpxcvfNG5snu7eJySwmwnsJQIkuN9r97q73Q9zVQLw5yRtwdHFqYFKurz8Wx14Vj9B/v6ZwHHoWMmZBu0vKXJ8eunzrGeb8yEdatxjhZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764151938; c=relaxed/simple;
	bh=CiB1YbzMYPUGCB3qAMiXd1PRpLrpCP3+LvvLUPvg4Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jI9A4pkpH+CY9202MpVTXsriMKsVLD6yV0YHB+a4SG4F0V8H7JzUqM+ds/BpLGz+Fvl2Vn2xtY3lpykTDOI1ZCBmfjmHPObHVS7tbrCGwbJGzQ2WDCdOKNE6FiE7oLI5KjCpsTzeVfj/95nxMQlBjybXTxXnRj6sEkGLYF7Hv3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B33Z0CTc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764151937; x=1795687937;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CiB1YbzMYPUGCB3qAMiXd1PRpLrpCP3+LvvLUPvg4Bk=;
  b=B33Z0CTcrbxqu9keYs8M8ZbxQoXxn0QomJzsw1EJpVqx7ptoOgEd+Wln
   q6cOd+sZy0PSG64iF4ca1+JvIua1j19YoGkU/OELUUuKC4HqCTpRV197w
   uHleVm9r4injxgz3ifTSMq+WWSWJklec7rvW9aIhaIG2M0s2hEhjTGK0n
   ix4zUfpEZLgfEeoSiyOmXwmF2kmVe1w4qB7BJXp1FvtpunPrrQLZ7ZvCd
   USJomelhX/50D+7cQg2T8bgzf7CPE553LZwvbJ8jQO6jdYy0Fn/bVCSeh
   RP3ikT7ZG56ZgxZTD0wI9Z7E7+xr7r7WppAds5xNu8DR7iT22bWcbdJPl
   A==;
X-CSE-ConnectionGUID: JhnQ9JqISqi5nRt8WvhP1Q==
X-CSE-MsgGUID: CguhU9RnTQWglDz4zyI+5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="70048211"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="70048211"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 02:12:16 -0800
X-CSE-ConnectionGUID: 3wsm7EmaTPezhdFhttxuew==
X-CSE-MsgGUID: gEgeuEZ3QuG14LNI5Osy5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="223623610"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa002.jf.intel.com with ESMTP; 26 Nov 2025 02:12:13 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Kiryl Shutsemau <kas@kernel.org>
Cc: x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	chao.p.peng@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH 0/2] x86/split_lock: Fix and enhancement for TDX guest
Date: Wed, 26 Nov 2025 18:02:02 +0800
Message-ID: <20251126100205.1729391-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running a split lock test[1] inside a TDX guest under KVM triggers the
warning below. The test hangs but can be terminated.

  x86/split lock detection: #AC: split_lock/1176 took a split_lock trap at address: 0x5630b30921f9
  unchecked MSR access error: WRMSR to 0x33 (tried to write 0x0000000000000000) at rIP: 0xffffffff812a061f (native_write_msr+0xf/0x30)
  Call Trace:
  handle_user_split_lock
  exc_alignment_check
  asm_exc_alignment_check

It turns out that split lock detection is enabled (by the host) when the
TDX vCPU is running, and #AC is not intercepted but delivered directly to
the TDX guest. The default "warning" mode of split lock #AC handler in
the guest tries to handle the split lock by temporarily disabling
detection. However, the MSR that disables detection is not accessible to
a guest.

Patch 1 forces the TDX guest to always treat the split lock #AC as the
"fatal" mode. This prevents the TDX guest from attempting invalid MSR
writes.

Patch 2 enhances the sld_state_show() to indicate that the TDX guest can
receive #AC on split locks depending on the host's split lock detection
configuration.

Note that all the split lock issues on TDX guests are due to the
non-architectural behavior of TDX: a TDX guest can receive #AC even
though the split lock detection feature is not available and the
relevant MSR is not accessible.

One option is to make the behavior architectural for TDX guests by not
delivering the (unexpected) #AC to the TDX guest and letting the host
handle it instead. This is exactly how KVM handles split lock #AC for
normal VMs. This option also has the advantage that the TDX guest can
survive from split locks when the host mode is not fatal.

However, this option cannot replace current patches because it changes
the behavior of current TDX and would need to be opted-in by the host VMM
for compatibility. More importantly, it would be a new feature available
only in newer TDX modules, which means all existing TDX modules
cannot benefit from it.

We list the option here as an open to solicit feedback and determine
whether to pursue adding such feature to TDX module.

[1] https://github.com/xiaoyaoli-intel/splitlock/blob/main/splitlock.c

Xiaoyao Li (2):
  x86/split_lock: Don't try to handle user split lock in TDX guest
  x86/split_lock: Describe #AC handling in TDX guest kernel log

 arch/x86/kernel/cpu/bus_lock.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
-- 
2.43.0


