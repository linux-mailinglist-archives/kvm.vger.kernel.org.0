Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8752F3B0F1B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFVVDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFVVDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:14 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A6CC061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:57 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b6-20020a05620a1266b02903b10c5cfa93so1371014qkl.13
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ep1uIwn5QmrQEMh0BtVDPzMtbSvWz3l8d9EGtBp/iDc=;
        b=LfQUQO92NITSA9DwKSXDfqpb7/ZFFM6n4Tu8U3zj+rLvVQEKRQ0D/LoOg/oTeeIED5
         dR5ThKvHmr6mYy44N5z7m4Ka+Agl6fijTK9T20ZEoWbWXK3PWulmBTRLtGQW7CATm2jU
         DwqKQkmLsiU3T72bSM71ywq0xm4koSP7SUHwJsU1BL0rP8er2gfIH9Zo5N0Sm7uoimJ+
         whe2sY4AmHLnWcCKO5UL9DH3raIctGOVIubBcdjIxqhfeJ9KBpk7QFx7+mA4HkuT8kN1
         kbfaFrtIaz54qfmpe0xqtXsVzDr8bDWgPW0WT8cMJr/VQEJrj1+vbyQEaEnTtA02V5Ym
         F7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ep1uIwn5QmrQEMh0BtVDPzMtbSvWz3l8d9EGtBp/iDc=;
        b=TJGIJix/62fuwecRQukZ6EA6c87mO9hj0UhZQRGIXAhqRy0PF3isOQjxDGRsglvFbY
         RHtGCXNJpkE+9EZsbdE4bnvJI78TetrOf0vBlKnBAzWXLxVlaUIMJLS5jU08AYlc2f13
         +dIXqPsdjoe9Zc0R4hqKvoYWAsACIEqCQ/aCUiAsBeVPBVhQtSxAJzIAX0TLDezpmUgv
         pR1Rc2hYsXo/jlrcrvHElt/uiT2+5VrY5FFv8rqdeukTPiUF5Okee+kvErgFHpzqeFV3
         XxPByoUh9Qh1hSEI2fxbKhvWh6HnEN3XaAm+OCGb4gdkQXJL1eYhh/mOpnPSY30j09Yo
         mxKQ==
X-Gm-Message-State: AOAM530LlfxH59xDfFqlbmZ/3GP/eB1apAtGRkX3N91XrwUYiHvSobmt
        tA37WNdS7UUmyRZs/OREtSMDbN7N2g8=
X-Google-Smtp-Source: ABdhPJxy5cPv2+EBjljA3Yau315dExAkgWxxN64seJE3tyFbxUrj0b24SLRQC9lyEyiSrBB6H26X7jK/BaM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:6dc5:: with SMTP id i188mr7897769ybc.420.1624395656840;
 Tue, 22 Jun 2021 14:00:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:38 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 03/12] nSVM: Reset the VMCB before every v1 test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh the VMCB before every v1 test to fix bugs where tests neglect to
initialize the VMCB and end up taking a dependency on previous tests,
e.g. looking at you mode_test and next_rip.  This will also allow tests
to modify VMCB fields without having to do their own manual save/restore.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c       |  2 ++
 x86/svm_tests.c | 13 -------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 9fbc0b2..6e5872d 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -250,6 +250,8 @@ static void test_run(struct svm_test *test)
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
 	irq_disable();
+	vmcb_ident(vmcb);
+
 	test->prepare(test);
 	guest_main = test->guest_func;
 	vmcb->save.rip = (ulong)test_thunk;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 4bfde2c..aa74cfe 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -667,7 +667,6 @@ static bool check_asid_zero(struct svm_test *test)
 
 static void sel_cr0_bug_prepare(struct svm_test *test)
 {
-    vmcb_ident(vmcb);
     vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
@@ -704,7 +703,6 @@ static void npt_nx_prepare(struct svm_test *test)
 
     u64 *pte;
 
-    vmcb_ident(vmcb);
     pte = npt_get_pte((u64)null_test);
 
     *pte |= PT64_NX_MASK;
@@ -727,7 +725,6 @@ static void npt_np_prepare(struct svm_test *test)
     u64 *pte;
 
     scratch_page = alloc_page();
-    vmcb_ident(vmcb);
     pte = npt_get_pte((u64)scratch_page);
 
     *pte &= ~1ULL;
@@ -753,7 +750,6 @@ static void npt_us_prepare(struct svm_test *test)
     u64 *pte;
 
     scratch_page = alloc_page();
-    vmcb_ident(vmcb);
     pte = npt_get_pte((u64)scratch_page);
 
     *pte &= ~(1ULL << 2);
@@ -780,7 +776,6 @@ static void npt_rsvd_prepare(struct svm_test *test)
 {
     u64 *pde;
 
-    vmcb_ident(vmcb);
     pde = npt_get_pde((u64) null_test);
 
     save_pde = *pde;
@@ -802,7 +797,6 @@ static void npt_rw_prepare(struct svm_test *test)
 
     u64 *pte;
 
-    vmcb_ident(vmcb);
     pte = npt_get_pte(0x80000);
 
     *pte &= ~(1ULL << 1);
@@ -830,7 +824,6 @@ static void npt_rw_pfwalk_prepare(struct svm_test *test)
 
     u64 *pte;
 
-    vmcb_ident(vmcb);
     pte = npt_get_pte(read_cr3());
 
     *pte &= ~(1ULL << 1);
@@ -850,7 +843,6 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
 {
     u64 *pdpe;
-    vmcb_ident(vmcb);
 
     pdpe = npt_get_pml4e();
     pdpe[0] |= (1ULL << 8);
@@ -867,7 +859,6 @@ static bool npt_rsvd_pfwalk_check(struct svm_test *test)
 
 static void npt_l1mmio_prepare(struct svm_test *test)
 {
-    vmcb_ident(vmcb);
 }
 
 u32 nested_apic_version1;
@@ -894,7 +885,6 @@ static void npt_rw_l1mmio_prepare(struct svm_test *test)
 
     u64 *pte;
 
-    vmcb_ident(vmcb);
     pte = npt_get_pte(0xfee00080);
 
     *pte &= ~(1ULL << 1);
@@ -1940,8 +1930,6 @@ static void init_startup_prepare(struct svm_test *test)
     struct segment_desc64 *tss_entry;
     int i;
 
-    vmcb_ident(vmcb);
-
     on_cpu(1, get_tss_entry, &tss_entry);
 
     orig_cpu_count = cpu_online_count;
@@ -1976,7 +1964,6 @@ static volatile bool init_intercept;
 static void init_intercept_prepare(struct svm_test *test)
 {
     init_intercept = false;
-    vmcb_ident(vmcb);
     vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
 }
 
-- 
2.32.0.288.g62a8d224e6-goog

