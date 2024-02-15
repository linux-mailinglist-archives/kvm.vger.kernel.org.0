Return-Path: <kvm+bounces-8750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BDF8561A0
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3122A282775
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CE512C7F5;
	Thu, 15 Feb 2024 11:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mNM56UJN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4971E12C559;
	Thu, 15 Feb 2024 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996739; cv=fail; b=QrzvZK5Btitz82sShCOFFRxDFpVXRRB7kvJ37oam6EM88+KGrhAp5AD4pjY6MYSowLR0TWS21iSwNX52wTw5Uz2LCLtfOWjt7fLb8HnYFgueDLvPDmdHjj3muzGMZbYzg8CyUtSUjvZZIPAPEPg87HvUTGGBiQbTuxOLwMzJ43c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996739; c=relaxed/simple;
	bh=B8iMShVIH0p4vXtok1I+NjcStMI2IY3/nDRpR3w/gdc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcyIvd2a6Omyv5frHND8An0hyCRXG/DlozdP84z5VlMXdBlmYGW5B1vOjG0dAs+lXl/3NKqWwCoke1krKD58LbfO2kTb4yUYxlbPa8AuBDiZhuO1Er5iYLwoUBNbIcQO1vQJF9UjgY1XxiVr6gTckCnR0An9trlK9UgognYrQrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mNM56UJN; arc=fail smtp.client-ip=40.107.95.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT9LDwG4M6XjQb8ZWLDu59vyPL/OvS1CpAsyoUY0R2m3UvJdQG+h+Xyp13iHmNxSHdJFsPnstbeawDWof532ifwvPeCjdO2NNsT9sCAAoc7K0RoUMynn5c32BpZDAuJIksgtWUySvu2Qp2N2pU6rb50mtfIEt+YPDEj52LqKrQBtcG9yBvtph9lBsCIErHkEeZnF7HQNSmNZJgP0h77V+e/65w17ZMYwR7fDxdY1D6y76vI7L71pb4j3TprQ2hRBp1oHrw3PfQ+3XbiE8ymYPQQWzkpK+rxFCREd+Rz7ZyCDgq1FhDHITu19SEm9rhWAaoq5rEYyoVTv4pGKErHMcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zfNJD1kkN9l4s3NElv1WbFtKhaBQ6JHKgcCta+N1vk=;
 b=LouNWdrCL96CUz10Dx1yYNWUM1L5dT5/kryYrRhpXO+zUiPrd1krhZiZF+2D4Bg0QdZe5An9O6Vt2/LLED2dd2dc98DJb+kSoQJ41PH5duxDHUN0FMm1KwIEzq1G1S104w3KzsQFClSSRKn0wRCIhK7ryOBh33mX+uGD8ZAudWexghFlc4aT0ABRbYWdYTCV8EPxuAD1F1Iao18oZxvASIf91KvYeLCC2rMoOq82LrEXpQbzw8EKVHnrqyJK7w963i6rhsWAs2a1bYV1rGkmlqoDeI3GZvK+D5iHapuqSaNQQv1y9vRgMo6+1j/WKFkrLb0M2GVgSdu5JJCiDNr5Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zfNJD1kkN9l4s3NElv1WbFtKhaBQ6JHKgcCta+N1vk=;
 b=mNM56UJNYh05Yvyp6LSXqw4uI1890ZX84W4PiKd8dWnE5L5kS/++lrK5yJdL8Fa75W/gCtG3bSceBHMaSP1ORs+DWS5YnUtNDUXEF2aLsXSQui909SvVylsdg008FpL4SDoBN1Qr8JblrQc0sOIp/vjGM7R1jt4d90uh0iRhWFE=
Received: from BL1PR13CA0194.namprd13.prod.outlook.com (2603:10b6:208:2be::19)
 by PH0PR12MB8150.namprd12.prod.outlook.com (2603:10b6:510:293::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Thu, 15 Feb
 2024 11:32:13 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:208:2be:cafe::a6) by BL1PR13CA0194.outlook.office365.com
 (2603:10b6:208:2be::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.8 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:09 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev struct
Date: Thu, 15 Feb 2024 17:01:16 +0530
Message-ID: <20240215113128.275608-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|PH0PR12MB8150:EE_
X-MS-Office365-Filtering-Correlation-Id: fe385d64-df56-4a32-58a9-08dc2e19c131
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GsQtf9+e6D9EFG6qFE1Rw6EvFy0clhXencmJQdyessRvrqGF1Mx6LY3RK4LNWSo68SelY+NHhqW4WEpCFdw7MegsJ3MF6LeuZmZ9Q0/OGjH6l1+dFxlm+DcDLGcP3lI3rrb/WZraQCt1lcZF0zJgxsbAhD3LueTGqB+FGNndS2wLPqo5QFO5Mee5j2LX98E0QHh/7WrmiKfWSaWEosFsuo6lnnSMs3JP1sDILQW39EXA9TGEal94zrBog6aID+R7shug+t+oUUIFIaXo9rtJmyafl3vrK3BrkgbecIlmaozy9lLkzIDWQgEnlgqTx4+XP18/sxvhaxcBvmVLM9epQw7CnW+rDDViRQ0vLtIzw/8gmtq+FKd2BUBPtsWSCiKvuziRAn/uyJdpeuL9p7g7h9GkAt5rbL8ly4WH3XkasCpW3eCpqyGS4zYt2ulvgMMidkbQxqplwHMJffzeH87AzFsFSt5QXWIXghdUBFIjl0DkgA8kwjL5Clv0J1dUwOsIj0VuotW4vCVyBjILMYb1wgNvH8TwdkVtBbs4p5vbxfGEeeotMRp0p1Fo7+XSXxO/PYSN3xtrqT18lp6xiK2WIhZjNwcIMVC2guPWMh5ha4mKOPnT0PcHyc6A4ADD385Wg6klz3QrPC8r7HwB+7iWHyb54PUn+SvKogDUHW/Gq8o=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(396003)(346002)(230922051799003)(82310400011)(186009)(451199024)(1800799012)(64100799003)(36860700004)(46966006)(40470700004)(5660300002)(70206006)(8676002)(8936002)(7416002)(82740400003)(4326008)(478600001)(2906002)(2616005)(336012)(426003)(7696005)(16526019)(1076003)(26005)(356005)(83380400001)(81166007)(70586007)(36756003)(54906003)(316002)(6666004)(41300700001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:12.9595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe385d64-df56-4a32-58a9-08dc2e19c131
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8150

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
index 0c0b11af9f89..e4f52a606487 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -135,6 +135,7 @@ struct secrets_os_area {
 } __packed;
 
 #define VMPCK_KEY_LEN		32
+#define VMPCK_MAX_NUM		4
 
 /* See the SNP spec version 0.9 for secrets page format */
 struct snp_secrets_page_layout {
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 596cec03f9eb..646eb215f3c7 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -55,8 +55,7 @@ struct snp_guest_dev {
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
 	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
+	unsigned int vmpck_id;
 };
 
 static u32 vmpck_id;
@@ -66,14 +65,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
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
@@ -95,20 +102,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
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
@@ -136,11 +145,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 
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
@@ -150,15 +161,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
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
@@ -590,7 +608,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	mutex_lock(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		mutex_unlock(&snp_cmd_mutex);
 		return -ENOTTY;
@@ -667,32 +685,14 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
+static bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
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
@@ -728,7 +728,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -848,21 +848,20 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
@@ -878,7 +877,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	snp_dev->ctx = snp_init_crypto(snp_dev);
 	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
@@ -903,7 +902,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-- 
2.34.1


