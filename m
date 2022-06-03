Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB253C300
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbiFCAuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240510AbiFCArR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D8737BCF
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u67-20020a627946000000b0051b9c1256b0so3498641pfc.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WzL1H+FJi0iT34F2bc/92yeswCFE9kGfAWNofTgrOJI=;
        b=oL5GDgYRYEbXPwWaLr+clEti/v+XZ2Lly4lvT/f+YCO69FwBVSKVrfCuU2h39gqb1Y
         c/EEdh4JlJ5yt3HhAvJT/Kwf4y0N2+fnCiMhtaMmbSnodX9ipW9Lm4TYJK36Ph9hdl4C
         Dr75XDItsnOTLUincucEirXi2E2Ar3DCH6LkylzdUXJ4wLt4cd9gaFnbXtsEzzz0RmHJ
         dCMKUPweIKOx2SUCPaFAQrR0R2p+ELU4dtAna+iXiEJyTkoko4BrceFehGA1ZegJbt5i
         lfCeEwitdKylUnyPOBOWikVABdpJMtX/EqzxORK0nJOK6Y2oyQuryOItxSaPmnXhltKt
         5faA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WzL1H+FJi0iT34F2bc/92yeswCFE9kGfAWNofTgrOJI=;
        b=HHTp/CMn8llgHhU/AjE49c23V7xB1C2ksGGXpmDJwmV7KKdagQkNhhsqb4EsinPcuh
         m+ba7rcStaK4LQ6rU3EsaLnczMfKQE6ixRWKhBDJNanHBp39eU4+jopyevPnLtgkMHfI
         UuIzYH1OzldkOq0suMIBhWP8XnThczSuXYbALzinE9lBehds4zDCAU6RHJKn+dCu0DkI
         YpQcTVe2gYoaXIsN2A2l1mKHr9oje/Jyfjq4Y29TqmQIUBhmnHsdTer8PewJVm+YfrUg
         jVyubSK/wjKDOCtSWneaT+2tt9o5aVziikiXh+dEgtSrfCZgKVbJMUHfVjN73iZjgWQR
         jB6A==
X-Gm-Message-State: AOAM531kAL7zuOALzI1E+Uee7fujojOS1AenoMcPLLJfzgt3muYDq3Ir
        DikQoA3mnpHarlVB2tRi+3ew9unT8OY=
X-Google-Smtp-Source: ABdhPJz6Sz+KXQhSdj+O57Tf05dMEf1VPn1WdoAzjtHgGhmehPuNcRss1vg9YubMVkOD5u3f+LU/ul6xCA0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3805:b0:1e6:85aa:51b with SMTP id
 mq5-20020a17090b380500b001e685aa051bmr6516686pjb.182.1654217187106; Thu, 02
 Jun 2022 17:46:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:41 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-95-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 094/144] KVM: selftests: Convert xapic_state_test away from
 hardcoded vCPU ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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
2.36.1.255.ge46751e96f-goog

