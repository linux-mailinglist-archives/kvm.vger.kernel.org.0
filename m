Return-Path: <kvm+bounces-60970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCF5C0482D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD403BA4C3
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7222275AE2;
	Fri, 24 Oct 2025 06:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="noVzHKXW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954DF27978C
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287715; cv=none; b=EptSaudGtiY3SGIjqkHY/6Nr3rfKO2Qs6NXEIJDzscZjva7eYtU8upPnv7rYi0UkY6gpGsQum2LyRTxMqC59MVfuV+HZ554oW6SDSipr15IxubdMMsXnEx+63Gy+kwOPZyWo1/pNaKMhpRCN8OFOcNHGrjuOX6aiWYMis3dTXns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287715; c=relaxed/simple;
	bh=J1ZCUKwfTEEbJGJiWsUOSMTCasUamsf1kDC1iuV9N+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=md70u1Ig6UBME2OpwOJ0f35/zXsAeEIh6W2z4g0HaS1gcABwSju1v3Bbnj0gev9zZBsbXDPny0rJCOQeVf13TiqIItwUwelGdN40GSAiDlt7+WbW8pzCGwbhQMOWdF4j0HNoDAKYsjMxxL8ghnMCuEG/CbPJ9olv+q6pkSPx92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=noVzHKXW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287714; x=1792823714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1ZCUKwfTEEbJGJiWsUOSMTCasUamsf1kDC1iuV9N+A=;
  b=noVzHKXW61QqyDG98KPjWet6GuRDKvqFRJ7HiJEJCllLegSsjSDBzxsn
   DDiWcBEt0SQUFiXqN2xfR99V2mEBw57GVHZyarABfcTe8lsTevTY7WMw6
   8vr5b8ZHoXHc/BRcRds+m/WDKzjqASymRBeN14fBU2URFCbpm9N6jT/xf
   fQ8eWlOkueWq28Ya2Ru5JMrcOpRSOm82ejt0fLnxbpL4qf+NWKZEymQLi
   2CnhCJ+zsVW7Fkw4CvZgl67WAHTpaSTCWAc0iPHPtgl6BV+t/Z4idzLBO
   PRV+bPm8w/PhYMdWlP9RhiEBGqmPFdfid8C0tlm2k+FzmPdpxB/CtDUEX
   A==;
X-CSE-ConnectionGUID: jgtQ/i8eQQSk5W0ykuPJKw==
X-CSE-MsgGUID: Nj5thKGWQgSiuVjYTQ2OZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095586"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095586"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:14 -0700
X-CSE-ConnectionGUID: nKAAY43bRoCSRywEKzFVvA==
X-CSE-MsgGUID: nVLkiWPbQ++CaQKbs7y7uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276057"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:10 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 09/20] i386/cpu: Fix supervisor xstate initialization
Date: Fri, 24 Oct 2025 14:56:21 +0800
Message-Id: <20251024065632.1448606-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Arch lbr is a supervisor xstate, but its area is not covered in
x86_cpu_init_xsave().

Fix it by checking supported xss bitmap.

In addition, drop the (uint64_t) type casts for supported_xcr0 since
x86_cpu_get_supported_feature_word() returns uint64_t so that the cast
is not needed. Then ensure line length is within 90 characters.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5cd335bb5574..1917376dbea9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9707,20 +9707,23 @@ static void x86_cpu_post_initfn(Object *obj)
 static void x86_cpu_init_xsave(void)
 {
     static bool first = true;
-    uint64_t supported_xcr0;
+    uint64_t supported_xcr0, supported_xss;
     int i;
 
     if (first) {
         first = false;
 
         supported_xcr0 =
-            ((uint64_t) x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) << 32) |
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) |
             x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_LO);
+        supported_xss =
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_HI) << 32 |
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_LO);
 
         for (i = XSTATE_SSE_BIT + 1; i < XSAVE_STATE_AREA_COUNT; i++) {
             ExtSaveArea *esa = &x86_ext_save_areas[i];
 
-            if (!(supported_xcr0 & (1 << i))) {
+            if (!((supported_xcr0 | supported_xss) & (1 << i))) {
                 esa->size = 0;
             }
         }
-- 
2.34.1


