Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767F451B2D3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244398AbiEDWz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379576AbiEDWy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A46541A0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:13 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d64-20020a17090a6f4600b001da3937032fso3565195pjk.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KStJxbQXxEW7Z2FlFuAOa9BN6coGSiFbzvl2Gq1jN2A=;
        b=RNWe0l2kZGk/kFvcdyuQ07vf5mKrt91fj7IDzGGEeR6I0vwlWCLP3/rpyg5lhqL5HF
         bLOy2cYQ9yJ2Bh+d28jACVLlQBb9bdZlyq6W6deya+151Y0s+8w+fTAWW9GlIbB2GcYU
         jcQ4cAGpwQSVzX17ZbhWGp1PFtYU/BvMHXkrGUl71ejYC1UA2o8btqp2JD+DfPXjTtXQ
         izMgY2OuM00z7nr6WdwhusgS/TV9E7NhS4SbV1z6bDk/HY2HPA00jy0w6lCa2zg9JmeN
         C+SrOqcq2gSd+EVDZMjqcTj5kzIES7thFUr3dNhD4uonM0Rkmuss/ajk1pxxQedAzjqW
         DEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KStJxbQXxEW7Z2FlFuAOa9BN6coGSiFbzvl2Gq1jN2A=;
        b=HANEqzUVm0SUNxlggWlQjvnKZ0FPiZ8LJ/GqyRRuJPEtYwo/XphyaEcj5GB9bBCcAM
         RKxBs5XE7fXHvS+rqamRmNw+7ZAvTIN/NvyIjZGjOgRcDCt4NinXknncwa6K17S+8NH3
         eFYwuRGWbVMpuoV2S+ti1BWoHksR0rHm3x2hFdxLloL2HhJEiajncnG3hLYYKDVG1Nli
         YVJJPPs+jlcOO8xPKeg0GHtmpgI/DcfinOtk3Bo5Zfr6jpjAQNJmhPf2vu10NvyKdTVo
         uIxl6rsMPG/tF5ki4dLReKrc2MiCzVkSzyNhOfkfz2+3adClk4MlVOAGK7mvySCnk2VM
         P5iA==
X-Gm-Message-State: AOAM532aBASsHK4CK0Tv3X2XKqZ6kmj8wqCrDwAVWm6cZpObGwmvTC5o
        yEriL4yttBvG3W2invtkVFxammCYBFo=
X-Google-Smtp-Source: ABdhPJzEtY/7+wJ/MQgg8J1pYdbI3+lPeKCc+mHMAIUN6USXpmz0DNrEs9cuBBszzAbI6MsLHGVgKP+UgUw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c7d2:b0:1d9:34fe:10dc with SMTP id
 gf18-20020a17090ac7d200b001d934fe10dcmr2214850pjb.109.1651704672704; Wed, 04
 May 2022 15:51:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:05 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-60-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 059/128] KVM: selftests: Convert vmx_nested_tsc_scaling_test
 away from VCPU_ID
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
2.36.0.464.gb9c8b46e94-goog

