Return-Path: <kvm+bounces-33232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFDB9E7B87
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A52C16A569
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 22:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D3B213E8C;
	Fri,  6 Dec 2024 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uKVZCSva"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B222C6C0;
	Fri,  6 Dec 2024 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523238; cv=fail; b=lRhzYqUFNwXWYPhBdLMz2whrwnhS9g89widaKhdrvAOGUWRZ5TnWsPeZRf3NfsnYCa8SHYRaNicPHdIJ7CuJLXKcX/GIDu4cOa2hJHTewKxeNGlu6BUH52gcji/7fZaEjLu8lq26RidmOmrC/pbyng7sXF8xW5FmdRCrKHwVlUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523238; c=relaxed/simple;
	bh=4dtbGJxb9djd9qTLkL+51yl3XDHmb2r2sSyL6u14efY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjDi8DSvAIuBwF7lh9hZd7mVS+gg0vKIFbwmwMHIWs+PkSgZyaZjRb7iM/pGZjEi42Bjr3j8dUfslZO+z4lX7ed05x7ZT94P12B8YqVt3SuTPO4WXfTA+S8pKeVkZXae++lc+4XeAB8YEcyMQUIfq6kSx1Y3QIv8ch2+kDSbFWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uKVZCSva; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLpxN5907nIab334NzDMwyHd6PixCG9ibIsOk3MQaKu+grDt4W0ODzCDAsD3pwb/wqBQe9PnTt56bujA0kRUhUuACv9XLiBKinSX3WSwnbmSd3gaBAWDAQY57wa/OFDuWr/uPA3mskvUCDSmjY3W/b/iUmjXcjjOcNDh5CAhY6WPO94fJnfmJ8p5qqDi0uacnphYxg9sXQMhRJ828XicBV1JzG/Lg/WyLof0lwiLPTv64c/g/PHo0euSNvMtyf3RQOfmBtIV+slLM3Cit7+gqZgYTAdQ//pmpWLVFQ5ZeP6BEhX1/UgyY2BV1BIVbHTBoNCtIHnAGe4/jDLbjYvgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyL+IE+eCha3dXEYBgkUPhnUi/1gCetOfEXmNAM8Uig=;
 b=haXywSzJ64EVwcZEmoS0cGYp6L9nfoaqBcXNJ+nVHYFSzf9tYp41Wwq+eMS5POWIakF9B89zg11ykbcopbaiBuFXicas96JaolgiyqWJnKqpZVN/pr9BuNjp6YW42XavfAsoSeW1IbSv1VbXQZrzG/PBRrEhj5zcSIizZGQ9m7nypawsOARqrWN7Cnhy1tKaM1iVn5zlud2kNCFEwA/dWg/PzR8v0Z/tG6qnQ+mDhxqg1PqefBzqrJCqPJg9DDgC/WJDcOtwnKS1HcuyrsAPNpaeiTX9/0T2b2Jvqm8ojHs1+zpOF/AQjlANFNm6iNrlFqpRFcnCgmy/NRIvB42lfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyL+IE+eCha3dXEYBgkUPhnUi/1gCetOfEXmNAM8Uig=;
 b=uKVZCSvagLOwokMh+R0LDTkcxV8y17Qi42g72iqdPIg2DntFRQNJto8YOCbedxVGJQpsORDOigOV2cRonEOpGmcz2LjY3cR7yiAVVCXV55pTd16rNPKW//RNgkIEiLXdt9Uc1R6foPpeMDHQxP4h+62bpiPqc8rcMffyr76oNtQ=
Received: from BL1PR13CA0146.namprd13.prod.outlook.com (2603:10b6:208:2bb::31)
 by SA1PR12MB6848.namprd12.prod.outlook.com (2603:10b6:806:25f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.22; Fri, 6 Dec
 2024 22:13:50 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::c3) by BL1PR13CA0146.outlook.office365.com
 (2603:10b6:208:2bb::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.9 via Frontend Transport; Fri, 6
 Dec 2024 22:13:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Fri, 6 Dec 2024 22:13:49 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 6 Dec
 2024 16:13:48 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Provide helpers to set the error code
Date: Fri, 6 Dec 2024 22:12:57 +0000
Message-ID: <20241206221257.7167-3-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|SA1PR12MB6848:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e3cffa-cbce-477d-9a17-08dd164342d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TM9Tp17kDkL4qbBtGCrhAVo/ChyIN6m47jSxZAYu96ZCEj9OukjuEZwcZBGh?=
 =?us-ascii?Q?AP4zad29GN4l/7x0hiAENDqfPMjRiZy9Tj7IMpTbvBoWKmVlMfXY9+pYsZqM?=
 =?us-ascii?Q?NoB/GuLa+nK9BCMEgtaKebA6eoId6Cnejn/vV9Cj24slBjLSAttVLJHTkEzr?=
 =?us-ascii?Q?zzXNzd6/+3AAUtavk9JXZWgp/hr6uAynKtkEbD4iE6XnwBxoiiJYESaQ4+ty?=
 =?us-ascii?Q?+Vfl8Nr9+O36Kvj+oexxcGaZ9eOSHSPcBaC6Vp0kGus0KcTZ/poEkBKlQT5O?=
 =?us-ascii?Q?RURL39XwoDlp55qMbSK4a8PMLld1tpWH3JlkAK1+t2eJUQj1jzn1t7CgBcML?=
 =?us-ascii?Q?ik3N4P+C3syRPmslfdBPx5Mc0qo4aMZdtqG88HvOuAtbnydFtoBwcNRrSJgM?=
 =?us-ascii?Q?EoFa9TbYHqJ+NCY7kFHIptxHfCZbPr0P1wkvgYugs8xK74nE6SfdZlcB5l5u?=
 =?us-ascii?Q?8DN3s5gMSm/REhttOa0IczG40nFb3JhWzacnX31kHCBk7Rv+r9/vjtSk+2+0?=
 =?us-ascii?Q?ZEPk3HVJ7IjlqvOcQwdLgK+ser8GpycS2T0KC0ervPbFjCLOg43FhmcNHpOg?=
 =?us-ascii?Q?hBEsv9+1Y/JfnDx+50hD0nHm2A6uUf53MJ5jcsOVmsOuld6cXHT55flHt9ye?=
 =?us-ascii?Q?xd+oRkfdRsdRAWx/LwMSXeGhDGTB8reN85lC0eJfKRbIOqe46IfJv5QDRfTG?=
 =?us-ascii?Q?4COxUnJ+uf228cVzv0eIgJamEEuJSX7AiPBxYA1iCCrxbD4/30LdAtAs7wqN?=
 =?us-ascii?Q?BrntD6gjy58Iz81b5M3oUp/Oaygtx3Gdidc5hlC58DOqfJysbnwaQoFv8ZX9?=
 =?us-ascii?Q?lCZcoHNnKrN5lRbR+OM9mpjGtWcNDP2rxRCUjCWhq9vedb5M1okLBWzyHqMN?=
 =?us-ascii?Q?QSAQjJJOdcT8jzVFtjbhMmCQaQ458WpfY/2X3mC+0fLqjQ3lONagAN3qBaWL?=
 =?us-ascii?Q?LQsW7JeDS0o1hS24ujC9UGV+cr3gJLzvTIb+U5cJfOxhVM8AtbC/snY/P83U?=
 =?us-ascii?Q?igdBLs6Xe2IxTq8UX59DcXB808zQ60fC5a9+0eMKiC3aPPD7fJmLRWZD9i1D?=
 =?us-ascii?Q?GfMBg6NmCRq2zm6T3lBsyudxjPRSji6KNr3wPM0HTojwCa+zZHObH3ZQ8sr+?=
 =?us-ascii?Q?NpOfbVY+hj0vK6BksH2YpS8guvj55JkT3QI72YMSNECMzb+fP4XU/Kbd4/wL?=
 =?us-ascii?Q?BX2f5zCMC8WTWZDkocjqEcDJkpq8NxI2KlM2/PShHUh974Pwb/tbAHtIFVNa?=
 =?us-ascii?Q?YGbNeqhzq0TDS9eKRUjMVqMyJ3kZjNlwvZz2kA6UApFWx2y56LdjOLfqbkxU?=
 =?us-ascii?Q?XsPOz4G84MtcKqND4EWKlNg1Ybs4I+vEfz3fXGUA/zCdY0s4ItKKuMdps1Im?=
 =?us-ascii?Q?V8XyiAmUV6P3Sf7wvs3+SwDD5Y8TJ/SOjyIBzoECIyafVel1sA0pckOneK6a?=
 =?us-ascii?Q?FNGpYW9P8N6spTeztChEvBpp2Rl3pc39?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 22:13:49.5571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e3cffa-cbce-477d-9a17-08dd164342d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6848

Provide helpers to set the error code when converting VMGEXIT SW_EXITINFO1 and
SW_EXITINFO2 codes from plain numbers to proper defines. Add comments for
better code readability.

No functionality changed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/kvm/svm/sev.c | 39 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c |  6 +-----
 arch/x86/kvm/svm/svm.h | 24 ++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e7db7a5703b7..409f77a6151e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3433,8 +3433,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
+	svm_vmgexit_bad_input(svm, reason);
 
 	/* Resume the guest to "return" the error code. */
 	return 1;
@@ -3577,8 +3576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -3671,7 +3669,11 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 	svm->sev_es.psc_inflight = 0;
 	svm->sev_es.psc_idx = 0;
 	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+	/*
+	 * psc_ret contains 0 if all entries have been processed successfully
+	 * or a reason code identifying why the request has not completed.
+	 */
+	svm_vmgexit_set_return_code(svm, 0, psc_ret);
 }
 
 static void __snp_complete_one_psc(struct vcpu_svm *svm)
@@ -4067,8 +4069,12 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 		ret = -EIO;
 		goto out_unlock;
 	}
-
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
+	/*
+	 * SNP_GUEST_ERR(0, fw_err): Upper 32-bits (63:32) will contain the
+	 * return code from the hypervisor. Lower 32-bits (31:0) will contain
+	 * the return code from the firmware call (0 = success)
+	 */
+	svm_vmgexit_set_return_code(svm, 0, SNP_GUEST_ERR(0, fw_err));
 
 	ret = 1; /* resume guest */
 
@@ -4124,8 +4130,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
 
@@ -4317,8 +4322,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
+	svm_vmgexit_success(svm, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
@@ -4362,20 +4366,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, sev->ap_jump_table);
+			svm_vmgexit_set_return_code(svm, 0, sev->ap_jump_table);
 			break;
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_HV_FEATURES:
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+		/* Get hypervisor supported features */
+		svm_vmgexit_success(svm, GHCB_HV_FT_SUPPORTED);
 
 		ret = 1;
 		break;
@@ -4397,8 +4401,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
@@ -4635,7 +4638,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		svm_vmgexit_success(svm, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58bce5f1ab0c..104e13d59c8a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2977,11 +2977,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
-				X86_TRAP_GP |
-				SVM_EVTINJ_TYPE_EXEPT |
-				SVM_EVTINJ_VALID);
+	svm_vmgexit_inject_exception(svm, X86_TRAP_GP);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..baff8237c5c9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -588,6 +588,30 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 		return false;
 }
 
+static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
+						u64 response, u64 data)
+{
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
+}
+
+static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8 vector)
+{
+	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;
+
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
+}
+
+static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suberror)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror);
+}
+
+static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_SUCCESS, data);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.34.1


