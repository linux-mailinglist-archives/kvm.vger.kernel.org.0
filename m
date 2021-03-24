Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0131347E9C
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhCXRFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:38 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237018AbhCXRFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yjfc5B+FstPrCTIEUid3VxrjqA9DtvcdUR6HvE5h6FUar609LFpTvHw88/48JKFtT50d+wmgJw+s1f5odEdW93gyza92pYxpXG+F7SQSDvueoJAEF2VCUvUS/B08q18E77A06GQR1F6Ap7ojBjaPF/5akt2bbS0+DZ0j/Mbo3c3x9wSHsdzWsSteVSdYBVOgQwrknNqzZ0ReJ7luI27oXgMDUPzEXzO/20PpK7I7O+pc2YD8Dweqackt2BYHVo05liydFXGzBB8SCl8TseKOH4+A8Dnzn8kq7zxlZ/VDpwVzYZiRAJybfNC1tKf/DC2LX/0gj1HOs85J9NKRy+5l4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zIFPFsBZoJQAkDbY+RAwOdM9hZj5RW1qMw2NnWtgbY=;
 b=I45IuZQYg54mlHZ5LLA9ltTmiAtRXyciCfb2dNxrNnCSwNKPyyVR4MQou4btWfLc5XanAYR52aDzsQzNxpcZJqWpJeWV1TyZNWU3Nv+p/xjOkGDjZst1SjOFbsqXXxF8KD1opguEdERtrX+2oJpkYDfE2zJod49OrxiW+Fm+CWPc1x8YkAEXAwu08MGx3HwXfqh6ktPJdJ6WVTTGI2X8Q7vzBNxFc9KqCA1Iinx4S+lnK/WVG5ulp+yFQtC1anYOrkh18Z0pT2U7eH0Z0RcJqZgnIkImw09FdwBXPTOpkWzMMvB49smeH6uQl52nGjD2eE53A4NAGsjHRLG2xy6XeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zIFPFsBZoJQAkDbY+RAwOdM9hZj5RW1qMw2NnWtgbY=;
 b=vlg3F4kMQeF1XnYWUlmUQ09fi1A6qzApBF8BQHRgj2q/DN1+MmEWme2FKOvBF7hMhHSn5wV5r72QBHbPta94z/l+DFQ+M8Du8Ayt6xYpXzhbXt2GSynQ2x5RtRvXJuAB4XqCnsT3eYhJHvkjZzXH4Z/dxCFQS23TvfBgHy0w/pQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:57 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 08/30] crypto:ccp: define the SEV-SNP commands
Date:   Wed, 24 Mar 2021 12:04:14 -0500
Message-Id: <20210324170436.31843-9-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 68a7efcf-27aa-4da0-f923-08d8eee6f3b0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557B6D4BE536DDCA094C081E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpjEPeazsynTcYQ+1amrFU+5ND4g80XwwYTvUrkJEOLGi64ZCFijACh8gNxiUD8bRrJxlcKF3EGtQeopEqP0Z7jxOqAIxCbK1lAA7Pz91/teQpfM6KaKJYI1NG2M+sQ+kZoR7ZD+acx2XxY3kvlDZB0vnaMKgmuO1NIkAWHxf96njuAi/n0Q8tjuSRHUw/TzhE7qFjHVvVyiPN9LikBRQMO9HWXoH1jMEnK99p2ACniQwelR9qn0nLxIOCKfUZqMBTz26DEyc7MboGPSbe8Z2+F5gU/gtTtID6O46piSsAubqyvqq1EKR5vY6ByZHAdlbJdcRsHW6Uk+oeXsv/eaWcouK16VljP+eX9SqIvd12DzXeX5qTaltNxhazZn0iwDMYg5NzezHafJc/5yabavSZcwpwWKXSQIV57cRA02/GWgrwoSbJHhoyFMzukWiT4vrIQNn4bXHpH2GUy0gIO4a8qBQM55SYBxBJdqK7ogc3aWDfpTF5kxfSh7yubEWbZh1aiWTtT2K2hPhee8g6VtFJ56k7EcN3/luB3zc1HH3wuP0Hw/yI9ThzS2ZP8GkprwcngpByLN7SMqkhwp/59DzvB22qgcmQTp6yCHOooe9afsq8LX52oXb/spEP1ytXa5uGKFFo5twSY3SMiNM5lCN3WJhoauqFvb0hsfPfF0KrA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(30864003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Imrh3UpJGYMqDpKqaf4ur/Hb93OYMN2eIDHMsxHI6zplsKF1hkQt+QSA4b02?=
 =?us-ascii?Q?eoUV/7NHMRcAznI7h8xmOSZH5znH7flc1MIHtAZZrWySrrRVo3P4a+S1Z0GH?=
 =?us-ascii?Q?Y92yrDOTATi+v7eva21Ds1TmKHDOYgwgJC5lgC1zNIh93d0fKnP1905zuqla?=
 =?us-ascii?Q?XPToQtMinWkOwquV0VuqSy94nJvFlZpSZj6pH08cqH/QEs1xCCi2SJAaXCzf?=
 =?us-ascii?Q?vdYfuBlG3L6jpkgYtbh73QRFQr+dbmiTLSs3DaHRo39tmwc8SxcLb6VKdBFv?=
 =?us-ascii?Q?sNeCEcTOoBrHUpJOtOJjGrqr1d0zumojSSS2aBNOo3VZlrOKyOzKEPE/EmUy?=
 =?us-ascii?Q?QCd5HcdVhZNkyyj9lqULq3S32qraFXdmpNhYqI1YcC2nUg+HSEF7+mv6OUxP?=
 =?us-ascii?Q?545M1EUIkTwlAtl7x6mdmmmuT/9kNPIEOQGSPeJPWerOJpmO0Is+21i9uxxn?=
 =?us-ascii?Q?NYvfdinArxAX8DnZMAwdMMOjXM6FL6B71c6FwGItH3dcXxxh+Ldglmb6x4QP?=
 =?us-ascii?Q?vt9trjV8V82LVoBhafWOZjFhY+zkUXsKqZjviRgmW3UUOWqxujg3AApegD79?=
 =?us-ascii?Q?hBdXDZU6kmbAOTrwUi7o6Aq3zupXbmBnaU13kbabB0j417CRCw8Vd4FnsLpS?=
 =?us-ascii?Q?mVCYNMipQ4iStrj5R9jPlpU90Tr7Bh89sIQsWHp87BU89MC4/SUd49BfvxGs?=
 =?us-ascii?Q?7BRIrlKTw94aDinmgyg3qBZSi4D/JO6uDybdVHJjSy8oPyvvUS7NZoxjDPNq?=
 =?us-ascii?Q?wk5TfGyWnPRGxx2SfUYNiZzJtXZND8XKGdPBx80/3jVIEP5wQitADi5bkw1B?=
 =?us-ascii?Q?mAS8qZ1NVL71hGPFUcdAabJU6epHLl7ilqG+zuOf93lUwPDYZ+KAgEbFkwSz?=
 =?us-ascii?Q?vvFcO9T08i1siKF6ri9rb9omJSsCbrHAGoCyi0ZdfBsva4ov5cSo2nRhHcvU?=
 =?us-ascii?Q?mOl+frNY8PY2U8Kyvbr1UC1s1rxaLF0N0R8Q3Wgqv2zZ8S06al2HcHMJ9Kbz?=
 =?us-ascii?Q?vsIrZAmyQTtdxcqJj2i9myCfOQxOL9Y3R3VijXunxF1ka8RV5AIwXRKmXCaS?=
 =?us-ascii?Q?1VNPm6TV2txZFdfBKfMR5OGQGlt51YJyb8hp9k+t10ZfJiP1bA5iambZfSWL?=
 =?us-ascii?Q?76ypo30+JjiFDr170mZ9H3KTXGw2TNey1IQNjFNhi/n1OaSjvU4d/ep0kNh5?=
 =?us-ascii?Q?0XIRUKtxSClo7eaKDoPKkJqJIbTqCoV6V3Z/8L2dHWqqQBrPZvKkc15GaeGe?=
 =?us-ascii?Q?Ko9E5zMnK+idwaG0k1GCRNhKDvJBwGNVUPkL4McTC0iLhkZ87BPOY9z/sPUM?=
 =?us-ascii?Q?KpflD6OddaQ1IK/ujfXZwKdO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a7efcf-27aa-4da0-f923-08d8eee6f3b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:57.2534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9iP4Gjx02ztRFm+kp/9I2WjhhWfBE69b/dCA+1IFZ5NWm2sZcFV6H7VJnTHDWnwL/j/cw6gbnlUGiHZq43WHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
while adding new hardware security protection.

Define the commands and structures used to communicate with the AMD-SP
when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
is available at developer.amd.com/sev.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  11 ++
 include/linux/psp-sev.h      | 210 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  27 +++++
 3 files changed, 248 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 476113e12489..8a9fd843ad9e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -128,6 +128,17 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
+	case SEV_CMD_SNP_GCTX_CREATE:		return sizeof(struct sev_data_snp_gctx_create);
+	case SEV_CMD_SNP_LAUNCH_START:		return sizeof(struct sev_data_snp_launch_start);
+	case SEV_CMD_SNP_LAUNCH_UPDATE:		return sizeof(struct sev_data_snp_launch_update);
+	case SEV_CMD_SNP_ACTIVATE:		return sizeof(struct sev_data_snp_activate);
+	case SEV_CMD_SNP_DECOMMISSION:		return sizeof(struct sev_data_snp_decommission);
+	case SEV_CMD_SNP_PAGE_RECLAIM:		return sizeof(struct sev_data_snp_page_reclaim);
+	case SEV_CMD_SNP_GUEST_STATUS:		return sizeof(struct sev_data_snp_guest_status);
+	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
+	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
+	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_platform_status_buf);
+	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 49d155cd2dfe..df89f0207099 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -83,6 +83,34 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* SNP specific commands */
+	SEV_CMD_SNP_INIT		= 0x81,
+	SEV_CMD_SNP_SHUTDOWN		= 0x82,
+	SEV_CMD_SNP_PLATFORM_STATUS	= 0x83,
+	SEV_CMD_SNP_DF_FLUSH		= 0x84,
+	SEV_CMD_SNP_DOWNLOAD_FIRMWARE	= 0x85,
+	SEV_CMD_SNP_GET_ID		= 0x86,
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
+	SEV_CMD_SNP_DBG_ENCRYT		= 0xB1,
+	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0xC0,
+	SEV_CMD_SNP_PAGE_SWAP_IN	= 0xC1,
+	SEV_CMD_SNP_PAGE_MOVE		= 0xC2,
+	SEV_CMD_SNP_PAGE_MD_INIT	= 0xC3,
+	SEV_CMD_SNP_PAGE_MD_RECLAIM	= 0xC4,
+	SEV_CMD_SNP_PAGE_RO_RECLAIM	= 0xC5,
+	SEV_CMD_SNP_PAGE_RO_RESTORE	= 0xC6,
+	SEV_CMD_SNP_PAGE_RECLAIM	= 0xC7,
+	SEV_CMD_SNP_PAGE_UNSMASH	= 0xC8,
+
 	SEV_CMD_MAX,
 };
 
@@ -483,6 +511,188 @@ struct sev_data_dbg {
 	u32 len;				/* In */
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
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf..9bc63b026091 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -61,6 +61,11 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
+	SEV_RET_INVALID_PAGE_SIZE,
+	SEV_RET_INVALID_PAGE_STATE,
+	SEV_RET_INVALID_MDATA_ENTRY,
+	SEV_RET_INVALID_PAGE_OWNER,
+	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
 	SEV_RET_MAX,
 } sev_ret_code;
 
@@ -147,6 +152,28 @@ struct sev_user_data_get_id2 {
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
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.17.1

