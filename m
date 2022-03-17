Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067B34DBE67
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiCQFev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 01:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCQFeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 01:34:50 -0400
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F222335DC
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:02:32 -0700 (PDT)
Received: by mail-pf1-f201.google.com with SMTP id k130-20020a628488000000b004f362b45f28so2906267pfd.9
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=orPz1N9sb4VObY0DVEB/1SEaT7xLNh+eUph/PNeO4nQ=;
        b=GHFh4+29HUaAFUYRfJ/jHI3C57so7rNewE6Lv/OXEhhyIgXMWs4LbD5tSqnSmzryUO
         BCU9Ke3HGeM/aIr7AemTs7+60ktbBDcDgmuhFV5Ss+8TuPogYofszjB+VsbF30hI35ii
         ApkgwVKn92b7jtL1cOY68PJUQSaEn+0hy3CifabQ4zAi7OQyzhubSfOkWgR+94WnoMlO
         QNxLLqAuXNY3mFjkJXnxZxfY3dO6aPZnl/wC5iShn224fcJc7GKXNU7Jepa05issM7PT
         zpq86zdo8RU15t9QLETux0eo7zaa/4+o7LYxG67/nOs0b1jEDAM+8Oqp5ZqAOyvvWlj/
         OsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=orPz1N9sb4VObY0DVEB/1SEaT7xLNh+eUph/PNeO4nQ=;
        b=dBiIA9rZXhPUh97UzjmHRrHRkTH1+2aANb5c+JZ6v2TQvX2rJrKjm2GQbFpnMmJ0hP
         j223V1NdCxVwpspL1Rrh8Ay3QrSX7XozbUHwERn8AiSHG1aBbKDPSQIwf5LeP0kJW+3I
         H5viYvtmBxayclmE9iK1WZ/GC7f8MWN0zYsyrS/PYYNxDL2A3ylHWIaOkK5zjEPZ0iSd
         xa5cH7VLl/mSx2UgD+FJc62kfHaU+kXJzmE5MZdFZysaf5clE9LhAr0RJk48gVnudrnj
         yAAyrHBVd97aGQ/HOWmp9CPn3ECa3e6Njno5Jcsvf7DhCJ4zXfQCl4Ham0AtwXcZsaOM
         /1MA==
X-Gm-Message-State: AOAM530E760yYcPNPBjkiuq1KvRdJpH6WoptGFdihg0AwBiki2PBHUVn
        PfIscZRIFCYC4zByrHSN99vdzuilw+2y9WjxU5AhPlUOQQ2AwMB4kVab7Pssoi0PgvsmEAX05Bv
        R7ssyHPBd5KXPGET5I8ieesCXnBQWhii9Qh5mi1bm9+r/2dgNZWuZtJOJsFZDVFU=
X-Google-Smtp-Source: ABdhPJzMNVszd9N8c+vlCGkv5DBuw+V048hOo2NeEOnk9aZLyf/NK51yu1+AdrmZzfTiIaeLEeS0t9jWO0FI8A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:10cb:b0:4f7:942:6a22 with SMTP
 id d11-20020a056a0010cb00b004f709426a22mr3258065pfu.84.1647492692552; Wed, 16
 Mar 2022 21:51:32 -0700 (PDT)
Date:   Wed, 16 Mar 2022 21:51:25 -0700
In-Reply-To: <20220317045127.124602-1-ricarkol@google.com>
Message-Id: <20220317045127.124602-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220317045127.124602-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 1/3] KVM: arm64: selftests: add timer_get_tval() lib function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add timer_get_tval() into the arch timer library functions in
selftests/kvm. Bonus: change the set_tval function to get an int32_t
(tval is signed).

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..93f35a4fc1aa 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return (int32_t)read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return (int32_t)read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.35.1.723.g4982287a31-goog

