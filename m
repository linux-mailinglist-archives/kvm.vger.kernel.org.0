Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2693F30C3
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhHTQEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:06 -0400
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:41272
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230156AbhHTQCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+HwDnuLFWSORVGIMwuDcS2nXf8k5tFoCGpDY/oWy1bQRF60uKq+M5qZSxpWu9xKUuA447EzgVZPY9hBoMBxi9Jp50Zbq1yoRTWGGy86vyTQ626K79v95BHzpubt4Kpb5KUz5g3H+zmgFO9gvRB435zqSTC2SjUHaMQXNcjhzpkKHl+VELxGkJkCj2VqSEv2Puh1fZR5L9c3MbSxREKUongKTUgOQEXT6wH4T/lVu359onoGMSgctf0uSW5f6dfnFWw011f9u75Zih6entqE51ip6zlAdVZUR0hWdvfzDFR+0g84q+G6ep+iafu/9r26rRboPzqYv2e4oEGJxEfxtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTbkg7spk/38cp+YsnSOOdsDNuDgieMFCl3/tLiiFiA=;
 b=j3YOIuOo5SZnqTv9nk2Ion2eyQdkw0qW/eMysYeKXrNWZjTe+hT7jyj+JP1E+pB/Nj5+eX/weDnX/MiwPxRUiOErPhLks2X2yzrj/w6R0OPx2tIXmF9vbqHYYwseqwysSG+AA26hEtYIBqoTzUwx4Ix/wX+/BfqnGGyWJwIKJjbW+jSGHXw1IOG3qkI+LhEzN5dkkW9my7Fjebmxb8GTuhprT2AYFRNWOuid4QXFLEhT3eBrqe7+mRFRmSAkr/i/ByhkFy/yYxFzAaXOgnts8EI6AE6kMNOrYATMQyd+h2xlpSiGpfjWwaCmzgbs1m25J37FIKi8uUGGFvO0c0sjAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTbkg7spk/38cp+YsnSOOdsDNuDgieMFCl3/tLiiFiA=;
 b=h2YAJHy/zjPxnpZYeIWpR+oa34Z5DkkpHELqv70J98/3VWvSsuA8wYs1I13p+0c0uAUL3eLNyEfgjQohF4PdYumS3pbFVPHOpl2eZm96ZJQuf6XpYTGtCRMgpO6LqgNDGHEGK/CU/LhgB/7T0EXnemjh3ob/ChNi53KrxZTEG7w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:08 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 11/45] crypto:ccp: Define the SEV-SNP commands
Date:   Fri, 20 Aug 2021 10:58:44 -0500
Message-Id: <20210820155918.7518-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 482d3a8a-2ea6-47fb-b75c-08d963f394fd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384F7FA9742C0651F23E0EFE5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nevrfL91G7ZQ3v/UEZRP0gSfTlysyvbli4yF9vHpPzfjNKpfSv+V5onY0dUW0HRDmCi4pti2O3Fw72ABJWYMOMJJPQbWmico1nEesFVff/IOgV1MFf4zi/yGNfJfd8FWmHF7Cb+db9aIUb/H9R4ImmBOySXI34yOaovLbY9XhkatJTDhXN3jeKa7NqVwD+rrwMD3kwqzMnd1EvsFaAX1Ou+zGFQWfqaBuDoS7qzfK+5p3GsZmeqmf/iw4UvdzKQampyj0kSTgmm4c5S7aw/kQUqbk+C3aYubSrtDp87j/arI8l9zxF1nOWwCGeEY3MT1tIfuA5hvNq7hGUSppGOyx6WTi6SY/TU/md0DMiD5wjfqO/vKJqI3cwm8tTbskjNLjwH6EekWQrA80DjpaysRASxcg+quDzTwYdBdVGrlh6VmgZDdVp1wGUe3GIo+4XcFbTLzdoy7+6ie1xp/8vvkVLjLCq6uIW8bozgesKys2BT9gwlur27vI19ZPiImSDgofNA7H9fOWlP1HvLKelYpNrK6HmQGV2EwfErki3zi1577pGgF4F5TFX46kb2G1q0h5NDyEOnPTyhnRTHKDt6tvquZgDUS2+0RalNkUIVK4Vz0zfk6fNyVbHLjhtDuLcciZ18bqOZMUIObiSjfv8KcAF0yuFz96ygVgb7Qbkhmv0rINfW1emd8HFrMP/GyeQ3KMIkjZ6y5GqUf+YqpkWUausvJ0gJtoi/i53yoFWPEhnI3M4A9p0t3Zg/67RGkkyIRrqMK7ArUPvSXecATERx0FL28M5uLOAB0hqcuXU3SCNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(30864003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mY0ZNc3bGs2RLAf9j0rzLqbmYQ6h8eaAKR08ukRH/iYwdlbX4pqDv2/2QtY?=
 =?us-ascii?Q?OujT4ZVjvOMo2v6c1VhgEqvDzQ8kIfuqTVzrW2+poV/zqRngHL6VcL1s0k4R?=
 =?us-ascii?Q?e/VBWiAWBBKN0jsubTpPQVSAF+RDcbUVmGyNlXeO5LEIq2BETdL3yMwe3rPo?=
 =?us-ascii?Q?wB+yoL4Wy2L3d3m84ruWazzwDRqgEWmXOagiB8C9LcE1xEi8CutfVt/U/kSY?=
 =?us-ascii?Q?I4XGacc+LMHMtfcMe0Qj/GDbpFB76jhSR8iKTEhK5IiEiWMBHCKKuQI1YB6u?=
 =?us-ascii?Q?K0mdl+dozXyT/lA6ERjytluKTfvloLBThbFkQAU+ObU4MmZNgs6LAA76AEIZ?=
 =?us-ascii?Q?jnqIscK8P2y1SBCcUqCWzyAFbOmVYxMjh1wL7o7GlrtfIaad0zWELgi0243d?=
 =?us-ascii?Q?H97VFZqCJGRQVFY9fFW/ozsxgIBKh69yoiCDz1NNRKD/rcOE8ZkUAFACtnbj?=
 =?us-ascii?Q?J0Bvf0jnV//4cmoo9zxCIgO3RxphKsTqvUo8GTFKx0Qgs0GOZVoMfaxMzJZG?=
 =?us-ascii?Q?JZW2eiSAsTzmsKzz80Z1y9jZCN8Rmcuxy+nTlqYF7f/y/PJ+Jah0LrkN+XBm?=
 =?us-ascii?Q?8/465gXKuJ7FiFRPCAhhK4gpY1F1p+mZvGl8/NhpGtZxcxhSSznssUaDEVCw?=
 =?us-ascii?Q?/lsYUzuZvX6eaI6NTa2kL/VJ45SZi8i+z3RM2ISyMej8AIO/IW96pos0jA18?=
 =?us-ascii?Q?TfSfXUEr8nY4q2MN3rvc7Cp+P4JWU+ybsEWZGhxIBjKp8rsklKVf5wbHWEpm?=
 =?us-ascii?Q?S+A/h+o+Isi3x174rgYv4D7oBLyd+6ktKQFLnxYwVgsP2MniKBuVPsE31g4N?=
 =?us-ascii?Q?TROxj5D6PpZ/L5qzrOSdDhSHZZCB8SM1JOwLdkSc3Mesxr5X1UDaGAk900MG?=
 =?us-ascii?Q?9YLR+LJ6UZgrZyJQ+ed1I0622dxbFuxD5SukSrHpL+lUlk7p9SPz3SBXz0tY?=
 =?us-ascii?Q?g1zBoaE7Cr+pfDvTUntZLJkn3v2/LpqNisiQ8wQ4LRdlKw0k3YsFWpub6nEB?=
 =?us-ascii?Q?cYMUiFjcT+AGVkhUOXA4ENyoq9f0MMebzLXnSylT+n5f9WqU0RfWG+nM/KwZ?=
 =?us-ascii?Q?RDSu+FFD28m+7cGw5kyn9Zztod9OB42ZPiZWMCVEJHTsgmrNi5wIB1WnTWbO?=
 =?us-ascii?Q?H7LMbGWQfiUDxrNVTAwkOKBfkr+L6WrKNVgYXGYw4wqiNPHf44oqJx7HfXTt?=
 =?us-ascii?Q?fXHRRm8qIg4Fbz8K9HRYetR5J0goWL/9eAqeZ1u+l4QoicMijRdU+rQN9rs0?=
 =?us-ascii?Q?xvyWkIhPt1O66PALPAegLAHyGFlTPT68hrgUKc5W5STamWkMPL2trb3gIkci?=
 =?us-ascii?Q?xzoG/1F+wW+XHHyP9Io/viOY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482d3a8a-2ea6-47fb-b75c-08d963f394fd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:07.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gbyst2Zn1fI3H2Z0o4eEV5rdJkvtpYXelwL/XZQ6hLWu+kP7u5wjLA82w1zp7zcYfZ5TVRop4WmUZdUCn91bow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
 include/uapi/linux/psp-sev.h |  42 +++++++
 3 files changed, 279 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8..f5dbadba82ff 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -134,7 +134,21 @@ static int sev_cmd_buffer_len(int cmd)
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
+	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
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
2.17.1

