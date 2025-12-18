Return-Path: <kvm+bounces-66203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FABFCCA31E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6D3A830138C4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE0F277CB8;
	Thu, 18 Dec 2025 03:48:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100171BC41;
	Thu, 18 Dec 2025 03:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029736; cv=none; b=QVjQBPOpuyQgqirvTsri3WRFhT3wwnz53ok8mCjL8eWCR65agC1Lo/uAqmO7ZNXXIE1/TfoCPO8pHyxMEuYaY+yS7eqfLsjeFU8y5UEIqodthdWtst9jLvuPItSCJtCMZzlhb0qHtePJb+bnLn+keWww7RoyTmifmNl07jXseAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029736; c=relaxed/simple;
	bh=wjhukzpgs+nKN0frMUJJQ6K21ijDNh4XlpkkPYIBn74=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AIfVeJaOu6LAqTZ7PQRsOLiY28z0SzX8SaT/16IZpcd+0B9DiDPAYsgCoIZLUesNt84FUbrV6meUra3PHTyPnumRcYu9+0j/w2jMX69c1hf+MN+SA9Oohy8Q8Rbo1EwxXe+TahjHFfIc1jDBbT6dAl6/f3ctS0OckHm2CvNz0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxvsOgeUNpZVwAAA--.1747S3;
	Thu, 18 Dec 2025 11:48:48 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBx68GfeUNpvy4BAA--.2184S2;
	Thu, 18 Dec 2025 11:48:48 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v4 0/9] crypto: virtio: Some bugfix and enhancement
Date: Thu, 18 Dec 2025 11:48:37 +0800
Message-Id: <20251218034846.948860-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx68GfeUNpvy4BAA--.2184S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

There is problem when multiple processes add encrypt/decrypt requests
with virtio crypto device and spinlock is missing with command response
handling. Also there is duplicated virtqueue_kick() without lock hold.

Here these two issues are fixed and the others are code clean up, such as
use common APIs for block size and iv size etc.

---
v3 ... v4:
  1. Remove patch 10 which adds ECB AES algo, since application and qemu
     backend emulation is not ready for ECB AES algo.
  2. Add Cc stable tag with patch 2 which removes duplicated
     virtqueue_kick() without lock hold.

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
Bibo Mao (9):
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

 drivers/crypto/virtio/virtio_crypto_common.h  |   2 +-
 drivers/crypto/virtio/virtio_crypto_core.c    |   5 +
 .../virtio/virtio_crypto_skcipher_algs.c      | 113 +++++++++---------
 3 files changed, 62 insertions(+), 58 deletions(-)


base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
-- 
2.39.3


