Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B073672B687
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbjFLEeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjFLEds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:33:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691B810C0;
        Sun, 11 Jun 2023 21:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INMgf6i4cDaPTI+dOPEyrPA2uEoSjGA314/tivaZGNTYqjugRu4VT6A5+etFlwE1uJa7E9iOHsmSsOTrTBb81JEkMiWX+7LHLfmTrjX6flsQfKXF4Ol23n3DQwBGCdilc4omny2PUD9CrfCsQXmhZBOwIZuNPjeEvV+/ZQGiUwFOGKHWWu1HM4wFZQjEozJ3SUjYRpVRdUahkpwJqQAsRqVcPJLDib0eLQ7UdHRn49w3V6bCBz9ROfJ7Jl6w0cp54kZQ24JDJQ4CA3QnLazkp58xVKHD3uU8Kr+3J43Wi4tmPRVjXM25b9kszGT1HSSOXIpA5tHXt2znnYHeXkqKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21O9V8fXiW3DdE/EWkyVZmcvDCjg+nAvrOW5CbIppOs=;
 b=PWfmsjhRAL0/cdL3ZyKLTN6oiaAglpx6UtOe2nqBIe+jpygdUJIK8vLwmZRvV8YWyEy/DBAOInUjMLnJdboX5qvsBAO2a7q26ELIIdK817T7SOYI94iomSLPsCfCjPF0o4CDNw1x8uBnWQ3OBNVhfPOEITEO6a2b5K2ncND/TOD02YQimcvqNteMizEKLZ9GE00hmpSjPPiheJGfyHN5whyHiX/xC4ucTbrAzLCwiuHnkVTeP7XqqfNfSho4WokumN4CL8s1C2MsYSzUz94qgw3TuV+AUPvfG+q0EmhAvXC+0Ggrg2DI4qDjVXfeeTUGDNtfhtxeLvmYVPFurCzufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21O9V8fXiW3DdE/EWkyVZmcvDCjg+nAvrOW5CbIppOs=;
 b=Ap7wXx3YWuMfpLKJLLlGBJyev29ltYk56xeh2jBX0a0KpDHbh0qt5kI/8DMfikFQ+i2DTNwPr0EnEjmP6IhK2XewPOD3OzH8G0+90YWW5PhbNw0bi4vKfGIntXq3Ei6e8Ndjgmh3vP1wLJS4gL9zCMaYp0BSi+YRfDN2+vzbkq4=
Received: from DM6PR05CA0050.namprd05.prod.outlook.com (2603:10b6:5:335::19)
 by MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:33:10 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::b4) by DM6PR05CA0050.outlook.office365.com
 (2603:10b6:5:335::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:33:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:33:04 -0500
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
Subject: [PATCH RFC v9 20/51] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Sun, 11 Jun 2023 23:25:28 -0500
Message-ID: <20230612042559.375660-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a77be9f-a83b-4c4f-8bdb-08db6afe208b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Sg4XbqAhiK/QXS0msCLvjxEgyEWAnCLG02T5kqRVLllS2r1QlK0G6v91H/fcXC9+MwUTab9qwrD1yqkI/1HysRny+N4pv41yX0xC8H9WTlnyvmNg1t4Dgwumcda3sPj1UFjHWLJDIkvF2BWFqoGcX/nxwY+nrMJAjqAX6jhM5kKLNXNkSeXlJWZTTMej4HtL6TDx9+bvuBk03GsKyhRR3Bz3510sw4V5hh/Cm6A5r4SH1aU4tQLiAh+3TVFIkenub0ZqCZL5vDL1t9j+pORRlNpIzO//vjlJNvpKxMJ5+pr35hAyZTUKFSMv5GHSqbLEvCO0gUH2OMnB6glRe+5hHsGRKH+ibJ9U/5d6DlyLaS2phqRnbYBNw0IPhBCF8GM7ca2kEODgQDWOlNjaW9ze8AwziXqR+Khg/S38OHQGNYR8rHy5WBTSl7PyMI8qYryTc0HpUnwZBpvi5I3hcQQ6gx+wWCDNfL72dQ1nUthjIT2D2ROIuJbEmnkFKNMrwaIeY/3May7uR1FQS3LJTA9GoDT0KemaHXF8TFOKUYbwzCI+UWzamTJijsNWuWMU1NtZLcpnNu2mdo8MwIsZ5D5pxGT+nM8n97jI7a2oOKJe44jbRayordJNBUMwyU+ZMsjl28CNoGdUkqCfifOib10FYfkKUXZ75AI4SB8MJwrlCqtxVuYxBvhRDJPQKw9O7KgbVp92Xd7nKMZOhlIt7xtnUTD2q8eA6B/nDJKjHvc2UL6LTRG+WA6dgYlQ+4t5ODyaU0d/8IPT3Z2DOti7SEr6w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(7406005)(7416002)(47076005)(8936002)(2906002)(8676002)(41300700001)(83380400001)(336012)(36860700001)(426003)(44832011)(356005)(82740400003)(81166007)(6916009)(70206006)(82310400005)(316002)(2616005)(40460700003)(70586007)(4326008)(186003)(16526019)(40480700001)(26005)(86362001)(1076003)(54906003)(478600001)(36756003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:33:10.2060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a77be9f-a83b-4c4f-8bdb-08db6afe208b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
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

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware specification
for more details.

Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
when SNP is enabled to satisfy new requirements for the SNP. Continue
allocating a 1mb region for !SNP configuration.

While at it, provide API that can be used by others to allocate a page
that can be used by the firmware. The immediate user for this API will
be the KVM driver. The KVM driver to need to allocate a firmware context
page during the guest creation. The context page need to be updated
by the firmware. See the SEV-SNP specification for further details.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: use struct sev_data_snp_page_reclaim instead of passing paddr
      directly to SEV_CMD_SNP_PAGE_RECLAIM]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 150 ++++++++++++++++++++++++++++++++---
 include/linux/psp-sev.h      |   9 +++
 2 files changed, 150 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 88c5bf264a87..d8124d33c831 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -91,6 +91,13 @@ static void *sev_init_ex_buffer;
 struct sev_data_range_list *snp_range_list;
 static int __sev_snp_init_locked(int *error);
 
+/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
+#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)
+
+static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
+
+static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -191,11 +198,131 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+{
+	/* Cbit maybe set in the paddr */
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	int ret, err, i, n = 0;
+
+	for (i = 0; i < npages; i++, pfn++, n++) {
+		struct sev_data_snp_page_reclaim data = {0};
+
+		data.paddr = pfn << PAGE_SHIFT;
+
+		if (locked)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		else
+			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+
+		if (ret)
+			goto cleanup;
+
+		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (ret)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * If failed to reclaim the page then page is no longer safe to
+	 * be release back to the system, leak it.
+	 */
+	snp_leak_pages(pfn, npages - n);
+	return ret;
+}
+
+static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
+{
+	/* Cbit maybe set in the paddr */
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	int rc, n = 0, i;
+
+	for (i = 0; i < npages; i++, n++, pfn++) {
+		rc = rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
+		if (rc)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * Try unrolling the firmware state changes by
+	 * reclaiming the pages which were already changed to the
+	 * firmware state.
+	 */
+	snp_reclaim_pages(paddr, n, locked);
+
+	return rc;
+}
+
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
+{
+	unsigned long npages = 1ul << order, paddr;
+	struct sev_device *sev;
+	struct page *page;
+
+	if (!psp_master || !psp_master->sev_data)
+		return NULL;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
+		return NULL;
+
+	/* If SEV-SNP is initialized then add the page in RMP table. */
+	sev = psp_master->sev_data;
+	if (!sev->snp_initialized)
+		return page;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (rmp_mark_pages_firmware(paddr, npages, locked))
+		return NULL;
+
+	return page;
+}
+
+void *snp_alloc_firmware_page(gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
+
+	return page ? page_address(page) : NULL;
+}
+EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
+
+static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	unsigned long paddr, npages = 1ul << order;
+
+	if (!page)
+		return;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (sev->snp_initialized &&
+	    snp_reclaim_pages(paddr, npages, locked))
+		return;
+
+	__free_pages(page, order);
+}
+
+void snp_free_firmware_page(void *addr)
+{
+	if (!addr)
+		return;
+
+	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
+}
+EXPORT_SYMBOL_GPL(snp_free_firmware_page);
+
 static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
-	page = alloc_pages(GFP_KERNEL, get_order(len));
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), false);
 	if (!page)
 		return NULL;
 
@@ -443,7 +570,7 @@ static int __sev_init_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -466,7 +593,7 @@ static int __sev_init_ex_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
@@ -499,14 +626,16 @@ static int __sev_platform_init_locked(int *error)
 
 	if (!sev_es_tmr) {
 		/* Obtain the TMR memory area for SEV-ES use */
-		sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
-		if (sev_es_tmr)
+		sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
+		if (sev_es_tmr) {
 			/* Must flush the cache before giving it to the firmware */
-			clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
-		else
+			if (!sev->snp_initialized)
+				clflush_cache_range(sev_es_tmr, sev_es_tmr_size);
+		} else {
 			dev_warn(sev->dev,
 				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 		}
+	}
 
 	if (sev_init_ex_buffer) {
 		init_function = __sev_init_ex_locked;
@@ -1001,6 +1130,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1507,8 +1638,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  false);
 		sev_es_tmr = NULL;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index c8656a36baeb..5ae61de96e44 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -906,6 +906,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -933,6 +935,13 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline void *snp_alloc_firmware_page(gfp_t mask)
+{
+	return NULL;
+}
+
+static inline void snp_free_firmware_page(void *addr) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.25.1

