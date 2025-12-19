Return-Path: <kvm+bounces-66299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9ADCCCE668
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE4483095A90
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AE62C0F62;
	Fri, 19 Dec 2025 03:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZRR+Cya"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9D1288C34
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116443; cv=none; b=ntGcfUF4ATxLgUscVVc0ePxdpblNTZR6XZ06fquzipCwvX/fyMCXUwcqdB/cZCgLst3R5aYiGIHphuHZAq5WzoMHV+payBFsogYD6zEK4GB0lHWKDog/NSNkfEFWIsO5jA1FsuNVtxL/IDkvt5VcktEjEaxZMAwWXfDyEiPUSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116443; c=relaxed/simple;
	bh=H8U0wRFSdW5gcTaqf8OG8+irmfu/waefCnMBKyOk/y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioHonq88Y5RN3uFRJFXgVRQDqcqgTwY8ZH3ZUdjPYLBKapTPBPEy4iRlYbt6z0tVBqlE5QPvCP3C9S8vhkkv0eg2ki47N9lEZYtsAy8ofzuqDsVobuZLsZIdAsahoDA10/sNqlrcVV7mDUIUH77RoMTmtYtQe4JVZajZHU2VFRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZRR+Cya; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f1bc40b35so24025385ad.2
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116439; x=1766721239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qf8yDAv14VzvWW94c4Eap1J+svTAb90Oiob+iJ0N9Kw=;
        b=UZRR+Cya8HgdcEUuONWiEgVQk1lo1FJWM3QeXpZ1Jjd9+rQxWk8FwtWQRhhm5OBPCH
         JLJdowOsu3SqQcgNZQzjtltlXdYD5W8JV8YuvSBxMUjUTrAQWZSjjTIdmDG5b0L8VFa2
         Exd2csCzIwJQsiiMdYyOfoU9ZkTGRo3nS8LwQaysjOo+DFdz6igIu5tJXXK69E9nIo/w
         ESWmQ4mBM9gSPXLrhziPi1Bn5cazSyX9HFX+U0z14xmpPkaqBV7kkR76eKIFvxh3/p9x
         og08McNNOjrFEBfA8QMLkkFdFntkIzlE2V4SsBjtKiArigSLryKtlYa36XytEErOfbB9
         m8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116439; x=1766721239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qf8yDAv14VzvWW94c4Eap1J+svTAb90Oiob+iJ0N9Kw=;
        b=pOx+ySRgnk8Z0dc7CuFUdrkn8PIyKYI+X5eIfCuFa5CfHdFt2inhV3dSUg0KPBbITD
         /MfONyfaHJpYL22IT1vsItHsFxuRc2ZCZ58gHYAoahDu1fWOta0XR9m2kTtlFSQ36hY6
         MlgjhHdtdSlXNpoXKtJPRqxFT8HqlpYBfvo2lD7c27rPTzkc90cXdpfL3nBoy0LbeAEG
         EH06UAYmi/eLQjVayAM66s1oV7sZzbcbDLRvLXSEHuFHHdNWeCa3zEEOD3M+BgFwT3A0
         mRvGmpTfkuIb5OiM8CEnxFKM2FeweNH3vaH6sDAnL6PWrp0i5v2PMVY2PbvcT0dQhjCx
         bjJA==
X-Forwarded-Encrypted: i=1; AJvYcCXcsih8qwa4qTOBl8+SyrmG5NjpVZwrQNfDmTBIqaHy1MI7g496jUioMIjDVT76ib9s5SI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS5BhUpUBX+w8ltRAr3wZ6TIu05izpxuseJt8VrwlMEjqFyqvF
	SFH1AdJaEVAqRe46SbQJVAoUgSq6aUJYwURGZkAmAFVquffFs8vlIb/h
X-Gm-Gg: AY/fxX7UsyPw9tF11Cf2PgPSXE/uZ+8O3a4Koq4cKsIhiPVFM0TIaEFnvlavYbAIaPp
	rnbRBoQvE1O53Tntydr0PrEB+CjaRbfS5wRxEESFF2EmpHue7SSoTnYPJb0W0oTLYzvechwI/wY
	rQe+gCHmn41H1KabRsrWXRM/WntFeE3olkbtKV5woog8MFG+x4Iu6S1PDiA8Lv2+SVRatT2IQoB
	bp65QxwM3mUzr7lQ0ZAir2/VNYQGAnw27dH026OWUqQRU0IxtjlSSeQX9pMZqM+UnVecifYUEOl
	6AtMSZtQAYQ2sQRO9cB5ur/6Q1fyi6QLZwNRWUbnV9NvUglVRS5efvvZMAyNzNhzwx4yVK+rJvY
	yO295AGE4FEh/2d1+3GflrzW3RS8641H9iph4LPMezt0g0aTfPuFXKvgrlPT/ZYjnF+b6BmeJHg
	plwbqW8I/S8w==
X-Google-Smtp-Source: AGHT+IG3CrHjUqC8LaluiLhOYvEUK1BTjRjaMa/qSz9KV9sZCRV9vB/gQavWA0z81NhCPjki2yEypw==
X-Received: by 2002:a17:902:ec90:b0:297:e59c:63cc with SMTP id d9443c01a7336-2a2f2737be9mr15900185ad.35.1766116439121;
        Thu, 18 Dec 2025 19:53:59 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:58 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 5/9] sched/fair: Wire up yield deboost in yield_to_task_fair()
Date: Fri, 19 Dec 2025 11:53:29 +0800
Message-ID: <20251219035334.39790-6-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Integrate yield_to_deboost() into yield_to_task_fair() to activate the
vCPU debooster mechanism.

The integration works in concert with the existing buddy mechanism:
set_next_buddy() provides immediate preference, yield_to_deboost()
applies bounded vruntime penalty based on the fairness gap, and
yield_task_fair() completes the standard yield path including the
EEVDF forfeit operation.

Note: yield_to_deboost() must be called BEFORE yield_task_fair()
because v6.19+ kernels perform forfeit (se->vruntime = se->deadline)
in yield_task_fair(). If deboost runs after forfeit, the fairness
gap calculation would see the already-inflated vruntime, resulting
in need=0 and only baseline penalty being applied.

Performance testing (16 pCPUs host, 16 vCPUs/VM):

Dbench 16 clients per VM:
  2 VMs: +14.4% throughput
  3 VMs:  +9.8% throughput
  4 VMs:  +6.7% throughput

Gains stem from sustained lock holder preference reducing ping-pong
between yielding vCPUs and lock holders. Most pronounced at moderate
overcommit where contention reduction outweighs context switch cost.

v1 -> v2:
- Move sysctl_sched_vcpu_debooster_enabled check to yield_to_deboost()
  entry point for early exit before update_rq_clock()
- Restore conditional update_curr() check (se_y_lca != cfs_rq->curr)
  to avoid unnecessary accounting updates
- Keep yield_task_fair() unchanged (no for_each_sched_entity loop)
  to avoid double-penalizing the yielding task
- Move yield_to_deboost() BEFORE yield_task_fair() to preserve fairness
  gap calculation (v6.19+ forfeit would otherwise inflate vruntime
  before penalty calculation)
- Improve function documentation

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 67 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8738cfc3109c..9e0991f0c618 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9066,23 +9066,19 @@ static bool yield_deboost_rate_limit(struct rq *rq)
  * Validate tasks for yield deboost operation.
  * Returns the yielding task on success, NULL on validation failure.
  *
- * Checks: feature enabled, valid target, same runqueue, target is fair class,
- * both on_rq. Called under rq->lock.
+ * Checks: valid target, same runqueue, target is fair class,
+ * both on_rq, rate limiting. Called under rq->lock.
  *
  * Note: p_yielding (rq->donor) is guaranteed to be fair class by the caller
  * (yield_to_task_fair is only called when curr->sched_class == p->sched_class).
+ * Note: sysctl_sched_vcpu_debooster_enabled is checked by caller before
+ * update_rq_clock() to avoid unnecessary clock updates.
  */
 static struct task_struct __maybe_unused *
 yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target)
 {
 	struct task_struct *p_yielding;
 
-	if (!sysctl_sched_vcpu_debooster_enabled)
-		return NULL;
-
-	if (!p_target)
-		return NULL;
-
 	if (yield_deboost_rate_limit(rq))
 		return NULL;
 
@@ -9287,6 +9283,57 @@ yield_deboost_apply_penalty(struct sched_entity *se_y_lca,
 	se_y_lca->deadline = new_vruntime + calc_delta_fair(se_y_lca->slice, se_y_lca);
 }
 
+/*
+ * yield_to_deboost - Apply vruntime penalty to favor the target task
+ * @rq: runqueue containing both tasks (rq->lock must be held)
+ * @p_target: task to favor in scheduling
+ *
+ * Cooperates with yield_to_task_fair(): set_next_buddy() provides immediate
+ * preference; this routine applies a bounded vruntime penalty at the cgroup
+ * LCA so the target maintains scheduling advantage beyond the buddy effect.
+ *
+ * Only operates on tasks resident on the same rq. Penalty is bounded by
+ * granularity and queue-size caps to prevent starvation.
+ */
+static void yield_to_deboost(struct rq *rq, struct task_struct *p_target)
+{
+	struct task_struct *p_yielding;
+	struct sched_entity *se_y, *se_t, *se_y_lca, *se_t_lca;
+	struct cfs_rq *cfs_rq_common;
+	u64 penalty;
+
+	/* Quick validation before updating clock */
+	if (!sysctl_sched_vcpu_debooster_enabled)
+		return;
+
+	if (!p_target)
+		return;
+
+	/* Update clock - rate limiting and debounce use rq_clock() */
+	update_rq_clock(rq);
+
+	/* Full validation including rate limiting */
+	p_yielding = yield_deboost_validate_tasks(rq, p_target);
+	if (!p_yielding)
+		return;
+
+	se_y = &p_yielding->se;
+	se_t = &p_target->se;
+
+	/* Find LCA in cgroup hierarchy */
+	if (!yield_deboost_find_lca(se_y, se_t, &se_y_lca, &se_t_lca, &cfs_rq_common))
+		return;
+
+	/* Update current accounting before modifying vruntime */
+	if (se_y_lca != cfs_rq_common->curr)
+		update_curr(cfs_rq_common);
+
+	/* Calculate and apply penalty */
+	penalty = yield_deboost_calculate_penalty(rq, se_y_lca, se_t_lca,
+						  p_target, cfs_rq_common->h_nr_queued);
+	yield_deboost_apply_penalty(se_y_lca, cfs_rq_common, penalty);
+}
+
 /*
  * sched_yield() is very simple
  */
@@ -9341,6 +9388,10 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
 	/* Tell the scheduler that we'd really like se to run next. */
 	set_next_buddy(se);
 
+	/* Apply deboost BEFORE forfeit to preserve fairness gap calculation */
+	yield_to_deboost(rq, p);
+
+	/* Complete the standard yield path (includes forfeit in v6.19+) */
 	yield_task_fair(rq);
 
 	return true;
-- 
2.43.0


