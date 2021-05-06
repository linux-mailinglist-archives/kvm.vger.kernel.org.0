Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743F1375A6C
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhEFSuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFSuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:50:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86241C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:49:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mw15-20020a17090b4d0fb0290157199aadbaso3606263pjb.7
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JanHG7KPAUG1YRQS7P7hCl7vtCSTtYbhxlwMrWYEFEI=;
        b=n7ZK7u7ZkrlmGeKGJsfWiRxDKKowuULOq7dYJt5bgojYxbvSOH1ZjUmTUO0Dsf0VAi
         Z2UfGkCllfCFmRPXHpeapoDUT58J2dWLPg9A6VCzl10sSL56O50aJ9XRJ0572N3fHCZ6
         tQr+7sOz0yNwxaVxuOV8sp7HiQ/5TEwBPXxsYyZQd4HXaPIMPLbvTsEhi3o08t2+DPt1
         St/u3xNjZSlA500ZtetS1sTu8k2p5504I697r9cIoq09XHPlthBE4l5G4AdXpxk3Fh6H
         OBo0i54GU0YeQUXUNcvpkFVRBPk2gLhrWgM0JQ/XHgdDaAr/KysHJPKMiFdsJeC8hhTR
         ySsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JanHG7KPAUG1YRQS7P7hCl7vtCSTtYbhxlwMrWYEFEI=;
        b=CzAKW5GCDr5q4ynTn6GWCZNwNuzUXJQ/bDitQgD1bcNAd0CCqzqHYm598ut/bqs1sZ
         oPUHcO7RgdPRKJSZ5lz8nACZ4jBNqTT4wOulLsoPegXPTXienfgzt27qqF03zdPxP/h9
         ARejlWE4eUVxN7E2/9obYqnoophVMG+3HGV55bJ1VuXikAKzvKGwaQzgOUltBI1z4K+w
         wJgcgzxlb42H6c7LGY4bXd03VLzGMH7Z//yfnhNlWoL30mISepRQBYU2Aki2TtdHWu0k
         ba1iq84qgyLibSNLJQzerumGczLav2EXMJVjjg+pL49jwzVMxtq61kpIGCHg4CSffCUD
         fSvQ==
X-Gm-Message-State: AOAM5315D4eok5j5jFAH6mVgjCrJeCkr158+At9QSsbjCiCHTNIvEtgW
        93RouS/+3mCFW34DA/or4i7MbYuVVmHUSQ==
X-Google-Smtp-Source: ABdhPJwdAm9E7lls89s9SILdpXU/0rETiH0p2FTA2p7wlhiqsiplQgzfiybmCpWPQnhVkAyddoTMnBvmovy8WQ==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:eeaf:2d87:56f1:7d73])
 (user=jacobhxu job=sendgmr) by 2002:a62:808b:0:b029:252:eddc:afb0 with SMTP
 id j133-20020a62808b0000b0290252eddcafb0mr6498401pfd.41.1620326973042; Thu,
 06 May 2021 11:49:33 -0700 (PDT)
Date:   Thu,  6 May 2021 11:49:25 -0700
Message-Id: <20210506184925.290359-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
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
uint32_t pointer. Then the compiler will not assume the pointer is
aligned to 128 bits.

Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
emulator.c")

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 9705073..a2c7e5b 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 
 	// test unaligned access for movups, movupd and movaps
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
 	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movups unaligned");
 
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
 	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movupd unaligned");
 	exceptions = 0;
@@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	// setup memory for cross page access
 	mem = (sse_union *)(&bytes[4096-8]);
 	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
 
 	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
 	report(sseeq(&v, mem), "movups unaligned crosspage");
-- 
2.31.1.607.g51e8a6a459-goog

