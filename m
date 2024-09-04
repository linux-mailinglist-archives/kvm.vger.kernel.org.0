Return-Path: <kvm+bounces-25859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3B496BA4C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B47284B59
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F401DA302;
	Wed,  4 Sep 2024 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSeZEYPg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F5A1D5888
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448738; cv=none; b=ixYwOKra/uvNjM85abCf2NDt7LuOYL542owG6smCMRX/N5h102RVfVFaSzceys8imU8eN65aDG80WdHO52ZFA0bHcNnBGKCd+Cl/7cqjvpCO4Qkl+b70l0Juf+AIZURFqUyRJ6ZCDA7LYm4Cts+N21qEHSn5ksy4CRu6eyiad2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448738; c=relaxed/simple;
	bh=Db3hWb98w1PC9tZ645cx1Qp2dP1ne5NT0NBKXZlXChs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eL6ompamOZiPkhvPoLOm40CAGu9BpC/I/fXXuLSFG59ELnf5BfLatRwABPCCmsG2VlsXRIf4XxTO7iBbEidCrQgs8EmINTcALQ9GuLg05fctclOspb7UHZMbLP9V3pKN7J36VHGMr0Ce0BwtQwT4w2D/GmbnmGhP62e5rfoaXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSeZEYPg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jvnxF7MUV7TcmDxjDOpIIuDd7PvoOLciN25fnQ1nCo=;
	b=fSeZEYPg/B0cPTFxctfhbNGaKGDpVG5uSXOASh8hWkdrye9RsBpVAB9mBGWExM+54rBoO8
	ugQM27AiGFlPJqPFyPgYCaQ/ignuid8r+WPF6ITZpk5NqKCItuKnOvbaqUl/0GwIZ8Oo+Q
	kZDAMfZ1YU8PfuC84kGc5YKgPC/MMu4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-52aQONzDMiaKr8BhmtZk7g-1; Wed,
 04 Sep 2024 07:18:52 -0400
X-MC-Unique: 52aQONzDMiaKr8BhmtZk7g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D847619560BF;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F524195608A;
	Wed,  4 Sep 2024 11:18:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E029721E66C9; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 18/19] qapi/cryptodev: Rename QCryptodevBackendAlgType to *Algo, and drop prefix
Date: Wed,  4 Sep 2024 13:18:35 +0200
Message-ID: <20240904111836.3273842-19-armbru@redhat.com>
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

QCryptodevBackendAlgType has a 'prefix' that overrides the generated
enumeration constants' prefix to QCRYPTODEV_BACKEND_ALG.

We could simply drop 'prefix', but I think the abbreviation "alg" is
less than clear.

Additionally rename the type to QCryptodevBackendAlgoType.  The prefix
becomes QCRYPTODEV_BACKEND_ALGO_TYPE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
---
 qapi/cryptodev.json          |  5 ++---
 include/sysemu/cryptodev.h   |  2 +-
 backends/cryptodev-builtin.c |  6 +++---
 backends/cryptodev-lkcf.c    |  4 ++--
 backends/cryptodev.c         |  6 +++---
 hw/virtio/virtio-crypto.c    | 14 +++++++-------
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/qapi/cryptodev.json b/qapi/cryptodev.json
index 65abc16842..5e417340dc 100644
--- a/qapi/cryptodev.json
+++ b/qapi/cryptodev.json
@@ -9,7 +9,7 @@
 ##
 
 ##
-# @QCryptodevBackendAlgType:
+# @QCryptodevBackendAlgoType:
 #
 # The supported algorithm types of a crypto device.
 #
@@ -19,8 +19,7 @@
 #
 # Since: 8.0
 ##
-{ 'enum': 'QCryptodevBackendAlgType',
-  'prefix': 'QCRYPTODEV_BACKEND_ALG',
+{ 'enum': 'QCryptodevBackendAlgoType',
   'data': ['sym', 'asym']}
 
 ##
diff --git a/include/sysemu/cryptodev.h b/include/sysemu/cryptodev.h
index 96d3998b93..b20822df0d 100644
--- a/include/sysemu/cryptodev.h
+++ b/include/sysemu/cryptodev.h
@@ -178,7 +178,7 @@ typedef struct CryptoDevBackendAsymOpInfo {
 typedef void (*CryptoDevCompletionFunc) (void *opaque, int ret);
 
 typedef struct CryptoDevBackendOpInfo {
-    QCryptodevBackendAlgType algtype;
+    QCryptodevBackendAlgoType algtype;
     uint32_t op_code;
     uint32_t queue_index;
     CryptoDevCompletionFunc cb;
diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 170c93a6be..b1486be630 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -549,7 +549,7 @@ static int cryptodev_builtin_operation(
     CryptoDevBackendBuiltinSession *sess;
     CryptoDevBackendSymOpInfo *sym_op_info;
     CryptoDevBackendAsymOpInfo *asym_op_info;
-    QCryptodevBackendAlgType algtype = op_info->algtype;
+    QCryptodevBackendAlgoType algtype = op_info->algtype;
     int status = -VIRTIO_CRYPTO_ERR;
     Error *local_error = NULL;
 
@@ -561,11 +561,11 @@ static int cryptodev_builtin_operation(
     }
 
     sess = builtin->sessions[op_info->session_id];
-    if (algtype == QCRYPTODEV_BACKEND_ALG_SYM) {
+    if (algtype == QCRYPTODEV_BACKEND_ALGO_TYPE_SYM) {
         sym_op_info = op_info->u.sym_op_info;
         status = cryptodev_builtin_sym_operation(sess, sym_op_info,
                                                  &local_error);
-    } else if (algtype == QCRYPTODEV_BACKEND_ALG_ASYM) {
+    } else if (algtype == QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM) {
         asym_op_info = op_info->u.asym_op_info;
         status = cryptodev_builtin_asym_operation(sess, op_info->op_code,
                                                   asym_op_info, &local_error);
diff --git a/backends/cryptodev-lkcf.c b/backends/cryptodev-lkcf.c
index 0dc4b067f5..38deac0717 100644
--- a/backends/cryptodev-lkcf.c
+++ b/backends/cryptodev-lkcf.c
@@ -474,7 +474,7 @@ static int cryptodev_lkcf_operation(
     CryptoDevBackendLKCF *lkcf =
         CRYPTODEV_BACKEND_LKCF(backend);
     CryptoDevBackendLKCFSession *sess;
-    QCryptodevBackendAlgType algtype = op_info->algtype;
+    QCryptodevBackendAlgoType algtype = op_info->algtype;
     CryptoDevLKCFTask *task;
 
     if (op_info->session_id >= MAX_SESSIONS ||
@@ -485,7 +485,7 @@ static int cryptodev_lkcf_operation(
     }
 
     sess = lkcf->sess[op_info->session_id];
-    if (algtype != QCRYPTODEV_BACKEND_ALG_ASYM) {
+    if (algtype != QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM) {
         error_report("algtype not supported: %u", algtype);
         return -VIRTIO_CRYPTO_NOTSUPP;
     }
diff --git a/backends/cryptodev.c b/backends/cryptodev.c
index 76dfe65904..d8bd2a1ae6 100644
--- a/backends/cryptodev.c
+++ b/backends/cryptodev.c
@@ -185,10 +185,10 @@ static int cryptodev_backend_operation(
 static int cryptodev_backend_account(CryptoDevBackend *backend,
                  CryptoDevBackendOpInfo *op_info)
 {
-    enum QCryptodevBackendAlgType algtype = op_info->algtype;
+    enum QCryptodevBackendAlgoType algtype = op_info->algtype;
     int len;
 
-    if (algtype == QCRYPTODEV_BACKEND_ALG_ASYM) {
+    if (algtype == QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM) {
         CryptoDevBackendAsymOpInfo *asym_op_info = op_info->u.asym_op_info;
         len = asym_op_info->src_len;
 
@@ -212,7 +212,7 @@ static int cryptodev_backend_account(CryptoDevBackend *backend,
         default:
             return -VIRTIO_CRYPTO_NOTSUPP;
         }
-    } else if (algtype == QCRYPTODEV_BACKEND_ALG_SYM) {
+    } else if (algtype == QCRYPTODEV_BACKEND_ALGO_TYPE_SYM) {
         CryptoDevBackendSymOpInfo *sym_op_info = op_info->u.sym_op_info;
         len = sym_op_info->src_len;
 
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 0ab8ae3282..6e9d8293da 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -461,7 +461,7 @@ static void virtio_crypto_init_request(VirtIOCrypto *vcrypto, VirtQueue *vq,
     req->in_iov = NULL;
     req->in_num = 0;
     req->in_len = 0;
-    req->flags = QCRYPTODEV_BACKEND_ALG__MAX;
+    req->flags = QCRYPTODEV_BACKEND_ALGO_TYPE__MAX;
     memset(&req->op_info, 0x00, sizeof(req->op_info));
 }
 
@@ -471,7 +471,7 @@ static void virtio_crypto_free_request(VirtIOCryptoReq *req)
         return;
     }
 
-    if (req->flags == QCRYPTODEV_BACKEND_ALG_SYM) {
+    if (req->flags == QCRYPTODEV_BACKEND_ALGO_TYPE_SYM) {
         size_t max_len;
         CryptoDevBackendSymOpInfo *op_info = req->op_info.u.sym_op_info;
 
@@ -486,7 +486,7 @@ static void virtio_crypto_free_request(VirtIOCryptoReq *req)
             memset(op_info, 0, sizeof(*op_info) + max_len);
             g_free(op_info);
         }
-    } else if (req->flags == QCRYPTODEV_BACKEND_ALG_ASYM) {
+    } else if (req->flags == QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM) {
         CryptoDevBackendAsymOpInfo *op_info = req->op_info.u.asym_op_info;
         if (op_info) {
             g_free(op_info->src);
@@ -571,10 +571,10 @@ static void virtio_crypto_req_complete(void *opaque, int ret)
     VirtIODevice *vdev = VIRTIO_DEVICE(vcrypto);
     uint8_t status = -ret;
 
-    if (req->flags == QCRYPTODEV_BACKEND_ALG_SYM) {
+    if (req->flags == QCRYPTODEV_BACKEND_ALGO_TYPE_SYM) {
         virtio_crypto_sym_input_data_helper(vdev, req, status,
                                             req->op_info.u.sym_op_info);
-    } else if (req->flags == QCRYPTODEV_BACKEND_ALG_ASYM) {
+    } else if (req->flags == QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM) {
         virtio_crypto_akcipher_input_data_helper(vdev, req, status,
                                              req->op_info.u.asym_op_info);
     }
@@ -884,7 +884,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
     switch (opcode) {
     case VIRTIO_CRYPTO_CIPHER_ENCRYPT:
     case VIRTIO_CRYPTO_CIPHER_DECRYPT:
-        op_info->algtype = request->flags = QCRYPTODEV_BACKEND_ALG_SYM;
+        op_info->algtype = request->flags = QCRYPTODEV_BACKEND_ALGO_TYPE_SYM;
         ret = virtio_crypto_handle_sym_req(vcrypto,
                          &req.u.sym_req, op_info,
                          out_iov, out_num);
@@ -894,7 +894,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
     case VIRTIO_CRYPTO_AKCIPHER_DECRYPT:
     case VIRTIO_CRYPTO_AKCIPHER_SIGN:
     case VIRTIO_CRYPTO_AKCIPHER_VERIFY:
-        op_info->algtype = request->flags = QCRYPTODEV_BACKEND_ALG_ASYM;
+        op_info->algtype = request->flags = QCRYPTODEV_BACKEND_ALGO_TYPE_ASYM;
         ret = virtio_crypto_handle_asym_req(vcrypto,
                          &req.u.akcipher_req, op_info,
                          out_iov, out_num);
-- 
2.46.0


