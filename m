Return-Path: <kvm+bounces-66295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA40ACCE64D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CEF43305AC52
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E475129BDBC;
	Fri, 19 Dec 2025 03:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUkhpetp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8845F29B200
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116427; cv=none; b=l1vip+VwrrCj9oB65MC8MclMo6vi5ORuzKEtpgtr7O4+ZWixY2gvtK5P8zu3bgLP4UKfjj2WcbCJL2+vytycebcNOlYk7PFHJB/VtyFh2w5y9wfDVHOIm+8Q3MpJyn64i8ylHMUu6dyVeoR01uRU0U14nEfMYW/S5jI7Dzl1sXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116427; c=relaxed/simple;
	bh=w0CW7uo/vOZWuw/zve3/fMNCvsXnM4VsZHL3uPvJ9u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoviyIYg6jI8ERX1z/TBoUHEAmesWa58yhrnhxxcSRxSY6t2U8llLsJENYlOhoPCEMHHsCpKZhTjr/lm+kaDGP+Uo6NBDGOG+5n6VT1deR7nosCxQxcj/rWxWdPJWuNoh5OxY9zIuNH9fS3gcpx+y5kWQqy0c2l/tltiWofy83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUkhpetp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a099233e8dso12439645ad.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116424; x=1766721224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iU1adEHK7jmf27ulImKBopSB3D0y4RPvKljgfgBZ8/o=;
        b=PUkhpetpfzTTjY1w+XfzjaY3U0Idbq1rfoY9/9UYaxGuJEyjJVCeNT0sPcMrSlJpnY
         q8SQsay+xWgv2JQT1sM7UOYBTc7a3e845zlUYZS9nXdWdF7+eq6RrP/12GHS32WWsBjC
         ZMHEEZP7VNE9kQfAv6L4o3Zy6ZaGy1z3qt1b+bg5eO9rbINscZh0AB3JGpbYFIqrkU05
         SDIP1W1UEqdBDjC2j0X5kcsC3MGVZWegzwLsHc9zJ6zCrGqNKg7ecJcAMBMEPpibndLK
         EDNrcLzXa0NH3t9WggVURhzORSCHDQqhJ1iH25HwKsHUfBN9lrQCqFAqGb97Zoa4LEFw
         ts6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116424; x=1766721224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iU1adEHK7jmf27ulImKBopSB3D0y4RPvKljgfgBZ8/o=;
        b=Dk50gfL7uVK0aYv+AdEvlCEK9nM+JUfHe6LY0eal7+6ncHmKcwyygMk2Z7Pbq+vOKG
         7dLL3O+BlJyjxA8NbhqMs8ybBXTn3TPnVObFsOj6tETY8UqpnX9unjdNxRxMxz9NzczJ
         4qFlG6f2UGUICsHT4jQQuSqd7rCdMtHETBxEEDkaf/hqERnBsRbvnX9GJvMESiUxCy6x
         uj6kXD/8dIb6jQCczxg7b5X7G3OXt5JFUCOrRxD/wL7TPiHT/hu/HnzsthvIhalLKOHM
         kkGLCY10HUDhiRVcTCB8ZajlEDlUtz7Za1/55hyyfyf2JflYb/8Wbmo6Z/mYXF/X4MJn
         Nk0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEmQnSuankMX6mhP2iycB6H137TfQkPAvslzMID5TCRm34Fv13p2PLIJ8AuBbJxuDA6tk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd/kYfNgzWrmgFZOl1M3b44NvHXhc2T+7HdWD8RPGioaKigdDU
	rFaja3UFtZ6jsckc8JLDs7s3tCUkmOjVEcx5zZFrIMB/llj4p9/GeKcR
X-Gm-Gg: AY/fxX4idV+Rg52dhwWQ0w5skVDyTJOTfCGvtJvksC/wOeol7EFZ3cP3VIhxEG0JH+j
	0hdUS0wy4GjtI9uu7TOyCKiCI8OGjvnZUsjh2m129WkPXdFWOY9hXP+cWQ1pLNn9FeABpg/kIaa
	m6BKvpqADocUf5JWenTqeYkmBygNkMRjUS8hir6yKzh60cb14VPbrkShIW8aw5Cmfn/BS8pQ0+C
	qOxM51NHFsiuNqiNG6vQRbkxx5I0LPdx3CEUSIppyrwc1rnqKiFgifQae3eGDiDFG6MDeeZjOVz
	XaFvpPjHQsEllwPZVsu/zw+j1IT3pf/XGVCKuGpH9+14y6YdLbeU7zRht76I0EUx2R8pBXyHMFH
	cSicJMDzbk4tGzmY5dHGzUqcCgsUEQxSKvFDFbqra1EyeFx6qgdWVYdDbaoWHRMgiLoeRz0E3vx
	HjjWzx/TAOFg==
X-Google-Smtp-Source: AGHT+IHq/XTLa4HqH0djQQD62duqDqJhKgnIGFSZ4XSY56Y+J9Hdfzsd3Z/LiRxZAWPyY68QIrnyoQ==
X-Received: by 2002:a17:902:c943:b0:295:9db1:ff3a with SMTP id d9443c01a7336-2a2f2735164mr15581985ad.28.1766116424485;
        Thu, 18 Dec 2025 19:53:44 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:44 -0800 (PST)
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
Subject: [PATCH v2 1/9] sched: Add vCPU debooster infrastructure
Date: Fri, 19 Dec 2025 11:53:25 +0800
Message-ID: <20251219035334.39790-2-kernellwp@gmail.com>
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

v1 -> v2:
- Rename debugfs entry from sched_vcpu_debooster_enabled to
  vcpu_debooster_enabled for consistency with other sched debugfs entries
- Add explicit initialization of yield_deboost_last_time_ns to 0 in
  sched_init() for clarity
- Improve comments to follow kernel documentation style

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/core.c  |  9 +++++++--
 kernel/sched/debug.c |  2 ++
 kernel/sched/fair.c  |  7 +++++++
 kernel/sched/sched.h | 12 ++++++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 41ba0be16911..9f0936b9c1c9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8606,9 +8606,14 @@ void __init sched_init(void)
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
-		struct rq *rq;
+		struct rq *rq = cpu_rq(i);
+
+		/* Initialize vCPU debooster per-rq state */
+		rq->yield_deboost_last_time_ns = 0;
+		rq->yield_deboost_last_src_pid = -1;
+		rq->yield_deboost_last_dst_pid = -1;
+		rq->yield_deboost_last_pair_time_ns = 0;
 
-		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->__lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 41caa22e0680..13e67617549d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -508,6 +508,8 @@ static __init int sched_init_debug(void)
 	debugfs_create_file("tunable_scaling", 0644, debugfs_sched, NULL, &sched_scaling_fops);
 	debugfs_create_u32("migration_cost_ns", 0644, debugfs_sched, &sysctl_sched_migration_cost);
 	debugfs_create_u32("nr_migrate", 0644, debugfs_sched, &sysctl_sched_nr_migrate);
+	debugfs_create_u32("vcpu_debooster_enabled", 0644, debugfs_sched,
+			   &sysctl_sched_vcpu_debooster_enabled);
 
 	sched_domains_mutex_lock();
 	update_sched_domain_debugfs();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da46c3164537..87c30db2c853 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -81,6 +81,13 @@ static unsigned int normalized_sysctl_sched_base_slice	= 700000ULL;
 
 __read_mostly unsigned int sysctl_sched_migration_cost	= 500000UL;
 
+/*
+ * vCPU debooster: runtime toggle for yield_to() vruntime penalty mechanism.
+ * When enabled (default), yield_to() applies bounded vruntime penalties to
+ * improve lock holder scheduling in virtualized environments.
+ */
+unsigned int sysctl_sched_vcpu_debooster_enabled __read_mostly = 1;
+
 static int __init setup_sched_thermal_decay_shift(char *str)
 {
 	pr_warn("Ignoring the deprecated sched_thermal_decay_shift= option\n");
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d30cca6870f5..b7aa0d35c793 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1294,6 +1294,16 @@ struct rq {
 	unsigned int		push_busy;
 	struct cpu_stop_work	push_work;
 
+	/*
+	 * vCPU debooster: per-rq state for yield_to() optimization.
+	 * Used to rate-limit and debounce vruntime penalties applied
+	 * when a vCPU yields to a lock holder.
+	 */
+	u64			yield_deboost_last_time_ns;
+	pid_t			yield_deboost_last_src_pid;
+	pid_t			yield_deboost_last_dst_pid;
+	u64			yield_deboost_last_pair_time_ns;
+
 #ifdef CONFIG_SCHED_CORE
 	/* per rq */
 	struct rq		*core;
@@ -2958,6 +2968,8 @@ extern int sysctl_resched_latency_warn_once;
 
 extern unsigned int sysctl_sched_tunable_scaling;
 
+extern unsigned int sysctl_sched_vcpu_debooster_enabled;
+
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
-- 
2.43.0


