Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3404C51B28F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379501AbiEDW4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379408AbiEDWyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BDD53B46
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g11-20020a17090a640b00b001dca0c276e7so1315998pjj.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bUwkxA0cdvDJSwzKR16x8oGgeZ9cJ1YyXWxtI8ySlZU=;
        b=Q9XMcbQSkXguTxWF3MEf4ku/OBqpn0w7sL1mKUfBb1uuig+w5KbUYaRtBp+aMlZVoL
         Vq6+rR9UQI9l6FJa5Ekrb+b7PdiwyE40Z90DyQtm7RdH93n7bK1c+4TmkvijW4f0Swup
         Wj5fOYLOPg/v2qdkyenLa3LET4wvIjzOMnE45hZCx1aSqrukltF+Iv5I4MFYUA5IUcuD
         /WMOle6itKS1HpE81y4qwu76lfMjDYJsZsAYdRGN6mbFxHyzd6d7GwHoH5Ku2EOiY/cw
         GQT2owanVlw9fCZGnoAijNm1xaSlxKxMB/rrGc8sQURIrE2HWr5S3yaGz6S9xVdfusbt
         Lmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bUwkxA0cdvDJSwzKR16x8oGgeZ9cJ1YyXWxtI8ySlZU=;
        b=IdX0XFd6E4t33l1ukpax48mvy0839PZfi3sJwjuDLp2Lontt9OkCO2ZwYdwiKMx5Rg
         8iobq3rsZMaP9UI41MYNeAG4vGgDinJGX2drVtIybvDfm+lpfoT8FDEcrcvIWyqGiQSp
         k9MCGte+FpmzJSk7aAAlj4J5lDcxEAbzJiYN3cLUfaJNmUlDgbIc9HreZNgxUW355gSh
         fmg679ee+wK4Rj0YmlHgU3fzSn0P3qmZtIRoyWtdxXGzWZFkZCaPzh6eiuj9AACZZeMt
         NPOklbQ3Lq1KiyfinGWLI8RJpDABE6zU/rbWWULTlyrN1IVHMxnRbMumBk5jiVlNWayD
         RJzQ==
X-Gm-Message-State: AOAM533GJBIiQ05OFFNbLqYEgu5uthd0YqLTADfPATkwRHiss3WA+jpQ
        FrjSKMEaviRuU2cNNManmDHef4x+790=
X-Google-Smtp-Source: ABdhPJx7MafP7nNnGcOg7F3OHo3XPpNcCxjHCM4oo/LLKpFrGq+D4B5dLGmxoAB3xrfrRkmrh1M58PzHZww=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8104:0:b0:50d:374b:4568 with SMTP id
 b4-20020aa78104000000b0050d374b4568mr23012688pfi.45.1651704662324; Wed, 04
 May 2022 15:51:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:59 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-54-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 053/128] KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
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
2.36.0.464.gb9c8b46e94-goog

