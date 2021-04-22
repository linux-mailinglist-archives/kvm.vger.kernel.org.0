Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703913677B2
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhDVDGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbhDVDF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEDCC06138C
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso18260483ybe.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k8kB/uxnv9kzLjc+aLY861fcn3exbD8jjXlTvKbdBc0=;
        b=hdXZPLc+ALcZLr+R5t4x/u6ggnfVRlH/p85VOmhZ641OOSKlL23jx7dMmTNCCd7qen
         HJtUFea2ZILlshoC65ebLuRnv+XXiPWfAQ8vNj0mVB6klzzDzS0vnWsw3mH5d86/uOq+
         5vmuJpH6rOOs1V/aoUaPO8e6L57eWzvH3zLYsTccU/HRyshDlSLoJitNieR3gbiPaXYJ
         KzAeKcN6rwnKIY5NBntxTHF23SJ4X16LhmY9xrjmOQqleRLlkTRqqPV2lkcEiLmG7j8L
         Hn0z+Lsr2+wu25kbjp+4cizDkGpdDmfq6dvRz5C+ftLeWyYlgc37hlp6YsGosWB1Ks4a
         jpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k8kB/uxnv9kzLjc+aLY861fcn3exbD8jjXlTvKbdBc0=;
        b=V8EANo5qm0e6xLjYnYI8eU0eNdcUpIRd1wEHEyhulVf8ky8jConS0At+0t2AELGVNq
         AxL/OrNotfpMprNWB1xRfjEWW0MNlJkG1/qNy2LYIyQO+ETZWZ+oLtqllCTaJVqMOR2j
         CUWIFm//nndtBtqLTugW153Fc6msc7UDHjIEz31tGcH4B2DGFQoNw4UGznpaZ4Qc9eNg
         zSEjvyF9xItcxgIypzkLJ6wMmBxQ4F4zkT4zUeeMOiIlnmMaGGAvQ7jNCSZ1rcXL3wFv
         cn7V2rV46dq3ARla6+scb5gka4Bx2bQ+7FJqAZdWkwC7eGV8d/mHKe/qwuPPDrbH3R/O
         oDYw==
X-Gm-Message-State: AOAM532le6nFi1tmrHOuXSRFSwC1uRXQkf6Ypxwx3Tp2LqbX4hBmhD/i
        aVnrdtWjJlHBJSo5O08P4u6bCGkQvQA=
X-Google-Smtp-Source: ABdhPJyE/C9cLKUhYN8wgjtkmrOqjU+E6l7Z11S+l4wbcqcBK8eEo8gjhALmnidtNSrcHIYqNXtOX13lPo8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:4446:: with SMTP id r67mr1508754yba.54.1619060719812;
 Wed, 21 Apr 2021 20:05:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:55 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 05/14] x86: Force the compiler to retrieve
 exception info from per-cpu area
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag the exception vector/error code/flags inline asm as volatile so that
it's not elided by the compiler.  Without "volatile", the compiler may
omit the instruction if it inlines the helper and observes that the
memory isn't modified between the store in TRY_CATCH() and the load in
the helper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 983d4d8..9c1228c 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -249,7 +249,7 @@ unsigned exception_vector(void)
 {
     unsigned char vector;
 
-    asm("movb %%gs:4, %0" : "=q"(vector));
+    asm volatile("movb %%gs:4, %0" : "=q"(vector));
     return vector;
 }
 
@@ -265,7 +265,7 @@ unsigned exception_error_code(void)
 {
     unsigned short error_code;
 
-    asm("mov %%gs:6, %0" : "=r"(error_code));
+    asm volatile("mov %%gs:6, %0" : "=r"(error_code));
     return error_code;
 }
 
@@ -273,7 +273,7 @@ bool exception_rflags_rf(void)
 {
     unsigned char rf_flag;
 
-    asm("movb %%gs:5, %b0" : "=q"(rf_flag));
+    asm volatile("movb %%gs:5, %b0" : "=q"(rf_flag));
     return rf_flag & 1;
 }
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

