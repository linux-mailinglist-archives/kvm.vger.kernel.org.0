Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CBA552795
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346158AbiFTXFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346241AbiFTXFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:05:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A20220DB;
        Mon, 20 Jun 2022 16:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2e10kI+pezFUnm56niArU3R6PaqFQlx3vwGB0z8shgmOBOIKwbJrqrFzoj5LwwvPE+FUB99HLu+MaNorQxz5CjGwoaDX3Cq1cOSeJwQ2pWfPvX4Ms18AAozVzQCJ28qlLJTGqg5Nfxjj+yx0VA1x4c83iPaFV/VVYbx0yQVdgFGZZg09figYQLgwSz7ENdxezW4Q9JD7PlKnP+aN3eE1hiWKRCx/gaAMkrt1PuGMZLiE0+KDFF5OJVC1rNIF9x7TpktHyJFZ16vZHzr3RzWJUZpVTcCpC3GfWrC5btQw/fJy+u0BaNbvPWtZMCFoN+91idoMXjsnZME47pVJIIvSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QujCiTXfwu/7a0pJ0Iyr8zR6YG6gwJ5rN07Jvg3JtnQ=;
 b=iny0ycM0Q5Eux3L7bGs6N9Ddg0WDD5DobWxSsM5IHDBbcimXVfamUugLPDe5pbFdqZsfStjl4SbRZU4UYFT5m6Rq1OaUcHpHMXTApJS4XM98hJq8mVOK/RyyWESB4FoRwz5ntIfCVG1+zQ5X+LAPQZAB6OcX/nbkpX0vfTqFFaCE33IDYGNEs+1ZQ8WbMYblbuadIQnytkDdRXHO39xZoOCIHLVnUzPKfiyImWDz+VN/B/yPvD5XpLRe5v7IF9pmJDm4xNcduWrGyLC9Ce5x0FGSEZbNVL6fxoZw0SZBNoQmouobr0pezLz+oESjaHzFYZx+FD36cdVdTUR5/XDFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QujCiTXfwu/7a0pJ0Iyr8zR6YG6gwJ5rN07Jvg3JtnQ=;
 b=qIh8SQlubbINZHdo4wu6t8FZdoPCB5ECRLfKeGBk79GlM51CJYJuCL3qAXCcPupU2gT65CYwPSsGSJy3dHmfb4RY26hBsi0SLJMLBeEFmls4EnlcKOq+P6xXcC/mma19/cjkO6Zgx2IN4FoREySF54mrQ1P8VLB7Jtc+7VZR/xU=
Received: from BN7PR02CA0011.namprd02.prod.outlook.com (2603:10b6:408:20::24)
 by DM6PR12MB3130.namprd12.prod.outlook.com (2603:10b6:5:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:04:57 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::29) by BN7PR02CA0011.outlook.office365.com
 (2603:10b6:408:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21 via Frontend
 Transport; Mon, 20 Jun 2022 23:04:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:04:56 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:04:54 -0500
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
Subject: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP commands
Date:   Mon, 20 Jun 2022 23:04:45 +0000
Message-ID: <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4de38a9-2efe-494e-5549-08da53114b1b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3130:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3130F41DC4BEBE5EBDD9634A8EB09@DM6PR12MB3130.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxT8pB6AtFoPa3tZY4f94cFFjOn1c9w4bx165bxRTteYBUDdF7x7WEtJTIBo8xk+DEBvhXSZmg44nyxC17HUdEdWr5bQWhTiTHCW51JJdS1Hyz0e9qW8yxJMTj2LyqrZliFZD0cFgMtVwQnR1N+fgfUIfehVEdDohl7gusMQKwjh+8yJHtp/IU9cl95GHHsZL30Yj4CKg5ZT03M79EfGILPwQ69rU+W9SPOSZ5/kq1RYAI6RK0NosyKHS1CRZoJ6irBktb2/Ftz5X0y1PIRt70Zk5EfkQ5NiGv0FXqAI2N2jQPjAdWnn8JiDJe9oOskwdmJ2or5jFCuU1OBs3gjnYCp09QFeW863HZaVHgmAYe9tZGiaH+T1kqkh2c9ZWcWCMMjP/J4ONvWLrzsBumYbCEPmV7wtLotQdm7x6LnNLDGuy9VfwaUTsAzeaYQYRWWavHPIXgTziB36KFBt9pjcKr51WHYhdIKM9Yu1sM9z2Df8WM/QpX5iH9TGC6a7LitKfzhUFqYKicnxjuo/Cqw6wv1GQfr5kqYuEMPEMhVPpHDSCzosNc2NDxBsF8AGPsMEh+ASrIZjxEsXpHe84ajLWApZwqL7UeNDMY7ppiwlnqcrDU60qXDnxN2LANP+s4Xm6KVkGov6zkjO0IeGFSeu8JvQ7HytgmWlqowK8ZjfPWFpvNJt2sAI/zobAW1xguTeDhYBwMvtPZmr4iT8lgbyuzVA3L1KFTGJuUxcihrFrqEWx4uTRV9rIhn2MsTPFi880XOGj6e26U810R1eoyAZ5KkM+Pvv8AhiiosK36a+z7w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(40470700004)(36840700001)(6666004)(8676002)(4326008)(70586007)(70206006)(2616005)(54906003)(186003)(16526019)(478600001)(41300700001)(426003)(8936002)(47076005)(316002)(336012)(7416002)(36756003)(82310400005)(7406005)(82740400003)(2906002)(356005)(5660300002)(40480700001)(26005)(7696005)(86362001)(110136005)(81166007)(36860700001)(40460700003)(36900700001)(2101003)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:04:56.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4de38a9-2efe-494e-5549-08da53114b1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3130
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

Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
commands for SEV-SNP is defined in the SEV-SNP firmware specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
 include/linux/psp-sev.h      | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f1173221d0b9..35d76333e120 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1205,6 +1205,30 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_decommission);
+
+int snp_guest_df_flush(int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_df_flush);
+
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
+
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index ef4d42e8c96e..9f921d221b75 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -881,6 +881,64 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * snp_guest_df_flush - perform SNP DF_FLUSH command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_df_flush(int *error);
+
+/**
+ * snp_guest_decommission - perform SNP_DECOMMISSION command
+ *
+ * @decommission: sev_data_decommission structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
+
+/**
+ * snp_guest_page_reclaim - perform SNP_PAGE_RECLAIM command
+ *
+ * @decommission: sev_snp_page_reclaim structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
+
+/**
+ * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -908,6 +966,21 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int
+snp_guest_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
+
+static inline int snp_guest_df_flush(int *error) { return -ENODEV; }
+
+static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return -ENODEV;
+}
+
+static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return -ENODEV;
+}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.25.1

