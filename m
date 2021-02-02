Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CEC30CAFC
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhBBTIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbhBBTEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:04:22 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742ABC061D7E
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 137so14093966pfw.4
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZvItmnRmq3+3IUtsIrhOy3Q/zP9ao+Af4hI06xbsCBk=;
        b=T06o6eb7cr8x20ra650Qhv19YCauK4JvfpH2VPNTwvPmtbqZa4F6+bx4i+bkR2FwoN
         RYZbdt8+Sofz/kn8MhYElw6lAIB2hxwkBE64lxBZ8mCrvd9jg0Sgr1DqjCE/j91pO7xj
         Bpt0Zb6tTkjnwHHGf4AosXwJUy4CY8arXs/jHQRj41vmpIXxlTxo8iR+2EAXVrPn72Bw
         LMoVRM0LcjI+aaN4S9Ml3dCja3XCk4LmuvZUTc5DLmAXW67FXKhQttM0oAYWXHOWOhZv
         0fRdg5Zawh5EQJnP9m4VCDxa1de7ftpF/0P/h5Zwk6RaC8wsCCoxwztH6JgpvcrrwxOI
         Uz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZvItmnRmq3+3IUtsIrhOy3Q/zP9ao+Af4hI06xbsCBk=;
        b=hKxxFXbK6blXM83MX0yfh5+5X2/DBajTdGewZaWyPirDG+xPy1E6hjeYofsFfWI2A2
         Dxnu5SMOKNnL3mcYoOGAwtWQYU7m9gGz6ajEDtpUUF1+gdIFl++Ay8ctDHeLkUOzYS6N
         jvN4FKlYiPXO+Cgx+qRfBlytMyRHzXP6qE463ZVbk1bhghR8JOJXqhF7LxMMYiB8t6rg
         londDAdWVj07D5FI8wEtfeGfJnJGHJ6TQG1yWHm+Xfzl7fkuBzXSHlocxZoDBWwm9JS8
         RYxA9ynmz2hFOlZ6dK8u4bqELiookzWQtOi6bUBDCi5ynvvUv1wX0YFFKIt3rz7qD5XT
         PsQw==
X-Gm-Message-State: AOAM530xyGsknocBuoLiukqGt/vw2V5eOVRsctVsEQfP3qmCaWmhKl3j
        oCju+yweOTDhqOab1w9t+Lci2tPphTun
X-Google-Smtp-Source: ABdhPJxMmxSs+7Fj0bLxcfcTv53Dae5POhJVmfwPfvOLN6jt6IT1flYD3vfMkIXyS8vkwr0W/inwMI9kfCd4
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:7143:: with SMTP id
 g3mr5960230pjs.196.1612292309943; Tue, 02 Feb 2021 10:58:29 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:34 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-29-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 28/28] KVM: selftests: Disable dirty logging with vCPUs running
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disabling dirty logging is much more intestesting from a testing
perspective if the vCPUs are still running. This also excercises the
code-path in which collapsible SPTEs must be faulted back in at a higher
level after disabling dirty logging.

To: linux-kselftest@vger.kernel.org
CC: Peter Xu <peterx@redhat.com>
CC: Andrew Jones <drjones@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 604ccefd6e76..d44a5b8ef232 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -205,11 +205,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
-	/* Tell the vcpu thread to quit */
-	host_quit = true;
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-		pthread_join(vcpu_threads[vcpu_id], NULL);
-
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX, 0);
@@ -217,6 +212,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	/* Tell the vcpu thread to quit */
+	host_quit = true;
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
+		pthread_join(vcpu_threads[vcpu_id], NULL);
+
 	avg = timespec_div(get_dirty_log_total, p->iterations);
 	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
 		p->iterations, get_dirty_log_total.tv_sec,
-- 
2.30.0.365.g02bc693789-goog

