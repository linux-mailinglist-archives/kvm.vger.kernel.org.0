Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE68054BB82
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357372AbiFNUI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357300AbiFNUIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185744D9E1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x19-20020aa78f13000000b0051bdda60a06so4240183pfr.2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oGoInidDHUgzKInjiMzYTC4+hLGUBWpt78EcTlPSheA=;
        b=IWSBcmGtUu2yFATqX0U7jHGVdD1p/n2dDsQ+yvmCv87YVaEbIN1OuFmeSSu0oFY7LS
         L+cQ6/1STlUQl10EFzKOd5O7CoN3OVe9JBnr0Pzz2DAE73V4Z80kSpHagbaQL7ZTQMEy
         MIvw8zJXcCBeSIan6JK14ITPVFuTkcUkDKjhF8yXGAjYNEq6tCTDBt4lRH4C/Q48WchQ
         sVGGoBb2SltoUrDSLm+aSrC0q4K30KCX4X1sbLkTCsHuD7p1Gje+XjcF91sRm86FG25B
         yzbMF1w/HV69cl5+PBBWnheKL5t2aKRpUmFqMu2/CE2QJlMXNr8W/5Ep2tiYQjcHVwlu
         kHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oGoInidDHUgzKInjiMzYTC4+hLGUBWpt78EcTlPSheA=;
        b=Sf/GIv/9pqCiHufImOjKydU8b/o0B4nOjI0hjVKhWnGLlVJdXwCtNJXza3aZJwvghM
         cpND/Y1rLsDg7g3kAjKEVKQzHLxJqjAoGFqQ1H495mD4CyAfZKAQTjqoS6+9hVkCPimt
         V82VWe7EXnPnlESrw9gkVbaoZUoKprln45HZHOtbtOZa1NQzYqYVtVzpLCYp8M4u5kjw
         G4QoLnF3oAO260tk+t1fjVsRxD8Mti0xQu4e3KqNUqj2VpfG9kNd/lNyLbEbQYhnCcew
         SIiuy3V8EEdwkN7XUOV4GTE28VoPRiKKhJP2EBRbkS6uEg02qP3XR/Hw0scQK2Bm4DLz
         mOjg==
X-Gm-Message-State: AOAM533hLc7GGmpgvPQDjUOQsyWA9POfut9a0/mOBRQf5DrkmKgVivbH
        kB2JAP2DIo7B3fr5wJ3tz9I24ThFl5I=
X-Google-Smtp-Source: AGRyM1v1PPmjWq4SV8HLSELMJXXYJac3kl+1yrRZDnFUB/3o7xEpKnF+O4UkofHRAhv1VUtRac09srOrZT0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:efc6:b0:167:8177:60a7 with SMTP id
 ja6-20020a170902efc600b00167817760a7mr5914061plb.110.1655237275404; Tue, 14
 Jun 2022 13:07:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:49 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-25-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 24/42] KVM: selftests: Add and use helper to set vCPU's
 CPUID maxphyaddr
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

Add a helper to set a vCPU's guest.MAXPHYADDR, and use it in the test
that verifies the emulator returns an error on an unknown instruction
when KVM emulates in response to an EPT violation with a GPA that is
legal in hardware but illegal with respect to the guest's MAXPHYADDR.

Add a helper even though there's only a single user at this time.  Before
its removal, mmu_role_test also stuffed guest.MAXPHYADDR, and the helper
provides a small amount of clarity.

More importantly, this eliminates a set_cpuid() user and an instance of
modifying kvm_get_supported_cpuid()'s static "cpuid".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c     |  8 ++++++++
 .../testing/selftests/kvm/x86_64/emulator_error_test.c | 10 +---------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 555e73f96982..2097822b4b98 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -656,6 +656,8 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
+void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
+
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5fd6563f23d1..cdc35dd765e7 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -762,6 +762,14 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
+void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
+{
+	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, 0x80000008);
+
+	entry->eax = (entry->eax & ~0xff) | maxphyaddr;
+	vcpu_set_cpuid(vcpu);
+}
+
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set)
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index bb410c359599..9d08ccdf6604 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -151,8 +151,6 @@ static uint64_t process_ucall(struct kvm_vcpu *vcpu)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t gpa, pte;
@@ -166,13 +164,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	cpuid = kvm_get_supported_cpuid();
-
-	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
-	entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
-	set_cpuid(cpuid, entry);
-
-	vcpu_init_cpuid(vcpu, cpuid);
+	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
-- 
2.36.1.476.g0c4daa206d-goog

