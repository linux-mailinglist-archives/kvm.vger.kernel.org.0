Return-Path: <kvm+bounces-18474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2D38D5969
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD2DA1C2378A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF0C78C98;
	Fri, 31 May 2024 04:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kO0uEPg4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08D6208A9;
	Fri, 31 May 2024 04:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129986; cv=fail; b=LkogPRt7s3HBvau/N9EuYsXHqbXlMJM9Fvptt8GwVXWJuJQ7lMOIPsDAbhWjhPm/fsAYYJtuXyRfubuQ9j4PR7SZqDion9OXjTcG3yvDbCT/TvJL1FJBd7T430COzJySrcD1+8AnTy9jpq+/7MRYxGL/NwTE4QRTWEvU2f6uF/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129986; c=relaxed/simple;
	bh=N0jmctl1Y5kfWALQdfPDmVNGaPqj8pTAjcDr4R2kApc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPDksOtP7phCDzT2yqjvtmaDXB9iDruT2jruCwF6RkOBXxwNjbZG4KOTWASDPuM4ILJ0RcEYskpMNwvZSr8jOCwSahEhtAx0/kXC+1GD4frIRtTKCgUnjPz0pKno66lKU9zXSs53wPwQ7DseWJ9NcG8GN3muuUCphsGQBNNTfpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kO0uEPg4; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6zlPd6d7n3GrSVaObjTs/ywu36S6Wwq17p8i/4G0VFoChd6kwFh88deETCIKbkyxxsiqopgqG3tMgCHfUtpa9p/7qYH0DA74ERLwzRxlC9xPUFVHqcRFpKcCfTNIWJlHJ1OXR1UGE8LznGR/S/z7LV8YExuQyz2O0QwGxCRvwTM42riHWHcQjahkg6Sn+bxCA/o3EKbJJ7fHhUxuVgI/i2zWseZXy5mHArIEycrkQLAYz3S9jqsZEHpHC4sx1K95J1xZZVaDUTboamTO1N4rywpAl4pONbMygbr0tWuwjBtoLZFXXY7CIKvgCtCy1bwmnXeKpk/zcepBBaKCrnDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5ZXXzrDtAq57WfO5Hy/z2mbdi69I8PVwNWrEhm1oOA=;
 b=XQ82A53NW9++5KOpsqK2yV5zjYBEYRngJWZSP5B830bFwRAzCcap/nRL34TtCA4WHWYBvYyBTpaVZ9LkLgUHYfOSdD2DoLgkT+B9aFqv2pfowSSEQgH6D54DgM8tluWBFWcg2J/YyQJYgk45p/zk2vCIjspQbj1rTCcmeKqwfwQmhSiq8uiydq0bwssF/4lhtDWKL8aokPlGv6ldvh++OYtwHaoS26LSs3tWKG8CpsXuuZjACpnEuJ0msPYqqwYws1Wvn/1nBoDg43JT/hDsUhy4XBqGwMTz2fyLmQ8iE8/lcIXg5D+ZRmW8VQ5Knrk6470zF7TygetIpngEsHwBLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5ZXXzrDtAq57WfO5Hy/z2mbdi69I8PVwNWrEhm1oOA=;
 b=kO0uEPg42EdpQEtkiLDQGksW3Pk15UzdNZcv5IV9VLUED2Z/cCgPN9pZQ0U/hoonQHzcGBLzi+MZnVuuD9DXWHVeR4+raJ/lXN2Fh0Yzaaahj696YohqiO0oM5xoku981JrLK5h0JY6jeRDh3pgVrUZm7y6VXqo75KOHFA7vbIU=
Received: from DM6PR08CA0039.namprd08.prod.outlook.com (2603:10b6:5:1e0::13)
 by DS7PR12MB8084.namprd12.prod.outlook.com (2603:10b6:8:ef::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.24; Fri, 31 May 2024 04:33:01 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::28) by DM6PR08CA0039.outlook.office365.com
 (2603:10b6:5:1e0::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Fri, 31 May 2024 04:33:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:01 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:32:55 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 07/24] virt: sev-guest: Store VMPCK index to SNP guest device structure
Date: Fri, 31 May 2024 10:00:21 +0530
Message-ID: <20240531043038.3370793-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|DS7PR12MB8084:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ba2f27-628a-4113-75c2-08dc812ac1ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?msFVR1PLRovHjW48jNxxzv8NmpcPAbS39/tVAImxMrnkMO5Dh/BngvEJ2OLg?=
 =?us-ascii?Q?QkstTt2zAlTpTaeh9pr3RxL99aPGqh0V86cQ+nSci7iOabvwt/lBml7kyAFq?=
 =?us-ascii?Q?BpyTAJT2OkVJ8AGDqBCb79agLqrVK36lHlM5IhjlexVmB1MZnOWsB1JoTtf/?=
 =?us-ascii?Q?IXNgyLatbHLIXowjdw7FwdIOhnX3n+8QXNmlDplkGFrMdfZ9cIvNCTduLPff?=
 =?us-ascii?Q?Bte0a3yVsDe80tTZ+Qic/KzGJEn4mU4MeOZ3wZgSpo9c9M7JfcMMnTwUb0CR?=
 =?us-ascii?Q?3p3dvkaN0oE4fOwQpnalBRm+suk1cj+Sw18xGx8mLgMfQKwNtY1CdZ5izEZD?=
 =?us-ascii?Q?oPNEK+5wNqKhBGg233Bw+dxvqykQeLdeL7FCYhFRJdsFH37KuN29SgdCuzIN?=
 =?us-ascii?Q?yH7ZjBPrfXis4D+XRGP/Em+3Awfsubederu6yJRMc7ikN1lRCQde7fief271?=
 =?us-ascii?Q?u1cotEf6M89bz1+uyJSieQlh5dk/mpGTxt/KNrOyBIgC0+FDTVXR6wf055Yx?=
 =?us-ascii?Q?ULzOvBuvGyvtHMK0Lo8xuE0lCWtl1aVNNy7FoQDZR2xaM+JEcumS7p4EjKJC?=
 =?us-ascii?Q?zjdNR6BUC2IRakNzxhAXdfxogr0zsQVNT3eFFHK5elNjR46tHUbm4CYME54g?=
 =?us-ascii?Q?CF+DjHu6Uzm1dthMpTajllaC5cnLx8BBb3nqFmjHB7LuP/IB0F+OWCsbAplo?=
 =?us-ascii?Q?teeOUQUoUsvR373/+9841eyxVvelwWNZ84uR+BVZodaXRA74DD/bywRdqaZH?=
 =?us-ascii?Q?GF+SHADIVMSLVmKf1+Kv5UgyrBXCeSk1DYdDQgsa/8Q3zGD291TN4L0Sd0Rj?=
 =?us-ascii?Q?0dTN77GbX2eLHs3/TAsr5iUc5tlX81DenKf6jD/u8amzq419gcC2HKAcaAak?=
 =?us-ascii?Q?2905hb64KE3MYLY1vcz1/OqKKAP6pKua7rt2H4Q1uZOO1n8+8YwMfXIMz+pa?=
 =?us-ascii?Q?LgZf9rY/QUiLthXND4wJssUuHc+kMIs86B9zhUJr33j+JTACLbfpq52sGJ0o?=
 =?us-ascii?Q?kdilsD59DIzCgXcG16mz706FgIw1nmLEnB5tuc971GjvQwnAhXwNBJniZHGr?=
 =?us-ascii?Q?f1lyZDCZvwOu8cQld9InbSAQtJpnoElp0J0IGc7RPS8rpIOt796PxJhT8CGk?=
 =?us-ascii?Q?tqP/zZqA1pg8SkRMz9He+geP2A3X+XnmV0+4PLTqjbvvWMF661XyhmW/Je9U?=
 =?us-ascii?Q?2qr34zQGYwyRxoIJOkrr3ckgu3fpbBYz3Z8CHOGsUr/swhwlnPMIffel2+L+?=
 =?us-ascii?Q?VpYs5r3rTQ8OElnauZNYYj2qeG2IqFryCPTSG407YlqnUGcOjdkd1CTANQbR?=
 =?us-ascii?Q?47l4+k6L0vKhBmIvtrJHwBHNmPKbTl3dG5Y1DxNr5vEOp8iCRkjHBWoa7QUU?=
 =?us-ascii?Q?vkcJBOSoJPBJybpuDPVAyLpfubiA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:01.7032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ba2f27-628a-4113-75c2-08dc812ac1ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8084

Currently, SEV guest driver retrieves the pointers to VMPCK and
os_area_msg_seqno from the secrets page. In order to get rid of this
dependency, use vmpck_id to index the appropriate key and the corresponding
message sequence number.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 67 ++++++++++++-------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index a3c0b22d2e14..0729d0b73495 100644
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
@@ -66,14 +65,17 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
+static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
+{
+	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
+}
+
 static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
+	u8 *key = get_vmpck(snp_dev);
 
-	if (snp_dev->vmpck)
-		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
-
-	return true;
+	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
 }
 
 /*
@@ -95,28 +97,23 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling VMPCK%d to prevent IV reuse.\n",
-		  vmpck_id);
-	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
-	snp_dev->vmpck = NULL;
-}
-
-static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	u64 count;
-
-	lockdep_assert_held(&snp_cmd_mutex);
+	u8 *key = get_vmpck(snp_dev);
 
-	/* Read the current message sequence counter from secrets pages */
-	count = *snp_dev->os_area_msg_seqno;
+	if (is_vmpck_empty(snp_dev))
+		return;
 
-	return count + 1;
+	dev_alert(snp_dev->dev, "Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
+	memzero_explicit(key, VMPCK_KEY_LEN);
 }
 
 /* Return a non-zero on success */
 static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
-	u64 count = __snp_get_msg_seqno(snp_dev);
+	u64 count;
+
+	lockdep_assert_held(&snp_cmd_mutex);
+
+	count = snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] + 1;
 
 	/*
 	 * The message sequence counter for the SNP guest request is a  64-bit
@@ -140,7 +137,7 @@ static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * The counter is also incremented by the PSP, so increment it by 2
 	 * and save in secrets page.
 	 */
-	*snp_dev->os_area_msg_seqno += 2;
+	snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] += 2;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -150,15 +147,17 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
+static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 {
 	struct aesgcm_ctx *ctx;
+	u8 *key;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
 
-	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
+	key = get_vmpck(snp_dev);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
 		pr_err("Crypto context initialization failed\n");
 		kfree(ctx);
 		return NULL;
@@ -666,13 +665,14 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
+static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
-	if ((id + 1) > VMPCK_MAX_NUM)
-		return NULL;
+	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
+		return false;
+
+	dev->vmpck_id = vmpck_id;
 
-	*seqno = &secrets->os_area.msg_seqno[id];
-	return secrets->vmpck[id];
+	return true;
 }
 
 struct snp_msg_report_resp_hdr {
@@ -828,21 +828,20 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 
 	ret = -EINVAL;
-	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
-	if (!snp_dev->vmpck) {
+	snp_dev->secrets = secrets;
+	if (!assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
 	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
+		dev_err(dev, "Empty VMPCK%d communication key\n", snp_dev->vmpck_id);
 		goto e_unmap;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	snp_dev->secrets = secrets;
 
 	/* Allocate secret request and response message for double buffering */
 	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
@@ -867,7 +866,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	snp_dev->ctx = snp_init_crypto(snp_dev);
 	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
-- 
2.34.1


