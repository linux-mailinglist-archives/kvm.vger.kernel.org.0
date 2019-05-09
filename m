Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DDA1887F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 12:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfEIKrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 06:47:08 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:44464 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfEIKrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 06:47:07 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 12BAC9BBD87513C55F72;
        Thu,  9 May 2019 18:47:03 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x49AktYE044383;
        Thu, 9 May 2019 18:46:55 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019050918471900-10203318 ;
          Thu, 9 May 2019 18:47:19 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wang.yi59@zte.com.cn
Subject: [PATCH v2] [next] KVM: lapic: allow set apic debug dynamically
Date:   Thu, 9 May 2019 18:47:57 +0800
Message-Id: <1557398877-32750-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-05-09 18:47:19,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-05-09 18:46:41,
        Serialize complete at 2019-05-09 18:46:41
X-MAIL: mse-fl1.zte.com.cn x49AktYE044383
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are many functions invoke apic_debug(), which is defined
a null function by default, and that's incovenient for debuging
lapic.

This patch allows setting apic debug according to add a apic_dbg
parameter of kvm.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
v2: change apic_dbg to bool and tag __read_mostly. Thanks to Sean.

 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9bf70cf..0827e7c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,8 +54,13 @@
 #define PRIu64 "u"
 #define PRIo64 "o"
 
+static bool apic_dbg __read_mostly;
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

