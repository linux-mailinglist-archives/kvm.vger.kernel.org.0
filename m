Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8AB4341B0
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJSW4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhJSW4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:56:07 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA94C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:53:54 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id l17-20020a05660227d100b005d6609eb90eso14393749ios.16
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v7meaSIba9u+Tv41QNKjKlrW1J3eV+swPVowkDP8eKo=;
        b=GwgMCdHxzOTmbE5ojZucnuabFbdaqtGAZkyuo+rsKzYjk4EtT3m6wn7ch4MfRYoGF5
         bSelm3HTHDwCfoQAewgL+KocRw7WlMvJfxcmDbN0pW1wL2qs+LtXcBl961OwV7U/f9AG
         WTTQ8Af0LUqjcCyNqdTqhjH41w1FutsBur++tBNUeGc9G5PUwdR07aZtj7RM1Qz8JzcQ
         kb/UBO3tq6ykd+vd07fOBT9uSAje0zTZNfgaMZ5rH1Ydw1vxgqK8vh+95P69ofvLAr4x
         wkoHy42JjbQikg8UNvmn7PDLewqD10lhbpSYxgQcn4FYWXxbNiki23N4Vn5rgZlGrjoO
         998w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=v7meaSIba9u+Tv41QNKjKlrW1J3eV+swPVowkDP8eKo=;
        b=ypiPsqSs11GqkOvyBIK4lTpg4lYRajpnvueWwZcaYp1bgvVDn1rE3hcOQlj/WBU/x6
         0tFSb2wtnP9vuqHwC8dDnVAc4ClGGp0z3BrA2CkoQoT+PWVlcJPH0G+5uMFXoarnp6Hr
         wdZDhwpiOjrtxf9fn8Rg61QdHHXM60rOg4geA0+x51eyvjLsi4zShX57SywLRnjphDMa
         Ji/8JXsn0tgrzJxRB+8SO1BooYRwyiaXVK1kRbTgIb58zRDfUuGgmz31MYEnX1DEnHUF
         8spE0wRlVHXb1Cl9LVX+3ByewxPSDzkGjzAZizAYwVj6o3uyLE2w/H1/t1ocPJtunuXV
         rfQA==
X-Gm-Message-State: AOAM5305IzwkTLG8R0cbEoGFDcLAJq31bw4ooFgYwz6gFhWxnIHzhRfZ
        W0X6gN99OGx1+yi2IYX1QtClDE9FulRm9Rq9fY8Nz/sZXAhlC9QXUoaadloih3EDWvH2sw1eIPj
        NcbGdYFazlXKcC1P5RSUCicWDh9geX72LI+ScxVljGcR4yycDqw6YfGyxcw==
X-Google-Smtp-Source: ABdhPJwgZn4A4BJidLhUsKshN1jNCddQupKVwDZMjigziBopnAfaR1ikytwqYIU6jZi4qjpo8+eByK5h1K0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a38e:: with SMTP id y14mr6283087jak.8.1634684033646;
 Tue, 19 Oct 2021 15:53:53 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:53:50 +0000
Message-Id: <20211019225351.970397-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: Consistently use safe_halt() in place
 of inline assembly
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The safe_halt() library function simply performs an 'sti; hlt'
instruction sequence. There are several places where bare inline
assembly was used instead of this helper. Replace all open-coded
implementations with the helper.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/svm_tests.c | 2 +-
 x86/vmexit.c    | 8 ++++----
 x86/vmx_tests.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3344e28..afdd359 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1302,7 +1302,7 @@ static void interrupt_test(struct svm_test *test)
     timer_fired = false;
     start = rdtsc();
     apic_write(APIC_TMICT, 1000000);
-    asm volatile ("sti; hlt");
+    safe_halt();
 
     report(rdtsc() - start > 10000 && timer_fired,
           "direct interrupt + hlt");
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 999babf..8cfb36b 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -103,7 +103,7 @@ static void self_ipi_sti_hlt(void)
 	x = 0;
 	irq_disable();
 	apic_self_ipi(IPI_TEST_VECTOR);
-	asm volatile("sti; hlt");
+	safe_halt();
 	if (x != 1) printf("%d", x);
 }
 
@@ -135,7 +135,7 @@ static void self_ipi_tpr_sti_hlt(void)
 	apic_set_tpr(0x0f);
 	apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
-	asm volatile("sti; hlt");
+	safe_halt();
 	if (x != 1) printf("%d", x);
 }
 
@@ -155,7 +155,7 @@ static void x2apic_self_ipi_sti_hlt(void)
 {
 	irq_disable();
 	x2apic_self_ipi(IPI_TEST_VECTOR);
-	asm volatile("sti; hlt");
+	safe_halt();
 }
 
 static void x2apic_self_ipi_tpr(void)
@@ -181,7 +181,7 @@ static void x2apic_self_ipi_tpr_sti_hlt(void)
 	apic_set_tpr(0x0f);
 	x2apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
-	asm volatile("sti; hlt");
+	safe_halt();
 }
 
 static void ipi(void)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3b97cfa..ac2b0b4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1674,7 +1674,7 @@ static void interrupt_main(void)
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	asm volatile ("sti; hlt");
+	safe_halt();
 
 	report(rdtsc() - start > 1000000 && timer_fired,
 	       "direct interrupt + hlt");
@@ -1686,7 +1686,7 @@ static void interrupt_main(void)
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	asm volatile ("sti; hlt");
+	safe_halt();
 
 	report(rdtsc() - start > 10000 && timer_fired,
 	       "intercepted interrupt + hlt");
-- 
2.33.0.1079.g6e70778dc9-goog

