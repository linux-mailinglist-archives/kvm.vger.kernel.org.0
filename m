Return-Path: <kvm+bounces-5356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 516B582074C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D09F71F21E96
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE48E57E;
	Sat, 30 Dec 2023 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VSJi5YLu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC35D2E1;
	Sat, 30 Dec 2023 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUvY+kga3J8En8QkPDOM9UdPREZ3m79rEwHlI4hwelptnnQQpLkZzm17W9vtXSa6lFM/nGkXyMdndRkxBlUOkPHGFVLfIuiNKqddQUGGCkoReRaSi6wiivqZLA5efUfCsbrtD7GiCzpnui6+NwSeSqP5yA2Bx7LKQ+kPnXSRVQy9zQpnyGhgDDuGE2LPWi2tRzOI5oGRT8nUrtJkJ5Y7yIIs1BtKBsFmpFeFEkfFHsYqx8BdlilusSUj3e4RfsOr2uDz6G29jxEjpFfD8cfBB6R/GL2DIbyh1HzepMaN9w69+/yY6uTH+pV7KSko944nmokKpAb3rVp605AzWdo7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2LWPNEzXew58/uEUkfHoR1k+7mj67hBVpXN4aUSkY8=;
 b=VufSR+pD+KNs5ccI6amCOxM2CMRx7sHcEx6SytOv2cA6FIlgtFoWMpYpK6zLHovm9MLEHifhT93TR0nGxu4c4I6giC0gjuah+YmCjXAsJkY+QnfWpfp6wC6cOJT6+Ilm/GDjK9HF2lCfFfLtiI+A2kEtQ5ddvh0ALdOMMX/StoC3UZN2pDdnPVhG6Z6bxu5/p43vQZkVCZuld3a26Jm2OMSUk93WOrU+UhHE26VTnUigpXSLseY2qFBxXKyT3tpDuxa4ysUQoEZxhmFXJLqbsjYOyh/iKnvJWpj/VieuRQ8752OQIPnT6X9fIiXrrlSKUQ1TE6wFmVAAbexYfz3vCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2LWPNEzXew58/uEUkfHoR1k+7mj67hBVpXN4aUSkY8=;
 b=VSJi5YLu77pkbGwXXd0nv+4Abs4N3Q9VOYsLdtgyPDCkhegb8je2BakcMNzMwByyLg6OpIs4jyOQHGHd+DK1XKVLpMzz/UTCRzOZoZyubRcjEoDMXcDk4iZmzQy4DFtp/jI+x/3RaM598cexkNZ/ESkn6BhPmuzedd6Wj9hSf/I=
Received: from DS7PR03CA0009.namprd03.prod.outlook.com (2603:10b6:5:3b8::14)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.19; Sat, 30 Dec
 2023 16:25:56 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::a1) by DS7PR03CA0009.outlook.office365.com
 (2603:10b6:5:3b8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.18 via Frontend
 Transport; Sat, 30 Dec 2023 16:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:25:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:25:55 -0600
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
Subject: [PATCH v1 20/26] crypto: ccp: Add debug support for decrypting pages
Date: Sat, 30 Dec 2023 10:19:48 -0600
Message-ID: <20231230161954.569267-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 7580137a-b5c5-4c2d-5624-08dc0954001d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TQNrNrDGcJlHMZFefXOkUH3NmyibU01QG/2ym/JxRFPOVwrYyxN/Cz9pa4Jv3EdiAF/98l+HacTVhKoPJrtaXuproynaG7F/WWcXA1UboGwa2ClcyOYmBKfNdcpj/WCBFq3WAy/6MqR4P9b1PMtXxT/DJpysniN+Ej2uRh9x2Q33A9kJVAJCt6rjZnthC2gAbny7hPwwphgGxxO2mrZwz3Ywpj078zVPQZkdSyXJh0oIrEC3FQPgB41WYeYHclo3hJ3mt0CbDNQcx4N/cp9zbOkmDwbGr7lyqDbiuXdtGGSvCs347rKwX+VgaJD7BL3qzom5n0+wi6WCgGZ6ez1uP8dmIzYgXhDpx58r9GYbbwLKkU0rn0BnH+bJBGBaUCwZMe4hfvpaA9XkinXJlSONzTx3JbAT2kfvTPGW4pok2nB4p2iqv0r14hHldktSL2760q3P6VWzM9zSOzlWSpoxrkpKgtwrvdRh6nYLWymONqlVT0hd+D+jKPF305733kG9hKUYqGPqxG7kZguytX2L/LO5HZwTlz0UZr2JOL6xItZFqVdUQEDKJKUKklaVGbMDdg1QLpbQBncD4YsDHFQ/g27Fy5FiuFRxn4P7EczkbmSfWLO1DZCT0G+ECQNjB1DvL09ndnD31zZQSl6pX9ih5Bly6iz38dc+9RXamYFlIHOMuX1CKzNF3f4No8r/SFe++fvWmsncEbV4YWyNGegtXYmvbFgYtP/Z4uJHyTz1+vn+R5VZG5T8as+PU+x4sYyd36XggUrqGrHc4BNWCFYrNV24aQG4bF94cckR7ZGmqSIRskYeKpLS/IHvAsVDTspsMoSPW9NSxXevPmhji30+oQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230173577357003)(230273577357003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(46966006)(36840700001)(40470700004)(36756003)(40480700001)(40460700003)(2616005)(47076005)(70206006)(86362001)(6916009)(70586007)(2906002)(81166007)(6666004)(82740400003)(356005)(26005)(7416002)(36860700001)(1076003)(83380400001)(5660300002)(8936002)(336012)(7406005)(44832011)(16526019)(316002)(54906003)(4326008)(478600001)(8676002)(41300700001)(426003)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:25:56.2812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7580137a-b5c5-4c2d-5624-08dc0954001d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846

From: Brijesh Singh <brijesh.singh@amd.com>

Add support to decrypt guest encrypted memory. These API interfaces can
be used for example to dump VMCBs on SNP guest exit.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: minor commit fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 19 +++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 47fc58ed9e6a..9792c7af3005 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2053,6 +2053,38 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	struct sev_data_snp_dbg data = {0};
+	struct sev_device *sev;
+	int ret;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
+	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
+	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
+	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
+
+	/* The destination page must be in the firmware state. */
+	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
+		return -EIO;
+
+	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
+
+	/* Restore the page state */
+	if (snp_reclaim_pages(data.dst_addr, 1, false))
+		ret = -EIO;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 16d0da895680..b14008388a37 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -930,6 +930,20 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  */
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
+/**
+ * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
@@ -960,6 +974,11 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	return -ENODEV;
+}
+
 static inline void *snp_alloc_firmware_page(gfp_t mask)
 {
 	return NULL;
-- 
2.25.1


