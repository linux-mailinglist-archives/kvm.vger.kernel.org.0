Return-Path: <kvm+bounces-65914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D45CBA19F
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 53305301B5B1
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572F31A00F0;
	Sat, 13 Dec 2025 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Of/hHykI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C836C1A9FAF
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584899; cv=none; b=ZEdFgzlKKxOiD4xO1ThV1CRL7YwYp+eMH6qol8jyZiTscJDm2xmvxaEXExYCfjhDYTQhpFQR5iu+c0RvY5GYpf05t2VWOmyu1ojWiPZjnLBS4ww1aNJPtaMAl2Vd3992kZGbEVmo38PLQkFIYBAC4XGiqOLO3d1/+AoeakRlljw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584899; c=relaxed/simple;
	bh=g2C+HzJoFJ/Keba0BfTfrWJKHhFGqnaSsLiyLfePH7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adf3U8HK486W3p94gdPp8EEYkb6Z/baanXl836b5+P4TRurye6Yd9yRTnILOeaaQc9zxDK7pv/nx2XHC4p4BfXdMeuuAWCimov7bc4Dzm05iLwt4T487Mt5iZqtiOHDUOVEfOyBaZPFs5kZk9Cms4dWITSa6tXicSYZdNk1rxyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Of/hHykI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac8137d45so1077065a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584897; x=1766189697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0/im7YjCCi+qgN9Vco+Ebkxox6sDC/emBzqJ0iO8yU=;
        b=Of/hHykIJgG7mulCV8OUD3JJQHN22dL2OFUNdIoroqxdCLo8WFYW25ZFCudCHikI8a
         9mdTEkjPzeXSL5aga4FykGj/oEgdQSgcS5iUuE36xZq4atH6HPVPKTHz2Eh102YvVfTw
         H1KbFcPrmuWm6x1PeqyRChGV9zX0TF0lGF0xUWoXN/FQzFt6mr3hULNP8wttP8TKUSmk
         /BGJ7TzwsO7DNn+JS45AemaDysIPxPaLD3lShxQ+g5RQ11qwPGlQtn0K7aI2fvinOBh/
         hipUXwsujlEdFo/rVzDbiC0ByOb60jZtWeIHfdx2IDE6h27GpGAuQD8diGLK3GePuMt5
         7Taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584897; x=1766189697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0/im7YjCCi+qgN9Vco+Ebkxox6sDC/emBzqJ0iO8yU=;
        b=oNVYxMGv/+OzivFQ/nsjOK8SqCPGWka1tVvmSq9eOpGxGPh6jqqdb5uHkQ8s4G/Zl8
         FUvSbp/WtKwb5/kj0Y22aYFqE3UJyWe8zjFWQPxEp2Jg2zFQ3cZRrWqBiP2ZjqsLbLOF
         WZUM72nH9g2jdzfZN3nUB4cZf8dkVDhD9CrZY/Ayh+0SlaKuAK63pRJzJDSQd31ABkFF
         rgTcVbyyNkDFiJSuU2qSOKpOER7cbF5eaAutXNBS7JMkjXjpbT00KAy9cQ62EolI1WJM
         wyorxigr9jqJXmuHH8gUJWadNv+mWNsBPg50Tl8+i6V6p519RY9OnBK+BwrZjS7sUdlH
         zxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPH+ewqAp5bQQU4gb9bC3IPwY9ow2OnIXQJM0+1pmwL2zsVx3/t/NRk/VbJFmFB12q2YA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRq3gVBpuzrgKv9zWL5SOzuGBoRQrmro5YsSoXwM1kV4+1bYFI
	od219oK8FL+IuuTeUsn5XeRhgzBV4/EdSYp1PoZ5FXz/6RmG8iVGfpHkWfGiuQVl2v1c8De/5R7
	7b61r2Se5aJCTKX2erlN5Rw==
X-Google-Smtp-Source: AGHT+IGP+nbj+TPXEpjND5WvAvwQyuoZEIuskWGCKNVI2224dHhTfkISQO4miX5JQWLAWdIhcNFv/TjfUJgNAbxi
X-Received: from dlbcj13.prod.google.com ([2002:a05:7022:698d:b0:11a:51f9:d69])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:b886:b0:11d:ef84:6cff with SMTP id a92af1059eb24-11f34c56ff8mr2376497c88.37.1765584896801;
 Fri, 12 Dec 2025 16:14:56 -0800 (PST)
Date: Sat, 13 Dec 2025 00:14:43 +0000
In-Reply-To: <20251213001443.2041258-1-marcmorcos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251213001443.2041258-1-marcmorcos@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251213001443.2041258-5-marcmorcos@google.com>
Subject: [PATCH 4/4] apic: Make apicbase accesses atomic to fix data race
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

A data race on APICCommonState->apicbase was detected by ThreadSanitizer.

To resolve this race, direct accesses to s->apicbase are converted
to use the appropriate qatomic_*__nocheck() atomic operations. This
ensures that reads and writes are properly ordered and visible across threads.

This patch depends on the previous commit changing the type of `apicbase`
to `uint64_t`.

The race was identified by the following TSAN report:

==================
WARNING: ThreadSanitizer: data race
  Read of size 8 at ... by main thread:
    #0 cpu_is_apic_enabled hw/intc/apic_common.c:75:15
    ...
    #15 main_loop_wait util/main-loop.c:600:5
    ...

  Previous write of size 8 at ... by thread T7 'CPU 0/KVM':
    #0 kvm_apic_set_base hw/i386/kvm/apic.c:101:17
    #1 cpu_set_apic_base hw/intc/apic_common.c:47:16
    #2 kvm_arch_post_run target/i386/kvm/kvm.c:5621:5
    #3 kvm_cpu_exec accel/kvm/kvm-all.c:3229:17
    #4 kvm_vcpu_thread_fn accel/kvm/kvm-accel-ops.c:51:17
    ...
SUMMARY: ThreadSanitizer: data race hw/intc/apic_common.c:75:15 in cpu_is_apic_enabled
==================

Signed-off-by: Marc Morcos <marcmorcos@google.com>
---
 hw/i386/kvm/apic.c    | 12 ++++++++----
 hw/intc/apic_common.c | 20 ++++++++++++--------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 82355f0463..b9b03c529f 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -34,9 +34,10 @@ static inline uint32_t kvm_apic_get_reg(struct kvm_lapic_state *kapic,
 static void kvm_put_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic)
 {
     int i;
+    uint64_t apicbase = qatomic_read__nocheck(&s->apicbase);
 
     memset(kapic, 0, sizeof(*kapic));
-    if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
+    if (kvm_has_x2apic_api() && apicbase & MSR_IA32_APICBASE_EXTD) {
         kvm_apic_set_reg(kapic, 0x2, s->initial_apic_id);
     } else {
         kvm_apic_set_reg(kapic, 0x2, s->id << 24);
@@ -63,8 +64,9 @@ static void kvm_put_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic
 void kvm_get_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic)
 {
     int i, v;
+    uint64_t apicbase = qatomic_read__nocheck(&s->apicbase);
 
-    if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
+    if (kvm_has_x2apic_api() && apicbase & MSR_IA32_APICBASE_EXTD) {
         assert(kvm_apic_get_reg(kapic, 0x2) == s->initial_apic_id);
     } else {
         s->id = kvm_apic_get_reg(kapic, 0x2) >> 24;
@@ -97,7 +99,7 @@ void kvm_get_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic)
 
 static int kvm_apic_set_base(APICCommonState *s, uint64_t val)
 {
-    s->apicbase = val;
+    qatomic_set__nocheck(&s->apicbase, val);
     return 0;
 }
 
@@ -140,12 +142,14 @@ static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
     APICCommonState *s = data.host_ptr;
     struct kvm_lapic_state kapic;
     int ret;
+    uint64_t apicbase;
 
     if (is_tdx_vm()) {
         return;
     }
 
-    kvm_put_apicbase(s->cpu, s->apicbase);
+    apicbase = qatomic_read__nocheck(&s->apicbase);
+    kvm_put_apicbase(s->cpu, apicbase);
     kvm_put_apic_state(s, &kapic);
 
     ret = kvm_vcpu_ioctl(CPU(s->cpu), KVM_SET_LAPIC, &kapic);
diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 1e9aba2e48..9e42189d8a 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -19,6 +19,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/atomic.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
@@ -52,8 +53,9 @@ int cpu_set_apic_base(APICCommonState *s, uint64_t val)
 uint64_t cpu_get_apic_base(APICCommonState *s)
 {
     if (s) {
-        trace_cpu_get_apic_base((uint64_t)s->apicbase);
-        return s->apicbase;
+        uint64_t apicbase = qatomic_read__nocheck(&s->apicbase);
+        trace_cpu_get_apic_base(apicbase);
+        return apicbase;
     } else {
         trace_cpu_get_apic_base(MSR_IA32_APICBASE_BSP);
         return MSR_IA32_APICBASE_BSP;
@@ -66,7 +68,7 @@ bool cpu_is_apic_enabled(APICCommonState *s)
         return false;
     }
 
-    return s->apicbase & MSR_IA32_APICBASE_ENABLE;
+    return qatomic_read__nocheck(&s->apicbase) & MSR_IA32_APICBASE_ENABLE;
 }
 
 void cpu_set_apic_tpr(APICCommonState *s, uint8_t val)
@@ -223,9 +225,9 @@ void apic_designate_bsp(APICCommonState *s, bool bsp)
     }
 
     if (bsp) {
-        s->apicbase |= MSR_IA32_APICBASE_BSP;
+        qatomic_fetch_or(&s->apicbase, MSR_IA32_APICBASE_BSP);
     } else {
-        s->apicbase &= ~MSR_IA32_APICBASE_BSP;
+        qatomic_fetch_and(&s->apicbase, ~MSR_IA32_APICBASE_BSP);
     }
 }
 
@@ -235,8 +237,9 @@ static void apic_reset_common(DeviceState *dev)
     APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
     uint64_t bsp;
 
-    bsp = s->apicbase & MSR_IA32_APICBASE_BSP;
-    s->apicbase = APIC_DEFAULT_ADDRESS | bsp | MSR_IA32_APICBASE_ENABLE;
+    bsp = qatomic_read__nocheck(&s->apicbase) & MSR_IA32_APICBASE_BSP;
+    qatomic_set__nocheck(&s->apicbase,
+                    APIC_DEFAULT_ADDRESS | bsp | MSR_IA32_APICBASE_ENABLE);
     s->id = s->initial_apic_id;
 
     kvm_reset_irq_delivered();
@@ -405,7 +408,8 @@ static void apic_common_get_id(Object *obj, Visitor *v, const char *name,
     APICCommonState *s = APIC_COMMON(obj);
     uint32_t value;
 
-    value = s->apicbase & MSR_IA32_APICBASE_EXTD ? s->initial_apic_id : s->id;
+    value = qatomic_read__nocheck(&s->apicbase) & MSR_IA32_APICBASE_EXTD ?
+            s->initial_apic_id : s->id;
     visit_type_uint32(v, name, &value, errp);
 }
 
-- 
2.52.0.239.gd5f0c6e74e-goog


