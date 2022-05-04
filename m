Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F7551B28C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359759AbiEDWzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379570AbiEDWy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1DD5418A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q91-20020a17090a756400b001d951f4846cso3557501pjk.8
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2uFSjC+RNcw6nw5QfKWzA8S+fTB7FlXQ6IXnxoZIo4w=;
        b=bRB8VWN5qm2Q7xyr6rDQpeCd+Zog8FCLGQ9KMdsVnSbrWLabQgYVt/9q9kheH+oPMq
         0WryY7yKnwq576NBlLgPwPtvSlYMDM29lXn8mhvtMKLfiluip8mFJDMxDX4knUvb27Ug
         fFlr4FwuART21oHyTbeyed8cNEQUuAoHMbuIqjHkzWe4OTK4HRtWhwmqZ50+jsMfJBSj
         kdzKmmHYim2To0kZNUspeREqa/bUfCOg6rUa860OD91hsE12AUTAoC1CS6r2vCzZXFbb
         H3BBuiY5SIOHNKtcExvwDBl5l2P+42T9y90SIUyQ/Bbzv6B2gYrd2ZOIeeyNH2wr6MNW
         XYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2uFSjC+RNcw6nw5QfKWzA8S+fTB7FlXQ6IXnxoZIo4w=;
        b=QRcerHkVvkeynDb/JwwBtiOs/k3Md6JENPTlKJ1c7KVIpTRwtY/jDmWT9jH3rphFkq
         /FcVJP9wQ++ysvtSDroSeCurng0l8ZqWlxsAKx5gRswMb3rlGRch4GFNB5baRsCVr2Cr
         0/YF2MMDtNkX+ZuJnn0orAdXtPQXXse6Tzbi6bzt5v6qjRPs+4dBlpHf8n6EywAJNVT2
         XPzk506yuOKyhzrlbzS2d61MDvnIr5sENkKZBG8MZib/4FdJE0SRGGVnjBfSfO9Cw6Kp
         K7JXQNZlIL1B5RPfWezeYvvyeevB7eaVYYPVPr+Z2Qwp1bbVuB7bUYo3l3MboUNuzLhs
         PgIQ==
X-Gm-Message-State: AOAM530djYsQ7zvuYGsaZOgAPT7gsF16trbQzfgNNOYtxwDe+FgCRzF6
        IEiFb7aEXpzEmH1rG+TKBOygvIDis4I=
X-Google-Smtp-Source: ABdhPJyBlWtmtc4tl96/FN9hhh/0EGQw76vblNNqdgrvXQ9ASlbsBrmA1sjs37FQIR6PSr0lSTj0kmI75Eg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c8:b0:15e:c2e2:bff6 with SMTP id
 u8-20020a170902e5c800b0015ec2e2bff6mr6495658plf.74.1651704670974; Wed, 04 May
 2022 15:51:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:04 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-59-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 058/128] KVM: selftests: Convert platform_info_test away from VCPU_ID
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

Convert platform_info_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 1e89688cbbbf..0468a51c05f6 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -21,7 +21,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
 #define MSR_PLATFORM_INFO_MAX_TURBO_RATIO 0xff00
 
 static void guest_code(void)
@@ -45,18 +44,18 @@ static void set_msr_platform_info_enabled(struct kvm_vm *vm, bool enable)
 	vm_enable_cap(vm, &cap);
 }
 
-static void test_msr_platform_info_enabled(struct kvm_vm *vm)
+static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	set_msr_platform_info_enabled(vm, true);
-	vcpu_run(vm, VCPU_ID);
+	set_msr_platform_info_enabled(vcpu->vm, true);
+	vcpu_run(vcpu->vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			"Exit_reason other than KVM_EXIT_IO: %u (%s),\n",
 			run->exit_reason,
 			exit_reason_str(run->exit_reason));
-	get_ucall(vm, VCPU_ID, &uc);
+	get_ucall(vcpu->vm, vcpu->id, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
 			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
 	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
@@ -65,12 +64,12 @@ static void test_msr_platform_info_enabled(struct kvm_vm *vm)
 		MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
 }
 
-static void test_msr_platform_info_disabled(struct kvm_vm *vm)
+static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
-	set_msr_platform_info_enabled(vm, false);
-	vcpu_run(vm, VCPU_ID);
+	set_msr_platform_info_enabled(vcpu->vm, false);
+	vcpu_run(vcpu->vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
 			"Exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
 			run->exit_reason,
@@ -79,6 +78,7 @@ static void test_msr_platform_info_disabled(struct kvm_vm *vm)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rv;
 	uint64_t msr_platform_info;
@@ -92,14 +92,14 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	msr_platform_info = vcpu_get_msr(vm, VCPU_ID, MSR_PLATFORM_INFO);
-	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO,
+	msr_platform_info = vcpu_get_msr(vm, vcpu->id, MSR_PLATFORM_INFO);
+	vcpu_set_msr(vm, vcpu->id, MSR_PLATFORM_INFO,
 		msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-	test_msr_platform_info_enabled(vm);
-	test_msr_platform_info_disabled(vm);
-	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO, msr_platform_info);
+	test_msr_platform_info_enabled(vcpu);
+	test_msr_platform_info_disabled(vcpu);
+	vcpu_set_msr(vm, vcpu->id, MSR_PLATFORM_INFO, msr_platform_info);
 
 	kvm_vm_free(vm);
 
-- 
2.36.0.464.gb9c8b46e94-goog

