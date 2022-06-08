Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F0544028
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiFHXvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiFHXvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41E5179966
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:55 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b0016363cdfe84so11832997plq.10
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b2R9sHjGKhjUJZC4UkF0gaXtOJaWeClk0e6Lj2UDITk=;
        b=NH2P+ml9Itqsr95pb7xg4iSdmzM53aFEgjKsaTKxp2ruIL51/vU+yGf+pKmrWD09L2
         PPghMhh3yMhDNxxLxDzxBAxFu6syBrgpFbnjVmABCq2VcdQEsLebkYYQFNJ5iZqFWjHR
         KgYrHwrhW52A531eoBhGaxpc9GFwF4cH/DKxTAsvwz9nJjhK0Omz6CivUtb8uywlE0Ok
         Uc1s/tqJ8McSgwQmgt+kygDNe/BaULx9JJ5+JW4RsRkRCCJ9Mwzas2YsQJKXHHXx3Nwl
         IXbPvhmQoIodJKJ8stuBY/7NxeXxLBjZCX9z1fduxcpOrdulKDKVwGAuSrZERk8Nwc6E
         uRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b2R9sHjGKhjUJZC4UkF0gaXtOJaWeClk0e6Lj2UDITk=;
        b=x6SVH6YYucTW9vBcBRFHBZkFHdHqMpLUTaUrFmEwUfLqwz+Xzn7jaJAbAFDIAgE3SM
         vns+/zcNz5oiBFT5IK/VoczFL813670j78aurR6JJwl5lO2uN7G8TBKDHptWiSgL9+gQ
         +VLdXCwK/S5TmwoRtm6mzOwbaL+cybuiKBFBIIt1J9VZ35+QrnZlJogwCiFFT8xa4+fw
         2/D1Yyobs57yJdC9w1MoP8mbmroTy/4wl1jDQ8D2zActqsJAq9IP+TgJg2hzzkdSLgad
         d5gVNSOvKYn2sFKXtu3OlhQ7hGNMDL5JVHV02aW6owQ/5yIpI9c+mKzN5dTzt1toTAg0
         J+SA==
X-Gm-Message-State: AOAM531lGC9IIDqtQvJMTzUNx8lYHKBpgn5ulnUYMEhGCUMnS0L0JY/L
        yVjS2v608VXTZ1YC0ZkS133x/I1DuZQ=
X-Google-Smtp-Source: ABdhPJxsC8ZhouQzRlz5TR9kpy9xezYKYmX/xB6WiQ6DoUCg1X1hu8PO4l9aZPDRTgD9lrYmBC3DAuegPcA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:179b:b0:51b:f51f:992e with SMTP id
 s27-20020a056a00179b00b0051bf51f992emr24904599pfg.60.1654732375181; Wed, 08
 Jun 2022 16:52:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:36 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 08/10] nVMX: Wrap VMXON in ASM_TRY(), a.k.a. in
 exception fixup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gracefully handle and return faults on VMXON instead of letting VMXON
explode.  The primary motivation is to be able to reuse the helper in
tests that verify VMXON faults when it's supposed to, but printing a nice
error message on fault is also nice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c       | 20 ++++++++++----------
 x86/vmx.h       | 29 +++++++++++++++++++++++------
 x86/vmx_tests.c |  6 +++---
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 8475bf3b..09e54332 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1461,34 +1461,34 @@ static int test_vmxon(void)
 
 	/* Unaligned page access */
 	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region + 1);
-	ret1 = _vmx_on(vmxon_region);
-	report(ret1, "test vmxon with unaligned vmxon region");
-	if (!ret1) {
+	ret1 = __vmxon_safe(vmxon_region);
+	report(ret1 < 0, "test vmxon with unaligned vmxon region");
+	if (ret1 >= 0) {
 		ret = 1;
 		goto out;
 	}
 
 	/* gpa bits beyond physical address width are set*/
 	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region | ((u64)1 << (width+1)));
-	ret1 = _vmx_on(vmxon_region);
-	report(ret1, "test vmxon with bits set beyond physical address width");
-	if (!ret1) {
+	ret1 = __vmxon_safe(vmxon_region);
+	report(ret1 < 0, "test vmxon with bits set beyond physical address width");
+	if (ret1 >= 0) {
 		ret = 1;
 		goto out;
 	}
 
 	/* invalid revision identifier */
 	*bsp_vmxon_region = 0xba9da9;
-	ret1 = vmx_on();
-	report(ret1, "test vmxon with invalid revision identifier");
-	if (!ret1) {
+	ret1 = vmxon_safe();
+	report(ret1 < 0, "test vmxon with invalid revision identifier");
+	if (ret1 >= 0) {
 		ret = 1;
 		goto out;
 	}
 
 	/* and finally a valid region */
 	*bsp_vmxon_region = basic.revision;
-	ret = vmx_on();
+	ret = vmxon_safe();
 	report(!ret, "test vmxon with valid vmxon region");
 
 out:
diff --git a/x86/vmx.h b/x86/vmx.h
index 7cd02410..604c78f6 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -870,18 +870,35 @@ void vmx_set_test_stage(u32 s);
 u32 vmx_get_test_stage(void);
 void vmx_inc_test_stage(void);
 
-static int _vmx_on(u64 *vmxon_region)
+/* -1 on VM-Fail, 0 on success, >1 on fault */
+static int __vmxon_safe(u64 *vmxon_region)
 {
-	bool ret;
+	bool vmfail;
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
-	asm volatile ("push %1; popf; vmxon %2; setbe %0\n\t"
-		      : "=q" (ret) : "q" (rflags), "m" (vmxon_region) : "cc");
-	return ret;
+
+	asm volatile ("push %1\n\t"
+		      "popf\n\t"
+		      ASM_TRY("1f") "vmxon %2\n\t"
+		      "setbe %0\n\t"
+		      "jmp 2f\n\t"
+		      "1: movb $0, %0\n\t"
+		      "2:\n\t"
+		      : "=q" (vmfail) : "q" (rflags), "m" (vmxon_region) : "cc");
+
+	if (vmfail)
+		return -1;
+
+	return exception_vector();
+}
+
+static int vmxon_safe(void)
+{
+	return __vmxon_safe(bsp_vmxon_region);
 }
 
 static int vmx_on(void)
 {
-	return _vmx_on(bsp_vmxon_region);
+	return vmxon_safe();
 }
 
 static int vmx_off(void)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4c963b96..60762285 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9695,7 +9695,7 @@ static void init_signal_test_thread(void *data)
 	u64 *ap_vmxon_region = alloc_page();
 	enable_vmx();
 	init_vmx(ap_vmxon_region);
-	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
+	TEST_ASSERT(!__vmxon_safe(ap_vmxon_region));
 
 	/* Signal CPU have entered VMX operation */
 	vmx_set_test_stage(1);
@@ -9743,7 +9743,7 @@ static void init_signal_test_thread(void *data)
 	while (vmx_get_test_stage() != 8)
 		;
 	/* Enter VMX operation (i.e. exec VMXON) */
-	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
+	TEST_ASSERT(!__vmxon_safe(ap_vmxon_region));
 	/* Signal to BSP we are in VMX operation */
 	vmx_set_test_stage(9);
 
@@ -9920,7 +9920,7 @@ static void sipi_test_ap_thread(void *data)
 	ap_vmxon_region = alloc_page();
 	enable_vmx();
 	init_vmx(ap_vmxon_region);
-	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
+	TEST_ASSERT(!__vmxon_safe(ap_vmxon_region));
 	init_vmcs(&ap_vmcs);
 	make_vmcs_current(ap_vmcs);
 
-- 
2.36.1.255.ge46751e96f-goog

