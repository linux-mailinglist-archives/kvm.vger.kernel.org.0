Return-Path: <kvm+bounces-25863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7551796BA50
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FE2D1F21618
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B356C1DA620;
	Wed,  4 Sep 2024 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wxa2mlk9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913B1D0956
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448739; cv=none; b=spBzJP+khYZc1JzRalKMr5Bztzi3zmnxk1IffhHW+zDi0Cpymd3qgT4CRRp7OTx+bMlEkh43h4DKkxkEO4G4yqU5n3+RB+EH/6vk4KGfNSMb4Xxtl7aKE15oJQ4I9VAa16MTwkGgeBth/div6FlCouoBL8lESUkdVX8FXOn8JLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448739; c=relaxed/simple;
	bh=iWhE8IRT9cIM65C4xMXiqipmWWkWWMNTho5USBFyuRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adTXQrgm0vA3u+vXWppiwYUYUvNfWKfnKm+gQuwAaoJv2/3AEmAVL24VMzj+YlwH/jEymj/N/YCBr6pX0emEIpo0tzz65VK1hERmz4u5FRyfFyf45qFRcrDj+Er7EKUSJSM4l9EwFpfOnWe3BZi5skQQi46yw548xEQWlEPACcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wxa2mlk9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3uQt/+SiPIadLyzyyQpdBIqIRk2kr2aqhw0ZJtjfdY=;
	b=Wxa2mlk9Rn2Xal2qINT1z9YpWbKwxLVxB5aN7aBcMUceSI0GsLf2f2ljd2Pvb2fqPx8ddv
	x0dcb3uef+7jT7k/RF3e7nUwhMsWKwbQdclnoLIwa/yP0nkd1oHQBcU1m8pxzPD8x5IH19
	e3uR7FWeeAcGaFWjQBjbQgDI2EUgp1M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-6Jl6ORluM_atKYsEPg3h4w-1; Wed,
 04 Sep 2024 07:18:51 -0400
X-MC-Unique: 6Jl6ORluM_atKYsEPg3h4w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3D361955D45;
	Wed,  4 Sep 2024 11:18:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E30A51956088;
	Wed,  4 Sep 2024 11:18:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C452C21E682A; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 12/19] qapi/crypto: Rename QCryptoCipherAlgorithm to *Algo, and drop prefix
Date: Wed,  4 Sep 2024 13:18:29 +0200
Message-ID: <20240904111836.3273842-13-armbru@redhat.com>
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

QCryptoCipherAlgorithm has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTO_CIPHER_ALG.

We could simply drop 'prefix', but then the prefix becomes
QCRYPTO_CIPHER_ALGORITHM, which is rather long.

We could additionally rename the type to QCryptoCipherAlg, but I think
the abbreviation "alg" is less than clear.

Rename the type to QCryptoCipherAlgo instead.  The prefix becomes
QCRYPTO_CIPHER_ALGO.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Acked-by: Daniel P. Berrangé <berrange@redhat.com>
---
 qapi/block-core.json                  |  2 +-
 qapi/crypto.json                      |  9 ++-
 crypto/blockpriv.h                    |  4 +-
 crypto/cipherpriv.h                   |  2 +-
 crypto/ivgenpriv.h                    |  2 +-
 include/crypto/cipher.h               | 18 +++---
 include/crypto/ivgen.h                | 10 +--
 include/crypto/pbkdf.h                |  4 +-
 backends/cryptodev-builtin.c          | 16 ++---
 block/rbd.c                           |  4 +-
 crypto/block-luks.c                   | 92 +++++++++++++--------------
 crypto/block-qcow.c                   |  4 +-
 crypto/block.c                        |  2 +-
 crypto/cipher-afalg.c                 | 24 +++----
 crypto/cipher.c                       | 72 ++++++++++-----------
 crypto/ivgen.c                        |  4 +-
 crypto/secret_common.c                |  2 +-
 tests/bench/benchmark-crypto-cipher.c | 22 +++----
 tests/unit/test-crypto-block.c        | 14 ++--
 tests/unit/test-crypto-cipher.c       | 66 +++++++++----------
 tests/unit/test-crypto-ivgen.c        |  8 +--
 ui/vnc.c                              |  4 +-
 crypto/cipher-builtin.c.inc           | 18 +++---
 crypto/cipher-gcrypt.c.inc            | 56 ++++++++--------
 crypto/cipher-gnutls.c.inc            | 38 +++++------
 crypto/cipher-nettle.c.inc            | 58 ++++++++---------
 26 files changed, 277 insertions(+), 278 deletions(-)

diff --git a/qapi/block-core.json b/qapi/block-core.json
index a7ae2da47b..9f6dd59298 100644
--- a/qapi/block-core.json
+++ b/qapi/block-core.json
@@ -4163,7 +4163,7 @@
 ##
 { 'struct': 'RbdEncryptionCreateOptionsLUKSBase',
   'base': 'RbdEncryptionOptionsLUKSBase',
-  'data': { '*cipher-alg': 'QCryptoCipherAlgorithm' } }
+  'data': { '*cipher-alg': 'QCryptoCipherAlgo' } }
 
 ##
 # @RbdEncryptionOptionsLUKS:
diff --git a/qapi/crypto.json b/qapi/crypto.json
index 68393568cf..0591d62f67 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -62,7 +62,7 @@
   'data': ['md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'ripemd160']}
 
 ##
-# @QCryptoCipherAlgorithm:
+# @QCryptoCipherAlgo:
 #
 # The supported algorithms for content encryption ciphers
 #
@@ -95,8 +95,7 @@
 #
 # Since: 2.6
 ##
-{ 'enum': 'QCryptoCipherAlgorithm',
-  'prefix': 'QCRYPTO_CIPHER_ALG',
+{ 'enum': 'QCryptoCipherAlgo',
   'data': ['aes-128', 'aes-192', 'aes-256',
            'des', '3des',
            'cast5-128',
@@ -225,7 +224,7 @@
 ##
 { 'struct': 'QCryptoBlockCreateOptionsLUKS',
   'base': 'QCryptoBlockOptionsLUKS',
-  'data': { '*cipher-alg': 'QCryptoCipherAlgorithm',
+  'data': { '*cipher-alg': 'QCryptoCipherAlgo',
             '*cipher-mode': 'QCryptoCipherMode',
             '*ivgen-alg': 'QCryptoIVGenAlgorithm',
             '*ivgen-hash-alg': 'QCryptoHashAlgo',
@@ -322,7 +321,7 @@
 # Since: 2.7
 ##
 { 'struct': 'QCryptoBlockInfoLUKS',
-  'data': {'cipher-alg': 'QCryptoCipherAlgorithm',
+  'data': {'cipher-alg': 'QCryptoCipherAlgo',
            'cipher-mode': 'QCryptoCipherMode',
            'ivgen-alg': 'QCryptoIVGenAlgorithm',
            '*ivgen-hash-alg': 'QCryptoHashAlgo',
diff --git a/crypto/blockpriv.h b/crypto/blockpriv.h
index cf1a66c00d..edf0b3a3d9 100644
--- a/crypto/blockpriv.h
+++ b/crypto/blockpriv.h
@@ -33,7 +33,7 @@ struct QCryptoBlock {
     void *opaque;
 
     /* Cipher parameters */
-    QCryptoCipherAlgorithm alg;
+    QCryptoCipherAlgo alg;
     QCryptoCipherMode mode;
     uint8_t *key;
     size_t nkey;
@@ -132,7 +132,7 @@ int qcrypto_block_encrypt_helper(QCryptoBlock *block,
                                  Error **errp);
 
 int qcrypto_block_init_cipher(QCryptoBlock *block,
-                              QCryptoCipherAlgorithm alg,
+                              QCryptoCipherAlgo alg,
                               QCryptoCipherMode mode,
                               const uint8_t *key, size_t nkey,
                               Error **errp);
diff --git a/crypto/cipherpriv.h b/crypto/cipherpriv.h
index 396527857d..64737ce961 100644
--- a/crypto/cipherpriv.h
+++ b/crypto/cipherpriv.h
@@ -42,7 +42,7 @@ struct QCryptoCipherDriver {
 #include "afalgpriv.h"
 
 extern QCryptoCipher *
-qcrypto_afalg_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+qcrypto_afalg_cipher_ctx_new(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode,
                              const uint8_t *key,
                              size_t nkey, Error **errp);
diff --git a/crypto/ivgenpriv.h b/crypto/ivgenpriv.h
index 0227ae4d00..ef24c76345 100644
--- a/crypto/ivgenpriv.h
+++ b/crypto/ivgenpriv.h
@@ -41,7 +41,7 @@ struct QCryptoIVGen {
     void *private;
 
     QCryptoIVGenAlgorithm algorithm;
-    QCryptoCipherAlgorithm cipher;
+    QCryptoCipherAlgo cipher;
     QCryptoHashAlgo hash;
 };
 
diff --git a/include/crypto/cipher.h b/include/crypto/cipher.h
index 083e12a7d9..92939310ef 100644
--- a/include/crypto/cipher.h
+++ b/include/crypto/cipher.h
@@ -26,7 +26,7 @@
 typedef struct QCryptoCipher QCryptoCipher;
 typedef struct QCryptoCipherDriver QCryptoCipherDriver;
 
-/* See also "QCryptoCipherAlgorithm" and "QCryptoCipherMode"
+/* See also "QCryptoCipherAlgo" and "QCryptoCipherMode"
  * enums defined in qapi/crypto.json */
 
 /**
@@ -50,12 +50,12 @@ typedef struct QCryptoCipherDriver QCryptoCipherDriver;
  * size_t keylen = 16;
  * uint8_t iv = ....;
  *
- * if (!qcrypto_cipher_supports(QCRYPTO_CIPHER_ALG_AES_128)) {
+ * if (!qcrypto_cipher_supports(QCRYPTO_CIPHER_ALGO_AES_128)) {
  *    error_report(errp, "Feature <blah> requires AES cipher support");
  *    return -1;
  * }
  *
- * cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALG_AES_128,
+ * cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALGO_AES_128,
  *                             QCRYPTO_CIPHER_MODE_CBC,
  *                             key, keylen,
  *                             errp);
@@ -78,7 +78,7 @@ typedef struct QCryptoCipherDriver QCryptoCipherDriver;
  */
 
 struct QCryptoCipher {
-    QCryptoCipherAlgorithm alg;
+    QCryptoCipherAlgo alg;
     QCryptoCipherMode mode;
     const QCryptoCipherDriver *driver;
 };
@@ -93,7 +93,7 @@ struct QCryptoCipher {
  *
  * Returns: true if the algorithm is supported, false otherwise
  */
-bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
+bool qcrypto_cipher_supports(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode);
 
 /**
@@ -106,7 +106,7 @@ bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
  *
  * Returns: the block size in bytes
  */
-size_t qcrypto_cipher_get_block_len(QCryptoCipherAlgorithm alg);
+size_t qcrypto_cipher_get_block_len(QCryptoCipherAlgo alg);
 
 
 /**
@@ -117,7 +117,7 @@ size_t qcrypto_cipher_get_block_len(QCryptoCipherAlgorithm alg);
  *
  * Returns: the key size in bytes
  */
-size_t qcrypto_cipher_get_key_len(QCryptoCipherAlgorithm alg);
+size_t qcrypto_cipher_get_key_len(QCryptoCipherAlgo alg);
 
 
 /**
@@ -130,7 +130,7 @@ size_t qcrypto_cipher_get_key_len(QCryptoCipherAlgorithm alg);
  *
  * Returns: the IV size in bytes, or 0 if no IV is permitted
  */
-size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgorithm alg,
+size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgo alg,
                                  QCryptoCipherMode mode);
 
 
@@ -156,7 +156,7 @@ size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgorithm alg,
  *
  * Returns: a new cipher object, or NULL on error
  */
-QCryptoCipher *qcrypto_cipher_new(QCryptoCipherAlgorithm alg,
+QCryptoCipher *qcrypto_cipher_new(QCryptoCipherAlgo alg,
                                   QCryptoCipherMode mode,
                                   const uint8_t *key, size_t nkey,
                                   Error **errp);
diff --git a/include/crypto/ivgen.h b/include/crypto/ivgen.h
index ab5f1a648e..b059e332cd 100644
--- a/include/crypto/ivgen.h
+++ b/include/crypto/ivgen.h
@@ -45,21 +45,21 @@
  * g_assert((ndata % 512) == 0);
  *
  * QCryptoIVGen *ivgen = qcrypto_ivgen_new(QCRYPTO_IVGEN_ALG_ESSIV,
- *                                         QCRYPTO_CIPHER_ALG_AES_128,
+ *                                         QCRYPTO_CIPHER_ALGO_AES_128,
  *                                         QCRYPTO_HASH_ALGO_SHA256,
  *                                         key, nkey, errp);
  * if (!ivgen) {
  *    return -1;
  * }
  *
- * QCryptoCipher *cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALG_AES_128,
+ * QCryptoCipher *cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALGO_AES_128,
  *                                            QCRYPTO_CIPHER_MODE_CBC,
  *                                            key, nkey, errp);
  * if (!cipher) {
  *     goto error;
  * }
  *
- * niv =  qcrypto_cipher_get_iv_len(QCRYPTO_CIPHER_ALG_AES_128,
+ * niv =  qcrypto_cipher_get_iv_len(QCRYPTO_CIPHER_ALGO_AES_128,
  *                                  QCRYPTO_CIPHER_MODE_CBC);
  * iv = g_new0(uint8_t, niv);
  *
@@ -134,7 +134,7 @@ typedef struct QCryptoIVGen QCryptoIVGen;
  * Returns: a new IV generator, or NULL on error
  */
 QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
-                                QCryptoCipherAlgorithm cipheralg,
+                                QCryptoCipherAlgo cipheralg,
                                 QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
                                 Error **errp);
@@ -179,7 +179,7 @@ QCryptoIVGenAlgorithm qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen);
  *
  * Returns: the cipher algorithm
  */
-QCryptoCipherAlgorithm qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen);
+QCryptoCipherAlgo qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen);
 
 
 /**
diff --git a/include/crypto/pbkdf.h b/include/crypto/pbkdf.h
index 6cf29e78ee..cf59fce610 100644
--- a/include/crypto/pbkdf.h
+++ b/include/crypto/pbkdf.h
@@ -38,7 +38,7 @@
  * ....
  *
  * char *password = "a-typical-awful-user-password";
- * size_t nkey = qcrypto_cipher_get_key_len(QCRYPTO_CIPHER_ALG_AES_128);
+ * size_t nkey = qcrypto_cipher_get_key_len(QCRYPTO_CIPHER_ALGO_AES_128);
  * uint8_t *salt = g_new0(uint8_t, nkey);
  * uint8_t *key = g_new0(uint8_t, nkey);
  * int iterations;
@@ -70,7 +70,7 @@
  *
  * g_free(salt);
  *
- * cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALG_AES_128,
+ * cipher = qcrypto_cipher_new(QCRYPTO_CIPHER_ALGO_AES_128,
  *                             QCRYPTO_CIPHER_MODE_ECB,
  *                             key, nkey, errp);
  * g_free(key);
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 4a49d328ec..2672755661 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -138,18 +138,18 @@ cryptodev_builtin_get_aes_algo(uint32_t key_len, int mode, Error **errp)
     int algo;
 
     if (key_len == AES_KEYSIZE_128) {
-        algo = QCRYPTO_CIPHER_ALG_AES_128;
+        algo = QCRYPTO_CIPHER_ALGO_AES_128;
     } else if (key_len == AES_KEYSIZE_192) {
-        algo = QCRYPTO_CIPHER_ALG_AES_192;
+        algo = QCRYPTO_CIPHER_ALGO_AES_192;
     } else if (key_len == AES_KEYSIZE_256) { /* equals AES_KEYSIZE_128_XTS */
         if (mode == QCRYPTO_CIPHER_MODE_XTS) {
-            algo = QCRYPTO_CIPHER_ALG_AES_128;
+            algo = QCRYPTO_CIPHER_ALGO_AES_128;
         } else {
-            algo = QCRYPTO_CIPHER_ALG_AES_256;
+            algo = QCRYPTO_CIPHER_ALGO_AES_256;
         }
     } else if (key_len == AES_KEYSIZE_256_XTS) {
         if (mode == QCRYPTO_CIPHER_MODE_XTS) {
-            algo = QCRYPTO_CIPHER_ALG_AES_256;
+            algo = QCRYPTO_CIPHER_ALGO_AES_256;
         } else {
             goto err;
         }
@@ -271,15 +271,15 @@ static int cryptodev_builtin_create_cipher_session(
         break;
     case VIRTIO_CRYPTO_CIPHER_3DES_ECB:
         mode = QCRYPTO_CIPHER_MODE_ECB;
-        algo = QCRYPTO_CIPHER_ALG_3DES;
+        algo = QCRYPTO_CIPHER_ALGO_3DES;
         break;
     case VIRTIO_CRYPTO_CIPHER_3DES_CBC:
         mode = QCRYPTO_CIPHER_MODE_CBC;
-        algo = QCRYPTO_CIPHER_ALG_3DES;
+        algo = QCRYPTO_CIPHER_ALGO_3DES;
         break;
     case VIRTIO_CRYPTO_CIPHER_3DES_CTR:
         mode = QCRYPTO_CIPHER_MODE_CTR;
-        algo = QCRYPTO_CIPHER_ALG_3DES;
+        algo = QCRYPTO_CIPHER_ALGO_3DES;
         break;
     default:
         error_setg(errp, "Unsupported cipher alg :%u",
diff --git a/block/rbd.c b/block/rbd.c
index 9c0fd0cb3f..04ed0e242e 100644
--- a/block/rbd.c
+++ b/block/rbd.c
@@ -367,11 +367,11 @@ static int qemu_rbd_convert_luks_create_options(
 
     if (luks_opts->has_cipher_alg) {
         switch (luks_opts->cipher_alg) {
-            case QCRYPTO_CIPHER_ALG_AES_128: {
+            case QCRYPTO_CIPHER_ALGO_AES_128: {
                 *alg = RBD_ENCRYPTION_ALGORITHM_AES128;
                 break;
             }
-            case QCRYPTO_CIPHER_ALG_AES_256: {
+            case QCRYPTO_CIPHER_ALGO_AES_256: {
                 *alg = RBD_ENCRYPTION_ALGORITHM_AES256;
                 break;
             }
diff --git a/crypto/block-luks.c b/crypto/block-luks.c
index 59af733b8c..8eadf124fc 100644
--- a/crypto/block-luks.c
+++ b/crypto/block-luks.c
@@ -68,38 +68,38 @@ struct QCryptoBlockLUKSCipherNameMap {
 
 static const QCryptoBlockLUKSCipherSizeMap
 qcrypto_block_luks_cipher_size_map_aes[] = {
-    { 16, QCRYPTO_CIPHER_ALG_AES_128 },
-    { 24, QCRYPTO_CIPHER_ALG_AES_192 },
-    { 32, QCRYPTO_CIPHER_ALG_AES_256 },
+    { 16, QCRYPTO_CIPHER_ALGO_AES_128 },
+    { 24, QCRYPTO_CIPHER_ALGO_AES_192 },
+    { 32, QCRYPTO_CIPHER_ALGO_AES_256 },
     { 0, 0 },
 };
 
 static const QCryptoBlockLUKSCipherSizeMap
 qcrypto_block_luks_cipher_size_map_cast5[] = {
-    { 16, QCRYPTO_CIPHER_ALG_CAST5_128 },
+    { 16, QCRYPTO_CIPHER_ALGO_CAST5_128 },
     { 0, 0 },
 };
 
 static const QCryptoBlockLUKSCipherSizeMap
 qcrypto_block_luks_cipher_size_map_serpent[] = {
-    { 16, QCRYPTO_CIPHER_ALG_SERPENT_128 },
-    { 24, QCRYPTO_CIPHER_ALG_SERPENT_192 },
-    { 32, QCRYPTO_CIPHER_ALG_SERPENT_256 },
+    { 16, QCRYPTO_CIPHER_ALGO_SERPENT_128 },
+    { 24, QCRYPTO_CIPHER_ALGO_SERPENT_192 },
+    { 32, QCRYPTO_CIPHER_ALGO_SERPENT_256 },
     { 0, 0 },
 };
 
 static const QCryptoBlockLUKSCipherSizeMap
 qcrypto_block_luks_cipher_size_map_twofish[] = {
-    { 16, QCRYPTO_CIPHER_ALG_TWOFISH_128 },
-    { 24, QCRYPTO_CIPHER_ALG_TWOFISH_192 },
-    { 32, QCRYPTO_CIPHER_ALG_TWOFISH_256 },
+    { 16, QCRYPTO_CIPHER_ALGO_TWOFISH_128 },
+    { 24, QCRYPTO_CIPHER_ALGO_TWOFISH_192 },
+    { 32, QCRYPTO_CIPHER_ALGO_TWOFISH_256 },
     { 0, 0 },
 };
 
 #ifdef CONFIG_CRYPTO_SM4
 static const QCryptoBlockLUKSCipherSizeMap
 qcrypto_block_luks_cipher_size_map_sm4[] = {
-    { 16, QCRYPTO_CIPHER_ALG_SM4},
+    { 16, QCRYPTO_CIPHER_ALGO_SM4},
     { 0, 0 },
 };
 #endif
@@ -123,7 +123,7 @@ struct QCryptoBlockLUKS {
     QCryptoBlockLUKSHeader header;
 
     /* Main encryption algorithm used for encryption*/
-    QCryptoCipherAlgorithm cipher_alg;
+    QCryptoCipherAlgo cipher_alg;
 
     /* Mode of encryption for the selected encryption algorithm */
     QCryptoCipherMode cipher_mode;
@@ -138,7 +138,7 @@ struct QCryptoBlockLUKS {
      * Encryption algorithm used for IV generation.
      * Usually the same as main encryption algorithm
      */
-    QCryptoCipherAlgorithm ivgen_cipher_alg;
+    QCryptoCipherAlgo ivgen_cipher_alg;
 
     /* Hash algorithm used in pbkdf2 function */
     QCryptoHashAlgo hash_alg;
@@ -179,7 +179,7 @@ static int qcrypto_block_luks_cipher_name_lookup(const char *name,
 }
 
 static const char *
-qcrypto_block_luks_cipher_alg_lookup(QCryptoCipherAlgorithm alg,
+qcrypto_block_luks_cipher_alg_lookup(QCryptoCipherAlgo alg,
                                      Error **errp)
 {
     const QCryptoBlockLUKSCipherNameMap *map =
@@ -195,7 +195,7 @@ qcrypto_block_luks_cipher_alg_lookup(QCryptoCipherAlgorithm alg,
     }
 
     error_setg(errp, "Algorithm '%s' not supported",
-               QCryptoCipherAlgorithm_str(alg));
+               QCryptoCipherAlgo_str(alg));
     return NULL;
 }
 
@@ -262,8 +262,8 @@ qcrypto_block_luks_has_format(const uint8_t *buf,
  * the cipher since that gets a key length matching the digest
  * size, not AES 128 with truncated digest as might be imagined
  */
-static QCryptoCipherAlgorithm
-qcrypto_block_luks_essiv_cipher(QCryptoCipherAlgorithm cipher,
+static QCryptoCipherAlgo
+qcrypto_block_luks_essiv_cipher(QCryptoCipherAlgo cipher,
                                 QCryptoHashAlgo hash,
                                 Error **errp)
 {
@@ -274,54 +274,54 @@ qcrypto_block_luks_essiv_cipher(QCryptoCipherAlgorithm cipher,
     }
 
     switch (cipher) {
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         if (digestlen == qcrypto_cipher_get_key_len(
-                QCRYPTO_CIPHER_ALG_AES_128)) {
-            return QCRYPTO_CIPHER_ALG_AES_128;
+                QCRYPTO_CIPHER_ALGO_AES_128)) {
+            return QCRYPTO_CIPHER_ALGO_AES_128;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_AES_192)) {
-            return QCRYPTO_CIPHER_ALG_AES_192;
+                       QCRYPTO_CIPHER_ALGO_AES_192)) {
+            return QCRYPTO_CIPHER_ALGO_AES_192;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_AES_256)) {
-            return QCRYPTO_CIPHER_ALG_AES_256;
+                       QCRYPTO_CIPHER_ALGO_AES_256)) {
+            return QCRYPTO_CIPHER_ALGO_AES_256;
         } else {
             error_setg(errp, "No AES cipher with key size %zu available",
                        digestlen);
             return 0;
         }
         break;
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
         if (digestlen == qcrypto_cipher_get_key_len(
-                QCRYPTO_CIPHER_ALG_SERPENT_128)) {
-            return QCRYPTO_CIPHER_ALG_SERPENT_128;
+                QCRYPTO_CIPHER_ALGO_SERPENT_128)) {
+            return QCRYPTO_CIPHER_ALGO_SERPENT_128;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_SERPENT_192)) {
-            return QCRYPTO_CIPHER_ALG_SERPENT_192;
+                       QCRYPTO_CIPHER_ALGO_SERPENT_192)) {
+            return QCRYPTO_CIPHER_ALGO_SERPENT_192;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_SERPENT_256)) {
-            return QCRYPTO_CIPHER_ALG_SERPENT_256;
+                       QCRYPTO_CIPHER_ALGO_SERPENT_256)) {
+            return QCRYPTO_CIPHER_ALGO_SERPENT_256;
         } else {
             error_setg(errp, "No Serpent cipher with key size %zu available",
                        digestlen);
             return 0;
         }
         break;
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_192:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_192:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
         if (digestlen == qcrypto_cipher_get_key_len(
-                QCRYPTO_CIPHER_ALG_TWOFISH_128)) {
-            return QCRYPTO_CIPHER_ALG_TWOFISH_128;
+                QCRYPTO_CIPHER_ALGO_TWOFISH_128)) {
+            return QCRYPTO_CIPHER_ALGO_TWOFISH_128;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_TWOFISH_192)) {
-            return QCRYPTO_CIPHER_ALG_TWOFISH_192;
+                       QCRYPTO_CIPHER_ALGO_TWOFISH_192)) {
+            return QCRYPTO_CIPHER_ALGO_TWOFISH_192;
         } else if (digestlen == qcrypto_cipher_get_key_len(
-                       QCRYPTO_CIPHER_ALG_TWOFISH_256)) {
-            return QCRYPTO_CIPHER_ALG_TWOFISH_256;
+                       QCRYPTO_CIPHER_ALGO_TWOFISH_256)) {
+            return QCRYPTO_CIPHER_ALGO_TWOFISH_256;
         } else {
             error_setg(errp, "No Twofish cipher with key size %zu available",
                        digestlen);
@@ -330,7 +330,7 @@ qcrypto_block_luks_essiv_cipher(QCryptoCipherAlgorithm cipher,
         break;
     default:
         error_setg(errp, "Cipher %s not supported with essiv",
-                   QCryptoCipherAlgorithm_str(cipher));
+                   QCryptoCipherAlgo_str(cipher));
         return 0;
     }
 }
@@ -1322,7 +1322,7 @@ qcrypto_block_luks_create(QCryptoBlock *block,
         luks_opts.iter_time = QCRYPTO_BLOCK_LUKS_DEFAULT_ITER_TIME_MS;
     }
     if (!luks_opts.has_cipher_alg) {
-        luks_opts.cipher_alg = QCRYPTO_CIPHER_ALG_AES_256;
+        luks_opts.cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256;
     }
     if (!luks_opts.has_cipher_mode) {
         luks_opts.cipher_mode = QCRYPTO_CIPHER_MODE_XTS;
diff --git a/crypto/block-qcow.c b/crypto/block-qcow.c
index 42e9556e42..a0ba9c1f2e 100644
--- a/crypto/block-qcow.c
+++ b/crypto/block-qcow.c
@@ -62,7 +62,7 @@ qcrypto_block_qcow_init(QCryptoBlock *block,
     memcpy(keybuf, password, MIN(len, sizeof(keybuf)));
     g_free(password);
 
-    block->niv = qcrypto_cipher_get_iv_len(QCRYPTO_CIPHER_ALG_AES_128,
+    block->niv = qcrypto_cipher_get_iv_len(QCRYPTO_CIPHER_ALGO_AES_128,
                                            QCRYPTO_CIPHER_MODE_CBC);
     block->ivgen = qcrypto_ivgen_new(QCRYPTO_IVGEN_ALG_PLAIN64,
                                      0, 0, NULL, 0, errp);
@@ -71,7 +71,7 @@ qcrypto_block_qcow_init(QCryptoBlock *block,
         goto fail;
     }
 
-    ret = qcrypto_block_init_cipher(block, QCRYPTO_CIPHER_ALG_AES_128,
+    ret = qcrypto_block_init_cipher(block, QCRYPTO_CIPHER_ALGO_AES_128,
                                     QCRYPTO_CIPHER_MODE_CBC,
                                     keybuf, G_N_ELEMENTS(keybuf),
                                     errp);
diff --git a/crypto/block.c b/crypto/block.c
index 9846caa591..96c83e60b9 100644
--- a/crypto/block.c
+++ b/crypto/block.c
@@ -267,7 +267,7 @@ static void qcrypto_block_push_cipher(QCryptoBlock *block,
 
 
 int qcrypto_block_init_cipher(QCryptoBlock *block,
-                              QCryptoCipherAlgorithm alg,
+                              QCryptoCipherAlgo alg,
                               QCryptoCipherMode mode,
                               const uint8_t *key, size_t nkey,
                               Error **errp)
diff --git a/crypto/cipher-afalg.c b/crypto/cipher-afalg.c
index 3df8fc54c0..c08eb7a39b 100644
--- a/crypto/cipher-afalg.c
+++ b/crypto/cipher-afalg.c
@@ -18,7 +18,7 @@
 
 
 static char *
-qcrypto_afalg_cipher_format_name(QCryptoCipherAlgorithm alg,
+qcrypto_afalg_cipher_format_name(QCryptoCipherAlgo alg,
                                  QCryptoCipherMode mode,
                                  Error **errp)
 {
@@ -27,22 +27,22 @@ qcrypto_afalg_cipher_format_name(QCryptoCipherAlgorithm alg,
     const char *mode_name;
 
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         alg_name = "aes";
         break;
-    case QCRYPTO_CIPHER_ALG_CAST5_128:
+    case QCRYPTO_CIPHER_ALGO_CAST5_128:
         alg_name = "cast5";
         break;
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
         alg_name = "serpent";
         break;
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_192:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_192:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
         alg_name = "twofish";
         break;
 
@@ -60,7 +60,7 @@ qcrypto_afalg_cipher_format_name(QCryptoCipherAlgorithm alg,
 static const struct QCryptoCipherDriver qcrypto_cipher_afalg_driver;
 
 QCryptoCipher *
-qcrypto_afalg_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+qcrypto_afalg_cipher_ctx_new(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode,
                              const uint8_t *key,
                              size_t nkey, Error **errp)
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 5f512768ea..c14a8b8a11 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -25,39 +25,39 @@
 #include "cipherpriv.h"
 
 
-static const size_t alg_key_len[QCRYPTO_CIPHER_ALG__MAX] = {
-    [QCRYPTO_CIPHER_ALG_AES_128] = 16,
-    [QCRYPTO_CIPHER_ALG_AES_192] = 24,
-    [QCRYPTO_CIPHER_ALG_AES_256] = 32,
-    [QCRYPTO_CIPHER_ALG_DES] = 8,
-    [QCRYPTO_CIPHER_ALG_3DES] = 24,
-    [QCRYPTO_CIPHER_ALG_CAST5_128] = 16,
-    [QCRYPTO_CIPHER_ALG_SERPENT_128] = 16,
-    [QCRYPTO_CIPHER_ALG_SERPENT_192] = 24,
-    [QCRYPTO_CIPHER_ALG_SERPENT_256] = 32,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_128] = 16,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_192] = 24,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_256] = 32,
+static const size_t alg_key_len[QCRYPTO_CIPHER_ALGO__MAX] = {
+    [QCRYPTO_CIPHER_ALGO_AES_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_AES_192] = 24,
+    [QCRYPTO_CIPHER_ALGO_AES_256] = 32,
+    [QCRYPTO_CIPHER_ALGO_DES] = 8,
+    [QCRYPTO_CIPHER_ALGO_3DES] = 24,
+    [QCRYPTO_CIPHER_ALGO_CAST5_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_192] = 24,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_256] = 32,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_192] = 24,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_256] = 32,
 #ifdef CONFIG_CRYPTO_SM4
-    [QCRYPTO_CIPHER_ALG_SM4] = 16,
+    [QCRYPTO_CIPHER_ALGO_SM4] = 16,
 #endif
 };
 
-static const size_t alg_block_len[QCRYPTO_CIPHER_ALG__MAX] = {
-    [QCRYPTO_CIPHER_ALG_AES_128] = 16,
-    [QCRYPTO_CIPHER_ALG_AES_192] = 16,
-    [QCRYPTO_CIPHER_ALG_AES_256] = 16,
-    [QCRYPTO_CIPHER_ALG_DES] = 8,
-    [QCRYPTO_CIPHER_ALG_3DES] = 8,
-    [QCRYPTO_CIPHER_ALG_CAST5_128] = 8,
-    [QCRYPTO_CIPHER_ALG_SERPENT_128] = 16,
-    [QCRYPTO_CIPHER_ALG_SERPENT_192] = 16,
-    [QCRYPTO_CIPHER_ALG_SERPENT_256] = 16,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_128] = 16,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_192] = 16,
-    [QCRYPTO_CIPHER_ALG_TWOFISH_256] = 16,
+static const size_t alg_block_len[QCRYPTO_CIPHER_ALGO__MAX] = {
+    [QCRYPTO_CIPHER_ALGO_AES_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_AES_192] = 16,
+    [QCRYPTO_CIPHER_ALGO_AES_256] = 16,
+    [QCRYPTO_CIPHER_ALGO_DES] = 8,
+    [QCRYPTO_CIPHER_ALGO_3DES] = 8,
+    [QCRYPTO_CIPHER_ALGO_CAST5_128] = 8,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_192] = 16,
+    [QCRYPTO_CIPHER_ALGO_SERPENT_256] = 16,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_128] = 16,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_192] = 16,
+    [QCRYPTO_CIPHER_ALGO_TWOFISH_256] = 16,
 #ifdef CONFIG_CRYPTO_SM4
-    [QCRYPTO_CIPHER_ALG_SM4] = 16,
+    [QCRYPTO_CIPHER_ALGO_SM4] = 16,
 #endif
 };
 
@@ -69,21 +69,21 @@ static const bool mode_need_iv[QCRYPTO_CIPHER_MODE__MAX] = {
 };
 
 
-size_t qcrypto_cipher_get_block_len(QCryptoCipherAlgorithm alg)
+size_t qcrypto_cipher_get_block_len(QCryptoCipherAlgo alg)
 {
     assert(alg < G_N_ELEMENTS(alg_key_len));
     return alg_block_len[alg];
 }
 
 
-size_t qcrypto_cipher_get_key_len(QCryptoCipherAlgorithm alg)
+size_t qcrypto_cipher_get_key_len(QCryptoCipherAlgo alg)
 {
     assert(alg < G_N_ELEMENTS(alg_key_len));
     return alg_key_len[alg];
 }
 
 
-size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgorithm alg,
+size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgo alg,
                                  QCryptoCipherMode mode)
 {
     if (alg >= G_N_ELEMENTS(alg_block_len)) {
@@ -101,20 +101,20 @@ size_t qcrypto_cipher_get_iv_len(QCryptoCipherAlgorithm alg,
 
 
 static bool
-qcrypto_cipher_validate_key_length(QCryptoCipherAlgorithm alg,
+qcrypto_cipher_validate_key_length(QCryptoCipherAlgo alg,
                                    QCryptoCipherMode mode,
                                    size_t nkey,
                                    Error **errp)
 {
-    if ((unsigned)alg >= QCRYPTO_CIPHER_ALG__MAX) {
+    if ((unsigned)alg >= QCRYPTO_CIPHER_ALGO__MAX) {
         error_setg(errp, "Cipher algorithm %d out of range",
                    alg);
         return false;
     }
 
     if (mode == QCRYPTO_CIPHER_MODE_XTS) {
-        if (alg == QCRYPTO_CIPHER_ALG_DES ||
-            alg == QCRYPTO_CIPHER_ALG_3DES) {
+        if (alg == QCRYPTO_CIPHER_ALGO_DES ||
+            alg == QCRYPTO_CIPHER_ALGO_3DES) {
             error_setg(errp, "XTS mode not compatible with DES/3DES");
             return false;
         }
@@ -148,7 +148,7 @@ qcrypto_cipher_validate_key_length(QCryptoCipherAlgorithm alg,
 #include "cipher-builtin.c.inc"
 #endif
 
-QCryptoCipher *qcrypto_cipher_new(QCryptoCipherAlgorithm alg,
+QCryptoCipher *qcrypto_cipher_new(QCryptoCipherAlgo alg,
                                   QCryptoCipherMode mode,
                                   const uint8_t *key, size_t nkey,
                                   Error **errp)
diff --git a/crypto/ivgen.c b/crypto/ivgen.c
index 080846cb74..ec0cb1a25b 100644
--- a/crypto/ivgen.c
+++ b/crypto/ivgen.c
@@ -28,7 +28,7 @@
 
 
 QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
-                                QCryptoCipherAlgorithm cipheralg,
+                                QCryptoCipherAlgo cipheralg,
                                 QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
                                 Error **errp)
@@ -79,7 +79,7 @@ QCryptoIVGenAlgorithm qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen)
 }
 
 
-QCryptoCipherAlgorithm qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen)
+QCryptoCipherAlgo qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen)
 {
     return ivgen->cipher;
 }
diff --git a/crypto/secret_common.c b/crypto/secret_common.c
index 3441c44ca8..2c141107a5 100644
--- a/crypto/secret_common.c
+++ b/crypto/secret_common.c
@@ -71,7 +71,7 @@ static void qcrypto_secret_decrypt(QCryptoSecretCommon *secret,
         return;
     }
 
-    aes = qcrypto_cipher_new(QCRYPTO_CIPHER_ALG_AES_256,
+    aes = qcrypto_cipher_new(QCRYPTO_CIPHER_ALGO_AES_256,
                              QCRYPTO_CIPHER_MODE_CBC,
                              key, keylen,
                              errp);
diff --git a/tests/bench/benchmark-crypto-cipher.c b/tests/bench/benchmark-crypto-cipher.c
index c04f0a0fba..889a29ba5c 100644
--- a/tests/bench/benchmark-crypto-cipher.c
+++ b/tests/bench/benchmark-crypto-cipher.c
@@ -17,7 +17,7 @@
 
 static void test_cipher_speed(size_t chunk_size,
                               QCryptoCipherMode mode,
-                              QCryptoCipherAlgorithm alg)
+                              QCryptoCipherAlgo alg)
 {
     QCryptoCipher *cipher;
     Error *err = NULL;
@@ -71,7 +71,7 @@ static void test_cipher_speed(size_t chunk_size,
     g_test_timer_elapsed();
 
     g_test_message("enc(%s-%s) chunk %zu bytes %.2f MB/sec ",
-                   QCryptoCipherAlgorithm_str(alg),
+                   QCryptoCipherAlgo_str(alg),
                    QCryptoCipherMode_str(mode),
                    chunk_size, (double)total / MiB / g_test_timer_last());
 
@@ -88,7 +88,7 @@ static void test_cipher_speed(size_t chunk_size,
     g_test_timer_elapsed();
 
     g_test_message("dec(%s-%s) chunk %zu bytes %.2f MB/sec ",
-                   QCryptoCipherAlgorithm_str(alg),
+                   QCryptoCipherAlgo_str(alg),
                    QCryptoCipherMode_str(mode),
                    chunk_size, (double)total / MiB / g_test_timer_last());
 
@@ -105,7 +105,7 @@ static void test_cipher_speed_ecb_aes_128(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_ECB,
-                      QCRYPTO_CIPHER_ALG_AES_128);
+                      QCRYPTO_CIPHER_ALGO_AES_128);
 }
 
 static void test_cipher_speed_ecb_aes_256(const void *opaque)
@@ -113,7 +113,7 @@ static void test_cipher_speed_ecb_aes_256(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_ECB,
-                      QCRYPTO_CIPHER_ALG_AES_256);
+                      QCRYPTO_CIPHER_ALGO_AES_256);
 }
 
 static void test_cipher_speed_cbc_aes_128(const void *opaque)
@@ -121,7 +121,7 @@ static void test_cipher_speed_cbc_aes_128(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_CBC,
-                      QCRYPTO_CIPHER_ALG_AES_128);
+                      QCRYPTO_CIPHER_ALGO_AES_128);
 }
 
 static void test_cipher_speed_cbc_aes_256(const void *opaque)
@@ -129,7 +129,7 @@ static void test_cipher_speed_cbc_aes_256(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_CBC,
-                      QCRYPTO_CIPHER_ALG_AES_256);
+                      QCRYPTO_CIPHER_ALGO_AES_256);
 }
 
 static void test_cipher_speed_ctr_aes_128(const void *opaque)
@@ -137,7 +137,7 @@ static void test_cipher_speed_ctr_aes_128(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_CTR,
-                      QCRYPTO_CIPHER_ALG_AES_128);
+                      QCRYPTO_CIPHER_ALGO_AES_128);
 }
 
 static void test_cipher_speed_ctr_aes_256(const void *opaque)
@@ -145,7 +145,7 @@ static void test_cipher_speed_ctr_aes_256(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_CTR,
-                      QCRYPTO_CIPHER_ALG_AES_256);
+                      QCRYPTO_CIPHER_ALGO_AES_256);
 }
 
 static void test_cipher_speed_xts_aes_128(const void *opaque)
@@ -153,7 +153,7 @@ static void test_cipher_speed_xts_aes_128(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_XTS,
-                      QCRYPTO_CIPHER_ALG_AES_128);
+                      QCRYPTO_CIPHER_ALGO_AES_128);
 }
 
 static void test_cipher_speed_xts_aes_256(const void *opaque)
@@ -161,7 +161,7 @@ static void test_cipher_speed_xts_aes_256(const void *opaque)
     size_t chunk_size = (size_t)opaque;
     test_cipher_speed(chunk_size,
                       QCRYPTO_CIPHER_MODE_XTS,
-                      QCRYPTO_CIPHER_ALG_AES_256);
+                      QCRYPTO_CIPHER_ALGO_AES_256);
 }
 
 
diff --git a/tests/unit/test-crypto-block.c b/tests/unit/test-crypto-block.c
index c2f5fe7b25..1a0d329368 100644
--- a/tests/unit/test-crypto-block.c
+++ b/tests/unit/test-crypto-block.c
@@ -77,7 +77,7 @@ static QCryptoBlockCreateOptions luks_create_opts_aes256_cbc_plain64 = {
     .u.luks = {
         .key_secret = (char *)"sec0",
         .has_cipher_alg = true,
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .has_cipher_mode = true,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .has_ivgen_alg = true,
@@ -91,7 +91,7 @@ static QCryptoBlockCreateOptions luks_create_opts_aes256_cbc_essiv = {
     .u.luks = {
         .key_secret = (char *)"sec0",
         .has_cipher_alg = true,
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .has_cipher_mode = true,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .has_ivgen_alg = true,
@@ -112,7 +112,7 @@ static struct QCryptoBlockTestData {
 
     bool expect_header;
 
-    QCryptoCipherAlgorithm cipher_alg;
+    QCryptoCipherAlgo cipher_alg;
     QCryptoCipherMode cipher_mode;
     QCryptoHashAlgo hash_alg;
 
@@ -128,7 +128,7 @@ static struct QCryptoBlockTestData {
 
         .expect_header = false,
 
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
 
         .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
@@ -141,7 +141,7 @@ static struct QCryptoBlockTestData {
 
         .expect_header = true,
 
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_XTS,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
@@ -156,7 +156,7 @@ static struct QCryptoBlockTestData {
 
         .expect_header = true,
 
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
@@ -171,7 +171,7 @@ static struct QCryptoBlockTestData {
 
         .expect_header = true,
 
-        .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
 
diff --git a/tests/unit/test-crypto-cipher.c b/tests/unit/test-crypto-cipher.c
index f5152e569d..b328b482e1 100644
--- a/tests/unit/test-crypto-cipher.c
+++ b/tests/unit/test-crypto-cipher.c
@@ -27,7 +27,7 @@
 typedef struct QCryptoCipherTestData QCryptoCipherTestData;
 struct QCryptoCipherTestData {
     const char *path;
-    QCryptoCipherAlgorithm alg;
+    QCryptoCipherAlgo alg;
     QCryptoCipherMode mode;
     const char *key;
     const char *plaintext;
@@ -43,7 +43,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.1.1 ECB-AES128.Encrypt */
         .path = "/crypto/cipher/aes-ecb-128",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "2b7e151628aed2a6abf7158809cf4f3c",
         .plaintext =
@@ -60,7 +60,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.1.3 ECB-AES192.Encrypt */
         .path = "/crypto/cipher/aes-ecb-192",
-        .alg = QCRYPTO_CIPHER_ALG_AES_192,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_192,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b",
         .plaintext  =
@@ -77,7 +77,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.1.5 ECB-AES256.Encrypt */
         .path = "/crypto/cipher/aes-ecb-256",
-        .alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key =
             "603deb1015ca71be2b73aef0857d7781"
@@ -96,7 +96,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.2.1 CBC-AES128.Encrypt */
         .path = "/crypto/cipher/aes-cbc-128",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_CBC,
         .key = "2b7e151628aed2a6abf7158809cf4f3c",
         .iv = "000102030405060708090a0b0c0d0e0f",
@@ -114,7 +114,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.2.3 CBC-AES128.Encrypt */
         .path = "/crypto/cipher/aes-cbc-192",
-        .alg = QCRYPTO_CIPHER_ALG_AES_192,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_192,
         .mode = QCRYPTO_CIPHER_MODE_CBC,
         .key = "8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b",
         .iv = "000102030405060708090a0b0c0d0e0f",
@@ -132,7 +132,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.2.5 CBC-AES128.Encrypt */
         .path = "/crypto/cipher/aes-cbc-256",
-        .alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .mode = QCRYPTO_CIPHER_MODE_CBC,
         .key =
             "603deb1015ca71be2b73aef0857d7781"
@@ -156,7 +156,7 @@ static QCryptoCipherTestData test_data[] = {
          * ciphertext in ECB and CBC modes
          */
         .path = "/crypto/cipher/des-ecb-56-one-block",
-        .alg = QCRYPTO_CIPHER_ALG_DES,
+        .alg = QCRYPTO_CIPHER_ALGO_DES,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "80c4a2e691d5b3f7",
         .plaintext = "70617373776f7264",
@@ -165,7 +165,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* See previous comment */
         .path = "/crypto/cipher/des-cbc-56-one-block",
-        .alg = QCRYPTO_CIPHER_ALG_DES,
+        .alg = QCRYPTO_CIPHER_ALGO_DES,
         .mode = QCRYPTO_CIPHER_MODE_CBC,
         .key = "80c4a2e691d5b3f7",
         .iv = "0000000000000000",
@@ -174,7 +174,7 @@ static QCryptoCipherTestData test_data[] = {
     },
     {
         .path = "/crypto/cipher/des-ecb-56",
-        .alg = QCRYPTO_CIPHER_ALG_DES,
+        .alg = QCRYPTO_CIPHER_ALGO_DES,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "80c4a2e691d5b3f7",
         .plaintext =
@@ -191,7 +191,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Borrowed from linux-kernel crypto/testmgr.h */
         .path = "/crypto/cipher/3des-cbc",
-        .alg = QCRYPTO_CIPHER_ALG_3DES,
+        .alg = QCRYPTO_CIPHER_ALGO_3DES,
         .mode = QCRYPTO_CIPHER_MODE_CBC,
         .key =
             "e9c0ff2e760b6424444d995a12d640c0"
@@ -220,7 +220,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Borrowed from linux-kernel crypto/testmgr.h */
         .path = "/crypto/cipher/3des-ecb",
-        .alg = QCRYPTO_CIPHER_ALG_3DES,
+        .alg = QCRYPTO_CIPHER_ALGO_3DES,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key =
             "0123456789abcdef5555555555555555"
@@ -233,7 +233,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Borrowed from linux-kernel crypto/testmgr.h */
         .path = "/crypto/cipher/3des-ctr",
-        .alg = QCRYPTO_CIPHER_ALG_3DES,
+        .alg = QCRYPTO_CIPHER_ALGO_3DES,
         .mode = QCRYPTO_CIPHER_MODE_CTR,
         .key =
             "9cd6f39cb95a67005a67002dceeb2dce"
@@ -308,7 +308,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* RFC 2144, Appendix B.1 */
         .path = "/crypto/cipher/cast5-128",
-        .alg = QCRYPTO_CIPHER_ALG_CAST5_128,
+        .alg = QCRYPTO_CIPHER_ALGO_CAST5_128,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "0123456712345678234567893456789A",
         .plaintext = "0123456789abcdef",
@@ -317,7 +317,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* libgcrypt serpent.c */
         .path = "/crypto/cipher/serpent-128",
-        .alg = QCRYPTO_CIPHER_ALG_SERPENT_128,
+        .alg = QCRYPTO_CIPHER_ALGO_SERPENT_128,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "00000000000000000000000000000000",
         .plaintext = "d29d576fcea3a3a7ed9099f29273d78e",
@@ -326,7 +326,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* libgcrypt serpent.c */
         .path = "/crypto/cipher/serpent-192",
-        .alg = QCRYPTO_CIPHER_ALG_SERPENT_192,
+        .alg = QCRYPTO_CIPHER_ALGO_SERPENT_192,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "00000000000000000000000000000000"
                "0000000000000000",
@@ -336,7 +336,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* libgcrypt serpent.c */
         .path = "/crypto/cipher/serpent-256a",
-        .alg = QCRYPTO_CIPHER_ALG_SERPENT_256,
+        .alg = QCRYPTO_CIPHER_ALGO_SERPENT_256,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "00000000000000000000000000000000"
                "00000000000000000000000000000000",
@@ -346,7 +346,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* libgcrypt serpent.c */
         .path = "/crypto/cipher/serpent-256b",
-        .alg = QCRYPTO_CIPHER_ALG_SERPENT_256,
+        .alg = QCRYPTO_CIPHER_ALGO_SERPENT_256,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "00000000000000000000000000000000"
                "00000000000000000000000000000000",
@@ -356,7 +356,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Twofish paper "Known Answer Test" */
         .path = "/crypto/cipher/twofish-128",
-        .alg = QCRYPTO_CIPHER_ALG_TWOFISH_128,
+        .alg = QCRYPTO_CIPHER_ALGO_TWOFISH_128,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "d491db16e7b1c39e86cb086b789f5419",
         .plaintext = "019f9809de1711858faac3a3ba20fbc3",
@@ -365,7 +365,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Twofish paper "Known Answer Test", I=3 */
         .path = "/crypto/cipher/twofish-192",
-        .alg = QCRYPTO_CIPHER_ALG_TWOFISH_192,
+        .alg = QCRYPTO_CIPHER_ALGO_TWOFISH_192,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "88b2b2706b105e36b446bb6d731a1e88"
                "efa71f788965bd44",
@@ -375,7 +375,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* Twofish paper "Known Answer Test", I=4 */
         .path = "/crypto/cipher/twofish-256",
-        .alg = QCRYPTO_CIPHER_ALG_TWOFISH_256,
+        .alg = QCRYPTO_CIPHER_ALGO_TWOFISH_256,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "d43bb7556ea32e46f2a282b7d45b4e0d"
                "57ff739d4dc92c1bd7fc01700cc8216f",
@@ -386,7 +386,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* SM4, GB/T 32907-2016, Appendix A.1 */
         .path = "/crypto/cipher/sm4",
-        .alg = QCRYPTO_CIPHER_ALG_SM4,
+        .alg = QCRYPTO_CIPHER_ALGO_SM4,
         .mode = QCRYPTO_CIPHER_MODE_ECB,
         .key = "0123456789abcdeffedcba9876543210",
         .plaintext  =
@@ -398,7 +398,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* #1 32 byte key, 32 byte PTX */
         .path = "/crypto/cipher/aes-xts-128-1",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_XTS,
         .key =
             "00000000000000000000000000000000"
@@ -415,7 +415,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* #2, 32 byte key, 32 byte PTX */
         .path = "/crypto/cipher/aes-xts-128-2",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_XTS,
         .key =
             "11111111111111111111111111111111"
@@ -432,7 +432,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* #5 from xts.7, 32 byte key, 32 byte PTX */
         .path = "/crypto/cipher/aes-xts-128-3",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_XTS,
         .key =
             "fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0"
@@ -449,7 +449,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* #4, 32 byte key, 512 byte PTX  */
         .path = "/crypto/cipher/aes-xts-128-4",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_XTS,
         .key =
             "27182818284590452353602874713526"
@@ -528,7 +528,7 @@ static QCryptoCipherTestData test_data[] = {
          * which is incompatible with XTS
          */
         .path = "/crypto/cipher/cast5-xts-128",
-        .alg = QCRYPTO_CIPHER_ALG_CAST5_128,
+        .alg = QCRYPTO_CIPHER_ALGO_CAST5_128,
         .mode = QCRYPTO_CIPHER_MODE_XTS,
         .key =
             "27182818284590452353602874713526"
@@ -537,7 +537,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.5.1 CTR-AES128.Encrypt */
         .path = "/crypto/cipher/aes-ctr-128",
-        .alg = QCRYPTO_CIPHER_ALG_AES_128,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .mode = QCRYPTO_CIPHER_MODE_CTR,
         .key = "2b7e151628aed2a6abf7158809cf4f3c",
         .iv = "f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff",
@@ -555,7 +555,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.5.3 CTR-AES192.Encrypt */
         .path = "/crypto/cipher/aes-ctr-192",
-        .alg = QCRYPTO_CIPHER_ALG_AES_192,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_192,
         .mode = QCRYPTO_CIPHER_MODE_CTR,
         .key = "8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b",
         .iv = "f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff",
@@ -573,7 +573,7 @@ static QCryptoCipherTestData test_data[] = {
     {
         /* NIST F.5.5 CTR-AES256.Encrypt */
         .path = "/crypto/cipher/aes-ctr-256",
-        .alg = QCRYPTO_CIPHER_ALG_AES_256,
+        .alg = QCRYPTO_CIPHER_ALGO_AES_256,
         .mode = QCRYPTO_CIPHER_MODE_CTR,
         .key = "603deb1015ca71be2b73aef0857d7781"
                "1f352c073b6108d72d9810a30914dff4",
@@ -750,7 +750,7 @@ static void test_cipher_null_iv(void)
     uint8_t ciphertext[32] = { 0 };
 
     cipher = qcrypto_cipher_new(
-        QCRYPTO_CIPHER_ALG_AES_256,
+        QCRYPTO_CIPHER_ALGO_AES_256,
         QCRYPTO_CIPHER_MODE_CBC,
         key, sizeof(key),
         &error_abort);
@@ -779,7 +779,7 @@ static void test_cipher_short_plaintext(void)
     int ret;
 
     cipher = qcrypto_cipher_new(
-        QCRYPTO_CIPHER_ALG_AES_256,
+        QCRYPTO_CIPHER_ALGO_AES_256,
         QCRYPTO_CIPHER_MODE_CBC,
         key, sizeof(key),
         &error_abort);
@@ -823,7 +823,7 @@ int main(int argc, char **argv)
             g_test_add_data_func(test_data[i].path, &test_data[i], test_cipher);
         } else {
             g_printerr("# skip unsupported %s:%s\n",
-                       QCryptoCipherAlgorithm_str(test_data[i].alg),
+                       QCryptoCipherAlgo_str(test_data[i].alg),
                        QCryptoCipherMode_str(test_data[i].mode));
         }
     }
diff --git a/tests/unit/test-crypto-ivgen.c b/tests/unit/test-crypto-ivgen.c
index 9aa3f6018b..6b4110775a 100644
--- a/tests/unit/test-crypto-ivgen.c
+++ b/tests/unit/test-crypto-ivgen.c
@@ -28,7 +28,7 @@ struct QCryptoIVGenTestData {
     uint64_t sector;
     QCryptoIVGenAlgorithm ivalg;
     QCryptoHashAlgo hashalg;
-    QCryptoCipherAlgorithm cipheralg;
+    QCryptoCipherAlgo cipheralg;
     const uint8_t *key;
     size_t nkey;
     const uint8_t *iv;
@@ -93,7 +93,7 @@ struct QCryptoIVGenTestData {
         "/crypto/ivgen/essiv/1",
         .sector = 0x1,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
-        .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
+        .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -107,7 +107,7 @@ struct QCryptoIVGenTestData {
         "/crypto/ivgen/essiv/1f2e3d4c",
         .sector = 0x1f2e3d4cULL,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
-        .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
+        .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -121,7 +121,7 @@ struct QCryptoIVGenTestData {
         "/crypto/ivgen/essiv/1f2e3d4c5b6a7988",
         .sector = 0x1f2e3d4c5b6a7988ULL,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
-        .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
+        .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
diff --git a/ui/vnc.c b/ui/vnc.c
index 9a17994969..b59af625dd 100644
--- a/ui/vnc.c
+++ b/ui/vnc.c
@@ -2783,7 +2783,7 @@ static int protocol_client_auth_vnc(VncState *vs, uint8_t *data, size_t len)
     vnc_munge_des_rfb_key(key, sizeof(key));
 
     cipher = qcrypto_cipher_new(
-        QCRYPTO_CIPHER_ALG_DES,
+        QCRYPTO_CIPHER_ALGO_DES,
         QCRYPTO_CIPHER_MODE_ECB,
         key, G_N_ELEMENTS(key),
         &err);
@@ -4064,7 +4064,7 @@ void vnc_display_open(const char *id, Error **errp)
     }
     if (password) {
         if (!qcrypto_cipher_supports(
-                QCRYPTO_CIPHER_ALG_DES, QCRYPTO_CIPHER_MODE_ECB)) {
+                QCRYPTO_CIPHER_ALGO_DES, QCRYPTO_CIPHER_MODE_ECB)) {
             error_setg(errp,
                        "Cipher backend does not support DES algorithm");
             goto fail;
diff --git a/crypto/cipher-builtin.c.inc b/crypto/cipher-builtin.c.inc
index b409089095..da5fcbd9a3 100644
--- a/crypto/cipher-builtin.c.inc
+++ b/crypto/cipher-builtin.c.inc
@@ -221,13 +221,13 @@ static const struct QCryptoCipherDriver qcrypto_cipher_aes_driver_cbc = {
     .cipher_free = qcrypto_cipher_ctx_free,
 };
 
-bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
+bool qcrypto_cipher_supports(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode)
 {
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         switch (mode) {
         case QCRYPTO_CIPHER_MODE_ECB:
         case QCRYPTO_CIPHER_MODE_CBC:
@@ -241,7 +241,7 @@ bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
     }
 }
 
-static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgo alg,
                                              QCryptoCipherMode mode,
                                              const uint8_t *key,
                                              size_t nkey,
@@ -252,9 +252,9 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
     }
 
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         {
             QCryptoCipherBuiltinAES *ctx;
             const QCryptoCipherDriver *drv;
@@ -292,7 +292,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
     default:
         error_setg(errp,
                    "Unsupported cipher algorithm %s",
-                   QCryptoCipherAlgorithm_str(alg));
+                   QCryptoCipherAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/cipher-gcrypt.c.inc b/crypto/cipher-gcrypt.c.inc
index 4a8314746d..12eb9ddb5a 100644
--- a/crypto/cipher-gcrypt.c.inc
+++ b/crypto/cipher-gcrypt.c.inc
@@ -20,33 +20,33 @@
 
 #include <gcrypt.h>
 
-static int qcrypto_cipher_alg_to_gcry_alg(QCryptoCipherAlgorithm alg)
+static int qcrypto_cipher_alg_to_gcry_alg(QCryptoCipherAlgo alg)
 {
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_DES:
+    case QCRYPTO_CIPHER_ALGO_DES:
         return GCRY_CIPHER_DES;
-    case QCRYPTO_CIPHER_ALG_3DES:
+    case QCRYPTO_CIPHER_ALGO_3DES:
         return GCRY_CIPHER_3DES;
-    case QCRYPTO_CIPHER_ALG_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
         return GCRY_CIPHER_AES128;
-    case QCRYPTO_CIPHER_ALG_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
         return GCRY_CIPHER_AES192;
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         return GCRY_CIPHER_AES256;
-    case QCRYPTO_CIPHER_ALG_CAST5_128:
+    case QCRYPTO_CIPHER_ALGO_CAST5_128:
         return GCRY_CIPHER_CAST5;
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
         return GCRY_CIPHER_SERPENT128;
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
         return GCRY_CIPHER_SERPENT192;
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
         return GCRY_CIPHER_SERPENT256;
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
         return GCRY_CIPHER_TWOFISH128;
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
         return GCRY_CIPHER_TWOFISH;
 #ifdef CONFIG_CRYPTO_SM4
-    case QCRYPTO_CIPHER_ALG_SM4:
+    case QCRYPTO_CIPHER_ALGO_SM4:
         return GCRY_CIPHER_SM4;
 #endif
     default:
@@ -70,23 +70,23 @@ static int qcrypto_cipher_mode_to_gcry_mode(QCryptoCipherMode mode)
     }
 }
 
-bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
+bool qcrypto_cipher_supports(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode)
 {
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_DES:
-    case QCRYPTO_CIPHER_ALG_3DES:
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
-    case QCRYPTO_CIPHER_ALG_CAST5_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_DES:
+    case QCRYPTO_CIPHER_ALGO_3DES:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
+    case QCRYPTO_CIPHER_ALGO_CAST5_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
 #ifdef CONFIG_CRYPTO_SM4
-    case QCRYPTO_CIPHER_ALG_SM4:
+    case QCRYPTO_CIPHER_ALGO_SM4:
 #endif
         break;
     default:
@@ -228,7 +228,7 @@ static const struct QCryptoCipherDriver qcrypto_gcrypt_ctr_driver = {
     .cipher_free = qcrypto_gcrypt_ctx_free,
 };
 
-static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgo alg,
                                              QCryptoCipherMode mode,
                                              const uint8_t *key,
                                              size_t nkey,
@@ -246,7 +246,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
     gcryalg = qcrypto_cipher_alg_to_gcry_alg(alg);
     if (gcryalg == GCRY_CIPHER_NONE) {
         error_setg(errp, "Unsupported cipher algorithm %s",
-                   QCryptoCipherAlgorithm_str(alg));
+                   QCryptoCipherAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/cipher-gnutls.c.inc b/crypto/cipher-gnutls.c.inc
index d3e231c13c..b9450d48b0 100644
--- a/crypto/cipher-gnutls.c.inc
+++ b/crypto/cipher-gnutls.c.inc
@@ -27,7 +27,7 @@
 #define QEMU_GNUTLS_XTS
 #endif
 
-bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
+bool qcrypto_cipher_supports(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode)
 {
 
@@ -35,11 +35,11 @@ bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
     case QCRYPTO_CIPHER_MODE_ECB:
     case QCRYPTO_CIPHER_MODE_CBC:
         switch (alg) {
-        case QCRYPTO_CIPHER_ALG_AES_128:
-        case QCRYPTO_CIPHER_ALG_AES_192:
-        case QCRYPTO_CIPHER_ALG_AES_256:
-        case QCRYPTO_CIPHER_ALG_DES:
-        case QCRYPTO_CIPHER_ALG_3DES:
+        case QCRYPTO_CIPHER_ALGO_AES_128:
+        case QCRYPTO_CIPHER_ALGO_AES_192:
+        case QCRYPTO_CIPHER_ALGO_AES_256:
+        case QCRYPTO_CIPHER_ALGO_DES:
+        case QCRYPTO_CIPHER_ALGO_3DES:
             return true;
         default:
             return false;
@@ -47,8 +47,8 @@ bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
 #ifdef QEMU_GNUTLS_XTS
     case QCRYPTO_CIPHER_MODE_XTS:
         switch (alg) {
-        case QCRYPTO_CIPHER_ALG_AES_128:
-        case QCRYPTO_CIPHER_ALG_AES_256:
+        case QCRYPTO_CIPHER_ALGO_AES_128:
+        case QCRYPTO_CIPHER_ALGO_AES_256:
             return true;
         default:
             return false;
@@ -229,7 +229,7 @@ static struct QCryptoCipherDriver gnutls_driver = {
     .cipher_free = qcrypto_gnutls_cipher_free,
 };
 
-static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgo alg,
                                              QCryptoCipherMode mode,
                                              const uint8_t *key,
                                              size_t nkey,
@@ -244,10 +244,10 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
 #ifdef QEMU_GNUTLS_XTS
     case QCRYPTO_CIPHER_MODE_XTS:
         switch (alg) {
-        case QCRYPTO_CIPHER_ALG_AES_128:
+        case QCRYPTO_CIPHER_ALGO_AES_128:
             galg = GNUTLS_CIPHER_AES_128_XTS;
             break;
-        case QCRYPTO_CIPHER_ALG_AES_256:
+        case QCRYPTO_CIPHER_ALGO_AES_256:
             galg = GNUTLS_CIPHER_AES_256_XTS;
             break;
         default:
@@ -259,19 +259,19 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
     case QCRYPTO_CIPHER_MODE_ECB:
     case QCRYPTO_CIPHER_MODE_CBC:
         switch (alg) {
-        case QCRYPTO_CIPHER_ALG_AES_128:
+        case QCRYPTO_CIPHER_ALGO_AES_128:
             galg = GNUTLS_CIPHER_AES_128_CBC;
             break;
-        case QCRYPTO_CIPHER_ALG_AES_192:
+        case QCRYPTO_CIPHER_ALGO_AES_192:
             galg = GNUTLS_CIPHER_AES_192_CBC;
             break;
-        case QCRYPTO_CIPHER_ALG_AES_256:
+        case QCRYPTO_CIPHER_ALGO_AES_256:
             galg = GNUTLS_CIPHER_AES_256_CBC;
             break;
-        case QCRYPTO_CIPHER_ALG_DES:
+        case QCRYPTO_CIPHER_ALGO_DES:
             galg = GNUTLS_CIPHER_DES_CBC;
             break;
-        case QCRYPTO_CIPHER_ALG_3DES:
+        case QCRYPTO_CIPHER_ALGO_3DES:
             galg = GNUTLS_CIPHER_3DES_CBC;
             break;
         default:
@@ -284,7 +284,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
 
     if (galg == GNUTLS_CIPHER_UNKNOWN) {
         error_setg(errp, "Unsupported cipher algorithm %s with %s mode",
-                   QCryptoCipherAlgorithm_str(alg),
+                   QCryptoCipherAlgo_str(alg),
                    QCryptoCipherMode_str(mode));
         return NULL;
     }
@@ -310,8 +310,8 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
         }
     }
 
-    if (alg == QCRYPTO_CIPHER_ALG_DES ||
-        alg == QCRYPTO_CIPHER_ALG_3DES)
+    if (alg == QCRYPTO_CIPHER_ALGO_DES ||
+        alg == QCRYPTO_CIPHER_ALGO_3DES)
         ctx->blocksize = 8;
     else
         ctx->blocksize = 16;
diff --git a/crypto/cipher-nettle.c.inc b/crypto/cipher-nettle.c.inc
index 42b39e18a2..ece5d65492 100644
--- a/crypto/cipher-nettle.c.inc
+++ b/crypto/cipher-nettle.c.inc
@@ -454,24 +454,24 @@ DEFINE_ECB(qcrypto_nettle_sm4,
            sm4_encrypt_native, sm4_decrypt_native)
 #endif
 
-bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
+bool qcrypto_cipher_supports(QCryptoCipherAlgo alg,
                              QCryptoCipherMode mode)
 {
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_DES:
-    case QCRYPTO_CIPHER_ALG_3DES:
-    case QCRYPTO_CIPHER_ALG_AES_128:
-    case QCRYPTO_CIPHER_ALG_AES_192:
-    case QCRYPTO_CIPHER_ALG_AES_256:
-    case QCRYPTO_CIPHER_ALG_CAST5_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_192:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_DES:
+    case QCRYPTO_CIPHER_ALGO_3DES:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
+    case QCRYPTO_CIPHER_ALGO_CAST5_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_192:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
 #ifdef CONFIG_CRYPTO_SM4
-    case QCRYPTO_CIPHER_ALG_SM4:
+    case QCRYPTO_CIPHER_ALGO_SM4:
 #endif
         break;
     default:
@@ -489,7 +489,7 @@ bool qcrypto_cipher_supports(QCryptoCipherAlgorithm alg,
     }
 }
 
-static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
+static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgo alg,
                                              QCryptoCipherMode mode,
                                              const uint8_t *key,
                                              size_t nkey,
@@ -510,7 +510,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
     }
 
     switch (alg) {
-    case QCRYPTO_CIPHER_ALG_DES:
+    case QCRYPTO_CIPHER_ALGO_DES:
         {
             QCryptoNettleDES *ctx;
             const QCryptoCipherDriver *drv;
@@ -536,7 +536,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_3DES:
+    case QCRYPTO_CIPHER_ALGO_3DES:
         {
             QCryptoNettleDES3 *ctx;
             const QCryptoCipherDriver *drv;
@@ -561,7 +561,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_AES_128:
+    case QCRYPTO_CIPHER_ALGO_AES_128:
         {
             QCryptoNettleAES128 *ctx = g_new0(QCryptoNettleAES128, 1);
 
@@ -590,7 +590,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_AES_192:
+    case QCRYPTO_CIPHER_ALGO_AES_192:
         {
             QCryptoNettleAES192 *ctx = g_new0(QCryptoNettleAES192, 1);
 
@@ -619,7 +619,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_AES_256:
+    case QCRYPTO_CIPHER_ALGO_AES_256:
         {
             QCryptoNettleAES256 *ctx = g_new0(QCryptoNettleAES256, 1);
 
@@ -648,7 +648,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_CAST5_128:
+    case QCRYPTO_CIPHER_ALGO_CAST5_128:
         {
             QCryptoNettleCAST128 *ctx;
             const QCryptoCipherDriver *drv;
@@ -674,9 +674,9 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_SERPENT_128:
-    case QCRYPTO_CIPHER_ALG_SERPENT_192:
-    case QCRYPTO_CIPHER_ALG_SERPENT_256:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_128:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_192:
+    case QCRYPTO_CIPHER_ALGO_SERPENT_256:
         {
             QCryptoNettleSerpent *ctx = g_new0(QCryptoNettleSerpent, 1);
 
@@ -703,9 +703,9 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 
-    case QCRYPTO_CIPHER_ALG_TWOFISH_128:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_192:
-    case QCRYPTO_CIPHER_ALG_TWOFISH_256:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_128:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_192:
+    case QCRYPTO_CIPHER_ALGO_TWOFISH_256:
         {
             QCryptoNettleTwofish *ctx = g_new0(QCryptoNettleTwofish, 1);
 
@@ -732,7 +732,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
             return &ctx->base;
         }
 #ifdef CONFIG_CRYPTO_SM4
-    case QCRYPTO_CIPHER_ALG_SM4:
+    case QCRYPTO_CIPHER_ALGO_SM4:
         {
             QCryptoNettleSm4 *ctx = g_new0(QCryptoNettleSm4, 1);
 
@@ -753,7 +753,7 @@ static QCryptoCipher *qcrypto_cipher_ctx_new(QCryptoCipherAlgorithm alg,
 
     default:
         error_setg(errp, "Unsupported cipher algorithm %s",
-                   QCryptoCipherAlgorithm_str(alg));
+                   QCryptoCipherAlgo_str(alg));
         return NULL;
     }
 
-- 
2.46.0


