Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859575B501
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 08:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfGAGX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 02:23:56 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:17002 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfGAGX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 02:23:56 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 4D0E2E971D527331D1C4;
        Mon,  1 Jul 2019 14:23:54 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x616Mhjw061468;
        Mon, 1 Jul 2019 14:22:43 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070114224554-1995714 ;
          Mon, 1 Jul 2019 14:22:45 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH 2/4] kvm: x86: allow set apic and ioapic debug dynamically
Date:   Mon, 1 Jul 2019 14:21:09 +0800
Message-Id: <1561962071-25974-3-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-01 14:22:45,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-01 14:22:44,
        Serialize complete at 2019-07-01 14:22:44
X-MAIL: mse-fl2.zte.com.cn x616Mhjw061468
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two *_debug() macros in kvm apic source file:
- ioapic_debug, which is disable using #if 0
- apic_debug, which is commented

Maybe it's better to control these two macros using CONFIG_KVM_DEBUG,
which can be set in make menuconfig.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/ioapic.c | 2 +-
 arch/x86/kvm/lapic.c  | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 1add1bc..8099253 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -45,7 +45,7 @@
 #include "lapic.h"
 #include "irq.h"
 
-#if 0
+#ifdef CONFIG_KVM_DEBUG
 #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
 #else
 #define ioapic_debug(fmt, arg...)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4924f83..dfff5c6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,8 +54,11 @@
 #define PRIu64 "u"
 #define PRIo64 "o"
 
-/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
+#ifdef CONFIG_KVM_DEBUG
+#define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
+#else
 #define apic_debug(fmt, arg...) do {} while (0)
+#endif
 
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
-- 
1.8.3.1

