Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3171444CE26
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhKKAPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhKKAPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:15:52 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D610C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:03 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id v17-20020a05622a131100b002aea167e24aso3402433qtk.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rboAKObAxco0O538iL45UDaisqHTUFArK2npanIYyBc=;
        b=TYnYE/ai6EXGXXeZAZE2mm4I4nJ+4WjxTaWEl3ASTbrM2qENzvEsA9Pm/YEXouEKA+
         mlNKZSoUr4L2Kq9R9TE4vITChjrKwFRIsUa2Fck0qtlzJv053uhE4CtXM9yARSTx3jws
         w2HVqPdpZMuVgHtijGVb+Yl2P4sE2PJvlFcfH3Hj+Yt4MAmqdFoi2Yb2Iqs0jfsx+NL6
         hNSN3fTBl+L639HggZn2sw5BQtyV5h9CYGpnZZZHGnBVegmWvEOiH2Hpz+lGrzqUPhiX
         xpKspgFtfLqkNgPf3aoLe8t+JwoR5sTtiE9FQ7mp0nwqc8p31mwnDwV8RjxIo0J3mBgG
         BgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rboAKObAxco0O538iL45UDaisqHTUFArK2npanIYyBc=;
        b=Bvg/Nt7BaCQFcg1K8wPrcFC5HiHS/IZBtgf6DMvpChNj+YLhcHbzhWrHhSNH5MTf8W
         tkWECMmJnBtbxFIRadyG2PFuFbkKCK2JSfAl1xV/XYi6Wr05KaX9XHyCApn5DAyROggW
         u+douXx92IRaiB+kCrsJKIiyNvzD8j0yXIrwiN8/1O40c05l5630LE6EgG8WiyxSVuVQ
         mCwF511HxJfuTRmVtX8A4b5aBEMMLu6k9y8Q1P1+5K9qVybzbWzqLSgE3vlo9EYxVexg
         Ip10n/X4jGu/N59OaHEJiiAtGaUJZOrhugp7oeeD8ND2kQlmfAWG+mJqXYwyBeGmDBAo
         eTkw==
X-Gm-Message-State: AOAM533FRY3tkNgbB3DFg2vLeUHwabaivebO1xLLQXTcCZlkyBMf9Mgz
        U0SXwj/6gF9JKbe2PPWKEAAkvv71nW+0qA==
X-Google-Smtp-Source: ABdhPJxIT/p99QD/g1fVBXPENF6MMMn5Z+hiIJfARLTE5lOOrif82gHbHHSctBiz/iyjvLsoIDuPFdX8Go/2Rg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:622a:307:: with SMTP id
 q7mr3399342qtw.330.1636589582587; Wed, 10 Nov 2021 16:13:02 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:12:54 +0000
In-Reply-To: <20211111001257.1446428-1-dmatlack@google.com>
Message-Id: <20211111001257.1446428-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 1/4] KVM: selftests: Start at iteration 0 instead of -1
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

Start at iteration 0 instead of -1 to avoid having to initialize
vcpu_last_completed_iteration when setting up vCPU threads. This
simplifies the next commit where we move vCPU thread initialization
out to a common helper.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 5364a2ed7c68..7f25a06e19c9 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -47,7 +47,7 @@
 #include "guest_modes.h"
 
 /* Global variable used to synchronize all of the vCPU threads. */
-static int iteration = -1;
+static int iteration;
 
 /* Defines what vCPU threads should do during a given iteration. */
 static enum {
@@ -220,7 +220,7 @@ static void *vcpu_thread_main(void *arg)
 	struct perf_test_vcpu_args *vcpu_args = arg;
 	struct kvm_vm *vm = perf_test_args.vm;
 	int vcpu_id = vcpu_args->vcpu_id;
-	int current_iteration = -1;
+	int current_iteration = 0;
 
 	while (spin_wait_for_next_iteration(&current_iteration)) {
 		switch (READ_ONCE(iteration_work)) {
@@ -303,11 +303,9 @@ static pthread_t *create_vcpu_threads(int vcpus)
 	vcpu_threads = malloc(vcpus * sizeof(vcpu_threads[0]));
 	TEST_ASSERT(vcpu_threads, "Failed to allocate vcpu_threads.");
 
-	for (i = 0; i < vcpus; i++) {
-		vcpu_last_completed_iteration[i] = iteration;
+	for (i = 0; i < vcpus; i++)
 		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main,
 			       &perf_test_args.vcpu_args[i]);
-	}
 
 	return vcpu_threads;
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

