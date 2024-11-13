Return-Path: <kvm+bounces-31803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C81A39C7D1A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 811B2B26429
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FE4206E92;
	Wed, 13 Nov 2024 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w5r6tYKm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8116318A6C5;
	Wed, 13 Nov 2024 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731530688; cv=fail; b=ZtGaUU4r6zV3lEcIWNVJeBxhHPt/es5l4BEIfJ9ShFm+awnc7syGLRJIgS04DMpVgkJJuPuRc5PEtfUO9B0m3bQJ7Fdg/V2zFQmLpstuJDOvQBedRCDPy7HOUTYcHHNL3G3ibuW8dxVK7pyppRlq/8UR+5RAy45SuSkaUHqIL64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731530688; c=relaxed/simple;
	bh=Bxk2gB8uDy3j69XUlhcfW6h0ZZhiEQ4lkEcXvw3Hnic=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EwMTzjFHFgTXo9QUEpwuv0/bu4biBsdY0UwO6dqGNiujJX/hUY7woPdfNDtDEbWp/xlOMc1m5YobzM5PxLDEEsXp5vwTsSKjZCnnejQGU8m0aerXJkMyqdlps727U/JSHOlQUVG/XkMxLZE6H/ZEqn7Viq+1wojjQZkWsB71wC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=w5r6tYKm; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ml3/tPq4Z4GMRECr3rtBEMCzLrNQcgLnKLUF2cm1ZVNIWkq/XLNdQ/vweHKzHxIGxfUnfRqjwoFJvSCuOdw7odPFUmeVAVOIOttodFDZIWxfd4G+3EKj+sfT+1VId1dVxVwi2dsFqnKOX/OurPYAcUGFXwUoNYPWIaT3/CkVTOw9MU5qK9E2+iCrz0nW4TrbFvb9zMi9ep8W8OQ0mTbwz0YACIeWKioTai79O3wRvNMq4u9oWGVLsgbWxHQfiAt7u/5LYQipuMVdjlmoki2WUSqPts39sQxQmzMBT1u9B5sxpJx+PkiWw55yYKqBpbp/VVC9trUtJvqzqXg2I9satA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcAxCHxwAC+TNG3avUQ/ux/p5D0a8P6KkwKLG2N1VjU=;
 b=R3TY7mhUxkZ/YHOzhYRKhaZ2Bc3YRWjSVzAXTVpO5HAOPN8CL9oWVjxeuumWGjbwG0PKmLzOX5HbGFexYgh6yeBafH1jyNUXrGqosc1J1D6PWY3lD4Ieci7B13X31JcDqWh/CaFGN0z53CZm+EoG4d18FgNWt1d1XLX9D8b8TaxHXAf86o+4Pqr0QILVOX5DABWKV/caaFjVRcqbrtyb586mbXarIqSRbl/SETXXome9hO073q3Y9vvb4OZtfmBYkE2fQDCUWyotlAm41T0nCinYqk0FF8tMb1EgTmn00cFlQgUEJWHzPAlOnRfjH29Ai9XgYKVZ01ATWg0udfHt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcAxCHxwAC+TNG3avUQ/ux/p5D0a8P6KkwKLG2N1VjU=;
 b=w5r6tYKm7OUc4I2fdwjYZ48RykAKjW3WI64hOI6NLmRGFisSKqNxF488SNoRC1zYzkufGV5Fee0jm+MArl/7nE3BiFD8mdPVjnDfsLEHt1rPEHGRDIWcpz5h4GXWbc1EwCZW8KHmM/F6JoVVnlVmKtR5PA2I9wMtXhflwxHcPYU=
Received: from SJ0PR03CA0046.namprd03.prod.outlook.com (2603:10b6:a03:33e::21)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 20:44:42 +0000
Received: from SJ1PEPF000023CC.namprd02.prod.outlook.com
 (2603:10b6:a03:33e:cafe::3e) by SJ0PR03CA0046.outlook.office365.com
 (2603:10b6:a03:33e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Wed, 13 Nov 2024 20:44:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CC.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 20:44:41 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 13 Nov
 2024 14:44:39 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<kvm@vger.kernel.org>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH] KVM: SVM: Convert plain error code numbers to defines
Date: Wed, 13 Nov 2024 20:44:25 +0000
Message-ID: <20241113204425.889854-1-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CC:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: a36467e1-63ed-4660-e9ac-08dd0423ffd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gn9JqqgnCKfi3tapazAuhJkT/ck3TqXj+EwvbLmWZ3SbFcxDTQmjrW6YuUY9?=
 =?us-ascii?Q?LO0grPEhblkbyHoiUsLc40lEQ7CrFoKmQEE4dF+SGcLh/+oX4e1MZwSDjPf8?=
 =?us-ascii?Q?lDdknHd9BRrXSvswG1N0bVZ+3X2i9rrohnPyEn6o/EdM4UrXKWABrejXWPhb?=
 =?us-ascii?Q?TD8lutGT46p4V0daFoQ48+IYCtvZZcYf/oSWTnlCgyxFEAbs71LVdgLFk/cJ?=
 =?us-ascii?Q?fXmUmV1EcQAV4vSdbw6ifUVHhV9qgrqi30cSjaXIhEWCifQW5lzzZCE+r4qU?=
 =?us-ascii?Q?Daa55lwLak+JZ5J+l+/NtAB7J2YaeM014qMYP426iiVz+iHEB3O6JqcY0Q0y?=
 =?us-ascii?Q?Qv4Wse2yyWeEZcaMQHYzjlGS+CBee46OX0c2reCkiaOpmiYkbnX2KKvP6HRt?=
 =?us-ascii?Q?5bSwG8SvT8d3p8hS0GOYhfbuYT0Xb2tZXuj/sfp0reXwfIPOQHeo9jedSQ7f?=
 =?us-ascii?Q?TSpUug2DgLf0A5lA62r/rZ/dPxhwIUkbjM/UO9i516rAYbgi10ZXc6D5Mnej?=
 =?us-ascii?Q?4JQ/FFKNGyZ8SUfatl7k/2dvGi2VE/5rRBk+clxLRZ0qO74KrwfbGvGGRLgZ?=
 =?us-ascii?Q?zfMimu8yki+vTZdM+R1fD2iFKOIQFehp1eDcseqInmzNXFaJ34w9E6FJ7Tdh?=
 =?us-ascii?Q?QQ2SHWTQmFouK8TI+e2nnfGElNEnC6t8ACLBAuh1UtotGHV5jABiu8K3ZB7Y?=
 =?us-ascii?Q?eP1BtHRBOqQ0GPillNIO+XLV2bsoGJrZO/obB7Ac1qroBX4Y6n1zOAGAcvE7?=
 =?us-ascii?Q?OIsZsScRiBk8zuLAyWFN+W3+h7qw9FB+LkMjipj7y/tM/0otwE7ReACCMzqc?=
 =?us-ascii?Q?VrphgwdxcWu8tt2tKScbPAjYHUgZY2WkbS7GnsZdStpY9cIEBzxvP1ENX8Sc?=
 =?us-ascii?Q?HkvQrogXMgFTeDKUxDfBG6X2Xrvz0iNlveATM4Vs9QEQLO4qKhplZzLFgHwT?=
 =?us-ascii?Q?5miOtp9vEk8fTBFJXp7dw/Ds34QepVKGG7u3kH/EW2Mp6sx9L/k/syrdonpY?=
 =?us-ascii?Q?DmL4nrH861nC/0awznjxAbSfKWyAqA7Bd7Py1XYGjF4tZ8t2822X0pb4nWT1?=
 =?us-ascii?Q?998IIXfifvTxvsvPLEtAZZheRT6JMVmmhTGaWjlGpo0uvIqSkEE3iHsI969W?=
 =?us-ascii?Q?Ftnz01rZnq98xb6J06ZbmEaaxvpSVU4cNZA7xVf9D1k9Ycad4HEgSxpOnI5R?=
 =?us-ascii?Q?/qg0fLmPgRLrL0qsWhqfGekRdVCglbjXCc4Zr0l1DiuTCj5epwfrPJg6jagz?=
 =?us-ascii?Q?MDr/fvNqFcLG5O1ycAbE/fG/ph/7nAqmB0DZq34NfBtXuwFB/BmEhdHrrZs3?=
 =?us-ascii?Q?pG8UT9PPODUcZ8QohJtxuTHEAmUkOASOA9+NxHlu5NytdRYUUP8WewbTof+H?=
 =?us-ascii?Q?74+ITTqBF3GtC+fiLssf3i2+dppROsydUvLHF47JULkwaqJN/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 20:44:41.5682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a36467e1-63ed-4660-e9ac-08dd0423ffd6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279

Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.

No functionality changed.

Signed-off-by: Melody Wang <huibo.wang@amd.com>
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
index c6c852485900..c78d18ba179c 100644
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
@@ -4121,7 +4121,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
@@ -4314,7 +4314,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
@@ -4364,7 +4364,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
@@ -4394,7 +4394,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c1e29307826b..5ebe8177d2c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2975,7 +2975,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
 				X86_TRAP_GP |
 				SVM_EVTINJ_TYPE_EXEPT |
-- 
2.34.1


