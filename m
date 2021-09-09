Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D94405CE2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbhIISdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIISdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C85C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f83-20020a25cf56000000b005a0445377e8so3486845ybg.20
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EM1p9jLZe64GSfZFXrNNDzp/kFXBtDKY79IHyvGGACo=;
        b=ArdYKRqruT/+1U++RR2B9OD4/5cdLA13XWym0VDtPXnZBHg8P+tsGNPlE/CVDHNwkj
         44U1jPUTBaXc+rJBDn9jWQhncakdJvbO6mQ7wbpPadq/3IGV5fFflikR4mQvJweEm0D8
         k7x1uLF0zY8zOhFuAPa78jwCz2hIqnq8q8/Q/Os1YWChUmzrPTLDTmrHiniW/FOeb4dU
         9khCQAF5pVO+5UG39PsMhAmNVmYSqeoWNqRcFrjKVA7I+oicU1QkOjYFYHR8814HR2XA
         02e3R/3hdsNL983FCZg6CfiZ8f9ELxPwO5ZDAVlM5ny0+FN1x/OpfTy3dKq2/31i2+dv
         B4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EM1p9jLZe64GSfZFXrNNDzp/kFXBtDKY79IHyvGGACo=;
        b=l1vr/pAowrRkE451mcXtU9Jr/BXogZ9voCZTkS2XEauS02guT8zMx+Bg792luAL09x
         ZNyJWE6Aw00M7cj/qZzNYjoDsh68xMVLff4v8S6FqLFtNXQFyGI4/DQzzbrXcol/B1KE
         oLk2tevaCV/g7yuwo5elVPa4MI/XE8eXw8w+UfGdJeUCEqu4rtj4lTqo4bL0TPIHmQq2
         wRSrFPr+YsxSguoZzzmJTdWYuYwzlTN1FSfDDlyOqKadvly/NSk60h43PEnD3luxn9pC
         mnREHRQlygpLTtHblzRKEH0kHxMkOAl+fWhjn1oc5IklLBaeK5UCPRWVdeWfFrAUWdYT
         VQ+A==
X-Gm-Message-State: AOAM533+95di7vwbuOErikRhaUBvrkMo/xOXl0SpGeP1b+gnBDEFR6I+
        fnwUcMKEqFD9HoKS4hWKRKhdrMhEMyI=
X-Google-Smtp-Source: ABdhPJyGLcETJP4EpxPPzBrI2piB0OrPkMbGraqCQ9gmFaoFscq/30ERb3/nO3MidaUBxmy+SDPkr+HRCSY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a25:2e42:: with SMTP id b2mr5766692ybn.313.1631212332342;
 Thu, 09 Sep 2021 11:32:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:01 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 1/7] lib: Drop x86/processor.h's barrier()
 in favor of compiler.h version
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop x86's duplicate version of barrier() in favor of the generic #define
provided by linux/compiler.h.  Include compiler.h in the all-encompassing
libcflat.h to pick up barrier() and other future goodies, e.g. new
attributes defines.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/libcflat.h      | 1 +
 lib/x86/processor.h | 5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 97db9e3..e619de1 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -22,6 +22,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
 #include <stdarg.h>
 #include <stddef.h>
 #include <stdint.h>
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f380321..eaf24d4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -216,11 +216,6 @@ struct descriptor_table_ptr {
     ulong base;
 } __attribute__((packed));
 
-static inline void barrier(void)
-{
-    asm volatile ("" : : : "memory");
-}
-
 static inline void clac(void)
 {
     asm volatile (".byte 0x0f, 0x01, 0xca" : : : "memory");
-- 
2.33.0.309.g3052b89438-goog

