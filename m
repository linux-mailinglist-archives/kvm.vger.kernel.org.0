Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCCE68E471
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 00:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBGXdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 18:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBGXdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 18:33:08 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE0228D0A
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 15:33:07 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id x12-20020a5d990c000000b00707d2f838acso10223181iol.21
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 15:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N6h618a8IiC/nGqLszjY9LqsjtRfc/MrCQyIIfIRceU=;
        b=kKnQH6i3lSpXOlPwaSR1R49mnXTs6pFalqV3F1N2sYxJBIymUDjZovHWsHbY0T6aEI
         FiN1OTfFRVrjs6cdJBMAb7c1ENszzTCF/oe6vqMi3JCn45OE6qWv6Gz8I6+wWC9VLqF0
         uPntNR9b2YP3br1S6wbHaGWYOo2ccRXK0GDxow3dXHGkej/ItybydTdY7EBFA2Aq0tCo
         EXGDy5JGs5J0kcRuzJ2Koyo+j4R1P1UnXcEqyg02N7dedpr0XKQcFOGiM7oO4uDNQemp
         HaZ2vCzk0u0v4G7KvlHno3j5lt4+zzaK7FO81YzBhx6f42eFh179ybgHVIP+iGpt5lfb
         spzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N6h618a8IiC/nGqLszjY9LqsjtRfc/MrCQyIIfIRceU=;
        b=kInY0zslw+Fz181Iv+BmNb8M9MS3WKmFUZHCD8CtFma/XiyGegUUVIHqgvixs113Og
         kFkSGih7cUxHL5f5zpLXZrr0IhqRG2QxIKhhLsleTmZohUAymwinlBQ1dLPBibWD7xQd
         +dfWXoheFuWkANGfVAqDo3p3o9MwVaijLydnQL6ZU18RC4kz7uxe0s1iszmb8+r7ckRh
         ujT8mdl9sZmqJO5khLnzowVeMFpYNDhUoQjqN1pluRq40xMXVdpJP9rWsMAsP9LoZnhG
         1Gfoe5hoTP2llZutfZZjoMNreU4VBIwRsXtqOPw4KKw0jgBWv8X+51e0jv/rRTJpI92G
         UH0w==
X-Gm-Message-State: AO0yUKXNyDBqyVNrsgPnC/eoqYuqm/TXPJ47S8CZybHJoDnymFhu7hYt
        qLV6TmD3n29M7IuNosSp/Jy0Vg9BGAYPRhiw7g==
X-Google-Smtp-Source: AK7set+k/u2kIySuEIR0kebO9mmsun3MYIoosq2YGY/w2M2IQl+7JdSKgUbauDGYTzIKCDoA322OA+aSPUaU28+RSw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:b691:0:b0:3b1:92c0:ac28 with SMTP
 id i17-20020a02b691000000b003b192c0ac28mr3685028jam.74.1675812786710; Tue, 07
 Feb 2023 15:33:06 -0800 (PST)
Date:   Tue,  7 Feb 2023 23:32:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207233256.3791424-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v5] arm: Replace MAX_SMP probe loop in favor of
 reading directly
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
 scripts/runtime.bash | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

v5: Remove the last awk reference and guard the probing code with a
check that ARCH = arm or arm64.

v4: https://lore.kernel.org/kvm/20230201172110.1970980-1-coltonlewis@google.com/

v3: https://lore.kernel.org/kvm/20230130195700.729498-1-coltonlewis@google.com/

v2: https://lore.kernel.org/kvm/20230111215422.2153645-1-coltonlewis@google.com/

v1: https://lore.kernel.org/kvm/20221219185250.631503-1-coltonlewis@google.com/

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..fb64e855 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -188,12 +188,11 @@ function run()
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
+# error first, so this check is only run for ARM and ARM64. The
+# parameter expansion takes the last number from the QEMU error
+# message, which gives the allowable MAX_SMP.
+if [ "${ARCH%64}" = arm ] && smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
+      |& grep 'exceeds max CPUs'); then
+	smp=${smp##*(}
+	MAX_SMP=${smp:0:-1}
+fi
--
2.39.1.519.gcb327c4b5f-goog
