Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82E0154908
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgBFQYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727518AbgBFQYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gazBEToOohskQvJ5e1gKVQYGWvoMk25IujSbSPiETqk=;
        b=YWw7pvkV8HYxDFJML7aG8aFWTELLCZ2IxzJcCHpz9fKpFqpdeDzDLCSTm//OXzhxSaU1HR
        O2yaNc8GMSEii0gVgQpV9VI8uXyfzynOtz1vB98D9q7XMTXqEmOYJMJbKhmwLhtHRhYu+n
        Y80B77goYPbAVG13Y1M9PuAHQuV9xcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-LMtNhphgP5WEt0EehdtWfQ-1; Thu, 06 Feb 2020 11:24:44 -0500
X-MC-Unique: LMtNhphgP5WEt0EehdtWfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39D7F1005F7F;
        Thu,  6 Feb 2020 16:24:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A7501001B05;
        Thu,  6 Feb 2020 16:24:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 03/10] arm64: timer: Add ISB after register writes
Date:   Thu,  6 Feb 2020 17:24:27 +0100
Message-Id: <20200206162434.14624-4-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

From ARM DDI 0487E.a glossary, the section "Context synchronization
event":

"All direct and indirect writes to System registers that are made before
the Context synchronization event affect any instruction, including a
direct read, that appears in program order after the instruction causing
the Context synchronization event."

The ISB instruction is a context synchronization event [1]. Add an ISB
after all register writes, to make sure that the writes have been
completed when we try to test their effects.

[1] ARM DDI 0487E.a, section C6.2.96

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f390e8e65d31..c6ea108cfa4b 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -41,6 +41,7 @@ static u64 read_vtimer_cval(void)
 static void write_vtimer_cval(u64 val)
 {
 	write_sysreg(val, cntv_cval_el0);
+	isb();
 }
=20
 static s32 read_vtimer_tval(void)
@@ -51,6 +52,7 @@ static s32 read_vtimer_tval(void)
 static void write_vtimer_tval(s32 val)
 {
 	write_sysreg(val, cntv_tval_el0);
+	isb();
 }
=20
 static u64 read_vtimer_ctl(void)
@@ -61,6 +63,7 @@ static u64 read_vtimer_ctl(void)
 static void write_vtimer_ctl(u64 val)
 {
 	write_sysreg(val, cntv_ctl_el0);
+	isb();
 }
=20
 static u64 read_ptimer_counter(void)
@@ -76,6 +79,7 @@ static u64 read_ptimer_cval(void)
 static void write_ptimer_cval(u64 val)
 {
 	write_sysreg(val, cntp_cval_el0);
+	isb();
 }
=20
 static s32 read_ptimer_tval(void)
@@ -86,6 +90,7 @@ static s32 read_ptimer_tval(void)
 static void write_ptimer_tval(s32 val)
 {
 	write_sysreg(val, cntp_tval_el0);
+	isb();
 }
=20
 static u64 read_ptimer_ctl(void)
@@ -96,6 +101,7 @@ static u64 read_ptimer_ctl(void)
 static void write_ptimer_ctl(u64 val)
 {
 	write_sysreg(val, cntp_ctl_el0);
+	isb();
 }
=20
 struct timer_info {
@@ -181,7 +187,6 @@ static bool test_cval_10msec(struct timer_info *info)
 	before_timer =3D info->read_counter();
 	info->write_cval(before_timer + time_10ms);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
=20
 	/* Wait for the timer to fire */
 	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
@@ -217,11 +222,9 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
 	report(!gic_timer_pending(info), "not pending before");
=20
 	info->write_cval(now - 1);
-	isb();
 	report(gic_timer_pending(info), "interrupt signal pending");
=20
 	/* Disable the timer again and prepare to take interrupts */
--=20
2.21.1

