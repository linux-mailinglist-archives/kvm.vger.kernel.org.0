Return-Path: <kvm+bounces-2609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 140827FBAC8
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A391C21673
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A5D57888;
	Tue, 28 Nov 2023 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dR66bK9s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151941FFA;
	Tue, 28 Nov 2023 05:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e739oU5a8UsEEbXzR/7z6+lLvk4aiovFceKwLbJgPf5bJjv5yhVt4kf/4irN7ZCa4wTUNlSUKc59VIqTOocEbVb9rjnijOo1aKf3v2V95wCkPYzF7/ilOb6ZDIa8B1u0vX1UKWCxj+jKWizV+yt/ywzY3YvhBlHNcOVuHGUveIG5xbTcnvWwULwRgBq39oqghLyGj7eQVdeLfdK+bpvBePd3W26VA/Q0Ys2V0wDP1mnrMSBxblVNTghO0LS+G7chYI83ysRoLS9QQFQ9InM/8T6UCAJjr5JWNImQqXQD+ZEDKmerGez/dfRj8VYvdK/Fn3hQAOyYARseJj2+xiqAUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uS3dAeK7ZkH8sWSkHDP9RjR9kuFxCalMt0JTEKlijjI=;
 b=VdU8mKrzeyVorF7hqC0sDb11+prfhIM3fSaa9xrsE8EaqhOIsGSGj6m4kIrodAZcbpFf1/QwEFfatFn2kATrrr2cIlYEEbf2C2xfPRbzpMvzg1r4/RwiFjWyNG1C+m2wBD3Chn2XLYt5lG9Ds5UdXQK9UtnoKlSxvn+cUVKH5LCbfh0d4RE0w7QELTs/YfJPNrsZnGatl/ca7wkqrEKpLmCvC8gHV1F0huDlbKnEaNUPYYEqEv+eWsGHoBLUevIPlADty41CWl1giOFs02dfXIzhAOuP+t/8imaItARqNbw6jIPRjJPStebjdFw7aMnqzzSl07WptMktP0X17tDxPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uS3dAeK7ZkH8sWSkHDP9RjR9kuFxCalMt0JTEKlijjI=;
 b=dR66bK9s5UZ2SFynB2FKtQfeUXUw4wzdJVkQyvhqJwG1NUC1n96eKSzDP8M7OCpNelU9S6CTzjGveXT+aDnZLYxpG+N69k9mA8gW+w3E43fa5vWHsLAfYrG8zCA7JBJhEGi0Gr/wN9pjQT470efA7bCgAfmflsaywsExn6qKHIA=
Received: from DM6PR07CA0122.namprd07.prod.outlook.com (2603:10b6:5:330::18)
 by PH7PR12MB5999.namprd12.prod.outlook.com (2603:10b6:510:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:02:02 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::31) by DM6PR07CA0122.outlook.office365.com
 (2603:10b6:5:330::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27 via Frontend
 Transport; Tue, 28 Nov 2023 13:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:02:01 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:56 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Tue, 28 Nov 2023 18:29:55 +0530
Message-ID: <20231128125959.1810039-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|PH7PR12MB5999:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fab717-62ee-4ace-ceb7-08dbf01236b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UAyAHMvl7/6/80CQ2ihdCRkBNQak+Tq9ML40CFAMoMoF3jfxqRt8I5IsVyAmFRG7hL/+bF8akG/QDBGA2QtvKBPXir8E/ufz72L8VSeTr2irRWw6CVj7j4wv3qKlc9Dtw7ml7wgay3gUDUKs7prsSD7p0IvyAx7P9E0Nz0O9t3cUwTc90I6QH9z2RqTKkwRN84fGXQ8ZQu8IcR21D/De2VMOEuxl/iHNsKwivO8rqlcx1XSqlNnbEDg1v8zwVEG1wSeokJTqqdI9raGfFMqx/mVJsLfE7VoT1NWf6evL4GcSNqMg48YjwUx4Aed9YefnyHrt1gQan2bo0OCv+jDVIU6JwgqsjaLVbJL1juInfBfY0dGv47B4eO8xXZviiSCwErviPUw5Ym5wF4SrriDwZ1/erJ0F4w1hz+eB2/unUE/NFtSHq9GJM21dHIvvZ3vVh/puXsuxFHyQv2LzjhvXIaIP+zJTEjt1vXz1HaMQGr1Dko5wm4zO/10vAUgoCtQ45/kTtObSAxhwk5igAQcuqgPXGV/nXyn26GRS6V1GB91rdL3qVCnhnoc6sr0lCQHMiLuqOfmWSV4c8csLQuNR8RYrStWfKewzVZTJM6B/gnOly3YWmiyHGhqqF/3LnVt6ju1m+XYg3d6gdL+eMslu6TuuVw6F3FD9eR6Vv7a5Z/dl17mfC3Ltt6tcYbcviXmms+Rmr2g0REYYoD9YYaEZUiKj00MGqXYGljPl8B+E6VeoCUk+ksvnf/UohT2ah3N2SUZGURmwxbuGXHJOHrMHUg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(1800799012)(82310400011)(451199024)(64100799003)(186009)(36840700001)(46966006)(40470700004)(41300700001)(36756003)(1076003)(81166007)(47076005)(356005)(36860700001)(5660300002)(7416002)(82740400003)(426003)(336012)(16526019)(40480700001)(2616005)(2906002)(26005)(7696005)(8676002)(4326008)(8936002)(478600001)(40460700003)(54906003)(70206006)(70586007)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:02:01.9663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fab717-62ee-4ace-ceb7-08dbf01236b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5999

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
instructions are being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/sev-shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ccb0915e84e1..6d9ef5897421 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -991,6 +991,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


