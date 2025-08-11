Return-Path: <kvm+bounces-54401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8DFB20470
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EBAB3A50DD
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9438229B1F;
	Mon, 11 Aug 2025 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SfO+Lbsy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C6E3B29E;
	Mon, 11 Aug 2025 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905788; cv=fail; b=blynAqCUE84EFFv+Yo/kJgDBH1Fz+tpwn0OFk6R4bM7OErNrEvvjhS+VfYS1AgPLwRIg7utPQjuaLGLOBvjVXmFH85tlPGlt0D3tJMWXGWBG4ouLByBDvq5Tprs3K8cZbSI36Sls16ARiSzaMSMNzoKWUcz5US+G3L1qtMEBlII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905788; c=relaxed/simple;
	bh=xU3PCyXN+KtMjQ4ke7W7xd9TW77clXw64Uj6s67um44=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHsf+MuXnsx5Hgnlw7HLQTaez+2X6AQ09u0SkAuJkxmWmo8FTymYXzRhBsUoBTwWmGaKba96MF8NHLklrFc7erEnNBy1V3bRrl9jIrRjJXKIa+QaBIqN2geZCog8K5bKwj5rcZU/KcbrJFZEQUNygVKjqRgh2D1WabxqkXWP+/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SfO+Lbsy; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyRTxi6vC4e2csXTbCtSD6FC3QzyklRP1vSePPod30oen5uRnBp2jv+vAnuSPkzvsydH11sWfzeE0WGlB872TfNySgHZR/x9sXkEwtGZ5dHpropLHXCDTrEu8txUgejqPVm//Y0rHpej4EQEYlr0lZxKDYQcAcN+DpVe6X1hi+dHZMacxkJCvV6DHxX1huZeiKiWEfeWtGbZEcOhhnNp/HcK4KpLgANevB2Xg5JMh+ti7IXEeO+7kyzumuC3KTfOsrzPWo7TuLlgsasaW1xLTe45a/oRMqtOCI7P7ww1/k6VAa93XYGTVlvJNqoQDSUp/uWElBphjM1cL++bdl0r9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOmlt8yz8he0rJDvlyeLxO/cu9fb63IVaNJqKEUAj+M=;
 b=a6QWKCRG/Pv71J2a7sZBo3VmRq3d6saHRnSB8HPiAP30MPgqCDRno4Y/CqTmWdaggIR0Q2oYsCn1jdFGuC59HsGxsJhbwh/5uoMBWzC5Gy7tCPJnlxBwDlypGwJBKgDyGZ8oHvbkhcrg7e16e/v9ZPLbcB5OgMcpLxUJaQhp28TXKG/tbU/8+7/jxyRRkjLtyPvcpruzYtFfBITqhgWxa+Emsoa4pckCioUmlv9op6yyXQWfUabbio+Vu9OnTOue5os4kM6eSKhraQ2Yey1koHIvxXLI/lyk6KfIIq11OTW+aMiqIWy3/AH11o25w59bhG7W1esZK4bzbDmIvK22xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOmlt8yz8he0rJDvlyeLxO/cu9fb63IVaNJqKEUAj+M=;
 b=SfO+LbsyssJOQhTkvzoEE0xHlYsTd0nMieoVRNxR9rQWJvnNuRmyhxT6bYgRn0ZOgdbCKF+RsScFEOf5tqNkCwDvuLwiy2BteuZBHMFtLjFPiPbxD6aanx3M/IE9h2hdZClHFwAfwVq6Jlh0mbnQo5OdfOhtr0IDK2cAVs3B8Mc=
Received: from CH2PR05CA0069.namprd05.prod.outlook.com (2603:10b6:610:38::46)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Mon, 11 Aug 2025 09:49:41 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:38:cafe::5) by CH2PR05CA0069.outlook.office365.com
 (2603:10b6:610:38::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.13 via Frontend Transport; Mon,
 11 Aug 2025 09:49:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:49:41 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:49:34 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 13/18] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Mon, 11 Aug 2025 15:14:39 +0530
Message-ID: <20250811094444.203161-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d4d66fe-ea7c-4f7a-b395-08ddd8bc6512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hjSJB6fYSYFdU/xnMJVTg3Ca9Zl+Gccg6UQRLiUKJ3l85uWrk3Dwc8VOrd6w?=
 =?us-ascii?Q?ktKktoDjiu1o4PLic3j6/tjMS5q0dy3EydAavh4EWo7SNmXQrxuq0GZ43/Px?=
 =?us-ascii?Q?bWEm2rtYD1xvs5jqS2nnI4SZR18N+kermwBFfRcECj0KhDgScBRTt9nlSygt?=
 =?us-ascii?Q?4TH6ET9KDSNw74bdbvFhePYpdsXcrTcDMlRhZsR78069amkCC1aEZJZEWXEJ?=
 =?us-ascii?Q?Y6lVomdlyJTDmb5i1DdWAgEDxkUFtVPbW2ZFdPd3MVBTwT4CztQONQvXA5nC?=
 =?us-ascii?Q?pWNhiGW0SignzDr2qQ3yBoPCJIdpimPRZv5xMjROVUWrpW+ZbrFHjmEbQuv4?=
 =?us-ascii?Q?OXnBwKum6dvWgxhwpPOcTLWFgmhePmK9khXCFW/DbzwtjMMdY0LCB6nCwb7h?=
 =?us-ascii?Q?TItO4nYYBZCDjv3dwjmAQ2B5sLJlUUCYkXzLG8jmAzALg7x/s9xoDh9P1oQd?=
 =?us-ascii?Q?6sEW4JZfGj6fhyVCovaS48GZsb2BOVNQP+q5v2AImOb3FO6EOF/rgeoWGruj?=
 =?us-ascii?Q?OsN5RLQwqPJ5VZCHorP5vUttyJIsn7GiYBsv/nMck0zNWPi6cOR0L8uem6Fm?=
 =?us-ascii?Q?tNWJazxUi5uaFMZg5Q1N4AJJ4x6YgAmZVxwCF2uZagtd/uZWHYRalFFYEDQR?=
 =?us-ascii?Q?IDeg3etwwCAt/BgY+vN8iQNzFH5fi+974AEYehdonzbpcyP6suFgc/uuNah/?=
 =?us-ascii?Q?rBIeErlQOtW2IUn+mbxM0gNPNCUDT4MEtG+KJeuvRqLbHdrbii25Wh1jmAy2?=
 =?us-ascii?Q?fcpx6DR8UqrLQb7yKKX4Qys+NLTT/MXj5YlWu0fCXQiREh+dgPcUJ8l0+MzS?=
 =?us-ascii?Q?r4pfBlSFpk5+H/Gu2q0ckJizkqtoEatoqBju1qoMK+HW+tdlUmaD+mdZcgJA?=
 =?us-ascii?Q?5mg4xEjtvBSAxYQTvNJsFOb2E7gJYYvWoGYCzhmAUr4AHWtm/ZuyEViMB09B?=
 =?us-ascii?Q?Nt7sn/yKjTJDW/WElc1yhW4rTD0UoxJzLmXQyuoV4izHJkpCqruBy02wQuoH?=
 =?us-ascii?Q?IMUVkpIy6M26XY2xz2b3lRqp4Eq3JORAVBBqE8Lfd+LTaQhwDX3Fa6IgNnHA?=
 =?us-ascii?Q?VW24vn66e2yrrI+E5jXFAV5F2B4lyP5Df6FLn6pGWoKjQi6q1BpjJwuFaeDa?=
 =?us-ascii?Q?qnpyXV1NbW9iC6kqeLmHXQIx1u+V/rf4Lj7HcrfTToMnqcOU1IGK43z6K+iw?=
 =?us-ascii?Q?DvegWF9+jOzvDR+n3m3TIuoK/UsB+fdJzrkkwCcZRitfHEyfIB1xEPSkedtf?=
 =?us-ascii?Q?FfKmxWdWDY0FPKtlQdXxItz2eAUMNZeOOR7fe1yFnjPxoGNntwY1yAZnLWl6?=
 =?us-ascii?Q?Rc5LX5XpJWkgFnTaGat5c20WHFlEetWoaGYVsSAU6xGHhShzcL+ydkg365AB?=
 =?us-ascii?Q?oE88jZ5KOerkwvmF3WiWnYBXE2BHtxDlC1/QlFnt/7KwphbgktMLifrXys5g?=
 =?us-ascii?Q?9abYuDr79fcErvlmObjCK7vmHOMjJYlJK6SGfMyBhpZexuja+SFAXRqLNJFB?=
 =?us-ascii?Q?P7/yfc76UGcsL04m7BraLTjHisOzW5Tv52ap?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:49:41.7117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4d66fe-ea7c-4f7a-b395-08ddd8bc6512
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2bae2f711959..6012c83cbf09 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -71,6 +71,11 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -80,11 +85,6 @@ static u32 savic_read(u32 reg)
 	case APIC_LDR:
 	case APIC_SPIV:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -201,18 +201,18 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


