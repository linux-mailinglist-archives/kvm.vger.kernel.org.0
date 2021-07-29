Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0F3D99F9
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhG2AKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhG2AKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:37 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05426C0613CF
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:35 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id l4-20020a9270040000b02901bb78581beaso2341622ilc.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
        b=Px1zlbyEAWBK8wPigjwJIHRv7fOGOmNXjNldEMUcRiDKtEJWggUs8YPUubCqx9ZtRa
         CAlomjMmf+CFaFW3Hpy+DdHEDyOCNZvGRxQE+z/5gnVYzoz848LIRJXyoHZzPugIyLF5
         +0YdrE81ozb4A1Bf/ISMYj0HP06wdRxxKHl40Tv/gjmtzkevsVBATiPhLFMbUvCMXg6m
         8VtKcYZIPbvk19LdeprJV6rmSoFjtvPSrnawd2yZT2KXY2VZWegLq95eaRfoBNNH34la
         PUQefCM81c6/9T0ekjgWP3FabJUqlbl1+YIiwxE5hbD63Ann5F4Mmdv6KIfEH+4xzI0s
         gTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
        b=cX2+9gOQeEq19ARkoim0zo5ZhSvXHC4XX9iFTcb3yEjdCxI/5+fPgDJieQqt/KtVmm
         x1659beU1OoVDn1Irp/6IdRHmFmOdT8z3p4lBrfb+n3tUtIwGBuvFQMeRMWMqFjfOVj5
         9afKIKh3uWcQp25cIOJ/Wcjq+gj4lGq7tvKtWKHsWxQ2t3jfFt+PO7Qyaz0iZX4chdXy
         lYUkzZtboFa1p2ob8YkwEJxUw7IGD3kDt61Fotf2lP64xTJbEmK14V+jL2Ca8Mr8RtY/
         6pZbEvqjuhg+2dByQQsEhSoH7PNlnLumx6nUMioKJ73swF7ClWn53QGCoDQ2cSz9wIeT
         3asQ==
X-Gm-Message-State: AOAM530hw3hJOtT5ROp9g0y4ZQqblAxjVMnfc7ZjRNRU4U40Ois67PUH
        dLCEa+v8e/JgfFijfxSa4KzZHGRuvh+qFX3Dw8iwDAleaeOsITPHT6gWF1ZpZLIWvLt2/SbT6ds
        QeuCzHW2Sy5zkC/b7GC9la0Nd3DsPpJr/gwm74IN4M+47NxMLFFN+B3i96A==
X-Google-Smtp-Source: ABdhPJy9CFny5+3Gnv3Skzy09KeEENu6h17Em/oyTeuIHYsWAi21QRb1r0pNUbceauhVOSb2tH2fQp1pxpY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:418f:: with SMTP id
 az15mr2053577jab.8.1627517434399; Wed, 28 Jul 2021 17:10:34 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:11 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-13-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 12/13] selftests: KVM: Test physical counter offsetting
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that userpace adjustment of the guest physical counter-timer
results in the correct view of within the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 12 ++++++++
 .../kvm/system_counter_offset_test.c          | 29 ++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 3168cdbae6ee..7f53d90e9512 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
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
index 25806cdd31ef..ef215fb43657 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -57,6 +57,7 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 
 enum arch_counter {
 	VIRTUAL,
+	PHYSICAL,
 };
 
 struct test_case {
@@ -68,23 +69,41 @@ static struct test_case test_cases[] = {
 	{ .counter = VIRTUAL, .offset = 0 },
 	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
 	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = 0 },
+	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
 };
 
 static void check_preconditions(struct kvm_vm *vm)
 {
 	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
-				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
+				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER) &&
+	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET_PTIMER))
 		return;
 
-	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
+	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_{VTIMER,PTIMER} not supported; skipping test");
 	exit(KSFT_SKIP);
 }
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
+	u64 attr = 0;
+
+	switch (test->counter) {
+	case VIRTUAL:
+		attr = KVM_ARM_VCPU_TIMER_OFFSET_VTIMER;
+		break;
+	case PHYSICAL:
+		attr = KVM_ARM_VCPU_TIMER_OFFSET_PTIMER;
+		break;
+	default:
+		TEST_ASSERT(false, "unrecognized counter index %u",
+			    test->counter);
+	}
+
 	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
-				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
-				true);
+				attr, &test->offset, true);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
@@ -92,6 +111,8 @@ static uint64_t guest_read_system_counter(struct test_case *test)
 	switch (test->counter) {
 	case VIRTUAL:
 		return read_cntvct_ordered();
+	case PHYSICAL:
+		return read_cntpct_ordered();
 	default:
 		GUEST_ASSERT(0);
 	}
-- 
2.32.0.432.gabb21c7263-goog

