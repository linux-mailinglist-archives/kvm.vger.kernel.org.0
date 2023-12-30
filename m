Return-Path: <kvm+bounces-5351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 300B082073D
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50D051C21465
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038E1F9E0;
	Sat, 30 Dec 2023 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b3awTLGo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB4FF9DB;
	Sat, 30 Dec 2023 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLT3ZwNE4uvTmiKjvQEZC0oqZQA06od/E9v1LJ6H17NA7/TiLD8Rj1u+HcW0d+FoQ/x86IezB4/RnfEpVPW/jE0uV/x9gndopaAky/S9vnbLcM3/2399HAvLS6K5G05UKBitZjlQM45ZjLqPt6p6yHbGMr+kAe6sl0ZL07MUCV9gBzpaiPkx9iDjkbcKFylgBfjvvcuaiqqt8nxNdU+PhOtL+sxC+ykKUNnS5AoXWGTPSPetHooVh3qzIfm5qW42BAwBq6oHPliwnzMoJZ4EVzrfJt9Mg08Qor13SO0Tg+TSUjORGJ3fv34lyP4Sf3+KIKsJEAbTuubJQgAh9Q68xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FA/1t8PixMH/B1yHI9ZjiXPt3EbWWVp9WThdwCnuvmo=;
 b=B3Z1H5hbyqgchwctDIY3mnEjKUW+itQW1OPIw044gO5MAm7sl5EYEUeI4KZQ/rYwYoZRf+ipojeH+/wjpLeq6imUZLQSr6AnBPKTrm6sUgd7382wl2eRCxCf1OddSk5FecRf+U44E5rmNBPwqrlM4rx5+cLlmovORW9VUf/gk+5d5aHMGUtl0FzHrLQaZ33lNe/t1g/IsewG52vKBKbRIoREbJGSh9/uTmgN36aC0w7obKz0Z7Mc7QsD5ll/zC7znNfFVvhckgt0gDoETYKcbju2o+Sdmbu23wBHMK5ovOcSbRRPjLiDClT1uHIn1nyDnEGM22UKJDYf14FPquGIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA/1t8PixMH/B1yHI9ZjiXPt3EbWWVp9WThdwCnuvmo=;
 b=b3awTLGo/Glo3wPaDjnjRYBFzaTGIUywkHw0hhm3fx167pBu8BWpIqvQH8ti0bo0JcNoNkovjhyKL/U2wRYGHx+tjXwXrK+Zfov1Xpg7IM9wp7mV9P3lW6FRqWcfMtiVgWLRBdkrRhHquxL+9+iJt+1nwpsDCV+ClTegX2mpyws=
Received: from DM6PR04CA0018.namprd04.prod.outlook.com (2603:10b6:5:334::23)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:24:13 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:5:334:cafe::e1) by DM6PR04CA0018.outlook.office365.com
 (2603:10b6:5:334::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 16:24:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:24:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:24:11 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 16/26] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date: Sat, 30 Dec 2023 10:19:44 -0600
Message-ID: <20231230161954.569267-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|BL1PR12MB5253:EE_
X-MS-Office365-Filtering-Correlation-Id: 538d34b3-346f-4ce6-67b5-08dc0953c2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X3uKAfg86ib6kXCdfKMouohs1uAxMrmGgAd5IhZaCdJmZdH/kYP7R1lWPRG+bXde5k+yZiRzVV1mqm3gH6I9et0avJruKxOhlyPk+aeHth/Jnht0sQjOpvhduNjOyfl71tttW7Ijzysc+9tS6TujSR8u4XdkI+5S11427Xx6MZSQkhnknQ2bNhH5S6+2uohhDDwfghS8SvV3rlfQY+DZWbqF+rRTbU+XVjrJmmRIdITMrce/ucwL5xhnvvuUl0qAENQCGB9Pq2V04CrQvQO8AqRAjOyPQm2Pj08o/13a3s8DwleexZEnppRL4wLC/VcWHgZRGcrpZK0D0SllKk9fJny0A/GgZGskuUb7aPmZAKvpT+bd7ees80hInUTo559wf1T36zBMpNV4al4LyKEoiKFiqkOKjUvoDqsrBQIJmRT7nE2yFXgslrfqx7T12snoWpeTmKWdboVb0kGQ1Hd/Hr0QbxJQZCpH5Wm3bgcgfD/s4SijNd0pTnkNq9yyIq2Tll9FDSY1dmxy7pT3DbMcOcRoT+iFe6YP4dCcpZcwzFuFSNVP5eE96z3o5yibS4CnbLDMyqpu0rV9NCP9aUuoq18zCD+YPeNUMpBtAxPaA+V2TFZiCS8GnXO+YZo/geYvWyViElfDYnggPGnr6lAvOKnZ3Fuc5uszmS9Wei8+O5gA7wFnd8m/hbW6nl5YZDqC5gUn0iVOAY+AXRHEvABx6GE1SfvcccB/DSL7DN6IBAtnS3yXBKNm6dl6MZ+6V4xkeX7pQ6z3Zz/r1CYYAUUIq9fGQyPy0CcFjLbQgYoaUPrrcGAxsUxLKLacKG1gWgJi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(230173577357003)(230922051799003)(230273577357003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(46966006)(36840700001)(40470700004)(26005)(1076003)(54906003)(70586007)(70206006)(40460700003)(6916009)(40480700001)(2616005)(6666004)(83380400001)(4326008)(8676002)(8936002)(36756003)(316002)(336012)(426003)(478600001)(16526019)(44832011)(7416002)(7406005)(5660300002)(47076005)(86362001)(356005)(2906002)(81166007)(36860700001)(82740400003)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:24:13.3901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 538d34b3-346f-4ce6-67b5-08dc0953c2c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253

From: Brijesh Singh <brijesh.singh@amd.com>

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware specification
for more details.

Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
when SNP is enabled to satisfy new requirements for SNP. Continue
allocating a 1mb region for !SNP configuration.

While at it, provide an API to allocate a firmware page. The KVM driver
needs to allocate a firmware context page during the guest creation. The
context page needs to be updated by the firmware. See the SEV-SNP
specification for further details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: use struct sev_data_snp_page_reclaim instead of passing paddr
      directly to SEV_CMD_SNP_PAGE_RECLAIM]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 176 +++++++++++++++++++++++++++++++----
 include/linux/psp-sev.h      |   9 ++
 2 files changed, 165 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 767f0ec3d5bb..307eb3e7c354 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -30,6 +30,7 @@
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/e820/types.h>
+#include <asm/sev.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -73,9 +74,14 @@ static int psp_timeout;
  *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
  *   to allocate the memory, which will return aligned memory for the specified
  *   allocation order.
+ *
+ * When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized.
  */
-#define SEV_ES_TMR_SIZE		(1024 * 1024)
+#define SEV_TMR_SIZE		(1024 * 1024)
+#define SNP_TMR_SIZE		(2 * 1024 * 1024)
+
 static void *sev_es_tmr;
+static size_t sev_es_tmr_size = SEV_TMR_SIZE;
 
 /* INIT_EX NV Storage:
  *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
@@ -192,17 +198,6 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
-static void *sev_fw_alloc(unsigned long len)
-{
-	struct page *page;
-
-	page = alloc_pages(GFP_KERNEL, get_order(len));
-	if (!page)
-		return NULL;
-
-	return page_address(page);
-}
-
 static struct file *open_file_as_root(const char *filename, int flags, umode_t mode)
 {
 	struct file *fp;
@@ -333,6 +328,142 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
 	return sev_write_init_ex_file();
 }
 
+/*
+ * snp_reclaim_pages() needs __sev_do_cmd_locked(), and __sev_do_cmd_locked()
+ * needs snp_reclaim_pages(), so a forward declaration is needed.
+ */
+static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+
+static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+{
+	int ret, err, i;
+
+	paddr = __sme_clr(paddr);
+
+	for (i = 0; i < npages; i++, paddr += PAGE_SIZE) {
+		struct sev_data_snp_page_reclaim data = {0};
+
+		data.paddr = paddr;
+
+		if (locked)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		else
+			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+
+		if (ret)
+			goto cleanup;
+
+		ret = rmp_make_shared(__phys_to_pfn(paddr), PG_LEVEL_4K);
+		if (ret)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * If there was a failure reclaiming the page then it is no longer safe
+	 * to release it back to the system; leak it instead.
+	 */
+	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
+	return ret;
+}
+
+static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
+{
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	int rc, i;
+
+	for (i = 0; i < npages; i++, pfn++) {
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
+	snp_reclaim_pages(paddr, i, locked);
+
+	return rc;
+}
+
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
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
+	if (rmp_mark_pages_firmware(paddr, npages, false))
+		return NULL;
+
+	return page;
+}
+
+void *snp_alloc_firmware_page(gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = __snp_alloc_firmware_pages(gfp_mask, 0);
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
+static void *sev_fw_alloc(unsigned long len)
+{
+	struct page *page;
+
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -456,7 +587,7 @@ static int __sev_init_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -479,7 +610,7 @@ static int __sev_init_ex_locked(int *error)
 		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
@@ -625,6 +756,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SNP_TMR_SIZE;
+
 	return rc;
 }
 
@@ -643,14 +776,16 @@ static int __sev_platform_init_locked(int *error)
 
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
@@ -1548,8 +1683,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
index 0581f194cdd0..16d0da895680 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -931,6 +931,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -958,6 +960,13 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
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


