Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31AE7CA988
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjJPNdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjJPNdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:33:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DB510EB;
        Mon, 16 Oct 2023 06:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QguyCBb3Bwfa8nIqQwjUVcy1e5GOBh9zFIkpiEEjjEz8ipmGDDG1prAiaQQRd2YHHSIPQPbN5LjHaUCIJOV5T1oTsg+FuOFd8M1Wwi6M1K4P5NcrGunXcbBPCsjI50ZBoKOWwvh6/qeiEi1a8L4chrztkcn1D/4bScik7Ye24bYmyeHp7w+/B5T9S7eNuuymAiQB57vsw/oYiIkHpj3YheY5tirKvxfeEFUl8LcLBjocrnMg7lSwedwjR8fIOFREHVjXM+rlXLoZt/JYXqUDSGA2nwYtH2LjEAMqvR9y2PkQ1v5TaTP6lcJwCOXbHvDiI6FN3vy4YQRWUfX7klVR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFt5V0e7LrKLJVVAo96/SeOF9jgQQeuE0xqDr9KtCno=;
 b=e/YBUcvfZRX7S6N+qo7ZAMxOycE5T5SROln5koT0ZePbRoSxnmIU/dudApnTCCMftRhO1nOcfYTlXMNbeiGzriF+wRpY6ksiJ0ttfvyTGwxspBH5dTMXqYiVL05d3ani/NtU/hG821+HRVgJd/bLU674ONKSuTB93By+B8LQsSCvky6cNMwEBvlAV5tCMr+6uHMXgmj9uhz6eRCQf4cDY1HflZ3SmRklypt1pJEg6NfaGoiXIldPyUfxcOSoG1O3u1nL5iPtcJrDBGZNhSBAcL5i2oMvF1x25hFJDvp3E39E6pQRUdUr7C5SJgxmMFXi5Z5i117Qp60X/iUHHt0txg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFt5V0e7LrKLJVVAo96/SeOF9jgQQeuE0xqDr9KtCno=;
 b=mPJgtZuatEDf3nOaNNRpUqoY4HKwsu4J23FB05GmzD98mCJHOgHNXrcxL665S4sqcJYHfm87YOg0KTMBoq4+cluNEMMO1o0o21lwnBmYuHwxDtfVWbpKETLtJd5n1p0aPeZmudbDTNmWJigy6EHbKeSQsnozUsS1YmGOOSWbq+8=
Received: from SJ0PR13CA0216.namprd13.prod.outlook.com (2603:10b6:a03:2c1::11)
 by PH7PR12MB9074.namprd12.prod.outlook.com (2603:10b6:510:2f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 13:32:56 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::2b) by SJ0PR13CA0216.outlook.office365.com
 (2603:10b6:a03:2c1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:32:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:32:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:32:54 -0500
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
Subject: [PATCH v10 17/50] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Mon, 16 Oct 2023 08:27:46 -0500
Message-ID: <20231016132819.1002933-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|PH7PR12MB9074:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1f2ecb-ae87-4fb0-d4ba-08dbce4c681e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7iRFI702YMXV9YFJx/zdSpQMpWDt9Ftv8v/tD6eXcTWTS1mUOJnEwsblz2dvfn+CUt1fcusGxqDeNp+w2pxJziZtAOtPppyEwrrXNG4NOz6o2KOhJ+QUsk7fE9O2sq20/Pvx2nCMZthoNFzCFr4xKjsAmgmbVLVzCAMlX42UE7qbCeASKo/WgZZn40DetFiSvCh/YejOKMfNk1AjQ9B7lJpG+YhyF4k/yiAs16CC7xLfoB0iE+WF8WlYDpY8dqxVA4Z5pC7C11jYia/Zg5gX3xSAbbBctLh0g6rqK54Z4INCCFZM8iOvzpQutZn+C4HK1IkgwCLzN/2IcK/woNt+k9lesvMofIzgrL6BOHcLoEqXyj28qdscfnIuPS+6E7vfKEwwiIgWpZVgRmQ7kM2JXx6fZxQ6PrEpV0q+Hay0iOkDO68MZ1BFZtrxHMmO9VJvX0yc5+/o4HR+QoH6QVREJgW6yptLwYLD8WSUhGHgi4HMr4jtKcPxpXd28OqSPtc4SBS2o3g8Neq4A3ZyqdaMMxBoBLb+nFlxONX1rzWHHWArQVbu1CdX2xgILbywHEZocC90UZpT32vx4SZgjO5KbNiwVmDkUkOeH8+25CVIM0+onz3BKaKstNJIngLQDKQRADjr5VwilcpaYHCbhichyNZ3LjKGhBI01b2x8yByuMb/kRBoHNTO9fwnU6pBu2LXPJi0DXqtZovJ3obgnWc9dMLAwln4GY+bALvSz6kyWQVoXAwdlnDG2QJUHCkqygEv527qEkFCFSqW0HzMSSRGQw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(396003)(346002)(376002)(230922051799003)(64100799003)(451199024)(82310400011)(1800799009)(186009)(46966006)(36840700001)(40470700004)(16526019)(6666004)(70206006)(70586007)(2616005)(6916009)(316002)(478600001)(54906003)(41300700001)(26005)(4326008)(426003)(8936002)(336012)(40480700001)(8676002)(36756003)(81166007)(356005)(1076003)(83380400001)(5660300002)(36860700001)(44832011)(2906002)(40460700003)(7406005)(82740400003)(7416002)(86362001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:32:56.1181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1f2ecb-ae87-4fb0-d4ba-08dbce4c681e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9074
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
 drivers/crypto/ccp/sev-dev.c | 151 ++++++++++++++++++++++++++++++++---
 include/linux/psp-sev.h      |   9 +++
 2 files changed, 151 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 613b25f81498..ea21307a2b34 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -30,6 +30,7 @@
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/e820/types.h>
+#include <asm/sev-host.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -93,6 +94,13 @@ static void *sev_init_ex_buffer;
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
@@ -193,11 +201,131 @@ static int sev_cmd_buffer_len(int cmd)
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
 
@@ -443,7 +571,7 @@ static int __sev_init_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -466,7 +594,7 @@ static int __sev_init_ex_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
@@ -513,14 +641,16 @@ static int ___sev_platform_init_locked(int *error, bool probe)
 
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
 		rc = sev_read_init_ex_file();
@@ -1030,6 +1160,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1536,8 +1668,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
index 61bb5849ebf2..9342cee1a1e6 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -898,6 +898,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -925,6 +927,13 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
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

