Return-Path: <kvm+bounces-68067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0230AD20A45
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 495B630161C7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3702C11CB;
	Wed, 14 Jan 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOmxNGnu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E77314A6C
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413055; cv=none; b=UrEOt2u/SRRzWIuKe27ZOtUEAIkLBe086LKA56s9+d0Ld+O5WDnBX3OT6C3eNL2sgk19wW4d3kdSHxWde50TkrJSDnd6LESpiwsU6eYIZP/vlr3Y5njieN/KYjp1VgGffMzi3mMV226A5AA5GM23aIFf8JFQAdl+EccEa0uywyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413055; c=relaxed/simple;
	bh=JVMU2xtercFuhcWYclfSUsxWk4ar5a9Zpcpq2+qa1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAy+03APxvUhostahMDgAs33iBcNsvk5i/dSzl0wON6YgKGbmqenIKtEsEi8Ty+DcMAaQjjPFsDKdUqeog6hGLJqGkon9f4cGFw0rHgaiBL5d5Xl/rKGyLbJDx+dlXqDC9drOwIaiZQEVIlHAOE9pFbA/CdvI0oz+2h/PvkWFPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eOmxNGnu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768413052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z97WeNJlMmycR+z4WcgaMcn3WWTu94HVQEJdZml9px0=;
	b=eOmxNGnu3D7Ve773XV+rV4NDG65F7KSfHY0O2cDtwWHJzyw3nnLXYSeJ2F/YpS88a/Irx6
	sRjRCoyIuEo6K428q2aTKWrcIYo8G0UWXTnDTto4zyHrDwGyBkzfjyuivp4hc4L5Fg/Tz0
	/dhlZMv26pMj4k0llDDhX+1xzj3AUKQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-8Z-IX3osPFKhDOfCdHM3tQ-1; Wed,
 14 Jan 2026 12:50:48 -0500
X-MC-Unique: 8Z-IX3osPFKhDOfCdHM3tQ-1
X-Mimecast-MFC-AGG-ID: 8Z-IX3osPFKhDOfCdHM3tQ_1768413047
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FDE41955DC7;
	Wed, 14 Jan 2026 17:50:47 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.224.90])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D30B11800665;
	Wed, 14 Jan 2026 17:50:41 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v4 5/5] igvm: Fill MADT IGVM parameter field
Date: Wed, 14 Jan 2026 18:50:07 +0100
Message-ID: <20260114175007.90845-6-osteffen@redhat.com>
In-Reply-To: <20260114175007.90845-1-osteffen@redhat.com>
References: <20260114175007.90845-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Use the new acpi_build_madt_standalone() function to fill the MADT
parameter field.

The IGVM parameter can be consumed by Coconut SVSM [1], instead of
relying on the fw_cfg interface, which has caused problems before due to
unexpected access [2,3]. Using IGVM parameters is the default way for
Coconut SVSM across hypervisors; switching over would allow removing
specialized code paths for QEMU in Coconut.

Coconut SVSM needs to know the SMP configuration, but does not look at
any other ACPI data, nor does it interact with the PCI bus settings.
Since the MADT is static and not linked with other ACPI tables, it can
be supplied stand-alone like this.

Generating the MADT twice (during ACPI table building and IGVM processing)
seems acceptable, since there is no infrastructure to obtain the MADT
out of the ACPI table memory area.

In any case OVMF, which runs after SVSM has already been initialized,
will continue reading all ACPI tables via fw_cfg and provide fixed up
ACPI data to the OS as before without any changes.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/backends/igvm.c b/backends/igvm.c
index cb2f997c87..980068fb58 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -18,6 +18,7 @@
 #include "system/memory.h"
 #include "system/address-spaces.h"
 #include "hw/core/cpu.h"
+#include "hw/i386/acpi-build.h"
 
 #include "trace.h"
 
@@ -134,6 +135,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
 static int qigvm_initialization_guest_policy(QIgvm *ctx,
                                        const uint8_t *header_data,
                                        Error **errp);
+static int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data,
+                                Error **errp);
 
 struct QIGVMHandler {
     uint32_t type;
@@ -162,6 +165,8 @@ static struct QIGVMHandler handlers[] = {
       qigvm_directive_snp_id_block },
     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
       qigvm_initialization_guest_policy },
+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
+      qigvm_directive_madt },
 };
 
 static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
@@ -771,6 +776,33 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
     return 0;
 }
 
+static int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data,
+                                Error **errp)
+{
+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
+    QIgvmParameterData *param_entry;
+    int result = 0;
+
+    /* Find the parameter area that should hold the MADT data */
+    param_entry = qigvm_find_param_entry(ctx, param);
+    if (param_entry != NULL) {
+
+        GArray *madt = acpi_build_madt_standalone(ctx->machine_state);
+
+        if (madt->len <= param_entry->size) {
+            memcpy(param_entry->data, madt->data, madt->len);
+        } else {
+            error_setg(
+                errp,
+                "IGVM: MADT size exceeds parameter area defined in IGVM file");
+            result = -1;
+        }
+
+        g_array_free(madt, true);
+    }
+    return result;
+}
+
 static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
 {
     int32_t header_count;
-- 
2.52.0


