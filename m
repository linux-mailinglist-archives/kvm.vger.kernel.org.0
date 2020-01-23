Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12F0146FB3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAWRaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 12:30:12 -0500
Received: from mout02.posteo.de ([185.67.36.66]:39953 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbgAWRaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 12:30:10 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 1BAB92400FE
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 18:30:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1579800608; bh=jswBLxzmjtwYk5Kuv4nAGpKgQNsVvBOU2fXHpQ4y5Gs=;
        h=From:To:Cc:Subject:Date:From;
        b=B/+QAD5PeIhk8ZzLMAIJLIf3n/rKfM3CU3W8F4FslYtVshYN8F+1kpTEn7+IrqA5G
         XJ05YHac7uYguFVgEP8OF8ksjX8QCn9s+VvzFPGRTqV8mQQ+bEpH2aM7QVXcEGdMYE
         YO/PZX68RhqNtZ9MZove5GVY2KaQinsMXLqFulaoewxct1IC3U5rRFUO9McT53dRN+
         IRSGC2FM/w5Pkgh7RVn0PHy4BwA0RB9dQcWRuKNGuZvVrZCA2NJZNscR8wH25TZKCJ
         LLCzB6WdzmxLOWK3LGRCEOr0+f89yBqt+rlmXnKhs9D/oI53YAznDfawUaqL4wmzKg
         30VhPiBrLuEEQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 483Tmv4HFFz9rxM;
        Thu, 23 Jan 2020 18:30:07 +0100 (CET)
From:   Benjamin Thiel <b.thiel@posteo.de>
To:     kvm@vger.kernel.org
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Benjamin Thiel <b.thiel@posteo.de>
Subject: [PATCH v2] x86/cpu: Move prototype for get_umwait_control_msr() to global location
Date:   Thu, 23 Jan 2020 18:29:45 +0100
Message-Id: <20200123172945.7235-1-b.thiel@posteo.de>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.. in order to fix a -Wmissing-prototype warning.

No functional change.

Signed-off-by: Benjamin Thiel <b.thiel@posteo.de>
---
 arch/x86/include/asm/mwait.h | 2 ++
 arch/x86/kernel/cpu/umwait.c | 1 +
 arch/x86/kvm/vmx/vmx.c       | 1 +
 arch/x86/kvm/vmx/vmx.h       | 2 --
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 9d5252c9685c..b809f117f3f4 100644
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
index c222f283b456..300e3fd5ade3 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 
 #include <asm/msr.h>
+#include <asm/mwait.h>
 
 #define UMWAIT_C02_ENABLE	0
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..11cd0242479b 100644
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
index a4f7f737c5d4..db947076bf68 100644
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
-- 
2.17.1

