Return-Path: <kvm+bounces-13133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 542DB89279D
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A95428449C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E1613E413;
	Fri, 29 Mar 2024 23:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EQB9OIea"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559F13E408;
	Fri, 29 Mar 2024 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753587; cv=fail; b=uVxzxBp9ua9ojUje7iOTm6ElFMdMHmdPYW0cUn6bjO7rF9rpTnSFzjBQNwx9spej1SZwD2d3ddUJSL7R2Behss3Yf5iVrst2nE0eE8Kf9rwbOVWN2G2Wo4zkjF8M1GkC3ISI2lp8VHqirYlYmhXAcrvJ0aWXLcJjioCaJ2gdSfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753587; c=relaxed/simple;
	bh=KalEbdqRGRxS5KjJYNiUkYknvhPkZuxd2fBb0cCgSeE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOktB9YS73vaB1FyI/btKNHhjK+iudqpuFu8zlcHRObZnEOUWR6aTCQIvgQSBjZ5ifi/zYzsQla9sGYZzlKbXFWcfl/2AMUZeZb7bjFZR/d+d1/oa1Sur7wYqaGcpelZf1ezG2GCIarZyD2juMhQo2HIkLuvXaJvQDhjINv0lNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EQB9OIea; arc=fail smtp.client-ip=40.107.95.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFHIOL2v24wJaO2yisaKcXeiUV+EUvOpK9IZEbVfDGmni78YdT0lMZvfpeYqipud8yhZ4gHslAMcdAQuRzk7xciD9c1598D8uZ49rcSjondc9yXX8RRPFMtdylgd6HqoBsseYuRzulAUZ37Zap4H6hxM73NbuAGbOPlloxcddZtPSqnauMXbFezr+3Ef+E4FyYSzxbLkuR8lcNsckXvl6B/FSK28NgDvprWlY8C8e9jc5TSQrufwnBwlVZnEXN40saecPKgxuvpcmxoS//9XPnw1OWEwqx0KLvA+oD1DiQhvgTJdmWJjEsN2gPhhKfBV0SxUD3Yml5RkRt2ef4lrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xP7eiDAex+6DfGwbSIMsn9LpYXQmn4Kn5QQfRgVRAv8=;
 b=ZvZnMU/ezwI47YqFGuq1hiunzr+cbZzvidUZhx+bqCC51581eV856EBTaw2ucSXMHjUU1fVSs08ZRxWyVUFU+/wF/uRF3k0Iix6KbiwZoY0YL5B3dlrL7oOsRCnqkL9AGsjIswEnCUoJQRUfeFtAVIXwhn/edhT3VN+ysHS188w6CWhK5PohJGWVw08l9Xox6RHmIBsgEiWCkMUKnHVeK2jJ4PAXzapHJz+ZZO0o4AoeC3uqTbbl4u1prerJUGbjuHsknwLjMpCEyTpCOFWaDk8hmEZmyCwnK9HDF7HGK0rLEgAVApg+HWWMbhRvvlLZu2ADZx9vo2DqA6wr0mZLDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xP7eiDAex+6DfGwbSIMsn9LpYXQmn4Kn5QQfRgVRAv8=;
 b=EQB9OIeaxFjsOzOPKNd8cAEUq7aSSCsc1yGTlBbuIZbxYtxUCa2I+XTMLCPgKruQYscZzJF92fnmoACvtFHOjpstNXrXbQkb38Z1Kc0qn5MP4NGE+3/CUP4fiFbfGWpQnglJXfkKUuHWghjC56ZmuNe921Y5nuLVeUGWMqB3KLI=
Received: from DM6PR01CA0015.prod.exchangelabs.com (2603:10b6:5:296::20) by
 DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ed::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.32; Fri, 29 Mar 2024 23:06:21 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::60) by DM6PR01CA0015.outlook.office365.com
 (2603:10b6:5:296::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:06:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:06:20 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 28/29] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
Date: Fri, 29 Mar 2024 17:58:34 -0500
Message-ID: <20240329225835.400662-29-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: cc6f20e1-32a1-4880-c374-08dc5044d987
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	leMQLN+KuRS4VcoSCnLaLz7JNsXtLC80aCs8Pj12CnRImmggJ3DHcFgvQll5xsifg/F+W9bI5AQmcUgQqWDWwCHPJTd7zXvQ1C82aUFmJN8M/gg3V5yymXo/c4W/5GwrqcAsxOnq+y8DAgVF0P5WdwcNDnOPWozhyr8xPtFKoW39EgfQvEMCSU/tNVuRU6PBH7V7Modl55CEewnnr0D4ldtLJDCpOwlcAI3q5xVSs6RWojWCjRU+ria7e4JSLKysNWfPDUy85V+cH9LSmxMHvyDmXsBLbvC0BK1TWDEmGyH3pPv0fxmSMuZ3r3WP/5PQWR39flwAtRXSe1GYsflpCbTlTZcju0SqiDhOINxrLbgEKF5QTKnQbcLHyIRupp0CVz44dF2Tp75Iznvkycf1Dtoj0uv8DIV9mz8Rc0HdRf40weU8+Btj93wy2FncEGSpr+Yq8o7hRxjhudDxwHaZw2ICisoEs8fbFbJrEzbhB7Iu+/xnn5IooeevBLB0vPQ8F4/qNQIaYMXQC3k2DTd5r0sN+Obmprz0Biq+ngTERL455yH84jkaW/AaZQPdH8+Wim7NFcmnE2BZ/kwo9aksMGZe+A5mV/3rJx+5+H659gQvgkkXJMRVAhmrnKKmZmePZkAQ/O45FJjrxhXXO8xp7UzVUG/jwDXzgRivyEc8VGg/zTNp0EmWwjU/ymrymD6gZPOPrteZxD+dHaHvXopGXCVl1SdmFOgY+UAe+h17Af9Syjhb77+v+JgZBQfK1ZrX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:06:21.6538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6f20e1-32a1-4880-c374-08dc5044d987
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322

These commands can be used to pause servicing of guest attestation
requests. This useful when updating the reported TCB or signing key with
commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
in turn require updates to userspace-supplied certificates, and if an
attestation request happens to be in-flight at the time those updates
are occurring there is potential for a guest to receive a certificate
blob that is out of sync with the effective signing key for the
attestation report.

These interfaces also provide some versatility with how similar
firmware/certificate update activities can be handled in the future.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 50 +++++++++++++++++++++++++--
 arch/x86/include/asm/sev.h            |  4 +++
 arch/x86/virt/svm/sev.c               | 43 +++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 47 +++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          | 12 +++++++
 5 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index e1eaf6a830ce..dd5cf2098afd 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -128,8 +128,6 @@ the SEV-SNP specification for further details.
 
 The SNP_GET_EXT_REPORT ioctl is similar to the SNP_GET_REPORT. The difference is
 related to the additional certificate data that is returned with the report.
-The certificate data returned is being provided by the hypervisor through the
-SNP_SET_EXT_CONFIG.
 
 The ioctl uses the SNP_GUEST_REQUEST (MSG_REPORT_REQ) command provided by the SEV-SNP
 firmware to get the attestation report.
@@ -176,6 +174,54 @@ to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
 the firmware parameters affected by this command can be queried via
 SNP_PLATFORM_STATUS.
 
+2.7 SNP_PAUSE_ATTESTATION / SNP_RESUME_ATTESTATION
+--------------------------------------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (out): struct sev_user_data_snp_pause_transaction
+:Returns (out): 0 on success, -negative on error
+
+When requesting attestation reports, SNP guests have the option of issuing
+an extended guest request which allows host userspace to supply additional
+certificate data that can be used to validate the signature used to sign
+the attestation report. This signature is generated using a key that is
+derived from the reported TCB that can be set via the SNP_SET_CONFIG and
+SNP_COMMIT ioctls, so the accompanying certificate data needs to be kept in
+sync with the changes made to the reported TCB via these ioctls.
+
+Similarly, interfaces like SNP_LOAD_VLEK can modify the key used to sign
+the attestation reports, which may in turn require updating the certificate
+data provided to guests via extended guest requests.
+
+To allow for updating the reported TCB, endorsement key, and any certificate
+data in a manner that is atomic to guests, the SNP_PAUSE_ATTESTATION and
+SNP_RESUME_ATTESTATION commands are provided.
+
+After SNP_PAUSE_ATTESTATION is issued, any attestation report requests via
+extended guest requests that are in-progress, or received after
+SNP_PAUSE_ATTESTATION is issued, will result in the guest receiving a
+GHCB-defined error message instructing it to retry the request. Once all
+the desired reported TCB, endorsement keys, or certificate data updates
+are completed on the host, the SNP_RESUME_ATTESTATION command must be
+issued to allow guest attestation requests to proceed.
+
+In general, hosts should serialize updates of this sort and never have more
+than 1 outstanding transaction in flight that could result in the
+interleaving of multiple SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION pairs.
+To guard against this, SNP_PAUSE_ATTESTATION will fail if another process
+has already paused attestation requests.
+
+However, there may be occassions where a transaction needs to be aborted due
+to unexpected activity in userspace such as timeouts, crashes, etc., so
+SNP_RESUME_ATTESTATION will always succeed. Nonetheless, this could
+potentially lead to SNP_RESUME_ATTESTATION being called out of sequence, so
+to allow for callers of SNP_{PAUSE,RESUME}_ATTESTATION to detect such
+occurrences, each ioctl will return a transaction ID in the response so the
+caller can monitor whether the start/end ID both match. If they don't, the
+caller should assume that attestation has been paused/resumed unexpectedly,
+and take whatever measures it deems necessary such as logging, reporting,
+auditing the sequence of events.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 234a998e2d2d..975e92005438 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -272,6 +272,8 @@ int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immut
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
+int snp_pause_attestation(u64 *transaction_id);
+void snp_resume_attestation(u64 *transaction_id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -285,6 +287,8 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
+static inline int snp_pause_attestation(u64 *transaction_id) { return 0; }
+static inline void snp_resume_attestation(u64 *transaction_id) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ab0e8448bb6e..09d62870306b 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -70,6 +70,11 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+/* For synchronizing TCB/certificate updates with extended guest requests */
+static DEFINE_MUTEX(snp_pause_attestation_lock);
+static u64 snp_transaction_id;
+static bool snp_attestation_paused;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -568,3 +573,41 @@ void kdump_sev_callback(void)
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		wbinvd();
 }
+
+int snp_pause_attestation(u64 *transaction_id)
+{
+	mutex_lock(&snp_pause_attestation_lock);
+
+	if (snp_attestation_paused) {
+		mutex_unlock(&snp_pause_attestation_lock);
+		return -EBUSY;
+	}
+
+	/*
+	 * The actual transaction ID update will happen when
+	 * snp_resume_attestation() is called, so return
+	 * the *anticipated* transaction ID that will be
+	 * returned by snp_resume_attestation(). This is
+	 * to ensure that unbalanced/aborted transactions will
+	 * be noticeable when the caller that started the
+	 * transaction calls snp_resume_attestation().
+	 */
+	*transaction_id = snp_transaction_id + 1;
+	snp_attestation_paused = true;
+
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_pause_attestation);
+
+void snp_resume_attestation(u64 *transaction_id)
+{
+	mutex_lock(&snp_pause_attestation_lock);
+
+	snp_attestation_paused = false;
+	*transaction_id = ++snp_transaction_id;
+
+	mutex_unlock(&snp_pause_attestation_lock);
+}
+EXPORT_SYMBOL_GPL(snp_resume_attestation);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 97a7959406ee..7eb18a273731 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2060,6 +2060,47 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_pause_attestation(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_pause_attestation transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	ret = snp_pause_attestation(&transaction.id);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, &transaction, sizeof(transaction)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int sev_ioctl_do_snp_resume_attestation(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_pause_attestation transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	snp_resume_attestation(&transaction.id);
+
+	if (copy_to_user((void __user *)argp->data, &transaction, sizeof(transaction)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2123,6 +2164,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_VLEK_LOAD:
 		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
 		break;
+	case SNP_PAUSE_ATTESTATION:
+		ret = sev_ioctl_do_snp_pause_attestation(&input, writable);
+		break;
+	case SNP_RESUME_ATTESTATION:
+		ret = sev_ioctl_do_snp_resume_attestation(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 2289b7c76c59..7b35b2814a99 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -32,6 +32,8 @@ enum {
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
 	SNP_VLEK_LOAD,
+	SNP_PAUSE_ATTESTATION,
+	SNP_RESUME_ATTESTATION,
 
 	SEV_MAX,
 };
@@ -241,6 +243,16 @@ struct sev_user_data_snp_wrapped_vlek_hashstick {
 	__u8 data[432];				/* In */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_pause_attestation - metadata for pausing attestation
+ *
+ * @id: the ID of the transaction started/ended by a call to SNP_PAUSE_ATTESTATION
+ *	or SNP_RESUME_ATTESTATION, respectively.
+ */
+struct sev_user_data_snp_pause_attestation {
+	__u64 id;				/* Out */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


