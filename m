Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1071C2F3D98
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393381AbhALVoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731248AbhALVn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:43:57 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C78C0617BA
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:43:01 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id c3so89079pgq.16
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9D60d6a+RHIMvsjgK7MdID+ZQQq9agXyNVhU1xi0rGw=;
        b=EBPyU4IxquAka6tndKBXi38jGYe9Wc5xSLXCMEuPUAMfc8ERikwZ7Q+5Vaine1yj/s
         Y94PrhvabXm92lZISmP5lLjXeQDYdfAs7G/6TwGny2haIsc7ifisvoH3ZVgsIao+e0VC
         ISI+5uZlG5oW/Q+z+GUDj2EXQmC8KPkyDdz+xoh/vppfLBZ0+YXkP/p7jN02Aq6M/C7s
         AFkBrgvhtyP4AtWcZPtuJuX2dbEtnb5hgqWYTZgHx1bbkMyQF3jQWImrbkzeQGeXKtjq
         i17XuZWixCsIt1YWWVafD70Pyc3ilK7b1o1bttscqEtXtupV2dQMg2X5k2qSX5kkNHnJ
         5+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9D60d6a+RHIMvsjgK7MdID+ZQQq9agXyNVhU1xi0rGw=;
        b=J8Mat2TocstlsKG8WkoGfbMIARWv9tPrKaw/2e2TItPq97hRJ1C9mZnjxSp6H7AypM
         LVMl6sVMAw9uGpWL4TUrHyEchij+jAiBtYqMDBKt7oftyFDzg5ZXBBZ6KdW5gjoVJry/
         zirw1kJChr3ASG8DeBine3viaz1XSbFx02T/9G+IolkqnK69tN7Me3vt3Yo276wAy019
         oJj2pbcV56PeN/N+PLuQBicgR87J9v2y5iALr9TvUmAHawrH/OEwUtgNY9gnAkN384eh
         tD8FsAEzCgGghTUNce8exO0+wr376vLOtLUMGuD5ao3aAXGiFhD+wPH21iV0bSQt1fRd
         rYsQ==
X-Gm-Message-State: AOAM532cG2FWSbMGEcFdBiqoEULwYDrvR7xtV+8fciKuJAbFkzgy9e5j
        TsL4bIDjtdzUt3zCsvOQBzZB3y19+KKN
X-Google-Smtp-Source: ABdhPJwDLHr7pwodvdrqC9F2QqiLJrBgP+QmgVRLQ9SkvNlPoxHoXuPwjuoAGKu3nulYpXd7GoIetAD+BhmY
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:ba84:b029:dc:f27:dd4e with SMTP id
 k4-20020a170902ba84b02900dc0f27dd4emr943795pls.61.1610487780931; Tue, 12 Jan
 2021 13:43:00 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:42:49 -0800
In-Reply-To: <20210112214253.463999-1-bgardon@google.com>
Message-Id: <20210112214253.463999-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210112214253.463999-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 2/6] KVM: selftests: Avoid flooding debug log while populating memory
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu pointed out that a log message printed while waiting for the
memory population phase of the dirty_log_perf_test will flood the debug
logs as there is no delay after printing the message. Since the message
does not provide much value anyway, remove it.

Reviewed-by: Jacob Xu <jacobhxu@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 16efe6589b43..15a9c45bdb5f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -146,8 +146,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Allow the vCPU to populate memory */
 	pr_debug("Starting iteration %lu - Populating\n", iteration);
 	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
-		pr_debug("Waiting for vcpu_last_completed_iteration == %lu\n",
-			iteration);
+		;
 
 	ts_diff = timespec_elapsed(start);
 	pr_info("Populate memory time: %ld.%.9lds\n",
@@ -171,9 +170,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		pr_debug("Starting iteration %lu\n", iteration);
 		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-			while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
-				pr_debug("Waiting for vCPU %d vcpu_last_completed_iteration == %lu\n",
-					 vcpu_id, iteration);
+			while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
+			       != iteration)
+				;
 		}
 
 		ts_diff = timespec_elapsed(start);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

