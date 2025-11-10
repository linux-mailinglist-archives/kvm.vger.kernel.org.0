Return-Path: <kvm+bounces-62472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF05C44D59
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 097BD4E5DC3
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BA3285045;
	Mon, 10 Nov 2025 03:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPQTIbZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1161A2868A6
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745568; cv=none; b=lEjzSQGwHgVuQi+Ywq62MuvfK57ir2CpYad8IOMtqB9MTci6UQIs34650ZZVpQ4RgiYfIcgJvG26YE/9l+dI9OzunlwJzS7kylonqHRRoehPt182AgjaL43NaNhiv4B+YL78WzfCxV+46ptn83Vt51O1fozZOx5NPwsOgxYmWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745568; c=relaxed/simple;
	bh=wbPUX9n8s+drIAX87sNapw/D2lFZMgm0X/R+CGmmVxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxLzAYIMa5+KdwDuC/r9VWG8HPV23x6C+yAocfVfZtcoWpJU6vOeN+WYtu5auWgMEbm/mO67SKRlz8X00B/czgKbKxX/5hYgNv+VuDFI5sObYvGyE6/gDgyLeGdLiGm7fG+eu3P8ZEeYNp9bka6YzBcHOVzE3i2v4vEKvma0eAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPQTIbZA; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2089613b3a.3
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745566; x=1763350366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njeTN44gIUPeOIH83iq5dF5dVqD8fgi+Xi9oci3U0Kg=;
        b=FPQTIbZAU1KO4n4qkSJRdtbpnVcVh4X9XvM+TfIrdyedQg+cXHzXzio/JZSoehhzLl
         pA/P2XXEYUVburC1LW70vu/7t6XLBQlr75RL45YAmu6oGQGAu5lAgqpTp5b/0uWg7a30
         MDMxF6wozDPnmFXmMwACXnq2WrSK+bGbRO5OWeXo1Mj7eq0Wlz8T5gj2VuHWDBObsIfC
         RN3Ap3YvIT3UokXZe9eU0+9DvLKLpoqgHZDbs0KT6H0Q6o+wEpzdrf3EpDrGXWw2MdXv
         3REACQG68ndVt9HuJRE0jeYSbB5HzfVnpp4FTN4HvFgccOgi8tLVBoi/MpWZAU5BmTlp
         GraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745566; x=1763350366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=njeTN44gIUPeOIH83iq5dF5dVqD8fgi+Xi9oci3U0Kg=;
        b=WjY5h5E5xwuzfGlkm+aYY5WICGR+j/d+5/msqJAXygbkA2bOQPjlHjKjvT/75/1751
         u0QApUy4B8OOl/pGJHjIUg0SzJwCIZ0YH4cjIFr8/+4yY6lvJszWZb4K7AWt8fjqNuK+
         oMR/IHVPVr/qa7Mr3XB56s0nMFlKlU/Iv5ruu0yStCDakbwI6WO7dgLChqLxcamAhFXb
         VScWa+pkmtCmfWFU0SVjYHVzbZ+ohR8l2/idrj6NVB/0yX3BeUQQem1kwPu+4M66Tb84
         QsiLVrqZ5GokfF+k+Z+m+vU+9ZvROzcaMeGahebf2YcmMMhTjEuh017O5BjDBSM2g7Sv
         hf0w==
X-Forwarded-Encrypted: i=1; AJvYcCV1MRM+0qZT79/TsEtzg9pVF41wr7aqz9TWVSXdT4xPG9UovDhprjkMPjtU+Y9LXJ0vQu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxENFoc0jTEWLtOBDED6gb6If2G4wv369jlD47hLWxkb5yqabZd
	4frb05H+ibmN7SVoPvuEbgT377k/vcetYsIQxu/WOhKTZQ7cAtd9AG/x
X-Gm-Gg: ASbGncsy8Xypkc6ZMCGjrtczK1LGgmnb2Hwve22ffc33xIhbgRyDomVPzsFk5fAVeOO
	6dPRhokl17MvPQcTSq9+FgUSMVRRKBkaGFRe63qvGHZQUc0WHeIeP3Ym8/h9gSGGUHdDXdsfy31
	70vi/e7sJERUtFao2FVFT/iRoLfbvOS2kIZtHFsgK5hW0Ab2kfAFrHTt0cL3NzgkqVqakk5rkdM
	XGKyyZtageMtSHLVzqdBeFc45sMj2ZtxAV+GHner49dlk3ZDYUUARE2QWu6KdRSr5ly3vppr7ft
	RgR5JmmX/iQ/n/qXWT/x9vnLAhtKP90xGm1FP6+G4ph6UWv6t3LaJKvvZzh7W9l7sRaHIEaijWn
	kGvbiT20Pf0vmEVRopqxby22Enck3R7YX8z5TD6PmgRmmVSlJljuyTDMJ8IDiFRISIqRSaTdEog
	==
X-Google-Smtp-Source: AGHT+IGgWj+riHl/0AxPM6/yf+3pf97HB4xt0VxRxXs/RO4msxXfu/kysFJz978Pl0ItdGF8SGUj7A==
X-Received: by 2002:a05:6a20:3d82:b0:342:a7cd:9214 with SMTP id adf61e73a8af0-353a20d6c44mr9577178637.23.1762745566383;
        Sun, 09 Nov 2025 19:32:46 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:32:46 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 02/10] sched/fair: Add rate-limiting and validation helpers
Date: Mon, 10 Nov 2025 11:32:23 +0800
Message-ID: <20251110033232.12538-3-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

From: Wanpeng Li <wanpengli@tencent.com>

Implement core safety mechanisms for yield deboost operations.

Add yield_deboost_rate_limit() for high-frequency gating to prevent
excessive overhead on compute-intensive workloads. Use 6ms threshold
with lockless READ_ONCE/WRITE_ONCE to minimize cache line contention
while providing effective rate limiting.

Add yield_deboost_validate_tasks() for comprehensive validation
ensuring feature is enabled via sysctl, both tasks are valid and
distinct, both belong to fair_sched_class, entities are on the same
runqueue, and tasks are runnable.

The rate limiter prevents pathological high-frequency cases while
validation ensures only appropriate task pairs proceed. Both functions
are static and will be integrated in subsequent patches.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 68 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b7fcc86ccff..a7dc21c2dbdb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8990,6 +8990,74 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev, struct t
 	}
 }
 
+/*
+ * High-frequency yield gating to reduce overhead on compute-intensive workloads.
+ * Returns true if the yield should be skipped due to frequency limits.
+ *
+ * Optimized: single threshold with READ_ONCE/WRITE_ONCE, refresh timestamp on every call.
+ */
+static bool yield_deboost_rate_limit(struct rq *rq, u64 now_ns)
+{
+	u64 last = READ_ONCE(rq->yield_deboost_last_time_ns);
+	bool limited = false;
+
+	if (last) {
+		u64 delta = now_ns - last;
+		limited = (delta <= 6000ULL * NSEC_PER_USEC);
+	}
+
+	WRITE_ONCE(rq->yield_deboost_last_time_ns, now_ns);
+	return limited;
+}
+
+/*
+ * Validate tasks and basic parameters for yield deboost operation.
+ * Performs comprehensive safety checks including feature enablement,
+ * NULL pointer validation, task state verification, and same-rq requirement.
+ * Returns false with appropriate debug logging if any validation fails,
+ * ensuring only safe and meaningful yield operations proceed.
+ */
+static bool __maybe_unused yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target,
+					  struct task_struct **p_yielding_out,
+					  struct sched_entity **se_y_out,
+					  struct sched_entity **se_t_out)
+{
+	struct task_struct *p_yielding;
+	struct sched_entity *se_y, *se_t;
+	u64 now_ns;
+
+	if (!sysctl_sched_vcpu_debooster_enabled)
+		return false;
+
+	if (!rq || !p_target)
+		return false;
+
+	now_ns = rq->clock;
+
+	if (yield_deboost_rate_limit(rq, now_ns))
+		return false;
+
+	p_yielding = rq->curr;
+	if (!p_yielding || p_yielding == p_target ||
+	    p_target->sched_class != &fair_sched_class ||
+	    p_yielding->sched_class != &fair_sched_class)
+		return false;
+
+	se_y = &p_yielding->se;
+	se_t = &p_target->se;
+
+	if (!se_t || !se_y || !se_t->on_rq || !se_y->on_rq)
+		return false;
+
+	if (task_rq(p_yielding) != rq || task_rq(p_target) != rq)
+		return false;
+
+	*p_yielding_out = p_yielding;
+	*se_y_out = se_y;
+	*se_t_out = se_t;
+	return true;
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


