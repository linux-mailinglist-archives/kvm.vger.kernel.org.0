Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A043D53C1B9
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbiFCAuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiFCArS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B1937ABC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:29 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so3492499pff.13
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=O9z5OCEb467ZbVZHbJcf5IG27G4WEK+6SdTj7Frn6ss=;
        b=Tz/OHaQUbmHyXU0TwaoYO6G9b+QzS5uNfvu+PnqZBXh2jiDYGMlVGVSXlI/zA4BK3P
         JbkLgZcR40bDTJg3PfatF9G+MHQ4wOzcTOxG16BGeKOSpqrJyCsWGMJIcbWIu15zu6i1
         mnOPtWmB5IVs6vACFWM8J03rIWwOGUTMPe4wMoB219vX8dG9+qO/3oRPV8rypmyOy7Rr
         4LMgYQX+mzFkOAUBEcOI4nPvHVQ0GqQmGQDhNXsweoRz2LtOtiBEwebbpdGmBnOhZTUy
         Nv7L86v33kHybG5ro47jnCW4unPzBZxDPwkpI+cepaaot/iABX0n0aoa2uvS8SBiJGqH
         4n5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=O9z5OCEb467ZbVZHbJcf5IG27G4WEK+6SdTj7Frn6ss=;
        b=oVMUOjPr6o7vRtNq0ymNIlEOIT8EQwFbqdSE5sD3fNPSo5azFbe4Mv5vz8SdLbhWBt
         hv/mr3UVgRuRwfeVXNqvyyVmCzBrAKIryed2btK/ZI5eDxmq6MN8hqQyd2plBdBKSQnG
         FgfwOebeROsQ8H7dguYPGF2gyYNktrSNd2ZklokZz9BQXVabC2ps3PTjosR9LOW/W/qY
         OQKmDomSsv946OZ8EvktL7qix5Oa2i7J0f8yHlPm9z/fe3VeBdGabpy6z/SNpP6/Meqc
         kDqZqcDuN9N1N9ypXBkd1qJAB87D67tybFjNlEdnw/AF7rnt0jeo0A8Z/rBMpRTvzpb4
         xaMA==
X-Gm-Message-State: AOAM5305/zU7oYgyzDLgbQ9OMqLBZ/MKCOMPTc2NPz/4RCUAA2KsJ18q
        7sz1l7HXBNmF8vulcH4R/biAy4xUnTU=
X-Google-Smtp-Source: ABdhPJxDsx6UvBtsJofMNd1XygyxMgqxc64JFFMEkRk3vS9zTRqN66znWSgWelaM/nqAIerVPDfQz5zNaAI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8895:0:b0:518:9fa0:7da with SMTP id
 z21-20020aa78895000000b005189fa007damr7766436pfe.48.1654217188843; Thu, 02
 Jun 2022 17:46:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:42 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-96-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 095/144] KVM: selftests: Convert debug-exceptions away from VCPU_ID
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

Convert debug-exceptions to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c    | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 63b2178210c4..b69db0942169 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -3,8 +3,6 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define VCPU_ID 0
-
 #define MDSCR_KDE	(1 << 13)
 #define MDSCR_MDE	(1 << 15)
 #define MDSCR_SS	(1 << 0)
@@ -240,27 +238,28 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-static int debug_version(struct kvm_vm *vm)
+static int debug_version(struct kvm_vcpu *vcpu)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vcpu->vm, vcpu->id, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
-	if (debug_version(vm) < 6) {
+	if (debug_version(vcpu) < 6) {
 		print_skip("Armv8 debug architecture not supported.");
 		kvm_vm_free(vm);
 		exit(KSFT_SKIP);
@@ -278,9 +277,9 @@ int main(int argc, char *argv[])
 				ESR_EC_SVC64, guest_svc_handler);
 
 	for (stage = 0; stage < 11; stage++) {
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == stage,
 				"Stage %d: Unexpected sync ucall, got %lx",
-- 
2.36.1.255.ge46751e96f-goog

