Return-Path: <kvm+bounces-51845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEACBAFDE3B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3AFE540D46
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25B6211A27;
	Wed,  9 Jul 2025 03:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Aez28lm0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2050.outbound.protection.outlook.com [40.107.212.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD861F4E57;
	Wed,  9 Jul 2025 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032196; cv=fail; b=cod8IM28Q+eGfoMK5FeWCE+fDWtabPI3NhPK/gZpuIjqanzJQwLsIGMdDIimooSu8PxsvyaDuXXc9ZXWXOhg8bWWe2MVTu5Qvzg5CrlzPQgJrTAUdXtRyLslnf9YqNRz+q/yLHA+FLJ7wSfil+/PC4Q3d9DReFpUPJNKQCtZGVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032196; c=relaxed/simple;
	bh=RN4hbLPNeY7ul8uB6UWwwXFwMw5AE1/vPqHhi3kYBDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eiPYpSx75ghswv3HfIMmYgwzXtBNfVGmD3dTo1o+8t+JBmLrZ/49MDniNtKanU+hnQAlQLwE2xCprbJ2duTstFoPqSs+wZIiryGkHwMGC0chv1z1L/7mm5XLReuhNzwX73zsQ+BBU+PIcarBEFYMAr/MgTVDQ76L5oxW9cZ4ty4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Aez28lm0; arc=fail smtp.client-ip=40.107.212.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOZN/IWmjP7qw5JBgM5NO356oGC2Io+M8gc2MnMW/MNqc65Ubj3W2cUyVVHDmc5Po/kyWprUjx/CbMRFHfBLFatxEYAdA4mq/vnPehe8on6VRDIBHMar0259FF947yuoRJoDxqPtGPEUWCtykanoA3HfALjuzTg788lTmbfVH+PDJpTwHzKSVnwsx7UKOLWkN8jTZJ0DFuc8SSk2hAZ2xqsYshIaTYI5HtYPuvHzN2iIvcDq0w9O7AY90pIJUWvm57O85zW1xVWx90/1Ac8upsDPA6dmDRpSz5iTw2N6ovJ+/QheeLU8MTsuhs+896xwidNMZuRJ9qcX3VcPhNuF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpTawitvebANqZEr7DgCOvSWvjUtxuJfwqp7YLakRAA=;
 b=qJvGQb8n/vJS8RMp38GQfUz1ax+eANkJPYxskR6idJxxTiCQBrSSPzE/dd0sXkjvYs2LINFpJqMrfyGi6iXAd1JifcMDfj/4rW/R8V2bVEu8haSQDsoP1zlpMb1Oc/fp4ehiyd1n80N8SToi9pJv3I7P3Q0nM6SXSy+2TfRfJ7x/F8cUg32X4CeYvB7s6rLUcNRza4IuviNkroQsV2Gh9NotlK3t3TX2PxiZyMs2Z5Rq3mGbNFCoiNNQOo0DSLXTPatwp7uQxc1p9dXxNPQTnOLn44LJJE1Bt+1hkr3E8AsoC/9lQDRQABYDyi8z7Ow3EVBnXH73IWW/O1VfWQFScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpTawitvebANqZEr7DgCOvSWvjUtxuJfwqp7YLakRAA=;
 b=Aez28lm0BLX3Sw2wZEIB/jp0cQO+5c3tSMn0MpcGhJxo/ITimXL06YErzr9votTU/l0Mf/3rOOQ3yj20/DyTLhde27OMtHmzpgz/xUT6uLH0f3FaNMpDVZZ+GT53Q9g/1XMxdOXexOSJYeZmkShtiFun/6VF58MiNr/fRciUoaw=
Received: from PH0PR07CA0110.namprd07.prod.outlook.com (2603:10b6:510:4::25)
 by CH2PR12MB9459.namprd12.prod.outlook.com (2603:10b6:610:27d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 03:36:25 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::4b) by PH0PR07CA0110.outlook.office365.com
 (2603:10b6:510:4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 03:36:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:36:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:36:18 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 11/35] x86/apic: KVM: Move lapic get/set helpers to common code
Date: Wed, 9 Jul 2025 09:02:18 +0530
Message-ID: <20250709033242.267892-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|CH2PR12MB9459:EE_
X-MS-Office365-Filtering-Correlation-Id: 174a4d37-b40b-4957-ed22-08ddbe99c80d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G6bf4cscKHG9o4xy4UifNGidLi9/dSrMUWWRPy75qsNR5tKW+Ns+ns8XBnEn?=
 =?us-ascii?Q?rjzTOVRPMS2rtpROxiPt1c1fyoA62oN0Y4o4cD2TXLIqSAlXg8OhsdiG/PSi?=
 =?us-ascii?Q?nW+QHx1bcZbzZ3HIUbjkU4J0fgtu7Tmh0rpeBxzlnos6oJ/6mT+v0A1jNHgd?=
 =?us-ascii?Q?VT7fUlTnDItjoOnQAeAPKYFHTNd0O7NT4txT4Dm829+Cg5ITLJTxAL39IAIY?=
 =?us-ascii?Q?Hs11GwQ52nh175iVp3NO1uFXDN2RAYtodiVuFuILOiF40FBlxSYv3eJ4Cq8L?=
 =?us-ascii?Q?sge2z73yYKck3BWZO8ocit4Pn9WmUXkxJ9Q1VTq78jvrPtx75fDW7rn00EPB?=
 =?us-ascii?Q?ziGZRMA2xakKdautVV4UXKVRWQUbfgpc/uIsc/X/Ip5dP5aEbEeGop1ZjnDC?=
 =?us-ascii?Q?KZ/H+WV/K3xBducHptc9HTVdLfYj/pZvxOSXNNoQSXbNNwgs0+IAXnQWWQY9?=
 =?us-ascii?Q?ai9aBX1eCtIOx83CyocGMuodPOd2y5d0UU1Au2OVnTBMGopFB1rhiUr+CZk3?=
 =?us-ascii?Q?Kj3EuXnzV5/8ix4ZA0MeLHfCgHpRK+xnMARm3xyOryFVQ2cBODbHSeZPBymk?=
 =?us-ascii?Q?qlXibgq56Gkz20kmXM2GwO4NRz0VHoG3V+m3Sh2/rQsQ3HOa5mt98Vdbrs4l?=
 =?us-ascii?Q?8P5EIUicBX9pUajUEsZigrw6flFnAUJzoIPL/nthhxCUKFA5vEZGhJqRdZmi?=
 =?us-ascii?Q?tnLf+D4FhKUD1EJj86cWM08en/xrZmjz8GVV4LjYF77Y0vtQ+3GQWOEEyAni?=
 =?us-ascii?Q?94rkqtKKwbbL1wprDy+vdxzFFaNyGO7kJW10XOHZ2edJqWPnK9rLxcW8MVLv?=
 =?us-ascii?Q?BgJa+u/DrklfLMMM9uKhtWN/YPuI1igkVzJ90JemoldEcgigdvZp+WPhXpKA?=
 =?us-ascii?Q?drHDJdxml71iByCKb93zvqcJsOjNZc6S1OuF15VeFSTpOC/H7t7IQ3tji9Yi?=
 =?us-ascii?Q?r0AtPel+jSpXxpzSPWoQ5NkVNrvJ/FiplFwPNlXRespKPAL4l3h2faNVPP0y?=
 =?us-ascii?Q?LRh6a1A//xU/JOiEkGl6ANLoEY+NfmMlNau/so6mGzn1P27H7Tb0aaaAb42F?=
 =?us-ascii?Q?rkXhmeBTQfa9nvbOB65spVwDzinVCYJLQrMGWSpv748fM/5f+S/WftYaXDwn?=
 =?us-ascii?Q?8uN++gCVPCzoMJ0IYVQw/wZDbO897npUc+3BrY+NVP4pFcLTKElyYz6zCU7V?=
 =?us-ascii?Q?kkNCRsFEIHFJAmfQyKlMi1VEWZjzUsP9j9C1LoMvJTV2wTLDJVyK6MctAhNb?=
 =?us-ascii?Q?7w1UjOwfO7YwaBuwzZa0AmUc5sOVlGoKAoaL/k3fX2EqJWbrPIUWcGyjx4x9?=
 =?us-ascii?Q?WLr+w2W0HacOra1vweZd/JDgv2HTvCbBynPFv2hJ9kJeWOrh3Yidvyl+/Gts?=
 =?us-ascii?Q?qlNRy/ewhjZ7eQ3JUGUNqcPyeSeemQYaONnbNix1F1EMxDez77pVcPNjd8Z+?=
 =?us-ascii?Q?tou9dVaf/478gYDZjvM5Otvd5h4yOkDObxeCPVFcqEaB8U6GMRmQeYEtSvoh?=
 =?us-ascii?Q?qmPIl0cgdqEQB6qdezGyuh/2/syqlJAUYaj6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:36:25.1234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 174a4d37-b40b-4957-ed22-08ddbe99c80d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9459

Move the apic_get_reg(), apic_set_reg(), apic_get_reg64() and
apic_set_reg64() helper functions to apic.h in order to reuse them in the
Secure AVIC guest APIC driver in later patches to read/write registers
from/to the APIC backing page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Squash 64-bit accessors movement to this patch.

 arch/x86/include/asm/apic.h | 22 ++++++++++++++++++++++
 arch/x86/kvm/lapic.c        | 17 -----------------
 arch/x86/kvm/lapic.h        |  7 ++-----
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c7355bcbfd60..b8b5fe875bde 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,6 +525,28 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
+static inline u32 apic_get_reg(void *regs, int reg_off)
+{
+	return *((u32 *) (regs + reg_off));
+}
+
+static inline void apic_set_reg(void *regs, int reg_off, u32 val)
+{
+	*((u32 *) (regs + reg_off)) = val;
+}
+
+static __always_inline u64 apic_get_reg64(void *regs, int reg)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	return *((u64 *) (regs + reg));
+}
+
+static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	*((u64 *) (regs + reg)) = val;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 018abf2ff890..c7c609171a40 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -77,33 +77,16 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void apic_set_reg(void *regs, int reg_off, u32 val)
-{
-	*((u32 *) (regs + reg_off)) = val;
-}
-
 static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
 	apic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 apic_get_reg64(void *regs, int reg)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	return *((u64 *) (regs + reg));
-}
-
 static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 {
 	return apic_get_reg64(apic->regs, reg);
 }
 
-static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	*((u64 *) (regs + reg)) = val;
-}
-
 static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 						int reg, u64 val)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c7babae8af83..174df6996404 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -4,6 +4,8 @@
 
 #include <kvm/iodev.h>
 
+#include <asm/apic.h>
+
 #include <linux/kvm_host.h>
 
 #include "hyperv.h"
@@ -165,11 +167,6 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 apic_get_reg(void *regs, int reg_off)
-{
-	return *((u32 *) (regs + reg_off));
-}
-
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
 	return apic_get_reg(apic->regs, reg_off);
-- 
2.34.1


