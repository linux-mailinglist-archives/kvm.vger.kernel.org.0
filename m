Return-Path: <kvm+bounces-11181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEC2873D52
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB769B25E70
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C28613E7D6;
	Wed,  6 Mar 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBjrpXfK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F213E7DF
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745519; cv=none; b=Hf7oiEOAGIqimdIN+Zic/NgR9WDj/zdar+BJThiPW/MAGUEug9HTLR3vjzMgFvjEl9ACyuQ13C2F7zWvwEX3xj10GXBe6P5LcxaqUmkVWUFO79pm363SU1kdAtR6dvQjsP2cQXI46KhNcohAlrEXVENo7/0p+6uk/t6sB2PJnN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745519; c=relaxed/simple;
	bh=0IgqP6tgK7lozLXAvAEhq217gI7wM1cjVK1BYqFteI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G6SqIYqU357hcWaa4VdJr30vuqSfzYsz0ByqdyFLemYLEfhod2nJC47lmxEhSvNoWkVcmCmeiDblamim0zeQF2JkWAKb6AJGunD7HqFpYq2ikxjfcJfBV+b8xiYe0+lt2Q2NNG3ub7qf5f72Iuiwd0vnLxG/eqt5nMIWNR30e20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBjrpXfK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NED6zmLfQ1yu+Vcg4qkQB+5/dEnMoeAlK1kFnv7QLxw=;
	b=YBjrpXfK9zqKxseks9QD21CMyOa3Pf3Mbw6pqEIOaCIwmZGlZDAFoikUX+YjngqaC/6rBg
	sefJHN3kKVmhaaM4P1bHnqCx04LGWpJlhaYyjb/5QUi26hBgR5trOITUS2kuVPJ/GvjtM8
	ndqKCrsk+SRD1DB4WQ3/sVPMOH/x/ZE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-vWlfUxpmMg6AHM5oR4HMEg-1; Wed,
 06 Mar 2024 12:18:33 -0500
X-MC-Unique: vWlfUxpmMg6AHM5oR4HMEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94FF729AA390;
	Wed,  6 Mar 2024 17:18:33 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF36140C6CB8;
	Wed,  6 Mar 2024 17:18:32 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 09/13] x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
Date: Wed,  6 Mar 2024 18:18:19 +0100
Message-ID: <20240306171823.761647-10-vkuznets@redhat.com>
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

As a preparation to enabling direct synthetic timers support stop
passing SINT number to stimer_start.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_stimer.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 9259e28c6a90..f4eb9f2bb158 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -161,11 +161,10 @@ static void stimer_isr_auto_eoi(isr_regs_t *regs)
 
 static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
-                         u64 tick_100ns, int sint)
+                         u64 tick_100ns)
 {
     u64 config, count;
 
-    timer->sint = sint;
     atomic_set(&timer->fire_count, 0);
 
     config = 0;
@@ -173,7 +172,7 @@ static void stimer_start(struct stimer *timer,
         config |= HV_STIMER_PERIODIC;
     }
 
-    config |= ((u8)(sint & 0xFF)) << 16;
+    config |= ((u8)(timer->sint & 0xFF)) << 16;
     config |= HV_STIMER_ENABLE;
     if (auto_enable) {
         config |= HV_STIMER_AUTOENABLE;
@@ -218,18 +217,29 @@ static void synic_disable(void)
 
 static void stimer_test_prepare(void *ctx)
 {
+    int vcpu = smp_id();
+    struct svcpu *svcpu = &g_synic_vcpu[vcpu];
+    struct stimer *timer1, *timer2;
+
     write_cr3((ulong)ctx);
     synic_enable();
+
     synic_sint_create(SINT1_NUM, SINT1_VEC, false);
     synic_sint_create(SINT2_NUM, SINT2_VEC, true);
+
+    timer1 = &svcpu->timer[0];
+    timer2 = &svcpu->timer[1];
+
+    timer1->sint = SINT1_NUM;
+    timer2->sint = SINT2_NUM;
 }
 
 static void stimer_test_periodic(int vcpu, struct stimer *timer1,
                                  struct stimer *timer2)
 {
     /* Check periodic timers */
-    stimer_start(timer1, false, true, ONE_MS_IN_100NS, SINT1_NUM);
-    stimer_start(timer2, false, true, ONE_MS_IN_100NS, SINT2_NUM);
+    stimer_start(timer1, false, true, ONE_MS_IN_100NS);
+    stimer_start(timer2, false, true, ONE_MS_IN_100NS);
     while ((atomic_read(&timer1->fire_count) < 1000) ||
            (atomic_read(&timer2->fire_count) < 1000)) {
         pause();
@@ -242,7 +252,7 @@ static void stimer_test_periodic(int vcpu, struct stimer *timer1,
 static void stimer_test_one_shot(int vcpu, struct stimer *timer)
 {
     /* Check one-shot timer */
-    stimer_start(timer, false, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, false, false, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
@@ -253,7 +263,7 @@ static void stimer_test_one_shot(int vcpu, struct stimer *timer)
 static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *timer)
 {
     /* Check auto-enable one-shot timer */
-    stimer_start(timer, true, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, true, false, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
@@ -264,7 +274,7 @@ static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *timer)
 static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
 {
     /* Check auto-enable periodic timer */
-    stimer_start(timer, true, true, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, true, true, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1000) {
         pause();
     }
@@ -280,7 +290,7 @@ static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
     msg->header.message_type = HVMSG_TIMER_EXPIRED;
     wmb();
 
-    stimer_start(timer, false, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, false, false, ONE_MS_IN_100NS);
 
     do
         rmb();
-- 
2.44.0


