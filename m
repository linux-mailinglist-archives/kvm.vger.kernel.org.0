Return-Path: <kvm+bounces-4939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D224C81A204
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D2D8B2505F
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DDF46554;
	Wed, 20 Dec 2023 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UKT3Slv4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3846526;
	Wed, 20 Dec 2023 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLqbDrTXP4TwDZ8VZ7B+znXDOsAreVVp73vb+Rk+NtzwCEJb3QXHMtL+fYkW4gGDFFUuEjzwpz2uQcEGXLAQP1wiUM/ExCP4GVE0eBVIBJ4xBDWqDfr5ICb3+fsTb6FKbciB9OUqizZyq2u4CNULrJ8PZBnXPa4Anz/mLILWsSW8jV21Fxzq+PNvqt7P99EDD/hs598FruaaNM4dq6abNdvO0kE20oE14wyKu7XwIxcqqOfHHI/fq94ZfgkvUvq5mOwTUI0iBGbzSOd4e1xF6bblLfAjcUVkMxBRnO8ev5aVghDtOBygAKCMkXtgy98kHYv/Q5CEmaxV0Fxt7PL/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeHVdKf+jAcF36+CPMNRL8m2xddHqrcAlBx2XNCzoRQ=;
 b=D4xL/+kfcPQJssQfeZdJ635o9bE96kTxuioBHgC4GB6E3zk1HCizm9kfsnrgER2Co0eVUd2JBbO3poRi13bMBuHmvX0uJVSHUuXqgDOZ52551KsoLvlekHtOAFVY8cX/q/KxTUSAxB89e2SEqr3pUZ+nh2EKUW0mRm1XDEki6AAvTzr7bLVR0kkJCx0cuGmSvcjwQrVoEACBXdd0C4il4NDS9nw8cwjxGcRrq1RlOUun699OPl7X+eWi/ii7UlX7997s3AFHg4ScEb90Xq6ZN3TkTEcBrLtDO4mwy1InLEBtE4bDwIDukGSr/D4+CMcnEy5xtRSStx2iQZqYVMiOTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeHVdKf+jAcF36+CPMNRL8m2xddHqrcAlBx2XNCzoRQ=;
 b=UKT3Slv4mxD4gX3L6LAxp36IiV6zYz218sY5r4erqBN8oofSaNS8tM4Li1wiWmcPVTEtxbHKBzptCeMyQc25uscDEc/QHmlIFVWyp0NKJiYNg5i4SY6NJvJLoU6U8XA6yAEgVq1Q/1aX+fZajWmuHquZePTSodwe0VX4hDbZNXU=
Received: from DS7PR03CA0222.namprd03.prod.outlook.com (2603:10b6:5:3ba::17)
 by PH7PR12MB7329.namprd12.prod.outlook.com (2603:10b6:510:20c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:03 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::41) by DS7PR03CA0222.outlook.office365.com
 (2603:10b6:5:3ba::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.19 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:02 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:14:58 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev struct
Date: Wed, 20 Dec 2023 20:43:46 +0530
Message-ID: <20231220151358.2147066-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|PH7PR12MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e276860-a165-4c41-acf2-08dc016e708e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P1yDJBcY7hr4XuScI0xzQAuu64+TyocJMM1VJQeOHmIjKmrxLofdy5NwxTQGymyzp1ahNc5cizcrUeuHBmjkShoEQ+6OQ81oj3jlhhQVlf/4M8spIEdsySsMHUD+RuLXzK7smBx+6oCPRPcZQSNrbn4zr7/7C3usyCgfkYbxAZqTR15JGwLNyTbMI62nTQbfFKS8ztfOWBUSmUghSloQlTiHg1gSyrKa9kgNvZL5xWvJZUQWPlzoHrEKDD0qriwmnx12yFmUJbZ8bPQEGV7sWB5rsf5EJRLxl7jV6+ekQxaEBIY3MGCFK0Uv5XC5yDIlEbA/OewbV74bQCko4H2UUuzXlmeRalOBRyoEXm3fcBXLdxGbqasRzOIMpbaikYWvMhcdH1g7i/JLA5CfpvUvMNRfvGHv30vUJAUgpJPAGmRFFzOHWWwLlX55QoZvnp71sSLIh3ttrEOfcOLwZv0dW2WQH6smD0almF0HW8Ix+z8YSZMTsSAz32aKNmUjsFu2uxETiXbLgayFkhdA/k/KcmfUEzPapOSGCQIT9hubTutgM6rWoYAGyRyO6nus6O8N3V7XIGeJwJ0phySincgEhud2y936UDaFIXT+tXMm3CD3HQwsYiztcMoYRVKpW2O5U6dbPh1awfUMoBx02bMsMzFrM0SvOmJRfk2JZcVG8WWvF0+TXQMcfuSUGF66htWEo5Ydc67mfnw2LgZPPRtm8scS7xFR30OM+IzS+ixkjfuOuJwwUhjh8pP9BfPjsu67hRY56vYTHRAbDNGPJ3MGWA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(81166007)(5660300002)(7416002)(2906002)(36756003)(82740400003)(356005)(41300700001)(16526019)(26005)(7696005)(40480700001)(426003)(336012)(54906003)(83380400001)(70206006)(70586007)(316002)(6666004)(36860700001)(40460700003)(2616005)(47076005)(110136005)(478600001)(8936002)(8676002)(4326008)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:02.5415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e276860-a165-4c41-acf2-08dc016e708e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7329

Drop vmpck and os_area_msg_seqno pointers so that secret page layout
does not need to be exposed to the sev-guest driver after the rework.
Instead, add helper APIs to access vmpck and os_area_msg_seqno when
needed. Added define for maximum supported VMPCK.

Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
preparation for moving to sev.c.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/include/asm/sev.h              |  1 +
 drivers/virt/coco/sev-guest/sev-guest.c | 95 ++++++++++++-------------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 78465a8c7dc6..97ff8c28d3b8 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -121,6 +121,7 @@ struct secrets_os_area {
 } __packed;
 
 #define VMPCK_KEY_LEN		32
+#define VMPCK_MAX_NUM		4
 
 /* See the SNP spec version 0.9 for secrets page format */
 struct snp_secrets_page_layout {
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 5cafbd1c42cb..9c0ff69a16da 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -56,8 +56,7 @@ struct snp_guest_dev {
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
 	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
+	unsigned int vmpck_id;
 };
 
 static u32 vmpck_id;
@@ -67,14 +66,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
 {
-	char zero_key[VMPCK_KEY_LEN] = {0};
+	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
+}
 
-	if (snp_dev->vmpck)
-		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
+static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
+}
 
-	return true;
+static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
+{
+	char zero_key[VMPCK_KEY_LEN] = {0};
+	u8 *key = snp_get_vmpck(snp_dev);
+
+	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
 }
 
 /*
@@ -96,20 +103,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
-		  vmpck_id);
-	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
-	snp_dev->vmpck = NULL;
+	u8 *key = snp_get_vmpck(snp_dev);
+
+	dev_alert(snp_dev->dev, "Disabling vmpck_id %u to prevent IV reuse.\n",
+		  snp_dev->vmpck_id);
+	memzero_explicit(key, VMPCK_KEY_LEN);
 }
 
 static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
+	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
 	u64 count;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
-	count = *snp_dev->os_area_msg_seqno;
+	count = *os_area_msg_seqno;
 
 	return count + 1;
 }
@@ -137,11 +146,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 
 static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
 {
+	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
+
 	/*
 	 * The counter is also incremented by the PSP, so increment it by 2
 	 * and save in secrets page.
 	 */
-	*snp_dev->os_area_msg_seqno += 2;
+	*os_area_msg_seqno += 2;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -151,15 +162,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
+static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 {
 	struct aesgcm_ctx *ctx;
+	u8 *key;
+
+	if (snp_is_vmpck_empty(snp_dev)) {
+		pr_err("VM communication key VMPCK%u is null\n", vmpck_id);
+		return NULL;
+	}
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
 
-	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
+	key = snp_get_vmpck(snp_dev);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
 		pr_err("Crypto context initialization failed\n");
 		kfree(ctx);
 		return NULL;
@@ -589,7 +607,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	mutex_lock(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		mutex_unlock(&snp_cmd_mutex);
 		return -ENOTTY;
@@ -666,32 +684,14 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
-	u8 *key = NULL;
+	if (WARN_ON((vmpck_id + 1) > VMPCK_MAX_NUM))
+		return false;
 
-	switch (id) {
-	case 0:
-		*seqno = &layout->os_area.msg_seqno_0;
-		key = layout->vmpck0;
-		break;
-	case 1:
-		*seqno = &layout->os_area.msg_seqno_1;
-		key = layout->vmpck1;
-		break;
-	case 2:
-		*seqno = &layout->os_area.msg_seqno_2;
-		key = layout->vmpck2;
-		break;
-	case 3:
-		*seqno = &layout->os_area.msg_seqno_3;
-		key = layout->vmpck3;
-		break;
-	default:
-		break;
-	}
+	dev->vmpck_id = vmpck_id;
 
-	return key;
+	return true;
 }
 
 struct snp_msg_report_resp_hdr {
@@ -727,7 +727,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -847,21 +847,20 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 
 	ret = -EINVAL;
-	snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
-	if (!snp_dev->vmpck) {
-		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
+	snp_dev->layout = layout;
+	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
+		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
+	if (snp_is_vmpck_empty(snp_dev)) {
+		dev_err(dev, "vmpck id %u is null\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	snp_dev->layout = layout;
 
 	/* Allocate the shared page used for the request and response message. */
 	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
@@ -877,7 +876,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	snp_dev->ctx = snp_init_crypto(snp_dev);
 	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
@@ -902,7 +901,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-- 
2.34.1


