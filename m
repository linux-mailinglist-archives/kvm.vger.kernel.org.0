Return-Path: <kvm+bounces-16326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 472B58B8755
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D304B22A98
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826E9502B6;
	Wed,  1 May 2024 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2eyGDdfs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4A4E1CE;
	Wed,  1 May 2024 09:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554575; cv=fail; b=H18O+gLb9CxDDnANlmnHWEmiZ0/EhfAhFfHgXYptIE+ogDOCojvB6lJzySsLEMycS8RvoNAh5c5Si8QwizOgrwQScAhfO9mgPAfaPSjVIZ/FZNrpbjWk8y6JpHs3qbpS4gXNzRKWheUPUvWzNRpm1Qjbp4yU7khFXXYSfeFUA4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554575; c=relaxed/simple;
	bh=836ytDsdBQ7gXrWqPodCXtxsPop0IKrnMf73+Ey6uGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuMn7BEyAYUeHmZ3eWePhxrwebSaKS0F21li0CUk6sqctTQJoFIdfZav/C5AozwoUEKdtztCnk84hIrcS8CuQl/cWazd3XUQ562FA8gpKyTtQ/FLcgILn7Ep1UlGUeoVCDe16Xy3NLbHvDXycgRSMDcVrfWbzthnmzr3qpwvnGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2eyGDdfs; arc=fail smtp.client-ip=40.107.220.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iehqxKffHJWHxchRrLta++7MmWW93auhdKgF1Qk7lDSjqMAiEYWADCpchLowcfzUbUukIn8y7X2TB5QC+AJrzaEZSuIvTTBNxfGsNiLZbi/w2ZEKngfQMbGqECs50x5aG+r7ESkGlCVxxrXShk6EK5X7I5+J128mg09FLnHD5nDiWztGgIy+tVZZazgrC/hHmY6+z4Hs+PyGlaMk/J0kcbWUVdznJDApTiA16IHAZCiobsQuyZUglDLdSauxMTOf5O5Bu6SyNVHayD/Rpzg5eJ3TPv2iJlI/gPoBJFVs1oVwjH00ZTd61QLMsdeKFdP07yRo1pvKrSnLhmTSXADimw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmmI4Fmr+tDaQB0oEsfFicY+rShpIyOPOkhjlKpDm2M=;
 b=OIrI9mFe84ej1Mtetqr6M+FkaSv4HPVva7jR8kur3o6yxrcMbou5CudPL6z/qz0UUX5bzzRo3bBSzHJ9OlmgfibhxTuktpPsa8BWwWtg+5CiKamjEFYncM59QtYJXWaPKQjGpLp1H9lmpPDgEqtEqr0TsjhKAGbs2pEQrDiJL3PQTvZKDdObv+OSivC2KPbJqXazV6WjrgziAqdfMH5pAoYy3l8GsP05GjINTIpNAWrx+FAh9eL1c04eoa5/7FHwJ2X2Zm2jxw7QX96xhodKeOMY99rTlGKJSLC8xFieGDyTiArg0PkMGA+kr5MGs0anfOryUKywjFAQ1HFBDFcM4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmmI4Fmr+tDaQB0oEsfFicY+rShpIyOPOkhjlKpDm2M=;
 b=2eyGDdfsaCRJdX684JzWgEIOKRi1IbDI9qITc1PnHgBhxZAYkFtd57yF1vvoqtE9BdCLKa0YZrmeM3V/IAvv9jzrbDji4UGSg1JxtJ60wThUnRrdMd5RDbHvEgYLz4OBQqhVv8DzY/FItNc4FxR9HpZdk6+YfDeBUqsdo7yDHMM=
Received: from BN9PR03CA0588.namprd03.prod.outlook.com (2603:10b6:408:10d::23)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.34; Wed, 1 May 2024 09:09:29 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:10d:cafe::ae) by BN9PR03CA0588.outlook.office365.com
 (2603:10b6:408:10d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Wed, 1 May 2024 09:09:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:09:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:09:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v15 08/20] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Wed, 1 May 2024 03:51:58 -0500
Message-ID: <20240501085210.2213060-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: cf70d100-2436-4e2a-96da-08dc69be680f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400014|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KjOOh29vRC6UQhfcvYqHmaK2jwfQIFkqvW2fYq9f9UYbNn7NpN0MsdBz6TEx?=
 =?us-ascii?Q?iRZMX+ZApTODie6TuexahIhaQkZn2uql+AYWLG+MR3JQfgBS4UHVM/VGz3Qp?=
 =?us-ascii?Q?PT/Wy8mTdapZ127MsELvryob37ffCddL0ciloFk/lYslsa4PfBvh5n/2pGVz?=
 =?us-ascii?Q?8UPNUcoOleq6nPRahlodbGSx1cUw7GAUKXDX3H230ag3L1CdxoWpA0il0nDT?=
 =?us-ascii?Q?T9sKvIMmeAtEkL9tQvHKzaDUW6SQXAsTGMGdbu0Br/qXhJH5QPewCL9ec9hC?=
 =?us-ascii?Q?BacsSl0j8650azeUNc/O4AlMNd07U72e0nIrHYUCvbefGtQTm59yvSiiM7VP?=
 =?us-ascii?Q?hePO6eTg0/YlD2kEeSSEJlQ9rsvxvnoDD9Um0+DZuG8smQDr3wVhzvO6JmDy?=
 =?us-ascii?Q?z40mEjCKJkiOZBM5JRPJekgHcXdhKhIT/HagiwB91782xufKMOFT3EgtR1oF?=
 =?us-ascii?Q?eSrMx0uG4+ToxsCoA3bA8ZZmV1npoWOX8T69JUuBggt8AT1n2StcYd7fzrCA?=
 =?us-ascii?Q?HGyidTjL/Xyw7bNjd6JwmvKjMf0s3CCzeD1f/Z0jMUCUsLQZ/jG6hVukUMDf?=
 =?us-ascii?Q?HOg56C+n/1rCvBVCaMsznVEkiCH1xPZ9VbMNaiMf5op3PkBP0T2/7s9LTYks?=
 =?us-ascii?Q?UHdQrLByykPL1k8GyKtIzq2DCjtUoBpDTgI6HGnpMKG+40EcR1WA1d7LGT2p?=
 =?us-ascii?Q?TsELV7fQ3PTy5ucWPr6kjCpI1TRXREcGhIHKjkFtR0hVqfLXlyuQTPuvYwTL?=
 =?us-ascii?Q?cx4RaGjJra2y2jxxqiKMrPfrym9Y13mxqVsHmJB10z2mddxYWVQ+XLrDbK3I?=
 =?us-ascii?Q?RSdHyo8LNR/KMIoYXFPsfxHEAcDcT4x2zVzFq08Ig+mI3Y0hWQniCioTrL6G?=
 =?us-ascii?Q?rEOTkSIwRft/rkkfFRTgVzcpFMrFW/C5N3UqeqE8O3cuALxsPb/TRe64Iuym?=
 =?us-ascii?Q?xr1qXQgBjR4I/QFyAKkHusfM77fODSRUcXS3P1i/ewfj1i5kjfxBOOj52N2l?=
 =?us-ascii?Q?lgdFxDKMgvdx645XwPXXNjnVG8q1Jii72PyGNax7fq73TctNsJOUKjOX2rPp?=
 =?us-ascii?Q?t0ZUMEPeWmo6ppE9IFD3BrHcOKuVv/mMYlHsJsTGAYw4C7dLndeXEY8Cjq/s?=
 =?us-ascii?Q?qIDWVetJAYk+5IoN2v9U+2Pkf/Qv8mMpp9Pa8JgWcJULy8teLX1aloN/ljmp?=
 =?us-ascii?Q?Oj0RU5GS8JrubOf61nbkHtH94W97sq4yex7eI2ly+xD4JA1TPERa6a8H3Qqq?=
 =?us-ascii?Q?sD0RqWywdBYEZtiBPDTOSMsIo5xLV9ppFFlyDluWEXLPihXw/NwGmzDkaUOU?=
 =?us-ascii?Q?wEzaY5XhrpNApfuNDmzY0Q0vDFClr+FSYjnCvK6KkZvPG9wjty4bfPZK8OA0?=
 =?us-ascii?Q?9ybwuE2AXrwv2di4ufaUm3qytcZb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:09:28.9697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf70d100-2436-4e2a-96da-08dc69be680f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++
 arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h            |  7 +++++
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 797230f810f8..e1ac5af4cb74 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3540,6 +3540,32 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3552,12 +3578,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
-		vcpu->run->system_event.ndata = 1;
-		vcpu->run->system_event.data[0] = control->ghcb_gpa;
-
-		return 0;
+		goto out_terminate;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
@@ -3568,6 +3589,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 					    control->ghcb_gpa, ret);
 
 	return ret;
+
+out_terminate:
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+	vcpu->run->system_event.ndata = 1;
+	vcpu->run->system_event.data[0] = control->ghcb_gpa;
+
+	return 0;
 }
 
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
@@ -3603,6 +3632,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d175059fa7c8..bbfbeed4c676 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -209,6 +209,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -362,6 +364,11 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


