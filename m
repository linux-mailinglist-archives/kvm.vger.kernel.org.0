Return-Path: <kvm+bounces-63477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A628EC671E3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4BCBE3624BB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3904832862D;
	Tue, 18 Nov 2025 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvMyH/4R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300F329E4B
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436079; cv=none; b=g3Wb4ho99Zhz0GYI+ajLA4PGatL6ALMeZHWl7t3ndJW+v2rGb0o6jCd8pwMmV7C476zzOvnpPmHU0JPEZV4bIM4oO/9j2SdvRatf29es9OPSKzJFtifefNUODmZdecEHvU6Z7onN3OJBPC/3O8BmmnCTQsjBoaS13mS0VPE9yks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436079; c=relaxed/simple;
	bh=Lnoh54IK1xdUE7ReHUApDtVaHR1nAbgq/jys15IExB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aod9zlniY1hUT1QgF2mN5FsCzu6cHs14Fnfu403Sw3JCQDfTfoeooSkwrF805xCfSLvz3H/669M7RzXbbb9t8Z8UgI2Ijy5PpXuA713vPeDDcFJuq6ttgOzHezpeJAGI4qiN0j024fpR/DXACfnOfXNHczOFI1gy7lon7vpkxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvMyH/4R; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436077; x=1794972077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lnoh54IK1xdUE7ReHUApDtVaHR1nAbgq/jys15IExB8=;
  b=gvMyH/4RQOr20fRdjARrK/k0UA7NhL5eC3LRD3wJ4DpAvgF0EbqtHNAE
   c1CcvyQTlWhczikBJh1OGnJkj2JFs8A7WQ9xjo5MP20Q5rnpI7WP1jVWY
   AVxNjUvh8DJ5LUwdyWU9mmH+kjnBhWnvdFx63IaROdKggKKCE1dl73IvL
   fr9FhsBdIhjtVem49EgAkKl2pVukRZlsxrsO3Vpi1PM/b3on5xdpWcudM
   0bN9qJVttLio3K7KmABdfKIrwTrSupBF3FBpNQmQ+i5daQN/bIzYTR+Q+
   W6BsP1NYMMjoI5fkGOiBdGHP47efRR7+JJ4OVxk3jQk7YZ4ziqhrrBpSS
   w==;
X-CSE-ConnectionGUID: lmIvP5liR9KbaCQo3tjakw==
X-CSE-MsgGUID: 0/xJZPcpQqq2rM7htSMSfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053903"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053903"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:17 -0800
X-CSE-ConnectionGUID: 2sxYWs5mSRKM+l9YBIWrPA==
X-CSE-MsgGUID: ocOj5Iz7TNGxnJo70sxTfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537340"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:13 -0800
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
Subject: [PATCH v4 17/23] i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and CET-SHSTK
Date: Tue, 18 Nov 2025 11:42:25 +0800
Message-Id: <20251118034231.704240-18-zhao1.liu@intel.com>
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

From: "Xin Li (Intel)" <xin@zytor.com>

Both FRED and CET-SHSTK need MSR_IA32_PL0_SSP, so add the vmstate for
this MSR.

When CET-SHSTK is not supported, MSR_IA32_PL0_SSP keeps accessible, but
its value doesn't take effect. Therefore, treat this vmstate as a
subsection rather than a fix for the previous FRED vmstate.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - New commit.
---
 target/i386/machine.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 45b7cea80aa7..0a756573b6cd 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1668,6 +1668,31 @@ static const VMStateDescription vmstate_triple_fault = {
     }
 };
 
+static bool pl0_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+#ifdef TARGET_X86_64
+    if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+        return true;
+    }
+#endif
+
+    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
+}
+
+static const VMStateDescription vmstate_pl0_ssp = {
+    .name = "cpu/msr_pl0_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl0_ssp_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1817,6 +1842,7 @@ const VMStateDescription vmstate_x86_cpu = {
 #endif
         &vmstate_arch_lbr,
         &vmstate_triple_fault,
+        &vmstate_pl0_ssp,
         NULL
     }
 };
-- 
2.34.1


