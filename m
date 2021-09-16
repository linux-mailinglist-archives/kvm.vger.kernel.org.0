Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00CA40EA76
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbhIPS6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbhIPS5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:34 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A484CC04A161
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:06 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c27-20020a05620a165b00b003d3817c7c23so44679217qko.16
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BQXd3Nk8LB8EegwpdynLlvWKL/Dc9feqpx1d4DPqITg=;
        b=YbtLMWiwVDR1FwoRZkkH3agBSZD6yFHazXXArNyT0cxXrYta0wqypu1LN+cZSMM8NW
         jW7uPn5jW+QM5fp3xMG2CEU0Xs9YrQ5AMvvwrIj92KZqf2S79zNhY4JyUUuGfobpyINN
         daSQmUZITVjQ6Eq6eJwqhjvukYDoLsEKA+CFKX2wkSjVtB49CJLDiyVlsbmYbTo/Mmxq
         xizlfzC3fGmjwn1YiYKaklStfI0tKm4WeSbGKnbWu+gb4Btpo2ELxWp2OFy0xkO+5Om2
         mLxwXGIj4EcbOUjkuX6tVcwJ6QE2E43ckqQ1HS+svgBMni2yvdCV8ivbwuOElk7wJvZv
         8qIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BQXd3Nk8LB8EegwpdynLlvWKL/Dc9feqpx1d4DPqITg=;
        b=m3E0uvSdKTlvdx9rK2qBZn4CXukUuKXRT2IDuACbLtXA4n8LzichSPg5BqJ1x9S960
         UVRjXbQaj9szfRGAt3KCyEoq9vmOps0kY4OokCFBx0CFGoYbnvTxsDeuU8OAwo7kzVCB
         zJv2yXd4xdf7tDwMU88C+ND27C56myiKqumaC2QQU3fPJAUv8nsEVj/Q5BSeY069Fqj8
         LvCtVZvefae4Pd7eaaxWwQrMn1jvDH+8oeEj+9UgYsjofrDsyxdJ+/EsvoDJE06niAUX
         VLPL+yUjyV0KuNf/ffxBIwPSPzQhz7hMERTrHE4KIISbPh6NHVrX/0xCNRgnT9qy4T1C
         3cFA==
X-Gm-Message-State: AOAM532Ilw0WKPb8APVgADPQNHz37VrPQKniFMoXSdEt5398VMV4wI6d
        54AnC4pJV0VFBbLuYIRJdoneXfpwSF6cLGiYLBITRczn7eu2nps9npFLfXwb3AnmEMgEHdUDkUx
        9y0/RQfXGZ+0GjoQy74YyJD1H6lz02Y/H0zWP97+BmvRND3b4z9JYd52z3w==
X-Google-Smtp-Source: ABdhPJzCpZqCRtF7Y9hBqtO2vjOxdiXuQnImjvuqW2/v2+k/6ic5Q04lFEhj2CGgxRj2QOIjvU7Igaov4Wg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:44a:: with SMTP id
 cc10mr6940242qvb.58.1631816165810; Thu, 16 Sep 2021 11:16:05 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:53 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-8-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 7/9] selftests: KVM: Test physical counter offsetting
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that userspace adjustment of the guest physical counter-timer
results in the correct view within the guest.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
 .../kvm/system_counter_offset_test.c          | 34 ++++++++++++++++---
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 4c7472823df3..57b7802cf9e2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -144,4 +144,16 @@ static inline uint64_t read_cntvct_ordered(void)
 	return r;
 }
 
+static inline uint64_t read_cntpct_ordered(void)
+{
+	uint64_t r;
+
+	__asm__ __volatile__("isb\n\t"
+			     "mrs %0, cntpct_el0\n\t"
+			     "isb\n\t"
+			     : "=r"(r));
+
+	return r;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7ea406fdd56f..757b5b2e960e 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -57,6 +57,9 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 
 enum arch_counter {
 	VIRTUAL,
+	PHYSICAL,
+	/* offset physical, read virtual */
+	PHYSICAL_READ_VIRTUAL,
 };
 
 struct test_case {
@@ -68,6 +71,12 @@ static struct test_case test_cases[] = {
 	{ .counter = VIRTUAL, .offset = 0 },
 	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
 	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = 0 },
+	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 0 },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = -180 * NSEC_PER_SEC },
 };
 
 static void check_preconditions(struct kvm_vm *vm)
@@ -76,32 +85,49 @@ static void check_preconditions(struct kvm_vm *vm)
 		.cap = KVM_CAP_ARM_VTIMER_OFFSET,
 	};
 
-	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
-		return;
-
 	if (!kvm_check_cap(KVM_CAP_ARM_VTIMER_OFFSET)) {
 		print_skip("KVM_REG_ARM_TIMER_OFFSET not supported");
 		exit(KSFT_SKIP);
 	}
 
 	vm_enable_cap(vm, &cap);
+
+	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				  KVM_ARM_VCPU_TIMER_PHYS_OFFSET)) {
+		print_skip("KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported");
+		exit(KSFT_SKIP);
+	}
 }
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
+	uint64_t cntvoff, cntpoff;
 	struct kvm_one_reg reg = {
 		.id = KVM_REG_ARM_TIMER_OFFSET,
-		.addr = (__u64)&test->offset,
+		.addr = (__u64)&cntvoff,
 	};
 
+	if (test->counter == VIRTUAL) {
+		cntvoff = test->offset;
+		cntpoff = 0;
+	} else {
+		cntvoff = 0;
+		cntpoff = test->offset;
+	}
+
 	vcpu_set_reg(vm, VCPU_ID, &reg);
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_PHYS_OFFSET, &cntpoff, true);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
 {
 	switch (test->counter) {
 	case VIRTUAL:
+	case PHYSICAL_READ_VIRTUAL:
 		return read_cntvct_ordered();
+	case PHYSICAL:
+		return read_cntpct_ordered();
 	default:
 		GUEST_ASSERT(0);
 	}
-- 
2.33.0.464.g1972c5931b-goog

