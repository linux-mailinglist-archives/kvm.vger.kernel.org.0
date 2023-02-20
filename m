Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD53569D3AC
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjBTTCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbjBTTCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:02:12 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451C41E29E;
        Mon, 20 Feb 2023 11:01:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFixzlaHQRPn/4tJOZdLKyRN3pn9JFfZc5aRJDLzcyP28sysiegffJfMu5ggOhz8+ZrvHMuLNyqBJATz5KN4Paly8WNgrsG6R3oG/z7QQJG9GSa9tv6nxutG39BdKghNg1tBMEENPKxuJ0mU0uyGJwpSgs9CyUjjASVwyKuCjoc+evs0aSaiai5XH4bv/z7JFJgHYsA5vZNRhtkDoxNXBZ0Q1Y35PdQjTmtv8QRcOt/B6sF3k0ptV1ueA/UrJtrp4SW6pHATj7mj3pYQYDoehxK6w5/+S+xHZNKa6Pk/3KVS54ZmoXi+2ZBSoc7iZ8VBKqWdHQG1p2ZBYTOY1b+dCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRUxSUaNWiRvHuEScxe5r3QlLNMXENAPIQKIYkpvNqE=;
 b=cb4y0Fz6oWSuC5zBEGtZk4J5IEPj5lA4EMBKrWpSKY8sAwSmzUHkiL4wKc4jqxe4K6sSz192gi/nNZOfERml8OsnxgRW5P0USzYbfXCKo+dC6wfqLzN4XYNp+bqzPnzXlrqPEJ12uEE9Y+qEKL2/pgPigfY+AOFu8ish7GX2xc33i+A0ZBASNZ6cBwNAVb/spSzBHhajbvIoBUufGLeqrPHM0AD80Rd0PaeJTk5t8qIpjRmdqeHSDP9UtuGBIn7M//bUjN59isHl0J8IsWOdWzcj+GInZLj2k1hzqtSe0CXFzHeWijGDg3XsrMFHpKY38Se4gkhH+xT+nBxKfGhAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRUxSUaNWiRvHuEScxe5r3QlLNMXENAPIQKIYkpvNqE=;
 b=d++de2GhzQ7DGgzYFkDuNI7LnoQ2Qb9ilJJiUFHZEwLqsQ1vJydUL2zsj/wZlM4FBNKKhv61VIE0e/Sf/mlgpE0pF1CgIqTTS/06FjVOw6TfAJcBb2TJ66DvQll92JXN5Aojh58cKLTXYTf8cgIW671PsPCl3ah25DQTkllvZso=
Received: from BL0PR01CA0032.prod.exchangelabs.com (2603:10b6:208:71::45) by
 IA1PR12MB6138.namprd12.prod.outlook.com (2603:10b6:208:3ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 19:00:00 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::71) by BL0PR01CA0032.outlook.office365.com
 (2603:10b6:208:71::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:00:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:59:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:59:58 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 52/56] ccp: Add support to decrypt the page
Date:   Mon, 20 Feb 2023 12:38:43 -0600
Message-ID: <20230220183847.59159-53-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|IA1PR12MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a72801-7bda-466e-4307-08db1374aadc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khXlFckNrLOpwfl8dDBBL4I2gjhAv1HO81ff3sUWr9lKzhkrtrVoyVxNJvLiivKvcfMp6k2RnxcNfgY4QxktVmiQvOA8N8RNz8g43+s1t2zgtM9n5I/7RwqPtBG7qe55C/L50vzOmp1MORm5Uuk+3J/s7rjAQRsQSRcv8a9oy6WXJEcnuDdxF8ejEjNOpuEbhrFq0m4pyI96yayaMjNbJVakdXNLwnY2ZxKpNVOAcvwNNKAR9Dhc2qpJyW6cfE9HX82LmwYkOjdh7EWXfu08vNSwcCDNaBuk4xpWKv3jxkFlnMf1rwi3canX7TmnkfsNbgWDk5HFsRTuVgRVvN8UKMYpTrmOGDRm1JsTewxlvROO0sCBzqbbr0SrnKMHa+JOC68PmFwEFLt3GokQ5+1oah9hkwiX2nZaBZrPdpIvsGQM83KxFP/gY8+Ly+KpPzroScHK8IxKG/0bky5QJ/prChzDyW7aipXcyLxIZl47siUsg2Skc7SAHRMohf5r5gmivgzvY+XGSsZG/R8pnwTGY5nYQMteEAGq8GenDo+YgUd3HTexFbo4Yfg79YV0RBdCDqaWYVgnnpXhAIrgsXTi4Sdx12B45MVBm3U81wk4rvotnNhCZy5X+Jjxm9P6gpj3w07wbvqYeUzKkYOutoI0fXdJecJWDfqpe/qdZsjsdcAcQ238aXXhbF6BLGG4iYEyS5PK/KAh95PsC1/qEpbGez3AL184ZvoHALJn1fbtapJgsyKObK9TJg9Ddaaaol/fTUdiA7dsFrefeHQT7mzrvw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(2616005)(426003)(40460700003)(336012)(47076005)(83380400001)(7406005)(478600001)(6666004)(1076003)(186003)(26005)(2906002)(16526019)(70206006)(70586007)(44832011)(41300700001)(82310400005)(6916009)(36756003)(8676002)(5660300002)(4326008)(316002)(54906003)(8936002)(7416002)(40480700001)(36860700001)(82740400003)(81166007)(356005)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:59:59.5815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a72801-7bda-466e-4307-08db1374aadc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6138
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 include/linux/psp-sev.h      | 22 ++++++++++++++++++++--
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e65563bc8298..bf5167b2acfc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2017,6 +2017,38 @@ int sev_guest_df_flush(int *error)
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
 int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
 				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 81bafc049eca..92116e2b74fd 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -710,7 +710,6 @@ struct sev_data_snp_dbg {
 	u64 gctx_paddr;				/* In */
 	u64 src_addr;				/* In */
 	u64 dst_addr;				/* In */
-	u32 len;				/* In */
 } __packed;
 
 /**
@@ -913,13 +912,27 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  * @error: SEV command return code
  *
  * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
+/**
+ * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
  * 0 if the SEV successfully processed the command
  * -%ENODEV    if the SEV device is not available
  * -%ENOTSUPP  if the SEV does not support SEV
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
  */
-int sev_do_cmd(int cmd, void *data, int *psp_ret);
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
@@ -987,6 +1000,11 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
 
 void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
 
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

