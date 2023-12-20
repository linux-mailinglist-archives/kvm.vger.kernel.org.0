Return-Path: <kvm+bounces-4945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1445B81A213
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FD3F1F24528
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC516487AE;
	Wed, 20 Dec 2023 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oWc5brwY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD1448799;
	Wed, 20 Dec 2023 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfPQMK3K3QZT6lnnG4etPt5Mcj+oMhxsOFzPQ/3p+i9SPMEXoNeSVjBwUGAZHnfjKvnEjDVwsmQOUv4P9jo5IV1AvigaAe91KwYcJesT4FzEGic24ebzEdDwhqUBx6WwRaQCuKJdkAnPeBO9D4A3dC/zCt02z5GBHWxpBpA5Fm+UdNoak+PpljZ8lHswZRBKwzPx9Pee/u5waBVCNAEAj35vHW+Cxq47BaTb6J+87x1jg2F3Fei0v5jaHplSBbEkr7i4/B+GpVPNn6ltVtl4w4BZH3zqC/+6YQHe+P0H4uFnXkeu1oPIi4jMv/jQ8iqCkMoVo6Q7lsJau5JIPyrVNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxaVCPk/dOIMJVIbPymkDbxKOqEWOjCA5BjDunO3z48=;
 b=myfVXjjv7ccOQ0eXSY6jTEW4BJhG2DHg+Odg9wCLqYksJdzObVVEYKr+qPx9oaEHRhiBliSFsOyYT98Gjl9jb8H69plaGxgE480vHIrNw0S7T5pz5mekMeg/+FrmnfEsyc0ta66tAUFrVl57Pfqr9ZhOXEMps8LQWUp1f3IZbEVC0EyKSlCKKeN3yT2I8N7bX+Y1fnYf05ZfbWHFF2UWm7N78g6FWY+8JgXLRVi8WPX9YUBY2tpzN6n8scHEZ7hSfrNaN/jQ2ZU1ALBbvjouv4GqLJNKh1GXQLxAWA7UJQJxRSCBCst0Wz24MzeMHh0MKMOJ+ESNKD66w2RBwPqmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxaVCPk/dOIMJVIbPymkDbxKOqEWOjCA5BjDunO3z48=;
 b=oWc5brwYB/5LL3Y8Jz5HItGeoZi4Jr7XVYd+u/qZnZksfaM//BF7/myGgiWA2KgsvuCtx7XWpAcqj6Ecr77N6FKHQuaqh37yWi0VCofL2Lr6dMt3kZNty610adZjp69J8PmAPsm4a7ssJ7r0hbueYq4d9OcjkGLWqHA9rCcUAzg=
Received: from DM6PR01CA0016.prod.exchangelabs.com (2603:10b6:5:296::21) by
 DM4PR12MB8523.namprd12.prod.outlook.com (2603:10b6:8:18e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.38; Wed, 20 Dec 2023 15:15:50 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:296:cafe::66) by DM6PR01CA0016.outlook.office365.com
 (2603:10b6:5:296::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:50 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:46 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 10/16] x86/sev: Add Secure TSC support for SNP guests
Date: Wed, 20 Dec 2023 20:43:52 +0530
Message-ID: <20231220151358.2147066-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|DM4PR12MB8523:EE_
X-MS-Office365-Filtering-Correlation-Id: 3663eba4-830e-4acb-9265-08dc016e8d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	safRQ7m2DqRQBdCrYldi2YrMeBsSDiq4U+6dJWfI+6iUSiLKrWPQDarKTG4facCScONaaeQcbnWOo6dSdcs/wYxG8LycAI31uLnvhtQElcP8DGz6iV7sygQcw6Cs4Ew7j71de19k+gVjcJgaI5DLtWEunDHKQL5G6SUyOYBLxwUeAmjbqULjkisByCvX/W1KtEnxF2ZuTM4Kr2TNRYiW7ISgWVrheilEEubIvh4G+G2O4Ij30xEDw/JJaxOik4s/YfspB+Q8iWz8pJmtmNBijWHNZRJEv6dp5uJxKxPoFeieHz7a7V4Z1cXGG/fUgfFThYMwlju1IfMv7hSGd0UrcRO3qGWjqG8xigNuRQJM0NrnfXNCect+5ZjWQ5+p2/ZXj4+WVRfCyYw4nku4j/daT5HgFUVlAXBczbPJMUfQrrHnCxmPBCpQkufSnVRxDWdHXEfOPmosaShmMpAsV7VJGHfCc4plC2bHOIElqXBBMF/P7vGsGc1kwzL7VXVkUS0yNOjxoLc2BF4Ej07C5/isKAyjAgyG+79WkG9QLDdweYNwpCZjASgHRjdSU2wrk/WMoKR19YdNc7WiMXyD97/Zdp+g3mxPo3M7GOxBAb2d/YpOHt0471Umwe4mEUKadmahx6SU2os62ogUb6ApNjYeObtif/tKHFtjevHxBRhPaGa9ElM5g8/OIsEdju9wjH4h3xpAR598gEWwI264gMSvtjQOWbOvNUF1cxW0pOpVL9lH/8iOMlzWY4fhUnhMDT5tjk1VdWMU903/pbb02Nfp8A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(316002)(110136005)(36860700001)(2616005)(478600001)(54906003)(70206006)(70586007)(40480700001)(83380400001)(426003)(336012)(16526019)(1076003)(26005)(40460700003)(47076005)(8676002)(8936002)(4326008)(7696005)(6666004)(5660300002)(7416002)(30864003)(2906002)(356005)(81166007)(82740400003)(41300700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:50.6377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3663eba4-830e-4acb-9265-08dc016e8d39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8523

Add support for Secure TSC in SNP enabled guests. Secure TSC allows
guest to securely use RDTSC/RDTSCP instructions as the parameters
being used cannot be changed by hypervisor once the guest is launched.

During the boot-up of the secondary cpus, SecureTSC enabled guests
need to query TSC info from AMD Security Processor. This communication
channel is encrypted between the AMD Security Processor and the guest,
the hypervisor is just the conduit to deliver the guest messages to
the AMD Security Processor. Each message is protected with an
AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
Guest messages to communicate with the PSP.

Use the guest enc_init hook to fetch SNP TSC info from the AMD Security
Processor and initialize the snp_tsc_scale and snp_tsc_offset. During
secondary CPU initialization set VMSA fields GUEST_TSC_SCALE (offset 2F0h)
and GUEST_TSC_OFFSET(offset 2F8h) with snp_tsc_scale and snp_tsc_offset
respectively.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/include/asm/sev-common.h |   1 +
 arch/x86/include/asm/sev-guest.h  |  20 ++++++
 arch/x86/include/asm/sev.h        |   2 +
 arch/x86/include/asm/svm.h        |   6 +-
 arch/x86/kernel/sev.c             | 107 ++++++++++++++++++++++++++++--
 arch/x86/mm/mem_encrypt_amd.c     |   6 ++
 6 files changed, 133 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..6adc8e27feeb 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -159,6 +159,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_NOT_VMPL0		3	/* SNP guest is not running at VMPL-0 */
 #define GHCB_TERM_CPUID			4	/* CPUID-validation failure */
 #define GHCB_TERM_CPUID_HV		5	/* CPUID failure during hypervisor fallback */
+#define GHCB_TERM_SECURE_TSC		6	/* Secure TSC initialization failed */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
index ed5c158ec29b..c82c78571020 100644
--- a/arch/x86/include/asm/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -39,6 +39,8 @@ enum msg_type {
 	SNP_MSG_ABSORB_RSP,
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
+	SNP_MSG_TSC_INFO_REQ = 17,
+	SNP_MSG_TSC_INFO_RSP,
 
 	SNP_MSG_TYPE_MAX
 };
@@ -83,6 +85,23 @@ struct sev_guest_platform_data {
 	struct snp_req_data input;
 };
 
+#define SNP_TSC_INFO_REQ_SZ 128
+
+struct snp_tsc_info_req {
+	/* Must be zero filled */
+	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
+} __packed;
+
+struct snp_tsc_info_resp {
+	/* Status of TSC_INFO message */
+	u32 status;
+	u32 rsvd1;
+	u64 tsc_scale;
+	u64 tsc_offset;
+	u32 tsc_factor;
+	u8 rsvd2[100];
+} __packed;
+
 struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
@@ -102,6 +121,7 @@ struct snp_guest_dev {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
+		struct snp_tsc_info_req tsc_info;
 	} req;
 	unsigned int vmpck_id;
 };
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index f8377b49b88d..880cfee3c3ad 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -201,6 +201,7 @@ void __init __noreturn snp_abort(void);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
+void __init snp_secure_tsc_prepare(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -224,6 +225,7 @@ static inline void snp_abort(void) { }
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
+static inline void __init snp_secure_tsc_prepare(void) { }
 #endif
 
 #endif
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 87a7b917d30e..3a8294bbd109 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -410,7 +410,9 @@ struct sev_es_save_area {
 	u8 reserved_0x298[80];
 	u32 pkru;
 	u32 tsc_aux;
-	u8 reserved_0x2f0[24];
+	u64 tsc_scale;
+	u64 tsc_offset;
+	u8 reserved_0x300[8];
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
@@ -542,7 +544,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
-	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 5e8afdc6af9e..1d6200b57643 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -76,6 +76,10 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+/* Secure TSC values read using TSC_INFO SNP Guest request */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -957,6 +961,83 @@ void snp_guest_cmd_unlock(void)
 }
 EXPORT_SYMBOL_GPL(snp_guest_cmd_unlock);
 
+static struct snp_guest_dev tsc_snp_dev __initdata;
+
+static int __snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				    struct snp_guest_request_ioctl *rio);
+
+static int __init snp_get_tsc_info(void)
+{
+	struct snp_tsc_info_req *tsc_req = &tsc_snp_dev.req.tsc_info;
+	static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
+	struct snp_guest_request_ioctl rio;
+	struct snp_tsc_info_resp tsc_resp;
+	struct snp_guest_req req;
+	int rc, resp_len;
+
+	/*
+	 * The intermediate response buffer is used while decrypting the
+	 * response payload. Make sure that it has enough space to cover the
+	 * authtag.
+	 */
+	resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
+	if (sizeof(buf) < resp_len)
+		return -EINVAL;
+
+	memset(tsc_req, 0, sizeof(*tsc_req));
+	memset(&req, 0, sizeof(req));
+	memset(&rio, 0, sizeof(rio));
+	memset(buf, 0, sizeof(buf));
+
+	if (!snp_assign_vmpck(&tsc_snp_dev, 0))
+		return -EINVAL;
+
+	/* Initialize the PSP channel to send snp messages */
+	rc = snp_setup_psp_messaging(&tsc_snp_dev);
+	if (rc)
+		return rc;
+
+	req.msg_version = MSG_HDR_VER;
+	req.msg_type = SNP_MSG_TSC_INFO_REQ;
+	req.vmpck_id = tsc_snp_dev.vmpck_id;
+	req.req_buf = tsc_req;
+	req.req_sz = sizeof(*tsc_req);
+	req.resp_buf = buf;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = __snp_send_guest_request(&tsc_snp_dev, &req, &rio);
+	if (rc)
+		goto err_req;
+
+	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
+	pr_debug("%s: Valid response status %x scale %llx offset %llx factor %x\n",
+		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
+		 tsc_resp.tsc_factor);
+
+	snp_tsc_scale = tsc_resp.tsc_scale;
+	snp_tsc_offset = tsc_resp.tsc_offset;
+
+err_req:
+	/* The response buffer contains the sensitive data, explicitly clear it. */
+	memzero_explicit(buf, sizeof(buf));
+	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
+	memzero_explicit(&req, sizeof(req));
+
+	return rc;
+}
+
+void __init snp_secure_tsc_prepare(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		return;
+
+	if (snp_get_tsc_info())
+		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
+
+	pr_debug("SecureTSC enabled\n");
+}
+
 static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 {
 	struct sev_es_save_area *cur_vmsa, *vmsa;
@@ -1057,6 +1138,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->vmpl		= 0;
 	vmsa->sev_features	= sev_status >> 2;
 
+	/* Setting Secure TSC parameters */
+	if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, true);
 	if (ret) {
@@ -2632,18 +2719,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	return rc;
 }
 
-int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
-			   struct snp_guest_request_ioctl *rio)
+static int __snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				    struct snp_guest_request_ioctl *rio)
 {
 	struct sev_guest_platform_data *pdata;
 	u64 seqno;
 	int rc;
 
-	if (!snp_dev || !snp_dev->pdata || !req || !rio)
-		return -ENODEV;
-
-	lockdep_assert_held(&snp_guest_cmd_mutex);
-
 	pdata = snp_dev->pdata;
 
 	/* Get message sequence and verify that its a non-zero */
@@ -2686,6 +2768,17 @@ int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *
 
 	return 0;
 }
+
+int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio)
+{
+	if (!snp_dev || !snp_dev->pdata || !req || !rio)
+		return -ENODEV;
+
+	lockdep_assert_held(&snp_guest_cmd_mutex);
+
+	return __snp_send_guest_request(snp_dev, req, rio);
+}
 EXPORT_SYMBOL_GPL(snp_send_guest_request);
 
 bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 70b91de2e053..c81b57ca03b6 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -214,6 +214,11 @@ void __init sme_map_bootdata(char *real_mode_data)
 	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
 }
 
+static void __init amd_enc_init(void)
+{
+	snp_secure_tsc_prepare();
+}
+
 static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
 {
 	unsigned long pfn = 0;
@@ -467,6 +472,7 @@ void __init sme_early_init(void)
 	x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
 	x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
 	x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
+	x86_platform.guest.enc_init                  = amd_enc_init;
 
 	/*
 	 * AMD-SEV-ES intercepts the RDMSR to read the X2APIC ID in the
-- 
2.34.1


