Return-Path: <kvm+bounces-22621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB377940AEB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6DA1C2234A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B13D194126;
	Tue, 30 Jul 2024 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eHT4Dkwy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF32190489
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327055; cv=none; b=PTItfQ2ANhmUZlCBcoAG6bBpsx49Xn74UAqPQYsIQG9VoBeNGuLyYQi8lvbKuklb6Am5Tul5KcmMRP0WfpIWigOiham4R6nWzs8JyFJqgWUPtAEfviJ91K0dZ0tsuc6AeV1qdjI3yMacvdKiQ4tWNlVqdbo0M8WMY8z7Yg8njgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327055; c=relaxed/simple;
	bh=CB+n5R6g2+Z06URCO8RohemKPp73IvFU0FSnVPRr5KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JZJkm30vS3e1TAQB7RpnZN6V9vli/U/I1FYtpz+1251No+JCxEyRWV+vgkchvVtc4cg543QGXhxxz+W1pdF/y7cBo5pWGy16xx17d9uZM7zRm62BI52D/KP0t91neAD5nclqt7vrG1TfIUarTvEqWTt5xvmd9WBb4FZOlAQQV+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eHT4Dkwy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrPMYKKLcBGOODCo0J5KSz2tkhQnlvWeFCzxUoif75Q=;
	b=eHT4DkwyAGj/+HCxLkkl7X7gZoG/BO6mcbYUwXwueNUwbfO79coXMEijtpZxxm1/A7Ch90
	x6e4WiLJTu1ngNve7Heh1jV7QL7a2DZMvcnpd1m7CP0De6+l73xpjzSTQFqOrNsQfCBRJk
	k53DGzxqjpl5w3+bClgrzdhEDJDS828=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-uN30GbkPNT-ywJIuXdeshw-1; Tue,
 30 Jul 2024 04:10:45 -0400
X-MC-Unique: uN30GbkPNT-ywJIuXdeshw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F67E1955D52;
	Tue, 30 Jul 2024 08:10:39 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9E6D1955D4B;
	Tue, 30 Jul 2024 08:10:34 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C85D321EC369; Tue, 30 Jul 2024 10:10:32 +0200 (CEST)
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
Subject: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for 'prefix'
Date: Tue, 30 Jul 2024 10:10:15 +0200
Message-ID: <20240730081032.1246748-2-armbru@redhat.com>
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

camel_to_upper() converts its argument from camel case to upper case
with '_' between words.  Used for generated enumeration constant
prefixes.

When some of the words are spelled all caps, where exactly to insert
'_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
to make people override them with a 'prefix' in the schema.

Rewrite it to guess better:

1. Insert '_' after a non-upper case character followed by an upper
   case character:

       OneTwo -> ONE_TWO
       One2Three -> ONE2_THREE

2. Insert '_' before the last upper case character followed by a
   non-upper case character:

       ACRONYMWord -> ACRONYM_Word

   Except at the beginning (as in OneTwo above), or when there is
   already one:

       AbCd -> AB_CD

This changes the default enumeration constant prefix for a number of
enums.  Generated enumeration constants change only where the default
is not overridden with 'prefix'.

The following enumerations without a 'prefix' change:

    enum       	     	 	    old camel_to_upper()
    				    new camel_to_upper()
    ------------------------------------------------------------------
    DisplayGLMode                   DISPLAYGL_MODE
				    DISPLAY_GL_MODE
    EbpfProgramID                   EBPF_PROGRAMID
				    EBPF_PROGRAM_ID
    HmatLBDataType                  HMATLB_DATA_TYPE
				    HMAT_LB_DATA_TYPE
    HmatLBMemoryHierarchy           HMATLB_MEMORY_HIERARCHY
				    HMAT_LB_MEMORY_HIERARCHY
    MultiFDCompression              MULTIFD_COMPRESSION
				    MULTI_FD_COMPRESSION
    OffAutoPCIBAR                   OFF_AUTOPCIBAR
				    OFF_AUTO_PCIBAR
    QCryptoBlockFormat              Q_CRYPTO_BLOCK_FORMAT
				    QCRYPTO_BLOCK_FORMAT
    QCryptoBlockLUKSKeyslotState    Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE
				    QCRYPTO_BLOCK_LUKS_KEYSLOT_STATE
    QKeyCode                        Q_KEY_CODE
    				    QKEY_CODE
    XDbgBlockGraphNodeType          X_DBG_BLOCK_GRAPH_NODE_TYPE
				    XDBG_BLOCK_GRAPH_NODE_TYPE
    TestUnionEnumA		    TEST_UNION_ENUMA
    				    TEST_UNION_ENUM_A

Add a 'prefix' so generated code doesn't change now.  Subsequent
commits will remove most of them again.  Two will remain:
MULTIFD_COMPRESSION, because migration code generally spells "multifd"
that way, and Q_KEY_CODE, because that one is baked into
subprojects/keycodemapdb/tools/keymap-gen.

The following enumerations with a 'prefix' change so that the prefix
is now superfluous:

    enum       	     	 	    old camel_to_upper()
    				    new camel_to_upper() [equal to prefix]
    ------------------------------------------------------------------
    BlkdebugIOType                  BLKDEBUGIO_TYPE
				    BLKDEBUG_IO_TYPE
    QCryptoTLSCredsEndpoint         Q_CRYPTOTLS_CREDS_ENDPOINT
				    QCRYPTO_TLS_CREDS_ENDPOINT
    QCryptoSecretFormat             Q_CRYPTO_SECRET_FORMAT
				    QCRYPTO_SECRET_FORMAT
    QCryptoCipherMode               Q_CRYPTO_CIPHER_MODE
				    QCRYPTO_CIPHER_MODE
    QCryptodevBackendType           Q_CRYPTODEV_BACKEND_TYPE
				    QCRYPTODEV_BACKEND_TYPE
    QType [builtin]                 Q_TYPE
				    QTYPE

Drop these prefixes.

The following enumerations with a 'prefix' change without making the
'prefix' superfluous:

    enum       	     	 	    old camel_to_upper()
    				    new camel_to_upper() [equal to prefix]
				    prefix
    ------------------------------------------------------------------
    CpuS390Entitlement              CPUS390_ENTITLEMENT
				    CPU_S390_ENTITLEMENT
				    S390_CPU_ENTITLEMENT
    CpuS390Polarization             CPUS390_POLARIZATION
				    CPU_S390_POLARIZATION
				    S390_CPU_POLARIZATION
    CpuS390State                    CPUS390_STATE
				    CPU_S390_STATE
				    S390_CPU_STATE
    QAuthZListFormat                Q_AUTHZ_LIST_FORMAT
				    QAUTH_Z_LIST_FORMAT
				    QAUTHZ_LIST_FORMAT
    QAuthZListPolicy                Q_AUTHZ_LIST_POLICY
				    QAUTH_Z_LIST_POLICY
				    QAUTHZ_LIST_POLICY
    QCryptoAkCipherAlgorithm        Q_CRYPTO_AK_CIPHER_ALGORITHM
				    QCRYPTO_AK_CIPHER_ALGORITHM
				    QCRYPTO_AKCIPHER_ALG
    QCryptoAkCipherKeyType          Q_CRYPTO_AK_CIPHER_KEY_TYPE
				    QCRYPTO_AK_CIPHER_KEY_TYPE
				    QCRYPTO_AKCIPHER_KEY_TYPE
    QCryptoCipherAlgorithm          Q_CRYPTO_CIPHER_ALGORITHM
				    QCRYPTO_CIPHER_ALGORITHM
				    QCRYPTO_CIPHER_ALG
    QCryptoHashAlgorithm            Q_CRYPTO_HASH_ALGORITHM
				    QCRYPTO_HASH_ALGORITHM
				    QCRYPTO_HASH_ALG
    QCryptoIVGenAlgorithm           Q_CRYPTOIV_GEN_ALGORITHM
				    QCRYPTO_IV_GEN_ALGORITHM
				    QCRYPTO_IVGEN_ALG
    QCryptoRSAPaddingAlgorithm      Q_CRYPTORSA_PADDING_ALGORITHM
				    QCRYPTO_RSA_PADDING_ALGORITHM
				    QCRYPTO_RSA_PADDING_ALG
    QCryptodevBackendAlgType        Q_CRYPTODEV_BACKEND_ALG_TYPE
				    QCRYPTODEV_BACKEND_ALG_TYPE
				    QCRYPTODEV_BACKEND_ALG
    QCryptodevBackendServiceType    Q_CRYPTODEV_BACKEND_SERVICE_TYPE
				    QCRYPTODEV_BACKEND_SERVICE_TYPE
				    QCRYPTODEV_BACKEND_SERVICE

Subsequent commits will tweak things to remove most of these prefixes.
Only QAUTHZ_LIST_FORMAT and QAUTHZ_LIST_POLICY will remain.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/block-core.json                     |  3 +-
 qapi/common.json                         |  1 +
 qapi/crypto.json                         |  6 ++--
 qapi/cryptodev.json                      |  1 -
 qapi/ebpf.json                           |  1 +
 qapi/machine.json                        |  1 +
 qapi/migration.json                      |  1 +
 qapi/ui.json                             |  2 ++
 scripts/qapi/common.py                   | 42 ++++++++++++++----------
 scripts/qapi/schema.py                   |  2 +-
 tests/qapi-schema/alternate-array.out    |  1 -
 tests/qapi-schema/comments.out           |  1 -
 tests/qapi-schema/doc-good.out           |  1 -
 tests/qapi-schema/empty.out              |  1 -
 tests/qapi-schema/include-repetition.out |  1 -
 tests/qapi-schema/include-simple.out     |  1 -
 tests/qapi-schema/indented-expr.out      |  1 -
 tests/qapi-schema/qapi-schema-test.json  |  1 +
 tests/qapi-schema/qapi-schema-test.out   |  2 +-
 19 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/qapi/block-core.json b/qapi/block-core.json
index f400b334c8..897bc7e0e7 100644
--- a/qapi/block-core.json
+++ b/qapi/block-core.json
@@ -2011,6 +2011,7 @@
 # Since: 4.0
 ##
 { 'enum': 'XDbgBlockGraphNodeType',
+  'prefix': 'X_DBG_BLOCK_GRAPH_NODE_TYPE', # TODO drop
   'data': [ 'block-backend', 'block-job', 'block-driver' ] }
 
 ##
@@ -3746,7 +3747,7 @@
 #
 # Since: 4.1
 ##
-{ 'enum': 'BlkdebugIOType', 'prefix': 'BLKDEBUG_IO_TYPE',
+{ 'enum': 'BlkdebugIOType',
   'data': [ 'read', 'write', 'write-zeroes', 'discard', 'flush',
             'block-status' ] }
 
diff --git a/qapi/common.json b/qapi/common.json
index 7558ce5430..25726d3113 100644
--- a/qapi/common.json
+++ b/qapi/common.json
@@ -92,6 +92,7 @@
 # Since: 2.12
 ##
 { 'enum': 'OffAutoPCIBAR',
+  'prefix': 'OFF_AUTOPCIBAR',   # TODO drop
   'data': [ 'off', 'auto', 'bar0', 'bar1', 'bar2', 'bar3', 'bar4', 'bar5' ] }
 
 ##
diff --git a/qapi/crypto.json b/qapi/crypto.json
index 39b191e8a2..e2d77c3fb3 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -20,7 +20,6 @@
 # Since: 2.5
 ##
 { 'enum': 'QCryptoTLSCredsEndpoint',
-  'prefix': 'QCRYPTO_TLS_CREDS_ENDPOINT',
   'data': ['client', 'server']}
 
 ##
@@ -36,7 +35,6 @@
 # Since: 2.6
 ##
 { 'enum': 'QCryptoSecretFormat',
-  'prefix': 'QCRYPTO_SECRET_FORMAT',
   'data': ['raw', 'base64']}
 
 ##
@@ -123,7 +121,6 @@
 # Since: 2.6
 ##
 { 'enum': 'QCryptoCipherMode',
-  'prefix': 'QCRYPTO_CIPHER_MODE',
   'data': ['ecb', 'cbc', 'xts', 'ctr']}
 
 ##
@@ -160,7 +157,7 @@
 # Since: 2.6
 ##
 { 'enum': 'QCryptoBlockFormat',
-#  'prefix': 'QCRYPTO_BLOCK_FORMAT',
+  'prefix': 'Q_CRYPTO_BLOCK_FORMAT', # TODO drop
   'data': ['qcow', 'luks']}
 
 ##
@@ -363,6 +360,7 @@
 # Since: 5.1
 ##
 { 'enum': 'QCryptoBlockLUKSKeyslotState',
+  'prefix': 'Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE', # TODO drop
   'data': [ 'active', 'inactive' ] }
 
 ##
diff --git a/qapi/cryptodev.json b/qapi/cryptodev.json
index 68289f4984..60f8fe8e4a 100644
--- a/qapi/cryptodev.json
+++ b/qapi/cryptodev.json
@@ -48,7 +48,6 @@
 # Since: 8.0
 ##
 { 'enum': 'QCryptodevBackendType',
-  'prefix': 'QCRYPTODEV_BACKEND_TYPE',
   'data': ['builtin', 'vhost-user', 'lkcf']}
 
 ##
diff --git a/qapi/ebpf.json b/qapi/ebpf.json
index e500b5a744..166a9d0eb0 100644
--- a/qapi/ebpf.json
+++ b/qapi/ebpf.json
@@ -42,6 +42,7 @@
 # Since: 9.0
 ##
 { 'enum': 'EbpfProgramID',
+  'prefix': 'EBPF_PROGRAMID',   # TODO drop
   'if': 'CONFIG_EBPF',
   'data': [ { 'name': 'rss' } ] }
 
diff --git a/qapi/machine.json b/qapi/machine.json
index fcfd249e2d..5514450e12 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -712,6 +712,7 @@
 # Since: 5.0
 ##
 { 'enum': 'HmatLBDataType',
+  'prefix': 'HMATLB_DATA_TYPE', # TODO drop
   'data': [ 'access-latency', 'read-latency', 'write-latency',
             'access-bandwidth', 'read-bandwidth', 'write-bandwidth' ] }
 
diff --git a/qapi/migration.json b/qapi/migration.json
index 073b67c052..1058d69971 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -571,6 +571,7 @@
 # Since: 5.0
 ##
 { 'enum': 'MultiFDCompression',
+  'prefix': 'MULTIFD_COMPRESSION',
   'data': [ 'none', 'zlib',
             { 'name': 'zstd', 'if': 'CONFIG_ZSTD' },
             { 'name': 'qpl', 'if': 'CONFIG_QPL' },
diff --git a/qapi/ui.json b/qapi/ui.json
index 5daca5168c..31c42821f6 100644
--- a/qapi/ui.json
+++ b/qapi/ui.json
@@ -948,6 +948,7 @@
 # Since: 1.3
 ##
 { 'enum': 'QKeyCode',
+  'prefix': 'Q_KEY_CODE',
   'data': [ 'unmapped',
             'shift', 'shift_r', 'alt', 'alt_r', 'ctrl',
             'ctrl_r', 'menu', 'esc', '1', '2', '3', '4', '5', '6', '7', '8',
@@ -1395,6 +1396,7 @@
 # Since: 3.0
 ##
 { 'enum'    : 'DisplayGLMode',
+  'prefix'  : 'DISPLAYGL_MODE', # TODO drop
   'data'    : [ 'off', 'on', 'core', 'es' ] }
 
 ##
diff --git a/scripts/qapi/common.py b/scripts/qapi/common.py
index 737b059e62..7081dcd943 100644
--- a/scripts/qapi/common.py
+++ b/scripts/qapi/common.py
@@ -40,22 +40,28 @@ def camel_to_upper(value: str) -> str:
         ENUM_Name2 -> ENUM_NAME2
         ENUM24_Name -> ENUM24_NAME
     """
-    c_fun_str = c_name(value, False)
-    if value.isupper():
-        return c_fun_str
+    ret = value[0]
+    upc = value[0].isupper()
 
-    new_name = ''
-    length = len(c_fun_str)
-    for i in range(length):
-        char = c_fun_str[i]
-        # When char is upper case and no '_' appears before, do more checks
-        if char.isupper() and (i > 0) and c_fun_str[i - 1] != '_':
-            if i < length - 1 and c_fun_str[i + 1].islower():
-                new_name += '_'
-            elif c_fun_str[i - 1].isdigit():
-                new_name += '_'
-        new_name += char
-    return new_name.lstrip('_').upper()
+    # Copy remainder of ``value`` to ``ret`` with '_' inserted
+    for ch in value[1:]:
+        if ch.isupper() == upc:
+            pass
+        elif upc:
+            # ``ret`` ends in upper case, next char isn't: insert '_'
+            # before the last upper case char unless there is one
+            # already, or it's at the beginning
+            if len(ret) > 2 and ret[-2] != '_':
+                ret = ret[:-1] + '_' + ret[-1]
+        else:
+            # ``ret`` doesn't end in upper case, next char is: insert
+            # '_' before it
+            if ret[-1] != '_':
+                ret += '_'
+        ret += ch
+        upc = ch.isupper()
+
+    return c_name(ret.upper())
 
 
 def c_enum_const(type_name: str,
@@ -68,9 +74,9 @@ def c_enum_const(type_name: str,
     :param const_name: The name of this constant.
     :param prefix: Optional, prefix that overrides the type_name.
     """
-    if prefix is not None:
-        type_name = prefix
-    return camel_to_upper(type_name) + '_' + c_name(const_name, False).upper()
+    if prefix is None:
+        prefix = camel_to_upper(type_name)
+    return prefix + '_' + c_name(const_name, False).upper()
 
 
 def c_name(name: str, protect: bool = True) -> str:
diff --git a/scripts/qapi/schema.py b/scripts/qapi/schema.py
index d65c35f6ee..e97c978d38 100644
--- a/scripts/qapi/schema.py
+++ b/scripts/qapi/schema.py
@@ -1249,7 +1249,7 @@ def _def_predefineds(self) -> None:
             [{'name': n} for n in qtypes], None)
 
         self._def_definition(QAPISchemaEnumType(
-            'QType', None, None, None, None, qtype_values, 'QTYPE'))
+            'QType', None, None, None, None, qtype_values, None))
 
     def _make_features(
         self,
diff --git a/tests/qapi-schema/alternate-array.out b/tests/qapi-schema/alternate-array.out
index a657d85738..2f30973ac3 100644
--- a/tests/qapi-schema/alternate-array.out
+++ b/tests/qapi-schema/alternate-array.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/comments.out b/tests/qapi-schema/comments.out
index ce4f6a4f0f..937070c2c4 100644
--- a/tests/qapi-schema/comments.out
+++ b/tests/qapi-schema/comments.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/doc-good.out b/tests/qapi-schema/doc-good.out
index 6d24f1127b..ec277be91e 100644
--- a/tests/qapi-schema/doc-good.out
+++ b/tests/qapi-schema/doc-good.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/empty.out b/tests/qapi-schema/empty.out
index 3feb3f69d3..d1981f8586 100644
--- a/tests/qapi-schema/empty.out
+++ b/tests/qapi-schema/empty.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/include-repetition.out b/tests/qapi-schema/include-repetition.out
index 16dbd9b819..c564d27862 100644
--- a/tests/qapi-schema/include-repetition.out
+++ b/tests/qapi-schema/include-repetition.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/include-simple.out b/tests/qapi-schema/include-simple.out
index 48e923bfbc..ec8200ab18 100644
--- a/tests/qapi-schema/include-simple.out
+++ b/tests/qapi-schema/include-simple.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/indented-expr.out b/tests/qapi-schema/indented-expr.out
index 6a30ded3fa..a7c22c3eef 100644
--- a/tests/qapi-schema/indented-expr.out
+++ b/tests/qapi-schema/indented-expr.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
diff --git a/tests/qapi-schema/qapi-schema-test.json b/tests/qapi-schema/qapi-schema-test.json
index 8ca977c49d..0f5f54e621 100644
--- a/tests/qapi-schema/qapi-schema-test.json
+++ b/tests/qapi-schema/qapi-schema-test.json
@@ -119,6 +119,7 @@
   'data': [ 'value-a', 'value-b' ] }
 
 { 'enum': 'TestUnionEnumA',
+  'prefix': 'TEST_UNION_ENUMA', # TODO drop
   'data': [ 'value-a1', 'value-a2' ] }
 
 { 'struct': 'TestUnionTypeA1',
diff --git a/tests/qapi-schema/qapi-schema-test.out b/tests/qapi-schema/qapi-schema-test.out
index e2f0981348..add7346f49 100644
--- a/tests/qapi-schema/qapi-schema-test.out
+++ b/tests/qapi-schema/qapi-schema-test.out
@@ -1,7 +1,6 @@
 module ./builtin
 object q_empty
 enum QType
-    prefix QTYPE
     member none
     member qnull
     member qnum
@@ -109,6 +108,7 @@ enum TestUnionEnum
     member value-a
     member value-b
 enum TestUnionEnumA
+    prefix TEST_UNION_ENUMA
     member value-a1
     member value-a2
 object TestUnionTypeA1
-- 
2.45.0


