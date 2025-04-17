Return-Path: <kvm+bounces-43547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4FBA917AD
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 803C43B6510
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAB3227E8A;
	Thu, 17 Apr 2025 09:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q/1rYMU1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05D22157E;
	Thu, 17 Apr 2025 09:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881678; cv=fail; b=M96zuhm8n+9wMbXMavOQFlzhlSIWw2p53BeLF74e2obu1VS/hhd+MJFSbc1JOFJxi+HrYUu9oECJ1F4+x1ujrGDZO4t1xsnWTq7bF3LpWP2dhGO54a4UxO78JCRmyUnoPf0qOiv7CdpxTJh9G0M5SKeKDwMERypYqgF2j+aC42Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881678; c=relaxed/simple;
	bh=pbjpfQzXcu29JKuwee1AaV4NRF/IoF+aN5GBRPYSkBI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QysuwmqjVvI6XC8S9bjA1bn4oLPPWa/V4VWvGLBIsFlUuI5X1kayLkUfYpWnZdIvaZWfmUm0UnbSn1+0fE6FXYCHyhMh0DKdYbZ96fsmT6moSGV53fK9Fx6JmC8Wkrh4nNmTIc/m1SZWDjgyjRvETsSmpKl7SkJcdPhF9b5ioTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q/1rYMU1; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDN6PTw+Ai2RuAHobI8pNbQ8WTAr4R4MpxJvfV1viPb9RhL/8tYgTNe1kC44SIjjn5azM0XYBNxHlt5g65ENiZpdrIENB5XzbGIe4K3ulybOiaPa1+4H9dJt3BHsV/UE3Hd0OSEeFOSDqrM3sNfC4qcfnjU+mjJkZRakV+o1NxbvxMBOuCyrsWqHY7Trm4FnC6UDFAEQn+ClvT3s6S0mbzVsU5EPAnjagBhhHcnEtfa4owXJ+/K8gxNGz3EL04mHA11TWCU/x+AGCDwpfODTcRlzDrF9BWMFCdzES3hl/ziJpNBEcdJu990T4zR7mQeNtg8ch227O7flckKWsm7Hqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kc28jYkv8xSQJq7KIOd9MGrBpSr/JUcs7Ps/camOaw0=;
 b=xvmfXXZilYigxAwOQAUoeJ07r4BO+vt5nWX/Sktq8IT+5I2EHdYntXsF8ZHfU1ycChUn1FXwSTjPGw5FDYzGABX398BV4LQDkJieo3UKAhPZrYUFkxIxAySCUj7CY/o0Ps//SjXiOrajDA/SqTpPN0XmTp7GR/uIzGsKz0A2+RyQB1yfFpqGdhfaJ5KbROyHWcLavL+Q3KqR8vLaSYxJ/4BZcQ9zIcocj48f/2RCblJxkdwNfMXMTKR5aFPQill8tX4Cwfq4VypWGzbKIgWVwMAGArKqaEP7u9GA0ORzTy0rRvfx35t+PyQOHWcxBWDK84MXcoy6Lr/KaOoV1ZPbvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kc28jYkv8xSQJq7KIOd9MGrBpSr/JUcs7Ps/camOaw0=;
 b=q/1rYMU1avfDWkNuyWx5YKPX2/e0N2AT2iiD2NGct5Zv6iS4TUvAWSYwMFEn5AVDS3iqpDoTV2zRzSTZVksoGwkgOZ1tjqgO3g/HH8fqs9HIXEdURFbR7gvgw5kFs/EHZMFa4uUjwzX/6kmWiJEnllvvEnbjlrDud+OoP0E7TYY=
Received: from BL1PR13CA0315.namprd13.prod.outlook.com (2603:10b6:208:2c1::20)
 by SA3PR12MB7880.namprd12.prod.outlook.com (2603:10b6:806:305::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Thu, 17 Apr
 2025 09:21:10 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:2c1:cafe::7b) by BL1PR13CA0315.outlook.office365.com
 (2603:10b6:208:2c1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.10 via Frontend Transport; Thu,
 17 Apr 2025 09:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:21:10 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:21:03 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 09/18] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:59 +0530
Message-ID: <20250417091708.215826-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|SA3PR12MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dae7f62-c91e-4041-e101-08dd7d913149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cOt0rxd6WGLoRhyWPGYrZ8RDg/wYnC0jbElUBHzhawZlfmMfZBPy6lCa9MCh?=
 =?us-ascii?Q?OEnT5WkDJUZ1nHIdC5ZjUufGfCxZa2oky8Thi0ZoROk3+OnoW92VOttamFuk?=
 =?us-ascii?Q?S1XZA2DVnzjwCc+AalkiasVbNQRObbpBTaw4+ns9w9AurGSk5MNGfAV2Jreo?=
 =?us-ascii?Q?8IdEfM0+JMe61ibn3xqLpX381DjKSQ+GplNH+6wVX1/j6wOe/VqRKEh60oVR?=
 =?us-ascii?Q?UkYAzyk254QobDKk903s2dKyycKilQNsuvWrCtbl6irNREySyHjwJCCqXjFd?=
 =?us-ascii?Q?krZweNPQA5mInezAWBz33RXJ+1/5i9ye495mzjbqmlli+TC5b0e64Bm4LSI3?=
 =?us-ascii?Q?ZV/5cXHuxNhY92utOb+PSAsdmv/47pNeO1dze5aNxO3doGdFE5wI4FQSm5bX?=
 =?us-ascii?Q?bCdXMqCkOZjdZwEoiUfhCxKxP/+I8up7qi9c4Jt07iDuAgMMtZhyKJ/3NS87?=
 =?us-ascii?Q?vFsBq0eca0fu1xOjtMpTRYjbz4SSjipixcZ0/kTsgABnGdr8cZg4jSiZdVIk?=
 =?us-ascii?Q?xo+bHUwvkK4V5oaxfXdq0XVptp6+d54YhyyoG0RFzyAXsN7RZ+Kt6YmWDD7Y?=
 =?us-ascii?Q?1+Mi/l02mciwXD+UPuZawJrgVw9Rfum6qBx+6wjR0dephq8cq0INpUOxZliN?=
 =?us-ascii?Q?5WvOx5jpuzlIIsFSbSfsysV4kCAWd/dtJE1/XgBeRpAhB1N5J920jgzdd8SC?=
 =?us-ascii?Q?wh4wc6B8dI41PbFmugtmGWhWDuqc4OHgecgTLE/wypKXh37srKJMvnPeMX/K?=
 =?us-ascii?Q?Vjldj6oYBjnRlHak5Q2d2DxLmfgHSsuqX9iPhxaNZnsYTjA3m4TQbCOpC0Lw?=
 =?us-ascii?Q?ptQruFvnnFkcYJ5tlv/uyn5RVvtSWeYRxOWOMpRlIIVjXQWGOr0zjhEjd9DG?=
 =?us-ascii?Q?lKToo7sC29hctvt+W9Zvu8lJ6vj1hujdQUyewO15eHFldM/SLmbdZHISMb5x?=
 =?us-ascii?Q?9hUvdC5Wqf9ruWayHU0/DiRoI1WFKtgw2WG287XVjg1tzwJ/vvEXX+HhnvoF?=
 =?us-ascii?Q?stKhrNF3RYefVoj1vJJmydHGxPUugO+PT+0WJ6PGG9LG1GA2Hzw00T60czj/?=
 =?us-ascii?Q?p8gQefIT1e+k8gMByAYdzWef3TRemsCl48PVJvUegl4OZ1S1mlgwAE17QMi2?=
 =?us-ascii?Q?+g0a41Nx+smv2BkvfFP5yAsNy7DZjEfoCXpnhSdKtiBB6sZZZO7FtutLfJLc?=
 =?us-ascii?Q?uC1nPBqEEq0LM78gtmT981MWtCpbk5Zr0TL/cb1X5o1mIwUVKwEg6sZHdyXW?=
 =?us-ascii?Q?6baJD+Kdp3G2eHt7OgGHbIWh0RdQPq0KddGLW5MbnJTaa0EOhwVpVseE6zWu?=
 =?us-ascii?Q?dKuGrWEWkgVM5VG2IeC7XbgraUE2PQ3I0S2HwSPhKs0Axc9dxZWyglB1fDBE?=
 =?us-ascii?Q?7+s2NxOkSqNOep33u+pfuOiril3R0KxdjqXaYZix/mcmGpVe2hUauqpySnpl?=
 =?us-ascii?Q?VAyFITnluoWduL8hsN+TOrF+Gl/DZxGeKBpFP9e4kOPRnILkdk7vEZ49oW0A?=
 =?us-ascii?Q?+HnlIML4BQKtyTOWhldSZq7W65NfU/Yggi+z?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:21:10.6700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dae7f62-c91e-4041-e101-08dd7d913149
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7880

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index aa335e0862eb..7bc0c036b4d7 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1188,6 +1188,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


