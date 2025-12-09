Return-Path: <kvm+bounces-65525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA1FCAEB44
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 03:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 641D8302AF84
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 02:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BD430102C;
	Tue,  9 Dec 2025 02:23:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE36812E1DC;
	Tue,  9 Dec 2025 02:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765246990; cv=none; b=je6a0UAIjCOmAfsZBgiqX4FnZRLAuHfUZ+rpMuwpaKZIXYxVHNdQB87LdQeza+1Bv/kWHtsVQztVH+cnXfB318lHadVgiHHniMA+QyEz9CNDl2p0o2n6SXky4rMg3B1+c8OnG1af9n51QOYVZqlE1Rf25eBv3C5kBsxktaiT//o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765246990; c=relaxed/simple;
	bh=ypMaCA1mNX+qMxlyzi4ApOsO9ZIx73wbxsRkTklSgh4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lB6LJPwQB1EzIBh1B15LkxUQt+LVcn5wzmKipYL3HuItAUMqNf401/lDcQB0Y3nd3fy88FkTlNa1kxrFWUKmAyZpihuci9uTaOL3fXft7OFa+vc4UIR8Gw5CB+OgL5INLa8Z9ZnzU2mwMiFK3KZYkcQz9enrb7XaPYqnNny7Xt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxvtMGiDdpqYIsAA--.25304S3;
	Tue, 09 Dec 2025 10:23:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxdOQDiDdpykFHAQ--.59037S2;
	Tue, 09 Dec 2025 10:22:59 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v3 00/10] crypto: virtio: Add ecb aes algo support
Date: Tue,  9 Dec 2025 10:22:48 +0800
Message-Id: <20251209022258.4183415-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxdOQDiDdpykFHAQ--.59037S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Here add ecb aes algo support with virtio crypto device, also it fixes
one problem when multiple processes execute cipher operation. Most of work
is code clean up, such as use common APIs for block size and iv size etc.

---
v2 ... v3:
  1. Remove NULL checking with req_data where kfree() is called, since
     NULL pointer is workable with kfree() API.
  2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
     are sensitive data, memzero_explicit() is used even on error path
     handling.
  3. Remove duplicated virtqueue_kick() in new patch 2, since it is
     already called in previous __virtio_crypto_skcipher_do_req().

v1 ... v2:
  1. Add Fixes tag with patch 1.
  2. Add new patch 2 - patch 9 to add ecb aes algo support.
---
Bibo Mao (10):
  crypto: virtio: Add spinlock protection with virtqueue notification
  crypto: virtio: Remove duplicated virtqueue_kick in
    virtio_crypto_skcipher_crypt_req
  crypto: virtio: Replace package id with numa node id
  crypto: virtio: Add algo pointer in virtio_crypto_skcipher_ctx
  crypto: virtio: Use generic API aes_check_keylen()
  crypto: virtio: Remove AES specified marcro AES_BLOCK_SIZE
  crypto: virtio: Add req_data with structure virtio_crypto_sym_request
  crypto: virtio: Add IV buffer in structure virtio_crypto_sym_request
  crypto: virtio: Add skcipher support without IV
  crypto: virtio: Add ecb aes algo support

 drivers/crypto/virtio/virtio_crypto_common.h  |   2 +-
 drivers/crypto/virtio/virtio_crypto_core.c    |   5 +
 .../virtio/virtio_crypto_skcipher_algs.c      | 187 ++++++++++--------
 3 files changed, 112 insertions(+), 82 deletions(-)


base-commit: 67a454e6b1c604555c04501c77b7fedc5d98a779
-- 
2.39.3


