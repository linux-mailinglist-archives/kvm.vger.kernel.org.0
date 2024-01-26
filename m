Return-Path: <kvm+bounces-7059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2C783D396
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E81471F24F77
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D91C8E0;
	Fri, 26 Jan 2024 04:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q0ioCkGN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA22EB642;
	Fri, 26 Jan 2024 04:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244201; cv=fail; b=OSsGAJbVgv/zfBvgSA2FSMv/68iwoKtzjCwSYpEzZc/enioDRjPUTBTD0oOqBkfDxls5HCRhJeZJsLhPS1vC+J09+XybPZjHl+WmJlOEa2A+asPyMX0CtDwfrzJeFbQGqHKbv7o0+DMgYDTYlDLhRGdU5GxB+GsO9vbJ7d5OTUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244201; c=relaxed/simple;
	bh=THtOTMsCk7OoTVKoGILJvoGFQaBuoYZmNjLHENdYkh8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rgFZU+4qGiMK1VJ7X90oUN35XZ6gw9Nfim1CiilbY9MjxqcSidGOAPrD1Wf0l286QREG09BVrJ6pP+ntOsvgkx1s7PZRjJRZmJMtyx7EAuh1E5/ILiBwHz5BMP26kivrTx1CLS1l0PejJ+hbSaJb4DWa+lzj2J6lbTPRjGIHBkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q0ioCkGN; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktlalzZaaFMKPnrIDo2+4ycTg/ir+fPk2IKQmzOscq6tGCyrsZdubT9JxUtYlppFKVOfaZkLRx3KP4lITgUEsMaOkwDW+9sCZ+VQzeEMHSwDsvNh++BI4ATRXpzkMOtyiTE5gy/7c/EeWFeiuneB4rEDWgh2h351LpIuxUS03j+ATJuElF3WAdDSU1jWQ7FQofK31ONqLy/iMYGE/Ki1qerXoFDhbW7LHhikgRyNgXxaoJd3GnBBQOjsDKTCB6b0nOdVBjbXS/1drivMFL8NinE7W9YjhpoMX9696rYmcgFoiAneNDhVNlo8n7GnCOwlKqEg5bNXEfewTcHLFr5kEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS9xr7kd5bHfaLb97IAWDyOpOz+WLSM7PA7ZyGIuU6I=;
 b=fq1u/nIcDLnlRZ/NHZsecIARNMwakibvqcJ+udgeJxlRR8YbXDLAVyWc/ekctQqMDrGnPu1Z+/kRnN1yOGap2cVaS5dFDsR4JKefAU3S7EF7Vquf9Rixf/nISlUD2cebFS7+xkQsClwXLqex3Ist2FSd5bMKqO+S9vM/o2Yd7PICOexVd1TDb6OqXZVx4vncpHcLJS4s+go2/EPrYffR640YfMBWK07LzDsSdF6RUakOlf0GBklN2FHW29oDcPgW6X4svQStJv54q7TP8PpAhwtTl+T+r9zaq+/hd/mkHLEsnGd7szgy46UqOG+woP1DtZyZ7mrtuAAwub9tYaOUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS9xr7kd5bHfaLb97IAWDyOpOz+WLSM7PA7ZyGIuU6I=;
 b=Q0ioCkGNuh4lvAJYjIJveQtG4DL6S7RY4yygdo0o17ezlCEyYFQrf8w2sdP3nH310ORzLH2Ibq3fs9U/iXUXaUTqf1C4fVmKSGqUkqeIgXBoBqqeToaQLhsjh6S0O9qT7J1G+PYoEeaAsbVzpNSWdQ77plK/RA2y8gZFLMXUCgU=
Received: from BY5PR16CA0005.namprd16.prod.outlook.com (2603:10b6:a03:1a0::18)
 by LV2PR12MB5966.namprd12.prod.outlook.com (2603:10b6:408:171::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:43:17 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::38) by BY5PR16CA0005.outlook.office365.com
 (2603:10b6:a03:1a0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 04:43:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:43:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:43:15 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 16/25] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date: Thu, 25 Jan 2024 22:11:16 -0600
Message-ID: <20240126041126.1927228-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|LV2PR12MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: aa9438fe-1114-4aad-8e0f-08dc1e295045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EXiB764r70Q7yvKppidWUfIR//0CNm7vhe5JI4DrekcjAdcrj12HA4Qz+JDOLGmCuoCndRHtkSmonr5V41wpAGzvN5qW0u5U05nx1SV+9kBnvpT9Z04Dtam9nQOA6p/+FOhUcfzAf+Z9tzdeiKMlo7vZ8FnGa18mB7rNwPS7RE/qRFOEcCvuphssom/fpgcnOXbHus4b2ufgJEcD8l2XaJjHzYe7BntBqftjadNW0G9eJUI/7itECRFwc33bk7zuBEvaK7MDBsBqrelwanfcqtwyxf5jo6JFBzuEI5M68EwnnvQPrYc440+5rjaF6mMn/votdZaRdsi0hWltP/RjZ43AzXYEsGi1ldIVG+XPa1l6kwZyFXSJ/Jb02UyHgkbXpVsh5mkFblADVmpR5xWjnLJQv3Ol3iUCwY+nHD/io8lp9mh7/N/dg4yVqJp62CarXZE27A6ChIrRdxcnEeb3Oj3XRRuRT160/o9K38CND0SXA/lkjNHkW5bpcNPnrcJ6VaoJBDR3VypLk1Od8vezr+Nebv1M1nw/LzTJzBJxNQ83hp0AI1HWf27E1wlaKwaqhzdqviJAKrgYhg6pvz5hIyyeJjAuaoPdpBTwQjy0qLeTx0RDX2aTGif1q2pzUypu2QRfGP82RWI+n20RKkDQkalKIULfMLReCZZb1dtj/uPo5C6OXYDxoOq2g6Os37aoYTAxvWuUJEE2/22AJ5NJFxbna5T4niEGa2jMBlDDQPZZkp709KXTun6yznm2XXPDWary9Y2DNowcuJsMul7BrjJYSQWo632HTSJIoNgQL8pXKzmXOmX/tjN7WjSPG3Vc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(39860400002)(376002)(230273577357003)(230173577357003)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(36840700001)(46966006)(40470700004)(47076005)(36860700001)(83380400001)(8676002)(8936002)(478600001)(5660300002)(44832011)(4326008)(70586007)(54906003)(86362001)(6916009)(70206006)(316002)(26005)(426003)(7416002)(16526019)(36756003)(2616005)(1076003)(336012)(7406005)(2906002)(41300700001)(356005)(40460700003)(81166007)(40480700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:43:16.7589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9438fe-1114-4aad-8e0f-08dc1e295045
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5966

From: Brijesh Singh <brijesh.singh@amd.com>

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware ABI
specification for more details.

Allocate the Trusted Memory Region (TMR) as a 2MB-sized/aligned region
when SNP is enabled to satisfy new requirements for SNP. Continue
allocating a 1MB-sized region for !SNP configuration.

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
index abee1a68d609..fa992ce57ffe 100644
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
+	paddr = __sme_clr(ALIGN_DOWN(paddr, PAGE_SIZE));
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
@@ -623,6 +754,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SNP_TMR_SIZE;
+
 	return rc;
 }
 
@@ -641,14 +774,16 @@ static int __sev_platform_init_locked(int *error)
 
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
@@ -1546,8 +1681,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
index c7dd6ff9f36b..7f9bc1979018 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -932,6 +932,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -959,6 +961,13 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
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


