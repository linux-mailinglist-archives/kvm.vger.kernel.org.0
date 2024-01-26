Return-Path: <kvm+bounces-7061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7765283D39C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02C411F249B4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97FFD524;
	Fri, 26 Jan 2024 04:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gJS8x26s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9941125AF;
	Fri, 26 Jan 2024 04:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244245; cv=fail; b=cPOx2o37AqNXkMf8FzsOgVqZt+kPDmFJH69Ud50mu29/WY0Ln+8I88BCzDi5LZGpBdBHMiGfVVtuDdgwkrlzlSBgr7iIbB5+J+nRShIBdOLpmdyPZRK7SHvdim0mVzl592tOL2xpxAArHMNmP8Ctp6p1tmSVPhp2TTJWdS9i1kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244245; c=relaxed/simple;
	bh=MFNwkHtFOsGkkAwJeNakjxcSENK1x4y870jas+dk3EQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GoT279P1JsdKs6Gv7mlj18ukbFh4IMC/OE8oqRhHFJQu0Y3NrfyMuwbRLCK49kl07cduBJa3B06XVPwEFblWUypadJJRfm8HXn4fILKysuYYo2xBY1uL9QJ3gTY/W3TA0emKR4W3vKkjPSTMHbmk3OYqgc/7jnvI/HVL+kYOl+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gJS8x26s; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILZaLjMchTI4RU+CNcquYEGomM1hzg8UDagr18HflWSdwQ8u3BU0CkosiZxJBp55G+pJZ8IGIFZ72i42/GgrCxQ4inKL6xgnBTlth9+3Rfjg0v94HP9vBumZ9zjqrSSyIHbBgrJ1QBJKwL+xoLcOjvneiNXhnNoybPvYMQ+9bIrMSMGPU+2XRzh2yt5Lf7rLYANHIjkhKg2QQYmWg1sqpX6vqPqOii+A1AUVWlHi1p+VGL2JA9hNWd9v1076waRwOoWyZ4o3vbxig3s4K0m+Au+EbxVsNHXdZlmOT40S0S747u4WBXc0DbeNC1hAd5rsm/8L8KGt4D6YM84wsdYvtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NI0TXxna9Q4A+0oib7Nh9hyRMric/3e/+cYBycjs+J8=;
 b=Lj4YyTJgLMbA3OLUsMzSMydsGRDg27NlvHFEM8ecKe6MzMz+2p2gL2qg8nUy78e6qvV/5mal5waTyC5wQX4PW2UMFAx7PcuuOa7gwBSskrLhFEmtU0iajGEJBJk8fHOPua7nx63nTT+keWFwH46iAhQCxK/IrCVWmKJm0mJV3AbuExmAqtieMUQhmoK58v1hvISXkNstgkD13XWgYZi9r+9gTM8m+3K0aRqAqGN8OHkuL6tlQNSlPRGl7yGkw9EsbkXUVYbG8AtDNhP5xxSuNsgmOpZk8laOZJb8ehp7Qq1vqnqkdT3Xfu9WnC4GEnORqMDlvwbaszxvTYRjMRKYMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NI0TXxna9Q4A+0oib7Nh9hyRMric/3e/+cYBycjs+J8=;
 b=gJS8x26s9J7pwrb6LmqOZs2eARcyToUMVmMTDhLCk4LrIiNtnNEOMjaDdBPUZX4LuF2dPtg9L07e6AmMJvQ3PETt43yvl1owzDxkWObcojee3Be3ClUCAMxndpLKxLcHrRNRtvHwXGEEgiCAXf1eKK05dP20fuyijulDU1yYFBA=
Received: from MW4PR02CA0024.namprd02.prod.outlook.com (2603:10b6:303:16d::9)
 by BN9PR12MB5306.namprd12.prod.outlook.com (2603:10b6:408:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:43:58 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::cf) by MW4PR02CA0024.outlook.office365.com
 (2603:10b6:303:16d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:43:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:43:57 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 18/25] crypto: ccp: Handle legacy SEV commands when SNP is enabled
Date: Thu, 25 Jan 2024 22:11:18 -0600
Message-ID: <20240126041126.1927228-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|BN9PR12MB5306:EE_
X-MS-Office365-Filtering-Correlation-Id: 591a442d-f3bc-45b1-16ae-08dc1e2968db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XOOHhdoKjm65vCjo8+hUgclOITHjxUG3Zaf4q796Jy2+fWKqEbtT9v/a3qoGt7GMaZGdCALyeOqEB0Zg1DKT5C/KEn4cgalsQMCUUg5SONT1hAo0vfvIfw9BO4kEwObNPR4PCHPpFBzfwmNlcA+H+AcurW6ziGfhqwDjA8AYKNBdg/w7ugtK1fsNC23ZjbDnuYdVxNw7QMfANnaiFCX4ZTygRs6+ZCNWIJLdtSxDZ9yMYouWKtmC3NKBEvu7aHfOykEQVQbepCzk1D0qVqxaUpZ2e8tnL80X7LRb+d1P4hJbPWy+P6rKY/7oOsaFATqWFf51o5gEIARnt1SLgYcTKOOfn4LJnfUkzlZ5qdTfuAGW69eWrSZJP1WvhLn1KS+WV3t7ut3xRQzf0rUvMQtYd5HoV976wuun4x9nPjTi963+XanHuO70vydnzraZej3tZgMsIfhuyUWgf8x42Vd5XcEEgvbEu/OyExYSqYw3Pvjv408lJNBeXwx083U2DxfKBpXoMK3mxCkIQH8Wz/SnC9DxYc9JqQYxmVAMNg/2ycpHtlGU+yLg5SDRhc9Lr5SDo0dgoav9333mwYe5IQLfbOS7TOJNMDBYqugLwuta8Cgaldgo768kL6uO1gjQnpgQ+U0QbpSDjcbDwkr1hAlL3qj3tH9sMQJZ/DnUAFOX+eBdPE2DV5+lBLurBYS4xAxs176yiwib5VOjbZto26jjsPEnnophGanEcjQ9+CuQKGoJiXHmxXHRBhBhxxHmDvV5SOeHuCFxvdEMe6A/LxzTag==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(376002)(396003)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(40470700004)(36840700001)(46966006)(82740400003)(7406005)(356005)(81166007)(30864003)(2906002)(7416002)(36860700001)(5660300002)(44832011)(41300700001)(36756003)(86362001)(336012)(426003)(26005)(16526019)(478600001)(1076003)(2616005)(6666004)(8936002)(8676002)(4326008)(47076005)(83380400001)(54906003)(70206006)(316002)(6916009)(70586007)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:43:58.0042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 591a442d-f3bc-45b1-16ae-08dc1e2968db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5306

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
to hypervisor-owned after the command completes.

For case #2, a bounce buffer is used instead of the original address.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 418 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   3 +
 2 files changed, 411 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 97fdd98e958c..b2ad41ce5f77 100644
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
 
@@ -464,13 +473,344 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+/**
+ * struct cmd_buf_desc - descriptors for managing legacy SEV command address
+ * parameters corresponding to buffers that may be written to by firmware.
+ *
+ * @paddr_ptr: pointer the address parameter in the command buffer, which may
+ *             need to be saved/restored depending on whether a bounce buffer is
+ *             used. Must be NULL if this descriptor is only an end-of-list
+ *             indicator.
+ * @paddr_orig: storage for the original address parameter, which can be used to
+ *              restore the original value in @paddr_ptr in cases where it is
+ *              replaced with the address of a bounce buffer.
+ * @len: length of buffer located at the address originally stored at @paddr_ptr
+ * @guest_owned: true if the address corresponds to guest-owned pages, in which
+ *               case bounce buffers are not needed.
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
+	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
+
+	/* Transition the buffer to firmware-owned. */
+	if (rmp_mark_pages_firmware(*desc->paddr_ptr, npages, true)) {
+		pr_warn("Error moving pages to firmware-owned state for SEV legacy command.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
+{
+	unsigned int npages;
+
+	if (!desc->len)
+		return 0;
+
+	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
+
+	/* Transition the buffers back to hypervisor-owned. */
+	if (snp_reclaim_pages(*desc->paddr_ptr, npages, true)) {
+		pr_warn("Failed to reclaim firmware-owned pages while issuing SEV legacy command.\n");
+		return -EFAULT;
+	}
+
+	/* Copy data from bounce buffer and then free it. */
+	if (!desc->guest_owned) {
+		void *bounce_buf = __va(__sme_clr(*desc->paddr_ptr));
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
+	int i;
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
+	for (i--; i >= 0; i--)
+		snp_unmap_cmd_buf_desc(&desc_list[i]);
+
+	return -EFAULT;
+}
+
+static int snp_unmap_cmd_buf_desc_list(struct cmd_buf_desc *desc_list)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
+		struct cmd_buf_desc *desc = &desc_list[i];
+
+		if (!desc->paddr_ptr)
+			break;
+
+		if (snp_unmap_cmd_buf_desc(&desc_list[i]))
+			ret = -EFAULT;
+	}
+
+	return ret;
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
+static int snp_reclaim_cmd_buf(int cmd, void *cmd_buf)
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
@@ -490,12 +830,47 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
+				"SEV: too many firmware commands in progress, no command buffers available.\n");
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
+				"SEV: failed to prepare buffer for legacy command 0x%x. Error: %d\n",
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
@@ -549,15 +924,36 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
+		int ret_reclaim;
+		/*
+		 * Restore the page state after the command completes.
+		 */
+		ret_reclaim = snp_reclaim_cmd_buf(cmd, cmd_buf);
+		if (ret_reclaim) {
+			dev_err(sev->dev,
+				"SEV: failed to reclaim buffer for legacy command %#x. Error: %d\n",
+				cmd, ret_reclaim);
+			return ret_reclaim;
+		}
+
+		memcpy(data, cmd_buf, buf_len);
+
+		if (sev->cmd_buf_backup_active)
+			sev->cmd_buf_backup_active = false;
+		else
+			sev->cmd_buf_active = false;
+
+		if (snp_unmap_cmd_buf_desc_list(desc_list))
+			return -EFAULT;
+	}
+
+	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     buf_len, false);
 
 	return ret;
 }
@@ -1657,10 +2053,12 @@ int sev_dev_init(struct psp_device *psp)
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


