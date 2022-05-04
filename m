Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB151B291
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353877AbiEDW5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379464AbiEDW4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:56:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC555232
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b33-20020a25aea1000000b0064588c45fbaso2269823ybj.16
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YDkhuD1tFveY1Cr6YZonD42KIh1P5gqeU9XwbNgB5as=;
        b=MlFD/eduoV76Petw58QkIbmSLj8MGKYaxEizrcED6ibzh5AkLLDmITURZ7CcQ+3Fnr
         39JcQTP6IvuPEoypiIYs1LgRDR5CwGTrTkwfyvH/mddjfrjKBz/y4NQgYc1GRdLEcamG
         zKWcpLWxxbmLn0YZld5sihVMbhHVFhBxodUnahm4tJbL08Zn4N2NZisk/4aLayvqKoE1
         uw4VPH2uGIcNS9n1RhE2BGo4b0qXBY2YOc+BuuwCsM3BTeXKCF2t0qGJgKeRxftpbYz6
         MEabaDJ7xCpcu7DXlekuAMrk5bXyigmWoEXl2NTvHkZxhoomwfaJihhUFhFebEU4sS4x
         CGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YDkhuD1tFveY1Cr6YZonD42KIh1P5gqeU9XwbNgB5as=;
        b=18FkP5LEtfdprnTTIRV6hBwXhNh3+ki+4WSjR+QXAMxpr8hNr+tG032zvAYMkl8rGA
         DAwAji+t4N3w3mVSdqwQ2cDRX3/JbpaIeTq+tbgn6cciOlIpAYyDcLuddNgfwaHFSd/9
         M2uRZ3iCNunqJPHp2wOeos9LN9156o0fjB0XDbYM0fv5Ja03p+FPNjSd/lmZYJQonl5z
         LKhvpYUZW1bAM6WA8obj3uWP91/POk7EZ3W2/9ZLQ4zLnt7k4G7ZdzSq6FaoFFuaWGBd
         BnlySiJblPS2d7Yb0klsNgjDUOpNVSQkefcJr8oNl0+EkHPEaZRBIJZ1nDlkBvjM6okW
         dXsA==
X-Gm-Message-State: AOAM532at2eGqyGY1mdKpeRFYtUapi+YldHHawZKVXbzZJJRBb7jQk/I
        JZet2+E7sf4dNe7D7dAxtiOLn3l0u9M=
X-Google-Smtp-Source: ABdhPJxX9UoaDQsOrATTVVBZXQnxE+0nAJP4PFl/N1BeuX1eAuqaZY8tlLrR2KDi+DRcUDfUhmJ61RVz4DI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:84c8:0:b0:645:6f45:3854 with SMTP id
 x8-20020a2584c8000000b006456f453854mr18427962ybm.608.1651704703893; Wed, 04
 May 2022 15:51:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:23 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-78-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 077/128] KVM: selftests: Convert cpuid_test away from VCPU_ID
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

Convert cpuid_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 16d2465c5634..76cdd0d10757 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -12,8 +12,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
-
 /* CPUIDs known to differ */
 struct {
 	u32 function;
@@ -118,13 +116,13 @@ static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
 		check_cpuid(cpuid1, &cpuid2->entries[i]);
 }
 
-static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 {
 	struct ucall uc;
 
-	_vcpu_run(vm, vcpuid);
+	vcpu_run(vcpu->vm, vcpu->id);
 
-	switch (get_ucall(vm, vcpuid, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
 			    uc.args[1] == stage + 1,
@@ -138,7 +136,7 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+			    exit_reason_str(vcpu->run->exit_reason));
 	}
 }
 
@@ -154,21 +152,21 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 	return guest_cpuids;
 }
 
-static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
+static void set_cpuid_after_run(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 {
 	struct kvm_cpuid_entry2 *ent;
 	int rc;
 	u32 eax, ebx, x;
 
 	/* Setting unmodified CPUID is allowed */
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
 	ent = get_cpuid(cpuid, 0x7, 0);
 	ebx = ent->ebx;
 	ent->ebx--;
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(rc, "Changing CPU features should fail");
 	ent->ebx = ebx;
 
@@ -177,7 +175,7 @@ static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
 	ent->eax = eax;
 }
@@ -185,25 +183,26 @@ static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
 int main(void)
 {
 	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
+	struct kvm_vcpu *vcpu;
 	vm_vaddr_t cpuid_gva;
 	struct kvm_vm *vm;
 	int stage;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	supp_cpuid = kvm_get_supported_cpuid();
-	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+	cpuid2 = vcpu_get_cpuid(vm, vcpu->id);
 
 	compare_cpuids(supp_cpuid, cpuid2);
 
 	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
 
-	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
+	vcpu_args_set(vm, vcpu->id, 1, cpuid_gva);
 
 	for (stage = 0; stage < 3; stage++)
-		run_vcpu(vm, VCPU_ID, stage);
+		run_vcpu(vcpu, stage);
 
-	set_cpuid_after_run(vm, cpuid2);
+	set_cpuid_after_run(vcpu, cpuid2);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

