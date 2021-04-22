Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571603677AF
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhDVDFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhDVDFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DD9C06138E
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v63-20020a252f420000b02904ecfc17c803so7053345ybv.18
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mSSHnXopyMXmFcA+159IyWL+hytDhJaLCTp1FEixKI8=;
        b=pSvzT9tQOaeyEWRk7E2rJi5lyN54wxyEhDI7Bk9oAynZB5db1xDE7r6K2o15Q56Ip3
         /MYlQQkR8u/UbyOFPieLyv2tNFYjbXOoQ/iC4O9aql7BKbq+BumIMG9/mFpl8oQcfJUj
         3Soe8zioHjD5KM8+SxR8W80Lr4hMS2xi7NZGx2FrskG4VNOYYLIEaDVU1yL/qnS+6bzE
         TreuFoZQg3tPY6EKlneV1X9Jd+PD245yLe+rW6KRVBi7eWL82fvlSOzwB0rqTz3Jzgly
         P4NPjB8A/N+AiRDbwUilNFCte5H5j0gCqPUagXnA64aPKIgwCn8rM114YkEWi2vjdbJo
         zquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mSSHnXopyMXmFcA+159IyWL+hytDhJaLCTp1FEixKI8=;
        b=Xo4m2xRjmXXJ8rAaqxb3Tk4nEERom9ji7JeaKXXc7QoxWl44BMpclXnQa8gqBclwlZ
         CgBjich4qpCTG6yrd6T3nK0ZXeN1hhqad4GsunjWyA4ONsPA71wUrlE0nBHtpuHId8lS
         PA8OiUd6R94d7rVIIZEURhOAqbOFGBARG5X1UPPznDPAl7KcKvnE88ESZcoYAcNwrrJq
         oiuMqoAy3oYpnGnQspWdWNs953Yg9aSaRM0a86mHij9oeRrxoy5vSvSHEvRPayhbb3Fm
         RkbQNJel1nzSXCRN8JR18CHzG65Jec8SAZhKAD1/7sRdyX9jU9++wREyKnw3nGr7TEjs
         bAUg==
X-Gm-Message-State: AOAM5328efmaSSS+c/UK/OyeCsD554gLTyC5PyCHNtQma+sX0pXAkunQ
        abfqdU/twhX5EfZA+pW5LV//cak91Gw=
X-Google-Smtp-Source: ABdhPJwnQwsTDVcoKI8g0vYlK6UNL4T6bk/AODRBbTuaEBljurdvtJOgNYFf0rJbzHyS4ugPbappluDELnU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a5b:788:: with SMTP id b8mr1605507ybq.66.1619060717518;
 Wed, 21 Apr 2021 20:05:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:54 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 04/14] x86: msr: Restore original MSR value
 after writing arbitrary test value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the original MSR value after the WRMSR/RDMSR test.  MSR_GS_BASE
in particular needs to be restored as it points at per-cpu data.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index 757156d..5a3f1c3 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -77,7 +77,7 @@ static int find_msr_info(int msr_index)
 
 static void test_msr_rw(int msr_index, unsigned long long input, unsigned long long expected)
 {
-    unsigned long long r = 0;
+    unsigned long long r, orig;
     int index;
     const char *sptr;
     if ((index = find_msr_info(msr_index)) != -1) {
@@ -86,8 +86,11 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
         printf("couldn't find name for msr # %#x, skipping\n", msr_index);
         return;
     }
+
+    orig = rdmsr(msr_index);
     wrmsr(msr_index, input);
     r = rdmsr(msr_index);
+    wrmsr(msr_index, orig);
     if (expected != r) {
         printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
 	       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
-- 
2.31.1.498.g6c1eba8ee3d-goog

