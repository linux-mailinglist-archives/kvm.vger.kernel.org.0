Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8097615D8B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 08:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEGGfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 02:35:52 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:41708 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfEGGfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 02:35:52 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 2B8AFE1BE5E61E24B8E3;
        Tue,  7 May 2019 14:35:50 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x476ZbcW041399;
        Tue, 7 May 2019 14:35:37 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019050714354990-10077385 ;
          Tue, 7 May 2019 14:35:49 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wang.yi59@zte.com.cn
Subject: [PATCH] [next] KVM: lapic: allow setting apic debug dynamically
Date:   Tue, 7 May 2019 14:37:33 +0800
Message-Id: <1557211053-17275-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-05-07 14:35:49,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-05-07 14:35:32,
        Serialize complete at 2019-05-07 14:35:32
X-MAIL: mse-fl1.zte.com.cn x476ZbcW041399
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are many functions invoke apic_debug(), which is defined
as a null function by default, and that's incovenient for debuging
lapic.

This patch allows setting apic debug according to add a apic_dbg
parameter of kvm.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9bf70cf..4d8f10f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,8 +54,13 @@
 #define PRIu64 "u"
 #define PRIo64 "o"
 
+static int apic_dbg;
+module_param(apic_dbg, bool, 0644);
+
 /* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
-#define apic_debug(fmt, arg...) do {} while (0)
+#define apic_debug(fmt, arg...) do {  if (apic_dbg)   \
+	printk(KERN_DEBUG fmt, ##arg);    \
+} while (0)
 
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
-- 
1.8.3.1

