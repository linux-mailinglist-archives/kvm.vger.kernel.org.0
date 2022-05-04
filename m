Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4306A51B362
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379641AbiEDW6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379768AbiEDW6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:24 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BB9554AC
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso1369613plr.13
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vQ9RsiC3eVUA3hf/NGcV00vB3mSKkhczdPMQnZTeFtU=;
        b=N9Thpx8WUYJimniuFToz9fHRfmFfDALDVHJU090OPHaVrsp/eMAmtsgvj5PEyGA3u+
         3J7qqB8glDXlIFVLuM1w6yAdAmXt7jvND6NkcYkStqYIjBYiscw7GKUsN+k+2qbXswks
         1Ork84yZBH18u8sMWJ81bhLC7CoQj7SyVKZbFBrGUr4Lk+/bvmEC8KFdyHNeZNxiWfvu
         g8Bw82MZShySuSphEfMuCO9z/Y6G425ZwBw2H4mDI7ZpVOm/6X6WJCANRbYI9KWvI99S
         5WCdNtKrdUlJkLwOx6GfM6Utx8s2PN/pkOQNqdLpaE/ewRw+FEN/sGz3PW+xxAM9RlOK
         jnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vQ9RsiC3eVUA3hf/NGcV00vB3mSKkhczdPMQnZTeFtU=;
        b=k+pR5dmJ0SRmE6K+2JwbXHiSRninpGWZzOOXsl3SF4pnt6BfWODAkcZH1/KJKDIJgi
         FSHJpIYfOQc+aMIMY68plc4M/FadN/qhINQUS4CsbjhezLezp6/3r/aaqchEaByH1wdR
         /JJsCYLQzjnkZ2MmcAhldOGQHSzUFCwjvNfi8bZVB6pXt7IHlN0A/N+jt41Ez/AclOIY
         n6lhBaUZNSQmAUi+vtqKVQQ9Xj13zd16bRFr5CFFDC9pryzVhntOTTS3hQjgMsIr25r8
         NX+eIqXrCZsUVkbNfK1n2mXPorXfpkJ4WtFubhyIdcTunPQfEWmfgYKSfhs4W7ucPKlI
         OcNQ==
X-Gm-Message-State: AOAM533WiHk+jXNL40i3Nyy0L1S0LS7oPpQIl5/ItiaGDFtINzNjZjOL
        IifDrrRJFifMfBKbl1nB4sPxabNktaI=
X-Google-Smtp-Source: ABdhPJwA8ShvFxiqc7WhGGVgNxnLD6F7oHU90fI7RS3S+0mFk7NS0e/7pLV3AotDAlO9n7jIMv1LZuZ1clo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:84c8:0:b0:3ab:180b:bb5a with SMTP id
 k191-20020a6384c8000000b003ab180bbb5amr19675601pgd.308.1651704724155; Wed, 04
 May 2022 15:52:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:35 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-90-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 089/128] KVM: selftests: Convert vgic_irq away from VCPU_ID
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

Convert vgic_irq to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of passing around a vCPU ID (which is
always the global VCPU_ID...).

Opportunstically align the indentation for multiple functions'
parameters.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 30 ++++++++++---------
 .../selftests/kvm/include/aarch64/vgic.h      |  6 ++--
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 10 +++----
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 87e41895b385..111170201e9b 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -22,7 +22,6 @@
 
 #define GICD_BASE_GPA		0x08000000ULL
 #define GICR_BASE_GPA		0x080A0000ULL
-#define VCPU_ID			0
 
 /*
  * Stores the user specified args; it's passed to the guest and to every test
@@ -589,7 +588,8 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 }
 
 static void kvm_irq_write_ispendr_check(int gic_fd, uint32_t intid,
-			uint32_t vcpu, bool expect_failure)
+					struct kvm_vcpu *vcpu,
+					bool expect_failure)
 {
 	/*
 	 * Ignore this when expecting failure as invalid intids will lead to
@@ -659,15 +659,16 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 		(tmp) < (uint64_t)(first) + (uint64_t)(num);			\
 		(tmp)++, (i)++)
 
-static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
-		struct kvm_inject_args *inject_args,
-		struct test_args *test_args)
+static void run_guest_cmd(struct kvm_vcpu *vcpu, int gic_fd,
+			  struct kvm_inject_args *inject_args,
+			  struct test_args *test_args)
 {
 	kvm_inject_cmd cmd = inject_args->cmd;
 	uint32_t intid = inject_args->first_intid;
 	uint32_t num = inject_args->num;
 	int level = inject_args->level;
 	bool expect_failure = inject_args->expect_failure;
+	struct kvm_vm *vm = vcpu->vm;
 	uint64_t tmp;
 	uint32_t i;
 
@@ -705,12 +706,12 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		break;
 	case KVM_WRITE_ISPENDR:
 		for (i = intid; i < intid + num; i++)
-			kvm_irq_write_ispendr_check(gic_fd, i,
-					VCPU_ID, expect_failure);
+			kvm_irq_write_ispendr_check(gic_fd, i, vcpu,
+						    expect_failure);
 		break;
 	case KVM_WRITE_ISACTIVER:
 		for (i = intid; i < intid + num; i++)
-			kvm_irq_write_isactiver(gic_fd, i, VCPU_ID);
+			kvm_irq_write_isactiver(gic_fd, i, vcpu);
 		break;
 	default:
 		break;
@@ -739,6 +740,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 {
 	struct ucall uc;
 	int gic_fd;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
 	vm_vaddr_t args_gva;
@@ -753,16 +755,16 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 
 	print_args(&args);
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
 	/* Setup the guest args page (so it gets the args). */
 	args_gva = vm_vaddr_alloc_page(vm);
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
-	vcpu_args_set(vm, 0, 1, args_gva);
+	vcpu_args_set(vm, vcpu->id, 1, args_gva);
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
@@ -775,12 +777,12 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
 
 	while (1) {
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			kvm_inject_get_call(vm, &uc, &inject_args);
-			run_guest_cmd(vm, gic_fd, &inject_args, &args);
+			run_guest_cmd(vcpu, gic_fd, &inject_args, &args);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index 4442081221a0..0ac6f05c63f9 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -8,6 +8,8 @@
 
 #include <linux/kvm.h>
 
+#include "kvm_util.h"
+
 #define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
 	(((uint64_t)(count) << 52) | \
 	((uint64_t)((base) >> 16) << 16) | \
@@ -26,8 +28,8 @@ void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
 int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
 
 /* The vcpu arg only applies to private interrupts. */
-void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu);
-void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu);
+void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
+void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
 
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 61da345c48ac..0de9b0686498 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -127,8 +127,8 @@ void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_IRQ_LINE, ret));
 }
 
-static void vgic_poke_irq(int gic_fd, uint32_t intid,
-		uint32_t vcpu, uint64_t reg_off)
+static void vgic_poke_irq(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu,
+			  uint64_t reg_off)
 {
 	uint64_t reg = intid / 32;
 	uint64_t index = intid % 32;
@@ -141,7 +141,7 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 
 	if (intid_is_private) {
 		/* TODO: only vcpu 0 implemented for now. */
-		assert(vcpu == 0);
+		assert(vcpu->id == 0);
 		attr += SZ_64K;
 	}
 
@@ -159,12 +159,12 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	kvm_device_attr_set(gic_fd, group, attr, &val);
 }
 
-void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu)
+void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISPENDR);
 }
 
-void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu)
+void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

