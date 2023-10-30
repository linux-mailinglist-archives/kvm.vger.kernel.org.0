Return-Path: <kvm+bounces-44-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D891F7DB38A
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 082761C209C7
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22954A1B;
	Mon, 30 Oct 2023 06:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VL9YDlKp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD5A1871
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:20 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2D9109;
	Sun, 29 Oct 2023 23:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCSrC4Csnv/MoH1Re/cL3xh75R2zpptWlZEiY4sRqIDzOhKLk2yKxUAfHYD4IIt1Ei/rnyoj4qG2pQYiqVpLMy38+ERT6HVJGRIGufcJ9AAiICaqeSIKL4ff3oRhqGUxFSJPmzMgCtdsWzVEYdbLgI5OOgZPimHelW5objEs8UMh3g58NH4JAvHBeKrZ9aY8Wnb9kiCZkrVhnSZT6ubnCuqiDXd5ZbBxm6KjuFuT6O4Ugvl2rPFBUebQ9lf46TCWiawzYqSas5VDfo+bMu90VMzsIrimAwipvcG02rKnuLgauSADJNqM4XJNm2ZL2D79ij9EA6KF5ckjMxcQXZ+r6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5C9YlLNWvr9aZipyWk6dgDei/vUf8ig2OfXDucLg9I=;
 b=lSoxohTKZhAxCFItCLIn6JQZHaOTOHZGa1T5iyNI6cT7ddeo5W7NsMXddWZb/KmyohfZbBuJK/pu2HDNztImtq+a2GsRNnYhs4MheRsJpvqZOqh6foJH7MPbj8pdqULJmO1UbEbdTZD8hA0WSneGxqCnQNcU8AeCUJ0mp1RyUhHua+Vt98r337L7AqKPU7Y+gRrrFmF+ghkQwzkxaReStL069yD/4ZzHTpOfi1/vLfUX6nQqaEnIW9u+1iRjcRRWzt+2fNSffldRMdv+dzuNpy77cFqIl+PNyk21ZbJVXkH8gD3Nv3axohdZXe0xP3+zHgq8pqrKj3c9w3oedreeIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5C9YlLNWvr9aZipyWk6dgDei/vUf8ig2OfXDucLg9I=;
 b=VL9YDlKpElcWVbfctLJtIBzZnG4gvOpuWh60bVA8P/2PhMG4YTEPDfusCVa6FXFqD+GM+5E+DOC/0CzQGE0XYuHJmTQ4lmuO8rSpa9RlkTQXEo/WNxgkab2i17PrIT7Icak+noTjCpdQvtITebEmthM64Ris+4STnbKx3wPTL+4=
Received: from MN2PR20CA0065.namprd20.prod.outlook.com (2603:10b6:208:235::34)
 by DM4PR12MB6112.namprd12.prod.outlook.com (2603:10b6:8:aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.22; Mon, 30 Oct 2023 06:38:14 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::6a) by MN2PR20CA0065.outlook.office365.com
 (2603:10b6:208:235::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:38:14 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:09 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 05/14] virt: sev-guest: Add vmpck_id to snp_guest_dev struct
Date: Mon, 30 Oct 2023 12:06:43 +0530
Message-ID: <20231030063652.68675-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|DM4PR12MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 1725621f-884c-4c5d-5310-08dbd912cb16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X2gSu3C29TmlVWgwd88BoUPP5hG5dkERh02HGNft0GNxTgDIzvSc2RCmD1cKMtb0ntyEYiajToW0hZQBLlDiaL7CvDseb+q6RrtTNeEw9Y0PVHgsJ/nG2kiywugggZM1Xtys2UT2I3+JpPGxcHEi/gZz/O4Uy22r8pTk0nzUxfszFM6ASuEEVyBuJEx+i/p65dU136jobyx2mmAQW4ZyVulRt+dOV/ZBreaZ+AlxMqXfFugDyuUERw0SJ84KIXFdoTWg32DlXw7y/3f6IYWKdYcp8XREbrzAT7SDG0RjOlYL+3anONfUxe46i37KKn95Ttx5Te8NDu3bLV2x0vWZGGODfzUGRw05yNYkFLWrBrCxU0emeOqSlVRY1NYM8iGTD5FNxRob9gJ2+RK/YiCenL7j/+99hweTmGo9aRLN0KU6vRvYxcyXGUQkhuBPPxDs/NyHppiY96yjkpxpFqtJc3O6Gb0Rbtq6bH2DD+JpKF2YmSlPQs+t/oypX0SzIpoef6PaYTgOnMuasJH4Hlehd2z/drE9z3Lup8LVGwsX2MQn3LbyviRu8Z7nuAWDKk05vBXw1BSV9OxRXAxE910L2zuE9FoiaGu+yXxoncCFFyh2/nOPRklfUzuK0fdXS6HUq55oXp5kn+YvUREeBI90GlRwGVcaUfEnvOeXz8ozDJKKFfcLr4YxpSGSlSxplTy5h8l0MDR8rq2l1APrrbaoTgugXhnSg/lkA0PP9JCIBsd7nuGlyZ+21nBIcnbU9e6sWl7Ib5X5dhg0QobY8utD5g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(186009)(82310400011)(1800799009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(2906002)(83380400001)(7416002)(47076005)(36860700001)(81166007)(426003)(40480700001)(336012)(5660300002)(1076003)(356005)(2616005)(82740400003)(41300700001)(110136005)(316002)(70586007)(54906003)(40460700003)(6666004)(7696005)(8676002)(16526019)(26005)(478600001)(70206006)(4326008)(8936002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:14.2465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1725621f-884c-4c5d-5310-08dbd912cb16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6112

Drop vmpck and os_area_msg_seqno pointers so that secret page layout
does not need to be exposed to the sev-guest driver after the rework.
Instead, add helper APIs to access vmpck and os_area_msg_seqno when
needed.

Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
preparation for moving to sev.c.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 85 ++++++++++++-------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 5801dd52ffdf..4dd094c73e2f 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -50,8 +50,7 @@ struct snp_guest_dev {
 
 	struct snp_secrets_page_layout *layout;
 	struct snp_req_data input;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
+	unsigned int vmpck_id;
 };
 
 static u32 vmpck_id;
@@ -61,14 +60,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
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
@@ -90,20 +97,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
+	u8 *key = snp_get_vmpck(snp_dev);
+
 	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
-		  vmpck_id);
-	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
-	snp_dev->vmpck = NULL;
+		  snp_dev->vmpck_id);
+	memzero_explicit(key, VMPCK_KEY_LEN);
 }
 
 static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
+	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
 	u64 count;
 
 	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
-	count = *snp_dev->os_area_msg_seqno;
+	count = *os_area_msg_seqno;
 
 	return count + 1;
 }
@@ -131,11 +140,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 
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
@@ -145,15 +156,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
+static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 {
 	struct aesgcm_ctx *ctx;
+	u8 *key;
+
+	if (snp_is_vmpck_empty(snp_dev)) {
+		pr_err("SNP: vmpck id %d is null\n", snp_dev->vmpck_id);
+		return NULL;
+	}
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
 
-	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
+	key = snp_get_vmpck(snp_dev);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
 		pr_err("SNP: crypto init failed\n");
 		kfree(ctx);
 		return NULL;
@@ -586,7 +604,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	mutex_lock(&snp_dev->cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		mutex_unlock(&snp_dev->cmd_mutex);
 		return -ENOTTY;
@@ -656,32 +674,14 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
+bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
 {
-	u8 *key = NULL;
+	if (WARN_ON(vmpck_id > 3))
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
 
 static int __init sev_guest_probe(struct platform_device *pdev)
@@ -713,14 +713,14 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 
 	ret = -EINVAL;
-	snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
-	if (!snp_dev->vmpck) {
+	snp_dev->layout = layout;
+	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
 		goto e_unmap;
 	}
@@ -728,7 +728,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	mutex_init(&snp_dev->cmd_mutex);
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	snp_dev->layout = layout;
 
 	/* Allocate the shared page used for the request and response message. */
 	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
@@ -744,7 +743,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	snp_dev->ctx = snp_init_crypto(snp_dev);
 	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
-- 
2.34.1


