Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0041A51B2CE
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379572AbiEDW6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379266AbiEDW5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:57:22 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A525535A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i6-20020a17090a718600b001dc87aca289so1081648pjk.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xEQbxUARELbhHSYHXmNFvwMBvlzdLsgmj19ArJnkrhs=;
        b=swamEmeh4M9RkQH2dqPuBEZMrLwQkEUgIzTDIzHEIXE7sci6ETIUGi6xs8QCOdqcl+
         6bcgNnECJXfui4mKHFlsJ/gqZ9F3Cfy/j21tel3kFYM0Wd7pK0j44KqQ7VPpEJPjOwX1
         SlMPm0rTzsDBPkGwVw4JRiKp9q95EZSUM0FYv1AMg/MTT0aTQWbi/3VbBP9uPTWZ6LEJ
         wYVWRX6oCqNp5PFOWWRWToX2lppaM8Y/pbAu+T1/AywU2FJNARY3NSPgqFzVKT87ZTRs
         on3ChcI8Mv8zAQDF/WlIZdQEh50F1Ue5Qva0yR27GrGCJ5ZeXalBT3DTPG9qfoe21DNr
         a45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xEQbxUARELbhHSYHXmNFvwMBvlzdLsgmj19ArJnkrhs=;
        b=rAUblP5tCUvHrr8Ma8URnWqaZCH2TgQ23ilh+owp7hEsBKN1qfPOgj21MEGrni66QX
         R5Pgt0WqyhQTk0m116ikWej3jX2N+tiiWvs5nXtau64ZAadnomlyB0QhuM/8rnrC8TTF
         sHevcUl/iq/67em/660lfWO7+/wHHXwM1J+oYgd3UNmLt4SU0FxTb2jk8zapiQIfQfsn
         XG4BJoTY9RhVEYF8vN0sgLAuo0RsGpAXXoQMGVpJufKriy2F8kwNYVIKIrh7kYhYTULc
         eIz7kRF9I3p8pewKFGA9RlN+PEq9qBHOze6Lc7FH8O9zLmjnJzYMd5645gE7DdAsvoYp
         T08g==
X-Gm-Message-State: AOAM531t96Uq5sKKkiJeA2LkzZJ59/UZf8/YOXQa75N2j/SYayw5Al11
        ZnM4e3FtARnGtnArqS3wQYt3i7v+RaE=
X-Google-Smtp-Source: ABdhPJz/a/GixBSxg9PMmZsWQEbfe02Yez+gKML1QUIpFmNDrgQT3JBowT5Mvl7INjkoSltq/FwX55LqTgs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr140044pjt.1.1651704705684; Wed, 04 May
 2022 15:51:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:24 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-79-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 078/128] KVM: selftests: Convert userspace_io_test away from VCPU_ID
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

Convert userspace_io_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note,
this is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing non-zero
vCPU IDs is desirable for generic tests, that can be done in the future by
tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/userspace_io_test.c   | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index e4bef2e05686..0ba774ed6476 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -10,8 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID			1
-
 static void guest_ins_port80(uint8_t *buffer, unsigned int count)
 {
 	unsigned long end;
@@ -52,31 +50,29 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int rc;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	memset(&regs, 0, sizeof(regs));
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		if (get_ucall(vm, VCPU_ID, &uc))
+		if (get_ucall(vm, vcpu->id, &uc))
 			break;
 
 		TEST_ASSERT(run->io.port == 0x80,
@@ -89,13 +85,13 @@ int main(int argc, char *argv[])
 		 * scope from a testing perspective as it's not ABI in any way,
 		 * i.e. it really is abusing internal KVM knowledge.
 		 */
-		vcpu_regs_get(vm, VCPU_ID, &regs);
+		vcpu_regs_get(vm, vcpu->id, &regs);
 		if (regs.rcx == 2)
 			regs.rcx = 1;
 		if (regs.rcx == 3)
 			regs.rcx = 8192;
 		memset((void *)run + run->io.data_offset, 0xaa, 4096);
-		vcpu_regs_set(vm, VCPU_ID, &regs);
+		vcpu_regs_set(vm, vcpu->id, &regs);
 	}
 
 	switch (uc.cmd) {
-- 
2.36.0.464.gb9c8b46e94-goog

