Return-Path: <kvm+bounces-65529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B50CCAEB86
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 03:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 404C830B327E
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 02:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25157301489;
	Tue,  9 Dec 2025 02:23:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01444301014;
	Tue,  9 Dec 2025 02:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765247002; cv=none; b=r05Lcvjs5UpCmBTytws8cUIXxyu1a5DnLQKu7Dr3GBwHlvjjFC0qeHiYqVL04i87mdW6Gew9hPy8v9ybdRrnbyPylpY9WnkCFiQmrRhyP6zsRa7VWU6xlOh5NYCobT4ztSXUdJGrOowdVeEYX8TlNBr7wsbTOqb7ctUqt2ixx9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765247002; c=relaxed/simple;
	bh=/DzPOaejdGgvEMqODqPQFsVL3+JPFrDYmIxvR3E+52k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WKTmAMQ1Um3wWWBKppOrZjfC/xZcOe8xdcu+PQwUkHHOIb5s+exBm9JGAb89oz4iFJ85ADkqua9i+7bVKNRvcOTi0glY0d1v7PZLpwirXnz5YVuHTLTVAfxtVXHJUqIo7S5sytDcifAyeCC7c2C2IG3Vpi8sJepxwTxzJtIb0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxK9IViDdpzYIsAA--.27799S3;
	Tue, 09 Dec 2025 10:23:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxicAPiDdpzEFHAQ--.36100S3;
	Tue, 09 Dec 2025 10:23:17 +0800 (CST)
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
Subject: [PATCH v3 05/10] crypto: virtio: Use generic API aes_check_keylen()
Date: Tue,  9 Dec 2025 10:22:53 +0800
Message-Id: <20251209022258.4183415-6-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxicAPiDdpzEFHAQ--.36100S3
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


