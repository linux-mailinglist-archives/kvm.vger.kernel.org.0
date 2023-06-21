Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3F73935F
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjFUXz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjFUXzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B463E19AE;
        Wed, 21 Jun 2023 16:55:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAQZ7c8OK0p6hI6GfNWLLxr9DoNkTosRe9L4pmIJxef9NpmRrUQ587+7t1w/pqo5UMg6z8DKlhVrgVM5keg6Kkpc3nOFEhR/RXqrOemBYJER3gmfnW+/IkFtGWzGUe71eofOILRHbtYbGr9bIlT6bxdHQmVzL5/TH9jXHQLSwTk7nlS1I3gYp37NK9B5P+S4R0mrCAtmaO3V0i7D4ovLD7d1n1ipC3rfCxLgJkX1m7JfjeRVZqzJynTRsMRnhRAZkgYM2dSknMFtn9BF8DtE8bxkNA1IQCQ9M4SpYb43QzqOFVOQr0//YdufXZY24PiPdhxWg+YUOLK9N2YwHb5cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gPmgzGctQgZlj/iyKvBXeaxd50UuxcrvUOqJyP51yM=;
 b=NLLRt73Xa6Q2j+vSrUabhpVe326bcPOLSzDS2w2q4Hfycu2rM0sfVr9hnjJF166dKQIq8xA9wwMM8/UwcaDz838MF2hEFYKaZgJnDuyyjQVjnx4XkpMWSRcpVoaouw/z3kr/jGmKe6ymtzIHUg9sarsbcxYsLZR1g9yi51rB2igGgSM6UhbH2KL21JpXKwSVnmq84JlNLTgVyQW891Z6+u/+O2liZGz4qcfmUSbAd2HHT6YQ9sZpVkIeSbDAxSBL4EFRnoYpX0ovdYPoGsdoQGZaVdcVpn5BWYkgkNYoYSSPnZom4/ApKjjshTrU5YfpytGibETOZW1rjYP8TUnZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gPmgzGctQgZlj/iyKvBXeaxd50UuxcrvUOqJyP51yM=;
 b=2h5k1Sakc2nk00xC06X2FeSNN+JzBiLJRX+nc1EZ4sRb350hm5hYpCzGxlc04BxO/VJt8IBXr+u1sAA7xmgl3pqWFYO5KZcbIyJI/BIN38adTQq9RgmWQ36OyaeXvpKMSQXTBaCBeOdPP8ckSmoXFFYq8U5X8MTO2lRxYlVH6Fs=
Received: from CYZPR10CA0001.namprd10.prod.outlook.com (2603:10b6:930:8a::25)
 by IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:44 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::72) by CYZPR10CA0001.outlook.office365.com
 (2603:10b6:930:8a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:55:44 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:42 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 01/21] iommu/amd: Declare helper functions as extern
Date:   Wed, 21 Jun 2023 18:54:48 -0500
Message-ID: <20230621235508.113949-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efdd915-31d2-4947-eabf-08db72b306ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2C/Szeu8l4vVwtgYHvfcz+mxpOU7e5D/hHwUpXgIFPGrxPWqEmxCyPN2pf5N3BEUuVKVzfFaiRlgd1SFfVKcF2BQiOhQPryrkNkbZ9PWHpXJr7ER8b8pi5t76zQEtN5qcGtKbIlnvkI0+DB6409uE0HbfX6F7TpsxAg4TlEY2FMspqXN87voUCHF+m6RzI0aaTVRJPa0IXYH27lNoZ403NyJ0kxOt/qnLK/Ic6eR3JkjcHO/R8nhVkIFvimKDdaRl/yyJtI+jPLEIYxuVvxACn/NqmJxoosRLSQtYAqzp4C9JOFd5IYTeVoxG1gVDfVPkG8pdQMnLrx+XEF+UJkEYQG47EzwnmyNryZZWS+7E8MnN3ZdcPSGfTDC93y1y1ab/8JaWa3ub+s/WTVP/gUK5dBYUpD42GY24bd9nSMzF9W/NPF7+eHV3wNZvnEmBI6P/NrPuc1BTKrjQJjLOTKhp5VBj/OsE3S43KlWLZlKLOrTZAJs7pVXwjKgT6vzFnZOWiamwjscFWQ7p32mYyHmPD/tW4AqLxu1aum1IiKoXLNlRPwXh0EFrGQW9RX5q/kuFjdN61msgeOcuyzUg8MPzDQuC7lfoexMvOlckhnmyDKflgCUVc53oJivuyf5Qf4RADU/P0vli2Q+Zsi9QLjDChRthvsJnpOP7bS87MtqFVnbXric9JuirOEvpre6kwf3w/VjapsTLQ2aRojqurcbgLfxmuJz8ZVZuKkgEDzpRBc1lyBiswdSBDT9OOdk2cuYf2ofcH3Enl+JH9Ka/F4cEQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(36756003)(82310400005)(40460700003)(81166007)(356005)(70206006)(5660300002)(44832011)(7416002)(41300700001)(8936002)(86362001)(4326008)(8676002)(316002)(40480700001)(82740400003)(70586007)(47076005)(426003)(26005)(1076003)(2616005)(16526019)(186003)(2906002)(7696005)(336012)(478600001)(83380400001)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:44.4267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efdd915-31d2-4947-eabf-08db72b306ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow reuse from other files. There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h  | 18 ++++++++++++++++++
 drivers/iommu/amd/init.c       |  6 +++---
 drivers/iommu/amd/io_pgtable.c | 18 +++++++++---------
 drivers/iommu/amd/iommu.c      | 14 +++++++-------
 4 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index e98f20a9bdd8..827d065bbe8e 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -11,6 +11,24 @@
 
 #include "amd_iommu_types.h"
 
+extern void iommu_feature_enable(struct amd_iommu *iommu, u8 bit);
+extern void iommu_feature_disable(struct amd_iommu *iommu, u8 bit);
+extern u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end);
+extern void set_dte_entry(struct amd_iommu *iommu, u16 devid,
+			  struct protection_domain *domain,
+			  bool ats, bool ppr);
+extern int iommu_flush_dte(struct amd_iommu *iommu, u16 devid);
+extern struct protection_domain *to_pdomain(struct iommu_domain *dom);
+extern struct iommu_domain *amd_iommu_domain_alloc(unsigned int type);
+extern void amd_iommu_domain_free(struct iommu_domain *dom);
+extern int amd_iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
+				  phys_addr_t paddr, size_t pgsize, size_t pgcount,
+				  int prot, gfp_t gfp, size_t *mapped);
+extern unsigned long amd_iommu_v1_unmap_pages(struct io_pgtable_ops *ops,
+					      unsigned long iova,
+					      size_t pgsize, size_t pgcount,
+					      struct iommu_iotlb_gather *gather);
+
 extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(struct amd_iommu *iommu, u16 devid);
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 329a406cc37d..886cf55e75e2 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -432,7 +432,7 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
 }
 
 /* Generic functions to enable/disable certain features of the IOMMU. */
-static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
+void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 {
 	u64 ctrl;
 
@@ -441,7 +441,7 @@ static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 	writeq(ctrl, iommu->mmio_base +  MMIO_CONTROL_OFFSET);
 }
 
-static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
+void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u64 ctrl;
 
@@ -490,7 +490,7 @@ static void iommu_disable(struct amd_iommu *iommu)
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
  */
-static u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end)
+u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end)
 {
 	if (!request_mem_region(address, end, "amd_iommu")) {
 		pr_err("Can not reserve memory region %llx-%llx for mmio\n",
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1b67116882be..9b398673208d 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -360,9 +360,9 @@ static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
  * supporting all features of AMD IOMMU page tables like level skipping
  * and full 64 bit address spaces.
  */
-static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
-			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			      int prot, gfp_t gfp, size_t *mapped)
+int amd_iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
+			   phys_addr_t paddr, size_t pgsize, size_t pgcount,
+			   int prot, gfp_t gfp, size_t *mapped)
 {
 	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
 	LIST_HEAD(freelist);
@@ -435,10 +435,10 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	return ret;
 }
 
-static unsigned long iommu_v1_unmap_pages(struct io_pgtable_ops *ops,
-					  unsigned long iova,
-					  size_t pgsize, size_t pgcount,
-					  struct iommu_iotlb_gather *gather)
+unsigned long amd_iommu_v1_unmap_pages(struct io_pgtable_ops *ops,
+				       unsigned long iova,
+				       size_t pgsize, size_t pgcount,
+				       struct iommu_iotlb_gather *gather)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
 	unsigned long long unmapped;
@@ -524,8 +524,8 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE,
 	cfg->tlb            = &v1_flush_ops;
 
-	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
-	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
+	pgtable->iop.ops.map_pages    = amd_iommu_v1_map_pages;
+	pgtable->iop.ops.unmap_pages  = amd_iommu_v1_unmap_pages;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
 
 	return &pgtable->iop;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4a314647d1f7..bbd10698851f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -177,7 +177,7 @@ static struct amd_iommu *rlookup_amd_iommu(struct device *dev)
 	return __rlookup_amd_iommu(seg, PCI_SBDF_TO_DEVID(devid));
 }
 
-static struct protection_domain *to_pdomain(struct iommu_domain *dom)
+struct protection_domain *to_pdomain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct protection_domain, domain);
 }
@@ -450,7 +450,7 @@ static void amd_iommu_uninit_device(struct device *dev)
  *
  ****************************************************************************/
 
-static void dump_dte_entry(struct amd_iommu *iommu, u16 devid)
+void dump_dte_entry(struct amd_iommu *iommu, u16 devid)
 {
 	int i;
 	struct dev_table_entry *dev_table = get_dev_table(iommu);
@@ -1192,7 +1192,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	return ret;
 }
 
-static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
+int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
 {
 	struct iommu_cmd cmd;
 
@@ -1553,8 +1553,8 @@ static void free_gcr3_table(struct protection_domain *domain)
 	free_page((unsigned long)domain->gcr3_tbl);
 }
 
-static void set_dte_entry(struct amd_iommu *iommu, u16 devid,
-			  struct protection_domain *domain, bool ats, bool ppr)
+void set_dte_entry(struct amd_iommu *iommu, u16 devid,
+		   struct protection_domain *domain, bool ats, bool ppr)
 {
 	u64 pte_root = 0;
 	u64 flags = 0;
@@ -2118,7 +2118,7 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
 	return NULL;
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
+struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
 {
 	struct protection_domain *domain;
 
@@ -2140,7 +2140,7 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 	return &domain->domain;
 }
 
-static void amd_iommu_domain_free(struct iommu_domain *dom)
+void amd_iommu_domain_free(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
 
-- 
2.34.1

