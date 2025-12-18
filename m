Return-Path: <kvm+bounces-66206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CCACCA363
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F73B3066DC6
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8909A3009C8;
	Thu, 18 Dec 2025 03:49:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500D2279DC2;
	Thu, 18 Dec 2025 03:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029743; cv=none; b=HutS5F5kUXk8kROn+V2h3YAh29+XHX+DyJNzU+ctw2y5to57TuHc3wfsdEmskRhp0QVfurcQmbx4tYmjyVVBPl6642X0tkkurYL7AMeXZdbORtO/QF37t6qZZO9uEVXSATxPrDQb2LA90HYz5MSppjCQc3yDr4NqnRyP/Lr6opQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029743; c=relaxed/simple;
	bh=7uEZlY08pApLqncxFus98l7GN5XvIf15qCw1fmPb8g8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aEkIROIc2HPZhfhBpWgj9lOHAk7xNImwImZt0PP17H/fNxjnEuyR6EhJ1R7VjMrAaJsD7LD8KgocrIIGRGx9XVwqYm6Jc5qY2dbeeFdQ2grykoviOQppeERWMoR2jzLHY8KCOOzyM5ok+PN3TUXXeuiR3f04uuH6EXr/jf2d/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxVvCmeUNpflwAAA--.1741S3;
	Thu, 18 Dec 2025 11:48:54 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBx68GfeUNpvy4BAA--.2184S5;
	Thu, 18 Dec 2025 11:48:54 +0800 (CST)
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
Subject: [PATCH v4 3/9] crypto: virtio: Replace package id with numa node id
Date: Thu, 18 Dec 2025 11:48:40 +0800
Message-Id: <20251218034846.948860-4-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBx68GfeUNpvy4BAA--.2184S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With multiple virtio crypto devices supported with different NUMA
nodes, when crypto session is created, it will search virtio crypto
device with the same numa node of current CPU.

Here API topology_physical_package_id() is replaced with cpu_to_node()
since package id is physical concept, and one package id have multiple
memory numa id.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 19c934af3df6..e559bdadf4f9 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -135,7 +135,7 @@ static inline int virtio_crypto_get_current_node(void)
 	int cpu, node;
 
 	cpu = get_cpu();
-	node = topology_physical_package_id(cpu);
+	node = cpu_to_node(cpu);
 	put_cpu();
 
 	return node;
-- 
2.39.3


