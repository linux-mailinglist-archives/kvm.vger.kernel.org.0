Return-Path: <kvm+bounces-47056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C907EABCBD6
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D2B4A6304
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F29123C8BE;
	Mon, 19 May 2025 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bLExQDRe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB51D23C505;
	Mon, 19 May 2025 23:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699055; cv=fail; b=fzGuZul5jnj2VPAD+7cMyiW0HsYwqcEXTys1s6Mn++1AmFqQYmINzFBWgxSL2YOstkB5GJIRU2/iDl4CNBZjr6MMON19G36B51ZxPClQb+I1+vyAAjqLd6GrPp/QFWJKBkcnF5m+ZWMaiqSOnVVTejxvm5hm7nhRKJKPviOWRWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699055; c=relaxed/simple;
	bh=fjQpUBhPsLubwvrY+S8NfN/vqpEkH3GGdfv3XNc1Mk0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TXKaRSxKs4ZFmaAEsxAvnLnS8aR56Xfbyyij/NU/B6aqaNCg1GLHkeuhCDLZ4MYgRgBvlL8wz27sr8DkxmVyvbqRJfL2bbz2vlzhGQeea+Mm+z6T4cS9n1ssksHA/SBdjaeiUL4CXG4zLoKeDt64q2dgO/PoBt1eNCGYRIV9PXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bLExQDRe; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIl1bcbBxaJ3n1826xjSOyatKFRCu/07PVP4Fba1q/n3QRaEsclXeCze/5e00LjX0Bywhuu65gOznTpO7552eR3nkhwoLBld3CpN8oVOgy/adAujxLqjvKbuaSs/H5abuJLClwR/CnJ18OY+ZnfkA/GHhNK5rENYlISTrOwATbkL1ZlAmJ/4fW16Iaj9os7kjAtdu7yt4IGbqWdymKotlnyVsmxM1Z+s1mG4RsKa6KnFLm3bbabc8+lZRCoH8NYmSE8Rpx+qkmP26TI/JwgdhcJytlsy0yVP6ZYg8EKJ+odTZUGs8wCQYZpio/g32cr/0l8PgltaPYoyEsh8fW+QOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OsmNMsUqx9xnAa+JwL//gyjUtbhZ0EaUk9DuC9u+9c=;
 b=xQioCFi2oSrL9wWJc1dYUCbvbCq14gekfJNFkbQvFmAPZEOHyymh+jrbIufRY0B4tnF8JFx7sG9kC1GAXch5ICzWTrWXBUXZvZTMcNBBRvtAgY60hMesYkCeG5/8sLUPWX88Cm8XchCkNbY87wTmvKY1+01waXa/qWZsKBmXDTzS3HHyGzbUE5eaynDZwEVX3nxW3LNrV8Bcl0cyVecvDjtFb7FEsLX4GNGJ1dbb8TQfYDH0Xq+Q0iXNf523VHxivHXxuhoQAHPVaj07+WK7sCX3TStjzZiahSNW4hUIRvU6w8Mfw/7+RBlSwLMGpLQk0rztlE7tQZulH/vKrDo+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OsmNMsUqx9xnAa+JwL//gyjUtbhZ0EaUk9DuC9u+9c=;
 b=bLExQDReCqYxC26/gcFaZK6WLNnVPR2Eyefr8nOsrM6E1PAJJ4aYdbIU4M/CCVcAAYVhCRiD9Y8Bik/pnuWTpJuPGvhLYLOY+G6QhRv/sp8W97VEO/onPY2VQ8pXOo0u2ExUGH0AwkAyRuZFpRUgmMybImZU+wWH8ibtTk5Jdpg=
Received: from MW3PR06CA0025.namprd06.prod.outlook.com (2603:10b6:303:2a::30)
 by CY5PR12MB6525.namprd12.prod.outlook.com (2603:10b6:930:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Mon, 19 May
 2025 23:57:30 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:303:2a:cafe::24) by MW3PR06CA0025.outlook.office365.com
 (2603:10b6:303:2a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.30 via Frontend Transport; Mon,
 19 May 2025 23:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Mon, 19 May 2025 23:57:29 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 18:57:28 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v4 4/5] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Mon, 19 May 2025 23:57:19 +0000
Message-ID: <0196b4b50a01312097a18bc86014d9f47c22e640.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1747696092.git.ashish.kalra@amd.com>
References: <cover.1747696092.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|CY5PR12MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eebdcf6-debe-4062-164e-08dd9730ea1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fnTIytzb+3KRrkc6Jh6tTv4YHWnJiCtZsV7leMlX3RumCfYvLuxuuxAzk6Tt?=
 =?us-ascii?Q?Dn+K7sFQVdESfYP3VQffpEzTkeQiEKSj0L7ckACHMq/Ba8MXuqbn/xT1PSHn?=
 =?us-ascii?Q?IZSosgHey8m8aufzSVx+iqzpMPEeqPL9pypGSaP9BMChv67qSFIrjksn51tD?=
 =?us-ascii?Q?hulkI4hseXyLd7RvF00hUrIyCxcrdIQl7a0MQjNCowiissMuuy3JYXd1fqlO?=
 =?us-ascii?Q?GzjsR9/k4ozwCBhi8fl3AcVYlnwg7tEQVwZU1jUTVCAT5KwkFrB9ef5Mk9R4?=
 =?us-ascii?Q?Sk4j6RD8Q7NpwBZFhVXPu8SMl0M7PG0XasZqnycdBAqtpQaukkPANhvsYhA6?=
 =?us-ascii?Q?4wH7Dnzlpx2pR30E86njRJxYwzkHiYzeFjqp2axmncYSoj9BeWvkBD0k/6PU?=
 =?us-ascii?Q?ootvtdJmz5Z76KWJGxk+TcGnZEA7fPv/U1SfhnBBMKz93dGbOLYy81uFva22?=
 =?us-ascii?Q?2O1eMWhSr78AYs1y73DmQ5tRQ90sNEWmqjPzdYL2C6ur6A+5Yn9EI4bENfNL?=
 =?us-ascii?Q?Ag9NqPUaeicmYaO7pNYqD3LktcP5QkeJWj/HlVSPh51/qR/ukf/ku4Fx44qC?=
 =?us-ascii?Q?akPM/RARs8Y207EW4kfL/D2TescuvR8lcZychWAsZkcIdH/eiDVAs/9XUAJP?=
 =?us-ascii?Q?J1ls+BW76NSZL1m9CYSz4YoHZmOw+ShES+88Fda4JD5zDoTdPU/yVYEbjp5j?=
 =?us-ascii?Q?kbnusVEFIiDqRWfzspOQwkk9GVYJLvo4++SmZMYG1D+j9/H/pjQ74WigFgcU?=
 =?us-ascii?Q?KytfRMURt57+wearyu9FVxlf0iM8m/1gW4Gl0g/Rfq1BszIWctAbnx3dfmmv?=
 =?us-ascii?Q?IwoA5yIIDwwg44PpX1R+7fL5TZ+zJqfb3HHE+Zi0jpau/PStmZdNw0bDulwW?=
 =?us-ascii?Q?+218TzKwDayWiLSSYzpVDDbGaPKmeKSlN35Ysk+U+WsXpazUu5rGaz92VOOa?=
 =?us-ascii?Q?E5BBLl2DGjQ8H6Pd1kG7eRQ2lVeXsj8kzJJT80HUTyy0WqAxINv7pZznRC8a?=
 =?us-ascii?Q?1Z149vgM5S/5VaTsunKG0J/SBBgKLVGylYXOnc5TArPTDLMmg4goXbn2hUnv?=
 =?us-ascii?Q?xOTTUNTxsSXT8pJ9UmnYRRPLfRQjKNQymR4PGVjLdm8ClARBn5yqdnlEelqn?=
 =?us-ascii?Q?lft6WtLyFEG8wds7CiU9pLdpI/oR9csRvRZFTxtyCrphuxaA6sIaxu3PO/kZ?=
 =?us-ascii?Q?eGl2jAAgdU2+fHV9DWYknEPoI1px+aYE6cXjnpyXbbMXKDDCUwcaFWEKZBiu?=
 =?us-ascii?Q?/3Ynlt8w3RvOzi039wRQk/tsSZeSGVlmXBU3nDm0LFVLTjhYSIxPHAeZs+pF?=
 =?us-ascii?Q?Dj1EXJa4fpdOXTBZhCMNKuDrkeAjaomf/ecmHfGb5fL6SlBmhEWzoP5pMl6T?=
 =?us-ascii?Q?p7c1Kizqz6C9vke9CUn+diRaKA0pclyxXLnaLpbOJNVqsYgv9G3R0qtsvthE?=
 =?us-ascii?Q?hd5EoNz0FQq96pUnsF53cRJHMaasBRfLFRCa30tC3dM/soP7qn8NkVb5Oi3l?=
 =?us-ascii?Q?W7E3QcmSdFyDn3qkHXE47DtzW0aJ7aO41TNw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 23:57:29.7343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eebdcf6-debe-4062-164e-08dd9730ea1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6525

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new min, max sev_es_asid and sev_snp_asid variables.

The new {min,max}_{sev_es,snp}_asid variables along with existing
{min,max}_sev_asid variable simplifies partitioning of the
SEV and SEV-ES+ ASID space.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dea9480b9ff6..383db1da8699 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned int max_sev_es_asid;
+static unsigned int min_sev_es_asid;
+static unsigned int max_snp_asid;
+static unsigned int min_snp_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
@@ -172,20 +176,32 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 * Note: min ASID can end up larger than the max if basic SEV support is
-	 * effectively disabled by disallowing use of ASIDs for SEV guests.
 	 */
-	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
-	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
-	unsigned int asid;
+	unsigned int min_asid, max_asid, asid;
 	bool retry = true;
 	int ret;
 
+	if (vm_type == KVM_X86_SNP_VM) {
+		min_asid = min_snp_asid;
+		max_asid = max_snp_asid;
+	} else if (sev->es_active) {
+		min_asid = min_sev_es_asid;
+		max_asid = max_sev_es_asid;
+	} else {
+		min_asid = min_sev_asid;
+		max_asid = max_sev_asid;
+	}
+
+	/*
+	 * The min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
+
 	if (min_asid > max_asid)
 		return -ENOTTY;
 
@@ -439,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3029,6 +3045,9 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
+	min_sev_es_asid = min_snp_asid = 1;
+	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
+
 	/* Has the system been allocated ASIDs for SEV-ES? */
 	if (min_sev_asid == 1)
 		goto out;
@@ -3048,11 +3067,11 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_es_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_snp_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_snp_asid, max_snp_asid);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
-- 
2.34.1


