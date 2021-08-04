Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723753DFD86
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhHDI7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbhHDI7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:10 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7847EC06179C
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:57 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id b8-20020a0562141148b02902f1474ce8b7so1265458qvt.20
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P+wj7LgLjEuWRbpjKCXjEpBSkxsEIWcdrd+/OVNGjgQ=;
        b=U2RWOObCpS8DFZJ10Fp2o+XLbL0l1Du9Q2Q9GE9WrsZOYR4vwBJQlSHULYkGmuvObp
         qkHivooxec/DqyZKsQVcgoEPCJi+6nxBSJa++GLLq4UkYPeTO/PnhQU8BxXCanAd/n3b
         1VAAXmzHLRgzm8XB6suWss1/HgHWX8AsDQjtvEEKe6uBRGu5tM62spN1T/IizoXmP1ZL
         /bcqtSUX18eaq6JGBkF1Jl6CZbI9tnVwffM2msHBTiN69mXBBWf9eO+ZEhofwM/eDIVc
         AgUFDx/s8u2xV/CUIjyX8OpmxWHZj6alRmINi+u/RPuPYEpQrLqUs/YiaPtSGXJY1Ysc
         UVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P+wj7LgLjEuWRbpjKCXjEpBSkxsEIWcdrd+/OVNGjgQ=;
        b=nrYK8sTztx5gnKMXXUExpgsvRCtwk08o+UW5218E/aofJNH4hgfnC1O/2wUIOVHOid
         3Ws6jGrCWU68VSS5nLkFt+z1Q9hoOgmpSa8shXxYohdBvZWn10won1XtJR/kbxOS7Spc
         k9G1YsFaYK+ncqk+Msw/hymje9x+Shvp4BRgcX4gVtbM1wVOelcvowUR+gbnI3gyUyTx
         430Y1PX1Nc/vf00SKBpCbzeW2BsFsyGaX/CX5DmHwMkIU3Gxb5e8qtIW66zmjM0b/KKM
         lo3skHq4hpRXr2f6AA1Xn/Q3HQ7Dxawn5yXEA9pNNwcQDsaocAm5VAMTVcuQ5vZN5/Jj
         3mLQ==
X-Gm-Message-State: AOAM532uOVAz2n7S2Bv7/xdiZdasnCnpP+U+9wYknB9FGh8kzANxkSho
        i+P3/h6UhMJYmM9PDBOGzVN6oBR1J4xxViHY6j5heQ6Ab1Wi7njvlufBRiyIglct2uhkkSF8BFK
        G50W28PxSIO/WEgfVbwFTczatykb0Z5KyyUvvkVGT1lqi0+3pY/mp6jCWbA==
X-Google-Smtp-Source: ABdhPJxwuRb6Dx8CoyJvkFTha9TsHjRjV9Svfskn24Ka80JcxAcKjGHT4By5V5+EQXZYVffGDUwuCZ/2cFY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:e67:: with SMTP id
 jz7mr23858033qvb.0.1628067536659; Wed, 04 Aug 2021 01:58:56 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:18 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-21-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 20/21] selftests: KVM: Test physical counter offsetting
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
---
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
 .../kvm/system_counter_offset_test.c          | 31 +++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

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
index ac933db83d03..82d26a45cc48 100644
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
@@ -68,32 +71,54 @@ static struct test_case test_cases[] = {
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
 {
-	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET) &&
+	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET))
 		return;
 
-	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_OFFSET not supported; skipping test");
 	exit(KSFT_SKIP);
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
+				KVM_ARM_VCPU_TIMER_OFFSET, &cntpoff, true);
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
2.32.0.605.g8dce9f2422-goog

