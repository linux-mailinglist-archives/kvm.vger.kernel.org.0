Return-Path: <kvm+bounces-63478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E673C67201
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D8AC44EDA8D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC59329386;
	Tue, 18 Nov 2025 03:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XcsJH6QN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CF322A1F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436082; cv=none; b=VHuqknvkVqRr+mZdMzlnlhVpaILXUeR7/PDfouDQwnWIspzGWzouq+g0x4MqFeaC29fscMV7pMj2CIXuN3EAmcQNL6AhWBG2z5263hYJ9vT8mKHUEy+o3t/jKPBFlG3O9OJm1DySE8vrBKsJusQ5MzjDzv1+stoDJv4eTUZGL08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436082; c=relaxed/simple;
	bh=Jyuv1slaPKAV+w4F0aJEddngoY9lcGquMMXzXgXMpc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d4ENlOoO3Y/1044bA/Oy7ts0IUjP1P74OktF4fWROtVT2WGBvCZJ5PcNLNc8xFDEZWwz8ob0hZ0iDHuM+re2GwE12FEw4UZUgUbKO/u+U+CUmWvUrj98cY63zJS+EH3WHfcRGCxp8GGsiQVedBYf1IuPC9MQN17ZhUp0aAO9vEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XcsJH6QN; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436081; x=1794972081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jyuv1slaPKAV+w4F0aJEddngoY9lcGquMMXzXgXMpc4=;
  b=XcsJH6QNHH8DQGdV1dYOLh8cGmjqTSWf5HpinrDu2rKw3+eEuKBaOqCG
   xYvWjQWY48YU75KwNuVeaEp9CWxXMxXknz7it5jaOmfqetpRRPiCe7/15
   YtQulPwWcEkyaA6QCzMjeEcJL9zg0C7duGaKDYHGZkjH6FaBvuNnx0adn
   qigIwpLe7VbV9XolGdhurhjNwJn25CF00Tyg7sV+moDvxl2nX7vANe7tP
   4pXy0YZGyeT0p9lfY8ySmvjG+4NSDDyadVmnZsu+oXb3CYZ2iRV2sU8lK
   Aa8uepVp8ygF4J5m201rcCjGvzcsiE3evu0yydChbf5qjegE5Yxe/0InP
   Q==;
X-CSE-ConnectionGUID: R33SXnuMSnGsI64JIROMxQ==
X-CSE-MsgGUID: NZPpCpz4RG6wFbJiCOLfzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053910"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053910"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:20 -0800
X-CSE-ConnectionGUID: bpQZXi/8Q6qs4/MvhT6veg==
X-CSE-MsgGUID: UuyFg7lLR/GWc64cBHO2ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537350"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:16 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 18/23] i386/machine: Add vmstate for cet-shstk and cet-ibt
Date: Tue, 18 Nov 2025 11:42:26 +0800
Message-Id: <20251118034231.704240-19-zhao1.liu@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

Add vmstates for cet-shstk and cet-ibt

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Rename vmstate_ss to vmstate_shstk.
 - Split pl0_ssp into a seperate vmstate in another patch.

Changes Since v2:
 - Split a subsection "vmstate_ss" since shstk is user-configurable.
---
 target/i386/machine.c | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0a756573b6cd..265388f1fd36 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1693,6 +1693,57 @@ static const VMStateDescription vmstate_pl0_ssp = {
     }
 };
 
+static bool shstk_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
+}
+
+static const VMStateDescription vmstate_shstk = {
+    .name = "cpu/cet_shstk",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = shstk_needed,
+    .fields = (VMStateField[]) {
+        /* pl0_ssp has been covered by vmstate_pl0_ssp. */
+        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
+#ifdef TARGET_X86_64
+        VMSTATE_UINT64(env.int_ssp_table, X86CPU),
+#endif
+        VMSTATE_UINT64(env.guest_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool cet_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT));
+}
+
+static const VMStateDescription vmstate_cet = {
+    .name = "cpu/cet",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cet_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.u_cet, X86CPU),
+        VMSTATE_UINT64(env.s_cet, X86CPU),
+        VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_shstk,
+        NULL,
+    },
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1843,6 +1894,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_arch_lbr,
         &vmstate_triple_fault,
         &vmstate_pl0_ssp,
+        &vmstate_cet,
         NULL
     }
 };
-- 
2.34.1


