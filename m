Return-Path: <kvm+bounces-18493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0F78D598F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 932281F26A26
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244C013D613;
	Fri, 31 May 2024 04:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jO4tOWzq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84778C8C;
	Fri, 31 May 2024 04:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130130; cv=fail; b=iftrvCj8wfNGkM3b5JwGZrtsYKyeIJ4y74nLb6dDmVQyF8mdhmsSw7nFfSVJFU4lBUl262q4dbIlGHYqJqF4Fh3LiyV/VnKHlHw8SCT4a53V1BZUrm/OKUAV0d0W921Y6QrGDJGh4qfeT9fJAAnWJGW42THQfnlLy3LAK3zcLOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130130; c=relaxed/simple;
	bh=s9ZaVU6rUpEL0ipla3Jmedzbd+/UXlp0Tr4hvBroiX4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2VRILMHm0xo+YO3mDktROU3aAMymdWXV+y349TpWE/GdW9I0FzG1lXF1UyTXQcLROdgjILd3DUMet8ojRELcJVi5fiVzwEiBK+EJIfjrFEwYGxMVOQ9TvlQZ+umiNDgAeTc3S9X8To6KLHKodxeZOCfYVXfGp8PK+oxPacQpNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jO4tOWzq; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZdg/POCod5sI0ko9gazNXaBz3108Qtsd2/VE5716jsD70nXZ14z69guuexJZ/YtIJTmep50kirKZmSv0Sy83eMOlYDvKTbGMLJJfO/BD9JJn4ofX+2y9MtCQq7kiTc5m6Ue1eGi4rxDb6sw0h9kLSTh1WJsSKa7NRrqkS79fR4P9eL6l/Jswj5oTsWRrBMaUL7arJfzDqKLAc3RgZZE8W2qOUfSesOFN8Cl3jd1YT/DQA8O56wI/E0tyoQj1UA6yq3APVtCv9/u5sCYC3aMuPiNOvngcIozXoc/6dFcZ1p89TFtEtIBcdbA7YRx62w3/I93UpPVDOF40Wj3jhwouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1ysbsAln7bP/WKAos1tZO5uWElhxX1Y/5p1lLqlJ2s=;
 b=MZQSS0/kIvBKARJlXtQXrWrYci7AjrUMLXmXKoxj/5xNHAX9tYivyFGX/YMp7mpcqbYjdUm7hUMN9va8CpyASZqdBuSOyvVwSZBElNuvo/2uoQvjHhQ3vxtuL/GHd2A5EqfoKhFWyxKYdELQEI6EVlxwbGi9CPlV5yCg1uO5EfECYJKZgPtW6lLYcdqF31oR3gLPNI//rdUbvvD7WbHFxJgYhErm4ud9CQ8+K7JMXLQTf55cS+FdW55ZSOoQDvcnNzQtME63Aj1otpbUwait+1mPDwd6qnpqathpWmMtUlbTQeye/zkJSkwysPTudz+kgYfL+BM6ZyoI3SE+ZZULLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1ysbsAln7bP/WKAos1tZO5uWElhxX1Y/5p1lLqlJ2s=;
 b=jO4tOWzqx7HGvlPoGMAt3O4oY2bGemWu7rc99Sr6xgR1tFC35JffFcxWnxBnOs0rP3U9mEil+ClPczikLc58RFGsIDQW1zlB1Ia41LBBUCD/kawkB8lBDvexaAuyDnBfVB2Vxt037tuUbKU7d6V0fmD8otlOUp+7FbkLLAW2bVE=
Received: from DM6PR08CA0064.namprd08.prod.outlook.com (2603:10b6:5:1e0::38)
 by DS0PR12MB7653.namprd12.prod.outlook.com (2603:10b6:8:13e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:35:26 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::f2) by DM6PR08CA0064.outlook.office365.com
 (2603:10b6:5:1e0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25 via Frontend
 Transport; Fri, 31 May 2024 04:35:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:35:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:35:22 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 24/24] x86/sev: Enable Secure TSC for SNP guests
Date: Fri, 31 May 2024 10:00:38 +0530
Message-ID: <20240531043038.3370793-25-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS0PR12MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: d369892d-c5c0-4e14-ea80-08dc812b1810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|376005|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZWFbvhTDWZxCpHegyv4k1FBk6suzcrzsqYapq9AdtTKqRGsNYkI2EVB3iXb/?=
 =?us-ascii?Q?cEpXyfkLkzWDj4gH5PlwRAndn+K0rsOK0/KpYT9HUABXE0ZG6Lb49VAC/bL+?=
 =?us-ascii?Q?iMvU5mgoAUO6/Sav94CtoE5JH/PYo33P+WnPm4dglq1oHAUg+69k71x3hUCm?=
 =?us-ascii?Q?xj+SxJ+Fk2eBXp/Y1LGqujgOBoZpX6ZuPp1Q9rvVVwQdWTMu6RD9Xy4eM2Ai?=
 =?us-ascii?Q?Q4IZKhIUecrbWxng07HdCo14oKOHagPiaNC5fE4q6d+SkGe1qgkp3f5L1zeX?=
 =?us-ascii?Q?jHZh7rksf+sw4fuBurp//YBM2lGtaO02rdyHEuIup+TieuJ9jzuaAwy5D3jx?=
 =?us-ascii?Q?FO/1aNc1XbWRkkBnzTZ2skqPr0eSxCqAO6ph2Qfi8aMumsDeDpouXACftDpR?=
 =?us-ascii?Q?21cBh0neoDSH6ASG+FaU4QeR3g4kvEy01dbrkMfuvGXi6PCLM9n0NxUsv10S?=
 =?us-ascii?Q?QGcznxDrZpa3K1Vv1PiWnFu8D2Z7CpY3CYlU/WSzwtm7LUIrGJBj5LHW/r7a?=
 =?us-ascii?Q?MOOZEJ/ZRSLdoHCoY1R1VrhpGNkR5LQKYkcGp1Dk11UvDlfaa9XYoZ7BhOxK?=
 =?us-ascii?Q?k0wxWqfXdVwLAZ7qkvE6L9J4QivDRlqgWp+Jm0eaX1LdQCbbPeIgw1uZUh2R?=
 =?us-ascii?Q?6cCvXiByuByUYxSObRci0qIYrnc0TO/N5xin1ZrVSTDH6Rkubx5KGv7tZA+m?=
 =?us-ascii?Q?WCiN4dCjG9R1U/JXel7krHOOvyfLf4HD+u8iNCffDGkLzJTRLqpgSAvSkeOb?=
 =?us-ascii?Q?qot/7mrcOvd48cuXQzl3Xh7BEMrZGox9nmCQOnP3EMlcO45jgrF4tQkMu8n6?=
 =?us-ascii?Q?1NLo0GOZxLkest9M6RlP5T5b8ufZzAu4fOxKPoMhRiNewzd7l45KKtDyJ60L?=
 =?us-ascii?Q?GWOSQnQ7IXDyOuXpT94dP23aDI4X1grEz4JnSA8slvWr3ySy9fHRGbE5w/RG?=
 =?us-ascii?Q?rNhHgNAa+L7doDwaCGWmMm09uDKQBM5J2FFNk/iZzskj2Ik+LQmVMEalgsbB?=
 =?us-ascii?Q?8PELxAORXP+Dm6C2pYJOhDQy5dvaqd2zd/qnCVMmvCktgL93XlHpfGOshmTe?=
 =?us-ascii?Q?/mTBzGpKIyMlW5/WyIHwk4bG9nzDhlVJ+N1QmrQ+Q1HHVBXjYRKZL6Thb9Fo?=
 =?us-ascii?Q?WJIYqQrrdvtFncLF4MKuVlYRmul3A3we+nV0vM5/m+mZsAX8yPLeBaLOc7eP?=
 =?us-ascii?Q?TKoWhDMVmoT11fbSZKkrONtixOeWc/jKGMlIGYiO2CYbFLiCmXTi+Rmu4GT4?=
 =?us-ascii?Q?WEXvjXk4rW7HRpAlB8hv0ORqEf2lzIhmVGtlE5nV89PzpAyl3dHE94OXHVzi?=
 =?us-ascii?Q?GkI/aJnU0HAbio6eyuDKAlLEQPziV672odbmKGKlt2bMjPOWJg9NRutI2ySm?=
 =?us-ascii?Q?Tqobhc9M4i5eP+9eqqbwjQTBq+tw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:35:26.6325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d369892d-c5c0-4e14-ea80-08dc812b1810
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7653

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 0457a9d7e515..9474a92e8c5d 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -363,7 +363,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


