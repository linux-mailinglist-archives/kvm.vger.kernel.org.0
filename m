Return-Path: <kvm+bounces-22789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 125939432E2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE9CF282325
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3C21BC097;
	Wed, 31 Jul 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JZIt4EpY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C4A1C8FD3;
	Wed, 31 Jul 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438577; cv=fail; b=MYF/ifY3cxu1kBSqWrr6V1RVNajQ60OT0ePQ7YLpD0YBeLIel3xwOuI6Da6v95LepNsdjcSmKwCTq9fVXvL+2ltq9CjZIBjKs6bLb+RjLc1R050HpFVarbglb5gH7rI36OnKVvCGmN9njQsI92vwEx3HYSMVwC2NyTXAwweg0WM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438577; c=relaxed/simple;
	bh=cAC/VFJ4wEnAQpkNDwUveWrurfRumjkFBldmm9DGTEY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLiuhG9AsJGSRhuB9rxQ+cM7W2CtSRu9hJjAdn3lkGESMixSNk3rNJKfap9qMW/a8dIvVshqXSzryBmO3PxQbBqCoVTSX6FF4bfYvTtQlpgqr70GwwsG5wm6oUHTU5UrQwXE0q1x0+sDvqod0TansKee1uQb6MSo9jwIsPX0N/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JZIt4EpY; arc=fail smtp.client-ip=40.107.102.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gbsir2laVek9LdC1gRLEALCmAoA3kBxPZR0Yfk4DZONaHNshmPadW0fuBm2lomeSrivf5WzsIoqfoDnlerbWiiw9fPivFzOwVRTIxFC97TM05f4cq3Z7veBR1xGr63MHSbeL+J+CbVjXZ2D28MVEkXJRjZpmE0EzLMfreTLcZwHmc2Tcam38zCeTkOvaZIAYlOvhNCeLiWlxpMeeLL0iSrUzOI+T8Xw+x4p90B8NHsGeo/qy+v1yL29IWQLykIMXpVPryk8vYsJ8OrCd9ZBd/U5LVkDeL1AWQ8TrmYrd5R6mqDlzv8cptLJMKEMbiNQyzVoU7bS4kFJ2fTXdvjk2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNKGJqPN3gcI3Ygqznh20qY8AnS8F0rxhXhh636gblQ=;
 b=mXuqURDUBcKj0NBl1wgY9oUf5PrepuvbcfZQKmPCvDD43iUdRC08MLF9Gt8wlST+u1kyeoDEw4DoJ0bmnC8jlPjVYSiwTkDZmj4J2AmQZHM/5bNc9QKhpEgoBK8a/rDLKR5fnNt9WR93nTUQLDMe5YKQe2D6xbA7jqpet6kBo8O09UdCINHcfa75jiubJM91045xz+O8++sATfPEGvJiXyszDc4HxAQjYTI8GkFa0T4l2JTvcBcr1ysOOOxqMOK4UgRKauzuNBOU2qOXG4xjpPBuHUmHUcN3qUtIjBibTkUcNqy+dwsN24ViMkXelb2ad5EdySlu1L7Zg0ZqjweOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNKGJqPN3gcI3Ygqznh20qY8AnS8F0rxhXhh636gblQ=;
 b=JZIt4EpYqzOS2mFoxBvnm/OKyEPHmJMDn0YRbU/tlfJgmhlbl+hAEDGKjheDBI/rgqUjQw0c2KRZgPZb8lppFLUQ8+OCX0RomDlRx0KAtcEwF0yE9NYsTReVdk5vIMdbqd2LPnsWP7pr/cfzlOTs+fz/1haPPa8p9/wTxfI/JT4=
Received: from DS7PR06CA0034.namprd06.prod.outlook.com (2603:10b6:8:54::18) by
 CYYPR12MB9014.namprd12.prod.outlook.com (2603:10b6:930:bf::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7807.27; Wed, 31 Jul 2024 15:09:33 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::5f) by DS7PR06CA0034.outlook.office365.com
 (2603:10b6:8:54::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:29 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 17/20] x86/sev: Allow Secure TSC feature for SNP guests
Date: Wed, 31 Jul 2024 20:38:08 +0530
Message-ID: <20240731150811.156771-18-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|CYYPR12MB9014:EE_
X-MS-Office365-Filtering-Correlation-Id: 9887e7e2-db4b-4c7a-fc82-08dcb172c912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9IgiZBd0jsY6iRLaDRc2M7Zo6XLbmEdQ+lQyVhnBZBO0zemVUV8j/mmLGEN0?=
 =?us-ascii?Q?MUVnSwbhsydHA6S0KUiK3XJMByOLZawz10UmRsLaKMHGgwnyftLaLpBnmt3x?=
 =?us-ascii?Q?ep4/FbgaYrkr9vgSLbKpsfCrTq26SGIFUy+9W7Ds9MJwYF37EV1IKc/bLJ4e?=
 =?us-ascii?Q?qDO8fReEmGgeTn7tJAbwbeG1iJtiZmqYn2SsjwHI5047Msz/JmgrAYLQLd+c?=
 =?us-ascii?Q?kSYRuJ/6waSaT1k7Hv7nEvD05tB04SY/nmOkif/6xhRQhnywt7pna4Mix7w+?=
 =?us-ascii?Q?1AXBpu8HS8+qZegz08g2WBzkFgLRBrmbkR57elryoLsNpoCTzcwqgtG47/8N?=
 =?us-ascii?Q?VILm0A3iuRhvjSLTUqHsu5UAZiyY+Pgy/GXJnbFw2q+I+nXJdW+MVaC6egrJ?=
 =?us-ascii?Q?XHmdBSRqziMAZLPVjZuAg7tuBaPMTxi5cKo3aFRILUjEO2Ct6yGeF7RrW4K+?=
 =?us-ascii?Q?iHSdEx0/wQdNqxbGSHx0xiDEXQjpK+cqOcUB94BtTI91rE5n5Xgqa76hiGqa?=
 =?us-ascii?Q?OISFATa+zJTlF8JdCVZZTR+bjzks7RSMvHtCEc0jhODUIj/uTJ9nVp4h9zbW?=
 =?us-ascii?Q?YBVYDFGM8DQFVk+8pyjwC3H8Bf1mWyx/idMr1anIyPOdOwSor7qtEqXJzmpv?=
 =?us-ascii?Q?8LN1pBLfXSYKhKVIgImR74W/8weT39KIzuH2+TEZPk77CtU/NbrL5rB8891L?=
 =?us-ascii?Q?LOQGhdvOloVsCdv3020QKhQZgtYydcFcWBvfLCDuH0rQRFuzuDG9Ripwak0b?=
 =?us-ascii?Q?3KYKqERas0Gf3NUATQJ95vgY8xsBAUfDnXIQrNJBzUan/qOJkBsDC5IdijS5?=
 =?us-ascii?Q?W9EtPn493hHqF1UoBH3+uhV1Iagv+zcQn36hPS2AYBznJ+ZeAvvNnj6corV7?=
 =?us-ascii?Q?l67u4yYVHfzQCauxtoXU+2cEqdnDRr7OARD4XWlx1Jug1csKTXF87cOo7Hhd?=
 =?us-ascii?Q?EX6zbKsFcC7AzwRhyhJ5zw6MXEZzKYsb0bBmGMSCMkf2i7DEFfwcwSs1KVxH?=
 =?us-ascii?Q?FTHUT5ptc5vikSs0Xw1WCzyaWumjMjLnlHwJ+PiGT7NFUSvMAZ4JT6YPWRnB?=
 =?us-ascii?Q?Md8pbX41bCw6bIDl7euPsx3UqgTVbiAOL8LZkdinC6QouBrV0KUWBMFD8cSw?=
 =?us-ascii?Q?vFwTf5la8qp3fqOcQa7nJL7xg7onL/MNKhzytZxSA9h6i7qUQtUJR0kj1XB9?=
 =?us-ascii?Q?8TiOH2wD3BBx7jgpTpImxXdkPVsyAFn47cqbdR8x4/865RQG3o77iA1pIa2b?=
 =?us-ascii?Q?g1xz7thofM5Zd/ODVSEbD6UM+3ZZngjxGYZ6+ytOgeH9m4YoFY/4KaufToTL?=
 =?us-ascii?Q?bQj7aynLMpzrMQiaDAwmvQwAb2ZcwnYYB80btP7RaIPg+YnAcjhwdM1c/rwq?=
 =?us-ascii?Q?3W0HD1zaHsUYDlYT7wDy6AS3wqPTBXIfYy1A3KIXOpJtHGrrIxSoOOfXPltW?=
 =?us-ascii?Q?KBgtmxlIqgy/y40UsYGNBDz/C70xxFuz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:33.6683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9887e7e2-db4b-4c7a-fc82-08dcb172c912
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9014

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
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


