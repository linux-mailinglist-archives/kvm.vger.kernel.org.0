Return-Path: <kvm+bounces-32856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2539E0E1C
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 22:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 946DCB2AA76
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 21:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1231DF729;
	Mon,  2 Dec 2024 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gi2bthN7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D2F2EAF7;
	Mon,  2 Dec 2024 21:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733175653; cv=fail; b=qSLINVmtv6S+vkNoZ5ICtPjYRVKTRv21fGMLXZsFklBJI3WuZeWdiIZ8koAQ3kNHHZm7YSkrJYq6QMh3gII6iym6upoORkm1N2nQC9T/2TLnT9v7Slq5Zeq4OQ0Ki/hrubZD+xE8d+/8rqjylmP5Do0T+oL98MpScSQD8Hbb+tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733175653; c=relaxed/simple;
	bh=vQa66D7bUfk37c5mxxUvvBqN705xKoSQPNu6RdVMpIo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZAWOBnkPUCniC79XjIWcJRHZYyyw0+qEudLjB4Fwv71YRxCNFlP6nsPL01yjD+KTBFWUcgzwkPSxiTXDIR6pm3jsaOc5uW2IMRIe+wnsPPZ2MNWgA+LU9mQkKTtqHwAMO69YsSolxkb/fOl1zfioiUHrf3NpO7CujQ6D/Le8l5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gi2bthN7; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7I54FGNzKbRhWiJbPNyHKRvdLww/aWOWxcDI+eT+VRiDlIldkYrxBVLT3BNcxANYPyeU3kpIf9LFsc1WWJ5rEEbSpR6j2C7KOHczYzYOQgVPN3ipPNzcv55EbvlOBChjRFuFFwM72L8m9C6DCyHNlfgsBjQs5IWDRi9oXglofFqrJDp1QztK6fC1vabx3/thMBRcC3MSEXgJrbf2+APjOfOlwjt9GWwHKQCBCC9JX0+rQUAV6GCAMA9SY3/HLDw/VhPx9xFqZsLmqTW/JZLEfgTeKBZFtBjatZQNu3pjbNvsmlb2Kxltq0CYl76kn2bf9q8fTJmxrsP/VBrfkCMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5+Tj+ZbiZQgeJDfsW93QeR/0JwYc5inVWMpP/0CzNU=;
 b=kUrKcqzLxkx3rxjt2dzCE2vvdTl1QQjJ0bw9Ep6zjQIpwGvu2vFFj6d/pJ82z9PW4gsvaTV9ZZzoHLLaQhfZRfvqINco0+3DfXqPOoy72zz6FH5RRqLtjIOH2CejTtcFrXIdnTs6TsyWGoyVun0q0iWBAcgyCK+DWq5n2ehyv7/oDV5wXlIy/lRcNkUIATxRp7gogFfvTrKHr965ywPtNPUPzram4bBtipvRhr0sV11JgXSMvhUVwMqFF8EC2PJNsGurDJ2f8FI3T2tk5PrScAat6dfVHX2/PT0qr0nC2+yweoUC/5i+Q7R+WWNaqTGRDhfTI784w7PO5Z0vjimYvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5+Tj+ZbiZQgeJDfsW93QeR/0JwYc5inVWMpP/0CzNU=;
 b=gi2bthN7bsv/IP28+mcAMQOnFpLxooWnNF6JlXXoUO2I+VR0uDxOM8fEWjNefSAFgCeqbG3coKZQtKFkS2U/BkKpRjKUtUE+voGR8lQYg8E2EuObummRcQVQ4PS2CzYvoA8mnHtvbRXHo6UM6Tjjpibk4iLQxYSkQtbMBfWKoYA=
Received: from CH0P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::15)
 by DS0PR12MB9057.namprd12.prod.outlook.com (2603:10b6:8:c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Mon, 2 Dec
 2024 21:40:47 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::c8) by CH0P221CA0010.outlook.office365.com
 (2603:10b6:610:11c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Mon,
 2 Dec 2024 21:40:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 2 Dec 2024 21:40:47 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Dec
 2024 15:40:46 -0600
From: Melody Wang <huibo.wang@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: X86 ML <x86@kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, KVM
	<kvm@vger.kernel.org>, Melody Wang <huibo.wang@amd.com>, Pavan Kumar Paluri
	<papaluri@amd.com>
Subject: [PATCH v2] KVM: SVM: Convert plain error code numbers to defines
Date: Mon, 2 Dec 2024 21:40:32 +0000
Message-ID: <20241202214032.350109-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|DS0PR12MB9057:EE_
X-MS-Office365-Filtering-Correlation-Id: 2739d6c0-e634-445e-ec3b-08dd1319fba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LEuG/yI1eDQ05phorhLxq5qYf9gPkx77xTaxUx2moOYy8iJ57j3Hsf3a+Lsn?=
 =?us-ascii?Q?lwQm/u9ypbXvbTXu/05tZKndtFaP3GGmGCe7ePOUTTLHNTUeKjtUAQKd0LX1?=
 =?us-ascii?Q?9eItqV1rMLeSv9YcTS+66k7IFRxpNM2TshU003svy+VV2ap0EP7EEDtWxtRO?=
 =?us-ascii?Q?kw7aQ/bm6GdjOYyK5ojM1p7/sblugvv17IEzJlsJEnsnC4hy6Pr7Xu/cIcb9?=
 =?us-ascii?Q?BCCdrzmt+wIo4mRjoQwISlJ8hxqRbUupnuAU0mOU90+zVsj883wh43btv/3A?=
 =?us-ascii?Q?NXBzfC9xwuVyCXDVhc4HLwCHYZEmw3JTouMuuyiD/x/ZOmjC0FGjAGp5NEWa?=
 =?us-ascii?Q?fYzuS8aFzPk96eOxYtujssh4T7rq9Pg/7yjKGd25zAvzPO49BFSBWf019dbd?=
 =?us-ascii?Q?2luJV/P8CMM9bib00oyY1OKj8Fn1T8q9xqxyADabot/9ekR1Ff2gTE0OFmzy?=
 =?us-ascii?Q?es37Qu1qGIPsX/oX48kTznVy2xveB4hGwSPdxFoY6UoH5Ez/VpyOq5SjG+CT?=
 =?us-ascii?Q?ULwJAzqRjq4O71wkimfaQegiy6IBtd3NNxaM6T33FYBTKoKFqDeksze6lc8I?=
 =?us-ascii?Q?JIYeTuCH/5vdGaO08hFOqBmZUP4NaU/lE315TQR4asg6PwVGl9nVP2TQ/opV?=
 =?us-ascii?Q?/o68Q8sSixT4uQjdCJPVqnyBdIpLcdNkHdqY6OPpI21zTic7QiTVNWzyWvUt?=
 =?us-ascii?Q?/E4PYexiRdydzCZ5x3nidRV4IRGIJyVoEp9y09qxFSSdmaqTxk4rj340s52s?=
 =?us-ascii?Q?PKT+kJw5VFEXWuyNg2QlTRKENC5na+j/vgs7ZBpBZX7PnF7dI7g5hOzOhF54?=
 =?us-ascii?Q?4mTOkwBuVc8N5/7+J++xGneiEdJv9TmRk9TurND6PkhgPkr+HZCXta0yjZyd?=
 =?us-ascii?Q?NlNZYsubVvzOXsBzd769xT8huXgAt/TqtFLpKPfP2hjMAf9VynbTFNY8TwW9?=
 =?us-ascii?Q?kUYRkNTfbrkeOtS2QOPvUbruVzpSwsWEvxUz5BRhWYHcBeMEDpOuHPI4Rwhp?=
 =?us-ascii?Q?Cf9ETT7atr6u/6jSRS6q+vVXbuq+7pXlyTsdzR/5ECGb6seGCHlYwH1CqEh+?=
 =?us-ascii?Q?sEpHOLtiOMxhl+xky5RmjiPeHnuUm+6MCYhejtR4zyNS5jM1FWAL7lTQtYy9?=
 =?us-ascii?Q?XEJ8mLGyDfwjikeS54znOfQNl/uDl37BUMSypiR09pcBJJL3QVjvy/HLYp7j?=
 =?us-ascii?Q?C2Phz7TSjiATKWdnF6ZyTxRq8ePhVQ8EjdjWEmxJPUkI3L1Vbx8fDuy3Ds1r?=
 =?us-ascii?Q?2S+WXYF2azMGMASGsVkF4fnemjQdSKTy3NlWy3PzJErHtHcs8WGTY85cmjPk?=
 =?us-ascii?Q?Nbn7P12Rtc/1J70auKYkWRfDQHHNibkjlN4ZOfpdM17v3taXxFRjiSvSIMHo?=
 =?us-ascii?Q?Vgfmb186O3iLckziFuG0PSoJWfXSqXjlnvoYgKZV5MiX/o8TC8pygA0/BNVi?=
 =?us-ascii?Q?1bhh2PoBn+O8EUNQ1pmyKnc3m4Fbyiz4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 21:40:47.2646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2739d6c0-e634-445e-ec3b-08dd1319fba8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9057

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


