Return-Path: <kvm+bounces-64642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CF8C89341
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB8D33A40BE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4705130103A;
	Wed, 26 Nov 2025 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j+xRCBUa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C272FFDDC;
	Wed, 26 Nov 2025 10:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764151942; cv=none; b=Fi9/l0Q1xUuZYPJuf/ZkQ0KLWmQKoYiSZsSRfGFEyk5HeZFS/X/2Y+whuYzvxb8TJKKoQVcXpuoj4uZfeQ0hZc9se4C0GtiCNYMjF+ZtWCnlrg3ztLhqODe/7yMUeYkFiSdZlU0C/bYQ/XRUKmGYbw1Vjrb+hSvbUsGwcUCQlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764151942; c=relaxed/simple;
	bh=aLKy8nSRP3ucBswNhLEEsXM7qghPXF05yi3+GN70UYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQR7l4B3E7IJ0aCw7MgVgo2xg4C4SDsRvnweHaNbGkqM3UTRi4l8AZuUx3il+8dfX0YrBO1PBkSh7dI9HTgv7fRkODoyU/1TXxNlvzWSk6nlSCO5pD8qirSsMx0J8HiN6vLhcCBstiOp1rJgqqt6XCL2ts8hKTCEYtxnbryc+cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j+xRCBUa; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764151940; x=1795687940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aLKy8nSRP3ucBswNhLEEsXM7qghPXF05yi3+GN70UYM=;
  b=j+xRCBUasMEiPiku9z/cC+Ptuhw2vPCVaQaE1ZajNQtynYMiVDLNcnvJ
   R9HTW0ypruUqKHZ8k+O8ajOnlPwNkb1RP1o8NcLrJPKKDirpPjguR6hT/
   b3ZRsU9K2enp4HcyVH94HMbeCuLeSUViLhEyESjzPc3lDMzigxrSy+mJo
   p8W1RjpJ18W4njhRSgg/Mp8usFosPKeXhW1zDgwPnkkvuTllAhvDo2eOq
   50Ojrb1J481PSNieKDFqCusUw+Uf9kb/dwODUishTOMQ1jWkIw4IK1uen
   eT5BQAUwyAA7MaOxHsM1zIpvgcqlx6pFetMZ5FoYXooGr+aoIUq4bVB5B
   A==;
X-CSE-ConnectionGUID: 0Gin3khaSLeW7lonLPEZpA==
X-CSE-MsgGUID: O+mXjOS2Rgyou1R5xZMYEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="70048227"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="70048227"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 02:12:19 -0800
X-CSE-ConnectionGUID: hXYVgR9CSeyUbf0OzaEzOQ==
X-CSE-MsgGUID: YqwaxlAtQWa5R7LYNu6GOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="223623641"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa002.jf.intel.com with ESMTP; 26 Nov 2025 02:12:16 -0800
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
Subject: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock in TDX guest
Date: Wed, 26 Nov 2025 18:02:03 +0800
Message-ID: <20251126100205.1729391-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251126100205.1729391-1-xiaoyao.li@intel.com>
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the host enables split lock detection feature, the split lock from
guests (normal or TDX) triggers #AC. The #AC caused by split lock access
within a normal guest triggers a VM Exit and is handled in the host.
The #AC caused by split lock access within a TDX guest does not trigger
a VM Exit and instead it's delivered to the guest self.

The default "warning" mode of handling split lock depends on being able
to temporarily disable detection to recover from the split lock event.
But the MSR that disables detection is not accessible to a guest.

This means that TDX guests today can not disable the feature or use
the "warning" mode (which is the default). But, they can use the "fatal"
mode.

Force TDX guests to use the "fatal" mode.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index 981f8b1f0792..f278e4ea3dd4 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -315,9 +315,24 @@ void bus_lock_init(void)
 	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
 }
 
+static bool split_lock_fatal(void)
+{
+	if (sld_state == sld_fatal)
+		return true;
+
+	/*
+	 * TDX guests can not disable split lock detection.
+	 * Force them into the fatal behavior.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
+		return true;
+
+	return false;
+}
+
 bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 {
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
+	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
 		return false;
 	split_lock_warn(regs->ip);
 	return true;
-- 
2.43.0


