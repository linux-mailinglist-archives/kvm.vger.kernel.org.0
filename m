Return-Path: <kvm+bounces-21500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA28192F867
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09FF11C20BEB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807341474CC;
	Fri, 12 Jul 2024 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MlScBCZV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055CA142629
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777955; cv=fail; b=lMfro3qTy0MpJDvhwuBWH8rhjmyDoUfTCUBiJ16JTdg77LBTBtUFlZmCcreu7+Bsi6sFcF/O6oMup0GFCRaeUpjUZHMieQ5itmbIV9C30glmpYyed8mC2y/gsqjl3H4llXP9pCkvsBiKsnUS53cbLvILij9ivPlX41UbjodJfGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777955; c=relaxed/simple;
	bh=/hyrwdrPiqugOc/Bic3fbzMF0u4lq6udhO38u4XLEtw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A906pUnlZDmbAXkS/XbZhRFnoe0dQ4pZAkTbd6w1muSO5HQ9JUiQ5EpcFtnQczC/fT9DKvwyslW2SkGghEs8JQK1b8aupAmHr5OaoW2Z8ZA1oDGbuFng85TbmXIdU/dVxMZ9RXbQ8U+2tYv4DYGyPQFm4bOTSe4kedplF0r7lG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MlScBCZV; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e1ujTzTmz8kKVJEvCp87FqDsndi14le0jgePpDT0NehK4gqsUBEGw3ILhevOUA1Eue8viGct6oKAipWb7iHd1PC+uL2GqHPj05EQjIZefwU+Cgd1Ls5aK5oeCmf0GwgcotzWFw6r/Zh9dcgl3wU8U4bTalhecV5xm1UtL83t7oPgLjUpvc9+5iO/kDFPdz7845KlGLLiyvZlK+y/lYJR+MQycRATODW+YnOwxGNn79FfKQwjcRl1J4OhQeU8Z1s66MLXNxYl3EYSh2Fl8uPlTWR/eHPLh3Cri8mqs/EuNQwFbmkRhqrSMbTRgqvawY/9/zjojjuRrF4f0wKrhabbxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeneaU6QgdAdcz2+hJHty8meWkeWbcB7d91HIK26Vq0=;
 b=GYDR9DkTP01AXzglTQWplxVSotjmXYeeQvNg5k1WwOPR530WKK/+vuKP200VWhGIq3Qe296I3O7WqUK22d5QiLmGc2PSgLoACoFGAmsrc9LIwVGZ2lYqVo2HO4gn3hWKYvZ50nMsiTwL2QvZVChBGSWWxxXEL6pEK2E/Ds9YIKCXfCl4Di7mLN/ydIGkGi6ZWxyIwbJnqdiGkC5FmsZ+VhizPQc2AZKJ2+KN9kx4dyWFOEM6VPRxmgE9OLh+SSAVhIb2OW1dqNT1LYXk0nakO2SUCu13NoGCQ6k6KeTNqFRLLpN+wTcYvb5AIFKjnbkSynhuUDOXwegRAluFRFUH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeneaU6QgdAdcz2+hJHty8meWkeWbcB7d91HIK26Vq0=;
 b=MlScBCZVFvtArETV/0tXaBZ8zo8EIroytTpPnzLDdZRbpVCBUp3Rr45Io0DGq0iQ1HBZDezIspc1o+gHy/pm2ss3Eqmk6fKhZIxCX/Efnj6uVmhSgqNj/ceKAPyvH/PFw/suK/mMvqKP9yae5hJS4Wx9YnrukV4Q477cJRvKfh8=
Received: from SA9PR03CA0026.namprd03.prod.outlook.com (2603:10b6:806:20::31)
 by SA1PR12MB6995.namprd12.prod.outlook.com (2603:10b6:806:24e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.22; Fri, 12 Jul
 2024 09:52:29 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:806:20:cafe::e) by SA9PR03CA0026.outlook.office365.com
 (2603:10b6:806:20::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 09:52:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:52:28 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:52:23 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<mtosatti@redhat.com>
CC: <ravi.bangoria@amd.com>, <michael.roth@amd.com>,
	<nikunj.dadhania@amd.com>, <babu.moger@amd.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <santosh.shukla@amd.com>, <ananth.narayan@amd.com>,
	<sandipan.das@amd.com>, <manali.shukla@amd.com>, <jmattson@google.com>
Subject: [PATCH] target/i386: Add Bus Lock Detect support
Date: Fri, 12 Jul 2024 09:52:08 +0000
Message-ID: <20240712095208.1553-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|SA1PR12MB6995:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dec7d2e-dbf4-4d16-6fd9-08dca258577e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VADzJ2Vc8IFWCs+tDiuqJ3iIlpRUoEdzdu95EwPxjElQ33jd/6TEihQteS/R?=
 =?us-ascii?Q?EZAKyb7Lj6EkkNINCodEgiZrK83mEbgwGbdcOJ1nGpuuBOEitWceIZwnc9Vn?=
 =?us-ascii?Q?PMoCp4l099a5qdBsKiX4gqiguVGicexw1ePBXXWYrf2Tcq079Zfe4AwpdNPP?=
 =?us-ascii?Q?Q8iACb4GPTNQ0GxC/O+1VEXgAzNxD0wm0nofXYlTBAPTD05FTLQFrnJtjylm?=
 =?us-ascii?Q?6wV0ZLV/0CtCfMlWBCs5IDfXQiY9pXnF5luOqDa8o77xLNraUH+L8C10Wdlg?=
 =?us-ascii?Q?QB8ZKWPGXskH7MYD51MRh9fZiO13rk5BrdfsV/xsqMXgXIoYuksVYfa0VdUQ?=
 =?us-ascii?Q?zj+8Qwj9bOAi2PrDYXHChZaO7TMZ6CKBDFRaIx3u3Bvjla3g0ziSXAGbctSe?=
 =?us-ascii?Q?3KPTK398lYkaRCwQ/Vd3vcF0lrScEL5/QfJKBnmRawC4CaxphX9oUk5C72FX?=
 =?us-ascii?Q?2/e7DrWYOiX54uQ+ff+nYSXXLSvfUPnH4Iky69TDEupO8Og1c1sKvKhtBCX1?=
 =?us-ascii?Q?Ymm55eC8qicIw8Gm04Duid8uDGlRgXkbal57dPUISBYqUZJ6aJD0CGA6qViR?=
 =?us-ascii?Q?nUHTc9anUUrSKZ1lGPHGT/6fKFFbm87iCjMx2Dbgh2rXHgAKeMsBoAySQBbi?=
 =?us-ascii?Q?wF1Cu9W2lwJ7o6HmAGfaO75XP9vJdEuWjZrV7Jdng8ACYd7evPewlH6zO4WN?=
 =?us-ascii?Q?UQlS7c2vhHuTl+a10X6J/umaV3NK0w2s2JKVYYDvE/BIM4hJqRKaAK90Hn8t?=
 =?us-ascii?Q?xn/IUZgQKHvhSSKphZeSqPrfkwrI/crLXiqxvesoQFf9RQy8awii32sVcp5o?=
 =?us-ascii?Q?+8nXe8QyOcvFNn3OV4oMQbJV7oGxGoyhOVc5I2pRCKwQp6t8ZH66hE1HpA8f?=
 =?us-ascii?Q?9tJKGVJiof+P/9pcc2c63tSlooPeznkh3Z8q0dsqt0C6iWKrJ/1hNRdwjFh7?=
 =?us-ascii?Q?elcXF6HU7NV5DtGqa9OoaQ53vrCJ3Xomr2isAYnG9FRL22wHWTKddyyxqUri?=
 =?us-ascii?Q?T5GyiQ+7O4qYkqI11iECSaUlvxLu8/CuBnirKoVdg8cNe8+dbXTfmyweEMvD?=
 =?us-ascii?Q?w8g7J94u/nYjeRNwDKz1ayZ8QApKtAJqvxHkuqA1udDaQcM6NlDFIEOMbjty?=
 =?us-ascii?Q?gaAupKbU8JfA9qLh6+h5DZB3i/s38zoP3QJKIyifVDzMTwJi9kD1GgWnyHd9?=
 =?us-ascii?Q?E7T7RV0/6ABSBWSiNSwsR42s99oPnQFzGizgKwUDycIEG87laPGjgy7qkxDc?=
 =?us-ascii?Q?GAALkKBZFeq8n8bgTVGHvCSypPe4lFpnv6ZEceVKYFqiclA7nIcsA6R63Akp?=
 =?us-ascii?Q?FtxJhcV465VMlYuHUTpAKfkpgkyYXUSagkGKPxPdnW5SqvfyN8VWBynrP59v?=
 =?us-ascii?Q?XYjSVm059grvpIuUkY26dwiHgjcRLi4Wy/afgRSJI1/jN5DHvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:52:28.7556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dec7d2e-dbf4-4d16-6fd9-08dca258577e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6995

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Bus Lock Detect is enumerated with cpuid Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

Qemu supports remote debugging through host gdb (the "gdbstub" facility)
where some of the remote debugging features like instruction and data
breakpoints relies on the same hardware infrastructure (#DB, DR6 etc.)
that Bus Lock Detect also uses. Instead of handling internally, KVM
forwards #DB to Qemu when remote debugging is ON and #DB is being
intercepted. It's Qemu's responsibility to re-inject the exception to
guest when some of the exception source bits (in DR6) are not being
handled by Qemu remote debug handler. Bus Lock Detect is one such case.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
Kernel and KVM patches:
  https://lore.kernel.org/r/20240712093943.1288-1-ravi.bangoria@amd.com

 target/i386/cpu.h     | 1 +
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c64ef0c1a2..89bcff2fa3 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -271,6 +271,7 @@ typedef enum X86Seg {
                 | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
                 | CR4_LAM_SUP_MASK))
 
+#define DR6_BLD         (1 << 11)
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
 #define DR6_BT          (1 << 15)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c864e4611..d128d4e5ca 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5141,14 +5141,14 @@ static int kvm_handle_debug(X86CPU *cpu,
     } else if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
         ret = EXCP_DEBUG;
     }
-    if (ret == 0) {
+    if (ret == 0 || !(arch_info->dr6 & DR6_BLD)) {
         cpu_synchronize_state(cs);
         assert(env->exception_nr == -1);
 
         /* pass to guest */
         kvm_queue_exception(env, arch_info->exception,
                             arch_info->exception == EXCP01_DB,
-                            arch_info->dr6);
+                            ret == 0 ? arch_info->dr6 ^ DR6_BLD : DR6_BLD);
         env->has_error_code = 0;
     }
 
-- 
2.34.1


