Return-Path: <kvm+bounces-17220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1AF08C2BB2
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8093A1F21310
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B46313BC19;
	Fri, 10 May 2024 21:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YSE+iF23"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20513BAF7;
	Fri, 10 May 2024 21:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375978; cv=fail; b=g/1pI3DAPHyU9l/6j1NTOmDazrIA3E9VauzrsCfRvXEIzKlz1szgcjIOXZwlsU/Nvvbgc0mtMMaZ92iAjoFlXzlA2wtildTAgBXe8F96fFswZzaXVzGy/Eopl3hjmt41CgUUKE0s61FcjMl0cJc20txfjxTU2/qoF64mQZu3784=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375978; c=relaxed/simple;
	bh=cA0BRdlMgj4mS21Y71WnWS8rynBMNHYJELrdO/3lfpI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0O9V2Sas1n9WMsEUMe1TIVkc2nqRAcVvBdci+ln1P1IM6OjpN00dtTil9srHy+MS2wAqpjV05spyrEGPs/W4PDJJ8iLXDJ1vSs1JCDg3QgWOKiKiX8MjfOoyyvXWgbjn17B6j7nC5CQpUiTtBlNh58Iy+5LBw1qNIT3z5b2bnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YSE+iF23; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+sMXxe/YMdEc9NpQon3L5sxtaMv72WVWpnC+KTufHwPx5aeLnAyBrzkhQGKXf01RxOCjFFR4wnu6ZB7zM1NzUJHy7qceuUGuBvGph+ofk5IFxQiDYcwCQF1ARmllHWPIhEHrjn+YNvQ+hUoDNSFhLvk2/zdzTlDWzc8SNMj4fTI1J75jeXEnugNdHdIdr/XRNfjNNkTwRUaox5wO7lHOjx6P23XHsYoG1RSq5sbl1SRUTIUQE9REUYcT4YUrEd36vb7fAtTO5etdgILcwND4zJ/2T6taQVp+1ugUGRjo2Vi/cPTXKxecbCLUOtPXmwgVfMn42YD8jjA3dn6RZYw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x19kI9HmknPHP8OG4YN8Ig8gnOdNgqW/ZC6ugVq9jYM=;
 b=D2I4oKtUWaXD27+VfkTF1G2b6QPQtaGI5GnX0Bi/PeHf2uQaUyww95mnjlitzcKBLubmycdWZV3euoVqNWF47+ItVknmykGDssovCLg7EmRfrc7HQbTpfGE9KYOj3Eb4uhdlphn2ZN9JRvAFH0vkYJ/rxad5f7U0J6jmzhzukkvw11uJuGNzOMkqTMPhVe59QTSAAzR0mnAzu//07OKwUBZgbCRYNMXDc+LfLUL3SZ/s+Y3t4FUVfRlOIlGKAEJou/6E4h8AcpxlwE+WVgLxZNIG9g60N8ztOIhJ3jq3cgPrCMx6Y545DmlpTuJ+cdtFskH+Z23YS+0eIZMAErVpaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x19kI9HmknPHP8OG4YN8Ig8gnOdNgqW/ZC6ugVq9jYM=;
 b=YSE+iF23+eIr3Dg/kOhpsAYfMqjwQxc+7qqRbERSIDzhY9tpRPxiu61Hn5FS6IBmlIGPKgHSgvcqzUYlPugcLBWuwqTcqzVXnQcjjSjuCtPPb+eTjzVNKMJH0cURX1BZRdM3O0vowbPtt3X5kFabpAj5cjJD/3Hi6EuhNQJ2emc=
Received: from BN6PR17CA0060.namprd17.prod.outlook.com (2603:10b6:405:75::49)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51; Fri, 10 May
 2024 21:19:31 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:405:75:cafe::d3) by BN6PR17CA0060.outlook.office365.com
 (2603:10b6:405:75::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:19:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:19:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:19:29 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 16/19] KVM: SVM: Add module parameter to enable SEV-SNP
Date: Fri, 10 May 2024 16:10:21 -0500
Message-ID: <20240510211024.556136-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: b666e59a-0a8a-435d-4144-08dc7136e15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gtv6qQTJseyvcCzV1KBCphe37jb/h3v9t+HwW4JTrNjqAPpPYuGpf6oJZEeE?=
 =?us-ascii?Q?efvkaFo4CMoTaH4p2anhBaqz5RWhcd4xeqQIwof+j5YAFPv6J3NQkPVWM/O+?=
 =?us-ascii?Q?4itfIVaTOfbXZfetpCO3pQJGAcIkMnobrZN4yv8CcCrtPeJPpWsfwmElTzE2?=
 =?us-ascii?Q?45xG/bIn6PjH2Adh61xug1vxzyNqQrhp9kZ3S1S+yCjbf0yvRTYbeMGyadi8?=
 =?us-ascii?Q?FcP4sMW3uNQA+Z5GnXdMbyyYJvBEo7tnOpd5abz+nfJPOEDsvGwu3jQen2ZW?=
 =?us-ascii?Q?9piiY4mmbv0Fk+FQvu7VBdLd/wSxA7fWIZRW2ZB+4Zu+mOUDHu/bgoMiD7A1?=
 =?us-ascii?Q?Cbw/UE7YKkBCa5Z35rF5Bv1VwkyMQgGxSRSE7qcDnGy7vjlwNHf36GJVRrlM?=
 =?us-ascii?Q?6VaCSCX4DGvl1dCyQq475vM2ms09pNdcWUj/T0jfKuGj0lIw6li2hUrTJ0lb?=
 =?us-ascii?Q?S89Vt7cdaa9RX96yzMfpp4OmkZZb+LlKJPdp1ySKZCUidqV7AcDLFb7+9Xkl?=
 =?us-ascii?Q?dDRGIkBkh+G1aRhvQ9FiGJxC4Wmkx7q0yKFFaw/NsYHsABPjKtIaHjgpqKO4?=
 =?us-ascii?Q?WTP10BZHN5IelMRL2ygVKlY98sr+31XgbVIi+C4W6BF0obWz4ngOLG7InsDS?=
 =?us-ascii?Q?2kESGo7CfPxLBITZIj8jnRpE3j0RW+mL+KvfuEVueNOkANZ23WRqHsTQCyj8?=
 =?us-ascii?Q?EtFaP6Ikm09DsO+k2IsXqv+tqHBQNZSq3gxCxBfnF+YYIU2AskGO5UZmNxen?=
 =?us-ascii?Q?BCvGdSS7ZzYJFIl1XL+/2vMk6WOeMUD37J2AZxas6NOLf8K3dZxLxpofLoHa?=
 =?us-ascii?Q?VgDF5gVeMpvmN9d2TA/5bs/zvw60eTCd6AiaDesouzuXdg3UhKCvkbO3zg4Q?=
 =?us-ascii?Q?AAIp+qPA8DItuaV6HPqlFQG2dtjQYa93reguzOi9osKmSWl7dYZNvlAZH49M?=
 =?us-ascii?Q?uX3SpGkuEUVPZqnSeVJWcCbJ1vidS8CbPqDVJBA5v1Mpxfz8KjE6HxoKmNj5?=
 =?us-ascii?Q?GOysHhGJn3BhfSvjGHYT6ZbplE/Opq8pUN1Ytl4EEquu1YCYp8T832vJdcSF?=
 =?us-ascii?Q?jjZa3iRehNYpF2tPk3FwoB+rLUFUSD2wylA+PbQjXYVA2v366nxiR6vWohXo?=
 =?us-ascii?Q?G6tBUx+pSuOt+RcUsSlinkFid51q6JztyLyZ3UBOuZiEjAPO+vHQrYGKDyR5?=
 =?us-ascii?Q?LjwNRuhMECpQgFrJGeYdlgSf2Kb2RUqYgipWrrvZ5fo773VJkPiWbDTSpcI6?=
 =?us-ascii?Q?ZcwwjP3olV2GYCqCHHY6m38P9qOI8xR075ZJgF0G3kNQXJxVCjySBSMfBwrB?=
 =?us-ascii?Q?XvGNxESBwz+oeTx6DTZ0H85O5GgQCtG3pmHwX9XOXKb0LtawRrXMYMU33LTi?=
 =?us-ascii?Q?8CG97uc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:19:30.2522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b666e59a-0a8a-435d-4144-08dc7136e15e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <20240501085210.2213060-18-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2b88ae9a4f48..eb397ec22a47 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,7 +49,8 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
-- 
2.25.1


