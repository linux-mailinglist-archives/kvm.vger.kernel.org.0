Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE09D4E18
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 09:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfJLHpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 03:45:01 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43217 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJLHpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 03:45:00 -0400
Received: by mail-pg1-f202.google.com with SMTP id 6so8576110pgi.10
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 00:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WmdqpqGfkHn4HPcnbsc3aPPkFBnc3wfZ29QxdaymD6w=;
        b=nwK2aSbtoqORtQUaZTLKj/N7XBRh/Tee1SjTjrgicpibjHL/sA3aN8BNQW060Xu9Dw
         H5hoPRt7QNnEiuBDJ/IM0qHla/3Lc5WZIlxzN/yWm70BX0cUhjMumZv6M43fqcFXwDIH
         kdPmNA3ZHAJTAO78J0YbZlbRFmlmDcJ6MTspHNfabQVRFCHqxuHiGa+sU4WKtpr4CAdS
         F7iYVhOHpbA6LnhrnWNFfnNiD6QMjwA5c9yxH8HmxNtnHkqRzD5E+GcbiTFmOi6GGoWB
         +N6K3Q+kJww2QkphfpBHqHGn2/glEKCXOMUwePWCuebXv9r9KQVoILh9ZWk5Oea9kwy4
         Mrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WmdqpqGfkHn4HPcnbsc3aPPkFBnc3wfZ29QxdaymD6w=;
        b=dZU+dFOD06IgZdnsYJf9eo3BgwhMgUr1PmhmYE7fqHoF0cwY2xnOpUF7pU2xUvhbLc
         RBBiMzvO3MfZkikEGEaN8G7jWZSr0hs5e6PUlIyJYw7Yn/m14p+JPqgNbe8c5ZmRqBD1
         o/GDNjLUhh+Lk4+AwMSwUVggGudQc0IssCmIb2IUGiQamgsq6zoSz8V4UJ+F3evHvgMQ
         nEiUDA+YKRifEGJa2Be4wfCknQJRk6ZyEQtuxlqZsw84QLtwC63B/zTkqcPettOosm3L
         mK+Te2mbc19ZF4awwhjw8RFDPc7Jz5K/Ql+jpuCDjKOIJz05xy/cIlZ8PBWa89I/KEoR
         LhlQ==
X-Gm-Message-State: APjAAAVWoVD9zj4oxUIZYcR8K/sF+U4nz/owpLoPdmpFi6uF9+Sa5/ZR
        Zh3+TLmfVA/fi0JbE3BCeaSUtei790SsmPVXV8zw0g0hOzgGy9Oytk4ucco0zzRm+EdP8LGSQKP
        L/231i30a10Ufv6rZj6Pls+UIckasYytMB2jRw2tVnaA7TdfIhRQ0Gw==
X-Google-Smtp-Source: APXvYqxGA7vqboZv8LTKMJ/xrapYf/RkHLED3rrKm5GU+GC1TlCDQgppBsJg1KZqirPrQFUXV99T8Yk4VA==
X-Received: by 2002:a63:2484:: with SMTP id k126mr20840500pgk.331.1570866298519;
 Sat, 12 Oct 2019 00:44:58 -0700 (PDT)
Date:   Sat, 12 Oct 2019 00:44:53 -0700
Message-Id: <20191012074454.208377-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some values passed into "report" as "pass/fail" are larger than the
size of the parameter. Instead use a status enum so that the size of the
argument no longer matters.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/libcflat.h | 13 +++++++++++--
 lib/report.c   | 24 ++++++++++++------------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b6635d9..8f80a1c 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 extern int vprintf(const char *fmt, va_list va)
 					__attribute__((format(printf, 1, 0)));
 
+enum status { PASSED, FAILED };
+
+#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
+
+#define report(msg_fmt, status, ...) \
+	report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
+#define report_xfail(msg_fmt, xfail, status, ...) \
+	report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
+
 void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, unsigned pass, ...)
+extern void report_status(const char *msg_fmt, unsigned pass, ...)
 					__attribute__((format(printf, 1, 3)));
-extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+extern void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
 					__attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)))
diff --git a/lib/report.c b/lib/report.c
index 2a5f549..4ba2ac0 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -80,12 +80,12 @@ void report_prefix_pop(void)
 	spin_unlock(&lock);
 }
 
-static void va_report(const char *msg_fmt,
-		bool pass, bool xfail, bool skip, va_list va)
+static void va_report(const char *msg_fmt, enum status status, bool xfail,
+               bool skip, va_list va)
 {
 	const char *prefix = skip ? "SKIP"
-				  : xfail ? (pass ? "XPASS" : "XFAIL")
-					  : (pass ? "PASS"  : "FAIL");
+				  : xfail ? (status == PASSED ? "XPASS" : "XFAIL")
+					  : (status == PASSED ? "PASS"  : "FAIL");
 
 	spin_lock(&lock);
 
@@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
 	puts("\n");
 	if (skip)
 		skipped++;
-	else if (xfail && !pass)
+	else if (xfail && status == FAILED)
 		xfailures++;
-	else if (xfail || !pass)
+	else if (xfail || status == FAILED)
 		failures++;
 
 	spin_unlock(&lock);
 }
 
-void report(const char *msg_fmt, unsigned pass, ...)
+void report_status(const char *msg_fmt, enum status status, ...)
 {
 	va_list va;
-	va_start(va, pass);
-	va_report(msg_fmt, pass, false, false, va);
+	va_start(va, status);
+	va_report(msg_fmt, status, false, false, va);
 	va_end(va);
 }
 
-void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
 {
 	va_list va;
-	va_start(va, pass);
-	va_report(msg_fmt, pass, xfail, false, va);
+	va_start(va, status);
+	va_report(msg_fmt, status, xfail, false, va);
 	va_end(va);
 }
 
-- 
2.23.0.700.g56cf767bdb-goog

