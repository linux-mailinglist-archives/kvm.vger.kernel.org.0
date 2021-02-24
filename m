Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96457324245
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhBXQjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:39:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235406AbhBXQhV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 11:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ul0Yt6zeiwAM8weYOyOSJ2OiEPiScZ2rMxR8/x//HFM=;
        b=GWJwJX4fvOpXLogQ5jfA0OnxicsIOGhgROOC2qozo7lolTq3HrxdaE+JaSETOqzPlMl9B8
        vvhMTKcJm7nm6cm5yNiFulMtuIypya5ypQxeVdOHpAxIoy15lSUA1KX/h1O4yIDTkimI69
        bqdEYpaE7X6nzZfHsRNsfR5Jgl/bGpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-wGC310LYMCSX2952f1eVjw-1; Wed, 24 Feb 2021 11:35:52 -0500
X-MC-Unique: wGC310LYMCSX2952f1eVjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D497BBEF3
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:35:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 265D419C71;
        Wed, 24 Feb 2021 16:35:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm-unit-tests v2 1/4] x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
Date:   Wed, 24 Feb 2021 17:35:44 +0100
Message-Id: <20210224163547.197100-2-vkuznets@redhat.com>
In-Reply-To: <20210224163547.197100-1-vkuznets@redhat.com>
References: <20210224163547.197100-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to enabling direct synthetic timers support stop
passing SINT number to stimer_start.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_stimer.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 75a69a127b4d..fa00dac4d66a 100644
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
@@ -265,7 +275,7 @@ static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *timer)
 static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
 {
     /* Check auto-enable periodic timer */
-    stimer_start(timer, true, true, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, true, true, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1000) {
         pause();
     }
@@ -282,7 +292,7 @@ static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
     msg->header.message_type = HVMSG_TIMER_EXPIRED;
     wmb();
 
-    stimer_start(timer, false, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, false, false, ONE_MS_IN_100NS);
 
     do
         rmb();
-- 
2.29.2

