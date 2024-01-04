Return-Path: <kvm+bounces-5668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 497B1824892
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A81B11F256BE
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1F52C191;
	Thu,  4 Jan 2024 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gs551/Ji"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268C0286AF;
	Thu,  4 Jan 2024 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKcwinse3RLW4TyZHjNbzU18te/2+Wfws0KBYqHJWbgrGNotRzyx7QTiTyQcLbrQbwoqh970sgvzxBj3reA8LkKUEcyYO+TaQS4i6xgCJ73rQW4hvcMgCUoDWtPDEvlarDcTAGr7jO6nOO2MMphZmou1zQgmcXVMK51YBSJIKOtUvt+bEw0nvYZ3tstAMWZJrqLdTcB4KZ1FxM1+DVmLJyxRG9HOeYA5bZ1Re1LCYqNgOq7g4RekKckLZ6fxFit+xC2ZQ9+QbUa2lzyU9dM6TOK06tuD+VlS0KpmHhBVpTQhLqJGuEfqfb5IcNLvSQIQOoTnSFk6NYQgJcNEMS8Lrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvhJ6sg9bHA+panwIqVyh/4I3TUy1y/BTBBzyNNnq2Y=;
 b=I4pbsTgolwq5XaIA7usiJYxjmU5o8e+Lo0eXYR9coU3sLYm1HjvL/w2wo+PHApH18ot4R+Pon8IDrBm6hhDhWbvGKhFMawRASg1I/pGABSUC1F9OEj7WuV9rKOxh2H0hVEA0u779C4dlIsgNL4qqr/er7IW7xIvs3eKJjWOthh7Hb7nL0iSY3VS3DTR2opta3xb5tubRFIk5EFBtXwbNurBD8yNZL0/LPlFZXC/mXdzGJa75RAQY8kc37LCD0OIiVnM2OWghSqBvhDXClmL85GBrbH5XAGVVlpZp/BkkEeTf4PjAL++vJEmN8kZWYucgFSr2lnr5v/ReY0hWlCqXtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvhJ6sg9bHA+panwIqVyh/4I3TUy1y/BTBBzyNNnq2Y=;
 b=gs551/JibpGZ/thylPBn5VDa/64K1y3XIivIHa1BQuAGcSQor3tVkWE+BKdmXOb4Ja4a6yRB9ZP7whAhLpru9g/w0SVpi+Zk323UWBPr43t/VV0zBjw+AcbJWafPYOBdzVVDwSzomk+/FXrfTOnRvp1o+5L05isfJHoN/JJKIlI=
Received: from BL0PR02CA0126.namprd02.prod.outlook.com (2603:10b6:208:35::31)
 by PH0PR12MB8150.namprd12.prod.outlook.com (2603:10b6:510:293::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Thu, 4 Jan
 2024 19:05:33 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:35:cafe::b2) by BL0PR02CA0126.outlook.office365.com
 (2603:10b6:208:35::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.15 via Frontend
 Transport; Thu, 4 Jan 2024 19:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Thu, 4 Jan 2024 19:05:31 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 4 Jan
 2024 13:05:29 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <pbonzini@redhat.com>
CC: <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <joro@8bytes.org>
Subject: [PATCH v3] x86/sev: Add support for allowing zero SEV ASIDs.
Date: Thu, 4 Jan 2024 19:05:20 +0000
Message-ID: <20240104190520.62510-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|PH0PR12MB8150:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c018437-03d9-4f01-f435-08dc0d582029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OL9qqhS0P6VRh2dAL9xeyzuB1u8vl9hOA+WmSeqbOArccbLg5xEgdt4ZL99V23ejpL/k5E/B8lOnduQW4XJrpUgenrOBfa6nPWRaIh5kLa/kZdJeTKCB0tJsWkemQ5amQLBFXP7RHbwWaW/RQT9v4bIX+k0KZczdUN7KikAAm+wPaiIWSmU0sfffq68gNHtmP0LKvmcwR9U4gIrm/HEFvu2nI3nMt4f2I8EYIF31wJQIGE5ghOkv0pdRg6NL0YuHfk7LIe/VMffTTvg1lVr49fKRS+hQZJpBw7DrS6zJYK/v/IWSTx6n9jsAomvegK9lgCkF0gy7EoFf7vyCvr80qOGS+xtZ/mVInYwlqypudRPZjIxpu82tQeBnj7Nzmsv7ajLjPBKB3ZK7CzyFiEta9XmBckidM6g2Y7LwXOr1Nn6eIpz/nVIY631tGgSEqjbNxyXxMwtWZjXwuU7ty1r87bk0FJydRT1I9fLlWsV3uKzUUZ518ZomTDmRjwATIqK13QIago6uynCSSE0+iaAxjg1MO8cBMGVmn03f6qedsZ7xQhTAhi95FVcJDykrRHDJZ1woOFqkP0NiK2l77fKjXC1u8+L06fQanQ3V/cq4ska8iZExzJXa2SDk2ct59RdJJ2totiFisqj9LKGSW3gt+H+wddXpF71qE/qjIQr50LgdZ7HKEr1fk1tiYxBvVrW3pVshCkLpRc3YVoZ23IZElnHyVSG6aaViXojSoYo4nYAxG1y8CYCGbgKCsIxsDIBEJQnGnMuDVA+ldwpj3uA8uQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(36756003)(40460700003)(86362001)(40480700001)(81166007)(83380400001)(82740400003)(16526019)(426003)(336012)(54906003)(47076005)(356005)(478600001)(26005)(1076003)(2616005)(7696005)(36860700001)(6666004)(316002)(8936002)(8676002)(70586007)(70206006)(6916009)(2906002)(7416002)(4326008)(41300700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 19:05:31.6421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c018437-03d9-4f01-f435-08dc0d582029
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8150

From: Ashish Kalra <ashish.kalra@amd.com>

Some BIOSes allow the end user to set the minimum SEV ASID value
(CPUID 0x8000001F_EDX) to be greater than the maximum number of
encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.

The SEV support, as coded, does not handle the case where the minimum
SEV ASID value can be greater than the maximum SEV ASID value.
As a result, the following confusing message is issued:

[   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)

Fix the support to properly handle this case.

Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..2112c94bac76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	int asid, min_asid, max_asid, ret;
+	/*
+	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
+	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
+	 * Note: min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
+	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
+	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
+	unsigned int asid;
 	bool retry = true;
+	int ret;
+
+	if (min_asid > max_asid)
+		return -ENOTTY;
 
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
@@ -157,12 +169,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
-	/*
-	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
-	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 */
-	min_asid = sev->es_active ? 1 : min_sev_asid;
-	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -246,21 +252,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	int asid, ret;
+	int ret;
 
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	ret = -EBUSY;
 	if (unlikely(sev->active))
-		return ret;
+		return -EINVAL;
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	asid = sev_asid_new(sev);
-	if (asid < 0)
+	ret = sev_asid_new(sev);
+	if (ret < 0)
 		goto e_no_asid;
-	sev->asid = asid;
+	sev->asid = ret;
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
@@ -2229,8 +2234,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	if (min_sev_asid <= max_sev_asid) {
+		sev_asid_count = max_sev_asid - min_sev_asid + 1;
+		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	}
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2261,7 +2268,8 @@ void __init sev_hardware_setup(void)
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
-			sev_supported ? "enabled" : "disabled",
+			sev_supported ? (min_sev_asid <= max_sev_asid ?  "enabled" : "unusable")
+			: "disabled",
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-- 
2.34.1


