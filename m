Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8476D1525
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 03:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCaBoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 21:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCaBob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 21:44:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA731287A
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 18:44:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i11-20020a256d0b000000b0086349255277so20632496ybc.8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 18:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680227062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bQHMl9pwJydZAQbrAoDkSnvavcJ/jzjaFAvojHFhORk=;
        b=cE6t4ZFZ1GrVpjJSvVne/IoBs3nTvhJx2/x7tbZXEgJWa1Mk0XQ0npmPY8f/9VQI/r
         K75GmTXHd4epQTJXabgReN4I22zYPK7rPDu8IZR6IGBgbKDvzB9+b6UtiKkohpPFxoPX
         b2L7y9HVxegUECa/hEkNEht7jAlxcJ1tJvwL9ceHPnOFEWz/igzM3p3WSjHHgg7mxyp8
         sRMKMOEZaZQ61niu5ApADy/l4UYir9EHW+X+ghjI8PIwO+2S4AVDQ9XYGpCJ//hJsLPh
         NDSDv2w67CQ/pth2hxiZBg6Ks/QMp3as8Oqh8rgVpxqdYgDkYf0aXake8sqaJq31zq8n
         /tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680227062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bQHMl9pwJydZAQbrAoDkSnvavcJ/jzjaFAvojHFhORk=;
        b=iukMclYRvqBsn/CbOmqMsdQQpLFMPEA8ATBzggjlRV0ow9mjPk+SlZ2OsERN2ciS5X
         bruHiuETrujlkhKlBZeavJILTbBQMdTEWjANSH6FKtyMHup8bGz7+SQNye9iNvPOv/Yl
         IZK0gYZ8QrbLpXQwd4qVF+eDzngve5Ro9o4aUxrIWzF2nDxdnhrsZ6DTp+AOtkLeR+ad
         +OYEGQcpcUssQl/NA3T+tb0d/1FIAXzxwrzIvO0KZRR+ZFWzQKMacfLVVvQbP+Ydxucn
         OiDXTgDL8OSH96UAxlG2BjMmsWAizIEpnffndVVJugB46r133UnYclKBDE8ySpF930JS
         tltA==
X-Gm-Message-State: AAQBX9dGYVIz312uda+iD45HLB5BDvkbR4hneQ8dWVY35KOEodbrFovt
        46e9OPGO3TGWTt7gXXPfwdZviBPWuKJd
X-Google-Smtp-Source: AKy350ZivNvxJZ18U+W1XPsWsfvpSQ+cLGN8Aj2+BZDUohIE+m0rmZgZiCfr6NdVfa3nqdRvfK2U2A2N5cMv
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a25:ab11:0:b0:a5f:0:bf12 with SMTP id
 u17-20020a25ab11000000b00a5f0000bf12mr12526269ybi.13.1680227062710; Thu, 30
 Mar 2023 18:44:22 -0700 (PDT)
Date:   Thu, 30 Mar 2023 18:43:45 -0700
In-Reply-To: <20230331014356.1033759-1-davidai@google.com>
Mime-Version: 1.0
References: <20230331014356.1033759-1-davidai@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331014356.1033759-2-davidai@google.com>
Subject: [RFC PATCH v2 1/6] sched/fair: Add util_guest for tasks
From:   David Dai <davidai@google.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        David Dai <davidai@google.com>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For virtualization usecases, util_est and util_avg currently tracked
on the host aren't sufficient to accurately represent the workload on
vCPU threads, which results in poor frequency selection and performance.
For example, when a large workload migrates from a busy vCPU thread to
an idle vCPU thread, it incurs additional DVFS ramp-up latencies
as util accumulates.

Introduce a new "util_guest" member as an additional PELT signal that's
independently updated by the guest. When used, it's max aggregated to
provide a boost to both task_util and task_util_est.

Updating task_util and task_util_est will ensure:
-Better task placement decisions for vCPU threads on the host
-Correctly updating util_est.ewma during dequeue
-Additive util with other threads on the same runqueue for more
accurate frequency responses

Co-developed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: David Dai <davidai@google.com>
---
 include/linux/sched.h | 11 +++++++++++
 kernel/sched/core.c   | 18 +++++++++++++++++-
 kernel/sched/fair.c   | 15 +++++++++++++--
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 63d242164b1a..d8c346fcdf52 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -445,6 +445,16 @@ struct util_est {
 #define UTIL_AVG_UNCHANGED		0x80000000
 } __attribute__((__aligned__(sizeof(u64))));
 
+/*
+ * For sched_setattr_nocheck() (kernel) only
+ *
+ * Allow vCPU threads to use UTIL_GUEST as a way to hint the scheduler with more
+ * accurate utilization info. This is useful when guest kernels have some way of
+ * tracking its own runqueue's utilization.
+ *
+ */
+#define SCHED_FLAG_UTIL_GUEST   0x20000000
+
 /*
  * The load/runnable/util_avg accumulates an infinite geometric series
  * (see __update_load_avg_cfs_rq() in kernel/sched/pelt.c).
@@ -499,6 +509,7 @@ struct sched_avg {
 	unsigned long			load_avg;
 	unsigned long			runnable_avg;
 	unsigned long			util_avg;
+	unsigned long			util_guest;
 	struct util_est			util_est;
 } ____cacheline_aligned;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d18c3969f90..7700ef5610c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2024,6 +2024,16 @@ static inline void uclamp_post_fork(struct task_struct *p) { }
 static inline void init_uclamp(void) { }
 #endif /* CONFIG_UCLAMP_TASK */
 
+static void __setscheduler_task_util(struct task_struct *p,
+				  const struct sched_attr *attr)
+{
+
+	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_GUEST)))
+		return;
+
+	p->se.avg.util_guest = attr->sched_util_min;
+}
+
 bool sched_task_on_rq(struct task_struct *p)
 {
 	return task_on_rq_queued(p);
@@ -7561,7 +7571,7 @@ static int __sched_setscheduler(struct task_struct *p,
 			return -EINVAL;
 	}
 
-	if (attr->sched_flags & ~(SCHED_FLAG_ALL | SCHED_FLAG_SUGOV))
+	if (attr->sched_flags & ~(SCHED_FLAG_ALL | SCHED_FLAG_SUGOV | SCHED_FLAG_UTIL_GUEST))
 		return -EINVAL;
 
 	/*
@@ -7583,6 +7593,9 @@ static int __sched_setscheduler(struct task_struct *p,
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
+		if (attr->sched_flags & SCHED_FLAG_UTIL_GUEST)
+			return -EINVAL;
+
 		retval = security_task_setscheduler(p);
 		if (retval)
 			return retval;
@@ -7629,6 +7642,8 @@ static int __sched_setscheduler(struct task_struct *p,
 			goto change;
 		if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)
 			goto change;
+		if (attr->sched_flags & SCHED_FLAG_UTIL_GUEST)
+			goto change;
 
 		p->sched_reset_on_fork = reset_on_fork;
 		retval = 0;
@@ -7718,6 +7733,7 @@ static int __sched_setscheduler(struct task_struct *p,
 		__setscheduler_prio(p, newprio);
 	}
 	__setscheduler_uclamp(p, attr);
+	__setscheduler_task_util(p, attr);
 
 	if (queued) {
 		/*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6986ea31c984..998649554344 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4276,14 +4276,16 @@ static int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
 
 static inline unsigned long task_util(struct task_struct *p)
 {
-	return READ_ONCE(p->se.avg.util_avg);
+	return max(READ_ONCE(p->se.avg.util_avg),
+			READ_ONCE(p->se.avg.util_guest));
 }
 
 static inline unsigned long _task_util_est(struct task_struct *p)
 {
 	struct util_est ue = READ_ONCE(p->se.avg.util_est);
 
-	return max(ue.ewma, (ue.enqueued & ~UTIL_AVG_UNCHANGED));
+	return max_t(unsigned long, READ_ONCE(p->se.avg.util_guest),
+			max(ue.ewma, (ue.enqueued & ~UTIL_AVG_UNCHANGED)));
 }
 
 static inline unsigned long task_util_est(struct task_struct *p)
@@ -6242,6 +6244,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	util_est_enqueue(&rq->cfs, p);
 
+	/*
+	 * The normal code path for host thread enqueue doesn't take into
+	 * account guest task migrations when updating cpufreq util.
+	 * So, always update the cpufreq when a vCPU thread has a
+	 * non-zero util_guest value.
+	 */
+	if (READ_ONCE(p->se.avg.util_guest))
+		cpufreq_update_util(rq, 0);
+
 	/*
 	 * If in_iowait is set, the code below may not trigger any cpufreq
 	 * utilization updates, so do it here explicitly with the IOWAIT flag
-- 
2.40.0.348.gf938b09366-goog

