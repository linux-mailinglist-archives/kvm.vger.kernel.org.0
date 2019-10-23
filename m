Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B0BE1535
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 11:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbfJWJDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 05:03:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35189 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390828AbfJWJDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 05:03:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id v6so1839673wmj.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roq6c70I9GjqFiiJIml3zwcN2Gf7Xs/5uP2UjYMVVNs=;
        b=tXiLamF0x3ALrB7lD6lXpSU2Bnm1OzuFcUxDSPnSK3yenyUrvbtMJBI6BxvWXdhM3U
         BWrZPYfRxiAuIv2Fdg5WSwlkTzN0SZNEY9WiBp2XUKOdseqauAMqLKPkno/8iPu/VzBW
         mrRCp3E5QS0LlE7JigmxCBwRA1FOMA3PSKFcUFJrVhgAWcRita3AjP5FOKSxQ6Srl6f1
         lsZqIeKPwxEofFw0kVRld225z6Kor2VGszeP7GoeKte6zNd5FhymqOZFagZP4UjSVsbi
         +3epGUgSk2oSe3d/fht0fiCMtNHwLt/uhTqmy89Utzgedi89fKvTGYsfdJbSw2kyyJeB
         lpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=roq6c70I9GjqFiiJIml3zwcN2Gf7Xs/5uP2UjYMVVNs=;
        b=pautK0Megws82af+DnxbsSIKNJwG/5viIY3mxdbQBqgAvXeu2yGC95DHWt/VYK7OrP
         /xMswAoypmTyDJraP/hvsAA6fE/VKT4Ku1h35Id5CbA7EBZo52HS1iXQbKe+NDFPjwiU
         WYuXeO2gKEOMtnyQLZF+pffsrL+5EXN3fCm1lWkwZPzFc+0vpQNCss735i3YGwvZk7N2
         Ghd9EzGvgACNW0+VadnRJ2y149vpD/CJ6pePsgdAjrGR+TwH5sRBX2BYZ82/Q/d+Sl2B
         sCQF3RG+T/FB/GSqmv26OUnqY9dynDdHamCYYWKLNIxA1pJov4uFi4mIg35UifOuMnGC
         JGdA==
X-Gm-Message-State: APjAAAVfElO81ex0kcPShTrQH4H6NV6ArfkcjHXaMDVhikQc6AocMmyG
        qU6K3z84ev2KFJWhVl+1Z3+fEYCG
X-Google-Smtp-Source: APXvYqwyaVs2q4cjr8NVZAnNe9P2nAAKovR3WDd064gNU86GlGf8WQEeggEyxZDqHmZR3fJGJIwM1w==
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr6693651wmj.124.1571821424052;
        Wed, 23 Oct 2019 02:03:44 -0700 (PDT)
Received: from donizetti.lan ([2001:b07:6468:f312:51de:b137:4c45:7cea])
        by smtp.gmail.com with ESMTPSA id u7sm14997531wre.59.2019.10.23.02.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 02:03:43 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests] Revert "lib: use an argument which doesn't require default argument promotion"
Date:   Wed, 23 Oct 2019 11:03:43 +0200
Message-Id: <20191023090343.7064-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit c09c54c66b1df63cd11a75859cf53527d1c6e959.
The s390x selftest, for example, passes a uintptr_t whose nonzero bits
are all above bit 31.  Therefore, the argument is truncated to zero if
it is unsigned rather than bool.

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/libcflat.h | 4 ++--
 lib/report.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b6635d9..b94d0ac 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, unsigned pass, ...)
+extern void report(const char *msg_fmt, bool pass, ...)
 					__attribute__((format(printf, 1, 3)));
-extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
 					__attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)))
diff --git a/lib/report.c b/lib/report.c
index 2a5f549..ca9b4fd 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
 	spin_unlock(&lock);
 }
 
-void report(const char *msg_fmt, unsigned pass, ...)
+void report(const char *msg_fmt, bool pass, ...)
 {
 	va_list va;
 	va_start(va, pass);
@@ -112,7 +112,7 @@ void report(const char *msg_fmt, unsigned pass, ...)
 	va_end(va);
 }
 
-void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
 {
 	va_list va;
 	va_start(va, pass);
-- 
2.21.0

