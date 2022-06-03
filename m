Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1501553C242
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiFCArt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbiFCApm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1F334647
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i8-20020a170902c94800b0016517194819so3357389pla.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZbJ0xN+LxZLXwNiuy5k0J6YWPhyRZK+kAps4sumczB4=;
        b=I68RlAutQvs+zo+uOlcw0DANUn6dsBjDuNP++WHZj7JYxdctpwXxpE3b45oDatEQVX
         12aalQJ4mneq1jR5GYW4RV7Dkx9S8iQVCd0prnYnnmrhe+GLy/SNtwG1rZ5ribS3/PJh
         otG9RufalY5MPN6ra2vNGg6mGT4reB0aZ5LbrRM4ANDyBR9oH/yZqD7sWN5jJwoTwKfj
         HmR9j1Sulz4WtMGximW5MktxTkeUywgXfH6MaRQhyG4FIFpOmoCd6+RVBiSDIipPe77j
         9fb+FGZwm2iTKWuGH2BRAoj/i+vY7e8BssaQ7uiUKVNVGOuYS0gGTgGvr69ILrEjmTQL
         Xk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZbJ0xN+LxZLXwNiuy5k0J6YWPhyRZK+kAps4sumczB4=;
        b=HZf3AvjEA0PCe5WcwkQcYu38NjTR3rhtfJ2EhVPaUTfB2lupFwH/muU1tMi5Sro3Q6
         PPWdLCUHH+4MsGXTvi/6BvYHXLp4IZPQKm8MfRYDb/jm+EU0VAxl4jU+4nubSryV4Mig
         3feiWxUWldxVbEiEt1DYNw22I/px+ttAHZoZDdinwfiMLWN52V4TvqPv4jS2A/H4Dod1
         p4CjVpCyW1ASHJpvNfwOqtTNyP7uZNDqMbxycREexsGi2X54rwIFqmsIAgmWMBU2AaWQ
         jLZ1lYX2O773SEXjcu+gDWVxq0x/DCrKblo14XAUhgNtIpmoIjaoooY75utoAxpEjqKA
         xdAw==
X-Gm-Message-State: AOAM530S2aj5Ie5NBExyM4S0GLU6UgisTrtb47g56uS0vsSr4w9BaloE
        j3OIbnoVWB7PzhqZVTW0zozGsnr8coc=
X-Google-Smtp-Source: ABdhPJx4mARyVOLC45eqy/Ae0cGI5Yhmu7SGNtpXEiiGktDWVWlKjgDtsL4EnTPn6Lujx3BuG9q5dUVTD+0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id
 b5-20020a056a00114500b004f63ebca79bmr7729203pfm.41.1654217130218; Thu, 02 Jun
 2022 17:45:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:09 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-63-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 062/144] KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
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
2.36.1.255.ge46751e96f-goog

