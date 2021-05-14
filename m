Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23438140F
	for <lists+kvm@lfdr.de>; Sat, 15 May 2021 01:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhENXGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 19:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 19:06:36 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD1FC06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 16:05:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w1-20020a17090a0281b0290156f7df20a0so622783pja.8
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 16:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=omC2Zg3MHlKG1tFQ/HKAY2Wl9w/KEfII3rpZaUlUwlA=;
        b=IcWPM2X4gSxjrlaqq2+nJCq2C9taSNotXHB2J54HQtG+ir8xjoedSW4oony2RGvkAA
         vrzWOP1AqpJxhf3nAyBqVUXyRz1G7s9u9futHi4msXqEoJDVXek7AVGBpuy8PgrPj1ZE
         jrgGeMJdnvpWgIl8LC21O3UD9DHmhiu+2kh036CUvn7kUtWe8vddXzqJwKpS/SSxHtE0
         BWXMqOTEqXCahdgRTQF6Z/n8pyLZsYA7GJ/assbtBxn8C416H/q8uHVGQDs2enihB6U9
         G2Cn5ueqXJrGCVJKA+MN3ITG7Pj/9cF2ehGaykyeBeT/Zwjh1uNKsWko/9ZqKbL8wSjy
         bAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=omC2Zg3MHlKG1tFQ/HKAY2Wl9w/KEfII3rpZaUlUwlA=;
        b=KAVD+FG4NX7Y6R8i9Hhxil/Oyi8vmtZUKfMW/4UOtwaAnHBpOwcXtJWza+52ku6G4y
         ZGyHVT/ZB/m3wXNESF5PutrJKq0t8dC//oKwLlYXKl79pj6s3vSQ2tDzjnlkBv+COq9d
         X8N28JecPisrjdOJeKnkBPFqcwrqWXOpBD75yT+R95VO/tL15U418rez1ybgHlEfVgk/
         YeN24V5jOb6jBnqmA4d9JXAH0T67LVADAXKLb81uuuOH4DofZNyjiAETUeAoE1M1S9ti
         BpPQFBT1qSQ7sxyJyc93Ma+C/SS/zBQkHcZmGKg7SCsTdUxneVGiU+5ZcusKDOI4gIOt
         NlnQ==
X-Gm-Message-State: AOAM532DXhVrv6++FiUe/uc/GsEf0UE7WXbTPBXHf9UuZ35rmF7F3qjr
        kMQR6hGypCTbacBX26LxQdTUZHPZbXFLMh6TZooLp/9Zi6gEAPek9OjfQvo4pk2YLgy6QER2YPo
        3672G1ByAcKqrQMJer1FB8ZHifufZkZRkb1o0tERdj+dMZNomyGO4+prj2pQm/T0=
X-Google-Smtp-Source: ABdhPJxwnWVSDfrxHHAz5FGSdRlfK2vgesG3/qH5vIABnY7JmjsShWtUIIxnjieKSfrvGy+sp1Xe7OSDpmJ5fA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:6309:: with SMTP id
 e9mr14178719pjj.20.1621033523813; Fri, 14 May 2021 16:05:23 -0700 (PDT)
Date:   Fri, 14 May 2021 23:05:21 +0000
Message-Id: <20210514230521.2608768-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH] KVM: selftests: Fix hang in hardware_disable_test
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ignacio Alvarado <ikalvarado@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If /dev/kvm is not available then hardware_disable_test will hang
indefinitely because the child process exits before posting to the
semaphore for which the parent is waiting.

Fix this by making the parent periodically check if the child has
exited. We have to be careful to forward the child's exit status to
preserve a KSFT_SKIP status.

I considered just checking for /dev/kvm before creating the child
process, but there are so many other reasons why the child could exit
early that it seemed better to handle that as general case.

Tested:

$ ./hardware_disable_test
/dev/kvm not available, skipping test
$ echo $?
4
$ modprobe kvm_intel
$ ./hardware_disable_test
$ echo $?
0

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 32 ++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 5aadf84c91c0..4b8db3bce610 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -132,6 +132,36 @@ static void run_test(uint32_t run)
 	TEST_ASSERT(false, "%s: [%d] child escaped the ninja\n", __func__, run);
 }
 
+void wait_for_child_setup(pid_t pid)
+{
+	/*
+	 * Wait for the child to post to the semaphore, but wake up periodically
+	 * to check if the child exited prematurely.
+	 */
+	for (;;) {
+		const struct timespec wait_period = { .tv_sec = 1 };
+		int status;
+
+		if (!sem_timedwait(sem, &wait_period))
+			return;
+
+		/* Child is still running, keep waiting. */
+		if (pid != waitpid(pid, &status, WNOHANG))
+			continue;
+
+		/*
+		 * Child is no longer running, which is not expected.
+		 *
+		 * If it exited with a non-zero status, we explicitly forward
+		 * the child's status in case it exited with KSFT_SKIP.
+		 */
+		if (WIFEXITED(status))
+			exit(WEXITSTATUS(status));
+		else
+			TEST_ASSERT(false, "Child exited unexpectedly");
+	}
+}
+
 int main(int argc, char **argv)
 {
 	uint32_t i;
@@ -148,7 +178,7 @@ int main(int argc, char **argv)
 			run_test(i); /* This function always exits */
 
 		pr_debug("%s: [%d] waiting semaphore\n", __func__, i);
-		sem_wait(sem);
+		wait_for_child_setup(pid);
 		r = (rand() % DELAY_US_MAX) + 1;
 		pr_debug("%s: [%d] waiting %dus\n", __func__, i, r);
 		usleep(r);
-- 
2.31.1.751.gd2f1c929bd-goog

