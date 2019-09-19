Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA8FB86AF
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 00:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404159AbfISWPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 18:15:07 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:35382 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406071AbfISWPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 18:15:07 -0400
Received: by mail-pf1-f202.google.com with SMTP id r7so3229160pfg.2
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sXbhgwagHRA9ISvIc6zPNxVwv36dHM1scEFF+Wpapbg=;
        b=So8jPdlGSRnHRVjCp2bwt3RbuIXHPdOaAoJ9haGRGEsSGcfDN2R2qHlpjzSnfxw5as
         BOp4KWBf3Md5tfD03sNX8BG4AWnzaMKVQ+pEBsHdt0FndnIcxZ13Ve2Difg91Qwz688Z
         XlqpX7U/Ux02VlUfT0Ai2LvfznJbkGMOhyxz1jsFWWPryKo3IsGHoFDHOkvWO65o74nb
         u4Mf0ztR0YEZ4CBJ88xOSBYU1cGWrJshR6nhzHxls+xaN4zr9ZkupOBl4BzCe6kzuq7X
         SbkNzjL4irMwxd4+IGJvMcgaSqaUP91OBgGoaZAcM24nKX57euNSq26eDLJhL2cNOEaf
         HSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sXbhgwagHRA9ISvIc6zPNxVwv36dHM1scEFF+Wpapbg=;
        b=ZYPhI07Lbyzi8TFa75mbXN9//GPSZxXpVYBu1SfSRrz5Ly6eVzuH4mMIGGeLGnG/9x
         jLSnrEm0UpQkINT+MI0KRdhOtFUsbWv0YoIMCh8hjtFh56LzvCEjN10eTeDrTIeJQ2lz
         JSBGo7r+pqkurKbPOaVD1smFig3wf1b41FcfWT6nulK+QIiBIfJOKB+ysEQ1O2d4wEAr
         0nt6VYY1Qyo0KY6SYAHDh9zqMzXxHmdBolHngurRQOh4ACENJTYDVXnTKm52Y2yWGA5a
         bA9bvTvPYRLTR6jeucHvicWL4CpeOWkwik8fWhc2klUIIv8kNzZ9VqCZvEnDkwdkDnMR
         wCIQ==
X-Gm-Message-State: APjAAAWZLSwCcf2WOayoK0RR79aWWdI5FDuZIi4SZ1Hz4EyHPst4OoBm
        glamHc3bmKXjdhr7lNjssZu1gYRurGGEm3H/Q+Ps2tcSJKXpK+tn4ldHEyvBZJkFQ2sBSTwhpBQ
        BaL90BOTgg8oXmp+31FHh3vnajRlLgENp0N3HdoT0GK7QXO7iyRGT1w==
X-Google-Smtp-Source: APXvYqwIe3hvcFfOdbRemLw/Ge2iH8lV94rFOCM7gxFJHTbPnqs2t7jw/MikDEUTshHS/CPpdwTcrBAuqw==
X-Received: by 2002:a63:505:: with SMTP id 5mr11053190pgf.297.1568931305825;
 Thu, 19 Sep 2019 15:15:05 -0700 (PDT)
Date:   Thu, 19 Sep 2019 15:14:53 -0700
In-Reply-To: <20190919203919.GF30495@linux.intel.com>
Message-Id: <20190919221453.130213-1-morbo@google.com>
Mime-Version: 1.0
References: <20190919203919.GF30495@linux.intel.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [kvm-unit-tests PATCH 1/1] x86: setjmp: check expected value of "i"
 to give better feedback
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a list of expected values instead of printing out numbers, which
aren't very meaningful. This prints only if the expected and actual
values differ.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/setjmp.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/x86/setjmp.c b/x86/setjmp.c
index 976a632..1874944 100644
--- a/x86/setjmp.c
+++ b/x86/setjmp.c
@@ -1,19 +1,26 @@
 #include "libcflat.h"
 #include "setjmp.h"
 
+static const int expected[] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
+};
+
+#define NUM_LONGJMPS ARRAY_SIZE(expected)
+
 int main(void)
 {
-    volatile int i;
+    volatile int index = 0;
     jmp_buf j;
+    int i;
 
-    if (setjmp(j) == 0) {
-	    i = 0;
-    }
-    printf("%d\n", i);
-    if (++i < 10) {
-	    longjmp(j, 1);
+    i = setjmp(j);
+    if (expected[index] != i) {
+	    printf("FAIL: actual %d / expected %d\n", i, expected[index]);
+	    return -1;
     }
+    index++;
+    if (i + 1 < NUM_LONGJMPS)
+	    longjmp(j, i + 1);
 
-    printf("done\n");
     return 0;
 }
-- 
2.23.0.351.gc4317032e6-goog

