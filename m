Return-Path: <kvm+bounces-62474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDFEC44D62
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7BCA34E535B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462E628851C;
	Mon, 10 Nov 2025 03:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MELO5OJP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB80D2857EA
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745576; cv=none; b=jdEjMujWQF/8phMfdKfu7aCQk43ROqI3gGOwu8BNerQCNEVlpVIHnc/6GL5kzuReCAjz8Rx9B3fU1XDtYvfIcWIE9uhLVaXM1UzMVF1vATj6q/MGJ4v2oHLylP1yJxY3E++qhg9vSKb6avbrZzF1uvLM9GdW2/ldmMuGXwxTbv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745576; c=relaxed/simple;
	bh=0DhqCZEAUwk5GW0YZMqACGIGSxBV+gPljFPnDh14bNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/suqKsozCLQSfDO0mzCQPvjP/ASjf+BATPTLT7yfSFWuQOyBgHPCbExaWLKdzGzQ+zN0/ns84t0EZP1O9s/fsS9ZYUqKrrrmxWH0OSONVElXhsloFekbWO8RTfYc89znCx27mXsG/HEz9K4pbACAi1Q3AVF4cGswClSGFA8OXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MELO5OJP; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b99dc8f439cso1035742a12.0
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745574; x=1763350374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPX8tZ0O6TTAOa2ZKkEwpS16B7GgfDVYswzaVPR09nc=;
        b=MELO5OJPOkHUDrAW/N82XYbs//lVRGq3kiGOw6E77r7YgtQgA+fcL2d3P1ODrTmMYA
         JXVRANrTvcwpR1kWRPuWSZ1FCn7YU/fE2QlyMe7fa6CTlBn2qd0uipatl6qN98HHS6mR
         dv5Al01BBolAFn96NZUC1NE4Jcs7Jh5VKMXCkhsszRFruwrLW40YBtabsMW3ftuIxS50
         MNCOQengD5e1FMAguuScpBFWW+phDjufPcyb4jz/0f1WSpAB+CaoMafOKbLgH6gej5tM
         onq+pfmZho5iQ6TFDQq/wgs+fEaUnyeS/sj3+2bEjDzNM1+SenNkDSlf+lceEQS8hgcZ
         o87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745574; x=1763350374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mPX8tZ0O6TTAOa2ZKkEwpS16B7GgfDVYswzaVPR09nc=;
        b=nLbgffXMvA62l2/q3y7f1jxsDCbAWSTcQby9plXWzCc5X/vKxeV1rKfyQ2JbMDw6+x
         1as0EhAktpWO0+xbPCdy2PfYwPB/dDoyuCtdcqNx4EbNSIlisLiQnu639oMiDawixDMF
         MwbGdYp4LEOtDkADrr0iBjQti3rSkjB6Y8XWK88iOyxEH2iAvxcZ6I01JFRx4Aw+Ncli
         nZVEKs1M0n4rJDDIsJ+8JIymL/zcgkpCTQ1qBaSzyN2BjH99m5brDzMO/eacYDh+0aDm
         xJtT7+ik8RfOm8b3j9vi7X44I7JSWS9195/oCMu7WRaf80yaxFCSUm/4XIf3q8QhK3Jn
         dbPw==
X-Forwarded-Encrypted: i=1; AJvYcCWdGspyAlKca+kkGN8uBgkhTE9IgwPWbgzia4tpN32f0Wzq+hyLn0zy2+Sj8P441ua5h0A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0GuuNTE9n5KoPA50Njyfj5vH99GKYS2c/AN+WV7STydwaiP/L
	hPRLjs3CbS5MmjQSAwAB8q+zwSe9OVER4baew9N6N1UkrVx4/DwbDaoS
X-Gm-Gg: ASbGncsaDGAgkZJBtk6tNp7uamcsizfe3X3j2NItUPWzYstKxRpMUJrE3FVAcdGKkih
	NHyJIxhU9Fby8orCY4NK2ik+8OBg3XDZtW82OPtNw67vKHJUkGchqIWcjij2eDaDcNxN5zCOyqk
	+CUTccWvTtQjXjA/LwOC7E71FamzeIki45P8R4VTdtAi5ygquN8hNIAcjVjBJVq3GD180R3xnkn
	TSXqrtejZsgPBBc8fQL/0uRGoMqpVgtirwY2quc9/+MhnqaWmRjRoEF7S4tcXHvyndYJ2fm1+qX
	4cfkpsilOIlyHCBlk+CHEKonk3IGpDNiAOM5w9EBZmkg/mctn1ubxLNVyqikmxiNoxKgbzurmAx
	ykkWY+XWxUVscc4lfbUFin/r8fFAagQrxna19lV3tf3UMCZBVw32YZssLRVykA8MYdZMImA9g3h
	s1h3V6Rebe
X-Google-Smtp-Source: AGHT+IGjidzUsSplxn0P3HZuGz53BOScmTeAp5wKz3ixJpJAL/2ddgSpIa9esU2unCmxQgSvrv47wg==
X-Received: by 2002:a17:903:2c03:b0:295:5a15:63db with SMTP id d9443c01a7336-297e570bf2emr92689815ad.61.1762745573950;
        Sun, 09 Nov 2025 19:32:53 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:32:53 -0800 (PST)
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
Subject: [PATCH 04/10] sched/fair: Add penalty calculation and application logic
Date: Mon, 10 Nov 2025 11:32:25 +0800
Message-ID: <20251110033232.12538-5-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

From: Wanpeng Li <wanpengli@tencent.com>

Implement core penalty calculation and application mechanisms for
yield deboost operations.

Add yield_deboost_apply_debounce() for reverse-pair debouncing to
prevent ping-pong behavior. When A→B then B→A occurs within ~600us,
downscale the penalty.

Add yield_deboost_calculate_penalty() to calculate vruntime penalty
based on the fairness gap (vruntime delta between yielding and target
tasks), scheduling granularity with safety floor for abnormal values,
and queue-size-based caps (2 tasks: 6.0×gran, 3: 4.0×, 4-6: 2.5×,
7-8: 2.0×, 9-12: 1.5×, >12: 1.0×). Apply special handling for zero
gap with refined multipliers and 10% boost weighting on positive gaps.

Add yield_deboost_apply_penalty() to apply the penalty with overflow
protection and update EEVDF fields (deadline, vlag) and min_vruntime.

The penalty is tuned to provide meaningful preference while avoiding
starvation, scales with queue depth, and prevents oscillation through
debouncing. These static functions will be integrated in the next
patch.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 153 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 740c002b8f1c..4bad324f3662 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9118,6 +9118,159 @@ static bool __maybe_unused yield_deboost_find_lca(struct sched_entity *se_y, str
 	return true;
 }
 
+/*
+ * Apply debounce for reverse pair within ~600us to reduce ping-pong.
+ * Downscales penalty to max(need, gran) when the previous pair was target->source,
+ * and updates per-rq debounce tracking fields to avoid cross-CPU races.
+ */
+static u64 yield_deboost_apply_debounce(struct rq *rq, struct sched_entity *se_t,
+					u64 penalty, u64 need, u64 gran)
+{
+	u64 now_ns = rq->clock;
+	struct task_struct *p_yielding = rq->curr;
+	struct task_struct *p_target = task_of(se_t);
+
+	if (p_yielding && p_target) {
+		pid_t src_pid = p_yielding->pid;
+		pid_t dst_pid = p_target->pid;
+		pid_t last_src = rq->yield_deboost_last_src_pid;
+		pid_t last_dst = rq->yield_deboost_last_dst_pid;
+		u64  last_ns  = rq->yield_deboost_last_pair_time_ns;
+
+		if (last_src == dst_pid && last_dst == src_pid &&
+		    (now_ns - last_ns) <= (600ULL * NSEC_PER_USEC)) {
+			u64 alt = need;
+			if (alt < gran)
+				alt = gran;
+			if (penalty > alt)
+				penalty = alt;
+		}
+
+		/* Update per-rq tracking */
+		rq->yield_deboost_last_src_pid = src_pid;
+		rq->yield_deboost_last_dst_pid = dst_pid;
+		rq->yield_deboost_last_pair_time_ns = now_ns;
+	}
+
+	return penalty;
+}
+
+/*
+ * Calculate penalty with debounce logic for EEVDF yield deboost.
+ * Computes vruntime penalty based on fairness gap (need) plus granularity,
+ * applies queue-size-based caps to prevent excessive penalties in small queues,
+ * and implements reverse-pair debounce (~300us) to reduce ping-pong effects.
+ * Returns 0 if no penalty needed, otherwise returns clamped penalty value.
+ */
+static u64 __maybe_unused yield_deboost_calculate_penalty(struct rq *rq, struct sched_entity *se_y_lca,
+				    struct sched_entity *se_t_lca, struct sched_entity *se_t,
+				    int nr_queued)
+{
+	u64 gran, need, penalty, maxp;
+	u64 gran_floor;
+	u64 weighted_need, base;
+
+	gran = calc_delta_fair(sysctl_sched_base_slice, se_y_lca);
+	/* Low-bound safeguard for gran when slice is abnormally small */
+	gran_floor = calc_delta_fair(sysctl_sched_base_slice >> 1, se_y_lca);
+	if (gran < gran_floor)
+		gran = gran_floor;
+
+	need = 0;
+	if (se_t_lca->vruntime > se_y_lca->vruntime)
+		need = se_t_lca->vruntime - se_y_lca->vruntime;
+
+	/* Apply 10% boost to need when positive (weighted_need = need * 1.10) */
+	penalty = gran;
+	if (need) {
+		/* weighted_need = need + 10% */
+		weighted_need = need + need / 10;
+		/* clamp to avoid overflow when adding to gran (still capped later) */
+		if (weighted_need > U64_MAX - penalty)
+			weighted_need = U64_MAX - penalty;
+		penalty += weighted_need;
+	}
+
+	/* Apply debounce via helper to avoid ping-pong */
+	penalty = yield_deboost_apply_debounce(rq, se_t, penalty, need, gran);
+
+	/* Upper bound (cap): slightly more aggressive for mid-size queues */
+	if (nr_queued == 2)
+		maxp = gran * 6;		/* Strongest push for 2-task ping-pong */
+	else if (nr_queued == 3)
+		maxp = gran * 4;		/* 4.0 * gran */
+	else if (nr_queued <= 6)
+		maxp = (gran * 5) / 2;		/* 2.5 * gran */
+	else if (nr_queued <= 8)
+		maxp = gran * 2;		/* 2.0 * gran */
+	else if (nr_queued <= 12)
+		maxp = (gran * 3) / 2;		/* 1.5 * gran */
+	else
+		maxp = gran;			/* 1.0 * gran */
+
+	if (penalty < gran)
+		penalty = gran;
+	if (penalty > maxp)
+		penalty = maxp;
+
+	/* If no need, apply refined baseline push (low risk + mid risk combined). */
+	if (need == 0) {
+		/*
+		 * Baseline multiplier for need==0:
+		 *   2        -> 1.00 * gran
+		 *   3        -> 0.9375 * gran
+		 *   4–6      -> 0.625 * gran
+		 *   7–8      -> 0.50  * gran
+		 *   9–12     -> 0.375 * gran
+		 *   >12      -> 0.25  * gran
+		 */
+		base = gran;
+		if (nr_queued == 3)
+			base = (gran * 15) / 16;	/* 0.9375 */
+		else if (nr_queued >= 4 && nr_queued <= 6)
+			base = (gran * 5) / 8;		/* 0.625 */
+		else if (nr_queued >= 7 && nr_queued <= 8)
+			base = gran / 2;		/* 0.5 */
+		else if (nr_queued >= 9 && nr_queued <= 12)
+			base = (gran * 3) / 8;		/* 0.375 */
+		else if (nr_queued > 12)
+			base = gran / 4;		/* 0.25 */
+
+		if (penalty < base)
+			penalty = base;
+	}
+
+	return penalty;
+}
+
+/*
+ * Apply penalty and update EEVDF fields for scheduler consistency.
+ * Safely applies vruntime penalty with overflow protection, then updates
+ * EEVDF-specific fields (deadline, vlag) and cfs_rq min_vruntime to maintain
+ * scheduler state consistency. Returns true on successful application,
+ * false if penalty cannot be safely applied.
+ */
+static void __maybe_unused yield_deboost_apply_penalty(struct rq *rq, struct sched_entity *se_y_lca,
+				 struct cfs_rq *cfs_rq_common, u64 penalty)
+{
+	u64 new_vruntime;
+
+	/* Overflow protection */
+	if (se_y_lca->vruntime > (U64_MAX - penalty))
+		return;
+
+	new_vruntime = se_y_lca->vruntime + penalty;
+
+	/* Validity check */
+	if (new_vruntime <= se_y_lca->vruntime)
+		return;
+
+	se_y_lca->vruntime = new_vruntime;
+	se_y_lca->deadline = se_y_lca->vruntime + calc_delta_fair(se_y_lca->slice, se_y_lca);
+	se_y_lca->vlag = avg_vruntime(cfs_rq_common) - se_y_lca->vruntime;
+	update_min_vruntime(cfs_rq_common);
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


