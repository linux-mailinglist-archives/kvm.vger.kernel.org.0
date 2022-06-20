Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349D155279F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245502AbiFTXGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346174AbiFTXFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:05:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B869B22B19;
        Mon, 20 Jun 2022 16:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6OmYm6hJwi5ZhSjG7ZcJvr7vD/NgwPNTmZYTNe/h/mHaSBgg3HXzB4gtFIPY9MflmNIVEkY83XiRUsYNzCh9g/eDvj2v3+MDfk5KKg4DXAL7f3Q0wBHOzhv3SCa0PT6HK5MKSY2PRO9Y2QiEgr8zWUag2Q6KbDGRbnviJ2xQ0xzLepQdgE5+N4zRrOLsMRp5xGk820WYmuc2QBg253ShiuL9RLmL9BKLIGCv9r1MGz9cfS+R2BzqBssLoeGgsUG4KmDsiQIfsDGW/1zbcljlyhWrigNkspiFikmKsDuDofrVOQS0M10aqbD6VUY7ct8iaUK/iBRLOVC0YZzJDsFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+5Y8gfq89dav30o0UqX4tCDd2C79aFqCJcwdvMSA3U=;
 b=L9qpz+ML6gMVxPd7OqLPGETR9wUqJFPGQYZ0QjPVyqbCELrP40BBLVmZZD2X63XiIRr4kNTHpY20BUd6S3zrx6szmYwQlPf1u7h8nsFlBN6eujUCrcC2QDplec/EuGKEBWHcl2r+brrad54hgxRj7hQkagrYKOVlpqgjvkBY2A7FHU1iEZbS/Bhi37foChHTwb987hB0eZ7Nv2237QAIYyHaY8x0Fg8yuLYqzTssFj9sIVGkJIfaGnFmVy+uBVcN4WGaVNZA5MQdDwNzKG6YzE6+PpRaMhrzcc6lDab+eJvn8hVQbmv4nCYbxx3M1W/0JcRJQOl2B3fJiEitPMBvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+5Y8gfq89dav30o0UqX4tCDd2C79aFqCJcwdvMSA3U=;
 b=AD5zm3b46HquMXCuXYg1zRoSHWdLX1rFe651+qMvirRaV++ZlMJdmYPgZMli2kAC7zVlrlUck6qPVsWVSR5FHetOrVVcDhbLorFdmWdWUpsF/53bLUGYCD9JflGpSyavUV3PopJTp7MPoAr+M1GEBNI0NPCbYNniQETXBpeI7fY=
Received: from DM6PR01CA0014.prod.exchangelabs.com (2603:10b6:5:296::19) by
 BL0PR12MB2529.namprd12.prod.outlook.com (2603:10b6:207:4e::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Mon, 20 Jun 2022 23:05:12 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::8a) by DM6PR01CA0014.outlook.office365.com
 (2603:10b6:5:296::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Mon, 20 Jun 2022 23:05:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:05:12 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:05:09 -0500
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
Subject: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Mon, 20 Jun 2022 23:05:01 +0000
Message-ID: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 40f0155d-25bd-47cb-c82f-08da5311545f
X-MS-TrafficTypeDiagnostic: BL0PR12MB2529:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB25294D010BB66049DC6205628EB09@BL0PR12MB2529.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkpVUWIGauIjtK8WbCEj7BhToSy//CD/rpozaN93op9ligJ/N8+a+2g0xSfJwSNdYPo2jFc+RTrxBbxxGkNylnvxpqY+wSHhAg4HEVnxORi+P7keSw1M9UknSSxGM6vNOwObuVvu9Qsg1wUp8gWYmpoMo8l6J/ivFCnb+4fSVytcXy+Z1YJQiI4wNkc5CcQ6PGrz5nbSDPC0D+wqKYNst4dXFbA0CLpp+Bq4QEy2t6XU+VjfB1Og/+aaKD26seTWD+x/JhhY2UkWZk3xq0f3cA9WicSuT0FmB2Lp0YHoMeZ01+ANZrlZd9NwMNvfAMTUaZZWqnMhnwxOiyYdMVFdpwN4dS+8pjdAzV0zitMeAmox+2MseTFXAoTyEMHgWpDapt7so4GywCrz1A+IEemaEtfG4crluM6rVx4+jk1ORIHOqDwHRqYI7GJLVMVnIuRDG8lozoez0eYwdqkZ5xfx7TTC7AytB/xFh7qZGlbh0gfTixkcD1tsjHrcFdrgjbMT5bHMpHiT6r/CBYhLwpj6woOPrUZdlrdskZaH0xXfTZAmzDPjN6QO+z034Pr9y82AcVv5atJB5ZFaYIMU6lyYwPbcv53kb6vsBgmoR3Nj3ryzZ2/pzXl5h7xE9oFB5N065Vvf2igH+FvxTpmyepLoq3Ms1wLU8zx++4lx28G8EK+D4NlXFpp567SkvkOt4VbUonaMh+t4oU+F7JGCG+QNmzIwG9QST8BPNOj3ewM8TFNfBRTnWCki8WWrlwEnv/TM0+Tcapjk7QLAJz5soNFfPw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39860400002)(376002)(46966006)(36840700001)(40470700004)(2906002)(40460700003)(7696005)(82740400003)(40480700001)(16526019)(7406005)(83380400001)(82310400005)(8676002)(41300700001)(70586007)(70206006)(316002)(6666004)(81166007)(47076005)(26005)(426003)(110136005)(8936002)(4326008)(36756003)(54906003)(2616005)(186003)(86362001)(5660300002)(478600001)(356005)(336012)(7416002)(36860700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:05:12.0521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f0155d-25bd-47cb-c82f-08da5311545f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2529
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

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware specification
for more details.

Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
when SNP is enabled to satify new requirements for the SNP. Continue
allocating a 1mb region for !SNP configuration.

While at it, provide API that can be used by others to allocate a page
that can be used by the firmware. The immediate user for this API will
be the KVM driver. The KVM driver to need to allocate a firmware context
page during the guest creation. The context page need to be updated
by the firmware. See the SEV-SNP specification for further details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 173 +++++++++++++++++++++++++++++++++--
 include/linux/psp-sev.h      |  11 +++
 2 files changed, 178 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 35d76333e120..0dbd99f29b25 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -79,6 +79,14 @@ static void *sev_es_tmr;
 #define NV_LENGTH (32 * 1024)
 static void *sev_init_ex_buffer;
 
+/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
+#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)
+
+static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
+
+static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+static int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -177,11 +185,161 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static void snp_leak_pages(unsigned long pfn, unsigned int npages)
+{
+	WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
+	while (npages--) {
+		memory_failure(pfn, 0);
+		dump_rmpentry(pfn);
+		pfn++;
+	}
+}
+
+static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
+{
+	struct sev_data_snp_page_reclaim data;
+	int ret, err, i, n = 0;
+
+	for (i = 0; i < npages; i++) {
+		memset(&data, 0, sizeof(data));
+		data.paddr = pfn << PAGE_SHIFT;
+
+		if (locked)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		else
+			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		if (ret)
+			goto cleanup;
+
+		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (ret)
+			goto cleanup;
+
+		pfn++;
+		n++;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * If failed to reclaim the page then page is no longer safe to
+	 * be released, leak it.
+	 */
+	snp_leak_pages(pfn, npages - n);
+	return ret;
+}
+
+static inline int rmp_make_firmware(unsigned long pfn, int level)
+{
+	return rmp_make_private(pfn, 0, level, 0, true);
+}
+
+static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
+			     bool need_reclaim)
+{
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
+	int rc, n = 0, i;
+
+	for (i = 0; i < npages; i++) {
+		if (to_fw)
+			rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
+		else
+			rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
+					    rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (rc)
+			goto cleanup;
+
+		pfn++;
+		n++;
+	}
+
+	return 0;
+
+cleanup:
+	/* Try unrolling the firmware state changes */
+	if (to_fw) {
+		/*
+		 * Reclaim the pages which were already changed to the
+		 * firmware state.
+		 */
+		snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
+
+		return rc;
+	}
+
+	/*
+	 * If failed to change the page state to shared, then its not safe
+	 * to release the page back to the system, leak it.
+	 */
+	snp_leak_pages(pfn, npages - n);
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
+	if (!sev->snp_inited)
+		return page;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (snp_set_rmp_state(paddr, npages, true, locked, false))
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
+	unsigned long paddr, npages = 1ul << order;
+
+	if (!page)
+		return;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (snp_set_rmp_state(paddr, npages, false, locked, true))
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
+EXPORT_SYMBOL(snp_free_firmware_page);
+
 static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
-	page = alloc_pages(GFP_KERNEL, get_order(len));
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), false);
 	if (!page)
 		return NULL;
 
@@ -393,7 +551,7 @@ static int __sev_init_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -421,7 +579,7 @@ static int __sev_init_ex_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
@@ -818,6 +976,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_inited = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1341,8 +1501,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  false);
 		sev_es_tmr = NULL;
 	}
 
@@ -1430,7 +1591,7 @@ void sev_pci_init(void)
 	}
 
 	/* Obtain the TMR memory area for SEV-ES use */
-	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
+	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
 	if (!sev_es_tmr)
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 9f921d221b75..a3bb792bb842 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -12,6 +12,8 @@
 #ifndef __PSP_SEV_H__
 #define __PSP_SEV_H__
 
+#include <linux/sev.h>
+
 #include <uapi/linux/psp-sev.h>
 
 #ifdef CONFIG_X86
@@ -940,6 +942,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
 int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -981,6 +985,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
 	return -ENODEV;
 }
 
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

