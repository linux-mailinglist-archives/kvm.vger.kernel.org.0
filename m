Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80322E1109
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLWBJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLWBJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 20:09:36 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F6C06179C
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:55 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id e25so4576322wme.0
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bWhDKCGsyM3Ql87nT5QipuNUsOUCpyWwRvfW/Lqd2Sg=;
        b=N79PbMTi8NpQjgTd8sW2oPCOJF9wmw6ibgOYYlcpKPuvptoB4y1lAtP+L7mI9dj+N3
         mpNFv3M5CpX1VEHEgIaBjV/CDiyZiAVVL/FE2OOJBgtslNZ3T3KPpBUtQiX1i9e1TZkP
         y8b01R6XIvrt4N2arJ2cKMToA6kNmXctP6id5R611psQ1Cyi7WxmucQxK48lkuJbKJvz
         K3TVWS1cyB9tksER2pgKIbgnfhWKDsk//vMfr1YW764gOkNcTtvLGY71rlyd5RRZvkDA
         B2JURVL0BBUGfGsZP2E411nxOv0aFMA7QWzqxdLStsAYJF57Jn6PKrD6TpcR5Nqa8SM2
         rSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=bWhDKCGsyM3Ql87nT5QipuNUsOUCpyWwRvfW/Lqd2Sg=;
        b=hn0Roz2CWipTm5ojpCPnXJE+DwL+fzrbiYbpVkw+FNnd23QUwbFA806v3zQpzHkgHE
         kb+YsfMsL8ywgIhHoXnERK+/zPpAPEQiD/CnF4twWeHR/D0zmaFd/aLr01sfMsg4sL3G
         N+8PCXZvoFntL2M9W2jXrYig6jED/YLuciyPI9rRIoZcy4r1T9JeSuiFWA90FuAMJTqv
         Xmq2qhNnCW5xt/ParUkv/Tdib65Kr5orNgoeVaVJH7Z/vyL89XOAkLtX6cfNNCv+gtj3
         4XGo+ausvBhlzFbyeOwMhemQzwgM7KA7tt2+85ecvVFtiO6A+gB+B9rdS8gkwLw5Pmdg
         76Uw==
X-Gm-Message-State: AOAM531PVUnD+wm8umjLzL4yRmRaAuClPM5uWYRfW4x1DrMak3NJtq6j
        0jrOSsgjXp7VZgeFr7TH7a19Pa+6N08=
X-Google-Smtp-Source: ABdhPJye/rodbBrAoSs2jjcNVYeirCUwUeKCmBlzKYnKW8TM/1W/3IsT4zTcDzYI+xQ9iGIf1X7HXQ==
X-Received: by 2002:a1c:2785:: with SMTP id n127mr24448988wmn.148.1608685734179;
        Tue, 22 Dec 2020 17:08:54 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h83sm30995047wmf.9.2020.12.22.17.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 17:08:53 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 2/4] chaos: add generic stress test
Date:   Wed, 23 Dec 2020 02:08:48 +0100
Message-Id: <20201223010850.111882-3-pbonzini@redhat.com>
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
 lib/x86/processor.h |   2 +-
 x86/Makefile.x86_64 |   1 +
 x86/chaos.c         | 114 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 x86/chaos.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 291d24b..a53654a 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -546,7 +546,7 @@ static inline void irq_enable(void)
     asm volatile("sti");
 }
 
-static inline void invlpg(volatile void *va)
+static inline void invlpg(const volatile void *va)
 {
 	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
 }
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index af61d85..761a1d9 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
+tests += $(TEST_DIR)/chaos.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/chaos.c b/x86/chaos.c
new file mode 100644
index 0000000..e723a3b
--- /dev/null
+++ b/x86/chaos.c
@@ -0,0 +1,114 @@
+#include "libcflat.h"
+#include "smp.h"
+#include "bitops.h"
+#include "string.h"
+#include "alloc.h"
+#include "alloc_page.h"
+#include "asm/page.h"
+#include "processor.h"
+
+#define MAX_NR_CPUS 256
+
+struct chaos_args {
+	long npages;		/* 0 for CPU workload. */
+	const char *mem;
+	int invtlb;
+};
+
+int ncpus;
+struct chaos_args all_args[MAX_NR_CPUS];
+
+static void parse_arg(struct chaos_args *args, const char *arg)
+{
+	char *s = strdup(arg);
+	char *p = s;
+
+	while (*p) {
+		char *word = p;
+		char delim = strdelim(&p, ",=");
+		long i = 0;
+		bool have_arg = false;
+		if (delim == '=') {
+			char *num = p;
+			strdelim(&p, ",");
+			if (!parse_long(num, &i))
+				printf("invalid argument for %s\n", word);
+			else
+				have_arg = true;
+		}
+
+		if (!strcmp(word, "mem")) {
+			if (!have_arg)
+				i = 12;
+			else if (i >= BITS_PER_LONG - 1 - PAGE_SHIFT) {
+				printf("mem argument too large, using 12\n");
+				i = 12;
+			}
+			args->npages = 1 << i;
+			args->mem = alloc_pages(i);
+			if (!args->mem)
+				printf("could not allocate memory\n");
+			printf("CPU %d: mem=%ld @ %p\n", smp_id(), i, args->mem);
+		} else if (!strcmp(word, "invtlb")) {
+			if (!have_arg)
+				i = 1;
+			else if (i != 0 && i != 1) {
+				printf("invtlb argument must be 0 or 1\n");
+				i = 1;
+			}
+			args->invtlb = i;
+			printf("CPU %d: invtlb=%ld\n", smp_id(), i);
+		} else {
+			printf("invalid argument %s\n", word);
+		}
+	}
+	free(s);
+}
+
+static void __attribute__((noreturn)) stress(void *data)
+{
+    const char *arg = data;
+    struct chaos_args *args = &all_args[smp_id()];
+
+    printf("starting CPU %d workload: %s\n", smp_id(), arg);
+    parse_arg(args, arg);
+
+    for (;;) {
+	    if (args->mem) {
+		    const char *s = args->mem;
+		    const char *e = s + (args->npages << PAGE_SHIFT);
+		    long i;
+		    for (i = args->npages; args->invtlb && i--; )
+			    invlpg(s + ((args->npages - i) << PAGE_SHIFT));
+		    while (s < e) {
+			    (*(unsigned long *)s)++;
+			    s += sizeof(unsigned long);
+		    }
+	    }
+    }
+}
+
+int main(int argc, char *argv[])
+{
+    int i;
+
+    setup_vm();
+    if (argc <= 1) {
+        return 1;
+    }
+
+    argv++;
+    argc--;
+    ncpus = cpu_count();
+    if (ncpus > MAX_NR_CPUS)
+	    ncpus = MAX_NR_CPUS;
+
+    for (i = 1; i < ncpus; ++i) {
+        if (i >= argc) {
+            break;
+        }
+        on_cpu_async(i, stress, argv[i]);
+    }
+
+    stress(argv[0]);
+}
-- 
2.29.2


