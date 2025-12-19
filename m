Return-Path: <kvm+bounces-66298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA52CCE65C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:56:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCB3E30285B6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B1728CF49;
	Fri, 19 Dec 2025 03:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPBVJrtX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B602BFC7B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116438; cv=none; b=jdi8/9e6qY7nOuXKCDqlDmpaKWWfYw0MfnwFoonOYB/+iIzT8dwNYH/IRrIrj5mKdbxOVzElAmWt2NZ44dBApH9kz4iyO32iFSeI3PzjwRp0PPM9MpdU0F7SmY9hZLBFmM87hvXZ9y3z+njmAa0x1T2yROgdvpy3EYXkyFNvsdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116438; c=relaxed/simple;
	bh=PyzQEsSg7kw/qd32fHAPwWOyK7EtXgvb42CetiCJpCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJMmyd9PfJb552j+KAA9XrsDkpnYrXPxU+NznZ/6E0njjEhTNnl3tfAZ4LhRX3b5z3q2vezfx3JIK5lZRflCnl0tNBAJYsBROsob/HoEt3UE0c1uA7OKJhl1bGEamV21APsuSk7ZQHwEmL1Y8YIu7ffRFGTDXSYZPpfC2QV/IR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPBVJrtX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso14999725ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116435; x=1766721235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYp6mne9RQBnm/zJso5fmZJvi26B9MVfbc7EUoVI1Fo=;
        b=bPBVJrtXuDu9wT96uH+79m4FJIvGRtynSjvqvj6waIhHHaI8LparlITe9F/0IrV8IP
         yiSLuBnuWJ1O37v5422aGR7ai3ykPdlQCy61tSZ0+2NaX69HGlA/KLv1zQOSqm5NeCq+
         VGxehlnnebLKOzuzoIKocwU8zG/kdE5Kft0kqlMyapVPRfDnd/7k0fZNGQClkJWePrf2
         bm3iq1mPvdp2M23zjUFErszrSLa4mrboTE4kwX+HDss3hP9GKGDrqJZqPKb6JIcFJmoS
         2rszX88JPqSxr/PFtw999LtjTxVNR3JCyJUaNIdiRDPJFcbt3q11O47Ae2KmngA3Km7S
         gniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116435; x=1766721235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hYp6mne9RQBnm/zJso5fmZJvi26B9MVfbc7EUoVI1Fo=;
        b=F5nFEPw2Ty+Jgh3J1v/H4jDsvFQVc/EvRmkofk+FWI0g/+dXVC7kZcav490IJRgINg
         YCIL/kLZyO0D4qe6sshph8jMKMF08a2gPvcT1ZQyZAUhMsyxyWuehGcKWF40j+tsAraX
         r3AH/7vpNweJ9BMFm5zCgvhctBRw+gHKqaU/5TBvnFFmcSsDaWVVSi2J52XW0VtkL90j
         jMAsKXJUgnc64JZ2W7/qKkNFG0UmFYZtBPomm6msMbQScJemwU0tVOSCCcEkzclQy0FM
         QEDvZ/ggoRgXwQgQgcePmVv6Q07smaLXyGe5Pfg2uuUzcwzfIjEtMCG1NnMe2cat+RZl
         SXLg==
X-Forwarded-Encrypted: i=1; AJvYcCV0JAWyV11GU75AbyOhYXgI5/nspfOh74Nh+sxVAyWNQdL7JUJkdMAAvq2E0ZrZfOaOzLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYmUGzcZv4km/f2mgDn62L6AwqZ25Mwm/v3WrSohovDN7jNOkh
	p+AgWPjMu0L6nSYwq/ZbpnTJ62g5WecD+8zubgCW01YvLK/+PccaJ5gC
X-Gm-Gg: AY/fxX7ljnMh010QKVo/sSY13XTRF6WMuPzB6ScDOS5rRhv8G26iWqaoPoQjf0Sbcrh
	4c73uGyURA5/TUWNTVPmIxfARPL0gNc3xpB9tb9z9zA8tM0nvwQ5M0Mz+GoMxzxFa2VZ1ZsnwMc
	F/6ouxNYCGWYk7j58psPo6rhxFPUXJuq3vzXHXftACIGndZPRx0WkqwgAUM9UQf8Vp6bF870tl8
	AdKfwyjM8MA/U6YXfychfQhCBFVUMPiBMDZ+iY0jF54LZhflpmJZsZt5VZ+s43YA8KNABE/dYw9
	JybzSZ+Ymo6Ggq+SvhopbSOt46AjppZ1U5RRaJwdEoPs29IecVhfTPPtgXJD5sn4wzCpvuNB4X8
	/PwiJcfpraiLz2usY5czfcmhi56BaQaRGsZdZfhyb7cmZ0tJHxFC4zY70b+ejRpk6q9XBfwk1fh
	06YeNJ7V7LUw==
X-Google-Smtp-Source: AGHT+IHiDoS1clMCz/1DsX5HsR1i60zES2fsmiCSAhFgHJzfjtR8nSUq08UUT+JvRXYXAyqsQ9X/YA==
X-Received: by 2002:a17:902:cec6:b0:2a0:fb05:879a with SMTP id d9443c01a7336-2a2f2a4f6damr14153035ad.51.1766116435362;
        Thu, 18 Dec 2025 19:53:55 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:55 -0800 (PST)
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
Subject: [PATCH v2 4/9] sched/fair: Add penalty calculation and application logic
Date: Fri, 19 Dec 2025 11:53:28 +0800
Message-ID: <20251219035334.39790-5-kernellwp@gmail.com>
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

Implement core penalty calculation and application mechanisms for
yield deboost operations.

yield_deboost_apply_debounce(): Reverse-pair debouncing prevents
ping-pong. When A->B then B->A within ~600us, penalty is downscaled.

yield_deboost_calculate_penalty(): Calculate vruntime penalty based on:
- Fairness gap (vruntime delta between yielding and target tasks)
- Scheduling granularity based on yielding entity's weight
- Queue-size-based caps (2 tasks: 6.0x gran, 3: 4.0x, 4-6: 2.5x,
  7-8: 2.0x, 9-12: 1.5x, >12: 1.0x)
- Special handling for zero gap with refined multipliers
- 10% weighting on positive gaps (alpha=1.10)

yield_deboost_apply_penalty(): Apply calculated penalty to EEVDF
state, updating vruntime and deadline atomically.

The penalty mechanism provides sustained scheduling preference beyond
the transient buddy hint, critical for lock holder boosting in
virtualized environments.

v1 -> v2:
- Change nr_queued to h_nr_queued for accurate hierarchical task
  counting in penalty cap calculation
- Remove vlag assignment as it will be recalculated on dequeue/enqueue
  and modifying it for on-rq entity is incorrect
- Remove update_min_vruntime() call: in EEVDF the yielding entity is
  always cfs_rq->curr (dequeued from RB-tree), so modifying its vruntime
  does not affect min_vruntime calculation
- Remove unnecessary gran_floor safeguard (calc_delta_fair already
  handles edge cases correctly)
- Change rq->curr to rq->donor for correct EEVDF donor tracking
- Simplify debounce function signature

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 155 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 39dbdd222687..8738cfc3109c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9132,6 +9132,161 @@ yield_deboost_find_lca(struct sched_entity *se_y, struct sched_entity *se_t,
 	return true;
 }
 
+/*
+ * Apply debounce for reverse yield pairs to reduce ping-pong effects.
+ * When A yields to B, then B yields back to A within ~600us, downscale
+ * the penalty to prevent oscillation.
+ *
+ * The 600us threshold is chosen to be:
+ * - Long enough to catch rapid back-and-forth yields
+ * - Short enough to not affect legitimate sequential yields
+ *
+ * Returns the (possibly reduced) penalty value.
+ */
+static u64 yield_deboost_apply_debounce(struct rq *rq, struct task_struct *p_target,
+					u64 penalty, u64 need, u64 gran)
+{
+	u64 now = rq_clock(rq);
+	struct task_struct *p_yielding = rq->donor;
+	pid_t src_pid, dst_pid;
+	pid_t last_src, last_dst;
+	u64 last_ns;
+
+	if (!p_yielding || !p_target)
+		return penalty;
+
+	src_pid = p_yielding->pid;
+	dst_pid = p_target->pid;
+	last_src = rq->yield_deboost_last_src_pid;
+	last_dst = rq->yield_deboost_last_dst_pid;
+	last_ns = rq->yield_deboost_last_pair_time_ns;
+
+	/* Detect reverse pair: previous was target->source */
+	if (last_src == dst_pid && last_dst == src_pid &&
+	    (now - last_ns) <= 600 * NSEC_PER_USEC) {
+		u64 alt = max(need, gran);
+
+		if (penalty > alt)
+			penalty = alt;
+	}
+
+	/* Update tracking state */
+	rq->yield_deboost_last_src_pid = src_pid;
+	rq->yield_deboost_last_dst_pid = dst_pid;
+	rq->yield_deboost_last_pair_time_ns = now;
+
+	return penalty;
+}
+
+/*
+ * Calculate vruntime penalty for yield deboost.
+ *
+ * The penalty is based on:
+ * - Fairness gap: vruntime difference between yielding and target tasks
+ * - Scheduling granularity: base unit for penalty calculation
+ * - Queue size: adaptive caps to prevent starvation in larger queues
+ *
+ * Queue-size-based caps (multiplier of granularity):
+ *   2 tasks:  6.0x - Strongest push for 2-task ping-pong scenarios
+ *   3 tasks:  4.0x
+ *   4-6:      2.5x
+ *   7-8:      2.0x
+ *   9-12:     1.5x
+ *   >12:      1.0x - Minimal push to avoid starvation
+ *
+ * Returns the calculated penalty value.
+ */
+static u64 __maybe_unused
+yield_deboost_calculate_penalty(struct rq *rq, struct sched_entity *se_y_lca,
+				struct sched_entity *se_t_lca,
+				struct task_struct *p_target, int h_nr_queued)
+{
+	u64 gran, need, penalty, maxp;
+	u64 weighted_need, base;
+
+	gran = calc_delta_fair(sysctl_sched_base_slice, se_y_lca);
+
+	/* Calculate fairness gap */
+	need = 0;
+	if (se_t_lca->vruntime > se_y_lca->vruntime)
+		need = se_t_lca->vruntime - se_y_lca->vruntime;
+
+	/* Base penalty is granularity plus 110% of fairness gap */
+	penalty = gran;
+	if (need) {
+		weighted_need = need + need / 10;
+		if (weighted_need > U64_MAX - penalty)
+			weighted_need = U64_MAX - penalty;
+		penalty += weighted_need;
+	}
+
+	/* Apply debounce to reduce ping-pong */
+	penalty = yield_deboost_apply_debounce(rq, p_target, penalty, need, gran);
+
+	/* Queue-size-based upper bound */
+	if (h_nr_queued == 2)
+		maxp = gran * 6;
+	else if (h_nr_queued == 3)
+		maxp = gran * 4;
+	else if (h_nr_queued <= 6)
+		maxp = (gran * 5) / 2;
+	else if (h_nr_queued <= 8)
+		maxp = gran * 2;
+	else if (h_nr_queued <= 12)
+		maxp = (gran * 3) / 2;
+	else
+		maxp = gran;
+
+	penalty = clamp(penalty, gran, maxp);
+
+	/* Baseline push when no fairness gap exists */
+	if (need == 0) {
+		if (h_nr_queued == 3)
+			base = (gran * 15) / 16;
+		else if (h_nr_queued >= 4 && h_nr_queued <= 6)
+			base = (gran * 5) / 8;
+		else if (h_nr_queued >= 7 && h_nr_queued <= 8)
+			base = gran / 2;
+		else if (h_nr_queued >= 9 && h_nr_queued <= 12)
+			base = (gran * 3) / 8;
+		else if (h_nr_queued > 12)
+			base = gran / 4;
+		else
+			base = gran;
+
+		if (penalty < base)
+			penalty = base;
+	}
+
+	return penalty;
+}
+
+/*
+ * Apply vruntime penalty and update EEVDF fields for consistency.
+ * Updates vruntime and deadline; vlag is not modified as it will be
+ * recalculated when the entity is dequeued/enqueued.
+ *
+ * Caller must call update_curr(cfs_rq) before invoking this function
+ * to ensure accounting is up-to-date before modifying vruntime.
+ */
+static void __maybe_unused
+yield_deboost_apply_penalty(struct sched_entity *se_y_lca,
+			    struct cfs_rq *cfs_rq, u64 penalty)
+{
+	u64 new_vruntime;
+
+	/* Overflow protection */
+	if (se_y_lca->vruntime > U64_MAX - penalty)
+		return;
+
+	new_vruntime = se_y_lca->vruntime + penalty;
+	if (new_vruntime <= se_y_lca->vruntime)
+		return;
+
+	se_y_lca->vruntime = new_vruntime;
+	se_y_lca->deadline = new_vruntime + calc_delta_fair(se_y_lca->slice, se_y_lca);
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


