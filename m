Return-Path: <kvm+bounces-22777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F62A9432C3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 834F0B28DBA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C75B1BE22E;
	Wed, 31 Jul 2024 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vTWzSGQY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B561BD51F;
	Wed, 31 Jul 2024 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438534; cv=fail; b=NEi3g2GDW3U9sVnaUe5Jz7d/Tu0iylbRdKuWIFyJF+fdJ+1LNwLA7imnJ2yu0rEevK7+H7alXpSRvqA2optRavJOkoUfo1v6qSxc7YOGjtkuMhY0rcVG+fe+BBH7Ek9LbHLxCt6BsOR3ezZ9t66YbeHBPkeKypr8REnPjgocHtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438534; c=relaxed/simple;
	bh=X/c1tU5wseIly3dd2hxCEg7kJ1dXU797cKl/muit0So=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUJ03evT8k6vGvqi7XTHq0/hbpV4aftFV+HA4WzmVcl1WxLRuQIMiX00vhyHRf/CgwUEMAewHbUxrb7I9owni59yyfzgPt61VwZ/t52u/5Fi2zxfXS+b+6Qekr8IcVJ2c4E74KcqU/4Lff1pDV3WKWqUe8T7K6jnN7z8kpfk0uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vTWzSGQY; arc=fail smtp.client-ip=40.107.96.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rehv2G1NDUFvCGHKzY8T3K00tjYaml23eTtYg+Fm2aTNDdnNMScosGQ6MG35zLMJaBUrma9DLc3TbxmIdqvvI4z5jwAKR7V9YfCtvfL+QYNMu6H9szy/pkBWIcdBlbMP6/MbA8+g5BIfa/vZKrxK1xZ7CnqiDLPfYYwFa9CMiSTEka0HIra/bxktdc2IhGVPWMrXyCwwRGx1JY5Rc9fX1XSeztiIfxPCt2eJoMTEjdac1ie4dKbfffvf9g7F+CWV99Cb32R6juclZRU3eTglNLsxuvnxzy5wl1rlUnGlSrPQTinir2Q4KuXev5DM9YswpJM/RAnOni4jHStaVu6bQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ut0PQbocBDA6BRrESZl3aqAZdZPopO4v1wevVq9FEc=;
 b=csq9sVhsuqY5/jxryDeA7QwNM6oskdUsfjvLfrwBNTjSlAMvW9TImkXOQkmi5FX8azN4zEhr9N/+hXmP0UDSJKBKNgV4wnoyePLcAEtbhAzamVM0oKsjaoBTzNcG8rAJ33GxT1HeSEAIc6sxiMj1F1tCIHvyT6TLA9YWqoO5kEdvqp7hV6gPXN52tA9tD3Skw+QxEjJNIHZiq9qXGPwtKNawjupVNe5misJh5M0wArSUvyKM/9GPnNv/qY3dhDb1qRipaW82on1ww/e3YVzNJu7KxiHCYAPrdKJK7hXoaO9GFbNW/MDwXXpfSX+sMH4KQH9Y/3qaw6ByxLgWlmmvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ut0PQbocBDA6BRrESZl3aqAZdZPopO4v1wevVq9FEc=;
 b=vTWzSGQYiTuW5XDdEj4GmdthVatVnwSUOhm1YiiFP+Mkb3bt30QQ86dHU/xQxhTywgJ0/dkzmJAn8tbVy6yQIFBEzIXcBlMrgu1YsgsQGtwpEpWIEBYD1HEG1BCR3cG2zyVekpgKVmeQ3vYGdijrLLU9QqbRaYQYKNBN6Z8eDyQ=
Received: from CH5PR05CA0017.namprd05.prod.outlook.com (2603:10b6:610:1f0::7)
 by SN7PR12MB8772.namprd12.prod.outlook.com (2603:10b6:806:341::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 15:08:48 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::ff) by CH5PR05CA0017.outlook.office365.com
 (2603:10b6:610:1f0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.20 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:48 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:44 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 05/20] virt: sev-guest: Use AES GCM crypto library
Date: Wed, 31 Jul 2024 20:37:56 +0530
Message-ID: <20240731150811.156771-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|SN7PR12MB8772:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d186d7-f073-4f25-a5ed-08dcb172adfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oN+HWieJAIWzLKX3MLTaQHIBB+cX9ycRjEkymXM8EGZqCcGkEDAUuu74duls?=
 =?us-ascii?Q?7x3h4NfSoVua0oJcCGGsFxZ0lflfooO8ZPoAY82xSm9liwQOIdRGssJ6ssNC?=
 =?us-ascii?Q?VVvbB8NpYBodFzFtpr0B3qQV4N2aieY2qTdjjCQdqCRa9L5j4dPzhk/rAlQg?=
 =?us-ascii?Q?QU6SiouMo1KccTIxz2QbIV/UZu4hCr7HRWi1Lkc4cZO8SGfHITDWfjW2YkwK?=
 =?us-ascii?Q?Xa5JGLEaO3mHZdpoHAIa9MxlLfcVLIsjketb8IBamIMZC7Y0OilZo020o5ny?=
 =?us-ascii?Q?zWup9omGztzWSV/g1ktGP1o4yOJQcHfO0oQnMtvnar/oIIGuJnOmLIsbYIzJ?=
 =?us-ascii?Q?LYdxhHZ6SJQrSF1+LfUQ4hxEx6ARA52HJ/ShXIeActtaYSDUd2aSexf1RAb1?=
 =?us-ascii?Q?yeMo05wq6E04jKMThkm5xgxBmSJhFuwqyzpEts1Yu8TQt0gOaWSZmXAP4Wfq?=
 =?us-ascii?Q?pUTk11c4BLbZuL3iue8Sn5QDQfghPGIqR4tnO9tHZuBRmcO24rih4GkhWAeN?=
 =?us-ascii?Q?RWgfKfUhE5ZeDFrmw86+w4xQWqSFfLFjIHZoy6VwfP3vw7B3ZpabxITT+ZHu?=
 =?us-ascii?Q?0c2O4+Gkj++TndmfrfnFS/kbRA5rqHnlPIv7CqTCEttuJV/vEtZH+ClQ9db5?=
 =?us-ascii?Q?FRYSkIHqOTUb9PH6DL6tKiw/HWF0g7idIYyDnToX0qvj93iy5ACgUXflStqi?=
 =?us-ascii?Q?skz/5WQyH5koEvRXMl3VriVLTJrsqJTHdNxIlaALUXbhvANBNsVMH8d1CuAJ?=
 =?us-ascii?Q?0R1nUUFjz1L9vqvehZWYM0kNx+FEiuDIzRDskZFwsRz9vzZpknDybaeP+Hvp?=
 =?us-ascii?Q?0wdEGWthQ1i1msyT66/6vZ2OJOdRQjdNb9NghLiq57sz6HymCHu8OAJWtz1A?=
 =?us-ascii?Q?T5iR7c9zbm2S/iGZeXCf1OQTxJxGoPfYkKI8Ckfi6l8qJqQ0hjx8z7mMduOf?=
 =?us-ascii?Q?FHrM3xina0ruLDtyMq1nS4ryT6QHwPZ1wIRBImlNC5uJXWpQNCEHdOv4Flry?=
 =?us-ascii?Q?XguGb1JMHy3HzUfStbnLagNMaFuX9gS7AokhAg/njXOhbvtG2VPl3eKIT4wm?=
 =?us-ascii?Q?1v3wcm+e29ZEzx8Q8WbLnotaXpPcH45LFELXsFnzqTsRyvRocIVYhnT9CoAA?=
 =?us-ascii?Q?9NSdmld7e+TEBYQQjnZ1o7brJZplxFkNuqS/FO3o/U685NVeOqxJ7h9rPUri?=
 =?us-ascii?Q?OL9VKgMJW12zFZ706Agv1OHVfRFIxTCVJUuUppUayQtDuYSjZ12jHieycOZW?=
 =?us-ascii?Q?tdcVbKYLgU5VCcGIhnUxCZoYPOIjzmkP7KXa5ymw5kATeZ2rNIriREKq368Q?=
 =?us-ascii?Q?kYmTxrGaM6uBQ2HcIEXcS8fWmIG/fhMOYDj3Xm7FMQb4tEgwRG4YC5DLUeay?=
 =?us-ascii?Q?H2rM7QDUH0dK4tvjREtXTcz2G+1KtWiN0RTSle8jhZsky5rULit4hYuVVs5t?=
 =?us-ascii?Q?2I2cL1O1xFkLYscvcUIpjcGj4OpJvyMi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:48.1790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d186d7-f073-4f25-a5ed-08dcb172adfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8772

The sev-guest driver encryption code uses the crypto API for SNP guest
messaging with the AMD Security processor. In order to enable secure TSC,
SEV-SNP guests need to send such a TSC_INFO message before the APs are
booted. Details from the TSC_INFO response will then be used to program the
VMSA before the APs are brought up.

However, the crypto API is not available this early in the boot process.

In preparation for moving the encryption code out of sev-guest to support
secure TSC and to ease review, switch to using the AES GCM library
implementation instead.

Drop __enc_payload() and dec_payload() helpers as both are small and can be
moved to the respective callers.

CC: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/sev.h              |   3 +
 drivers/virt/coco/sev-guest/sev-guest.c | 175 ++++++------------------
 drivers/virt/coco/sev-guest/Kconfig     |   4 +-
 3 files changed, 43 insertions(+), 139 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ee34ab00a8d6..e7977f76d77e 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -120,6 +120,9 @@ struct snp_req_data {
 };
 
 #define MAX_AUTHTAG_LEN		32
+#define AUTHTAG_LEN		16
+#define AAD_LEN			48
+#define MSG_HDR_VER		1
 
 /* See SNP spec SNP_GUEST_REQUEST section for the structure */
 enum msg_type {
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0b950069bfcb..39d90dd0b012 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -17,8 +17,7 @@
 #include <linux/set_memory.h>
 #include <linux/fs.h>
 #include <linux/tsm.h>
-#include <crypto/aead.h>
-#include <linux/scatterlist.h>
+#include <crypto/gcm.h>
 #include <linux/psp-sev.h>
 #include <linux/sockptr.h>
 #include <linux/cleanup.h>
@@ -31,26 +30,18 @@
 #include <asm/sev.h>
 
 #define DEVICE_NAME	"sev-guest"
-#define AAD_LEN		48
-#define MSG_HDR_VER	1
 
 #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
 #define SNP_REQ_RETRY_DELAY		(2*HZ)
 
 #define SVSM_MAX_RETRIES		3
 
-struct snp_guest_crypto {
-	struct crypto_aead *tfm;
-	u8 *iv, *authtag;
-	int iv_len, a_len;
-};
-
 struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
 	void *certs_data;
-	struct snp_guest_crypto *crypto;
+	struct aesgcm_ctx *ctx;
 	/* request and response are in unencrypted memory */
 	struct snp_guest_msg *request, *response;
 
@@ -169,132 +160,31 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct snp_guest_crypto *init_crypto(struct snp_guest_dev *snp_dev, u8 *key, size_t keylen)
+static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 {
-	struct snp_guest_crypto *crypto;
+	struct aesgcm_ctx *ctx;
 
-	crypto = kzalloc(sizeof(*crypto), GFP_KERNEL_ACCOUNT);
-	if (!crypto)
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
 		return NULL;
 
-	crypto->tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-	if (IS_ERR(crypto->tfm))
-		goto e_free;
-
-	if (crypto_aead_setkey(crypto->tfm, key, keylen))
-		goto e_free_crypto;
-
-	crypto->iv_len = crypto_aead_ivsize(crypto->tfm);
-	crypto->iv = kmalloc(crypto->iv_len, GFP_KERNEL_ACCOUNT);
-	if (!crypto->iv)
-		goto e_free_crypto;
-
-	if (crypto_aead_authsize(crypto->tfm) > MAX_AUTHTAG_LEN) {
-		if (crypto_aead_setauthsize(crypto->tfm, MAX_AUTHTAG_LEN)) {
-			dev_err(snp_dev->dev, "failed to set authsize to %d\n", MAX_AUTHTAG_LEN);
-			goto e_free_iv;
-		}
+	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
+		pr_err("Crypto context initialization failed\n");
+		kfree(ctx);
+		return NULL;
 	}
 
-	crypto->a_len = crypto_aead_authsize(crypto->tfm);
-	crypto->authtag = kmalloc(crypto->a_len, GFP_KERNEL_ACCOUNT);
-	if (!crypto->authtag)
-		goto e_free_iv;
-
-	return crypto;
-
-e_free_iv:
-	kfree(crypto->iv);
-e_free_crypto:
-	crypto_free_aead(crypto->tfm);
-e_free:
-	kfree(crypto);
-
-	return NULL;
-}
-
-static void deinit_crypto(struct snp_guest_crypto *crypto)
-{
-	crypto_free_aead(crypto->tfm);
-	kfree(crypto->iv);
-	kfree(crypto->authtag);
-	kfree(crypto);
-}
-
-static int enc_dec_message(struct snp_guest_crypto *crypto, struct snp_guest_msg *msg,
-			   u8 *src_buf, u8 *dst_buf, size_t len, bool enc)
-{
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct scatterlist src[3], dst[3];
-	DECLARE_CRYPTO_WAIT(wait);
-	struct aead_request *req;
-	int ret;
-
-	req = aead_request_alloc(crypto->tfm, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
-
-	/*
-	 * AEAD memory operations:
-	 * +------ AAD -------+------- DATA -----+---- AUTHTAG----+
-	 * |  msg header      |  plaintext       |  hdr->authtag  |
-	 * | bytes 30h - 5Fh  |    or            |                |
-	 * |                  |   cipher         |                |
-	 * +------------------+------------------+----------------+
-	 */
-	sg_init_table(src, 3);
-	sg_set_buf(&src[0], &hdr->algo, AAD_LEN);
-	sg_set_buf(&src[1], src_buf, hdr->msg_sz);
-	sg_set_buf(&src[2], hdr->authtag, crypto->a_len);
-
-	sg_init_table(dst, 3);
-	sg_set_buf(&dst[0], &hdr->algo, AAD_LEN);
-	sg_set_buf(&dst[1], dst_buf, hdr->msg_sz);
-	sg_set_buf(&dst[2], hdr->authtag, crypto->a_len);
-
-	aead_request_set_ad(req, AAD_LEN);
-	aead_request_set_tfm(req, crypto->tfm);
-	aead_request_set_callback(req, 0, crypto_req_done, &wait);
-
-	aead_request_set_crypt(req, src, dst, len, crypto->iv);
-	ret = crypto_wait_req(enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req), &wait);
-
-	aead_request_free(req);
-	return ret;
-}
-
-static int __enc_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
-			 void *plaintext, size_t len)
-{
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-
-	memset(crypto->iv, 0, crypto->iv_len);
-	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
-
-	return enc_dec_message(crypto, msg, plaintext, msg->payload, len, true);
-}
-
-static int dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
-		       void *plaintext, size_t len)
-{
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-
-	/* Build IV with response buffer sequence number */
-	memset(crypto->iv, 0, crypto->iv_len);
-	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
-
-	return enc_dec_message(crypto, msg, msg->payload, plaintext, len, false);
+	return ctx;
 }
 
 static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
 {
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
 	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
 	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
 		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
@@ -316,11 +206,16 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_msg_hdr->msg_sz + crypto->a_len) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	return dec_payload(snp_dev, resp_msg, payload, resp_msg_hdr->msg_sz + crypto->a_len);
+	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, payload, resp_msg->payload, resp_msg_hdr->msg_sz,
+			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
+		return -EBADMSG;
+
+	return 0;
 }
 
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
@@ -328,6 +223,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 {
 	struct snp_guest_msg *msg = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	memset(msg, 0, sizeof(*msg));
 
@@ -347,7 +244,14 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	return __enc_payload(snp_dev, msg, payload, sz);
+	if (WARN_ON((sz + ctx->authsize) > sizeof(msg->payload)))
+		return -EBADMSG;
+
+	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
+	aesgcm_encrypt(ctx, msg->payload, payload, sz, &hdr->algo, AAD_LEN,
+		       iv, hdr->authtag);
+
+	return 0;
 }
 
 static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
@@ -495,7 +399,6 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_report_req *report_req = &snp_dev->req.report;
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
@@ -513,7 +416,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + crypto->a_len;
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
@@ -534,7 +437,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_derived_key_resp derived_key_resp = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
@@ -550,7 +452,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(derived_key_resp.data) + crypto->a_len;
+	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
@@ -579,7 +481,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 {
 	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_report_resp *report_resp;
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
@@ -622,7 +523,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + crypto->a_len;
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
@@ -1148,8 +1049,8 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->crypto = init_crypto(snp_dev, snp_dev->vmpck, VMPCK_KEY_LEN);
-	if (!snp_dev->crypto)
+	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
 	misc = &snp_dev->misc;
@@ -1175,11 +1076,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_cert_data;
+		goto e_free_ctx;
 
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
+e_free_ctx:
+	kfree(snp_dev->ctx);
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
@@ -1198,7 +1101,7 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	deinit_crypto(snp_dev->crypto);
+	kfree(snp_dev->ctx);
 	misc_deregister(&snp_dev->misc);
 }
 
diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index 1cffc72c41cb..0b772bd921d8 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,9 +2,7 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
-	select CRYPTO
-	select CRYPTO_AEAD2
-	select CRYPTO_GCM
+	select CRYPTO_LIB_AESGCM
 	select TSM_REPORTS
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with
-- 
2.34.1


