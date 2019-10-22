Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52446E0809
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbfJVP4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:56:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43834 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731793AbfJVP4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 11:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxjDNqjz6jOgBTYwePDqWFKfY8jBva/lRjE5JWzfDtc=;
        b=fEuYkPEy1w89k/6riNdh9t/R2SPvdU9utBShXUIVRfmxgeQhO32BlwdAXu+mZYAS44O/B0
        xR819bWO6PTDzTNxbGoDMjJ3BVILRlgM+9+2WFEoT3Nxfi7yxqSLydATMCrdj+iP2sApBU
        r8TnrDHYUZe3kZfyu7sF7amIbF3JS1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-jgCgPTQgNzy1hyZntvDYVA-1; Tue, 22 Oct 2019 11:56:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89ACC800D49;
        Tue, 22 Oct 2019 15:56:15 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70B1A5D6A9;
        Tue, 22 Oct 2019 15:56:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH kvm-unit-tests 1/4] x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
Date:   Tue, 22 Oct 2019 17:56:05 +0200
Message-Id: <20191022155608.8001-2-vkuznets@redhat.com>
In-Reply-To: <20191022155608.8001-1-vkuznets@redhat.com>
References: <20191022155608.8001-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jgCgPTQgNzy1hyZntvDYVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
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
index b6332fd57bbd..3b452749c2b3 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -161,11 +161,10 @@ static void stimer_isr_auto_eoi(isr_regs_t *regs)
=20
 static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
-                         u64 tick_100ns, int sint)
+                         u64 tick_100ns)
 {
     u64 config, count;
=20
-    timer->sint =3D sint;
     atomic_set(&timer->fire_count, 0);
=20
     config =3D 0;
@@ -173,7 +172,7 @@ static void stimer_start(struct stimer *timer,
         config |=3D HV_STIMER_PERIODIC;
     }
=20
-    config |=3D ((u8)(sint & 0xFF)) << 16;
+    config |=3D ((u8)(timer->sint & 0xFF)) << 16;
     config |=3D HV_STIMER_ENABLE;
     if (auto_enable) {
         config |=3D HV_STIMER_AUTOENABLE;
@@ -218,18 +217,29 @@ static void synic_disable(void)
=20
 static void stimer_test_prepare(void *ctx)
 {
+    int vcpu =3D smp_id();
+    struct svcpu *svcpu =3D &g_synic_vcpu[vcpu];
+    struct stimer *timer1, *timer2;
+
     write_cr3((ulong)ctx);
     synic_enable();
+
     synic_sint_create(SINT1_NUM, SINT1_VEC, false);
     synic_sint_create(SINT2_NUM, SINT2_VEC, true);
+
+    timer1 =3D &svcpu->timer[0];
+    timer2 =3D &svcpu->timer[1];
+
+    timer1->sint =3D SINT1_NUM;
+    timer2->sint =3D SINT2_NUM;
 }
=20
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
@@ -242,7 +252,7 @@ static void stimer_test_periodic(int vcpu, struct stime=
r *timer1,
 static void stimer_test_one_shot(int vcpu, struct stimer *timer)
 {
     /* Check one-shot timer */
-    stimer_start(timer, false, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, false, false, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
@@ -253,7 +263,7 @@ static void stimer_test_one_shot(int vcpu, struct stime=
r *timer)
 static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *time=
r)
 {
     /* Check auto-enable one-shot timer */
-    stimer_start(timer, true, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, true, false, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
@@ -264,7 +274,7 @@ static void stimer_test_auto_enable_one_shot(int vcpu, =
struct stimer *timer)
 static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *time=
r)
 {
     /* Check auto-enable periodic timer */
-    stimer_start(timer, true, true, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, true, true, ONE_MS_IN_100NS);
     while (atomic_read(&timer->fire_count) < 1000) {
         pause();
     }
@@ -280,7 +290,7 @@ static void stimer_test_one_shot_busy(int vcpu, struct =
stimer *timer)
     msg->header.message_type =3D HVMSG_TIMER_EXPIRED;
     wmb();
=20
-    stimer_start(timer, false, false, ONE_MS_IN_100NS, SINT1_NUM);
+    stimer_start(timer, false, false, ONE_MS_IN_100NS);
=20
     do
         rmb();
--=20
2.20.1

