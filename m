Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F345F53D461
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350359AbiFDBXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350121AbiFDBXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B42C136
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y66-20020a62ce45000000b0051bb4d19f5fso4430344pfg.18
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=swbJ6v8rwkX5ox5kjlWFOdrm0/u3IDwNIqI+0XE8E5g=;
        b=B9PrjQZmvSAIKXNjNRf8xJhmmpWYuAkjiNJPP3tniNIahD7Fx5tuhaXmQrjxz5Hfjy
         zbA+y8KJQeMywOyulpapLuKGR1XYX6RgQRoPZpd4CPVI3Hgbwe/5U0uNL7vM9mhoLd+A
         xJO+veeL/wsAJEqlLVLAL486xa3ESlHzzCHVJBH2m1RvUm4jP8H8Grz1GmzU8BXPsi4t
         bhZkZ5yjaikJaes+TiN4Tic5BBxUredQrxxZg065HBYm9LLn1bVhf15LgtImwU82myGK
         7iUGt9pIY2I6ISrmsR3CzaUkUl1oQExOrMhvRQoFBw3MkY/BiOQRGtI7n3C9egrDPziX
         gd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=swbJ6v8rwkX5ox5kjlWFOdrm0/u3IDwNIqI+0XE8E5g=;
        b=jdpcx++wGmG7LPFZjEyIKxYMAAmga+/XFjr3qYUnTbEGaRX63Rplzzn8pS9kGLmK98
         IQ2b4x/ct4iDCF5DAynxJd5Y1+obKB8VI7sJYGbQLTOdBNem3+O9Ou2kf602UTWprKjk
         gCCVCBvj1jxnZcJA07bWBQ9oEfHqWF1XoGmzoJN1PF7rBh/MvSyOGZxmU5pKZmhdHi4E
         /+Air56BnNJ8dqKGZXLnIUx1lI8fKukeS4UN+mCsuTc4fmZ6aOPkWbEnt5jNeOnKqiOn
         MyxwozcXxfzBJtd06ouJP9apoJDfRFsiNcGleIzLPQRsE9tuK8H+TwoLXCiofEJXOsOS
         E9WQ==
X-Gm-Message-State: AOAM533KvjeEpbfp+9TK0t7o/otHabEjAPYuXANDV5ZMhj7grjXnAivp
        utQOOsO5lPAcB/Q9EY7eXYoSapDHmeo=
X-Google-Smtp-Source: ABdhPJwrOcqIcOGwRZoGsX8a7YmmriJaRtGl/5Sedt42uYX8l7pqbbhcjlOXBG0LkIxCuDzXHxckiouR+PA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a8c:b0:1e2:f378:631d with SMTP id
 lp12-20020a17090b4a8c00b001e2f378631dmr13480171pjb.58.1654305718994; Fri, 03
 Jun 2022 18:21:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:49 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-34-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 33/42] KVM: selftests: Use this_cpu_has() in CR4/CPUID sync test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Use this_cpu_has() to query OSXSAVE from the L1 guest in the CR4=>CPUID
sync test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h       |  3 ---
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     | 14 ++------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index d79060f55307..db724670c895 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -158,9 +158,6 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_KVM_HC_MAP_GPA_RANGE	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 16)
 #define X86_FEATURE_KVM_MIGRATION_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 17)
 
-/* CPUID.1.ECX */
-#define CPUID_OSXSAVE		(1ul << 27)
-
 /* Page table bitfield declarations */
 #define PTE_PRESENT_MASK        BIT_ULL(0)
 #define PTE_WRITABLE_MASK       BIT_ULL(1)
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 092fedbe6f52..a310674b6974 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -21,19 +21,9 @@
 
 static inline bool cr4_cpuid_is_sync(void)
 {
-	int func, subfunc;
-	uint32_t eax, ebx, ecx, edx;
-	uint64_t cr4;
+	uint64_t cr4 = get_cr4();
 
-	func = 0x1;
-	subfunc = 0x0;
-	__asm__ __volatile__("cpuid"
-			     : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
-			     : "a"(func), "c"(subfunc));
-
-	cr4 = get_cr4();
-
-	return (!!(ecx & CPUID_OSXSAVE)) == (!!(cr4 & X86_CR4_OSXSAVE));
+	return (this_cpu_has(X86_FEATURE_OSXSAVE) == !!(cr4 & X86_CR4_OSXSAVE));
 }
 
 static void guest_code(void)
-- 
2.36.1.255.ge46751e96f-goog

