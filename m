Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0ED398C41
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhFBOQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:16:32 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230208AbhFBOOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXf1qq8cRQFPniCwQwb3KkyoleLTqBeEL1UEj22pb/KoBJVMTcIarQ2jf13uoSqUspPRIs8LyijQ46Eur3rxx8IRlEZGe8iqX9NedCxNheUtbNfdMAIg0Ocp8TDhZoam3paXZyhja9iOMsPa8fqx4A7hOPceAOQtNCTr1mU7I4A4d9u948eEeughX7587XNi8uygNqRN0Z+7gwZTDLiC00ysJkzAP3OfyYw+icNq1MVjvi8EV9owURL703MxztLWTgqG3ulMxfXRVzsNM/1NVOxZf9OqTOL3tqtI6m1Rb7632Uh/RtbLuXtK5XQhOulaTsYTxR51esvniTql/8qvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2Z7JSlGWPerJZfQq8QU8d7hr+48kKTAD1KSOj4Bnmo=;
 b=jvl5TSGmxFcqjHtB0n7lotOZkt4mF35MWxzlKnznxlpExe9zPiNTDyv/zBsmhv5AiBhP+8qY7ducpvVchZCug/8YyM23RaTwuKvkygwwL01TqEdnMPAJzwJKhDnN0sYbyRoSeWkm0dAnV3wVan49FKrOfAI9H8MhtYSK1PYicj2L+tC7u1sMyd3RCGBLQSbVBYDJhekM0+ykLzFr+X89e10+TEw2fRZvesUBXZy39xtfAlqzbpmccEDzG6bF7O9KqCJ/d1S9Q5WzcBlxTAeecQp77TswIcV3lQZMFBbu/3oj7vTscQDZcCNFWvjRBhtB6vLOxg/ScWOBP9zAWCCAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2Z7JSlGWPerJZfQq8QU8d7hr+48kKTAD1KSOj4Bnmo=;
 b=Gmysjav6szr5xnBlkSfYKZIWOCw0Px16oi7rX5qY1y8z71bRhc959loo6pVLEDTHHBTZHRY391ob5n/HG9rfSUdPfpuNSleuWWt9ja+J1a7wCKVwEHNZmV4bOQQuA3HgT7oMMJNQg7XDzZr4gAwvJsGgWGjqTL+pENJDvUtvkG8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:42 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 11/37] crypto:ccp: Define the SEV-SNP commands
Date:   Wed,  2 Jun 2021 09:10:31 -0500
Message-Id: <20210602141057.27107-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46a7b252-9342-48bd-2619-08d925d0589b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368970659AF0A716E9AC123E53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GB+UiVaTdeLxSzzr1ZXayEJwuViagFtAxnDk2T/Q4PIZzXJk9Fx598bZvgMCE54OzRkAaGB3DhcgU17gEazldkQitWnFWKAPeCm0SfUxIgrROWO2VCC5B8pUcOIR+AXw2Weq0BZQuWMBX2SyATv675HVyE/XXtv7xMTkSUAxg0Dp8H91y7ZGOxMBF9YnFIkifaNMMDK/P/Qcn+bfcwK7R2idAEQ1A/dv9HzUkNM4LrnbPannmheVgAKQCAdTHkug64/MbMIyuDidZOQoUntcWjwAWcKTbb4+z9g11o7NljWLhk24H8jy6Wb+u9H3dSHXJvshwIPQ5VExNOLFUPI+Ctlavb9pz/2YSOymDvKmz9BoymjAvX6LhA7wbzrZfslYIq4sflTna5C/xXWjZxRGDdO/EJF8giXFxkgwb8lc1UFnSrKVeX5RKvD8A9FZQ8EVO7ijTQfuDH+M/OYdukRJoDGU+Z1iLkrxpBjh6QAKaJzORANv78vx6ALmMjMD93BEEe1fE4Cgk0JPok0m4HNMUE9DiXhK+3npX7Fse6SQwTvF9dXxAXIpOTf3XA1hBYNyz/B5A5DScp0LuSXD47xqb4qdMDPq/pvtb3HptNY0nUKN14ycp85FuPEIprr6cG889xuPaBikvAqM2wAmdsjO5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(30864003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9GP75woSh5w9vJdmeTg/7rHFX1LE/dK97yO3o5nu48oMmy5I7DVPKaOKL4zm?=
 =?us-ascii?Q?/Z/hBnL0fu7CUjAYc44p002J6EgMQxISo0JPM3lyCF0/HWWz37GGOslQu4Z2?=
 =?us-ascii?Q?sEhL95yggH92EfuBY1EkimTtOuFVliTMW3x46YpdJQLrvXO5FTi/BW+GB68i?=
 =?us-ascii?Q?ucirrxuF3QS8Bcz0rCDn5UEbcVsHfhVCIbfM3Zi1QUdqr8QHE8+h1+dWgoci?=
 =?us-ascii?Q?YilRgGZ7i9yzmtr666pZig+kmar+qgSTwmJ/jZM0iM0zDGlPXsOUr3CV5XOi?=
 =?us-ascii?Q?sRPSmRnwkNXVbU7CoTbE6zoIq42i55ZItufMF+R8g1ah7hR9UWeRbmLxyh3S?=
 =?us-ascii?Q?CaCn0KhG3wOGboK2arG1XLr/ESzh4BV4rYqgOBOArmGHM2xw/Pvi2WbYo34O?=
 =?us-ascii?Q?zx7FOJSNqpg2JuCyXBeysXg22HYFKQBxWw8q3vjJGFCNyVAvB8VcSTdSCQMR?=
 =?us-ascii?Q?8hFcMaJ3SBvI2HWmtMUwuz7zM69jUZzA1MuaQO5Z8k6ZZscVvKgRtXvGB2vi?=
 =?us-ascii?Q?yVPIHgijVyqTC9whd/p/5o5t4JfM7JkCZH0lJ8VPSI4I93ARNvfeHoq8gR4V?=
 =?us-ascii?Q?qEpv2DRB2UNIDguWa3YsmyuYUBu7rgxGoh9i2yQyCU+XQ2K0nEoFyAZQ+roE?=
 =?us-ascii?Q?WEL7GKJiLjLAiy54PbKXe/xyWyASfbc9ymIS9cZ3QCN/5C0RRVETPIPztaIc?=
 =?us-ascii?Q?oOm5rlOq131bO7TYFChIZW7k2gzS99ZFk5mPVLYXMN/oChGnSM5ek53C2HVP?=
 =?us-ascii?Q?NIGaB9KsOyKL02Ka5d8K2GUEM3qndbV4txTf6wFPWKQipii57Dkw7ePI8BSh?=
 =?us-ascii?Q?Xghwdbw96waydqso6yMCYTAfk1lbkCqhOj+ySHLSoqHumhNblzChUZnx4b0b?=
 =?us-ascii?Q?E9xAP2pQLf2cZ9cIKyaQoBuQ0k1z7AYNu3EpfKRtqR4Dt+WxYzwAafirc/aS?=
 =?us-ascii?Q?vLTLkOUmcNRUgIFndTwgA2vIGhh780tgGA3JxXemAyT3opVxWKvINy0VNd6u?=
 =?us-ascii?Q?DReMDj7NFp6Swhek4NUnzyKdHL/ok8dQQoGOargMdUFRFEFuf1j2xXQ0F8my?=
 =?us-ascii?Q?2r56A/FwESMelhpFnVrsRpBjcLtli3z1iO/sU3OWAq5tAPC0OsHIRcIbUeOV?=
 =?us-ascii?Q?TNYu+Cayx7TTsvD6t4+5LlzClNVcoWxbBfYgp/RRol0pS2uY54VOQutz2VtF?=
 =?us-ascii?Q?sgw7KVV3axeIQqrzC/nsIcNxPLFAvZ8Z321rWYKG2OtWH2sdVE80JDye73s1?=
 =?us-ascii?Q?L66tVmDEZsYx26J6jzUqWaYc6M/ZZ45A6Km5bZZSjc+ujsGtwksVeLO5AkgH?=
 =?us-ascii?Q?sMRq6p56vBSv9bXsz8/31y8i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a7b252-9342-48bd-2619-08d925d0589b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:42.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYwWJsiW1lfJfO0HyNYUhEenfLnXzYtOlKDZXb7NTjl5k9m69XKWpJsBbpUFsGOZAFpw+wUJjGDxxl2ikE2I9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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
index 3506b2050fb8..0331d4cea7da 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -130,7 +130,21 @@ static int sev_cmd_buffer_len(int cmd)
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
index 91b4c63d5cbf..b7207629eb90 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -28,6 +28,8 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SNP_PLATFORM_STATUS = 255,
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

