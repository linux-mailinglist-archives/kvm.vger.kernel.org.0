Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7594251B35C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379834AbiEDW6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379742AbiEDW5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:57:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9066254685
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i6-20020a17090a718600b001dc87aca289so1081595pjk.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Hx8sCbhJvCh5cLdAhmGu8wLUB1jVDA/mxGjlfX4jDqM=;
        b=tfLtI6sfhovJRsf3jGIwzoV9D3TJaeV+YvUAEkJIwJSxaewRMzz53Llw7lmWCI0j4K
         eUOSQ31RJ6XLelenIebss22NvfTU3D+X7Tt0X81MZenpjuKsgQulvOZP7MJ9UYP+Y6zr
         3Lx1LOG1Aldt32RQMvbzPmu8gFeqV4vTHHkLlrKDG0dZLMgc4WHpXI9qVGdJW2zX7XAi
         3gqd340xVwC3KBfYI3zro5OT4LTZKR5gbWOSuAHlA9FaoheMSe6OA62TW0rRctwSVvYm
         XMGsPLfguqtHE6tKbO5tUvlN8G5KWIGfOtrKXLvTm6AAdIgd2OmOnR/Qh23Vku0QYZrr
         h1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Hx8sCbhJvCh5cLdAhmGu8wLUB1jVDA/mxGjlfX4jDqM=;
        b=1h8wY6B7Pv9MdPfrc+sBYr6kPZIPFpex6EGXfxAAdQPPtlhScsKBbQMx2PCmvoJnxV
         qTwFgJDL8UouJk3ryvkAx8Ii+NcUJtTh3akrylLTDhE0oGBB/GE+F6sSTvDI12kCxL5i
         sSZojftJ7rNftlslAsrOeIeViqHZPuQPcYvx6s41wTeFcBN3O2gqBAalvdD2eMyW9g/w
         gdTqyuJ16zX32jxUDWnIUzwKnVHQq0/a7FpCUv63kXqdB8neVxDPlXhwbNuzpV1xtNsD
         69BQSn06ki1zuR/j+ucpYfMlitgIlp2Vrlhw9MbQc4dzzhddQ5dGkI+lO6RyOTQZX9SI
         cyxg==
X-Gm-Message-State: AOAM530+to7bmOLnehvlwSObGSnrFrfnlq6N6j8i7ancXAcMo1xDFpXj
        HcJSmYW5GL6yxUdB3ceH5uQBb6VZcvs=
X-Google-Smtp-Source: ABdhPJyQwjqPyAPUvRIzb7J6XsuFaPqeZRZSGX1w+CRJDk08taZEW9zNDQzFxttZ7zMLtPTHM+ir5HkkoEU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1784:b0:50d:d8cb:7a4f with SMTP id
 s4-20020a056a00178400b0050dd8cb7a4fmr19715916pfg.23.1651704719268; Wed, 04
 May 2022 15:51:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:32 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-87-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 086/128] KVM: selftests: Convert xapic_state_test away from
 hardcoded vCPU ID
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert xapic_state_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of the raw vCPU ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 48 ++++++++++---------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 9d8393b6ec75..56301ee1adee 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -12,7 +12,7 @@
 #include "test_util.h"
 
 struct xapic_vcpu {
-	uint32_t id;
+	struct kvm_vcpu *vcpu;
 	bool is_x2apic;
 };
 
@@ -47,8 +47,9 @@ static void x2apic_guest_code(void)
 	} while (1);
 }
 
-static void ____test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu, uint64_t val)
+static void ____test_icr(struct kvm_vm *vm, struct xapic_vcpu *x, uint64_t val)
 {
+	struct kvm_vcpu *vcpu = x->vcpu;
 	struct kvm_lapic_state xapic;
 	struct ucall uc;
 	uint64_t icr;
@@ -70,28 +71,29 @@ static void ____test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu, uint64_t va
 	vcpu_ioctl(vm, vcpu->id, KVM_GET_LAPIC, &xapic);
 	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
-	if (!vcpu->is_x2apic)
+	if (!x->is_x2apic)
 		val &= (-1u | (0xffull << (32 + 24)));
 	ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
-static void __test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu, uint64_t val)
+static void __test_icr(struct kvm_vm *vm, struct xapic_vcpu *x, uint64_t val)
 {
-	____test_icr(vm, vcpu, val | APIC_ICR_BUSY);
-	____test_icr(vm, vcpu, val & ~(u64)APIC_ICR_BUSY);
+	____test_icr(vm, x, val | APIC_ICR_BUSY);
+	____test_icr(vm, x, val & ~(u64)APIC_ICR_BUSY);
 }
 
-static void test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu)
+static void test_icr(struct kvm_vm *vm, struct xapic_vcpu *x)
 {
+	struct kvm_vcpu *vcpu = x->vcpu;
 	uint64_t icr, i, j;
 
 	icr = APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_FIXED;
 	for (i = 0; i <= 0xff; i++)
-		__test_icr(vm, vcpu, icr | i);
+		__test_icr(vm, x, icr | i);
 
 	icr = APIC_INT_ASSERT | APIC_DM_FIXED;
 	for (i = 0; i <= 0xff; i++)
-		__test_icr(vm, vcpu, icr | i);
+		__test_icr(vm, x, icr | i);
 
 	/*
 	 * Send all flavors of IPIs to non-existent vCPUs.  TODO: use number of
@@ -100,32 +102,32 @@ static void test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu)
 	icr = APIC_INT_ASSERT | 0xff;
 	for (i = vcpu->id + 1; i < 0xff; i++) {
 		for (j = 0; j < 8; j++)
-			__test_icr(vm, vcpu, i << (32 + 24) | APIC_INT_ASSERT | (j << 8));
+			__test_icr(vm, x, i << (32 + 24) | APIC_INT_ASSERT | (j << 8));
 	}
 
 	/* And again with a shorthand destination for all types of IPIs. */
 	icr = APIC_DEST_ALLBUT | APIC_INT_ASSERT;
 	for (i = 0; i < 8; i++)
-		__test_icr(vm, vcpu, icr | (i << 8));
+		__test_icr(vm, x, icr | (i << 8));
 
 	/* And a few garbage value, just make sure it's an IRQ (blocked). */
-	__test_icr(vm, vcpu, 0xa5a5a5a5a5a5a5a5 & ~APIC_DM_FIXED_MASK);
-	__test_icr(vm, vcpu, 0x5a5a5a5a5a5a5a5a & ~APIC_DM_FIXED_MASK);
-	__test_icr(vm, vcpu, -1ull & ~APIC_DM_FIXED_MASK);
+	__test_icr(vm, x, 0xa5a5a5a5a5a5a5a5 & ~APIC_DM_FIXED_MASK);
+	__test_icr(vm, x, 0x5a5a5a5a5a5a5a5a & ~APIC_DM_FIXED_MASK);
+	__test_icr(vm, x, -1ull & ~APIC_DM_FIXED_MASK);
 }
 
 int main(int argc, char *argv[])
 {
-	struct xapic_vcpu vcpu = {
-		.id = 0,
+	struct xapic_vcpu x = {
+		.vcpu = NULL,
 		.is_x2apic = true,
 	};
 	struct kvm_cpuid2 *cpuid;
 	struct kvm_vm *vm;
 	int i;
 
-	vm = vm_create_default(vcpu.id, 0, x2apic_guest_code);
-	test_icr(vm, &vcpu);
+	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
+	test_icr(vm, &x);
 	kvm_vm_free(vm);
 
 	/*
@@ -133,18 +135,18 @@ int main(int argc, char *argv[])
 	 * the guest in order to test AVIC.  KVM disallows changing CPUID after
 	 * KVM_RUN and AVIC is disabled if _any_ vCPU is allowed to use x2APIC.
 	 */
-	vm = vm_create_default(vcpu.id, 0, xapic_guest_code);
-	vcpu.is_x2apic = false;
+	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
+	x.is_x2apic = false;
 
-	cpuid = vcpu_get_cpuid(vm, vcpu.id);
+	cpuid = vcpu_get_cpuid(vm, x.vcpu->id);
 	for (i = 0; i < cpuid->nent; i++) {
 		if (cpuid->entries[i].function == 1)
 			break;
 	}
 	cpuid->entries[i].ecx &= ~BIT(21);
-	vcpu_set_cpuid(vm, vcpu.id, cpuid);
+	vcpu_set_cpuid(vm, x.vcpu->id, cpuid);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
-	test_icr(vm, &vcpu);
+	test_icr(vm, &x);
 	kvm_vm_free(vm);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

