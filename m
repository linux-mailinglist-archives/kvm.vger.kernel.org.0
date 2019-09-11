Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C73FAF446
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 04:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfIKCcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 22:32:21 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44805 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfIKCcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 22:32:21 -0400
Received: by mail-pf1-f201.google.com with SMTP id b204so14558209pfb.11
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 19:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VYuTDX4Ncc3pgau4EG/2ob1LMzFBgqPRY3cI9SdDu4s=;
        b=G4ee354GvO9uEp4Yi3nXy4FRn5J6wGdN/ZjQIQ5hYkvGgYZVjdCGYAerkfeNvrjueV
         rOQskLynifLjQf+uEnDi+WEJaU1ECqIMlrFDYZCP0HMxfvkHmVS84dOguDvkRCSKFB2V
         gkT5UkjND3QCo7J5HDN6BG9VLyAHVBrAJUbU3GPdXzifFFpcn7I/DNT9/h318g4W7Pb6
         0sfEM/JoJKIaSvDxxh0prXVA1iYUFb87K+q/OY4aENO6w57Dua8hczokasV3MsjkSdvt
         BPGBvrhR+yKlcyFSNOqw04yetppIq7xP3bHEf5DUt7Rw4Kvr9zd/DW8cDuZi+PqV/dW2
         Ks+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VYuTDX4Ncc3pgau4EG/2ob1LMzFBgqPRY3cI9SdDu4s=;
        b=MHu+m19Yt1XcP7VLAg67lgQsprtMIja6i76tYtAjDnOaQS6wBaX1/y5m4DjVwoSt+U
         2XW0gmKdozx0qpRgv4hq+DTPLeu1wFiaXMxP3N8sTyotl0kZ9Q2UELh1e9nv9pUVMbnv
         wIaH2MQxxR4hPN04x0QHxsI+ne7f2nCeAp0KLJTAjhWwaE2vjx3QZEeZgCI9g7mV0XsZ
         foikV3PSYGGU8z8SxItkDtuSs7ybVHkW70enp0V5gStQ6ZSZFmpQW5X3mggc3GzRsOWM
         hr4XuqMD7GIJcKRU14UzzzOPVQ6CDaJE01bVRugns/nd3J7Qtzk+qiI/T1o/85v72UyT
         +PxQ==
X-Gm-Message-State: APjAAAXZd4FAyEGjysgIDG6FD2h3wpArqi7t7g4ch/G6QM4MG8IUTgsE
        G4vxWxI85XTr6l8kMtxMAlWXnKYpW6xEprHTlV2dca5BasxQXwsIaSWi4WolF97h+GyEymeOXM8
        X2u6dxjXVF8DvGP5qtuLHxM9192xDN6/M8fgdsz4e6X7mPSjT44xDpg==
X-Google-Smtp-Source: APXvYqyIh3X/BP1Giz6hj0H9bf8gg6qdwQ3zEZieZDh40WB7d6H+0ZHCmDxLvJ84l06lnZ6voLXdVUNrBg==
X-Received: by 2002:a63:3006:: with SMTP id w6mr31055891pgw.440.1568169139836;
 Tue, 10 Sep 2019 19:32:19 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:31:42 -0700
Message-Id: <20190911023142.85970-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [kvm-unit-tests PATCH] x86: setjmp: check expected value of "i" to
 give better feedback
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
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
 x86/setjmp.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/x86/setjmp.c b/x86/setjmp.c
index 976a632..c0b25ec 100644
--- a/x86/setjmp.c
+++ b/x86/setjmp.c
@@ -1,19 +1,30 @@
 #include "libcflat.h"
 #include "setjmp.h"
 
+int expected[] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
+};
+
+#define NUM_EXPECTED (sizeof(expected) / sizeof(int))
+
 int main(void)
 {
-    volatile int i;
+    volatile int i = -1, index = 0;
+    volatile bool had_errors = false;
     jmp_buf j;
 
     if (setjmp(j) == 0) {
 	    i = 0;
     }
-    printf("%d\n", i);
-    if (++i < 10) {
+    if (expected[index++] != i) {
+	    printf("FAIL: actual %d / expected %d\n", i, expected[index]);
+            had_errors = true;
+    }
+    if (index < NUM_EXPECTED) {
+	    i++;
 	    longjmp(j, 1);
     }
 
-    printf("done\n");
+    printf("Test %s\n", had_errors ? "FAILED" : "PASSED");
     return 0;
 }
-- 
2.23.0.162.g0b9fbb3734-goog

