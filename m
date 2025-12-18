Return-Path: <kvm+bounces-66212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE20CCA36C
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 04C533058715
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7913016E5;
	Thu, 18 Dec 2025 03:49:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4D9258CE5;
	Thu, 18 Dec 2025 03:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029772; cv=none; b=Vi/c/VGXWxKf8fzpVqvdV9H1U1Bm0PXppaEzK7YUpmlaYU3f6O2Peog1TlVG4J2kDWiQQVnBqMhoqcvXNgM2lz3Njg+xexavF9ujDkiKDwBpMPJKe5PDf4Uaeyp55pNkLBePBXey8ZnxMK+NWd8IQ9uflIE1N+N/4hsNNR33KeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029772; c=relaxed/simple;
	bh=grCOtZ4Ju+0sueoqgtSNNz9VfT19eAf/VTVNoD0qhNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dUzxhnVqUBq0NfIND0v8ivZPk5cWIW+NFTTqUZqZZQznMUbBYtRIyItOJnsQ8uZK1piE18odg8ij3TMxGXW+pLjGiv2L+pgCiAx2Y8EVsZJK1e7WIPrrR9y24cLCrcOoaI1EGyo+6udn9XrDTC6twE1LakfBn34GcaGox94CTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxScKzeUNptFwAAA--.1102S3;
	Thu, 18 Dec 2025 11:49:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxPMKxeUNpwy4BAA--.2235S3;
	Thu, 18 Dec 2025 11:49:06 +0800 (CST)
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
Subject: [PATCH v4 9/9] crypto: virtio: Add skcipher support without IV
Date: Thu, 18 Dec 2025 11:48:46 +0800
Message-Id: <20251218034846.948860-10-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxPMKxeUNpwy4BAA--.2235S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Some skcipher algo has no IV buffer such as ecb(aes) also, here add
checking with ivsize.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 39 +++++++++++--------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 3d47e7c30c6b..a5e6993da2ef 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -345,7 +345,9 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 			src_nents, dst_nents);
 
 	/* Why 3?  outhdr + iv + inhdr */
-	sg_total = src_nents + dst_nents + 3;
+	sg_total = src_nents + dst_nents + 2;
+	if (ivsize)
+		sg_total += 1;
 	sgs = kcalloc_node(sg_total, sizeof(*sgs), GFP_KERNEL,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!sgs)
@@ -402,15 +404,17 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	 * Avoid to do DMA from the stack, switch to using
 	 * dynamically-allocated for the IV
 	 */
-	iv = vc_sym_req->iv;
-	memcpy(iv, req->iv, ivsize);
-	if (!vc_sym_req->encrypt)
-		scatterwalk_map_and_copy(req->iv, req->src,
-					 req->cryptlen - ivsize,
-					 ivsize, 0);
-
-	sg_init_one(&iv_sg, iv, ivsize);
-	sgs[num_out++] = &iv_sg;
+	if (ivsize) {
+		iv = vc_sym_req->iv;
+		memcpy(iv, req->iv, ivsize);
+		if (!vc_sym_req->encrypt)
+			scatterwalk_map_and_copy(req->iv, req->src,
+					req->cryptlen - ivsize,
+					ivsize, 0);
+
+		sg_init_one(&iv_sg, iv, ivsize);
+		sgs[num_out++] = &iv_sg;
+	}
 
 	/* Source data */
 	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
@@ -437,7 +441,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	return 0;
 
 free_iv:
-	memzero_explicit(iv, ivsize);
+	if (ivsize)
+		memzero_explicit(iv, ivsize);
 free:
 	memzero_explicit(req_data, sizeof(*req_data));
 	kfree(sgs);
@@ -543,11 +548,13 @@ static void virtio_crypto_skcipher_finalize_req(
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 
-	if (vc_sym_req->encrypt)
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->cryptlen - ivsize,
-					 ivsize, 0);
-	memzero_explicit(vc_sym_req->iv, ivsize);
+	if (ivsize) {
+		if (vc_sym_req->encrypt)
+			scatterwalk_map_and_copy(req->iv, req->dst,
+					req->cryptlen - ivsize,
+					ivsize, 0);
+		memzero_explicit(vc_sym_req->iv, ivsize);
+	}
 	virtcrypto_clear_request(&vc_sym_req->base);
 
 	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
-- 
2.39.3


