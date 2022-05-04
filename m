Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B1951B355
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379507AbiEDWzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379543AbiEDWyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:25 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375464C796
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f7-20020a6547c7000000b003c600995546so781288pgs.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ptWOSYHzrTU7MJFi2fvY7/zIwBOxaD6Vf2Bdw3uHKKk=;
        b=KUe8HCAq6O3QNcnhA9v1kGE+Y6kKKZrWfBiV1a9o4tYJi02H+64BAKUBSIgVbo/KwG
         Tl4F9QhCdudF1MjPKFiNnoOMphte7KbcTKGzIVnNL20oRTqN+AEIoZYroo/lmSZG/m55
         dLiXcj9BxysHLvVKodr+FPdY+bnyJbQJdLPY2Wm9BPuF2aj+s4oydVcXf4oS++ciAOIV
         WUu6kLPBSOuKq3k4uZohyL5atPRSHQCHEGufKDdsKOTQCk39y3hkfwfH39R9ryghVGx9
         s3PDOe9X3DDklsR7qVU/+Hfb807ojPraaxPgP28uswHeBchSwJB54fdOolapGYC5wajP
         OT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ptWOSYHzrTU7MJFi2fvY7/zIwBOxaD6Vf2Bdw3uHKKk=;
        b=V7CoshNYk14VPEMZZeE6vuXK+BRB9l84qrplr3wHk90G3WuhDC7O+m7svVwsZnxnHf
         s0DCaU/7vOXsyjI/n1uskViQcaN3lZZi0qYecCdCC4qVL/7c+FPCb0dx1yqWZ8LDHgnF
         WXolp7MAIw+vcNB66fk8qYTeOTuWb9CInfjkhB7HSdptTu9EV64qcy13+Hdk+VkSat3s
         Cp5p0cowbNJULNM23hT/h9I9Kl8gj4I/T538g8RhhsTVwt4ZM7Cxe1zYyx5dAc3WKgll
         e94+z289SFNs3iCOIUJXmo4zz+RYykR9i5PzA9mTBwg477pzl4jwoIaDO+n0v2yOINJE
         Bskw==
X-Gm-Message-State: AOAM531JJCBuOkZjdwVowaT7rnRJ8AdWxEpqZFaGVYCvnBmcF+jjlmbW
        pjfq8npit2ds6U6K+EA2VbVYxGBwzak=
X-Google-Smtp-Source: ABdhPJyO/YfL1S/F8SR1KX6H4Dvbn1ASMgETH9bl9hc1568+78A7gB6ODpKjdirnFHvLlTlj4JhUYGN06OA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:22ce:b0:15e:bd57:5bec with SMTP id
 y14-20020a17090322ce00b0015ebd575becmr8645899plg.114.1651704647710; Wed, 04
 May 2022 15:50:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:50 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-45-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 044/128] KVM: selftests: Convert xss_msr_test away from VCPU_ID
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

Convert xss_msr_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 3529376747c2..c5672d2949db 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -12,7 +12,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define VCPU_ID	      1
 #define MSR_BITS      64
 
 #define X86_FEATURE_XSAVES	(1<<3)
@@ -40,11 +39,12 @@ int main(int argc, char *argv[])
 	struct kvm_cpuid_entry2 *entry;
 	bool xss_supported = false;
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	uint64_t xss_val;
 	int i, r;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, 0);
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	if (kvm_get_cpuid_max_basic() >= 0xd) {
 		entry = kvm_get_supported_cpuid_index(0xd, 1);
@@ -55,11 +55,11 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	xss_val = vcpu_get_msr(vm, VCPU_ID, MSR_IA32_XSS);
+	xss_val = vcpu_get_msr(vm, vcpu->id, MSR_IA32_XSS);
 	TEST_ASSERT(xss_val == 0,
 		    "MSR_IA32_XSS should be initialized to zero\n");
 
-	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, xss_val);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_XSS, xss_val);
 	/*
 	 * At present, KVM only supports a guest IA32_XSS value of 0. Verify
 	 * that trying to set the guest IA32_XSS to an unsupported value fails.
@@ -67,7 +67,7 @@ int main(int argc, char *argv[])
 	 * IA32_XSS is in the KVM_GET_MSR_INDEX_LIST.
 	 */
 	for (i = 0; i < MSR_BITS; ++i) {
-		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
+		r = _vcpu_set_msr(vm, vcpu->id, MSR_IA32_XSS, 1ull << i);
 		TEST_ASSERT(r == 0 || is_supported_msr(MSR_IA32_XSS),
 			    "IA32_XSS was able to be set, but was not found in KVM_GET_MSR_INDEX_LIST.\n");
 	}
-- 
2.36.0.464.gb9c8b46e94-goog

