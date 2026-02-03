Return-Path: <kvm+bounces-70006-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UI4WJFTkgWmDLQMAu9opvQ
	(envelope-from <kvm+bounces-70006-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D67D8BF7
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 243B9303033A
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1353031AA96;
	Tue,  3 Feb 2026 12:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WsybMFLC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EFF33D6D9
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120250; cv=none; b=SY6BilgGpii1wPHH+CnpyKANJy5xkW3OzdtB4xm8Q6EH9p+sg2PXbGaUhvVottT7zxTorl49i72IWInsbtIzfWnW7c3MAm9SS+sdLJf2lxMeQmB7ZGtxTLla5rlyDZI0yXh3NiaU2edIQ+pUlPsYwkU1GiSl+seycIVkdGaQcjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120250; c=relaxed/simple;
	bh=K2KRzgRnDKFWm6f+U3EhQYgrBiNoBgtqmVo9Sv4WKK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cwz9ET4mGWx8D4k4gJdOXxIKuaCInHfjrE6ptHkoQm90op+o/DEJPM0+n1D3ny/QwCiSSzPeCNKzq1bforfG6Wqs8uoWbnRT53Q1RIlPEJOxIdLu46cCi+kuL68+S97M+qk7aNUBtZ8GPGsbuI+uVNOueyaZNee6JuZdNCz0G14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WsybMFLC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zpyf+w17AybpMWTXFwJ3HLZT/fuObdabqNF+kg5kjEw=;
	b=WsybMFLCvkQ67B0JsOXWQzAZnWotF0RlhJK4DWETVR3RsjmWrhzFUJIM1nnTUfHkyN2y5L
	Hu9BTVBFhOEAeiDtzHkMlkU59JuvSPbf7lPQ+Wm15Te57IlA4ftTuR3RsSsn1kpUGDAvQO
	hLRWfu/ebfhz7v1QCYZ5Q5TZ8c7wyIM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-3L6RRDOjMK6v_AYp3S_m3g-1; Tue,
 03 Feb 2026 07:04:04 -0500
X-MC-Unique: 3L6RRDOjMK6v_AYp3S_m3g-1
X-Mimecast-MFC-AGG-ID: 3L6RRDOjMK6v_AYp3S_m3g_1770120242
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8E57180035C;
	Tue,  3 Feb 2026 12:04:02 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4197F18004D8;
	Tue,  3 Feb 2026 12:04:02 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 5A6EA1826266; Tue, 03 Feb 2026 13:03:44 +0100 (CET)
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
	Gerd Hoffmann <kraxel@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PULL 12/17] igvm: Move structs to internal header
Date: Tue,  3 Feb 2026 13:03:37 +0100
Message-ID: <20260203120343.656961-13-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70006-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kraxel@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 38D67D8BF7
X-Rspamd-Action: no action

From: Oliver Steffen <osteffen@redhat.com>

Move QIgvm and QIgvmParameter struct definitions from the source file
into an IGVM internal header file to allow implementing architecture
specific IGVM code in other places, for example target/i386/igvm.c.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
Message-ID: <20260130054714.715928-5-osteffen@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/system/igvm-internal.h | 40 ++++++++++++++++++++++++++++++++++
 backends/igvm.c                | 37 -------------------------------
 2 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index 171cec8d0f6c..9c8e887d6f60 100644
--- a/include/system/igvm-internal.h
+++ b/include/system/igvm-internal.h
@@ -9,10 +9,12 @@
 #ifndef QEMU_IGVM_INTERNAL_H
 #define QEMU_IGVM_INTERNAL_H
 
+#include "qemu/queue.h"
 #include "qemu/typedefs.h"
 #include "qom/object.h"
 #include "hw/core/resettable.h"
 
+#include "system/confidential-guest-support.h"
 #include <igvm/igvm.h>
 
 struct IgvmCfg {
@@ -28,6 +30,44 @@ struct IgvmCfg {
     ResettableState reset_state;
 };
 
+typedef struct QIgvmParameterData {
+    QTAILQ_ENTRY(QIgvmParameterData) next;
+    uint8_t *data;
+    uint32_t size;
+    uint32_t index;
+} QIgvmParameterData;
+
+/*
+ * QIgvm contains the information required during processing of a single IGVM
+ * file.
+ */
+typedef struct QIgvm {
+    IgvmHandle file;
+    ConfidentialGuestSupport *cgs;
+    ConfidentialGuestSupportClass *cgsc;
+    uint32_t compatibility_mask;
+    unsigned current_header_index;
+    QTAILQ_HEAD(, QIgvmParameterData) parameter_data;
+    IgvmPlatformType platform_type;
+
+    /*
+     * SEV-SNP platforms can contain an ID block and authentication
+     * that should be verified by the guest.
+     */
+    struct sev_id_block *id_block;
+    struct sev_id_authentication *id_auth;
+
+    /* Define the guest policy for SEV guests */
+    uint64_t sev_policy;
+
+    /* These variables keep track of contiguous page regions */
+    IGVM_VHS_PAGE_DATA region_prev_page_data;
+    uint64_t region_start;
+    unsigned region_start_index;
+    unsigned region_last_index;
+    unsigned region_page_count;
+} QIgvm;
+
 IgvmHandle qigvm_file_init(char *filename, Error **errp);
 
 #endif
diff --git a/backends/igvm.c b/backends/igvm.c
index 4cf7b572347c..3a3832dc2dde 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -25,12 +25,6 @@
 #include <igvm/igvm.h>
 #include <igvm/igvm_defs.h>
 
-typedef struct QIgvmParameterData {
-    QTAILQ_ENTRY(QIgvmParameterData) next;
-    uint8_t *data;
-    uint32_t size;
-    uint32_t index;
-} QIgvmParameterData;
 
 /*
  * Some directives are specific to particular confidential computing platforms.
@@ -66,37 +60,6 @@ struct QEMU_PACKED sev_id_authentication {
 
 #define IGVM_SEV_ID_BLOCK_VERSION 1
 
-/*
- * QIgvm contains the information required during processing
- * of a single IGVM file.
- */
-typedef struct QIgvm {
-    IgvmHandle file;
-    ConfidentialGuestSupport *cgs;
-    ConfidentialGuestSupportClass *cgsc;
-    uint32_t compatibility_mask;
-    unsigned current_header_index;
-    QTAILQ_HEAD(, QIgvmParameterData) parameter_data;
-    IgvmPlatformType platform_type;
-
-    /*
-     * SEV-SNP platforms can contain an ID block and authentication
-     * that should be verified by the guest.
-     */
-    struct sev_id_block *id_block;
-    struct sev_id_authentication *id_auth;
-
-    /* Define the guest policy for SEV guests */
-    uint64_t sev_policy;
-
-    /* These variables keep track of contiguous page regions */
-    IGVM_VHS_PAGE_DATA region_prev_page_data;
-    uint64_t region_start;
-    unsigned region_start_index;
-    unsigned region_last_index;
-    unsigned region_page_count;
-} QIgvm;
-
 static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
                                      Error **errp);
 static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
-- 
2.52.0


