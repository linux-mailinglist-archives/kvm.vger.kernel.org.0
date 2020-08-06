Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A13423D471
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHFAPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgHFAOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:14:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9B3C061756
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 17:14:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a127so59293243ybb.14
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Xwhl6oTAS7prpbXCRZdZshg5xz57JrEbZ056Cu9NiLQ=;
        b=VKxFANE2z8MkZfjpbuaXTo5P0s50q7AGLs5Y57qk8+qSFN45yWmnON2wvsbgP2aWqe
         EBFsVb1emqXoo16aaqh2e223MPRKIRHggIQI3gjhx3BjgZXiqMIozVHGxjmXQNLXgqoo
         L/BEsleyNk+bsbmRzMwQFTYc64tVPcEWQ9Jcgx+IytqxeluWoQU7xOd12x+RomIJyoib
         TeKOijeKxj1NcXOxiPSMQxBecKm+jMeR5jnHGv3MV4k7dAat60xTlWY/rLDArWBXZtqY
         KXAFOX83AU/ixka8rnhi3PcwcrJ1odMJHVhJCXpVf2GfwNqYwvHVeuI4eE8brjJKtC/R
         3kaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xwhl6oTAS7prpbXCRZdZshg5xz57JrEbZ056Cu9NiLQ=;
        b=fxIzROkRiNkBoYCYcHnCediXMJkAuvZb05UHCPqxkba2wV0jbI/8GRxPzvi1SVbbXh
         0zNCZatOcTfgh2pC2EpQ2RRM26rT6pOlJYUToMAuwpz5zhQ0B+moLZs8DFP1LcdjAnB7
         oOl3mwrnIPnQZ6oyU6Ucp2sEdw1+tzGK80m6u3gnS1H9HJ4xcTsCB7YasGK8gFxFZ+cS
         wyHUWcjSuOM0W+tDlvaE9ElU/vwawv4N6dV4mowtoTKQgBwvc/iasYGJK2Vzs0UrsmTa
         wRD70JaJNoffpI9l5u4rvoDL6pV2zNJR7NND/jZD9ws5UKxL3k4RG9Z0Dm2AXQxfGqdd
         W+pw==
X-Gm-Message-State: AOAM532l0o44srVdWcrWj4MAvEqD1k02m8luRHmcnQkt7y2/CvTz4xsY
        sj3iLJ45Q89vgd8HYtzvGhIwg3GlaoY=
X-Google-Smtp-Source: ABdhPJwRQIuaxLlvD7nKGgHBW7zgYR9Ow2PSyUVWdoP+ivcY83drRuY5X7rDV9GVTrdHfjvWqwKBlSLXadLA
X-Received: by 2002:a25:b41:: with SMTP id 62mr9521967ybl.8.1596672883707;
 Wed, 05 Aug 2020 17:14:43 -0700 (PDT)
Date:   Wed,  5 Aug 2020 17:14:27 -0700
In-Reply-To: <20200806001431.2072150-1-jwadams@google.com>
Message-Id: <20200806001431.2072150-4-jwadams@google.com>
Mime-Version: 1.0
References: <20200806001431.2072150-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 3/7] core/metricfs: metric for kernel warnings
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

Count kernel warnings by function name of the caller.

Each time WARN() is called, which includes WARN_ON(), increment a counter
in a 256-entry hash table. The table key is the entry point of the calling
function, which is found using kallsyms.

We store the name of the function in the table (because it may be a
module address); reporting the metric just walks the table and prints
the values.

The "warnings" metric is cumulative.

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-rc6, removed google-isms,
	added lockdep_assert_held(), NMI handling, ..._unknown*_counts
	and locking in warn_tbl_fn(); renamed warn_metric... to
	warn_tbl...

	The original work was done in 2012 by an engineer no longer
	at Google.
---
 kernel/panic.c | 131 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index e2157ca387c8..c019b41ab387 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -31,6 +31,9 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/utsname.h>
+#include <linux/hash.h>
+#include <linux/metricfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -568,6 +571,133 @@ void oops_exit(void)
 	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
+#ifdef CONFIG_METRICFS
+
+/*
+ * Hash table from function address to count of WARNs called within that
+ * function.
+ * So far this is an add-only hash table (ie, entries never removed), so some
+ * simplifying assumptions are made.
+ */
+#define WARN_TBL_BITS (8)
+#define WARN_TBL_SIZE (1<<WARN_TBL_BITS)
+static struct {
+	void *function;
+	int count;
+	char function_name[KSYM_NAME_LEN];
+} warn_tbl[WARN_TBL_SIZE];
+
+static DEFINE_SPINLOCK(warn_tbl_lock);
+static atomic_t warn_tbl_unknown_lookup_count = ATOMIC_INIT(0);
+static atomic_t warn_tbl_unknown_nmi_count = ATOMIC_INIT(0);
+static int warn_tbl_unknown_count;
+
+/*
+ * Find the entry corresponding to the given function address.
+ * Insert a new entry if one doesn't exist yet.
+ * Returns -1 if the hash table is full.
+ */
+static int tbl_find(void *caller_function)
+{
+	int entry, start_entry;
+
+	lockdep_assert_held(&warn_tbl_lock);
+
+	start_entry = hash_ptr(caller_function, WARN_TBL_BITS);
+	entry = start_entry;
+	do {
+		if (warn_tbl[entry].function == caller_function)
+			return entry;
+		if (warn_tbl[entry].function == NULL) {
+			if (!kallsyms_lookup((unsigned long)caller_function,
+					NULL, NULL, NULL,
+					warn_tbl[entry].function_name))
+				return -1;
+			warn_tbl[entry].function = caller_function;
+			return entry;
+		}
+		entry = (entry + 1) % (WARN_TBL_SIZE);
+	} while (entry != start_entry);
+
+	return -1;
+}
+
+static void tbl_increment(void *caller)
+{
+	void *caller_function;
+	unsigned long caller_offset;
+	unsigned long flags;
+	int entry;
+
+	if (!kallsyms_lookup_size_offset(
+			(unsigned long)caller, NULL, &caller_offset)) {
+		atomic_inc(&warn_tbl_unknown_lookup_count);
+		return;
+	}
+	/* use function entrypoint */
+	caller_function = caller - caller_offset;
+
+	if (in_nmi()) {
+		if (!spin_trylock_irqsave(&warn_tbl_lock, flags)) {
+			atomic_inc(&warn_tbl_unknown_nmi_count);
+			return;
+		}
+	} else {
+		spin_lock_irqsave(&warn_tbl_lock, flags);
+	}
+	entry = tbl_find(caller_function);
+	if (entry >= 0)
+		warn_tbl[entry].count++;
+	else
+		warn_tbl_unknown_count++;
+
+	spin_unlock_irqrestore(&warn_tbl_lock, flags);
+}
+
+/*
+ * Export the hash table to metricfs.
+ */
+static void warn_tbl_fn(struct metric_emitter *e)
+{
+	int i;
+	unsigned long flags;
+	int unknown_count = READ_ONCE(warn_tbl_unknown_count) +
+		atomic_read(&warn_tbl_unknown_nmi_count) +
+		atomic_read(&warn_tbl_unknown_lookup_count);
+
+	if (unknown_count != 0)
+		METRIC_EMIT_INT(e, unknown_count, "(unknown)", NULL);
+
+	spin_lock_irqsave(&warn_tbl_lock, flags);
+	for (i = 0; i < WARN_TBL_SIZE; i++) {
+		unsigned long fn = (unsigned long)warn_tbl[i].function;
+		const char *function_name = warn_tbl[i].function_name;
+		int count = warn_tbl[i].count;
+
+		if (!fn)
+			continue;
+
+		// function_name[] is constant once function is non-NULL
+		spin_unlock_irqrestore(&warn_tbl_lock, flags);
+		METRIC_EMIT_INT(e, count, function_name, NULL);
+		spin_lock_irqsave(&warn_tbl_lock, flags);
+	}
+	spin_unlock_irqrestore(&warn_tbl_lock, flags);
+}
+METRIC_EXPORT_COUNTER(warnings, "Count of calls to WARN().",
+		      "function", NULL, warn_tbl_fn);
+
+static int __init metricfs_panic_init(void)
+{
+	metric_init_warnings(NULL);
+	return 0;
+}
+late_initcall(metricfs_panic_init);
+
+#else  /* CONFIG_METRICFS */
+inline void tbl_increment(void *caller) {}
+#endif
+
 struct warn_args {
 	const char *fmt;
 	va_list args;
@@ -576,6 +706,7 @@ struct warn_args {
 void __warn(const char *file, int line, void *caller, unsigned taint,
 	    struct pt_regs *regs, struct warn_args *args)
 {
+	tbl_increment(caller);
 	disable_trace_on_warning();
 
 	if (file)
-- 
2.28.0.236.gb10cc79966-goog

