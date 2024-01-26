Return-Path: <kvm+bounces-7055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADF683D38A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E2D7B2430D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660D2D29B;
	Fri, 26 Jan 2024 04:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UBqDzf6H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE09511185;
	Fri, 26 Jan 2024 04:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244120; cv=fail; b=qhr8l3bYJDVtrwcTxX3UiOMWJRqR4uth2L3bLNe2Rjt+6dOWx7EtO6gHAoMMSQRJZRe8yWfgpsj6T1pBC7fG5xy7yzk1LsI8XNmrf5SFKKngZMmU+64kc8gL15grIsCl45tgr0d2QQ7es8VsfHJSlHU3CL+VN6Fp9W4JezgxybM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244120; c=relaxed/simple;
	bh=aOy2/olMr0teb3g3T30dDY1SNksUSnENCO97rOG7yuU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDJzWGNf4Ml3aPnxdfVeem87oXx99zux4e6JWjwd6NeoAEwmg1hHgcZrd7C1erpkFqEFDhR7dH4AdDosU2QPise75AocFmjsZAtmqoz7rpHQA0uVfynEkDPKEkvI0j1fzGei0mWESu/xenyb4abQOsWo+RRoW1of4uXqdLRK5As=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UBqDzf6H; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iwgkqbrk6TJ7N+k5EExU4f6blUeAM3R4Q9tOU8I5s0zNGvYrUOyJM+VRQ+YQPKh4F50C1kLc4QmcLz7m2x6NI2pjYN/h6JK2fqynzpYfqdiVrM/nccVvJdo2/VLm+FGPk65yVqWYP2JqyHtExq8iIT4NaGpU7RKFBJFildkyZXNXo8nm39KYhYpxnAP9Gc1SAU2BLHf6gquce6dlrdfHTnXTieuXjsPu1luIQlVD7bY+F6TSJLf4b+EA0PxJGD96sUguTZ5yydU2un99SGNffzgT49xoXl6x89yfAiBsbilBqgfh4yOsWqGzqMF18JUMIeTCKCrNR1GdxEfdwJC1Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMQff3xMrtTAk9jHUzlJLddFasX2fCuSYJJ9cnssB5s=;
 b=Hsko0JEoJkmgV/NRFaOLekBgZ1V1TgWHh0EHMayVPGcTBPCnxGiESB9C+G/+LWux4ucSNlEQb04unoOg28HjlalP4LekRdnuirMIKagBU6/yFB3ZndWBAxQMqW8URTtBzJFEOak0sym+mftjSOkuFJNhNF8RKprke2cveoBvfFoYBxC89vO0yjXpovPxEYylVxTf4+aOi5eYVyRjLRpxeCPYtyNjiiXLlAYnrZp/d2BJyU/wH2cMxfgQmcjY2yzw9K4k2AbhrN4YhKd7tOKu5qT9I+a6vVHGlf5VenzJclq/jjjWZTPmy6XGQB4MidGzC4m58KdplqUSJfeFjEuy+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMQff3xMrtTAk9jHUzlJLddFasX2fCuSYJJ9cnssB5s=;
 b=UBqDzf6Hi29E3U8MWsqVYWhcQ2v2kUoyFukIbY4n8lsn1pxkH+OLeC71npOXmdyd6mYNjWBTpTBrh7lY6n2RHQXFiSt0rAfS1pE9dLdPXbAk45+Le4K7MkZ1aw3v0qmtJCgc08HAYOyKVcPtNaBkSfT7kCCwSAGD+Glwsh9UuNQ=
Received: from MW4PR02CA0009.namprd02.prod.outlook.com (2603:10b6:303:16d::20)
 by DM4PR12MB7765.namprd12.prod.outlook.com (2603:10b6:8:113::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 04:41:54 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::69) by MW4PR02CA0009.outlook.office365.com
 (2603:10b6:303:16d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:41:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:41:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:41:52 -0600
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
Subject: [PATCH v2 12/25] crypto: ccp: Define the SEV-SNP commands
Date: Thu, 25 Jan 2024 22:11:12 -0600
Message-ID: <20240126041126.1927228-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|DM4PR12MB7765:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f09d903-e00e-4fd8-187b-08dc1e291edf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	stQ6lE2yg+RufQX99qT6q2Hl70WebvoleNAoZLUCmy45c9TP8k0s89T+BFImcyr3EvpmUJKGYhiYEgCToiOx52qevUx2F/d0XWkCFDyaxlT5dHdqeqRmCxztv8yUEb7e79K4T+CcSk3vCVHUqNt2KNMpghaOsr/v/sqgGbNwjfz85r72xWv0gLxSSBMR3nhNNjoxokTG/IoQsCy5AlcyPhnNXp8sh2bDEwG1O4Cz7kZTKZKLNBLZ+/V0EJEmfrn7esr2KExH7FOOtlF5aGflhTeRHlmiE8RVY64EXJZ9+VVqeLv8WsIFqrTaLTp3Gm2MY3HPOLQq8XN0ba4TCBWJ+t7fvi7M4H5dcFvGKgoM6YNqGEjnY8n/s6bV005S93zTShYDLGyZ1UU+0046jubhHVMuDPeI3G0a20S7oFxJd6vjxA7D8z1ASN8QYfi0zis6FdC+g/aUKIxRcAk4zAMfKEXDo3g3JrxJZCU3/JquR1NgmVugSe7S/UIPaCpgMiFfpBCUuzql7+Hiqc4VO/6pbLbrlMU8mSQxFC3RwMfXMpEWqQrMSVbMHq7JfVcwBYcmRt4opakcv9q6IYbxaH8uUZD4gtiF5asJCbuJuKkyGbBY/5NnowPJRtceFPi/AAQ3TyOsWJMlRQqkuSMEByo9+W9h8y+X7FDKFQ17bxszgYROdV8cGUCfQd1s02pgTN1nG2owuqpA6wOt5JvhiufF9LzfYtA0Bn3CXcVto+48tWsePXhC73ZOrXUdXAAJR7KV/5AOiBoPi5gBDaxkEm+buA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(82310400011)(1800799012)(186009)(451199024)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(84970400001)(83380400001)(336012)(41300700001)(356005)(86362001)(36756003)(426003)(82740400003)(81166007)(2616005)(26005)(1076003)(30864003)(47076005)(36860700001)(8676002)(16526019)(70206006)(6666004)(6916009)(54906003)(7406005)(2906002)(316002)(478600001)(70586007)(44832011)(8936002)(5660300002)(7416002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:41:53.8791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f09d903-e00e-4fd8-187b-08dc1e291edf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7765

From: Brijesh Singh <brijesh.singh@amd.com>

AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality while
adding new hardware security protection.

Define the commands and structures used to communicate with the AMD-SP
when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
is available at developer.amd.com/sev.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: update SNP command list and SNP status struct based on current
      spec, use C99 flexible arrays, fix kernel-doc issues]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  16 +++
 include/linux/psp-sev.h      | 265 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  56 ++++++++
 3 files changed, 337 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e4d3f45242f6..e38986d39b63 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -130,6 +130,8 @@ static int sev_cmd_buffer_len(int cmd)
 	switch (cmd) {
 	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
 	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
+	case SEV_CMD_SNP_SHUTDOWN_EX:		return sizeof(struct sev_data_snp_shutdown_ex);
+	case SEV_CMD_SNP_INIT_EX:		return sizeof(struct sev_data_snp_init_ex);
 	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
 	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
 	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
@@ -158,6 +160,20 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
 	case SEV_CMD_SEND_CANCEL:		return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_SNP_GCTX_CREATE:		return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_LAUNCH_START:		return sizeof(struct sev_data_snp_launch_start);
+	case SEV_CMD_SNP_LAUNCH_UPDATE:		return sizeof(struct sev_data_snp_launch_update);
+	case SEV_CMD_SNP_ACTIVATE:		return sizeof(struct sev_data_snp_activate);
+	case SEV_CMD_SNP_DECOMMISSION:		return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_PAGE_RECLAIM:		return sizeof(struct sev_data_snp_page_reclaim);
+	case SEV_CMD_SNP_GUEST_STATUS:		return sizeof(struct sev_data_snp_guest_status);
+	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
+	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
+	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
+	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 7fd17e82bab4..006e4cdbeb78 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -78,6 +78,36 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* SNP specific commands */
+	SEV_CMD_SNP_INIT		= 0x081,
+	SEV_CMD_SNP_SHUTDOWN		= 0x082,
+	SEV_CMD_SNP_PLATFORM_STATUS	= 0x083,
+	SEV_CMD_SNP_DF_FLUSH		= 0x084,
+	SEV_CMD_SNP_INIT_EX		= 0x085,
+	SEV_CMD_SNP_SHUTDOWN_EX		= 0x086,
+	SEV_CMD_SNP_DECOMMISSION	= 0x090,
+	SEV_CMD_SNP_ACTIVATE		= 0x091,
+	SEV_CMD_SNP_GUEST_STATUS	= 0x092,
+	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
+	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
+	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
+	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
+	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
+	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
+	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
+	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
+	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
+	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
+	SEV_CMD_SNP_PAGE_MD_INIT	= 0x0C3,
+	SEV_CMD_SNP_PAGE_SET_STATE	= 0x0C6,
+	SEV_CMD_SNP_PAGE_RECLAIM	= 0x0C7,
+	SEV_CMD_SNP_PAGE_UNSMASH	= 0x0C8,
+	SEV_CMD_SNP_CONFIG		= 0x0C9,
+	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
+	SEV_CMD_SNP_COMMIT		= 0x0CB,
+	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+
 	SEV_CMD_MAX,
 };
 
@@ -523,6 +553,241 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
+ *
+ * @address: physical address of firmware image
+ * @len: length of the firmware image
+ */
+struct sev_data_snp_download_firmware {
+	u64 address;				/* In */
+	u32 len;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_activate - SNP_ACTIVATE command params
+ *
+ * @gctx_paddr: system physical address guest context page
+ * @asid: ASID to bind to the guest
+ */
+struct sev_data_snp_activate {
+	u64 gctx_paddr;				/* In */
+	u32 asid;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_addr - generic SNP command params
+ *
+ * @address: physical address of generic data param
+ */
+struct sev_data_snp_addr {
+	u64 address;				/* In/Out */
+} __packed;
+
+/**
+ * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @policy: guest policy
+ * @ma_gctx_paddr: system physical address of migration agent
+ * @ma_en: the guest is associated with a migration agent
+ * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
+ *          purpose of guest-assisted migration.
+ * @rsvd: reserved
+ * @gosvw: guest OS-visible workarounds, as defined by hypervisor
+ */
+struct sev_data_snp_launch_start {
+	u64 gctx_paddr;				/* In */
+	u64 policy;				/* In */
+	u64 ma_gctx_paddr;			/* In */
+	u32 ma_en:1;				/* In */
+	u32 imi_en:1;				/* In */
+	u32 rsvd:30;
+	u8 gosvw[16];				/* In */
+} __packed;
+
+/* SNP support page type */
+enum {
+	SNP_PAGE_TYPE_NORMAL		= 0x1,
+	SNP_PAGE_TYPE_VMSA		= 0x2,
+	SNP_PAGE_TYPE_ZERO		= 0x3,
+	SNP_PAGE_TYPE_UNMEASURED	= 0x4,
+	SNP_PAGE_TYPE_SECRET		= 0x5,
+	SNP_PAGE_TYPE_CPUID		= 0x6,
+
+	SNP_PAGE_TYPE_MAX
+};
+
+/**
+ * struct sev_data_snp_launch_update - SNP_LAUNCH_UPDATE command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @page_size: page size 0 indicates 4K and 1 indicates 2MB page
+ * @page_type: encoded page type
+ * @imi_page: indicates that this page is part of the IMI (Incoming Migration
+ *            Image) of the guest
+ * @rsvd: reserved
+ * @rsvd2: reserved
+ * @address: system physical address of destination page to encrypt
+ * @rsvd3: reserved
+ * @vmpl1_perms: VMPL permission mask for VMPL1
+ * @vmpl2_perms: VMPL permission mask for VMPL2
+ * @vmpl3_perms: VMPL permission mask for VMPL3
+ * @rsvd4: reserved
+ */
+struct sev_data_snp_launch_update {
+	u64 gctx_paddr;				/* In */
+	u32 page_size:1;			/* In */
+	u32 page_type:3;			/* In */
+	u32 imi_page:1;				/* In */
+	u32 rsvd:27;
+	u32 rsvd2;
+	u64 address;				/* In */
+	u32 rsvd3:8;
+	u32 vmpl1_perms:8;			/* In */
+	u32 vmpl2_perms:8;			/* In */
+	u32 vmpl3_perms:8;			/* In */
+	u32 rsvd4;
+} __packed;
+
+/**
+ * struct sev_data_snp_launch_finish - SNP_LAUNCH_FINISH command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @id_block_paddr: system physical address of ID block
+ * @id_auth_paddr: system physical address of ID block authentication structure
+ * @id_block_en: indicates whether ID block is present
+ * @auth_key_en: indicates whether author key is present in authentication structure
+ * @rsvd: reserved
+ * @host_data: host-supplied data for guest, not interpreted by firmware
+ */
+struct sev_data_snp_launch_finish {
+	u64 gctx_paddr;
+	u64 id_block_paddr;
+	u64 id_auth_paddr;
+	u8 id_block_en:1;
+	u8 auth_key_en:1;
+	u64 rsvd:62;
+	u8 host_data[32];
+} __packed;
+
+/**
+ * struct sev_data_snp_guest_status - SNP_GUEST_STATUS command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @address: system physical address of guest status page
+ */
+struct sev_data_snp_guest_status {
+	u64 gctx_paddr;
+	u64 address;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_reclaim - SNP_PAGE_RECLAIM command params
+ *
+ * @paddr: system physical address of page to be claimed. The 0th bit in the
+ *         address indicates the page size. 0h indicates 4KB and 1h indicates
+ *         2MB page.
+ */
+struct sev_data_snp_page_reclaim {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_unsmash - SNP_PAGE_UNSMASH command params
+ *
+ * @paddr: system physical address of page to be unsmashed. The 0th bit in the
+ *         address indicates the page size. 0h indicates 4 KB and 1h indicates
+ *         2 MB page.
+ */
+struct sev_data_snp_page_unsmash {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @src_addr: source address of data to operate on
+ * @dst_addr: destination address of data to operate on
+ */
+struct sev_data_snp_dbg {
+	u64 gctx_paddr;				/* In */
+	u64 src_addr;				/* In */
+	u64 dst_addr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_guest_request - SNP_GUEST_REQUEST command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @req_paddr: system physical address of request page
+ * @res_paddr: system physical address of response page
+ */
+struct sev_data_snp_guest_request {
+	u64 gctx_paddr;				/* In */
+	u64 req_paddr;				/* In */
+	u64 res_paddr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_init_ex - SNP_INIT_EX structure
+ *
+ * @init_rmp: indicate that the RMP should be initialized.
+ * @list_paddr_en: indicate that list_paddr is valid
+ * @rsvd: reserved
+ * @rsvd1: reserved
+ * @list_paddr: system physical address of range list
+ * @rsvd2: reserved
+ */
+struct sev_data_snp_init_ex {
+	u32 init_rmp:1;
+	u32 list_paddr_en:1;
+	u32 rsvd:30;
+	u32 rsvd1;
+	u64 list_paddr;
+	u8  rsvd2[48];
+} __packed;
+
+/**
+ * struct sev_data_range - RANGE structure
+ *
+ * @base: system physical address of first byte of range
+ * @page_count: number of 4KB pages in this range
+ * @rsvd: reserved
+ */
+struct sev_data_range {
+	u64 base;
+	u32 page_count;
+	u32 rsvd;
+} __packed;
+
+/**
+ * struct sev_data_range_list - RANGE_LIST structure
+ *
+ * @num_elements: number of elements in RANGE_ARRAY
+ * @rsvd: reserved
+ * @ranges: array of num_elements of type RANGE
+ */
+struct sev_data_range_list {
+	u32 num_elements;
+	u32 rsvd;
+	struct sev_data_range ranges[];
+} __packed;
+
+/**
+ * struct sev_data_snp_shutdown_ex - SNP_SHUTDOWN_EX structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @iommu_snp_shutdown: Disable enforcement of SNP in the IOMMU
+ * @rsvd1: reserved
+ */
+struct sev_data_snp_shutdown_ex {
+	u32 len;
+	u32 iommu_snp_shutdown:1;
+	u32 rsvd1:31;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b44ba7dcdefc..207e34217528 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -69,6 +69,12 @@ typedef enum {
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
 	SEV_RET_INVALID_KEY = 0x27,
+	SEV_RET_INVALID_PAGE_SIZE,
+	SEV_RET_INVALID_PAGE_STATE,
+	SEV_RET_INVALID_MDATA_ENTRY,
+	SEV_RET_INVALID_PAGE_OWNER,
+	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
+	SEV_RET_RMP_INIT_REQUIRED,
 	SEV_RET_MAX,
 } sev_ret_code;
 
@@ -155,6 +161,56 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_status - SNP status
+ *
+ * @api_major: API major version
+ * @api_minor: API minor version
+ * @state: current platform state
+ * @is_rmp_initialized: whether RMP is initialized or not
+ * @rsvd: reserved
+ * @build_id: firmware build id for the API version
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @rsvd1: reserved
+ * @guest_count: the number of guest currently managed by the firmware
+ * @current_tcb_version: current TCB version
+ * @reported_tcb_version: reported TCB version
+ */
+struct sev_user_data_snp_status {
+	__u8 api_major;			/* Out */
+	__u8 api_minor;			/* Out */
+	__u8 state;			/* Out */
+	__u8 is_rmp_initialized:1;	/* Out */
+	__u8 rsvd:7;
+	__u32 build_id;			/* Out */
+	__u32 mask_chip_id:1;		/* Out */
+	__u32 mask_chip_key:1;		/* Out */
+	__u32 vlek_en:1;		/* Out */
+	__u32 rsvd1:29;
+	__u32 guest_count;		/* Out */
+	__u64 current_tcb_version;	/* Out */
+	__u64 reported_tcb_version;	/* Out */
+} __packed;
+
+/**
+ * struct sev_user_data_snp_config - system wide configuration value for SNP.
+ *
+ * @reported_tcb: the TCB version to report in the guest attestation report.
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @rsvd: reserved
+ * @rsvd1: reserved
+ */
+struct sev_user_data_snp_config {
+	__u64 reported_tcb  ;   /* In */
+	__u32 mask_chip_id:1;   /* In */
+	__u32 mask_chip_key:1;  /* In */
+	__u32 rsvd:30;          /* In */
+	__u8 rsvd1[52];
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


