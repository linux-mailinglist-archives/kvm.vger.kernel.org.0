Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9486544CE28
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhKKAP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhKKAPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:15:53 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECAC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:05 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so2815364pfx.21
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bRE2BKrM7sb/3k6dyJldfQAsHjjIPk1koYlPjHmoAKE=;
        b=gSe9DyAiulmqhVy9gvjSC0lmoCvRw+68n7OmTuiKbDtTuA539c7okwia6Xx00ARJxi
         FP4noi+dlHYr5pgfpMruHv0c2Q64UjWFc12P1DleZFVQ/pb1JODoQuYQITWS+jql7iGr
         yu1BqxrNRN/6pPQRkm26kkDG7aJwKhG8BpZfPGRiWfy5H5i7ppCnikqaCsYCCEf7ReQW
         Zw+IpzpjePUraOso+KndFtOW/7puRbhaEkl020pL6iutEQrd9NEAxmvUB7aAYYZRJ/LB
         DdBXD/YzXlXtoOzmTBvyfuCpa6crxWqtO0p7fiv5LfAZ87PKpHVpNIC7BABsdUJGfZog
         5vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bRE2BKrM7sb/3k6dyJldfQAsHjjIPk1koYlPjHmoAKE=;
        b=pw31f6UeIkBQrrOBI/BS1KL9CYEcsqSjOsxLSKhBEseryEgC8QLE2Z8hSPxuRrDpKD
         +dcxPOfFtDWPoYv0QHiRM1EhkuYrTyygLgHw0THGZqsv1wDWxl9C1lvGKhVD49+tXgW4
         5tMJL49V4mnSDEM5wtFLx1pA+VF6O7Iu54jyFeHwZ7eWtbtCMjRh5F+PJLkop1l0IyQH
         lGZYRewB0BQYyOgbUJtWvj4J4Xta+uUBFwIVR4i0UPlzgXv6o7dX5qTtD1PJz1CkNGQD
         iL4w3Hlyi1fE3pxgMupvdw+1ez6S+mFYsfBuuNWbkB+FaiEznGvosaNCT1FJqVxR6/Ff
         HvUQ==
X-Gm-Message-State: AOAM531xO31m+boLiKthBtJFwf9OtBfKsVrw3Q26CmCHxaisOSjzRkVf
        FPEzSPAKKcf9u+z7EIP4FqaUSgJNmwTwpg==
X-Google-Smtp-Source: ABdhPJyExBeAPnGOSYTZlq7uw/o7sMvS0ggx4uFHF7mEzThNJ+QuUj40mrFs1nWlztFgR7m29swi3eWpb6zdpw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:124d:: with SMTP id
 gx13mr21674761pjb.106.1636589585409; Wed, 10 Nov 2021 16:13:05 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:12:56 +0000
In-Reply-To: <20211111001257.1446428-1-dmatlack@google.com>
Message-Id: <20211111001257.1446428-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 3/4] KVM: selftests: Wait for all vCPU to be created before
 entering guest mode
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thread creation requires taking the mmap_sem in write mode, which causes
vCPU threads running in guest mode to block while they are populating
memory. Fix this by waiting for all vCPU threads to be created and start
running before entering guest mode on any one vCPU thread.

This substantially improves the "Populate memory time" when using 1GiB
pages since it allows all vCPUs to zero pages in parallel rather than
blocking because a writer is waiting (which is waiting for another vCPU
that is busy zeroing a 1GiB page).

Before:

  $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
  ...
  Populate memory time: 52.811184013s

After:

  $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
  ...
  Populate memory time: 10.204573342s

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/lib/perf_test_util.c        | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index d646477ed16a..722df3a28791 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -22,6 +22,9 @@ struct vcpu_thread {
 
 	/* The pthread backing the vCPU. */
 	pthread_t thread;
+
+	/* Set to true once the vCPU thread is up and running. */
+	bool running;
 };
 
 /* The vCPU threads involved in this test. */
@@ -30,6 +33,9 @@ static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
 /* The function run by each vCPU thread, as provided by the test. */
 static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
 
+/* Set to true once all vCPU threads are up and running. */
+static bool all_vcpu_threads_running;
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -196,6 +202,17 @@ static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
 
+	WRITE_ONCE(vcpu->running, true);
+
+	/*
+	 * Wait for all vCPU threads to be up and running before calling the test-
+	 * provided vCPU thread function. This prevents thread creation (which
+	 * requires taking the mmap_sem in write mode) from interfering with the
+	 * guest faulting in its memory.
+	 */
+	while (!READ_ONCE(all_vcpu_threads_running))
+		;
+
 	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
 
 	return NULL;
@@ -206,14 +223,23 @@ void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vc
 	int vcpu_id;
 
 	vcpu_thread_fn = vcpu_fn;
+	WRITE_ONCE(all_vcpu_threads_running, false);
 
 	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
 		struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
 
 		vcpu->vcpu_id = vcpu_id;
+		WRITE_ONCE(vcpu->running, false);
 
 		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
 	}
+
+	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+		while (!READ_ONCE(vcpu_threads[vcpu_id].running))
+			;
+	}
+
+	WRITE_ONCE(all_vcpu_threads_running, true);
 }
 
 void perf_test_join_vcpu_threads(int vcpus)
-- 
2.34.0.rc1.387.gb447b232ab-goog

