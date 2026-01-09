Return-Path: <kvm+bounces-67569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5FCD0AA5C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2D4C300DBAF
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E0733B6E8;
	Fri,  9 Jan 2026 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YjkG6js8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B1F2D7812
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969320; cv=none; b=lSUTJEj2vjUzO/C0MqL9eD8Hwnrim5GhVbtvtcp7vUPTpgv6zXIq5iieRFeDLzsz4I+H7BnjN0wywJwS5dgX410ZrUkqrb6EJROVXv3TpPsWKvvzpz1UqJz/Ga5AtDt68mAnvxhONmgtNtNhzA7MvkE9LnusxMFV6H/YMBgie3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969320; c=relaxed/simple;
	bh=X6cLy0hCV/SAXL6//SGIacMObxg7d6EqIJKuRFjE10g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3digXByaRRo6oZf7oiKAotWOuw7Zx9iFsM3ngU/nh5adeFhA4QGTWCLAd4TWtgBShX/Gr9f6Q/1dcX0GFY6thNPyqQAtQV2LEJi60b3tPkNKZhZcysdeAQrIpQqxoumR8wn2A4Z0Zu8AZ4vDnblLFQVwC+0wuUpIUGqst49iYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YjkG6js8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kk/8eotG0F0P+tesvNKVdbvvCdd2DwmMuhkjQ8i8LyE=;
	b=YjkG6js8Su2rlM+AD7fpfOqUu2pLs2DFYH6IpOaXJRjB0mWthku6upjPdaQ3WKHRq7MM6I
	RKrZuoJkjYUIv7+sgwyNHdhlMM3n1uwLHfyUxwJCuh53RlxvysVae3fh9i25nRoMSNxYVP
	C3yxT84B6jX6NtGPRdwB4atZU+Pk5Ck=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-qH2LqthvP6G-KazQNLRC2g-1; Fri,
 09 Jan 2026 09:34:59 -0500
X-MC-Unique: qH2LqthvP6G-KazQNLRC2g-1
X-Mimecast-MFC-AGG-ID: qH2LqthvP6G-KazQNLRC2g_1767969298
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39A7718005B7;
	Fri,  9 Jan 2026 14:34:58 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.84])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1C4E180066A;
	Fri,  9 Jan 2026 14:34:52 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v3 6/6] igvm: Fill MADT IGVM parameter field
Date: Fri,  9 Jan 2026 15:34:13 +0100
Message-ID: <20260109143413.293593-7-osteffen@redhat.com>
In-Reply-To: <20260109143413.293593-1-osteffen@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Use the new acpi_build_madt_standalone() function to fill the MADT
parameter field.

The IGVM parameter can be consumed by Coconut SVSM [1], instead of
relying on the fw_cfg interface, which has caused problems before due to
unexpected access [2,3]. Using IGVM parameters is the default way for
Coconut SVSM; switching over would allow removing specialized code paths
for QEMU in Coconut.

In any case OVMF, which runs after SVSM has already been initialized,
will continue reading all ACPI tables via fw_cfg and provide fixed up
ACPI data to the OS as before.

Generating the MADT twice (during ACPI table building and IGVM processing)
seems acceptable, since there is no infrastructure to obtain the MADT
out of the ACPI table memory area.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

Signed-off-by: Oliver Steffen <osteffen@redhat.com>

SQUASH: Rename madt parameter handler
---
 backends/igvm.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/backends/igvm.c b/backends/igvm.c
index 7390dee734..90ea2c22fd 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -15,9 +15,11 @@
 #include "qapi/error.h"
 #include "qemu/target-info-qapi.h"
 #include "system/igvm.h"
+#include "glib.h"
 #include "system/memory.h"
 #include "system/address-spaces.h"
 #include "hw/core/cpu.h"
+#include "hw/i386/acpi-build.h"
 
 #include "trace.h"
 
@@ -134,6 +136,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
 static int qigvm_initialization_guest_policy(QIgvm *ctx,
                                        const uint8_t *header_data,
                                        Error **errp);
+static int qigvm_directive_madt(QIgvm *ctx,
+                                     const uint8_t *header_data, Error **errp);
 
 struct QIGVMHandler {
     uint32_t type;
@@ -162,6 +166,8 @@ static struct QIGVMHandler handlers[] = {
       qigvm_directive_snp_id_block },
     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
       qigvm_initialization_guest_policy },
+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
+      qigvm_directive_madt },
 };
 
 static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
@@ -780,6 +786,35 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
     return 0;
 }
 
+static int qigvm_directive_madt(QIgvm *ctx,
+                                     const uint8_t *header_data, Error **errp)
+{
+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
+    QIgvmParameterData *param_entry;
+
+    if (ctx->machine_state == NULL) {
+        return 0;
+    }
+
+    /* Find the parameter area that should hold the MADT data */
+    param_entry = qigvm_find_param_entry(ctx, param);
+    if (param_entry != NULL) {
+
+        GArray *madt = acpi_build_madt_standalone(ctx->machine_state);
+
+        if (madt->len > param_entry->size) {
+            error_setg(
+                errp,
+                "IGVM: MADT size exceeds parameter area defined in IGVM file");
+            return -1;
+        }
+        memcpy(param_entry->data, madt->data, madt->len);
+
+        g_array_free(madt, true);
+    }
+    return 0;
+}
+
 static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
 {
     int32_t header_count;
-- 
2.52.0


