Return-Path: <kvm+bounces-4937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973D881A1FE
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E967FB24BA7
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EE841847;
	Wed, 20 Dec 2023 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e1E/Zuo6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358140C13;
	Wed, 20 Dec 2023 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4Qb88sgCnf6zKROjipWhbTFeQlHo4HPUbyb5qCQV0i5E4zsfpFFbkSVk9HuS9K8hnRoL6ql1Q4J7kmOwbKfeYgpE210o/7RSZA4XfnErvJjDfNqEZXVuQ9252Wkxrjo8y/mT+NToktwSJJHt8xxB/MFEaY0972nwkNvbsjvGD/l4jfPF/hQZ8DcO7TWhj/6BVLOU9tDmniCaMAKcNkMxFFeCeCU98Llk1TRxvzuBvoIm4+8um2x5VDh3417HPAhfxd8tjxma68pOJg5IBHnhBn+fFy6Ng+AylYHFSWr2R1YvPObKLP3/S60TOaoNeTmoalSaWjWM0m7l0pq0hHUoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6c08twlIEBymD++4gJ/+1nGMofjP5MwreTUpiORmi4=;
 b=GHRKTS9jS24pitKpRH6U8Jk3Gkz/9GQG1ighqQuTTSat6B3CmAczNmYdaQhasGpuMHjejcqFQU9kdgPH+c4PllcMDmZUsDL8T2BrDXFCb37fO9/qW1tOHh5UjFqaOhy7BOTOJUcPx16LuzTFqvJ4iZ6JJCTVPCRnIrTp+hp7N4ewScC3WbxMcb293W4cI8Jo8UAmga4b1WpjyrVF4576VoG77PaxAwij6Sv9fg8TAwJGs4JlJzW1va3mvGf8pxAgEgQyHDo2YH07ORciRrd0mtlMKv2AEjPgKrzwzlsHKRufHb822Vuyl0c8X23zlP8BQTNhpPeIG6mqSxOg1J7irg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6c08twlIEBymD++4gJ/+1nGMofjP5MwreTUpiORmi4=;
 b=e1E/Zuo6OoS/UtaRwFOBXSW7TyB8I06d3G2bsJZcSyxlS6kgdL1iEjjFJZowasPPYa46GdZ+H0SzQunJOcR7pJ/bqMwT5ShEpEx8YV4d5q7KVtVrKRMhbss9BslwqJvDto0QKdcgM1xb5mavYmMSWNwbpXJEmIOOhvCfscH6isQ=
Received: from CH0PR03CA0212.namprd03.prod.outlook.com (2603:10b6:610:e7::7)
 by DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:14:51 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::82) by CH0PR03CA0212.outlook.office365.com
 (2603:10b6:610:e7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:14:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:14:51 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:14:46 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 01/16] virt: sev-guest: Use AES GCM crypto library
Date: Wed, 20 Dec 2023 20:43:43 +0530
Message-ID: <20231220151358.2147066-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|DS7PR12MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: c55b494b-89b6-4e0a-c72b-08dc016e69b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SHBz4ijBDLMobxky+E09urt0lJEqgK53olpKKZaPryZ8/i8DXN1TA8h3TSkieMdd3cYjcYeG7J7Oj72nIvN3A9kWnJaIvuhD4jt2N6uh11ZMGLIVyD3K86EAf/N6W088yhTpXDgakAb50aKvicf1lqAxrCmg7EWnOKvxNYGxNPbxWuLIN/yYrwqmm/iF6FPU+Vbx/mzUXs6vo2tWRIkmpEXkzVWDKLEoZgCFo/b2wT/cTfGSGV/uS6Q2R5R2rjJppM7/zaZGzJyqYZgc+T9LO14I0dKbaj4P+qnPZUugX5cZs+WhKqQIQgfsc79tNfXf+uEySd/NlSMkleD0SIc5XkuWfmwTEvFseisj3SOVMQcjdy7TUpn+TxVK56raVmdKttm1OyRQqKCu8LzbHLyx3n5QCwbWGgfO7JwjYKSmPVj6LDN7h0D4VWxLScveI03kxRvYw8KLpWiH5Yq9jvPbADys0P5BJgdeA72+IK4ckoIKnerrEoNCHlBWfGjn99tXwXxfu5Um/aNFZQYsoGOaGndZ8Wcpa+rrXe3HqGdN35eWkxNp1gdPrQP0gMjMxhVYdZsmvhxuxQmiHUd1Z/o5KYhIa5URb4tW4kLRYYOQDjADzfUZ6IurhHyHaLrEn/TEzuRwY3yOslS8AzqxwfejAFVlqY9LXndLibr+/cgaUa98qSMIUtQRDtPgmwnqBPqQ8al/MJhqRu3VZSGgrbDafReuBZaV57zOqeM30GuwOR5zGgRPnn09UeTKl5/qJJ1kO+Z8YlOWA/hUgkWHnWoHXQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(46966006)(40470700004)(36840700001)(36860700001)(2906002)(41300700001)(81166007)(36756003)(47076005)(82740400003)(356005)(6666004)(54906003)(110136005)(8936002)(8676002)(70586007)(70206006)(7416002)(336012)(426003)(16526019)(1076003)(4326008)(7696005)(5660300002)(30864003)(26005)(83380400001)(2616005)(316002)(478600001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:14:51.0340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c55b494b-89b6-4e0a-c72b-08dc016e69b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5766

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
---
 drivers/virt/coco/sev-guest/Kconfig     |   4 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 175 ++++++------------------
 drivers/virt/coco/sev-guest/sev-guest.h |   3 +
 3 files changed, 43 insertions(+), 139 deletions(-)

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
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index bc564adcf499..aedc842781b6 100644
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
+	memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));
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
+	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
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
@@ -1001,7 +904,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	deinit_crypto(snp_dev->crypto);
+	kfree(snp_dev->ctx);
 	misc_deregister(&snp_dev->misc);
 
 	return 0;
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
-- 
2.34.1


