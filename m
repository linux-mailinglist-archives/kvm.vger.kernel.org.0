Return-Path: <kvm+bounces-32034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C079D1B52
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 23:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34101F2202E
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 22:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3101E883E;
	Mon, 18 Nov 2024 22:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ChpTXHlU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57191EE004
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970483; cv=none; b=i7KbTL17h7aimjy51m6HG2VgAcyLwyKl2iPiFx1Bjvn3YhGXiHlxAp2prwiJeAbX5eKSzCAFXO4IHwE7/Xgz0xgqxeaU8IO/DGi6hZaK3DTja5TnRGFoRescuG8Mo48BffjeNdZo1kGsgFYfgeGIfwp17XJ2OqShVZHbhFaL2vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970483; c=relaxed/simple;
	bh=tWtFWXcZQwcoM/P2ECbObjIBGkE/YYzisg8saOY5SuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MAb3nc+cTeN7MINixymO69K4j+VXKIxXzoH7kSrYDHARTdB5eEmp9wGGBRA12wCmOceL0se4jhdh7KOYlOjbnZmPBOkg9tLajfDgM73+17C5bOvXfygFKkwAap/hOXVn6pGbPW8gintS6yBGj4Hj6UBrOHm5jR7ismWw3F4FRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ChpTXHlU; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731970482; x=1763506482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tWtFWXcZQwcoM/P2ECbObjIBGkE/YYzisg8saOY5SuM=;
  b=ChpTXHlUpGRG6GDAJr4ntlbJtos6h9ibJ+CtqPdjAlCjy/jwfwoilhyG
   tPX5stHrD7gHUyc4fcqXoBfmbXRA1IiDslrJMQUBw0H3yhVaIgmn3mKiM
   tPMBZUrvt82LFeUNHJL+YurkO+n5jgaHDG0xqevRLI5KuHiFYdHVA4iQA
   7Dlg/yFyNBg9c8WCf2Bff4GrUhfjhU5EdfXivEtahVydgf7AQpyxz/Yo6
   b+aCF441yI/JKYCVhQVGHMmB1tQ0RV4bzTQ2Iz8k0wFQWQZ/yqp7HzOZD
   imGL0M217TYOGvMaORygi/D1ZhU5azbr4So77UR5huuI0IQ5s3nFZusGY
   A==;
X-CSE-ConnectionGUID: PtVozNjRRlWwW3w9H5w4sA==
X-CSE-MsgGUID: 8IWt5e/cQImppxpu+3mtrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="42579576"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="42579576"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:41 -0800
X-CSE-ConnectionGUID: Zr/oP45iRSO2eLmx80F/jQ==
X-CSE-MsgGUID: SWIL9fmfSoO43eV+kCTrlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="89145931"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:41 -0800
From: Zide Chen <zide.chen@intel.com>
To: kvm@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-test PATCH 3/3] x86/pmu: Execute PEBS test only if PEBSRecordFormat >= 4
Date: Mon, 18 Nov 2024 14:52:07 -0800
Message-Id: <20241118225207.16596-3-zide.chen@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241118225207.16596-1-zide.chen@intel.com>
References: <20241118225207.16596-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before adaptive PEBS v4, the PEBS record format is not determined by
MSR_PEBS_DATA_CFG, but by IA32_PERF_CAPABILITIES.PEBS_FMT[11:8] (< 4),
which is not covered by this unit test.

We don't want additional implementation to support such legacy
platforms, instead, we can exclude them from the test to avoid test
failures.

Technically, it seems checking IA32_PERF_CAPABILITIES.PEBS_BASELINE[14]
is more reasonable.  But this bit is not exposed to the guest in the
current KVM emulated vPMU implementation, and if we use it as a filter,
it will filter out all platforms.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu_pebs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 6b4a5ed3b91e..6396d51c6b49 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -404,8 +404,8 @@ int main(int ac, char **av)
 	} else if (!pmu_has_pebs()) {
 		report_skip("PEBS required PMU version 2, reported version is %d", pmu.version);
 		return report_summary();
-	} else if (!pmu_pebs_format()) {
-		report_skip("PEBS not enumerated in PERF_CAPABILITIES");
+	} else if (pmu_pebs_format() < 4) {
+		report_skip("This test supports PEBS_Record_Format >= 4 only");
 		return report_summary();
 	} else if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
 		report_skip("PEBS unavailable according to MISC_ENABLE");
-- 
2.34.1


