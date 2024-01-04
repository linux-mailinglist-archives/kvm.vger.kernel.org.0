Return-Path: <kvm+bounces-5611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57EDD823AD5
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C32A6B23786
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8255221;
	Thu,  4 Jan 2024 02:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vwvCq/mU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC884C67;
	Thu,  4 Jan 2024 02:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlUXpn+90GUUGuGssS9z+xdCAWsFNhZpCSg4JM5o8u65kTVgbQklQlbL0FDADY1CcMhowoIchzqZxPCIOFuXnIZqReTU/Y0SrzOzf/kAZSznHxTbatFt0kZUv0EtOzeH9pfYmSlaUY7rAY59M0qRdhyS0KQdEiLRuEhKqntBZj1A2Cx+OcTKRNlyIoDWKEFrN7daTGUrF3wgesi07X0WIoXIw7U35Iu5c9NDgybdZyEUIDjkPQqnjSQ1fS6c07DgEA3E1ZZv5b84EoNkZrKbYuHgdNhJVBUFVb6mA+gR2Wu++El7jBvkoQU3TSpxkfUp1s0K/aC+MuVDSsMV/J5sLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUESUAAdl06YmEu4phgq75m8iLuPKmP/2o53pLRgFhE=;
 b=VaWI2jlWsGq8hx90aEpqrzwcdzROxBqjroF2Oe5QzDCJy1zC4krfEd44bSc6QeT92cFnco9o6xdfNsDvUYvDr20B7+3rEGedlXUnN/r7b58uqD71loQRDniEuBP1f3cddB9Z82+9XCIKIcm6Bhgtt8TQWsWonN0mIi9gCZDMAWf67kLi338pwl4Y6jouOLEduz/1ETUcLp5txfQGJof5OB+uQwbIfAJEl0ZS0V6VwMjURlmMqU+C6hKPhNlsrWqK9gGgQYRqDbg+q1DB1ENYLmiYNuifTWGy75Iqddco3srj/NPhLOr4SCt7j90Hn/lken+qaV2Y6+XHu622sDTxIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUESUAAdl06YmEu4phgq75m8iLuPKmP/2o53pLRgFhE=;
 b=vwvCq/mU0xYKZG1BuI14A1pX4w6yF9HmOOaH5oOWWHobVmicayvZxyEGFXATAiOQbvFkHRdvXp99ljndpUpsd0WZtdUUMD4LYe1JlCxpNE1mpoh3QXFmsR0QpM2Z6bnFJtfhvWX9yBfq0NTy5EanQ+r19Nm5AsYKHR3wJ452Qvs=
Received: from SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6)
 by PH7PR12MB7966.namprd12.prod.outlook.com (2603:10b6:510:274::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Thu, 4 Jan
 2024 02:47:09 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::11) by SJ0PR05CA0121.outlook.office365.com
 (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13 via Frontend
 Transport; Thu, 4 Jan 2024 02:47:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Thu, 4 Jan 2024 02:47:08 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 3 Jan
 2024 20:47:06 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <pbonzini@redhat.com>
CC: <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <joro@8bytes.org>
Subject: [PATCH v2] x86/sev: Add support for allowing zero SEV ASIDs.
Date: Thu, 4 Jan 2024 02:46:56 +0000
Message-ID: <20240104024656.57821-1-Ashish.Kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|PH7PR12MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c30eb6-d980-4bfd-85d7-08dc0ccf7200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UtD6Tal4b4kHPqisUuSmNxBOSEEETtOIOzclkpRyvY6OKe5vSCCpsLltXF7qVBId98LZvERtoG2OYWRLWnddnEINi2Aqot3xdWxqalb3Zt1hFy6EoIJjaRiB6VIoitaZr+Q5UOG/OUm+cWTN36tZxPu37TDVqLY9JTUrS6ALPrgKw3IMo7wC04p9ZQSSxlTmt0+6m6caiBFldzgZl5IXXpV/UKYIamkcidzyMDnx6twb+5EQTvb6QbJSS6voRTR2KiKudQuZ3FABZtt6CpRXzE7rpLVcjj0KfuSNSNk10JkeF9CfgmBm/wWW63fu9hI8N8mhd2UZfS8Bk1cAbBurLqKFq7UAkD1qzjxXYB1BxE9SoN/oDzPCMti7iYhk6rmzOhVuNCjtl1vLpBZgbTV7U45fwIIQvbsuPn1VmB5mjJXgkV3oRJG1WvlCfi0S9LBo/FuoakPED60VU2ALbV4Z3DH8n28FsL8Lv3P2HaNooDxTl8iyRctnG8B3eJpN/DsxQmJAi0uWGUWjPjmXM+IXjlIpBrfkx4zmyv18rPQRk7yB0/s20Sv17sFpk+XQZyTRC2cf1eMunCDEKWDWqdN14LpfWzNH9IOUbty2tO+dqhtHrmZvUqglBL/NwLXGcnnqKUTOOIC3n49vZ2jyz9KV9eqYBlw7BESX2hTfE+a7mTkl6VGywfBf4bEkf8YGqvdAz1b4tSfIVq4Tmv3wqan1ZPnN5jj6/zaiPVz9XUGfTU6VDaggRvt/beDPUVaAWj94ha7mlDGg/sfiVKOwozk8+Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(336012)(426003)(83380400001)(26005)(8936002)(1076003)(2616005)(16526019)(47076005)(41300700001)(316002)(4326008)(8676002)(36756003)(2906002)(7416002)(5660300002)(54906003)(70586007)(70206006)(6916009)(7696005)(6666004)(478600001)(86362001)(82740400003)(40460700003)(81166007)(40480700001)(36860700001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 02:47:08.8293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c30eb6-d980-4bfd-85d7-08dc0ccf7200
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7966

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
 arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..651d671ff8ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -143,8 +143,21 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
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
+
 	bool retry = true;
+	int ret;
+
+	if (min_asid > max_asid)
+		return -ENOTTY;
 
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
@@ -157,12 +170,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
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
@@ -246,21 +253,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
@@ -2229,8 +2235,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	if (min_sev_asid > max_sev_asid) {
+		sev_asid_count = max_sev_asid - min_sev_asid + 1;
+		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	}
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2261,7 +2269,8 @@ void __init sev_hardware_setup(void)
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


