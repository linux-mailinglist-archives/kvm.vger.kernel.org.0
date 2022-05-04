Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC36F51B2C8
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379747AbiEDW5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379510AbiEDW4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:56:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF10155214
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i6-20020a17090a718600b001dc87aca289so1081595pjk.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qqoAeeErdsEhij0HQ/LNwRXxgCZ0knSRj2MksVXFRSA=;
        b=OO7xyAOZSwHZe3gwe1S/Px+5Qm/+w1z7XgGiIAWzmAO/YPyFEk8tL0+eZstmFYWtHb
         y3rbY/pEPtWfZlD4ekeQ9SDCXYR+qOoQqHdnObzQUIkTyYdu/TIIriVRC6GpLU4W9pUv
         jAFLvtw66xokP3ffnhVOSsyO2IswMHbAwTEZd3DJdvoL8iLo9WjOp6fijFMbAiq/8Jxu
         5uh9b4MonmsIFP9G+oUnjNiEQwLp2IWPp+kUSm/k1Ac4fl0Lt15UjyWDY/po/HwsQA65
         vItoskaiqVKc62gBiEHikOAYKxbYtgoHbVB6Aq9HBou4uyq9zBC/3VVyCQDXagZF8fO9
         yiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qqoAeeErdsEhij0HQ/LNwRXxgCZ0knSRj2MksVXFRSA=;
        b=e5rcUm47IYdBBS5CCf05FBEsJct8ttlviNKClTa5W4y+UDBKNdPxRbadWnAtqGK5QO
         G3kP3Z5EFDpEOGPp7GvWzytASK7D9OqHdCpUdsKyffL47b5xmVrS+uy04zDGEhFOAlpl
         7Blibfkakee1txaqfqplPePIll5LW6B96BrO3RVT3cSrQKHqeL5ghQX1GwlPSITmuObO
         f4hPmWKh6+UvHbOEQeocQSIWoBnLtAF2cGDrfk26hNmFBhyOkmtSXDadWTAws5hD9gry
         JmCzF3DvOfKaHPzC3CJy6KdYKzXpbzYLglamsXwzvsFKloYHTMXwc04Oe52mof2TESGM
         3XbQ==
X-Gm-Message-State: AOAM533JlNa8uIWuf51pD45u/oNU1hx6u8nh1kLBbQRDGH9i/iR+EiOL
        /W23K8J3xf2uSCPC3k1mYLIrbk+BOZM=
X-Google-Smtp-Source: ABdhPJyfA+4PQaBNp1bqa3kM6KRVv2I33LLNv9lu4lg/WAN/JXYMWLW25+dHX0/mRv51r5L3jsCPxGnUpxY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:f307:0:b0:3c5:74b3:1b72 with SMTP id
 l7-20020a63f307000000b003c574b31b72mr5359471pgh.120.1651704702065; Wed, 04
 May 2022 15:51:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:22 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-77-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 076/128] KVM: selftests: Convert cr4_cpuid_sync_test away from VCPU_ID
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

Convert cr4_cpuid_sync_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note,
this is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing non-zero
vCPU IDs is desirable for generic tests, that can be done in the future by
tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c  | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 6f6fd189dda3..d5615cd0b81b 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -21,7 +21,6 @@
 
 #define X86_FEATURE_XSAVE	(1<<26)
 #define X86_FEATURE_OSXSAVE	(1<<27)
-#define VCPU_ID			1
 
 static inline bool cr4_cpuid_is_sync(void)
 {
@@ -63,12 +62,12 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
 	struct kvm_cpuid_entry2 *entry;
 	struct ucall uc;
-	int rc;
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -79,25 +78,23 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			/* emulate hypervisor clearing CR4.OSXSAVE */
-			vcpu_sregs_get(vm, VCPU_ID, &sregs);
+			vcpu_sregs_get(vm, vcpu->id, &sregs);
 			sregs.cr4 &= ~X86_CR4_OSXSAVE;
-			vcpu_sregs_set(vm, VCPU_ID, &sregs);
+			vcpu_sregs_set(vm, vcpu->id, &sregs);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("Guest CR4 bit (OSXSAVE) unsynchronized with CPUID bit.");
-- 
2.36.0.464.gb9c8b46e94-goog

