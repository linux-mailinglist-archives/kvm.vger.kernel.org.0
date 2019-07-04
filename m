Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEED65F767
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 13:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfGDLsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 07:48:19 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:55268 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfGDLsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 07:48:17 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id D972EEECE78B6B671F1C;
        Thu,  4 Jul 2019 19:48:13 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x64BlpKl014390;
        Thu, 4 Jul 2019 19:47:51 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070419482202-2086634 ;
          Thu, 4 Jul 2019 19:48:22 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn, up2wing@gmail.com,
        wang.liang82@zte.com.cn
Subject: [PATCH 2/2] sched: fix unlikely use of sched_info_on()
Date:   Thu, 4 Jul 2019 19:46:15 +0800
Message-Id: <1562240775-16086-3-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
References: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-04 19:48:22,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-04 19:47:56,
        Serialize complete at 2019-07-04 19:47:56
X-MAIL: mse-fl2.zte.com.cn x64BlpKl014390
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sched_info_on() is called with unlikely hint, however, the test
is to be true when make defconfig. So replace unlikely with
likely.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 kernel/sched/stats.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index aa0de24..b7a7c4d 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -157,7 +157,7 @@ static inline void sched_info_dequeued(struct rq *rq, struct task_struct *t)
 {
 	unsigned long long now = rq_clock(rq), delta = 0;
 
-	if (unlikely(sched_info_on()))
+	if (likely(sched_info_on()))
 		if (t->sched_info.last_queued)
 			delta = now - t->sched_info.last_queued;
 	sched_info_reset_dequeued(t);
@@ -192,7 +192,7 @@ static void sched_info_arrive(struct rq *rq, struct task_struct *t)
  */
 static inline void sched_info_queued(struct rq *rq, struct task_struct *t)
 {
-	if (unlikely(sched_info_on())) {
+	if (likely(sched_info_on())) {
 		if (!t->sched_info.last_queued)
 			t->sched_info.last_queued = rq_clock(rq);
 	}
@@ -239,7 +239,7 @@ static inline void sched_info_depart(struct rq *rq, struct task_struct *t)
 static inline void
 sched_info_switch(struct rq *rq, struct task_struct *prev, struct task_struct *next)
 {
-	if (unlikely(sched_info_on()))
+	if (likely(sched_info_on()))
 		__sched_info_switch(rq, prev, next);
 }
 
-- 
1.8.3.1

