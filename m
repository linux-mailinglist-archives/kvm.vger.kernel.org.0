Return-Path: <kvm+bounces-39188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12482A44F0C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 985437A71DC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA2720FA9E;
	Tue, 25 Feb 2025 21:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RckF+1JD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C2719CD0B;
	Tue, 25 Feb 2025 21:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740519616; cv=fail; b=Y7m0RJTxvZdxY/8fw0DenDiOwl3iIyDpnf7bzH3QgbI8px9qdh6EpuXRnb5Wy1af9FPcf44/QG/Zz/Enk65BleS+hDQ5vbOk6/Y57YbLneMVavLIU/dOeGTVTzf7KZdsap69RxG6k0Qy8HnOXbnT7iyb981K9AGITEw1EKqr9hI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740519616; c=relaxed/simple;
	bh=A/iAN1K+dksNwKIzn9Pes37wOiqK7+W107Aw+Kaqq68=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtIS4rUulCa8jzWsB6XsrZu3IqhbxYm5P5Cuml/uIzL7cbrcISnucAuwOy0QWDUCEq8gEoCWeKFd40OBLJSLPMRVBDf9diMSTtd0rDHSXlvotp5IdtAo2n1r6+LV9ME0C+gFVBl9rt8+RotybYNZYWFz6WHN8KuJRkJjaDy2DSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RckF+1JD; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVtEz+XSK8SLhpJF48nHqBLt9Smq9cM7u74nb+QFdECf0vqnjmnjHKf+dJkysdUmbIzYTcoNcZvCMnVgm+hM+IcBebH+071iw0F+CBmwKlACiHcAh7JvU5eys+2KmJCTu3c2eTz0roRBPbo46i34LMXV198XwGbMFbSlu9ier919EOXH1X3VcJE3dUXsFbqehPG+DSjcMWKfOtdTOfoyiciIlXC4/geyYz6axqV0xn28KT7DcRytbmoqYgh1Y4pTjzezo2UsmAm7+n9gqnxQXUs8LssUAhDtg5pm814sgBK1x5cmcs6ZQMXBgKEXX0myNruX73YMCW69QCU65KowLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/lWliKjhINwW1telRXSKn30EsfU7Qk80tiRjzklLSI=;
 b=FCE61R0+a73FcoxZs89qsnveerAy2rQ1gTeR1mjlP8uKsdkXv6/nWwmiX3DKyckdiKwwVncGYllX2PKmN2wPML1fQxHlNGl3UcxScm8Y91dtM0oj2NGwD9TgXmiNculGKtaNP5ipRRlXYl4YyU8H1mrW4bJUXkiApNW2KfhOffPTa9+seDT1saBw9dOxYNpF6u3NwytZ5aQNyu0LtCxubRFlan8lO7rbepfrK8FxTnO/CVaeQtRCUV96bepV3LV6f9/bC1H78VIl32W7a/BaKaTQ6SVzciOyXo3VmzYdgouGsCasYodGSddWwq5B6XxcJr6xS847oB3/Bxx8io4O1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/lWliKjhINwW1telRXSKn30EsfU7Qk80tiRjzklLSI=;
 b=RckF+1JDtakZ6yGEGle2rsfA4R5lCSlG6USCNwQLnX8X1Fetsp229HEWvpl5PUfr5sNiprsDr5mEv1ScdoBj6XHXsnBKGhipDOd0ryyat+x1EmqjOYSWA9rCaFxoLYTlx+aUVr4cFQuqAXrocqT+7tP+Sh0m92fxPaS4Yxk3zYw=
Received: from PH7P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::16)
 by CYXPR12MB9278.namprd12.prod.outlook.com (2603:10b6:930:e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 21:40:09 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::fe) by PH7P220CA0004.outlook.office365.com
 (2603:10b6:510:326::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 21:40:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:40:08 +0000
Received: from ethanolx5646host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:40:07 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Paluri PavanKumar <pavankumar.paluri@amd.com>, Melody Wang
	<huibo.wang@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [PATCH v5 1/2] KVM: SVM: Convert plain error code numbers to defines
Date: Tue, 25 Feb 2025 21:39:36 +0000
Message-ID: <20250225213937.2471419-2-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250225213937.2471419-1-huibo.wang@amd.com>
References: <20250225213937.2471419-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|CYXPR12MB9278:EE_
X-MS-Office365-Filtering-Correlation-Id: eae84d0b-4a77-4774-2807-08dd55e4f991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6TdbDKGhFOIain0AwwifQSGkdBnny9n+qVksVVYWMtNdTTwaq58dM3dcZKt3?=
 =?us-ascii?Q?p+KEG7I41CkktCmQJ3Lttez/yJBnsRCOFWVMRu/4Xc+zephBQ65fJS7U7NBa?=
 =?us-ascii?Q?zZFNIv8WAv3w3tyJ05c1hN/8rZEPPES1yF9qBotc1ycEsIWoG65YmFQnYS1p?=
 =?us-ascii?Q?kt1HWUk0dfv17pCYrKQuvRSxcydObsZLhTOHjoXK2U9zzb0krTyguYRJHtB0?=
 =?us-ascii?Q?1hv7aF61byk+o1ilFkxXH+faZy0H+IFG9pQz5IvG3Yr13zRQK2gNEa1+qyQ4?=
 =?us-ascii?Q?gkf1O68iJpOc0M5tTPoEYD7xgozaqfQ5NlgFazTxIq44e8gfGTlI9fyN9MEL?=
 =?us-ascii?Q?1sKSmxyNUcwWI3xHWW8pQb0lbz4ZcRybQA4KLCOnyw1SrgMpkIt2bNQN1RqQ?=
 =?us-ascii?Q?Kfjh1lYCj2S3gqA8y/FC+Jo9GiTCA2czjgpUp84J/fhRJqFWOMeW//7AUg7P?=
 =?us-ascii?Q?VymfYy52p0eKOs0mUso+GwdaEgT+l7U9MpFKyD0uZ4Wg3V+PbCh6aPisE6g6?=
 =?us-ascii?Q?echU7F5zpTSYF1hyWpgh5yuoMx4ZKI/TDtENLEzPLY5oIwn/rCepYxaE9KzN?=
 =?us-ascii?Q?oSH7b2e838St7WgDOvhYTN5jxAa3QqZbVL/3s8nMsJnPwhDHsFHSOn+3xgiK?=
 =?us-ascii?Q?mfTKhvPfv/2HjH3d/vnNbdgayERwdR/y7/UigvZETWozZlf2DfNYdDuvf1sr?=
 =?us-ascii?Q?DMRAGVL2NwqpJr7m5bZChlcTpyFIh1MJlSuYV8Ou8gw0BNW7fTTsIqiXaxGu?=
 =?us-ascii?Q?uF1Zzwjr/H8Afepi5YEz0m/DjlTAiOgT2hu73zt95poNKYEvrzvwAKnEM1qY?=
 =?us-ascii?Q?awLGEd5AJmk8m2+1v3l7LPger80L94G/hZ9u10nYrw2EYYSIFvIZ3kGTPx+p?=
 =?us-ascii?Q?H2c2hqxVrQ315LpbCZb5FkjyBaV9i720Zv44Sh4PDzAnbeQb+sICoaTZpOgx?=
 =?us-ascii?Q?p/IWuGdtqYwNg8nrSBDcC8OeOEjQTAHnZUVBewhJtvjUKjNTMEx0NOHJpKj0?=
 =?us-ascii?Q?VTuddyIwv8psz1WuBgrV3iF4+MplFrJwUoT7rvhxP63nwcdpQe1kBHjZ3wIs?=
 =?us-ascii?Q?rpoc0t+FxpjLBZfC7s5sLKBR12E0wJEOTCMD0G3JvF+W0sJIkC8W4TYRNOtp?=
 =?us-ascii?Q?S9mSokF9auEvsrlB8j1b13XCuXcFDcHqhzzjjWhjbfVOzfftpvL0yDvY3QJE?=
 =?us-ascii?Q?ktNZGqxjQRpDdVcvFji66KiZqHEFPy6ZJ8/WakU3QRarcpxqpWsmvk50CR+0?=
 =?us-ascii?Q?2qRPpdlq73wc/RXeufFn4OdOQ8wcH+vvKHbpxLAdzvHs5nW0MzSnLnZTuNMn?=
 =?us-ascii?Q?NDV28BWeEfcZdXO9l+Fv6up7ZqVHSRtd2G4XXFwykNuXYn/xU5m5aIMsiDhT?=
 =?us-ascii?Q?qjzffIxCUJ15RqYyTkaJsJwWjkNSDul7YL59duq1VVeHS+uL0PfP7mwLbRxT?=
 =?us-ascii?Q?zRApcE/JrIAoMAohCdvcLiQYVktqKoVuX3a8w6r+2p3jgRxmGYbKgrRV+ohr?=
 =?us-ascii?Q?11Pq7e2MwRZJ6Sc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:40:08.3641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eae84d0b-4a77-4774-2807-08dd55e4f991
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9278

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
index dcbccdb280f9..3aca97d22cdc 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -211,6 +211,14 @@ struct snp_psc_desc {
 
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
index 0dbb25442ec1..bc42c93d2b97 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3430,7 +3430,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
 
 	/* Resume the guest to "return" the error code. */
@@ -3574,7 +3574,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
@@ -4135,7 +4135,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
@@ -4328,7 +4328,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_NO_ACTION);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
@@ -4378,7 +4378,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
@@ -4408,7 +4408,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a713c803a3a3..e14f8ae7d868 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2973,7 +2973,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
 				X86_TRAP_GP |
 				SVM_EVTINJ_TYPE_EXEPT |
-- 
2.34.1


