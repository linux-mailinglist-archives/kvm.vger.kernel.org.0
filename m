Return-Path: <kvm+bounces-34416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6034E9FEAA5
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 21:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E4021883438
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 20:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7F619C560;
	Mon, 30 Dec 2024 20:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pfOkBxdA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1600819ABAC;
	Mon, 30 Dec 2024 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735591044; cv=fail; b=tUXpv1HYmyvlLCXTqtzZiGlZrIQwZTM+m41EukiUhFcVsjg+8vQBD1rsysv7nmnIw6Nnf9CIgAbJRt5ZiFKaMyJRtU+6DT/mAW3ouvI0AfqY3IhWTSLCMZ2E7uLpj1pwhioEQL+ofxSVU4y3BHAf1IlX5tPu2HEgk4GKuw8EAhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735591044; c=relaxed/simple;
	bh=pgJwhJjL+aV6M1xuHgmAJXjoBQaHyEjiRYahOicgnkc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0vWysEfwT0qOZnnd49wS6cqGu3hRB6M6FR4E1wRRQGS5hAV+DrIacqjTjxG3idQGYYldNiAM/R/1v7Jk2K10b/gbVnqbP39YdqxLM1PTuQnahf3BRJz4lln+LEi6SVWbqNyyrqlzsHCul/qMQz4pIzbqdmMs8foiaQt13ohiqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pfOkBxdA; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EBKrtcTy+PxsX7b/KF2WEB/E7AR0KTcbsZJ2f+R/ynDBLzv/AX6VMYK5qVyg5HhyAki5D16n9pJVmd77haGSR/+DT4LhPmj34XZEfn6ei1ebbVoXvcK+hw/Pw3W0RNb2UkzsNcjF7trrHQ6sl0AKS32HNbwW6fO+euig+yG7hvQmGkDCsuZGcvqXKLPRMeWu0BvQXpDCpzw3PZnRq5FatQQKrQGj+sTP3zNe1wFOrHZq5GpdBM3kw2II5+EUHIxr3SQEIHNQOSp+WCH8UUcB3D0WkePkH76YgtR/WdMHgBD/sWoG/q7Dddgq3iWEYv8yl6U2IFqyzuY4eAyAnTOgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+gy7rEfOLZs7Bz1D4YwLnaYuftWkumu9xFQ7ASjUow=;
 b=NpzyTCWzJLNek6PkWnzIpl1eGKBtnbxJczZAqTFLy47/7nL63JEknrFvFb2GwSER32zAEzAjA7xyD02hetiA9FbtwPk+AphuJQ0eGGOyioQaSLGoina/+8jU588S4Lm+ANbrffVVkLTLmO1YwekpkeulTxywuYO/OjYgVKA7387ybccNj2ykM8s4/PHTP4PkXTJ5Q4dkjbVaPE9Kjb42MAuu0qAEJ/2fXimA59JiEItCvHuvFWKdeNpkJmHGiaajFgfOZTl+aYSo0Lp/lu2+tFD6X8DnXU2EyZbgHQwEpw95EYyADeH9iURZKX98gcpt1SSIdvMMZ+WRUszHlA5PuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+gy7rEfOLZs7Bz1D4YwLnaYuftWkumu9xFQ7ASjUow=;
 b=pfOkBxdAgqSKGXPHbqYFS04kImoTLYZxJ7Sd3bN6wWgIWNK5MfUl98Y+zmB1s5v7YHpYRYlygtGZk7n6579Gqi5rgmOU0LKXwNZyMhF5PP/a910467zrJRBCHSMPDx4n9cuIjyynzz4CCDkAaIUlnPTa7G1ukMEEoJSNOiq+1qI=
Received: from CH2PR11CA0012.namprd11.prod.outlook.com (2603:10b6:610:54::22)
 by IA1PR12MB7760.namprd12.prod.outlook.com (2603:10b6:208:418::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Mon, 30 Dec
 2024 20:37:14 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:54:cafe::4e) by CH2PR11CA0012.outlook.office365.com
 (2603:10b6:610:54::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.19 via Frontend Transport; Mon,
 30 Dec 2024 20:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.0 via Frontend Transport; Mon, 30 Dec 2024 20:37:14 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Dec
 2024 14:37:13 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>, "Pavan
 Kumar Paluri" <papaluri@amd.com>
Subject: [PATCH v4 1/2] KVM: SVM: Convert plain error code numbers to defines
Date: Mon, 30 Dec 2024 20:36:39 +0000
Message-ID: <1d6215bcb4b92716733df8870769254e267317e0.1735590556.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735590556.git.huibo.wang@amd.com>
References: <cover.1735590556.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bcfe758-2fd2-4767-d0af-08dd2911be74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bklw+c6ohVIvrqx603DsJqlQ6DOPPQZtqKU17Blp34eAtcaqNi+mTDMiGct5?=
 =?us-ascii?Q?ZswVfcxANjoCqJD0CDmAQpUOJW4yRhA4D+22QIpnmavi7crk5d//CXclMyV1?=
 =?us-ascii?Q?a85tEIsv71xBQj+EQFeFyMlJQwetH9wpiv/va8d8wX79aQ6y4wth4aXFxtns?=
 =?us-ascii?Q?ZFfqtaYS0rQA/fZx/eMiIzXlPtOBkkKoZ4bHsRSt/tTrNZA8v1CoTYIjS1Jf?=
 =?us-ascii?Q?zASuol7/IkOsOKmu+dXPCf08xsFgsADmoOaC3OmSFftHIuyBMNVVhh7TsHqx?=
 =?us-ascii?Q?oCoxw0G+YT7P2KCTZHt0vISiJ/R1wBIf2sDkVanFF5gIGTZJzyEwfW6vqqPK?=
 =?us-ascii?Q?G3JbxZwbybwYtvnTOkU8HEDHrA/6oW8OYCJGUwBUP5NsfxSAZGswQ7ppHk17?=
 =?us-ascii?Q?HJDZJfZN6rVsjYM9kpcCSXFCoSPokC+e+L1rXcrJylpu6J5xyy2cA3qZsNVm?=
 =?us-ascii?Q?wtgZF0p0Va2iF0BNInydHdIsKMjcg/UBPwXWWuY+3UGn+pSIwpNSiAe+de3/?=
 =?us-ascii?Q?vHWPCW6xOY4XBi+vByzc82uFzn7rtXYe4zSLqC4ur1gy0dWyOXUYRgn2ZGNv?=
 =?us-ascii?Q?f3kcbV19jll4L2ZF4sdpmRcsZNbegR8JFzgllm/4W9Wly/hXxLSDvLxyJJG5?=
 =?us-ascii?Q?voVR7CasBhv92Slqv8W5nrz2fxUvzsSeqdX5Y0U9XCvQ6w4LINJSgd/Vh7KQ?=
 =?us-ascii?Q?PuvShbp8VwBiVICz7xw+F/ShQf80ZUvV7jUwzsZI85FqabOeoSn+FyRTjCPQ?=
 =?us-ascii?Q?btHpvNyqaS+d6HnbdVv+AzRMmmPluKqyKaSluteDfwiMbYgK0xEUZJNwKNFw?=
 =?us-ascii?Q?tHHJLDsD0wxzVbQYButdkWHAPtg52Vx2JTq4giR74wxiLqkW5uu8zTDoloub?=
 =?us-ascii?Q?xrL3eQY4/bGGrUlGFRy0f4XF9WVO5FO9zRjo+YTqrg4pdSNLy4i9gO08Xl5Z?=
 =?us-ascii?Q?mSG8Pvu2e8wO3l/J9LnvrXvvN8WLoCfl0fB2AxHOoaXqD+FXGlXFPZ+gxrAr?=
 =?us-ascii?Q?H0ozdd6QysxABSaLrIz6lNjKODg1wPAPe/P3+TWl4Cd1TFpVFUQaGArKJjc6?=
 =?us-ascii?Q?RlgEGtOvB2VrtSzTgrELpmiGPU25Vr/QnEeESBp14c0GSv1LkJAANo7K3xX4?=
 =?us-ascii?Q?miF5GqWNcuApvdaTDvcC1fuicmEqCVEC7yFpnA4SO8BMZcqcUI510rF+r3vs?=
 =?us-ascii?Q?eR8S6JFVfUu4ph8i5zbvVohvb+JQCQra0tGVF2yQqXegALzc7Vu5NRDx2reH?=
 =?us-ascii?Q?bp1GxeWgm9w8Vkfmc7Ppt/jvyVPeVH4i7QU4QCZSDZCVQvUFt/Hxi7KmdsD2?=
 =?us-ascii?Q?w3ETzIFSf9Z3rOpeiWWnovV7vdkZxEC9rBymQMocxE8hUZyRgUAhvi8bNSrs?=
 =?us-ascii?Q?FTXddMtVQ/Du+yfosDJ3bDmVQ5TGEwnYCUWlK3hu1+PT3NyuiG/a+lKz8Tr9?=
 =?us-ascii?Q?T9SnjFGuDrokIg6TYpsxGCNRr8vR5HyQbe3L+MSiLMaYc7Foc9wjk/ehQtVY?=
 =?us-ascii?Q?mr4curPgP44vrZU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2024 20:37:14.2050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bcfe758-2fd2-4767-d0af-08dd2911be74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760

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
index 50f5666938c0..ac166af9a422 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -209,6 +209,14 @@ struct snp_psc_desc {
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+/*
+ * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
+ * communicated back to the guest
+ */
+#define GHCB_HV_RESP_NO_ACTION		0
+#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
+#define GHCB_HV_RESP_MALFORMED_INPUT	2
+
 /*
  * Error codes related to GHCB input that can be communicated back to the guest
  * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..59a0d8292f87 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3420,7 +3420,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
 
 	/* Resume the guest to "return" the error code. */
@@ -3564,7 +3564,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
@@ -4111,7 +4111,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
@@ -4304,7 +4304,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_NO_ACTION);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
@@ -4354,7 +4354,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
@@ -4384,7 +4384,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21dacd312779..0de2bf132056 100644
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


