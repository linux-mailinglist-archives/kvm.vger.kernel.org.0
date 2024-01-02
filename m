Return-Path: <kvm+bounces-5481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7569822574
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34EA92848FA
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F65A17755;
	Tue,  2 Jan 2024 23:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lLHQn/Bf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E321773F;
	Tue,  2 Jan 2024 23:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drrXFiIjpSaq9otzGtlZ9SwtgLAwjh7pmnzhyjIh7NLpXYdPe+jXi59EMNLErQ7AUT3lYu6QYEWIZgjAEdtDOKzPQUXXjO+YXKR0Ok6lgn2iqNZRbB5EpYU298XEDtFeIyXBNLZgxwNIAdYWCF9nqC155jrIAumPC3qxciUnHeHiA8VzHldMBkX93Gps50FWqReO6vEo7v3Kjw75HZqK2ndLH2XH6viGf7LbmxLU8Y2FTaIbbTs3uJesSxmtqtba+CYniQ4H23UUtZDPz/1X1FB20FEn/MQfXXGGrxNL9vSQC6+xIyn7d+z9xJmeLWSym6NByPwKp8L/L9GU/VoIpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx1KCH4vzCYjZr/dJQJAt9v3mDo5m2kpsLg5RRyXb8I=;
 b=I4/HR5KKMLtAskiYVNkufKttjpmk5EKc5mfLVqmu7pmCQN1MFgJe8VwwL2/p4aT7do7vBYJxjjpjRTznA5I4aSdIYK8ecp+IqIrUmw/LkRN261m/xQAkmWjBaaEyBPJYxtXWbl/LtZzaemxQFIdUe3V43Ef8hrTY/NBhhrW4hKHK5Y5qlrkcBFMNiZVKXdojg/2Y9VLt/qifn4K+nBUC7nowIauc1/E3ZJETj64Ntjdh5cM6HTt1gCt15f9Y5E5m4CDTsn8Rx8yOKm9e6qM23ROd5giCDQMOJwSXaW449WZUJ8tXwelngRN0G5YhsG96RFfMyaRedwirlH+D5s6U9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cx1KCH4vzCYjZr/dJQJAt9v3mDo5m2kpsLg5RRyXb8I=;
 b=lLHQn/BfgEYVkNHVXcNlvpB2qM5BH0oFWC6149yzCbk4Tt5mBB2SD+ydw+T7awyuaDw6awvNsYvnnVtLZoxokmpbowC6y6TlVVaD3SpAhuM/zgHFcZq1NzgykitdDLewjCzd37Sx8pXJbsQAgdEfyjliCcRs+Af7WuEc9cpuMkY=
Received: from DS7PR03CA0356.namprd03.prod.outlook.com (2603:10b6:8:55::22) by
 BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.13; Tue, 2 Jan 2024 23:21:48 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::a1) by DS7PR03CA0356.outlook.office365.com
 (2603:10b6:8:55::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23 via Frontend
 Transport; Tue, 2 Jan 2024 23:21:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Tue, 2 Jan 2024 23:21:48 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 2 Jan
 2024 17:21:46 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <pbonzini@redhat.com>
CC: <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <joro@8bytes.org>
Subject: [PATCH] x86/sev: Add support for allowing zero SEV ASIDs.
Date: Tue, 2 Jan 2024 23:21:36 +0000
Message-ID: <20240102232136.38778-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|BL1PR12MB5270:EE_
X-MS-Office365-Filtering-Correlation-Id: 2448efd4-ea16-4695-4a09-08dc0be997da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z3tNTV6mLoxI7qBcPl62QPTp7mDv4H5JGDNeKlehUZ3nDkeSRaJpUa/LyfuIb682q8Qteggh0IT3EBbORzE1nwHgXFan+9T9q80MuFBvXch4XAd0OknNH9rZ5fKBHSyrFqchcFTcickAd6fRFLeOGB1wTcF9wrJwqlxxCS11/OcMpdaIY48KYOPpujeCOm9y4qUhhpMwg6UmDi5K5Q/5ru+sd+oCbu/DMwqkiTrrIrZ7QsP/cpa4k6Ewy/9xBQRU9uQwJ9DrNW17loitdEQyR+LKIF0t1Y+N63epqg/vbOOglB1KXZxZINutXvBQUrMrLqXEiIfEwNULBDPqFJn0kIWFU/H19QohjH2f1mx6Iu2IvIah4fYV6jgNfQAvGomR8aZ1K/0a/G0EJ54M3jQBFnCeHHHtxmguuaIhfWF0DOSBN9UluReTmM/cQD+y4AqMG1uOs7wd42ByQqCj2g1FaC/zsNX1SFddco+62z5bOPMxlFGYzv2cc3kl0//XyCiqrV9NzpnIxbjgdjihfAdOfVLtNbxhxGPutMOjdtWdVe7mmKjjz58DYmYlbCLtlqtz5r6ipc4hLpf0Kfd2T6XiYLhIi+sWnmazBSzCjDhJgSFWmOewDaeCJ74pkuXt7dh+EqB/o3nRV6TIhIfie975UxXItZB8eoplJieP2ySbJ+uSSjfXqrdDQxsutuCvuNLEUWh3Jhw1iKBPicn9N6UsOEPJfmBeVtwGrl00TNM29s0qyhR8vFL0vbB+/Ed/zQXlSqxNNkFBtnBXONY3Wb+5FQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(82310400011)(40470700004)(36840700001)(46966006)(2906002)(26005)(2616005)(47076005)(83380400001)(41300700001)(336012)(356005)(81166007)(16526019)(1076003)(426003)(82740400003)(36860700001)(316002)(8676002)(8936002)(54906003)(7416002)(4326008)(5660300002)(478600001)(70206006)(6666004)(6916009)(70586007)(7696005)(86362001)(36756003)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 23:21:48.1937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2448efd4-ea16-4695-4a09-08dc0be997da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270

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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..ad41008ca0d9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,10 +59,14 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+/* When true, at least one type of SEV guest is enabled to run */
+static bool sev_guests_enabled;
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #define sev_es_debug_swap_enabled false
+#define sev_guests_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
@@ -1854,7 +1858,7 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!sev_enabled)
+	if (!sev_guests_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -2172,8 +2176,10 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
-	if (!sev_enabled)
+	if (!sev_guests_enabled) {
 		kvm_cpu_cap_clear(X86_FEATURE_SEV);
+		return;
+	}
 	if (!sev_es_enabled)
 		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
 }
@@ -2229,9 +2235,11 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
-	sev_supported = true;
+	if (min_sev_asid <= max_sev_asid) {
+		sev_asid_count = max_sev_asid - min_sev_asid + 1;
+		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+		sev_supported = true;
+	}
 
 	/* SEV-ES support requested? */
 	if (!sev_es_enabled)
@@ -2262,7 +2270,8 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
 			sev_supported ? "enabled" : "disabled",
-			min_sev_asid, max_sev_asid);
+			sev_supported ? min_sev_asid : 0,
+			sev_supported ? max_sev_asid : 0);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
@@ -2270,6 +2279,7 @@ void __init sev_hardware_setup(void)
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_guests_enabled = sev_enabled || sev_es_enabled;
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
@@ -2278,7 +2288,7 @@ void __init sev_hardware_setup(void)
 
 void sev_hardware_unsetup(void)
 {
-	if (!sev_enabled)
+	if (!sev_guests_enabled)
 		return;
 
 	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
@@ -2293,7 +2303,7 @@ void sev_hardware_unsetup(void)
 
 int sev_cpu_init(struct svm_cpu_data *sd)
 {
-	if (!sev_enabled)
+	if (!sev_guests_enabled)
 		return 0;
 
 	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
-- 
2.34.1


