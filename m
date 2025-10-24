Return-Path: <kvm+bounces-60965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCBBC04821
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E8D1C4F5425
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB6F27587E;
	Fri, 24 Oct 2025 06:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4ayFwPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECDF22370D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287696; cv=none; b=ggM8uK/NnOHyQlgTBvv8QRgZwy7rcjC9vFa/Xfq0jGM/O2qrg8adFq7ezU3sbrFI7eQjRUR85j7H1Kj/pYhBFFKW/PgdeDJio0cir1F7uKMFQR/eDcS20/a1rcGxbpHkIw6k+MaEaE6MWg6DIShiAYh35GrZhVBmgxnjE7/NrZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287696; c=relaxed/simple;
	bh=kkUvhWWn3x3yZVQUkN6Y01CSNllf7T4mTVcXM5cusck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q/t3byjrfkl195Jws3avtPYJ9CTJky4nQfYZhYUWyPKCR/6lJU1dq7ccusShlPPBNaL2ko5EqMLf9PRD3KRqlKKoUTlz1TOP+rQgxpHt7GY1cClC/HNLGvc8GqkmQFolN6SKbGdAjsbTooAi0IAUaJSJDX4sa7/YllKcpqyk6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m4ayFwPJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287696; x=1792823696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kkUvhWWn3x3yZVQUkN6Y01CSNllf7T4mTVcXM5cusck=;
  b=m4ayFwPJQyHbm2qlQ1rg6MTex7M9aMstD7tA8ltkjK8wHgBLN2R6n0gO
   UQou0cTedI2JS6gZNAzvD+YGkuD5bz7gytHoKdQWjcZv/RDw9fVdxX9Mv
   G93SuQKK8qKEuTJCcJAeQCJZp8LyF9GKmP6j8AYObHx4INgEuqciA4rvS
   cbSqbl5idDBrzwqU2MJrzgy94q3pYvjtTBcorv3hI9kWkJxfmFmmUpL3D
   NbiHbWjujZb590jYdGbJUZUk3NyaSeWEB8gX7kfDW6IpWa7ISQRsLmSRH
   lQCQitoyswP3qwpocpmiLoo7ObdNrTdWfd4yniRJyg/OG3mxI/u/oc6Fa
   Q==;
X-CSE-ConnectionGUID: 0oAumrxaRLm4a7zfVsOtKQ==
X-CSE-MsgGUID: 7hz3GKY4T7qOtfHaJMGVCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095572"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095572"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:34:55 -0700
X-CSE-ConnectionGUID: 56FlWhHdRCS3cQObciryqw==
X-CSE-MsgGUID: 8gx1vQa2RNueRtKYOCpGPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184275918"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:34:50 -0700
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
Subject: [PATCH v3 04/20] i386/cpu: Reorganize arch lbr structure definitions
Date: Fri, 24 Oct 2025 14:56:16 +0800
Message-Id: <20251024065632.1448606-5-zhao1.liu@intel.com>
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

- Move ARCH_LBR_NR_ENTRIES macro and LBREntry definition before XSAVE
  areas definitions.
- Reorder XSavesArchLBR (area 15) between XSavePKRU (area 9) and
  XSaveXTILECFG (area 17), and reorder the related QEMU_BUILD_BUG_ON
  check to keep the same ordering.

This makes xsave structures to be organized together and makes them
clearer.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 886a941e481c..ac527971d8cd 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1652,6 +1652,14 @@ typedef struct {
 
 #define NB_OPMASK_REGS 8
 
+typedef struct {
+    uint64_t from;
+    uint64_t to;
+    uint64_t info;
+} LBREntry;
+
+#define ARCH_LBR_NR_ENTRIES 32
+
 /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
  * that APIC ID hasn't been set yet
  */
@@ -1729,24 +1737,6 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
-/* Ext. save area 17: AMX XTILECFG state */
-typedef struct XSaveXTILECFG {
-    uint8_t xtilecfg[64];
-} XSaveXTILECFG;
-
-/* Ext. save area 18: AMX XTILEDATA state */
-typedef struct XSaveXTILEDATA {
-    uint8_t xtiledata[8][1024];
-} XSaveXTILEDATA;
-
-typedef struct {
-       uint64_t from;
-       uint64_t to;
-       uint64_t info;
-} LBREntry;
-
-#define ARCH_LBR_NR_ENTRIES            32
-
 /* Ext. save area 15: Arch LBR state */
 typedef struct XSaveArchLBR {
     uint64_t lbr_ctl;
@@ -1757,6 +1747,16 @@ typedef struct XSaveArchLBR {
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
 } XSaveArchLBR;
 
+/* Ext. save area 17: AMX XTILECFG state */
+typedef struct XSaveXTILECFG {
+    uint8_t xtilecfg[64];
+} XSaveXTILECFG;
+
+/* Ext. save area 18: AMX XTILEDATA state */
+typedef struct XSaveXTILEDATA {
+    uint8_t xtiledata[8][1024];
+} XSaveXTILEDATA;
+
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
@@ -1764,9 +1764,9 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
+QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
-QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 
 typedef struct ExtSaveArea {
     uint32_t feature, bits;
-- 
2.34.1


