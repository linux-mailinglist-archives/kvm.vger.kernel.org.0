Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9770854BB41
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356985AbiFNUHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352449AbiFNUHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:36 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CD1BE16
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id nb10-20020a17090b35ca00b001eaa6b6c61dso3768822pjb.3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ix8LxbFMyT0f0KurACg7xFUB0b+m8p+ZiAchdE34/lk=;
        b=SOLoRrkUYs63+1Nm8A8481yZmKUKX/unwtnE3WCdTt//i6TjDOEdiHAFp1tydZQyHE
         BqCYWKW9pzqhMc+A9V1cLaGM6smcnmrs55VoVJpSsnPJGLnEMX8sKdhqGSfTNMZXw2F4
         PVx/upckfItAzOLe/70klXtzXWmhMDz1HLwvZsM553CH7aVnDrNrSvDm1Tuggv3bPabc
         ZDy70wx/nGvVz4bUZQPdL7K/A1uhDlmje6umIU3FhlLpildyMFzri/BvP+YvQXiJH5tP
         nhE9xJ0xPJxj4b9Qss5F+Y70QaOsgviTFOl5vQAIAWOlinTY9AMe2fmlVPc5DKVSfNAb
         lpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ix8LxbFMyT0f0KurACg7xFUB0b+m8p+ZiAchdE34/lk=;
        b=E8HM6LjUL13UCvGqMOLV+J2oUZWUSGapH00V0ihrZg+kcUeY9T405pAIU9ZxvSIfPi
         L8t27q72KVuSkpd9rS4QtVJFEnnnIWrdaQv/n9lpOXF2Gf9fxJYraI6PiL8GUNhWLTvY
         URQO7FEFqW5Kghl7HQ729oiplDxSnLfsHXz8A7TXc3PmWS4ktgNCV4GlfBc9o1DeEITw
         XBAFDpxWdL2KaR6iq+Ks4jlG1jZBmfkZ4lctKiWN0E3hcn4UD67D4KvaKm7oZ+qm119Z
         rE+ibLBnv6NBlSz2teP2xSvbeznfAjL35eG7Do8Jo75Gj6YNqu1hKz3+CfWnqal0KHHw
         1Cgg==
X-Gm-Message-State: AJIora/a6yIpJPwhR+tQJi0tZ6a7k0ZLT9+iipT42Ipz8s5QBjRltHCo
        7QkFmx/MHBqxVDVBtibsAhS4pVa+6oA=
X-Google-Smtp-Source: AGRyM1uo0B5/l7IOGbrwE1pyFaa/TwYOxA8i4cDON+VwOIKn2m2Z1KgTc4TWuHq0YSIwD9XFnz1Yho+Dmgs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4503:b0:51b:de97:7f2c with SMTP id
 cw3-20020a056a00450300b0051bde977f2cmr5990382pfb.12.1655237249548; Tue, 14
 Jun 2022 13:07:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:34 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 09/42] KVM: selftests: Use kvm_cpu_has() for XSAVES in XSS
 MSR test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the XSS MSR test instead of open coding equivalent
functionality using kvm_get_supported_cpuid_index().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c      | 8 +-------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9fe2a9534686..2100eb08916a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -110,6 +110,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_SPEC_CTRL		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 26)
 #define	X86_FEATURE_ARCH_CAPABILITIES	KVM_X86_CPU_FEATURE(0x7, 0, EDX, 29)
 #define	X86_FEATURE_PKS			KVM_X86_CPU_FEATURE(0x7, 0, ECX, 31)
+#define	X86_FEATURE_XSAVES		KVM_X86_CPU_FEATURE(0xD, 1, EAX, 3)
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 4e2e08059b95..e0ddf47362e7 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -14,11 +14,8 @@
 
 #define MSR_BITS      64
 
-#define X86_FEATURE_XSAVES	(1<<3)
-
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry;
 	bool xss_in_msr_list;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -28,10 +25,7 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
-	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
-
-	entry = kvm_get_supported_cpuid_index(0xd, 1);
-	TEST_REQUIRE(entry->eax & X86_FEATURE_XSAVES);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVES));
 
 	xss_val = vcpu_get_msr(vcpu, MSR_IA32_XSS);
 	TEST_ASSERT(xss_val == 0,
-- 
2.36.1.476.g0c4daa206d-goog

