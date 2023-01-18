Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1067258F
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjARRxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjARRxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937F74AA7C
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p204-20020a2574d5000000b007f1def880b0so5503137ybc.10
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xxm/orB7LUO4GbG3GXDW9zqBQZYJZAY27FDyiH6MiwU=;
        b=WhEOyvhdwbIBkXwCJqOo7JOsZ+49EE4uRplRC8Tnxu3ELQMlKr/meSG9pzssds8q7f
         /uiYaQIH6Di9d/XO/XkKw8jBqL9R871EWSWtVMe6s4VFHHOUD2v06rKkyXp9RPED2YP9
         wC58FNnVn2mXwFrEiQXoA6hcn2Y4as/HfHBpYSVCJKYKNbtFqFHJWOaPHM/HcUkKpzpC
         IZ+mWyZ+mWY4CEWOzgBP+RM4SZGEoiZND26R7tcP0XCwaMfpeoT/zQfb+rRvg22QbC0C
         aGKn7d6Den6pBwb0DRKqrZG8PMxrO1qx4V7iEjQI7ynzZtgytDGZKOF9i6JKUXiiarUo
         miFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xxm/orB7LUO4GbG3GXDW9zqBQZYJZAY27FDyiH6MiwU=;
        b=JmzW2sS/P0VJMKWx7y3NF/Jlvqk8BR7v4MVo/ZM7v2p9yOHh4LKoLrjgFsUaVpDiqk
         44hjNXKkiu3rsL/JX6CEpIqHdNHXCdez9E1q2yfyUB6OK7/Kosl0DANjQkDiih2cHQPQ
         chI77m3JbSV/u2Iab90EWv20yoxby/0md0Yewab4sZXMeNFOxasgexzjgc8xoeSFfFSZ
         dEdpedOuSLww6wK5fDzr+JHf2sbXfpztDBP3/0HbwfTMzheIwZJx3RWSZgXNzR/i0sS4
         5zR7c4jNgWALYZxKFpogsHUfS8nYv/Gpjv7QIU+n07v1URhC71WXTAhUgwF9M67c3aF3
         DrKQ==
X-Gm-Message-State: AFqh2kp/+mjCX0RUQZbK/qGoKZu1nmjf+m3VcrCLnd75DCxnDCRlbMT5
        x/ajbw4AW2MU0ORRv/Q/xDFJJP1HjLp8Zg==
X-Google-Smtp-Source: AMrXdXuJvato0uhpkPkbFNJCZbzmev1u5D+kL5lpxK0ZLR3cqt+l1BD9MTkr8KqIgz7MtHcOs+k02lKiZgsWzA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:d90c:0:b0:4d7:cc6f:f8db with SMTP id
 b12-20020a0dd90c000000b004d7cc6ff8dbmr1009459ywe.509.1674064386021; Wed, 18
 Jan 2023 09:53:06 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:52:56 -0800
In-Reply-To: <20230118175300.790835-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230118175300.790835-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-2-dmatlack@google.com>
Subject: [PATCH 1/5] KVM: Consistently use "stat" name in stats macros
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consistently use "stat" instead of a mix of "stat" and "name" in the
various KVM stats macros. This improves the readability, and also
enables a future commit to add a separate "name" parameter.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 52 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 109b18e2789c..e0f21bf8ff72 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1789,55 +1789,55 @@ struct _kvm_stats_desc {
 #define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
 	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
 
-#define STATS_DESC_CUMULATIVE(SCOPE, name, unit, base, exponent)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE,		       \
+#define STATS_DESC_CUMULATIVE(SCOPE, stat, unit, base, exponent)	       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_CUMULATIVE,		       \
 		unit, base, exponent, 1, 0)
-#define STATS_DESC_INSTANT(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT,			       \
+#define STATS_DESC_INSTANT(SCOPE, stat, unit, base, exponent)		       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_INSTANT,			       \
 		unit, base, exponent, 1, 0)
-#define STATS_DESC_PEAK(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK,			       \
+#define STATS_DESC_PEAK(SCOPE, stat, unit, base, exponent)		       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_PEAK,			       \
 		unit, base, exponent, 1, 0)
-#define STATS_DESC_LINEAR_HIST(SCOPE, name, unit, base, exponent, sz, bsz)     \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LINEAR_HIST,		       \
+#define STATS_DESC_LINEAR_HIST(SCOPE, stat, unit, base, exponent, sz, bsz)     \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
 		unit, base, exponent, sz, bsz)
-#define STATS_DESC_LOG_HIST(SCOPE, name, unit, base, exponent, sz)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LOG_HIST,		       \
+#define STATS_DESC_LOG_HIST(SCOPE, stat, unit, base, exponent, sz)	       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LOG_HIST,		       \
 		unit, base, exponent, sz, 0)
 
 /* Cumulative counter, read/write */
-#define STATS_DESC_COUNTER(SCOPE, name)					       \
-	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_COUNTER(SCOPE, stat)					       \
+	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Instantaneous counter, read only */
-#define STATS_DESC_ICOUNTER(SCOPE, name)				       \
-	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_ICOUNTER(SCOPE, stat)				       \
+	STATS_DESC_INSTANT(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Peak counter, read/write */
-#define STATS_DESC_PCOUNTER(SCOPE, name)				       \
-	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_PCOUNTER(SCOPE, stat)				       \
+	STATS_DESC_PEAK(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Instantaneous boolean value, read only */
-#define STATS_DESC_IBOOLEAN(SCOPE, name)				       \
-	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BOOLEAN,		       \
+#define STATS_DESC_IBOOLEAN(SCOPE, stat)				       \
+	STATS_DESC_INSTANT(SCOPE, stat, KVM_STATS_UNIT_BOOLEAN,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Peak (sticky) boolean value, read/write */
-#define STATS_DESC_PBOOLEAN(SCOPE, name)				       \
-	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_BOOLEAN,		       \
+#define STATS_DESC_PBOOLEAN(SCOPE, stat)				       \
+	STATS_DESC_PEAK(SCOPE, stat, KVM_STATS_UNIT_BOOLEAN,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Cumulative time in nanosecond */
-#define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
-	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+#define STATS_DESC_TIME_NSEC(SCOPE, stat)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
 /* Linear histogram for time in nanosecond */
-#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, name, sz, bsz)		       \
-	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, stat, sz, bsz)		       \
+	STATS_DESC_LINEAR_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9, sz, bsz)
 /* Logarithmic histogram for time in nanosecond */
-#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, name, sz)			       \
-	STATS_DESC_LOG_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, stat, sz)			       \
+	STATS_DESC_LOG_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
-- 
2.39.0.246.g2a6d74b583-goog

