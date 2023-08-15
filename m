Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3458977C4AD
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 02:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjHOAs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 20:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjHOAsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 20:48:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C7173E
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:48:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589e5e46735so31140297b3.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692060514; x=1692665314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=52oFZVaLBUqV5JDZKjfa7j0JbQy+FgnNmye7nF0zv4Q=;
        b=FxxWccPFx99rf/V93BNIHCJQDo4G5Zqgck3MdWGlrvNjMCRPN8+G/pY2KOQxIsmru4
         vHP6l3UEcIbqov0g/ZNfatfTRlVJ4PqnbEjX8htHswC2UWPgE8BCpl4N5rf6TqJAj5r7
         3cNurQ0Uef0OB/kGIOacEBA/AwM3Z0NXdnm7Tl/dvyTytatiTtWBRn4NtDzJl8cuZpiE
         An0JjLDU7h1dJCpalHenIF1GbxY9OlZdC6Cps6IKdn8w/2qZYzdExGGuFKJLqlohWPz+
         CLzdX4lu/e5vAb3ExxkeJaeWP64lX43sqrSEThAmoeNcMVwSigCbOhpzG+ztFaEtaHZe
         sr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060514; x=1692665314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52oFZVaLBUqV5JDZKjfa7j0JbQy+FgnNmye7nF0zv4Q=;
        b=UVGvno6N3EB/XZB2rHmOtko80ftBUQyxpmR35HGZZrAMXkfaTWGnYOqvd+AoBfh96y
         z+XLCUfXI2nmjDkHbuOln81t5tX0TFD1KjQCB04KEIwjIts4nJ58i9F/mJx1Av3WWh5C
         lMuNfN4b0VsXB/cOG8ZS4x4y/3VOgGOYQzK+cMwhjFh6y4Aq5bL4t8vL5MKnAzcbTOJO
         U1/jyS286mYEOCxSQM9T61cpc5WDGdV7Qs+T3EhjUGLh7u24lgecJrzIo1vZlbnaFfGT
         UFnQ2rIP28XI7dzHsmw9jKj3Qk8taXWJBzUXfALGXWhA6Hny+sq/buqAIPo2M5zLu8jV
         zC3A==
X-Gm-Message-State: AOJu0YwXwR1j8xk95kyZ31zxCh5dlxfZRjOUPLLSEgtjcs4MG4rPdcO5
        ELoxMiEm2xmTEQlpaVpZI4MpflZ7Orc=
X-Google-Smtp-Source: AGHT+IENRn7eU5S576awdNT0hdv6zNDIVzHUqiIWxFSkMpa6HSwObqb6uEWL8dr1GX7l67afv6TxWe2boxM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:709:b0:57a:118a:f31 with SMTP id
 bs9-20020a05690c070900b0057a118a0f31mr182637ywb.7.1692060514350; Mon, 14 Aug
 2023 17:48:34 -0700 (PDT)
Date:   Mon, 14 Aug 2023 17:48:32 -0700
In-Reply-To: <169100872740.1737125.14417847751002571677.b4-ty@google.com>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <169100872740.1737125.14417847751002571677.b4-ty@google.com>
Message-ID: <ZNrLYOiQuImD1g8A@google.com>
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Sean Christopherson wrote:
> On Fri, 28 Jul 2023 02:12:56 +0200, Michal Luczaj wrote:
> > Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
> > have exclusive rights to structs they operate on. While this is true when
> > coming from an ioctl handler (caller makes a local copy of user's data),
> > sync_regs() breaks this contract; a pointer to a user-modifiable memory
> > (vcpu->run->s.regs) is provided. This can lead to a situation when incoming
> > data is checked and/or sanitized only to be re-set by a user thread running
> > in parallel.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests (there are in-flight reworks for selftests
> that will conflict, and I didn't want to split the testcases from the fix).
> 
> As mentioned in my reply to patch 2, I split up the selftests patch and
> massaged things a bit.  Please holler if you disagree with any of the
> changes.
> 
> Thanks much!
> 
> [1/4] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
>       https://github.com/kvm-x86/linux/commit/0d033770d43a
> [2/4] KVM: selftests: Extend x86's sync_regs_test to check for CR4 races
>       https://github.com/kvm-x86/linux/commit/ae895cbe613a
> [3/4] KVM: selftests: Extend x86's sync_regs_test to check for event vector races
>       https://github.com/kvm-x86/linux/commit/60c4063b4752
> [4/4] KVM: selftests: Extend x86's sync_regs_test to check for exception races
>       https://github.com/kvm-x86/linux/commit/0de704d2d6c8

Argh, apparently I didn't run these on AMD.  The exception injection test hangs
because the vCPU hits triple fault shutdown, and because the VMCB is technically
undefined on shutdown, KVM synthesizes INIT.  That starts the vCPU at the reset
vector and it happily fetches zeroes util being killed.

This fixes the issue, and I confirmed all three testcases repro the KVM bug with
it.  I'll post formally tomorrow.

---
 .../testing/selftests/kvm/x86_64/sync_regs_test.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 93fac74ca0a7..55e9b68e6947 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -94,6 +94,7 @@ static void *race_events_inj_pen(void *arg)
 	for (;;) {
 		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
 		WRITE_ONCE(events->flags, 0);
+		WRITE_ONCE(events->exception.nr, GP_VECTOR);
 		WRITE_ONCE(events->exception.injected, 1);
 		WRITE_ONCE(events->exception.pending, 1);
 
@@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
 	for (;;) {
 		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
 		WRITE_ONCE(events->flags, 0);
+		WRITE_ONCE(events->exception.nr, GP_VECTOR);
 		WRITE_ONCE(events->exception.pending, 1);
 		WRITE_ONCE(events->exception.nr, 255);
 
@@ -152,6 +154,7 @@ static noinline void *race_sregs_cr4(void *arg)
 static void race_sync_regs(void *racer)
 {
 	const time_t TIMEOUT = 2; /* seconds, roughly */
+	struct kvm_x86_state *state;
 	struct kvm_translation tr;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
@@ -178,8 +181,17 @@ static void race_sync_regs(void *racer)
 
 	TEST_ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
 
+	state = vcpu_save_state(vcpu);
+
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
@@ -190,6 +202,7 @@ static void race_sync_regs(void *racer)
 	TEST_ASSERT_EQ(pthread_cancel(thread), 0);
 	TEST_ASSERT_EQ(pthread_join(thread, NULL), 0);
 
+	kvm_x86_state_cleanup(state);
 	kvm_vm_free(vm);
 }
 

base-commit: 722b2afc50abbfaa74accbc52911f9b5e8719c95
-- 

