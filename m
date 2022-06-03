Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BE453C1C0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbiFCAro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240248AbiFCApm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:42 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065C634640
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x18-20020a62fb12000000b0051bab667811so3499606pfm.5
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gf/3WhosbDQbquEXufiQCNkkI21LPU8IPD8LLf4fW2Y=;
        b=lo4OOYCvQW7cm2iGxp4LKBtoa08BgZBY0m19rWQAblk7OGnGy2jl08abC4D1pP7FG/
         p+WcbDfg9bDRNs/C4IssiE34ZkhnMPoTLv0tzr5xHv8deuRyM+lJYhWvf3GGgcEDxMfC
         Va0ZCv04BSeArHdcHwa6Excv4+f33n7lxC+dCCGWod/Y7cikTUT/5XlgLQZLIiPFdluW
         UxodvfQSv6oi7HOVM5aAx0Xbe8hq3+u1ox8gxiBe0rhFF5qDibtUyQETreTOWwCrBByK
         6L9Yv+83y/3Xy1KHjbcjZr0KRO6R6pJ+APXfO99q4SA+AhR4EYJnyOBjquOJbWn2ljUJ
         G/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gf/3WhosbDQbquEXufiQCNkkI21LPU8IPD8LLf4fW2Y=;
        b=5NGHaLo+2uXw/d24PqD+9cqRdPKSomiOT7SP4fFLnV71Ofe4lqmtCYm1tvLZglRjwn
         pZEYp+uFDWoOAocSzqrjkdX8LrLftNwMO47MlQgFD+blrlyuu0o2KmKlaaRd313Fj1mH
         Ym3rQ9x3TLQEq0q/uLb0WJBDOwMXzwDbxm02lFLTRcJhv966ipd5Jh4KJNPNqmFyK4ri
         0OgB09Mg+d1IkiLvu7XLmi4YvJ6HlVEcmAGJu4hYLIcIIXgJYnF3B2WHYtLT0/DcvTZF
         9RMoUylsplFh5i600bfXumHs8bSRjfrpE2ENGpvWChzB2TU+zNm10XSGgqxbkqZ5T39d
         gbqw==
X-Gm-Message-State: AOAM532BF9UpzNJ1FyodUExK2XVcOMjFClND6M37Ocls5pD53bmvmSVK
        KboIfrLPCPHwatdy57Nludjadvz1eAI=
X-Google-Smtp-Source: ABdhPJw1/eDHJ15wxdmCPCvmG7oAvpHelnw0d7hSZRApBhMwLuP/pDmmgEO2WoL0xcIIJmAfrSUuc5+jWCY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:44b:0:b0:3fc:cd1c:49e8 with SMTP id
 72-20020a63044b000000b003fccd1c49e8mr6628197pge.172.1654217128469; Thu, 02
 Jun 2022 17:45:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:08 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-62-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 061/144] KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
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

Convert svm_int_ctl_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically make the "vm" variable a local function variable, there
are no users outside of main().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
index 30a81038df46..8e90e463895a 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
@@ -13,10 +13,6 @@
 #include "svm_util.h"
 #include "apic.h"
 
-#define VCPU_ID		0
-
-static struct kvm_vm *vm;
-
 bool vintr_irq_called;
 bool intr_irq_called;
 
@@ -88,31 +84,34 @@ static void l1_guest_code(struct svm_test_data *svm)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
 	vm_vaddr_t svm_gva;
+	struct kvm_vm *vm;
+	struct ucall uc;
 
 	nested_svm_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
 	vm_install_exception_handler(vm, VINTR_IRQ_NUMBER, vintr_irq_handler);
 	vm_install_exception_handler(vm, INTR_IRQ_NUMBER, intr_irq_handler);
 
 	vcpu_alloc_svm(vm, &svm_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
+	vcpu_args_set(vm, vcpu->id, 1, svm_gva);
 
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
-	struct ucall uc;
+	run = vcpu->run;
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vm, vcpu->id, &uc)) {
 	case UCALL_ABORT:
 		TEST_FAIL("%s", (const char *)uc.args[0]);
 		break;
-- 
2.36.1.255.ge46751e96f-goog

