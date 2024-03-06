Return-Path: <kvm+bounces-11185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3758873D56
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 306F01F26B5B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E2913BAE7;
	Wed,  6 Mar 2024 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FmgSsf5S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3205D8F0
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745547; cv=none; b=MX3xc4g9OvexFmp3ZjwdqhUMyJ9JZrvH4KNlJRJXb08NDKQqZ+zS3w4IpH3a8vcDNM7E3VhUhl/l+Ci6mwZPsF92MD2GawXY80stxHP62hHqKzSw5OhU2ert+nXgCoaSHNOF8Pg3+gCfvDYjDE023vWptsnhNa7CJMMY3UXzOqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745547; c=relaxed/simple;
	bh=w0RM1ha67gutDct3bcJ5CAWfi4LV86a0498a3gv08EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRO3PfVKKmtIuQcSaWuJIH74+of38gfotf/fXeuDkPu1+oemmgsNfGfITC+GY+Cz9J3uSbd/f69iG4BfgbmgnDIwn2SS7xIOGGgr9hEdjOMeW3oaHr1xrW6opzB3gjkDCGAQ6VTH7RCQuufyOIjNUgsDjUzBcYFRc/oYOpRJkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FmgSsf5S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tSQuJ13buQyGoy3R6iX2AL9wFy5gOmEWHO/Auop62Ns=;
	b=FmgSsf5SZuyBszhCqno9o7IFOnrT6F7t7CAezJkUcUqAxtwFa5T+fcJrRg/AyDKTEWd4FN
	js9crI0Av6bkA6kXdmy3ClyzGVQX9rXexcAFo9AORXgeDCTlvWH6qVMmMdOxz+byckOutr
	eNkYeeoEQ53/QXht3ZAi0f6Vb9F+7T4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-tc5FyA3iPkSJ20ulLc1BHw-1; Wed, 06 Mar 2024 12:18:44 -0500
X-MC-Unique: tc5FyA3iPkSJ20ulLc1BHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F7608007A7;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA38240C6CB8;
	Wed,  6 Mar 2024 17:18:33 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 10/13] x86: hyperv_stimer: define union hv_stimer_config
Date: Wed,  6 Mar 2024 18:18:20 +0100
Message-ID: <20240306171823.761647-11-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

As a preparation to enabling direct synthetic timers properly define
hv_stimer_config.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        | 22 +++++++++++++++++-----
 x86/hyperv_stimer.c | 21 ++++++++-------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index 3e1723ee9609..2fc70e561ef2 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -60,11 +60,23 @@
 #define HV_SYNIC_SINT_VECTOR_MASK               (0xFF)
 #define HV_SYNIC_SINT_COUNT                     16
 
-#define HV_STIMER_ENABLE                (1ULL << 0)
-#define HV_STIMER_PERIODIC              (1ULL << 1)
-#define HV_STIMER_LAZY                  (1ULL << 2)
-#define HV_STIMER_AUTOENABLE            (1ULL << 3)
-#define HV_STIMER_SINT(config)          (__u8)(((config) >> 16) & 0x0F)
+/*
+ * Synthetic timer configuration.
+ */
+union hv_stimer_config {
+	u64 as_uint64;
+	struct {
+		u64 enable:1;
+		u64 periodic:1;
+		u64 lazy:1;
+		u64 auto_enable:1;
+		u64 apic_vector:8;
+		u64 direct_mode:1;
+		u64 reserved_z0:3;
+		u64 sintx:4;
+		u64 reserved_z1:44;
+	};
+};
 
 #define HV_SYNIC_STIMER_COUNT           (4)
 
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index f4eb9f2bb158..0b9ec7a5b1b4 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -163,20 +163,15 @@ static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
                          u64 tick_100ns)
 {
-    u64 config, count;
+    u64 count;
+    union hv_stimer_config config = {.as_uint64 = 0};
 
     atomic_set(&timer->fire_count, 0);
 
-    config = 0;
-    if (periodic) {
-        config |= HV_STIMER_PERIODIC;
-    }
-
-    config |= ((u8)(timer->sint & 0xFF)) << 16;
-    config |= HV_STIMER_ENABLE;
-    if (auto_enable) {
-        config |= HV_STIMER_AUTOENABLE;
-    }
+    config.periodic = periodic;
+    config.enable = 1;
+    config.auto_enable = auto_enable;
+    config.sintx = timer->sint;
 
     if (periodic) {
         count = tick_100ns;
@@ -186,9 +181,9 @@ static void stimer_start(struct stimer *timer,
 
     if (!auto_enable) {
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64);
     } else {
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64);
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
     }
 }
-- 
2.44.0


