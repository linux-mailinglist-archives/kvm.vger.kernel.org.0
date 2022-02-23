Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70324C0B05
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbiBWEUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237834AbiBWEU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:28 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B93B2BE
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:20:01 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id y9-20020a927d09000000b002c24b428ff4so4575710ilc.18
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ln5NpBpAQfeJH+D9rE91ZmcHe7YhrG7E3g5O/Fn36fE=;
        b=Xjc9neOk8jLLu+5+Yti4DACQgrQiyssQHoAN7SFgxpMJyEW3cYy+lMA8PkZGdKa2/Z
         suF9pIyrCUOYdJJDUKrMbl8SC+woir18EsBPWNqzPzpKUdm8/53eOBdpSJtWvwu4Jtci
         qhrqwwZhKcQsO0a8HFMlK+1YEa8YCothulVqpLiPz3MEYxNhNOO8/yxB4W6vkc5mspmj
         v1N6wuKoaSiWKhN13VjP3x3VK3YJJDwBcY9T3IU6LoKRCOLSVGjNm3eABUMVNgbkPWQ8
         kjo1bqmvbsPpgbCpPFxoFG3FfwcFuuK7tTIwAT59RcWtut6JZnjS2XnB75pDTVKpj8GB
         Zy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ln5NpBpAQfeJH+D9rE91ZmcHe7YhrG7E3g5O/Fn36fE=;
        b=2cyK9e5Biia/8VfXdxIM3KY56/3ZE6s4QocSrY/FGuvYHc0vVnzDVR0lFXsvJrgc8C
         MbN0gtyBfhp4QhtxOeJfeUjI0dpD5ymvuoAFliABaYRmQS+X6ihUr0wR5ZDsPknRiucJ
         xKexUIuP3W4Rs9IRzWXx9Ionx58y26WOTH9NDagItUeuCvOgehNZi+kDesbVyjlfnyNp
         oB5ALKx//mjhjFS0C4gZ8dBK11n9/6N1XbMtga7QPNHqBK5vdmIXgaHlKHoYYzZ68U6+
         1Fj3BYyANoei/2Yuakv4bCOwxM34Mo32Gja7PVHX1yDrDLrwpKuPWzOHb9EUclAqVjo6
         KOSA==
X-Gm-Message-State: AOAM532mFYJRPNV81GcXusxfWyRFZSlZn3KX1+Kcy0j5SYuc9qClV1vw
        w/s8CS5tSa+gGNtSsUjpD/mPhD+FU88=
X-Google-Smtp-Source: ABdhPJxixMOimHhRWdkDlokvYZ9TdxE7WefirH3ZQMjiEuPl8GdS7TYGQs/MgM2jjjoBQ5O+TiFAkrLSadw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:8b8c:0:b0:613:8223:321a with SMTP id
 p12-20020a5d8b8c000000b006138223321amr21146843iol.203.1645590001085; Tue, 22
 Feb 2022 20:20:01 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:44 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-20-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 19/19] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
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
it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
that the guest PSCI call fails if preconditions are not met (more than 1
running vCPU).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 535130d5e97f..ef7fd58af675 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
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
 static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct kvm_mp_state mp_state = {
@@ -137,8 +147,72 @@ static void host_test_cpu_on(void)
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
+	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+
+	GUEST_SYNC(r);
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
+static void host_test_system_suspend_fails(void)
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+	TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
+		    "Unhandled ucall: %lu", uc.cmd);
+	TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
+		    "Unrecognized PSCI return code: %lu (expected: %u)",
+		    uc.args[1], PSCI_RET_DENIED);
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
+	host_test_system_suspend_fails();
 	return 0;
 }
-- 
2.35.1.473.g83b2b277ed-goog

