Return-Path: <kvm+bounces-38480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C49A3A963
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A33B17A22E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D60211A05;
	Tue, 18 Feb 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="qMo8T24K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABB72116F4;
	Tue, 18 Feb 2025 20:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910424; cv=none; b=W3msEgYBiosMU5i358JPdy/9wxyQa00U3CAInWTOKGW7We0keGM7Uxb+guxDB0K5SHgkXuWCHggW2VrZUmHDVCZoGGsZwaRxxz39bH53aRpEjFZl1Qar4L3ScNMbefqMVftASoIFFvDxg07nNNBhHG8RACJaumAbzmjXV+9zr5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910424; c=relaxed/simple;
	bh=1z+s/5oLUgkpVX+TZ6VZExymfp2lWHBOshwhP3rfD88=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmc8ktXUKy3P7wnLG6pez3Mk5OEzA8YxrkL6ANP10uBtL/zVVwYeWmnF/G11pGHTJkvL1/e/+gfZDbqJeImMZH+Ykpn6p1Wk02/4ESm9EFtaK36rFkUEz+0UJGKcbe+MaQCBnDvBbztBQfteoAU+95D+2P9PXrXBQggJF2OhBjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=qMo8T24K; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739910423; x=1771446423;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=VRi00QC9itLgrUbe0p8KBclI5A1SKRWOXY7c+YjuKak=;
  b=qMo8T24K60PtM1d/PXXQskCAj5qQ3TeJItBi/pbVi+z7RjH1123+LbYH
   Qh5osn5vdhMCM/nmZiYDULSLn0D+nHYjernLHSxcOIDRBow7XneSC63x5
   VS5z8Sip4umxqP092cJWjkkxHD0EiAIYyRrYXRy2TOer+9Newl/IklreP
   A=;
X-IronPort-AV: E=Sophos;i="6.13,296,1732579200"; 
   d="scan'208";a="719883548"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 20:27:02 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:16632]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.0.236:2525] with esmtp (Farcaster)
 id 6628eb86-21a6-4254-8fbe-883f5b39d6fa; Tue, 18 Feb 2025 20:27:00 +0000 (UTC)
X-Farcaster-Flow-ID: 6628eb86-21a6-4254-8fbe-883f5b39d6fa
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 18 Feb 2025 20:27:00 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.227) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 18 Feb 2025 20:26:55 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <sieberf@amazon.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 1/3] fs/proc: Add gtime halted to proc/<pid>/stat
Date: Tue, 18 Feb 2025 22:26:01 +0200
Message-ID: <20250218202618.567363-2-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250218202618.567363-1-sieberf@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The hypervisor may need to gain visibility to CPU guest activity for various
purposes such as reporting it to monitoring systems that tracks the amount
of work done on behalf of a guest.

With guest hlt, pause and mwait passthrough, gtime is not useful since the
guest never tells the hypervisor that it has halted execution. So the reported
guest time is always 100% even when the guest is completely halted.

Add a new concept of guest halted time that allows the hypervisor to keep
track of the number of halted cycles a CPU spends in guest mode.

The value is reported in proc/<pid>/stat and defaults to zero for architectures
that do not support it.
---
 Documentation/filesystems/proc.rst | 1 +
 fs/proc/array.c                    | 7 ++++++-
 include/linux/sched.h              | 1 +
 include/linux/sched/signal.h       | 1 +
 kernel/exit.c                      | 1 +
 kernel/fork.c                      | 2 +-
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 09f0aed5a08b..bbb230420fa4 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -386,6 +386,7 @@ It's slow but very precise.
   env_end       address below which program environment is placed
   exit_code     the thread's exit_code in the form reported by the waitpid
 		system call
+  gtime_halted  guest time when the cpu is halted of the task in jiffies
   ============= ===============================================================

 The /proc/PID/maps file contains the currently mapped memory regions and
diff --git a/fs/proc/array.c b/fs/proc/array.c
index d6a0369caa93..0788ef0fa710 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -478,7 +478,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt, cmaj_flt, min_flt, maj_flt;
-	u64 cutime, cstime, cgtime, utime, stime, gtime;
+	u64 cutime, cstime, cgtime, utime, stime, gtime, gtime_halted;
 	unsigned long rsslim = 0;
 	unsigned long flags;
 	int exit_code = task->exit_code;
@@ -556,12 +556,14 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			min_flt = sig->min_flt;
 			maj_flt = sig->maj_flt;
 			gtime = sig->gtime;
+			gtime_halted = sig->gtime_halted;

 			rcu_read_lock();
 			__for_each_thread(sig, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
+				gtime_halted += t->gtime_halted;
 			}
 			rcu_read_unlock();
 		}
@@ -575,6 +577,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
 		gtime = task_gtime(task);
+		gtime_halted = task->gtime_halted;
 	}

 	/* scale priority and nice values from timeslices to -20..20 */
@@ -662,6 +665,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	else
 		seq_puts(m, " 0");

+	seq_put_decimal_ull(m, " ", nsec_to_clock_t(gtime_halted));
+
 	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9632e3318e0d..5f6745357e20 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1087,6 +1087,7 @@ struct task_struct {
 	u64				stimescaled;
 #endif
 	u64				gtime;
+	u64				gtime_halted;
 	struct prev_cputime		prev_cputime;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 	struct vtime			vtime;
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index d5d03d919df8..633082f7c7b8 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -187,6 +187,7 @@ struct signal_struct {
 	seqlock_t stats_lock;
 	u64 utime, stime, cutime, cstime;
 	u64 gtime;
+	u64 gtime_halted;
 	u64 cgtime;
 	struct prev_cputime prev_cputime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
diff --git a/kernel/exit.c b/kernel/exit.c
index 3485e5fc499e..ba6efc6900d0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -188,6 +188,7 @@ static void __exit_signal(struct task_struct *tsk)
 	sig->utime += utime;
 	sig->stime += stime;
 	sig->gtime += task_gtime(tsk);
+	sig->gtime_halted += tsk->gtime_halted;
 	sig->min_flt += tsk->min_flt;
 	sig->maj_flt += tsk->maj_flt;
 	sig->nvcsw += tsk->nvcsw;
diff --git a/kernel/fork.c b/kernel/fork.c
index 735405a9c5f3..e3453084bb5a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2296,7 +2296,7 @@ __latent_entropy struct task_struct *copy_process(

 	init_sigpending(&p->pending);

-	p->utime = p->stime = p->gtime = 0;
+	p->utime = p->stime = p->gtime = p->gtime_halted = 0;
 #ifdef CONFIG_ARCH_HAS_SCALED_CPUTIME
 	p->utimescaled = p->stimescaled = 0;
 #endif
--
2.43.0




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


