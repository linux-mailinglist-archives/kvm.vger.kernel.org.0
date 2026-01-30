Return-Path: <kvm+bounces-69678-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHPrOixGfGnfLgIAu9opvQ
	(envelope-from <kvm+bounces-69678-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5B7B76DC
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6726301DC15
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16694374756;
	Fri, 30 Jan 2026 05:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bK/kdiw/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE66F19E819
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752101; cv=none; b=lnF5afZ2Fkh2Jx4nSZA7z9ezX436E0qkj7OEx1d3IJqiT5DAkMsl2OuR0zDZNtKAEp+7bAhD9M4Gs2Vsoleu8feXhVyo6/1aw1ELbuuuMRPC5+MbRoURqxm+YUp3ELcF+S/dmqJctVtqXRwGy4xxcJ5E1aTI7i7gxL/vaB+hv3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752101; c=relaxed/simple;
	bh=2HLylPNnfjclDGPEUhDVJTDcNCxiWRHrp64fYCir/R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfNAMxjwe+I8PyBOEH/+j4Hg3JLkWDdRkDHeThGqWoT33WbrL1BKxNSs3QR5bPJv6PIugW6w6ANMt73c9HHiCu+0LsxNVcll6FRl+y1uX6PFT3mMJPg12k/AZHfvix6GKl3vo8W6BG3ikiMZrxDIc5Xnmg/rsjMXTKUZBnGMV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bK/kdiw/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt0BDuzVfRRSqIs7smZlzqjo43w3EakTREOmpWDmELk=;
	b=bK/kdiw/VZHng43so3QvCmFPYQ/lkgGun9TlyZCIApDUc6aAMW2FJ9fSQwP8QTG3Z+rYId
	tMNUvOJpPAH4dmTDCzxCIKBDO7vCA90v2kVHGIipe5zLfIJ7ECmjt7WZeIggYICDLUj5+P
	QZFk1RDVCHtU2Cs+F65ujth7vRr3THk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-EMEZV-J_OB6emv7PXqe8lg-1; Fri,
 30 Jan 2026 00:48:17 -0500
X-MC-Unique: EMEZV-J_OB6emv7PXqe8lg-1
X-Mimecast-MFC-AGG-ID: EMEZV-J_OB6emv7PXqe8lg_1769752096
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38BFD1954B1B;
	Fri, 30 Jan 2026 05:48:16 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3EFA19560A2;
	Fri, 30 Jan 2026 05:48:10 +0000 (UTC)
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
Subject: [PATCH v6 9/9] igvm: Fill MADT IGVM parameter field on x86_64
Date: Fri, 30 Jan 2026 06:47:14 +0100
Message-ID: <20260130054714.715928-10-osteffen@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,intel.com,habkost.net,vger.kernel.org,linaro.org,amd.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69678-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,gitlab.com:url]
X-Rspamd-Queue-Id: 8C5B7B76DC
X-Rspamd-Action: no action

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

The IGVM parameter handler is implemented for the i386 machine target
and stubbed for all others.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c                |  2 ++
 include/system/igvm-internal.h |  5 +++++
 stubs/igvm.c                   |  6 ++++++
 target/i386/igvm.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/backends/igvm.c b/backends/igvm.c
index 3e7c0ea41d..b01a19ba46 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -128,6 +128,8 @@ static struct QIGVMHandler handlers[] = {
       qigvm_directive_snp_id_block },
     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
       qigvm_initialization_guest_policy },
+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
+      qigvm_directive_madt },
 };
 
 static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index 1d36519ab0..38004bd908 100644
--- a/include/system/igvm-internal.h
+++ b/include/system/igvm-internal.h
@@ -74,4 +74,9 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp);
 QIgvmParameterData*
 qigvm_find_param_entry(QIgvm *igvm, uint32_t parameter_area_index);
 
+/*
+ *  IGVM parameter handlers
+ */
+int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data, Error **errp);
+
 #endif
diff --git a/stubs/igvm.c b/stubs/igvm.c
index 17cd1e903e..47d5130d9d 100644
--- a/stubs/igvm.c
+++ b/stubs/igvm.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 
 #include "system/igvm.h"
+#include "system/igvm-internal.h"
 
 int qigvm_x86_get_mem_map_entry(int index,
                                 ConfidentialGuestMemoryMapEntry *entry,
@@ -24,3 +25,8 @@ int qigvm_x86_set_vp_context(void *data, int index, Error **errp)
 {
     return -1;
 }
+
+int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data, Error **errp)
+{
+    return -1;
+}
diff --git a/target/i386/igvm.c b/target/i386/igvm.c
index 457c253b03..f41b498b89 100644
--- a/target/i386/igvm.c
+++ b/target/i386/igvm.c
@@ -13,7 +13,9 @@
 
 #include "cpu.h"
 #include "hw/i386/e820_memory_layout.h"
+#include "hw/i386/acpi-build.h"
 #include "system/igvm.h"
+#include "system/igvm-internal.h"
 
 struct IgvmNativeVpContextX64 {
     uint64_t rax;
@@ -178,3 +180,33 @@ void qigvm_x86_bsp_reset(CPUX86State *env)
 
     qigvm_x86_load_context(bsp_context, env);
 }
+
+/*
+ * Process MADT IGVM parameter
+ */
+int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data, Error **errp)
+{
+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
+    QIgvmParameterData *param_entry;
+    int result = 0;
+
+    /* Find the parameter area that should hold the MADT data */
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
+    }
+
+    GArray *madt = acpi_build_madt_standalone(ctx->machine_state);
+
+    if (madt->len <= param_entry->size) {
+        memcpy(param_entry->data, madt->data, madt->len);
+    } else {
+        error_setg(
+            errp,
+            "IGVM: MADT size exceeds parameter area defined in IGVM file");
+        result = -1;
+    }
+
+    g_array_free(madt, true);
+    return result;
+}
-- 
2.52.0


