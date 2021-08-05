Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9307C3E1A5C
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhHER2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbhHER2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 13:28:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA6C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 10:28:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso6875935ybh.12
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 10:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Nw/CRkpZ7RFGLR9XxhC+lMWi1OMewVwtobZB8kofttI=;
        b=kpd66kAzyv5IdJba85HpD3wIwpXhOzhmf1zoQ1+hbQuOjXjj6Iq/3mafC6SBLfs3vB
         yLoMI9GzZfQHf0A1/rbAl+7E9xphyzyY50XR2X169LRfHkgCG7Vc6gCaEAa4TArE0oku
         28X8V5otlp49ZyXOr9PTC10Z06sXooyYqvhm/SGm0Pw9TqJT/za2mK3snnPh0hJcj/lV
         6a8Iq2AhR2cLzgy7Fh6qjQINfyesG18QlWHCBwLN0T0XOfh0I4HhtIktgJ1jPbLNFrQd
         Tn1lR0aHDzPefcG3/d57ciN2ua/jfedM/Gfp11/JCYAhmnTKO7nzK5Pd8GaPLgsi6ggO
         UUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Nw/CRkpZ7RFGLR9XxhC+lMWi1OMewVwtobZB8kofttI=;
        b=Si+ajtbzkWseFjzulsdubV1CBLSIkC4s8cw2ObVsrzKLH5kvJkfHPm1Gdq6xrEdrP9
         Dp9/Rs2vWol2tb7gB7k0JMkvBzF7rkNhNjBBbAExIfZT7JZQ2vQKiut4a8s6IOvyBpLq
         +3LQOtR25FGCchsYJeOir4E8R8CivHL6P/A9GWVSgA5Zftqko9S1m4kp8sP4E3ap2Y+2
         8j1sUxRtTU305hu1BUkq7ef2OSTMnSbhvhRZuNZIwEc11JqofKjeSfWjjzbHZ+lq4G/P
         iD9R81Mtb/QnAmB0PrklQmDVuXWuH0qJ+opaTs2U2dUny0jcZDnT34uoaADuxsyus+yP
         pXjw==
X-Gm-Message-State: AOAM533uvQ9WQw9tAwQuTQeP14qAlLLdERuiE1xzJTH5tClnWoGky1m9
        tzqdQTRaSDULUylodqeVbf2ABUEVN4n7PQ==
X-Google-Smtp-Source: ABdhPJwoFvqoZ9kygbNm+XvuYtWvpqEgYmRH3IusDCXwvgqn5HvB8NuDBMhs3DyYjVcS1c66t2zIxc5nOHHQuQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:6d08:: with SMTP id
 i8mr7125756ybc.100.1628184506111; Thu, 05 Aug 2021 10:28:26 -0700 (PDT)
Date:   Thu,  5 Aug 2021 17:28:21 +0000
Message-Id: <20210805172821.2622793-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH] KVM: selftests: Move vcpu_args_set into perf_test_util
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

perf_test_util is used to set up KVM selftests where vCPUs touch a
region of memory. The guest code is implemented in perf_test_util.c (not
the calling selftests). The guest code requires a 1 parameter, the
vcpuid, which has to be set by calling vcpu_args_set(vm, vcpu_id, 1,
vcpu_id).

Today all of the selftests that use perf_test_util are making this call.
Instead, perf_test_util should just do it. This will save some code but
more importantly prevents mistakes since totally non-obvious that this
needs to be called and failing to do so results in vCPUs not accessing
the right regions of memory.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c        | 2 --
 tools/testing/selftests/kvm/demand_paging_test.c               | 1 -
 tools/testing/selftests/kvm/dirty_log_perf_test.c              | 1 -
 tools/testing/selftests/kvm/lib/perf_test_util.c               | 2 ++
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 1 -
 5 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index e2baa187a21e..72714573ba4f 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -222,8 +222,6 @@ static void *vcpu_thread_main(void *arg)
 	int vcpu_id = vcpu_args->vcpu_id;
 	int current_iteration = -1;
 
-	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
-
 	while (spin_wait_for_next_iteration(&current_iteration)) {
 		switch (READ_ONCE(iteration_work)) {
 		case ITERATION_ACCESS_MEMORY:
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b74704305835..950f2eb634e6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -52,7 +52,6 @@ static void *vcpu_worker(void *data)
 	struct timespec start;
 	struct timespec ts_diff;
 
-	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 	run = vcpu_state(vm, vcpu_id);
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 80cbd3a748c0..ef45a133560f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -44,7 +44,6 @@ static void *vcpu_worker(void *data)
 	struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
 	int vcpu_id = vcpu_args->vcpu_id;
 
-	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 	run = vcpu_state(vm, vcpu_id);
 
 	while (!READ_ONCE(host_quit)) {
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b488f4aefea8..f6aa81af3e6f 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -140,6 +140,8 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 			vcpu_gpa = guest_test_phys_mem;
 		}
 
+		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
+
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 vcpu_id, vcpu_gpa, vcpu_gpa +
 			 (vcpu_args->pages * perf_test_args.guest_page_size));
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 98351ba0933c..b6f7cc298e4d 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -45,7 +45,6 @@ static void *vcpu_worker(void *data)
 	struct kvm_vm *vm = perf_test_args.vm;
 	struct kvm_run *run;
 
-	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 	run = vcpu_state(vm, vcpu_id);
 
 	/* Let the guest access its memory until a stop signal is received */
-- 
2.32.0.554.ge1b32706d8-goog

