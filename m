Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1C3CEE61
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359035AbhGSUkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383757AbhGSSKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:10:09 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8ABC061793
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:38:19 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id u17-20020a5443910000b02902409d8d9f2fso13838700oiv.5
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
        b=KUYAhBpQDsMooQkrz7c2zqbWLBcD1F57p/29Oql51TqngGSrTxE+wp2bi7H6WlPEpG
         92P89yaUU/AuvB+jJXVMlSvqpqjjr04VSekq6Ex7An/nbaJaaqymAt7A+L4GmNbxWphk
         O9wNM44lF9ZUF0xacIlsBJ9n4+/rjQLxaNK2o0a4nYI1OeU0BtxMk6oCs6BhobrFEKrv
         TIYwsaDYVMZ9otssI1HiIuWC4z9qTat04n1lUCMuWtVWz7xek+ilPdS9nkS+NGd1GmiH
         sB/hX25SAUMnxbw4fILjiZQbUQbB6/H+iD/MltOVRChrpE1OkzQJIE5N8tvygqTbscR6
         dPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
        b=LlDM7IvJ5s51mJUxKyeOPQDZhqSqzb8heLndL8Qy53ZS8YWm2skRDrDvUmmQnt+Ca+
         cdSuttFJerqr+PNbNCG7Bd0aQ8pURsWDn6h1Y9AY9WDEaeLT/swQG3UBHffy8aCV1mQn
         exAliHw6Sq1U6MjSB1EJLv4sb7dxRFj1LecBMHsapbJhjObbxQdn0g+HAQ6rVrLzKmFb
         n5Ws3nyWxdGdN5LUzoFAj5/PSv+/CBQEPomfQZA7wovL/fekmYjYT7KGElE1p+BDzQDK
         4aTQNUG1ssf6DXk2WwJfMWONVxWgxG4UrlNlkpVMWF5OfveC6p4WIREQEy+rbebc4Usg
         4TaA==
X-Gm-Message-State: AOAM5311vdKs0/yljLlIF7qju2QuGqPFVxMQoGLSC+1PYPqlRpWvldxw
        S1+5n4UrTc8iRbhCQ9AWprdtf0V8ojrtZCjKL3J7E6UrIYQclEO8BcxgzfT2qXNzBxDXRjRwFjR
        zRIwhdPr7sVUj5jk7aGyBNAMWqdFtEqU0pCAqf5R+Iv2InzqjWGczLDSikQ==
X-Google-Smtp-Source: ABdhPJyU/b4AHJqg2AmHxiUKhxVMZZVmOLISQrCNLvElELkpv2SnrsueT4Y05a8t4GjE8ckwmm6/FWbJdVc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:b682:: with SMTP id g124mr18546043oif.138.1626720611974;
 Mon, 19 Jul 2021 11:50:11 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:48 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-12-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 11/12] selftests: KVM: Test physical counter offsetting
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

