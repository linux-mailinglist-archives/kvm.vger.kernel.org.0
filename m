Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AD0133A0
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfECSe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 14:34:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42782 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECSe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 14:34:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id 13so2979005pfw.9
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 11:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5W+J6ncGgPXbSwPcvTfFQICDLvRUf5JmFteitZynUqs=;
        b=iBaHa27I1n9HoeTs75iDzRUxF5CyTzD3F7SJpAb0kjWCwDnsxRoU37Sr/mAZy5Krv5
         rDnrF2STC2Teyvqi+dxaYMI8HacwpAsM6zpFFotYJ7SvQkXqlPxCOhlBcPTSqOXR3iRT
         1ouO7get6MKyquPGxAWXBcoUhOkMJl5BiebF3xMf97mX1eGcmVzdpuzet8FBX5+sZ0w/
         eeAFSuSpDsi8WeaGxsctQrpj+Oz/zo2sNrqmSNZK/tuJhmxtrsv41gcPdep+iTqFd46N
         Sf2De+3UtykMJBb+xambkJNgjkpGeT3Jm7z42/xTmd9xyPDvTH0uG+ii57mByJ/OHWHI
         rRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5W+J6ncGgPXbSwPcvTfFQICDLvRUf5JmFteitZynUqs=;
        b=cqQoBGO2RHd1ZRHYhAoGmjkn6Jpmp+6lh4OrKvoYNlvZa1cCQ7Y2X7qhE8gIzU3dYo
         zhWUyKw+rQJ4sKVO+KrtigXZ8IXTVh/hcfhfaDy5ieZpBXkncDZGTStTckxcxpdiY6J6
         HkhfjffNaLmsS9GFNQuvHCZ7vsS/C1Zwt/p63Icz++U1cz1OIqveY4ZAV4Klj7Gd8Psh
         HXs+RL4p3n/nhVcJJ9QmmIN/x3SDpePGSsClfMWU+7P261B73T/dq/Ywz1pIY3deVCPV
         FbXRzmQr1KhSJ9QSdEjQErxeU/Uk/1PRDN+X5DMtt4L89rrfNBKxUHCOwephF83WOvak
         n7KQ==
X-Gm-Message-State: APjAAAWIHL5strki0k0FdVVQ1KZ4t6ckenokd+kDgwCG3Iwm5Iuja3B1
        nz9CcePoSvp3mRgxIWVKKD6g14qVkwI=
X-Google-Smtp-Source: APXvYqzIZa+lLP6wMXU+mj1ndzB0nfz8WCLHlLCqADBTLaDdjr6GT9VJSj/+gpdrMITLYkpI2OjZow==
X-Received: by 2002:a62:5994:: with SMTP id k20mr12884273pfj.150.1556908498120;
        Fri, 03 May 2019 11:34:58 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h20sm6907389pfj.40.2019.05.03.11.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 11:34:57 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH v2] x86: Some cleanup of delay() and io_delay()
Date:   Fri,  3 May 2019 04:13:07 -0700
Message-Id: <20190503111307.10716-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

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

