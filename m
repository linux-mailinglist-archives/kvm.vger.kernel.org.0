Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9397D63C6CB
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiK2RxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiK2RxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:53:09 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1E622521
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:53:06 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u10-20020a17090341ca00b001897a151311so9326514ple.8
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YQYMQ5TWIkasP9BJVVj6hmvyVoNhk7XnNn3h91+5VkA=;
        b=frHEo0XtDqPZACEUQ2weEeovjiztTB9ysfaI29EV10g0HOFMziutKKGRFHrQmeSGNR
         ECaDYAgpppOxjQzHeZk0tlAe6Bt8qy2w9DcMjVtSoiZPSs2bjSX4e/znHpyw6+uEGDxZ
         66Gce8MvYf4swaRUAlv0aIDvTtBh9PN6Td1fp9uPIoo9k7j5Qr7EanUTXdDsPukVZBs1
         vO+kUTp4LcwbdeAE6Yv+86QqdtNDj5IG4QxbbJbmT89u36G0sA61RT5c3zrhhsBgzmXt
         DJMlvf6FZKMa4gWOn+q5HsW84njqECMFsKOXush90wluZAdoKklom1sSJfvjdqeVscCg
         XZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQYMQ5TWIkasP9BJVVj6hmvyVoNhk7XnNn3h91+5VkA=;
        b=RpTVh+NUlrIWpTP33usWh5Q5NJdtUDYlr16pphnQCUY3caZECJyP0XlwW3Z7ta1f/c
         zeVE7Jx9mGT+bwz6UIFoEOk9dyMh+qcD0Nx7sLKwAbXS/N3PgOb5RYzOsWOUjVhv0jkK
         KM516WGmDaZ97ywzITX4S/aIFoZm//CffGv2N/ZjVBUS+BKAxbrw2llWfUNSC3ohPdw+
         frvjddp40yMjiJ5nAo0gpxF5WXmGhd5i9u3oU/gEoycPWQSOwT26ziVYiQi29Ue9KY3i
         ocAjgJ+j66rvbh5HAYa+GAz6xmitbM7vxRi9nQp7R78OUGskggNScMLOE785amKI0jpM
         KfcA==
X-Gm-Message-State: ANoB5pmXao4ELZuipri7+t+inGp3GZyHTh98NnLHvhxVC0nP0vhYZjkI
        t+3ds4EqChzMWrtcINTHBxvVTQfkN+s=
X-Google-Smtp-Source: AA0mqf4PXOL23sfKTrTaOyhFFDDrf0McQzPnBCBetrWYrA4lfqAZM7skUAjsgPQ4amUvnkfsJVaMUCu/QnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b89:b0:179:eaa8:9113 with SMTP id
 p9-20020a1709026b8900b00179eaa89113mr37921813plk.55.1669744386298; Tue, 29
 Nov 2022 09:53:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Nov 2022 17:52:59 +0000
In-Reply-To: <20221129175300.4052283-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221129175300.4052283-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129175300.4052283-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: selftests: Fix inverted "warning" in access tracking
 perf test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Warn if the number of idle pages is greater than or equal to 10% of the
total number of pages, not if the percentage of idle pages is less than
10%.  The original code asserted that less than 10% of pages were still
idle, but the check got inverted when the assert was converted to a
warning.

Opportunistically clean up the warning; selftests are 64-bit only, there
is no need to use "%PRIu64" instead of "%lu".

Fixes: 6336a810db5c ("KVM: selftests: replace assertion with warning in access_tracking_perf_test")
Cc: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 02d3587cab0a..d45ef319a68f 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -185,10 +185,9 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	 * happens, much more pages are cached there and guest won't see the
 	 * "idle" bit cleared.
 	 */
-	if (still_idle < pages / 10)
-		printf("WARNING: vCPU%d: Too many pages still idle (%" PRIu64
-		       "out of %" PRIu64 "), this will affect performance results"
-		       ".\n",
+	if (still_idle >= pages / 10)
+		printf("WARNING: vCPU%d: Too many pages still idle (%lu out of %lu), "
+		       "this will affect performance results.\n",
 		       vcpu_idx, still_idle, pages);
 
 	close(page_idle_fd);
-- 
2.38.1.584.g0f3c55d4c2-goog

