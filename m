Return-Path: <kvm+bounces-3729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9298807601
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCB501C20F5B
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9A0675BA;
	Wed,  6 Dec 2023 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kUszgREh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0425F10FA
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:49 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-54cd2281ccbso4315608a12.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882168; x=1702486968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HY3/IKmkz8hCxSR9XqKhZvr4gqtwY0S5JXo3M770QTA=;
        b=kUszgREh15i5MZn3p6g3Gd1yew7/utY7t99BH/Tyy4UqNF6kvxxNY8rBfYH6vrHQgx
         QhQRz0QJB3Ra4whQ/dBgm2L7s0BuiDjf7/FVgJ97GpSizegfu55qCMCSj5gz+6zPtEI0
         H7ggi1UVSbgKwpaZGrrMbyVcRIjFx/w/F0VyHg/evOIDbH4RUW8DGPd8fVLsqREJ1g3M
         DXvWRwpsCKCcCLJEyW30eqHNg+HMQGDoIowoba2ODrDGjcIsZqCbediF30WuHO7orTlV
         plOkec7jB1GdwD6n0SZnve6P3yKnCIYdlOxMebZYA9Jt4FQfoLGjzde29iL08smNpdd2
         84pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882168; x=1702486968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HY3/IKmkz8hCxSR9XqKhZvr4gqtwY0S5JXo3M770QTA=;
        b=IJ6K/yO69MclIw+LZ+Z5dNYieHDA5PIgxl4/MPugtjpwDl1nfbmwNOJtR4Y5+ZlAly
         R3Zq3P/ya16cYClon/MHp1wz6BO+DUg9M3UnF2XHq5G8q1gR5eDmwRIUy4t1+Zla4gbG
         CHWCC61MbsNKJEyYRLEMVY3NdlRTeQaPjN0wEs2bU7LL14v7PEiQnOi3I7Sx3O/gaENX
         xJ2lA7d/WILz/RJoLfAu0g5hW3DwRqESEirBYo9zNIe1pTkiLh6XKIT9DTLx0DyeJzL4
         UxOLVLUmAga2tskh7tFdDsbr+kJf10X+PGR6Si+qpc2GKpyZsY3soDnupFXg4cp7A/tg
         jGRA==
X-Gm-Message-State: AOJu0YzH7B8ghQKhSJT538GITeEPlPnRADHko1SGYZmxEpj+QwRzikHi
	bK/GhujcHGmC3RWZqRKU4ia2eUQAfBuv7kJ2KoM=
X-Google-Smtp-Source: AGHT+IG+765FS5RSLiikFQUhOKhXe8bzsuZDyk5lz9HA+46hxIbzOTrUiczonQnHZ/+e4wuegS5r1Q==
X-Received: by 2002:a17:906:f2cf:b0:a1b:e80a:b68 with SMTP id gz15-20020a170906f2cf00b00a1be80a0b68mr703662ejb.143.1701882168538;
        Wed, 06 Dec 2023 09:02:48 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n16-20020a17090625d000b00a1e081369a9sm177592ejb.23.2023.12.06.09.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:48 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 4/5] KVM: selftests: s390x: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:46 +0100
Message-ID: <20231206170241.82801-11-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 tools/testing/selftests/kvm/s390x/resets.c    |  4 ++--
 .../selftests/kvm/s390x/sync_regs_test.c      | 20 +++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 15945121daf1..f6d227892cbc 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -198,7 +198,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 5, "Unsupported number of args,\n"
-		    "  num: %u\n",
+		    "  num: %u",
 		    num);
 
 	va_start(ap, num);
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index e41e2cb8ffa9..357943f2bea8 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -78,7 +78,7 @@ static void assert_noirq(struct kvm_vcpu *vcpu)
 	 * (notably, the emergency call interrupt we have injected) should
 	 * be cleared by the resets, so this should be 0.
 	 */
-	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d\n", errno);
+	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d", errno);
 	TEST_ASSERT(!irqs, "IRQ pending");
 }
 
@@ -199,7 +199,7 @@ static void inject_irq(struct kvm_vcpu *vcpu)
 	irq->type = KVM_S390_INT_EMERGENCY;
 	irq->u.emerg.code = vcpu->id;
 	irqs = __vcpu_ioctl(vcpu, KVM_S390_SET_IRQ_STATE, &irq_state);
-	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
+	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d", errno);
 }
 
 static struct kvm_vm *create_vm(struct kvm_vcpu **vcpu)
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 636a70ddac1e..43fb25ddc3ec 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -39,13 +39,13 @@ static void guest_code(void)
 #define REG_COMPARE(reg) \
 	TEST_ASSERT(left->reg == right->reg, \
 		    "Register " #reg \
-		    " values did not match: 0x%llx, 0x%llx\n", \
+		    " values did not match: 0x%llx, 0x%llx", \
 		    left->reg, right->reg)
 
 #define REG_COMPARE32(reg) \
 	TEST_ASSERT(left->reg == right->reg, \
 		    "Register " #reg \
-		    " values did not match: 0x%x, 0x%x\n", \
+		    " values did not match: 0x%x, 0x%x", \
 		    left->reg, right->reg)
 
 
@@ -82,14 +82,14 @@ void test_read_invalid(struct kvm_vcpu *vcpu)
 	run->kvm_valid_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 
 	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_valid_regs = 0;
 }
@@ -103,14 +103,14 @@ void test_set_invalid(struct kvm_vcpu *vcpu)
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
-		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d",
 		    rv);
 	run->kvm_dirty_regs = 0;
 }
@@ -125,12 +125,12 @@ void test_req_and_verify_all_valid_regs(struct kvm_vcpu *vcpu)
 	/* Request and verify all valid register sets. */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s390_sieic.icptcode == 4 &&
 		    (run->s390_sieic.ipa >> 8) == 0x83 &&
 		    (run->s390_sieic.ipb >> 16) == 0x501,
-		    "Unexpected interception code: ic=%u, ipa=0x%x, ipb=0x%x\n",
+		    "Unexpected interception code: ic=%u, ipa=0x%x, ipb=0x%x",
 		    run->s390_sieic.icptcode, run->s390_sieic.ipa,
 		    run->s390_sieic.ipb);
 
@@ -161,7 +161,7 @@ void test_set_and_verify_various_reg_values(struct kvm_vcpu *vcpu)
 	}
 
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] == 0xBAD1DEA + 1,
 		    "r11 sync regs value incorrect 0x%llx.",
@@ -193,7 +193,7 @@ void test_clear_kvm_dirty_regs_bits(struct kvm_vcpu *vcpu)
 	run->s.regs.gprs[11] = 0xDEADBEEF;
 	run->s.regs.diag318 = 0x4B1D;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d", rv);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] != 0xDEADBEEF,
 		    "r11 sync regs value incorrect 0x%llx.",
-- 
2.43.0


