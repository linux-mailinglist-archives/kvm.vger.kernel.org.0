Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00A33C7449
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhGMQWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhGMQWG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGIoWhWTdf6Sax8hktc53jnOBfQk1TJaNlNeCGFHgGw=;
        b=JqyQNukpnRLJFKXp8TSwjO0CguKBRfCl2KfDU2xwHcHw4/BoHEps/eHA4wDnXNJOSzyXWL
        Uun2YexSxNy+hD+/f2zBZBQVFDbKjb1mdTKVLecadBBP41I9ueAWfBTJG/JXSYm0YOq5Rg
        Mn7GewKg3ywqTXdsmKXk9YoJaB8qAIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-pFBUbuqTOWKI540AV4d75Q-1; Tue, 13 Jul 2021 12:19:15 -0400
X-MC-Unique: pFBUbuqTOWKI540AV4d75Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECD5B1B2C980;
        Tue, 13 Jul 2021 16:19:13 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B39CC60936;
        Tue, 13 Jul 2021 16:19:13 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 07/11] i386: Hyper-V SynIC requires POST_MESSAGES/SIGNAL_EVENTS privileges
Date:   Tue, 13 Jul 2021 12:09:53 -0400
Message-Id: <20210713160957.3269017-8-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

When Hyper-V SynIC is enabled, we may need to allow Windows guests to make
hypercalls (POST_MESSAGES/SIGNAL_EVENTS). No issue is currently observed
because KVM is very permissive, allowing these hypercalls regarding of
guest visible CPUid bits.

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210608120817.1325125-9-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm/hyperv-proto.h | 6 ++++++
 target/i386/kvm/kvm.c          | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/target/i386/kvm/hyperv-proto.h b/target/i386/kvm/hyperv-proto.h
index e30d64b4ade..5fbb385cc13 100644
--- a/target/i386/kvm/hyperv-proto.h
+++ b/target/i386/kvm/hyperv-proto.h
@@ -38,6 +38,12 @@
 #define HV_ACCESS_FREQUENCY_MSRS     (1u << 11)
 #define HV_ACCESS_REENLIGHTENMENTS_CONTROL  (1u << 13)
 
+/*
+ * HV_CPUID_FEATURES.EBX bits
+ */
+#define HV_POST_MESSAGES             (1u << 4)
+#define HV_SIGNAL_EVENTS             (1u << 5)
+
 /*
  * HV_CPUID_FEATURES.EDX bits
  */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index eee1a6b46ea..59ed8327ac1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1346,6 +1346,12 @@ static int hyperv_fill_cpuids(CPUState *cs,
     /* Unconditionally required with any Hyper-V enlightenment */
     c->eax |= HV_HYPERCALL_AVAILABLE;
 
+    /* SynIC and Vmbus devices require messages/signals hypercalls */
+    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
+        !cpu->hyperv_synic_kvm_only) {
+        c->ebx |= HV_POST_MESSAGES | HV_SIGNAL_EVENTS;
+    }
+
     /* Not exposed by KVM but needed to make CPU hotplug in Windows work */
     c->edx |= HV_CPU_DYNAMIC_PARTITIONING_AVAILABLE;
 
-- 
2.31.1

