Return-Path: <kvm+bounces-55633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 942F1B3459E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C59E1A8818C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1D12FE054;
	Mon, 25 Aug 2025 15:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="trCTusb/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E682FDC5C
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135244; cv=fail; b=JTOVoFIlw4SQwUvxS4jJQ4XE9rB1kXwuz6AxBcbapmc70p2VxPd+HIvUSPKWynyX4/pY2hTY/p7rOpykcRSpuULKE1rwsn2gNfF75LbOS0W+36qGoH2YTkpJWJAx91xZaXJir16BY1oeJZy35btfGKbou0mql/J5K5+qA7VeOds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135244; c=relaxed/simple;
	bh=cYxCZNbTC59bLmwY3QUQpr5fegtil7OgK8+X+0NLWrA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKG4GU29nbBAUBvKWwrbi2LWxyH75qas86jJ3foaYMaOH86EQmUjU8KzACjJWoqhatBP/MnWWVN77gXVCt3vommir5I33hQyEyUYMyDJGVcp3vCTiTR0tcZrUfAQ1zMG07hEObd5Slqcc8q0jRQqtiaVPPvQBfp7nsQOlNgdN5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=trCTusb/; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNAnsxS8OcS0uyc+oqtiqmRarO1WxHdpJregWRs3Qi0Dm5v4ov2VYHo1Vmm8hp+Cn7seW+qPMaHmTxO86pfBqB+SNonXR/+c6cb8utXFbg2JU2HOqWZrcoioJnMvdCTAZn0/eB1BfrFFzhhzq9Cvdr3jXzUV0V0fAUKEthX3aGUosQSc2hLMvizdLPTc4mAYojbRVQ2syfy11bLan/pU4Acgizj7gYJ/+/E9npyUrKGhVZcwkjw4QYr05+PyxQahLRd3UKexjkpsTgUZCbBpjI2ztrTCpxTHJonzghgTNu8+7ZZNtOGo0xvVEs6qvPuprSvIV/dbbscP7Yu4UDVcZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+tWwLeXbjr15JjtQgjeW9BwKlC9r9PerZqYw9oW7DU=;
 b=k/C26dgS3kWW5Wmle5iThcci2PNx3V9pAVzQu6aWpVZBRyOIREjR+iRF9BS7kxWPxHd6l0uPmLLefe1KBVlZv5GHjCzvZg6QMD2QS/dSREK0+qlLOKq3kPqKCp2AG/SWQrVLPxCcG+4JgNfpo4oWqDeXpNBxF+zfxfVjA+zYWNzMLbvJAxz8C6k4cX4j21XPOYRYwVg9nQ1YNjzCXiE32hmtS6zjERdoNGRaH7icClzdSDDk0j/193AR5/I2m7af9gkAN0XO7au1OYFx0ddXS2zmK0ZPC7dFAqWrBi2TzaljGhu/uEgK46or1uBa1XoWwxjPKIADMKI1YKDmjVh5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+tWwLeXbjr15JjtQgjeW9BwKlC9r9PerZqYw9oW7DU=;
 b=trCTusb/jcDvaFHh0EF4vtF8tVQ5hFIYEm7Ud7ZprZUW+c2g2GzLCRlRGZWksf294f1FSEBfhaSnZWqLFhXoZtg6mQPEOz01hWYHv6KYRlG97SbzpoIfjvplky8kCokt3wIsOXbgqgqflVwEfaRRlOQOryxaAIGeK44C3TH/64Y=
Received: from MN2PR19CA0062.namprd19.prod.outlook.com (2603:10b6:208:19b::39)
 by DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 15:20:38 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:208:19b:cafe::74) by MN2PR19CA0062.outlook.office365.com
 (2603:10b6:208:19b::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.23 via Frontend Transport; Mon,
 25 Aug 2025 15:20:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 15:20:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 10:20:34 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>
Subject: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Date: Mon, 25 Aug 2025 15:20:09 +0000
Message-ID: <20250825152009.3512-5-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825152009.3512-1-nikunj@amd.com>
References: <20250825152009.3512-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|DM4PR12MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d8621bd-b9c8-41c2-68e7-08dde3eaf255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FTVSDbOxhRryjOlNVw+05rs69BaR0fuUKbMD8VhgszsQ2KMELjc0J/iyTtlB?=
 =?us-ascii?Q?/V1KZHbQWmU0RDwNK6x10VJn9v3Gon5+2fSTzbK5B0Ck3yNWZvQSewGA3fqd?=
 =?us-ascii?Q?ErKDZgbA5mqDAwsxi15DJRfOom2a8dLwKGWT9rwNK68fP9PkBLhGnEbg0Xrs?=
 =?us-ascii?Q?pyDtrOcDCubSbEsCa2ubMNT43TjmXnYezglOkSJuwT9FEOrzu0dD8wOaq3+U?=
 =?us-ascii?Q?XjztEQ95XrACrUFomRDmUC5D8ZXLfI3oB/Bis+oESxqqqRIaqo3p63EEpYGg?=
 =?us-ascii?Q?qE/AE8mApql+s46rdyvfpG3xmAYEGdvVGpa0X09Y9j/KTzAOIN2fZZFJPkh6?=
 =?us-ascii?Q?CWG/Nj8mcVdsQX1l2mHbuRSNS8ugr7Ba5uATLPqYhRCsgJp63PY3iSC51RxZ?=
 =?us-ascii?Q?KTK24qljJR0OBuizeSJTpQdmBLALK+KpJ77gaoUOZkEOS/V+nuwq8iFDM1eO?=
 =?us-ascii?Q?1LJJlE5fxrTK74i6HDSc57080TLzcL4e8+0VtRFdMY6BR5GEt08JUBr6OYEf?=
 =?us-ascii?Q?NpY7imueE9hZByQnwoTLsbzBe6B29gTHBmYNLrV/fYCaGEMQbpVc9C0dcT+I?=
 =?us-ascii?Q?SRbfPliQPdnPvmcpbxmUlIsvBr0GMkft6N6g81EpclnsPpX5wjm1SnbXgort?=
 =?us-ascii?Q?+kMfvku9ogWYOmOCgZ/h5NrxaZEW7zRcyywBfs1oQs8mZ5eH1PtVcRvIW5V/?=
 =?us-ascii?Q?fFAkTKbrebSIGyfsbPiROwNDLrqdOp326LJKegdo99k9fRPmMWsdhVXMEM4u?=
 =?us-ascii?Q?WHGdT+7uUhCsoFB8VTtUf9Xv33Mpw3s8qZgwF7ZNuqaBTasL4kp7On1n2Bi9?=
 =?us-ascii?Q?kivRaUWAKD1e1c8/TfwUmdc+SZwb8sR5vK7y2F1ypYwwn2+zESBg9HNksN2u?=
 =?us-ascii?Q?E3H9eHWJ7zVfiXAFhw+QP4qZpWxw5XbwcEQJU9FSDnEIhrcpysYV47xcpKNx?=
 =?us-ascii?Q?h5ZZmBSNCEP140W37MtabwPEqIeinVJfOyha7GfSY8SX1gagUIazEEe0G3An?=
 =?us-ascii?Q?zVhFkI6xZrwD+lm67tGFnq3ovN81dOOPgjAnM1IHbnq7m3DWz0XfpkHnto4a?=
 =?us-ascii?Q?eqI+lKdoJwtQvihrKRXyqTcYWpW4r9MSnNC/5b2iBe8vdO6Af91Q59B8qtYX?=
 =?us-ascii?Q?BuQpmvZf5rH4dfWP/+9UMB8a/9DuYIMoJHzcAAjb5QVKTKYTUBWg5vb2e4iM?=
 =?us-ascii?Q?dS7NgIj6vMJE3wUEwwUEbEvs5bIn28SzyhQXYARxpSZVS2LNlf8KhbZzH4ED?=
 =?us-ascii?Q?StkiTTOiTEYvL5/u99HDRZnM1EeZB/RhNHMgr78loky74svszcjquBgjr2Ke?=
 =?us-ascii?Q?VS6m1d9AOLDM3E95D0ZjAhQb0VywfVYt0Y1dtIkayt84mDIJ66ryJd3IOglZ?=
 =?us-ascii?Q?2gaL1DgkzOteRIcYfLgS2NPN9S2P8E4bdL3w7qjn2s5i2wNZS+QobKofy9FA?=
 =?us-ascii?Q?+CnD06rato/c+lI+dgqX9F5cN02pFzL1qpeFQRSGQxyTnHyP5yk84Yd97sFn?=
 =?us-ascii?Q?pUpnQ7RV0nuSAF0JUgk5FgL8iuSy3HZH71NA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:20:38.3141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8621bd-b9c8-41c2-68e7-08dde3eaf255
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6280

Currently, dirty logging relies on write protecting guest memory and
marking dirty GFNs during subsequent write faults. This method works but
incurs overhead due to additional write faults for each dirty GFN.

Implement support for the Page Modification Logging (PML) feature, a
hardware-assisted method for efficient dirty logging. PML automatically
logs dirty GPA[51:12] to a 4K buffer when the CPU sets NPT D-bits. Two new
VMCB fields are utilized: PML_ADDR and PML_INDEX. The PML_INDEX is
initialized to 511 (8 bytes per GPA entry), and the CPU decreases the
PML_INDEX after logging each GPA. When the PML buffer is full, a
VMEXIT(PML_FULL) with exit code 0x407 is generated.

PML is enabled by default when supported and can be disabled via the 'pml'
module parameter.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h      |  6 +-
 arch/x86/include/uapi/asm/svm.h |  2 +
 arch/x86/kvm/svm/svm.c          | 99 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  4 ++
 4 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..9fbada95afd5 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -165,7 +165,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_9[22];
 	u64 allowed_sev_features;	/* Offset 0x138 */
 	u64 guest_sev_features;		/* Offset 0x140 */
-	u8 reserved_10[664];
+	u8 reserved_10[128];
+	u64 pml_addr;			/* Offset 0x1c8 */
+	u16 pml_index;			/* Offset 0x1d0 */
+	u8 reserved_11[526];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -239,6 +242,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CTL_PML_ENABLE	BIT(11)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..f329dca167de 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -101,6 +101,7 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_PML_FULL	0x407
 
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
@@ -232,6 +233,7 @@
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
 	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_EXIT_PML_FULL,		"pml_full" }, \
 	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
 	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
 	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..f46680a3c44f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -178,6 +178,9 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+bool pml = true;
+module_param(pml, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1220,6 +1223,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
+	if (pml) {
+		/*
+		 * Populate the page address and index here, PML is enabled
+		 * when dirty logging is enabled on the memslot through
+		 * svm_update_cpu_dirty_logging()
+		 */
+		control->pml_addr = (u64)__sme_set(page_to_pfn(svm->pml_page) << PAGE_SHIFT);
+		control->pml_index = PML_HEAD_INDEX;
+	}
+
 	if (sev_guest(vcpu->kvm))
 		sev_init_vmcb(svm);
 
@@ -1296,14 +1309,20 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 			goto error_free_vmcb_page;
 	}
 
+	if (pml) {
+		svm->pml_page = snp_safe_alloc_page();
+		if (!svm->pml_page)
+			goto error_free_vmsa_page;
+	}
+
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_vmsa_page;
+		goto error_free_pml_page;
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
-		goto error_free_vmsa_page;
+		goto error_free_pml_page;
 	}
 
 	svm->x2avic_msrs_intercepted = true;
@@ -1319,6 +1338,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+error_free_pml_page:
+	if (svm->pml_page)
+		__free_page(svm->pml_page);
 error_free_vmsa_page:
 	if (vmsa_page)
 		__free_page(vmsa_page);
@@ -1339,6 +1361,9 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
+	if (pml)
+		__free_page(svm->pml_page);
+
 	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	svm_vcpu_free_msrpm(svm->msrpm);
 }
@@ -3206,6 +3231,53 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(!pml))
+		return;
+
+	if (is_guest_mode(vcpu))
+		return;
+
+	/*
+	 * Note, nr_memslots_dirty_logging can be changed concurrently with this
+	 * code, but in that case another update request will be made and so the
+	 * guest will never run with a stale PML value.
+	 */
+	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
+		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_PML_ENABLE;
+	else
+		svm->vmcb->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
+}
+
+static void svm_flush_pml_buffer(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	/* Do nothing if PML buffer is empty */
+	if (control->pml_index == PML_HEAD_INDEX)
+		return;
+
+	kvm_flush_pml_buffer(vcpu, svm->pml_page, control->pml_index);
+
+	/* Reset the PML index */
+	control->pml_index = PML_HEAD_INDEX;
+}
+
+static int pml_full_interception(struct kvm_vcpu *vcpu)
+{
+	trace_kvm_pml_full(vcpu->vcpu_id);
+
+	/*
+	 * PML buffer is already flushed at the beginning of svm_handle_exit().
+	 * Nothing to do here.
+	 */
+	return 1;
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3282,6 +3354,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 #ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 #endif
+	[SVM_EXIT_PML_FULL]			= pml_full_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3330,8 +3403,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%llx\n", "nested_ctl:", control->nested_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
+	pr_err("%-20s%016llx\n", "pml_addr:", control->pml_addr);
+	pr_err("%-20s%04x\n", "pml_index:", control->pml_index);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
@@ -3562,6 +3637,15 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	/*
+	 * Opportunistically flush the PML buffer on VM exit. This keeps the
+	 * dirty bitmap current by processing logged GPAs rather than waiting for
+	 * PML_FULL exit.
+	 */
+	if (pml && !is_guest_mode(vcpu))
+		svm_flush_pml_buffer(vcpu);
+
+
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -5028,6 +5112,9 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	if (pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
 	svm_srso_vm_init();
 	return 0;
 }
@@ -5181,6 +5268,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.private_max_mapping_level = sev_private_max_mapping_level,
+
+	.update_cpu_dirty_logging = svm_update_cpu_dirty_logging,
 };
 
 /*
@@ -5382,6 +5471,10 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	pml = pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
+	if (pml)
+		pr_info("Page modification logging supported\n");
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..6c2be19d8d46 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,6 +335,8 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	struct page *pml_page;
 };
 
 struct svm_cpu_data {
@@ -717,6 +719,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.43.0


