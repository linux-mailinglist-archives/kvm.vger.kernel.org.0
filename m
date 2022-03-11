Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA54D67E1
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350873AbiCKRmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350861AbiCKRmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:20 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCA61C65C4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:16 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so6733997ioc.14
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2LSJANjSYpAWOJFNIXz+8dt0F/NtwX4/yDcBJViXKEo=;
        b=VlHiPeyTld/1NEk/E5VMaNHpezW5J48Ln8kdGwQgrmfpaHqxesSVY7tRWUosoJXplI
         F9W3pkhSk76+quWnsaAbZW2S3ltT21dCRJ+kP1wGmDThq7tm+k+tZiwmNXcRevC6Y5+y
         Gp2tz9/2N16lbXBwYoSoWap+jD7C5H28Vvdv/R3bInAqoxEIwxuTyyF6X/GyalQ7Jgup
         JiTlA4qtNID5BN0RG4tP5GSnFvSLV0kiNsUTm072zN9GzW0CNiE/i05m5vx8GrLK7tNJ
         qhP4mXDkxPI9VLdwja9wo9ByBlpVK0w29OTvnLhK78lglNFRbSuc6DGQg+w3lLAVMctE
         gkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2LSJANjSYpAWOJFNIXz+8dt0F/NtwX4/yDcBJViXKEo=;
        b=OJGz6vvukE02gTuZWmH4mck/M+/Kl3Lk167XozjUPU6Pxf+IoFbEdXuAmX3wsWeuqU
         J+mm4pgBU1uKGH8rkGGbLpcHENZeeUNf5oecutI7T0TzqQhZrqv3G/QOe0GIQxJfVnN8
         7MrL3CC5kyJmRE/8zSa+/8vr8t7ovNNkF02iAiPBSkMXMraan/UgByHUgvrJBDgWqHq5
         fk1RWHngPhCeC9+2O0qTG91jHPN/H4pTsukCijsIauIJdIDi0HYz3Fcq35y4Mb6FBSTb
         NYOAHjLdXK62yi2FcM4qWNlWToPADAtP+2KBZdtJnKsJOnYcL+3rlIDtjIyiQJIs+wFB
         VCWQ==
X-Gm-Message-State: AOAM533Hb+UJCD6ZrvIE2BQrfFkUT3ebFBi/Ci/H5qGgixFzKSarqACG
        aGqSRe1Mv5CYK/Yglr+DKHFCL86OQiY=
X-Google-Smtp-Source: ABdhPJwFStQunXcwugd9xidupQuW9bZm+6k3cfSglfyyz0xljBqYTInRveQuXk40mwAmA8qhksT+CAzWSXk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:d003:0:b0:646:4652:bd57 with SMTP id
 x3-20020a6bd003000000b006464652bd57mr8748957ioa.51.1647020476191; Fri, 11 Mar
 2022 09:41:16 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:40:01 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-16-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 15/15] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
        Oliver Upton <oupton@google.com>
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

Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
the guest calls PSCI SYSTEM_SUSPEND. Additionally, guarantee that the
SMC32 and SMC64 flavors of this call are discoverable with the
PSCI_FEATURES call.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 535130d5e97f..88541de21c41 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,6 +45,25 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
+static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
+{
+	struct arm_smccc_res res;
+
+	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
+		  0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
+static uint64_t psci_features(uint32_t func_id)
+{
+	struct arm_smccc_res res;
+
+	smccc_hvc(PSCI_1_0_FN_PSCI_FEATURES, func_id, 0, 0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
 static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct kvm_mp_state mp_state = {
@@ -137,8 +156,58 @@ static void host_test_cpu_on(void)
 	kvm_vm_free(vm);
 }
 
+static void enable_system_suspend(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
+	};
+
+	vm_enable_cap(vm, &cap);
+}
+
+static void guest_test_system_suspend(void)
+{
+	uint64_t ret;
+
+	/* assert that SYSTEM_SUSPEND is discoverable */
+	GUEST_ASSERT(!psci_features(PSCI_1_0_FN_SYSTEM_SUSPEND));
+	GUEST_ASSERT(!psci_features(PSCI_1_0_FN64_SYSTEM_SUSPEND));
+
+	ret = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+	GUEST_SYNC(ret);
+}
+
+static void host_test_system_suspend(void)
+{
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	vcpu_power_off(vm, VCPU_ID_TARGET);
+	run = vcpu_state(vm, VCPU_ID_SOURCE);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+		    "Unhandled exit reason: %u (%s)",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
+		    "Unhandled system event: %u (expected: %u)",
+		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
+
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
+	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
+		exit(KSFT_SKIP);
+	}
+
 	host_test_cpu_on();
+	host_test_system_suspend();
 	return 0;
 }
-- 
2.35.1.723.g4982287a31-goog

