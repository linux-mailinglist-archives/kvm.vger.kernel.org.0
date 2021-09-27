Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0146C4197F7
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhI0PcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:32:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:14125 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhI0PcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632756646; x=1664292646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aKQ3tgknLQLcPTeF4FhATXMnvpEfNpZhwI40xNtAnfo=;
  b=GIvSjX/uHYXisv1wVtEPPV+OdaV4caDk4vx99s387IdJeIz2VKvjqFrx
   2pAqQ0S+PHEWrWCWgs1OJdDlzSr9oZ9V6tb3zLQ20Zr46RZxu2EI75BuS
   ZQ4iK+2oLJ5NAHVZvQIrsGO/7u5dnh5DwdFSWXngwLA9VRVF0sSFogSdG
   w=;
X-IronPort-AV: E=Sophos;i="5.85,326,1624320000"; 
   d="scan'208";a="150233689"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 27 Sep 2021 15:30:38 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id BFED5C101A;
        Mon, 27 Sep 2021 15:30:36 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:30:35 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:30:35 +0000
Received: from dev-dsk-ahmeddan-hc-1a-c85ff794.eu-west-1.amazon.com
 (172.19.109.50) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.23 via Frontend Transport; Mon, 27 Sep 2021 15:30:34
 +0000
From:   <ahmeddan@amazon.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <nikos.nikoleris@arm.com>, <drjones@redhat.com>, <graf@amazon.com>
CC:     Daniele Ahmed <ahmeddan@amazon.com>
Subject: [kvm-unit-tests PATCH v2 1/3] lib/string: Add stroull and strtoll
Date:   Mon, 27 Sep 2021 15:30:26 +0000
Message-ID: <20210927153028.27680-1-ahmeddan@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniele Ahmed <ahmeddan@amazon.com>

Add the two functions strtoull and strtoll.
This is in preparation for an update
in x86/msr.c to write 64b values
that are given as inputs as strings by
a user.

Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>
---
 lib/stdlib.h |  2 ++
 lib/string.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/lib/stdlib.h b/lib/stdlib.h
index 33c00e8..48e10f0 100644
--- a/lib/stdlib.h
+++ b/lib/stdlib.h
@@ -9,5 +9,7 @@
 
 long int strtol(const char *nptr, char **endptr, int base);
 unsigned long int strtoul(const char *nptr, char **endptr, int base);
+long long int strtoll(const char *nptr, char **endptr, int base);
+unsigned long long strtoull(const char *nptr, char **endptr, int base);
 
 #endif /* _STDLIB_H_ */
diff --git a/lib/string.c b/lib/string.c
index ffc7c7e..dacd927 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -242,6 +242,80 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
     return __strtol(nptr, endptr, base, false);
 }
 
+static unsigned long long __strtoll(const char *nptr, char **endptr,
+                              int base, bool is_signed) {
+    unsigned long long acc = 0;
+    const char *s = nptr;
+    int neg, c;
+
+    assert(base == 0 || (base >= 2 && base <= 36));
+
+    while (isspace(*s))
+        s++;
+
+    if (*s == '-') {
+        neg = 1;
+        s++;
+    } else {
+        neg = 0;
+        if (*s == '+')
+            s++;
+    }
+
+    if (base == 0 || base == 16) {
+        if (*s == '0') {
+            s++;
+            if (*s == 'x' || *s == 'X') {
+                 s++;
+                 base = 16;
+            } else if (base == 0)
+                 base = 8;
+        } else if (base == 0)
+            base = 10;
+    }
+
+    while (*s) {
+        if (*s >= '0' && *s < '0' + base && *s <= '9')
+            c = *s - '0';
+        else if (*s >= 'a' && *s < 'a' + base - 10)
+            c = *s - 'a' + 10;
+        else if (*s >= 'A' && *s < 'A' + base - 10)
+            c = *s - 'A' + 10;
+        else
+            break;
+
+        if (is_signed) {
+            long long sacc = (long long)acc;
+            assert(!check_mul_overflow(sacc, base));
+            assert(!check_add_overflow(sacc * base, c));
+        } else {
+            assert(!check_mul_overflow(acc, base));
+            assert(!check_add_overflow(acc * base, c));
+        }
+
+        acc = acc * base + c;
+        s++;
+    }
+
+    if (neg)
+        acc = -acc;
+
+    if (endptr)
+        *endptr = (char *)s;
+
+    return acc;
+}
+
+long long int strtoll(const char *nptr, char **endptr, int base)
+{
+    return __strtoll(nptr, endptr, base, true);
+}
+
+unsigned long long int strtoull(const char *nptr, char **endptr, int base)
+{
+    return __strtoll(nptr, endptr, base, false);
+}
+
 long atol(const char *ptr)
 {
     return strtol(ptr, NULL, 10);
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



