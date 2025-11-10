Return-Path: <kvm+bounces-62471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E85C44D53
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCE763AD7E1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3F5286405;
	Mon, 10 Nov 2025 03:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmNFqNYG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763B62857C7
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745565; cv=none; b=DKMhuJGP0AZox5rJw1KqmNn30ulerCbRdxS/DjKQOKQ42f3eW4rs7BD9div+6mMIiSzUNoy0zQyNVDXF8KPGUToWAfehuwuVkgWpO+FcCWtspPJpCstkPD58ZKqM11HKIowTVKJ3g4MdO8R3i0IX6yWBFF5ZdvBechE8sNop79E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745565; c=relaxed/simple;
	bh=nRWXZzHnr+QYjtzY+ghJMKruLFzKkLqJHp3ZfSMEgjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3PEGuF3rSRkvJtekKtBeL9v7AVAvB964Si8Zc0H9v9frNitibmw7ooCPoMHwRxxUDRK6kyABcPGvrfyJPGSrYGFWgeB8T6P/e6TGJUBNT4wHlL8lcpABRy03+3u/4tqADtyXcBSq/4kCFbsroXTWK2DCq21TD+TaImClOvfFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmNFqNYG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so1870282b3a.2
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745563; x=1763350363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9qw7YzFGlFaoDmp/Ld9yRvNLNmzyUxB788+zSCyjy8=;
        b=gmNFqNYGxiXKyjaVyQPTmYzjpzJQmYQP/BtXM/uzTpfG7ous3+8lRr/Escuc+9b3Yh
         vpbBfdDMEezAYKpTkGo6y7mcoHwwzX719HAaG6nFLON4EYpYme3NIgmsod3rFVf8r2id
         OikUrXeG+kpSRpB2zOY8HjfwddIYcimkAP/G3oA9AuuvccUnESsD6OKRSaIZFbR/awHi
         VrMInQ6mPQvuxdbvxXMul5KNNMufGThrwD8m3plnGLOmGW995t/BpsXSaAmdrHmnce2H
         jXf4D5Lctck5+E8PO/zGXK4jziF/TSf5dOdug9P+ske10rSkMocTI4qyqOof+Cks9MX+
         6YZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745563; x=1763350363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X9qw7YzFGlFaoDmp/Ld9yRvNLNmzyUxB788+zSCyjy8=;
        b=LsCopu5NbWiXbOGwI8RnLdAi/AHzQ0kB604NM7Q4IOF6nZMmssEdLXhhOBzZLfL91/
         mu7J5nnxcuXK7Pj3DF9xcqPsgwtewnfiGFJ7VeJB9mTcRUPtoJFYQr0YQeMXXKQ3AJT3
         lfKMNXLMMuRt1RUPmwEbaNgMBFzqdLsb1qvnFSfq30p1m0bTeBdhYastDMQNJhFrycT9
         LbCbiC0NxSPNF21i+c02HNCBEKL9n8pvTY5b8v667TRtHaBP/mkaij5/NxhmHeC4qMyv
         ApiisM7pt0kzisXG1+v0yZPOwT+MMv3jtXjsHH3ezLssyVXakZc+OCzCmcIfkfSFvvUE
         u3IA==
X-Forwarded-Encrypted: i=1; AJvYcCW7WCbs373fxgt+Uw6DW1gMpe4HGHHKjRKVI77q80RiqN976xJggsgRf9aiBRFPwU6ACTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhqMal0Hbvc0RudXS2fWfoXv4zgFcqwGocDFoMk6VOd7FWqwmz
	7bQi30pvoUOm/g2LQ2hZfCLAmbxq/+/HZZX5f5nYPmoOaVIcLetEWWeo
X-Gm-Gg: ASbGncvWY2A/wUAMzutSNzVOm1E963/r2+ZcoT2Zdypk8pbFGrqtbY/qZAZFcGIWp4L
	ZzAHJnWZID+Vqnxiwm0cuoIqq237mHd5kWTiUnYqndgsy79dStddmpaed6ovFi0DDiOT5vcsHRq
	fyrkwjtwmYqhYDWm4C6GZcTxIm8g74PiyUsrg8XyldAMHVfo4f9/P8v4KAo9jdPa1lrwBYsqAKW
	ryPL+dGkcRCjtm7WQKn9gCKja3Drxiwn+yZLYM/ID6fTtwtv0ZqtU43tBZrjEpcA5wp0TebBlP6
	8l5sYZeEDD8JFnFM6n8ENRrfj3gLha7Iy1KV7HZDQ+/3i0tVFcMYBgaNij8tQX6hhlAwbKx2uDq
	XD0cU+oZTnTcLaLruKsF9BgqhAjsrScxgdScLl25CaVsSGEZq3aWc7MhXudj7t9pTwW0N9olZLA
	==
X-Google-Smtp-Source: AGHT+IGHSkz/u8h+id2h+2kiN6Hn0irMMkmqsw1GYisIjjIpCXgcmApZJ3oJAtOVfvQCuYhZnaVvuQ==
X-Received: by 2002:a05:6a20:2450:b0:342:a7cd:9221 with SMTP id adf61e73a8af0-353a18b4d2amr8121683637.20.1762745562607;
        Sun, 09 Nov 2025 19:32:42 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:32:42 -0800 (PST)
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
Subject: [PATCH 01/10] sched: Add vCPU debooster infrastructure
Date: Mon, 10 Nov 2025 11:32:22 +0800
Message-ID: <20251110033232.12538-2-kernellwp@gmail.com>
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

Introduce foundational infrastructure for the vCPU debooster mechanism
to improve yield_to() effectiveness in virtualization workloads.

Add per-rq tracking fields for rate limiting (yield_deboost_last_time_ns)
and debouncing (yield_deboost_last_src/dst_pid, last_pair_time_ns).
Introduce global sysctl knob sysctl_sched_vcpu_debooster_enabled for
runtime control, defaulting to enabled. Add debugfs interface for
observability and initialization in sched_init().

The infrastructure is inert at this stage as no deboost logic is
implemented yet, allowing independent verification that existing
behavior remains unchanged.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/core.c  | 7 +++++--
 kernel/sched/debug.c | 3 +++
 kernel/sched/fair.c  | 5 +++++
 kernel/sched/sched.h | 9 +++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f754a60de848..03380790088b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8706,9 +8706,12 @@ void __init sched_init(void)
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
-		struct rq *rq;
+		struct rq *rq = cpu_rq(i);
+		/* init per-rq debounce tracking */
+		rq->yield_deboost_last_src_pid = -1;
+		rq->yield_deboost_last_dst_pid = -1;
+		rq->yield_deboost_last_pair_time_ns = 0;
 
-		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->__lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 02e16b70a790..905f303af752 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -508,6 +508,9 @@ static __init int sched_init_debug(void)
 	debugfs_create_file("tunable_scaling", 0644, debugfs_sched, NULL, &sched_scaling_fops);
 	debugfs_create_u32("migration_cost_ns", 0644, debugfs_sched, &sysctl_sched_migration_cost);
 	debugfs_create_u32("nr_migrate", 0644, debugfs_sched, &sysctl_sched_nr_migrate);
+	debugfs_create_u32("sched_vcpu_debooster_enabled", 0644, debugfs_sched,
+		&sysctl_sched_vcpu_debooster_enabled);
+
 
 	sched_domains_mutex_lock();
 	update_sched_domain_debugfs();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b752324270b..5b7fcc86ccff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -81,6 +81,11 @@ static unsigned int normalized_sysctl_sched_base_slice	= 700000ULL;
 
 __read_mostly unsigned int sysctl_sched_migration_cost	= 500000UL;
 
+/*
+ * vCPU debooster sysctl control
+ */
+unsigned int sysctl_sched_vcpu_debooster_enabled __read_mostly = 1;
+
 static int __init setup_sched_thermal_decay_shift(char *str)
 {
 	pr_warn("Ignoring the deprecated sched_thermal_decay_shift= option\n");
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index adfb6e3409d7..e9b4be024f89 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1292,6 +1292,13 @@ struct rq {
 	unsigned int		push_busy;
 	struct cpu_stop_work	push_work;
 
+	/* vCPU debooster rate-limit */
+	u64			yield_deboost_last_time_ns;
+	/* per-rq debounce state to avoid cross-CPU races */
+	pid_t			yield_deboost_last_src_pid;
+	pid_t			yield_deboost_last_dst_pid;
+	u64			yield_deboost_last_pair_time_ns;
+
 #ifdef CONFIG_SCHED_CORE
 	/* per rq */
 	struct rq		*core;
@@ -2816,6 +2823,8 @@ extern int sysctl_resched_latency_warn_once;
 
 extern unsigned int sysctl_sched_tunable_scaling;
 
+extern unsigned int sysctl_sched_vcpu_debooster_enabled;
+
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
-- 
2.43.0


