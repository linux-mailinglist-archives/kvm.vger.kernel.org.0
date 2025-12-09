Return-Path: <kvm+bounces-65530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEF3CAEB8F
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 03:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D41930C15B4
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 02:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95153019B2;
	Tue,  9 Dec 2025 02:23:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28272417C3;
	Tue,  9 Dec 2025 02:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765247003; cv=none; b=ldVvVka6oHInrllG501rLC5SVWsiMlzqqK7C6xhQnkPnRHVvStr2UorcxbGUZg4wRSkw67U3gDl4AdWIyjnuH9+lmzz3DseKT+whQVyRFd2S2hZMZqvSTqhgMdEOdm5SdKZU3IVYKJOJTWlApeTq7q1AW0YYWwD9re9tkdrrxzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765247003; c=relaxed/simple;
	bh=JWwaJBFy5oIvmdtqhh5mZ0Gbwalk+2T00rI/ggDjVuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IOR3iJlNfKRJSBe0A1kVV6PIIdxU/bBQst+XkJrsJq6eJ5TXs36AZcSvnoSi3c9DCu58urAIdQ/G9+bBP2sF3UcDJ9JcPI+oEMpUxgzrZ0uRMqbef4+jBnXYpHIVmC1DLbyTmrCIJUuBi873/yeJL4lZBfICSQ9KJnCsn6IVGQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cxrr8ViDdpxoIsAA--.28623S3;
	Tue, 09 Dec 2025 10:23:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxicAPiDdpzEFHAQ--.36100S2;
	Tue, 09 Dec 2025 10:23:11 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/10] crypto: virtio: Add algo pointer in virtio_crypto_skcipher_ctx
Date: Tue,  9 Dec 2025 10:22:52 +0800
Message-Id: <20251209022258.4183415-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251209022258.4183415-1-maobibo@loongson.cn>
References: <20251209022258.4183415-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxicAPiDdpzEFHAQ--.36100S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Structure virtio_crypto_skcipher_ctx is allocated together with
crypto_skcipher, and skcipher_alg is set in strucutre crypto_skcipher
when it is created.

Here add virtio_crypto_algo pointer in virtio_crypto_skcipher_ctx and
set it in function virtio_crypto_skcipher_init(). So crypto service
and algo can be acquired from virtio_crypto_algo pointer.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 11053d1786d4..8a139de3d064 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -15,9 +15,11 @@
 #include "virtio_crypto_common.h"
 
 
+struct virtio_crypto_algo;
 struct virtio_crypto_skcipher_ctx {
 	struct virtio_crypto *vcrypto;
 
+	struct virtio_crypto_algo *alg;
 	struct virtio_crypto_sym_session_info enc_sess_info;
 	struct virtio_crypto_sym_session_info dec_sess_info;
 };
@@ -108,9 +110,7 @@ virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
 
 static int virtio_crypto_alg_skcipher_init_session(
 		struct virtio_crypto_skcipher_ctx *ctx,
-		uint32_t alg, const uint8_t *key,
-		unsigned int keylen,
-		int encrypt)
+		const uint8_t *key, unsigned int keylen, int encrypt)
 {
 	struct scatterlist outhdr, key_sg, inhdr, *sgs[3];
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
@@ -140,7 +140,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 	/* Pad ctrl header */
 	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
-	ctrl->header.algo = cpu_to_le32(alg);
+	ctrl->header.algo = cpu_to_le32(ctx->alg->algonum);
 	/* Set the default dataqueue id to 0 */
 	ctrl->header.queue_id = 0;
 
@@ -261,13 +261,11 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		return -EINVAL;
 
 	/* Create encryption session */
-	ret = virtio_crypto_alg_skcipher_init_session(ctx,
-			alg, key, keylen, 1);
+	ret = virtio_crypto_alg_skcipher_init_session(ctx, key, keylen, 1);
 	if (ret)
 		return ret;
 	/* Create decryption session */
-	ret = virtio_crypto_alg_skcipher_init_session(ctx,
-			alg, key, keylen, 0);
+	ret = virtio_crypto_alg_skcipher_init_session(ctx, key, keylen, 0);
 	if (ret) {
 		virtio_crypto_alg_skcipher_close_session(ctx, 1);
 		return ret;
@@ -293,7 +291,7 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 		int node = virtio_crypto_get_current_node();
 		struct virtio_crypto *vcrypto =
 				      virtcrypto_get_dev_node(node,
-				      VIRTIO_CRYPTO_SERVICE_CIPHER, alg);
+				      ctx->alg->service, ctx->alg->algonum);
 		if (!vcrypto) {
 			pr_err("virtio_crypto: Could not find a virtio device in the system or unsupported algo\n");
 			return -ENODEV;
@@ -509,7 +507,11 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 
 static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
 {
+	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct virtio_crypto_sym_request));
+	ctx->alg = container_of(alg, struct virtio_crypto_algo, algo.base);
 
 	return 0;
 }
-- 
2.39.3


