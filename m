Return-Path: <kvm+bounces-69998-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEDKATTkgWmDLQMAu9opvQ
	(envelope-from <kvm+bounces-69998-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C786D8BC9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 69F95302A957
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6A633AD93;
	Tue,  3 Feb 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6nDGiDh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D21B313546
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120239; cv=none; b=U+JpvPbwW/9m2crL+mRep31pTroSTf8MrS5JBlnAuYPrxiKpU0ipQNz2hF5Tm3NpWHYNdD1+hDv6Iyum+DZ6L1zSj4RmBUHEK1wDgi7892fCmm+IveKO0ltkUFPwevM3wiAZycJ6FgkokiJhknH8DpNTdlTJDnGIjJ3u/RAWkx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120239; c=relaxed/simple;
	bh=Z84pmFf7Nx0s9z93Yl5ti3lfFEZ4dBD7fJIAJ2JZgZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoVJOQRW1qC7+DUnW5kuDqH6vQUgEeHInAcnyNQdyMvtmooT/HQuyxgyJXBod98ZtFTRqlOHb2VtbifyJq4tgWy9uIYd6aBRpDTjaAlIm9Pz9q/8rDVceMoR3rR0djvfAShSK/YfdMgK3j5SGGvulgspIu6rfX6fBZzm6tXo0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6nDGiDh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94g7mivH60rDzW0871uzSXpoDqoV+knONpW2UR0CSeY=;
	b=f6nDGiDhu6zMH6o4i168uxAZdzMUm1jVfK0wNkVmG8uUSWZltkOJU8/tTWG4xbpEsDjGJJ
	nIUZLlqTteiLql36mdyEgn87Uzh7SCMjNQ5TZh52AjA3XqcL48OQvJziWQgqG4ArYLa30D
	DOez1bgRkRyO6tBBrjzhvxY1RwQ/xBg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-cXuFFGVLMrCKma1HhIpk2Q-1; Tue,
 03 Feb 2026 07:03:53 -0500
X-MC-Unique: cXuFFGVLMrCKma1HhIpk2Q-1
X-Mimecast-MFC-AGG-ID: cXuFFGVLMrCKma1HhIpk2Q_1770120232
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2E871956094;
	Tue,  3 Feb 2026 12:03:51 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4633618004D8;
	Tue,  3 Feb 2026 12:03:51 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id B43F81800635; Tue, 03 Feb 2026 13:03:43 +0100 (CET)
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
Subject: [PULL 04/17] igvm: reorganize headers
Date: Tue,  3 Feb 2026 13:03:29 +0100
Message-ID: <20260203120343.656961-5-kraxel@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69998-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9C786D8BC9
X-Rspamd-Action: no action

Add a new igvm-internal.h header file.  Structs and declarations which
depend on the igvm library header go into that file.

Also declare IgvmCfg in typedefs.h, so the type can be used without
including igvm header files.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <20260126123755.357378-2-kraxel@redhat.com>
---
 include/qemu/typedefs.h        |  1 +
 include/system/igvm-cfg.h      | 12 +-----------
 include/system/igvm-internal.h | 26 ++++++++++++++++++++++++++
 include/system/igvm.h          |  2 +-
 backends/igvm-cfg.c            |  4 +++-
 backends/igvm.c                |  2 ++
 6 files changed, 34 insertions(+), 13 deletions(-)
 create mode 100644 include/system/igvm-internal.h

diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 4a94af9665a5..416a8c9acead 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -55,6 +55,7 @@ typedef struct FWCfgState FWCfgState;
 typedef struct HostMemoryBackend HostMemoryBackend;
 typedef struct I2CBus I2CBus;
 typedef struct I2SCodec I2SCodec;
+typedef struct IgvmCfg IgvmCfg;
 typedef struct IOMMUMemoryRegion IOMMUMemoryRegion;
 typedef struct ISABus ISABus;
 typedef struct ISADevice ISADevice;
diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
index 944f23a814dd..6c07f3084082 100644
--- a/include/system/igvm-cfg.h
+++ b/include/system/igvm-cfg.h
@@ -12,19 +12,9 @@
 #ifndef QEMU_IGVM_CFG_H
 #define QEMU_IGVM_CFG_H
 
+#include "qemu/typedefs.h"
 #include "qom/object.h"
 
-typedef struct IgvmCfg {
-    ObjectClass parent_class;
-
-    /*
-     * filename: Filename that specifies a file that contains the configuration
-     *           of the guest in Independent Guest Virtual Machine (IGVM)
-     *           format.
-     */
-    char *filename;
-} IgvmCfg;
-
 typedef struct IgvmCfgClass {
     ObjectClass parent_class;
 
diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
new file mode 100644
index 000000000000..475a29bbf3d7
--- /dev/null
+++ b/include/system/igvm-internal.h
@@ -0,0 +1,26 @@
+/*
+ * QEMU IGVM private data structures
+ *
+ * Everything which depends on igvm library headers goes here.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef QEMU_IGVM_INTERNAL_H
+#define QEMU_IGVM_INTERNAL_H
+
+#include "qemu/typedefs.h"
+#include "qom/object.h"
+
+struct IgvmCfg {
+    ObjectClass parent_class;
+
+    /*
+     * filename: Filename that specifies a file that contains the configuration
+     *           of the guest in Independent Guest Virtual Machine (IGVM)
+     *           format.
+     */
+    char *filename;
+};
+
+#endif
diff --git a/include/system/igvm.h b/include/system/igvm.h
index 48ce20604259..8355e54e95fc 100644
--- a/include/system/igvm.h
+++ b/include/system/igvm.h
@@ -12,8 +12,8 @@
 #ifndef BACKENDS_IGVM_H
 #define BACKENDS_IGVM_H
 
+#include "qemu/typedefs.h"
 #include "system/confidential-guest-support.h"
-#include "system/igvm-cfg.h"
 #include "qapi/error.h"
 
 int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index d00acf351249..001c4dc93346 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -11,8 +11,10 @@
 
 #include "qemu/osdep.h"
 
-#include "system/igvm-cfg.h"
 #include "system/igvm.h"
+#include "system/igvm-cfg.h"
+#include "system/igvm-internal.h"
+#include "system/reset.h"
 #include "qom/object_interfaces.h"
 
 static char *get_igvm(Object *obj, Error **errp)
diff --git a/backends/igvm.c b/backends/igvm.c
index 905bd8d98994..fbb8300b6d01 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -14,6 +14,8 @@
 #include "qapi/error.h"
 #include "qemu/target-info-qapi.h"
 #include "system/igvm.h"
+#include "system/igvm-cfg.h"
+#include "system/igvm-internal.h"
 #include "system/memory.h"
 #include "system/address-spaces.h"
 #include "hw/core/cpu.h"
-- 
2.52.0


