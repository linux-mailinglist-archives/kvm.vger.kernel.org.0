Return-Path: <kvm+bounces-22624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40217940AF0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61C311C21631
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24C194150;
	Tue, 30 Jul 2024 08:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cT1Avi2D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E961940B2
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327057; cv=none; b=UGqZYrqznVGT/VQ28qw5y454CqezSjOuplsy24b32LjuXfGwPeRqRq3K3jEHhRzUFCdz2U0H9uSkA6KiNdwQPVXZIUf5a7amEL5ux5jGN+xevy5Il5Whe9fPG8if/6oUxEDuozOJfPj7DhfaKJOZsyVPsayeK9zfWss2KXJFjg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327057; c=relaxed/simple;
	bh=zWsAOWL8CpGltT61IRthWWusvmRnOHrBTOUIE3eX4vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mjZaRodZ2ynXUqrNDWGMBotugfjG7TT2UFuO04FJFvOW0lyRp6U8BFuXndzwFv8L4EQqZwVJVuONFCTQwUCJEzY9k+Kfo3uXb7nMW19KIX80rXTjhZHtLKnLcqdHcgxblsQRV8JKNEFOzBkDu64KFsp1d5TGUDOSdirRrodoMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cT1Avi2D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMPCHNQfy3tZ+ovqltmhnjAU4FtimTeV+sqHt5QzZ78=;
	b=cT1Avi2DasV/JYSCTqbh5Qxe1pnaGge0FohfTm3RZNhj3rkf11lkHZwHjYs9rwWGWXtzv6
	CMVRvwS0NjwhJAda6l3XZl0OuQpiaBZGeMT6gmY0uoHfCeGwB0oCJGoNDotBe+kGT9g59n
	6+jwTSkf21O5CIkXgdHuuJSDUNhFbGc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-IO6leV3RPVaLPwJzSj45SQ-1; Tue,
 30 Jul 2024 04:10:50 -0400
X-MC-Unique: IO6leV3RPVaLPwJzSj45SQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F36E1955D56;
	Tue, 30 Jul 2024 08:10:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3D571955D42;
	Tue, 30 Jul 2024 08:10:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0EAAD21F4B9B; Tue, 30 Jul 2024 10:10:33 +0200 (CEST)
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
Subject: [PATCH 14/18] qapi/crypto: Rename QCryptoAkCipherAlgorithm to *Algo, and drop prefix
Date: Tue, 30 Jul 2024 10:10:28 +0200
Message-ID: <20240730081032.1246748-15-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

QCryptoAkCipherAlgorithm has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTO_AKCIPHER_ALG.

We could simply drop 'prefix', but then the prefix becomes
QCRYPTO_AK_CIPHER_ALGORITHM, which is rather long.

We could additionally rename the type to QCryptoAkCipherAlg, but I
think the abbreviation "alg" is less than clear.

Rename the type to QCryptoAkCipherAlgo instead.  The prefix becomes
QCRYPTO_AK_CIPHER_ALGO.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/crypto.json                        |  7 +++----
 crypto/akcipherpriv.h                   |  2 +-
 backends/cryptodev-builtin.c            |  4 ++--
 backends/cryptodev-lkcf.c               |  4 ++--
 crypto/akcipher.c                       |  2 +-
 tests/bench/benchmark-crypto-akcipher.c |  2 +-
 tests/unit/test-crypto-akcipher.c       | 10 +++++-----
 crypto/akcipher-gcrypt.c.inc            |  4 ++--
 crypto/akcipher-nettle.c.inc            |  4 ++--
 9 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 996853cecf..5ea16c69e0 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -586,7 +586,7 @@
             '*sanity-check': 'bool',
             '*passwordid': 'str' } }
 ##
-# @QCryptoAkCipherAlgorithm:
+# @QCryptoAkCipherAlgo:
 #
 # The supported algorithms for asymmetric encryption ciphers
 #
@@ -594,8 +594,7 @@
 #
 # Since: 7.1
 ##
-{ 'enum': 'QCryptoAkCipherAlgorithm',
-  'prefix': 'QCRYPTO_AKCIPHER_ALG',
+{ 'enum': 'QCryptoAkCipherAlgo',
   'data': ['rsa']}
 
 ##
@@ -649,6 +648,6 @@
 # Since: 7.1
 ##
 { 'union': 'QCryptoAkCipherOptions',
-  'base': { 'alg': 'QCryptoAkCipherAlgorithm' },
+  'base': { 'alg': 'QCryptoAkCipherAlgo' },
   'discriminator': 'alg',
   'data': { 'rsa': 'QCryptoAkCipherOptionsRSA' }}
diff --git a/crypto/akcipherpriv.h b/crypto/akcipherpriv.h
index 739f639bcf..3b33e54f08 100644
--- a/crypto/akcipherpriv.h
+++ b/crypto/akcipherpriv.h
@@ -27,7 +27,7 @@
 typedef struct QCryptoAkCipherDriver QCryptoAkCipherDriver;
 
 struct QCryptoAkCipher {
-    QCryptoAkCipherAlgorithm alg;
+    QCryptoAkCipherAlgo alg;
     QCryptoAkCipherKeyType type;
     int max_plaintext_len;
     int max_ciphertext_len;
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 2672755661..d8b64091b6 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -64,7 +64,7 @@ static void cryptodev_builtin_init_akcipher(CryptoDevBackend *backend)
 {
     QCryptoAkCipherOptions opts;
 
-    opts.alg = QCRYPTO_AKCIPHER_ALG_RSA;
+    opts.alg = QCRYPTO_AK_CIPHER_ALGO_RSA;
     opts.u.rsa.padding_alg = QCRYPTO_RSA_PADDING_ALG_RAW;
     if (qcrypto_akcipher_supports(&opts)) {
         backend->conf.crypto_services |=
@@ -318,7 +318,7 @@ static int cryptodev_builtin_create_akcipher_session(
 
     switch (sess_info->algo) {
     case VIRTIO_CRYPTO_AKCIPHER_RSA:
-        opts.alg = QCRYPTO_AKCIPHER_ALG_RSA;
+        opts.alg = QCRYPTO_AK_CIPHER_ALGO_RSA;
         if (cryptodev_builtin_set_rsa_options(sess_info->u.rsa.padding_algo,
             sess_info->u.rsa.hash_algo, &opts.u.rsa, errp) != 0) {
             return -1;
diff --git a/backends/cryptodev-lkcf.c b/backends/cryptodev-lkcf.c
index 6e6012e716..6fb6e03d98 100644
--- a/backends/cryptodev-lkcf.c
+++ b/backends/cryptodev-lkcf.c
@@ -133,7 +133,7 @@ static int cryptodev_lkcf_set_op_desc(QCryptoAkCipherOptions *opts,
                                       Error **errp)
 {
     QCryptoAkCipherOptionsRSA *rsa_opt;
-    if (opts->alg != QCRYPTO_AKCIPHER_ALG_RSA) {
+    if (opts->alg != QCRYPTO_AK_CIPHER_ALGO_RSA) {
         error_setg(errp, "Unsupported alg: %u", opts->alg);
         return -1;
     }
@@ -518,7 +518,7 @@ static int cryptodev_lkcf_create_asym_session(
 
     switch (sess_info->algo) {
     case VIRTIO_CRYPTO_AKCIPHER_RSA:
-        sess->akcipher_opts.alg = QCRYPTO_AKCIPHER_ALG_RSA;
+        sess->akcipher_opts.alg = QCRYPTO_AK_CIPHER_ALGO_RSA;
         if (cryptodev_lkcf_set_rsa_opt(
             sess_info->u.rsa.padding_algo, sess_info->u.rsa.hash_algo,
             &sess->akcipher_opts.u.rsa, &local_error) != 0) {
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index e4bbc6e5f1..0a0576b792 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -115,7 +115,7 @@ int qcrypto_akcipher_export_p8info(const QCryptoAkCipherOptions *opts,
                                    Error **errp)
 {
     switch (opts->alg) {
-    case QCRYPTO_AKCIPHER_ALG_RSA:
+    case QCRYPTO_AK_CIPHER_ALGO_RSA:
         qcrypto_akcipher_rsakey_export_p8info(key, keylen, dst, dst_len);
         return 0;
 
diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
index 0029972385..225e426bde 100644
--- a/tests/bench/benchmark-crypto-akcipher.c
+++ b/tests/bench/benchmark-crypto-akcipher.c
@@ -25,7 +25,7 @@ static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
 {
     QCryptoAkCipherOptions opt;
 
-    opt.alg = QCRYPTO_AKCIPHER_ALG_RSA;
+    opt.alg = QCRYPTO_AK_CIPHER_ALGO_RSA;
     opt.u.rsa.padding_alg = padding;
     opt.u.rsa.hash_alg = hash;
     return qcrypto_akcipher_new(&opt, QCRYPTO_AK_CIPHER_KEY_TYPE_PRIVATE,
diff --git a/tests/unit/test-crypto-akcipher.c b/tests/unit/test-crypto-akcipher.c
index 86501f19ab..7dd86125c2 100644
--- a/tests/unit/test-crypto-akcipher.c
+++ b/tests/unit/test-crypto-akcipher.c
@@ -785,7 +785,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
     {
         .path = "/crypto/akcipher/rsa1024-raw",
         .opt = {
-            .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+            .alg = QCRYPTO_AK_CIPHER_ALGO_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_RAW,
             },
@@ -805,7 +805,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
     {
         .path = "/crypto/akcipher/rsa1024-pkcs1",
         .opt = {
-            .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+            .alg = QCRYPTO_AK_CIPHER_ALGO_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
                 .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
@@ -830,7 +830,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
     {
         .path = "/crypto/akcipher/rsa2048-raw",
         .opt = {
-            .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+            .alg = QCRYPTO_AK_CIPHER_ALGO_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_RAW,
             },
@@ -850,7 +850,7 @@ static QCryptoAkCipherTestData akcipher_test_data[] = {
     {
         .path = "/crypto/akcipher/rsa2048-pkcs1",
         .opt = {
-            .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+            .alg = QCRYPTO_AK_CIPHER_ALGO_RSA,
             .u.rsa = {
                 .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
                 .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
@@ -944,7 +944,7 @@ static void test_rsakey(const void *opaque)
 {
     const QCryptoRSAKeyTestData *data = (const QCryptoRSAKeyTestData *)opaque;
     QCryptoAkCipherOptions opt = {
-        .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+        .alg = QCRYPTO_AK_CIPHER_ALGO_RSA,
         .u.rsa = {
             .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
             .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
index 2c81de97de..8f1c2b8143 100644
--- a/crypto/akcipher-gcrypt.c.inc
+++ b/crypto/akcipher-gcrypt.c.inc
@@ -59,7 +59,7 @@ QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
                                       Error **errp)
 {
     switch (opts->alg) {
-    case QCRYPTO_AKCIPHER_ALG_RSA:
+    case QCRYPTO_AK_CIPHER_ALGO_RSA:
         return (QCryptoAkCipher *)qcrypto_gcrypt_rsa_new(
             &opts->u.rsa, type, key, keylen, errp);
 
@@ -568,7 +568,7 @@ error:
 bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
 {
     switch (opts->alg) {
-    case QCRYPTO_AKCIPHER_ALG_RSA:
+    case QCRYPTO_AK_CIPHER_ALGO_RSA:
         switch (opts->u.rsa.padding_alg) {
         case QCRYPTO_RSA_PADDING_ALG_RAW:
             return true;
diff --git a/crypto/akcipher-nettle.c.inc b/crypto/akcipher-nettle.c.inc
index 37a579fbd9..21f27f8286 100644
--- a/crypto/akcipher-nettle.c.inc
+++ b/crypto/akcipher-nettle.c.inc
@@ -61,7 +61,7 @@ QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
                                       Error **errp)
 {
     switch (opts->alg) {
-    case QCRYPTO_AKCIPHER_ALG_RSA:
+    case QCRYPTO_AK_CIPHER_ALGO_RSA:
         return qcrypto_nettle_rsa_new(&opts->u.rsa, type, key, keylen, errp);
 
     default:
@@ -425,7 +425,7 @@ error:
 bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
 {
     switch (opts->alg) {
-    case QCRYPTO_AKCIPHER_ALG_RSA:
+    case QCRYPTO_AK_CIPHER_ALGO_RSA:
         switch (opts->u.rsa.padding_alg) {
         case QCRYPTO_RSA_PADDING_ALG_PKCS1:
             switch (opts->u.rsa.hash_alg) {
-- 
2.45.0


