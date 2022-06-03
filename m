Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9D53C248
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbiFCAtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B559237A3B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t2-20020a635342000000b003fc607eb7feso3039502pgl.20
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VJrVHzCEs42CWM1dqRRF3PdVfPPmzEFc68MwMgn9Z6Y=;
        b=Kg2OlBraLmkzaiubrmk79tXApvgk07Xo9aQqShCo+m0cIjfomV+BI4I/F2f86wqwBp
         IwTG8opJoQ/H0X3y3vCTMM/ulAFoamo/zkpOXKeB4PsgF3jOH+tJdKVoboWCm9Ykjq4D
         wjnVY931fs6jea+OZffTg65+55nMfVE7yKcYqQUMEgFttqTi5GQBaILdYenUfR8bfmUg
         GB5ZPJ860EIyjJUhPom2xyLzRRm9coVs+8pdwBDTFJfwVlmystwSZzpHNmY9IL06KvDw
         dh21cEz0OAqxAQ4i3MzCVtrFjqv67QOlpwOffGZsbk/B1+FuxKEHgUTg1s2DJThXkoKA
         HNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VJrVHzCEs42CWM1dqRRF3PdVfPPmzEFc68MwMgn9Z6Y=;
        b=Zr96Wa0T9qiKZCPsL6A/4+JaXdQFqObZJQjC3ZQQ4nPEiPHjnUMWDqMD9dGq5Onqfs
         03gOxPxziucnS5AtRpFP240jXEMRurkLalEUI3C4gVRbVTM7kRnpizBzQss3kZ1UF+DJ
         FN+2ed/YdXqIj30TNgXkW2GFjTDV7zFAaIt3iHPJLlrKLHgfoKnNX01uMc7W9LoH2tAw
         QiYFBBPYsUwPQ9C4w1v2nY01vQ2Ek42PSrl+YWOErYNe9aFzaGBcme7ebUTWzN6Xhoiz
         vKPWHe1y7ASsIAxGqCKIIBGJsCksf/l7mFOEosiDbkiUfdbUxgPnKOwG1MZeHoHUwc/r
         f7Sg==
X-Gm-Message-State: AOAM531rYvPE+hUr/bimlAEOkCvUShvldKYjXqdVs055OeuSyfk5YwSS
        /xEoHYHdyQZZA0Jkq1MhatYRnfKzi9M=
X-Google-Smtp-Source: ABdhPJy1+LnuXl9A5kyJyIIplzogHTvrDpj16Qpa5BG9VXOtM1Qykdg+tYr6Rc8KfhxkOTxwc4EyRANndzo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea57:b0:15a:6173:87d6 with SMTP id
 r23-20020a170902ea5700b0015a617387d6mr7395649plg.104.1654217176214; Thu, 02
 Jun 2022 17:46:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:35 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-89-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 088/144] KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
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
2.36.1.255.ge46751e96f-goog

