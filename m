Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39A24ABEB
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 02:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgHTAOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 20:14:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728082AbgHTAOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 20:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597882459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7EkdIlxETPfIAzHkOFinRG+mYgIs7T56rbnwrgrdbzk=;
        b=L9r7TOfSa7U0D/tivPefChBdu2DFSo6+gohnUZjsweNmlqXfE/9HIrBSnsGcykgEIzg5xM
        knlYuObxOY5+qK43V+8UW0E1CRWagHbmMRhbiaNbH3a33754LzQig0zE7/Jqx6zb1XC4Gm
        u3xscLURMDVVa0KoqP8q5scC7Gi3a30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-P48DF9CMNx281CAIqhZFHA-1; Wed, 19 Aug 2020 20:14:17 -0400
X-MC-Unique: P48DF9CMNx281CAIqhZFHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADC0B8030A4;
        Thu, 20 Aug 2020 00:14:16 +0000 (UTC)
Received: from localhost (ovpn-117-244.rdu2.redhat.com [10.10.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7549C757C0;
        Thu, 20 Aug 2020 00:14:16 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 41/58] kvm: Move QOM macros to kvm.h
Date:   Wed, 19 Aug 2020 20:12:19 -0400
Message-Id: <20200820001236.1284548-42-ehabkost@redhat.com>
In-Reply-To: <20200820001236.1284548-1-ehabkost@redhat.com>
References: <20200820001236.1284548-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move QOM macros close to the KVMState typedef.

This will make future conversion to OBJECT_DECLARE* easier.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Changes series v1 -> v2: new patch in series v2

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: qemu-devel@nongnu.org
---
 include/sysemu/kvm.h     | 6 ++++++
 include/sysemu/kvm_int.h | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4174d941c..8445a88db1 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -17,6 +17,7 @@
 #include "qemu/queue.h"
 #include "hw/core/cpu.h"
 #include "exec/memattrs.h"
+#include "sysemu/accel.h"
 
 #ifdef NEED_CPU_H
 # ifdef CONFIG_KVM
@@ -199,7 +200,12 @@ typedef struct KVMCapabilityInfo {
 #define KVM_CAP_LAST_INFO { NULL, 0 }
 
 struct KVMState;
+
+#define TYPE_KVM_ACCEL ACCEL_CLASS_NAME("kvm")
 typedef struct KVMState KVMState;
+#define KVM_STATE(obj) \
+    OBJECT_CHECK(KVMState, (obj), TYPE_KVM_ACCEL)
+
 extern KVMState *kvm_state;
 typedef struct Notifier Notifier;
 
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index c660a70c51..65740806da 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -33,11 +33,6 @@ typedef struct KVMMemoryListener {
     int as_id;
 } KVMMemoryListener;
 
-#define TYPE_KVM_ACCEL ACCEL_CLASS_NAME("kvm")
-
-#define KVM_STATE(obj) \
-    OBJECT_CHECK(KVMState, (obj), TYPE_KVM_ACCEL)
-
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id);
 
-- 
2.26.2

