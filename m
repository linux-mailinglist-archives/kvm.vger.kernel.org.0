Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2E17A24A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCEJeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:34:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39896 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCEJeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:34:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id j1so4900663wmi.4
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 01:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=inOOEeU8s4MrMsZvPiN0++tfetTMGOEO2+eeER8zsek=;
        b=ALrNrWgkNd2p5pFR/ZIwZChNseSuz5G6+cTUdZEBl0e5qwYCns7kkQ4lA1WDRdTI8V
         fkg0yvz8eaqn5tSBTg4sKjhcR7XA/fPGCW3cHM+4xCkNmYUL4HfsJYj/V5lpODqqNfce
         r4eMCyhA2xKJDmoNY7vUuh9uqC5LOFqXkMA2dZkymhuQVfmvBkXEkISw6zGzp9DFzi5Q
         s/JWjSH0U9dhTa5yPqjv6r+3Gl3H01ZLldsdLKB1oBjWVjx4hzDjq2pfCto+lVNV44Xe
         Skz9XUh/QvKiGJWwjDUGp6J073XZjVLX4c4nDU9Qa6Gq2FFe4gxHp+4lojIxu4N6VbR4
         l4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=inOOEeU8s4MrMsZvPiN0++tfetTMGOEO2+eeER8zsek=;
        b=QNh/mBujWalplkMO11nMrajgc823ZRgcPLpmmIn29cp/DlcN2o/XAlgkqietpuxLK5
         nUfzNqw3R7zbo8id6imF3ZzHLpXI0fqs1iQL/hyjEQJZiDp0qQ0JKFZiIf5MdlRbmXH0
         unIBP3M6+KN4YsJ8RgLf/Omu+cnpC2YdU06qtXFao+sueif5WIrX/2aJMzZhyaYfV1YH
         whCjPPtvAogUhl+G1KCwO/Clo6hC4wXTdkad0hl/ZCUO4pl+IVF3esjjX+S4lte+KTgC
         FL1GJr+DebWyGs7yA53YAcuXZyt4nTcltVl8Jpv0G9S1QRR8aM4FavMmKtQZiCRrGswB
         wVEQ==
X-Gm-Message-State: ANhLgQ3l3GnJ9y9xm31TW3IogYDanBN4VO7+ARmGmiZQFnds9sEpFa9N
        7LwsP7Uqk8v2G5J0H+mPD9UsK6SC
X-Google-Smtp-Source: ADFU+vvFrZaXLFGUv+geLRkR53ie855V/El8x2mh8raI6hNczTUG77r0M65sAnmuFtAWnwuN6En9PQ==
X-Received: by 2002:a05:600c:2942:: with SMTP id n2mr8270323wmd.87.1583400874687;
        Thu, 05 Mar 2020 01:34:34 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i7sm28323587wro.87.2020.03.05.01.34.33
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 01:34:34 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: allow specifying the tests to be run
Date:   Thu,  5 Mar 2020 10:34:32 +0100
Message-Id: <1583400872-56657-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copy over the test_wanted machinery from vmx.c.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index ae85194..70e5169 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1577,11 +1577,52 @@ static struct test tests[] = {
       pending_event_check_vmask },
 };
 
+int matched;
+
+static bool
+test_wanted(const char *name, char *filters[], int filter_count)
+{
+        int i;
+        bool positive = false;
+        bool match = false;
+        char clean_name[strlen(name) + 1];
+        char *c;
+        const char *n;
+
+        /* Replace spaces with underscores. */
+        n = name;
+        c = &clean_name[0];
+        do *c++ = (*n == ' ') ? '_' : *n;
+        while (*n++);
+
+        for (i = 0; i < filter_count; i++) {
+                const char *filter = filters[i];
+
+                if (filter[0] == '-') {
+                        if (simple_glob(clean_name, filter + 1))
+                                return false;
+                } else {
+                        positive = true;
+                        match |= simple_glob(clean_name, filter);
+                }
+        }
+
+        if (!positive || match) {
+                matched++;
+                return true;
+        } else {
+                return false;
+        }
+}
+
 int main(int ac, char **av)
 {
     int i, nr;
     struct vmcb *vmcb;
 
+    ac--;
+    av++;
+
     setup_vm();
     smp_init();
 
@@ -1596,10 +1637,13 @@ int main(int ac, char **av)
 
     nr = ARRAY_SIZE(tests);
     for (i = 0; i < nr; ++i) {
-        if (!tests[i].supported())
+        if (!test_wanted(tests[i].name, av, ac) || !tests[i].supported())
             continue;
         test_run(&tests[i], vmcb);
     }
 
+    if (!matched)
+        report(matched, "command line didn't match any tests!");
+
     return report_summary();
 }
-- 
1.8.3.1

