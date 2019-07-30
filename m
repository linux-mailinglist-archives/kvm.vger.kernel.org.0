Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E1D7AD25
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfG3QB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:41026 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbfG3QB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from [172.16.25.136] (helo=localhost.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <andrey.shinkevich@virtuozzo.com>)
        id 1hsUZS-0001RG-Fs; Tue, 30 Jul 2019 19:01:50 +0300
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, berto@igalia.com, mdroth@linux.vnet.ibm.com,
        armbru@redhat.com, ehabkost@redhat.com, rth@twiddle.net,
        mtosatti@redhat.com, pbonzini@redhat.com, den@openvz.org,
        vsementsov@virtuozzo.com, andrey.shinkevich@virtuozzo.com
Subject: [PATCH 2/3] tests: Fix uninitialized byte in test_visitor_in_fuzz
Date:   Tue, 30 Jul 2019 19:01:37 +0300
Message-Id: <1564502498-805893-3-git-send-email-andrey.shinkevich@virtuozzo.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One byte in the local buffer stays uninitialized, at least with the
first iteration, because of the double decrement in the
test_visitor_in_fuzz(). This is what Valgrind does not like and not
critical for the test itself. So, reduce the number of the memory
issues reports.

Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
---
 tests/test-string-input-visitor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tests/test-string-input-visitor.c b/tests/test-string-input-visitor.c
index 34b54df..5418e08 100644
--- a/tests/test-string-input-visitor.c
+++ b/tests/test-string-input-visitor.c
@@ -444,16 +444,14 @@ static void test_visitor_in_fuzz(TestInputVisitorData *data,
     char buf[10000];
 
     for (i = 0; i < 100; i++) {
-        unsigned int j;
+        unsigned int j, k;
 
         j = g_test_rand_int_range(0, sizeof(buf) - 1);
 
         buf[j] = '\0';
 
-        if (j != 0) {
-            for (j--; j != 0; j--) {
-                buf[j - 1] = (char)g_test_rand_int_range(0, 256);
-            }
+        for (k = 0; k != j; k++) {
+            buf[k] = (char)g_test_rand_int_range(0, 256);
         }
 
         v = visitor_input_test_init(data, buf);
-- 
1.8.3.1

