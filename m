Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599FF53C298
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiFCAsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbiFCApr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:47 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586A233887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t2-20020a635342000000b003fc607eb7feso3038907pgl.20
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KYdW6YZIqFNXsTTYBSVirMMFVngLYzrfEoDxcCp6GVs=;
        b=rR5XmtGdHFhybuFDAwZKwVMyn2x65XnyxXM7UshP6sYRlc8DNAYJ3Q8OwnltEzr1TN
         49HmQrx8OrC3EFIeE2R/FF4Q/E1mgAll2CeWZQrnU597k5iqZ5n3ZNTsT4heOB+zsiTK
         ib2ZXyR2SSDncl1k6o+b+W28ihDLWtW6P0g8ocld9cSaspPSLg8lLkEGVSVjnHzMoE+P
         0/PAQCMK0qkGIIUNzk9OQT719/0gkG2hBQXMTtyvALxDX3bKpxtq1JP8czPQgHzQg3Pj
         5fr7CD1wKG7j0Y5kOzvc669/MV0QJWj8WpTr00TIS6/RCEf/LTc8lqg1IglaGvI89XH3
         DjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KYdW6YZIqFNXsTTYBSVirMMFVngLYzrfEoDxcCp6GVs=;
        b=1xqYbQQxSHTu12dR3a5IlSgScGcI8yDkLsvJy8E/N6F8fVkg3Mk31MZiM8ZQ2d1tnr
         kmaKaA3DwOoJ7xBOUhbAZrVaM8Pb6Pnk6MgYpqto2eRpRnXoPc4IEII2sCgulgx2EY7D
         2WvDxV9qfYps7dOPFK1Eb+MBm1dZgXtcuoYjdsuTDUmc+WS8PcQ5X8BaIe4uBZDPBVl1
         aR8xOj4sKMLBywRdtht5tZzoDhey8sbHSHa9Tom2ywyAahwdlG0Myk7Ubcf/+bZerLxG
         F1xUuq/Pi5Obi2gZDQKP2Vsb8Wugrkx3kL/lxrFlYWB75Zk5Q8s3IYtibTOtPmtecIwF
         /bFw==
X-Gm-Message-State: AOAM531DtZMOFIWOSWRz45rwFlb9QG17hjiCdlnVYpuoBfmFTxWirzdu
        6/39MHkQUUJYtaR3mTXdUbCWYQfezak=
X-Google-Smtp-Source: ABdhPJwykWEsE3nKRqcmxQiZY0Utlxp2sTH8cTZd8R4fsyK09AsA8NWUhLz9aPnZ1YtAbOA8tzjryT1zHFE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307313pje.0.1654217142546; Thu, 02 Jun
 2022 17:45:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:16 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-70-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 069/144] KVM: selftests: Convert vmx_dirty_log_test away
 from VCPU_ID
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
2.36.1.255.ge46751e96f-goog

