Return-Path: <kvm+bounces-39189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1283A44F0D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F22F17BE76
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA1320FA9E;
	Tue, 25 Feb 2025 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BAlrOb1z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EAC1C5D56;
	Tue, 25 Feb 2025 21:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740519633; cv=fail; b=b+ztGFHGP8vLebk1zhP1atj+FC7UKOBDxeJZELjocl63AeHF6FO7tYinWWcuNspdFsOfSqXYoTEF8xYo0T4QnFpwCOSSLFAfNHGEkQcoTSvpEvBRftX4su1wwz+WeJa2rTJWSbmefeJM7ObvpJ4jnZCkoirQjT+fE2nBrE2SdFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740519633; c=relaxed/simple;
	bh=vX5gpo5eXFiV4j021TAIUQK3cVjChFgDH0GvAqU6+F8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbuS67AkbcCu17l3Dl8FwFvLqJylbnQhRqtDQNS+youOimGEcfS8I41sWdJJ7GH349liIah2DLfIkXjiNXMB6jdl27lioUZyiOYRazhSChjk/w0hAc8W9gpp4JgzmGBnMTB5IMyRPn5cz5C5ZrlmxkFca30JWRNRxQ1+sB5WnlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BAlrOb1z; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWD8Ico76cLOo0jlJHFxOauM/ExjrdgDOaKjYKuD/ueRxH+tOofbneKMnTZ1jYw1fl+I0j4boDETRkK4LPa9V9jboYfKSDRDE8WNh3ZFIU1j+J8vbI4cTttQSpaKE9OmIBh8UQvCZ69Trtnd3AbPRssQY7I5y4/pX031XzNUlBYb2jtl9kC7QsAbsPAN+V/SCZSHhHoKqVcbp1kO65gsYjx+0TXTOQ4298HlHhnsOjVys5g7/JaDv3fEfTh2WrIdYKneWyE+jqYNNlLnQ9BDqRjIE29w3XJRJcgCwrN/LgD1fiw1VxOBg2jZDYGNQ2Tqjt3DA4AEnrSUfcYDg+52hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvcjKyMpsJaYwfyzv9Vhb2DbiXYyhKM3BP42QZMcWyk=;
 b=e/zKI38Hri+aO8E0H3KaiISpn74/7OsztvejQ4zG9remI3HPMaKaNX180qPTxJv+zDrEaHhmYqRd/2oXHvhEUPltAmuXbMYVpv+3/tURCnsgQHYFsMi6h8dn/rdhj376FI99swW+kEkeVrhcwtyzh1ZI3pm+oqbbJIIJp6ARpf7mFl+Y4ieg8YRCNrq4j/MdrgzW4Bun7doue7aFQDE2JTE6jzWPhIZvwXouW5cK0V7EqhDi+ye9eBTjmasI6rG9ePUYiOPpSpH2kMY+nPnREnd1loG7Y5ofRJ6K8XbcjS8vJpxPLrjaFWLI21qjFdmdW6KwrYtp44li0pt7b7MVvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvcjKyMpsJaYwfyzv9Vhb2DbiXYyhKM3BP42QZMcWyk=;
 b=BAlrOb1zau/UcztI3de7m2esnz8/8bG1OxrpUMM2pdKH0fQZ5+FuaJNP2XfqtOKu3F/8vf5nwmRdy3RxZprh2I9KNxerDlfNhjSKOx/CyZqtqKivCN9hHZcbSelZacl0+S0hBkgtEXScHxt17/aOeW16EHoY/RFs+2BeqOmCSa4=
Received: from PH7P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::32)
 by DM3PR12MB9390.namprd12.prod.outlook.com (2603:10b6:0:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 21:40:24 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::72) by PH7P220CA0021.outlook.office365.com
 (2603:10b6:510:326::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Tue,
 25 Feb 2025 21:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:40:24 +0000
Received: from ethanolx5646host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:40:23 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Paluri PavanKumar <pavankumar.paluri@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v5 2/2] KVM: SVM: Provide helpers to set the error code
Date: Tue, 25 Feb 2025 21:39:37 +0000
Message-ID: <20250225213937.2471419-3-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|DM3PR12MB9390:EE_
X-MS-Office365-Filtering-Correlation-Id: ab09534e-f654-4a19-0ee0-08dd55e50330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cDUSNegqXCaxhdlAoqteevIG/sdIZpsrm88Fc5imGTbPZcbe8eFvoZlfsWiN?=
 =?us-ascii?Q?go1LCOmAbedgO7CPkvXevR3HCsc7TRnHC7Gb+yGW4kvasbIRThghDMNK9Y5L?=
 =?us-ascii?Q?Zj2bmRaG0z1MPt/RQGEpqyjzmUz3OYpgIE37+G3V+p8c4MzpGLY35PISmY94?=
 =?us-ascii?Q?5r0qSzlr+rsXdxnIvyAWkyPYQqRGBiDkjymoOV06GtJ05oq6I7UoVwvLchQd?=
 =?us-ascii?Q?ThSohJE15noeAZDRS0sk81GdYSNC4aifxbegnuaWojFaQjZDRvLwgS82wP0E?=
 =?us-ascii?Q?paCFILw21Kiu7Wtssb2ilG2fQ49Q5BhcuE1aHk6WKSSXTXI969qY1Su0gLg5?=
 =?us-ascii?Q?+eKzPCyna5OpZnZwAXAlimz8xZHbXCXUs2zJm4d8SirpZkAX9uc3hxHC48Kj?=
 =?us-ascii?Q?2KQldfKwdagg9hcvzvNLmnhCen0HZn+3MDv/kfPP63OrGfPKaUc2G+CrC82X?=
 =?us-ascii?Q?kT6m6Y1siic8Zoump1spK97+9kKL/fOIIb+w0iqmpAifj3J9CY0jxtXX39VI?=
 =?us-ascii?Q?fNzkmP60WYK3y4KnU/L2DzKjmRPJexARZQKyVPfSnJlmE11Aved9qJjs9v/5?=
 =?us-ascii?Q?yGeNC6BBjWq711RrwWDpWpxL5xBkAdhPoSza1rw+RudFKitJ9GhWPNDLYE/l?=
 =?us-ascii?Q?iAJoX9xNtpBsH4VDZFCUIhlhBvIgl0qbBKREcvVvvO/PkXgCX8yi7NT2Xx74?=
 =?us-ascii?Q?MqVucPwUU5D+v3r65K7Nf6AJSHXTNIn4TZxVEm/vgqvF8lMKdeNkjHf7IHiD?=
 =?us-ascii?Q?RvGeCquCS47SI08b0SbDFFY4ArZmeWtKxSU9S7QfTYBstfWI3vIzx5Px+cRH?=
 =?us-ascii?Q?Z0YrhElGGOGZO5DCdBiPQEjPnnv/4mFVk2WqOIF3zYbZdivUXxW37oU1Geb6?=
 =?us-ascii?Q?7NX4XE1xMO4oXQ01On6C5ybIlXyzOmNgI3Sir2Bvn+HXF2ctuK7vR5tVH9xG?=
 =?us-ascii?Q?ajC3ucROzwEgT2hmBU3K9mQlwjt5+M6svoxuWXszpqn8Q5eLjZs2D4KF642b?=
 =?us-ascii?Q?j4FTVVnm+C1VJv47yvtOAU5cL9qWN6ajFm/xqYg5QYnxanA1So30J7qvQkMA?=
 =?us-ascii?Q?z7PG6bA9j2w9pviW+whKtBXt8pQ9OWPC4032KQIKpmFqkut3ZGsiAq0qlUrS?=
 =?us-ascii?Q?aoZeWBXaRK8Jlzqw/L0USRigkAeZQyNP/IAYDRQ4FtaR/XaLsxDkB8ueMCNC?=
 =?us-ascii?Q?bOaCBnG9bw0UOUELT65Yk8UbQd8HV4Af5HwHD1lH/RaYmd+c5XYCt38rkF1b?=
 =?us-ascii?Q?IW5N7EGIqoLMUdVQuWel3jhXKgnFAYOHe9VKUhHXUs2HWK0s/4Z2Duj5n457?=
 =?us-ascii?Q?r5d4bf2KejOt6SBLndqdMPFyE2OclMUprJGhcARyVot5ku6SIiZ8+OhdDw0r?=
 =?us-ascii?Q?v0FVj7OoF2my4olcpL4mTLcL6HpnN3YUSqBmc7pmGLIBZOKpjQpSEXnMFsv9?=
 =?us-ascii?Q?7QnRTe482cukkRyctHvl1J1zHhbhQXSRecMN+jvJLQN/8o95wlUStyfhVKfU?=
 =?us-ascii?Q?SRRYZcQjwT8YwK8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:40:24.4893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab09534e-f654-4a19-0ee0-08dd55e50330
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9390

Provide helpers to set the error code when converting VMGEXIT SW_EXITINFO1 and
SW_EXITINFO2 codes from plain numbers to proper defines. Add comments for
better code readability.

No functionality changed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/kvm/svm/sev.c | 39 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c |  6 +-----
 arch/x86/kvm/svm/svm.h | 29 +++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bc42c93d2b97..5f8ee090c110 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3430,8 +3430,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
+	svm_vmgexit_bad_input(svm, reason);
 
 	/* Resume the guest to "return" the error code. */
 	return 1;
@@ -3574,8 +3573,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -3675,8 +3673,13 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 	svm->sev_es.psc_inflight = 0;
 	svm->sev_es.psc_idx = 0;
 	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
-}
+
+	/*
+	 * A value of zero in SW_EXITINFO1 does not guarantee that all operations have
+	 * completed or completed successfully.  PSC requests always get a "no action"
+	 * response in SW_EXITINFO1, with a PSC-specific return code in SW_EXITINFO2.
+	 */
+	svm_vmgexit_no_action(svm, psc_ret); }
 
 static void __snp_complete_one_psc(struct vcpu_svm *svm)
 {
@@ -4079,7 +4082,10 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 		goto out_unlock;
 	}
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
+	/*
+	 * No action is requested from Hypervisor while there is a firmware error
+	 */
+	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
 
 	ret = 1; /* resume guest */
 
@@ -4135,8 +4141,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
 
@@ -4328,8 +4333,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_NO_ACTION);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
+	svm_vmgexit_success(svm, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
@@ -4373,20 +4377,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, sev->ap_jump_table);
+			svm_vmgexit_success(svm, sev->ap_jump_table);
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
@@ -4408,8 +4412,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
@@ -4645,7 +4648,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		svm_vmgexit_success(svm, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e14f8ae7d868..f8d446177101 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2973,11 +2973,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
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
index 9d7cdb8fbf87..b94570924aba 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -581,6 +581,35 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
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
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
+}
+
+static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.34.1


