Return-Path: <kvm+bounces-5398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B52498207F8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5E37B21AD3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C019E14F9F;
	Sat, 30 Dec 2023 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NxN+tESr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8714AA4;
	Sat, 30 Dec 2023 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6OzabGEefmxWECjGW0+leNgqcr1s8KBLhwHTuoam4jPI7ybaOXVJkaXeB8ve4f1e1A4b6d1MTfaLR/rG9Z4KseXDUfLQ04c7Svn+7unv7o4HHjQSYbA4tyyzPXhYRJeF4+dxrg4oGnXdZcBmKOrRNlnVHuajwKcf4OhOFvjwqs8Xm9LEbLaJcItjWi3yBVHf84MC9tTpJwY9CGh18lMAqEoo7WVzJ2+zpW+wmkKcFDk3Lc7CsRt06a1h10XWzg4bQeU6lYJa08SvAIlbbHL4Lw2zcsVFP28v6qKs9scJqe6N0eTfi9rtBkpphHSmlqsCNaRTtsEobCcZree0ugDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBZ+nSrwGeIdfIdDGpvKWJpGg1lN5AAkK8SmiPKEG/8=;
 b=l3ZmjQwvIv15TKHCRK3hc8DxGhCdVAXrWkoVOZfQYQyGdZf3AkLycOO/gXMzLUxgAte+gxKXGLLRDs+E1IOv4AIyQEYfyMeA4eT7SSKLe04W1jnPdD+PDfjUZpdlpTncf3D7X+noSmvalM+Vfs2iuQoBxXNXZhGeHG02lj6wL7s+UeO7qT8JdwPtA4kgGRBfGvpjlQQYPjo85ycWP5zBhHeluLyhIV3NjQfAvo1ADlZ29Ob3p7BraPPZdjIvjqhnF97UUNaMEJkzacoxB/jkFoopAilZzfZjCPfc2ggVLrzAYIYVWjcyBCVZ1HxeTxPgmowFJ3zXobq9wC7npip7QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBZ+nSrwGeIdfIdDGpvKWJpGg1lN5AAkK8SmiPKEG/8=;
 b=NxN+tESrp4uTgQ6OeMhwqHOVHasTuTl25y0DThYySnnqr5veDLCpCqNNScGcljEBDqmHVuEsPdoo/j/kYmVFEZdU5BVoixZ2QMDypTiiRrUWaDfi3CFvROSHyiO5IFoXZOBi6iOXkP1tQAvKi13op9gX7Th1R7pIznzHjaxUZ1I=
Received: from MW4PR03CA0237.namprd03.prod.outlook.com (2603:10b6:303:b9::32)
 by MN0PR12MB6103.namprd12.prod.outlook.com (2603:10b6:208:3c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:34:05 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:303:b9:cafe::54) by MW4PR03CA0237.outlook.office365.com
 (2603:10b6:303:b9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 17:34:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:34:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:34:04 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 34/35] crypto: ccp: Add the SNP_SET_CONFIG_{START,END} commands
Date: Sat, 30 Dec 2023 11:23:50 -0600
Message-ID: <20231230172351.574091-35-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|MN0PR12MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: b41db981-faa0-4363-fad7-08dc095d852d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fy5BnvsnP9lk20RkToVZ17q5jBZxN0yvitSwr1RGxpPyg8eaNdMitCTNOeEWiMKnl5+Qo0/gvLGTed5porcv8IVrnIsBEvYIUpkleo6fNdTxVN79lupbM1kdpi08fdCo8lY5RPsSyKs7i4Oi0/Dc1JZ3C8wSxXA4Tx2Pkwo2PJ+/wabMQZsOwpkxKt0csmpoo32UFOpacqDP4pabW8u/HpCY01wXLSyshWXF0VKJKcJK4T00fFGxdNSvqm3MUVwF8taGsyUNK59vG2Ba38JjQ/+8hIT7YGJBNfpreAeVCPI0t3GR1zSGzIRZxBvpsFHmHF8RLI45NIMq+64W3DSMopF+CbtXgmv6PheLxrSNNlze0anrcnU3pKNHJf0s5TZ0SJTkS1senBlV2OHrDELM5lvJ0m3H13d/rYFONEkz6Or/pkYRcfIsiEIXY2mp5tFGb87VNvqKasPGxBShth0kn4ngqEEeolpcsV8NykYBO8UsTULyf2SfwXB56jDmn0YfHdrRvksbAu3smN1VZyjHF2ovNSJkFrEtb5sUsWhmLNf++7kPiFTPxDrTmdbhSRhQnLMZRROVkTRHm588w8X8NjK7cbnIFig9IE810yO0yGxRSN2y/Xzy8GEHRRTmFHrliKOmnG4alm6Y3CxkC0rAYeyEFnmWgclBGz+jeIy2sxKmcaAPdnRgZ9uUuBtfh3chW39Xq8NhkC+GqVZlxIpwLp2wB49gOyRTCvX8FTlwWGP63NAW84OTcoRxuQkhR1v1A5a0JuYSJVpYBdOHJgWtBw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(186009)(82310400011)(64100799003)(36840700001)(46966006)(40470700004)(7416002)(7406005)(2906002)(44832011)(5660300002)(41300700001)(356005)(81166007)(478600001)(86362001)(82740400003)(6666004)(36756003)(83380400001)(26005)(1076003)(2616005)(336012)(426003)(16526019)(36860700001)(47076005)(8936002)(8676002)(316002)(4326008)(6916009)(54906003)(70586007)(70206006)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:34:04.9353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b41db981-faa0-4363-fad7-08dc095d852d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6103

These commands can be used to create a transaction such that commands
that update the reported TCB, such as SNP_SET_CONFIG/SNP_COMMIT, and
updates to userspace-supplied certificates, can be handled atomically
relative to any extended guest requests issued by any SNP guests while
the updates are taking place.

Without this interface, there is a risk that a guest will be given
certificate information that does not correspond to the VCEK/VLEK used
to sign a particular attestation report unless all the running guests
are paused in advance, which would cause disruption to all guests in the
system even if no attestation requests are being made. Even then, care
is needed to ensure that KVM does not pass along certificate information
that was fetched from userspace in advance of the guest being paused.

This interface also provides some versatility with how similar firmware
maintenance activity can be handled in the future without passing
unnecessary management complexity on to userspace.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 33 ++++++++++++++++++--
 arch/x86/include/asm/sev.h            |  4 +++
 arch/x86/virt/svm/sev.c               | 31 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 44 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          | 12 ++++++++
 5 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 4f696aacc866..0426ebad7671 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -127,8 +127,6 @@ the SEV-SNP specification for further details.
 
 The SNP_GET_EXT_REPORT ioctl is similar to the SNP_GET_REPORT. The difference is
 related to the additional certificate data that is returned with the report.
-The certificate data returned is being provided by the hypervisor through the
-SNP_SET_EXT_CONFIG.
 
 The ioctl uses the SNP_GUEST_REQUEST (MSG_REPORT_REQ) command provided by the SEV-SNP
 firmware to get the attestation report.
@@ -175,6 +173,37 @@ SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
 firmware parameters affected by this command can be queried via
 SNP_PLATFORM_STATUS.
 
+2.7 SNP_SET_CONFIG_START / SNP_SET_CONFIG_END
+---------------------------------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (out): struct sev_user_data_snp_config_transaction
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
+To allow for this, SNP_SET_CONFIG_START can be issued prior to performing
+any updates to the reported TCB or certificate data that will be fetched
+from userspace. Any attestation report requests via extended guest requests
+that are in-progress, or received after SNP_SET_CONFIG_START is issued, will
+result in the guest receiving a GHCB-defined error message instructing it to
+retry the request. Once the updates are completed on the host,
+SNP_SET_CONFIG_END must be issued to resume normal servicing of extended
+guest requests.
+
+In general, hosts should avoid having more than 1 outstanding
+SNP_SET_CONFIG_{START,END} transaction in flight at any point in time, but
+each ioctl will return a transaction ID in the response so the caller can
+monitor whether the start/end ID both match. If they don't, the caller
+should assume the transaction has been invalidated and retry the full update
+sequence.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e84dd1d2d8ab..925578ad34e6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -268,6 +268,8 @@ int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
+u64 snp_config_transaction_start(void);
+u64 snp_config_transaction_end(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -280,6 +282,8 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline u64 snp_config_transaction_start(void) { return 0; }
+static inline u64 snp_config_transaction_end(void) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 0f2e1ce241b5..fc9e1b7fc187 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -71,6 +71,11 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+/* For synchronizing TCB updates with extended guest requests */
+static DEFINE_MUTEX(snp_transaction_lock);
+static u64 snp_transaction_id;
+static bool snp_transaction_pending;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -511,3 +516,29 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
 EXPORT_SYMBOL_GPL(snp_leak_pages);
+
+u64 snp_config_transaction_start(void)
+{
+	u64 id;
+
+	mutex_lock(&snp_transaction_lock);
+	snp_transaction_pending = true;
+	id = ++snp_transaction_id;
+	mutex_unlock(&snp_transaction_lock);
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(snp_config_transaction_start);
+
+u64 snp_config_transaction_end(void)
+{
+	u64 id;
+
+	mutex_lock(&snp_transaction_lock);
+	snp_transaction_pending = false;
+	id = snp_transaction_id;
+	mutex_unlock(&snp_transaction_lock);
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(snp_config_transaction_end);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c5b26b3fe7ff..d81f86d2697a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2035,6 +2035,44 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
+static int sev_ioctl_do_snp_set_config_start(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_config_transaction transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	transaction.id = snp_config_transaction_start();
+
+	if (copy_to_user((void __user *)argp->data, &transaction, sizeof(transaction)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int sev_ioctl_do_snp_set_config_end(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_config_transaction transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	transaction.id = snp_config_transaction_end();
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
@@ -2095,6 +2133,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_SET_CONFIG:
 		ret = sev_ioctl_do_snp_set_config(&input, writable);
 		break;
+	case SNP_SET_CONFIG_START:
+		ret = sev_ioctl_do_snp_set_config_start(&input, writable);
+		break;
+	case SNP_SET_CONFIG_END:
+		ret = sev_ioctl_do_snp_set_config_end(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index f28d4fb5bc21..9deacb894b1e 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -31,6 +31,8 @@ enum {
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
+	SNP_SET_CONFIG_START,
+	SNP_SET_CONFIG_END,
 
 	SEV_MAX,
 };
@@ -214,6 +216,16 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
 } __packed;
 
+/**
+ * struct sev_user_data_snp_config_transaction - metadata for config transactions
+ *
+ * @id: the ID of the transaction started/ended by a call to SNP_SET_CONFIG_START
+ *	or SNP_SET_CONFIG_END, respectively.
+ */
+struct sev_user_data_snp_config_transaction {
+	__u64 id;		/* Out */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


