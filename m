Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6123D478
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgHFAPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHFAOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:14:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1C1C0617A1
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 17:14:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v11so51393405ybm.22
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iVslrzv4xFzBXNEn359Z/Whm6d2iMTLeHC3W31lAdWA=;
        b=C/SP0oGOW1Or0jT1oy8iTM7UpU1UdLCVB8XtXPbbhM8nUGF/k9zuT96H8/k1S2BPKz
         GH5kyP4tdhCcsLhgn8rcadoYQlTO83PD9GurtMSGz+82arCK0ifyqSXg8TZyHvUT4g+e
         +k4VMFJphoSzYgDTwtYuYzosOEyZMlvPAM+opXYtnM/8i5eXMcqXDWbrgHh3H4hgN6ur
         5ydu82s+kCbf12Ocmgq1tZDBYQzWVBiShHlJEbsTOnLSQmCiDniGXpO2VNiZGWV5aQ+5
         K8kUk72cHvQAzLwAVzFnwSI06Ek+xEWFPcxTlNM8G7BoLXXbXC4tSuIo7jY5To7ZNcVV
         QcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iVslrzv4xFzBXNEn359Z/Whm6d2iMTLeHC3W31lAdWA=;
        b=mILmVhGhap3A1LcJyd3QGa7b6yUpLi91yhLM/3AuMs8zcEZmBWmonP1whWikif6Ip+
         BbRG5VZw+NCYUVdAyRMEQJjC+O1Ntr17NBCQU1jluMI6akgLs+uQsTBsiRwzTj6gun2y
         EqWvVcPS2EO8HNM9qbT3vIDoDx3K0faxGqZAbhSxFic3Mqm25a+vF+gj5uzE8VVU1j40
         W1fBnbdRGzh9LumqWjWiQRlQWUFc6WSWFbCdkrposEHZSZE2Dit3X5lh6AnP1NQWw5nA
         XM81cglcFqk5I+RkGxmGiQCcCVRwV+azjZYJ6caDmLOqRcBThjGHaXAoOVKnGxPrXBzF
         BW+g==
X-Gm-Message-State: AOAM531WBP+xNMP0ewKRABcE1xkYtj+wuXkFZMeVch8dFudimWm1AYup
        C9hoYaxdz+aDFFNKXnMzUi6oGishzRQ=
X-Google-Smtp-Source: ABdhPJySwxnkEmF4OtYZyg3Lz9Wk5GKLTOnJhkx2H+LHVcgdTtgb++K+3ddPPhSTVHbV3Od9xyNUGIbZg7Zb
X-Received: by 2002:a25:32d6:: with SMTP id y205mr9190286yby.77.1596672887452;
 Wed, 05 Aug 2020 17:14:47 -0700 (PDT)
Date:   Wed,  5 Aug 2020 17:14:29 -0700
In-Reply-To: <20200806001431.2072150-1-jwadams@google.com>
Message-Id: <20200806001431.2072150-6-jwadams@google.com>
Mime-Version: 1.0
References: <20200806001431.2072150-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 5/7] core/metricfs: expose scheduler stat information
 through metricfs
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add metricfs support for displaying percpu scheduler counters.
The top directory is /sys/kernel/debug/metricfs/stat (analogous
to /proc/stat).  Then there is a subdirectory for each scheduler
stat.  For example:

    cat /sys/kernel/debug/metricfs/stat/user/values

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-pre6
	This is work originally done by another engineer at
	google, who would rather not have their name associated with this
	patchset. They're okay with me sending it under my name.
---
 fs/proc/stat.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 46b3293015fe..deb378507b0b 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -13,6 +13,7 @@
 #include <linux/irqnr.h>
 #include <linux/sched/cputime.h>
 #include <linux/tick.h>
+#include <linux/metricfs.h>
 
 #ifndef arch_irq_stat_cpu
 #define arch_irq_stat_cpu(cpu) 0
@@ -237,3 +238,59 @@ static int __init proc_stat_init(void)
 	return 0;
 }
 fs_initcall(proc_stat_init);
+
+#ifdef CONFIG_METRICFS
+#define METRICFS_ITEM(name, field, desc) \
+static void \
+metricfs_##name(struct metric_emitter *e, int cpu) \
+{ \
+	int64_t v = kcpustat_field(&kcpustat_cpu(cpu), field, cpu); \
+	METRIC_EMIT_PERCPU_INT(e, cpu, v); \
+} \
+METRIC_EXPORT_PERCPU_COUNTER(name, desc, metricfs_##name)
+
+#define METRICFS_FUNC_ITEM(name, func, desc) \
+static void \
+metricfs_##name(struct metric_emitter *e, int cpu) \
+{ \
+	struct kernel_cpustat cpustat; \
+	int64_t v; \
+	kcpustat_cpu_fetch(&cpustat, cpu); \
+	v = func(&cpustat, cpu); \
+	METRIC_EMIT_PERCPU_INT(e, cpu, v); \
+} \
+METRIC_EXPORT_PERCPU_COUNTER(name, desc, metricfs_##name)
+
+METRICFS_ITEM(user, CPUTIME_USER, "time in user mode (nsec)");
+METRICFS_ITEM(nice, CPUTIME_NICE, "time in user mode niced (nsec)");
+METRICFS_ITEM(system, CPUTIME_SYSTEM, "time in system calls (nsec)");
+METRICFS_ITEM(irq, CPUTIME_IRQ, "time in interrupts (nsec)");
+METRICFS_ITEM(softirq, CPUTIME_SOFTIRQ, "time in softirqs (nsec)");
+METRICFS_ITEM(steal, CPUTIME_STEAL, "time in involuntary wait (nsec)");
+METRICFS_ITEM(guest, CPUTIME_GUEST, "time in guest mode (nsec)");
+METRICFS_ITEM(guest_nice, CPUTIME_GUEST_NICE,
+	"time in guest mode niced (nsec)");
+METRICFS_FUNC_ITEM(idle, get_idle_time, "time in idle (nsec)");
+METRICFS_FUNC_ITEM(iowait, get_iowait_time, "time in iowait (nsec)");
+
+static int __init init_stat_metricfs(void)
+{
+	struct metricfs_subsys *subsys;
+
+	subsys = metricfs_create_subsys("stat", NULL);
+	metric_init_user(subsys);
+	metric_init_nice(subsys);
+	metric_init_system(subsys);
+	metric_init_irq(subsys);
+	metric_init_softirq(subsys);
+	metric_init_steal(subsys);
+	metric_init_guest(subsys);
+	metric_init_guest_nice(subsys);
+	metric_init_idle(subsys);
+	metric_init_iowait(subsys);
+
+	return 0;
+}
+module_init(init_stat_metricfs);
+
+#endif
-- 
2.28.0.236.gb10cc79966-goog

