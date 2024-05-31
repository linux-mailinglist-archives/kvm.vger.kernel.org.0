Return-Path: <kvm+bounces-18469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BED8D595F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B54F285698
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6C47D06B;
	Fri, 31 May 2024 04:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2N5KgMeA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08397BB0C;
	Fri, 31 May 2024 04:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129890; cv=fail; b=BPYhl++Q3cHMlKwktC9/PrNPioVP1/RRB7CdNdGGNzjhpgpth8gSpmj7JJsQJnfZKpTr1ZdmmjYYP4nYQjdGdgvZb4fL2E+yOThjjPQJ/Rn8Pln5ak73rzyjODIOwH09eV/xpAbo6ZqRfLIRKWBsmme/xo/9q5ofRCoINOV5M7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129890; c=relaxed/simple;
	bh=sgzW8Mc18zB8Z7oryreValO4nHvWpNjQwC0ieFMSd84=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lr2uNeIVDEEM5QY4lrE+QXt7FxLB2hrNvRLHUtRm/W5l/tPvKt3nE3MeFZ7UmJ9evDEUnD8U8j53fpXB+goAJ4af2jWGqQFcYHXb5jIEdVedYmL8g3Zcc9DmYPazh/izhcNasIdO+kDDG/yB6DOeVn9GiAetWLzM8UYS764gUas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2N5KgMeA; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1nPH6H7mXixoNXk+1IE2BRscCy+kWL45DXv/e5f/nG7AeCDaSXsVzIQUNne44BuwrRG97w+z5XPNCU7EHphCai0CjfniqyIiWaCRuTGePeH/jRrBH6904RtAF99P2CJSie0LUc0XqilhXzpYAc2vw1T1SmFNzkVXcsHzdLXUdqOcSYTAQ5yzuV2Pb+xryz4k49cqTkjFfbJigMC+Fs34CU3dvBhVPmXAXuSR0u2jbULvjc62EAS4o4f5KwaovFQMoPNMflBG0wEIF/d/hoS6h4f0sABJTRQu5ezZs0eHrnLb3Ka6/4fATMkGRr4He7EIpsQu8uYqZnxhmH/0ZO9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My/46emAAveMnlDZZLz52UnrMsuXP5H6Gb8aOQdZTQk=;
 b=LBBCW/+Lk+vRU7oKor3gh02GZfYYTAjCrTe7LTdDZpgrY58f6WFJiqeg0E/CmjTHPALxKF0al1M0MpRhwBgDnqBT4K2f2ns2MorluT5ft4YF2zKveqD5rXQhfJCUZOD2A6JgrFS8PfYbTebwQ1hYwVtNBJtiJQ7daMyR9yzeCbVFfpzEtk9ZCeSZZmMOLbYl9ZgLpP4OAKrmiPWRVP1W7MPPX1lHrTn+RfrbrqHUVQ/Ow29l1r2f8lIYndC0BncoJadpXm2mAV9dpcPxZ57/CyLn+Bq+9t5b5S/f8eSS5h5us3OxH40F9msuYAfwsi6FJeGfDFOwXAq/4FClTjRq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My/46emAAveMnlDZZLz52UnrMsuXP5H6Gb8aOQdZTQk=;
 b=2N5KgMeAv8mW7C5e5dK+f3rh7LweaF74JP3VhsQbPH4IuNGOl1PQdhIrP+/EZIl1BpNxPJfVeEF9sKnY84uyDHBG38Ck6A0COTCw69laf4bw2Pm/7xTBizw+9kN1B/UOSDAj5Zi2eqH/cZfzAqpTF6FbMpNPcnxc0Ao+bWQaCpQ=
Received: from BY3PR05CA0028.namprd05.prod.outlook.com (2603:10b6:a03:254::33)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:31:25 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::ad) by BY3PR05CA0028.outlook.office365.com
 (2603:10b6:a03:254::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.8 via Frontend
 Transport; Fri, 31 May 2024 04:31:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:31:24 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:31:20 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 01/24] virt: sev-guest: Use AES GCM crypto library
Date: Fri, 31 May 2024 10:00:15 +0530
Message-ID: <20240531043038.3370793-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 581aebe3-a2a8-4d9a-6ced-08dc812a87ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lx1vakVT7QAfWCfO0S04m/2Eg6VjAtrCk/3hcxX3LqXgi/NxP8NgffuoDnYS?=
 =?us-ascii?Q?u+aSGx/Lre1gT2IlavVkv53pOQXZrMg9w2ZI3El1Ntij7/DLq/Za2LqLBCC2?=
 =?us-ascii?Q?GTjckyz/JP/V9xdHxiJkNt412pJyyPFfQoA2vwgt0u5CR1h0DcyDomJDkM97?=
 =?us-ascii?Q?CG6nMiMvAKfqQ2tvyagt/RS5sTRlSO+WfuGMaUH/k+vX7AVuGAFjODD/OSv2?=
 =?us-ascii?Q?uG9d8pwBoydrqm8MUQYx/gO84YnNZC6k2O1cG0cKcr9T3Libn23+Nm8a36Ar?=
 =?us-ascii?Q?bZ7SlYm8nJh233BXnJDmnq2dm/SD5Oa7AWl3aIFnmferluLPphZaGQ/5qI6Z?=
 =?us-ascii?Q?hBc5xFFXuKrwKND9X7A/RkmdjEYmJYMaPUui0WGYZQu/N7oAAWdvyhfE0ikK?=
 =?us-ascii?Q?EeBv41N3QZb19n2kgeUnUU4J1ITSk89rXrmb6HGsBKI8bvDC+fdo7/2ZnP3i?=
 =?us-ascii?Q?dEUC9nCvdv9FbnR+BF145XL95jtjcbAQqfA8NB+u6mncdbDaJPqYTn9BAF+I?=
 =?us-ascii?Q?bjyuKbk8h6siqVgxf9yuCJikVdcSbB1v8sd8JpnTJVncTFhJrA1JOcwrNOMY?=
 =?us-ascii?Q?jxfGYivE34zj64cXLJM94gcalA2bVLYjMyOSbVypV2u6OIiLpNO6WSHN5yrU?=
 =?us-ascii?Q?2QzhOdzze1FL1MFlcvBFARf2yhK8+cDWE0pqHrpBM6ZwyjriUsKXdwWCHRrG?=
 =?us-ascii?Q?rytPKUV5LLDni7IndlgCv82pT61XcgAWR0eX9xDMhC4edQIqq3/c4yIa8rge?=
 =?us-ascii?Q?3Ybah+nx9VHtyxjnIEN3aQ2/8zd7TYBpz9E9EX8Kt0oezfiAQDpb/xod16Jo?=
 =?us-ascii?Q?jLHybrab6Bt2tbP9R1mjmoePCYmlDh/lw+/JapbfXC1LvmhySdok84mxsDfl?=
 =?us-ascii?Q?MjfmJ8/q+E9xs4hSBNfaQBhGXl+lfs/NsMQhdCLW1Ay1X4+mm0lCo9qLkYW5?=
 =?us-ascii?Q?Kg8hmzqozo7TmHGYnKGlMN36iP4y8vPvsIlrzKeccZmTnehpkXReruO9Br8r?=
 =?us-ascii?Q?gPHP5FyK9iS3YBHXQVAh/HHRHoSQDiG7JJsgq4SZs0qbdI1qb98/vuUi8Jek?=
 =?us-ascii?Q?uBY8aGNFX3ZBS+3MjpaNNN2x1n4R1vRTgz6HF9VKeQr6kQs4ZWQi4bSwt5KQ?=
 =?us-ascii?Q?2fF5Z+TuGruGDVJWm2eNIKCLsEUQX4dZj4vBd2NFGf06qIWE6tPklHqTFqi7?=
 =?us-ascii?Q?1jP2mf9R3xCGJnwZ05/aT7h+DbV1X7SUXgZEFB5nsehjaL+977JlOxQ0+6yw?=
 =?us-ascii?Q?sMbtVgzsy56ezgcz8jaHlGGV+j6Tm8UbELg0LGgDf/hIs7CcgTgeLrPEycN0?=
 =?us-ascii?Q?kLIMo3kncwJ80jIRq7gRTv4TxPNFoD9ThqYyMn5TbiUU8LYD0IWu1Wiqea/3?=
 =?us-ascii?Q?xNr+J2C8Q82yEA1D2H4qA25TCSFj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:31:24.7611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 581aebe3-a2a8-4d9a-6ced-08dc812a87ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

The sev-guest driver encryption code uses Crypto API for SNP guest
messaging to interact with AMD Security processor. For enabling SecureTSC,
SEV-SNP guests need to send a TSC_INFO request guest message before the
smpboot phase starts. Details from the TSC_INFO response will be used to
program the VMSA before the secondary CPUs are brought up. The Crypto API
is not available this early in the boot phase.

In preparation of moving the encryption code out of sev-guest driver to
support SecureTSC and make reviewing the diff easier, start using AES GCM
library implementation instead of Crypto API.

Drop __enc_payload() and dec_payload() helpers as both are pretty small and
can be moved to the respective callers.

CC: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 drivers/virt/coco/sev-guest/sev-guest.h |   3 +
 drivers/virt/coco/sev-guest/sev-guest.c | 175 ++++++------------------
 drivers/virt/coco/sev-guest/Kconfig     |   4 +-
 3 files changed, 43 insertions(+), 139 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index 21bda26fdb95..ceb798a404d6 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -13,6 +13,9 @@
 #include <linux/types.h>
 
 #define MAX_AUTHTAG_LEN		32
+#define AUTHTAG_LEN		16
+#define AAD_LEN			48
+#define MSG_HDR_VER		1
 
 /* See SNP spec SNP_GUEST_REQUEST section for the structure */
 enum msg_type {
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 654290a8e1ba..0768c6692483 100644
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
@@ -32,24 +31,16 @@
 #include "sev-guest.h"
 
 #define DEVICE_NAME	"sev-guest"
-#define AAD_LEN		48
-#define MSG_HDR_VER	1
 
 #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
 #define SNP_REQ_RETRY_DELAY		(2*HZ)
 
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
 
@@ -161,132 +152,31 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
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
 	struct snp_guest_msg *resp = &snp_dev->secret_response;
 	struct snp_guest_msg *req = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
 	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
 		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
@@ -307,11 +197,16 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > sz))
+	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	return dec_payload(snp_dev, resp, payload, resp_hdr->msg_sz + crypto->a_len);
+	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
+			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
+		return -EBADMSG;
+
+	return 0;
 }
 
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
@@ -319,6 +214,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 {
 	struct snp_guest_msg *req = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	memset(req, 0, sizeof(*req));
 
@@ -338,7 +235,14 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
 		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	return __enc_payload(snp_dev, req, payload, sz);
+	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+		return -EBADMSG;
+
+	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
+	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
+		       iv, hdr->authtag);
+
+	return 0;
 }
 
 static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
@@ -486,7 +390,6 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_report_req *req = &snp_dev->req.report;
 	struct snp_report_resp *resp;
 	int rc, resp_len;
@@ -504,7 +407,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + crypto->a_len;
+	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
 	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!resp)
 		return -ENOMEM;
@@ -526,7 +429,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_derived_key_req *req = &snp_dev->req.derived_key;
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_derived_key_resp resp = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
@@ -542,7 +444,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp.data) + crypto->a_len;
+	resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
@@ -569,7 +471,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 {
 	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
-	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_report_resp *resp;
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
@@ -612,7 +513,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + crypto->a_len;
+	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
 	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!resp)
 		return -ENOMEM;
@@ -954,8 +855,8 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->crypto = init_crypto(snp_dev, snp_dev->vmpck, VMPCK_KEY_LEN);
-	if (!snp_dev->crypto)
+	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
+	if (!snp_dev->ctx)
 		goto e_free_cert_data;
 
 	misc = &snp_dev->misc;
@@ -978,11 +879,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_cert_data;
+		goto e_free_ctx;
 
 	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
 	return 0;
 
+e_free_ctx:
+	kfree(snp_dev->ctx);
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
@@ -1001,7 +904,7 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
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


