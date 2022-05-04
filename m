Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705B65195F7
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbiEDD32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344461AbiEDD3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:29:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A2E65DD
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:25:22 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so79424pgn.23
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O6gsi1VosCJ9Q+QJJSE7NIUXWalRHVe1tFy/2jVg0nU=;
        b=J2nRE+pM0k4FjNp2cMlnN8/gWRkViT6d6HglwgNSrVeXwgSSlC2eD0N42z2TxFenrK
         1++90Z1DhXB+oCBWCaQUko3MtAX2Vwd7k7Tg1W8U1wFg4ebNTsyShXIVfZkQlXp61hpV
         P8TkYscwX69KGqwKqPYsXZHORIsX6xH+TgDrD+LwGi6A533g0QAbvuLY4DBvjChRlkuh
         uAKUg7eTOY8BCZ0zNkVkrc+zK8FyrgaDWWHxRBy50l5jAmd2A4PbUM4xe1EOHPswFwyu
         luobZxTR3exLfL81rO4/ZURyhjwdWEhoN7RcpAgHC25Ze+urfrMTfV3ojBPHk7Pyw04k
         jjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O6gsi1VosCJ9Q+QJJSE7NIUXWalRHVe1tFy/2jVg0nU=;
        b=W1tHmg/P818speNPfH1FjQw6BxywvguK9aq/GynS/v3yoLg+SDEZVj2YQ5+N1ZYoTX
         S3YDiu4SMpu94BNSl2VVKBaRkLNn8TYqkvzfbIzv9V2GobHrx05Dpa+wGHYNlMv62EME
         il0JlHU1dOn8ThGWrRSrLyL3qxLX5FCPBfSxt976YIpoLu4bdbB45cmjdmb3rVZJmMD0
         H2VgeVkUzt8G9+tu39+XBGiVbeQx3hoWqcVq1KelmIjbjtns0foN7/1mZoQF8xZhb3pz
         Utp0wlrOEpAU/vQV+LzyFG40wccQQk9VKJmqVtEcZkskNrZXG6Xbc6XMCDFSqgbOtuJ2
         xjNA==
X-Gm-Message-State: AOAM531p9qpUiyfaoYtOfa8AGMMN3qIs0R3DITUPQxHSG/NXn33W4bre
        UsDqxBt9yPzvw+1mWB9R9f/ZQQTimWg=
X-Google-Smtp-Source: ABdhPJzFv7NkWcBU+6vplhxBAUpwjxPW1/ACANI7rwBZF4ra9bVHx4OSHqKJtvMgIzFZVeY3+CTj/EOn3DA=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:9309:b0:156:983d:2193 with SMTP id
 bc9-20020a170902930900b00156983d2193mr19155791plb.158.1651634713185; Tue, 03
 May 2022 20:25:13 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:46 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-13-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 12/12] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
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
2.36.0.464.gb9c8b46e94-goog

