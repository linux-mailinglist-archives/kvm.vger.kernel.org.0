Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD0727053
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbjFGVKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbjFGVKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05B0D1
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-568ae92e492so131447467b3.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172204; x=1688764204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kwoI54QcezUdtPGH+B3kTK9cn/G+XyWgh9otzTVHM6g=;
        b=IEW353KOSjOnR+DRz3XKoGyx4G0I6vR54WGb/64rnNVHL0XBF8TcM8oAYKCltFI10j
         cQlfnPKRm9N5q+XOKuCyp13pNM343f6hfsMsXsxcg7Gzh5Ylq0737Ps/06HjNz+/xnUY
         aMg91gHcENdXo1LGgkfjfJgr6yF4KcAv06eZJU8juZwKdlGxkkT5Qcj4nsTB4Q4QPlXH
         9DVu1r/sh4pkHHYHQmw7MxGdz0yBkiceHIHxQOBbt1hGsM1CiC/dgoi/I9bEZGtR6xSi
         SwcWfrGja1XRtfuqoxtbB47cwbT9AY6/PnxdUahW+dgEmbIMezVVf/mpIx1M5wzTGUhs
         hPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172204; x=1688764204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwoI54QcezUdtPGH+B3kTK9cn/G+XyWgh9otzTVHM6g=;
        b=D9TTOOtR036ss0COWw6gzeMaW1Rfpp/G6iskA4Sgd5D8xZdv6dEd4hY4SKmYqIXCRI
         ZV7PvaBm2XAyTTKBpXBSB2URuIZHaRVFT1/5Nc4FpoSilsI988rTH88ylk1LcqmguKmK
         hXED65i2nbnrsqolfmK72bqHIkwkuK12N93oUN9DfOfn9cEtIikK5Qs5pKnmaTNjiKCR
         lSrc9Qdasi0unKa/q9fwH71OKrC/o724faDJbJzJp6cpnoV4qGnwRz2oq7Rm5pcwJ9MR
         JRrmauB8r88tz0Fy7hNNbnRSeAHzuy1/DqwyT/aIS5t5S8b7pmY/JnbPrDz+tg1N+4At
         gnRQ==
X-Gm-Message-State: AC+VfDwB/Ed7AcMT6EaWM3hL5qRIdnNRnyxl3XQ3dxAbwOWV4To3SuE9
        +NDp5p2LIxwHXjpYfu7rj8C6jcTVT0I=
X-Google-Smtp-Source: ACHHUZ7Lkc+NTEQZs5QNVBrIJweAURD23w8nL2L6BSAb0JUumRF9XpBFRehRCTHnoy35AVRZ/RBOyZwDgQ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dbc1:0:b0:ba8:54dc:9d0 with SMTP id
 g184-20020a25dbc1000000b00ba854dc09d0mr2377689ybf.12.1686172203894; Wed, 07
 Jun 2023 14:10:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:54 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/6] x86: nSVM: Set up a guest stack in LBRV tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URIBL_SBL_A,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to configure save.rip and save.rsp, and use it in the LBRV
tests, which use a "bare" VMRUN to avoid branches around VMRUN.  This
fixes a bug where the LBRV tests explode in confusing ways if the
compiler generates guest code that touches the stack in *any* way.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c       | 7 ++++++-
 x86/svm.h       | 2 +-
 x86/svm_tests.c | 8 ++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index ba435b4a..c24cb97c 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -212,10 +212,15 @@ struct svm_test *v2_test;
 
 u64 guest_stack[10000];
 
-int __svm_vmrun(u64 rip)
+void svm_setup_vmrun(u64 rip)
 {
 	vmcb->save.rip = (ulong)rip;
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
+}
+
+int __svm_vmrun(u64 rip)
+{
+	svm_setup_vmrun(rip);
 	regs.rdi = (ulong)v2_test;
 
 	asm volatile (
diff --git a/x86/svm.h b/x86/svm.h
index 766ff7e3..4857212b 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -425,8 +425,8 @@ void inc_test_stage(struct svm_test *test);
 void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
+void svm_setup_vmrun(u64 rip);
 int __svm_vmrun(u64 rip);
-void __svm_bare_vmrun(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
 u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 27ce47b4..e20f6697 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2895,7 +2895,7 @@ static void svm_lbrv_test1(void)
 {
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
 	vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
@@ -2917,7 +2917,7 @@ static void svm_lbrv_test2(void)
 {
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
 	vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
@@ -2945,7 +2945,7 @@ static void svm_lbrv_nested_test1(void)
 	}
 
 	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
 
@@ -2978,7 +2978,7 @@ static void svm_lbrv_nested_test2(void)
 	}
 
 	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 
 	vmcb->save.dbgctl = 0;
-- 
2.41.0.162.gfafddb0af9-goog

