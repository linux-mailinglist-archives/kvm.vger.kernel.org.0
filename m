Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6490C51B2F4
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353619AbiEDXAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379862AbiEDW7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331854BC2
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n4-20020a170902f60400b00158d1f2d442so1365610plg.18
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UTDAzzugAKRqfKqJrZIH/IoYzHByuOdUPAxmATSKiTI=;
        b=rPiXZxY9Drt4UlQiJqVDmGBvE/HflKVSziywhLwdekQJkNQszfFBXTP0dGF02xDOiy
         6DIgghypxyKNFUGeHpmIKXQg3EYuwYjwi/BF0LtPWCnROC4HdUBSYAK4I8Q9Ifh9OSTx
         GZburL02vNPxAqVJBEHtWEwbL909D3Vvk5VSEXrv884U5oo4KH/Y6+SBKiK8RMOHsdAE
         EL5OKKAMFsSCo+XzZGZsYqaI/5EKdtnNM7rVCU3Ar2JdF9SYny9pgO1VjkWpzGroDVuZ
         SD6ob1pGbB8xnBrKHLF6sD3kIplyFlAPRggU9Zrd/GkFwBIjcH1lRZl5fM84vBb9WK1u
         kpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UTDAzzugAKRqfKqJrZIH/IoYzHByuOdUPAxmATSKiTI=;
        b=0RsTyDjWjoMlFsJJxybnmsGg3/tbVGHBBzmWVIdyApIF/OpAvGeTAxcFNstQzeLA/o
         oiIIoaFe6PycRt5HGgKphLRl4pHKh4zcab7f+PMPv9C3E3ybmFZ4YJZ8WwnArzy14Ysx
         MZZkhtlSeTv4yHVdAhb9mEkA6mqBgfHQjdpedRXtv569cSTENfUDlQEsl6A510X38P4J
         urbHobPn2wC3fSNcwOL7dFcDhZHFg9TSKdlaCMe1/NctL4tR7c5BYmrQrk06000H8Buu
         CkVx2JINNwAwscEeDV51dhS6zgLqtLuSfVXdx/E+OK3sxqO+nFzoJFYaaixnJGnl8lkp
         9xFw==
X-Gm-Message-State: AOAM533OFYDVeBYFhT/MAG/lxHi4UoE3lq678IQtAxXdxnMby2ICE3Sp
        oXQEthTt46HGIxRxlaeZZZVkArpL5Fg=
X-Google-Smtp-Source: ABdhPJyUsCpZRiADmS9XSR+E80A84NjTgBzy50rGR/Fr7VTw8WmyGZKnE+RolUDwK6+0n2aIBUaR5EGyoi8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b395:b0:1dc:a402:bd4 with SMTP id
 e21-20020a17090ab39500b001dca4020bd4mr2245297pjr.238.1651704737681; Wed, 04
 May 2022 15:52:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:43 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-98-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 097/128] KVM: selftests: Convert hardware_disable_test to pass
 around vCPU objects
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass around 'struct kvm_vcpu' objects in hardware_disable_test instead of
the VM+vcpu_id (called "index" by the test).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 25 ++++++-------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 31f6d408419f..b522610f0ba4 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -27,12 +27,6 @@
 
 sem_t *sem;
 
-/* Arguments for the pthreads */
-struct payload {
-	struct kvm_vm *vm;
-	uint32_t index;
-};
-
 static void guest_code(void)
 {
 	for (;;)
@@ -42,14 +36,14 @@ static void guest_code(void)
 
 static void *run_vcpu(void *arg)
 {
-	struct payload *payload = (struct payload *)arg;
-	struct kvm_run *state = vcpu_state(payload->vm, payload->index);
+	struct kvm_vcpu *vcpu = arg;
+	struct kvm_run *run = vcpu->run;
 
-	vcpu_run(payload->vm, payload->index);
+	vcpu_run(vcpu->vm, vcpu->id);
 
 	TEST_ASSERT(false, "%s: exited with reason %d: %s\n",
-		    __func__, state->exit_reason,
-		    exit_reason_str(state->exit_reason));
+		    __func__, run->exit_reason,
+		    exit_reason_str(run->exit_reason));
 	pthread_exit(NULL);
 }
 
@@ -92,11 +86,11 @@ static inline void check_join(pthread_t thread, void **retval)
 
 static void run_test(uint32_t run)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	cpu_set_t cpu_set;
 	pthread_t threads[VCPU_NUM];
 	pthread_t throw_away;
-	struct payload payloads[VCPU_NUM];
 	void *b;
 	uint32_t i, j;
 
@@ -108,12 +102,9 @@ static void run_test(uint32_t run)
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
-		vm_vcpu_add(vm, i, guest_code);
-		payloads[i].vm = vm;
-		payloads[i].index = i;
+		vcpu = vm_vcpu_add(vm, i, guest_code);
 
-		check_create_thread(&threads[i], NULL, run_vcpu,
-				    (void *)&payloads[i]);
+		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
 		check_set_affinity(threads[i], &cpu_set);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
-- 
2.36.0.464.gb9c8b46e94-goog

