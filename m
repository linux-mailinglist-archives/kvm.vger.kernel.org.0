Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E433374C82
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 02:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEFAtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 20:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEFAtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 20:49:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3216EC061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 17:48:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u3-20020a2509430000b02904e7f1a30cffso4228918ybm.8
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 17:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HOXBWmgxEesnlPSTtd8P6NnachLBXrmty/gg16gcyj0=;
        b=QoG1kbuEO+URMeJmt2aLsDGE2a3jrRLoMoaOV95XKXhNVndHGaUfPL0r1/Pp8KM7T0
         85j0RK/12lG0FoVkqWha7BNfpyxQoNgmbbQbt5gkfDS82Ucv667QFMyicp+T5qdOMDap
         8RZNFKALFW5WDfK50UZ1ouFwN9MMhjdz8lpLY2epU0tisNWpLS25mnSkRrOQyzOWSmht
         SVHQBIo0bFvSuRhTKRsZXpDcaI/l1TwUadu90ShVgvTDdFCuJSxzbin1MerFsfMI4qrs
         ts36tJRxmIsuzOmrv66UyRy8uAokLxh1+mdPVfpREopnePSYjkALjb1FpcHVGjozAU8F
         KRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HOXBWmgxEesnlPSTtd8P6NnachLBXrmty/gg16gcyj0=;
        b=GZdua2WXmCnjIvsyAyZGvkq+v5GSMaDx4c1MT7VuPPw+yLjeW2Lg0eFik2Qzl09q/w
         mGB7CXiXR3xb6iONjJjARBUC/R3G5RtqmploN5Qaw/zliG8u+8GPXbOJd7hitYkbFrJL
         ugYbBBHBSkfKV+mgQUwwjTp/su1dg/DZ/Rd2bgrJf8sW9PgJSUhxlb+CjRDzXhZTDZ0I
         abuHcG9yPizRhbpRvz2/wy2ysr90dHjQFM6qebvCA8lii1e8gHKg2unNiWC+9Qbf+0WV
         S9r9/vlPQoQtma7wvDQbU2eCEtZBxqY2OPCH6NLxi0IMqTboWrluObOdwmBAP7KA0mb3
         t1yw==
X-Gm-Message-State: AOAM531EUHoHvrv7H1O0wCL+17uukQrbkNlrbiUYpNnGxmIbbatA4rbI
        j3s2IEip7pZuP8EnBP1dg1usZIHzsCF82A==
X-Google-Smtp-Source: ABdhPJzdAoNO9Ji3PBaQIjl1+fxf+m55M3kiUvheBzR+AYJ3srK1Uhhe9/qiMofMjuhw998gBZg7SfFhEAGXPg==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:77e2:ac:d4b1:cc53])
 (user=jacobhxu job=sendgmr) by 2002:a25:9982:: with SMTP id
 p2mr2115438ybo.457.1620262132380; Wed, 05 May 2021 17:48:52 -0700 (PDT)
Date:   Wed,  5 May 2021 17:48:47 -0700
Message-Id: <20210506004847.210466-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH] x86: Do not assign values to unaligned pointer to 128 bits
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiled with clang, the following statement gets converted into a
movaps instructions.
mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;

Since mem is an unaligned pointer to a union of an sse, we get a GP when
running.

All we want is to make the values between mem and v different for this
testcase, so let's just memset the pointer at mem, and convert to
uint8_t pointer. Then the compiler will not assume the pointer is
aligned to 128 bits.

Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
emulator.c")

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 9705073..672bfda 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 
 	// test unaligned access for movups, movupd and movaps
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint8_t *)mem, 0, 128);
 	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movups unaligned");
 
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint8_t *)mem, 0, 128);
 	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movupd unaligned");
 	exceptions = 0;
@@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	// setup memory for cross page access
 	mem = (sse_union *)(&bytes[4096-8]);
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint8_t *)mem, 0, 128);
 
 	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movups unaligned crosspage");
-- 
2.31.1.527.g47e6f16901-goog

