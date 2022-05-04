Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7C51B327
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379655AbiEDW5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379590AbiEDWy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B78A5469E
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l72-20020a63914b000000b003c1ac4355f5so1350726pge.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2DvNe/lVFNyApVfFfANOn9Tl2eup4/lMIPjudKEr87E=;
        b=o69HCDL7L9y8N0yXFyFpmsfEDs+XjEl+RqsLX0QxYAyFgoQ/gQpxJJwCaGcrOwnrJV
         /pnkDNL6od9ie1odmUGrQ/GAa4VUq9PP5qGq1ZFH3VWyFFImb7RCVE6fxVzSDek89Tzj
         ytHWpZxsOTYtrUpgOG6rmkFI7Gpi4+k0RtqJTzvqSbpnqBoXL5+64l2u+fBVqwPpYGIZ
         nBrMn9gsmJXWwltJVhYyCKazDyY5z2kG9U7Y+nz9S5vv3xBel+PYnD+aVVnX621qBxt9
         83IJqZu4XNgo/OdwXzYT59EdMkbFc87T+XEM2wdg6IkA3OV5JVil+mE1THBIjQa31D87
         fPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2DvNe/lVFNyApVfFfANOn9Tl2eup4/lMIPjudKEr87E=;
        b=netUGJtmk86YcDsQob+L47aZ2jSVgg8Co0I818+diCuz/DMOLjkrXEuOgLFXX6kWb9
         iuNJcwoQk3jQqGKeH76HZ9D1Twn84XSOvXEFoEWSXK1d7CtW2XVpqtSPzgly2FLkeqA9
         cFmo6uurb47rMwMI90EvZt08dBnhQqpKGdw2MkXX5vYw0BxY/iP84XG9hjLZB+hKa1Fo
         ajEgAebgw10c24MCzgaDrKtSTl0LN4QbeW+Xfw1+Fm0/fTgb3tm0SvJRhgYvXGkPcv4X
         ko1ZOwVq1AR7oEVv075GxV28QimldE9PrReSAcGh4ANIL31LHtto2mGi4JsUsxZCrOcl
         ZAoA==
X-Gm-Message-State: AOAM531BWA8Kd1S7IWpGpNgI1F3zzU7rLzAQh19tymb86xj/F1kDco48
        W4IYg5nRTMM9Ut18Vu3Bu55PolmdfD8=
X-Google-Smtp-Source: ABdhPJyNGDBltd8Z8uN43eEbGfNYndtoCa9UZqGXdEKkkrOadszA3VyIwWBnMf044pzFX7FW/IspsToka/g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8893:0:b0:4fb:10e1:8976 with SMTP id
 z19-20020aa78893000000b004fb10e18976mr22726077pfe.36.1651704676317; Wed, 04
 May 2022 15:51:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:07 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-62-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 061/128] KVM: selftests: Convert vmx_dirty_log_test away from VCPU_ID
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

Convert vmx_dirty_log_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==1.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c       | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 68f26a8b4f42..fb8c7f7236f7 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -17,8 +17,6 @@
 #include "processor.h"
 #include "vmx.h"
 
-#define VCPU_ID				1
-
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 #define TEST_MEM_PAGES			3
@@ -73,6 +71,7 @@ int main(int argc, char *argv[])
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
@@ -81,10 +80,10 @@ int main(int argc, char *argv[])
 	nested_vmx_check_supported();
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
-	run = vcpu_state(vm, VCPU_ID);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
+	run = vcpu->run;
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -116,13 +115,13 @@ int main(int argc, char *argv[])
 
 	while (!done) {
 		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * 4096);
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 			       	  __FILE__, uc.args[1]);
-- 
2.36.0.464.gb9c8b46e94-goog

