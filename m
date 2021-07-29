Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C083DAA53
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhG2RdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhG2RdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:21 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A259C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:17 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y10-20020a0cd98a0000b029032ca50bbea1so4297287qvj.12
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
        b=axscSmOWmq1C0aoI8NBQYvdm+hA6Sf9gCPl7luIIV/m8XpC9a0xJfvOT90n2lIyiUK
         JexEUTNCu6Ju02gqX6FtKa9QFMC3RCbZ8vmLvqz0c3MgiAiq1dacIbSL7cO4CR2ASFO+
         zXmv0winC1An28YmyIkaIBw35D47lkKEaJhItaBSbeJGlbTPO/Pl4gENeDU+FjncCYxX
         jtaii0qQvEm3PKFIuSGmv0INcAHFNXAWK9Sj2be/cG2XPGwDNHQyu3mqVKqhhQ+uCQHh
         l6OOf9H8ry2bSkysEiCQPuMe/uUb39Ge4meg90vo7GianxKzs7RzWLrBfeP+lXEmUbD3
         VUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
        b=TF5dYUe+4M93kdORZ6d9P23Q2GNQyQxfsLL7Fo4bBkgIHah8WPRuj5hOYNGbgVy01/
         BAnIsX94FzUqqJuxdBE/yweBun4Xs+at63cl7aX7fzW3XSquTgSzPsnD8M4g88kzwBR6
         mAJZPJtePLSi5y0g9lQBPYPcbondRXTQ4SzeT6FpHgPOGGqupYWZRWzh9vxl2KqBwpYe
         VjTE7seaXtDf3JJ5zQL60legmEamwWPNRZDJNfqj5YvjwYRCJbgdFydIZpznNJn3HTDd
         CLf3tgk3vPWjXBgHOJta3GzefO5ry+4LC3Y9OYT9W8rmgHDh9u+RC7k4JiM96lxe/bXr
         CYrw==
X-Gm-Message-State: AOAM533W8MrsFT2BaSAoEuZtbd7zucvi2QBFSFmIl0JYgi/nNKoXZUlb
        9pH4vz9bASKyFZjoudRr0Qxx/euoLSBgVtJgOPoGPZ22B/lYvNmLi8RAuEeFqIJWsAT6+ePR0fZ
        EYxx1dK/v3uymsOL7cZEHf6iemAckXgbw442AS8jSdUppyI/cXw7pvHO/zg==
X-Google-Smtp-Source: ABdhPJwwJ8W8ngHZoCaRMOvxLOYKOwr+YOUEJiypJs7egH0lnGnqgDbgJeHFIzCV/H2Bcsl57/+fDA25X7U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:ca5:: with SMTP id
 s5mr6492494qvs.58.1627579996274; Thu, 29 Jul 2021 10:33:16 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:59 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-13-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 12/13] selftests: KVM: Test physical counter offsetting
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

