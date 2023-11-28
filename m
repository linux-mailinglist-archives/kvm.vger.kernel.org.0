Return-Path: <kvm+bounces-2607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A417FBAC5
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 871001C21580
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8611C56B6C;
	Tue, 28 Nov 2023 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JOqNLK3r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96F19B5;
	Tue, 28 Nov 2023 05:01:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQJwnDRPIe+MBYiB68zfMYw+wzaHtjpwWcfWDZHLJAZu3T7PWRx/h7mdR4btxp7kVvL2/T3iF1Q3yfjmGwRFXkm/UkFR6z7qsPVA33pXABtluPChUDVmBpetZEWwOoP6JWNktmC/9b9Zzop1xfh415R2v6Tn3S+5htd0TnoFJSC9RmtOD1K7NHodlr9b7fesTfEknFqPYLYt6/l6iECXCsFjrjuMNetOh4E/g47d9alkf+PzRefC5zgYpOowqn0+WxOdCWqRDoVGdDF+rsI/k4oEa/tb4oTHbP7QLbg34iDTsy/HjkceroSgo6VMPvXpgoESuUIUD0S3JL3OLXRZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6Vj6CqOyYpIzkHnEQAJ0CB9Vi91c/9Td/ZASzEAEcA=;
 b=f+GT6Qll5xulS/mLW4mvWYAZq4kWU+lwi0PZoWD5mBt5dNjVrvcr8w5NdJlbEH4foH/ruOhOGDxVC4BzxvtBkGCuhqQYtLYqp/G1e0EOhCqrQqhBgDx4JRrbVTAv9BVGFNOIwdi8lYvajUz/WuCcihOO9NLUpkqbFY9OuFY1MueiWJCR03QSBf8bGWm9VxBzdaFNtvKZKGvhPWD+wsflwBmmd9xuRnY3U4y3fuI6dP46tu62i771WMd4OcNo8fd8uSZhFV81u2KrcApSGX8LGTAAqo4b/evg9KuwuLv/PmO7HxspwA1vXPOqMIxobm9Nm0/5oMVD5kJXIhnbKmV2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6Vj6CqOyYpIzkHnEQAJ0CB9Vi91c/9Td/ZASzEAEcA=;
 b=JOqNLK3r6jY2fVXclnayoW93l+Pgqtd2IswgiPugKfU5UqZFBPaEwm0GhWp98T1eJglMYKHJKBuaC5g3vjAz5hItj925OcGywOepg58F//wwLgmU+dkRawmkXc1ljLgT06SRVMeLk9BT02xGw4MqYlfa9q4ckEHWLo/JoCVFcSw=
Received: from DM6PR07CA0118.namprd07.prod.outlook.com (2603:10b6:5:330::31)
 by SJ2PR12MB9191.namprd12.prod.outlook.com (2603:10b6:a03:55a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:01:53 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::78) by DM6PR07CA0118.outlook.office365.com
 (2603:10b6:5:330::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:30 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 10/16] x86/sev: Add Secure TSC support for SNP guests
Date: Tue, 28 Nov 2023 18:29:53 +0530
Message-ID: <20231128125959.1810039-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|SJ2PR12MB9191:EE_
X-MS-Office365-Filtering-Correlation-Id: b73567bf-18a9-4df2-1d4e-08dbf0123171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0/e7ZZzIlAQw9ML2npiT/CayKizbLH8kafVmWt2txuDontgUQ38rFtxr1kWB72arH491JoWC14iuMweFAq2WyEsVrYkfEJW+Kva76QmKjX0Y6tdIlb1m495UkegZwvXC5YBFMauvPzXwx4WhbwadyUYO6GjFeUGXjWlazT/9GGc2R1ph06REgHqVn1fcOe09VpxHkEES0TYiZW4Fjp9fJDGH3r255Qe8dNsyHVcOl3itSMZUStYx5mvds2b/4xwuK9OlrSlW1rKmWJADVzA2lJHSXLWwgeiehryRINuwddUGVY84WJBJmGo8xyNuEp7IfYx4ufjIRXGK4+vtXtOYKmtCVYetHyiirjVVSsZmX4VMKCyF/EQWMGnOf1fu1YSPFKcEwACp5prJAeqnTZSX0YgPdxjf6YumpYoNukbih18ng3VceqJ9ejVto+LH2OE7xhKQ0QvmHFTG88D5Wdh6dBAKdmypbmrvmA1P6UJ9pq4mCxRNgXzpKj1hmdWK87WqFTBKC/uH5UIflAGAGA4a7FM6QYPpWBveRhAmXWaCMQ2t3qpTrJWls3/Vjctdt3bDQuIzBqKXOI1CylRd53fgvfgLwCc1CaWOIc2j9JOCi6aEfevGqFLSHqaMhf8oVhS7zR5PKyfYpZKrhaT1TwPpS1wdPHh+dV/CcM4eLU/2b+p6czNad+aDvFTSvZb6tRoN1gs4ie0Vc3am1DsDK1Lhjcd0b6eXbgcb/nnc38Xivv5cb38bbs/WEA2Qov2ib+IpG2S4X/EsaDmNUA/NPki0pQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(136003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(82310400011)(36840700001)(40470700004)(46966006)(6666004)(4326008)(8936002)(8676002)(7696005)(54906003)(110136005)(316002)(40460700003)(478600001)(81166007)(356005)(47076005)(36756003)(41300700001)(40480700001)(1076003)(36860700001)(26005)(70586007)(2906002)(2616005)(426003)(336012)(83380400001)(16526019)(70206006)(82740400003)(7416002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:53.1538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b73567bf-18a9-4df2-1d4e-08dbf0123171
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9191

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
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/sev-guest.h  | 20 +++++++
 arch/x86/include/asm/sev.h        |  2 +
 arch/x86/include/asm/svm.h        |  6 ++-
 arch/x86/kernel/sev.c             | 88 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt_amd.c     |  6 +++
 6 files changed, 121 insertions(+), 2 deletions(-)

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
index 16bf25c14e6f..b23051e6b39e 100644
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
@@ -105,6 +124,7 @@ struct snp_guest_dev {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
+		struct snp_tsc_info_req tsc_info;
 	} req;
 	unsigned int vmpck_id;
 };
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 783150458864..038a5a15d937 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -200,6 +200,7 @@ void __init __noreturn snp_abort(void);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
+void __init snp_secure_tsc_prepare(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -223,6 +224,7 @@ static inline void snp_abort(void) { }
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
index a413add2fd2c..1cb6c66d1601 100644
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
@@ -942,6 +946,84 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 		free_page((unsigned long)vmsa);
 }
 
+static struct snp_guest_dev tsc_snp_dev __initdata;
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
+	mutex_init(&tsc_snp_dev.cmd_mutex);
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
+	mutex_lock(&tsc_snp_dev.cmd_mutex);
+	rc = snp_send_guest_request(&tsc_snp_dev, &req, &rio);
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
+	mutex_unlock(&tsc_snp_dev.cmd_mutex);
+
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
@@ -1042,6 +1124,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
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
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index a68f2dda0948..f561753fc94d 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -213,6 +213,11 @@ void __init sme_map_bootdata(char *real_mode_data)
 	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
 }
 
+void __init amd_enc_init(void)
+{
+	snp_secure_tsc_prepare();
+}
+
 static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
 {
 	unsigned long pfn = 0;
@@ -466,6 +471,7 @@ void __init sme_early_init(void)
 	x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
 	x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
 	x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
+	x86_platform.guest.enc_init                  = amd_enc_init;
 
 	/*
 	 * AMD-SEV-ES intercepts the RDMSR to read the X2APIC ID in the
-- 
2.34.1


