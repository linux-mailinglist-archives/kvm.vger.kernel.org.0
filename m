Return-Path: <kvm+bounces-39256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADFEA45992
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9125418997B6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36817238165;
	Wed, 26 Feb 2025 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WW7iXPHG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEC92135B7;
	Wed, 26 Feb 2025 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560952; cv=fail; b=lymTCHWJh4fEg/sYYzRIhDIBZJPzifYOSDC/oaCAeowB1XZB1ZYOXr7YRVO6W5E3Z//UABUOIJB4+Qg1DD7g8QJqjnJhGdOix1tWTBdTDGzQ4DCQXpJpTLaDFIeD4NyJQCV2qKAhV3+7bCOGrU2Tuh1P6XVsU4A1Scf4sqgCtiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560952; c=relaxed/simple;
	bh=Adkc41nKKcUzv6S93hYXJBzmPxwEoPAjGiwiw4cb8Es=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9NNvehK4Y8uwNVlD4/krzKgxLfD6Xfki1DsTEnCY9coQZoUneE9BLBEE92I2bSRL4IRu6V/Uar/UNiep8+sSj+buIjOokm82PZ9s0Ln1/DCzPjD0AzejtnViQasgsZaotnW0pkruuttpk/hAPbvXjV5DcOMm94bIXZAQIz+9cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WW7iXPHG; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boHvPbbtpSYhGYAzo5kgO5sZTMh7b5D7W8h99MS8qucTmKJ1/jgcBxdBuZwNtkXGJOpmDXR85ER6Igo5QtLiYFrUSDC820nuT+Rk/9S01zd8VEuCZ9WuqB3UZ/FYwYdREJkt3Z2swGb9eJahf2o5XIIWkpNEoWRBCfJoRkMMoIsxISeRGoIpNDLArnwiobBJZTsNHJdBe1Gu8PWHPYgCDyoGOyKf9dLtNyCVQU9kwqsSx8XX4e0NyJ02BHI+7T+K7TxtqNOJ74B8GdCFqIIVD2uBuEknQ3zzsgeB3ENNaW2ycfxC+n9x8h1bu7QvEC8oeWmxYr7wUalhJi8FEzHVGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbHN7887P5jV1fLbLmTagSeV1hOPIrcrTM8OzFtOvN4=;
 b=oa670cUFPRdPMwLZ2MDxt0HRp9PcYjJ+23BUfTy5rzFAqEscB01HQA1Fcu78dwLowG0J0qkYL3ytmr8Fvxo3ZEboly3GLtwMRaGy6EZJ1BnsfMEwQ4xGSWK5hBDwCj0obOnFeSf6Wbjsys33nKC/43YGJA7PqShhPaOZCET16kT4gxqyAlcL+Sl1EOqR/N1WJHarpHfwd6+NaebPCqnPY1ayUQgdYDohCCnmqKYi++dHahPWXziF3kgrlIlMqmOgPGlG8B7DLpINjWU9W+dem/Z3jpgJx6R8LeMguieeP/4ls6sxyoeF8FkCypilCPU/ytv5M6wgZvJ4lJuTHD8f1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbHN7887P5jV1fLbLmTagSeV1hOPIrcrTM8OzFtOvN4=;
 b=WW7iXPHGot9yqCe1r7PD7iCcjAxXb6dfmqBJXkVhugBrHaQqLUgQTVm8eq/yIuTsgsZoeuaMGFxVinhpkOPdFi6xGMtPcxWy29MdvfEmkI0rllFqjipcpts8Gy+3cGv2KhGgfSmcXrimEAgD84bq/aLBaZtkGdZkX3VFfLt1KQo=
Received: from MW2PR2101CA0017.namprd21.prod.outlook.com (2603:10b6:302:1::30)
 by SJ0PR12MB6878.namprd12.prod.outlook.com (2603:10b6:a03:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 09:09:07 +0000
Received: from SJ1PEPF00002324.namprd03.prod.outlook.com
 (2603:10b6:302:1:cafe::4a) by MW2PR2101CA0017.outlook.office365.com
 (2603:10b6:302:1::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.11 via Frontend Transport; Wed,
 26 Feb 2025 09:09:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002324.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:09:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:09:00 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 11/17] x86/sev: Enable NMI support for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:19 +0530
Message-ID: <20250226090525.231882-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002324:EE_|SJ0PR12MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 446779c4-aa1d-45df-7cdf-08dd56453939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VgsGhzKNXeUs9U85UOwusNUFgbxsBfK/e+ITxAL5IddX7vmA9YtQ75/FvpaU?=
 =?us-ascii?Q?cL8KN3wVesW7aCZqwWm+n/CHJ3YF0xtm6kxz+o6bdS1b97JK6Al8a00iqgbA?=
 =?us-ascii?Q?RdWAwDcwgDCYP4jjHyXEbow+2kCxLPRpoGPzsw6xM/AjnlQ36/oOtKY4eEDq?=
 =?us-ascii?Q?q6d2/zMXYzU3T6WqleMNMwIu2x4HEESz2YKfddwmGaPJ35yoPFUcvVrxO2kn?=
 =?us-ascii?Q?PCS87azYr00kYeq04n3TzXA/nQ1B2lkVrG4cgE/AFsd4WiYKLQ8FZyin0Jb0?=
 =?us-ascii?Q?/0mWwR4zjcVahl9zI3D2ruV0dU+8gids4Scu9Lj2JQwlulOZ9/k/XAf2H59y?=
 =?us-ascii?Q?R6z6x88VF8sogLJRFmmNMYUsZA9+iJ28ECq8GG1BJ2UYLkz/jxGnYggRUOGh?=
 =?us-ascii?Q?ccPrnMH0grnkaOtjJJy8d9Up/MDco+2PdiZeZp2c5Fh7bNMyIfvCh7UyXxxC?=
 =?us-ascii?Q?mPmontTNWF0sDsjBg+JE60qz/VVA83RwTSg2J7bNQyZHVZYJ2TcjeTxOC7hk?=
 =?us-ascii?Q?NI+9fM4yzI2yt8dKwfd8v3ZYcRy0+aE/EdtVNX5j3+CVpS16uvzB7euHtn1Q?=
 =?us-ascii?Q?YCpu6AWalyVX6z9wKFsG5lOsTd4xMT0HiGP0UrhuBab8eSO8lYXOLqsOcF9w?=
 =?us-ascii?Q?/bs023L4UBw+9uiECPwWII6ElvtiBfKBLekFcc1BQ78a9NlwH70nuQTpnusW?=
 =?us-ascii?Q?i6jY8K/g+uAy5speN7J46mu08X/cLXKnzvPWhFBoZYO6XjjVwQ2ArYzVxfSQ?=
 =?us-ascii?Q?sEPE4qLXISpvCVe4wgbggn0+uckS9MX92d5VZzmOFuWKBoA+1jfbbH4lgEbx?=
 =?us-ascii?Q?VRbEGIG89BWylPXAdGHl7UbrDjypPjU45bwo3QUK/LOOdZTIgdGq3hj9+fCP?=
 =?us-ascii?Q?ByHsy9dAaS44mIpkiqwmk7l6WTqUX+eECUjJnDeS6IdmNfK8eIaXIQe0SheV?=
 =?us-ascii?Q?f/95HfUjOfRtGQ2clFiVCAQKF4vGCbdF6yh4r64hYmLLAZDYhIu69ospb2Zo?=
 =?us-ascii?Q?IMXkGCNIbRj3ccu7bCtj6Ck/fVPW5Ge+ekIAI6aRqRTCVVn3qKgeZYyDfAjn?=
 =?us-ascii?Q?NDvLE6T0EARt5U2XvgoMob/KkB5gUT4VYv7zK8siS0Yt2Je1JpNIUVUcYt4f?=
 =?us-ascii?Q?wuzA+1C5PAfTp5ih8XUQ0I1tfAY+5Nq0TwSsZyaVz0mwTAzB5emxhC0Nvdaz?=
 =?us-ascii?Q?Lph8q/g3l31Mt09ktGyN9NR7LMbgq4SNs9FO9CeyVTAfO6UOwj6LK6RPobV8?=
 =?us-ascii?Q?dUY7RzytnbCtXMBK84506GmoB/1ZXYoHP8pENTy4zc3YdgNbNj8maeoXxd2u?=
 =?us-ascii?Q?rQBibUQjclKE1gVnyOGa73pKzZ8NLfCAGk5bmdBhb6SKz4jxCGaaLuV2f1M5?=
 =?us-ascii?Q?WuQSAkG+/sPel42xr7nTQPEl/E4EHmnxJW6tY2/cUctGwRqRI7GOlZot8WE0?=
 =?us-ascii?Q?1KppQ6106pYBLCsMJBKTYqD43XGCp7a48sG4HsMzQI/4Kfnc495Mlac5svzo?=
 =?us-ascii?Q?5+WjOnz/mYUuXZg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:09:06.7716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 446779c4-aa1d-45df-7cdf-08dd56453939
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002324.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6878

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL field of
VMSA to enable NMI.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - No change

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 8a4ad392d188..248ffd593bc3 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1273,7 +1273,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


