Return-Path: <kvm+bounces-22626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C678D940AF2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD8A281486
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33671946AD;
	Tue, 30 Jul 2024 08:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kkcus29R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963C419413B
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327059; cv=none; b=icJ6FcwJzWxOJ6h+xIhOFVVZ7LDkYT1YmhebLO8VWbVrOpCgb/8kpn4ceGUMtot+osgiDMuCryN2TNxu9k9eV0Nvvw8xvpR47/dBXxbqPd0hy1RuccLAN1DS/NeEbKLuJRVUMhel16kzr2lZRsBfFAL2+B/11n+p+xzzEuc3LO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327059; c=relaxed/simple;
	bh=RD7QQE7xS/N9WImT/656mJMj/Ng1kNY85cM8YS99B+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=QF0I8AH9xxB8yg7RZAJZy4In8CrUYHRQ+JqW6Uo2euNqQbwfqDshJ7tC+scd1zLYwXEeCd5N4sWOpirh6odXJl86fzKqHpqqPVTAeMKmPPeGVhxmxBRDLobbHXyRzYFIU0kx6Oa+sg3f/UD2B706EpFcydbCsn9GjipsbpCT2wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kkcus29R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0JopmNllRYFEMaPc67cAs60A4W60BVFuQXpNv3T5Ac=;
	b=Kkcus29RBl8NWgoBWSILBSJhTCBYgI9QdM4wMSc38aWFgzD5yjjsFIctvMagz+hMqAXpJB
	aCTxns5PWdwNw/3vGrhKLRAMeca7oMwgNoMUEcygNsoMCqtDI5kKbjUfpFfzifTbzcCo/7
	IHKMoQxvFnJ2P+rurPsT2pbnvhNzwpU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-g7u-qIc5PzuKfrYDUWx8NA-1; Tue,
 30 Jul 2024 04:10:51 -0400
X-MC-Unique: g7u-qIc5PzuKfrYDUWx8NA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8E8F1955D50;
	Tue, 30 Jul 2024 08:10:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35FDD3000198;
	Tue, 30 Jul 2024 08:10:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1B7E921F4BA1; Tue, 30 Jul 2024 10:10:33 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH 17/18] qapi/cryptodev: Drop unwanted 'prefix'
Date: Tue, 30 Jul 2024 10:10:31 +0200
Message-ID: <20240730081032.1246748-18-armbru@redhat.com>
In-Reply-To: <20240730081032.1246748-1-armbru@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

QCryptodevBackendServiceType has a 'prefix' that overrides the
generated enumeration constants' prefix to QCRYPTODEV_BACKEND_SERVICE.

Drop it.  The prefix becomes QCRYPTODEV_BACKEND_SERVICE_TYPE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/cryptodev.json             |  1 -
 backends/cryptodev-builtin.c    |  8 ++++----
 backends/cryptodev-lkcf.c       |  2 +-
 backends/cryptodev-vhost-user.c |  6 +++---
 backends/cryptodev.c            |  6 +++---
 hw/virtio/virtio-crypto.c       | 10 +++++-----
 6 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/qapi/cryptodev.json b/qapi/cryptodev.json
index 60f8fe8e4a..65abc16842 100644
--- a/qapi/cryptodev.json
+++ b/qapi/cryptodev.json
@@ -31,7 +31,6 @@
 # Since: 8.0
 ##
 { 'enum': 'QCryptodevBackendServiceType',
-  'prefix': 'QCRYPTODEV_BACKEND_SERVICE',
   'data': ['cipher', 'hash', 'mac', 'aead', 'akcipher']}
 
 ##
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 6f3990481b..170c93a6be 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -68,7 +68,7 @@ static void cryptodev_builtin_init_akcipher(CryptoDevBackend *backend)
     opts.u.rsa.padding_alg = QCRYPTO_RSA_PADDING_ALGO_RAW;
     if (qcrypto_akcipher_supports(&opts)) {
         backend->conf.crypto_services |=
-                     (1u << QCRYPTODEV_BACKEND_SERVICE_AKCIPHER);
+                     (1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_AKCIPHER);
         backend->conf.akcipher_algo = 1u << VIRTIO_CRYPTO_AKCIPHER_RSA;
     }
 }
@@ -93,9 +93,9 @@ static void cryptodev_builtin_init(
     backend->conf.peers.ccs[0] = cc;
 
     backend->conf.crypto_services =
-                         1u << QCRYPTODEV_BACKEND_SERVICE_CIPHER |
-                         1u << QCRYPTODEV_BACKEND_SERVICE_HASH |
-                         1u << QCRYPTODEV_BACKEND_SERVICE_MAC;
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_CIPHER |
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_HASH |
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_MAC;
     backend->conf.cipher_algo_l = 1u << VIRTIO_CRYPTO_CIPHER_AES_CBC;
     backend->conf.hash_algo = 1u << VIRTIO_CRYPTO_HASH_SHA1;
     /*
diff --git a/backends/cryptodev-lkcf.c b/backends/cryptodev-lkcf.c
index fde32950f6..0dc4b067f5 100644
--- a/backends/cryptodev-lkcf.c
+++ b/backends/cryptodev-lkcf.c
@@ -230,7 +230,7 @@ static void cryptodev_lkcf_init(CryptoDevBackend *backend, Error **errp)
     backend->conf.peers.ccs[0] = cc;
 
     backend->conf.crypto_services =
-        1u << QCRYPTODEV_BACKEND_SERVICE_AKCIPHER;
+        1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_AKCIPHER;
     backend->conf.akcipher_algo = 1u << VIRTIO_CRYPTO_AKCIPHER_RSA;
     lkcf->running = true;
 
diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index c3283ba84a..e33fb78521 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -221,9 +221,9 @@ static void cryptodev_vhost_user_init(
                      cryptodev_vhost_user_event, NULL, s, NULL, true);
 
     backend->conf.crypto_services =
-                         1u << QCRYPTODEV_BACKEND_SERVICE_CIPHER |
-                         1u << QCRYPTODEV_BACKEND_SERVICE_HASH |
-                         1u << QCRYPTODEV_BACKEND_SERVICE_MAC;
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_CIPHER |
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_HASH |
+                         1u << QCRYPTODEV_BACKEND_SERVICE_TYPE_MAC;
     backend->conf.cipher_algo_l = 1u << VIRTIO_CRYPTO_CIPHER_AES_CBC;
     backend->conf.hash_algo = 1u << VIRTIO_CRYPTO_HASH_SHA1;
 
diff --git a/backends/cryptodev.c b/backends/cryptodev.c
index fff89fd62a..76dfe65904 100644
--- a/backends/cryptodev.c
+++ b/backends/cryptodev.c
@@ -74,7 +74,7 @@ static int qmp_query_cryptodev_foreach(Object *obj, void *data)
 
     backend = CRYPTODEV_BACKEND(obj);
     services = backend->conf.crypto_services;
-    for (i = 0; i < QCRYPTODEV_BACKEND_SERVICE__MAX; i++) {
+    for (i = 0; i < QCRYPTODEV_BACKEND_SERVICE_TYPE__MAX; i++) {
         if (services & (1 << i)) {
             QAPI_LIST_PREPEND(info->service, i);
         }
@@ -424,11 +424,11 @@ cryptodev_backend_complete(UserCreatable *uc, Error **errp)
     }
 
     services = backend->conf.crypto_services;
-    if (services & (1 << QCRYPTODEV_BACKEND_SERVICE_CIPHER)) {
+    if (services & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_CIPHER)) {
         backend->sym_stat = g_new0(CryptodevBackendSymStat, 1);
     }
 
-    if (services & (1 << QCRYPTODEV_BACKEND_SERVICE_AKCIPHER)) {
+    if (services & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_AKCIPHER)) {
         backend->asym_stat = g_new0(CryptodevBackendAsymStat, 1);
     }
 }
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 5034768bff..0ab8ae3282 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -1008,19 +1008,19 @@ static uint32_t virtio_crypto_init_services(uint32_t qservices)
 {
     uint32_t vservices = 0;
 
-    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_CIPHER)) {
+    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_CIPHER)) {
         vservices |= (1 << VIRTIO_CRYPTO_SERVICE_CIPHER);
     }
-    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_HASH)) {
+    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_HASH)) {
         vservices |= (1 << VIRTIO_CRYPTO_SERVICE_HASH);
     }
-    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_MAC)) {
+    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_MAC)) {
         vservices |= (1 << VIRTIO_CRYPTO_SERVICE_MAC);
     }
-    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_AEAD)) {
+    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_AEAD)) {
         vservices |= (1 << VIRTIO_CRYPTO_SERVICE_AEAD);
     }
-    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_AKCIPHER)) {
+    if (qservices & (1 << QCRYPTODEV_BACKEND_SERVICE_TYPE_AKCIPHER)) {
         vservices |= (1 << VIRTIO_CRYPTO_SERVICE_AKCIPHER);
     }
 
-- 
2.45.0


