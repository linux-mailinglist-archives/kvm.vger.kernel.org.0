Return-Path: <kvm+bounces-63462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C853C671B6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0E7783622FC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4F731577D;
	Tue, 18 Nov 2025 03:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cnv+PZmi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DBB30FC25
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436025; cv=none; b=KJ3/zUr0LDjV93S9QxrgCgBNwPjJ7I54uHX7yjWa9kI2Ho2Bba3om3k1PQN/hGR7Vr7BUgHJ+6W0rYbZaNAlLFFNj2h5ZF812ORZeKWQQzK8p+Y7Dxde0XBlcasCf/CfGUMSKj6zacb7+TSk/4nHzPDdSeNBcnjDhREEj98g7gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436025; c=relaxed/simple;
	bh=enKcO38L6D4368mFk9WuGh+dSr2WFd6BUxl4+hq0Pz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vm+JjLok7K5FlNLzG33wl/E8NueaMbmbW4/V/YunBcT0NIxbcpRyKIPxSXvmis4REEQr0w6G8iOBBzpVOD+e34JjiN5nvI4Qe3SdbIiA4X43pH1PdSBCLa1Nodd50pU7S3jQueUHlD9rTyNtmI4LmVmC+w8c4C7mLH7VS00C9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cnv+PZmi; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436024; x=1794972024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enKcO38L6D4368mFk9WuGh+dSr2WFd6BUxl4+hq0Pz4=;
  b=cnv+PZmizwFQ8B/2KNFfhZ3DIx1f8M/SLA77R7GLMiCH9tG/+YYCqcDn
   8jqAxSKQJM4mq5rFWEqj0pO8EriwuzbJBybSIIsiT25+VAmP8b/EgkfnM
   hyCIEoah3bEtblod51R0Pv0jCP8pOV5D0SjBBA/6v5Jm8NATuZO18Gq3h
   DGSE+kpglukgdqGG29NkyJ2VU6iuJCo0ISGof3MoB8UTVEIFAyvCr2xfV
   BWS3LuO3Ws+eFKJfcBDgUMijAT1oy5TQUeOja/y/LAs6XMz5NenkB4l2x
   9gm1297HvqqHz4QRB6qc24x9OaOloZJIDsfggsAOpOXECvIARiqq/m28g
   Q==;
X-CSE-ConnectionGUID: Rm5oMGAOSAS4hZ58cBMD+A==
X-CSE-MsgGUID: cGmP40W+S4qsHzWTFu5Z/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053736"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053736"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:24 -0800
X-CSE-ConnectionGUID: KloAmZodSrWOopC6xpWqrg==
X-CSE-MsgGUID: B3BIwUb5Rsuu6KBSN/t8IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537139"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:20 -0800
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
Subject: [PATCH v4 02/23] i386/cpu: Clean up arch lbr xsave struct and comment
Date: Tue, 18 Nov 2025 11:42:10 +0800
Message-Id: <20251118034231.704240-3-zhao1.liu@intel.com>
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

Arch LBR state is area 15, not 19. Fix this comment. And considerring
other areas don't mention user or supervisor state, for consistent
style, remove "Supervisor mode" from its comment.

Moreover, rename XSavesArchLBR to XSaveArchLBR since there's no need to
emphasize XSAVES in naming; the XSAVE related structure is mainly
used to represent memory layout.

In addition, arch lbr specifies its offset of xsave component as 0. But
this cannot help on anything. The offset of ExtSaveArea is initialized
by accelerators (e.g., hvf_cpu_xsave_init(), kvm_cpu_xsave_init() and
x86_tcg_cpu_xsave_init()), so explicitly setting the offset doesn't
work and CPUID 0xD encoding has already ensure supervisor states won't
have non-zero offsets. Drop the offset initialization and its comment
from the xsave area of arch lbr.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 +--
 target/i386/cpu.h | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c598f09f3d50..34a4c2410d03 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2058,8 +2058,7 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     },
     [XSTATE_ARCH_LBR_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
-        .offset = 0 /*supervisor mode component, offset = 0 */,
-        .size = sizeof(XSavesArchLBR),
+        .size = sizeof(XSaveArchLBR),
     },
     [XSTATE_XTILE_CFG_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cee1f692a1c3..c95b772719ce 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1747,15 +1747,15 @@ typedef struct {
 
 #define ARCH_LBR_NR_ENTRIES            32
 
-/* Ext. save area 19: Supervisor mode Arch LBR state */
-typedef struct XSavesArchLBR {
+/* Ext. save area 15: Arch LBR state */
+typedef struct XSaveArchLBR {
     uint64_t lbr_ctl;
     uint64_t lbr_depth;
     uint64_t ler_from;
     uint64_t ler_to;
     uint64_t ler_info;
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
-} XSavesArchLBR;
+} XSaveArchLBR;
 
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
@@ -1766,7 +1766,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
-QEMU_BUILD_BUG_ON(sizeof(XSavesArchLBR) != 0x328);
+QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 
 typedef struct ExtSaveArea {
     uint32_t feature, bits;
-- 
2.34.1


