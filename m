Return-Path: <kvm+bounces-66209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 14396CCA388
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B03C930B0189
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680F22EB5D4;
	Thu, 18 Dec 2025 03:49:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F33D2E0400;
	Thu, 18 Dec 2025 03:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029759; cv=none; b=k1fJeNPQ9vLuOjbzuB60jKIumPYcQyYpDfiPCbBhDBPwgp8zPC1reszgIVAAxDkNQL+LQwbzDmbYJAfMZGDzVOnpQyRC/PVRoGZYJA6rAM1ipyyeX50+3u/drMhf5v7MmlXxML1jDVtRM0IN+Db7UV84/6fG/Xu0ZZTa/9llRkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029759; c=relaxed/simple;
	bh=bP+MftIy5MZyKErTXJZOXlqqWq32ab3+bPjAzNt3ddw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ojq5HO4zOkzc+Yk8Ush0WOdmH28KH3lElJN1ZRYIWTpRhXjZsAnea82m0lVHB/Q23mIL/NoYMUChwT9ldn9RIqWcvWyXkmLM4ZU79zFBgYuk8Vu07Gn62HHwDiBoPFOi1efIrriafXvYal9w1BvUnWB5Hy6W7EE+uzAQLFCrqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxAfGueUNpo1wAAA--.1805S3;
	Thu, 18 Dec 2025 11:49:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxXcKpeUNpwS4BAA--.2172S5;
	Thu, 18 Dec 2025 11:49:01 +0800 (CST)
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
Subject: [PATCH v4 7/9] crypto: virtio: Add req_data with structure virtio_crypto_sym_request
Date: Thu, 18 Dec 2025 11:48:44 +0800
Message-Id: <20251218034846.948860-8-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJAxXcKpeUNpwS4BAA--.2172S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With normal encrypt/decrypt workflow, req_data with struct type
virtio_crypto_op_data_req will be allocated. Here put req_data in
virtio_crypto_sym_request, it is pre-allocated when encrypt/decrypt
interface is called.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 788d2d4a9b83..bf9fdf56c2a3 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -26,6 +26,7 @@ struct virtio_crypto_skcipher_ctx {
 
 struct virtio_crypto_sym_request {
 	struct virtio_crypto_request base;
+	struct virtio_crypto_op_data_req req_data;
 
 	/* Cipher or aead */
 	uint32_t type;
@@ -350,14 +351,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	if (!sgs)
 		return -ENOMEM;
 
-	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
-				dev_to_node(&vcrypto->vdev->dev));
-	if (!req_data) {
-		kfree(sgs);
-		return -ENOMEM;
-	}
-
-	vc_req->req_data = req_data;
+	req_data = &vc_sym_req->req_data;
+	vc_req->req_data = NULL;
 	vc_sym_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
 	/* Head of operation */
 	if (vc_sym_req->encrypt) {
@@ -450,7 +445,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 free_iv:
 	kfree_sensitive(iv);
 free:
-	kfree_sensitive(req_data);
+	memzero_explicit(req_data, sizeof(*req_data));
 	kfree(sgs);
 	return err;
 }
-- 
2.39.3


