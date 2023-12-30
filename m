Return-Path: <kvm+bounces-5352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 302C0820740
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99F081F21115
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB8C14F78;
	Sat, 30 Dec 2023 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1tFjaEz7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1414010;
	Sat, 30 Dec 2023 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sf9Tk6ULlWlk3Rhb6j8mzNZle8WHZWP5YxE3fEt3pGB6HefEPfwHqyhr9qQtEJ62zzM8O85oV5z/Q17La/OcRkpAU2/lY+aPvK+uvy62gBHCZongRIufqOz53XVuESkWYSEHVBE1p98pHVhdkPZ7Pw18Yl5F8nm43NoB77avuh3s7UShTUytoOKQEjRYUR0Ug0TMeqLd2Zc4bRq+y1RyUDPx2HJdQ4z84NDeUsTvA3L//kkJEWYvCVvbabv+pgKQLEmIYE8EgEe6w7S7fW47SPAAVrtz5VeL5ZUtyUkRHd1WfQk/B98ZkrdO5xdIWGqTByHHA6VWo36VAGOTuu4h8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVm2wPHZtBPaRL9pNsSxsS2/yrfr71lZByCaBifbzMQ=;
 b=JegwaF74VnT9RtZPiwgmrnxBf2ahzD8r5t5WZeph0odTP34mN0DzPWhIohLJvP87pQdKN2/+6N1Mf7rYOljf74EFfXAF9aKBGaGXfLfQ+wARxQYVCKtxcxThWLw0sCPuexVX5auT+hrghGybDCm+Nqx9CdEEGdfJAaH5EPKyRR0MB57U8PgEwqgbRWOp3a9hdrw4NREE4KjHw5EjCnk8yjyLko2Q26/ziI8SgFMG5lic5zH8fvG/0CUNp+2gfDsMOWDg4LGIJbDcGPXZLDvyw/ts0Y98QmGEg0yFjSoyfyWkBqNsD8uzYBI4427Odj9Pc4PsUWjCD6xvqmFTSHmtgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVm2wPHZtBPaRL9pNsSxsS2/yrfr71lZByCaBifbzMQ=;
 b=1tFjaEz7PbXFjJZfrcpUWfVtskBQKEwKU80uGZydKZYoIsm3d45U+UfkHseetY5wwdRw8rten+ucUZ7fGBBO7kReNVEm6a04MheIj5OPXVYZYRfdKUxMvp9f43AHavyClO/WWfHZbcKFwLaRnd9MYwHpUnEe/G7bFmuDuY94xvY=
Received: from DS7PR03CA0114.namprd03.prod.outlook.com (2603:10b6:5:3b7::29)
 by DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.22; Sat, 30 Dec 2023 16:24:33 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:3b7:cafe::ae) by DS7PR03CA0114.outlook.office365.com
 (2603:10b6:5:3b7::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.18 via Frontend
 Transport; Sat, 30 Dec 2023 16:24:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:24:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:24:32 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 17/26] crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled
Date: Sat, 30 Dec 2023 10:19:45 -0600
Message-ID: <20231230161954.569267-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|DM8PR12MB5413:EE_
X-MS-Office365-Filtering-Correlation-Id: f252f1f5-5a1b-4691-88b4-08dc0953ce80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9Vc7I29ioAKe9UeMu7kSn4oDSIRYCWAMyrQRXiqRNP5s6yJLFTaycXONc/cwkB48GFB/iNSmwtf3n7cAgk+07MgBPVtWMEupqaedq/Zz5AByXvv06qoXayLlHsr87re0bDicHQcSXJWTuCwNB5s/tearPMrBVKdpeYM1tgR8Q8TIBM1OGtpQUzjdHJcntAdjiE+ydHH3N82BUPOLRLjwfs/IbpbhJ+pvgIegOVHG4mJre4anV9bBXchyja/kfvunL5wKbZ+kOuuAHHUbzZWkKe+074sIZBRSZHntbipHXiUQAz9hx9EZjDv6qO+jA92TwjNe6KlB+Ia2pLzS9+cJb6o2+WLaAtQjN90G4kvLTia+aY9pjqsMDECmcWfC8wTnNoNWfvYeBDmB+ZiRl66pnZxxYQQWGS1ABVtz6NVxrVHmlDMuKltIp4F/a2JGMs3/SDlXTH2bdYkFHMAwOUR8XI9pGyijgvugYSijpDHH9c0GpHJFs+IqzRMZPigpRrXKwDxrZ/2PoEYULGn9eElpRVxFS+zecUB25TXZDBCVGVt6BpBI0NzUMNs39jgo5TsIApxCby3lN3k5yg1UIribATzNa+oLnZxW08WMW1UKT/w3WkGjvT980mFc9f8wL+7bO/50YnEypVl8WK0ZFVm7e0GLVh5KtFPEppNwcy4djoY9FtR1vU6IbqUt4JVy/ro15zV4x+T2utDHg6RIJ5EJ3LY9VKosIi5/cDSHzywI9C0CAFa8RX4VxOCKwB+jk5GQHI9rYeJy52k20jjZ+o8RWA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40480700001)(426003)(83380400001)(16526019)(1076003)(26005)(2616005)(40460700003)(336012)(478600001)(6666004)(47076005)(41300700001)(316002)(54906003)(70206006)(70586007)(6916009)(36756003)(44832011)(4326008)(8936002)(8676002)(36860700001)(356005)(81166007)(86362001)(82740400003)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:24:33.0452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f252f1f5-5a1b-4691-88b4-08dc0953ce80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV/SEV-ES, a buffer can be used to access non-volatile data so it
can be initialized from a specified by the init_ex_path CCP module
parameter instead of relying on the SPI bus for NV storage, and
afterward the buffer can be read from to sync new data back to the file.

When SNP is enabled, the pages comprising this buffer need to be set to
firmware-owned in the RMP table before they can be accessed by firmware
for subsequent updates to the initial contents.

Implement that handling here.

Setting these pages to firmware-owned will also result in them being
removed from the kernel direct map, since generally the hypervisor does
not access firmware-owned pages. However, in this exceptional case,
the hypervisor does need to read the buffer to transfer updated contents
back to the file at init_ex_path.

Support this by using vmap() to create temporary mappings to the
firmware-owned buffer whenever accesses are made, and rework the
existing code to track the struct page corresponding to the start of the
buffer rather than the virtual address that was previously provided via
the direct map.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 104 ++++++++++++++++++++++++++---------
 1 file changed, 79 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 307eb3e7c354..dfe7f7afc411 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -88,8 +88,9 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
  *   allocator to allocate the memory, which will return aligned memory for the
  *   specified allocation order.
  */
-#define NV_LENGTH (32 * 1024)
-static void *sev_init_ex_buffer;
+#define NV_LENGTH	(32 * 1024)
+#define NV_PAGES	(NV_LENGTH >> PAGE_SHIFT)
+static struct page *sev_init_ex_page;
 
 /*
  * SEV_DATA_RANGE_LIST:
@@ -231,7 +232,7 @@ static int sev_read_init_ex_file(void)
 
 	lockdep_assert_held(&sev_cmd_mutex);
 
-	if (!sev_init_ex_buffer)
+	if (!sev_init_ex_page)
 		return -EOPNOTSUPP;
 
 	fp = open_file_as_root(init_ex_path, O_RDONLY, 0);
@@ -251,7 +252,7 @@ static int sev_read_init_ex_file(void)
 		return ret;
 	}
 
-	nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
+	nread = kernel_read(fp, page_to_virt(sev_init_ex_page), NV_LENGTH, NULL);
 	if (nread != NV_LENGTH) {
 		dev_info(sev->dev,
 			"SEV: could not read %u bytes to non volatile memory area, ret %ld\n",
@@ -264,16 +265,44 @@ static int sev_read_init_ex_file(void)
 	return 0;
 }
 
+/*
+ * When SNP is enabled, the pages comprising the buffer used to populate
+ * the file specified by the init_ex_path module parameter needs to be set
+ * to firmware-owned, which removes the mapping from the kernel direct
+ * mapping since generally the hypervisor does not access firmware-owned
+ * pages. However, in this case the hypervisor does need to read the
+ * buffer to transfer the contents to the file at init_ex_path, so this
+ * function is used to create a temporary virtual mapping to be used for
+ * this purpose.
+ */
+static void *vmap_sev_init_ex_buffer(void)
+{
+	struct page *pages[NV_PAGES];
+	unsigned long base_pfn;
+	int i;
+
+	if (WARN_ON_ONCE(!sev_init_ex_page))
+		return NULL;
+
+	base_pfn = page_to_pfn(sev_init_ex_page);
+
+	for (i = 0; i < NV_PAGES; i++)
+		pages[i] = pfn_to_page(base_pfn + i);
+
+	return vmap(pages, NV_PAGES, VM_MAP, PAGE_KERNEL_RO);
+}
+
 static int sev_write_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	void *sev_init_ex_buffer;
 	struct file *fp;
 	loff_t offset = 0;
 	ssize_t nwrite;
 
 	lockdep_assert_held(&sev_cmd_mutex);
 
-	if (!sev_init_ex_buffer)
+	if (!sev_init_ex_page)
 		return 0;
 
 	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
@@ -286,6 +315,12 @@ static int sev_write_init_ex_file(void)
 		return ret;
 	}
 
+	sev_init_ex_buffer = vmap_sev_init_ex_buffer();
+	if (!sev_init_ex_buffer) {
+		dev_err(sev->dev, "SEV: failed to map non-volative memory area\n");
+		return -EIO;
+	}
+
 	nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
 	vfs_fsync(fp, 0);
 	filp_close(fp, NULL);
@@ -294,10 +329,12 @@ static int sev_write_init_ex_file(void)
 		dev_err(sev->dev,
 			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nwrite);
+		vunmap(sev_init_ex_buffer);
 		return -EIO;
 	}
 
 	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
+	vunmap(sev_init_ex_buffer);
 
 	return 0;
 }
@@ -306,7 +343,7 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
 {
 	lockdep_assert_held(&sev_cmd_mutex);
 
-	if (!sev_init_ex_buffer)
+	if (!sev_init_ex_page)
 		return 0;
 
 	/*
@@ -599,7 +636,7 @@ static int __sev_init_ex_locked(int *error)
 
 	memset(&data, 0, sizeof(data));
 	data.length = sizeof(data);
-	data.nv_address = __psp_pa(sev_init_ex_buffer);
+	data.nv_address = sme_me_mask | PFN_PHYS(page_to_pfn(sev_init_ex_page));
 	data.nv_len = NV_LENGTH;
 
 	if (sev_es_tmr) {
@@ -618,7 +655,7 @@ static int __sev_init_ex_locked(int *error)
 
 static inline int __sev_do_init_locked(int *psp_ret)
 {
-	if (sev_init_ex_buffer)
+	if (sev_init_ex_page)
 		return __sev_init_ex_locked(psp_ret);
 	else
 		return __sev_init_locked(psp_ret);
@@ -787,10 +824,38 @@ static int __sev_platform_init_locked(int *error)
 		}
 	}
 
-	if (sev_init_ex_buffer) {
+	/*
+	 * If an init_ex_path is provided allocate a buffer for the file and
+	 * read in the contents. Additionally, if SNP is initialized, convert
+	 * the buffer pages to firmware pages.
+	 */
+	if (init_ex_path && !sev_init_ex_page) {
+		struct page *page;
+
+		page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+		if (!page) {
+			dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
+			return -ENOMEM;
+		}
+
+		sev_init_ex_page = page;
+
 		rc = sev_read_init_ex_file();
 		if (rc)
 			return rc;
+
+		/* If SEV-SNP is initialized, transition to firmware page. */
+		if (sev->snp_initialized) {
+			unsigned long npages;
+
+			npages = 1UL << get_order(NV_LENGTH);
+			if (rmp_mark_pages_firmware(PFN_PHYS(page_to_pfn(sev_init_ex_page)),
+						    npages, false)) {
+				dev_err(sev->dev,
+					"SEV: INIT_EX NV memory page state change failed.\n");
+				return -ENOMEM;
+			}
+		}
 	}
 
 	rc = __sev_do_init_locked(&psp_ret);
@@ -1689,10 +1754,11 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		sev_es_tmr = NULL;
 	}
 
-	if (sev_init_ex_buffer) {
-		free_pages((unsigned long)sev_init_ex_buffer,
-			   get_order(NV_LENGTH));
-		sev_init_ex_buffer = NULL;
+	if (sev_init_ex_page) {
+		__snp_free_firmware_pages(sev_init_ex_page,
+					  get_order(NV_LENGTH),
+					  true);
+		sev_init_ex_page = NULL;
 	}
 
 	if (snp_range_list) {
@@ -1745,18 +1811,6 @@ void sev_pci_init(void)
 	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
-	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
-	 * instead of INIT.
-	 */
-	if (init_ex_path) {
-		sev_init_ex_buffer = sev_fw_alloc(NV_LENGTH);
-		if (!sev_init_ex_buffer) {
-			dev_err(sev->dev,
-				"SEV: INIT_EX NV memory allocation failed\n");
-			goto err;
-		}
-	}
-
 	/* Initialize the platform */
 	args.probe = true;
 	rc = sev_platform_init(&args);
-- 
2.25.1


