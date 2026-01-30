Return-Path: <kvm+bounces-69674-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDouIkhGfGn+LgIAu9opvQ
	(envelope-from <kvm+bounces-69674-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27451B772F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE704303A6D3
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D08377573;
	Fri, 30 Jan 2026 05:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCWvBMFC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544B1326D53
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752077; cv=none; b=doGg18HT6n/TlxscJZJVvAHXw/tgcWoLU0oOIY8EVu6GZ+ZSsTfrxpA4Dl56twJ701d/MBPhEw2s0K4zs6q4DVpDq6/V9CifUgzmZHK2+Vj0SqEMsmOgNWLvCaSprTnSVeBKPSgHpjXKrBuIC8tYVpOJw/8RxQdmiUzkrwtTxF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752077; c=relaxed/simple;
	bh=hYod6cdg6r+xZ4I1ChhKDWpixadpxFCeppeRLaU+Mb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmaPn07PVi+7jOVfQ75xkVtrQB46RQi8El8Clyl8OAHEfQ9z0DjT83WbUuZAc25dTivQXfKCQ0RsMN6IcwZs0bfeYmuGvuFvep71rYouKvCUJ0HeXmL/Ja9As4Jofrv/y/759B+r/2/PSmzEqVSDrYkXbWJVp1KhR1+imkKcHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCWvBMFC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IJXdOXhspaRHklivBUBRzY+kMbUeEquACPs/3ejqttU=;
	b=PCWvBMFCx0SwYYQsHjotWP19hQN1t9NqcQvNsZ9beowjx/NpOlwAvdMcMdJOodt0HqwuVG
	H1ICKwJvJWXBa5yo0n0tqVYHzD3y88VnAbSXlLP/PqLGAk/Fn097NiwyEzMLYRFO7LjGbD
	ci+IyGDETpGndqqT8B6YPsYjGjBPR0A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-Sg-M-CeCMq-A4wCxjfO0AA-1; Fri,
 30 Jan 2026 00:47:47 -0500
X-MC-Unique: Sg-M-CeCMq-A4wCxjfO0AA-1
X-Mimecast-MFC-AGG-ID: Sg-M-CeCMq-A4wCxjfO0AA_1769752066
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC9811954B0C;
	Fri, 30 Jan 2026 05:47:45 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BAD2119560A2;
	Fri, 30 Jan 2026 05:47:40 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v6 4/9] igvm: Move structs to internal header
Date: Fri, 30 Jan 2026 06:47:09 +0100
Message-ID: <20260130054714.715928-5-osteffen@redhat.com>
In-Reply-To: <20260130054714.715928-1-osteffen@redhat.com>
References: <20260130054714.715928-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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
	FREEMAIL_CC(0.00)[redhat.com,intel.com,habkost.net,vger.kernel.org,linaro.org,amd.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69674-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[osteffen@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 27451B772F
X-Rspamd-Action: no action

Move QIgvm and QIgvmParameter struct definitions from the source file
into an IGVM internal header file to allow implementing architecture
specific IGVM code in other places, for example target/i386/igvm.c.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c                | 37 -------------------------------
 include/system/igvm-internal.h | 40 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index 4cf7b57234..3a3832dc2d 100644
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
diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index 171cec8d0f..9c8e887d6f 100644
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
-- 
2.52.0


