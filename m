Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34353C2F5
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240654AbiFCAtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240523AbiFCArS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5467D37BD4
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso3519506pjd.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IRoCVqv4AGV0w4b47hD/RBw9j+ld7xWuAgNqbC9za8Y=;
        b=N0XoHp66jUsIf2FZke9OxI1+maVnwfsbXtVYQOXMhAnhURTHeS3ULonBf35YQthk7L
         +N5gE6zvXDVAW5hjLRe7RaKVTjVoFFN40tcdbCxS4cSjnWO+hbtziaA4YdY6DjAH+2TK
         vjFpLzQn13w2vpVI65tjSJ9eagQc4fM1OC7gQLbn52w4nd6o5jx6tfxUxQ/su6BNupRC
         YPSaTOf6n6PrI/CLnDv6sIxQDdk2zX/fOTrGrPEO+7u/9jiILchIu6YItJf+iVtvEyoA
         EHvoyrTDidiDO3CxfLHcpuIpTbuZt7tBQew3KqKUfnQw2oxCLY0ZhCdrVmIFq70C+T+g
         AUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IRoCVqv4AGV0w4b47hD/RBw9j+ld7xWuAgNqbC9za8Y=;
        b=lzWexU6+/yb3Le74DqSPiRpuVv7pk1l5AbJVdnPOfqPGmrZuakrT8t31EMNo01s6IU
         c7u/nJX7PQ3BOl2qKXwipLkO+RknHI7Yg+NJ/WIPWcVvgI84nQ5Rc5JyvwitS0waYM29
         8BQJ4styC5mQRn0CmV9SfvkhAXzBXSoYlYOqp1haXywoIOUJ1s9c2K0DvKKh3Myq6t2d
         78Hz7d1MIQFE6x+cXUYLrKdKHjPKMeN1G+pjRqh7aV2UCXc+UUpwng3CDyyOLPCmPKI1
         oaqqgRdR4HyflXCwmYpbcCSZtYXpaT0JIrSQ1L6iMS4rZMbpoAPSLHSQ3DKydLJWnlW6
         gy5A==
X-Gm-Message-State: AOAM5329V/D4aw4E6RLqLhOfV3Y+WREfhShl75gxV1+noyPDOyoDGnEh
        ztxyn+U9aBmhwVXHOpVnxcHjkb8Acwk=
X-Google-Smtp-Source: ABdhPJz7hkT62hXVx4MA/mDi13XMW7mRrf3YE7KKEcAV5p7/lEdCD+PN8/euDGKoZYFacjln6vZYn5uOUk0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307318pje.0.1654217190501; Thu, 02 Jun
 2022 17:46:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:43 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-97-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 096/144] KVM: selftests: Convert fix_hypercall_test away
 from VCPU_ID
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert fix_hypercall_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 34 +++++++++----------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 81f9f5b1f655..108c3f75361d 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -14,8 +14,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
-
 static bool ud_expected;
 
 static void guest_ud_handler(struct ex_regs *regs)
@@ -94,22 +92,20 @@ static void guest_main(void)
 	GUEST_DONE();
 }
 
-static void setup_ud_vector(struct kvm_vm *vm)
+static void setup_ud_vector(struct kvm_vcpu *vcpu)
 {
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+	vm_init_descriptor_tables(vcpu->vm);
+	vcpu_init_descriptor_tables(vcpu->vm, vcpu->id);
+	vm_install_exception_handler(vcpu->vm, UD_VECTOR, guest_ud_handler);
 }
 
-static void enter_guest(struct kvm_vm *vm)
+static void enter_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run;
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	run = vcpu_state(vm, VCPU_ID);
-
-	vcpu_run(vm, VCPU_ID);
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	vcpu_run(vcpu->vm, vcpu->id);
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		pr_info("%s: %016lx\n", (const char *)uc.args[2], uc.args[3]);
 		break;
@@ -125,25 +121,27 @@ static void enter_guest(struct kvm_vm *vm)
 
 static void test_fix_hypercall(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
-	setup_ud_vector(vm);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
+	setup_ud_vector(vcpu);
 
 	ud_expected = false;
 	sync_global_to_guest(vm, ud_expected);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
-	enter_guest(vm);
+	enter_guest(vcpu);
 }
 
 static void test_fix_hypercall_disabled(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
-	setup_ud_vector(vm);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
+	setup_ud_vector(vcpu);
 
 	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2,
 		      KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
@@ -153,7 +151,7 @@ static void test_fix_hypercall_disabled(void)
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
-	enter_guest(vm);
+	enter_guest(vcpu);
 }
 
 int main(void)
-- 
2.36.1.255.ge46751e96f-goog

