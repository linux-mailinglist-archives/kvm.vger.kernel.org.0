Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1D336FA8A
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhD3Mk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:29 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:41101
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232619AbhD3MkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ir0wQnPOy/aENO2abSSt7JTOXNQMPRFe26yyko3aOxXXcOeMhCxVyWUgEy18e72LMm0Uh3SyVf74RaoJdT/kz1KHnLHKAQU/0s6LtxpU0ZWZJBnTrL/QYPwqytIym9zNNnBbDcgf6isA0lu5oh0OxJk0G5vljBMNO2ywYq6QTMbXuPaPEFyHR5oitEb1l9N3Nwk40nMXfCLkB36RfRZyDhwgnKgqnzBB6aCMv4H1g2DfEDxrHrlNpixbLNR2MlpE9FEf4+P1mH2dv2coWPiSCwVDqt+P6nuqNfPzMUx5AhUgkLAgcCFCUEpfozkmAw+MuE9ifSk0x8FM67+4noqrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ6Bw8lrIRwS2WUrmh5XBCQ5mWYqcrqWepkePO899xY=;
 b=SmSR3sn+mAQp+GZ3f5U8CKadK/Jnc+iHZnSRI5mLTemtux1ozEG1pmgBzU+chvL/VxdqlOtCRlKnz6GN8YmT/6h2u7zErTdUhNtzJPEYW+QldL46eQdabTlDr0HoZ76mRmqd38lE4Xa7zrmNu5ZG9fqzqkyYwlQj5WJk+VmRqkRj/BIAPmM2+08+9IRJAHF5lbk4QQE1G80HJPWmB0mQbGcfyvh2e1L9tdTgvA6u4tt+vrDosxQ3jxbtdIedzVL7CRI/mpAAJaokvbB0vOoEulJFVP/yvN0NlmWM8RawZHs3S0GBH/0DjFZsl1n2wihlgavePAVn5Rf9zY+i2jdcXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ6Bw8lrIRwS2WUrmh5XBCQ5mWYqcrqWepkePO899xY=;
 b=Zhjq4hUETM45XLDzA0dmM4QOqX7mQAQA77Bea1jtB74zW4rO2vl4PfgAPsvLtcQ3rGtoXu7vsALgggbOebBsPnwrvqDHG/MX3JH2rrvnnR0x3VxlCi2RrJfmBNxXCHjGOiDhokOT7Wce6ykJ4467GtiiMOWAAAjYndxxus7cMWs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:02 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 12/37] crypto:ccp: Define the SEV-SNP commands
Date:   Fri, 30 Apr 2021 07:37:57 -0500
Message-Id: <20210430123822.13825-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd128264-08c3-4764-9ad8-08d90bd4ef22
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832508A8B1E76F3293C30A7E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvs9oIm7oEUnMC7WnuZm03skXDWtg9ZF0obw8rEmrizUsPIdaGSZtP1nCnIwY1Eluz9X04NR8Xu+kGx8wyLj1MuL2g+hfTIrIFFC7uaeMUwwjY0KPEGeAG8u65h7qicHT/AukXndg/6gImKE8TiIBXFdz3FmPhBZlem/IDyt/feFMNrxBTFQO7O8Z4VcuBPi33dnkS2r+JQdHpzlJ8ezFsPIApz/KSHs9NfPEOJJXvYdn8X6UNB0inni34LOonVZa5yEwdyfgyWKZTO+QbThZgcF7Fu0fi+1rmOm2hYY8eLA46/TOqLz+kL6LrJbpGbp8RUKzl/qXM0hAetUYWcd2paYPZrZyCaLua9tL5DtdDTuCb5Ix61Q7aOUnp3dc0kngnK2a6sKl9DwEAkxuAKSdqi8IVrpl+UsP2zeJ4Np6uzYhRZm5dMau6L67rK+yNYpv5eRplOGFZfUTwQ6ylL+J89XC6X7U/nybrJ5ZRGBKD/h7xL+L77fi/18PFSk3nL1nuR3lXuhU2cTzXVC1c45QqUyTnaFWJVdaqXzAgZMulwXWg74otewqUUbpkmeOButwy7FS4ErluwjYN3An+7Sk4Z7R/KEJnUutYRwKfUudnp2vZIODM7LSUkyBvejNDJFHL2zN5UN2+w5tot+qMBZnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(30864003)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YSXLaK7eyDmowTMEpADwbT41h5cFDKIR+6OQ0q62uIgd8mtSZPXGWgEWM9oJ?=
 =?us-ascii?Q?Be8zNYHFwbPS05wODDG/bBC5sIraBDNk3SmhDvqt7zv74PRlpXqB570q9/zN?=
 =?us-ascii?Q?PeC42HgCSdmMyjYT9npYYc+iVtDJWh8+eKCWhXCiPUpGiE3ikIhBa1XWHu0i?=
 =?us-ascii?Q?HCSygQEPG2z7Arez/KLSfCvOvlFAqFQZGrVMfvnorNeglo8OLqP9QOlGONU0?=
 =?us-ascii?Q?Ahebt2czDq7zvkWj1cY/zDFJv0vGl2glO1qhlXpmcobJd2KBwqAhhB1ekBZT?=
 =?us-ascii?Q?PA3D/y+5lByfTZNCqpZIswZ6TXmbOuejicnpl7mxUt+arYe6HbzgGqfBsRNZ?=
 =?us-ascii?Q?L2XDJkrp+oLQL2redNiF0Fq5vwG1ieU3zZ+SV0gnx3L7SasVA58QIlx4F0G5?=
 =?us-ascii?Q?zRckTkClAgfm7UpGc6dDfnfVSL/nq/+Fl9qgGg0CzGNdW0fiY2bHoReTiprP?=
 =?us-ascii?Q?6XIfnNS42NDETM37mwzmLNSDRwf5txCUanbzyq4c4aAJtGnfE5w5DKj+zDeD?=
 =?us-ascii?Q?6Eooidi3ygoBrW8EO7fKDHfMbdybMXCPYpZpYMApdUYJAngM0uOu3u/Vftgj?=
 =?us-ascii?Q?oy4qqVeCyEcgsagRTvy+6PylHIrUBQxU/OTXsB24WZCDG42kBKPX7bBxO7gZ?=
 =?us-ascii?Q?H+mlI2NRbLPAw40mlvNouk8o/ADnTBYtxgY1kQwIsHrEEVTDJLXla4TdjFMZ?=
 =?us-ascii?Q?fITxGIIYFxeIkRgI98QumyAXpmIhmgTcjF6sjVL4cXWEQwaltX9zqD+5WzVP?=
 =?us-ascii?Q?4FBaCuyan9Db7FnEBPIpSXl9yktZY++98eaBv8kYJQhLEId4cu/EWL65HdKh?=
 =?us-ascii?Q?qjkmA+brkFn01hcQeQI65PpLJYWdyDyvlUsdP8E21r+tjJMsGn7aKyPBbtrG?=
 =?us-ascii?Q?EuFLL3VLHnPqsQ8LlYNuCBmNggvNJVQjP9wvIDKxaPXaFSRJX/AWEq6gZrM4?=
 =?us-ascii?Q?CYHxl1P4CrEDQYb4+5HVSkiwjIXdWppow8BjknZsKACQDIkiANp8MLX+SERO?=
 =?us-ascii?Q?UuIS5eOt9yvNsPMt4d9+Zej17/uz39YkfINVaygze+y2b73r4YpfDcWvZF7Q?=
 =?us-ascii?Q?EjIXXSBhueUyrWKN3wkm4Uo+q0D6fpMEwsYRWJcLd6kg1/uKzQ7NHwN+6d+a?=
 =?us-ascii?Q?x/qWGN86qN80x+eTyBseJtH0R0dPJeK/DIEFVCj3pWwr1meVrOjte+qiRTV1?=
 =?us-ascii?Q?L8X7vxiXYG/oaQgYwQjfA1dLhLA2a6v+cdPX/rvJ1VPmErSPGc8Ks2M5xO5+?=
 =?us-ascii?Q?lUa9eglbe5RyloftwRtBjV2nUlCx9PstvGJFQoshCXpZGyAO9zsWMM3qLrPz?=
 =?us-ascii?Q?hYZHIQLC7rnp2eBscKuE4MEU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd128264-08c3-4764-9ad8-08d90bd4ef22
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:02.5009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CpG343kGEOXwvc3EwsTPfaUY3Lp3ofJ5AXu/rwCMtZLtMcpB8udbhZA6+v4j+q202dtgXLHqSQX7+lGaF9imA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
while adding new hardware security protection.

Define the commands and structures used to communicate with the AMD-SP
when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
is available at developer.amd.com/sev.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  16 ++-
 include/linux/psp-sev.h      | 222 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  44 +++++++
 3 files changed, 281 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ee703176049..09d117b99bf5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -129,7 +129,21 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
-	case SEV_CMD_SEND_CANCEL:			return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_SEND_CANCEL:		return sizeof(struct sev_data_send_cancel);
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
+	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_data_snp_config);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d48a7192e881..c3755099ab55 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -85,6 +85,34 @@ enum sev_cmd {
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
 
@@ -510,6 +538,200 @@ struct sev_data_attestation_report {
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
+ * @vmpl3_perms: VMPL permission mask for VMPL3
+ * @vmpl2_perms: VMPL permission mask for VMPL2
+ * @vmpl1_perms: VMPL permission mask for VMPL1
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
+	u32 vmpl3_perms:8;			/* In */
+	u32 vmpl2_perms:8;			/* In */
+	u32 vmpl1_perms:8;			/* In */
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
index 91b4c63d5cbf..f6d02d4dd014 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -28,6 +28,8 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SNP_PLATFORM_STATUS,
+	SNP_CONFIG,
 
 	SEV_MAX,
 };
@@ -61,6 +63,13 @@ typedef enum {
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
 
@@ -147,6 +156,41 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_platform_status - Platform status
+ *
+ * @major: API major version
+ * @minor: API minor version
+ * @state: current platform state
+ * @build: firmware build id for the API version
+ * @guest_count: the number of guest currently managed by the firmware
+ * @tcb_version: current TCB version
+ */
+struct sev_user_snp_status {
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
+/**
+ * struct sev_data_snp_config - system wide configuration value for SNP.
+ *
+ * @reported_tcb: The TCB version to report in the guest attestation report.
+ * @mask_chip_id: Indicates that the CHID_ID field in the attestation report
+ *  will always be zero.
+ */
+struct sev_data_snp_config {
+	__u64 reported_tcb;	/* In */
+	__u32 mask_chip_id;	/* In */
+	__u8 rsvd[52];
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.17.1

