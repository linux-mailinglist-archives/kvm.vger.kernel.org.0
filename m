Return-Path: <kvm+bounces-12399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03976885AC8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 345D31C21413
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA6284FC5;
	Thu, 21 Mar 2024 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+zcS0gm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A3F84A51
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031319; cv=none; b=X3sd4sa01jKelEMYk2w19QXUG86WZmEYPbyAbEKwvm2pTo0P8QaYmRiIH/UJ/Gp0R17sqWXxA/ueoF08e39R0/zxBspfQkimkNY8ikZVm7YrSw6irN3NJA/pk4qZp+RhrU/nMa8ll0Z2cDEZ5/w9dbVhC8j95atUW73T9F+/zcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031319; c=relaxed/simple;
	bh=2cHMC5a5BJRlD/PsC4aspwTroLUP40TmuAMHURKso6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LhsRdLS3GOyITXu5jB4uUgthMLKr/p1Mggm2wG90D9ogcj2YVuYSWHvE11K2daKfe4rV+6JjPlF7AnAXnJwAOEOerPYh2FwllQ4Lvz3VcaU/qgumETeEJM+CRibVBUpEbjNDEILi/OulX1/pSU6NFbuLqsMusvFo6pdAVrWiSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+zcS0gm; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031319; x=1742567319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2cHMC5a5BJRlD/PsC4aspwTroLUP40TmuAMHURKso6g=;
  b=J+zcS0gmi/n/Zi3rm5l/quO4H5zUzK7NjgoKAYjE1UL5rR8DWwC5hcJi
   ARcK/TGkQ//RMLY2TFdxnUnO+i2vYikK1Eucnytj2eoxRJF4aYCyq3Bej
   tgQN4ZD4LGY2Q7QnUNTX4RDXLQhYuzKRJMQaTdlnET50z9e1G1eO+lXgn
   J6bJNh/Rb3ON/CrLjkCcQJ+A/bRajFgzGoMaz6Wq2FKuJr+FfNsIFPnLa
   ZpWWn9NNy0YL30U+LuY9hSonuCFcRe64TdU4MWpXCCXLA99BtY/me518p
   Ur9ovYqQkvvCqaM3RjWd64snQxY92yrynuwyBlYoH4NvqhC7jipCWyfWh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806627"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806627"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:28:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14528331"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:28:33 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 17/21] tests: Add test case of APIC ID for module level parsing
Date: Thu, 21 Mar 2024 22:40:44 +0800
Message-Id: <20240321144048.3699388-18-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

After i386 supports module level, it's time to add the test for module
level's parsing.

Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 tests/unit/test-x86-topo.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tests/unit/test-x86-topo.c b/tests/unit/test-x86-topo.c
index f21b8a5d95c2..55b731ccae55 100644
--- a/tests/unit/test-x86-topo.c
+++ b/tests/unit/test-x86-topo.c
@@ -37,6 +37,7 @@ static void test_topo_bits(void)
     topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 0);
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 0);
+    g_assert_cmpuint(apicid_module_width(&topo_info), ==, 0);
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
 
     topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
@@ -74,13 +75,22 @@ static void test_topo_bits(void)
     topo_info = (X86CPUTopoInfo) {1, 1, 33, 2};
     g_assert_cmpuint(apicid_core_width(&topo_info), ==, 6);
 
-    topo_info = (X86CPUTopoInfo) {1, 1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {1, 6, 30, 2};
+    g_assert_cmpuint(apicid_module_width(&topo_info), ==, 3);
+    topo_info = (X86CPUTopoInfo) {1, 7, 30, 2};
+    g_assert_cmpuint(apicid_module_width(&topo_info), ==, 3);
+    topo_info = (X86CPUTopoInfo) {1, 8, 30, 2};
+    g_assert_cmpuint(apicid_module_width(&topo_info), ==, 3);
+    topo_info = (X86CPUTopoInfo) {1, 9, 30, 2};
+    g_assert_cmpuint(apicid_module_width(&topo_info), ==, 4);
+
+    topo_info = (X86CPUTopoInfo) {1, 6, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
-    topo_info = (X86CPUTopoInfo) {2, 1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {2, 6, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 1);
-    topo_info = (X86CPUTopoInfo) {3, 1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {3, 6, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
-    topo_info = (X86CPUTopoInfo) {4, 1, 30, 2};
+    topo_info = (X86CPUTopoInfo) {4, 6, 30, 2};
     g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
 
     /* build a weird topology and see if IDs are calculated correctly
@@ -91,6 +101,7 @@ static void test_topo_bits(void)
     topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
     g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
     g_assert_cmpuint(apicid_core_offset(&topo_info), ==, 2);
+    g_assert_cmpuint(apicid_module_offset(&topo_info), ==, 5);
     g_assert_cmpuint(apicid_die_offset(&topo_info), ==, 5);
     g_assert_cmpuint(apicid_pkg_offset(&topo_info), ==, 5);
 
-- 
2.34.1


