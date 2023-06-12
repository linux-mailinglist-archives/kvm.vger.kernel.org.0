Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1A472B700
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbjFLE6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbjFLE6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:58:13 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7832D6B;
        Sun, 11 Jun 2023 21:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7QwnoHsLQAel88XQqN7XTNHE5m4nCWOLANeKr5Qi+aGYKRz5NJNLVdA2YrW2YnWlyb9Vg3glh5KCiCvpJBoRYL/2z5IknPPhSnhiJE+ClY7h+VR3zIXKpOd/VvX+CZTAdciMwTMDFFaxEKn6URJ8q/HBky1KptBKrxevUrP1cbIN8Y9GpsciH403CfvgacW9xCkt6nHpqmXmlefmv74blUCRDJr7X0spG4c9vVaTpl9z6a0cXYL9/npk+ovLE73w+9rplzXwNbx2cMfT7HNmXD3F34IG757DsjqBa3R+R0ztOKiZ9IhXmHVuwXOCZNuZKA4xsM7r0A7AjLHN/4tCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjrtDRnX4hUbBvCvwo1i1y/QPZ+dHBYmNvNtfJMhRak=;
 b=EkDCqPgU43oi3TPjnEN5S+ijm64HMCu/0+rYqzBFReN+N5+Nc31Ff7jy57+Gx2CHolXAfo/yTAq//S35Tn0/5kHDhBItxYZ8OVO44tmSI8Vdjj0sOqcmMQy4KUIxvwPCckTD4uqKFfWTOg7Qo5qLLRzjpL10iCupQfPotJYXrR8TCFBuN/8guNOUrlRq8PJqT90Ly+Em4doy38VOEWk3binJfDKeIceeLLfzv9wZGx4mOGbIr38AW1LLEgixZ3MF80KrHDdzvqOfCBEB7FAbXqe0HY3Na1TALXBBbptiotmjXHw+1z1Q9M5VxSKNILLNMm0HEdITngpQkipgxJAw/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjrtDRnX4hUbBvCvwo1i1y/QPZ+dHBYmNvNtfJMhRak=;
 b=md+6pjLMK2ykrkM0a/b+89M7rIa2mvsvbVjUWPp4T4lkWySrLx3VYg636nFoMpZFdH2H9xE2PLvnMI2d2rz3SpEpZiwboB9yyPzxF6kXHNg9PYhBzICl1PgQFh9HTx6hpnZtMwWc1hJbhkonz+tl6hH+1V4NMOpMGl6DwJvkxX8=
Received: from CYXPR03CA0077.namprd03.prod.outlook.com (2603:10b6:930:d3::19)
 by CH0PR12MB5249.namprd12.prod.outlook.com (2603:10b6:610:d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Mon, 12 Jun
 2023 04:57:10 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:d3:cafe::d5) by CYXPR03CA0077.outlook.office365.com
 (2603:10b6:930:d3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:57:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:57:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:57:07 -0500
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
Subject: [PATCH RFC v9 51/51] crypto: ccp: Add debug support for decrypting pages
Date:   Sun, 11 Jun 2023 23:25:59 -0500
Message-ID: <20230612042559.375660-52-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|CH0PR12MB5249:EE_
X-MS-Office365-Filtering-Correlation-Id: 499dbd1a-db19-494a-8345-08db6b017a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71t+1axCyvSl/V6S59kONElavhM4jLvegT9GfJXF519MRl0ZhzWRf0RmHqL0U8U4jv/iq52DGbgm13fWzwMeLlhu3mB7SikkcGkuUhUm6l0pDcMcY0eR7hoys9oP3+hHbNtFRJKT63oDbzmDcqq32Qq2UaYQmxx1D4TWtChYzkmqK5A9bSWxQ1r/t7eePnSryFBcNiPxKX3bgP9pb0A0T7+3Gmnveqau5X+QRvhVyESyhzeIRK9kS87j8fyFGgxRKGOj0t+gEpDQ/sZQPxiRiM0xsx0KPSADx+fu+44Yir5r/W6Kot34PCo4TPG733wY3DIFF5P7YlvKiPiu5WyCRumeGXaU5mUHCSqZszyhdVb8RTICGh8le46ezuUebuTom1Xpo9tpDEsTMh9VmM3Rs23jdtXT/NT3QedmaviPX9MMGyl0l6TiDoUIAvAZYw8yYp1cpyD6HC7E5mV8Rul9SjcQneujZ7VwD5MHu7fCvI+0pRD40060pbBvgpOOFTD6ZNPLQKPdHBwpedaED+5+JAzSy8AKLFOLuxL9X1IWDlDWY3c2XR7ChDnMSCZXgOpJ0HkWooKevUmPFiefWi+CZSFTpS9QeyJLwrmrbp76nLwr6XShajkaNUiVpv+RLHD5ixEPFGbJZ9jlCJJSfXGfu6jggqWwAvftDe2pxUO+vzTjzsXPuaP2nNlVgXmeuoNtpHLEcd7C2VlpnvGeCzA0ZaUkGEvJbLsysPwUzbtcOVqh+wULmBvm2PIcJRLvSmicr4UTVjP0yQNS1ijQRcBGDnYo1UPZwr92wlHvbZRk0bI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(2616005)(36756003)(2906002)(7406005)(82310400005)(86362001)(44832011)(7416002)(40480700001)(6666004)(47076005)(16526019)(36860700001)(186003)(83380400001)(40460700003)(5660300002)(336012)(26005)(426003)(1076003)(82740400003)(356005)(81166007)(478600001)(54906003)(70586007)(4326008)(70206006)(6916009)(41300700001)(316002)(8676002)(8936002)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:57:09.6400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 499dbd1a-db19-494a-8345-08db6b017a88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5249
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

Add support to decrypt guest encrypted memory. These API interfaces can
be used for example to dump VMCBs on SNP guest exit.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: minor commit fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 19 +++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096ba15d0740..3c8cd2d20016 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2061,6 +2061,38 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	struct sev_data_snp_dbg data = {0};
+	struct sev_device *sev;
+	int ret;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
+	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
+	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
+	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
+
+	/* The destination page must be in the firmware state. */
+	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
+		return -EIO;
+
+	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
+
+	/* Restore the page state */
+	if (snp_reclaim_pages(data.dst_addr, 1, false))
+		ret = -EIO;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
+
 static void sev_snp_certs_release(struct kref *kref)
 {
 	struct sev_snp_certs *certs = container_of(kref, struct sev_snp_certs, kref);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1235eb3110cb..55f6dfc2580d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -916,6 +916,20 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  */
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
+/**
+ * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
@@ -946,6 +960,11 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	return -ENODEV;
+}
+
 static inline void *snp_alloc_firmware_page(gfp_t mask)
 {
 	return NULL;
-- 
2.25.1

