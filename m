Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB55D23F458
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 23:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHGVa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 17:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgHGV3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 17:29:47 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0F0C061A30
        for <kvm@vger.kernel.org>; Fri,  7 Aug 2020 14:29:42 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id s29so2607919qtc.12
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 14:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=wF2sKYSCPfS1oM0NH0xBupgB1N/FqdnAiRnprzF9CglUuoj8PFS0W/tP4/W0GJPNuX
         TyrQaJi9YYWikcZeI0piuRjIgi7S5jtC+iCUMgx8SN14rfqmKY7koAozdgACk/O4WfVJ
         yv7+JzWcCmipUuyAMJMfzjLlkCoyIjH1rZVL2QfDcg/SnWLNI8ygMAJbmEQc4uzHhanr
         cOazUENtE+ArWoT9JNvMKb2ZhVEp8J8eXYoSQYPithEBghTam0jogYR9DsEv5IJ8i0zG
         nhl2W24qoGsirdUwqm7iXnLP0F2QVNElE3cyh5qkdYDPSSJRi85rrFJtgQ3oy1s4p4h+
         sSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=Drise22o/I/ysJWqZq8jVL3BDvPOqC/18RjVMIlYwZrEkqiVCmexcdpD581pCYoXRU
         DTi48nnlvsDBHy8HrCdshMPGUEJ5/t0L4Ax4+QUbaw7VcdIEDi94sCmdruv5mzXvnKio
         izYjQwRAIZaB/en/PdhLpfVKN/v3Nfvr+QY7G3qN/tVFJ+cBBa2FvJl2T5xNHnnx1SCK
         D2KHKgtGdlavYwT2McwBbNE8V2OA9mvSeQmKeAdW7QHory7SpqqkbhA82NJDqoNGz0gG
         PQlppo5xPWLakyouwQoOwFpxXC4PJOECQdKoHBJbCf12pK4i9/zSN5b+uU0otfTb/X1c
         HPPQ==
X-Gm-Message-State: AOAM533EYEPpfk/uOFQD+rEV9GrjS5cwlgnZK9gCC7F5esZFosxMNOtO
        v/WmIRWak1Y7htwxkhiuKcrzQQD5wlM=
X-Google-Smtp-Source: ABdhPJwX9D4en+hACeaFijzp6xuG9EX9sqMK2d3+XO8tWnEdN3dt94ChhAurZV3Fxr5jxFzwH9+/rqq5AG1s
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr15191510qvv.88.1596835781537;
 Fri, 07 Aug 2020 14:29:41 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:13 -0700
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Message-Id: <20200807212916.2883031-5-jwadams@google.com>
Mime-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 4/7] core/metricfs: expose softirq information through metricfs
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add metricfs support for displaying percpu softirq counters.  The
top directory is /sys/kernel/debug/metricfs/softirq.  Then there
is a subdirectory for each softirq type.  For example:

    cat /sys/kernel/debug/metricfs/softirq/NET_RX/values

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-pre6
	This is work originally done by another engineer at
	google, who would rather not have their name associated with this
	patchset. They're okay with me sending it under my name.
---
 kernel/softirq.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index c4201b7f42b1..1ae3a540b789 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -25,6 +25,8 @@
 #include <linux/smpboot.h>
 #include <linux/tick.h>
 #include <linux/irq.h>
+#include <linux/jump_label.h>
+#include <linux/metricfs.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -738,3 +740,46 @@ unsigned int __weak arch_dynirq_lower_bound(unsigned int from)
 {
 	return from;
 }
+
+#ifdef CONFIG_METRICFS
+
+#define METRICFS_ITEM(name) \
+static void \
+metricfs_##name(struct metric_emitter *e, int cpu) \
+{ \
+	int64_t v = kstat_softirqs_cpu(name##_SOFTIRQ, cpu); \
+	METRIC_EMIT_PERCPU_INT(e, cpu, v); \
+} \
+METRIC_EXPORT_PERCPU_COUNTER(name, #name " softirq", metricfs_##name)
+
+METRICFS_ITEM(HI);
+METRICFS_ITEM(TIMER);
+METRICFS_ITEM(NET_TX);
+METRICFS_ITEM(NET_RX);
+METRICFS_ITEM(BLOCK);
+METRICFS_ITEM(IRQ_POLL);
+METRICFS_ITEM(TASKLET);
+METRICFS_ITEM(SCHED);
+METRICFS_ITEM(HRTIMER);
+METRICFS_ITEM(RCU);
+
+static int __init init_softirq_metricfs(void)
+{
+	struct metricfs_subsys *subsys;
+
+	subsys = metricfs_create_subsys("softirq", NULL);
+	metric_init_HI(subsys);
+	metric_init_TIMER(subsys);
+	metric_init_NET_TX(subsys);
+	metric_init_NET_RX(subsys);
+	metric_init_BLOCK(subsys);
+	metric_init_IRQ_POLL(subsys);
+	metric_init_TASKLET(subsys);
+	metric_init_SCHED(subsys);
+	metric_init_RCU(subsys);
+
+	return 0;
+}
+module_init(init_softirq_metricfs);
+
+#endif
-- 
2.28.0.236.gb10cc79966-goog

