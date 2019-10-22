Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDCE080A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbfJVP4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:56:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732102AbfJVP4X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HwWNwqQCGJ1DyywdmN78ZmdO5Ux8y6pN40V9oQ24TcE=;
        b=Zk01PFlRWNQN1PQuM8qJap+/Kq5NuLhOoH+9P+u8qh+7IBph+KI6leNJeWMkTyiUf/W2s5
        iiBgFRrY52ISWkA7qOqr2PyCxFdNUvsDx9y/iPJOoI0heefQl6xyMKmJ+5cMXOEvkI6ps1
        HUzUNRPVaeaEtfCwHbmGK62b8yF5LjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-TUWr0C-aO8WHTmj900UgZA-1; Tue, 22 Oct 2019 11:56:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F49E107AD31;
        Tue, 22 Oct 2019 15:56:18 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D37005D6A9;
        Tue, 22 Oct 2019 15:56:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH kvm-unit-tests 2/4] x86: hyperv_stimer: define union hv_stimer_config
Date:   Tue, 22 Oct 2019 17:56:06 +0200
Message-Id: <20191022155608.8001-3-vkuznets@redhat.com>
In-Reply-To: <20191022155608.8001-1-vkuznets@redhat.com>
References: <20191022155608.8001-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: TUWr0C-aO8WHTmj900UgZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to enabling direct synthetic timers properly define
hv_stimer_config.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        | 22 +++++++++++++++++-----
 x86/hyperv_stimer.c | 21 ++++++++-------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index e135221fa28a..9a83da483467 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -60,11 +60,23 @@
 #define HV_SYNIC_SINT_VECTOR_MASK               (0xFF)
 #define HV_SYNIC_SINT_COUNT                     16
=20
-#define HV_STIMER_ENABLE                (1ULL << 0)
-#define HV_STIMER_PERIODIC              (1ULL << 1)
-#define HV_STIMER_LAZY                  (1ULL << 2)
-#define HV_STIMER_AUTOENABLE            (1ULL << 3)
-#define HV_STIMER_SINT(config)          (__u8)(((config) >> 16) & 0x0F)
+/*
+ * Synthetic timer configuration.
+ */
+union hv_stimer_config {
+=09u64 as_uint64;
+=09struct {
+=09=09u64 enable:1;
+=09=09u64 periodic:1;
+=09=09u64 lazy:1;
+=09=09u64 auto_enable:1;
+=09=09u64 apic_vector:8;
+=09=09u64 direct_mode:1;
+=09=09u64 reserved_z0:3;
+=09=09u64 sintx:4;
+=09=09u64 reserved_z1:44;
+=09};
+};
=20
 #define HV_SYNIC_STIMER_COUNT           (4)
=20
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 3b452749c2b3..6f72205d97c0 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -163,20 +163,15 @@ static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
                          u64 tick_100ns)
 {
-    u64 config, count;
+    u64 count;
+    union hv_stimer_config config =3D {.as_uint64 =3D 0};
=20
     atomic_set(&timer->fire_count, 0);
=20
-    config =3D 0;
-    if (periodic) {
-        config |=3D HV_STIMER_PERIODIC;
-    }
-
-    config |=3D ((u8)(timer->sint & 0xFF)) << 16;
-    config |=3D HV_STIMER_ENABLE;
-    if (auto_enable) {
-        config |=3D HV_STIMER_AUTOENABLE;
-    }
+    config.periodic =3D periodic;
+    config.enable =3D 1;
+    config.auto_enable =3D auto_enable;
+    config.sintx =3D timer->sint;
=20
     if (periodic) {
         count =3D tick_100ns;
@@ -186,9 +181,9 @@ static void stimer_start(struct stimer *timer,
=20
     if (!auto_enable) {
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64=
);
     } else {
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64=
);
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
     }
 }
--=20
2.20.1

