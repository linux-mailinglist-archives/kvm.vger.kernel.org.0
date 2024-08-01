Return-Path: <kvm+bounces-22835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7B694424E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 06:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 948EE1F22DEF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 04:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDD113DDD5;
	Thu,  1 Aug 2024 04:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ex0DYgu7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE671422C2
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488357; cv=none; b=DILb8WMzfv3Ef9fAIK3nkN4iKBtRfAMyxbB11mv0S8BCOl0v1L5Nn12+4miuGBKfG9Rhk2sH0EjNUtnFmKXNewJaQ2ujP4I4ImcqknjP39NqaqR8HA+VUDIf2tEdZcoa+3iM328z7c7ZEx5K6Njz0D7PXhvjujzv5Q1Jo5PlhSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488357; c=relaxed/simple;
	bh=EwrTeTKxjkriGU2aCK6fduTgKiXaA6b+BnkXf+Qj9ZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OuRtVLZ+mK49Jqb7aHWu7xFInkNCepoigCAxY1iQFWB04EFz1j8yzi4u0idyPcX8qgH7rpVdnK+PB0gcF8E6rV68llwWYdJ7GGlia+JJB3y8eZiGrX5+Do0bHp/pD0cjiHG27G6c7jfzQHKg7JEwdhY/juGF/a0+W1rWqoyCKic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ex0DYgu7; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso865419276.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488355; x=1723093155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=30BVAe+lKKTv8P9DRYR4aCbEP24dhJmDTry4BD28JV4=;
        b=Ex0DYgu7uMf12V/WcnHY1PvTkF33ZiIfV4lRCvFoOF+HaL6pgdk8HOIyE5aKcFVRDA
         nVQh7WrkxVgtJeyzFf2Ua87Sq06XeQ46rXUOYAyPCZuz1vTPeU3GL0ver1UtzRg9bOnT
         lax9U+eNBX1ZYVRqMEn0nyQ+1aAhUgjIqSA+KJz7t4hpT2TeOKMi2d3hiUobhUcDuYVi
         ubdhkv5u4zeSMvUq9YMU1bw/Ufb7ImXv9Khg6+rYFQD7OBIpHGAt3nLn9HFp3v7YSgbj
         9GLUva0sQwg+buJdUwLp4ggahSEylks589JetjEjTD61aEPsteoD0tOoqkR+fafTES/4
         xdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488355; x=1723093155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=30BVAe+lKKTv8P9DRYR4aCbEP24dhJmDTry4BD28JV4=;
        b=unzRWkcYZ509KUDe8hFhjNH+uRGTOtUGB8W6VBzCGdC/kYNz41BDXvriUfW745FF2a
         qitFYx45KLBbimXCFmd9db7gbPnGt8UdlSZsi2wMHcJ6jPNVV8th6ixZcc5EqL9Rk+LI
         KCK3RSYSUnbhLYz3zyJCZYkjAuV9TfT45dkTrXbJEb1NtYTbloyQU5pdYzLG7jHFUWuQ
         o/UT58xPLorm0fE9S25Xe3DnZIW2Gco3kL/2DY28rfothP1MvfCb4k2cgC5EuGBbuQsf
         Z/sL07jw2cNNzYIrDcnVdjET3wnzwR9sxmq02xwFEuPGALGt/ZVTvfvB6dNpGPhsg+pn
         vkgA==
X-Forwarded-Encrypted: i=1; AJvYcCUeHevhA4oioMxVe4uyVo/H0DtwrNz7TBB5W1JGG59U1G2YQImhxQVDy3T7FNMcHzcp1k0ahtmdWieC4uJloenr9dTI
X-Gm-Message-State: AOJu0YwUKfmIxHDkMCKYHHbd/mc0eMMJqml82PV91EoZZ4RK+ETEx2Uh
	rl08IlQLFaBc6WdOwgXg48twex8ttWwttVgx40SUgCTvHGRe0HySF7pnicPXq77kXberd6vBZbc
	so4HKBQ==
X-Google-Smtp-Source: AGHT+IGvhovXiEJA501fg8AsGQ0Ln/NIeUOKimM+zmuKhSDeJfSO8OIJ055qsyeZqjkBJTB18xRTjwVfaXKZ
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:2203:b0:e0b:c99d:b6d4 with SMTP id
 3f1490d57ef6-e0bcd23d3c0mr2531276.5.1722488354932; Wed, 31 Jul 2024 21:59:14
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:11 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-3-mizhang@google.com>
Subject: [RFC PATCH v3 02/58] sched/core: Drop spinlocks on contention iff
 kernel is preemptible
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Use preempt_model_preemptible() to detect a preemptible kernel when
deciding whether or not to reschedule in order to drop a contended
spinlock or rwlock.  Because PREEMPT_DYNAMIC selects PREEMPTION, kernels
built with PREEMPT_DYNAMIC=y will yield contended locks even if the live
preemption model is "none" or "voluntary".  In short, make kernels with
dynamically selected models behave the same as kernels with statically
selected models.

Somewhat counter-intuitively, NOT yielding a lock can provide better
latency for the relevant tasks/processes.  E.g. KVM x86's mmu_lock, a
rwlock, is often contended between an invalidation event (takes mmu_lock
for write) and a vCPU servicing a guest page fault (takes mmu_lock for
read).  For _some_ setups, letting the invalidation task complete even
if there is mmu_lock contention provides lower latency for *all* tasks,
i.e. the invalidation completes sooner *and* the vCPU services the guest
page fault sooner.

But even KVM's mmu_lock behavior isn't uniform, e.g. the "best" behavior
can vary depending on the host VMM, the guest workload, the number of
vCPUs, the number of pCPUs in the host, why there is lock contention, etc.

In other words, simply deleting the CONFIG_PREEMPTION guard (or doing the
opposite and removing contention yielding entirely) needs to come with a
big pile of data proving that changing the status quo is a net positive.

Opportunistically document this side effect of preempt=full, as yielding
contended spinlocks can have significant, user-visible impact.

Fixes: c597bfddc9e9 ("sched: Provide Kconfig support for default dynamic preempt mode")
Link: https://lore.kernel.org/kvm/ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Friedrich Weber <f.weber@proxmox.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 +++-
 include/linux/spinlock.h                        | 14 ++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b600df82669d..ebb971a57d04 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4774,7 +4774,9 @@
 			none - Limited to cond_resched() calls
 			voluntary - Limited to cond_resched() and might_sleep() calls
 			full - Any section that isn't explicitly preempt disabled
-			       can be preempted anytime.
+			       can be preempted anytime.  Tasks will also yield
+			       contended spinlocks (if the critical section isn't
+			       explicitly preempt disabled beyond the lock itself).
 
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3fcd20de6ca8..63dd8cf3c3c2 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -462,11 +462,10 @@ static __always_inline int spin_is_contended(spinlock_t *lock)
  */
 static inline int spin_needbreak(spinlock_t *lock)
 {
-#ifdef CONFIG_PREEMPTION
+	if (!preempt_model_preemptible())
+		return 0;
+
 	return spin_is_contended(lock);
-#else
-	return 0;
-#endif
 }
 
 /*
@@ -479,11 +478,10 @@ static inline int spin_needbreak(spinlock_t *lock)
  */
 static inline int rwlock_needbreak(rwlock_t *lock)
 {
-#ifdef CONFIG_PREEMPTION
+	if (!preempt_model_preemptible())
+		return 0;
+
 	return rwlock_is_contended(lock);
-#else
-	return 0;
-#endif
 }
 
 /*
-- 
2.46.0.rc1.232.g9752f9e123-goog


