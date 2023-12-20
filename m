Return-Path: <kvm+bounces-4949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8EC81A224
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EE301C2025B
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C334B125;
	Wed, 20 Dec 2023 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GmNRc5TW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A645F4AF7A;
	Wed, 20 Dec 2023 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCXgq13vyl/2TwGBKsvd8zBh3nlq70MXdsN+Autt0n2Im+9C3JEDN0vbaI1PvryNhupcMszwG8MZuQZx1LfdPqOoaSDKHc7e9fkSnsGwP0bM4VkUSQkNAO//xvHNe6KNntKRlytDh7TRtKBF3ch4xvqrIyRuDPMvFgwYWlxvh3BJuLxsQ07m0aJb+BxNRNKIYHEPnv8psk44w2LT5N8nr8GLUrRULlfjHe4TOc7g6Vx93H0Totr8KhzEo9Yf6S7ISpZPkfkScQxSbmhVV1Uvsn6k/VgP3RhP0StyGps6wKh/nymvTmn8ku0Rq65A5z/mbcsc+YjwMid4OrdB6OfLrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6Azz9JKP+iWwyMpqCx1n9PztIoAiGoKnWnk6LRpHj0=;
 b=NY9iZaT3tKrUIe1VTuybw0hCshL6OqQVIDlh2Yd/K5EAMbewF0GubpJYhToUL8h8NnbqlEQOL8wndPxnGX/TEpVygUzmXxBCFn75ePhYv97lZgUkc65wFgusanwW9UQx5r6VIVLwrqwTeB2NXNfFzot7DG23Io8dTNeIgTDgBWwnoSbtsZSeTP+nhgay7a5ATrOA5xZZWCt8d39FJyAk+9f10UxW4HCnW8p3D66DKJHCaFCaIksrVUUBCc+3ux2wo9haE+5Mz+mJhIohZ9p0s/Sy+Jivv6Fam5N/MT/kmkHeZAFh5a60rgLQ6NrhNnbALguq4DTnKIVx/cgNDx7woQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6Azz9JKP+iWwyMpqCx1n9PztIoAiGoKnWnk6LRpHj0=;
 b=GmNRc5TWm6iX5drfNXzpd+juUIFUJjLUK4a5WxelgouGiTaCInKezqFEtXYL4i0iweB71G+pEuMu3bSQI0tb5lXJgNtdfccl2gRcWZJPxlbUCWC0TOsMlxtpl9e0KktDjDHnSu8VciWbOO/V3Jv42xSPAmdlMtIpRixB7JwBCvU=
Received: from DM6PR01CA0014.prod.exchangelabs.com (2603:10b6:5:296::19) by
 SA1PR12MB6848.namprd12.prod.outlook.com (2603:10b6:806:25f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.38; Wed, 20 Dec 2023 15:16:07 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:296:cafe::ff) by DM6PR01CA0014.outlook.office365.com
 (2603:10b6:5:296::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:16:07 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:16:01 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 14/16] x86/sev: Mark Secure TSC as reliable
Date: Wed, 20 Dec 2023 20:43:56 +0530
Message-ID: <20231220151358.2147066-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|SA1PR12MB6848:EE_
X-MS-Office365-Filtering-Correlation-Id: 6515a1e5-6ea0-4bb9-fc9a-08dc016e971f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UGUxM3a01+b3k+Cqmhw1odO9/n0Qzm/o2HfVpxalsswfna4PdiIPgQMeSxJE01TTJOw9dMoQJOkKFZ0Zex6S/j8xpLn3ioe5cMj+JvU0g3W9PL4Ly0Q/iFX4g4Nr8miZtgEZ7znUpKlf9Hufo6GjQ+lp/dNRhivJ0AlxavlIbTbx6nzqFfT6W9dbScPpbURdw9HYuVi9zkrOSZUqYqi4RFFWS+eYe4CKZdJFm0KNw4MwkAiFtOy7BXI+uQQEsqX7Ph4q/3vriyAHOTiMieARNlFKUeAUlrBqDK0FZoBl9ZdydRZWd/JtHFVNp6fxg5aU5IUMXxLQ82wa5TQkulAi0/wcbfFuQTTIBnC5yJrpwZelm6KgJ5J5QcCkjM1XYx2sTSh4ya704xYXjNwWr8FDKpEA/hcWrLP/MopHtzwrIN7q7oD88jfVh0KYARRs1/e4BRmxMVdFbayyPFUyhdXBwJij3jfhf/pcm4P7Whh2H34+jlNEciTG460Tsoa9uKMFD9sCp9UFCBKc5C9l/ff5Bv4mCVHId1nxvvyudNHEhc57F1Ft4oj/XXxAaWRVhS6AmO2cd3lIMrW5LenfZvNWiOyKvSBDzNw3wrulaoFh0BKlaII2Lc6OK1hOao+n6zNe/7jMAeV4uY8SeG0DAxQJZYbYWr9kU+AGVVoKRsMMwmfeWtDFDcR4bW9duPvmmCvJe43RdCk7fEm/++V8iDijRFdxjd5tp4fdlYleOWC+BRDUoLcziQ7Zyf3oC009o+Qcsa8rmJKn1OzJhmABDt53+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82310400011)(46966006)(40470700004)(36840700001)(1076003)(40460700003)(336012)(83380400001)(2616005)(70206006)(47076005)(26005)(16526019)(8676002)(4744005)(7416002)(4326008)(426003)(5660300002)(6666004)(36860700001)(7696005)(54906003)(41300700001)(478600001)(316002)(8936002)(2906002)(356005)(81166007)(110136005)(82740400003)(36756003)(70586007)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:16:07.2472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6515a1e5-6ea0-4bb9-fc9a-08dc016e971f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6848

AMD SNP guests may have Secure TSC feature enabled. Use the Secure TSC
as the only reliable clock source in SEV-SNP guests when enabled,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index c81b57ca03b6..cc936999efc8 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -498,6 +498,10 @@ void __init sme_early_init(void)
 	 */
 	if (sev_status & MSR_AMD64_SEV_ENABLED)
 		ia32_disable();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


