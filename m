Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8E77D5B7
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbjHOWAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbjHOWAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:00:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783CD1FEC
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:00:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6349e1d4c2so5089994276.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692136832; x=1692741632;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dF0HtzyRabwbN6uBaAo152fs8WqDxHJSFBeI7T0eqFE=;
        b=CbAnsdN1EliwmxWZfixfEAXtTIKrjeUeXXikW0OD6m3cdm6Yko1L4kXjHnzXdCTMm3
         Prg5Vodz5v79Qm6MlevAqVRb/uT7HOIkuo4ALBvlEBhp/dywgSugjcwMW7+sPJZGCPrm
         Vr3stLz3OQu4VYaTUwGOWhx5/yDcP6k42IFtH3aRjmI/Q1m+YAbn6EL0Ctk5H0GzJA64
         tHz90khJYLGhfW4e5hl2u6xm2i8fwmdHWR8u5NLxmW/ZAHfvjh5T0ukGbt/2Cx7Ve2vl
         BZUsFBXJDnaIN5T65qbhSWwTloR+fyBPMhCFaalQIrt4yaEWRqctQRhW6oLiRhql50Qz
         ZOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692136832; x=1692741632;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dF0HtzyRabwbN6uBaAo152fs8WqDxHJSFBeI7T0eqFE=;
        b=AeT/oY764kiWUueSmMUfDh+DY9Xh/Leb58VbZFfM0ppU+Two6cCGVDJx/P2O2dERRi
         BeXb5+HldbcHqLuz4U2XZxmV+AqLv0W8hZZwBHsgBPXAdAQZj8uxh1dlHJ3INRdyob0d
         WJJVgo6vElnmuWYz9l+jYALwQqUlGjIXc1Rgdz3cuPmBQa7G30CW7OCdl12DncOKTJej
         Ke4JpDOKnX+DGZe9SojRUJjT9QGWK7wicGqfRFb3bteMHXCuabT2fhBc8HqgVC4QHT9M
         HSg4a4VsrAg/jGj9qhI6u6XtMhzeQICCZBn5hZMxYtbyjFZiOVmVH+eAuiRkYeF0piXw
         +OTQ==
X-Gm-Message-State: AOJu0YzcXxKYxeXN9pStSArVcGMpHd4sPOen8yzYs4O4vGZbWIsEWX+2
        0wJ5SxewOWUUAJIufdwosGUqOTakIXI=
X-Google-Smtp-Source: AGHT+IGoee2vwn5kvOvd6m0iSZYyN5sCI+nqzIs3uVXjYtHoLL3OBYN63QVsLOsWcE03iQl/mqtqrV/sthk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e788:0:b0:d3a:f3a6:ee64 with SMTP id
 e130-20020a25e788000000b00d3af3a6ee64mr642ybh.5.1692136832749; Tue, 15 Aug
 2023 15:00:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 15:00:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815220030.560372-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Remove x86's so called "MMIO warning" test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove x86's mmio_warning_test, as it is unnecessarily complex (there's no
reason to fork, spawn threads, initialize srand(), etc..), unnecessarily
restrictive (triggering triple fault is not unique to Intel CPUs without
unrestricted guest), and provides no meaningful coverage beyond what
basic fuzzing can achieve (running a vCPU with garbage is fuzzing's bread
and butter).

That the test has *all* of the above flaws is not coincidental, as the
code was copy+pasted almost verbatim from the syzkaller reproducer that
originally found the KVM bug (which has long since been fixed).

Cc: Michal Luczaj <mhal@rbox.co>
Link: https://groups.google.com/g/syzkaller/c/lHfau8E3SOE
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 -
 .../selftests/kvm/x86_64/mmio_warning_test.c  | 121 ------------------
 2 files changed, 122 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 77026907968f..b81d13a9c6dc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -76,7 +76,6 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
-TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
deleted file mode 100644
index ce1ccc4c1503..000000000000
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * mmio_warning_test
- *
- * Copyright (C) 2019, Google LLC.
- *
- * This work is licensed under the terms of the GNU GPL, version 2.
- *
- * Test that we don't get a kernel warning when we call KVM_RUN after a
- * triple fault occurs.  To get the triple fault to occur we call KVM_RUN
- * on a VCPU that hasn't been properly setup.
- *
- */
-
-#define _GNU_SOURCE
-#include <fcntl.h>
-#include <kvm_util.h>
-#include <linux/kvm.h>
-#include <processor.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/ioctl.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <sys/wait.h>
-#include <test_util.h>
-#include <unistd.h>
-
-#define NTHREAD 4
-#define NPROCESS 5
-
-struct thread_context {
-	int kvmcpu;
-	struct kvm_run *run;
-};
-
-void *thr(void *arg)
-{
-	struct thread_context *tc = (struct thread_context *)arg;
-	int res;
-	int kvmcpu = tc->kvmcpu;
-	struct kvm_run *run = tc->run;
-
-	res = ioctl(kvmcpu, KVM_RUN, 0);
-	pr_info("ret1=%d exit_reason=%d suberror=%d\n",
-		res, run->exit_reason, run->internal.suberror);
-
-	return 0;
-}
-
-void test(void)
-{
-	int i, kvm, kvmvm, kvmcpu;
-	pthread_t th[NTHREAD];
-	struct kvm_run *run;
-	struct thread_context tc;
-
-	kvm = open("/dev/kvm", O_RDWR);
-	TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
-	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, NULL);
-	TEST_ASSERT(kvmvm > 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, kvmvm));
-	kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
-	TEST_ASSERT(kvmcpu != -1, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, kvmcpu));
-	run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
-				    kvmcpu, 0);
-	tc.kvmcpu = kvmcpu;
-	tc.run = run;
-	srand(getpid());
-	for (i = 0; i < NTHREAD; i++) {
-		pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
-		usleep(rand() % 10000);
-	}
-	for (i = 0; i < NTHREAD; i++)
-		pthread_join(th[i], NULL);
-}
-
-int get_warnings_count(void)
-{
-	int warnings;
-	FILE *f;
-
-	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
-	if (fscanf(f, "%d", &warnings) < 1)
-		warnings = 0;
-	pclose(f);
-
-	return warnings;
-}
-
-int main(void)
-{
-	int warnings_before, warnings_after;
-
-	TEST_REQUIRE(host_cpu_is_intel);
-
-	TEST_REQUIRE(!vm_is_unrestricted_guest(NULL));
-
-	warnings_before = get_warnings_count();
-
-	for (int i = 0; i < NPROCESS; ++i) {
-		int status;
-		int pid = fork();
-
-		if (pid < 0)
-			exit(1);
-		if (pid == 0) {
-			test();
-			exit(0);
-		}
-		while (waitpid(pid, &status, __WALL) != pid)
-			;
-	}
-
-	warnings_after = get_warnings_count();
-	TEST_ASSERT(warnings_before == warnings_after,
-		   "Warnings found in kernel.  Run 'dmesg' to inspect them.");
-
-	return 0;
-}

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0.694.ge786442a9b-goog

