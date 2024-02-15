Return-Path: <kvm+bounces-8759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A608561B9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B2F0293AB7
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827C3130AF5;
	Thu, 15 Feb 2024 11:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Nl9ZUZwh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6F1EF1D;
	Thu, 15 Feb 2024 11:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996770; cv=fail; b=qmehvxNl0NB4IfsoW15zui+fp3M30ngxckSFqoOMdZFe/JikCayabPaqgrXR7+22Y7Ay22E2O+JgpZ2M9WELIZgHEob3hArKMEJMAAOqBpqy+cYfzxKNons0ecgd4QG9NgYNBydkifrJBwdaw4zWQTyPECpHFKL2MjHhYX8JW2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996770; c=relaxed/simple;
	bh=3SCXmC70q/huQKSAadEvqtREaQqyVBJwbq4WsxO1gHU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQO7z5uy0rYuSwbUhdl1kZ92nKaRh1/U70sgsaNnm+DFWd7kH4GBrhchoZ4upnXYcywOHx01syJuI78R8ztivY7pxaUh05DLmgEX1H1vN2yLcz3c2pOOOAVb99RnMc8WliOzNuuqCLkKcSoFURk0z2g45abfrM1prLGiC/CmYLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Nl9ZUZwh; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2I3ueGBd4IDDPhQ7dqEBRUomf1SxxXFKmNtHvB67osaDoUzrt9+sqkaJij2dkxNxrC8rmxKqlMHAR0SYhEt+p2Zd6C9JvTWTVDfVJcAShTihOyk8fx9xN9K/b8O/9dYso3doNvD9AOEXasyVUN7DyBs24ZbXxYpJ6OLji3JIh80GJZ9pMGiAmfN0GmhPLs51CzlC08C/8PORzfnTws8fJeeIm56UJILvYPSu5jMxBffpgVnITsozv+m7ysBIUH4R5sa5z9hi7fK4oI1MtJ77PMVDhGToEEuArQfIflU+Csa0xeDHGSz60JI6T4lPLH6QH0eajHtyptA5O1e3FINVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmzkZIn5blsXJSa5sKhi8W7HaiDBomECuKMRZw5MSvk=;
 b=SrGdpLhVYPhceCQk5w9AriQApL297u1sBuqRXpdBiLusMicIB+LwYHWTjAXxl/stq8XZW0raaPlcV/mKiTZoGVt89W1o7b4kwDp9FaNqkQ/R9Fzc55zKL45Q+rUUfduYemXymeUUJ5KN9s2OGknd9ZoPFKHBJXgr7VVqNnjp5UJvfPxE9mON7XYiylhsXgqY/Lg5ROmWkzt6aDlYzUJxzodcuRWxeVk6zsYl3hew3Sq7ulerGuD7BF5zwC+96E5cvYYUfGjjeYrp5KTGZmuQB89X+FFMb7rPQCAiu0CKvgBhJdfogRB7ixUiDrdBsaRAHpJeURGe4t15lKjps3Eqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmzkZIn5blsXJSa5sKhi8W7HaiDBomECuKMRZw5MSvk=;
 b=Nl9ZUZwhXJfzH1aBoqvPK3WYgl6BCTGrmW0M3fYNsjGmsvkeJgXn/g62Kb674x1UxDxBZxrZAna661cQUJKwZM0u7raIHjIWwnHjlG05btP8K4HAr0ZZjjm4V9NUBc7gHpIvMTOvdKHLV7+5LDqEWe7u6mBvcpWk7r3Z3RIODAs=
Received: from PR3P250CA0024.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::29)
 by CY8PR12MB7706.namprd12.prod.outlook.com (2603:10b6:930:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Thu, 15 Feb
 2024 11:32:47 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10a6:102:57:cafe::33) by PR3P250CA0024.outlook.office365.com
 (2603:10a6:102:57::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:46 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:42 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 13/16] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Thu, 15 Feb 2024 17:01:25 +0530
Message-ID: <20240215113128.275608-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|CY8PR12MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: 4586a35c-ab88-400e-80d1-08dc2e19d4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5C18g46qY1W7aWsgJDD9nusYOj4QDx/Oa5nH9+qK92y7R51B+r5B1I1Gy+4cAJg7LtUqVGbNc70erMXD2Dcj2EeAr7Wcc9RAqgCrFjxbHUtbqjOk+9Lb7rwU7GPyi7ZvZmTovf3PXMUpK2CvnKDpQfE9fD9Dpipj+icY8rmF/UOWy9iaRqgpgrsMkQpGW9WO9ptpTb9IzavUL3bhs58iUb47mALblS3eWM3w5NSc4xGHxpY2YkJYfTzEYpadZIQmX3eSafiXoUMXbi60gbEvzVAXHc0A8LzleLQP/7YpRMXJBtoso14eIKFsC1Ul/+uiXHtTxLVtPoeVtqbJGpwt4IQnNc9uHRFiXhmEr+exJ59cSnoHylzhgKaV0LdUbHHmiSLFyTyu4ToBCxZ9czf13kOkWaLJoNHm/cDEnGtw1ItoHHuburFIa3CH6A/roeh98jcfRLK9OpTeM09AD532+TvNWAhoWqOMce51SQx9pBdsKeKxhKhqvSkhvlwyIBs+w7FQ/YLGfg8qdRP6AFLtjs/l+QR3v0dohlWB7E/16LrB7DPSfYPEJ+WGtjp+XymTHOzzIPuZlFGHVXtnWp/hmL39O7aJZhtOTAKyI462tQZbmTZ14FQsR1FatFheqPRPrdkzpeFo6fOY+xCRO1HKIoZ03yOfZKLmbPL59QfnLhk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(1800799012)(82310400011)(451199024)(186009)(36860700004)(64100799003)(46966006)(40470700004)(8936002)(41300700001)(70586007)(4744005)(4326008)(7416002)(478600001)(2906002)(16526019)(356005)(82740400003)(7696005)(26005)(1076003)(83380400001)(2616005)(426003)(81166007)(336012)(70206006)(8676002)(5660300002)(6666004)(316002)(54906003)(36756003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:46.1389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4586a35c-ab88-400e-80d1-08dc2e19d4fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7706

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5bb395551c44..855ef65dbc4a 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -289,7 +289,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


