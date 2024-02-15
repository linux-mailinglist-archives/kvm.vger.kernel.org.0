Return-Path: <kvm+bounces-8756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 377AC8561AE
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3568292002
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6871812FB14;
	Thu, 15 Feb 2024 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CjPRO9uk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B714112BE9F;
	Thu, 15 Feb 2024 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996763; cv=fail; b=kiIhutwiUY4FD5lTTwZ4jDGbpcR8vzREtxj7rY+iPmS6kYP8oLM9/8h0voPXr9aeFXa28LF4rrIH6GBhoJELULneKBgo344yIKleKHVPA43fHJVyqja5x6cRQNCSPIVrJeJl/M5gjZC3Pwf8v26xicuhVHxCWZ+K6tvNXGgCoQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996763; c=relaxed/simple;
	bh=VUOZNEc//hE3XoaVvugvub+oL2Ozh/ngkizh0CUMB7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlA5JVtpDGdM6V2oQLAH8dOIb7aZd4NrLKac6dtEixisQp5zG7wkMIQF79/43Mlx3hySc4wk0A/d1YNCvHhqa8TyKiFAzXknGwqTAicRqE9fL+iNc30kofnpunmNW6GceR6PISoJ7pfZZB26mh1Spo5kR7kQpQQZsAZFctCM7ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CjPRO9uk; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hp0WMLZSE+j3tqm/GuxMMvVUS8TR/wKxNPUS0MwvJ9AnhrivsvP8uoRmWWFqIAUNJxJgoQ+d1nSgJUMVjF9C+S76QD0OPH7GniwloWo8PW/RSRlE78w7fPMajEQsRyTkl/awnV0vzVR3kz+KcmOVy405iU1xNpVS/s3VHrx2sdqmZgHRFG8J9Y9Em/JOflWbGCwWV02FyU8/H+vocYTGqJqxsR8rMExEz0PYryIJjwgmli/9GGpWZqCIacV4mMxK4+smXC3PF6Tc9Yh4oKVJ/lK3kJ3qljMEo3Enm7YJRLB4eoogCwEwwNWNMexmNlb9QCWFvDVlpx3IEiL+Vyzypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOijg6vdq88S1suaFP4J9/tP4OEYg3Z9bHi+tVQ4+24=;
 b=m5NRbsA3DlPEcrNoXKSrTB2QpkDMGQA4S6a/ddcZJBDzPxkjahSGZjuNI3zGnQVz2GluQGQYMI54f7lJd8KecraNU0P1X6lcUgacHd8An30KSWuahcaD1L74u0OEoS+JIvYQ7RHUW3ZHS63tQO261Jz/pPaR3qMoXv0aK5tuyEss4gECM5fORRZiw8SQlDAuzBeBF4ddX5J5BOmlb46YdsKutLPss2qBdUdSzsqlwrAZ1VKZgme4MfNgpMLCSzYWEEtBPNVfvPHHkSQei6nsy1vmdQCOpPt1AgHuisgCLawhnTJ0LGdWuklB17a+TzlH8Tqc4vOwl5ilVWiVCqVg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOijg6vdq88S1suaFP4J9/tP4OEYg3Z9bHi+tVQ4+24=;
 b=CjPRO9ukfoUJfNxwSWC+v53OrjQcOGToQ5yen3yoJ97aXTZOTFR1utCMZBw3jllprSf8xmKc3HgUxBrFAjqLo1lmRzU0qFQ9wY2upJce/ly2lM3zu7KtITYoVGujXglgXnvpJilcqeaTuMa64x4lI3MppsYndfxGCDI68FkyrRc=
Received: from DS7PR06CA0010.namprd06.prod.outlook.com (2603:10b6:8:2a::17) by
 DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.14; Thu, 15 Feb 2024 11:32:37 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:8:2a:cafe::4b) by DS7PR06CA0010.outlook.office365.com
 (2603:10b6:8:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:37 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:31 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 10/16] x86/sev: Add Secure TSC support for SNP guests
Date: Thu, 15 Feb 2024 17:01:22 +0530
Message-ID: <20240215113128.275608-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 60fe40ad-99df-44e9-8d3d-08dc2e19cfe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5ZR5fpa71rNm3hLsRQpHgIh3126KdTEfiyZNdrAfAXPoTgcuPTyboxzdSkfVKLq+R2oPfdrs7O9ccBXWZCG3oaQGgpulzQ8oJfPf1ijqPCLVTkExbKI4Tue4XVRh3/w1l7Wums9nPgseEkGaoh95d1ezRTfYnz69VdtxjFhW5jtrnwwFAng8wCDUsL2ykpPNfglEdESuFSe3OMUIEWDjpz8fanNyXrjAhi2an1F/f5cOCqcujJwf9/mArH3OnswZRdouaItVhQNrpbYfYC0ILBk/789UXLpaH89yuD3CKQ7cfcofr2E2oRsBpcmApCMvqx0Z/lWq9zxkkLzdMLcmpzVEd91WN1TsM1Y/v2MQztNisWlTp+sG2U86D99TQq40s9NmDMuIhMUzvwDyluERmsvPGdnazGGuij7YlpybyRCi2nI6fprIAnUduHypF4DFOICqOE7L2Q8w7GfqpGAI+HMs17D+qnx3H2EVmnruSmMK4YvrG5QwS2Rx4yEc0xjJe8EEBoPaFQIXwoaU5ca69LGGamIn2WEfNl8z/fKdA0pdHYsP7RCk+thBycAz8hzjFtU6qAhF/dBMq9iqnpcJCt3Z264J131GMxmq/GOoLRfpXZt9ib6jvtADyb9qSRF0Q45zS30AxWmshE1Uvgl+Pw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(82310400011)(1800799012)(186009)(36860700004)(451199024)(64100799003)(40470700004)(46966006)(5660300002)(7416002)(2906002)(83380400001)(336012)(426003)(16526019)(26005)(1076003)(8676002)(4326008)(8936002)(41300700001)(316002)(6666004)(70586007)(478600001)(70206006)(2616005)(54906003)(110136005)(7696005)(356005)(81166007)(82740400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:37.6221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fe40ad-99df-44e9-8d3d-08dc2e19cfe4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849

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
 arch/x86/include/asm/sev.h        |  23 +++++++
 arch/x86/include/asm/svm.h        |   6 +-
 arch/x86/kernel/sev.c             | 107 ++++++++++++++++++++++++++++--
 arch/x86/mm/mem_encrypt_amd.c     |   6 ++
 5 files changed, 134 insertions(+), 9 deletions(-)

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
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d950a3ac5694..16bf5afa7731 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -170,6 +170,8 @@ enum msg_type {
 	SNP_MSG_ABSORB_RSP,
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
+	SNP_MSG_TSC_INFO_REQ = 17,
+	SNP_MSG_TSC_INFO_RSP,
 
 	SNP_MSG_TYPE_MAX
 };
@@ -214,6 +216,23 @@ struct sev_guest_platform_data {
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
@@ -233,6 +252,7 @@ struct snp_guest_dev {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
+		struct snp_tsc_info_req tsc_info;
 	} req;
 	unsigned int vmpck_id;
 };
@@ -370,6 +390,8 @@ static inline void *alloc_shared_pages(size_t sz)
 
 	return page_address(page);
 }
+
+void __init snp_secure_tsc_prepare(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -404,6 +426,7 @@ static inline int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_g
 					 struct snp_guest_request_ioctl *rio) { return 0; }
 static inline void free_shared_pages(void *buf, size_t sz) { }
 static inline void *alloc_shared_pages(size_t sz) { return NULL; }
+static inline void __init snp_secure_tsc_prepare(void) { }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
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
index a9c1efd6d4e3..20a1e50b7638 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -75,6 +75,10 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+/* Secure TSC values read using TSC_INFO SNP Guest request */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -956,6 +960,83 @@ void snp_guest_cmd_unlock(void)
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
@@ -1056,6 +1137,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
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
@@ -2638,18 +2725,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
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
@@ -2692,6 +2774,17 @@ int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *
 
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


