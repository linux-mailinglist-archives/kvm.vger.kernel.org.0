Return-Path: <kvm+bounces-16301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 743978B864F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89155B224C6
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A5F4EB31;
	Wed,  1 May 2024 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wPFqxagW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C204D9FC;
	Wed,  1 May 2024 07:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549633; cv=fail; b=nwNFKhLhACR23jDY4r+TIn64U6sOfvZRD9mx2PxwqiMlkBrbMy5xjqVXCqTfhaCh7xyJM/LynpQ01pV24/rRyk+ishrOeht5m9C0HUcwyeP4TiRuKSXNkyK4wKzHRqQbd4pP3f5SifDe+ed95CfKrWm+FpW7lBlw7uFpwmGcRag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549633; c=relaxed/simple;
	bh=uQ7Kx3TwQhw26SgLxowep5X/GtjYEaH5Eg1Jg4fANxI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDUwDfQZ/12UAlM4Zl3lBJ86iJ+El9H55mEEnEMLepYG+4iQBel2pn7nw2RhBNI0BYKA/UF2up9SCzyi8ynQCYg+08h9OWMgFebU3+3yTgInheEJeqXsdvkx1S89ibA6nSoT2eph7b6gV7NZpfJcmIcVhrxg2KkmqJIB81NrFAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wPFqxagW; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3cD4kf4eqmNzCu3W33RvisHQPQk/0fanEGLK50E3FaFSobCQrn448mb8poxfPS/W8hgtDQ/9PG8JQGSJU/T0x97e3GmNXb0UskNBWsxQPLVTnyPhr1/Hz2U84uqVAOxZJZx2DV7TxtuItWDL7oN4YFR0A5oA/Xr/Zl7LDmwtU4Ye1VFvWpM5tGU20QMOndFqG+C6jv3TGHAm7HswgNJ3X1LE9A2XM8z7qqEm0MPjs/e/cMVx5uD9vwQn0DN2k+RgRqx4mEHSVHQ3VvZpCeO/5K7PSIYb28g/vwaHIS711W9iZIPJJOszDcCH//Z49g7r4MnCkF9VtAV0BcbQmaiBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=DL06191+Xdrx0vGUbBoBseCltQLWtESAd7SjqqV6x9E+UbzrBq4cW+GVrvpZlgsyBjhGe3ON420JIlt3LJHvtqOl0GdLo02aHURIb2homtqqPGM7sVFNz2uqs9ukzZg5uvKlFPITvI3K46y8LGkGcYFL0u2EOB9hCZo6kuRh11P+e5MFZz8DZcHwRHJg7/rsP5bcBg9KD/JqVqSOcAeUWPp5ggv5VKkquK5ivPH5s8l7WuDgFZ+39wBdiZe9eIlHPjJL/1NZR1ZKz95hU2e1EEJVBr5sRihn0+D1vdP/fielbZfyAAUUGlMFSrgeHRsDz0pPwBktbBPO6ORArbJIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=wPFqxagW1qZ4LDbDS+ucv9kFms2IeXeH9TOKytknqQhJJca6q3jpsbsWj/9yQaD6eiZzaeDRFrFAKMDvf08A8L7o/HwZEEnDDnVSVpeqDUJtJf56p6e8rt6PMCTexpKT6TH9+jc29eA+v+G3rbgpTcaRnrdyWzW+ebzG6XDlpBE=
Received: from CY5PR22CA0090.namprd22.prod.outlook.com (2603:10b6:930:65::12)
 by CY5PR12MB6275.namprd12.prod.outlook.com (2603:10b6:930:20::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 07:47:07 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:930:65:cafe::b3) by CY5PR22CA0090.outlook.office365.com
 (2603:10b6:930:65::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 07:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 07:47:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 02:47:05 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 1/4] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Wed, 1 May 2024 02:10:45 -0500
Message-ID: <20240501071048.2208265-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501071048.2208265-1-michael.roth@amd.com>
References: <20240501071048.2208265-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|CY5PR12MB6275:EE_
X-MS-Office365-Filtering-Correlation-Id: de3d0678-c094-4ea5-97f1-08dc69b2e614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|7416005|82310400014|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gTsMrHNuxBjAgsALplTx9Y+g5quhH5/ukFsafYl2/VKu/VgYWgx8jNpvPGUp?=
 =?us-ascii?Q?ZKBfQQ+RmFIGT/VhNv8fGvySpZqcQCNZGkbjMM2hvYASWY85Ut8GLdH/rspt?=
 =?us-ascii?Q?zLTgtwE77j6XUJgUc4mEmXaQ382PNOMI+xibkEVh9tOHdZ1UL8CbSjrh9kZt?=
 =?us-ascii?Q?Fj+wIzEiz1bBJSzjbGF/qtasj9Ok52VLjlzHXaLUgcRezFlv0zKrYGbIKuIv?=
 =?us-ascii?Q?/DjAJqvguSeBCJcjxpsLfh9r94KUh6I2I2YNncS3I4tpUIVa0eN8OBJXwBGk?=
 =?us-ascii?Q?83sLKp5scs3Z0vGPFOP22S9hMbh8w5znvS15n1DqYOhPmgFPBWOUxr2Tgh2O?=
 =?us-ascii?Q?WuBzTUjHalmZ0Xb3rL6rcHwtj73qF8xDUb1V6hOe/l49yP2aU9VgxVrKJW4u?=
 =?us-ascii?Q?GfnrHF6ngdpNcz0zkcbLix7Ku+g+y0InHHC5rfEtFGWCIsXmDdHv2EiFetf/?=
 =?us-ascii?Q?kEib/JRMQuF5MOK+oiCzleGr3rWvju1Qysh31DYDmf8Poz9ydPWzVPuywCo+?=
 =?us-ascii?Q?DASapf+J8YNd3g7OqNRdJrc/j6lZQB1rDVn/uDDVIq11SAxJSay0jJUsAxIS?=
 =?us-ascii?Q?YAzPetbPNL7MQVm7L0nwbh5mrKLuRVS5NWYWZzRelS0Kjz0BjPyXNBCfj+Pk?=
 =?us-ascii?Q?8LUlURxJiWY2pqH67rDcXX5fCwccGkKO6FUpwy2+UEFCnwOvjfTF0t+fCt9L?=
 =?us-ascii?Q?zrAYuk8ax4wG//H04tYwj+OXXgCoJ5thtxWUHdTo5hvx3iI9kDhn5fIxXCtV?=
 =?us-ascii?Q?M760FyZtVhEo6xZhfSNGwKW047Sdz8TNpX/UasyV+ftJ/PLfjzSrwBPSVlp7?=
 =?us-ascii?Q?YHXwtboOUtVBnRwZBYa46f5n43+FFOBU7idGCvmDv02agiUq4vuEs1VUekUj?=
 =?us-ascii?Q?uK0jaLeTk1KTNtIb73pwNJYJ1fdDp1G7wdTEQqBfLD1/+T+a39V7oRIratIj?=
 =?us-ascii?Q?sxxZqrMIvn1NPJ26fNv6V2UwTSTXYEPb8Vcg2CYSwUzLAMp/4u2fVhBY8gAA?=
 =?us-ascii?Q?4ojovKxTBcsKJpm9XyfFrtlExFDXwNZTGRX1YRtF8wkhLa6zHKCL+GfUPWLs?=
 =?us-ascii?Q?VKKoRF0jWRcoHp88SLLAiTTAcZ0ETuACbC96RWNGrhanMdbdE/Vdv6smfnYJ?=
 =?us-ascii?Q?FHeHWzmOsXlRlOnVN8OSTZ++3BnHlcOcakElwl2QWjM66jfCAEkD49+jiQJD?=
 =?us-ascii?Q?XqFQrKp/yCThR3o691P4mziX6qMqZn6FOg9Z9/6SE54ssBXTWmS5hErWc1q/?=
 =?us-ascii?Q?KLqKDJePXRqtb6a5WyJf52PKvi6RZ5LOhFfKJxIf05PL8RQiznTKZCyEO2u2?=
 =?us-ascii?Q?bJ7Wh7ZUJmhxLqR6DDXq+16oidUjiNvtr95M1lFdDdyyr4SDVVNUuoH0O1jN?=
 =?us-ascii?Q?j6jr4ZLXPOvTHgWg6nmdyg5CrB3x?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(7416005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:47:06.3934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de3d0678-c094-4ea5-97f1-08dc69b2e614
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6275

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++--
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
 
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 598d78b4107f..6e31cb408dd8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2727,6 +2731,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2938,6 +2945,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3037,6 +3060,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3280,15 +3304,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->sev_es.ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
 
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 323901782547..6fd0f5862681 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1


