Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982323CBE95
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhGPV3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbhGPV3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5ACC06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:51 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x11-20020ae9f80b0000b02903b8d1e253a9so5097899qkh.11
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
        b=b8t9DdgCqPuR2UnoT0GWSzOZJJBPUdIz3hog5NHSzQX1KdgyIEve3UuQk8NWg7PeYT
         0hcHxEpdXateqVQ5BsKRkc5DGtoKoHKtmtT0MZ59LV8jIOIEmz0jcaIbngWtkh1j2sO6
         3S3JvEIrkJl41Ofh0pH6MI1ylz24x3UtG+PqDzk/SqD7enT7oT8KmEXAClybzSHNcXN/
         iA61C6x08Zk9Nvhfip/WHFAnqsO1d/iWWFxGWRH8gTISa77H1Q4L4DeJYfZK6vcQsjT6
         a1+8oJhLQb8hm9AmAHPvebrBTnniCHXm/YF2UPIcv1+wPRcN0U801VrTR2NRbtNzKxw6
         uq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
        b=rA3Y79gHjjXJAvMkd+VncHpfp1aG1v6Y7+PSLaGnnQA5S48jhEsfyahfH7ZKGI0gCy
         f711ciSnwV4Sf0VKTdChAAMv3Ccag8XtJ3FLWn2u8FIZE2ukSYW39i7Hxc6D4xkQsn4c
         Hxcw2II5oD0GNAF5l32h/uNuzOANDUisIqo+r/4jL7yqiqW/qMsFgiL2ozRsuJq2+M9G
         RQZbdhdPvnzr5gNL7l0AMq1l2iISssamXUEz8ScpNTgLU9jq8eIGEJD6UMF/8svwH4NV
         VaqOLsHRn4Ej76exdJiCnPT+JUJUFfxllRMZ70u5Vt4LECeJpzNUQo+YN1zu3CfKM9Pj
         kicQ==
X-Gm-Message-State: AOAM5330/E49244GQT9WCnNpWfTEseJpfjQz+VW0eaNFP+pl6dSNEQuZ
        3v1WuaMSCaKzF749dbX7VBfY84O6f+NsbTAcoQwuO+A9wJkwJGKcxNmDO/whBdawCp2fCUZ6Bpo
        lVV23+LzX8h2PfwcR4z+X7i6eydwGtNKs8HfoT3hw+12v8YFuwJlYcHi+VA==
X-Google-Smtp-Source: ABdhPJxdMMzj7m+DdM5IVuhVT668UYH1N0CU9KNbCaCSt1Cpr238O4n9eAy/PFAJlugWekgTuAx0IJRNPPk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:7cf:: with SMTP id
 bb15mr12249569qvb.29.1626470810648; Fri, 16 Jul 2021 14:26:50 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:28 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-12-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 11/12] selftests: KVM: Test physical counter offsetting
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that userpace adjustment of the guest physical counter-timer
results in the correct view of within the guest.

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
index 88ad997f5b69..3eed9dcb7693 100644
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
2.32.0.402.g57bb445576-goog

