Return-Path: <kvm+bounces-25861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CDA396BA4E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1863D1F22E64
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362481DA601;
	Wed,  4 Sep 2024 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kic4TgjQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F711D5CF8
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448739; cv=none; b=LOqcHlu/s6Zv0yW8DAKe1Ao3rsYnKgl8J7vQ1r448yDS6s6uGyCVBNaLKcB3eynE+/v9gU2go6pDp3g3GSXN+mxZfkPt2rCOSTtC0uAwjuHkFDg/oxfCpMiRY1S4tNaXBYI6WaQgh6AnsMUj9PFRiUlvSzQEjlNMA5rcTr0Bq9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448739; c=relaxed/simple;
	bh=h0rGckFs9xwhbRraoXi5+zzKz23q6iBgL71GcCWbgs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxjZ9fYi7uQQGTEYDhozT5SignWn7Kz/BkgyEMohE5Q5R6/xOY7JcJBVPkHTpqirXdRsi71KvFj7dtpNyj1WhgpK7tm7wzXeQG9beY2NGu7v0Ewkmvxdz/QFu2Xp/uuvGsWStinCqSmZoLMwOB0tBZATMmPAjzoaj4cDvs3A6vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kic4TgjQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gWp+iCFBJ9F2d1YyCUo75gPc+JrIQoSE3ebW3zYSASw=;
	b=Kic4TgjQ+luEk6dFo+Jxfad0NpnzZITaajiEiE1bR5QmISocdKY6c8qMKrCF4suVLsg7uq
	CgNXtwYJlXpJ/0bZwgY76pp7/4IjDr/ZPi/sDjGdWmWW5u/PKy/JBk220k16pGTolKwfZX
	6SXDPD6JowhyNZyXGhlEXjlnlnuA9B4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-RA6P3sr1OiqPVB6mMsX1Cw-1; Wed,
 04 Sep 2024 07:18:52 -0400
X-MC-Unique: RA6P3sr1OiqPVB6mMsX1Cw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91BE41956096;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9DE030001AB;
	Wed,  4 Sep 2024 11:18:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D6E9421E682E; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 16/19] qapi/crypto: Rename QCryptoAFAlg to QCryptoAFAlgo
Date: Wed,  4 Sep 2024 13:18:33 +0200
Message-ID: <20240904111836.3273842-17-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

For consistency with other types names *Algo.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Acked-by: Daniel P. Berrangé <berrange@redhat.com>
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
2.46.0


