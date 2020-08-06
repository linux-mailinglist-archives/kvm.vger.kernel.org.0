Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2580223D47C
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHFAPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgHFAOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:14:47 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1518C06179F
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 17:14:46 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id q18so29012238qkq.11
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=P2x3PctwOJH5TuP9RSIAld4PsP/j3XNf0AvQXQ/DodKu083Iwcspo5T0atbcBDsOrJ
         0muuNfCGfJv2UYZs4THq+0JJHbABbX5/d+U9rXKBjhLAcqh/qA9l+wDxBWI5FlGn48GT
         n//FasAVkPn21NR0+MvA0EQn1nxFbtKy6fABVAr7Mp1OMARjoHZ8T/jsqEcUhx3bj6/2
         V+ADQDg90iYizGu72GdVwVjhB0p43nWwLP9qqQSCMCjudSGp4lbe1Y6GvsMCowNuzxah
         1ljHzyW2xnvEJmsBpWAhJgQzacZvfeFe36VRxoG3XAwexV99oPDYkDxdZgV3+aIYp2vJ
         VEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=t2Ehr+JY/SKjU4XTRJPWabsiB1vWaS91pctFI5iXAWemi9xihVkt00k9/KW7y0CCPD
         Y5eNU/oOuwimqVaiMe228j/HBnGVNh3TLSaacYEX0+eB7h8U3JFUfPZk163s2eaUo1jL
         tSSqNbxkOuQONWuB0UtvcmuYeZwe91lDvaeBV6Brif1f9zFD6DLk5NmKIL+pK9Gs0mB6
         PGNHPvVSxoXpwsZoVio488vzInVcDnVZFJDdjniY2dP3jff0y73bORiPJUbug/8LfD4u
         W3q8OyNY984waqNfihGUmV3qOeJrtso4gi8x8lgi7DViIJPKzrkgZpL5S+RkrGqA4m4g
         XSlw==
X-Gm-Message-State: AOAM533NmvJyhBslS5kEgKuhLDt0CFsaZE0k2ixKPdXn+z4VvGKwpLEY
        ppNyfkC/pQ5ox4PsbTIIEDNeToZcYFk=
X-Google-Smtp-Source: ABdhPJwdyTprB9qz0EIRwUGruGxBVFwvWVEzapoGVgGGJXsE7/AA/AyXt0lpcFDiRYIFwQKbOSD1eVkGKwTK
X-Received: by 2002:ad4:4ea5:: with SMTP id ed5mr6415961qvb.130.1596672885491;
 Wed, 05 Aug 2020 17:14:45 -0700 (PDT)
Date:   Wed,  5 Aug 2020 17:14:28 -0700
In-Reply-To: <20200806001431.2072150-1-jwadams@google.com>
Message-Id: <20200806001431.2072150-5-jwadams@google.com>
Mime-Version: 1.0
References: <20200806001431.2072150-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 4/7] core/metricfs: expose softirq information through metricfs
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

