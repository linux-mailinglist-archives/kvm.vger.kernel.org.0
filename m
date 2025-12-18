Return-Path: <kvm+bounces-66208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D0952CCA33C
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F69D30161FC
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E0D28641F;
	Thu, 18 Dec 2025 03:49:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE2E258CE7;
	Thu, 18 Dec 2025 03:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029754; cv=none; b=idAGVEmxs+u69hhs+a4Nz9frn71TG/EJsGr+kacuVNaYUz84c7r7dS0HjqByqKUxWkPfIVtUoV/g4ej9oKh+wHmOprYm4jrmY8YVMtx64nebgpufyHmmmiFeRDJ8r2k3Wi3X910fCNfQZiM7OotA5doU5M31Fm4l4CUDpoCD3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029754; c=relaxed/simple;
	bh=1UhYwSPdYu3p8N92u33jtXlRnLQIOHWDGq0+ij+jLiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oF/GPh9PDRoGW8MCBoT7suWD7AzsXgY82ld0qNYFFKGZfUaESISIgiQbrD1D1mi7dhm2ZZKwms2O8o/VToBkm0cpNDfGv5omkAV2A/ytIDq9kmfiD3yGI7o1KGRm8nQPa/z3ftg+z4dtBDxLd7myGEOST+B8vL7Qen0eDgh51gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dx+8KteUNpmlwAAA--.1072S3;
	Thu, 18 Dec 2025 11:49:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxXcKpeUNpwS4BAA--.2172S4;
	Thu, 18 Dec 2025 11:49:00 +0800 (CST)
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
Subject: [PATCH v4 6/9] crypto: virtio: Remove AES specified marcro AES_BLOCK_SIZE
Date: Thu, 18 Dec 2025 11:48:43 +0800
Message-Id: <20251218034846.948860-7-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJAxXcKpeUNpwS4BAA--.2172S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Macro AES_BLOCK_SIZE is meaningful only for algo AES, replace it
with generic API crypto_skcipher_blocksize(), so that new algo can
be added in later.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../crypto/virtio/virtio_crypto_skcipher_algs.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 682d192a4ed7..788d2d4a9b83 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -416,8 +416,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	memcpy(iv, req->iv, ivsize);
 	if (!vc_sym_req->encrypt)
 		scatterwalk_map_and_copy(req->iv, req->src,
-					 req->cryptlen - AES_BLOCK_SIZE,
-					 AES_BLOCK_SIZE, 0);
+					 req->cryptlen - ivsize,
+					 ivsize, 0);
 
 	sg_init_one(&iv_sg, iv, ivsize);
 	sgs[num_out++] = &iv_sg;
@@ -459,6 +459,7 @@ static int virtio_crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(req);
 	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(atfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(atfm);
 	struct virtio_crypto_sym_request *vc_sym_req =
 				skcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
@@ -468,7 +469,7 @@ static int virtio_crypto_skcipher_encrypt(struct skcipher_request *req)
 
 	if (!req->cryptlen)
 		return 0;
-	if (req->cryptlen % AES_BLOCK_SIZE)
+	if (req->cryptlen % blocksize)
 		return -EINVAL;
 
 	vc_req->dataq = data_vq;
@@ -482,6 +483,7 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(req);
 	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(atfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(atfm);
 	struct virtio_crypto_sym_request *vc_sym_req =
 				skcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
@@ -491,7 +493,7 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 
 	if (!req->cryptlen)
 		return 0;
-	if (req->cryptlen % AES_BLOCK_SIZE)
+	if (req->cryptlen % blocksize)
 		return -EINVAL;
 
 	vc_req->dataq = data_vq;
@@ -547,10 +549,13 @@ static void virtio_crypto_skcipher_finalize_req(
 	struct skcipher_request *req,
 	int err)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+
 	if (vc_sym_req->encrypt)
 		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->cryptlen - AES_BLOCK_SIZE,
-					 AES_BLOCK_SIZE, 0);
+					 req->cryptlen - ivsize,
+					 ivsize, 0);
 	kfree_sensitive(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
 
-- 
2.39.3


