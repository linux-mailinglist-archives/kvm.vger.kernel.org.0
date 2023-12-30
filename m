Return-Path: <kvm+bounces-5354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C62B3820746
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CAEDB20CCB
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A197C139;
	Sat, 30 Dec 2023 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I/Q5VkyU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2082.outbound.protection.outlook.com [40.107.212.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC32E15495;
	Sat, 30 Dec 2023 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdSyZ+FhRjEpkWO5iCsppYDlvFgLdrcXIuAt4b7ZNIiALTZkB+1Pi3w2KSrlUhyXB14xv+x6cbU54mFhVJ3kihTfPByHiz7LcAD5hc0h0YE//wgidR8NNp16u3Nwb5omBtZjx/RBKxQLd1gasjWqQpaulL1XKggnS7YyKV9XyiDaJNkcmrREYwIOCu3mddOjleUhmYtIozxrNaXsUsU2tHNQhbRya570e8n3OpmjVqzmTU31OJ2rfTQPFitfpPmZhMwxIogOpll5SMelj/Ih+//XljPgQK/MNHHMyAiFFVsanNb2Bg3l/9UfB44Ofhocfh+0oyrUCJ+DWaCIMDnJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4RrTLfk50bxr/h871ke6toc4E7KSmR8gWEfO5q1KSk=;
 b=YXYgrm28CW8VUjmnnmKYZ84lA8wUvjskpGmt2cq8yNtD2LfpsQlqUpT1oHUj8zDMW5MXImDpDV7yQpqscVox90v1gA8WDLRMdwvU+Eu067kJeCpMUIKPEANYaPP1zqHUokO7uDTiNe2uTVvROT4MVnaqMb9LaP62P058q8NKpXYs4xRR12wc/Mhzc3U5Cp6yeac5u04ua4ojwQ/PPBRQnD9m3FHewCfb7POx2JMF96WB7n0BwAuG034nmRjymKHxNTZ1c5RgaJb890tSOu49Uw8y5VdtqHzkqbnLVOTSsbqOI7T8uYPPDfuMmq0mEb5vVtSwyjnMSuN7WNn4NNL0qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4RrTLfk50bxr/h871ke6toc4E7KSmR8gWEfO5q1KSk=;
 b=I/Q5VkyUHqEAH8wvzzANseHD/PWgcFOzXfLZ7AHpkT7aO72gweS8EeMX7XtxNBTQGIYAfMyizs6DUq86r2DUhpkp1vuvNyUuWDS804UjmDEjEUlFoZ5zc+NrnP13CgSMXQI4heWJhGvtSbky2c3dGSZPXGu13WNw/Ypp81pMFng=
Received: from DM5PR07CA0091.namprd07.prod.outlook.com (2603:10b6:4:ae::20) by
 SJ0PR12MB5486.namprd12.prod.outlook.com (2603:10b6:a03:3bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:25:15 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:4:ae:cafe::16) by DM5PR07CA0091.outlook.office365.com
 (2603:10b6:4:ae::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:25:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:25:14 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 18/26] crypto: ccp: Handle legacy SEV commands when SNP is enabled
Date: Sat, 30 Dec 2023 10:19:46 -0600
Message-ID: <20231230161954.569267-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|SJ0PR12MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 9787405c-42fd-46ff-e740-08dc0953e784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mYaA6az/j9oQiF6mxCgtKNGbGABI/l3IzdnyKJli5KiewWkxKbOdeXEnirdncz/XMVO1tMaUuwUfCoefKbVdqABrpwyGDmuEErW/wOgw5oJW8lt9sCJUz6NZdDLsX3SdXPpfbEglx/pmbiKhbl+xBhx+jFR8JG2fRShJ+hlyoVUa08fzRKJ3TXneIilMcqcPw+4OAENvbFyMQuMaBsnglXgk4aa4BiTYLwuFrcx4yM7dcOKaGMOZl1Zqusy9sS3++9CI03BchTtTvrtl0L41BXRY2GhHXEFbe/T85F9ExdRDEGRwFO2nfnKkTFOW1eP/61xZ0Lbn/EUWl8x8K56s6u5LxZhpQpVwL4BdsPHqNPoime+i2/4s/HUcnY4MqN4ce2EDp0y9EXaiCiBqEJAVfP55hrz/3RdA76fsoDW+JOxgA65FiHsaYkX+to7V2dVunGcIH21ci8RkCiesUZMKpv87+fnMdsUYkr0R3vOlv/i1B3Tss4xTV59VmrWd6N/F6uc+DUJO8KQ9qv5TPhN0639TJS/IzMwYBfn+JRnqb6Acg99WqhIqj1wm6di8inyfK2mELPifbEq/Gla7SDqH3MuhJQL0De/okluy52m0sMzy+39Sz3I/7QUNkR0dJkvuxmIB3RSWItDcSZGBwCzueWoxAmmF+5k3R+el6cyQ8gMowhDVcqhUcVd9tN2AC8PfBgAbQXySiC0+CTA7mUE/wjF4MgSHTtr2iGLfCHRxtfWkkWcXnc3G5kbNF0G+oRqLgxKz+nNDoQljcCfkzWDelQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(1800799012)(64100799003)(451199024)(82310400011)(186009)(36840700001)(40470700004)(46966006)(2906002)(4326008)(8936002)(8676002)(36756003)(40480700001)(30864003)(5660300002)(7406005)(7416002)(40460700003)(44832011)(2616005)(16526019)(83380400001)(36860700001)(81166007)(478600001)(356005)(6666004)(82740400003)(426003)(47076005)(41300700001)(336012)(26005)(1076003)(86362001)(70586007)(70206006)(6916009)(54906003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:25:15.0168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9787405c-42fd-46ff-e740-08dc0953e784
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5486

From: Brijesh Singh <brijesh.singh@amd.com>

The behavior of legacy SEV commands is altered when the firmware is
initialized for SNP support. In that case, all command buffer memory
that may get written to by legacy SEV commands must be marked as
firmware-owned in the RMP table prior to issuing the command.

Additionally, when a command buffer contains a system physical address
that points to additional buffers that firmware may write to, special
handling is needed depending on whether:

  1) the system physical address points to guest memory
  2) the system physical address points to host memory

To handle case #1, the pages of these buffers are changed to
firmware-owned in the RMP table before issuing the command, and restored
to after the command completes.

For case #2, a bounce buffer is used instead of the original address.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 421 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   3 +
 2 files changed, 414 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index dfe7f7afc411..8cfb376ca2e7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -43,6 +43,15 @@
 #define SNP_MIN_API_MAJOR	1
 #define SNP_MIN_API_MINOR	51
 
+/*
+ * Maximum number of firmware-writable buffers that might be specified
+ * in the parameters of a legacy SEV command buffer.
+ */
+#define CMD_BUF_FW_WRITABLE_MAX 2
+
+/* Leave room in the descriptor array for an end-of-list indicator. */
+#define CMD_BUF_DESC_MAX (CMD_BUF_FW_WRITABLE_MAX + 1)
+
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
@@ -501,13 +510,351 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+/**
+ * struct cmd_buf_desc - descriptors for managing legacy SEV command address
+ * parameters corresponding to buffers that may be written to by firmware.
+ *
+ * @paddr_ptr: pointer the address parameter in the command buffer, which may
+ *	need to be saved/restored depending on whether a bounce buffer is used.
+ *	Must be NULL if this descriptor is only an end-of-list indicator.
+ * @paddr_orig: storage for the original address parameter, which can be used to
+ *	restore the original value in @paddr_ptr in cases where it is replaced
+ *	with the address of a bounce buffer.
+ * @len: length of buffer located at the address originally stored at @paddr_ptr
+ * @guest_owned: true if the address corresponds to guest-owned pages, in which
+ *	case bounce buffers are not needed.
+ */
+struct cmd_buf_desc {
+	u64 *paddr_ptr;
+	u64 paddr_orig;
+	u32 len;
+	bool guest_owned;
+};
+
+/*
+ * If a legacy SEV command parameter is a memory address, those pages in
+ * turn need to be transitioned to/from firmware-owned before/after
+ * executing the firmware command.
+ *
+ * Additionally, in cases where those pages are not guest-owned, a bounce
+ * buffer is needed in place of the original memory address parameter.
+ *
+ * A set of descriptors are used to keep track of this handling, and
+ * initialized here based on the specific commands being executed.
+ */
+static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
+					   struct cmd_buf_desc *desc_list)
+{
+	switch (cmd) {
+	case SEV_CMD_PDH_CERT_EXPORT: {
+		struct sev_data_pdh_cert_export *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->pdh_cert_address;
+		desc_list[0].len = data->pdh_cert_len;
+		desc_list[1].paddr_ptr = &data->cert_chain_address;
+		desc_list[1].len = data->cert_chain_len;
+		break;
+	}
+	case SEV_CMD_GET_ID: {
+		struct sev_data_get_id *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		break;
+	}
+	case SEV_CMD_PEK_CSR: {
+		struct sev_data_pek_csr *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		break;
+	}
+	case SEV_CMD_LAUNCH_UPDATE_DATA: {
+		struct sev_data_launch_update_data *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_LAUNCH_UPDATE_VMSA: {
+		struct sev_data_launch_update_vmsa *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_LAUNCH_MEASURE: {
+		struct sev_data_launch_measure *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		break;
+	}
+	case SEV_CMD_LAUNCH_UPDATE_SECRET: {
+		struct sev_data_launch_secret *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].len = data->guest_len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_DBG_DECRYPT: {
+		struct sev_data_dbg *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->dst_addr;
+		desc_list[0].len = data->len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_DBG_ENCRYPT: {
+		struct sev_data_dbg *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->dst_addr;
+		desc_list[0].len = data->len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_ATTESTATION_REPORT: {
+		struct sev_data_attestation_report *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].len = data->len;
+		break;
+	}
+	case SEV_CMD_SEND_START: {
+		struct sev_data_send_start *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->session_address;
+		desc_list[0].len = data->session_len;
+		break;
+	}
+	case SEV_CMD_SEND_UPDATE_DATA: {
+		struct sev_data_send_update_data *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->hdr_address;
+		desc_list[0].len = data->hdr_len;
+		desc_list[1].paddr_ptr = &data->trans_address;
+		desc_list[1].len = data->trans_len;
+		break;
+	}
+	case SEV_CMD_SEND_UPDATE_VMSA: {
+		struct sev_data_send_update_vmsa *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->hdr_address;
+		desc_list[0].len = data->hdr_len;
+		desc_list[1].paddr_ptr = &data->trans_address;
+		desc_list[1].len = data->trans_len;
+		break;
+	}
+	case SEV_CMD_RECEIVE_UPDATE_DATA: {
+		struct sev_data_receive_update_data *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].len = data->guest_len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	case SEV_CMD_RECEIVE_UPDATE_VMSA: {
+		struct sev_data_receive_update_vmsa *data = cmd_buf;
+
+		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].len = data->guest_len;
+		desc_list[0].guest_owned = true;
+		break;
+	}
+	default:
+		break;
+	}
+}
+
+static int snp_map_cmd_buf_desc(struct cmd_buf_desc *desc)
+{
+	unsigned long paddr;
+	unsigned int npages;
+
+	if (!desc->len)
+		return 0;
+
+	/* Allocate a bounce buffer if this isn't a guest owned page. */
+	if (!desc->guest_owned) {
+		struct page *page;
+
+		page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(desc->len));
+		if (!page) {
+			pr_warn("Failed to allocate bounce buffer for SEV legacy command.\n");
+			return -ENOMEM;
+		}
+
+		desc->paddr_orig = *desc->paddr_ptr;
+		*desc->paddr_ptr = __psp_pa(page_to_virt(page));
+	}
+
+	paddr = *desc->paddr_ptr;
+	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
+
+	/* Transition the buffer to firmware-owned. */
+	if (rmp_mark_pages_firmware(paddr, npages, true)) {
+		pr_warn("Failed move pages to firmware-owned state for SEV legacy command.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
+{
+	unsigned long paddr;
+	unsigned int npages;
+
+	if (!desc->len)
+		return 0;
+
+	paddr = *desc->paddr_ptr;
+	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
+
+	/* Transition the buffers back to hypervisor-owned. */
+	if (snp_reclaim_pages(paddr, npages, true)) {
+		pr_warn("Failed to reclaim firmware-owned pages while issuing SEV legacy command.\n");
+		return -EFAULT;
+	}
+
+	/* Copy data from bounce buffer and then free it. */
+	if (!desc->guest_owned) {
+		void *bounce_buf = __va(__sme_clr(paddr));
+		void *dst_buf = __va(__sme_clr(desc->paddr_orig));
+
+		memcpy(dst_buf, bounce_buf, desc->len);
+		__free_pages(virt_to_page(bounce_buf), get_order(desc->len));
+
+		/* Restore the original address in the command buffer. */
+		*desc->paddr_ptr = desc->paddr_orig;
+	}
+
+	return 0;
+}
+
+static int snp_map_cmd_buf_desc_list(int cmd, void *cmd_buf, struct cmd_buf_desc *desc_list)
+{
+	int i, n;
+
+	snp_populate_cmd_buf_desc_list(cmd, cmd_buf, desc_list);
+
+	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
+		struct cmd_buf_desc *desc = &desc_list[i];
+
+		if (!desc->paddr_ptr)
+			break;
+
+		if (snp_map_cmd_buf_desc(desc))
+			goto err_unmap;
+	}
+
+	return 0;
+
+err_unmap:
+	n = i;
+	for (i = 0; i < n; i++)
+		snp_unmap_cmd_buf_desc(&desc_list[i]);
+
+	return -EFAULT;
+}
+
+static int snp_unmap_cmd_buf_desc_list(struct cmd_buf_desc *desc_list)
+{
+	int i;
+
+	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
+		struct cmd_buf_desc *desc = &desc_list[i];
+
+		if (!desc->paddr_ptr)
+			break;
+
+		if (snp_unmap_cmd_buf_desc(desc))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static bool sev_cmd_buf_writable(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_PLATFORM_STATUS:
+	case SEV_CMD_GUEST_STATUS:
+	case SEV_CMD_LAUNCH_START:
+	case SEV_CMD_RECEIVE_START:
+	case SEV_CMD_LAUNCH_MEASURE:
+	case SEV_CMD_SEND_START:
+	case SEV_CMD_SEND_UPDATE_DATA:
+	case SEV_CMD_SEND_UPDATE_VMSA:
+	case SEV_CMD_PEK_CSR:
+	case SEV_CMD_PDH_CERT_EXPORT:
+	case SEV_CMD_GET_ID:
+	case SEV_CMD_ATTESTATION_REPORT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* After SNP is INIT'ed, the behavior of legacy SEV commands is changed. */
+static bool snp_legacy_handling_needed(int cmd)
+{
+	struct sev_device *sev = psp_master->sev_data;
+
+	return cmd < SEV_CMD_SNP_INIT && sev->snp_initialized;
+}
+
+static int snp_prep_cmd_buf(int cmd, void *cmd_buf, struct cmd_buf_desc *desc_list)
+{
+	if (!snp_legacy_handling_needed(cmd))
+		return 0;
+
+	if (snp_map_cmd_buf_desc_list(cmd, cmd_buf, desc_list))
+		return -EFAULT;
+
+	/*
+	 * Before command execution, the command buffer needs to be put into
+	 * the firmware-owned state.
+	 */
+	if (sev_cmd_buf_writable(cmd)) {
+		if (rmp_mark_pages_firmware(__pa(cmd_buf), 1, true))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int snp_reclaim_cmd_buf(int cmd, void *cmd_buf, struct cmd_buf_desc *desc_list)
+{
+	if (!snp_legacy_handling_needed(cmd))
+		return 0;
+
+	/*
+	 * After command completion, the command buffer needs to be put back
+	 * into the hypervisor-owned state.
+	 */
+	if (sev_cmd_buf_writable(cmd))
+		if (snp_reclaim_pages(__pa(cmd_buf), 1, true))
+			return -EFAULT;
+
+	if (snp_unmap_cmd_buf_desc_list(desc_list))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
+	struct cmd_buf_desc desc_list[CMD_BUF_DESC_MAX] = {0};
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	unsigned int cmdbuff_hi, cmdbuff_lo;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret = 0;
+	void *cmd_buf;
 	int buf_len;
 
 	if (!psp || !psp->sev_data)
@@ -527,12 +874,47 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
 	 * physically contiguous.
 	 */
-	if (data)
-		memcpy(sev->cmd_buf, data, buf_len);
+	if (data) {
+		/*
+		 * Commands are generally issued one at a time and require the
+		 * sev_cmd_mutex, but there could be recursive firmware requests
+		 * due to SEV_CMD_SNP_PAGE_RECLAIM needing to be issued while
+		 * preparing buffers for another command. This is the only known
+		 * case of nesting in the current code, so exactly one
+		 * additional command buffer is available for that purpose.
+		 */
+		if (!sev->cmd_buf_active) {
+			cmd_buf = sev->cmd_buf;
+			sev->cmd_buf_active = true;
+		} else if (!sev->cmd_buf_backup_active) {
+			cmd_buf = sev->cmd_buf_backup;
+			sev->cmd_buf_backup_active = true;
+		} else {
+			dev_err(sev->dev,
+				"SEV: too many firmware commands are in-progress, no command buffers available.\n");
+			return -EBUSY;
+		}
+
+		memcpy(cmd_buf, data, buf_len);
+
+		/*
+		 * The behavior of the SEV-legacy commands is altered when the
+		 * SNP firmware is in the INIT state.
+		 */
+		ret = snp_prep_cmd_buf(cmd, cmd_buf, desc_list);
+		if (ret) {
+			dev_err(sev->dev,
+				"SEV: failed to prepare buffer for legacy command %#x. Error: %d\n",
+				cmd, ret);
+			return ret;
+		}
+	} else {
+		cmd_buf = sev->cmd_buf;
+	}
 
 	/* Get the physical address of the command buffer */
-	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
-	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
+	phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
 
 	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);
@@ -586,15 +968,32 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		ret = sev_write_init_ex_file_if_required(cmd);
 	}
 
-	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     buf_len, false);
-
 	/*
 	 * Copy potential output from the PSP back to data.  Do this even on
 	 * failure in case the caller wants to glean something from the error.
 	 */
-	if (data)
-		memcpy(data, sev->cmd_buf, buf_len);
+	if (data) {
+		/*
+		 * Restore the page state after the command completes.
+		 */
+		ret = snp_reclaim_cmd_buf(cmd, cmd_buf, desc_list);
+		if (ret) {
+			dev_err(sev->dev,
+				"SEV: failed to reclaim buffer for legacy command %#x. Error: %d\n",
+				cmd, ret);
+			return ret;
+		}
+
+		memcpy(data, cmd_buf, buf_len);
+
+		if (sev->cmd_buf_backup_active)
+			sev->cmd_buf_backup_active = false;
+		else
+			sev->cmd_buf_active = false;
+	}
+
+	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     buf_len, false);
 
 	return ret;
 }
@@ -1696,10 +2095,12 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev)
 		goto e_err;
 
-	sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 0);
+	sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 1);
 	if (!sev->cmd_buf)
 		goto e_sev;
 
+	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
+
 	psp->sev_data = sev;
 
 	sev->dev = dev;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 85506325051a..3e4e5574e88a 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,9 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+	void *cmd_buf_backup;
+	bool cmd_buf_active;
+	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
 };
-- 
2.25.1


