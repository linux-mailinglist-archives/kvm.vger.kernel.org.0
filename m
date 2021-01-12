Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D1F2F3DBD
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393433AbhALVpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393395AbhALVoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:44:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6074FC061382
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:43:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x17so101235ybs.12
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=16jbzAetGxf2Iv1g2IYZbvaGAz4mTMe0xFaX8UvhNy8=;
        b=tmIvX70kf0AHC4077r/GFIgFMtTnN+ZuZyI7xh65Jyok9zaS1lSl7Zz+YbJ+acDWye
         /OqgiaUfGzobMJF/iSMhTiI0k29jAxIgpMDYotVyW1YVr7z+4oyKqYsCBStXQ9Iu0F+q
         sBJlMXozAWqF42QCdpv4Pmmesi1Xq+/hy5jP0dkMqBOP0NlXlNeM+iM9u0hrXF4lYTJD
         2W6Ptq/dtbm6qOmgYqkoViv6pQ5E/chYSZcJ8mCj6CmcDybFQ4Ed86p/9xkmHqXFFGk5
         aH8kbii/6/elVIL73n5Wxg/efKxRNhH8PMw9/GrPaCBdzcZnfmxfSClzqmviDOS5gEQD
         B1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=16jbzAetGxf2Iv1g2IYZbvaGAz4mTMe0xFaX8UvhNy8=;
        b=Afi/CncyZI1CI922esZ4013lo1aa7M5v4RdcVY4Mn2mQGzB+QKUf5XNzbuuSLdXykB
         oyieKTBTDlZkcySTY0fwOuig3NPENOjwNFk24vc86vPFLAi7RmGguDCZ3c2TQU+6YHdR
         KxlCRKo2JLATGR6Fs/e+ibiq2SrQWxGwo50vcJiZTDk+Q7QuT1kr2cA8AWDIC7ewfUOb
         RdSCb7leBXoWDxdmN1wn97Y4AVKfPbSBeMYEMSESf+mFRPlymXnwWTlUruPEDpGziql7
         dL5ZWuzgtq+f8dCee8xCyP1yIniM0CfIXqUt4/6OoKmuw+7ZtcZgrdN1lEzutNbU1dKj
         dhbw==
X-Gm-Message-State: AOAM533t4jzVzejMcLrOkstyIdyOTRq16gO/6fBzSjxG6XHJczn7nILD
        PdoICyiBdZjPdC9f648yiDqfT8YU0DSN
X-Google-Smtp-Source: ABdhPJxTjoIqSDq8yGZNncNeEfmIVI0e54UPHQjHvk8yhSLAZXhHCFW85AWEH4wSxU3IYMR8Yk3pRl1zS/D9
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:cb42:: with SMTP id
 b63mr2317704ybg.521.1610487784576; Tue, 12 Jan 2021 13:43:04 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:42:51 -0800
In-Reply-To: <20210112214253.463999-1-bgardon@google.com>
Message-Id: <20210112214253.463999-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210112214253.463999-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 4/6] KVM: selftests: Fix population stage in dirty_log_perf_test
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

Currently the population stage in the dirty_log_perf_test does nothing
as the per-vCPU iteration counters are not initialized and the loop does
not wait for each vCPU. Remedy those errors.

Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Makarand Sonare <makarandsonare@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 3875f22d7283..fb6eb7fa0b45 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -139,14 +139,19 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		vcpu_last_completed_iteration[vcpu_id] = -1;
+
 		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
 			       &perf_test_args.vcpu_args[vcpu_id]);
 	}
 
-	/* Allow the vCPU to populate memory */
+	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
-	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
-		;
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
+		       iteration)
+			;
+	}
 
 	ts_diff = timespec_elapsed(start);
 	pr_info("Populate memory time: %ld.%.9lds\n",
-- 
2.30.0.284.gd98b1dd5eaa7-goog

