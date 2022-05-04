Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3454151B2C3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiEDW4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379422AbiEDWyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5BA53B5D
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:04 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id b198-20020a6334cf000000b003ab23ccd0cbso1338406pga.14
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XIDdXFOkDVy5SJapPAjtIumoXgEMA8drU4nFneUqcss=;
        b=sLIL62vkhfenMrg59N3qnvWrZAryk/gK47WQkWsS0G+8hkowjDz6YrsMpAxRFXVRB3
         I7CJ9fcWsJ89ePfYse6I1jiGC5wwaZ6QAoOMlix1CuG1gZyFRdhGKrScdqIKM7AJyEk8
         NGm4IiBoIRtMxU6n+r/QFGF4dgtzcHTaV1Zj1kylWAzBK/+EYedQ5Nr1jx9Gi+oPmCb6
         fFzgpaWkZ3n5xLmpROsVeL46jU1ZjuNtrs1E9Xd65DoCeHpZGSpV4Rvur/8YVy0wD+D1
         wkAWsHPflAOeKfWZgV/LfQf6/2zHiGk4PxV2zdDonvV8FR544Fi0C06iJkLJFd7GwBRo
         KX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XIDdXFOkDVy5SJapPAjtIumoXgEMA8drU4nFneUqcss=;
        b=5g5WvQ3J/xI0rQS7Kny04uJXVKsjneomuVmYJu75lHQD7JyqbOBDnAjOkchtKlVVrs
         Lz5ioDDf+hulyK1qKD99GrYPRajyYUQTuu6VH2QqTRq/6XKrxwLs3I57MK52kJx92C8n
         6bsZnWD1Le5PUDsS6OTYdpJDBycH662y5zi0FFH8L5rDN87dEKehMeb7kHTXv4D9jqxF
         B7A1Kgzai1lOroRU9qssQDhjabwrCWZGzz9XI72IXhWypVHlF2+AGJ6pvRaaR6h+Qwak
         Z0eAyrq89Wq4WuRRcgG065bvFnxhsZt8FwobogsyzdZU/bbACCREGGOwyToIjR/PchRx
         /LGQ==
X-Gm-Message-State: AOAM533+kqXg9/9jyeRib7H2Zy3rLk6+JuYZZmABwaAATHmGsOj8dPiF
        F8Qo0Hfu8UNgI8an3Sm/5uyxKXTjeVU=
X-Google-Smtp-Source: ABdhPJwKYyiszUouLC8ehMlepVP+AHjsIot3+Ba+EfTpNiIXyVQb03gwDR0HOizSv/42P4iwcXt42WyW9JQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:dec4:0:b0:50f:70d1:41dd with SMTP id
 h187-20020a62dec4000000b0050f70d141ddmr7163473pfg.68.1651704664030; Wed, 04
 May 2022 15:51:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:00 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-55-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 054/128] KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
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

Convert svm_vmcall_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/svm_vmcall_test.c       | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
index be2ca157485b..15e389a7cd31 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -12,10 +12,6 @@
 #include "processor.h"
 #include "svm_util.h"
 
-#define VCPU_ID		5
-
-static struct kvm_vm *vm;
-
 static void l2_guest_code(struct svm_test_data *svm)
 {
 	__asm__ __volatile__("vmcall");
@@ -39,26 +35,28 @@ static void l1_guest_code(struct svm_test_data *svm)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	vm_vaddr_t svm_gva;
+	struct kvm_vm *vm;
 
 	nested_svm_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
 	vcpu_alloc_svm(vm, &svm_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
+	vcpu_args_set(vm, vcpu->id, 1, svm_gva);
 
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
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-- 
2.36.0.464.gb9c8b46e94-goog

