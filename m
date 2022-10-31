Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6A613CC5
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJaSA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJaSA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:00:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EA13D2B
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q1-20020a17090aa00100b002139a592adbso5750541pjp.1
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mssMmFyCgRGMuxB7n0IJhZMiRilQUWU+GcvZo19Dlsk=;
        b=Xa7Zm/XmddVMtPHWm7IbpVr2li6rD76IsuEYJnmjZzrTlKJyECkf7p5oiPhrQHDfe4
         Vewwc7Ur9BvHQYzLCFAqSTyRYFUMTMVrZv6MG/1MkdOZpn8IrNRyvrEnv+OxymMaODIx
         I83yuOl66qphxaA2wsMDuxrFuUjp7H2+jhGjIFQUWXZR0ptdYzFHeeP+WYKBOi4hwq/s
         bfacIX+5Y8UwwRrMzpukbZCO/858j/H41xqurA1UxraYxMnqeB+MfhI0qggh/ZccYCFm
         5uUjVXAN1gXbxOuqhv8GEtUPwOIlY3bCrBBu8p3yWb858oOuHnW6U+R1mSYhn6wMYeb0
         wWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mssMmFyCgRGMuxB7n0IJhZMiRilQUWU+GcvZo19Dlsk=;
        b=fKoOxi2EQMj+hUU7SRJiZ8YeRlOhOOmwpBxFZcioXn+T/BZ6nBC/n8y/SuZXXpNB2E
         DBNwjcSOr3vfExA/shnaIOgSnC57Cj2v+tOh2r1V3fykTz9IxXd8/ZDEUAm3ozWTowDb
         jGgAfeokY8ubfjmYEkorWch0+mDGTbwCZSEKtrR1k5m/jyQM1Hu3oxHEbAUqNrMl3fYi
         6M9XDtBxbFqFx5dhzwLhJItTIoqEP1pJ148+Sv7OD318FxHNVOB/7iCBem5Ex/DRAba+
         GYupahGkYYfE+1TEfGgWqCy5cW2mIyBMKdcxk0v/pRktAkfaAkZUU/GI3u78mOmK8Scs
         Yu/g==
X-Gm-Message-State: ACrzQf1dar68GigzHG1FBI82WJaDVG6S/LUfMkVO7oOXNLFiqn9Udbho
        IE+8o5qIucjP4YkNCgS2LDDdBtM5kV+3aA==
X-Google-Smtp-Source: AMsMyM55PpF6WO0Gk6qKIT+ZCLpaOdHW8ymhEja7s89zqIlSkBTYsMrQChHQNLayIpcn1iO2QYzxOdJmXV1kaA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:aa7:9421:0:b0:56b:b2a8:6822 with SMTP id
 y1-20020aa79421000000b0056bb2a86822mr15382772pfo.86.1667239255001; Mon, 31
 Oct 2022 11:00:55 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:38 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-4-dmatlack@google.com>
Subject: [PATCH v3 03/10] KVM: selftests: Delete dead ucall code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete a bunch of code related to ucall handling from
smaller_maxphyaddr_emulation_test. The only thing
smaller_maxphyaddr_emulation_test needs to check is that the vCPU exits
with UCALL_DONE after the second vcpu_run().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 61 +------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index d92cd4139f6d..f9fdf365dff7 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -63,64 +63,6 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 	vcpu_regs_set(vcpu, &regs);
 }
 
-static void do_guest_assert(struct ucall *uc)
-{
-	REPORT_GUEST_ASSERT(*uc);
-}
-
-static void check_for_guest_assert(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
-	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
-		do_guest_assert(&uc);
-	}
-}
-
-static void process_ucall_done(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct ucall uc;
-
-	check_for_guest_assert(vcpu);
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
-		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
-		    uc.cmd, UCALL_DONE);
-}
-
-static uint64_t process_ucall(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct ucall uc;
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		break;
-	case UCALL_ABORT:
-		do_guest_assert(&uc);
-		break;
-	case UCALL_DONE:
-		process_ucall_done(vcpu);
-		break;
-	default:
-		TEST_ASSERT(false, "Unexpected ucall");
-	}
-
-	return uc.cmd;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -157,8 +99,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
 	vcpu_run(vcpu);
-
-	TEST_ASSERT(process_ucall(vcpu) == UCALL_DONE, "Expected UCALL_DONE");
+	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 
 	kvm_vm_free(vm);
 
-- 
2.38.1.273.g43a17bfeac-goog

