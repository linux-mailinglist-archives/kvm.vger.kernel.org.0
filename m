Return-Path: <kvm+bounces-22631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 801BA940AFB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B7571F234AE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375721922F6;
	Tue, 30 Jul 2024 08:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="alEALcMH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855C18D4DC
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327067; cv=none; b=Kjh5qPfrsUR4oNyccmuq1eI5vfXHdw1jJhvRXXLwlJr/ERfivmF15olGlEMrTBheF3U0m7X9zT2EnLdmenFbb+/jXMO9SO70FgOikjjjzz7OmylYNMnbV65sCPXWjasAABPJYyLvMyWib68Xq1+Kpk0yZ77dF2wdhgK0EFh+Rpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327067; c=relaxed/simple;
	bh=BM73ylrczlZglWee6D+sIihjK+h6f7S4Rxwv9enG1QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=us5r5I4Mi/tz/2XN35C6EuFd0LD/ohL1Fwd95siRQxhQ9hpmy2xQW2oqetriUtUIAoRih50aZf30DGkIYZJQQ6/ITBiDOnVjG/pjKizkyUquSBryOuvM0hiNp+kcZZnQ8SeY6X4+XZjc9PMrVnhxiTzrjcC9pT3DhCmsM+9YE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=alEALcMH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yyh6fsAVLJigAc5J2Kyd3aADvei1GeeZmy+DnRZmGtk=;
	b=alEALcMH4IjDy903i7va2y3QIjiX0T2jZsTM5rQRg/wt2cBVNb89BA9PWCKBUV+puzA/zI
	0Yoe7ww54DXmz7PX4kqbjDFeGSZI5wrACmKBpaXEhlu+4zSMCiaYJ+2mRYmFjWGoPkMBPZ
	uEahj+NANUvV7W+C3Jx4fKXfSsb5KxY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-kO77dZJdNCCsndwFrZ3f8Q-1; Tue,
 30 Jul 2024 04:10:47 -0400
X-MC-Unique: kO77dZJdNCCsndwFrZ3f8Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6673E195608B;
	Tue, 30 Jul 2024 08:10:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BBE21955D42;
	Tue, 30 Jul 2024 08:10:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id EFA8121E668F; Tue, 30 Jul 2024 10:10:32 +0200 (CEST)
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
Subject: [PATCH 10/18] qapi/crypto: Drop unwanted 'prefix'
Date: Tue, 30 Jul 2024 10:10:24 +0200
Message-ID: <20240730081032.1246748-11-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

QCryptoAkCipherKeyType has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTO_AKCIPHER_KEY_TYPE.

Drop it.  The prefix becomes QCRYPTO_AK_CIPHER_KEY_TYPE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/crypto.json                        |  1 -
 backends/cryptodev-builtin.c            |  4 ++--
 backends/cryptodev-lkcf.c               |  6 +++---
 tests/bench/benchmark-crypto-akcipher.c |  2 +-
 tests/unit/test-crypto-akcipher.c       | 28 ++++++++++++-------------
 crypto/akcipher-gcrypt.c.inc            |  8 +++----
 crypto/akcipher-nettle.c.inc            |  8 +++----
 crypto/rsakey-builtin.c.inc             |  4 ++--
 crypto/rsakey-nettle.c.inc              |  4 ++--
 9 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 42d321fdcb..aafb5d5c8d 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -609,7 +609,6 @@
 # Since: 7.1
 ##
 { 'enum': 'QCryptoAkCipherKeyType',
-  'prefix': 'QCRYPTO_AKCIPHER_KEY_TYPE',
   'data': ['public', 'private']}
 
 ##
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 940104ee55..e95af9bb72 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -334,11 +334,11 @@ static int cryptodev_builtin_create_akcipher_session(
 
     switch (sess_info->keytype) {
     case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
-        type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC;
+        type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC;
         break;
 
     case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
-        type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
+        type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE;
         break;
 
     default:
diff --git a/backends/cryptodev-lkcf.c b/backends/cryptodev-lkcf.c
index 45aba1ff67..e1ee11a158 100644
--- a/backends/cryptodev-lkcf.c
+++ b/backends/cryptodev-lkcf.c
@@ -322,7 +322,7 @@ static void cryptodev_lkcf_execute_task(CryptoDevLKCFTask *task)
      * 2. generally, public key related compution is fast, just compute it with
      * thread-pool.
      */
-    if (session->keytype == QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE) {
+    if (session->keytype == QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE) {
         if (qcrypto_akcipher_export_p8info(&session->akcipher_opts,
                                            session->key, session->keylen,
                                            &p8info, &p8info_len,
@@ -534,11 +534,11 @@ static int cryptodev_lkcf_create_asym_session(
 
     switch (sess_info->keytype) {
     case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
-        sess->keytype = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC;
+        sess->keytype = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC;
         break;
 
     case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
-        sess->keytype = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
+        sess->keytype = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE;
         break;
 
     default:
diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
index 5e68cb0a1c..bbc29c9b12 100644
--- a/tests/bench/benchmark-crypto-akcipher.c
+++ b/tests/bench/benchmark-crypto-akcipher.c
@@ -28,7 +28,7 @@ static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
     opt.alg = QCRYPTO_AKCIPHER_ALG_RSA;
     opt.u.rsa.padding_alg = padding;
     opt.u.rsa.hash_alg = hash;
-    return qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+    return qcrypto_akcipher_new(&opt, QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
                                 priv_key, keylen, &error_abort);
 }
 
diff --git a/tests/unit/test-crypto-akcipher.c b/tests/unit/test-crypto-akcipher.c
index 4f1f4214dd..59bc6f1e69 100644
--- a/tests/unit/test-crypto-akcipher.c
+++ b/tests/unit/test-crypto-akcipher.c
@@ -692,7 +692,7 @@ struct QCryptoAkCipherTestData {
 static QCryptoRSAKeyTestData rsakey_test_data[] = {
     {
         .path = "/crypto/akcipher/rsakey-1024-public",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa1024_public_key,
         .keylen = sizeof(rsa1024_public_key),
         .is_valid_key = true,
@@ -700,7 +700,7 @@ static QCryptoRSAKeyTestData rsakey_test_data[] = {
     },
     {
         .path = "/crypto/akcipher/rsakey-1024-private",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
         .key = rsa1024_private_key,
         .keylen = sizeof(rsa1024_private_key),
         .is_valid_key = true,
@@ -708,7 +708,7 @@ static QCryptoRSAKeyTestData rsakey_test_data[] = {
     },
     {
         .path = "/crypto/akcipher/rsakey-2048-public",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa2048_public_key,
         .keylen = sizeof(rsa2048_public_key),
         .is_valid_key = true,
@@ -716,7 +716,7 @@ static QCryptoRSAKeyTestData rsakey_test_data[] = {
     },
     {
         .path = "/crypto/akcipher/rsakey-2048-private",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
         .key = rsa2048_private_key,
         .keylen = sizeof(rsa2048_private_key),
         .is_valid_key = true,
@@ -724,56 +724,56 @@ static QCryptoRSAKeyTestData rsakey_test_data[] = {
     },
     {
         .path = "/crypto/akcipher/rsakey-public-lack-elem",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa_public_key_lack_element,
         .keylen = sizeof(rsa_public_key_lack_element),
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-private-lack-elem",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
         .key = rsa_private_key_lack_element,
         .keylen = sizeof(rsa_private_key_lack_element),
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-public-empty-elem",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa_public_key_empty_element,
         .keylen = sizeof(rsa_public_key_empty_element),
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-private-empty-elem",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
         .key = rsa_private_key_empty_element,
         .keylen = sizeof(rsa_private_key_empty_element),
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-public-empty-key",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = NULL,
         .keylen = 0,
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-private-empty-key",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
         .key = NULL,
         .keylen = 0,
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-public-invalid-length-val",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa_public_key_invalid_length_val,
         .keylen = sizeof(rsa_public_key_invalid_length_val),
         .is_valid_key = false,
     },
     {
         .path = "/crypto/akcipher/rsakey-public-extra-elem",
-        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key_type = QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
         .key = rsa_public_key_extra_elem,
         .keylen = sizeof(rsa_public_key_extra_elem),
         .is_valid_key = false,
@@ -885,12 +885,12 @@ static void test_akcipher(const void *opaque)
         return;
     }
     pub_key = qcrypto_akcipher_new(&data->opt,
-                                   QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+                                   QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC,
                                    data->pub_key, data->pub_key_len,
                                    &error_abort);
     g_assert(pub_key != NULL);
     priv_key = qcrypto_akcipher_new(&data->opt,
-                                    QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+                                    QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
                                     data->priv_key, data->priv_key_len,
                                     &error_abort);
     g_assert(priv_key != NULL);
diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
index abb1fb272e..e942d43421 100644
--- a/crypto/akcipher-gcrypt.c.inc
+++ b/crypto/akcipher-gcrypt.c.inc
@@ -85,7 +85,7 @@ static int qcrypto_gcrypt_parse_rsa_private_key(
     const uint8_t *key, size_t keylen, Error **errp)
 {
     g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
-        QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE, key, keylen, errp);
+        QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE, key, keylen, errp);
     gcry_mpi_t n = NULL, e = NULL, d = NULL, p = NULL, q = NULL, u = NULL;
     bool compute_mul_inv = false;
     int ret = -1;
@@ -178,7 +178,7 @@ static int qcrypto_gcrypt_parse_rsa_public_key(QCryptoGcryptRSA *rsa,
 {
 
     g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
-        QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC, key, keylen, errp);
+        QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC, key, keylen, errp);
     gcry_mpi_t n = NULL, e = NULL;
     int ret = -1;
     gcry_error_t err;
@@ -540,13 +540,13 @@ static QCryptoGcryptRSA *qcrypto_gcrypt_rsa_new(
     rsa->akcipher.driver = &gcrypt_rsa;
 
     switch (type) {
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE:
         if (qcrypto_gcrypt_parse_rsa_private_key(rsa, key, keylen, errp) != 0) {
             goto error;
         }
         break;
 
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC:
         if (qcrypto_gcrypt_parse_rsa_public_key(rsa, key, keylen, errp) != 0) {
             goto error;
         }
diff --git a/crypto/akcipher-nettle.c.inc b/crypto/akcipher-nettle.c.inc
index 02699e6e6d..62ac8699c4 100644
--- a/crypto/akcipher-nettle.c.inc
+++ b/crypto/akcipher-nettle.c.inc
@@ -87,7 +87,7 @@ static int qcrypt_nettle_parse_rsa_private_key(QCryptoNettleRSA *rsa,
                                                Error **errp)
 {
     g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
-        QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE, key, keylen, errp);
+        QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE, key, keylen, errp);
 
     if (!rsa_key) {
         return -1;
@@ -137,7 +137,7 @@ static int qcrypt_nettle_parse_rsa_public_key(QCryptoNettleRSA *rsa,
                                               Error **errp)
 {
     g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
-        QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC, key, keylen, errp);
+        QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC, key, keylen, errp);
 
     if (!rsa_key) {
         return -1;
@@ -397,13 +397,13 @@ static QCryptoAkCipher *qcrypto_nettle_rsa_new(
     rsa_private_key_init(&rsa->priv);
 
     switch (type) {
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE:
         if (qcrypt_nettle_parse_rsa_private_key(rsa, key, keylen, errp) != 0) {
             goto error;
         }
         break;
 
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC:
         if (qcrypt_nettle_parse_rsa_public_key(rsa, key, keylen, errp) != 0) {
             goto error;
         }
diff --git a/crypto/rsakey-builtin.c.inc b/crypto/rsakey-builtin.c.inc
index 46cc7afe87..6337b84c54 100644
--- a/crypto/rsakey-builtin.c.inc
+++ b/crypto/rsakey-builtin.c.inc
@@ -183,10 +183,10 @@ QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
     size_t keylen, Error **errp)
 {
     switch (type) {
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE:
         return qcrypto_builtin_rsa_private_key_parse(key, keylen, errp);
 
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC:
         return qcrypto_builtin_rsa_public_key_parse(key, keylen, errp);
 
     default:
diff --git a/crypto/rsakey-nettle.c.inc b/crypto/rsakey-nettle.c.inc
index cc49872e78..b7f34b0234 100644
--- a/crypto/rsakey-nettle.c.inc
+++ b/crypto/rsakey-nettle.c.inc
@@ -145,10 +145,10 @@ QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
     size_t keylen, Error **errp)
 {
     switch (type) {
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE:
         return qcrypto_nettle_rsa_private_key_parse(key, keylen, errp);
 
-    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+    case QCRYPTO_AK_CIPHER_KEY_TYPE_PUBLIC:
         return qcrypto_nettle_rsa_public_key_parse(key, keylen, errp);
 
     default:
-- 
2.45.0


