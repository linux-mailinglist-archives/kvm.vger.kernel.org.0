Return-Path: <kvm+bounces-63465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B019BC671BF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 311EE29D60
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C826329371;
	Tue, 18 Nov 2025 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PE74lcJ6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C56328B71
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436036; cv=none; b=rpKL1+bhUlVtB4g6XH/9+hHsQOf0O5bdVdp8EGjcNsFW+BMxEpeGNA8Fm8cJa7wgRZJTnXcYD+4sWMYl2VQa9/hXQytTj09KfWTLxJFRRLL5Zesx2Kp8VF9lLWqwdmZzRlbMkLNHM+arAJG6tbphiQRhMMb12E2dJmYTx4zgvak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436036; c=relaxed/simple;
	bh=c/VS1/2chdkAwU46yWRjXngVNYQ5YwGggg1BKVSm57Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FUJMdbPLFOLrRxj8fskOEqIIDN/Gm+dg5YtJX8JXFTYl5A1piajq/02I8+uKby/VE+Cus63a8dndforcn9NJJr5PjjRJQ2aRI7xCT7Dy7siDBalHLMfAzdC6CZGTb9EOiOfM42aFyCzimfb9w2qauA0Af+vFOCPLl+j/N6UJgn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PE74lcJ6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436035; x=1794972035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/VS1/2chdkAwU46yWRjXngVNYQ5YwGggg1BKVSm57Q=;
  b=PE74lcJ61nzG6wCsObaOQj2uALLMwp7uXZr087i1vHzARdblHzxCVj0S
   V6wihAGsUdpbE7DCmHairXtMI9qaohXRBkDuFYq50khMUO4wkqW007lax
   EArPz9XlL9K1LpvV9uDGqxW8AacrMCNDJ9gfEeFD+ULRNPcBpnALD/Bwi
   ooBknLQkTn7d+egyZmqMnVzO2BEyG2J9TEtS/FHKIzk/8Tj4Fk6v5u17C
   2+JpibM3JZN3D4MfhsOgf6C5HnIXD+ArD4uCGBaUgTt6nmNBwTEPO1Vk+
   4xLCoASqhi7dOEwBvwuPkOwbdixKU7MXWjY+7hYlCnvDRdr8YkvWF9LVF
   A==;
X-CSE-ConnectionGUID: Yy9Nbhv7QF2hSIFbmBcYew==
X-CSE-MsgGUID: JgzDc8kXS6Gy9qwNRX05hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053765"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053765"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:34 -0800
X-CSE-ConnectionGUID: tY2UtiO5SReuvQs52PsQQw==
X-CSE-MsgGUID: 6S7lQ1wKSUGghZcA7lHJdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537165"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:31 -0800
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
Subject: [PATCH v4 05/23] i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
Date: Tue, 18 Nov 2025 11:42:13 +0800
Message-Id: <20251118034231.704240-6-zhao1.liu@intel.com>
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

With feature array in ExtSaveArea, add avx10 as the second dependency
for Opmask/ZMM_Hi256/Hi16_ZMM xsave components, and drop the special
check in cpuid_has_xsave_feature().

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e495e6d9b21c..70a282668f72 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2054,18 +2054,21 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
         .size = sizeof(XSaveOpmask),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_ZMM_Hi256_BIT] = {
         .size = sizeof(XSaveZMM_Hi256),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_Hi16_ZMM_BIT] = {
         .size = sizeof(XSaveHi16_ZMM),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_PKRU_BIT] = {
@@ -8648,12 +8651,6 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
         }
     }
 
-    if (esa->features[0].index == FEAT_7_0_EBX &&
-        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
-        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
-        return true;
-    }
-
     return false;
 }
 
-- 
2.34.1


