Return-Path: <kvm+bounces-33231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F9B9E7B85
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2E61282604
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 22:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A5E213E64;
	Fri,  6 Dec 2024 22:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hy65Hmtu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36232204592;
	Fri,  6 Dec 2024 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523214; cv=fail; b=mUbQBsqC0tjDEP+rzMFikktGFvEipWVnNwuFh6zzmXtW4R0MARHgfgcwIkwhap0BffFu0xC3ZuqCBv0lVXg7rriwae2pfDzFO8FY0Mn3ETno7bP/qY/Xw+2xXjmRWko8SwmvdxwhWbtBpmsW2zBNBDqcvZWQYL89e7S7cNSEhzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523214; c=relaxed/simple;
	bh=vQa66D7bUfk37c5mxxUvvBqN705xKoSQPNu6RdVMpIo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzXAUjd2SyQ1WJuiRKlvW8HUPxTzG2gmqf+dEje2TBqiuaBPNeWbr6kYqLJ2+WadjU2iIcH3jPGczRIErjkRVdIxNecrcm/ArkRsNSQ9pBu6NUW0xLBSI9eXstB+vLXJ/Wa9aFrtHmx0TP5qd9UZEfWsJcOtUpnVpcrK9USbxcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hy65Hmtu; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1/rHU1HiH08sK3LwTbLackywIIR+3X1TruwLWbDqXekGvX6l+AVDd6iMZiAnvxefTvRZJT2eb6L9rdTFQroRW0iIEp6iagw6BNcE58vGobfx02jFP0T0tGmZ4NgU+Sb8EUtlLnCzSEtYEWiUF7mXkM6f85DuXMIbGbJZd4kduMI55S7FcFhMn/kvBeK+MLNp8MtkT81VlS7fc5pSP+sFcTlADA2w3Oc5xBtWQZfQNZ7c5XPQ5MDjOEix69/2ucBCkYM57ntpoc8zYoRtcS4GHkzu8ClWmnrYYTZbKRJ8dySX6m5vCiUeiADvYQbKbXOdNb1KnI0w/k/7CIg0SDN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5+Tj+ZbiZQgeJDfsW93QeR/0JwYc5inVWMpP/0CzNU=;
 b=HQBauu8BteygIP44ZsXjw0+TT4R9bW2BVH55ERqCG2Ssnq3rhSS//cLj+cDDjMeNgBJKVuDOBPUFNBvk09Ecd6clptRMyBGX0ycc0XG5mn/J/D9URmrhZnF3VgCyaqFybKVoPxc6u6YfA8gQpbY35goYigg0s17Q5QHNP8kEEZWLNiJD4yVfSgW6a0t/PA2p7/9jrPFx+g6pjNJFWvxAORFVRmY064gI3PtTKhaO3Y7erBGJfxPXep4ldIKLsA0HcTzpMVdfHsokBfjCWKvAveJJMwNCOShjfAVqUGrP91dVLPg3Nj8F1qv1L9SVXe5EXXGjmUqjaYZeFzznU1muow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5+Tj+ZbiZQgeJDfsW93QeR/0JwYc5inVWMpP/0CzNU=;
 b=hy65HmtuKo9KCY2xz4rP+eP6LqrMdMYXq4N6/4D8Os1p+oX3Lb5sduQrGc9z6aSvYKKQwZPjMEcjr+mwXk+cXKmVjZh59XNDVLBhoky+6iLJUgJ7Xvs8YeDfnJaXCRtvKMjgKMn2K9RF5b175hEJJ4h3nE7AqdnEfurd+24ab1s=
Received: from BN9PR03CA0987.namprd03.prod.outlook.com (2603:10b6:408:109::32)
 by SN7PR12MB7225.namprd12.prod.outlook.com (2603:10b6:806:2a8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Fri, 6 Dec
 2024 22:13:28 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:109:cafe::d2) by BN9PR03CA0987.outlook.office365.com
 (2603:10b6:408:109::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Fri,
 6 Dec 2024 22:13:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Fri, 6 Dec 2024 22:13:28 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 6 Dec
 2024 16:13:27 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>, "Pavan
 Kumar Paluri" <papaluri@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Convert plain error code numbers to defines
Date: Fri, 6 Dec 2024 22:12:56 +0000
Message-ID: <20241206221257.7167-2-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241206221257.7167-1-huibo.wang@amd.com>
References: <20241206221257.7167-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|SN7PR12MB7225:EE_
X-MS-Office365-Filtering-Correlation-Id: 14dbb7b1-4ef6-46f1-9f20-08dd1643360f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QtTJwuvHHK1USTpNI30n81E4snIRCzbuvVUhlp1glv+WoeaBWb7SNCuKZ8za?=
 =?us-ascii?Q?+FJFBj46nmMxAP64eX/p7x4tFl9GC7KabH7PpN5bzIEjR9gLsKCZfzCRMqL9?=
 =?us-ascii?Q?Z1pGYIk2a0O6S3XDfecrp1xPi4hnQl/R86ZRlBJ3Qu0bMhVb4BpWB8k8pGAK?=
 =?us-ascii?Q?to/YpQwyeCD4eerMTg6av5uhth+rcKubJQ64NYq02mxorykth6hBJtSY0YTn?=
 =?us-ascii?Q?DF+56lsMTVku9hbra7stuLz+jAnfkEGI57GwMaLJMyo1d914xWFfnMp2T8qG?=
 =?us-ascii?Q?Cibsa6b1y9sL9htqcqKmvmrIXrN5KxgSM64uMOVue1fEbkl6JGDwIvI0WsQK?=
 =?us-ascii?Q?txV5367BE4Udb2YMsd6FHDW6p7StggXJgMoZutTYIBcmCv4kfa5U8a+cBCJR?=
 =?us-ascii?Q?biyuUyQC4yt4nz0t7k3RNU+mfwRqTDRdquNVzXriREZPxyRZUCubuyWz/DSn?=
 =?us-ascii?Q?GvHH5nk3H6cmzFxU9tXTeAy+JufNXBHloEV07vOWPPePPDF/tMNNi8dIBEbb?=
 =?us-ascii?Q?sanfFqjtX3dnjPpKATogeGvdW03q8GswbKtLovwEgHVNmgc4UMxdl/5x8EyB?=
 =?us-ascii?Q?6o3ifqDehIw9EcMfP637bKbW145eLQSJZAPkZL/TXA0mVpvFerbi4Rfbut3I?=
 =?us-ascii?Q?LwGDTL7mIDi3JyB2AL/CAhIBeCGaz9GPEBCFDVmTH4fuVu7hZnIOTNGjL3MP?=
 =?us-ascii?Q?FdWXK5YZln7DpK30Zbpmc/xUYSwEwo6sMzA6lt6/svvyx2nEDRVSXguFmTfu?=
 =?us-ascii?Q?3NLWKh+bfN6lifr3lZdF3xqfUSs7LuxMercoEJ/AYGv5qJhgKFOLH1jJqEk+?=
 =?us-ascii?Q?ki5S7BdoXWeiKovn1oMVUYYQDjGmPIsfwgtG1gDZiARaRkPTSCQfYXR+vz3E?=
 =?us-ascii?Q?Xs1JDbhbXQlC9qUapwjdfCR4ggyTs4RyD1q0vumto11Dkm32M5vIHJC/QsKs?=
 =?us-ascii?Q?i7diP5sh/cU1FZltOGlUKrvCyHkLWzcFZl0cP+uHXqYDF9jHFC1nCOgMtbkD?=
 =?us-ascii?Q?UoM+MDmKDrNIdyx8H/DJGY3vVa41k4tujfxabyXNrpVBfAo0+SVhWjNILxys?=
 =?us-ascii?Q?nrBpXIr4vfMHn9avQngyfN8cnkGP0kgikkHgEEsZzAQFHQJ3byZ4l6+WrB5x?=
 =?us-ascii?Q?gIlO/430vcGjUpbr8zJM2sURK7yQnOR8TlnCgjiCyCOIRN/zFVbDQN2OsLtX?=
 =?us-ascii?Q?9qHs91y9bOOrPjdG0WJfm/Bq4tZJ0w9mmYJYYkRjV7miN0oyE38AnMynU5Nb?=
 =?us-ascii?Q?c3J31ARxVdqu315WWETjN2Yg/loakK1JFWN+w1e8/4uusftR/Y9+XmcXjw1s?=
 =?us-ascii?Q?SHpQbTUBv1jovKSMBSPWxm0bdmvo93RNxi+gkHqJ+7MUvoEgL0uCetC/wfCu?=
 =?us-ascii?Q?BiS+mLP6/r3fp438Gr4i8XhJ8P4fOD5aYD+evZFfNJYP9ym+DKBGK3t4C+sS?=
 =?us-ascii?Q?vxZil2XF+YT4iKM5JtBJijVX07ibW9xQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 22:13:28.1310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dbb7b1-4ef6-46f1-9f20-08dd1643360f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7225

Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.

No functionality changed.

Signed-off-by: Melody Wang <huibo.wang@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 12 ++++++------
 arch/x86/kvm/svm/svm.c            |  2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 98726c2b04f8..01d4744e880a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -209,6 +209,14 @@ struct snp_psc_desc {
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+/*
+ * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
+ * communicated back to the guest
+ */
+#define GHCB_HV_RESP_SUCCESS		0
+#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
+#define GHCB_HV_RESP_MALFORMED_INPUT	2
+
 /*
  * Error codes related to GHCB input that can be communicated back to the guest
  * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 72674b8825c4..e7db7a5703b7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3433,7 +3433,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
 
 	/* Resume the guest to "return" the error code. */
@@ -3577,7 +3577,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
@@ -4124,7 +4124,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
@@ -4317,7 +4317,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
@@ -4367,7 +4367,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
@@ -4397,7 +4397,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..58bce5f1ab0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2977,7 +2977,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
 				X86_TRAP_GP |
 				SVM_EVTINJ_TYPE_EXEPT |
-- 
2.34.1


