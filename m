Return-Path: <kvm+bounces-20254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E480B9125B4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99E93282F00
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B14315F40C;
	Fri, 21 Jun 2024 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JYNg6HK6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FE115ADBB;
	Fri, 21 Jun 2024 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973596; cv=fail; b=uyIfBpDmVpoCWoabwSu4v/WKqkkQbiuxzMTpF1p3gz5TnkTBDl01qpSjKJPIXsa5JEEBxBefWP9V6PM3b4XK/Y8OBWt+RS1uONbHTjvWTdpGsxDpNnzfay9/dBPna9slcYowJwDKP6XbYnN/v657vy9RwYud/ws1ki8D1c82Tm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973596; c=relaxed/simple;
	bh=MVToh/UKrGa8buheEVhhEm5acdBovufkYy4bO19fGV4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myaAGbLj2QtilmHZ6caFRTFcgHICkjr8ZBp6s2M0Zt6H+q5bYzlKK/7o26mF7FehPVL0dkUrrfifUhfSsdzOA+21xp7yOosb+4abrKGZwCfQf/DtePiLhc6mvBuagfE8QVEZ66WH820Zpc2twg4KFCsiXUpGnXwaclHfYg6nL34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JYNg6HK6; arc=fail smtp.client-ip=40.107.220.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLAnjYIid1w01tnrZfrkN8MaExx3hJUVhruzeTjtCzBN0n2oHDMkla09fGgf/HTZl8FGOWZ86stivUhMYDHSKu9c/AaW7qF8rmSHtYrwSl8/SHjX3aeqc5hVzgN9ljd1TKKvNHs32zzwlQN4lCaOyZNbEN1Qk/Ne2SCX3j7JScNTW6VrsKHaUbuu3Zu2UpmZds58ZZ56qfwqycguPKtOIrvrEXx3AuePyzPV5EDlY9BDCW1nyLmOtDrgb5XrxoQHzvaQ7znosdPSwWxOOTJ8N5jCgtv8AZaVFRZJXGm7lFQz4pV/cH4HsO26Xn9djeHEn18rfSfEHiE+2DYKERFv5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0gGWdFUXjk6iboDQWBHyOtK+Nmee2mnFr1u3Y9qIgE=;
 b=fK5bSNCXt1sCsCzrreYK8+QgzSC7F8KZgB8F9CcWGlIvU3fN4WWxRNKqUi4k3lej8iaPY6oqJGHJ5xuTrf2MHuQwCfxr2HC4AYHmxOMAvMr8JDu8tq8O0qQMyKaPqWnne/mEDqKD24VCwghWoOzTZaADIBL0jpg4jgGmkm9ABaaMfx6xrnLzgvxnUJTVy6Cpk03getXOrprNXCQEMJkmZF8pLOYtSZZQSEiX9GgBhUJayT/L1e1ed83+JLEQzgJeffAaAH30gSpb+bUKfoljrYmlmjVGdPFXX8RQBFkUrASRX3HIUqYXMmAyQ+cXA2MYiOZ1y/YKrmOw/80OkWzV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0gGWdFUXjk6iboDQWBHyOtK+Nmee2mnFr1u3Y9qIgE=;
 b=JYNg6HK6oR9jruS0wTL/5fLR+T4SOsID1gr10FiNXH/mWlk6d5VJbBQAqt8XAkuhXmNfU17RlIwk6FFsKf/AS5EjAnIoaWLE2VQuAMtBFBEAthieebbJv0TCXDWEj/y9gfW+cn7qfn9zdZBxmHDTb9C9wPhAJjUQe56nFDInYVA=
Received: from SN1PR12CA0099.namprd12.prod.outlook.com (2603:10b6:802:21::34)
 by MN0PR12MB6367.namprd12.prod.outlook.com (2603:10b6:208:3d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 12:39:51 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:802:21:cafe::86) by SN1PR12CA0099.outlook.office365.com
 (2603:10b6:802:21::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:51 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:47 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 07/24] virt: sev-guest: Store VMPCK index to SNP guest device structure
Date: Fri, 21 Jun 2024 18:08:46 +0530
Message-ID: <20240621123903.2411843-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|MN0PR12MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 6caf80db-1ce0-414f-1519-08dc91ef3eda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|82310400023|376011|1800799021|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7T1ozoEVgZoyJ0qZV65V9gY253auZpzYJFVGi4+HetifzNFuYPOhK1Gdg3Rv?=
 =?us-ascii?Q?UaOVJ+JZ64nO/YaWhqp2/2wB1AYxdQlUnge28ewlYbIT8YNepqakS9yBMG9o?=
 =?us-ascii?Q?poveFV5mtaQiGWjHDkME0ve0VwEo1Ips0fIqzpTWZTNIaRY8hJAee1lMIi+V?=
 =?us-ascii?Q?/MNVqPxXGgnqlZbDRa7JRrrdlHw7yf4nUfSRhJgeS9WMsBjryfVTRfQhlkRs?=
 =?us-ascii?Q?F+4oG/479swwSnOP2xC4QaSz+6opRIXesbK+LkprcB2oYTm2Xd0z19f0TYaq?=
 =?us-ascii?Q?DpC2UHAox6lc0lXUB4MfEMql1DGPZ37WvaW/9aqa3o+PYlrJIMtJLq7UpB2R?=
 =?us-ascii?Q?X7A8Ud1B1+19h+XRmc/+tDuACvVCaB7xK+g8wDQ2e/MC9rXs+PfAatAubpXa?=
 =?us-ascii?Q?6GtrFZ7TzTIyV3IMmJd8ov9mRbfql3jBgbli82s6DdKpoT4KXkrFCol5pOgw?=
 =?us-ascii?Q?vec4S9eiVerDZtwxu/DFmMFIqXGJFjszaGmX/3WIp0HoH51NRCMQq2+Bnha7?=
 =?us-ascii?Q?wtAMt0i9mswhrwPYBrUvmmYOYmPRkIfedk5GdTWR4QSlpWhkCEKiZnBXdbzN?=
 =?us-ascii?Q?yRpDs//leuQYcnHDKwjDAwQTGWoX9S/0dxyUWD0N7g/WUvBaaWvMGfLv3yKm?=
 =?us-ascii?Q?Ndg5v6NgUzPxhkWnBD1aeoXw+MgzmgTvePu83DuwLKhqWiTDCNwYUztVm0tC?=
 =?us-ascii?Q?n7QtLW1yQ2oE2c5YIahKbma92bno3Qyls+7lYg67wTrauwa1R97ZEOK7zWRQ?=
 =?us-ascii?Q?ASVsyOX2PZ250HJlVCoQgXYH4X0aVN2gVGaziVJ1YruCIgNE6h0aioRWm3Ok?=
 =?us-ascii?Q?achnqJu0LzbopH7qmlR8UyAne7HQWin+6QPtcJ4Gm70XG/jxhkRV9Bx/8BzQ?=
 =?us-ascii?Q?0S0DFowvfb31C8oJFuV8RMcZBtcZ+rhCifE0ei9E7xDtLPKPEL0DOady/xKl?=
 =?us-ascii?Q?qD9/M8u2YApZnpD1UISTBl6m1+LEun/578mlzSlFo2O3UCP291WPFr+aegC4?=
 =?us-ascii?Q?UEC5whDOlfU302fWUFGCziRPhfocDGytuaZpaW2VGo89wNdUg0bgUp1DmwMw?=
 =?us-ascii?Q?qk/GBMKEmFat8Ehr6c3BMwvI7piXyZhA1OWPLO8MaY83jMfp1MFiFOoyR1V1?=
 =?us-ascii?Q?RPLsM+S//rjtXLW/tcK42L5Uoq6iWBtAldWOzT4CnC6znverIcSUPmUlpAXD?=
 =?us-ascii?Q?Q3rwFew5/ZvgYelv4WlkcoCaEctP8nAwO3baSfx9qy0fGQdQDymWLI82OA7m?=
 =?us-ascii?Q?XfX06EVvrB745FFTI8lHQOJO1oe2HKMPQbF8tWViwzS01/Zf4d15S0FTTiCw?=
 =?us-ascii?Q?3yqFzKlQbBHLtdX/AEsrWfHzNVTdxYXWiLx7aiyHc6pcEFY70JJmIy8HJqDt?=
 =?us-ascii?Q?1fEXCXPE5uYWOkM5eA0oNioVT+qPwxxK3N2EQ9WMfri5/B4cAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(7416011)(82310400023)(376011)(1800799021)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:51.6052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6caf80db-1ce0-414f-1519-08dc91ef3eda
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6367

Currently, SEV guest driver retrieves the pointers to VMPCK and
os_area_msg_seqno from the secrets page. In order to get rid of this
dependency, use vmpck_id to index the appropriate key and the corresponding
message sequence number.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 74 ++++++++++++-------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index a5602c84769f..fcd61df08702 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -58,8 +58,7 @@ struct snp_guest_dev {
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
 	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
+	unsigned int vmpck_id;
 };
 
 /*
@@ -69,21 +68,24 @@ struct snp_guest_dev {
  * Should the default key be wiped (see snp_disable_vmpck()), this parameter
  * allows for using one of the remaining VMPCKs.
  */
-static int vmpck_id = -1;
-module_param(vmpck_id, int, 0444);
+static u32 vmpck_id = VMPCK_MAX_NUM;
+module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
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
@@ -105,28 +107,24 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
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
+	dev_alert(snp_dev->dev, "Disabling VMPCK%u communication key to prevent IV reuse.\n",
+		  snp_dev->vmpck_id);
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
@@ -150,7 +148,7 @@ static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * The counter is also incremented by the PSP, so increment it by 2
 	 * and save in secrets page.
 	 */
-	*snp_dev->os_area_msg_seqno += 2;
+	snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] += 2;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -160,15 +158,17 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
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
@@ -676,13 +676,14 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
+static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
-	if (!(id < VMPCK_MAX_NUM))
-		return NULL;
+	if (!(vmpck_id < VMPCK_MAX_NUM))
+		return false;
+
+	dev->vmpck_id = vmpck_id;
 
-	*seqno = &secrets->os_area.msg_seqno[id];
-	return secrets->vmpck[id];
+	return true;
 }
 
 struct snp_msg_report_resp_hdr {
@@ -1015,25 +1016,24 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 
 	/* Adjust the default VMPCK key based on the executing VMPL level */
-	if (vmpck_id == -1)
+	if (vmpck_id == VMPCK_MAX_NUM)
 		vmpck_id = snp_vmpl;
 
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
@@ -1058,7 +1058,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	snp_dev->ctx = snp_init_crypto(snp_dev);
 	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
-- 
2.34.1


