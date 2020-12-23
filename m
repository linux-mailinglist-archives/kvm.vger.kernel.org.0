Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B8E2E110A
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgLWBJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLWBJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 20:09:37 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAF0C0617A6
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id y23so4561615wmi.1
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqvxB++JbstIrAPr04yW9wMQ+lWNdxGPmHgGagwAD+g=;
        b=acOuzm54IV6ZtzYuAxvLqs0BYxZbc9kEYU6lj6AjSTiw0yaMVrafsUp1yff1IDvSxj
         IXlPfH5zgg1z3LcsC15yM7LGTTwhdx34D3RVGDU52glSgeQfhpwR+2AbXZewHCsNOnAh
         a6MeQnaa7RUU4QcljeAb0/RU/i3a3/RoGu9J9YnNr9pC0WeJOG0LxA1nhITwqBhl0MBW
         XGLDN7RJS+69fAA+kv3JwTE9Hai9G9vRLU2mnmmJs5fQtztNhJL0GlTeCnn8D7YZzeD1
         Kj9iE+vzRXEpzR7sqGMA/PbjN6zccNcgIvB7PNUxgK6Wdoi8hL6OthhKOx/ksQ0WDTd7
         Xxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SqvxB++JbstIrAPr04yW9wMQ+lWNdxGPmHgGagwAD+g=;
        b=sl/P4vRvqt28wRaJe06GRuAog0bqIxL/5tmuoDvn69ghjZd26lljxM9PtO9i2XyrzC
         0Mb9QTFXx/hltv+zpwQmXoUld5AeSMulh5AEogA3UrG9rguJlJcxB2gjBFIxP6bLE49k
         yLE/HNpMhc2f/XFIOFXd8O3RQJMRvlMr6Sqb6Q4YBbMEhlyZZdRONNi87RE5DiXfX+57
         0Mf1GE/il/gPQdkRUM2+8zfrO4Jb3lSJTQ1AQvgsyNMofQwlLHrpRjlO+ps+vEtWrs4G
         vDvpKF3OGLvMy9E1LSYBTuKFvlaxzb8m1aBxGHPhqrumpxTWW/ysEzeCoVhnPyGfUqlt
         uxiw==
X-Gm-Message-State: AOAM533CePvF4dJIwra/bAUTD+Gkz6YY9Y2UQhcUY/B9+gmBhwpO39Mn
        fxQGmtCMLadTRCiS/ZdoZiSSrZvHSYc=
X-Google-Smtp-Source: ABdhPJxMWezpctYhSLAA26t2cBHETe7XVKcu3ZBnP/+BEFsnvvXTnyWEWmIo9GsRtGoSRf6hXXU2ag==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr24224330wmm.80.1608685735272;
        Tue, 22 Dec 2020 17:08:55 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h83sm30995047wmf.9.2020.12.22.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 17:08:54 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 3/4] chaos: add timer interrupt to the workload
Date:   Wed, 23 Dec 2020 02:08:49 +0100
Message-Id: <20201223010850.111882-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223010850.111882-1-pbonzini@redhat.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/chaos.c  | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+)

diff --git a/x86/chaos.c b/x86/chaos.c
index e723a3b..0b1e29c 100644
--- a/x86/chaos.c
+++ b/x86/chaos.c
@@ -1,5 +1,7 @@
 #include "libcflat.h"
 #include "smp.h"
+#include "isr.h"
+#include "apic.h"
 #include "bitops.h"
 #include "string.h"
 #include "alloc.h"
@@ -9,14 +11,24 @@
 
 #define MAX_NR_CPUS 256
 
+#define TIMER_IRQ 0x44
+
 struct chaos_args {
 	long npages;		/* 0 for CPU workload. */
 	const char *mem;
 	int invtlb;
+
+	int hz;
+	bool hlt;
+};
+
+struct counters {
+	int ticks_left;
 };
 
 int ncpus;
 struct chaos_args all_args[MAX_NR_CPUS];
+struct counters cnt[MAX_NR_CPUS];
 
 static void parse_arg(struct chaos_args *args, const char *arg)
 {
@@ -58,6 +70,20 @@ static void parse_arg(struct chaos_args *args, const char *arg)
 			}
 			args->invtlb = i;
 			printf("CPU %d: invtlb=%ld\n", smp_id(), i);
+		} else if (!strcmp(word, "hz")) {
+			if (!have_arg)
+				i = 1000;
+			args->hz = i;
+			printf("CPU %d: hz=%ld\n", smp_id(), i);
+		} else if (!strcmp(word, "hlt")) {
+			if (!have_arg)
+				i = 1;
+			else if (i != 0 && i != 1) {
+				printf("hlt argument must be 0 or 1\n");
+				i = 1;
+			}
+			args->hlt = i;
+			printf("CPU %d: hlt=%ld\n", smp_id(), i);
 		} else {
 			printf("invalid argument %s\n", word);
 		}
@@ -65,6 +91,31 @@ static void parse_arg(struct chaos_args *args, const char *arg)
 	free(s);
 }
 
+static void do_timer(void)
+{
+	int cpu = smp_id();
+	struct counters *c = &cnt[cpu];
+	char out[4];
+	if (c->ticks_left > 0) {
+		c->ticks_left--;
+		return;
+	}
+
+	c->ticks_left = all_args[cpu].hz;
+
+	/* Print current CPU number.  */
+	out[2] = (cpu % 10) + '0'; cpu /= 10;
+	out[1] = (cpu % 10) + '0'; cpu /= 10;
+	out[0] = (cpu % 10) + '0'; cpu /= 10;
+	puts(out + (ncpus < 100) + (ncpus < 10));
+}
+
+static void timer(isr_regs_t *regs)
+{
+	do_timer();
+        eoi();
+}
+
 static void __attribute__((noreturn)) stress(void *data)
 {
     const char *arg = data;
@@ -73,6 +124,15 @@ static void __attribute__((noreturn)) stress(void *data)
     printf("starting CPU %d workload: %s\n", smp_id(), arg);
     parse_arg(args, arg);
 
+    apic_write(APIC_TDCR, 0x0000000b);
+    if (args->hz) {
+	    /* FIXME: assumes that the LAPIC timer counts in nanoseconds.  */
+
+	    apic_write(APIC_TMICT, 1000000000 / args->hz);
+	    apic_write(APIC_LVTT, TIMER_IRQ | APIC_LVT_TIMER_PERIODIC);
+    }
+
+    irq_enable();
     for (;;) {
 	    if (args->mem) {
 		    const char *s = args->mem;
@@ -85,6 +145,8 @@ static void __attribute__((noreturn)) stress(void *data)
 			    s += sizeof(unsigned long);
 		    }
 	    }
+	    if (args->hlt)
+		    asm volatile("hlt");
     }
 }
 
@@ -103,6 +165,8 @@ int main(int argc, char *argv[])
     if (ncpus > MAX_NR_CPUS)
 	    ncpus = MAX_NR_CPUS;
 
+    handle_irq(TIMER_IRQ, timer);
+
     for (i = 1; i < ncpus; ++i) {
         if (i >= argc) {
             break;
-- 
2.29.2


