Return-Path: <kvm+bounces-43543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D289A9178D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EFE31908117
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5306418BC0C;
	Thu, 17 Apr 2025 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QV2toHP6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F372C1F8EF6;
	Thu, 17 Apr 2025 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881576; cv=fail; b=fs259cVpYedGfjyN61EmWdq458BKiTNgQt8ZMkGiU+2n/NCcNMkMqDUt+50MQ3CXdSFWJ5UwdDgL5O6y0tO2e68azK8r9ZAp20zlqTtYBe2NVv4lgWEPPDFg98vmw4SchZry2R/g0lIJOTlBpvRXVzLBERdtaXOwGSw821npLnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881576; c=relaxed/simple;
	bh=fNWvREtw20UDRUDeaet1hyJW63o9ph+wDCxPj7HlkbE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OgFdzzuIRxKgymXYUVn9/VaXmXnAdwxLofwAMd84QK/Xfx97yT/xiCo/M7c+sFGKDl6ADL1NIj7L2kZtIZfyP8H5qXYT5FVqbizdrUrdT9UkEsDqmlOsJ7GV6xzqA9WukV1O4xs3VEXDDlcqTMheudKHqV1kUd6/wBTGT+Mm24M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QV2toHP6; arc=fail smtp.client-ip=40.107.95.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ESZ19LPWPF5nMzzUNP40Fhn9esDxpvkBKRhGveN73Ju9LOxb6/4fsIQDlf1UPpHxtLjFnZKCvvBMvpDp04WRXdayzXIMrk+UQ63N1VeuXey5eWtFRY5+w6foLjrkxTzb/x9/KN5RuoIPGTR/q+EAZETMizvf5PvZ9R3H0cYj7O5rKPzeYhtJ9vudrkKSB7TyHs/yjV1uFsPFQu3Q+p8+wO4nLjFh2X7PNJ6ODlT9W0JXRdOZ96yrZQwqpjXsKvChOOf9QB4SlpD/IiN9gQHYv5FmIO3NJ4/vfIRkf71bPM/ng++kdlUmbjdJTimfCA1bP2gedh/YtYjLA3eDGBVLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQLaFtxVNJw6R7KICuzkF7I+xkXI00u1GIQfeQRlwWI=;
 b=pRG4F8AuYkMNjV8rCX+f/2NWjUFmgCg+Xb+p/qxVJ2rKyOY2DbtQgbpKEz/aYljWzuBVD74InPYzzNBA1m9DP3PVlJE8b2F/nYAurxtFAENPmiCAAOk22buyZ2k0zRDXd1BnBCGfVXRDET6OxgGQVngXotrKnK/eP5jnLrRRKxyXinsjlUvEq9V+2FtV8BEbux3ZdeXc5lJZc4/vfzbGeHdXXVL14DcvC7Xfss6XVVoEPp3duzj9vBhbYRtRmt+MbgC8LTzOwN9cWDUHSXWn2SRZBE9y3OUHttFimWSEf9sIA/W31FWw2BK4aoaP9Y5725VkrGo1vEBY8MsPw/pbEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQLaFtxVNJw6R7KICuzkF7I+xkXI00u1GIQfeQRlwWI=;
 b=QV2toHP6wygnshJugFaOqm6oXM6+xPg6e+XRlBgufRmDtgkysdqsyY4hfFV+eRlYnk5+IhmhrMZ/5fAyEPQl3xHMRGN+YyVhH0Ly+/1G67u9kgsW5Cx0Z78AmX3+vYOhrH1Kklxvq7B2jj3rdlMxUzdime6rdKcj6yL+esnUal0=
Received: from BN8PR12CA0008.namprd12.prod.outlook.com (2603:10b6:408:60::21)
 by DS0PR12MB8217.namprd12.prod.outlook.com (2603:10b6:8:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.47; Thu, 17 Apr
 2025 09:19:31 +0000
Received: from BN2PEPF000055DA.namprd21.prod.outlook.com
 (2603:10b6:408:60:cafe::4b) by BN8PR12CA0008.outlook.office365.com
 (2603:10b6:408:60::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.34 via Frontend Transport; Thu,
 17 Apr 2025 09:19:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DA.mail.protection.outlook.com (10.167.245.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:19:31 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:19:23 -0500
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
Subject: [PATCH v4 05/18] x86/apic: Initialize APIC ID for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:55 +0530
Message-ID: <20250417091708.215826-6-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DA:EE_|DS0PR12MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db76b59-3b3f-43eb-464e-08dd7d90f603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4mPr27xtO+2PTeUMT7fxSgZbKGXRlXb2eHv1A4u1zQq5pEusnYfvYEYVdPo4?=
 =?us-ascii?Q?uTkxi5sRKM+z+o+AMZvNCEL6Xeu3TTkn0NHq2MVBluBTEiVxpbed2wNEUl0z?=
 =?us-ascii?Q?AFRg9g0FavZPRQJ6a5IymNQcVUQUMhrSQ/Ac0V8O8/yA501rl42YTqVkW81V?=
 =?us-ascii?Q?HJA+pJLhHrLuiu5liKOOQKSnSJi1zD4jPuZ0SBkaqH4i0Iy0pgbN5Sw+awbL?=
 =?us-ascii?Q?XxAsbiNl1tG6w3eJkRVedph05LYlDWWaPLc6opS/PHSmm1cRAfs9DOvbykgC?=
 =?us-ascii?Q?CO7O/2eHutvKDv7MDpYq7OwsDMhNf308gjZXXraxYRPusvtiVeuG14voAivr?=
 =?us-ascii?Q?GSxsLi25twuaz0PBHzinutF3ICvtU8wT26nBRD+ZBO0gC7UCrRKPkf1dFrwu?=
 =?us-ascii?Q?KXu1BX72Qqtu7qTi5uFWOhhAo3MKxVx2xU1D/RcO6yVCHYMr8Bckvj6FVF6L?=
 =?us-ascii?Q?8UazRZ8tVTmeKmdlzzGGImxfx0vV8kCrB9bMbJVcqqEqCDImrfH/M99nk8A+?=
 =?us-ascii?Q?c3+8GjyuKfRT3qaX9qHFe8rmaBmi6MLBRS2oudCH1DmVUO8Q35PYvlUWhUZW?=
 =?us-ascii?Q?MildBmpz6DgTa2dhYHB9tLcx6A0iDN8VVckRu2e8/OSDdy89Oexpynxjj5gR?=
 =?us-ascii?Q?vua+Cce/qqeOZ9cmCoZHudqtA8s6K3CMqu0kWSPrsAugdQk5O3sHfcUllG4O?=
 =?us-ascii?Q?fj2+U+WYyqhHhEpSLWFuCtyIrux2EIrENWuLotWcQWA0BimgB61QKNfDDYMv?=
 =?us-ascii?Q?bROQn8jPC67v5vE2BOvB/9YNvhiskCWDuTHvjnDLbbYqoq9LJxEbZAAuQ+LR?=
 =?us-ascii?Q?luYE6+csK7cZjwSBaz73jbKcEbFYXH+0SA94GOhMzIEDwuMcD1kd5OKVa99D?=
 =?us-ascii?Q?bVsCqio4dZ1OBj2L1766TCXRnaLriMnG2/GxXe9jCdDcEq1YVDD/HiNMvUMg?=
 =?us-ascii?Q?7rAsYVuA73BaX1Yc5iOCmT2tBfuYvmJNJ9AbtEE1VKYVU1D9iOqnvsIU0PSU?=
 =?us-ascii?Q?UtSNew4MxSmvJDjsR+k8rkKa0tOIkwFpSbRX7ZGcVijgOZDWhVm2OHvooGuf?=
 =?us-ascii?Q?5GkjXlJeCxW37X5DbNMLkC/VNK0RCjQFtsVJhxkUd9iY5jBfpGqbCx8k1upe?=
 =?us-ascii?Q?3Q18wDJ5PBNhyNdteSfGSDHJfnddKe2DGCYYrNcRvpm+Qq3/7u0UjhGA4xN/?=
 =?us-ascii?Q?exhAIaJdXMk48C4dA2xgQmZlaywTonrU+sRi9LDkgwu9XlRPlkyEBZDFdViK?=
 =?us-ascii?Q?VmeJkperwkJo/1h3gMXHf+3CfKaRoHXCw32kP6l9e1n5XeR3TcGthzXyioH0?=
 =?us-ascii?Q?R2cuiMS2+oa266NEXVlPCoJShA6ynpDLRUpSxeGroYZLnFkRRUWjtPmuhwkH?=
 =?us-ascii?Q?3qhFcGiq+hfk+O3UbmOeuKdS8MhZj1XxNtMJai23CnwohqfDDMzGOdjx2GH8?=
 =?us-ascii?Q?J+AiCcao18Cq0gsOVbirFHlvO+RRZb4LbBpC9GkocDKSO0qXmCQVQYF6RgKy?=
 =?us-ascii?Q?IEV/vUlM5iG3s4KKlCZBzC/VmL573z+Q/Dwy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:19:31.2228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db76b59-3b3f-43eb-464e-08dd7d90f603
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8217

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 4761afc7527d..81d932061b7b 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -144,12 +144,25 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void init_apic_page(void)
+{
+	u32 apic_id;
+
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_id = native_apic_msr_read(APIC_ID);
+	set_reg(APIC_ID, apic_id);
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
 	enum es_result res;
 	unsigned long gpa;
 
+	init_apic_page();
 	backing_page = this_cpu_ptr(apic_page);
 	gpa = __pa(backing_page);
 
-- 
2.34.1


