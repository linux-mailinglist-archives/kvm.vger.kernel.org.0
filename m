Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F92552831
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346545AbiFTXT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347897AbiFTXSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:18:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5A025EBE;
        Mon, 20 Jun 2022 16:14:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7dUUYGqflibQYcf1nIyTu4B+ALH7DMbNBT3OXfRJX+7aUGAqUe3UReRIAzmOpqd11VK3SNQxxKw56Zg6TntP4Ifv10WxSdFCL4M/ad9j0Oq/9YCqSEmNyrxQfBif0lNy3b7qwAr+hw7HY2LNYvNv4VDfuWdvDejv3bO9mqqNuf++6E9OrEAM1xZzE6L0pAmcp8NzAmFPLeuMMVlpR7ryzQLR0wfFuNBMSh6zn4Lfj4hjTNwwIoI6gCt379mSgsZVxOgYfvcuyDXrTv3ZCdJD4hM3R0nvYOc8Tpe5adupAVkAyS1MmaPemIDqpsKEJqi8z2cd5PVY+c0HS70MJ4KEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7AT8kU+nKhKnw7+Cx8PeBE5hqBJEwnr9MI0G/xqwvo=;
 b=Ght2FrJKZRVqzG53oDrI/7KW6nfWc0MOSw69HY3J8nzOHqB/Aw3zXfnt3SCtnPq3u/SvJuYRIgRsBnH/bHX9oNY1iuFODYVqpUy8RqOImO3HaI5448x3I6+QlcCQYe/I4NYJlbybBdQPWbgMsBMqf3VEVnyELHI0b3+ZV7q5L0dwTsWfvMGcZuOfJp3vPYg7Jz0fER2VOM+vwul4tk/Lpu0mm4+2haRG9EKxr+4JtSyjyKbfHogX2YBqyLp2gIBWvEyRDv6NzbssqLot70/7Bj3ipDfKF9hREmSN+I2EDLgr2rKRyDHeLb7qnytI0BA8D2ZSoNolHyeQIBtPHrc4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7AT8kU+nKhKnw7+Cx8PeBE5hqBJEwnr9MI0G/xqwvo=;
 b=GCqbGYgf2aLPA9pGBd8iCNJy3zgU/CsDp+l5vluCW61tfG/4dAfd8KZ3XqhHn5NFdD9bpVKK7Un6dKQTJr/bfsjg7vPzZdBbQkrlr45WTBNmbntGCefZ+g7ioDhLTyvA4QuP3uPuxBhtOQKmi0kIdJPnIDP/AB0H/080DX7AToI=
Received: from DM6PR07CA0132.namprd07.prod.outlook.com (2603:10b6:5:330::25)
 by DM4PR12MB5913.namprd12.prod.outlook.com (2603:10b6:8:66::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:14:54 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::d0) by DM6PR07CA0132.outlook.office365.com
 (2603:10b6:5:330::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Mon, 20 Jun 2022 23:14:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:14:53 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:14:51 -0500
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
Subject: [PATCH Part2 v6 46/49] ccp: add support to decrypt the page
Date:   Mon, 20 Jun 2022 23:14:43 +0000
Message-ID: <dd5b7ab26269d70f82f2ac31f7bfbe254186ba55.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c7c212f4-9d91-41fd-13da-08da5312af22
X-MS-TrafficTypeDiagnostic: DM4PR12MB5913:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB591395AB5A9399D49AE68C978EB09@DM4PR12MB5913.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q949V+FoWGFDzWvqHvObzttm0FFPm7srvFCkSqqqVabiLa54N2UslT5oylrkqlJ2sUhVk4Yt3ubuJjdWCnCi3Jdk+5riNAaqn8oggkjS51SuOzHmZRsr+uz7cBY9BoP5aNRV4Yrf9PMAroCfTYI3KmTjAy6v+LUGhFZ/hU9F5uBFYgQdvsuKP63O6QFEC4kVjk7cB/QLVOcReuhyqUALORckm6tlxvLX1F6XWuU4nwQPPHGZit//MzmvVcCxCwSHggARpnchubrQexA22DPy/GOK0TwzPbnJRpSK1XGbnZt9m5qh/S70YhDmYi6C5q+vWnL4iP6dMMG44qnZksyOyRA2tYRMwVYVypM1EUE1li9C46gNTHl2gEQ98s8iP6QuRkNhRLKGj8Q1kUiVP3L/hNSPPqj4ixptdgMZTwErKbVUASL5mtg1XAkVayjec7FqrpbUII5EtAam+ALB7/hJxQ2UxnWbFSvO48u8XvpA6rbOFiwFHTr2Y+o3oUfHlBWV73SuEAeY0IPhm7MFreKYGRVveu2z/IR3KbRz+5tPXs6KxXcowhhdb4vlyhfPoB6Lu642UJsn2jRrirAtuJDOautZmiaIJ/rFhFk5qm30GJ/TaWFZjQhDS7xU74gkreCYRx4FFf1CYKRQIQrmwM4Rm7zg1WtWOBW8rMyVVUcpT4w5DK/eJ2GzKRSCpCZzIb+0YLePwlIFh2vMHP6NWi8fQ/U6PryFj9mfsTtrvfAefBIAy7vK/5GnUu9OStorbg5ekXfrGqDrQr98xfcfkc+sFEQN0WmLhVk7kJVYwqC+uMg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(40470700004)(2906002)(7416002)(26005)(4326008)(40480700001)(110136005)(47076005)(40460700003)(36860700001)(81166007)(7406005)(7696005)(36756003)(86362001)(82740400003)(83380400001)(186003)(356005)(8676002)(426003)(336012)(54906003)(2616005)(478600001)(70206006)(5660300002)(8936002)(82310400005)(16526019)(6666004)(316002)(41300700001)(70586007)(2101003)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:14:53.8015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c212f4-9d91-41fd-13da-08da5312af22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5913
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

Add support to decrypt guest encrypted memory, these API interfaces can be
used for example to dump VMCBs on SNP guest exit.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 33 ++++++++++++++++++++++++++++++---
 include/linux/psp-sev.h      |  6 +++---
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f6306b820b86..9896350e7f56 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1852,11 +1852,38 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
 }
 EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
 
-int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
 {
-	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
+	struct sev_data_snp_dbg data = {0};
+	struct sev_device *sev;
+	int ret;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_inited)
+		return -EINVAL;
+
+	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
+	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
+	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
+	data.len = PAGE_SIZE;
+
+	/* The destination page must be in the firmware state. */
+	if (snp_set_rmp_state(data.dst_addr, 1, true, false, false))
+		return -EIO;
+
+	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
+
+	/* Restore the page state */
+	if (snp_set_rmp_state(data.dst_addr, 1, false, false, true))
+		ret = -EIO;
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
 
 int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
 				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index cd37ccd1fa1f..8d2565c70c39 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -928,7 +928,7 @@ int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
 int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
 
 /**
- * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
+ * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
  *
  * @sev_ret: sev command return code
  *
@@ -939,7 +939,7 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
  * -%ETIMEDOUT if the sev command timed out
  * -%EIO       if the sev returned a non-zero return code
  */
-int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
@@ -997,7 +997,7 @@ static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data,
 	return -ENODEV;
 }
 
-static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
 {
 	return -ENODEV;
 }
-- 
2.25.1

