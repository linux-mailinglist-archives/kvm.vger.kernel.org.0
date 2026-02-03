Return-Path: <kvm+bounces-70007-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMLqEmLkgWmDLQMAu9opvQ
	(envelope-from <kvm+bounces-70007-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABBDD8C13
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1F2A03033226
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10ED833EAF3;
	Tue,  3 Feb 2026 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gz0zckKg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015D433E350
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120252; cv=none; b=hAUl1U96eGWKSJRb63o+fG0OWCW2PmIZkj/JnpRiCO4/HYxYBGKqHyNGOBElqEhJPixAdjb2qncZHKI6vYQSMdQd6LUuqSOsodEtMY1+abCHWQjmizILdbK2agwcnFh3c5XaElMl6YHrpgz0KDKUB1jxdne7dzTTAjpNYp3ywEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120252; c=relaxed/simple;
	bh=OIdmoa7YQ8cwxdw0odTKLrrxRcL7Ihfbf6TF8HrWjqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htwZAgUzeLjxIP1nQHxNDbmuHMwVyvQqESiuJzGQIkknAR/1hMCUWrN9A2pF+vCGi9y1BJ6imtUKdgWf4+tiX+ALKd9XCaW76HdIqqQERhuCiI1nc8yWN6XNZ9qWmtyXjAkjRnnOX8DEjpVViIFqwguLQsyeBWraMX2sr8GN4us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gz0zckKg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiiY6hdAG4pbuPdzjGdEJ5gQuntuGsJCEg5mBLcgkBI=;
	b=gz0zckKggqTZwazCXrtWKIxSvgH5qXfalch2yTvPukwNb0IPO7yT3SnMv/VbQhD/xLZzfv
	JoqdUc2P5H7Dx+8NDYvvdDoti1gWJVPxitrID+XRsNIK5fbuj98bdpHg2+wCO5EG/HB192
	1VWPsX5NK82KIZSC+2qNTHlUQ8I8PFU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-F-2lWMMIOTunCZmJ-JDT_g-1; Tue,
 03 Feb 2026 07:04:06 -0500
X-MC-Unique: F-2lWMMIOTunCZmJ-JDT_g-1
X-Mimecast-MFC-AGG-ID: F-2lWMMIOTunCZmJ-JDT_g_1770120245
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6738F1956054;
	Tue,  3 Feb 2026 12:04:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD8C81800947;
	Tue,  3 Feb 2026 12:04:04 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 7ED951826269; Tue, 03 Feb 2026 13:03:44 +0100 (CET)
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
	Oliver Steffen <osteffen@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PULL 14/17] igvm: Refactor qigvm_parameter_insert
Date: Tue,  3 Feb 2026 13:03:39 +0100
Message-ID: <20260203120343.656961-15-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70007-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 1ABBDD8C13
X-Rspamd-Action: no action

From: Oliver Steffen <osteffen@redhat.com>

Use qigvm_find_param_entry() also in qigvm_parameter_insert().
This changes behavior: Processing now stops after the first parameter
entry found. That is OK, because we expect only one matching entry
anyway.

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Oliver Steffen <osteffen@redhat.com>
Message-ID: <20260130054714.715928-7-osteffen@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 backends/igvm.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/backends/igvm.c b/backends/igvm.c
index ea3f9d6b008f..ffd1c325b661 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -476,31 +476,31 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
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
+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
+    if (param_entry == NULL) {
+        return 0;
+    }
 
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


