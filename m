Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21C146A82
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAWOBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:01:22 -0500
Received: from mout02.posteo.de ([185.67.36.66]:57195 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgAWOBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:01:20 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 096EE2400FE
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 15:01:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1579788077; bh=ZVtVWPk2nLjF6dSYv8YBCQyVws1d8uWihyfKP1Ac6VI=;
        h=From:To:Cc:Subject:Date:From;
        b=EyV02xAnENVfXhyv4Lhbtdbc/olaRO5FYvIkqCnWKpl/4uChQbKdPJwpQ986uX9m0
         6wLwTgXbJp+dpo5ZyG6OBhZW7yklu4U5ynvToY0PCa/zPyBvzJYzCrGJ4hTEjX64yL
         gn6d8680yoI0EVTEVK8hmVy7APo/RHLI5ohdMyuAbxtHrnggAdncYlHT3MkSXtUex4
         YRkSjTz9DeaGpVQJbs9AQMF894DtHWn93BXa1WMWlwq/9jGJvL4QoQgJb9+EHGomA4
         3zoHSly76K9sb9zpvHwD/CUGGW903PJZHgRMCqapLpFvI7S0nGvYx/so/1/x4fbt4Q
         A0qr4x0ZcMgKw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 483P7w5D0gz9rxS;
        Thu, 23 Jan 2020 15:01:16 +0100 (CET)
From:   Benjamin Thiel <b.thiel@posteo.de>
To:     X86 ML <x86@kernel.org>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>
Subject: [PATCH] x86/cpu: Move prototype for get_umwait_control_msr() to global location
Date:   Thu, 23 Jan 2020 15:01:13 +0100
Message-Id: <20200123140113.8447-1-b.thiel@posteo.de>
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
index 9d5252c9685c..83b296ffc85a 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -23,6 +23,8 @@
 #define MWAITX_MAX_LOOPS		((u32)-1)
 #define MWAITX_DISABLE_CSTATES		0xf0
 
+extern u32 get_umwait_control_msr(void);
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
index e3394c839dea..25ddfd3d6bb0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -44,6 +44,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/mwait.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
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

