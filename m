Return-Path: <kvm+bounces-63479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD5EC671F2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C96993624C9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEC4326D5F;
	Tue, 18 Nov 2025 03:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEpigI5k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF750329C6E
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436085; cv=none; b=HEkAOHbpCzDLy4sOReBzokGF8uFJRQByo20jJQXQ+jqcRsY0i+70W2S0hNbe8MZqeAEU2RVfZmYXpTEQbpynBOBI1gcsoPVC0w3ovmESJsNcjcsjXNN9ZKkmrf1SoIU2tWYxKYrOPePCEl6ABY1bp0KfsaA9ZM5TNkDHrjDa5DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436085; c=relaxed/simple;
	bh=kMqBy7CxyEmFl74t7tv9rzwXuI+1Gc0Y9duW9Lw4FqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BRdueMSylvBeoSdu8DDjpGaJTRuC2fUbCsNxshrpZ2i0I3kAq1VM1YvbdCuoN79yu7gd/zpA5rK8HbIX4vaPGfIipw2S3H8flkJOZPrMrA2HHYJHrLCxL8aj/W+NiLuXEKErm7kA2BK/9zuGyp3HlQT0SMfALCC+Jeqs8bHvePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEpigI5k; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436084; x=1794972084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMqBy7CxyEmFl74t7tv9rzwXuI+1Gc0Y9duW9Lw4FqE=;
  b=HEpigI5kPLWEtInhZKaOswJr4DzqtieptDPF5AEBfxAzq/xGp3xLAV2Y
   ow92efU6wwA3ILnNOvJF4Ok9a31cjpiaBsmnvpGAR7BBcSre0cboGwNij
   hRtK8OaXK03HTvL6WPOLLoXndW8QdGVD+ZCpSoSleTB3oXDheifHNcKMq
   R0KAp806wxUTnENh8h5STgiMJipuSjm89Rpj9tH1IXXDP3eFSsVSrWPYH
   tRXhF/RvJRSx1nh6FlvyorCzDkLPyHIlC5UVB72uNalDziPtIHCyBTxo7
   wX7/ddzrHtNMzy+8Ky1WqugZCG3leyuV1vOu5lNsW/SW9r512cWLpsF4O
   A==;
X-CSE-ConnectionGUID: eKSVjJ7QRIS0yKk9ZxA5jw==
X-CSE-MsgGUID: CmTqh5uNSieE32YxOlzP3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053922"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053922"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:24 -0800
X-CSE-ConnectionGUID: lvZ5Y8FHQ4O9xXAhUCWG6g==
X-CSE-MsgGUID: yMxHwHelT1Wult8IrPLcng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537366"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:20 -0800
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
Subject: [PATCH v4 19/23] i386/cpu: Mark cet-u & cet-s xstates as migratable
Date: Tue, 18 Nov 2025 11:42:27 +0800
Message-Id: <20251118034231.704240-20-zhao1.liu@intel.com>
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

Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
saving/loading related CET MSRs. And there're the "vmstate_cet" and
"vmstate_pl0_ssp" to migrate these MSRs.

Thus, it's safe to mark them as migratable.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Add the flags in FEAT_XSAVE_XSS_LO.
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4d29e784061c..848e3ccbb8e3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1484,7 +1484,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .ecx = 1,
             .reg = R_ECX,
         },
-        .migratable_flags = XSTATE_ARCH_LBR_MASK,
+        .migratable_flags = XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |
+            XSTATE_ARCH_LBR_MASK,
     },
     [FEAT_XSAVE_XSS_HI] = {
         .type = CPUID_FEATURE_WORD,
-- 
2.34.1


