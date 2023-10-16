Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9F7CAA51
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbjJPNsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbjJPNrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:47:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8671A1;
        Mon, 16 Oct 2023 06:47:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMmE6fJo+XyCBIwNoEgUKldN9mn3AHanS0GyayBDI8n77wV9H3p/S4fgvdDO0OXE/etenGRA2sFCoYARCW3syC6jUmQem9X7qkeVTZhAirzueKMlWLDe/nsFl1bF6wr4x73ocbfJLxDKE2oLbooz06WIz24yIJq9jnvn6RtwCndTGKCcax9ijU1VCU6MGEU3ZiwcSbWLNXJyFsIblndAfEqW2RqwlWF6qr82S5qpR4OBdGKeBUzKM7NiEaZyokldiiTZjVeves5LNbMfvg/fMHVQpu1r95bnAxtKbSF5w7q8G2/G+96BTsfco7/GFAQHa4JUsWiEVUpjRI8AFi0Dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygj93dfhFOyFNaHWPzClbQfSHLdYgUyNFdWHZCYMzkA=;
 b=IbCGILc1+um5rZdtzDDUCv6JROtN6atGoCW5GszAAPzCRqr+Nf3I3oqBjtO45rHo8gMoSpSKHdAsDwyX85Hl4Vz/nJhXN+dfLSdwgVVniFwlC7Fm/15Nv6r7KnMnvJmD551z8BrJL2Pkuwg16wR10h/tBESHHZvBxh6t4l0vd+V4aXA1GaeFfa2N3Nvxzl9XkFO0M8u0b3dxzqvNg501/2HPxqQxNP6YPJ+T8F8TI7b7KnH3/Sv/g9Fk9oy0s/7kERg0F2P2pOnP/BECseExjFypEqw1wAgGltjnhdHVizq4jxJBKseoFObUbnjcyYC8mU8vRMujFYXaq4b3S+pNpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygj93dfhFOyFNaHWPzClbQfSHLdYgUyNFdWHZCYMzkA=;
 b=UFSi49H5/GJ2nJigZEu/RDVlE3nFxcoLAs1smCpGaFOLtmgpWliQX5EPyydASA/F8I4gaxR3u6dgliiT+/pWwkg1FJY2VeNiiIUCtdlnTTdk0mWLRwRsXKuN2Xaed7PKborpKZB9czVGdl7rbmLMME3HCDJl3v9p/+nqxHB37rQ=
Received: from MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19)
 by SJ1PR12MB6340.namprd12.prod.outlook.com (2603:10b6:a03:453::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:47:23 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::2d) by MN2PR18CA0014.outlook.office365.com
 (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:47:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:47:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:47:22 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 49/50] crypto: ccp: Add debug support for decrypting pages
Date:   Mon, 16 Oct 2023 08:28:18 -0500
Message-ID: <20231016132819.1002933-50-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|SJ1PR12MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c591994-f8d9-4a08-919d-08dbce4e6cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gy0Zf7Nyzv7Wpwux2eII6qv9419TY9G5geGSkT76n23ulXsIbvUy/zk9ZbZLnuoppPt+jhkERrTiGOJNUu05Dc2eeBe9YIleaKT7iJ3t7kaDP73IOEMcrhd8+3A7L1tdIO35S1afdEqRe+0gOdH9zvwhgLLfmsoOvhNqW6ItQI84nt67KPLLpTMtBOmPEDmcZvm/TISEEnGJjEiBgjWQd+1sckSiBBHTMo3VUWmSmSHghwiescu1bJEleOFs0JmmS3kH/leVRF1pYcynh3exA29QAY1TFAfzn92e7fM0uTfFDEJVbnLmf2On5cpMRiU7Igo6kQsCO8OdTmSD11aQ3KL6b8PS9I8U1HxNcEkumIeSvvonq70XDYL5jG7bDWRqxlqf7KwzvS8OUrHYybHek/hxDehgSQMMOW/NTq+ba9h0oLERs2WdRpjcwxU366kTnuBDWzOneevVuppkAgRlvKcAIn8VFxHlquwlRoZ7gVsh7Uq6wejHmzzGcUU7gRXmpExeG/UrImGIiUF/U1teyHdW0XO4k2UWLEJJAc8WJpiph9F5G1KaCHOeLWa4KS0ap/42gzAb8e8uK81G0NULJUFxqNtHy1wthpaFNJrx/oEORSUZ2BHSixuXLQk2nIPMfqRv2lT2Ejt1yK6cnNAQrazCNr9Ql07yxWnFYFVG/djIHNni0vNXWUK38zrAKQKzcx0KejxoGnxdEnsS1gOS7pJFh/JRYscg08b7izOM7uv5VZMdF6m0mjKrIAYVDITWXbZz0pe+rRunRi3JyJOY34bs7E/z1f8sJPth97oxWZI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(1800799009)(64100799003)(82310400011)(451199024)(186009)(36840700001)(46966006)(40470700004)(41300700001)(478600001)(54906003)(70206006)(70586007)(6666004)(6916009)(16526019)(26005)(1076003)(426003)(316002)(336012)(2616005)(7416002)(8936002)(7406005)(4326008)(8676002)(2906002)(5660300002)(36756003)(44832011)(81166007)(86362001)(356005)(47076005)(36860700001)(83380400001)(82740400003)(40460700003)(40480700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:47:22.8885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c591994-f8d9-4a08-919d-08dbce4e6cb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index f9c75c561c4e..26218df1371e 100644
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
index 3b294ccbbec9..eb2c8a2b2a02 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -908,6 +908,20 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
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
@@ -938,6 +952,11 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
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

