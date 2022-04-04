Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B794F1E23
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiDDWXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242787AbiDDWUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:20:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1351D1C7
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 14:46:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id md13-20020a17090b23cd00b001ca7df65e1cso306929pjb.3
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 14:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bgj4NZpJwoartOALBkABgI03/83ehDZ+dNPnSd5eEa8=;
        b=cFb4s+itgwCPDnzf1h7IWr8F+AYDXeQp9cHQo6gByutC9zEymjvH63Z7Nw4/sNshPb
         r/L8uoKBEXAOM4wgcJNw5vH0AXTa5GngBRNG2dxHOOoZm2X/2F2V6Nt+O8HdMMCm3H2K
         8+5lGF7i1HpxtucB/Um16EAqVNz9xQb8aNQHaGXIckJLkxiySGMFiPYTtar2GlaT9cPn
         82FhxJ+xRQm1VH1cuog+LXAa7//J8x/gCxjVxNjoqu25z4ey92COlrDA/TTlJ8NGpY8k
         /B33s76ZPQwp7chJfbMIlVq2hTzp+lF2MsFqW8+50mCfGlQH/dnsQjs/rs9eF43sMwFv
         RaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bgj4NZpJwoartOALBkABgI03/83ehDZ+dNPnSd5eEa8=;
        b=anVYlJg1kSVAb+IlnvhY+4cgzVGellNFOW1XvzyA+MiF9/U42gNLGbyFb1upeBQII4
         8ch/0sdJfcwK5iCx2B1XpChO3Ji7++EFk+flOTfJ8RHIrVpbTqM2TPDLANJArRdYZoc2
         AMPRcw2CsneBD9WJdP257gDdf+qLLOZWYXPMNsPUkkTJybjF/jOKwqWL0kZTBOMkaY7G
         1N4hz+EnGe696HjjkFkK8ECATNPtpCpoWJKWNuup2cwylGDiLrvhXtEhyh0CZ7LXBhRj
         iiIT1Qq4UDeK71p2UBahIZ7Ng32rTAaxt7mqzYfHqG9Rk6KW8gm1rvh3vyWgfy9Q5cV7
         wZmg==
X-Gm-Message-State: AOAM531YvrYw69UdILy5WZAjTWZLFc6VQ5Cee+h8k9VHTIS3qi27rurx
        /GEo+Q7ydYJzRML33PO39BHgEvjFhVe3ga7QBh9DYRnD5CKe5lC+w0G8/puasioXbvGg4bp4dFx
        G+zgA+U90jlZsnsK3kMoSyU5dOFfYVirvRWJBEecLP9iBPA1TdZFeuUdNuv1QnG8=
X-Google-Smtp-Source: ABdhPJz5PNgnFZ3AfMQBuUBc7BAhXFMbNhPnmChySNjWMKVPyJyuUxWTzki/MWh6TI0Av7CTOmLsCv5ZfQA2tg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:2f41:0:b0:382:26ba:8855 with SMTP id
 v62-20020a632f41000000b0038226ba8855mr183442pgv.310.1649108809529; Mon, 04
 Apr 2022 14:46:49 -0700 (PDT)
Date:   Mon,  4 Apr 2022 14:46:40 -0700
In-Reply-To: <20220404214642.3201659-1-ricarkol@google.com>
Message-Id: <20220404214642.3201659-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220404214642.3201659-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run() utility function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add is_cpu_eligible_to_run() utility function, which checks whether the current
process, or one of its threads, is eligible to run on a particular CPU.
This information is obtained using sched_getaffinity.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..a7653f369b6c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+bool is_cpu_eligible_to_run(int pcpu);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..7813a68333c0 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2020, Google LLC.
  */
+#define _GNU_SOURCE
 
 #include <assert.h>
 #include <ctype.h>
@@ -13,7 +14,9 @@
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <linux/mman.h>
-#include "linux/kernel.h"
+#include <linux/kernel.h>
+#include <sched.h>
+#include <sys/sysinfo.h>
 
 #include "test_util.h"
 
@@ -334,3 +337,18 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+bool is_cpu_eligible_to_run(int pcpu)
+{
+	cpu_set_t cpuset;
+	long i, nprocs;
+
+	nprocs = get_nprocs_conf();
+	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
+	for (i = 0; i < nprocs; i++) {
+		if (i == pcpu)
+			return CPU_ISSET(i, &cpuset);
+	}
+
+	return false;
+}
-- 
2.35.1.1094.g7c7d902a7c-goog

