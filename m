Return-Path: <kvm+bounces-25864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 886AC96BA51
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DD71C21EC6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99851DA623;
	Wed,  4 Sep 2024 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GpCZqiz7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050661D58B9
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448740; cv=none; b=pOVptAVO/X6aVSI7PjdCEIjyoMcFM8So010S70jx6fkdQ+cBCuJpLrP0WTP8U1JJ+ospH1tm1C/PujSzxQucg+aABg+j8kf6d9MBAGVskyAZnSg4jdc7QrZhBHdr7igNHhP5E2A3Xrn7w4Lt3tPg/OlhgPSCfFgVJuTJ3vu4BTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448740; c=relaxed/simple;
	bh=jITSRX9rtQIt/ZZGxh64OcKt6uga5kZkolKxDNCPAS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WtssgA361R4wqzDqjCdlSEajEeFAJK6snC9Cn7eswnG3cA9l+yQDeiicfQpJP45of+Np4FGwdYsURJ/u8u2Uj5LLAdcv/HC33/FgHbnjw/Xzen9LRg79S489mX7Tve4Dgs2wgygSduRSfZ7pmTEaz9VKxJICfTN+FB4iaj3G+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GpCZqiz7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvQ0bkuh975N3/39hMCT7dsPlX5V08GBG2VFlBYmSHw=;
	b=GpCZqiz7Ae3QPE6x+RyaEQbgPYkLgsaVgsy+26UEeE+VvOv2Or0pWNB4fVNSsDlOdy8a/S
	0kTjrnmqSjhDJAMookbIvW6k60pGHneRv7OaTPWsh6PFROGrl+XpJouIuNNqapuQ5uplsC
	FyfSpQme6U9USRvucBaCrSPrTXK3llc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-kfPfu0HXPWi1c5ZIfT_ZuQ-1; Wed,
 04 Sep 2024 07:18:51 -0400
X-MC-Unique: kfPfu0HXPWi1c5ZIfT_ZuQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F2C31953963;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6E9919560AB;
	Wed,  4 Sep 2024 11:18:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C8E4721E682B; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 13/19] qapi/crypto: Rename QCryptoIVGenAlgorithm to *Algo, and drop prefix
Date: Wed,  4 Sep 2024 13:18:30 +0200
Message-ID: <20240904111836.3273842-14-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

QCryptoIVGenAlgorithm has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTO_IVGEN_ALG.

We could simply drop 'prefix', but then the prefix becomes
QCRYPTO_IV_GEN_ALGORITHM, which is rather long.

We could additionally rename the type to QCryptoIVGenAlg, but I think
the abbreviation "alg" is less than clear.

Rename the type to QCryptoIVGenAlgo instead.  The prefix becomes
QCRYPTO_IV_GEN_ALGO.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Acked-by: Daniel P. Berrangé <berrange@redhat.com>
---
 qapi/crypto.json               |  9 ++++-----
 crypto/ivgenpriv.h             |  2 +-
 include/crypto/ivgen.h         | 14 +++++++-------
 crypto/block-luks.c            | 16 ++++++++--------
 crypto/block-qcow.c            |  2 +-
 crypto/ivgen.c                 | 10 +++++-----
 tests/unit/test-crypto-block.c | 14 +++++++-------
 tests/unit/test-crypto-ivgen.c | 22 +++++++++++-----------
 8 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 0591d62f67..3e6a7fb8e5 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -122,7 +122,7 @@
   'data': ['ecb', 'cbc', 'xts', 'ctr']}
 
 ##
-# @QCryptoIVGenAlgorithm:
+# @QCryptoIVGenAlgo:
 #
 # The supported algorithms for generating initialization vectors for
 # full disk encryption.  The 'plain' generator should not be used for
@@ -138,8 +138,7 @@
 #
 # Since: 2.6
 ##
-{ 'enum': 'QCryptoIVGenAlgorithm',
-  'prefix': 'QCRYPTO_IVGEN_ALG',
+{ 'enum': 'QCryptoIVGenAlgo',
   'data': ['plain', 'plain64', 'essiv']}
 
 ##
@@ -226,7 +225,7 @@
   'base': 'QCryptoBlockOptionsLUKS',
   'data': { '*cipher-alg': 'QCryptoCipherAlgo',
             '*cipher-mode': 'QCryptoCipherMode',
-            '*ivgen-alg': 'QCryptoIVGenAlgorithm',
+            '*ivgen-alg': 'QCryptoIVGenAlgo',
             '*ivgen-hash-alg': 'QCryptoHashAlgo',
             '*hash-alg': 'QCryptoHashAlgo',
             '*iter-time': 'int' }}
@@ -323,7 +322,7 @@
 { 'struct': 'QCryptoBlockInfoLUKS',
   'data': {'cipher-alg': 'QCryptoCipherAlgo',
            'cipher-mode': 'QCryptoCipherMode',
-           'ivgen-alg': 'QCryptoIVGenAlgorithm',
+           'ivgen-alg': 'QCryptoIVGenAlgo',
            '*ivgen-hash-alg': 'QCryptoHashAlgo',
            'hash-alg': 'QCryptoHashAlgo',
            'detached-header': 'bool',
diff --git a/crypto/ivgenpriv.h b/crypto/ivgenpriv.h
index ef24c76345..e3388d30be 100644
--- a/crypto/ivgenpriv.h
+++ b/crypto/ivgenpriv.h
@@ -40,7 +40,7 @@ struct QCryptoIVGen {
     QCryptoIVGenDriver *driver;
     void *private;
 
-    QCryptoIVGenAlgorithm algorithm;
+    QCryptoIVGenAlgo algorithm;
     QCryptoCipherAlgo cipher;
     QCryptoHashAlgo hash;
 };
diff --git a/include/crypto/ivgen.h b/include/crypto/ivgen.h
index b059e332cd..bfa5d28103 100644
--- a/include/crypto/ivgen.h
+++ b/include/crypto/ivgen.h
@@ -44,7 +44,7 @@
  *
  * g_assert((ndata % 512) == 0);
  *
- * QCryptoIVGen *ivgen = qcrypto_ivgen_new(QCRYPTO_IVGEN_ALG_ESSIV,
+ * QCryptoIVGen *ivgen = qcrypto_ivgen_new(QCRYPTO_IV_GEN_ALGO_ESSIV,
  *                                         QCRYPTO_CIPHER_ALGO_AES_128,
  *                                         QCRYPTO_HASH_ALGO_SHA256,
  *                                         key, nkey, errp);
@@ -97,7 +97,7 @@
 
 typedef struct QCryptoIVGen QCryptoIVGen;
 
-/* See also QCryptoIVGenAlgorithm enum in qapi/crypto.json */
+/* See also QCryptoIVGenAlgo enum in qapi/crypto.json */
 
 
 /**
@@ -113,19 +113,19 @@ typedef struct QCryptoIVGen QCryptoIVGen;
  * are required or not depends on the choice of @alg
  * requested.
  *
- * - QCRYPTO_IVGEN_ALG_PLAIN
+ * - QCRYPTO_IV_GEN_ALGO_PLAIN
  *
  * The IVs are generated by the 32-bit truncated sector
  * number. This should never be used for block devices
  * that are larger than 2^32 sectors in size.
  * All the other parameters are unused.
  *
- * - QCRYPTO_IVGEN_ALG_PLAIN64
+ * - QCRYPTO_IV_GEN_ALGO_PLAIN64
  *
  * The IVs are generated by the 64-bit sector number.
  * All the other parameters are unused.
  *
- * - QCRYPTO_IVGEN_ALG_ESSIV:
+ * - QCRYPTO_IV_GEN_ALGO_ESSIV:
  *
  * The IVs are generated by encrypting the 64-bit sector
  * number with a hash of an encryption key. The @cipheralg,
@@ -133,7 +133,7 @@ typedef struct QCryptoIVGen QCryptoIVGen;
  *
  * Returns: a new IV generator, or NULL on error
  */
-QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
+QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgo alg,
                                 QCryptoCipherAlgo cipheralg,
                                 QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
@@ -167,7 +167,7 @@ int qcrypto_ivgen_calculate(QCryptoIVGen *ivgen,
  *
  * Returns: the IV generator algorithm
  */
-QCryptoIVGenAlgorithm qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen);
+QCryptoIVGenAlgo qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen);
 
 
 /**
diff --git a/crypto/block-luks.c b/crypto/block-luks.c
index 8eadf124fc..0926ad28f0 100644
--- a/crypto/block-luks.c
+++ b/crypto/block-luks.c
@@ -129,7 +129,7 @@ struct QCryptoBlockLUKS {
     QCryptoCipherMode cipher_mode;
 
     /* Initialization vector generation algorithm */
-    QCryptoIVGenAlgorithm ivgen_alg;
+    QCryptoIVGenAlgo ivgen_alg;
 
     /* Hash algorithm used for IV generation*/
     QCryptoHashAlgo ivgen_hash_alg;
@@ -229,7 +229,7 @@ static int qcrypto_block_luks_name_lookup(const char *name,
 
 #define qcrypto_block_luks_ivgen_name_lookup(name, errp)                \
     qcrypto_block_luks_name_lookup(name,                                \
-                                   &QCryptoIVGenAlgorithm_lookup,       \
+                                   &QCryptoIVGenAlgo_lookup,       \
                                    "IV generator",                      \
                                    errp)
 
@@ -660,7 +660,7 @@ qcrypto_block_luks_parse_header(QCryptoBlockLUKS *luks, Error **errp)
         return -1;
     }
 
-    if (luks->ivgen_alg == QCRYPTO_IVGEN_ALG_ESSIV) {
+    if (luks->ivgen_alg == QCRYPTO_IV_GEN_ALGO_ESSIV) {
         if (!ivhash_name) {
             error_setg(errp, "Missing IV generator hash specification");
             return -1;
@@ -1328,12 +1328,12 @@ qcrypto_block_luks_create(QCryptoBlock *block,
         luks_opts.cipher_mode = QCRYPTO_CIPHER_MODE_XTS;
     }
     if (!luks_opts.has_ivgen_alg) {
-        luks_opts.ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64;
+        luks_opts.ivgen_alg = QCRYPTO_IV_GEN_ALGO_PLAIN64;
     }
     if (!luks_opts.has_hash_alg) {
         luks_opts.hash_alg = QCRYPTO_HASH_ALGO_SHA256;
     }
-    if (luks_opts.ivgen_alg == QCRYPTO_IVGEN_ALG_ESSIV) {
+    if (luks_opts.ivgen_alg == QCRYPTO_IV_GEN_ALGO_ESSIV) {
         if (!luks_opts.has_ivgen_hash_alg) {
             luks_opts.ivgen_hash_alg = QCRYPTO_HASH_ALGO_SHA256;
             luks_opts.has_ivgen_hash_alg = true;
@@ -1384,7 +1384,7 @@ qcrypto_block_luks_create(QCryptoBlock *block,
     }
 
     cipher_mode = QCryptoCipherMode_str(luks_opts.cipher_mode);
-    ivgen_alg = QCryptoIVGenAlgorithm_str(luks_opts.ivgen_alg);
+    ivgen_alg = QCryptoIVGenAlgo_str(luks_opts.ivgen_alg);
     if (luks_opts.has_ivgen_hash_alg) {
         ivgen_hash_alg = QCryptoHashAlgo_str(luks_opts.ivgen_hash_alg);
         cipher_mode_spec = g_strdup_printf("%s-%s:%s", cipher_mode, ivgen_alg,
@@ -1411,7 +1411,7 @@ qcrypto_block_luks_create(QCryptoBlock *block,
         goto error;
     }
 
-    if (luks_opts.ivgen_alg == QCRYPTO_IVGEN_ALG_ESSIV) {
+    if (luks_opts.ivgen_alg == QCRYPTO_IV_GEN_ALGO_ESSIV) {
         luks->ivgen_cipher_alg =
                 qcrypto_block_luks_essiv_cipher(luks_opts.cipher_alg,
                                                 luks_opts.ivgen_hash_alg,
@@ -1886,7 +1886,7 @@ static int qcrypto_block_luks_get_info(QCryptoBlock *block,
     info->u.luks.cipher_alg = luks->cipher_alg;
     info->u.luks.cipher_mode = luks->cipher_mode;
     info->u.luks.ivgen_alg = luks->ivgen_alg;
-    if (info->u.luks.ivgen_alg == QCRYPTO_IVGEN_ALG_ESSIV) {
+    if (info->u.luks.ivgen_alg == QCRYPTO_IV_GEN_ALGO_ESSIV) {
         info->u.luks.has_ivgen_hash_alg = true;
         info->u.luks.ivgen_hash_alg = luks->ivgen_hash_alg;
     }
diff --git a/crypto/block-qcow.c b/crypto/block-qcow.c
index a0ba9c1f2e..054078b895 100644
--- a/crypto/block-qcow.c
+++ b/crypto/block-qcow.c
@@ -64,7 +64,7 @@ qcrypto_block_qcow_init(QCryptoBlock *block,
 
     block->niv = qcrypto_cipher_get_iv_len(QCRYPTO_CIPHER_ALGO_AES_128,
                                            QCRYPTO_CIPHER_MODE_CBC);
-    block->ivgen = qcrypto_ivgen_new(QCRYPTO_IVGEN_ALG_PLAIN64,
+    block->ivgen = qcrypto_ivgen_new(QCRYPTO_IV_GEN_ALGO_PLAIN64,
                                      0, 0, NULL, 0, errp);
     if (!block->ivgen) {
         ret = -ENOTSUP;
diff --git a/crypto/ivgen.c b/crypto/ivgen.c
index ec0cb1a25b..6b7d24d889 100644
--- a/crypto/ivgen.c
+++ b/crypto/ivgen.c
@@ -27,7 +27,7 @@
 #include "ivgen-essiv.h"
 
 
-QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
+QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgo alg,
                                 QCryptoCipherAlgo cipheralg,
                                 QCryptoHashAlgo hash,
                                 const uint8_t *key, size_t nkey,
@@ -40,13 +40,13 @@ QCryptoIVGen *qcrypto_ivgen_new(QCryptoIVGenAlgorithm alg,
     ivgen->hash = hash;
 
     switch (alg) {
-    case QCRYPTO_IVGEN_ALG_PLAIN:
+    case QCRYPTO_IV_GEN_ALGO_PLAIN:
         ivgen->driver = &qcrypto_ivgen_plain;
         break;
-    case QCRYPTO_IVGEN_ALG_PLAIN64:
+    case QCRYPTO_IV_GEN_ALGO_PLAIN64:
         ivgen->driver = &qcrypto_ivgen_plain64;
         break;
-    case QCRYPTO_IVGEN_ALG_ESSIV:
+    case QCRYPTO_IV_GEN_ALGO_ESSIV:
         ivgen->driver = &qcrypto_ivgen_essiv;
         break;
     default:
@@ -73,7 +73,7 @@ int qcrypto_ivgen_calculate(QCryptoIVGen *ivgen,
 }
 
 
-QCryptoIVGenAlgorithm qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen)
+QCryptoIVGenAlgo qcrypto_ivgen_get_algorithm(QCryptoIVGen *ivgen)
 {
     return ivgen->algorithm;
 }
diff --git a/tests/unit/test-crypto-block.c b/tests/unit/test-crypto-block.c
index 1a0d329368..9217b9a2ef 100644
--- a/tests/unit/test-crypto-block.c
+++ b/tests/unit/test-crypto-block.c
@@ -81,7 +81,7 @@ static QCryptoBlockCreateOptions luks_create_opts_aes256_cbc_plain64 = {
         .has_cipher_mode = true,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .has_ivgen_alg = true,
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
     },
 };
 
@@ -95,7 +95,7 @@ static QCryptoBlockCreateOptions luks_create_opts_aes256_cbc_essiv = {
         .has_cipher_mode = true,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .has_ivgen_alg = true,
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_ESSIV,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_ESSIV,
         .has_ivgen_hash_alg = true,
         .ivgen_hash_alg = QCRYPTO_HASH_ALGO_SHA256,
         .has_hash_alg = true,
@@ -116,7 +116,7 @@ static struct QCryptoBlockTestData {
     QCryptoCipherMode cipher_mode;
     QCryptoHashAlgo hash_alg;
 
-    QCryptoIVGenAlgorithm ivgen_alg;
+    QCryptoIVGenAlgo ivgen_alg;
     QCryptoHashAlgo ivgen_hash;
 
     bool slow;
@@ -131,7 +131,7 @@ static struct QCryptoBlockTestData {
         .cipher_alg = QCRYPTO_CIPHER_ALGO_AES_128,
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
 
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
     },
 #ifdef TEST_LUKS
     {
@@ -145,7 +145,7 @@ static struct QCryptoBlockTestData {
         .cipher_mode = QCRYPTO_CIPHER_MODE_XTS,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
 
         .slow = true,
     },
@@ -160,7 +160,7 @@ static struct QCryptoBlockTestData {
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA256,
 
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
 
         .slow = true,
     },
@@ -175,7 +175,7 @@ static struct QCryptoBlockTestData {
         .cipher_mode = QCRYPTO_CIPHER_MODE_CBC,
         .hash_alg = QCRYPTO_HASH_ALGO_SHA1,
 
-        .ivgen_alg = QCRYPTO_IVGEN_ALG_ESSIV,
+        .ivgen_alg = QCRYPTO_IV_GEN_ALGO_ESSIV,
         .ivgen_hash = QCRYPTO_HASH_ALGO_SHA256,
 
         .slow = true,
diff --git a/tests/unit/test-crypto-ivgen.c b/tests/unit/test-crypto-ivgen.c
index 6b4110775a..bc9ffe34e7 100644
--- a/tests/unit/test-crypto-ivgen.c
+++ b/tests/unit/test-crypto-ivgen.c
@@ -26,7 +26,7 @@
 struct QCryptoIVGenTestData {
     const char *path;
     uint64_t sector;
-    QCryptoIVGenAlgorithm ivalg;
+    QCryptoIVGenAlgo ivalg;
     QCryptoHashAlgo hashalg;
     QCryptoCipherAlgo cipheralg;
     const uint8_t *key;
@@ -38,7 +38,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain/1",
         .sector = 0x1,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN,
         .iv = (const uint8_t *)"\x01\x00\x00\x00\x00\x00\x00\x00"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -47,7 +47,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain/1f2e3d4c",
         .sector = 0x1f2e3d4cULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN,
         .iv = (const uint8_t *)"\x4c\x3d\x2e\x1f\x00\x00\x00\x00"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -56,7 +56,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain/1f2e3d4c5b6a7988",
         .sector = 0x1f2e3d4c5b6a7988ULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN,
         .iv = (const uint8_t *)"\x88\x79\x6a\x5b\x00\x00\x00\x00"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -65,7 +65,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain64/1",
         .sector = 0x1,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
         .iv = (const uint8_t *)"\x01\x00\x00\x00\x00\x00\x00\x00"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -74,7 +74,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain64/1f2e3d4c",
         .sector = 0x1f2e3d4cULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
         .iv = (const uint8_t *)"\x4c\x3d\x2e\x1f\x00\x00\x00\x00"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -83,7 +83,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/plain64/1f2e3d4c5b6a7988",
         .sector = 0x1f2e3d4c5b6a7988ULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_PLAIN64,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_PLAIN64,
         .iv = (const uint8_t *)"\x88\x79\x6a\x5b\x4c\x3d\x2e\x1f"
                                "\x00\x00\x00\x00\x00\x00\x00\x00",
         .niv = 16,
@@ -92,7 +92,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/essiv/1",
         .sector = 0x1,
-        .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -106,7 +106,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/essiv/1f2e3d4c",
         .sector = 0x1f2e3d4cULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -120,7 +120,7 @@ struct QCryptoIVGenTestData {
     {
         "/crypto/ivgen/essiv/1f2e3d4c5b6a7988",
         .sector = 0x1f2e3d4c5b6a7988ULL,
-        .ivalg = QCRYPTO_IVGEN_ALG_ESSIV,
+        .ivalg = QCRYPTO_IV_GEN_ALGO_ESSIV,
         .cipheralg = QCRYPTO_CIPHER_ALGO_AES_128,
         .hashalg = QCRYPTO_HASH_ALGO_SHA256,
         .key = (const uint8_t *)"\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -166,7 +166,7 @@ int main(int argc, char **argv)
     size_t i;
     g_test_init(&argc, &argv, NULL);
     for (i = 0; i < G_N_ELEMENTS(test_data); i++) {
-        if (test_data[i].ivalg == QCRYPTO_IVGEN_ALG_ESSIV &&
+        if (test_data[i].ivalg == QCRYPTO_IV_GEN_ALGO_ESSIV &&
             !qcrypto_hash_supports(test_data[i].hashalg)) {
             continue;
         }
-- 
2.46.0


