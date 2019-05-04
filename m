Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29313D9C
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 07:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfEEF6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 01:58:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36192 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEEF6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 01:58:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id cb4so805104plb.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 22:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nBaAaZbmRcdZVOUAKNjhL5fk7tl5aUZlBDobzpQRnpY=;
        b=C5XxHHYDWbRTkbnG9sf2ivuEXDMQiWiDiBl3yhU8brdPf1zdd7tlX8kFYXsZGHLRyS
         mmN2/eKSmGeaVHSpmyJvFUbLfUqMtaZJt87oyLm5LC9WUql6/OD1bGo7lfw2rb1yTaD+
         H/FgGg+o3kVrckGJd9QbNZrh7SJepl8pQCR3iKRjN29Nj5pyrlidLgINiGdDaswm1v/z
         Uab/lELuuC1ThoKtjItRBBA936FR1ghVakVcQupQ+QxdZux1UuFkilRkdoatLxeHohbO
         VldTJpfo7p8V0+BO2Y/5CS01VOokSvd1R8h78O3q7L9PzNo7JESyDeqAQpcqT3AI8w34
         60TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nBaAaZbmRcdZVOUAKNjhL5fk7tl5aUZlBDobzpQRnpY=;
        b=rYpFA3s+q2d3FJvY3KYUBTr/uXhjwclAIUlVsNY7lfbQXJZIJbnmBo9I/p8+O+BZG3
         tn8qNRX7mGJzOV2KlHhoWw7mLXIyMJ2Y8a4M87IWtu7xyibWUS0CbSVxTUoRC4P5YAev
         aBgJp52P5cU+zl37stWIEW6bXRkCxO37pxTRWEGQ3a0x56xzaI4eEWABcOjOcE6EBPJT
         pnj2CcUOTdWcywETBhdpUGikXkoQa4WySrp5cmOpOtyLCmqSKp6UTAIQPIc0+hIjsOWu
         jaFXTYN8mdL65AWKdVCkve57GuL8LTxGaI5waa+FE9ryIZth77VV2oK1SPTEcbLv5O92
         5vFw==
X-Gm-Message-State: APjAAAUH0GCgD+Gis4RmBbX+XVNWbY2v/slfzf9vxZIhIVdmWozRMAhT
        7AvGEP1jkDq9Hb3Z4+oQlHS8yi+bBXA=
X-Google-Smtp-Source: APXvYqwcYEFuKxOoNuVJpHPpkulchUWcuwaq+jWaW5eugHt0xSArRC759A8u3ESAuB06j6OXo9WOfQ==
X-Received: by 2002:a17:902:2cc1:: with SMTP id n59mr23561549plb.22.1557035890171;
        Sat, 04 May 2019 22:58:10 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id f5sm7474018pgo.75.2019.05.04.22.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 22:58:09 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [kvm-unit-tests PATCH v3] x86: Incorporate timestamp in delay() and call the latter in io_delay()
Date:   Sat,  4 May 2019 15:36:18 -0700
Message-Id: <20190504223618.26742-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no guarantee that a self-IPI would be delivered immediately.
In eventinj, io_delay() is called after self-IPI is generated but does
nothing.

In general, there is mess in regard to delay() and io_delay(). There are
two definitions of delay() and they do not really look on the timestamp
counter and instead count invocations of "pause" (or even "nop"), which
might be different on different CPUs/setups, for example due to
different pause-loop-exiting configurations.

To address these issues change io_delay() to really do a delay, based on
timestamp counter, and move common functions into delay.[hc].

Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/delay.c | 9 ++++++---
 lib/x86/delay.h | 7 +++++++
 x86/eventinj.c  | 5 +----
 x86/ioapic.c    | 8 +-------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/lib/x86/delay.c b/lib/x86/delay.c
index 595ad24..e7d2717 100644
--- a/lib/x86/delay.c
+++ b/lib/x86/delay.c
@@ -1,8 +1,11 @@
 #include "delay.h"
+#include "processor.h"
 
 void delay(u64 count)
 {
-	while (count--)
-		asm volatile("pause");
-}
+	u64 start = rdtsc();
 
+	do {
+		pause();
+	} while (rdtsc() - start < count);
+}
diff --git a/lib/x86/delay.h b/lib/x86/delay.h
index a9bf894..a51eb34 100644
--- a/lib/x86/delay.h
+++ b/lib/x86/delay.h
@@ -3,6 +3,13 @@
 
 #include "libcflat.h"
 
+#define IPI_DELAY 1000000
+
 void delay(u64 count);
 
+static inline void io_delay(void)
+{
+	delay(IPI_DELAY);
+}
+
 #endif
diff --git a/x86/eventinj.c b/x86/eventinj.c
index d2dfc40..901b9db 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -7,6 +7,7 @@
 #include "apic-defs.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
+#include "delay.h"
 
 #ifdef __x86_64__
 #  define R "r"
@@ -16,10 +17,6 @@
 
 void do_pf_tss(void);
 
-static inline void io_delay(void)
-{
-}
-
 static void apic_self_ipi(u8 v)
 {
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
diff --git a/x86/ioapic.c b/x86/ioapic.c
index 2ac4ac6..c32dabd 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -4,6 +4,7 @@
 #include "smp.h"
 #include "desc.h"
 #include "isr.h"
+#include "delay.h"
 
 static void toggle_irq_line(unsigned line)
 {
@@ -165,13 +166,6 @@ static void test_ioapic_level_tmr(bool expected_tmr_before)
 	       expected_tmr_before ? "true" : "false");
 }
 
-#define IPI_DELAY 1000000
-
-static void delay(int count)
-{
-	while(count--) asm("");
-}
-
 static void toggle_irq_line_0x0e(void *data)
 {
 	irq_disable();
-- 
2.17.1

