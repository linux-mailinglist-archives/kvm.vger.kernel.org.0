Return-Path: <kvm+bounces-18492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3588D598E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 595011F263F3
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F26113D52C;
	Fri, 31 May 2024 04:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nx1NmRNg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5F978C88;
	Fri, 31 May 2024 04:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130129; cv=fail; b=OIluAZN+Ao3Fy0UJBuvqmUb6/K3UueC3KkOE2+BsDgVgYSM+bZz+7qLUv7mlOHiSkl7pNAT+ecX0q6vHgFZ0Pm85UCfbGrSZByeQFjkSG1aUUb90/ZhwQwoNzgRIK7RA4usPgS9qCG9CiuXcMPpGJ7BlTg35IcGNrapgwSIJ5vE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130129; c=relaxed/simple;
	bh=sMUEgS2OAgLUi3hCkfqVE3W55RNR9QGPfw4LxwPs2VA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RncX1fgy+tPt31+/odWeQ++DhvdX2bqvpbt2xTgxnMLovMw0zSRtNphfJjvzrlOCES//SYpGI8NHv7nn49r1V9H+9w99B0KLGyyWYx3PSwy4Z5VBMKgaPMYosMjoIctwmAyqDof1/BVwLVnFq0zkNFTFJ2qVJKLSlmRAXyXy+Ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nx1NmRNg; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5Q9mXq1fKeUsTgLAhaz3E4DqhD8s4KIiuBLIdLtn+S5dvgTjSOn7P+CGl3APywvT76JQbqVb+0PcKkggWrCgmoS3AJ2QmxLOsw25N5ZCL5kCss11O2UORYduh45Xglmu0R+ODQEFuhVJYzsqK1MtYJifsegoTAvRZPylVxgM6Q+1nXJ9FS/tfhP6cmKdnt2YVKiV61nPguOLBba6ZwUymmkXX7A22s142yg+uqLIzwa17ZSd5oglvCfkNpFO4neb75WvopCwv9QDv5qCpKpCCJP7RIFr0p+Ir/pAWD/SdLTHq0syLIHfQxk9babvr0tSLXy/76Xz72nLs5UindvTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxzyqnMqVWcls0UcDrE4oX6b/GsUu1v5GwYmfO4Rbxw=;
 b=Utci9CKusG8vT5nDQyFGNOADu6NbzX9ujrXHjEkKosWRv2ENGyZVcfZfvbUPv4lqfY+i5ofcSuQCgrf7Jrv0Pv4HhPcgwsyAUTn+mefCBiZYC/BGXq4wT8gLI3qBHXcEfi/A3xDCvwO0f5GJUgA+S20fNk3dMkUOBd0ZC3d9GxRyqFwKL5U56/+FLCk3oqvPDuC6Mx3bQY4p2/vWF0wx8d4otMBT1lBWL6DU/p3vE30BDZlzmAI7gcxXAytimjQf2tbaGQxAayt2CmCUCdkHYtuangYpy1ce5odXsLO82SN3+Y6H2TtIgzDlMSeU10oomU7IeSyzdFdLXKNssLMRXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxzyqnMqVWcls0UcDrE4oX6b/GsUu1v5GwYmfO4Rbxw=;
 b=nx1NmRNgkEUmqHbPNiN6N1WZRPeoDBPmRBsT4SfqILvkgMkHRcfBAvv9s4JO68AfbwHAOE42pjiqwCsKojBGwHm97ZafbJzgz5noFlskLQOp20ILPmQSt6uD72OxiSK22hJzChiCK4LkqkxyWYQM8XjB1l3ewRUWBt2dVr1VW3U=
Received: from DM6PR03CA0011.namprd03.prod.outlook.com (2603:10b6:5:40::24) by
 MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Fri, 31 May
 2024 04:35:26 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:5:40:cafe::80) by DM6PR03CA0011.outlook.office365.com
 (2603:10b6:5:40::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:35:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:35:25 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:54 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 23/24] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Fri, 31 May 2024 10:00:37 +0530
Message-ID: <20240531043038.3370793-24-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bda054-1237-4f32-9299-08dc812b179f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|82310400017|36860700004|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5RS8HSc2E/OCDat6Rx92pHUuBgv/kMmsGmELsphdOqEnygsQaGBPgy9MTUOY?=
 =?us-ascii?Q?DY61ZMVrLnQayJa2gl3G5S+B7r4390eACezyIH7qJJBV6JIlfk7dzVcuIO8b?=
 =?us-ascii?Q?TvDy6z4HtJ5uUMeN8VnUA7vLt1GIKBk+b3JTKD9R4ZtmVuH8ydbo0NxXIJ+s?=
 =?us-ascii?Q?W5Tn3jdwof1ZsKwVYAftRTVJz8TSvb6HUNs3zTzQG5OivZ0GYfGTSrhWfHsh?=
 =?us-ascii?Q?sCwBtwhkBC0a3VJ+P1gdUmzVgZC7lcfqN4oXb3SOyGtqufEca5i42aTZnvpw?=
 =?us-ascii?Q?7mLfq+VDnRTF6uewnVTxTD16TGEecAE+qWKnVmnz+EPTzzya+fZDp9vErVBc?=
 =?us-ascii?Q?q5260DodOygzzxnPkIS4RkAzBAm4j6Hn+Urv7X2GHFJ2ht5QMXOS6UcpqvyG?=
 =?us-ascii?Q?e2C9GItYIllUmyNU35UuK4XMVg6/nNeVPt2A59NuLO9uufCXNfC+iydUTwug?=
 =?us-ascii?Q?0dXRN49crvMRuh7DFiwToiH5XAefeaGDHnmb1KbucrqTAQvA1t6p7zrg/GRO?=
 =?us-ascii?Q?7rCgcTatlZ08zZHgB89vKqbAB7UX/1xAOkulhlcTc+NDbTWHLzNT4cP0CNoc?=
 =?us-ascii?Q?ZU7TwXgimnfu8mGWq87D4umnQzrnpRCYO0hmIW6UUgayXaXXORrXafRIGVUt?=
 =?us-ascii?Q?6c1XIC0DcAWsNqJEjWBBlcSdUaffGmXdElM1tJZJyirTsbyuSwHdnUVCuwGF?=
 =?us-ascii?Q?ieXIzWN27f5Naa8Ae4z5amD7akaoUblFzaF65M7fClrOlsxSmrxYIDPlchnu?=
 =?us-ascii?Q?PQQGkVTUcADnOi1AwNWdbKMjQIM0VXXmxwfzahfQdc6KMq7B/klc8Gb0JCA2?=
 =?us-ascii?Q?srQJIlgrBjzEbusA7d+CCCL8aX3T/0u/xhuuu5rqfYlGixPdqJb1hAa3umPC?=
 =?us-ascii?Q?PinrYdzckOIXq208OYW2IXz1KKhMtaHxBEyj8sXzmCk8ALOWObwVAwZs0Fz8?=
 =?us-ascii?Q?9io5x3RhYG5fjTjMAXbTWo4/26Crs6VxMvXoAfkNPJ5HdClXDBnOwCE69Il1?=
 =?us-ascii?Q?mlwio5E/DE/YxacXMIYkmV9mi0dXP5raFrCUcIiHQ8UYXVmPVPzpoqC8uPAs?=
 =?us-ascii?Q?NcOUlns5I6SMKH75CkaOJxyEGqlfVAgQz6h6gFj9P7y+Ici5jIj4XmYF8x1t?=
 =?us-ascii?Q?wDOAYi8aRDsD2zvrpMwLYmwq2/lNUZyBY7T7i8WUFlwcYRS28j/FAo5061TT?=
 =?us-ascii?Q?XnEp58hxzueq2WfZ8sox6EmAtN/74Xvjp4vEYYvGrh2DNqzH7nNhaRwPXjd6?=
 =?us-ascii?Q?bgKs7YqksMqPeXWGJnBlABn/xF2j90Rs4ocFosIS+T5sraRQDKs1Ky1Uboiv?=
 =?us-ascii?Q?VFskwse0dWgVvmDY5UKirC4k0Z0iCBYTgNrk9g1MqnIC1zVm9M7Y474ZPhZS?=
 =?us-ascii?Q?bEPeQy7O6/PtGtC9ntiB3J1flJWf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400017)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:35:25.8897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bda054-1237-4f32-9299-08dc812b179f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

When SecureTSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC need not run at P0 frequency, the TSC frequency is set by the
VMM as part of the SNP_LAUNCH_START command. Avoid the check when Secure
TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 44df3f11e731..905e57ca324f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


