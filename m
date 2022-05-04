Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7635751B2DD
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379705AbiEDW6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379407AbiEDW5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:57:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4429955372
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:51 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g11-20020a17090a640b00b001dca0c276e7so1316746pjj.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZW3w9xofgltN1neo0tjqm25A7AFY7+GoNG7TSvd2coE=;
        b=lzlYTUTL0Ftpdhwl2RRfG2+gvphI+IRrYXzHKvc5W9nY4Rf6Pz+ht4zScOf0lCunPG
         zJOaiFBKUk4BPf3fws16j4DRLYXLTBokezqVSzqBf98cOLJTbg9PIqz5c1MkcLK0ZwJw
         Frk7g1K1Gq0YAAGB5K+Ahqyh2mwcUgqf1B3rZpz+/4yIFrt0WJOkjADxUAG/QOYhbw9s
         wqeQnWoo6WCtXlIpCHdPCueQUbjjjDXaONuunq/8TkxTGH2DJf7YhNIXbZV0S+M+QuQI
         YFj1s7LfMQYCiWSziKghOSt0XzmHOeV3yF8N10bRtJrP2JFHkAGAs2/sZupMRIDBP4Nw
         XR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZW3w9xofgltN1neo0tjqm25A7AFY7+GoNG7TSvd2coE=;
        b=6G/paoNWo7kDri2SQLr7CKMDp2cx8bAGn9L+eFRlA+qkvl/y0qbakcR/z8gNSFH0ZJ
         CUOxcUOuSMr/qyakM3q1sdOy5Q67Kc1GKjB2cnjJEp7wJq6KkHkjW10upPxpPdV3R40P
         K3GKDh9N6mHKeQAShVG3APfRX6exg0JthLU69OowyuaDnXPB9H4iKLKWB+iUjlmfHLO3
         Qv8e7cYkWH23LWiaWmYLx1vO27eQvCTl4pZIHfhw0IObE/bBRw4itjR4v9SW4MD9eQhi
         UD2Qt2ixugdaMhHo6ep4bYGVjQD1Y9ddpSpPJ+/2PERmdd3cLE4GaC4TiI27vF0h/uGt
         entg==
X-Gm-Message-State: AOAM533Zqd4KKgPQCB3T7bBBfYd9YG8oj7NwiglJfu/VoMFBOlw/hLTc
        DcmWiSInJaz8KBO40XSyvgWz3kKE1Ac=
X-Google-Smtp-Source: ABdhPJweO1jeaf/s+FxYi79dpsM67S4Y8HecNdtHDW/Z3aKONSylH47HtCpMaOCyFByJU33x8S0GaHK1D0w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b94:b0:50f:2255:ae03 with SMTP id
 g20-20020a056a000b9400b0050f2255ae03mr7547957pfj.74.1651704709118; Wed, 04
 May 2022 15:51:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:26 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-81-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 080/128] KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
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

Convert xen_vmcall_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Opportunistically make the "vm" variable local, it is unused outside of
main().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xen_vmcall_test.c      | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index b30fe9de1d4f..1411ead620fe 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -11,13 +11,9 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID		5
-
 #define HCALL_REGION_GPA	0xc0000000ULL
 #define HCALL_REGION_SLOT	10
 
-static struct kvm_vm *vm;
-
 #define INPUTVALUE 17
 #define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
 #define RETVALUE 0xcafef00dfbfbffffUL
@@ -84,14 +80,17 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
 	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
 	      KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) ) {
 		print_skip("KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL not available");
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_set_hv_cpuid(vm, vcpu->id);
 
 	struct kvm_xen_hvm_config hvmc = {
 		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
@@ -105,10 +104,10 @@ int main(int argc, char *argv[])
 	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
 		if (run->exit_reason == KVM_EXIT_XEN) {
 			ASSERT_EQ(run->xen.type, KVM_EXIT_XEN_HCALL);
@@ -130,7 +129,7 @@ int main(int argc, char *argv[])
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-- 
2.36.0.464.gb9c8b46e94-goog

