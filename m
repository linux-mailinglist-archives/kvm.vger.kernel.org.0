Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB14645D2C2
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347359AbhKYCDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353044AbhKYCBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD668C0619DF
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:39 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so3903844pjb.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CYYbYIUgNxlxD5T2pM27zWETe1m3WAzfa5GcKN+GXRY=;
        b=r/GVFU7zRAEsvvWFlT1Pzo9rzHBQs9MOeueJWYg0iVMoN1zVvYyEjiwg04Iygzbb8x
         1Smndi53Z0UTGkmL/PxYXyXnvLyMeGFTiGyoMyfEc/QEAtfMhfan+YeIivO3nlUetSSR
         LuouFYsQgagtG3s0zC9tgc/p2HQFbgFiKspmtsQt7BRMg/YuJOzD670+PvzgbC6y4E8J
         GHNMeThwLUbIWeWqNoOpbWWIBmoEOTLZBx57IPU/t0Ga4yfsDZ3N7M3HMB1oTQTtL7V6
         IfNHUWHX/6cBotCN/P0dc/AMeXpJ7rh78Wzq0Lr49eylb4jmA36pt/BBuy0U8a+VWClR
         tzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CYYbYIUgNxlxD5T2pM27zWETe1m3WAzfa5GcKN+GXRY=;
        b=pu++7JEobwlv/D9hn54gFgNSnRv6+qJ0DOaIfXm+pOze2YcfR2X0SxJsMaW1mI3gpr
         0JCtqiUyJw1iLzTW2EK2C382/gUO8XbUrXxWi/ciWf4kk2rkWQu7pAgew7/hZcZtrdze
         niBzdRkSLP/HaZHSKoyMIC4lFQ6eLOaDkJ6ouGX7G2b9wXBTqNMa02k4ktMtcXNmMq5U
         K2AN83//exreXtmJPSIs5M5FCj9OOuSrH1E5oRttaytZCZZTdycV/gnPEQOvBKtkcDMS
         v8xJxxjNh0WRPUbgWnp9J2tyqzhdIEKJbZ7ntUpZhiK8qin8aNqrBSyOX1YxWjrDEp9C
         Og3g==
X-Gm-Message-State: AOAM532ePRkDBUn7jwYt8iJB37COFkvnR+Rda/d0N/3PWsfjCxzEc9SE
        dLg+QdYU59r7VdO82RQOx3ividO4QP4=
X-Google-Smtp-Source: ABdhPJz43DnwLm6rbRytXHuREBeB4+ekz/gPyr4kUPZGy/FhpNiPLzfpGKeEP/QgoDt7BeNpdo/eKFENuig=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr626236pjb.0.1637803779100; Wed, 24 Nov 2021 17:29:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:42 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 24/39] nVMX: Assert success in unchecked
 INVEPT/INVVPID helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert if INVEPT or INVVPID fails instead of silently ignoring potential
problems and hoping they'll show up later.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 26 ++++++++++++++++++--------
 x86/vmx_tests.c |  6 +++---
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 47b0461..28e28f1 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -912,28 +912,38 @@ static inline int vmcs_save(struct vmcs **vmcs)
 	return ret;
 }
 
-static inline bool invept(unsigned long type, u64 eptp)
+static inline int __invept(unsigned long type, u64 eptp)
 {
-	bool ret;
+	bool failed = false;
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
 
 	struct {
 		u64 eptp, gpa;
 	} operand = {eptp, 0};
 	asm volatile("push %1; popf; invept %2, %3; setbe %0"
-		     : "=q" (ret) : "r" (rflags), "m"(operand),"r"(type) : "cc");
-	return ret;
+		     : "=q" (failed) : "r" (rflags), "m"(operand),"r"(type) : "cc");
+	return failed ? -1: 0;
 }
 
-static inline bool invvpid(unsigned long type, u64 vpid, u64 gla)
+static inline void invept(unsigned long type, u64 eptp)
 {
-	bool ret;
+	__TEST_ASSERT(!__invept(type, eptp));
+}
+
+static inline int __invvpid(unsigned long type, u64 vpid, u64 gla)
+{
+	bool failed = false;
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
 
 	struct invvpid_operand operand = {vpid, gla};
 	asm volatile("push %1; popf; invvpid %2, %3; setbe %0"
-		     : "=q" (ret) : "r" (rflags), "m"(operand),"r"(type) : "cc");
-	return ret;
+		     : "=q" (failed) : "r" (rflags), "m"(operand),"r"(type) : "cc");
+	return failed ? -1: 0;
+}
+
+static inline void invvpid(unsigned long type, u64 vpid, u64 gla)
+{
+	__TEST_ASSERT(!__invvpid(type, vpid, gla));
 }
 
 void enable_vmx(void);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index cbf22e3..0df69ee 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1248,7 +1248,7 @@ static bool invept_test(int type, u64 eptp)
 	bool ret, supported;
 
 	supported = ept_vpid.val & (EPT_CAP_INVEPT_SINGLE >> INVEPT_SINGLE << type);
-	ret = invept(type, eptp);
+	ret = __invept(type, eptp);
 
 	if (ret == !supported)
 		return false;
@@ -1551,7 +1551,7 @@ static bool invvpid_test(int type, u16 vpid)
 
 	supported = ept_vpid.val &
 		(VPID_CAP_INVVPID_ADDR >> INVVPID_ADDR << type);
-	ret = invvpid(type, vpid, 0);
+	ret = __invvpid(type, vpid, 0);
 
 	if (ret == !supported)
 		return false;
@@ -3280,7 +3280,7 @@ static void try_invvpid(u64 type, u64 vpid, u64 gla)
 	 * that we can tell if it is updated by INVVPID.
 	 */
 	vmcs_read(~0);
-	rc = invvpid(type, vpid, gla);
+	rc = __invvpid(type, vpid, gla);
 	report(!rc == valid, "INVVPID type %ld VPID %lx GLA %lx %s", type,
 	       vpid, gla,
 	       valid ? "passes" : "fails");
-- 
2.34.0.rc2.393.gf8c9666880-goog

