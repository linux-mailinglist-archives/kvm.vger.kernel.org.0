Return-Path: <kvm+bounces-12235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3B9880D96
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8165E28151D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8F7405CB;
	Wed, 20 Mar 2024 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Eiu/d2tQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8A53FB94
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924410; cv=fail; b=K5D3F1vVlLxXun3yOlmbuNTN1+hMCwIetaAkV4bF2y4/WrvK/CS8XYavxBElwth62KaqOLKTNZyUV7RjLBo7jdLf6xFvt5rT18/kJF3tEXiqD1ixrjisAiwjx4rqiWl7HJwaDf4F8oC1VFF1RZ293qM+Bsw9If/mPovOVYbXQ3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924410; c=relaxed/simple;
	bh=0wd4xwZDEag9DuQE8PTTenHaPdjwYTDUaZHWGLLcj1c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vn+9GcSvc9R08sdaAQZaNN4SBqjz2grspxALS6UwQ80LeYRP+Apy3KQ3oKMbKnynzLSHiX5GyGzchlXX196TLX59AHevSbVzxgOMJ7jAy19nh+ggyTFIRaKg067nnZ7t3oIpVSVEB37/QIhxLgzL6u5iDxNfVXOf9rk6UaXa4k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Eiu/d2tQ; arc=fail smtp.client-ip=40.107.102.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCZwU/RW8vndEkAiRmYkYBv9DGAztR7DEfn+kIZAgPkaqRJ8TmxPsVHA9u1/qONs95hQH9AN6akJaozxYgBcqsvf7q8fzT1agSbj4rstA/OXxpArvb19Vx+wopHssakbpittWuTGFdbjfENXIHAHIVOVSqvBCzXTCPlXwB3p0h4EXhy/ZW1HL9YTTV9ZNzPIJLWt1WUjwMeWqZB/jm0ohpU91eB50T0os00MhxbwxOOLvS/4Yu3b09Z/wLu4Pn25Ac6DDqcmDknlm/OEF+3TNlcg21jeXNnlInwDNN0ELexuKQR37mQ30E7dM4y85GmnAhB3wgXkeaY3ORQqwSR66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QZjs6d4O5agYP3i9hqBVC8aeLTM4t8g8XLSghIdta8=;
 b=Zrc6bzJ9y8XgH3JTNZYDjnFanOPCXBU1W25pNajhm18/EwqjWi990F6t++xALGcNy3paXi8rsevoAUDrcpxjV/mM8skHRuiCgMRsP8U5jyv1Jb3zyvZgez/0kxKyKn9sdZkEGHarHyZFO6sEw5tODloIa6OqNI/PfnSEgG/Fll/pkkYOX0nSFfxcg19z6VP9+kvpjwazx/hyTwZofgagwumSXM7IiZHDmX6vCGFzEBsqKAXJdjYOdtqdhFwXSM1OtiqsCXzKTc8bCIeYgjm6AE7S4Zighe3jkuOCqbglkZaIzU4+S7AEVQtqS1MkkkLrNDYeowaT88OfKWxUy7NCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QZjs6d4O5agYP3i9hqBVC8aeLTM4t8g8XLSghIdta8=;
 b=Eiu/d2tQ6/KRd0daDZYOsrtR5cZ0ptNDHxzj3BEl61NKxNyr12nYoUG04pG49MsmuhUFgoIrLYBLzSyMOaWHckZ5FNiLNu34imc0QMboHeagvHLh4cqkjHHrXOhsX1iqggmLPfucjGO7JbnRE/o7/P7SYgFPl7HdtAQAyMbuAsM=
Received: from BYAPR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:c0::32)
 by PH7PR12MB6763.namprd12.prod.outlook.com (2603:10b6:510:1ad::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:46:44 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:c0:cafe::3b) by BYAPR05CA0019.outlook.office365.com
 (2603:10b6:a03:c0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 08:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:46:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:46:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 23/49] i386/sev: Add a sev_snp_enabled() helper
Date: Wed, 20 Mar 2024 03:39:19 -0500
Message-ID: <20240320083945.991426-24-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|PH7PR12MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: ae25f0f3-f6cf-45e0-1bc1-08dc48ba455c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	STKm4Qdd3lR2sfLvorcL6K1sV4EjME7VqyQGKxsJlUSe0MWuApgLfeY/kLezOn/14quUhK4y50Bfc6g1L9MGyjZ3iU+1BpKG8QOFrooUcv9s6Y/pCeiJvo4iYCQoF4AHxHxPr9NoCYx3FoN2tu/PSkLXhb5clzcQdjfwFvlGqo3c+CKTP6iD0NMUVGe2xtDs5F+drj7t4b5T48cO2iKW4mV7rQi40ODdk3CQFPjhnByK50Z0KRvmaYfHzF9xYenCsgTrXxA4l/4BiKP//fhTn9dy9kcRKwT0VhpioznSgPztBy/gwCaQFWBE5C1k+VtW7IVlpn9aod96xYjpqQg4IeJ3LQ23MlAL4YYiF+T7Ml9vyOigCBx2AlHqS+ycvlXjzKogWBx5v7/aEutYic+MJeSeqDS7HJDZw0Zo0nxda50I54DXIPSOyObDg/pL/fuVVm9NiRJw5KaGlkGlaFHJJjPU5C+p3nFWF61lJHL738FhbOJH7SNVgsOV4v0P/nMymqeDcz3E1dO0afPovaHtbc4kCxx1FAWqvxxsSZJVMTyjQkasMXgj0R9VfUB60DAcbJAe1IOotMBAvdhg2KtIAgV4HOIhhnGkPNcoNbHc0zM52vaOQZknrEk0mnLqLJwizo8WAmr+pNUHk0bzNePc8Nq4QmAnuqrOglauMlpwCgf1taZq+EyauBnDnCow2G/IvGnodznJkaQjbt45weFGM36M+sbf4fZH9YVIrSsE0FSMiqfeiqLr832Ex9f24BAE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:46:44.3142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae25f0f3-f6cf-45e0-1bc1-08dc48ba455c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6763

Add a simple helper to check if the current guest type is SNP. Also have
SNP-enabled imply that SEV-ES is enabled as well, and fix up any places
where the sev_es_enabled() check is expecting a pure/non-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 13 ++++++++++++-
 target/i386/sev.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7e6dab642a..2eb13ba639 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -316,12 +316,21 @@ sev_enabled(void)
     return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
 }
 
+bool
+sev_snp_enabled(void)
+{
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_SNP_GUEST);
+}
+
 bool
 sev_es_enabled(void)
 {
     ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
 
-    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
+    return sev_snp_enabled() ||
+            (sev_enabled() && SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
 }
 
 uint32_t
@@ -933,7 +942,9 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
                          __func__);
             goto err;
         }
+    }
 
+    if (sev_es_enabled() && !sev_snp_enabled()) {
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_report("%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
diff --git a/target/i386/sev.h b/target/i386/sev.h
index bedc667eeb..94295ee74f 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -45,9 +45,11 @@ typedef struct SevKernelLoaderContext {
 #ifdef CONFIG_SEV
 bool sev_enabled(void);
 bool sev_es_enabled(void);
+bool sev_snp_enabled(void);
 #else
 #define sev_enabled() 0
 #define sev_es_enabled() 0
+#define sev_snp_enabled() 0
 #endif
 
 uint32_t sev_get_cbit_position(void);
-- 
2.25.1


