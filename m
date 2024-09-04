Return-Path: <kvm+bounces-25866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB0796BA53
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BC881F21EE5
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5131DA638;
	Wed,  4 Sep 2024 11:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AeBWmHaK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9C01D0968
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448740; cv=none; b=EuqX6+LVDHYyXw7PDb9056BFcmkLXfjt51Gp9AVTFo4X1z84hDibiBuVf+TMAHomn2FeqzMLH88Lna2GoXlhqw+/TQUQJ84KbScQU3STVdUtfCPYtMKLI8u2ON754asxfGPtrMDa8hwJ8JpGvEcQrRCgkvYYgbT4qsZsr3O4xus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448740; c=relaxed/simple;
	bh=8e80zE+UM5aJ7HoKXYbdc/0Rg/ss4N1i64LSqbH5TO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTIlWkeX1idqsCwOFPWJmDemfzO+pLyPvKTsSSYdtHgp0tuIuechVDDU6nh+y8ek9WkM70SEOVBz40qiNn4wVR/0/LDwUgwMQzzU+VrkSNXFQnR4vOy9KQirdCoKNoMumVTSSFSgPAdsfUGAi0olG2vQWpVBWIKJDlenBLhNTjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AeBWmHaK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QX4JUInoHUF7q6csJlaRB2sSg2TElp2pQDt4acUj8qE=;
	b=AeBWmHaK76424kQpsX5R/LY/HHpakgXXmxz93vLSqO3hOPcluu+0pQ78+der4zavx6w1r+
	kYQbE9J+B3MugHNopEK4GXq2Nn7QWCIYMgMXD9+Zb5C7Ih+V/0nm26KfTBeF+SJKbNL8On
	oBvNQ1G/3SjOv0SQWvWb7ntBJypHNL4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-kPFm4qfVNPiD0eqbEwR-kw-1; Wed,
 04 Sep 2024 07:18:50 -0400
X-MC-Unique: kPFm4qfVNPiD0eqbEwR-kw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78745196CE1D;
	Wed,  4 Sep 2024 11:18:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08D731956094;
	Wed,  4 Sep 2024 11:18:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id BF11421E6829; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 11/19] qapi/crypto: Rename QCryptoHashAlgorithm to *Algo, and drop prefix
Date: Wed,  4 Sep 2024 13:18:28 +0200
Message-ID: <20240904111836.3273842-12-armbru@redhat.com>
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

QCryptoHashAlgorithm has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTO_HASH_ALG.

We could simply drop 'prefix', but then the prefix becomes
QCRYPTO_HASH_ALGORITHM, which is rather long.

We could additionally rename the type to QCryptoHashAlg, but I think
the abbreviation "alg" is less than clear.

Rename the type to QCryptoHashAlgo instead.  The prefix becomes to
QCRYPTO_HASH_ALGO.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Acked-by: Daniel P. Berrangé <berrange@redhat.com>
---
 qapi/crypto.json                        | 17 +++++-----
 crypto/blockpriv.h                      |  2 +-
 crypto/hashpriv.h                       |  2 +-
 crypto/hmacpriv.h                       |  4 +--
 crypto/ivgenpriv.h                      |  2 +-
 include/crypto/afsplit.h                |  8 ++---
 include/crypto/block.h                  |  2 +-
 include/crypto/hash.h                   | 18 +++++-----
 include/crypto/hmac.h                   |  6 ++--
 include/crypto/ivgen.h                  |  6 ++--
 include/crypto/pbkdf.h                  | 10 +++---
 backends/cryptodev-builtin.c            |  8 ++---
 backends/cryptodev-lkcf.c               | 10 +++---
 block/parallels-ext.c                   |  2 +-
 block/quorum.c                          |  4 +--
 crypto/afsplit.c                        |  6 ++--
 crypto/block-luks.c                     | 16 ++++-----
 crypto/block.c                          |  2 +-
 crypto/hash-afalg.c                     | 26 +++++++--------
 crypto/hash-gcrypt.c                    | 20 +++++------
 crypto/hash-glib.c                      | 20 +++++------
 crypto/hash-gnutls.c                    | 20 +++++------
 crypto/hash-nettle.c                    | 18 +++++-----
 crypto/hash.c                           | 30 ++++++++---------
 crypto/hmac-gcrypt.c                    | 22 ++++++-------
 crypto/hmac-glib.c                      | 22 ++++++-------
 crypto/hmac-gnutls.c                    | 22 ++++++-------
 crypto/hmac-nettle.c                    | 22 ++++++-------
 crypto/hmac.c                           |  2 +-
 crypto/ivgen.c                          |  4 +--
 crypto/pbkdf-gcrypt.c                   | 36 ++++++++++----------
 crypto/pbkdf-gnutls.c                   | 36 ++++++++++----------
 crypto/pbkdf-nettle.c                   | 32 +++++++++---------
 crypto/pbkdf-stub.c                     |  4 +--
 crypto/pbkdf.c                          |  2 +-
 hw/misc/aspeed_hace.c                   | 16 ++++-----
 io/channel-websock.c                    |  2 +-
 target/i386/sev.c                       |  6 ++--
 tests/bench/benchmark-crypto-akcipher.c | 12 +++----
 tests/bench/benchmark-crypto-hash.c     | 10 +++---
 tests/bench/benchmark-crypto-hmac.c     |  6 ++--
 tests/unit/test-crypto-afsplit.c        | 10 +++---
 tests/unit/test-crypto-akcipher.c       |  6 ++--
 tests/unit/test-crypto-block.c          | 16 ++++-----
 tests/unit/test-crypto-hash.c           | 42 +++++++++++------------
 tests/unit/test-crypto-hmac.c           | 16 ++++-----
 tests/unit/test-crypto-ivgen.c          |  8 ++---
 tests/unit/test-crypto-pbkdf.c          | 44 ++++++++++++-------------
 ui/vnc.c                                |  2 +-
 util/hbitmap.c                          |  2 +-
 crypto/akcipher-gcrypt.c.inc            | 14 ++++----
 crypto/akcipher-nettle.c.inc            | 26 +++++++--------
 52 files changed, 350 insertions(+), 351 deletions(-)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index b5c25e7cd9..68393568cf 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -38,7 +38,7 @@
   'data': ['raw', 'base64']}
 
 ##
-# @QCryptoHashAlgorithm:
+# @QCryptoHashAlgo:
 #
 # The supported algorithms for computing content digests
 #
@@ -58,8 +58,7 @@
 #
 # Since: 2.6
 ##
-{ 'enum': 'QCryptoHashAlgorithm',
-  'prefix': 'QCRYPTO_HASH_ALG',
+{ 'enum': 'QCryptoHashAlgo',
   'data': ['md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'ripemd160']}
 
 ##
@@ -229,8 +228,8 @@
   'data': { '*cipher-alg': 'QCryptoCipherAlgorithm',
             '*cipher-mode': 'QCryptoCipherMode',
             '*ivgen-alg': 'QCryptoIVGenAlgorithm',
-            '*ivgen-hash-alg': 'QCryptoHashAlgorithm',
-            '*hash-alg': 'QCryptoHashAlgorithm',
+            '*ivgen-hash-alg': 'QCryptoHashAlgo',
+            '*hash-alg': 'QCryptoHashAlgo',
             '*iter-time': 'int' }}
 
 ##
@@ -326,8 +325,8 @@
   'data': {'cipher-alg': 'QCryptoCipherAlgorithm',
            'cipher-mode': 'QCryptoCipherMode',
            'ivgen-alg': 'QCryptoIVGenAlgorithm',
-           '*ivgen-hash-alg': 'QCryptoHashAlgorithm',
-           'hash-alg': 'QCryptoHashAlgorithm',
+           '*ivgen-hash-alg': 'QCryptoHashAlgo',
+           'hash-alg': 'QCryptoHashAlgo',
            'detached-header': 'bool',
            'payload-offset': 'int',
            'master-key-iters': 'int',
@@ -631,14 +630,14 @@
 #
 # Specific parameters for RSA algorithm.
 #
-# @hash-alg: QCryptoHashAlgorithm
+# @hash-alg: QCryptoHashAlgo
 #
 # @padding-alg: QCryptoRSAPaddingAlgorithm
 #
 # Since: 7.1
 ##
 { 'struct': 'QCryptoAkCipherOptionsRSA',
-  'data': { 'hash-alg':'QCryptoHashAlgorithm',
+  'data': { 'hash-alg':'QCryptoHashAlgo',
             'padding-alg': 'QCryptoRSAPaddingAlgorithm'}}
 
 ##
diff --git a/crypto/blockpriv.h b/crypto/blockpriv.h
index b8f77cb5eb..cf1a66c00d 100644
--- a/crypto/blockpriv.h
+++ b/crypto/blockpriv.h
@@ -44,7 +44,7 @@ struct QCryptoBlock {
     QCryptoIVGen *ivgen;
     QemuMutex mutex;
 
-    QCryptoHashAlgorithm kdfhash;
+    QCryptoHashAlgo kdfhash;
     size_t niv;
     uint64_t payload_offset; /* In bytes */
     uint64_t sector_size; /* In bytes */
diff --git a/crypto/hashpriv.h b/crypto/hashpriv.h
index cee26ccb47..47daec3f7a 100644
--- a/crypto/hashpriv.h
+++ b/crypto/hashpriv.h
@@ -18,7 +18,7 @@
 typedef struct QCryptoHashDriver QCryptoHashDriver;
 
 struct QCryptoHashDriver {
-    int (*hash_bytesv)(QCryptoHashAlgorithm alg,
+    int (*hash_bytesv)(QCryptoHashAlgo alg,
                        const struct iovec *iov,
                        size_t niov,
                        uint8_t **result,
diff --git a/crypto/hmacpriv.h b/crypto/hmacpriv.h
index 62dfe8257a..bd4c498c62 100644
--- a/crypto/hmacpriv.h
+++ b/crypto/hmacpriv.h
@@ -28,7 +28,7 @@ struct QCryptoHmacDriver {
     void (*hmac_free)(QCryptoHmac *hmac);
 };
 
-void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp);
 extern QCryptoHmacDriver qcrypto_hmac_lib_driver;
@@ -37,7 +37,7 @@ extern QCryptoHmacDriver qcrypto_hmac_lib_driver;
 
 #include "afalgpriv.h"
 
-QCryptoAFAlg *qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgorithm alg,
+QCryptoAFAlg *qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
                                          const uint8_t *key, size_t nkey,
                                          Error **errp);
 extern QCryptoHmacDriver qcrypto_hmac_afalg_driver;
diff --git a/crypto/ivgenpriv.h b/crypto/ivgenpriv.h
index cecdbedfde..0227ae4d00 100644
--- a/crypto/ivgenpriv.h
+++ b/crypto/ivgenpriv.h
@@ -42,7 +42,7 @@ struct QCryptoIVGen {
 
     QCryptoIVGenAlgorithm algorithm;
     QCryptoCipherAlgorithm cipher;
-    QCryptoHashAlgorithm hash;
+    QCryptoHashAlgo hash;
 };
 
 
diff --git a/include/crypto/afsplit.h b/include/crypto/afsplit.h
index 4894d64330..06f28fe67c 100644
--- a/include/crypto/afsplit.h
+++ b/include/crypto/afsplit.h
@@ -46,7 +46,7 @@
  *
  * splitkey = g_new0(uint8_t, nkey * stripes);
  *
- * if (qcrypto_afsplit_encode(QCRYPTO_HASH_ALG_SHA256,
+ * if (qcrypto_afsplit_encode(QCRYPTO_HASH_ALGO_SHA256,
  *                            nkey, stripes,
  *                            masterkey, splitkey, errp) < 0) {
  *     g_free(splitkey);
@@ -71,7 +71,7 @@
  *
  * masterkey = g_new0(uint8_t, nkey);
  *
- * if (qcrypto_afsplit_decode(QCRYPTO_HASH_ALG_SHA256,
+ * if (qcrypto_afsplit_decode(QCRYPTO_HASH_ALGO_SHA256,
  *                            nkey, stripes,
  *                            splitkey, masterkey, errp) < 0) {
  *     g_free(splitkey);
@@ -102,7 +102,7 @@
  *
  * Returns: 0 on success, -1 on error;
  */
-int qcrypto_afsplit_encode(QCryptoHashAlgorithm hash,
+int qcrypto_afsplit_encode(QCryptoHashAlgo hash,
                            size_t blocklen,
                            uint32_t stripes,
                            const uint8_t *in,
@@ -124,7 +124,7 @@ int qcrypto_afsplit_encode(QCryptoHashAlgorithm hash,
  *
  * Returns: 0 on success, -1 on error;
  */
-int qcrypto_afsplit_decode(QCryptoHashAlgorithm hash,
+int qcrypto_afsplit_decode(QCryptoHashAlgo hash,
                            size_t blocklen,
                            uint32_t stripes,
                            const uint8_t *in,
diff --git a/include/crypto/block.h b/include/crypto/block.h
index 5b5d039800..b013d27f00 100644
--- a/include/crypto/block.h
+++ b/include/crypto/block.h
@@ -287,7 +287,7 @@ QCryptoIVGen *qcrypto_block_get_ivgen(QCryptoBlock *block);
  *
  * Returns: the hash algorithm
  */
-QCryptoHashAlgorithm qcrypto_block_get_kdf_hash(QCryptoBlock *block);
+QCryptoHashAlgo qcrypto_block_get_kdf_hash(QCryptoBlock *block);
 
 /**
  * qcrypto_block_get_payload_offset:
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 54d87aa2a1..67be72b01d 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -23,7 +23,7 @@
 
 #include "qapi/qapi-types-crypto.h"
 
-/* See also "QCryptoHashAlgorithm" defined in qapi/crypto.json */
+/* See also "QCryptoHashAlgo" defined in qapi/crypto.json */
 
 /**
  * qcrypto_hash_supports:
@@ -34,7 +34,7 @@
  *
  * Returns: true if the algorithm is supported, false otherwise
  */
-gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg);
+gboolean qcrypto_hash_supports(QCryptoHashAlgo alg);
 
 
 /**
@@ -45,7 +45,7 @@ gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg);
  *
  * Returns: the digest length in bytes
  */
-size_t qcrypto_hash_digest_len(QCryptoHashAlgorithm alg);
+size_t qcrypto_hash_digest_len(QCryptoHashAlgo alg);
 
 /**
  * qcrypto_hash_bytesv:
@@ -65,7 +65,7 @@ size_t qcrypto_hash_digest_len(QCryptoHashAlgorithm alg);
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_bytesv(QCryptoHashAlgorithm alg,
+int qcrypto_hash_bytesv(QCryptoHashAlgo alg,
                         const struct iovec *iov,
                         size_t niov,
                         uint8_t **result,
@@ -90,7 +90,7 @@ int qcrypto_hash_bytesv(QCryptoHashAlgorithm alg,
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_bytes(QCryptoHashAlgorithm alg,
+int qcrypto_hash_bytes(QCryptoHashAlgo alg,
                        const char *buf,
                        size_t len,
                        uint8_t **result,
@@ -114,7 +114,7 @@ int qcrypto_hash_bytes(QCryptoHashAlgorithm alg,
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_digestv(QCryptoHashAlgorithm alg,
+int qcrypto_hash_digestv(QCryptoHashAlgo alg,
                          const struct iovec *iov,
                          size_t niov,
                          char **digest,
@@ -137,7 +137,7 @@ int qcrypto_hash_digestv(QCryptoHashAlgorithm alg,
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_digest(QCryptoHashAlgorithm alg,
+int qcrypto_hash_digest(QCryptoHashAlgo alg,
                         const char *buf,
                         size_t len,
                         char **digest,
@@ -160,7 +160,7 @@ int qcrypto_hash_digest(QCryptoHashAlgorithm alg,
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_base64v(QCryptoHashAlgorithm alg,
+int qcrypto_hash_base64v(QCryptoHashAlgo alg,
                          const struct iovec *iov,
                          size_t niov,
                          char **base64,
@@ -183,7 +183,7 @@ int qcrypto_hash_base64v(QCryptoHashAlgorithm alg,
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_hash_base64(QCryptoHashAlgorithm alg,
+int qcrypto_hash_base64(QCryptoHashAlgo alg,
                         const char *buf,
                         size_t len,
                         char **base64,
diff --git a/include/crypto/hmac.h b/include/crypto/hmac.h
index ad4d778416..c69a0dfab3 100644
--- a/include/crypto/hmac.h
+++ b/include/crypto/hmac.h
@@ -16,7 +16,7 @@
 
 typedef struct QCryptoHmac QCryptoHmac;
 struct QCryptoHmac {
-    QCryptoHashAlgorithm alg;
+    QCryptoHashAlgo alg;
     void *opaque;
     void *driver;
 };
@@ -31,7 +31,7 @@ struct QCryptoHmac {
  * Returns:
  *  true if the algorithm is supported, false otherwise
  */
-bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg);
+bool qcrypto_hmac_supports(QCryptoHashAlgo alg);
 
 /**
  * qcrypto_hmac_new:
@@ -52,7 +52,7 @@ bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg);
  * Returns:
  *  a new hmac object, or NULL on error
  */
-QCryptoHmac *qcrypto_hmac_new(QCryptoHashAlgorithm alg,
+QCryptoHmac *qcrypto_hmac_new(QCryptoHashAlgo alg,
                               const uint8_t *key, size_t nkey,
                               Error **errp);
 
diff --git a/include/crypto/ivgen.h b/include/crypto/ivgen.h
index a09d5732da..ab5f1a648e 100644
--- a/include/crypto/ivgen.h
+++ b/include/crypto/ivgen.h
@@ -46,7 +46,7 @@
  *
  * QCryptoIVGen *ivgen = qcrypto_ivgen_new(QCRYPTO_IVGEN_ALG_ESSIV,
  *                                         QCRYPTO_CIPHER_ALG_AES_128,
- *                                         QCRYPTO_HASH_ALG_SHA256,
+ *                                         QCRYPTO_HASH_ALGO_SHA256,
  *                                         key, nkey, errp);
  * if (!ivgen) {
  *    return -1;
@@ -135,7 +135,7 @@ typedef struct QCryptoIVGen QCryptoIVGen;
  */
 QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
                                 QCryptoCipherAlgorithm cipheralg,
-                                QCryptoHashAlgorithm hash,
+                                QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
                                 Error **errp);
 
@@ -191,7 +191,7 @@ QCryptoCipherAlgorithm qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen);
  *
  * Returns: the hash algorithm
  */
-QCryptoHashAlgorithm qcrypto_ivgen_get_hash(QCryptoIVGen *ivgen);
+QCryptoHashAlgo qcrypto_ivgen_get_hash(QCryptoIVGen *ivgen);
 
 
 /**
diff --git a/include/crypto/pbkdf.h b/include/crypto/pbkdf.h
index 2c31a44a27..6cf29e78ee 100644
--- a/include/crypto/pbkdf.h
+++ b/include/crypto/pbkdf.h
@@ -50,7 +50,7 @@
  *     return -1;
  * }
  *
- * iterations = qcrypto_pbkdf2_count_iters(QCRYPTO_HASH_ALG_SHA256,
+ * iterations = qcrypto_pbkdf2_count_iters(QCRYPTO_HASH_ALGO_SHA256,
  *                                         (const uint8_t *)password,
  *                                         strlen(password),
  *                                         salt, nkey, errp);
@@ -60,7 +60,7 @@
  *     return -1;
  * }
  *
- * if (qcrypto_pbkdf2(QCRYPTO_HASH_ALG_SHA256,
+ * if (qcrypto_pbkdf2(QCRYPTO_HASH_ALGO_SHA256,
  *                    (const uint8_t *)password, strlen(password),
  *                    salt, nkey, iterations, key, nkey, errp) < 0) {
  *     g_free(key);
@@ -92,7 +92,7 @@
  *
  * Returns true if supported, false otherwise
  */
-bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash);
+bool qcrypto_pbkdf2_supports(QCryptoHashAlgo hash);
 
 
 /**
@@ -119,7 +119,7 @@ bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash);
  *
  * Returns: 0 on success, -1 on error
  */
-int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
+int qcrypto_pbkdf2(QCryptoHashAlgo hash,
                    const uint8_t *key, size_t nkey,
                    const uint8_t *salt, size_t nsalt,
                    uint64_t iterations,
@@ -147,7 +147,7 @@ int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
  *
  * Returns: number of iterations in 1 second, -1 on error
  */
-uint64_t qcrypto_pbkdf2_count_iters(QCryptoHashAlgorithm hash,
+uint64_t qcrypto_pbkdf2_count_iters(QCryptoHashAlgo hash,
                                     const uint8_t *key, size_t nkey,
                                     const uint8_t *salt, size_t nsalt,
                                     size_t nout,
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index e95af9bb72..4a49d328ec 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -169,16 +169,16 @@ static int cryptodev_builtin_get_rsa_hash_algo(
 {
     switch (virtio_rsa_hash) {
     case VIRTIO_CRYPTO_RSA_MD5:
-        return QCRYPTO_HASH_ALG_MD5;
+        return QCRYPTO_HASH_ALGO_MD5;
 
     case VIRTIO_CRYPTO_RSA_SHA1:
-        return QCRYPTO_HASH_ALG_SHA1;
+        return QCRYPTO_HASH_ALGO_SHA1;
 
     case VIRTIO_CRYPTO_RSA_SHA256:
-        return QCRYPTO_HASH_ALG_SHA256;
+        return QCRYPTO_HASH_ALGO_SHA256;
 
     case VIRTIO_CRYPTO_RSA_SHA512:
-        return QCRYPTO_HASH_ALG_SHA512;
+        return QCRYPTO_HASH_ALGO_SHA512;
 
     default:
         error_setg(errp, "Unsupported rsa hash algo: %d", virtio_rsa_hash);
diff --git a/backends/cryptodev-lkcf.c b/backends/cryptodev-lkcf.c
index e1ee11a158..6e6012e716 100644
--- a/backends/cryptodev-lkcf.c
+++ b/backends/cryptodev-lkcf.c
@@ -142,7 +142,7 @@ static int cryptodev_lkcf_set_op_desc(QCryptoAkCipherOptions *opts,
     if (rsa_opt->padding_alg == QCRYPTO_RSA_PADDING_ALG_PKCS1) {
         snprintf(key_desc, desc_len, "enc=%s hash=%s",
                  QCryptoRSAPaddingAlgorithm_str(rsa_opt->padding_alg),
-                 QCryptoHashAlgorithm_str(rsa_opt->hash_alg));
+                 QCryptoHashAlgo_str(rsa_opt->hash_alg));
 
     } else {
         snprintf(key_desc, desc_len, "enc=%s",
@@ -161,19 +161,19 @@ static int cryptodev_lkcf_set_rsa_opt(int virtio_padding_alg,
 
         switch (virtio_hash_alg) {
         case VIRTIO_CRYPTO_RSA_MD5:
-            opt->hash_alg = QCRYPTO_HASH_ALG_MD5;
+            opt->hash_alg = QCRYPTO_HASH_ALGO_MD5;
             break;
 
         case VIRTIO_CRYPTO_RSA_SHA1:
-            opt->hash_alg = QCRYPTO_HASH_ALG_SHA1;
+            opt->hash_alg = QCRYPTO_HASH_ALGO_SHA1;
             break;
 
         case VIRTIO_CRYPTO_RSA_SHA256:
-            opt->hash_alg = QCRYPTO_HASH_ALG_SHA256;
+            opt->hash_alg = QCRYPTO_HASH_ALGO_SHA256;
             break;
 
         case VIRTIO_CRYPTO_RSA_SHA512:
-            opt->hash_alg = QCRYPTO_HASH_ALG_SHA512;
+            opt->hash_alg = QCRYPTO_HASH_ALGO_SHA512;
             break;
 
         default:
diff --git a/block/parallels-ext.c b/block/parallels-ext.c
index b4e14c88f2..778b8f684e 100644
--- a/block/parallels-ext.c
+++ b/block/parallels-ext.c
@@ -206,7 +206,7 @@ parallels_parse_format_extension(BlockDriverState *bs, uint8_t *ext_cluster,
         goto fail;
     }
 
-    ret = qcrypto_hash_bytes(QCRYPTO_HASH_ALG_MD5, (char *)pos, remaining,
+    ret = qcrypto_hash_bytes(QCRYPTO_HASH_ALGO_MD5, (char *)pos, remaining,
                              &hash, &hash_len, errp);
     if (ret < 0) {
         goto fail;
diff --git a/block/quorum.c b/block/quorum.c
index db8fe891c4..46be65a95f 100644
--- a/block/quorum.c
+++ b/block/quorum.c
@@ -393,7 +393,7 @@ static int quorum_compute_hash(QuorumAIOCB *acb, int i, QuorumVoteValue *hash)
     /* XXX - would be nice if we could pass in the Error **
      * and propagate that back, but this quorum code is
      * restricted to just errno values currently */
-    if (qcrypto_hash_bytesv(QCRYPTO_HASH_ALG_SHA256,
+    if (qcrypto_hash_bytesv(QCRYPTO_HASH_ALGO_SHA256,
                             qiov->iov, qiov->niov,
                             &data, &len,
                             NULL) < 0) {
@@ -1308,7 +1308,7 @@ static BlockDriver bdrv_quorum = {
 
 static void bdrv_quorum_init(void)
 {
-    if (!qcrypto_hash_supports(QCRYPTO_HASH_ALG_SHA256)) {
+    if (!qcrypto_hash_supports(QCRYPTO_HASH_ALGO_SHA256)) {
         /* SHA256 hash support is required for quorum device */
         return;
     }
diff --git a/crypto/afsplit.c b/crypto/afsplit.c
index b1a5a20899..b2e383aa67 100644
--- a/crypto/afsplit.c
+++ b/crypto/afsplit.c
@@ -40,7 +40,7 @@ static void qcrypto_afsplit_xor(size_t blocklen,
 }
 
 
-static int qcrypto_afsplit_hash(QCryptoHashAlgorithm hash,
+static int qcrypto_afsplit_hash(QCryptoHashAlgo hash,
                                 size_t blocklen,
                                 uint8_t *block,
                                 Error **errp)
@@ -85,7 +85,7 @@ static int qcrypto_afsplit_hash(QCryptoHashAlgorithm hash,
 }
 
 
-int qcrypto_afsplit_encode(QCryptoHashAlgorithm hash,
+int qcrypto_afsplit_encode(QCryptoHashAlgo hash,
                            size_t blocklen,
                            uint32_t stripes,
                            const uint8_t *in,
@@ -117,7 +117,7 @@ int qcrypto_afsplit_encode(QCryptoHashAlgorithm hash,
 }
 
 
-int qcrypto_afsplit_decode(QCryptoHashAlgorithm hash,
+int qcrypto_afsplit_decode(QCryptoHashAlgo hash,
                            size_t blocklen,
                            uint32_t stripes,
                            const uint8_t *in,
diff --git a/crypto/block-luks.c b/crypto/block-luks.c
index 7b9c7b292d..59af733b8c 100644
--- a/crypto/block-luks.c
+++ b/crypto/block-luks.c
@@ -132,7 +132,7 @@ struct QCryptoBlockLUKS {
     QCryptoIVGenAlgorithm ivgen_alg;
 
     /* Hash algorithm used for IV generation*/
-    QCryptoHashAlgorithm ivgen_hash_alg;
+    QCryptoHashAlgo ivgen_hash_alg;
 
     /*
      * Encryption algorithm used for IV generation.
@@ -141,7 +141,7 @@ struct QCryptoBlockLUKS {
     QCryptoCipherAlgorithm ivgen_cipher_alg;
 
     /* Hash algorithm used in pbkdf2 function */
-    QCryptoHashAlgorithm hash_alg;
+    QCryptoHashAlgo hash_alg;
 
     /* Name of the secret that was used to open the image */
     char *secret;
@@ -223,7 +223,7 @@ static int qcrypto_block_luks_name_lookup(const char *name,
 
 #define qcrypto_block_luks_hash_name_lookup(name, errp)                 \
     qcrypto_block_luks_name_lookup(name,                                \
-                                   &QCryptoHashAlgorithm_lookup,        \
+                                   &QCryptoHashAlgo_lookup,        \
                                    "Hash algorithm",                    \
                                    errp)
 
@@ -264,7 +264,7 @@ qcrypto_block_luks_has_format(const uint8_t *buf,
  */
 static QCryptoCipherAlgorithm
 qcrypto_block_luks_essiv_cipher(QCryptoCipherAlgorithm cipher,
-                                QCryptoHashAlgorithm hash,
+                                QCryptoHashAlgo hash,
                                 Error **errp)
 {
     size_t digestlen = qcrypto_hash_digest_len(hash);
@@ -1331,11 +1331,11 @@ qcrypto_block_luks_create(QCryptoBlock *block,
         luks_opts.ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64;
     }
     if (!luks_opts.has_hash_alg) {
-        luks_opts.hash_alg = QCRYPTO_HASH_ALG_SHA256;
+        luks_opts.hash_alg = QCRYPTO_HASH_ALGO_SHA256;
     }
     if (luks_opts.ivgen_alg == QCRYPTO_IVGEN_ALG_ESSIV) {
         if (!luks_opts.has_ivgen_hash_alg) {
-            luks_opts.ivgen_hash_alg = QCRYPTO_HASH_ALG_SHA256;
+            luks_opts.ivgen_hash_alg = QCRYPTO_HASH_ALGO_SHA256;
             luks_opts.has_ivgen_hash_alg = true;
         }
     }
@@ -1386,13 +1386,13 @@ qcrypto_block_luks_create(QCryptoBlock *block,
     cipher_mode = QCryptoCipherMode_str(luks_opts.cipher_mode);
     ivgen_alg = QCryptoIVGenAlgorithm_str(luks_opts.ivgen_alg);
     if (luks_opts.has_ivgen_hash_alg) {
-        ivgen_hash_alg = QCryptoHashAlgorithm_str(luks_opts.ivgen_hash_alg);
+        ivgen_hash_alg = QCryptoHashAlgo_str(luks_opts.ivgen_hash_alg);
         cipher_mode_spec = g_strdup_printf("%s-%s:%s", cipher_mode, ivgen_alg,
                                            ivgen_hash_alg);
     } else {
         cipher_mode_spec = g_strdup_printf("%s-%s", cipher_mode, ivgen_alg);
     }
-    hash_alg = QCryptoHashAlgorithm_str(luks_opts.hash_alg);
+    hash_alg = QCryptoHashAlgo_str(luks_opts.hash_alg);
 
 
     if (strlen(cipher_alg) >= QCRYPTO_BLOCK_LUKS_CIPHER_NAME_LEN) {
diff --git a/crypto/block.c b/crypto/block.c
index 899561a080..9846caa591 100644
--- a/crypto/block.c
+++ b/crypto/block.c
@@ -332,7 +332,7 @@ QCryptoIVGen *qcrypto_block_get_ivgen(QCryptoBlock *block)
 }
 
 
-QCryptoHashAlgorithm qcrypto_block_get_kdf_hash(QCryptoBlock *block)
+QCryptoHashAlgo qcrypto_block_get_kdf_hash(QCryptoBlock *block)
 {
     return block->kdfhash;
 }
diff --git a/crypto/hash-afalg.c b/crypto/hash-afalg.c
index 3ebea39292..8fc6bd0edf 100644
--- a/crypto/hash-afalg.c
+++ b/crypto/hash-afalg.c
@@ -20,7 +20,7 @@
 #include "hmacpriv.h"
 
 static char *
-qcrypto_afalg_hash_format_name(QCryptoHashAlgorithm alg,
+qcrypto_afalg_hash_format_name(QCryptoHashAlgo alg,
                                bool is_hmac,
                                Error **errp)
 {
@@ -28,25 +28,25 @@ qcrypto_afalg_hash_format_name(QCryptoHashAlgorithm alg,
     const char *alg_name;
 
     switch (alg) {
-    case QCRYPTO_HASH_ALG_MD5:
+    case QCRYPTO_HASH_ALGO_MD5:
         alg_name = "md5";
         break;
-    case QCRYPTO_HASH_ALG_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA1:
         alg_name = "sha1";
         break;
-    case QCRYPTO_HASH_ALG_SHA224:
+    case QCRYPTO_HASH_ALGO_SHA224:
         alg_name = "sha224";
         break;
-    case QCRYPTO_HASH_ALG_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA256:
         alg_name = "sha256";
         break;
-    case QCRYPTO_HASH_ALG_SHA384:
+    case QCRYPTO_HASH_ALGO_SHA384:
         alg_name = "sha384";
         break;
-    case QCRYPTO_HASH_ALG_SHA512:
+    case QCRYPTO_HASH_ALGO_SHA512:
         alg_name = "sha512";
         break;
-    case QCRYPTO_HASH_ALG_RIPEMD160:
+    case QCRYPTO_HASH_ALGO_RIPEMD160:
         alg_name = "rmd160";
         break;
 
@@ -65,7 +65,7 @@ qcrypto_afalg_hash_format_name(QCryptoHashAlgorithm alg,
 }
 
 static QCryptoAFAlg *
-qcrypto_afalg_hash_hmac_ctx_new(QCryptoHashAlgorithm alg,
+qcrypto_afalg_hash_hmac_ctx_new(QCryptoHashAlgo alg,
                                 const uint8_t *key, size_t nkey,
                                 bool is_hmac, Error **errp)
 {
@@ -99,14 +99,14 @@ qcrypto_afalg_hash_hmac_ctx_new(QCryptoHashAlgorithm alg,
 }
 
 static QCryptoAFAlg *
-qcrypto_afalg_hash_ctx_new(QCryptoHashAlgorithm alg,
+qcrypto_afalg_hash_ctx_new(QCryptoHashAlgo alg,
                            Error **errp)
 {
     return qcrypto_afalg_hash_hmac_ctx_new(alg, NULL, 0, false, errp);
 }
 
 QCryptoAFAlg *
-qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgorithm alg,
+qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
 {
@@ -115,7 +115,7 @@ qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgorithm alg,
 
 static int
 qcrypto_afalg_hash_hmac_bytesv(QCryptoAFAlg *hmac,
-                               QCryptoHashAlgorithm alg,
+                               QCryptoHashAlgo alg,
                                const struct iovec *iov,
                                size_t niov, uint8_t **result,
                                size_t *resultlen,
@@ -173,7 +173,7 @@ out:
 }
 
 static int
-qcrypto_afalg_hash_bytesv(QCryptoHashAlgorithm alg,
+qcrypto_afalg_hash_bytesv(QCryptoHashAlgo alg,
                           const struct iovec *iov,
                           size_t niov, uint8_t **result,
                           size_t *resultlen,
diff --git a/crypto/hash-gcrypt.c b/crypto/hash-gcrypt.c
index 829e48258d..0973cc0d93 100644
--- a/crypto/hash-gcrypt.c
+++ b/crypto/hash-gcrypt.c
@@ -25,17 +25,17 @@
 #include "hashpriv.h"
 
 
-static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = GCRY_MD_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = GCRY_MD_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = GCRY_MD_SHA224,
-    [QCRYPTO_HASH_ALG_SHA256] = GCRY_MD_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = GCRY_MD_SHA384,
-    [QCRYPTO_HASH_ALG_SHA512] = GCRY_MD_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = GCRY_MD_RMD160,
+static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = GCRY_MD_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = GCRY_MD_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = GCRY_MD_SHA224,
+    [QCRYPTO_HASH_ALGO_SHA256] = GCRY_MD_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = GCRY_MD_SHA384,
+    [QCRYPTO_HASH_ALGO_SHA512] = GCRY_MD_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = GCRY_MD_RMD160,
 };
 
-gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
+gboolean qcrypto_hash_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hash_alg_map) &&
         qcrypto_hash_alg_map[alg] != GCRY_MD_NONE) {
@@ -46,7 +46,7 @@ gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
 
 
 static int
-qcrypto_gcrypt_hash_bytesv(QCryptoHashAlgorithm alg,
+qcrypto_gcrypt_hash_bytesv(QCryptoHashAlgo alg,
                            const struct iovec *iov,
                            size_t niov,
                            uint8_t **result,
diff --git a/crypto/hash-glib.c b/crypto/hash-glib.c
index 82de9db705..821fc9ac0c 100644
--- a/crypto/hash-glib.c
+++ b/crypto/hash-glib.c
@@ -24,17 +24,17 @@
 #include "hashpriv.h"
 
 
-static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = G_CHECKSUM_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = G_CHECKSUM_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = -1,
-    [QCRYPTO_HASH_ALG_SHA256] = G_CHECKSUM_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = -1,
-    [QCRYPTO_HASH_ALG_SHA512] = G_CHECKSUM_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = -1,
+static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = G_CHECKSUM_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = G_CHECKSUM_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = -1,
+    [QCRYPTO_HASH_ALGO_SHA256] = G_CHECKSUM_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = -1,
+    [QCRYPTO_HASH_ALGO_SHA512] = G_CHECKSUM_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = -1,
 };
 
-gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
+gboolean qcrypto_hash_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hash_alg_map) &&
         qcrypto_hash_alg_map[alg] != -1) {
@@ -45,7 +45,7 @@ gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
 
 
 static int
-qcrypto_glib_hash_bytesv(QCryptoHashAlgorithm alg,
+qcrypto_glib_hash_bytesv(QCryptoHashAlgo alg,
                          const struct iovec *iov,
                          size_t niov,
                          uint8_t **result,
diff --git a/crypto/hash-gnutls.c b/crypto/hash-gnutls.c
index 17911ac5d1..0636c0727a 100644
--- a/crypto/hash-gnutls.c
+++ b/crypto/hash-gnutls.c
@@ -25,17 +25,17 @@
 #include "hashpriv.h"
 
 
-static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = GNUTLS_DIG_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = GNUTLS_DIG_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = GNUTLS_DIG_SHA224,
-    [QCRYPTO_HASH_ALG_SHA256] = GNUTLS_DIG_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = GNUTLS_DIG_SHA384,
-    [QCRYPTO_HASH_ALG_SHA512] = GNUTLS_DIG_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = GNUTLS_DIG_RMD160,
+static int qcrypto_hash_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = GNUTLS_DIG_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = GNUTLS_DIG_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = GNUTLS_DIG_SHA224,
+    [QCRYPTO_HASH_ALGO_SHA256] = GNUTLS_DIG_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = GNUTLS_DIG_SHA384,
+    [QCRYPTO_HASH_ALGO_SHA512] = GNUTLS_DIG_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = GNUTLS_DIG_RMD160,
 };
 
-gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
+gboolean qcrypto_hash_supports(QCryptoHashAlgo alg)
 {
     size_t i;
     const gnutls_digest_algorithm_t *algs;
@@ -54,7 +54,7 @@ gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
 
 
 static int
-qcrypto_gnutls_hash_bytesv(QCryptoHashAlgorithm alg,
+qcrypto_gnutls_hash_bytesv(QCryptoHashAlgo alg,
                            const struct iovec *iov,
                            size_t niov,
                            uint8_t **result,
diff --git a/crypto/hash-nettle.c b/crypto/hash-nettle.c
index 1ca1a41062..8b08a9c675 100644
--- a/crypto/hash-nettle.c
+++ b/crypto/hash-nettle.c
@@ -50,43 +50,43 @@ struct qcrypto_hash_alg {
     qcrypto_nettle_result result;
     size_t len;
 } qcrypto_hash_alg_map[] = {
-    [QCRYPTO_HASH_ALG_MD5] = {
+    [QCRYPTO_HASH_ALGO_MD5] = {
         .init = (qcrypto_nettle_init)md5_init,
         .write = (qcrypto_nettle_write)md5_update,
         .result = (qcrypto_nettle_result)md5_digest,
         .len = MD5_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA1] = {
+    [QCRYPTO_HASH_ALGO_SHA1] = {
         .init = (qcrypto_nettle_init)sha1_init,
         .write = (qcrypto_nettle_write)sha1_update,
         .result = (qcrypto_nettle_result)sha1_digest,
         .len = SHA1_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA224] = {
+    [QCRYPTO_HASH_ALGO_SHA224] = {
         .init = (qcrypto_nettle_init)sha224_init,
         .write = (qcrypto_nettle_write)sha224_update,
         .result = (qcrypto_nettle_result)sha224_digest,
         .len = SHA224_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA256] = {
+    [QCRYPTO_HASH_ALGO_SHA256] = {
         .init = (qcrypto_nettle_init)sha256_init,
         .write = (qcrypto_nettle_write)sha256_update,
         .result = (qcrypto_nettle_result)sha256_digest,
         .len = SHA256_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA384] = {
+    [QCRYPTO_HASH_ALGO_SHA384] = {
         .init = (qcrypto_nettle_init)sha384_init,
         .write = (qcrypto_nettle_write)sha384_update,
         .result = (qcrypto_nettle_result)sha384_digest,
         .len = SHA384_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA512] = {
+    [QCRYPTO_HASH_ALGO_SHA512] = {
         .init = (qcrypto_nettle_init)sha512_init,
         .write = (qcrypto_nettle_write)sha512_update,
         .result = (qcrypto_nettle_result)sha512_digest,
         .len = SHA512_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_RIPEMD160] = {
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = {
         .init = (qcrypto_nettle_init)ripemd160_init,
         .write = (qcrypto_nettle_write)ripemd160_update,
         .result = (qcrypto_nettle_result)ripemd160_digest,
@@ -94,7 +94,7 @@ struct qcrypto_hash_alg {
     },
 };
 
-gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
+gboolean qcrypto_hash_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hash_alg_map) &&
         qcrypto_hash_alg_map[alg].init != NULL) {
@@ -105,7 +105,7 @@ gboolean qcrypto_hash_supports(QCryptoHashAlgorithm alg)
 
 
 static int
-qcrypto_nettle_hash_bytesv(QCryptoHashAlgorithm alg,
+qcrypto_nettle_hash_bytesv(QCryptoHashAlgo alg,
                            const struct iovec *iov,
                            size_t niov,
                            uint8_t **result,
diff --git a/crypto/hash.c b/crypto/hash.c
index b0f8228bdc..a1ae9be977 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -22,23 +22,23 @@
 #include "crypto/hash.h"
 #include "hashpriv.h"
 
-static size_t qcrypto_hash_alg_size[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = 16,
-    [QCRYPTO_HASH_ALG_SHA1] = 20,
-    [QCRYPTO_HASH_ALG_SHA224] = 28,
-    [QCRYPTO_HASH_ALG_SHA256] = 32,
-    [QCRYPTO_HASH_ALG_SHA384] = 48,
-    [QCRYPTO_HASH_ALG_SHA512] = 64,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = 20,
+static size_t qcrypto_hash_alg_size[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = 16,
+    [QCRYPTO_HASH_ALGO_SHA1] = 20,
+    [QCRYPTO_HASH_ALGO_SHA224] = 28,
+    [QCRYPTO_HASH_ALGO_SHA256] = 32,
+    [QCRYPTO_HASH_ALGO_SHA384] = 48,
+    [QCRYPTO_HASH_ALGO_SHA512] = 64,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = 20,
 };
 
-size_t qcrypto_hash_digest_len(QCryptoHashAlgorithm alg)
+size_t qcrypto_hash_digest_len(QCryptoHashAlgo alg)
 {
     assert(alg < G_N_ELEMENTS(qcrypto_hash_alg_size));
     return qcrypto_hash_alg_size[alg];
 }
 
-int qcrypto_hash_bytesv(QCryptoHashAlgorithm alg,
+int qcrypto_hash_bytesv(QCryptoHashAlgo alg,
                         const struct iovec *iov,
                         size_t niov,
                         uint8_t **result,
@@ -65,7 +65,7 @@ int qcrypto_hash_bytesv(QCryptoHashAlgorithm alg,
 }
 
 
-int qcrypto_hash_bytes(QCryptoHashAlgorithm alg,
+int qcrypto_hash_bytes(QCryptoHashAlgo alg,
                        const char *buf,
                        size_t len,
                        uint8_t **result,
@@ -79,7 +79,7 @@ int qcrypto_hash_bytes(QCryptoHashAlgorithm alg,
 
 static const char hex[] = "0123456789abcdef";
 
-int qcrypto_hash_digestv(QCryptoHashAlgorithm alg,
+int qcrypto_hash_digestv(QCryptoHashAlgo alg,
                          const struct iovec *iov,
                          size_t niov,
                          char **digest,
@@ -103,7 +103,7 @@ int qcrypto_hash_digestv(QCryptoHashAlgorithm alg,
     return 0;
 }
 
-int qcrypto_hash_digest(QCryptoHashAlgorithm alg,
+int qcrypto_hash_digest(QCryptoHashAlgo alg,
                         const char *buf,
                         size_t len,
                         char **digest,
@@ -114,7 +114,7 @@ int qcrypto_hash_digest(QCryptoHashAlgorithm alg,
     return qcrypto_hash_digestv(alg, &iov, 1, digest, errp);
 }
 
-int qcrypto_hash_base64v(QCryptoHashAlgorithm alg,
+int qcrypto_hash_base64v(QCryptoHashAlgo alg,
                          const struct iovec *iov,
                          size_t niov,
                          char **base64,
@@ -132,7 +132,7 @@ int qcrypto_hash_base64v(QCryptoHashAlgorithm alg,
     return 0;
 }
 
-int qcrypto_hash_base64(QCryptoHashAlgorithm alg,
+int qcrypto_hash_base64(QCryptoHashAlgo alg,
                         const char *buf,
                         size_t len,
                         char **base64,
diff --git a/crypto/hmac-gcrypt.c b/crypto/hmac-gcrypt.c
index 0c6f979711..19990cb6ed 100644
--- a/crypto/hmac-gcrypt.c
+++ b/crypto/hmac-gcrypt.c
@@ -18,14 +18,14 @@
 #include "hmacpriv.h"
 #include <gcrypt.h>
 
-static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = GCRY_MAC_HMAC_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = GCRY_MAC_HMAC_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = GCRY_MAC_HMAC_SHA224,
-    [QCRYPTO_HASH_ALG_SHA256] = GCRY_MAC_HMAC_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = GCRY_MAC_HMAC_SHA384,
-    [QCRYPTO_HASH_ALG_SHA512] = GCRY_MAC_HMAC_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = GCRY_MAC_HMAC_RMD160,
+static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = GCRY_MAC_HMAC_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = GCRY_MAC_HMAC_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = GCRY_MAC_HMAC_SHA224,
+    [QCRYPTO_HASH_ALGO_SHA256] = GCRY_MAC_HMAC_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = GCRY_MAC_HMAC_SHA384,
+    [QCRYPTO_HASH_ALGO_SHA512] = GCRY_MAC_HMAC_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = GCRY_MAC_HMAC_RMD160,
 };
 
 typedef struct QCryptoHmacGcrypt QCryptoHmacGcrypt;
@@ -33,7 +33,7 @@ struct QCryptoHmacGcrypt {
     gcry_mac_hd_t handle;
 };
 
-bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
+bool qcrypto_hmac_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hmac_alg_map) &&
         qcrypto_hmac_alg_map[alg] != GCRY_MAC_NONE) {
@@ -43,7 +43,7 @@ bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
     return false;
 }
 
-void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
 {
@@ -52,7 +52,7 @@ void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
 
     if (!qcrypto_hmac_supports(alg)) {
         error_setg(errp, "Unsupported hmac algorithm %s",
-                   QCryptoHashAlgorithm_str(alg));
+                   QCryptoHashAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/hmac-glib.c b/crypto/hmac-glib.c
index 509bbc74c2..ea80c8d1b2 100644
--- a/crypto/hmac-glib.c
+++ b/crypto/hmac-glib.c
@@ -17,14 +17,14 @@
 #include "crypto/hmac.h"
 #include "hmacpriv.h"
 
-static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = G_CHECKSUM_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = G_CHECKSUM_SHA1,
-    [QCRYPTO_HASH_ALG_SHA256] = G_CHECKSUM_SHA256,
-    [QCRYPTO_HASH_ALG_SHA512] = G_CHECKSUM_SHA512,
-    [QCRYPTO_HASH_ALG_SHA224] = -1,
-    [QCRYPTO_HASH_ALG_SHA384] = -1,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = -1,
+static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = G_CHECKSUM_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = G_CHECKSUM_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA256] = G_CHECKSUM_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA512] = G_CHECKSUM_SHA512,
+    [QCRYPTO_HASH_ALGO_SHA224] = -1,
+    [QCRYPTO_HASH_ALGO_SHA384] = -1,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = -1,
 };
 
 typedef struct QCryptoHmacGlib QCryptoHmacGlib;
@@ -32,7 +32,7 @@ struct QCryptoHmacGlib {
     GHmac *ghmac;
 };
 
-bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
+bool qcrypto_hmac_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hmac_alg_map) &&
         qcrypto_hmac_alg_map[alg] != -1) {
@@ -42,7 +42,7 @@ bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
     return false;
 }
 
-void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
 {
@@ -50,7 +50,7 @@ void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
 
     if (!qcrypto_hmac_supports(alg)) {
         error_setg(errp, "Unsupported hmac algorithm %s",
-                   QCryptoHashAlgorithm_str(alg));
+                   QCryptoHashAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/hmac-gnutls.c b/crypto/hmac-gnutls.c
index 24db383322..822995505c 100644
--- a/crypto/hmac-gnutls.c
+++ b/crypto/hmac-gnutls.c
@@ -20,14 +20,14 @@
 #include "crypto/hmac.h"
 #include "hmacpriv.h"
 
-static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = GNUTLS_MAC_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = GNUTLS_MAC_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = GNUTLS_MAC_SHA224,
-    [QCRYPTO_HASH_ALG_SHA256] = GNUTLS_MAC_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = GNUTLS_MAC_SHA384,
-    [QCRYPTO_HASH_ALG_SHA512] = GNUTLS_MAC_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = GNUTLS_MAC_RMD160,
+static int qcrypto_hmac_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = GNUTLS_MAC_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = GNUTLS_MAC_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = GNUTLS_MAC_SHA224,
+    [QCRYPTO_HASH_ALGO_SHA256] = GNUTLS_MAC_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = GNUTLS_MAC_SHA384,
+    [QCRYPTO_HASH_ALGO_SHA512] = GNUTLS_MAC_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = GNUTLS_MAC_RMD160,
 };
 
 typedef struct QCryptoHmacGnutls QCryptoHmacGnutls;
@@ -35,7 +35,7 @@ struct QCryptoHmacGnutls {
     gnutls_hmac_hd_t handle;
 };
 
-bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
+bool qcrypto_hmac_supports(QCryptoHashAlgo alg)
 {
     size_t i;
     const gnutls_digest_algorithm_t *algs;
@@ -52,7 +52,7 @@ bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
     return false;
 }
 
-void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
 {
@@ -61,7 +61,7 @@ void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
 
     if (!qcrypto_hmac_supports(alg)) {
         error_setg(errp, "Unsupported hmac algorithm %s",
-                   QCryptoHashAlgorithm_str(alg));
+                   QCryptoHashAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/hmac-nettle.c b/crypto/hmac-nettle.c
index 1ad6c4f253..54dd75d5ff 100644
--- a/crypto/hmac-nettle.c
+++ b/crypto/hmac-nettle.c
@@ -46,44 +46,44 @@ struct qcrypto_nettle_hmac_alg {
     qcrypto_nettle_hmac_update update;
     qcrypto_nettle_hmac_digest digest;
     size_t len;
-} qcrypto_hmac_alg_map[QCRYPTO_HASH_ALG__MAX] = {
-    [QCRYPTO_HASH_ALG_MD5] = {
+} qcrypto_hmac_alg_map[QCRYPTO_HASH_ALGO__MAX] = {
+    [QCRYPTO_HASH_ALGO_MD5] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_md5_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_md5_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_md5_digest,
         .len = MD5_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA1] = {
+    [QCRYPTO_HASH_ALGO_SHA1] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_sha1_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_sha1_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_sha1_digest,
         .len = SHA1_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA224] = {
+    [QCRYPTO_HASH_ALGO_SHA224] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_sha224_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_sha224_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_sha224_digest,
         .len = SHA224_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA256] = {
+    [QCRYPTO_HASH_ALGO_SHA256] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_sha256_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_sha256_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_sha256_digest,
         .len = SHA256_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA384] = {
+    [QCRYPTO_HASH_ALGO_SHA384] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_sha384_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_sha384_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_sha384_digest,
         .len = SHA384_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_SHA512] = {
+    [QCRYPTO_HASH_ALGO_SHA512] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_sha512_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_sha512_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_sha512_digest,
         .len = SHA512_DIGEST_SIZE,
     },
-    [QCRYPTO_HASH_ALG_RIPEMD160] = {
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = {
         .setkey = (qcrypto_nettle_hmac_setkey)hmac_ripemd160_set_key,
         .update = (qcrypto_nettle_hmac_update)hmac_ripemd160_update,
         .digest = (qcrypto_nettle_hmac_digest)hmac_ripemd160_digest,
@@ -91,7 +91,7 @@ struct qcrypto_nettle_hmac_alg {
     },
 };
 
-bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
+bool qcrypto_hmac_supports(QCryptoHashAlgo alg)
 {
     if (alg < G_N_ELEMENTS(qcrypto_hmac_alg_map) &&
         qcrypto_hmac_alg_map[alg].setkey != NULL) {
@@ -101,7 +101,7 @@ bool qcrypto_hmac_supports(QCryptoHashAlgorithm alg)
     return false;
 }
 
-void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
 {
@@ -109,7 +109,7 @@ void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
 
     if (!qcrypto_hmac_supports(alg)) {
         error_setg(errp, "Unsupported hmac algorithm %s",
-                   QCryptoHashAlgorithm_str(alg));
+                   QCryptoHashAlgo_str(alg));
         return NULL;
     }
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4de7e8c9cb..422e005182 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -83,7 +83,7 @@ int qcrypto_hmac_digest(QCryptoHmac *hmac,
     return qcrypto_hmac_digestv(hmac, &iov, 1, digest, errp);
 }
 
-QCryptoHmac *qcrypto_hmac_new(QCryptoHashAlgorithm alg,
+QCryptoHmac *qcrypto_hmac_new(QCryptoHashAlgo alg,
                               const uint8_t *key, size_t nkey,
                               Error **errp)
 {
diff --git a/crypto/ivgen.c b/crypto/ivgen.c
index 12822f8519..080846cb74 100644
--- a/crypto/ivgen.c
+++ b/crypto/ivgen.c
@@ -29,7 +29,7 @@
 
 QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
                                 QCryptoCipherAlgorithm cipheralg,
-                                QCryptoHashAlgorithm hash,
+                                QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
                                 Error **errp)
 {
@@ -85,7 +85,7 @@ QCryptoCipherAlgorithm qcrypto_ivgen_get_cipher(QCryptoIVGen *ivgen)
 }
 
 
-QCryptoHashAlgorithm qcrypto_ivgen_get_hash(QCryptoIVGen *ivgen)
+QCryptoHashAlgo qcrypto_ivgen_get_hash(QCryptoIVGen *ivgen)
 {
     return ivgen->hash;
 }
diff --git a/crypto/pbkdf-gcrypt.c b/crypto/pbkdf-gcrypt.c
index a8d8e64f4d..d4230c0f9c 100644
--- a/crypto/pbkdf-gcrypt.c
+++ b/crypto/pbkdf-gcrypt.c
@@ -23,37 +23,37 @@
 #include "qapi/error.h"
 #include "crypto/pbkdf.h"
 
-bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash)
+bool qcrypto_pbkdf2_supports(QCryptoHashAlgo hash)
 {
     switch (hash) {
-    case QCRYPTO_HASH_ALG_MD5:
-    case QCRYPTO_HASH_ALG_SHA1:
-    case QCRYPTO_HASH_ALG_SHA224:
-    case QCRYPTO_HASH_ALG_SHA256:
-    case QCRYPTO_HASH_ALG_SHA384:
-    case QCRYPTO_HASH_ALG_SHA512:
-    case QCRYPTO_HASH_ALG_RIPEMD160:
+    case QCRYPTO_HASH_ALGO_MD5:
+    case QCRYPTO_HASH_ALGO_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA224:
+    case QCRYPTO_HASH_ALGO_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA384:
+    case QCRYPTO_HASH_ALGO_SHA512:
+    case QCRYPTO_HASH_ALGO_RIPEMD160:
         return true;
     default:
         return false;
     }
 }
 
-int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
+int qcrypto_pbkdf2(QCryptoHashAlgo hash,
                    const uint8_t *key, size_t nkey,
                    const uint8_t *salt, size_t nsalt,
                    uint64_t iterations,
                    uint8_t *out, size_t nout,
                    Error **errp)
 {
-    static const int hash_map[QCRYPTO_HASH_ALG__MAX] = {
-        [QCRYPTO_HASH_ALG_MD5] = GCRY_MD_MD5,
-        [QCRYPTO_HASH_ALG_SHA1] = GCRY_MD_SHA1,
-        [QCRYPTO_HASH_ALG_SHA224] = GCRY_MD_SHA224,
-        [QCRYPTO_HASH_ALG_SHA256] = GCRY_MD_SHA256,
-        [QCRYPTO_HASH_ALG_SHA384] = GCRY_MD_SHA384,
-        [QCRYPTO_HASH_ALG_SHA512] = GCRY_MD_SHA512,
-        [QCRYPTO_HASH_ALG_RIPEMD160] = GCRY_MD_RMD160,
+    static const int hash_map[QCRYPTO_HASH_ALGO__MAX] = {
+        [QCRYPTO_HASH_ALGO_MD5] = GCRY_MD_MD5,
+        [QCRYPTO_HASH_ALGO_SHA1] = GCRY_MD_SHA1,
+        [QCRYPTO_HASH_ALGO_SHA224] = GCRY_MD_SHA224,
+        [QCRYPTO_HASH_ALGO_SHA256] = GCRY_MD_SHA256,
+        [QCRYPTO_HASH_ALGO_SHA384] = GCRY_MD_SHA384,
+        [QCRYPTO_HASH_ALGO_SHA512] = GCRY_MD_SHA512,
+        [QCRYPTO_HASH_ALGO_RIPEMD160] = GCRY_MD_RMD160,
     };
     int ret;
 
@@ -68,7 +68,7 @@ int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
         hash_map[hash] == GCRY_MD_NONE) {
         error_setg_errno(errp, ENOSYS,
                          "PBKDF does not support hash algorithm %s",
-                         QCryptoHashAlgorithm_str(hash));
+                         QCryptoHashAlgo_str(hash));
         return -1;
     }
 
diff --git a/crypto/pbkdf-gnutls.c b/crypto/pbkdf-gnutls.c
index 2dfbbd382c..68ed77f437 100644
--- a/crypto/pbkdf-gnutls.c
+++ b/crypto/pbkdf-gnutls.c
@@ -23,37 +23,37 @@
 #include "qapi/error.h"
 #include "crypto/pbkdf.h"
 
-bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash)
+bool qcrypto_pbkdf2_supports(QCryptoHashAlgo hash)
 {
     switch (hash) {
-    case QCRYPTO_HASH_ALG_MD5:
-    case QCRYPTO_HASH_ALG_SHA1:
-    case QCRYPTO_HASH_ALG_SHA224:
-    case QCRYPTO_HASH_ALG_SHA256:
-    case QCRYPTO_HASH_ALG_SHA384:
-    case QCRYPTO_HASH_ALG_SHA512:
-    case QCRYPTO_HASH_ALG_RIPEMD160:
+    case QCRYPTO_HASH_ALGO_MD5:
+    case QCRYPTO_HASH_ALGO_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA224:
+    case QCRYPTO_HASH_ALGO_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA384:
+    case QCRYPTO_HASH_ALGO_SHA512:
+    case QCRYPTO_HASH_ALGO_RIPEMD160:
         return true;
     default:
         return false;
     }
 }
 
-int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
+int qcrypto_pbkdf2(QCryptoHashAlgo hash,
                    const uint8_t *key, size_t nkey,
                    const uint8_t *salt, size_t nsalt,
                    uint64_t iterations,
                    uint8_t *out, size_t nout,
                    Error **errp)
 {
-    static const int hash_map[QCRYPTO_HASH_ALG__MAX] = {
-        [QCRYPTO_HASH_ALG_MD5] = GNUTLS_DIG_MD5,
-        [QCRYPTO_HASH_ALG_SHA1] = GNUTLS_DIG_SHA1,
-        [QCRYPTO_HASH_ALG_SHA224] = GNUTLS_DIG_SHA224,
-        [QCRYPTO_HASH_ALG_SHA256] = GNUTLS_DIG_SHA256,
-        [QCRYPTO_HASH_ALG_SHA384] = GNUTLS_DIG_SHA384,
-        [QCRYPTO_HASH_ALG_SHA512] = GNUTLS_DIG_SHA512,
-        [QCRYPTO_HASH_ALG_RIPEMD160] = GNUTLS_DIG_RMD160,
+    static const int hash_map[QCRYPTO_HASH_ALGO__MAX] = {
+        [QCRYPTO_HASH_ALGO_MD5] = GNUTLS_DIG_MD5,
+        [QCRYPTO_HASH_ALGO_SHA1] = GNUTLS_DIG_SHA1,
+        [QCRYPTO_HASH_ALGO_SHA224] = GNUTLS_DIG_SHA224,
+        [QCRYPTO_HASH_ALGO_SHA256] = GNUTLS_DIG_SHA256,
+        [QCRYPTO_HASH_ALGO_SHA384] = GNUTLS_DIG_SHA384,
+        [QCRYPTO_HASH_ALGO_SHA512] = GNUTLS_DIG_SHA512,
+        [QCRYPTO_HASH_ALGO_RIPEMD160] = GNUTLS_DIG_RMD160,
     };
     int ret;
     const gnutls_datum_t gkey = { (unsigned char *)key, nkey };
@@ -70,7 +70,7 @@ int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
         hash_map[hash] == GNUTLS_DIG_UNKNOWN) {
         error_setg_errno(errp, ENOSYS,
                          "PBKDF does not support hash algorithm %s",
-                         QCryptoHashAlgorithm_str(hash));
+                         QCryptoHashAlgo_str(hash));
         return -1;
     }
 
diff --git a/crypto/pbkdf-nettle.c b/crypto/pbkdf-nettle.c
index d6293c25a1..93e686c2c6 100644
--- a/crypto/pbkdf-nettle.c
+++ b/crypto/pbkdf-nettle.c
@@ -25,22 +25,22 @@
 #include "crypto/pbkdf.h"
 
 
-bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash)
+bool qcrypto_pbkdf2_supports(QCryptoHashAlgo hash)
 {
     switch (hash) {
-    case QCRYPTO_HASH_ALG_SHA1:
-    case QCRYPTO_HASH_ALG_SHA224:
-    case QCRYPTO_HASH_ALG_SHA256:
-    case QCRYPTO_HASH_ALG_SHA384:
-    case QCRYPTO_HASH_ALG_SHA512:
-    case QCRYPTO_HASH_ALG_RIPEMD160:
+    case QCRYPTO_HASH_ALGO_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA224:
+    case QCRYPTO_HASH_ALGO_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA384:
+    case QCRYPTO_HASH_ALGO_SHA512:
+    case QCRYPTO_HASH_ALGO_RIPEMD160:
         return true;
     default:
         return false;
     }
 }
 
-int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
+int qcrypto_pbkdf2(QCryptoHashAlgo hash,
                    const uint8_t *key, size_t nkey,
                    const uint8_t *salt, size_t nsalt,
                    uint64_t iterations,
@@ -65,43 +65,43 @@ int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
     }
 
     switch (hash) {
-    case QCRYPTO_HASH_ALG_MD5:
+    case QCRYPTO_HASH_ALGO_MD5:
         hmac_md5_set_key(&ctx.md5, nkey, key);
         PBKDF2(&ctx.md5, hmac_md5_update, hmac_md5_digest,
                MD5_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA1:
         hmac_sha1_set_key(&ctx.sha1, nkey, key);
         PBKDF2(&ctx.sha1, hmac_sha1_update, hmac_sha1_digest,
                SHA1_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA224:
+    case QCRYPTO_HASH_ALGO_SHA224:
         hmac_sha224_set_key(&ctx.sha224, nkey, key);
         PBKDF2(&ctx.sha224, hmac_sha224_update, hmac_sha224_digest,
                SHA224_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA256:
         hmac_sha256_set_key(&ctx.sha256, nkey, key);
         PBKDF2(&ctx.sha256, hmac_sha256_update, hmac_sha256_digest,
                SHA256_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA384:
+    case QCRYPTO_HASH_ALGO_SHA384:
         hmac_sha384_set_key(&ctx.sha384, nkey, key);
         PBKDF2(&ctx.sha384, hmac_sha384_update, hmac_sha384_digest,
                SHA384_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA512:
+    case QCRYPTO_HASH_ALGO_SHA512:
         hmac_sha512_set_key(&ctx.sha512, nkey, key);
         PBKDF2(&ctx.sha512, hmac_sha512_update, hmac_sha512_digest,
                SHA512_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
         break;
 
-    case QCRYPTO_HASH_ALG_RIPEMD160:
+    case QCRYPTO_HASH_ALGO_RIPEMD160:
         hmac_ripemd160_set_key(&ctx.ripemd160, nkey, key);
         PBKDF2(&ctx.ripemd160, hmac_ripemd160_update, hmac_ripemd160_digest,
                RIPEMD160_DIGEST_SIZE, iterations, nsalt, salt, nout, out);
@@ -110,7 +110,7 @@ int qcrypto_pbkdf2(QCryptoHashAlgorithm hash,
     default:
         error_setg_errno(errp, ENOSYS,
                          "PBKDF does not support hash algorithm %s",
-                         QCryptoHashAlgorithm_str(hash));
+                         QCryptoHashAlgo_str(hash));
         return -1;
     }
     return 0;
diff --git a/crypto/pbkdf-stub.c b/crypto/pbkdf-stub.c
index 9c4622e424..9f29d0eed7 100644
--- a/crypto/pbkdf-stub.c
+++ b/crypto/pbkdf-stub.c
@@ -22,12 +22,12 @@
 #include "qapi/error.h"
 #include "crypto/pbkdf.h"
 
-bool qcrypto_pbkdf2_supports(QCryptoHashAlgorithm hash G_GNUC_UNUSED)
+bool qcrypto_pbkdf2_supports(QCryptoHashAlgo hash G_GNUC_UNUSED)
 {
     return false;
 }
 
-int qcrypto_pbkdf2(QCryptoHashAlgorithm hash G_GNUC_UNUSED,
+int qcrypto_pbkdf2(QCryptoHashAlgo hash G_GNUC_UNUSED,
                    const uint8_t *key G_GNUC_UNUSED,
                    size_t nkey G_GNUC_UNUSED,
                    const uint8_t *salt G_GNUC_UNUSED,
diff --git a/crypto/pbkdf.c b/crypto/pbkdf.c
index 8d198c152c..051dbbbd2e 100644
--- a/crypto/pbkdf.c
+++ b/crypto/pbkdf.c
@@ -85,7 +85,7 @@ static int qcrypto_pbkdf2_get_thread_cpu(unsigned long long *val_ms,
 #endif
 }
 
-uint64_t qcrypto_pbkdf2_count_iters(QCryptoHashAlgorithm hash,
+uint64_t qcrypto_pbkdf2_count_iters(QCryptoHashAlgo hash,
                                     const uint8_t *key, size_t nkey,
                                     const uint8_t *salt, size_t nsalt,
                                     size_t nout,
diff --git a/hw/misc/aspeed_hace.c b/hw/misc/aspeed_hace.c
index c06c04ddc6..3541adf813 100644
--- a/hw/misc/aspeed_hace.c
+++ b/hw/misc/aspeed_hace.c
@@ -68,15 +68,15 @@
 
 static const struct {
     uint32_t mask;
-    QCryptoHashAlgorithm algo;
+    QCryptoHashAlgo algo;
 } hash_algo_map[] = {
-    { HASH_ALGO_MD5, QCRYPTO_HASH_ALG_MD5 },
-    { HASH_ALGO_SHA1, QCRYPTO_HASH_ALG_SHA1 },
-    { HASH_ALGO_SHA224, QCRYPTO_HASH_ALG_SHA224 },
-    { HASH_ALGO_SHA256, QCRYPTO_HASH_ALG_SHA256 },
-    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA512, QCRYPTO_HASH_ALG_SHA512 },
-    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA384, QCRYPTO_HASH_ALG_SHA384 },
-    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA256, QCRYPTO_HASH_ALG_SHA256 },
+    { HASH_ALGO_MD5, QCRYPTO_HASH_ALGO_MD5 },
+    { HASH_ALGO_SHA1, QCRYPTO_HASH_ALGO_SHA1 },
+    { HASH_ALGO_SHA224, QCRYPTO_HASH_ALGO_SHA224 },
+    { HASH_ALGO_SHA256, QCRYPTO_HASH_ALGO_SHA256 },
+    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA512, QCRYPTO_HASH_ALGO_SHA512 },
+    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA384, QCRYPTO_HASH_ALGO_SHA384 },
+    { HASH_ALGO_SHA512_SERIES | HASH_ALGO_SHA512_SHA256, QCRYPTO_HASH_ALGO_SHA256 },
 };
 
 static int hash_algo_lookup(uint32_t reg)
diff --git a/io/channel-websock.c b/io/channel-websock.c
index de39f0d182..55192b770a 100644
--- a/io/channel-websock.c
+++ b/io/channel-websock.c
@@ -351,7 +351,7 @@ static void qio_channel_websock_handshake_send_res_ok(QIOChannelWebsock *ioc,
               QIO_CHANNEL_WEBSOCK_GUID_LEN + 1);
 
     /* hash and encode it */
-    if (qcrypto_hash_base64(QCRYPTO_HASH_ALG_SHA1,
+    if (qcrypto_hash_base64(QCRYPTO_HASH_ALGO_SHA1,
                             combined_key,
                             QIO_CHANNEL_WEBSOCK_CLIENT_KEY_LEN +
                             QIO_CHANNEL_WEBSOCK_GUID_LEN,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index a0d271f898..1a4eb1ada6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1883,7 +1883,7 @@ static bool build_kernel_loader_hashes(PaddedSevHashTable *padded_ht,
      * be used.
      */
     hashp = cmdline_hash;
-    if (qcrypto_hash_bytes(QCRYPTO_HASH_ALG_SHA256, ctx->cmdline_data,
+    if (qcrypto_hash_bytes(QCRYPTO_HASH_ALGO_SHA256, ctx->cmdline_data,
                            ctx->cmdline_size, &hashp, &hash_len, errp) < 0) {
         return false;
     }
@@ -1894,7 +1894,7 @@ static bool build_kernel_loader_hashes(PaddedSevHashTable *padded_ht,
      * -initrd, an empty buffer will be used (ctx->initrd_size == 0).
      */
     hashp = initrd_hash;
-    if (qcrypto_hash_bytes(QCRYPTO_HASH_ALG_SHA256, ctx->initrd_data,
+    if (qcrypto_hash_bytes(QCRYPTO_HASH_ALGO_SHA256, ctx->initrd_data,
                            ctx->initrd_size, &hashp, &hash_len, errp) < 0) {
         return false;
     }
@@ -1906,7 +1906,7 @@ static bool build_kernel_loader_hashes(PaddedSevHashTable *padded_ht,
         { .iov_base = ctx->setup_data, .iov_len = ctx->setup_size },
         { .iov_base = ctx->kernel_data, .iov_len = ctx->kernel_size }
     };
-    if (qcrypto_hash_bytesv(QCRYPTO_HASH_ALG_SHA256, iov, ARRAY_SIZE(iov),
+    if (qcrypto_hash_bytesv(QCRYPTO_HASH_ALGO_SHA256, iov, ARRAY_SIZE(iov),
                             &hashp, &hash_len, errp) < 0) {
         return false;
     }
diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
index bbc29c9b12..0029972385 100644
--- a/tests/bench/benchmark-crypto-akcipher.c
+++ b/tests/bench/benchmark-crypto-akcipher.c
@@ -21,7 +21,7 @@
 static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
                                             size_t keylen,
                                             QCryptoRSAPaddingAlgorithm padding,
-                                            QCryptoHashAlgorithm hash)
+                                            QCryptoHashAlgo hash)
 {
     QCryptoAkCipherOptions opt;
 
@@ -40,7 +40,7 @@ static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
 #define SIGN_TIMES 10000
 #define VERIFY_TIMES 100000
 #define PADDING QCRYPTO_RSA_PADDING_ALG_PKCS1
-#define HASH QCRYPTO_HASH_ALG_SHA1
+#define HASH QCRYPTO_HASH_ALGO_SHA1
 
     g_autoptr(QCryptoAkCipher) rsa =
         create_rsa_akcipher(priv_key, keylen, PADDING, HASH);
@@ -54,7 +54,7 @@ static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
 
     g_test_message("benchmark rsa%zu (%s-%s) sign...", key_size,
                    QCryptoRSAPaddingAlgorithm_str(PADDING),
-                   QCryptoHashAlgorithm_str(HASH));
+                   QCryptoHashAlgo_str(HASH));
     g_test_timer_start();
     for (count = 0; count < SIGN_TIMES; ++count) {
         g_assert(qcrypto_akcipher_sign(rsa, dgst, SHA1_DGST_LEN,
@@ -65,13 +65,13 @@ static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
     g_test_message("rsa%zu (%s-%s) sign %zu times in %.2f seconds,"
                    " %.2f times/sec ",
                    key_size,  QCryptoRSAPaddingAlgorithm_str(PADDING),
-                   QCryptoHashAlgorithm_str(HASH),
+                   QCryptoHashAlgo_str(HASH),
                    count, g_test_timer_last(),
                    (double)count / g_test_timer_last());
 
     g_test_message("benchmark rsa%zu (%s-%s) verification...", key_size,
                    QCryptoRSAPaddingAlgorithm_str(PADDING),
-                   QCryptoHashAlgorithm_str(HASH));
+                   QCryptoHashAlgo_str(HASH));
     g_test_timer_start();
     for (count = 0; count < VERIFY_TIMES; ++count) {
         g_assert(qcrypto_akcipher_verify(rsa, signature, key_size / BYTE,
@@ -82,7 +82,7 @@ static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
     g_test_message("rsa%zu (%s-%s) verify %zu times in %.2f seconds,"
                    " %.2f times/sec ",
                    key_size, QCryptoRSAPaddingAlgorithm_str(PADDING),
-                   QCryptoHashAlgorithm_str(HASH),
+                   QCryptoHashAlgo_str(HASH),
                    count, g_test_timer_last(),
                    (double)count / g_test_timer_last());
 }
diff --git a/tests/bench/benchmark-crypto-hash.c b/tests/bench/benchmark-crypto-hash.c
index 927b00bb4d..252098a69d 100644
--- a/tests/bench/benchmark-crypto-hash.c
+++ b/tests/bench/benchmark-crypto-hash.c
@@ -17,7 +17,7 @@
 
 typedef struct QCryptoHashOpts {
     size_t chunk_size;
-    QCryptoHashAlgorithm alg;
+    QCryptoHashAlgo alg;
 } QCryptoHashOpts;
 
 static void test_hash_speed(const void *opaque)
@@ -49,7 +49,7 @@ static void test_hash_speed(const void *opaque)
     g_test_timer_elapsed();
 
     g_test_message("hash(%s): chunk %zu bytes %.2f MB/sec",
-                   QCryptoHashAlgorithm_str(opts->alg),
+                   QCryptoHashAlgo_str(opts->alg),
                    opts->chunk_size, total / g_test_timer_last());
 
     g_free(out);
@@ -65,14 +65,14 @@ int main(int argc, char **argv)
 
 #define TEST_ONE(a, c)                                          \
     QCryptoHashOpts opts ## a ## c = {                          \
-        .alg = QCRYPTO_HASH_ALG_ ## a, .chunk_size = c,         \
+        .alg = QCRYPTO_HASH_ALGO_ ## a, .chunk_size = c,         \
     };                                                          \
     memset(name, 0 , sizeof(name));                             \
     snprintf(name, sizeof(name),                                \
              "/crypto/benchmark/hash/%s/bufsize-%d",            \
-             QCryptoHashAlgorithm_str(QCRYPTO_HASH_ALG_ ## a),  \
+             QCryptoHashAlgo_str(QCRYPTO_HASH_ALGO_ ## a),  \
              c);                                                \
-    if (qcrypto_hash_supports(QCRYPTO_HASH_ALG_ ## a))          \
+    if (qcrypto_hash_supports(QCRYPTO_HASH_ALGO_ ## a))          \
         g_test_add_data_func(name,                              \
                              &opts ## a ## c,                   \
                              test_hash_speed);
diff --git a/tests/bench/benchmark-crypto-hmac.c b/tests/bench/benchmark-crypto-hmac.c
index 5cca636789..d51de98f47 100644
--- a/tests/bench/benchmark-crypto-hmac.c
+++ b/tests/bench/benchmark-crypto-hmac.c
@@ -28,7 +28,7 @@ static void test_hmac_speed(const void *opaque)
     Error *err = NULL;
     int ret;
 
-    if (!qcrypto_hmac_supports(QCRYPTO_HASH_ALG_SHA256)) {
+    if (!qcrypto_hmac_supports(QCRYPTO_HASH_ALGO_SHA256)) {
         return;
     }
 
@@ -40,7 +40,7 @@ static void test_hmac_speed(const void *opaque)
 
     g_test_timer_start();
     do {
-        hmac = qcrypto_hmac_new(QCRYPTO_HASH_ALG_SHA256,
+        hmac = qcrypto_hmac_new(QCRYPTO_HASH_ALGO_SHA256,
                                 (const uint8_t *)KEY, strlen(KEY), &err);
         g_assert(err == NULL);
         g_assert(hmac != NULL);
@@ -56,7 +56,7 @@ static void test_hmac_speed(const void *opaque)
 
     total /= MiB;
     g_test_message("hmac(%s): chunk %zu bytes %.2f MB/sec",
-                   QCryptoHashAlgorithm_str(QCRYPTO_HASH_ALG_SHA256),
+                   QCryptoHashAlgo_str(QCRYPTO_HASH_ALGO_SHA256),
                    chunk_size, total / g_test_timer_last());
 
     g_free(out);
diff --git a/tests/unit/test-crypto-afsplit.c b/tests/unit/test-crypto-afsplit.c
index 00a7c180fd..45e9046bf6 100644
--- a/tests/unit/test-crypto-afsplit.c
+++ b/tests/unit/test-crypto-afsplit.c
@@ -26,7 +26,7 @@
 typedef struct QCryptoAFSplitTestData QCryptoAFSplitTestData;
 struct QCryptoAFSplitTestData {
     const char *path;
-    QCryptoHashAlgorithm hash;
+    QCryptoHashAlgo hash;
     uint32_t stripes;
     size_t blocklen;
     const uint8_t *key;
@@ -36,7 +36,7 @@ struct QCryptoAFSplitTestData {
 static QCryptoAFSplitTestData test_data[] = {
     {
         .path = "/crypto/afsplit/sha256/5",
-        .hash = QCRYPTO_HASH_ALG_SHA256,
+        .hash = QCRYPTO_HASH_ALGO_SHA256,
         .stripes = 5,
         .blocklen = 32,
         .key = (const uint8_t *)
@@ -68,7 +68,7 @@ static QCryptoAFSplitTestData test_data[] = {
     },
     {
         .path = "/crypto/afsplit/sha256/5000",
-        .hash = QCRYPTO_HASH_ALG_SHA256,
+        .hash = QCRYPTO_HASH_ALGO_SHA256,
         .stripes = 5000,
         .blocklen = 16,
         .key = (const uint8_t *)
@@ -77,7 +77,7 @@ static QCryptoAFSplitTestData test_data[] = {
     },
     {
         .path = "/crypto/afsplit/sha1/1000",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .stripes = 1000,
         .blocklen = 32,
         .key = (const uint8_t *)
@@ -88,7 +88,7 @@ static QCryptoAFSplitTestData test_data[] = {
     },
     {
         .path = "/crypto/afsplit/sha256/big",
-        .hash = QCRYPTO_HASH_ALG_SHA256,
+        .hash = QCRYPTO_HASH_ALGO_SHA256,
         .stripes = 1000,
         .blocklen = 64,
         .key = (const uint8_t *)
diff --git a/tests/unit/test-crypto-akcipher.c b/tests/unit/test-crypto-akcipher.c
index 59bc6f1e69..86501f19ab 100644
--- a/tests/unit/test-crypto-akcipher.c
+++ b/tests/unit/test-crypto-akcipher.c
@@ -808,7 +808,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
             .alg = QCRYPTO_AKCIPHER_ALG_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
-                .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+                .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
             },
         },
         .pub_key = rsa1024_public_key,
@@ -853,7 +853,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
             .alg = QCRYPTO_AKCIPHER_ALG_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
-                .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+                .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
             },
         },
         .pub_key = rsa2048_public_key,
@@ -947,7 +947,7 @@ static void test_rsakey(const void *opaque)
         .alg = QCRYPTO_AKCIPHER_ALG_RSA,
         .u.rsa = {
             .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
-            .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+            .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
         }
     };
     g_autoptr(QCryptoAkCipher) key = qcrypto_akcipher_new(
diff --git a/tests/unit/test-crypto-block.c b/tests/unit/test-crypto-block.c
index 2a6c6e99e5..c2f5fe7b25 100644
--- a/tests/unit/test-crypto-block.c
+++ b/tests/unit/test-crypto-block.c
@@ -97,9 +97,9 @@ static QCryptoBlockCreateOptions luks_create_opts_aes256_cbc_essiv = {
         .has_ivgen_alg = true,
         .ivgen_alg = QCRYPTO_IVGEN_ALG_ESSIV,
         .has_ivgen_hash_alg = true,
-        .ivgen_hash_alg = QCRYPTO_HASH_ALG_SHA256,
+        .ivgen_hash_alg = QCRYPTO_HASH_ALGO_SHA256,
         .has_hash_alg = true,
-        .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+        .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
     },
 };
 #endif /* TEST_LUKS */
@@ -114,10 +114,10 @@ static struct QCryptoBlockTestData {
 
     QCryptoCipherAlgorithm cipher_alg;
     QCryptoCipherMode cipher_mode;
-    QCryptoHashAlgorithm hash_alg;
+    QCryptoHashAlgo hash_alg;
 
     QCryptoIVGenAlgorithm ivgen_alg;
-    QCryptoHashAlgorithm ivgen_hash;
+    QCryptoHashAlgo ivgen_hash;
 
     bool slow;
 } test_data[] = {
@@ -143,7 +143,7 @@ static struct QCryptoBlockTestData {
 
         .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_XTS,
-        .hash_alg = QCRYPTO_HASH_ALG_SHA256,
+        .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
         .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
 
@@ -158,7 +158,7 @@ static struct QCryptoBlockTestData {
 
         .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
-        .hash_alg = QCRYPTO_HASH_ALG_SHA256,
+        .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
         .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
 
@@ -173,10 +173,10 @@ static struct QCryptoBlockTestData {
 
         .cipher_alg = QCRYPTO_CIPHER_ALG_AES_256,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
-        .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+        .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
 
         .ivgen_alg = QCRYPTO_IVGEN_ALG_ESSIV,
-        .ivgen_hash = QCRYPTO_HASH_ALG_SHA256,
+        .ivgen_hash = QCRYPTO_HASH_ALGO_SHA256,
 
         .slow = true,
     },
diff --git a/tests/unit/test-crypto-hash.c b/tests/unit/test-crypto-hash.c
index 1f4abb822b..124d204485 100644
--- a/tests/unit/test-crypto-hash.c
+++ b/tests/unit/test-crypto-hash.c
@@ -55,31 +55,31 @@
 #define OUTPUT_RIPEMD160_B64 "89ZY+tP9+ytSyTac8NRBJJ3fqKA="
 
 static const char *expected_outputs[] = {
-    [QCRYPTO_HASH_ALG_MD5] = OUTPUT_MD5,
-    [QCRYPTO_HASH_ALG_SHA1] = OUTPUT_SHA1,
-    [QCRYPTO_HASH_ALG_SHA224] = OUTPUT_SHA224,
-    [QCRYPTO_HASH_ALG_SHA256] = OUTPUT_SHA256,
-    [QCRYPTO_HASH_ALG_SHA384] = OUTPUT_SHA384,
-    [QCRYPTO_HASH_ALG_SHA512] = OUTPUT_SHA512,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = OUTPUT_RIPEMD160,
+    [QCRYPTO_HASH_ALGO_MD5] = OUTPUT_MD5,
+    [QCRYPTO_HASH_ALGO_SHA1] = OUTPUT_SHA1,
+    [QCRYPTO_HASH_ALGO_SHA224] = OUTPUT_SHA224,
+    [QCRYPTO_HASH_ALGO_SHA256] = OUTPUT_SHA256,
+    [QCRYPTO_HASH_ALGO_SHA384] = OUTPUT_SHA384,
+    [QCRYPTO_HASH_ALGO_SHA512] = OUTPUT_SHA512,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = OUTPUT_RIPEMD160,
 };
 static const char *expected_outputs_b64[] = {
-    [QCRYPTO_HASH_ALG_MD5] = OUTPUT_MD5_B64,
-    [QCRYPTO_HASH_ALG_SHA1] = OUTPUT_SHA1_B64,
-    [QCRYPTO_HASH_ALG_SHA224] = OUTPUT_SHA224_B64,
-    [QCRYPTO_HASH_ALG_SHA256] = OUTPUT_SHA256_B64,
-    [QCRYPTO_HASH_ALG_SHA384] = OUTPUT_SHA384_B64,
-    [QCRYPTO_HASH_ALG_SHA512] = OUTPUT_SHA512_B64,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = OUTPUT_RIPEMD160_B64,
+    [QCRYPTO_HASH_ALGO_MD5] = OUTPUT_MD5_B64,
+    [QCRYPTO_HASH_ALGO_SHA1] = OUTPUT_SHA1_B64,
+    [QCRYPTO_HASH_ALGO_SHA224] = OUTPUT_SHA224_B64,
+    [QCRYPTO_HASH_ALGO_SHA256] = OUTPUT_SHA256_B64,
+    [QCRYPTO_HASH_ALGO_SHA384] = OUTPUT_SHA384_B64,
+    [QCRYPTO_HASH_ALGO_SHA512] = OUTPUT_SHA512_B64,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = OUTPUT_RIPEMD160_B64,
 };
 static const int expected_lens[] = {
-    [QCRYPTO_HASH_ALG_MD5] = 16,
-    [QCRYPTO_HASH_ALG_SHA1] = 20,
-    [QCRYPTO_HASH_ALG_SHA224] = 28,
-    [QCRYPTO_HASH_ALG_SHA256] = 32,
-    [QCRYPTO_HASH_ALG_SHA384] = 48,
-    [QCRYPTO_HASH_ALG_SHA512] = 64,
-    [QCRYPTO_HASH_ALG_RIPEMD160] = 20,
+    [QCRYPTO_HASH_ALGO_MD5] = 16,
+    [QCRYPTO_HASH_ALGO_SHA1] = 20,
+    [QCRYPTO_HASH_ALGO_SHA224] = 28,
+    [QCRYPTO_HASH_ALGO_SHA256] = 32,
+    [QCRYPTO_HASH_ALGO_SHA384] = 48,
+    [QCRYPTO_HASH_ALGO_SHA512] = 64,
+    [QCRYPTO_HASH_ALGO_RIPEMD160] = 20,
 };
 
 static const char hex[] = "0123456789abcdef";
diff --git a/tests/unit/test-crypto-hmac.c b/tests/unit/test-crypto-hmac.c
index 23eb724d94..3fa50f24bb 100644
--- a/tests/unit/test-crypto-hmac.c
+++ b/tests/unit/test-crypto-hmac.c
@@ -27,43 +27,43 @@
 
 typedef struct QCryptoHmacTestData QCryptoHmacTestData;
 struct QCryptoHmacTestData {
-    QCryptoHashAlgorithm alg;
+    QCryptoHashAlgo alg;
     const char *hex_digest;
 };
 
 static QCryptoHmacTestData test_data[] = {
     {
-        .alg = QCRYPTO_HASH_ALG_MD5,
+        .alg = QCRYPTO_HASH_ALGO_MD5,
         .hex_digest =
             "ede9cb83679ba82d88fbeae865b3f8fc",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_SHA1,
+        .alg = QCRYPTO_HASH_ALGO_SHA1,
         .hex_digest =
             "c7b5a631e3aac975c4ededfcd346e469"
             "dbc5f2d1",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_SHA224,
+        .alg = QCRYPTO_HASH_ALGO_SHA224,
         .hex_digest =
             "5f768179dbb29ca722875d0f461a2e2f"
             "597d0210340a84df1a8e9c63",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_SHA256,
+        .alg = QCRYPTO_HASH_ALGO_SHA256,
         .hex_digest =
             "3798f363c57afa6edaffe39016ca7bad"
             "efd1e670afb0e3987194307dec3197db",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_SHA384,
+        .alg = QCRYPTO_HASH_ALGO_SHA384,
         .hex_digest =
             "d218680a6032d33dccd9882d6a6a7164"
             "64f26623be257a9b2919b185294f4a49"
             "9e54b190bfd6bc5cedd2cd05c7e65e82",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_SHA512,
+        .alg = QCRYPTO_HASH_ALGO_SHA512,
         .hex_digest =
             "835a4f5b3750b4c1fccfa88da2f746a4"
             "900160c9f18964309bb736c13b59491b"
@@ -71,7 +71,7 @@ static QCryptoHmacTestData test_data[] = {
             "94c4ba26862b2dadb59b7ede1d08d53e",
     },
     {
-        .alg = QCRYPTO_HASH_ALG_RIPEMD160,
+        .alg = QCRYPTO_HASH_ALGO_RIPEMD160,
         .hex_digest =
             "94964ed4c1155b62b668c241d67279e5"
             "8a711676",
diff --git a/tests/unit/test-crypto-ivgen.c b/tests/unit/test-crypto-ivgen.c
index 29630ed348..9aa3f6018b 100644
--- a/tests/unit/test-crypto-ivgen.c
+++ b/tests/unit/test-crypto-ivgen.c
@@ -27,7 +27,7 @@ struct QCryptoIVGenTestData {
     const char *path;
     uint64_t sector;
     QCryptoIVGenAlgorithm ivalg;
-    QCryptoHashAlgorithm hashalg;
+    QCryptoHashAlgo hashalg;
     QCryptoCipherAlgorithm cipheralg;
     const uint8_t *key;
     size_t nkey;
@@ -94,7 +94,7 @@ struct QCryptoIVGenTestData {
         .sector = 0x1,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
-        .hashalg = QCRYPTO_HASH_ALG_SHA256,
+        .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
         .nkey = 16,
@@ -108,7 +108,7 @@ struct QCryptoIVGenTestData {
         .sector = 0x1f2e3d4cULL,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
-        .hashalg = QCRYPTO_HASH_ALG_SHA256,
+        .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
         .nkey = 16,
@@ -122,7 +122,7 @@ struct QCryptoIVGenTestData {
         .sector = 0x1f2e3d4c5b6a7988ULL,
         .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALG_AES_128,
-        .hashalg = QCRYPTO_HASH_ALG_SHA256,
+        .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
                                 "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
         .nkey = 16,
diff --git a/tests/unit/test-crypto-pbkdf.c b/tests/unit/test-crypto-pbkdf.c
index 43c417f6b4..d2cbd5b26e 100644
--- a/tests/unit/test-crypto-pbkdf.c
+++ b/tests/unit/test-crypto-pbkdf.c
@@ -32,7 +32,7 @@
 typedef struct QCryptoPbkdfTestData QCryptoPbkdfTestData;
 struct QCryptoPbkdfTestData {
     const char *path;
-    QCryptoHashAlgorithm hash;
+    QCryptoHashAlgo hash;
     unsigned int iterations;
     const char *key;
     size_t nkey;
@@ -53,7 +53,7 @@ static QCryptoPbkdfTestData test_data[] = {
     /* RFC 3962 test data */
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter1",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 1,
         .key = "password",
         .nkey = 8,
@@ -67,7 +67,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter2",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 2,
         .key = "password",
         .nkey = 8,
@@ -81,7 +81,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter1200a",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 1200,
         .key = "password",
         .nkey = 8,
@@ -95,7 +95,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter5",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 5,
         .key = "password",
         .nkey = 8,
@@ -109,7 +109,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter1200b",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
@@ -124,7 +124,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter1200c",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
@@ -139,7 +139,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc3962/sha1/iter50",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 50,
         .key = "\360\235\204\236", /* g-clef ("\xf09d849e) */
         .nkey = 4,
@@ -155,7 +155,7 @@ static QCryptoPbkdfTestData test_data[] = {
     /* RFC-6070 test data */
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter1",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 1,
         .key = "password",
         .nkey = 8,
@@ -167,7 +167,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter2",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 2,
         .key = "password",
         .nkey = 8,
@@ -179,7 +179,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter4096",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 4096,
         .key = "password",
         .nkey = 8,
@@ -191,7 +191,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter16777216",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 16777216,
         .key = "password",
         .nkey = 8,
@@ -204,7 +204,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter4096a",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 4096,
         .key = "passwordPASSWORDpassword",
         .nkey = 24,
@@ -217,7 +217,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/rfc6070/sha1/iter4096b",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 4096,
         .key = "pass\0word",
         .nkey = 9,
@@ -232,7 +232,7 @@ static QCryptoPbkdfTestData test_data[] = {
     {
         /* empty password test. */
         .path = "/crypto/pbkdf/nonrfc/sha1/iter2",
-        .hash = QCRYPTO_HASH_ALG_SHA1,
+        .hash = QCRYPTO_HASH_ALGO_SHA1,
         .iterations = 2,
         .key = "",
         .nkey = 0,
@@ -245,7 +245,7 @@ static QCryptoPbkdfTestData test_data[] = {
     {
         /* Password exceeds block size test */
         .path = "/crypto/pbkdf/nonrfc/sha256/iter1200",
-        .hash = QCRYPTO_HASH_ALG_SHA256,
+        .hash = QCRYPTO_HASH_ALGO_SHA256,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
@@ -260,7 +260,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/nonrfc/sha512/iter1200",
-        .hash = QCRYPTO_HASH_ALG_SHA512,
+        .hash = QCRYPTO_HASH_ALGO_SHA512,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
@@ -277,7 +277,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/nonrfc/sha224/iter1200",
-        .hash = QCRYPTO_HASH_ALG_SHA224,
+        .hash = QCRYPTO_HASH_ALGO_SHA224,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
@@ -294,7 +294,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/nonrfc/sha384/iter1200",
-        .hash = QCRYPTO_HASH_ALG_SHA384,
+        .hash = QCRYPTO_HASH_ALGO_SHA384,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
@@ -311,7 +311,7 @@ static QCryptoPbkdfTestData test_data[] = {
     },
     {
         .path = "/crypto/pbkdf/nonrfc/ripemd160/iter1200",
-        .hash = QCRYPTO_HASH_ALG_RIPEMD160,
+        .hash = QCRYPTO_HASH_ALGO_RIPEMD160,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
@@ -329,7 +329,7 @@ static QCryptoPbkdfTestData test_data[] = {
 #if 0
     {
         .path = "/crypto/pbkdf/nonrfc/whirlpool/iter1200",
-        .hash = QCRYPTO_HASH_ALG_WHIRLPOOL,
+        .hash = QCRYPTO_HASH_ALGO_WHIRLPOOL,
         .iterations = 1200,
         .key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
@@ -403,7 +403,7 @@ static void test_pbkdf_timing(void)
     memset(key, 0x5d, sizeof(key));
     memset(salt, 0x7c, sizeof(salt));
 
-    iters = qcrypto_pbkdf2_count_iters(QCRYPTO_HASH_ALG_SHA256,
+    iters = qcrypto_pbkdf2_count_iters(QCRYPTO_HASH_ALGO_SHA256,
                                        key, sizeof(key),
                                        salt, sizeof(salt),
                                        32,
diff --git a/ui/vnc.c b/ui/vnc.c
index dae5d51210..9a17994969 100644
--- a/ui/vnc.c
+++ b/ui/vnc.c
@@ -3852,7 +3852,7 @@ static int vnc_display_get_addresses(QemuOpts *opts,
         return 0;
     }
     if (qemu_opt_get(opts, "websocket") &&
-        !qcrypto_hash_supports(QCRYPTO_HASH_ALG_SHA1)) {
+        !qcrypto_hash_supports(QCRYPTO_HASH_ALGO_SHA1)) {
         error_setg(errp,
                    "SHA1 hash support is required for websockets");
         return -1;
diff --git a/util/hbitmap.c b/util/hbitmap.c
index 6d6e1b595d..d9a1dabc63 100644
--- a/util/hbitmap.c
+++ b/util/hbitmap.c
@@ -949,7 +949,7 @@ char *hbitmap_sha256(const HBitmap *bitmap, Error **errp)
     size_t size = bitmap->sizes[HBITMAP_LEVELS - 1] * sizeof(unsigned long);
     char *data = (char *)bitmap->levels[HBITMAP_LEVELS - 1];
     char *hash = NULL;
-    qcrypto_hash_digest(QCRYPTO_HASH_ALG_SHA256, data, size, &hash, errp);
+    qcrypto_hash_digest(QCRYPTO_HASH_ALGO_SHA256, data, size, &hash, errp);
 
     return hash;
 }
diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
index e942d43421..2c81de97de 100644
--- a/crypto/akcipher-gcrypt.c.inc
+++ b/crypto/akcipher-gcrypt.c.inc
@@ -33,7 +33,7 @@ typedef struct QCryptoGcryptRSA {
     QCryptoAkCipher akcipher;
     gcry_sexp_t key;
     QCryptoRSAPaddingAlgorithm padding_alg;
-    QCryptoHashAlgorithm hash_alg;
+    QCryptoHashAlgo hash_alg;
 } QCryptoGcryptRSA;
 
 static void qcrypto_gcrypt_rsa_free(QCryptoAkCipher *akcipher)
@@ -417,7 +417,7 @@ static int qcrypto_gcrypt_rsa_sign(QCryptoAkCipher *akcipher,
 
     err = gcry_sexp_build(&dgst_sexp, NULL,
                           "(data (flags pkcs1) (hash %s %b))",
-                          QCryptoHashAlgorithm_str(rsa->hash_alg),
+                          QCryptoHashAlgo_str(rsa->hash_alg),
                           in_len, in);
     if (gcry_err_code(err) != 0) {
         error_setg(errp, "Failed to build dgst: %s/%s",
@@ -497,7 +497,7 @@ static int qcrypto_gcrypt_rsa_verify(QCryptoAkCipher *akcipher,
 
     err = gcry_sexp_build(&dgst_sexp, NULL,
                           "(data (flags pkcs1) (hash %s %b))",
-                          QCryptoHashAlgorithm_str(rsa->hash_alg),
+                          QCryptoHashAlgo_str(rsa->hash_alg),
                           in2_len, in2);
     if (gcry_err_code(err) != 0) {
         error_setg(errp, "Failed to build dgst: %s/%s",
@@ -575,10 +575,10 @@ bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
 
         case QCRYPTO_RSA_PADDING_ALG_PKCS1:
             switch (opts->u.rsa.hash_alg) {
-            case QCRYPTO_HASH_ALG_MD5:
-            case QCRYPTO_HASH_ALG_SHA1:
-            case QCRYPTO_HASH_ALG_SHA256:
-            case QCRYPTO_HASH_ALG_SHA512:
+            case QCRYPTO_HASH_ALGO_MD5:
+            case QCRYPTO_HASH_ALGO_SHA1:
+            case QCRYPTO_HASH_ALGO_SHA256:
+            case QCRYPTO_HASH_ALGO_SHA512:
                 return true;
 
             default:
diff --git a/crypto/akcipher-nettle.c.inc b/crypto/akcipher-nettle.c.inc
index 62ac8699c4..37a579fbd9 100644
--- a/crypto/akcipher-nettle.c.inc
+++ b/crypto/akcipher-nettle.c.inc
@@ -34,7 +34,7 @@ typedef struct QCryptoNettleRSA {
     struct rsa_public_key pub;
     struct rsa_private_key priv;
     QCryptoRSAPaddingAlgorithm padding_alg;
-    QCryptoHashAlgorithm hash_alg;
+    QCryptoHashAlgo hash_alg;
 } QCryptoNettleRSA;
 
 static void qcrypto_nettle_rsa_free(QCryptoAkCipher *akcipher)
@@ -276,19 +276,19 @@ static int qcrypto_nettle_rsa_sign(QCryptoAkCipher *akcipher,
 
     mpz_init(s);
     switch (rsa->hash_alg) {
-    case QCRYPTO_HASH_ALG_MD5:
+    case QCRYPTO_HASH_ALGO_MD5:
         rv = rsa_md5_sign_digest(&rsa->priv, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA1:
         rv = rsa_sha1_sign_digest(&rsa->priv, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA256:
         rv = rsa_sha256_sign_digest(&rsa->priv, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA512:
+    case QCRYPTO_HASH_ALGO_SHA512:
         rv = rsa_sha512_sign_digest(&rsa->priv, data, s);
         break;
 
@@ -341,19 +341,19 @@ static int qcrypto_nettle_rsa_verify(QCryptoAkCipher *akcipher,
 
     nettle_mpz_init_set_str_256_u(s, sig_len, sig);
     switch (rsa->hash_alg) {
-    case QCRYPTO_HASH_ALG_MD5:
+    case QCRYPTO_HASH_ALGO_MD5:
         rv = rsa_md5_verify_digest(&rsa->pub, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA1:
+    case QCRYPTO_HASH_ALGO_SHA1:
         rv = rsa_sha1_verify_digest(&rsa->pub, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA256:
+    case QCRYPTO_HASH_ALGO_SHA256:
         rv = rsa_sha256_verify_digest(&rsa->pub, data, s);
         break;
 
-    case QCRYPTO_HASH_ALG_SHA512:
+    case QCRYPTO_HASH_ALGO_SHA512:
         rv = rsa_sha512_verify_digest(&rsa->pub, data, s);
         break;
 
@@ -429,10 +429,10 @@ bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
         switch (opts->u.rsa.padding_alg) {
         case QCRYPTO_RSA_PADDING_ALG_PKCS1:
             switch (opts->u.rsa.hash_alg) {
-            case QCRYPTO_HASH_ALG_MD5:
-            case QCRYPTO_HASH_ALG_SHA1:
-            case QCRYPTO_HASH_ALG_SHA256:
-            case QCRYPTO_HASH_ALG_SHA512:
+            case QCRYPTO_HASH_ALGO_MD5:
+            case QCRYPTO_HASH_ALGO_SHA1:
+            case QCRYPTO_HASH_ALGO_SHA256:
+            case QCRYPTO_HASH_ALGO_SHA512:
                 return true;
 
             default:
-- 
2.46.0


