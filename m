Return-Path: <kvm+bounces-69235-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGNVIFqOeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69235-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:07:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A21C0926F5
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CDC7D301D24F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF922E6CC8;
	Tue, 27 Jan 2026 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ao+Kr3wZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AF22DB7A4
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508240; cv=none; b=YD0KKuKiB9Igagc+h3hwGHj+5MX7FggsD3vSDrU+Q+uGfKEUnCnsuKB8gn5ba/w7e/17geRWuk19wiX/Y+TAigs9tgAxcGtkzXbmn7yKgsrq6f6O++pNKgR3z50t5uOjNEmjmvEWJDSeE7yEQA6431vjYOtGkzRVm0Nm7luVo18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508240; c=relaxed/simple;
	bh=bAt515GjteXmABY8GIFIJAUUw7sYBBmvJliD8A0VHX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWzqpv0V8Xgg24ezaNLVuXJJxbK5+5xLtyknXoil5JqiJ/8Pn/BKED85jiaY68Q/rO9btwhFOe6EvKzZ/obGuNw+ZSjvzPdYkvuLGtsmb+aF5pSuKX40GCOg0zXtmSNo2kitmtSJEqxrBwDyqg4vWOHLTVQkrxEDgGmLKgTtGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ao+Kr3wZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769508237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78qEYGxPGWEZJXeutuZiOnK8kpP41OBXgXR3DQZ5n0c=;
	b=ao+Kr3wZYr9rd+lyRfuqxp2ust/ckFk9DLj1wrp/ELndoxjUgO1DwOEseOwF75nCsHboq9
	edwDLOODMR4le34W1YwuM+i4sJWyfzCewfl6WumL+6LaAW4VpnJl/uPCsLKl+PWTSe7SOl
	cxZuzxNh6swN8O34+A/U89iNEUxB5us=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-iPqbXcF-PBmbKc4lB7fTYg-1; Tue,
 27 Jan 2026 05:03:42 -0500
X-MC-Unique: iPqbXcF-PBmbKc4lB7fTYg-1
X-Mimecast-MFC-AGG-ID: iPqbXcF-PBmbKc4lB7fTYg_1769508221
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14D521800365;
	Tue, 27 Jan 2026 10:03:41 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.44.34.174])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BB4A180049F;
	Tue, 27 Jan 2026 10:03:34 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v5 6/6] igvm: Fill MADT IGVM parameter field
Date: Tue, 27 Jan 2026 11:02:57 +0100
Message-ID: <20260127100257.1074104-7-osteffen@redhat.com>
In-Reply-To: <20260127100257.1074104-1-osteffen@redhat.com>
References: <20260127100257.1074104-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69235-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A21C0926F5
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

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/backends/igvm.c b/backends/igvm.c
index f26eb633f8..1d8f807cf6 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -21,6 +21,7 @@
 #include "system/memory.h"
 #include "system/address-spaces.h"
 #include "hw/core/cpu.h"
+#include "hw/i386/acpi-build.h"
 
 #include "trace.h"
 
@@ -138,6 +139,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
 static int qigvm_initialization_guest_policy(QIgvm *ctx,
                                        const uint8_t *header_data,
                                        Error **errp);
+static int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data,
+                                Error **errp);
 
 struct QIGVMHandler {
     uint32_t type;
@@ -166,6 +169,8 @@ static struct QIGVMHandler handlers[] = {
       qigvm_directive_snp_id_block },
     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
       qigvm_initialization_guest_policy },
+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
+      qigvm_directive_madt },
 };
 
 static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
@@ -779,6 +784,34 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
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
+
 static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
 {
     int32_t header_count;
-- 
2.52.0


