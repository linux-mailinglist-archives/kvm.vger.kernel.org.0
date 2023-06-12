Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A8972B67B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbjFLEcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbjFLEbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:31:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6981BDF;
        Sun, 11 Jun 2023 21:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H967fgcnWDfI8f1DAABvenBz5Yfdm+n/GDCDu2fm7tZhV8d+STOHSLDbPsOlnZOo4nOwYX3fBeT5CePouZ9ggI9hPSnQ2LxTcOEk6+x61mKiIK9QCtgAo5+3SnFVWRuYGgIPch0UVfXwRk1tIgQKADy2/qKQHz3pJQ815M/TFMA2cqJcvIu0uW4RJWjZA8qqiXLXvtt59sBUpZUQBABn3M+JdVac3OZZqHhQDVuTWeeRcdz9sV9VgWUHsdbl+IgVr9r2ahG+zbdsmQYyMUnFnXmhPb8mzEUOy28lgB7H/wGZnYgIFJ/fqhiPAOm5MMBCbGGHIEvm6ePEURsQ37ZiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Zsc6mV3GrvXD9w3AgjvVW3vHnvwWqzD9ghwmSVayr4=;
 b=grKXx+OOh7xGgaYfkGq6vChAsHOg/KH2r6OTTxZTfMymU8XggV+fclKCqe3o8+VDAZwEeT6rdXq6a1DI6lWA1SoNZNz0ZyZrj695q2Miox9Gy3h3aIsls7Zb/7K5j6hduJTg9S2SnyRqVnDG89CuUqNHnqAd1h5G/Y4beSSbjNghD6kE2BJ74yUIEXLM5MxO+/sKBfQfdM9w4mrVzjlpKdL1uJCs4An8iEVDY8/d/U/peTpHKwpUKNZo5yv0zrr2Yas1Cm/fqGwnCEfjo2vgbkYB28QRRvb8Qg8hMBUEhk31QLL9ca4Xf0dVP1qgWsC95I83/8oYy43cu6woBvuwYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Zsc6mV3GrvXD9w3AgjvVW3vHnvwWqzD9ghwmSVayr4=;
 b=lH/2OwSTOzmy7Jxd1ZRgMVF+OTA0tXuCn+c1Xiy451c4BCuUi0Vg3vKs8GqjgH/F1kL/vK8Q3sy62x7m6Lo9uYT6cScKN87qawWgunHKbLChwqX1LhTQQmwZIMcLh1d79ml/imtNT+pAcjTBtGjPJYddn7cqgJLOG7eqcJw5krc=
Received: from CY5PR19CA0115.namprd19.prod.outlook.com (2603:10b6:930:64::23)
 by CH0PR12MB8532.namprd12.prod.outlook.com (2603:10b6:610:191::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:31:04 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:64:cafe::e5) by CY5PR19CA0115.outlook.office365.com
 (2603:10b6:930:64::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:31:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:31:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:31:01 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 16/51] crypto: ccp: Define the SEV-SNP commands
Date:   Sun, 11 Jun 2023 23:25:24 -0500
Message-ID: <20230612042559.375660-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|CH0PR12MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb54a42-0649-427a-20d3-08db6afdd516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qUrvsZ7WQdvcw7jNRRQ1QvZlFnsVj0Ngig1WJFmkuxmkrMzaBfAjhF+qmuBoiXOAwXExGsx/+142TFDJMY1fYB/ai3oiAeTz+T+jT+4uVIQQsvOR/J/ujKZ7nSiursecQFIibzPk5pmFRLYpJZsRBChA0I4K+I8FCuePNxOUtQyvlPVekN0tuttkWGD/F8lPNvBj62iQgu9hloH2VUa1gX0WQA3gRYir/dd35yxkOZ3B31uufMSs69+CWMO1dZ2kthKUEC4DRoWrX53kNc4uTDk+Ed6LdyVZlw/oxT9eAuxx56zgI2Qr9Z+NmxYgF/UcZbXDrbSKUD4chsIcwV/qDuWaev9dTiGfOllD71grNZjFtpPfk6gSzsQbehFkXeZZIYtkpq/p1JfqeUr9+mdhU4mAi6MYtRvvr6aiELP4wYBXmBx1l621WGgcaMZLtTzIw/jaPBOPttf9aScQB5pKIw5DtNfEjAosuQNdWjBAkc2qIws6XlqbPrfEe2WwxGCo+SjosmIzRAjotsaP5FKsOl3fZ5Yz28sqDHtzB6u1hTdOYrCQxwgfEbiXtsMVMLk7DT1eJB7vM96wabW3UtiaqlAp6mfijoKr2XAMKlr6SosQtPojauJyeQBMV0EUfApz6kmZ0RJHoP4U1CzzggvKIgRz6kssze0a2iP1x2lf/tICvrYAdvZ5hIiGtVOVCS06emKAbbrIhQdrDrIpKuaZXikdi3te/N51qTZZxDwuykUElLMvXyaV2KJN9DZ5p6jcRX4/AwFBLKdbE+WjMjLAw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(336012)(2616005)(47076005)(83380400001)(426003)(36860700001)(82740400003)(356005)(40480700001)(86362001)(82310400005)(81166007)(36756003)(40460700003)(478600001)(44832011)(54906003)(4326008)(6666004)(84970400001)(8936002)(8676002)(30864003)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(6916009)(41300700001)(316002)(16526019)(186003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:31:03.6074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb54a42-0649-427a-20d3-08db6afdd516
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8532
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
while adding new hardware security protection.

Define the commands and structures used to communicate with the AMD-SP
when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
is available at developer.amd.com/sev.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: update SNP command list and SNP status struct based on current
      spec]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  16 +++
 include/linux/psp-sev.h      | 246 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  53 ++++++++
 3 files changed, 315 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e2f25926eb51..ab3572286755 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -128,6 +128,8 @@ static int sev_cmd_buffer_len(int cmd)
 	switch (cmd) {
 	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
 	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
+	case SEV_CMD_SNP_SHUTDOWN_EX:		return sizeof(struct sev_data_snp_shutdown_ex);
+	case SEV_CMD_SNP_INIT_EX:		return sizeof(struct sev_data_snp_init_ex);
 	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
 	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
 	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
@@ -156,6 +158,20 @@ static int sev_cmd_buffer_len(int cmd)
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
index 1595088c428b..06d0619ca442 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -86,6 +86,36 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* SNP specific commands */
+	SEV_CMD_SNP_INIT			= 0x81,
+	SEV_CMD_SNP_SHUTDOWN			= 0x82,
+	SEV_CMD_SNP_PLATFORM_STATUS		= 0x83,
+	SEV_CMD_SNP_DF_FLUSH			= 0x84,
+	SEV_CMD_SNP_INIT_EX			= 0x85,
+	SEV_CMD_SNP_SHUTDOWN_EX			= 0x86,
+	SEV_CMD_SNP_DECOMMISSION		= 0x90,
+	SEV_CMD_SNP_ACTIVATE			= 0x91,
+	SEV_CMD_SNP_GUEST_STATUS		= 0x92,
+	SEV_CMD_SNP_GCTX_CREATE			= 0x93,
+	SEV_CMD_SNP_GUEST_REQUEST		= 0x94,
+	SEV_CMD_SNP_ACTIVATE_EX			= 0x95,
+	SEV_CMD_SNP_LAUNCH_START		= 0xA0,
+	SEV_CMD_SNP_LAUNCH_UPDATE		= 0xA1,
+	SEV_CMD_SNP_LAUNCH_FINISH		= 0xA2,
+	SEV_CMD_SNP_DBG_DECRYPT			= 0xB0,
+	SEV_CMD_SNP_DBG_ENCRYPT			= 0xB1,
+	SEV_CMD_SNP_PAGE_SWAP_OUT		= 0xC0,
+	SEV_CMD_SNP_PAGE_SWAP_IN		= 0xC1,
+	SEV_CMD_SNP_PAGE_MOVE			= 0xC2,
+	SEV_CMD_SNP_PAGE_MD_INIT		= 0xC3,
+	SEV_CMD_SNP_PAGE_SET_STATE		= 0xC6,
+	SEV_CMD_SNP_PAGE_RECLAIM		= 0xC7,
+	SEV_CMD_SNP_PAGE_UNSMASH		= 0xC8,
+	SEV_CMD_SNP_CONFIG			= 0xC9,
+	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX	= 0xCA,
+	SEV_CMD_SNP_COMMIT			= 0xCB,
+	SEV_CMD_SNP_VLEK_LOAD			= 0xCD,
+
 	SEV_CMD_MAX,
 };
 
@@ -531,6 +561,222 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
+ *
+ * @address: physical address of firmware image
+ * @len: len of the firmware image
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
+ * @address: system physical address guest context page
+ */
+struct sev_data_snp_addr {
+	u64 gctx_paddr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
+ *
+ * @gctx_addr: system physical address of guest context page
+ * @policy: guest policy
+ * @ma_gctx_addr: system physical address of migration agent
+ * @imi_en: launch flow is launching an IMI for the purpose of
+ *   guest-assisted migration.
+ * @ma_en: the guest is associated with a migration agent
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
+ * @gctx_addr: system physical address of guest context page
+ * @imi_page: indicates that this page is part of the IMI of the guest
+ * @page_type: encoded page type
+ * @page_size: page size 0 indicates 4K and 1 indicates 2MB page
+ * @address: system physical address of destination page to encrypt
+ * @vmpl1_perms: VMPL permission mask for VMPL1
+ * @vmpl2_perms: VMPL permission mask for VMPL2
+ * @vmpl3_perms: VMPL permission mask for VMPL3
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
+ * @gctx_addr: system physical address of guest context page
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
+ * @paddr: system physical address of page to be claimed. The 0th bit
+ *	in the address indicates the page size. 0h indicates 4 kB and
+ *	1h indicates 2 MB page.
+ */
+struct sev_data_snp_page_reclaim {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_unsmash - SNP_PAGE_UNSMASH command params
+ *
+ * @paddr: system physical address of page to be unsmashed. The 0th bit
+ *	in the address indicates the page size. 0h indicates 4 kB and
+ *	1h indicates 2 MB page.
+ */
+struct sev_data_snp_page_unsmash {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
+ *
+ * @handle: handle of the VM to perform debug operation
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
+ * struct sev_snp_guest_request - SNP_GUEST_REQUEST command params
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
+ * struct sev_data_snp_init - SNP_INIT_EX structure
+ *
+ * @init_rmp: indicate that the RMP should be initialized.
+ * @list_paddr_en: indicate that list_paddr is valid
+ * @list_paddr: system physical address of range list
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
+ * @ranges: array of num_elements of type RANGE
+ */
+struct sev_data_range_list {
+	u32 num_elements;
+	u32 rsvd;
+	struct sev_data_range ranges[0];
+} __packed;
+
+/**
+ * struct sev_data_snp_shutdown_ex - SNP_SHUTDOWN_EX structure
+ *
+ * @length: len of the command buffer read by the PSP
+ * @iommu_snp_shutdown: Disable enforcement of SNP in the IOMMU
+ */
+struct sev_data_snp_shutdown_ex {
+	u32 length;
+	u32 iommu_snp_shutdown:1;
+	u32 rsvd1:31;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf..7d8a2dd20273 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -61,6 +61,13 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
+	SEV_RET_INVALID_PAGE_SIZE,
+	SEV_RET_INVALID_PAGE_STATE,
+	SEV_RET_INVALID_MDATA_ENTRY,
+	SEV_RET_INVALID_PAGE_OWNER,
+	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
+	SEV_RET_RMP_INIT_REQUIRED,
+
 	SEV_RET_MAX,
 } sev_ret_code;
 
@@ -147,6 +154,52 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_status - SNP status
+ *
+ * @major: API major version
+ * @minor: API minor version
+ * @state: current platform state
+ * @is_rmp_initialized: whether RMP is initialized or not
+ * @build: firmware build id for the API version
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @vlek_en: VLEK hashstick is loaded
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
+/*
+ * struct sev_user_data_snp_config - system wide configuration value for SNP.
+ *
+ * @reported_tcb: The TCB version to report in the guest attestation report.
+ * @mask_chip_id: Indicates that the CHID_ID field in the attestation report
+ * will always be zero.
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

