Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E339D51B30C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379876AbiEDXAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379836AbiEDW6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1EE546B2
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so3564253pjo.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xjXe7wrgH2q/z7D9TWpA0E4IHD4yQCBTWf+8GpgeOow=;
        b=njv960a3c06xGMs+URNfx9eBzxI2l23QFB1jV5hGJMgqbwijub/vuOATRoDmstIFZo
         44/gOd9dQ869J7BL6G9g/3+b8xn4i48IYAruXDMoQS272pI9CnnpEXbvIW+fsNdR0kBu
         pAzE7ThB5Kjj2o0rnta5VfIkt0sERkY9MHydYw6zTJ8ef/l1QdNgFsIpK+zV8fo9c7AD
         SYayrxvDn9Okb/MND9yE6Wuyqy5B17YRc8MH9yIodyFcKMDnW6zaK92jl/0gg8D4sk7+
         StGb6Yb8MDVqlV8SYhxT3BS2WYg2uAUDLe6XhpeV8mO4uCx+mksQRFFiicreTPmoNxvS
         JAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xjXe7wrgH2q/z7D9TWpA0E4IHD4yQCBTWf+8GpgeOow=;
        b=7eT6t71czr61jGFIm85xcSFNGmYIHscY3WeoI9k9KXhH6HO2DARs0iPrkePUE8HPAP
         +SGrsoZWDgu9Dmsj48ITZZ+3UMcOnnTM3RGaPtL1YEjAPOkdl4MSuQI7EdwqEUNz8Pip
         MMO9u3x5kgSi34SGFh14n8oPrHaoJUQIJYIbPvwQwXV2MZ6tOo7CdGL7VbhQ1iaO1TmD
         YpDW104akBlMvMnZLA9Pi01AAM3DvY/efMhSaWoQzbcdLMFDR3BnvR4OYu/gJhdyTgr6
         0/GN9VYmHdoQk9M1V2IDS3BcrWinUZXTVuHldncPm4+7To19bsqQD6vSiFDNFl3uq9Gg
         xtHw==
X-Gm-Message-State: AOAM533ZDVWs5OoyYS0uKqHzKgHES4vVdIXgvTjUZqqEuDsMe70ferkG
        dU4zp9pXpfBqxr9iaDpBpmjINLfgHz8=
X-Google-Smtp-Source: ABdhPJwDmxnTD/LTb/O2hBEutrq6toQND04rlUIbC9tRQVSAiH0QcAd3dUi+85BaFOzHne+xnMUC1wy0LAM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id
 c18-20020a056a000ad200b004f12734a3d9mr23072750pfl.61.1651704735715; Wed, 04
 May 2022 15:52:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:42 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-97-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 096/128] KVM: selftests: Convert psci_cpu_on_test away from VCPU_ID
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

Pass around 'struct kvm_vcpu' objects in psci_cpu_on_test instead of
relying on global VCPU_IDs.  Ideally, the test wouldn't have to manually
create vCPUs and thus care about vCPU IDs, but it's not the end of the
world and avoiding that behavior isn't guaranteed to be a net positive
(an attempt at macro shenanigans did not go very well).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index ffea4f3634b3..142c3fa2f5f7 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -17,9 +17,6 @@
 #include "processor.h"
 #include "test_util.h"
 
-#define VCPU_ID_SOURCE 0
-#define VCPU_ID_TARGET 1
-
 #define CPU_ON_ENTRY_ADDR 0xfeedf00dul
 #define CPU_ON_CONTEXT_ID 0xdeadc0deul
 
@@ -72,6 +69,7 @@ static void guest_main(uint64_t target_cpu)
 int main(void)
 {
 	uint64_t target_mpidr, obs_pc, obs_x0;
+	struct kvm_vcpu *vcpu0, *vcpu1;
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -82,19 +80,19 @@ int main(void)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
-	aarch64_vcpu_add(vm, VCPU_ID_SOURCE, &init, guest_main);
+	vcpu0 = aarch64_vcpu_add(vm, 0, &init, guest_main);
 
 	/*
 	 * make sure the target is already off when executing the test.
 	 */
 	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
-	aarch64_vcpu_add(vm, VCPU_ID_TARGET, &init, guest_main);
+	vcpu1 = aarch64_vcpu_add(vm, 1, &init, guest_main);
 
-	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
-	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-	vcpu_run(vm, VCPU_ID_SOURCE);
+	get_reg(vm, vcpu1->id, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, vcpu0->id, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	vcpu_run(vm, vcpu0->id);
 
-	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
+	switch (get_ucall(vm, vcpu0->id, &uc)) {
 	case UCALL_DONE:
 		break;
 	case UCALL_ABORT:
@@ -105,8 +103,8 @@ int main(void)
 		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
 	}
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	get_reg(vm, vcpu1->id, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vm, vcpu1->id, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
-- 
2.36.0.464.gb9c8b46e94-goog

