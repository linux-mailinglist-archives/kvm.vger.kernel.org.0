Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220AF69D336
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjBTSuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjBTSt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:49:57 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BB521291;
        Mon, 20 Feb 2023 10:49:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ba2sPBd6+TvO80X9LCAwVcJUYUC/iSF0XjskWsZfRdXx8/1vFHnoAUGqFmelJU06IHEVrcQZ+o9mBpYaeyre/Q1zk/mXJZwOL6v+NxA48DuyHpkkPXU1TTTu+clcKolKcngQyqFqKIfBBXLxr9w5wgur/P8IOTeh7aZTv12XebpN7yffqszZLaOiW/nel10/pnRrOZYF4ciUSt2C2V4DRejp8AE0BEC7/8eqvnKxkUXRfEhWupvGfFwnTnYj/dFu+DZ5QNZsbfQlYLqXnpwOuzTQhk1eUi5Uh7t20/y1cPdGOs+Db+w0CDw8URZ/uE5sIb7PsHgFPF+7+9YNBGY1Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqs+ScbwS9SaGm6GdjYtLpsrVAyQkW77Y2/rbuGN220=;
 b=I9qTrKGkNzQgKmMWp6z5KOd3uOJCL0eopg+/vuTR9J0XMwnH4TOV04vLvCDMXCMw0vtKh6UQWd0bOqaFFjr5d61B9HPv9BA9J5a3PV0jYVGcYyJ0DMLd9PFtPF7ZSeRPUTQ5/Yrqdi0OO4vIm4dDqnF4McWS/Yy1vTZBxJLQOGQO9qWpg7l8KIYMYJJVImN+EV3KF99j1k1Lqy2bNwAmlG8IPwIFr7CQu1tTpF8j/X22rqhtyRDOqU8HbwGcBZbEyqKagfOHpnUatnWlIKjdoy3ofav9KXqJMlNGb6wVN2FP+N7ScPNF3IEun7xK0VhLULnGkwzeSkNcKR8RCEbPpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqs+ScbwS9SaGm6GdjYtLpsrVAyQkW77Y2/rbuGN220=;
 b=TjAb+zXalch/7DwFUedEqazxoO10/TnxHgh/exabkwtw4gOPqrbRfUaWKqvxjHHYnALQq8s54xpn2iXEkaSQmXmJMIdT8gdOrn7nVxClTz7L7qZ5Bq2c4sz9SqvzdCRIJnyRlWZ3s1wj0jUVpzGuuYcSYEl/Bs9jZaQ1z9MVUdw=
Received: from CY5PR10CA0024.namprd10.prod.outlook.com (2603:10b6:930:1c::24)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:49:08 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:1c:cafe::39) by CY5PR10CA0024.outlook.office365.com
 (2603:10b6:930:1c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:49:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:49:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:49:07 -0600
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
Subject: [PATCH RFC v8 24/56] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Mon, 20 Feb 2023 12:38:15 -0600
Message-ID: <20230220183847.59159-25-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|DM6PR12MB5518:EE_
X-MS-Office365-Filtering-Correlation-Id: 31847463-33b7-4e3a-bf70-08db13732635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nlLV6aJFHDivvWcwmq+ZfAt4q2dSS0zhQ4RzQ6y40tb1Uleli7t7lm5Or670bkWby4tSSGHH6GaKdgtcDFZ5cRUgWmf7b0icuUcHrgbTnOs3cJKTRDmEcqrB9g37JoIlBmKJIAR3jV2HdOpNGcHt9yNpFn23A0+aAZsoWFSBGs8pZAdip6wHyskf59D6XKxHfmFxLPbvjUozFfkgnMjVLyhFb/mCa4AhIFxL5T0JLE5ai8yDc/+Wdo8tBVclWlarb4RclFz21K1qEazXlX6nQbIScUXoTF+OoBmPNhglTCCvqiyi/938YMEZ9jVP+5JZZDRkDCUt+1xJzt/HzzqWTDppkiRq1B7sprzx/33U6s9FRUCAgBgj2Hu6/iOoHxdzevRZpz4e/nsHwl/5WXWxclBHc6U3SsWyB5CKC9HDRoHRWLZdAX4SpUhraDFyPEWssSRt4d49MVwULI+6Baypw1ZenEV+Cjo8yKo5DWWa1WsoExbj9mUtUeJIkzm8T/lP6iFCwklqmmI1ppAEwgAEIDYlFPgJrBvLtU1VV7K2S4HFDj98MtOhYArZoIpDlqjqYbcs2WCvN9ettBYP7KMMB9JWzoDEfP6JXnkKz9SlSi8h2qJXWwq6TGr7Z8GGDCO3ekczPK+GODVlaYx9j+VBIYsfgb/Sdj9+PWNEnrKt6Dvy1SKFpdq/77QghxecTF7yZihdVofNqG+2dvKOkT2pg+tdlZMKHOYVj9Zzz4vliy8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(82740400003)(81166007)(82310400005)(36756003)(356005)(36860700001)(16526019)(40460700003)(40480700001)(6666004)(26005)(186003)(70586007)(1076003)(70206006)(4326008)(336012)(2616005)(478600001)(54906003)(316002)(2906002)(8676002)(6916009)(83380400001)(5660300002)(7406005)(8936002)(44832011)(86362001)(7416002)(41300700001)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:49:08.5186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31847463-33b7-4e3a-bf70-08db13732635
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 148 +++++++++++++++++++++++++++++++++--
 include/linux/psp-sev.h      |   9 +++
 2 files changed, 149 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index eca4e59b0f44..4c12e98a1219 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -94,6 +94,13 @@ static void *sev_init_ex_buffer;
  */
 struct sev_data_range_list *snp_range_list;
 
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
@@ -216,11 +223,134 @@ void snp_mark_pages_offline(unsigned long pfn, unsigned int npages)
 }
 EXPORT_SYMBOL_GPL(snp_mark_pages_offline);
 
+static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+{
+	/* Cbit maybe set in the paddr */
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	int ret, err, i, n = 0;
+
+	if (!pfn_valid(pfn)) {
+		pr_err("%s: Invalid PFN %lx\n", __func__, pfn);
+		return 0;
+	}
+
+	for (i = 0; i < npages; i++, pfn++, n++) {
+		paddr = pfn << PAGE_SHIFT;
+
+		if (locked)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
+		else
+			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
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
+	snp_mark_pages_offline(pfn, npages - n);
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
 
@@ -468,7 +598,7 @@ static int __sev_init_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -491,7 +621,7 @@ static int __sev_init_ex_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
@@ -982,6 +1112,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1499,8 +1631,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  false);
 		sev_es_tmr = NULL;
 	}
 
@@ -1511,8 +1644,7 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	}
 
 	if (snp_range_list) {
-		free_pages((unsigned long)snp_range_list,
-			   get_order(PAGE_SIZE));
+		snp_free_firmware_page(snp_range_list);
 		snp_range_list = NULL;
 	}
 
@@ -1593,7 +1725,7 @@ void sev_pci_init(void)
 	}
 
 	/* Obtain the TMR memory area for SEV-ES use */
-	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
+	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
 	if (!sev_es_tmr)
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 8edf5c548fbf..d19744807471 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -922,6 +922,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 /**
  * sev_mark_pages_offline - insert non-reclaimed firmware/guest pages
@@ -959,6 +961,13 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
 
 void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
 
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

