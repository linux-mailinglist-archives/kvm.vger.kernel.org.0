Return-Path: <kvm+bounces-22623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A91940AEE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F54C1F220F5
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3DA192B92;
	Tue, 30 Jul 2024 08:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btLm+l7i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F79019408E
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327057; cv=none; b=AcckK0Gtkz8IaGi2AhhkowqEC6ufj2dvxnVBynBpZflNoz08SnJJxoG5efQSYaZqlQ0vcXtzWvePlBXQIzAFb9EUKQYFry5LP3xvwZR8KKk/bNlKALBLiUq9PN+/ZsRI9GHJJwAnfI1tuDrPvj+oVdzfRblY5pZ/B4j5dnuVCwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327057; c=relaxed/simple;
	bh=/3DjVxiLz9ySqvV1vTXd2pY/8AvQYvHMweV/mHexTbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=DytKJ4GaDNDIIH7ZSSGzf6dUkbf5XHlQTjjN18DeznTBiOkFbhhJwu54AWmJUFFHWPgzTpWI6vC6d8RBng69RIK55hLwDfuEhh0oHN1JyD75LQEjGVApKZcKEokI+AxGVizALOeyjqT7TtjSzvs3tx4wLxOXO8IAud1l2tUXTbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btLm+l7i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CRXQh6ZY5UlqE0j16xgo50rsn3odB+RrAVuoTShGYJ0=;
	b=btLm+l7iE/aY2kScLt1SmtjW4s/6tTg4t3xYAp+sdSk9OKNdP10RmjpMOtUidy3rjj8VGh
	Wol/NkWGlKn4iFZR9pDODw2xn69qPKokC7kVuGzmvsP18nQmk06XPAulEy7peZ18LOdWro
	IojkGzVhKW44wT7z8NDrf3iF14Dc01g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-dlZMvMOdMWqSaAyBipMpvg-1; Tue,
 30 Jul 2024 04:10:52 -0400
X-MC-Unique: dlZMvMOdMWqSaAyBipMpvg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 808E21955BFE;
	Tue, 30 Jul 2024 08:10:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E25D61955F40;
	Tue, 30 Jul 2024 08:10:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1735F21F4B9F; Tue, 30 Jul 2024 10:10:33 +0200 (CEST)
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
Subject: [PATCH 16/18] qapi/crypto: Rename QCryptoAFAlg to QCryptoAFAlgo
Date: Tue, 30 Jul 2024 10:10:30 +0200
Message-ID: <20240730081032.1246748-17-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

For consistency with other types names *Algo.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 crypto/afalgpriv.h    | 14 +++++++-------
 crypto/hmacpriv.h     |  2 +-
 crypto/afalg.c        |  8 ++++----
 crypto/cipher-afalg.c | 12 ++++++------
 crypto/hash-afalg.c   | 14 +++++++-------
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/crypto/afalgpriv.h b/crypto/afalgpriv.h
index 5a2393f1b7..3fdcc0f831 100644
--- a/crypto/afalgpriv.h
+++ b/crypto/afalgpriv.h
@@ -30,9 +30,9 @@
 #define ALG_OPTYPE_LEN 4
 #define ALG_MSGIV_LEN(len) (sizeof(struct af_alg_iv) + (len))
 
-typedef struct QCryptoAFAlg QCryptoAFAlg;
+typedef struct QCryptoAFAlgo QCryptoAFAlgo;
 
-struct QCryptoAFAlg {
+struct QCryptoAFAlgo {
     QCryptoCipher base;
 
     int tfmfd;
@@ -46,22 +46,22 @@ struct QCryptoAFAlg {
  * @type: the type of crypto operation
  * @name: the name of crypto operation
  *
- * Allocate a QCryptoAFAlg object and bind itself to
+ * Allocate a QCryptoAFAlgo object and bind itself to
  * a AF_ALG socket.
  *
  * Returns:
- *  a new QCryptoAFAlg object, or NULL in error.
+ *  a new QCryptoAFAlgo object, or NULL in error.
  */
-QCryptoAFAlg *
+QCryptoAFAlgo *
 qcrypto_afalg_comm_alloc(const char *type, const char *name,
                          Error **errp);
 
 /**
  * afalg_comm_free:
- * @afalg: the QCryptoAFAlg object
+ * @afalg: the QCryptoAFAlgo object
  *
  * Free the @afalg.
  */
-void qcrypto_afalg_comm_free(QCryptoAFAlg *afalg);
+void qcrypto_afalg_comm_free(QCryptoAFAlgo *afalg);
 
 #endif
diff --git a/crypto/hmacpriv.h b/crypto/hmacpriv.h
index bd4c498c62..f339596bd9 100644
--- a/crypto/hmacpriv.h
+++ b/crypto/hmacpriv.h
@@ -37,7 +37,7 @@ extern QCryptoHmacDriver qcrypto_hmac_lib_driver;
 
 #include "afalgpriv.h"
 
-QCryptoAFAlg *qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
+QCryptoAFAlgo *qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
                                          const uint8_t *key, size_t nkey,
                                          Error **errp);
 extern QCryptoHmacDriver qcrypto_hmac_afalg_driver;
diff --git a/crypto/afalg.c b/crypto/afalg.c
index 52a491dbb5..246d0679d4 100644
--- a/crypto/afalg.c
+++ b/crypto/afalg.c
@@ -66,13 +66,13 @@ qcrypto_afalg_socket_bind(const char *type, const char *name,
     return sbind;
 }
 
-QCryptoAFAlg *
+QCryptoAFAlgo *
 qcrypto_afalg_comm_alloc(const char *type, const char *name,
                          Error **errp)
 {
-    QCryptoAFAlg *afalg;
+    QCryptoAFAlgo *afalg;
 
-    afalg = g_new0(QCryptoAFAlg, 1);
+    afalg = g_new0(QCryptoAFAlgo, 1);
     /* initialize crypto API socket */
     afalg->opfd = -1;
     afalg->tfmfd = qcrypto_afalg_socket_bind(type, name, errp);
@@ -93,7 +93,7 @@ error:
     return NULL;
 }
 
-void qcrypto_afalg_comm_free(QCryptoAFAlg *afalg)
+void qcrypto_afalg_comm_free(QCryptoAFAlgo *afalg)
 {
     if (!afalg) {
         return;
diff --git a/crypto/cipher-afalg.c b/crypto/cipher-afalg.c
index c08eb7a39b..4980d419c4 100644
--- a/crypto/cipher-afalg.c
+++ b/crypto/cipher-afalg.c
@@ -65,7 +65,7 @@ qcrypto_afalg_cipher_ctx_new(QCryptoCipherAlgo alg,
                              const uint8_t *key,
                              size_t nkey, Error **errp)
 {
-    QCryptoAFAlg *afalg;
+    QCryptoAFAlgo *afalg;
     size_t expect_niv;
     char *name;
 
@@ -119,7 +119,7 @@ qcrypto_afalg_cipher_setiv(QCryptoCipher *cipher,
                            const uint8_t *iv,
                            size_t niv, Error **errp)
 {
-    QCryptoAFAlg *afalg = container_of(cipher, QCryptoAFAlg, base);
+    QCryptoAFAlgo *afalg = container_of(cipher, QCryptoAFAlgo, base);
     struct af_alg_iv *alg_iv;
     size_t expect_niv;
 
@@ -143,7 +143,7 @@ qcrypto_afalg_cipher_setiv(QCryptoCipher *cipher,
 }
 
 static int
-qcrypto_afalg_cipher_op(QCryptoAFAlg *afalg,
+qcrypto_afalg_cipher_op(QCryptoAFAlgo *afalg,
                         const void *in, void *out,
                         size_t len, bool do_encrypt,
                         Error **errp)
@@ -202,7 +202,7 @@ qcrypto_afalg_cipher_encrypt(QCryptoCipher *cipher,
                              const void *in, void *out,
                              size_t len, Error **errp)
 {
-    QCryptoAFAlg *afalg = container_of(cipher, QCryptoAFAlg, base);
+    QCryptoAFAlgo *afalg = container_of(cipher, QCryptoAFAlgo, base);
 
     return qcrypto_afalg_cipher_op(afalg, in, out, len, true, errp);
 }
@@ -212,14 +212,14 @@ qcrypto_afalg_cipher_decrypt(QCryptoCipher *cipher,
                              const void *in, void *out,
                              size_t len, Error **errp)
 {
-    QCryptoAFAlg *afalg = container_of(cipher, QCryptoAFAlg, base);
+    QCryptoAFAlgo *afalg = container_of(cipher, QCryptoAFAlgo, base);
 
     return qcrypto_afalg_cipher_op(afalg, in, out, len, false, errp);
 }
 
 static void qcrypto_afalg_comm_ctx_free(QCryptoCipher *cipher)
 {
-    QCryptoAFAlg *afalg = container_of(cipher, QCryptoAFAlg, base);
+    QCryptoAFAlgo *afalg = container_of(cipher, QCryptoAFAlgo, base);
 
     qcrypto_afalg_comm_free(afalg);
 }
diff --git a/crypto/hash-afalg.c b/crypto/hash-afalg.c
index 8fc6bd0edf..28ab899b18 100644
--- a/crypto/hash-afalg.c
+++ b/crypto/hash-afalg.c
@@ -64,12 +64,12 @@ qcrypto_afalg_hash_format_name(QCryptoHashAlgo alg,
     return name;
 }
 
-static QCryptoAFAlg *
+static QCryptoAFAlgo *
 qcrypto_afalg_hash_hmac_ctx_new(QCryptoHashAlgo alg,
                                 const uint8_t *key, size_t nkey,
                                 bool is_hmac, Error **errp)
 {
-    QCryptoAFAlg *afalg;
+    QCryptoAFAlgo *afalg;
     char *name;
 
     name = qcrypto_afalg_hash_format_name(alg, is_hmac, errp);
@@ -98,14 +98,14 @@ qcrypto_afalg_hash_hmac_ctx_new(QCryptoHashAlgo alg,
     return afalg;
 }
 
-static QCryptoAFAlg *
+static QCryptoAFAlgo *
 qcrypto_afalg_hash_ctx_new(QCryptoHashAlgo alg,
                            Error **errp)
 {
     return qcrypto_afalg_hash_hmac_ctx_new(alg, NULL, 0, false, errp);
 }
 
-QCryptoAFAlg *
+QCryptoAFAlgo *
 qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
                            const uint8_t *key, size_t nkey,
                            Error **errp)
@@ -114,14 +114,14 @@ qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgo alg,
 }
 
 static int
-qcrypto_afalg_hash_hmac_bytesv(QCryptoAFAlg *hmac,
+qcrypto_afalg_hash_hmac_bytesv(QCryptoAFAlgo *hmac,
                                QCryptoHashAlgo alg,
                                const struct iovec *iov,
                                size_t niov, uint8_t **result,
                                size_t *resultlen,
                                Error **errp)
 {
-    QCryptoAFAlg *afalg;
+    QCryptoAFAlgo *afalg;
     struct iovec outv;
     int ret = 0;
     bool is_hmac = (hmac != NULL) ? true : false;
@@ -197,7 +197,7 @@ qcrypto_afalg_hmac_bytesv(QCryptoHmac *hmac,
 
 static void qcrypto_afalg_hmac_ctx_free(QCryptoHmac *hmac)
 {
-    QCryptoAFAlg *afalg;
+    QCryptoAFAlgo *afalg;
 
     afalg = hmac->opaque;
     qcrypto_afalg_comm_free(afalg);
-- 
2.45.0


