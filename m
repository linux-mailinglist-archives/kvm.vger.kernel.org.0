Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ACB51B31A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiEDXA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380237AbiEDW7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BAB56C36
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:05 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 92-20020a17090a09e500b001d917022847so1092696pjo.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OjfbmCPfsPFbm1g2v6wtPVS0L/Dcelop2dJZ2b57DQw=;
        b=Ax22X01ToKZWVI/cZ1sWZvxq5vVTyrDAZRUMwiRyEU2G5/Ztfc149wXmJM3Zt22yjo
         GAZrnjHE3Up4O5tTOlQw8JFhPiYA9XA/RFxs3z+k0K7QlaFooHhmhqUGXygjjCAgyM7L
         QQt3CmoRAJbw0AuteRpHkOC7Ca3dBCBPAHfpJs1kRzCef9EgzIi9mXK65FjCGnpKQYPy
         DGjiSaL23biy9Ygr06UWnvT12QIE54zzAE7FSTi/r1UBoJAnHPCc5+c7Xl6tPS1ZZIxc
         od9i5gWVl+ur8oetN8gqL41bHNF34KWoUHd8rpMZcvVtHD4Dr6YQiANxKmHOVM/IwVD7
         CoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OjfbmCPfsPFbm1g2v6wtPVS0L/Dcelop2dJZ2b57DQw=;
        b=GyqnYHTU0s9NG6mthi/9EZbxESasHaNdiEosXdeDZ5c2rb6gZHIEFywOkhpMlMmCOt
         H2MEPNddQyACgnaejGQWC2OzCpOxNTBnwu57B9CGX0bIf1JDdjjl041SxQZ7osO45rt9
         uFlAgQrC3jZWS1Czq7KVDC6MuWe/1UUfZsVuOf178OSgTYgv59ogHBenupy8E1P0LgRr
         5Y6mfhGd+6+iM9+FIDpoXPLsJHLn3z66M2GeyEuB5G1+t567Iprw/dqOGrbhuD/1v8Z6
         qA+aK8VNuIvo7/fmV7bK6EqDPu8iIqpOl95l0vhQ+Us1aWqrxtCtFJIVwJ4l2b/op1E9
         dVCw==
X-Gm-Message-State: AOAM5318J24AswI0N3O/EXSLIX7f18taPZn3E9mv/5X2LD5PJ0/VpVYN
        661Z5cTPFe0AJ60pYBpE3YMkNiYKr4Y=
X-Google-Smtp-Source: ABdhPJyEObyDIhU6OmP+vRHG7qigqJkML103tgWt+w08GLLW6bCafdSm2rXNNX0KNNwoxWgeF2UdES5l7JY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cccc:b0:15a:30ec:2f56 with SMTP id
 z12-20020a170902cccc00b0015a30ec2f56mr24062309ple.169.1651704753960; Wed, 04
 May 2022 15:52:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:52 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-107-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 106/128] KVM: selftests: Convert memop away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Pass around a 'struct kvm_vcpu' object instead of a vCPU ID in s390's
memop test.  Pass NULL for the vCPU instead of a magic '-1' ID to
indicate that an ioctl/test should be done at VM scope.

Rename "struct test_vcpu vcpu" to "struct test_info info" in order to
avoid naming collisions (this is the bulk of the diff :-( ).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 82 ++++++++++++-----------
 1 file changed, 42 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 5eb20a358cfe..ba5f645b7565 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -96,21 +96,18 @@ static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc desc)
 	return ksmo;
 }
 
-/* vcpu dummy id signifying that vm instead of vcpu ioctl is to occur */
-const uint32_t VM_VCPU_ID = (uint32_t)-1;
-
-struct test_vcpu {
+struct test_info {
 	struct kvm_vm *vm;
-	uint32_t id;
+	struct kvm_vcpu *vcpu;
 };
 
 #define PRINT_MEMOP false
-static void print_memop(uint32_t vcpu_id, const struct kvm_s390_mem_op *ksmo)
+static void print_memop(struct kvm_vcpu *vcpu, const struct kvm_s390_mem_op *ksmo)
 {
 	if (!PRINT_MEMOP)
 		return;
 
-	if (vcpu_id == VM_VCPU_ID)
+	if (!vcpu)
 		printf("vm memop(");
 	else
 		printf("vcpu memop(");
@@ -145,25 +142,29 @@ static void print_memop(uint32_t vcpu_id, const struct kvm_s390_mem_op *ksmo)
 	puts(")");
 }
 
-static void memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
+static void memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 {
-	if (vcpu.id == VM_VCPU_ID)
-		vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
+	struct kvm_vcpu *vcpu = info.vcpu;
+
+	if (!vcpu)
+		vm_ioctl(info.vm, KVM_S390_MEM_OP, ksmo);
 	else
-		vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
+		vcpu_ioctl(vcpu->vm, vcpu->id, KVM_S390_MEM_OP, ksmo);
 }
 
-static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
+static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 {
-	if (vcpu.id == VM_VCPU_ID)
-		return __vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
+	struct kvm_vcpu *vcpu = info.vcpu;
+
+	if (!vcpu)
+		return __vm_ioctl(info.vm, KVM_S390_MEM_OP, ksmo);
 	else
-		return __vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
+		return __vcpu_ioctl(vcpu->vm, vcpu->id, KVM_S390_MEM_OP, ksmo);
 }
 
-#define MEMOP(err, vcpu_p, mop_target_p, access_mode_p, buf_p, size_p, ...)	\
+#define MEMOP(err, info_p, mop_target_p, access_mode_p, buf_p, size_p, ...)	\
 ({										\
-	struct test_vcpu __vcpu = (vcpu_p);					\
+	struct test_info __info = (info_p);					\
 	struct mop_desc __desc = {						\
 		.target = (mop_target_p),					\
 		.mode = (access_mode_p),					\
@@ -175,13 +176,13 @@ static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 										\
 	if (__desc._gaddr_v) {							\
 		if (__desc.target == ABSOLUTE)					\
-			__desc.gaddr = addr_gva2gpa(__vcpu.vm, __desc.gaddr_v);	\
+			__desc.gaddr = addr_gva2gpa(__info.vm, __desc.gaddr_v);	\
 		else								\
 			__desc.gaddr = __desc.gaddr_v;				\
 	}									\
 	__ksmo = ksmo_from_desc(__desc);					\
-	print_memop(__vcpu.id, &__ksmo);					\
-	err##memop_ioctl(__vcpu, &__ksmo);					\
+	print_memop(__info.vcpu, &__ksmo);					\
+	err##memop_ioctl(__info, &__ksmo);					\
 })
 
 #define MOP(...) MEMOP(, __VA_ARGS__)
@@ -197,7 +198,6 @@ static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 
 #define CHECK_N_DO(f, ...) ({ f(__VA_ARGS__, CHECK_ONLY); f(__VA_ARGS__); })
 
-#define VCPU_ID 1
 #define PAGE_SHIFT 12
 #define PAGE_SIZE (1ULL << PAGE_SHIFT)
 #define PAGE_MASK (~(PAGE_SIZE - 1))
@@ -209,21 +209,22 @@ static uint8_t mem2[65536];
 
 struct test_default {
 	struct kvm_vm *kvm_vm;
-	struct test_vcpu vm;
-	struct test_vcpu vcpu;
+	struct test_info vm;
+	struct test_info vcpu;
 	struct kvm_run *run;
 	int size;
 };
 
 static struct test_default test_default_init(void *guest_code)
 {
+	struct kvm_vcpu *vcpu;
 	struct test_default t;
 
 	t.size = min((size_t)kvm_check_cap(KVM_CAP_S390_MEM_OP), sizeof(mem1));
-	t.kvm_vm = vm_create_default(VCPU_ID, 0, guest_code);
-	t.vm = (struct test_vcpu) { t.kvm_vm, VM_VCPU_ID };
-	t.vcpu = (struct test_vcpu) { t.kvm_vm, VCPU_ID };
-	t.run = vcpu_state(t.kvm_vm, VCPU_ID);
+	t.kvm_vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	t.vm = (struct test_info) { t.kvm_vm, NULL };
+	t.vcpu = (struct test_info) { t.kvm_vm, vcpu };
+	t.run = vcpu->run;
 	return t;
 }
 
@@ -238,14 +239,15 @@ enum stage {
 	STAGE_COPIED,
 };
 
-#define HOST_SYNC(vcpu_p, stage)					\
+#define HOST_SYNC(info_p, stage)					\
 ({									\
-	struct test_vcpu __vcpu = (vcpu_p);				\
+	struct test_info __info = (info_p);				\
+	struct kvm_vcpu *__vcpu = __info.vcpu;				\
 	struct ucall uc;						\
 	int __stage = (stage);						\
 									\
-	vcpu_run(__vcpu.vm, __vcpu.id);					\
-	get_ucall(__vcpu.vm, __vcpu.id, &uc);				\
+	vcpu_run(__vcpu->vm, __vcpu->id);				\
+	get_ucall(__vcpu->vm, __vcpu->id, &uc);				\
 	ASSERT_EQ(uc.cmd, UCALL_SYNC);					\
 	ASSERT_EQ(uc.args[1], __stage);					\
 })									\
@@ -264,7 +266,7 @@ static void prepare_mem12(void)
 
 #define DEFAULT_WRITE_READ(copy_cpu, mop_cpu, mop_target_p, size, ...)		\
 ({										\
-	struct test_vcpu __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
+	struct test_info __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
 	enum mop_target __target = (mop_target_p);				\
 	uint32_t __size = (size);						\
 										\
@@ -279,7 +281,7 @@ static void prepare_mem12(void)
 
 #define DEFAULT_READ(copy_cpu, mop_cpu, mop_target_p, size, ...)		\
 ({										\
-	struct test_vcpu __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
+	struct test_info __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
 	enum mop_target __target = (mop_target_p);				\
 	uint32_t __size = (size);						\
 										\
@@ -580,34 +582,34 @@ static void guest_idle(void)
 		GUEST_SYNC(STAGE_IDLED);
 }
 
-static void _test_errors_common(struct test_vcpu vcpu, enum mop_target target, int size)
+static void _test_errors_common(struct test_info info, enum mop_target target, int size)
 {
 	int rv;
 
 	/* Bad size: */
-	rv = ERR_MOP(vcpu, target, WRITE, mem1, -1, GADDR_V(mem1));
+	rv = ERR_MOP(info, target, WRITE, mem1, -1, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
 
 	/* Zero size: */
-	rv = ERR_MOP(vcpu, target, WRITE, mem1, 0, GADDR_V(mem1));
+	rv = ERR_MOP(info, target, WRITE, mem1, 0, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
 		    "ioctl allows 0 as size");
 
 	/* Bad flags: */
-	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR_V(mem1), SET_FLAGS(-1));
+	rv = ERR_MOP(info, target, WRITE, mem1, size, GADDR_V(mem1), SET_FLAGS(-1));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
 
 	/* Bad guest address: */
-	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR((void *)~0xfffUL), CHECK_ONLY);
+	rv = ERR_MOP(info, target, WRITE, mem1, size, GADDR((void *)~0xfffUL), CHECK_ONLY);
 	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
 
 	/* Bad host address: */
-	rv = ERR_MOP(vcpu, target, WRITE, 0, size, GADDR_V(mem1));
+	rv = ERR_MOP(info, target, WRITE, 0, size, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == EFAULT,
 		    "ioctl does not report bad host memory address");
 
 	/* Bad key: */
-	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR_V(mem1), KEY(17));
+	rv = ERR_MOP(info, target, WRITE, mem1, size, GADDR_V(mem1), KEY(17));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows invalid key");
 }
 
-- 
2.36.0.464.gb9c8b46e94-goog

