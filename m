Return-Path: <kvm+bounces-42302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B75A779AD
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8FE67A3FA5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC8A1F03C1;
	Tue,  1 Apr 2025 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZNy0LTSW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88191FA26C;
	Tue,  1 Apr 2025 11:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507433; cv=fail; b=LDe24cmeJBydFmsTAKXB4ZQJcQe9BhY8tmGx48zfTGgI9zjCschuslbdkd4h0xI61VMIeWJgS1+tFRZC0kYYw6EPr6Cr8sABpY4Uxcx56kEv+Vs1Wca629LHKdiWbFoVXxyu2BPUUYRNN3R+7BNmTANRfZQqFi5OHlsTAynrb1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507433; c=relaxed/simple;
	bh=FdS+W6jNuLsELa1oovaLQuixpQOyjpvYU1ywH7iKHMg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikZet/iNXtsZK/7Je/aMmEoc7tWKjKN6wfAAWl6RSvol4jy5OC6Scywz9w/qeIykoKIXzAazEOPuu44TrQ0O6Fd+2OvaYWglIs5vFcfu9spKyWoRddgg8T3yiWP6ZFxpHAiLnfZWM8yGmmPdOL5qtCHot9zXcyiSkFkTAIICMXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZNy0LTSW; arc=fail smtp.client-ip=40.107.100.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMgbnyjVJE3cp+9OBVPNLcqoMv90k6fHpZKLM16hMRD+dTiOOJnAUWhnzOUDNYPH+sbZCUFy+QNvtH8Erun7riULBIGKnhCnqIdJ24Zsss6XgHb5sbhU9DsN72/Nl2/INzOwEQj3olFab4c6IgyN5YZqVwzXFJB3SjL7cXqxj1SRz6NZBaRWNX2lsnAsYlwIeLpSaQM47zDlnCfZnI3OtCI9uS10K1UfSCB0jEF7qe8c+Rl5Kyy7y7cYCMM9h5+6j/qgoWejRVXpoigP+EsuBkK9lCopQOT0hsSOGDb+AetSrPYJv2fe8K2SQFRgoABjNDcppzak9yUJu+wzwW9P6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34fcyjYEUipDQ01X335EP6qTWkgf/ZJe8uwJI2IK2yg=;
 b=gSakkceDLzwcoxR/qoiPd3kyuFiUaBbhOpphnedeKVZJf2fniFYbQexK1PFomXWbYzKrdLZgW+Kce6m0SzUtc8D8H5eemE7D5zwgB7yjx6gtfnzkzAYj6E0zASR5gGqLmpWtD0Gtm7W6WX2CqAGl8aAS3v4BKBlf0FJHMU7pRszueiZsW/ZSk+iJgypaaGzVtmPb/d186NNc70h2C4h0Wyu4rfvbb34D+wq+DrPDZQ4He9JTUkDOqydRMBWGjgWsLPiq/PXApI4xEviZ0TL3a7vGqhPBfUlvZvMPMco5TmWSJ0MhK118DvBL4kVoe+7eIq/4sv5JQcuzB9ttOvQlrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34fcyjYEUipDQ01X335EP6qTWkgf/ZJe8uwJI2IK2yg=;
 b=ZNy0LTSW6P2D14Ngp1FiLrGFRP15STu4iN46ShQmQVUxJRJUNJkg79HUQPrt+CGMk4U0swgQu5qYyYIFlCaGp6HjL0iYYo+qmIB+jcsmkpR1qh1NHzOg+h7poiNWVTagIyi+Kzw6RiKuXo5myz7WUryzLFREvtHyl5J80Vzx1Dk=
Received: from MW4PR03CA0026.namprd03.prod.outlook.com (2603:10b6:303:8f::31)
 by DS7PR12MB9504.namprd12.prod.outlook.com (2603:10b6:8:252::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Tue, 1 Apr
 2025 11:37:07 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:303:8f:cafe::6) by MW4PR03CA0026.outlook.office365.com
 (2603:10b6:303:8f::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.54 via Frontend Transport; Tue,
 1 Apr 2025 11:37:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 1 Apr 2025 11:37:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:37:00 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v3 02/17] x86/apic: Initialize Secure AVIC APIC backing page
Date: Tue, 1 Apr 2025 17:06:01 +0530
Message-ID: <20250401113616.204203-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|DS7PR12MB9504:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea7053a-cf16-49b3-5a0d-08dd71118821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mCoJu+yv7QZNQkNcpccbFFyIJTCU+8za27uTaI+pGCgwDMFd2XYlOlw8nzOt?=
 =?us-ascii?Q?4/I+lulV1DFQbcn5sdlMPoF4lUwKDFi/SeRYN6kn2kCcUM6sxyzpNFXbufCM?=
 =?us-ascii?Q?zPdfmBavoE63e9f+SV0SI3DJMawiqOPaN5Q59Pbwcu9/7SI9lc9kTS7DKvPl?=
 =?us-ascii?Q?q9nIWjdcGCdU3PAg6dLz6LqCcUqZ90QuGLO09oG6jx/boR5K0aux2YBv6Mh8?=
 =?us-ascii?Q?q2jCZw9NPXkb32VtWXiscdboMaX57Km5vjXlghs/oMMGvxj5Ous3C8SJT1Ph?=
 =?us-ascii?Q?4VaZL4Knyf/uPy/klo3JS82/pB+i38PnoZNiBcRvMjfYL25ixhrY1NIVDJ+z?=
 =?us-ascii?Q?fJwCIhp+xeg98Luln7sTva0kgVhbxsr06s16lrNX6etfIvYfceRxX58jDynn?=
 =?us-ascii?Q?UmKGwEYru4A7iyQnOgxYJYaaJDUX7PSFklNFJcsfO5Ac9pAeXzqIsdzYEM8Q?=
 =?us-ascii?Q?xGgCOmB72HvV0CRJEExEnpM5KIItdAmjPmHhdHR3SIKqqPYao4nWiLgmhYy3?=
 =?us-ascii?Q?LKDl/5/XN2SwynTCNiF9xiaFQ//+KGXYlp+pKshtHHCo2j8Td+xDHndG0l8o?=
 =?us-ascii?Q?Ktenb39eiwkkBboyiV5iMa+dHXcIzs35Olqdm8P2xzuTCPLqtreWYJqe4hSx?=
 =?us-ascii?Q?GRnA6hGoHaj4HLEcTIVv5kXR0SY6rbHrU1Vil73FZe2fkhjVo87elNL3dNLj?=
 =?us-ascii?Q?PzOw/ubPoESO9I6ypuhBmT37jSZIFZo+mbQF9uOAZhQ7xK98iqcXboLBNiFR?=
 =?us-ascii?Q?CDM6dxhmogJHeQe0GHozMxcbE0/+sh6O1KoUQZIx9fOgrVCRxaACADzOcgE7?=
 =?us-ascii?Q?zqBeWw0Z5AYVnjXuiYjtlhL0H5A486pAh5JxYVZmkNLZ/Vn69xePLuiloykb?=
 =?us-ascii?Q?+/qq6/p+KRchWTEFAdlmUTy0lkWVJA9kNzXa+WFfxCb5yU1fhnoZSaIztOMY?=
 =?us-ascii?Q?Mc6m5sEG965s4R2pJB5WThDrCYsfJtXAzK2At04mYddDPxnTvYB2UKDA/Uki?=
 =?us-ascii?Q?fw/LWfrz07M3q7wj3OFQ5GV94XQS6WavQlQE5B6XNJ50BEo7Boqk4ZaF96HG?=
 =?us-ascii?Q?nrZKhGv08oBjLV6Fm6AiARwXcOVohIkCyGRsDxTpW9pS5jXhVrKQKPlDL9gu?=
 =?us-ascii?Q?ocrMqxg5ujQE13w7saJgHE+4RGX4jGirMjcloISi+zRaIcu5lPYVqyz73VGv?=
 =?us-ascii?Q?Ah5YzAPoUQ3ttEowp3NMHips1FBH0IF69EU0Fa6dJemRPHEanfApU/CfGEVA?=
 =?us-ascii?Q?aor2hCoJNb7zO/tgUqixFhXx1fZj//NpVD5lLcWYBLfkwDf4UK8K2B1rRw+x?=
 =?us-ascii?Q?vlIT7dKtH8LlsgfLcUS6boz+vHvf3s5vXfPmbDpGd8AySR1JhuanfaBzodi+?=
 =?us-ascii?Q?PwQxTiSEK9XapAFZBQknE5XjXw1Tew8A2Z1c6czlHnz/LTGk8ZQeq3p2+94X?=
 =?us-ascii?Q?claniPpJQbND8P0myINZ6Y3JtTcf1yuyiwpHl58hGRthWoCSvte3aTBn3MIi?=
 =?us-ascii?Q?4rIADYC+rxjjGKo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:37:06.7342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea7053a-cf16-49b3-5a0d-08dd71118821
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9504

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present
when the vCPU is running in order for Secure AVIC to function. A
VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
the NPT entry for the APIC backing page is not present. Notify GPA of
the vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
the hypervisor makes use of this information to make sure the APIC backing
page is mapped in NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:

 - Fix broken AP bringup due to GFP_KERNEL allocation in setup()
   callback.
 - Define apic_page struct and allocate per CPU API backing pages
   for all CPUs in Secure AVIC driver probe.
 - Change savic_register_gpa() to only allow local CPU GPA
   registration.
 - Misc cleanups.

 arch/x86/coco/sev/core.c            | 27 +++++++++++++++++++
 arch/x86/coco/sev/core.c            | 27 +++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  3 +++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 42 +++++++++++++++++++++++++++++
 6 files changed, 77 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index b0c1a7a57497..036833ac17e1 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1501,6 +1501,33 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+enum es_result savic_register_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	unsigned long flags;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	local_irq_save(flags);
+
+	ghcb = __sev_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+
+	/* Register GPA for the local CPU */
+	ghcb_set_rax(ghcb, -1ULL);
+	ghcb_set_rbx(ghcb, gpa);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
+			SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA, 0);
+
+	__sev_put_ghcb(&state);
+
+	local_irq_restore(flags);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c903d358405d..e17c8cb810a2 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ba7999f66abe..3448032bae8c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -483,6 +483,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -526,6 +527,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index ec1321248dac..36fc87bdb859 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -117,6 +117,9 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SECURE_AVIC			0x8000001a
+#define SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA	0
+#define SVM_VMGEXIT_SECURE_AVIC_UNREGISTER_GPA	1
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 62584a347931..f59ed284ec5b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1502,6 +1502,8 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 28cb32e3d803..44a44fe242bf 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,12 +9,25 @@
 
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+/* APIC_EILVTn(3) is the last defined APIC register. */
+#define NR_APIC_REGS	(APIC_EILVTn(4) >> 2)
+
+struct apic_page {
+	union {
+		u32	regs[NR_APIC_REGS];
+		u8	bytes[PAGE_SIZE];
+	};
+} __aligned(PAGE_SIZE);
+
+static struct apic_page __percpu *apic_page __ro_after_init;
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -60,6 +73,30 @@ static void x2apic_savic_send_ipi_mask_allbutself(const struct cpumask *mask, in
 	__send_ipi_mask(mask, vector, true);
 }
 
+static void x2apic_savic_setup(void)
+{
+	void *backing_page;
+	enum es_result ret;
+	unsigned long gpa;
+
+	backing_page = this_cpu_ptr(apic_page);
+	gpa = __pa(backing_page);
+
+	/*
+	 * The NPT entry for a vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	ret = savic_register_gpa(gpa);
+	if (ret != ES_OK)
+		snp_abort();
+}
+
 static int x2apic_savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -70,6 +107,10 @@ static int x2apic_savic_probe(void)
 		snp_abort();
 	}
 
+	apic_page = alloc_percpu(struct apic_page);
+	if (!apic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -78,6 +119,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= x2apic_savic_probe,
 	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
+	.setup				= x2apic_savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


