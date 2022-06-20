Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADDB552788
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346295AbiFTXE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346124AbiFTXEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:04:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE0522538;
        Mon, 20 Jun 2022 16:04:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gooQaPpNrLdtYvYtNDydfJRJjlR/7AJr6owOI7CR8ZBnD3DXw1XKFq1WZRjvQV2Pd1ZIP6Z7wAJWUJ7hqyiASOoNxdekdA2KCzCEG9CK9s+6QDluK7fw212FbALGpRp/PzuhWwSMRspA/qm2/AaweRj/kjpVKOQmT1CsbPkqPQFQv5er95+yfCB7ezBWPr/dh7NVeunQobvq9GhumxqdNb7M0TDm5/8AmZkPWkRnIdM3Je1JD8Q7UK8dHIKLqy5NK/aeRD03VZHqEQX6Y2OY1lS/3n2PaYU0nNkU40HyA2Ea/m+2reqrtywF38nGNFWX3iDqu0c+C2hAYaArKHVAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pg4zQ/yUsU6Fg1kyiVahkpOCAiv2WsDy1gbOZFp5PVo=;
 b=FjqMrFUErR95nsvj/qfwLCHVY7/1q4JHUoglsMTBW+ys/CBE01RDm7u+VuDDHOqFLfHCNA+xc4rjhrsbLtrMIUmLrmGkSJR/LCGmF0NILWdRiAXUvb2dP8ZGjTY5l5v/B2n8R0Kt3GjTXI22Nq0il8kBK7K+gMvutqNV0jbEdB+UfpgSk1AwgBjxgzPqAZw4IQkuxOtlMN2sIg/76/15OCku0CNJ7c9G6W9vWh2W1mxPWEhcXZ87bSYJy69i7ju7wC58SNcE6QMGmd1H+WcCLItINUZYjQQMrI9XUzQoQiGXIsej30YHKGUw4Z9z7rXeb+dE5CAFWYBSx2jZA2KZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pg4zQ/yUsU6Fg1kyiVahkpOCAiv2WsDy1gbOZFp5PVo=;
 b=v3VtWRuclJysKEk2e0RAaFE6YNKwVbiOxAcFjSq5yJKxhfeOgJ8BsEg0JA/3xfwB25rA9tBK5Tsqh9Jlyq/2Hx0r6MIX1ucg1TiuDd9HB2u7lilV8OrBVhVSfuntdpo81KYAXtjHUrPcT6aAXSGrcQR/W3iEtYYqXZWXxZbL/Oc=
Received: from SJ0PR03CA0090.namprd03.prod.outlook.com (2603:10b6:a03:331::35)
 by CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:04:27 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:331:cafe::5f) by SJ0PR03CA0090.outlook.office365.com
 (2603:10b6:a03:331::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17 via Frontend
 Transport; Mon, 20 Jun 2022 23:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:04:26 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:04:23 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 11/49] crypto:ccp: Define the SEV-SNP commands
Date:   Mon, 20 Jun 2022 23:04:14 +0000
Message-ID: <f5dec307d246096768afd770d16a26be25fa28b3.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a765b70-61c3-472f-c4f2-08da53113948
X-MS-TrafficTypeDiagnostic: CO6PR12MB5489:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB548959C13CD9F3B3942EC7308EB09@CO6PR12MB5489.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1QCRKbb/rgnRPNNGzveNTQUUXYwomWWyEFYRlr2tO8kr+x8sPTjITh6ITOeiW2r+vsQm2RB7Zse2nFGVvMjXvvIHfkCuvgEAIYj+rwy69H8RFDbXU6TQRRLnImdnJFWOQTvKzpbbHCvQOHyneJtZSCdnvlqZnpNZkdJ/wI0H4az/K9aoiTTetjW4VBoUdpI2ncm/7ImLckpAuFmhtwJMrIfVnU26Z3iyBN5SRVYgbSv0fOBIcqxiWPufBWlGwGgvWh/1h1+Cequx4CcBhYV1JR4LETfAc3yJgdQmQB6mv6lF5AWoh/JZIMFRbiOzY9VdJc3IUN5kCHP4nFf/Cb2FXT+VI2bD+NRrSFZrOgVdAGg+iFrGlujSOIfgWTkv9ujPfn0zou3hREFAJbzf3K/LbExWvkn+U3Frjjc1qAwkTOssR80KdeX5w9yTk63UJzpkwqW5cLV+Sxu10uPSK2HElPzQTSMntv74wJuST6yK+nc4mPlGrdU82EJGeWutu/VQpHvkMlsAqPRKqGNdWMRBQV81kXT+IbevFNZ/LeB5+TvOCdICdxzX0zYU6Pp5Wi6NQtM32rVu/XR/pFHYTmCN5f+BMi+ICgnE4GxXnOFWIluUPxkgRZ8q1mm++jWle8kAyN1DD+PU70kcIUFwRTtL8dopBY2fKBHXNJWVzMH+s+8dT11yMKlGZmuQ3pVEbp3tDwn35Zwu4Of1pcp4aSiI9AuVWk75bKIWQAxHyJ8wWxuZury5A9LP0KDg+otp8BUt3fPvupvWJc7xhZRFWc5LTWH9u6TIkZdiOoegFdpQiG5W9HRMeDBCxdVMNUpaDfDa5EyP63/QHMQ2zTLb7XatPWty7ol2xXvNJvKhqXPiyQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(40470700004)(36840700001)(478600001)(54906003)(36860700001)(82310400005)(82740400003)(36756003)(83380400001)(2906002)(8936002)(70586007)(110136005)(8676002)(7406005)(5660300002)(7416002)(30864003)(316002)(7696005)(4326008)(81166007)(186003)(426003)(336012)(47076005)(16526019)(6666004)(2616005)(40480700001)(86362001)(40460700003)(70206006)(26005)(356005)(41300700001)(84970400001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:04:26.5872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a765b70-61c3-472f-c4f2-08da53113948
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  14 +++
 include/linux/psp-sev.h      | 222 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  42 +++++++
 3 files changed, 278 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fd928199bf1e..9cb3265f3bef 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -153,6 +153,20 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
 	case SEV_CMD_SEND_CANCEL:		return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_SNP_GCTX_CREATE:		return sizeof(struct sev_data_snp_gctx_create);
+	case SEV_CMD_SNP_LAUNCH_START:		return sizeof(struct sev_data_snp_launch_start);
+	case SEV_CMD_SNP_LAUNCH_UPDATE:		return sizeof(struct sev_data_snp_launch_update);
+	case SEV_CMD_SNP_ACTIVATE:		return sizeof(struct sev_data_snp_activate);
+	case SEV_CMD_SNP_DECOMMISSION:		return sizeof(struct sev_data_snp_decommission);
+	case SEV_CMD_SNP_PAGE_RECLAIM:		return sizeof(struct sev_data_snp_page_reclaim);
+	case SEV_CMD_SNP_GUEST_STATUS:		return sizeof(struct sev_data_snp_guest_status);
+	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
+	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
+	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_platform_status_buf);
+	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
+	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1595088c428b..01ba9dc46ca3 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -86,6 +86,34 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* SNP specific commands */
+	SEV_CMD_SNP_INIT		= 0x81,
+	SEV_CMD_SNP_SHUTDOWN		= 0x82,
+	SEV_CMD_SNP_PLATFORM_STATUS	= 0x83,
+	SEV_CMD_SNP_DF_FLUSH		= 0x84,
+	SEV_CMD_SNP_INIT_EX		= 0x85,
+	SEV_CMD_SNP_DECOMMISSION	= 0x90,
+	SEV_CMD_SNP_ACTIVATE		= 0x91,
+	SEV_CMD_SNP_GUEST_STATUS	= 0x92,
+	SEV_CMD_SNP_GCTX_CREATE		= 0x93,
+	SEV_CMD_SNP_GUEST_REQUEST	= 0x94,
+	SEV_CMD_SNP_ACTIVATE_EX		= 0x95,
+	SEV_CMD_SNP_LAUNCH_START	= 0xA0,
+	SEV_CMD_SNP_LAUNCH_UPDATE	= 0xA1,
+	SEV_CMD_SNP_LAUNCH_FINISH	= 0xA2,
+	SEV_CMD_SNP_DBG_DECRYPT		= 0xB0,
+	SEV_CMD_SNP_DBG_ENCRYPT		= 0xB1,
+	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0xC0,
+	SEV_CMD_SNP_PAGE_SWAP_IN	= 0xC1,
+	SEV_CMD_SNP_PAGE_MOVE		= 0xC2,
+	SEV_CMD_SNP_PAGE_MD_INIT	= 0xC3,
+	SEV_CMD_SNP_PAGE_MD_RECLAIM	= 0xC4,
+	SEV_CMD_SNP_PAGE_RO_RECLAIM	= 0xC5,
+	SEV_CMD_SNP_PAGE_RO_RESTORE	= 0xC6,
+	SEV_CMD_SNP_PAGE_RECLAIM	= 0xC7,
+	SEV_CMD_SNP_PAGE_UNSMASH	= 0xC8,
+	SEV_CMD_SNP_CONFIG		= 0xC9,
+
 	SEV_CMD_MAX,
 };
 
@@ -531,6 +559,200 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_platform_status_buf - SNP_PLATFORM_STATUS command params
+ *
+ * @address: physical address where the status should be copied
+ */
+struct sev_data_snp_platform_status_buf {
+	u64 status_paddr;			/* In */
+} __packed;
+
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
+ * struct sev_data_snp_gctx_create - SNP_GCTX_CREATE command params
+ *
+ * @gctx_paddr: system physical address of the page donated to firmware by
+ *		the hypervisor to contain the guest context.
+ */
+struct sev_data_snp_gctx_create {
+	u64 gctx_paddr;				/* In */
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
+ * struct sev_data_snp_decommission - SNP_DECOMMISSION command params
+ *
+ * @address: system physical address guest context page
+ */
+struct sev_data_snp_decommission {
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
+ * @gctx_addr: system pphysical address of guest context page
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
+ * @paddr: system physical address of page to be claimed. The BIT0 indicate
+ *	the page size. 0h indicates 4 kB and 1h indicates 2 MB page.
+ */
+struct sev_data_snp_page_reclaim {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_unsmash - SNP_PAGE_UNMASH command params
+ *
+ * @paddr: system physical address of page to be unmashed. The BIT0 indicate
+ *	the page size. 0h indicates 4 kB and 1h indicates 2 MB page.
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
+ * @len: len of data to operate on
+ */
+struct sev_data_snp_dbg {
+	u64 gctx_paddr;				/* In */
+	u64 src_addr;				/* In */
+	u64 dst_addr;				/* In */
+	u32 len;				/* In */
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
+ * struuct sev_data_snp_init - SNP_INIT_EX structure
+ *
+ * @init_rmp: indicate that the RMP should be initialized.
+ */
+struct sev_data_snp_init_ex {
+	u32 init_rmp:1;
+	u32 rsvd:31;
+	u8 rsvd1[60];
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf..bed65a891223 100644
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
 
@@ -147,6 +154,41 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_status - SNP status
+ *
+ * @major: API major version
+ * @minor: API minor version
+ * @state: current platform state
+ * @build: firmware build id for the API version
+ * @guest_count: the number of guest currently managed by the firmware
+ * @tcb_version: current TCB version
+ */
+struct sev_user_data_snp_status {
+	__u8 api_major;		/* Out */
+	__u8 api_minor;		/* Out */
+	__u8 state;		/* Out */
+	__u8 rsvd;
+	__u32 build_id;		/* Out */
+	__u32 rsvd1;
+	__u32 guest_count;	/* Out */
+	__u64 tcb_version;	/* Out */
+	__u64 rsvd2;
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
+	__u64 reported_tcb;     /* In */
+	__u32 mask_chip_id;     /* In */
+	__u8 rsvd[52];
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1

