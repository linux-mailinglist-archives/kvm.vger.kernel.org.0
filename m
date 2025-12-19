Return-Path: <kvm+bounces-66296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5241CCE650
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86D5E30657AC
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA94F28030E;
	Fri, 19 Dec 2025 03:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G63yyoXX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E761529C321
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116431; cv=none; b=DEWk5g5m5TXMHuO8TGkUkLLwOM2Tia85io4JLP99jqF7EfC+400iiYNFOWKPbYaB21hMqWvYw8cTgeCiQP04qfhDbJqpDF4c6s9XSKqFyf9RZIZMaMLwZA+dzJWR+UhecxJmUbMpixomPk46eW0zihQ6ver68QVM/DXkTdPOlQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116431; c=relaxed/simple;
	bh=uyTv52x6ZHnufc68tUyR5LEwDwfJcWQT5mBt9gd8Sac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNIBy9gabxI5F/WqXkfR1tyYfZ++Z4hxWGYJ6cI6mIn9JJ7NP+puE0TaTeb/nGma6KK9Yv4b57pH2CK44HNtlGQ0uMDiazFALDdBZoOgXXjZbN66J9ajw0EMC0uSD3AtUNXipGDfLeJ21LFnvPY3K/N3uvpumeu+wxz4zQE7uTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G63yyoXX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0bae9aca3so18538065ad.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116428; x=1766721228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMdxKLElCH6dq+q/a5oZXIHsPg35QMvjNqTyuXC9Pks=;
        b=G63yyoXX90j9rPY6yazBvt59twEN+FEBolKsSOdmwofhO5LXXEcIciPAyy5o0umJoF
         0rjSz9Bm/plmzOV1yk0fxdYnOJYnSCwi6T2LS4rAGe1AqWXdcXPKpEygsRIRFu6vUDgK
         ySGFVXEWEIuwjez4FInBEOHKdeMfvZ2aGvpaNYL7kQo/YuXK9WYPF1jrWz1rh2azJooy
         tUQURw+yMx1ntfnO/Z7/1vGTw/qcTlWZgorw2QpcXOVlrCbYSJEMRwr23Hd0G5m4aQb+
         c518vrBsJSlh3wqJXpZhJTOa4gN1rQYmJfhfzvRzafNF+ryYCy2se8JWCdVmPzg/9LiJ
         XgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116428; x=1766721228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OMdxKLElCH6dq+q/a5oZXIHsPg35QMvjNqTyuXC9Pks=;
        b=jsp+tAEZD72xwbfidAPTZNCeO7pjzyzINQl9DClsFNYTw+BCN8hiypUWRKSDJlG1HJ
         Zusauv388AcbZ4kQtL7OfkXQcKrYuZj1bTX6dNEt8hs0zdRoWQN2Jk1JZUwodWG8ryzn
         s/tNMp6raFqZ8skgU2iOPlZ6Lt/TCafaQZ0ghsSiMuyUB+FGsY4dqvWpKwKjhPAZatNu
         VSHSsyak2IDuaipFW46sBzT7oG4WgR4yqyM+7y9Z+JhdjK5xFpNBzJXZx2T0Vdopikro
         bLJZJBQ7iFpZ1YYnmy7611V8FOpyP5mhagP9y7VYH2EOvwoMS0nqPWnrc3pdJ2C88Okz
         KADg==
X-Forwarded-Encrypted: i=1; AJvYcCXHV4qOSZyoxmNt0MrMEqs9UMtNlnfirgsjHL4elw5QE/6vPKwCJtfufHFtqGTdc3fYoQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCwx0zLqw7ckH6H1iqoNtl+jLoYEAnQ4+ctl919FfwF82Qr0JU
	rHFzX1eTdVpsZtAlHWoIWBT/jPE5ga8FwKXBFVGEJ69TFWiR1QDZI1bs
X-Gm-Gg: AY/fxX5arJJ4NA3akJZBpy4/rpPRZBO6vXv1orkgf1AqVFFL8A4eqNb8heKJBzl27lS
	ZmuNz0vgy3Wrk99kaaMunnmIU5FUAVdPngqr52FMq18unD91kQR241oYP0Q6zBPqLEcUX/ItvUz
	Ipto6kkXcd8U1GfdRMuQYqHUx8DGNY7rTPbHT9ADKOTYfyh+XTEUg7glRWLr62xfHmjNv/kUTTj
	GYLXo8uGeV9PKx025M6vCAKPDopXD3TgJyrkm/MBiP1AeBt+tUolXrzYT1HYO0ZNrEZUMZqkQ2s
	svGWI+1fxAUlToovTjQznaGmnHx/5k+PuNSs+mTjVeTmJWa2wRxHOIXytO7gKOQFfmMlRQIfNWj
	ZHHE5yie0q4hJlUHj3gJPd6u5iHbKtBaNKsS2EcHjsFyBG9a7f7kLtJTh137Y++wFF8YrAAB3sr
	EGxo/IKV9N0A==
X-Google-Smtp-Source: AGHT+IFnJ2R42OMGoxKqOusa0MAzx7Gd6hkBgQwWawENhau2L5GQ8F2uMlxqxfr4j40Vr0WoY7jZWQ==
X-Received: by 2002:a17:903:2285:b0:29b:e512:752e with SMTP id d9443c01a7336-2a2f293b6c1mr13029455ad.47.1766116428140;
        Thu, 18 Dec 2025 19:53:48 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:47 -0800 (PST)
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
Subject: [PATCH v2 2/9] sched/fair: Add rate-limiting and validation helpers
Date: Fri, 19 Dec 2025 11:53:26 +0800
Message-ID: <20251219035334.39790-3-kernellwp@gmail.com>
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

Implement core safety mechanisms for yield deboost operations.

Add yield_deboost_rate_limit() for high-frequency gating to prevent
excessive overhead on compute-intensive workloads. The 6ms threshold
balances responsiveness with overhead reduction.

Add yield_deboost_validate_tasks() for comprehensive validation ensuring
both tasks are valid and distinct, both belong to fair_sched_class,
target is on the same runqueue, and tasks are runnable.

The rate limiter prevents pathological high-frequency cases while
validation ensures only appropriate task pairs proceed. Both functions
are static and will be integrated in subsequent patches.

v1 -> v2:
- Remove unnecessary READ_ONCE/WRITE_ONCE for per-rq fields accessed
  under rq->lock
- Change rq->clock to rq_clock(rq) helper for consistency
- Change yield_deboost_rate_limit() signature from (rq, now_ns) to (rq),
  obtaining time internally via rq_clock()
- Remove redundant sched_class check for p_yielding (already implied by
  rq->donor being fair)
- Simplify task_rq check to only verify p_target
- Change rq->curr to rq->donor for correct EEVDF donor tracking
- Move sysctl_sched_vcpu_debooster_enabled and NULL checks to caller
  (yield_to_deboost) for early exit before update_rq_clock()
- Simplify function signature by returning p_yielding directly instead
  of using output pointer parameters
- Add documentation explaining the 6ms rate limit threshold

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 62 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 87c30db2c853..2f327882bf4d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9040,6 +9040,68 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev, struct t
 	}
 }
 
+/*
+ * Rate-limit yield deboost operations to prevent excessive overhead.
+ * Returns true if the operation should be skipped due to rate limiting.
+ *
+ * The 6ms threshold balances responsiveness with overhead reduction:
+ * - Short enough to allow timely yield boosting for lock contention
+ * - Long enough to prevent pathological high-frequency penalty application
+ *
+ * Called under rq->lock, so direct field access is safe.
+ */
+static bool yield_deboost_rate_limit(struct rq *rq)
+{
+	u64 now = rq_clock(rq);
+	u64 last = rq->yield_deboost_last_time_ns;
+
+	if (last && (now - last) <= 6 * NSEC_PER_MSEC)
+		return true;
+
+	rq->yield_deboost_last_time_ns = now;
+	return false;
+}
+
+/*
+ * Validate tasks for yield deboost operation.
+ * Returns the yielding task on success, NULL on validation failure.
+ *
+ * Checks: feature enabled, valid target, same runqueue, target is fair class,
+ * both on_rq. Called under rq->lock.
+ *
+ * Note: p_yielding (rq->donor) is guaranteed to be fair class by the caller
+ * (yield_to_task_fair is only called when curr->sched_class == p->sched_class).
+ */
+static struct task_struct __maybe_unused *
+yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target)
+{
+	struct task_struct *p_yielding;
+
+	if (!sysctl_sched_vcpu_debooster_enabled)
+		return NULL;
+
+	if (!p_target)
+		return NULL;
+
+	if (yield_deboost_rate_limit(rq))
+		return NULL;
+
+	p_yielding = rq->donor;
+	if (!p_yielding || p_yielding == p_target)
+		return NULL;
+
+	if (p_target->sched_class != &fair_sched_class)
+		return NULL;
+
+	if (task_rq(p_target) != rq)
+		return NULL;
+
+	if (!p_target->se.on_rq || !p_yielding->se.on_rq)
+		return NULL;
+
+	return p_yielding;
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


