Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1053C319
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbiFCAsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiFCApn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B322A37A3A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-310061f47faso12885487b3.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=p5UnJnS91vtMeaDHfsKiSMs+oHMFzkeSZWyIST+FoDs=;
        b=MCzDWUUIyEucNE3hHClXNVFR+5T16668b/7sJY354niuYd9tJ+pJGguoP/lsDm+DIv
         PvVDe5NMToy4SVCDeJayojCjQMadqJGRpUx0TEwUCy3hAm1XNQT3GNLjZ9bIEJPeHc5r
         5ja27gOz3o+2HyeyyE7VXqq4VGOm+/gH7SGyPLtSlB14ZPyqnRd6/S9DdpgnojeQa9v7
         6gymSZFmDi/PWFvEMtStOpSTl6BEMZfDFFP0Gw8uyljHq1tIiZegIaY12IOxIXtcSe5Z
         NvqFT6G+fWK9abnplIW+IjENrgrfCcTJKwqOHhSBf9TIY67rO5qVueYN3tpt5UJ08o14
         p3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=p5UnJnS91vtMeaDHfsKiSMs+oHMFzkeSZWyIST+FoDs=;
        b=VxaJOh2PmAfiTHWuDHogH4MQOI/kjxtf8EW9+N2XAauHSiFzdIqJN7VLF3/eMCUiT+
         Sn9r6TMLfthryRD4FgX1+3Z2xy0E0Jup9r2HfZOYoIiul7MUMDNtZd1NtSB4zbpIMnFa
         AgX9DUleF2aXCLhgzIcge/Fz/sqxnzomzdGVfwN/wBy5DRQoiI0uwMJYt+Ysp5AG29lZ
         x31X59vw/E3116SunvEX2Rsarlg8Kzb4Y/7+TdGrWUOynY5+C3kOcYGyaGaCSKeEkVol
         GwVUERIFRpsqbZO0nYpnLUHO34H/RwWEroeLn7pQPIyaSYAo7HLysS6y2f30eKw3rrmm
         4g+w==
X-Gm-Message-State: AOAM531qPeXjmiA+eo8MlFcveiaqqN4Y4rPHZc8R2XwyVd3dHjCqVC61
        Lx4iqh31/z0gE0krc2gVCeoWUjHjyi0=
X-Google-Smtp-Source: ABdhPJwXM6K3Fp/k6RSfRwXWNXYpy2b/QfQ/DRwi7K/ni2ZE5YgEHkLLhGWffJlbhFMAoZiM5HNlCvorPh0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154b:b0:65d:2be4:cfa2 with SMTP id
 r11-20020a056902154b00b0065d2be4cfa2mr8875709ybu.236.1654217139425; Thu, 02
 Jun 2022 17:45:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:14 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-68-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 067/144] KVM: selftests: Convert vmx_nested_tsc_scaling_test
 away from VCPU_ID
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

Convert vmx_nested_tsc_scaling_test to use vm_create_with_one_vcpu() and
pass around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index c35ada9f7f9c..c9cb29f06244 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -15,9 +15,6 @@
 #include "vmx.h"
 #include "kselftest.h"
 
-
-#define VCPU_ID 0
-
 /* L2 is scaled up (from L1's perspective) by this factor */
 #define L2_SCALE_FACTOR 4ULL
 
@@ -150,6 +147,7 @@ static void stable_tsc_check_supported(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	vm_vaddr_t vmx_pages_gva;
 
@@ -182,28 +180,28 @@ int main(int argc, char *argv[])
 	l0_tsc_freq = tsc_end - tsc_start;
 	printf("real TSC frequency is around: %"PRIu64"\n", l0_tsc_freq);
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
-	tsc_khz = __vcpu_ioctl(vm, VCPU_ID, KVM_GET_TSC_KHZ, NULL);
+	tsc_khz = __vcpu_ioctl(vm, vcpu->id, KVM_GET_TSC_KHZ, NULL);
 	TEST_ASSERT(tsc_khz != -1, "vcpu ioctl KVM_GET_TSC_KHZ failed");
 
 	/* scale down L1's TSC frequency */
-	vcpu_ioctl(vm, VCPU_ID, KVM_SET_TSC_KHZ,
+	vcpu_ioctl(vm, vcpu->id, KVM_SET_TSC_KHZ,
 		  (void *) (tsc_khz / l1_scale_factor));
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *) uc.args[0]);
 		case UCALL_SYNC:
-- 
2.36.1.255.ge46751e96f-goog

