Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5D853C2BF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbiFCAup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiFCAqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E913464B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n3-20020a257203000000b0064f867fcfc0so5569735ybc.15
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dtKn/1s6u0G58r1neb2YaJY76UbcP9qLfe4/PWDPKHo=;
        b=QFictB3WUVf3oY4ZmSCgbstv+sdSwlhQ5B7U1hGi/9zuadjzT1Xx5n94oX/koHEYlZ
         whqOnKEMmeHpb4hcvnVhgWQOusinfN3KSiYJDrhaJbEOQ9wSIZC/6KjuB0I/699VoHB5
         KK1MOWomPfMYVg1R2GpYOvsjiJ9IVSBvFQU6qNPm+LmQMxtTXonntAVFirhDscxJfrtf
         gOf0BK2IebQJWInCgl+LoJaDHrlOK8bprkJIbE5jrI8bpsODzivg9QKgRbSIU/Ukx1N9
         nJy0fnWfTs4modFsPpor1iW9aqdvO8LQOfb9Dy+HLuegZy3UImsKZLHjPlLSSrYoLKYL
         at4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dtKn/1s6u0G58r1neb2YaJY76UbcP9qLfe4/PWDPKHo=;
        b=UhavBaMrvU3KIMJr5MFcq45p15v767Uco76ev/UJDHJSfzVVont4ESMSypg/vAp6rb
         NeiSTCChjV82Y2VkUns9r8KABd5NNAHg2orNo8WfAGGUIVUBPE9aR5u27OEgXxr7wjtI
         2pzBG6Nc5zTeOMkW1FGPxbxMpG6GOS4HVQw/La8SZ/XJyBFXZ1RyIQ/Ik0i2BdyiXQZv
         /mUKaWm82bY6VcWoxLyLJjWu7LEXhOQnqKtcbX2Ll69+wEcy0Hxtv9OqOvTbs6sGYFDj
         Ay8+5Dzqs2OAyX3m6a7a0P0GxaPZUz7JiKVo9qgieiNI2gCFDGhZ6INUijLr78ucGLhs
         Zxsg==
X-Gm-Message-State: AOAM532SDcuRSVIbHNtkzyN0IjwjjupvrtrMHnaGZiB+ojmDY13Tc17N
        mJBqPX8cNdeFvdgr67llJ8rvuptii90=
X-Google-Smtp-Source: ABdhPJxHTnxlNfUb+1pMM1jvfC18BkySL94v0dyAd23wbuLKDoSwUam9Q8WUem1lRxG9QhNBAZv+X37cFUs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:5f50:0:b0:65c:bf1d:25fa with SMTP id
 h16-20020a255f50000000b0065cbf1d25famr8919268ybm.60.1654217155121; Thu, 02
 Jun 2022 17:45:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:23 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-77-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 076/144] KVM: selftests: Convert hyperv_svm_test away from VCPU_ID
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

Convert hyperv_svm_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 994b33fd8724..b6a749f5c766 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -21,7 +21,6 @@
 #include "svm_util.h"
 #include "hyperv.h"
 
-#define VCPU_ID		1
 #define L2_GUEST_STACK_SIZE 256
 
 struct hv_enlightenments {
@@ -122,6 +121,7 @@ int main(int argc, char *argv[])
 {
 	vm_vaddr_t nested_gva = 0;
 
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
@@ -132,20 +132,20 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_set_hv_cpuid(vm, vcpu->id);
+	run = vcpu->run;
 	vcpu_alloc_svm(vm, &nested_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+	vcpu_args_set(vm, vcpu->id, 1, nested_gva);
 
 	for (stage = 1;; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
-- 
2.36.1.255.ge46751e96f-goog

