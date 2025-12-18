Return-Path: <kvm+bounces-66207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B3838CCA336
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2255A3015B93
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACAF3016E7;
	Thu, 18 Dec 2025 03:49:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6662FF66C;
	Thu, 18 Dec 2025 03:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029746; cv=none; b=BPlO2qbXXA9N7LORjBYfIakssKQEW1xz/x2MUthI7o6hFa5Yv3ugWqm5x7ClAdBGyEFpwR8FoPy0eF8chIGeZebsF2lLRiDvO7qNf9NJd3Qp9h9fDfwQzUJ+whpxekTArI5+72t7Xv8x3FJTxdF5wyG6xcPIHv1auqko32G0Xxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029746; c=relaxed/simple;
	bh=/DzPOaejdGgvEMqODqPQFsVL3+JPFrDYmIxvR3E+52k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kL6GfAmXkaftaU9+DauCh0woZqlvJOQv+AX9ZuPRLqiHt6acoiznTm655p9TgiVoa1iV61BtU/EcOMEIouXU9H2Oric2bQLVr8dOl2NJNalzIsa+2uYRllQxFUDAKq/MsNGO4HiH1if1uwiEPIXWEBsLAoG/uc7jZxTa7iytb+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxPMOreUNpj1wAAA--.1016S3;
	Thu, 18 Dec 2025 11:48:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxXcKpeUNpwS4BAA--.2172S3;
	Thu, 18 Dec 2025 11:48:58 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v4 5/9] crypto: virtio: Use generic API aes_check_keylen()
Date: Thu, 18 Dec 2025 11:48:42 +0800
Message-Id: <20251218034846.948860-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251218034846.948860-1-maobibo@loongson.cn>
References: <20251218034846.948860-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxXcKpeUNpwS4BAA--.2172S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With AES algo, generic API aes_check_keylen() is used to check length
of key.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 8a139de3d064..682d192a4ed7 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -94,18 +94,16 @@ static u64 virtio_crypto_alg_sg_nents_length(struct scatterlist *sg)
 }
 
 static int
-virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
+virtio_crypto_alg_validate_key(int key_len, uint32_t alg)
 {
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-	case AES_KEYSIZE_192:
-	case AES_KEYSIZE_256:
-		*alg = VIRTIO_CRYPTO_CIPHER_AES_CBC;
-		break;
+	switch (alg) {
+	case VIRTIO_CRYPTO_CIPHER_AES_ECB:
+	case VIRTIO_CRYPTO_CIPHER_AES_CBC:
+	case VIRTIO_CRYPTO_CIPHER_AES_CTR:
+		return aes_check_keylen(key_len);
 	default:
 		return -EINVAL;
 	}
-	return 0;
 }
 
 static int virtio_crypto_alg_skcipher_init_session(
@@ -248,7 +246,6 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		struct virtio_crypto_skcipher_ctx *ctx,
 		const uint8_t *key, unsigned int keylen)
 {
-	uint32_t alg;
 	int ret;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 
@@ -257,7 +254,7 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		return -EINVAL;
 	}
 
-	if (virtio_crypto_alg_validate_key(keylen, &alg))
+	if (virtio_crypto_alg_validate_key(keylen, ctx->alg->algonum))
 		return -EINVAL;
 
 	/* Create encryption session */
@@ -279,10 +276,9 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 					 unsigned int keylen)
 {
 	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	uint32_t alg;
 	int ret;
 
-	ret = virtio_crypto_alg_validate_key(keylen, &alg);
+	ret = virtio_crypto_alg_validate_key(keylen, ctx->alg->algonum);
 	if (ret)
 		return ret;
 
-- 
2.39.3


