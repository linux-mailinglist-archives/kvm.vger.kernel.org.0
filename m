Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACB0686CC2
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjBARVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjBARVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:21:43 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CF77CCBA
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 09:21:35 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id u6-20020a6be406000000b00716ceebf132so6994689iog.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 09:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vixU9pzYhiOIncz9zX7lMuKnpujKybYqZj2xZH7tetQ=;
        b=sQEjai0uI3qOrLb6DRDGWSLF38T3/lb+HhYxA9+PZAfg2jPauHRpIvyVUjOkOmtSAk
         5dryqdBMCQNqG8NWE1+YzakqVh13rtbsvpL4S6N40CpAr6OE1jF1PH6m0nL/vtGnzFC/
         jqiuJtdtHt4+YZIuFoZEOTRYHnpbSGq4AJCfcK1TBpTR0RfufarXi+pe9bjLLxKjD1GZ
         aQO8lHp3nwbklsf6IUiRL9WoNumJBkuwL+Bsx50k3Y9RGqMAMuYAHrM30DQ0gA3vrgVe
         3/lshYL0mNpKeQJq9ib8EOeL/fDcyTqVmJ6wuq3yPBKJjVU0IUkY/GgFZ/nQsjjljuII
         ellA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vixU9pzYhiOIncz9zX7lMuKnpujKybYqZj2xZH7tetQ=;
        b=iuFOXUKefT+8/oG87+YlK66zcOa+UJVpjKmKu0iDLv6zOVt6mzIJixDx9Is8HVFYEw
         qgEM3AhePuX/09EzTlVlxyte+J5ZlBNYm/qV9XNa5g0ZOVmMyXzgvpdyFV66ganDG9Ma
         I+hSUM/abkIaNeiElUybAHQQ/neUZnVFpM0uOg6TEvV49XTjSQhukW5agMtQEryJilb6
         qSJRdZeLA1XAlXfU1ebsVBo3h5Q1lfu4938bwlnBAH7DBMNbW8FfZjBv7VOLzokWm6/z
         Rx5/BpK1zhhe7/LMOceeUUXMcwe3oe3vOCwuQOgaTuyC0ZHL820e2DCQjPqzN5tGZej7
         KHFQ==
X-Gm-Message-State: AO0yUKWxzkjCGpv36NrNNcvoLU4rvM4mW6Y6sUVtrro7OtvQV8naL7K/
        EISOfeBMnmgQkrst6gZ2C1KKXhS0DqjsNub7zg==
X-Google-Smtp-Source: AK7set+UzX3gG1XPgKuvwDtcN7U1fDyg7jbdKztXIPTFDY92+NzE9OAAn4OUdFJxb6VsVVYZM30v2et1JJQ9EOpnTg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:c712:0:b0:310:9907:2319 with SMTP
 id a18-20020a92c712000000b0031099072319mr612423ilp.113.1675272095007; Wed, 01
 Feb 2023 09:21:35 -0800 (PST)
Date:   Wed,  1 Feb 2023 17:21:10 +0000
In-Reply-To: <20230201172110.1970980-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230201172110.1970980-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201172110.1970980-2-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From:   Colton Lewis <coltonlewis@google.com>
To:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Colton Lewis <coltonlewis@google.com>
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

Replace the MAX_SMP probe loop in favor of reading a number directly
from the QEMU error message. This is equally safe as the existing code
because the error message has had the same format as long as it has
existed, since QEMU v2.10. The final number before the end of the
error message line indicates the max QEMU supports.

This loop logic is broken for machines with a number of CPUs that
isn't a power of two. This problem was noticed for gicv2 tests on
machines with a non-power-of-two number of CPUs greater than 8 because
tests were running with MAX_SMP less than 8. As a hypothetical example,
a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
6. This can, in rare circumstances, lead to different test results
depending only on the number of CPUs the machine has.

A previous comment explains the loop should only apply to kernels
<=v4.3 on arm and suggests deletion when it becomes tiresome to
maintain. However, it is always theoretically possible to test on a
machine that has more CPUs than QEMU supports, so it makes sense to
leave some check in place.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..587ffe30 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -188,12 +188,10 @@ function run()
 # Probe for MAX_SMP, in case it's less than the number of host cpus.
 #
 # This probing currently only works for ARM, as x86 bails on another
-# error first. Also, this probing isn't necessary for any ARM hosts
-# running kernels later than v4.3, i.e. those including ef748917b52
-# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
-# point when maintaining the while loop gets too tiresome, we can
-# just remove it...
-while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
-		|& grep -qi 'exceeds max CPUs'; do
-	MAX_SMP=$((MAX_SMP >> 1))
-done
+# error first. The awk program takes the last number from the QEMU
+# error message, which gives the allowable MAX_SMP.
+if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
+      |& grep 'exceeds max CPUs'); then
+	smp=${smp##*(}
+	MAX_SMP=${smp:0:-1}
+fi
-- 
2.39.1.456.gfc5497dd1b-goog

