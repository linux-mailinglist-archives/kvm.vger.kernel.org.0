Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51ABD53C229
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbiFCAyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbiFCArb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5448E186
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s9-20020a634509000000b003fc7de146d4so3056910pga.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OD3/Ff0FEeZAS0nqwH4UPNx13i1cw9+dfKCyUGzw+1A=;
        b=A6IjW4Pfge5ajq8p3D8iO4s/jIIfmuvg3Sn4+SjXCaB5+gWwXD7VO+0vdGoivWV9JA
         WuneV+tji8pY/MzwSeqnqlvW4yMazzYwRKV/LfCUmu5MaSnEGLUJJu2LV8vpoDqihzAo
         oHVasHJzeVlpi8Gg6eMd6A8yD1AWHjwXkNEIpbW9bXKylYYcp2H3GgSm+bpMjZqr69vA
         eUbFGiyfkZEZwMHbZSdbaI1RQaDEkTreGx8JEqoidiAgALxLT6aTtVzshoOYJP8Y5PZn
         3G322aPQ8zDWRMA8YnNkt5MRSvJ8uic/iV0GrHh5uw7kiGR4eoZt6YT6tmBLNCQpIL5O
         lwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OD3/Ff0FEeZAS0nqwH4UPNx13i1cw9+dfKCyUGzw+1A=;
        b=fatuyFBANus3QT70O+8b7dGqfNpQO3PMrHt76ofmjxGjlePQuHFzEAgZ+/klsrFTuR
         ZymB3tyMxWbMnR8N/UHQB/vXXBNJDRbHwmZRQbSIHrs2HrPW7sAqkrDjf21/o6owZMB9
         JXxGBMX0hC5mBxBFS9I/Pk17VevDYmRBxI1Jr7lrll5JqUG9wHKgSRwVcoURaBh/GNgr
         QJvsLHxXTqxENOIIs2IRr3QSVLtGWVYpU3XLMTyGMaXtJ96o+sx/XNkEn1phtDugKM3N
         Mg5l1X8TIHTSoB4pRYRT6FLlDSB33989ZlbJJT49JIA+fiZKEIVEAY1r66/TTSMje4oL
         HC/A==
X-Gm-Message-State: AOAM533MH31Wi7gLYiaU+BHwmvyOB3q4IKXKEXxkK5Qhvr+d1Ac7JFeG
        RLMR0FYrxQ7HiKcGrQYYiRXEjN8MQeI=
X-Google-Smtp-Source: ABdhPJyWijgiTatf76rt3yvRFdLsJqaNYW3ya6aIl8/vQSQLcvJi9/vklY+ebYDoFT6lm/HFHuoCslvmYnA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307322pje.0.1654217206143; Thu, 02 Jun
 2022 17:46:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:52 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-106-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 105/144] KVM: selftests: Convert hardware_disable_test to
 pass around vCPU objects
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
2.36.1.255.ge46751e96f-goog

