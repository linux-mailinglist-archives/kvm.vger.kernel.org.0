Return-Path: <kvm+bounces-18391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED05C8D4A25
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B43FB227E7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEAC1761AE;
	Thu, 30 May 2024 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="16fIXoh9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E116F82B
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067810; cv=fail; b=eI1ylJqf5TJ/YCOBedCrKCQkuB9sE3u7JJtNiLX/fEHiAMXVn5oz0WnN2Wzv4icT3ux4+TlQhfjPKjgTsu9qKovjHvqQTYwCAw+X3I2OOmRaiKg1WLo7kOxygPadY3luaN9y31sQuBTMIEp4+thrWLpaxYdomZNDIxasflZ2gs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067810; c=relaxed/simple;
	bh=bdYh5IEf/NehVUrPR95TLSgGo2HJLLTWm1/hMJsueBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qd5NZInaqniv97kImaoCJn0F2RVXiuXlwle1Qq0U7azj6aR2GqC/Q/aQ/yoo1to1vjBMTudJ/1TGRzFsPRBpOCA6hVuya+/cEK+0nAimUK6n6EfzXlrs+jQeZ/CVH1P1B6cjArbPoOvrBtx1aVfu1dleK3hJVvS4NKrYONfUE+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=16fIXoh9; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFJDS57Q0Ghx3sMvGIhxqXIHisKY/UzqUIhyjHt1TFG7EyBhl1RmcOZC8sG9VlhlTK4/98nUPQB79feRfMJK7VFMyjkOFjh0NE1Mh+lvcPlJbcBpQOJRK7Z2jwfphBYtWrKBMumBzK3EZM/hcToSVf7U6AK3z0qv8hEYByP2z1qUC2+xwwbNVyhwnBVTFV4h2L47TSSe8gtPb4hSqFk2soe75CC/5UpR1BOuAqgX2KBaEj95CqhZIfDhY83OqhKneuQrlTNvqzXufpwnQ+JaCddwJ94/q2Wd6JE7H6D3n1mVwXTJtXDgR8hluCXCwHuPkkF49hRA+6GBwt6iL2pxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JkClulmXbQtFW6h696tZ77G1l+wWY734mqZS78QWKY=;
 b=Du6QjqngS/G0X6fPExO6JaKqM7UtG75H+l4ZsnEf9eMEvMpKVXrrQq3E5GyXfVojqYt2ZpEbdq3a/9BGOwNl9vxP2W2FmBqX/zRGJxpFRbZsdHg7qvUv8nIymZCuyDCyASOItXmZboY9q0ZuaW61/rkiR7W4RPD6m8Sk2AWGsBufagNcTC5hJZHiLYA3o/yzlcC8ZstwR3uoQunY/tAxTxMDedUsjgn/FZyq5kB1eW8X7+GFbKED+I6DGarDHttvkMwotzQSeGjXFHCIZ7FNSuKKWZ1tQIrvR8UxDiQKfW5zU3vS3oxrSh8dhoJXWK3xSrVELSslFQcdxn5/EbWSaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JkClulmXbQtFW6h696tZ77G1l+wWY734mqZS78QWKY=;
 b=16fIXoh9yPQ9DlTj7ihXSk1kX4rG23SVRDM8euEO28aHXt29CG2/ObdRqrysLQSC8FI+V734wdGdlC6UtP/3D1ijELNJTiBdHRam2FjzRzSO+p9Zr/QKL7D4ThViprzWZHz2TG0bfKU8QnrIyjUb/OipjWkndRRJXKTPxKNWwU4=
Received: from BL0PR02CA0137.namprd02.prod.outlook.com (2603:10b6:208:35::42)
 by CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Thu, 30 May
 2024 11:16:46 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::c4) by BL0PR02CA0137.outlook.office365.com
 (2603:10b6:208:35::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Thu, 30 May 2024 11:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:45 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:45 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:45 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 02/31] linux-headers: Update to current kvm/next
Date: Thu, 30 May 2024 06:16:14 -0500
Message-ID: <20240530111643.1091816-3-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|CY8PR12MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 7030d750-8580-42c7-410c-08dc8099fdfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J3D99eiDaseJ+RtXk0vB8FLUVh9mnr7aOtMfAPDWpeEWQgFU7sKsa7uf3NiF?=
 =?us-ascii?Q?UqwL20+D5f8q2Kd+QnQkY/+DqKzaUYnxpoXUPjve8KgPNsDc/asny6zYjIJt?=
 =?us-ascii?Q?4am4W62B/67eAoD2HPFgNo5e1bk6tQTCdgwkiwEGWuRI5aX3bHzibprEKvmB?=
 =?us-ascii?Q?IXw4DpOQxHgW5IhLSCtLCp3a3HqEk9Gx49z4RA+SM7Wc9JTJHOi9jZ6CCb2d?=
 =?us-ascii?Q?fykG0mI35bC1bGz9U2Bpi2+5kKfOshVrcvEDQWhgLmCpVSCbFxjPQhJnRdNU?=
 =?us-ascii?Q?sgFaLesHtoVCloyFFJVcNeAKvtUVRBtymaTi/FNbC8aJUc3EA5vnoA8SSftx?=
 =?us-ascii?Q?tF/QTSlsE4HSINWwkXluKhvzPNBMiB9DC2owRjRw0eB3jtuQ/HRz24KxBqv8?=
 =?us-ascii?Q?ChUBaUSSVlUwI8nyF+LeLRTc7YF4hEgzWKbBPoQfX8n+t1q6GljyqN+kiJDy?=
 =?us-ascii?Q?5GJDY2qkotQacVN9kwGcDAQ4eKm7ooMToHepz6PfofxNJLPf03hRGKG5q1d0?=
 =?us-ascii?Q?FQ0tom2R05cMkR9mxKuZnjjgvqV+jUwOTf/7h6UIv7497+Ch3wI6yWQoIRY9?=
 =?us-ascii?Q?7fi6hSKh1Ll+8AkJVDXEER2NsVm1ELe672iMQJrpoXNzA1e7wgzhKTydVMWn?=
 =?us-ascii?Q?vhFCgADsYu3Ch9o4NW/CpdItTNf9yaE01A27BkVeZ28WRMUZRHJOXodHz13a?=
 =?us-ascii?Q?ZXGhxaHy6JaCgotQqZCrvdCA7buRF163Dk9P4PVYWUCDlKZZ7aE3Ax1C9fQg?=
 =?us-ascii?Q?NvfqbsDaWsASdNmhwth5czgHsrBhqOp/jJJOhyCB37rvGV+nfvgTiq03aUxl?=
 =?us-ascii?Q?lgXt4cGRY3sw1fm2lNjvShPXrCUD4OxXh6NM79acUjYlQmvzfH44WWtvmOSp?=
 =?us-ascii?Q?pgXGwzgh+huAq3lQa4SgQpyD6jqW8zlSRD+fB9ZWPYJbT0V/tKNY1H5PmtI+?=
 =?us-ascii?Q?TGNNdnOUhf2Vd/VdAbw4KfcF3n6Cut9wJ/6e+7DRqy81cSmgoDnSWTMFQwJG?=
 =?us-ascii?Q?d91vJnWl9xNN5wWdLzIOl1E7pFNUNKy5ACOKFliRFB0DWdTKDXBp7OwDdwBb?=
 =?us-ascii?Q?EEslO5t1Uor5+AEm5F4jzUU46ybwKAR+25unAqeNHXhOFiOeeLM4ub7lsioX?=
 =?us-ascii?Q?w4V2Wb18WKEtsWYtdjPmpIXUPx69pWAKRrOE2KH8i2cblvQICn6NyLuM4gIZ?=
 =?us-ascii?Q?yQAuosn2XnakL0ddC0hAiYlVhRbOMaAQLMgrCL47zdijBaRRisK1OgtE9rbq?=
 =?us-ascii?Q?pCXotKAFN36vcDnj2i6HnJ5JuEhT1GCjlHGXDnN6iAQKR2ez7UndhPsTCZGv?=
 =?us-ascii?Q?A8Advsbr8d9LYeia7HjeqWxM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:45.8949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7030d750-8580-42c7-410c-08dc8099fdfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8300

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 linux-headers/asm-loongarch/bitsperlong.h | 23 ++++++++++
 linux-headers/asm-loongarch/kvm.h         |  4 ++
 linux-headers/asm-loongarch/mman.h        |  9 ++++
 linux-headers/asm-riscv/kvm.h             |  1 +
 linux-headers/asm-riscv/mman.h            | 36 +++++++++++++++-
 linux-headers/asm-s390/mman.h             | 36 +++++++++++++++-
 linux-headers/asm-x86/kvm.h               | 52 ++++++++++++++++++++++-
 linux-headers/linux/vhost.h               | 15 ++++---
 8 files changed, 166 insertions(+), 10 deletions(-)

diff --git a/linux-headers/asm-loongarch/bitsperlong.h b/linux-headers/asm-loongarch/bitsperlong.h
index 6dc0bb0c13..485d60bee2 100644
--- a/linux-headers/asm-loongarch/bitsperlong.h
+++ b/linux-headers/asm-loongarch/bitsperlong.h
@@ -1 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_BITSPERLONG_H
+#define __ASM_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
 #include <asm-generic/bitsperlong.h>
+
+#endif	/* __ASM_BITSPERLONG_H */
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 109785922c..f9abef3823 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -17,6 +17,8 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
@@ -72,6 +74,8 @@ struct kvm_fpu {
 
 #define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
 #define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+/* Debugging: Special instruction for software breakpoint */
+#define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
diff --git a/linux-headers/asm-loongarch/mman.h b/linux-headers/asm-loongarch/mman.h
index 8eebf89f5a..d0dbfe9587 100644
--- a/linux-headers/asm-loongarch/mman.h
+++ b/linux-headers/asm-loongarch/mman.h
@@ -1 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __ASM_MMAN_H
+#define __ASM_MMAN_H
+
 #include <asm-generic/mman.h>
+
+#define PROT_BTI	0x10		/* BTI guarded page */
+#define PROT_MTE	0x20		/* Normal Tagged mapping */
+
+#endif /* ! _UAPI__ASM_MMAN_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index b1c503c295..e878e7cc39 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_SSCOFPMF,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/linux-headers/asm-riscv/mman.h b/linux-headers/asm-riscv/mman.h
index 8eebf89f5a..8db7c2a3be 100644
--- a/linux-headers/asm-riscv/mman.h
+++ b/linux-headers/asm-riscv/mman.h
@@ -1 +1,35 @@
-#include <asm-generic/mman.h>
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_POWERPC_MMAN_H
+#define _ASM_POWERPC_MMAN_H
+
+#include <asm-generic/mman-common.h>
+
+
+#define PROT_SAO	0x10		/* Strong Access Ordering */
+
+#define MAP_RENAME      MAP_ANONYMOUS   /* In SunOS terminology */
+#define MAP_NORESERVE   0x40            /* don't reserve swap pages */
+#define MAP_LOCKED	0x80
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+
+
+#define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
+#define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
+
+/* Override any generic PKEY permission defines */
+#define PKEY_DISABLE_EXECUTE   0x4
+#undef PKEY_ACCESS_MASK
+#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
+				PKEY_DISABLE_WRITE  |\
+				PKEY_DISABLE_EXECUTE)
+#endif /* _ASM_POWERPC_MMAN_H */
diff --git a/linux-headers/asm-s390/mman.h b/linux-headers/asm-s390/mman.h
index 8eebf89f5a..8db7c2a3be 100644
--- a/linux-headers/asm-s390/mman.h
+++ b/linux-headers/asm-s390/mman.h
@@ -1 +1,35 @@
-#include <asm-generic/mman.h>
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_POWERPC_MMAN_H
+#define _ASM_POWERPC_MMAN_H
+
+#include <asm-generic/mman-common.h>
+
+
+#define PROT_SAO	0x10		/* Strong Access Ordering */
+
+#define MAP_RENAME      MAP_ANONYMOUS   /* In SunOS terminology */
+#define MAP_NORESERVE   0x40            /* don't reserve swap pages */
+#define MAP_LOCKED	0x80
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+
+
+#define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
+#define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
+
+/* Override any generic PKEY permission defines */
+#define PKEY_DISABLE_EXECUTE   0x4
+#undef PKEY_ACCESS_MASK
+#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
+				PKEY_DISABLE_WRITE  |\
+				PKEY_DISABLE_EXECUTE)
+#endif /* _ASM_POWERPC_MMAN_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 31c95c2dfe..1c8f918234 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -695,6 +695,11 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START = 100,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -709,7 +714,9 @@ struct kvm_sev_cmd {
 struct kvm_sev_init {
 	__u64 vmsa_features;
 	__u32 flags;
-	__u32 pad[9];
+	__u16 ghcb_version;
+	__u16 pad1;
+	__u32 pad2[8];
 };
 
 struct kvm_sev_launch_start {
@@ -820,6 +827,48 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+	__u16 flags;
+	__u8 pad0[6];
+	__u64 pad1[4];
+};
+
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u64 len;
+	__u8 type;
+	__u8 pad0;
+	__u16 flags;
+	__u32 pad1;
+	__u64 pad2[4];
+};
+
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vcek_disabled;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad0[3];
+	__u16 flags;
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
@@ -870,5 +919,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index bea6973906..b95dd84eef 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -179,12 +179,6 @@
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
-/* Get the count of all virtqueues */
-#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
-
-/* Get the number of virtqueue groups. */
-#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
-
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 
@@ -228,10 +222,17 @@
 #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
 					      struct vhost_vring_state)
 
+
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
+
 /* Get the queue size of a specific virtqueue.
  * userspace set the vring index in vhost_vring_state.index
  * kernel set the queue size in vhost_vring_state.num
  */
-#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
+#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
 #endif
-- 
2.34.1


