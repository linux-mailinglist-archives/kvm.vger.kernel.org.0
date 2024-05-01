Return-Path: <kvm+bounces-16302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD038B8652
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFDC91C213AA
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8F04E1D2;
	Wed,  1 May 2024 07:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h4UPymRT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB84DA04;
	Wed,  1 May 2024 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549655; cv=fail; b=odJYA6S0HEPnmRf06M9bj4L8B80wIS4u/Brah2IyXmnIGo6iReXSREUIg1WEoKoLXa0fP1sa7njgX/TY1mOTpbJ8iOe9omgiRm9+5VAHdSymRPtf6FDFhSxhLr+ay9mRA5hjavdgMDAuZGnoQs2urTxeNij7iaC4bV1VQ3oimNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549655; c=relaxed/simple;
	bh=SWNjXMUiQ4nFwytyHo3IEl8gpMql5RSwtJdgbTqfyi4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeT6V+DkDm9LIKLLE/dkZePOum8fisqibSALHcCZfQhmai5Bl3UhbUvTPxJBfe2Hd1LZrQV4mS9sbsP7wBzcV3FJKUBX4afgNx9GKT4+TKXjNTrzHKN/sW/K7dbixkpE10MOciXNur9iBJkLBvuZZbWriPJmUt0il0A/aBWsolU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h4UPymRT; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMszF3FLlATSC6frTe+TXMCtCDB1s78s3cOvR2/vVBnlItfSFVA2dxSMH27SLAMm8nWyX7NUSZ/vdK8Ok8hfBdJYh6Vs9JZIzl9kZICXA694zOIEwKKjJ3slZTc6UQIi/v83eFySD7OB5bdr/hWTmeh6mvwKm6DBGZxIwOWtNWjy1RvyUrJ/shL9DX5UPjknwy1uSIeVpxY1pcRcx2OzDU9ydP2WMl0B0IQEYezls7bvWvXjuRBRGnetiTe0+84lFU6TUVPJT2eQXE1XQ8WKzbuoGl2yLHilSc7VNBCm4EeRG1Sw8BfBjVZpLTqPHhE81d8Ts6I9vOF9NtefI0Ti3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iPsbHUVqfnQYObn0gY0+/pNGlt+1qkXCH3qvnDFpWw=;
 b=EIPrSxv//dapJ6UYk+iYGPFZ9ECVvgbLu2I3V0CnYqXtYH6d19MlVh2zsUQAum1TZT1jPKPl1if9xcyYUONxxXQCIFbzjsOfiKdIkJMpoMD8Ow7Vn1fDP77jYuplyH/ZpWGzKWPBbh+kR8CkmUzgUiAbq1DY7RrFOMU892EL26KsXBVBf5WlLO7/oWtc/j/4ecdUfstQFK/ffN2HlEceOG9rIZkwXR0Xb+tH2el7NPA4Vs2kGBZY0LU9nFZmBGSzRLFfZy0VJyLBmK2NWZoDrYOAS4H6+0xocaPTOAD7pMgOnEIpcAjGiRctJM8fiFQ/GIHP5N7xj/WtN3yNmuJpUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iPsbHUVqfnQYObn0gY0+/pNGlt+1qkXCH3qvnDFpWw=;
 b=h4UPymRTBoVrMvfgdEZxtmFAXdNpf9jyYNioFA8C0rEF8BV/RF9TRnvyxmSPZTcRB96NKZkew3UGw/0hGZAK8PF/8QSXPGsbF249dp1IPE4UBKwdGlRI23xo2RYyB3bDLDeOlkec7hUJUbYShSl3MKUPMj1EiMv6VF+F4wjOyl8=
Received: from CY5PR22CA0092.namprd22.prod.outlook.com (2603:10b6:930:65::7)
 by SN7PR12MB6690.namprd12.prod.outlook.com (2603:10b6:806:272::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 07:47:30 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:930:65:cafe::7a) by CY5PR22CA0092.outlook.office365.com
 (2603:10b6:930:65::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 07:47:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 07:47:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 02:47:29 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 2/4] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date: Wed, 1 May 2024 02:10:46 -0500
Message-ID: <20240501071048.2208265-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|SN7PR12MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: ed4c0486-2ae0-40c4-37f8-08dc69b2f442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|7416005|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZkOUr4mIdgIC8ZCNd/VafdF+FM90bq+xPZGJUZpp8F9Rwc1ykHoWAP4RI9Zm?=
 =?us-ascii?Q?XEn0bbfEZcMWAf7fBzjv83cfsP/OD0tJVy3ys0TG8rcwmqHsBQKbRjgO0bow?=
 =?us-ascii?Q?jIxBrqqiZuRRy+WAnbZMcm1NXAGJTJ2VDDG+mWYmB3onu2co7qTobU6l6qkm?=
 =?us-ascii?Q?Y6UxHZra3QxDBUv5Jf+9Pt5vcp0AbyzGAJnYvmmob1OCXSIKRX2QiWq1uENT?=
 =?us-ascii?Q?nQVTYQS5kyQNI1PukgD/we/+j0aM/QLqpFNPFyRc5mFT2xz/ZjdLk12w5r42?=
 =?us-ascii?Q?5FIvpd+RnueAfqELdHUv6O7qJPciL5zz2XicOVDtj0EFRnhCusBS7+LniFg8?=
 =?us-ascii?Q?GvRs7M0AoixdDAxOJyL2AVzSOdcvVr0KnI8Ajxfpy83VilYUd+hRFHlCfY8J?=
 =?us-ascii?Q?T2KsD4OjlIlD/LV+xQ/jTHREMFT4T7DCiJw9p7TbTxWxKr0OcqrjyLqxtEa7?=
 =?us-ascii?Q?BslQDLzSP9MVS5TFG2Zwwt19z2C9DL4Bn5VDQKBAXIBwefkcSd/tGK94sOPR?=
 =?us-ascii?Q?INwWdyHUJYovJiEVDGIuonxvd9JHBQGSZ0L1YjwhTZ+wDEI4vl8hQWWAKXnx?=
 =?us-ascii?Q?wVPXgAli99mc41GWFCyPhEElHAI5WVPl/WFI5ON7NhCCwup57y0vJYDYAj2f?=
 =?us-ascii?Q?s0arodEYEx0ybJejpMaUHsAJbyt7XFnkGPDehOV4r0z0dhaGJ6QR242WbqiX?=
 =?us-ascii?Q?tTtqFzWt2KRGMZHboB7YYwYwNgZSRUMkOsMpAroeH+HG4BjracRrqyAgXHK7?=
 =?us-ascii?Q?ABBIg1u9gdL+g5J4wRnf8+4vzphGPUPn1cIK4/lfQ7hVCgOoe7F4eqHfGkil?=
 =?us-ascii?Q?HS02JzeY+31ccNw2qJrwgcWU+AXU7FQOF4FXvG1ht64sd9G3FRg0jm64xRiX?=
 =?us-ascii?Q?1HtrAbIF69EGTNwI80orMiaficGu3236JVILX7G96uYwm759re3OXJwFV338?=
 =?us-ascii?Q?o2l35isYzaITltrB8JX0hO5lAk7pTmKhf4sA2WMxOEz4WJE2AGl7ZIKceJYV?=
 =?us-ascii?Q?AQqxfXjRnvh2POEvpuWCmFONA/S8mSCneyA3rARCqa8FXQ2zzdJzcrjqWrI2?=
 =?us-ascii?Q?qUrGa1t4SqGRaivsDJRbFpbnxgZpQaYzyx4Oof6+7rWbibtQ3pJ9XXvE4A4d?=
 =?us-ascii?Q?nE8pZHyWKqydhWNmWfXVhYo2zmlSUNOax3HIM2z+98zl73R2SboTOOtoZDAw?=
 =?us-ascii?Q?l1fwXp/rFgSktWvmfIXWVbigeE+EsY21O5d/QVTFeHRat1bOK1rhWmfP1Y9q?=
 =?us-ascii?Q?pqhTNrIFRhWwDC5SCviO9sJqLdHD93wP+Vqod1xxr+cptYYPsYIFq36PP71p?=
 =?us-ascii?Q?V8u3txgfAqgmQ1s7wv+6LgKYBtx/FwxhRsEDgndflog4S9fiWFcPzlhlBS/Y?=
 =?us-ascii?Q?Kbku5IM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:47:30.1819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4c0486-2ae0-40c4-37f8-08dc69b2f442
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6690

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e31cb408dd8..37d396636b71 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -36,6 +36,8 @@
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2701,6 +2703,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2961,6 +2964,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3085,6 +3094,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


