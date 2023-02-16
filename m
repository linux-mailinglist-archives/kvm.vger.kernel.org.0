Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF88699D4A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBPUCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:02:23 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ED03B220
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:02:22 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k15-20020a5b0a0f000000b007eba3f8e3baso3028675ybq.4
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jIgrYbrw1OcjMvUr5NxPosJwiRZMEmOTls06KUUbRQc=;
        b=meju69KoHaINzwjCZgxS6UiKeUm/8jnihSc7WaSW125QfTMeJ27kk1aoGzHLv25Q48
         7kp/eSATATPovAxTPIScxxnvogQa31Xh0kRWeOFq2sF4wvFKuBCQNgSRgDTmfx0g7PF1
         oNvh6T41Bx/CEFFWmwaqOnivail/UjErz4RqdboLixkQEkkQrrj30gcYhi7siBDaOp/x
         LBcYJZU+jkZ7M2rNDhV/2fY7qg4e8lH//lt159a9nwonQG3EnhFdZqRLnX64p41Ec349
         MAync0eh9hSIxzcw8LhKP6VtOH4mJEHmH1aqAOH6qGMbDXd29P+VcSp20D6UyrpvBZLl
         SMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIgrYbrw1OcjMvUr5NxPosJwiRZMEmOTls06KUUbRQc=;
        b=UBtN3AsP/25eifN1Ad6NSSAVgG/DpK4Tymmx7B888722rNQRPLJC/DQXtFabSzwWBG
         DhUa9qj7Gnnm/MoUi27ici523vf92mBej5V8mw+qKrobLHQ2SFKglnbC+wSRYoGPZtAn
         lRvxxCUluIcog5HjHk2f4CXCVPq1ipIvwa28PJDrAduazWxgfakbkIPKXIc/bH6RAkQz
         /XSAbmIuk8oFJkXbBB+3qbDN6UinTRvt5KXf/PKUsFDJuzAIkbghoeP/xjshLz5PcBCq
         532rqMT6WnvFIn1uBqBe9kDo88lZqTGLD/wRa2o+PdsTuKiekokaocykSyEhwEaK6TLx
         2Caw==
X-Gm-Message-State: AO0yUKXhtEVjaWr7YowIqyOIrH1PZEoyDSiXylU6ZxZ4FQxJ45Ekja0x
        veOx5uuXGwQZCMfWcjX68pj/oljyrScTig==
X-Google-Smtp-Source: AK7set8e9rjh3QXcjR+A+/r5XfAnPRP4H1GfKvV7t1A+6nzeeoB6jgwNXpkF9+KZ8OCCYAgoaZO4IKH6MBMSlg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:308:b0:855:fd13:bc3c with SMTP
 id b8-20020a056902030800b00855fd13bc3cmr16ybs.11.1676577741072; Thu, 16 Feb
 2023 12:02:21 -0800 (PST)
Date:   Thu, 16 Feb 2023 20:02:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216200218.1028943-1-amoorthy@google.com>
Subject: [PATCH] selftests/kvm: Fix bug in how demand_paging_test calculates
 paging rate
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     jthoughton@google.com, seanjc@google.com, oliver.upton@linux.dev,
        Anish Moorthy <amoorthy@google.com>
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

The current denominator is 1E8, not 1E9 as it should be.

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e29..2439c4043fed6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
 		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
 
 	memstress_destroy_vm(vm);
 
-- 
2.39.2.637.g21b0678d19-goog

