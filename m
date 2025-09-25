Return-Path: <kvm+bounces-58725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 41407B9E94B
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E9F7E4E33F3
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC49B2EA464;
	Thu, 25 Sep 2025 10:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2tUDVekb"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D25A2E9EC9
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795088; cv=fail; b=algve8BQmZdHhbk2kp99uHT8s1OstM8mzmsrdilpPueplQkS9bYXi5pYY/0/Ljw2zFXIf0RztPVnvTGOc7R7Zy+QG5uq2qygSg6j7tKiJCw8YDnzgbPm0FqOa/VQTCwkHw+V/bLNVTHT8WijwactCHf/Ltb1I8+QShqHsMNOpPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795088; c=relaxed/simple;
	bh=R/5zQqefUBSyilHcQ2z9xnMV5B7Wq5ajL0xHmzuHpig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvBb8Hzgg7Q8RRxUAmYQ0FMX1mFU4YJNJhJk628P4qgcErEdaCArcqTUn+D0beOqAfWjXmA4SaGGg/6oVa8LotPjILPzY9GXqi/PIOg09X7CaG2G8nsMUajZ/9z+RirPq0I6LOnISJZEUuJjyIXc5bVMP+sf3+gcU89dpc39W0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2tUDVekb; arc=fail smtp.client-ip=52.101.62.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UWQlIJwwHRzlicLMg88DERJcBmxqnpGe55GN7CUPSc5/MgABJQLlRxO7p1Tn6KAOJtCszkVnhQX/dC3YgbI5+TW0F4Xlb+W+YFhVq/FgZWZG8djD1k5Cyrnapz0OtADdskGPNy+qModDboOYk86BUNhWPiGAnyCfvywDTaftvDZMa3G4ZAvZZyPmh2frZ/3Bqo5UOjDzcAjb9g4Q7uQWUfJDmpUO2ObvlUM4/lExcFLVtddF3Mxrtyv/L17FjPiqB7hM+SXfZyIJsGXhBqyjYbXUDFo4ezvCjqTf5efjybHMa4QCaJka5O0XDAH3IF17dXM3VGwb3K8Tww/LCinlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2jHYsfK1tfUaAPw1ldo0aAcLMmOE1vjIJq0Bc0NA8o=;
 b=vz6TUely+25MXoY1xVxjcULYTp79q4ZJqs0jkqlJhT4+0uJPKw+E/Q4mAHqfY5ahUUESNiSwZjrdu5fQxpAoLmK8zyk9ErOHRtiaXyosfTE7mGdFoTfJ3U09rE7KSn5KFDPbxGpRsSqA57kqPJC3KS1GotitSLpvuFI8rwGoyOqhEzGTNDcSZ/xCCjMSXQy8j0dzywYWiAOimcSbX134oNY+cuUZ3iOt95r20utD95mHmLbfwwwGzFN8iMuRkVt5dpbv5uuPAnxMy9JYU245U2uZLPlTFMLqrGTkhlg6w6JW0+kZ5qDjzmkB0c+OGVyDv1EW+jLHxblX2AZFlEIqTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2jHYsfK1tfUaAPw1ldo0aAcLMmOE1vjIJq0Bc0NA8o=;
 b=2tUDVekbDjxWPgv93vesPqizfhalarBird1sP4e48rDIZtbWNCyJy5G7eU9iy+spVMGuR6dtNLXEaF9Yp+GDMyk8BaqauObYV+kPMBfm2Oc5qA1qHNKatFwRClW5SbNPYnerflYMFZRR79M3WVDQZurGwAYO9C8hUMmEvFiWl6o=
Received: from CH2PR11CA0002.namprd11.prod.outlook.com (2603:10b6:610:54::12)
 by PH8PR12MB6722.namprd12.prod.outlook.com (2603:10b6:510:1cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 10:11:23 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::6d) by CH2PR11CA0002.outlook.office365.com
 (2603:10b6:610:54::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.10 via Frontend Transport; Thu,
 25 Sep 2025 10:11:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:23 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:19 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 4/5] KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
Date: Thu, 25 Sep 2025 10:10:51 +0000
Message-ID: <20250925101052.1868431-5-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250925101052.1868431-1-nikunj@amd.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|PH8PR12MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de0b392-50bf-451a-0afe-08ddfc1be16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S22I+qOdlGg5mT3aoJ1iRWEwFFWOPbM5ok78m8kOXNLR+IMMBriyL19Vms0+?=
 =?us-ascii?Q?6XwuJD1iBcqmoJ6DFa1LNBUX3X7JjfmMDRjjAtjwUbb9TGIAGTr2P77QDT+v?=
 =?us-ascii?Q?JPALifZO1lILbalqxPucVfenfvaX1jo/ONqTfCTJHi5S3oKQjnb/ftsI+tm8?=
 =?us-ascii?Q?gUR94yKLM+Bqutnb0sS4O2JFt+qabqSlK3bJ53hdpLOpGCNrEzS9mQI3SJLu?=
 =?us-ascii?Q?YfQhy+fhbkOkASEaBsdNhPrWeYX4mqCLADF3bwaQKvCf/cAMfZiDt7MME36J?=
 =?us-ascii?Q?vgxwcNfq9D9MWIhV5ilfBQfCuypBQTEDHhT30yX1ADuS4C6S1e943D/XNaAN?=
 =?us-ascii?Q?ZnazEkk5M56XH6BQk0k2AEuQsR59xLrdlMgtjPhC0kI0lQxvAYxnAU68xPZv?=
 =?us-ascii?Q?cJFXxrb7KUqOWqYFMONgsT+eLjEOQup4Gr5lvlEVRB97NI/tWlWJknruDvrk?=
 =?us-ascii?Q?Truwzz+aYDfYKnaD6NaOtJEQPGNlmqSr02FLjJzs7SDc55iWKio0H7c+dyQ0?=
 =?us-ascii?Q?F7y4COjTpd5l4SeDc5YdyduwNay0XepzcSqDmpY0Imu6obxxXocegCemFV/E?=
 =?us-ascii?Q?Wz/Zd9YmZ2opWv7JNnqrmR+vKNHa+cbfs1qHjYLXjPMIeTgPEAcz/YAELpXl?=
 =?us-ascii?Q?nCIsq1W5oNvBeoejBaR8pC/MMCHg7KPpNs5boFaxOubAxPYb4fa1tBtVTdy2?=
 =?us-ascii?Q?y5AwPRjPouUce4eVOaBpP8n2G5zijVg9U2fGczW+3+hg3WRrwUKeOO2xunUl?=
 =?us-ascii?Q?1a8K4siO9dryrz1/2Jeoy2g7pnG0Tvsi0834G7CUG6hS7SLltvRdbiZUQIQB?=
 =?us-ascii?Q?0vWNzyqJnVCcy1mjbu0hJQAz7UgWrlPS4YCgZxo7w1Fy9OuaGYI7NARbAcTf?=
 =?us-ascii?Q?bzCeQRmLZHob7BW7qjn3QwdBIgoJBL1AdDfskZ9S23ogqxTVybbH0GLdMPAR?=
 =?us-ascii?Q?llKWybb7zgjVR9MW/n/fm/UxSmbdCzMKDO9f+jst2K5AOCzB38ex6WhtgsHd?=
 =?us-ascii?Q?pXlc2/UOGoDdcqI+ZUMKCrgEkHQKQqzzEyMMPTlWNgQt/Wopej4VFiMzDJnt?=
 =?us-ascii?Q?BJKx5E0wbfzwUoNANtZeKIa3wVssdzC6NwiFcl/vrHgMKqw9131UyGh4mH38?=
 =?us-ascii?Q?v+b7/rXjYb01Vh2taIiYX0RCrqY0zTmLKHDBPokTF7ZBd+6rk1F1lTkArTGc?=
 =?us-ascii?Q?4ZIjMZPii3bbQGl2GyrgbMFvcVxymg0nnpT9BzYXQj3GH4FigvyuPS51gK/I?=
 =?us-ascii?Q?289AT42Fv/dIB5SNEnqUmS12lcDmYzNf1t/DtdW2iccgrJclr0O2LKlGI2n4?=
 =?us-ascii?Q?DqLCtdQ99OEwp/hWTqxhJOoH+jaDlAkVBsIV6tAOAACdA84GrdHGbKNfCwYF?=
 =?us-ascii?Q?09OagGmNV4z0dOrmbvqpiDkOg/7RwwkVImFeZDg60EzMWc2pr5nGmjTDeBas?=
 =?us-ascii?Q?eTSZ6b2xGh2rD/PUFvrVU9Y4THiN5OlTq/l8A8API3IKz+MkUT0S+iDOuRkR?=
 =?us-ascii?Q?Evh39p0L4B72bQ2wWFfqOb0ZuwHBcP1MnUor?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:23.2081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de0b392-50bf-451a-0afe-08ddfc1be16a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6722

Replace BIT() with BIT_ULL() for SVM nested control bit definitions
since nested_ctl is a 64-bit field in the VMCB control area structure.

No functional change intended.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..e2c28884ff32 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -236,9 +236,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CTL_NP_ENABLE	BIT_ULL(0)
+#define SVM_NESTED_CTL_SEV_ENABLE	BIT_ULL(1)
+#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT_ULL(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
-- 
2.48.1


