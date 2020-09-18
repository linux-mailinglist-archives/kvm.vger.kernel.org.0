Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501FD27070A
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 22:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIRU2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 16:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbgIRU2F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 16:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600460883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L3cjk35aVUeH0V89TyoXg2jKoacEF7LRbN9bwQItQ+Q=;
        b=M058UFsO8uWiWIj6t7s+0UA+8M6YRJQ44I3HtfhxObxq9bLr8nvc5+UmrfjaXxbxcKrgLh
        chz5WQji/k/BnDhUMYzdH6i6X7xx2YgkFywpgQuoYAyER5fhGYcLVWW1CHwhHcMrGh7PNc
        hW/VYZecnv4izC9DNjPrtdMd7LUPL0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-WpF5Sl3BPxecuIy6bMKyFA-1; Fri, 18 Sep 2020 16:28:01 -0400
X-MC-Unique: WpF5Sl3BPxecuIy6bMKyFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 261861074646;
        Fri, 18 Sep 2020 20:28:00 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9995A10013C1;
        Fri, 18 Sep 2020 20:27:55 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 1/4] i386/kvm: correct the meaning of '0xffffffff' value for hv-spinlocks
Date:   Fri, 18 Sep 2020 16:27:47 -0400
Message-Id: <20200918202750.10358-2-ehabkost@redhat.com>
In-Reply-To: <20200918202750.10358-1-ehabkost@redhat.com>
References: <20200918202750.10358-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Hyper-V TLFS prior to version 6.0 had a mistake in it: special value
'0xffffffff' for CPUID 0x40000004.EBX was called 'never to retry', this
looked weird (like why it's not '0' which supposedly have the same effect?)
but nobody raised the question. In TLFS version 6.0 the mistake was
corrected to 'never notify' which sounds logical. Fix QEMU accordingly.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200515114847.74523-1-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 docs/hyperv.txt   | 2 +-
 target/i386/cpu.h | 4 ++--
 target/i386/cpu.c | 2 +-
 target/i386/kvm.c | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/docs/hyperv.txt b/docs/hyperv.txt
index 6518b716a9..5df00da54f 100644
--- a/docs/hyperv.txt
+++ b/docs/hyperv.txt
@@ -49,7 +49,7 @@ more efficiently. In particular, this enlightenment allows paravirtualized
 ======================
 Enables paravirtualized spinlocks. The parameter indicates how many times
 spinlock acquisition should be attempted before indicating the situation to the
-hypervisor. A special value 0xffffffff indicates "never to retry".
+hypervisor. A special value 0xffffffff indicates "never notify".
 
 3.4. hv-vpindex
 ================
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d3097be6a5..f519d2bfd4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -991,8 +991,8 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
 #define HYPERV_FEAT_IPI                 13
 #define HYPERV_FEAT_STIMER_DIRECT       14
 
-#ifndef HYPERV_SPINLOCK_NEVER_RETRY
-#define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
+#ifndef HYPERV_SPINLOCK_NEVER_NOTIFY
+#define HYPERV_SPINLOCK_NEVER_NOTIFY             0xFFFFFFFF
 #endif
 
 #define EXCP00_DIVZ	0
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 49d8958528..37725bd354 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7263,7 +7263,7 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
-                       HYPERV_SPINLOCK_NEVER_RETRY),
+                       HYPERV_SPINLOCK_NEVER_NOTIFY),
     DEFINE_PROP_BIT64("hv-relaxed", X86CPU, hyperv_features,
                       HYPERV_FEAT_RELAXED, 0),
     DEFINE_PROP_BIT64("hv-vapic", X86CPU, hyperv_features,
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index d87af57a23..9efb07e7c8 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -730,7 +730,7 @@ static bool hyperv_enabled(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
     return kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0 &&
-        ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_RETRY) ||
+        ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_NOTIFY) ||
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
 
@@ -1236,7 +1236,7 @@ static int hyperv_handle_properties(CPUState *cs,
             env->features[FEAT_HV_RECOMM_EAX] = c->eax;
 
             /* hv-spinlocks may have been overriden */
-            if (cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_RETRY) {
+            if (cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_NOTIFY) {
                 c->ebx = cpu->hyperv_spinlock_attempts;
             }
         }
-- 
2.26.2

