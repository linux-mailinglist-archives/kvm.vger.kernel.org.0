Return-Path: <kvm+bounces-63483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3EEC671FC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 5FFCA29E33
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDA8329C74;
	Tue, 18 Nov 2025 03:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIcIQ0xG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F49322A1F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436099; cv=none; b=rNdfQkdD/85O2W75cvrgoLUbpKxBFXkLwyFb+In+ji0M4DQ7rnTB9oYUjZOEPdAhSejDGkJkIw5D0uBjBhLCBSXfwMYfS4SY1Izq/I5uGxm6+2+LtLZGSGd74o3XbfexXpQb62IQrOv1cAxv0MJBQWKwfLU3ANGA+sQu74myqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436099; c=relaxed/simple;
	bh=0uF8jj575zYxVcWmkztmsgjmlH5SFSks+bBKxFEAv3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bkv/OVKxVz5yhY2qFjisrNPU033Y7yFGsPy7O9IezynC6d+k4k6mOdo47CUOCVo1jV8XxB8tFYCY4jPhrPVjUnFha6IEQ71Cgjl583VbH+YLFE5o9fqF2c5xfmprYZliDmu895CtGp1YObx4ggeKWabkPaXzcz0QY6IwwY0iMZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIcIQ0xG; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436098; x=1794972098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0uF8jj575zYxVcWmkztmsgjmlH5SFSks+bBKxFEAv3A=;
  b=bIcIQ0xGy1SgGmr+E/dVQ8Mzuam71Psqsl5KVleHRAy/7M9GCDUU5CD4
   mGAsHAzPNUryKMEmEbqQBisUlB2eo4lL8R2SlJ3DTqWJPsZf5rorXM3BN
   jbem1RP04Srywwe9UFtBIqDZACBBygQaRuD4+2BWvpS2R1lvPH9lWihTl
   UdSBvY1M+Vx1ey1ofkdaIpv8goBL+8Djd1Mx4FRlSUN3T7AN0G/FWzq3B
   EG0Y9+SzYuXR4zdCL1G7giPoKQN7qO7cjQ5CYLTZRTWETsD2nIAsoaut0
   8B8B+wQSmaMQP8iTQQ3UvkeqRQSYOJYfqC6PqIugH6XnP+n2Tcs4W9nSr
   g==;
X-CSE-ConnectionGUID: VHXw5zdURySJdNBKe3uV3Q==
X-CSE-MsgGUID: 6Z9Zm+6xQ6a3XKzhrsXs2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053957"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053957"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:38 -0800
X-CSE-ConnectionGUID: yAf05xPZRri5ON25CMKy6A==
X-CSE-MsgGUID: YjWtQHYSQQGvzBGxuphx5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537478"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:34 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 23/23] i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM
Date: Tue, 18 Nov 2025 11:42:31 +0800
Message-Id: <20251118034231.704240-24-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chenyi Qiang <chenyi.qiang@intel.com>

So that it can be configured in TD guest.

And considerring CET_U and CET_S bits are always same in supported
XFAM reported by TDX module, i.e., either 00 or 11. So, only need to
choose one of them.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Refine the commit message.
---
 target/i386/kvm/tdx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a3444623657f..01619857685b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -526,6 +526,8 @@ TdxXFAMDep tdx_xfam_deps[] = {
     { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
     { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
     { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_ECX, CPUID_7_0_ECX_CET_SHSTK } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_EDX, CPUID_7_0_EDX_CET_IBT } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },
-- 
2.34.1


