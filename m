Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E83AE161
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfIIXMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 19:12:09 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:41707 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730250AbfIIXMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 19:12:08 -0400
Received: by mail-ua1-f67.google.com with SMTP id w12so4920240uam.8
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 16:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Z8yAWtxnj86qvtEzRgj68osdN0PFw+G6ih8dBi3Hz9g=;
        b=Towipsb9v0aWV9jpg5TeUU7DDRKo/1ldN8GbvpDxUUgbfQM2XuqRDVfojNH42a2HE8
         Cy8t1lVD6+2DVULHQoG0WEJtTuM8Ngjx6USNBpcQRdHV+p+wy+yQgyN1pN2exBRDNCxI
         isRxOLvJ3l21AHsiYU8hVai76rJptSjZ5Y0V1bEekTtrr0WXbH6snU11C1J3elEyZl9n
         QzgN11tg5qoZ0YesLz5sTj5ZzQvzHrtBxBhtsf2RQsUgayT8GKhw+2BDLOSHeJMGq6YX
         uR31XbzC9g5QNlgRbk/RoF9PynpBi3wdxuUGS6FUoOrykBmhSyDDfm35XuSsx5PffDmK
         yxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Z8yAWtxnj86qvtEzRgj68osdN0PFw+G6ih8dBi3Hz9g=;
        b=GgX3+V5N83+1RfMnd3T4g1dHH9eSOd4/rOcpuo00oYeFbGk2HY+N912P8FBnjxbqsR
         5ry3G1aOle7KMdxIEmsYn2RQ/buWYmtGLNZSLCmMCVxRb5X3x/mLJCCJFqFYxSncH2ud
         LHj0do8jXt/tD7RDAZajAo0lC7ih/aZKN4PH3qznAzYallB7GnsAoj7+IXuE/Ccv6scZ
         b278ZqLz6v6hAlS8g1l6vFGZSDnPfblsXB46IgeI6aWCvTnuSf1iZszXgOYGHvmBmY8K
         t/q/gWI+lqZeKL18msZtPD3/mODFaTT5Kc9Ml5ZGV9WwQ5XRtLuF3zTcRnN17PgjoC2+
         Ku3w==
X-Gm-Message-State: APjAAAVa7g/TDJTHCNEGl4TukSnZpAKB7tx3JkjcysnoxyVlV37i2LEJ
        k8F7RLERTHtsqSeCIkXj2T/pozrGR8AcVcSPlwYuVkUO3QK1
X-Google-Smtp-Source: APXvYqzrTraNs95AQ6Snb338k6NtEzllqEM/rZvQapLRf5ZnmxLo0an9Sukad3HeuYMn5IU7zSNYoIo8OBNZ2DuzaPw=
X-Received: by 2002:ab0:4261:: with SMTP id i88mr12598274uai.95.1568070727088;
 Mon, 09 Sep 2019 16:12:07 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 9 Sep 2019 16:11:56 -0700
Message-ID: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang warns that passing an object that undergoes default argument
promotion to "va_start" is undefined behavior:

lib/report.c:106:15: error: passing an object that undergoes default
argument promotion to 'va_start' has undefined behavior
[-Werror,-Wvarargs]
        va_start(va, pass);

Using an "unsigned" type removes the need for argument promotion.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/libcflat.h | 4 ++--
 lib/report.c   | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b94d0ac..b6635d9 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
  __attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, bool pass, ...)
+extern void report(const char *msg_fmt, unsigned pass, ...)
  __attribute__((format(printf, 1, 3)));
-extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
+extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
  __attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
  __attribute__((format(printf, 1, 2)))
diff --git a/lib/report.c b/lib/report.c
index ca9b4fd..7d259f6 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -81,7 +81,7 @@ void report_prefix_pop(void)
 }

 static void va_report(const char *msg_fmt,
- bool pass, bool xfail, bool skip, va_list va)
+ unsigned pass, bool xfail, bool skip, va_list va)
 {
  const char *prefix = skip ? "SKIP"
    : xfail ? (pass ? "XPASS" : "XFAIL")
@@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
  spin_unlock(&lock);
 }

-void report(const char *msg_fmt, bool pass, ...)
+void report(const char *msg_fmt, unsigned pass, ...)
 {
  va_list va;
  va_start(va, pass);
@@ -112,7 +112,7 @@ void report(const char *msg_fmt, bool pass, ...)
  va_end(va);
 }

-void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
+void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
 {
  va_list va;
  va_start(va, pass);
