Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA47801AF
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356087AbjHQXeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356092AbjHQXeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:34:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5DB35A5
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:34:36 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-684c8a66e86so553320b3a.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692315276; x=1692920076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iNsyygtCkxaRG/w4LzwwK4pPTj7xXCXneWqdoaGeIeQ=;
        b=2DXOAySptxOYbmlvUM/tAgN5Eb2QG8aBcujtmvvdDHchGbi3ioHIC7BrqR+5uyVxHp
         8cimBY/Cgyi5B85WehpXRY+spZ09SWs0efDl0WsRYWh0t0/fFem5IO4+0FBbHATibZ3w
         LyUmz0VwTI7OON7WM65RT9Ao7JHmrqvaJ3EAAAzcjyZpa7vXih4TaXwyDu6ESVrnRk3g
         XfuH3Db+1njF3BnVv8ASsuUBwtOWNCMjhwLFgSwYkpTaRH/6b/vTHe1URb/IWdOUQbbk
         cmFgAWwrff+YvATIOAsamEL9YKElLd4jyBqCsgGXgR8VMQjVuvnUqRwlITHJAQLf+ZMo
         lDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692315276; x=1692920076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iNsyygtCkxaRG/w4LzwwK4pPTj7xXCXneWqdoaGeIeQ=;
        b=Au4u733s5Euctjin1IEkLQ+sObDLqy7AFFp5AolPdTfGPLcD/8aFE+5u/1NqEB0Dqe
         G89yDnXa6SQ5EvCpUtN1ciOAtKRrZEgOh9erx2HxcyRAuY8tWwGGtKwmTqGJt00VU+IM
         FO2VZUPv3J0NfO9ZoD2dtEJRHUGTv4kJpyYc1o80v+j48ful+Ykh2HWdwPON7P3PPoYo
         cMCyujZotx3CeQZbBTnKx0bzDX3flEaW5HJSRgLd4VE9Ewl0o8D90ObBUvbNjzRX61FY
         eEwC/GtcIQ6F+CICHQeU81GGhfsCwFxJzfE11AFeo89bhO8W6s3dq8gpmLnhhFstgna/
         dgPA==
X-Gm-Message-State: AOJu0YwDTwhh++jMuQ6JQQzuQXfetZN+Tl/7KvHC+zECZc0ta7fN1K46
        bcS0KTjxNdGE+D4yqVo+VgRyLWENWck=
X-Google-Smtp-Source: AGHT+IGPb7xUAnqelzwy8bFGjkctwq5sz77pLCX7wc/RzVl/oFwqDVUkEZ5x5uw8aP5Z0q8mJ/733npteAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:808:b0:687:4fcf:8fd9 with SMTP id
 m8-20020a056a00080800b006874fcf8fd9mr554018pfk.1.1692315275871; Thu, 17 Aug
 2023 16:34:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Aug 2023 16:34:29 -0700
In-Reply-To: <20230817233430.1416463-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230817233430.1416463-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817233430.1416463-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: selftests: Reload "good" vCPU state if vCPU hits shutdown
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reload known good vCPU state if the vCPU triple faults in any of the
race_sync_regs() subtests, e.g. if KVM successfully injects an exception
(the vCPU isn't configured to handle exceptions).  On Intel, the VMCS
is preserved even after shutdown, but AMD's APM states that the VMCB is
undefined after a shutdown and so KVM synthesizes an INIT to sanitize
vCPU/VMCB state, e.g. to guard against running with a garbage VMCB.

The synthetic INIT results in the vCPU never exiting to userspace, as it
gets put into Real Mode at the reset vector, which is full of zeros (as is
GPA 0 and beyond), and so executes ADD for a very, very long time.

Fixes: 60c4063b4752 ("KVM: selftests: Extend x86's sync_regs_test to check for event vector races")
Cc: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 93fac74ca0a7..21e99dae2ff2 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -152,6 +152,7 @@ static noinline void *race_sregs_cr4(void *arg)
 static void race_sync_regs(void *racer)
 {
 	const time_t TIMEOUT = 2; /* seconds, roughly */
+	struct kvm_x86_state *state;
 	struct kvm_translation tr;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
@@ -166,6 +167,9 @@ static void race_sync_regs(void *racer)
 	vcpu_run(vcpu);
 	run->kvm_valid_regs = 0;
 
+	/* Save state *before* spawning the thread that mucks with vCPU state. */
+	state = vcpu_save_state(vcpu);
+
 	/*
 	 * Selftests run 64-bit guests by default, both EFER.LME and CR4.PAE
 	 * should already be set in guest state.
@@ -179,7 +183,14 @@ static void race_sync_regs(void *racer)
 	TEST_ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
 
 	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
-		__vcpu_run(vcpu);
+		/*
+		 * Reload known good state if the vCPU triple faults, e.g. due
+		 * to the unhandled #GPs being injected.  VMX preserves state
+		 * on shutdown, but SVM synthesizes an INIT as the VMCB state
+		 * is architecturally undefined on triple fault.
+		 */
+		if (!__vcpu_run(vcpu) && run->exit_reason == KVM_EXIT_SHUTDOWN)
+			vcpu_load_state(vcpu, state);
 
 		if (racer == race_sregs_cr4) {
 			tr = (struct kvm_translation) { .linear_address = 0 };
@@ -190,6 +201,7 @@ static void race_sync_regs(void *racer)
 	TEST_ASSERT_EQ(pthread_cancel(thread), 0);
 	TEST_ASSERT_EQ(pthread_join(thread, NULL), 0);
 
+	kvm_x86_state_cleanup(state);
 	kvm_vm_free(vm);
 }
 
-- 
2.42.0.rc1.204.g551eb34607-goog

