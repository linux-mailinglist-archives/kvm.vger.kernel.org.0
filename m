Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5531619D0
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 19:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgBQSio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 13:38:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34317 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbgBQSio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 13:38:44 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j3lHz-0005C0-7x; Mon, 17 Feb 2020 19:38:39 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id CC90D1C20B4;
        Mon, 17 Feb 2020 19:38:38 +0100 (CET)
Date:   Mon, 17 Feb 2020 18:38:38 -0000
From:   "tip-bot2 for Benjamin Thiel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/cleanups] x86/cpu: Move prototype for
 get_umwait_control_msr() to a global location
Cc:     Benjamin Thiel <b.thiel@posteo.de>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200123172945.7235-1-b.thiel@posteo.de>
References: <20200123172945.7235-1-b.thiel@posteo.de>
MIME-Version: 1.0
Message-ID: <158196471850.13786.2863222761853021206.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/cleanups branch of tip:

Commit-ID:     b10c307f6f314c068814d0e23c86f06d5d57004b
Gitweb:        https://git.kernel.org/tip/b10c307f6f314c068814d0e23c86f06d5d57004b
Author:        Benjamin Thiel <b.thiel@posteo.de>
AuthorDate:    Thu, 23 Jan 2020 18:29:45 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 17 Feb 2020 19:32:45 +01:00

x86/cpu: Move prototype for get_umwait_control_msr() to a global location

.. in order to fix a -Wmissing-prototypes warning.

No functional change.

Signed-off-by: Benjamin Thiel <b.thiel@posteo.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20200123172945.7235-1-b.thiel@posteo.de
---
 arch/x86/include/asm/mwait.h | 2 ++
 arch/x86/kernel/cpu/umwait.c | 1 +
 arch/x86/kvm/vmx/vmx.c       | 1 +
 arch/x86/kvm/vmx/vmx.h       | 2 --
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 9d5252c..b809f11 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -23,6 +23,8 @@
 #define MWAITX_MAX_LOOPS		((u32)-1)
 #define MWAITX_DISABLE_CSTATES		0xf0
 
+u32 get_umwait_control_msr(void);
+
 static inline void __monitor(const void *eax, unsigned long ecx,
 			     unsigned long edx)
 {
diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index c222f28..300e3fd 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 
 #include <asm/msr.h>
+#include <asm/mwait.h>
 
 #define UMWAIT_C02_ENABLE	0
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a66648..2068cda 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -41,6 +41,7 @@
 #include <asm/mce.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
+#include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3..b4e14ed 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,8 +14,6 @@
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
 
-extern u32 get_umwait_control_msr(void);
-
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3
