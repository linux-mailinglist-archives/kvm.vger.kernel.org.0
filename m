Return-Path: <kvm+bounces-44694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E178AA02B3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1F7C482B57
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1F12750EE;
	Tue, 29 Apr 2025 06:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tu9eBw1Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43A92749D1;
	Tue, 29 Apr 2025 06:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907168; cv=fail; b=f+kf9G4CUrZ6keontQSVu079be/1eOxJhAdJlaeOgsGwQDNkxj2m+lhX9YUNcW4yt5l38WiAp6ft/d5TNo45pU3yj7uKAPgSevvcG+nt6w885Fjc5TojVJ2tGujYcKJCZTD8NiGTAxtBPqAJHTyc3rXmY7dPFqu5zNFnwEzz9ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907168; c=relaxed/simple;
	bh=Vj9aPVoFE0lc/VCiUgUvC8VYsukPtunUbI7oOtafwlk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdFWhdmiB0a+/KD6GKtLm3ChYEoZGluu8RJEIIVMRjvP/1aQrTwZwiUImDETnssIzOJ3ev6KuDLq2MR7NJT7t7Q8Mwoqo5M+CLVxU1IxebykAXUX9v/h2w6a1zxrG6jBLnv7x0/9Vnew6nboiPsu7fm/aELGAgCVF9IVnXbjGYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tu9eBw1Y; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLEn34/KSQ+EtC8pvBbSyYc6m+QdIBdZdZXvSd9Qju8o8GfR/uJ2/KZqZL05kj8gohhjGgtIh7jMK9NP3szxjHasJsQHikSyrMzOVflYLlFm8qTtCHtGwm8RUXySzrJoTLeQ22V3wU5oEiH3HEuZX/RutjV+nhzHMpedyenj8XdgwC/ipWMKFixqD5rmXznZHthroGRZnY+6UfKAnEfB/cGIzfV+r5y0+Wi+iY/6FISYpjanz1xq6UUQ2JM9D4Td2lNh85iWZUTmz6ZdkKxbU+RCDULayWFCTRYG8RKcu05vKgOrX8ltECcMSnr0edvodCLzsEvvvvlHMXcBV7Mo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DMA1CeMoOY3QDLEVblI8olHvRz0JxoRY5p8GLyY+Bk=;
 b=kCSH0CMRf6ok4hieLlx/hNQo4bOC7G1AEr9/gi0FrZgIJ70+aYIdrZGcwhxkI6P2BYOFLMPmPEPXQp/Ngh4qZZasG80QficRJ3O5vf9og3b/JFNW6xJa4CD+nE7NAJ6UWTRiNTwuGK9R6IR3M4TFT1FxNZ2PJuxl3dRWHNcgXfZgvpgzHnxf/qjbJWePT4RcRfUmsdzOfU6jjeL/4A9SijkVQFEgwLcj368fgbnzmc9C7LD0LZu9zqwKFFgjYXcQJqiNQ+QYBL6Rf19ZlCDSCeqNCACpSqQwx0E4N3DCVRe1WCQNNZmkY86XZepsWweoVRLZQPId56RIlFuqD+Kanw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DMA1CeMoOY3QDLEVblI8olHvRz0JxoRY5p8GLyY+Bk=;
 b=tu9eBw1YX3GUEo5Bbf7FOo7sb2iso3txMKu9CAKTJbZuEaOVgp31jZ9jkQGDy01ERLxReYV4LTA2YUOwaBWYixZ2h30anFocj6IfpZk0VGcZ7OvJAby0PmvHgvFR5sWmnxc0n7gc4hujXS6QFPwf7U4zrNhpREGmFtDLM2JKSGI=
Received: from BLAPR03CA0071.namprd03.prod.outlook.com (2603:10b6:208:329::16)
 by MN6PR12MB8589.namprd12.prod.outlook.com (2603:10b6:208:47d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Tue, 29 Apr
 2025 06:12:40 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::7) by BLAPR03CA0071.outlook.office365.com
 (2603:10b6:208:329::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:12:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:12:39 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:12:31 -0500
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
Subject: [PATCH v5 06/20] x86/apic: Initialize APIC ID for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:50 +0530
Message-ID: <20250429061004.205839-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|MN6PR12MB8589:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ceee002-b076-4aa0-4cdb-08dd86e4d88b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZP+YSqEKmaEY3eAwFcZPCFRg+2NlMVM5iZv/7+Y9+GAngZAnH+zoAnaLdhIt?=
 =?us-ascii?Q?vraSpRSvV4+IG1LbLsJixYc4ScgBCL3QCuUMgcyTZLIXSLD5yCrrxvrI+AAs?=
 =?us-ascii?Q?Z4RovsVMkmJlBSOlwFEA/xe9LwpavyKukmYyRsdM1sMlVKR8qvmXr4X9grzm?=
 =?us-ascii?Q?vLrFfzBolnqLEVfygY+4SbXQHrYdL/Yayns4HJGjtuAllV5L4lZHh3WBo7+z?=
 =?us-ascii?Q?65tWYTaOw0amhUskTuewy7HgHKNDSdCQgNhHPVF5FaNa/lN9qb1T2Dsw6DtB?=
 =?us-ascii?Q?J6GO9WiKnQnHZdVqlJFg+KDHYneMZxP6IIQflTuYEVJkeyJgsVKdRrGFLAE7?=
 =?us-ascii?Q?KbeG25+Xeylo6hn21j/QhV6GEcakTDkMt45WkpnuJrheZH+4cjJZIpgFkGND?=
 =?us-ascii?Q?REjg5l9l+p977DvhJ4RyaAwvIKuHlpgEhR0DMMV9uIgp7IEsRa8tvAkQaZ1U?=
 =?us-ascii?Q?/pVqBZZH4LjcHnd5pVAngL0CqLHZwRyDBUbugPbksqIc6/ZT7i/OsGW9RuhY?=
 =?us-ascii?Q?6e2BYAdEd3pFuPDMSswW3gwrcfFDMLcb9k4SHLL/50NA6vF7B1hKE4Up4M6B?=
 =?us-ascii?Q?dNRM6U7VtGHiXc5aT+THJCjazLAkr68sSX1m+DqIT0rCreGvL6cGSq1IDFqe?=
 =?us-ascii?Q?pyPf3W4iZwesHz14aBZOUEq8ZKFXeYbKdWXnSEvOWSLOZNlUYK3SsDQINbdv?=
 =?us-ascii?Q?54/QGQC+Q1KfyaD7baI54y6Ig250tZ01WsTq0O3JxKax+/JsII3Jf9XeldiG?=
 =?us-ascii?Q?ESgSa5s7/Du7krWlbILP3wZMsybauT/pgVvO5w23hvezbtYRHZQebOMxvrvS?=
 =?us-ascii?Q?5eYXDFnGNuyIjze+mukR3EJjDUfjfzDgbbch0ZQBlymxFGtgzFFFihu3DgDx?=
 =?us-ascii?Q?vUED+bIqp6F5wIy2PAufXAPfcQ42HziWMLI9QNChXzTjwC9Ok3axryXmy0BY?=
 =?us-ascii?Q?UDqQvACyTK7+A6a6g5QQiYgyHk/A+Nb/ET0TwStdw+Cdxo44VmXM/dv1Tcxo?=
 =?us-ascii?Q?XttBQote8rAwZg0Miwcf8i5bfgmvB9YZ/ekmeJnYMQCybYGuAwTpqB+b/Vnn?=
 =?us-ascii?Q?aILL4YWX17NuUr6I25rXB11Z9lFs84DLyiQBv2DI63syBCLONng3HnyG/Xks?=
 =?us-ascii?Q?ZF7TeNtBH1FuObXWB3sbJTT/Bp6uno3qnKa7djpPIVOv+HnDYZElGQqRBIKr?=
 =?us-ascii?Q?wvkS7CLaqw88fpi1UyCeAzH2KeGubvw+/u6kU+ob0D/2aFbLE3pKOXvf4T15?=
 =?us-ascii?Q?qllzDfFhPoqfVnipTwstUes69Q/lCs8Gx2xBEOJdKdP+XlHJAxwlRP2r9eDO?=
 =?us-ascii?Q?LHzrAdU5dyLPx9PKuifkj9qRVZHM1p+Vwgkd0dHp3KK/J0Fdjw0rWO+VQQvm?=
 =?us-ascii?Q?HbdJpDbQjBUyOTtxS+l3CCeSNv/wJ1B6mIFrdT4TV2FV1KsIIVIRxW8DgvqU?=
 =?us-ascii?Q?py7nrDB1JFu2nFVfD8DEuJBuj5qwG6syRlImEMHM5SvEb9khrt4OqVY99mWO?=
 =?us-ascii?Q?p12dvqnz4Gbi1C7vNJpE8vzCNbkZVyUACVtR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:12:39.9724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ceee002-b076-4aa0-4cdb-08dd86e4d88b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8589

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
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


