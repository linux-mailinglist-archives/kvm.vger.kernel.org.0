Return-Path: <kvm+bounces-70002-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBXkGYTlgWl0LwMAu9opvQ
	(envelope-from <kvm+bounces-70002-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4951D8D1C
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E1BD314959F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD08533C51A;
	Tue,  3 Feb 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj+3ZzT+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABD33C53C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120243; cv=none; b=T2Lzphc6HJJMvUmYMntkKuHhvIZ28kxWWdxZ+WuScjzI6fG1FDNDQ+yZM4rAMeiTPbnPpNYxxM5H00OMuEbPWqavGqv+43Hq6rYfi5NR2TC90Sqj2g/ygFO1354I9sq9B9E3IuamfhJKBJ37ob83wCodC/9nxN+xuDJg1xzHB2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120243; c=relaxed/simple;
	bh=7FeUD4vlFNA8vQHgVu0WYK295qX9eGXjAIERH31cRnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZN+fcUlGevp/Ko3GM0X9yNzyyp2nTWqrWgoYTJPeh0CBK2KpPx8S7ou8/ZY2IujiSyqCG/kB+OflEE84n1wg90ntgMxF5N82lj8lYnyAQoModiL0WOAYbwc+63JJDE7nCGBCHv3I/JWxw5Bd+7HN3cieudKf3R2RDDZNXjRqauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj+3ZzT+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2yAZjsvESraEcG8eDAOsyuG+02DfRy5k2L12yW5XDU=;
	b=Gj+3ZzT+wb3L4vg/NGv+tQCj2e0kladhlVvRTXWI/zDaKeImwVvzeIUlV7QA+rqOM1tf4C
	wFhnYT28siPWH094IiCkjuOjveawwt7FMe9c2J4rlRktfWaW9PGtlE/ddZPiLsB+uV7V2S
	BSJu6d4bz8aaouyY/DaEqoJ7F3I4HIc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-9rXH_ywQNcKrvCavLQOqmA-1; Tue,
 03 Feb 2026 07:03:56 -0500
X-MC-Unique: 9rXH_ywQNcKrvCavLQOqmA-1
X-Mimecast-MFC-AGG-ID: 9rXH_ywQNcKrvCavLQOqmA_1770120235
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0904C1955F34;
	Tue,  3 Feb 2026 12:03:55 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A9A81956053;
	Tue,  3 Feb 2026 12:03:54 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id DDA2D1800639; Tue, 03 Feb 2026 13:03:43 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PULL 06/17] igvm: move file load to complete callback
Date: Tue,  3 Feb 2026 13:03:31 +0100
Message-ID: <20260203120343.656961-7-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70002-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kraxel@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C4951D8D1C
X-Rspamd-Action: no action

Add UserCreatableClass->complete callback function for igvm-cfg object.

Move file loading and parsing of the igvm file from the process function
to the new complete() callback function.  Keep the igvm file loaded
after processing, release it in finalize() instead, so we parse it only
once.

Reviewed-by: Ani Sinha <anisinha@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <20260126123755.357378-4-kraxel@redhat.com>
---
 include/system/igvm-internal.h |  5 +++++
 backends/igvm-cfg.c            | 18 ++++++++++++++++++
 backends/igvm.c                |  9 ++++-----
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index ac9e5683cc63..171cec8d0f6c 100644
--- a/include/system/igvm-internal.h
+++ b/include/system/igvm-internal.h
@@ -13,6 +13,8 @@
 #include "qom/object.h"
 #include "hw/core/resettable.h"
 
+#include <igvm/igvm.h>
+
 struct IgvmCfg {
     ObjectClass parent_class;
 
@@ -22,7 +24,10 @@ struct IgvmCfg {
      *           format.
      */
     char *filename;
+    IgvmHandle file;
     ResettableState reset_state;
 };
 
+IgvmHandle qigvm_file_init(char *filename, Error **errp);
+
 #endif
diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index e0df3eaa8efd..4014062e0f22 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -53,6 +53,13 @@ static void igvm_reset_exit(Object *obj, ResetType type)
     trace_igvm_reset_exit(type);
 }
 
+static void igvm_complete(UserCreatable *uc, Error **errp)
+{
+    IgvmCfg *igvm = IGVM_CFG(uc);
+
+    igvm->file = qigvm_file_init(igvm->filename, errp);
+}
+
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(IgvmCfg, igvm_cfg, IGVM_CFG, OBJECT,
                                    { TYPE_USER_CREATABLE },
                                    { TYPE_RESETTABLE_INTERFACE },
@@ -62,6 +69,7 @@ static void igvm_cfg_class_init(ObjectClass *oc, const void *data)
 {
     IgvmCfgClass *igvmc = IGVM_CFG_CLASS(oc);
     ResettableClass *rc = RESETTABLE_CLASS(oc);
+    UserCreatableClass *uc = USER_CREATABLE_CLASS(oc);
 
     object_class_property_add_str(oc, "file", get_igvm, set_igvm);
     object_class_property_set_description(oc, "file",
@@ -73,14 +81,24 @@ static void igvm_cfg_class_init(ObjectClass *oc, const void *data)
     rc->phases.enter = igvm_reset_enter;
     rc->phases.hold = igvm_reset_hold;
     rc->phases.exit = igvm_reset_exit;
+
+    uc->complete = igvm_complete;
 }
 
 static void igvm_cfg_init(Object *obj)
 {
+    IgvmCfg *igvm = IGVM_CFG(obj);
+
+    igvm->file = -1;
     qemu_register_resettable(obj);
 }
 
 static void igvm_cfg_finalize(Object *obj)
 {
+    IgvmCfg *igvm = IGVM_CFG(obj);
+
     qemu_unregister_resettable(obj);
+    if (igvm->file >= 0) {
+        igvm_free(igvm->file);
+    }
 }
diff --git a/backends/igvm.c b/backends/igvm.c
index fbb8300b6d01..a01e01a12a60 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -869,7 +869,7 @@ static int qigvm_handle_policy(QIgvm *ctx, Error **errp)
     return 0;
 }
 
-static IgvmHandle qigvm_file_init(char *filename, Error **errp)
+IgvmHandle qigvm_file_init(char *filename, Error **errp)
 {
     IgvmHandle igvm;
     g_autofree uint8_t *buf = NULL;
@@ -898,10 +898,11 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
     QIgvm ctx;
 
     memset(&ctx, 0, sizeof(ctx));
-    ctx.file = qigvm_file_init(cfg->filename, errp);
-    if (ctx.file < 0) {
+    if (cfg->file < 0) {
+        error_setg(errp, "No IGVM file loaded.");
         return -1;
     }
+    ctx.file = cfg->file;
 
     /*
      * The ConfidentialGuestSupport object is optional and allows a confidential
@@ -992,7 +993,5 @@ cleanup_parameters:
     g_free(ctx.id_auth);
 
 cleanup:
-    igvm_free(ctx.file);
-
     return retval;
 }
-- 
2.52.0


