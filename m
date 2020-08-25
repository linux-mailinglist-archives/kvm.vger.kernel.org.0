Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6E251FDD
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgHYTWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbgHYTWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 15:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598383365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3i9Dto6wylUbRr2eIO0FnAXXH86Fg9jKOhIqiNdyqs=;
        b=WxfUEgHkEkXWoxn+McU4eh6/FY6A6HRgNJmjWwOPFlQYx4MpUIsThb6zxDDDCeEmDDFW/Y
        7garwIU5W9YaooikltL6Np8KMLHRFUt+xOmrx87i87jlCeRtWZgJMgkUSXr8dspLdFP4Uu
        3pNHfXK1zfSxbfnJYwyOz/ueBwID4FQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-94J20PfpM62dnTnVgTsdjA-1; Tue, 25 Aug 2020 15:22:43 -0400
X-MC-Unique: 94J20PfpM62dnTnVgTsdjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B42A01DDE0;
        Tue, 25 Aug 2020 19:22:42 +0000 (UTC)
Received: from localhost (unknown [10.10.67.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7568A5D9D3;
        Tue, 25 Aug 2020 19:22:42 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 41/74] kvm: Move QOM macros to kvm.h
Date:   Tue, 25 Aug 2020 15:20:37 -0400
Message-Id: <20200825192110.3528606-42-ehabkost@redhat.com>
In-Reply-To: <20200825192110.3528606-1-ehabkost@redhat.com>
References: <20200825192110.3528606-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move QOM macros close to the KVMState typedef.

This will make future conversion to OBJECT_DECLARE* easier.

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Changes v2 -> v3: none

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

