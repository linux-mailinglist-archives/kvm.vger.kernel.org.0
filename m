Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDE75B2A66
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIHXeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiIHXeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:34:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D89E3D7F
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso3806344pgk.18
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=pR1IVVufUDoLTi7sM6oCGasuX8D5bEWKzHsK5TFQcjA=;
        b=SX1Arlkk9SXL+yXwVHelHtbPesxMkKFSWRgdWNPe60pe4PPF/Ksx+DrYv59q+p822t
         qdRaYY+1oiHQYa2apG6DXI3edxKcbkRVV5uiZdk5Bf49RmqsP5R3AsSks6vjDVRMpwFh
         3nAbt5iAnC3qgauHbLFi5iTpfj+bfOHXiG9KvrfficB8mHmR8/py1j+cwrHjypH99zpi
         DHAA+kAEjL6wARYr/gYUDnr3rtT5g6RaCCjHVs8Fin8Trw0kJ9IL9qbA0p+ZcbOmib7O
         e74dOXCziorpnV2ITxi+Qdr1l3brBLOcbvFtTWB5oHN71YWuHV7ICn74Ecd6pPD4BKS4
         UJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=pR1IVVufUDoLTi7sM6oCGasuX8D5bEWKzHsK5TFQcjA=;
        b=bAV9tUp7MSCVXnBBfX6XuJCe9EgEX9INqvp41TG/a/v5v42y0KT1mrnHJx3YeyzZJo
         hrNcUwKPq+ToR/e8QT8wDWnUrmN8dq8eKMqD+VWkQYA1XaqA9YrQ8mAY7Sv59xOBtCue
         SII5KYrnOv7OBLzvm6UOGaQ8HBZ+WWAITmlPY9EA0/FvTdl6KlrSSyLkO5iLR7j6q+14
         Icggc8PgrjxwXPRiKuu2yUacDuagWnvqB4wtfc4c6VImsjCD++W1/FC3vrlatjqIwq4c
         Inv/eFlq4nuO8SFlozOcF0zwEJif30BxGZJT5icJxymR5Ralc8PxQiF3C+DeCFO14T6x
         1mog==
X-Gm-Message-State: ACgBeo2y6XNKNm1GyNat3wPhGNQepZjO9cbxl3lB9Uo4doZut76bi3f2
        N5cUJZP1ZMlVDg55V2liSlrpADUsvuY=
X-Google-Smtp-Source: AA6agR4XlUDA4rSv8HuDaVOd7n0uD2AzVoaUOTKU3me7i+UtljPpFWgpXphG8R/kJnJaK8ckDWoeZLVZjJA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr118903pje.0.1662679908489; Thu, 08 Sep
 2022 16:31:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:34 +0000
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220908233134.3523339-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Dedup subtests of fix_hypercall_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Combine fix_hypercall_test's two subtests into a common routine, the only
difference between the two is whether or not  disable the quirk.  Passing
a boolean is a little gross, but using an enum to make it super obvious
that the callers are enabling/disabling the quirk seems like overkill.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 45 ++++++-------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 5925da3b3648..4bbc4b95136f 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -17,7 +17,7 @@
 /* VMCALL and VMMCALL are both 3-byte opcodes. */
 #define HYPERCALL_INSN_SIZE	3
 
-static bool ud_expected;
+static bool quirk_disabled;
 
 static void guest_ud_handler(struct ex_regs *regs)
 {
@@ -81,7 +81,7 @@ static void guest_main(void)
 	 * enabled, verify that the hypercall succeeded and that KVM patched in
 	 * the "right" hypercall.
 	 */
-	if (ud_expected) {
+	if (quirk_disabled) {
 		GUEST_ASSERT(ret == (uint64_t)-EFAULT);
 
 		/*
@@ -101,13 +101,6 @@ static void guest_main(void)
 	GUEST_DONE();
 }
 
-static void setup_ud_vector(struct kvm_vcpu *vcpu)
-{
-	vm_init_descriptor_tables(vcpu->vm);
-	vcpu_init_descriptor_tables(vcpu);
-	vm_install_exception_handler(vcpu->vm, UD_VECTOR, guest_ud_handler);
-}
-
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
@@ -128,35 +121,23 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void test_fix_hypercall(void)
+static void test_fix_hypercall(bool disable_quirk)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
-	setup_ud_vector(vcpu);
 
-	ud_expected = false;
-	sync_global_to_guest(vm, ud_expected);
+	vm_init_descriptor_tables(vcpu->vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_exception_handler(vcpu->vm, UD_VECTOR, guest_ud_handler);
 
-	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+	if (disable_quirk)
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2,
+			      KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
 
-	enter_guest(vcpu);
-}
-
-static void test_fix_hypercall_disabled(void)
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-
-	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
-	setup_ud_vector(vcpu);
-
-	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2,
-		      KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
-
-	ud_expected = true;
-	sync_global_to_guest(vm, ud_expected);
+	quirk_disabled = disable_quirk;
+	sync_global_to_guest(vm, quirk_disabled);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
@@ -167,6 +148,6 @@ int main(void)
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
 
-	test_fix_hypercall();
-	test_fix_hypercall_disabled();
+	test_fix_hypercall(false);
+	test_fix_hypercall(true);
 }
-- 
2.37.2.789.g6183377224-goog

