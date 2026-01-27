Return-Path: <kvm+bounces-69233-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MHItA8COeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69233-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:09:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 711B19276E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D4F5308B3EC
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208C22E6CAB;
	Tue, 27 Jan 2026 10:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEQqgHbD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EE52E5418
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508216; cv=none; b=Sg1m4V7Zl2QJ85Mh6LmI9qYY0SfQ5ewyPocdilYENwSiO1QjKUM/dESm5iawrnB3YgrZ6JRAazjyGxv3y1PwrqmBVnPSG2CJ3G4Yl8grDSzrF4nzpxOSRf5Y4QAf0XKdlCYLig9P29an9+952i/UhdQUe/CXsrc4FfVRFX9b7Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508216; c=relaxed/simple;
	bh=5EhFf3HZ0isNEVaIX2EXwvLzeOWd3YRmlcMKmhkgQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkqpbkzNoawgVL1CvAk1VqbTMYQfLmjZsxO+fqx7ylNVOCJxCVxWtnHnF9yGgBX+ESZffHBy4wMLX6bxC5nMwhPkF9iNg+8d6spS1KMjAo1HhAkPMlWUzhNdHWM5RwWIVIfYV7cRoCEwFSQJTVZ6qPOaHOKOJ3sY+SbHkWOo9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEQqgHbD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769508214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lU8cfl9gCDqNxnMilRoV/PVgA412LlMd5AfMzj0nBzw=;
	b=ZEQqgHbDKkSgsVjM0ognHX68LVn09/IhqbnjtLbn/H6MEr0QwH+2R/ReOmtKlRdq9upyg/
	HIEUOGVKuLzKJiSR3R7OcnWEp991rtBV3nB9V94t2sHg+X+BnCk7a+vdBXHGVaiHcAHKtJ
	dW9alDrVWhqGmbaA3NYG7iT715dkbSk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-tdPfesTPMxOheGj8B1vzHg-1; Tue,
 27 Jan 2026 05:03:30 -0500
X-MC-Unique: tdPfesTPMxOheGj8B1vzHg-1
X-Mimecast-MFC-AGG-ID: tdPfesTPMxOheGj8B1vzHg_1769508209
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 145F11800614;
	Tue, 27 Jan 2026 10:03:29 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.44.34.174])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0D67C180066A;
	Tue, 27 Jan 2026 10:03:23 +0000 (UTC)
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
Subject: [PATCH v5 4/6] igvm: Refactor qigvm_parameter_insert
Date: Tue, 27 Jan 2026 11:02:55 +0100
Message-ID: <20260127100257.1074104-5-osteffen@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69233-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 711B19276E
X-Rspamd-Action: no action

Use qigvm_find_param_entry() also in qigvm_parameter_insert().
This changes behavior: Processing now stops after the first parameter
entry found. That is OK, because we expect only one matching entry
anyway.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 backends/igvm.c | 50 ++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index 213c9d337e..0a0092fb55 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -513,31 +513,31 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
         return 0;
     }
 
-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
-    {
-        if (param_entry->index == param->parameter_area_index) {
-            region = qigvm_prepare_memory(ctx, param->gpa, param_entry->size,
-                                          ctx->current_header_index, errp);
-            if (!region) {
-                return -1;
-            }
-            memcpy(region, param_entry->data, param_entry->size);
-            g_free(param_entry->data);
-            param_entry->data = NULL;
-
-            /*
-             * If a confidential guest support object is provided then use it to
-             * set the guest state.
-             */
-            if (ctx->cgs) {
-                result = ctx->cgsc->set_guest_state(param->gpa, region,
-                                                    param_entry->size,
-                                                    CGS_PAGE_TYPE_UNMEASURED, 0,
-                                                    errp);
-                if (result < 0) {
-                    return -1;
-                }
-            }
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
+    }
+
+    region = qigvm_prepare_memory(ctx, param->gpa, param_entry->size,
+                                    ctx->current_header_index, errp);
+    if (!region) {
+        return -1;
+    }
+    memcpy(region, param_entry->data, param_entry->size);
+    g_free(param_entry->data);
+    param_entry->data = NULL;
+
+    /*
+     * If a confidential guest support object is provided then use it to
+     * set the guest state.
+     */
+    if (ctx->cgs) {
+        result = ctx->cgsc->set_guest_state(param->gpa, region,
+                                            param_entry->size,
+                                            CGS_PAGE_TYPE_UNMEASURED, 0,
+                                            errp);
+        if (result < 0) {
+            return -1;
         }
     }
     return 0;
-- 
2.52.0


