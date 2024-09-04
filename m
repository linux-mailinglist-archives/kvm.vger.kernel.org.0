Return-Path: <kvm+bounces-25858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E92C96BA4B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EDBF1F2113E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B7D1DA2FF;
	Wed,  4 Sep 2024 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODHymXZs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39231D54EF
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448738; cv=none; b=F9t2gGSgErjGzvbs0HvvjUx3mbkv/BYojzZ60vpUXLZUclbRYdCNNEFRE1QlcZXxeqRJq4eoPlX3TtV+RFRPpGYSWgrinSlffc2OUxKACtG/9jYVl3vJnXyg5FiD+mK+4ASJk+raXXgFlmN9PsI32wo7SO0fjvRdXaZn9JgVEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448738; c=relaxed/simple;
	bh=Ocukc/m3MDTmoBhu9vA1MEr/6Tst921KGZMpmuUlaAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIWMEv0tGjEMeg0qvJu4lvW9rXqq8TDdhrsc6JFVPYdu+Daimk5cPa/gwgOt4khCuG80NxXUSn92tlmKR/LssZGIhhKAVa7LK8nL2c/lqRZ4Rpn93Y4X0xHs+DOPN2ZWJ1rxYqBZYv/FylyJeMEHmPJR3DBJWfc2ozZuKAgu+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODHymXZs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oh/NCqjRTQGWDv+iIQfkI/24tYYyPpV/TrHZbGUd03w=;
	b=ODHymXZsVJ5mySFb4wFwxr2W9orPTE1JyZdbA8gI72haSw/XbNHAVTpcUHBcehBwraxQ1Q
	HyHBEv53v2rBAkrWr1KO/0MrT15kmi3Avxv8rIJQ1vlJXTUNTz0w7CnTpI5oW2o69F/wiF
	Cr+ctbJosJdW2eZwyZfHIMDbGnNNHkU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-vgWluKH0OjuyiNqi3QfSzw-1; Wed,
 04 Sep 2024 07:18:51 -0400
X-MC-Unique: vgWluKH0OjuyiNqi3QfSzw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98C6D1956057;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F78D1956094;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DB87221E683A; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 17/19] qapi/cryptodev: Drop unwanted 'prefix'
Date: Wed,  4 Sep 2024 13:18:34 +0200
Message-ID: <20240904111836.3273842-18-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

QCryptodevBackendServiceType has a 'prefix' that overrides the
generated enumeration constants' prefix to QCRYPTODEV_BACKEND_SERVICE.

Drop it.  The prefix becomes QCRYPTODEV_BACKEND_SERVICE_TYPE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
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
2.46.0


