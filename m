Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34ED53C254
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiFCAsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240273AbiFCApn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:43 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D7D37A35
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:38 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so3480059pfa.22
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oaxRJdvupESB0wCWTL2diaJZxgDjRKfr3rKjINqjwJs=;
        b=DH7KAtCboew+L7WLe2pnfz5NPC7KhGMaC1C4VYHOn8x1wG0CGKk2jQdGrah0D1Lg6D
         PV3x95awiGeknRxCe2y1HnTgO6ejQlqHB0FS8xRc5Lr2Lf1SmhVnGXlWlgR+PkxQwkva
         B2w+Tj/VHYV4f7YqsALY+JqfEcZXtysYzMxwPBgFo0eQRTzW9RbaOeP3zW5tqKaY5W1A
         ugwreSKSQ3GtQvpLCcGvZ+ctzhQEsDuM8pnD9nSn2VfWTjCm/iyIZ6JWqbiLSJ8BxbPW
         efOvG/n7fCCKmZVk1ui4n5mzead2RLcuFDbhaQEZ4c8WeaXzYUYFTvAXJ9xDyrG1Szna
         A0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oaxRJdvupESB0wCWTL2diaJZxgDjRKfr3rKjINqjwJs=;
        b=shQnzhKtKlBD7xb3NsCIxsU7eX+Dt+Y/2p9YAdhIJs4PMvt/H4DsMUZvjKsa+3jlxU
         KzrwCjBpx8Ny4ZQscN25VYAq3Uw57Lk7xvGoJwnA0pOC9bKEbMO8P8gCw/Q9aMxgj8QT
         tfDLc3whfyHQTSyIkBRwrOwApm121LivAq8j5UfLKIXBBm+NnUhbRezaKT2Pf2WLbKoo
         MSN1VjQ/7Jdb8rZ0xSaXSTs1QykOtTKR3fR18avBiJFJp5XQXbiu0id3EttjL+Z5EbiD
         DQfb9fwIsKiS6sWfGbZcBvJTzcDkna2w8k3K/EJ9PeHl/IpXF76U2YjTV/X23T/2lsCy
         S32Q==
X-Gm-Message-State: AOAM530oqhSVQhwZHT3c1Lyimx4rZrXPoqMovH0ecEQWYtrIPLEmQRf6
        yJP1Rcays+OrXSjb7AuiD8RfYXe8zr8=
X-Google-Smtp-Source: ABdhPJwq+GXa3GRW0uUpp8GrUHUGP55WKvCVhbCyJ/xvFO0jgXp7ECaVuuk3B9ktD184it8IqdTChA8nv5U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b90:b0:1e0:1b0:1a1 with SMTP id
 lr16-20020a17090b4b9000b001e001b001a1mr43502507pjb.70.1654217137515; Thu, 02
 Jun 2022 17:45:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:13 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-67-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 066/144] KVM: selftests: Convert platform_info_test away
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert platform_info_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index e79c04581ca8..eb5e1f972d76 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -21,7 +21,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
 #define MSR_PLATFORM_INFO_MAX_TURBO_RATIO 0xff00
 
 static void guest_code(void)
@@ -35,18 +34,18 @@ static void guest_code(void)
 	}
 }
 
-static void test_msr_platform_info_enabled(struct kvm_vm *vm)
+static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, true);
-	vcpu_run(vm, VCPU_ID);
+	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, true);
+	vcpu_run(vcpu->vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			"Exit_reason other than KVM_EXIT_IO: %u (%s),\n",
 			run->exit_reason,
 			exit_reason_str(run->exit_reason));
-	get_ucall(vm, VCPU_ID, &uc);
+	get_ucall(vcpu->vm, vcpu->id, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
 			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
 	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
@@ -55,12 +54,12 @@ static void test_msr_platform_info_enabled(struct kvm_vm *vm)
 		MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
 }
 
-static void test_msr_platform_info_disabled(struct kvm_vm *vm)
+static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
-	vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, false);
-	vcpu_run(vm, VCPU_ID);
+	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, false);
+	vcpu_run(vcpu->vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
 			"Exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
 			run->exit_reason,
@@ -69,6 +68,7 @@ static void test_msr_platform_info_disabled(struct kvm_vm *vm)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rv;
 	uint64_t msr_platform_info;
@@ -82,14 +82,14 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	msr_platform_info = vcpu_get_msr(vm, VCPU_ID, MSR_PLATFORM_INFO);
-	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO,
+	msr_platform_info = vcpu_get_msr(vm, vcpu->id, MSR_PLATFORM_INFO);
+	vcpu_set_msr(vm, vcpu->id, MSR_PLATFORM_INFO,
 		msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-	test_msr_platform_info_enabled(vm);
-	test_msr_platform_info_disabled(vm);
-	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO, msr_platform_info);
+	test_msr_platform_info_enabled(vcpu);
+	test_msr_platform_info_disabled(vcpu);
+	vcpu_set_msr(vm, vcpu->id, MSR_PLATFORM_INFO, msr_platform_info);
 
 	kvm_vm_free(vm);
 
-- 
2.36.1.255.ge46751e96f-goog

