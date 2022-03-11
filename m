Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB14D67DF
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350865AbiCKRmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350853AbiCKRmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:18 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939DD1BE4D0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:14 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso6754175ioo.13
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OfvwPno/vdVeaI3Bj5TBXZDiFhwzoDjkPKpMT+kPSsg=;
        b=Z1f4KpYaERqF+Z8wu4YaA3FqS4uUe0o489BvF9qQu+m5jAdV0e2lMnn0bKzZiIFKyu
         X9L0LQInEbA43NtmcasH163uIOWEZHF3m9b1oFQ+1LaU4nvjnfGfZTIHgK5xa8joRgCu
         U5boVyiFvKsnlsC95lZ8jC9d8iyyZSrkS6SVwlS2nJh7p3Ido7dU9sc6ZRyMyHxJmau0
         i8N6iXnmHtU2hFZEQmx8s9+B31O6AD4yFPqMS1Nhpn2SBevF+B/EsO+kow7ntN2w8Ct7
         CBaCCGL/lP8tkCaikzq/yHBUzh5uGWOOQ7sObzGy/4p6HA3MQwYcM7CsC78SX91YbDz5
         DpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OfvwPno/vdVeaI3Bj5TBXZDiFhwzoDjkPKpMT+kPSsg=;
        b=uPUa4V6tF/lJC1unGPGSYKYXla/e849eaDjR4GldnzOpq3o/DXf7sEQpKyGncLjNh4
         6Ji8yjnN20mepYdCJVVaimfHghLCQwp2q1SKatkXK9Ymu5C+ywgnHnjHCypBgugxP1JN
         YdDmPmZkNPa76PPDydh5u45eqtp2UbTpwIdBFirm+yafK80W/vColiXEOIbWk6ofZqpJ
         fdqIoeu2AHeZutkqibg7W9yBUHgl8RUgudR64S7/RKx9TnT4swaFYcmX5GcTf+JEMTbo
         Ys6ouhkPK0wY12Akz1a9Q6Lg/E3FR5Fjv1aNJagWK/WFhe+TmaTOtWgTYg+6XFdRTaeb
         Nhug==
X-Gm-Message-State: AOAM530YN/51NTZd7V/rnxDWHVS+ti096cHrMu2wW7kNoBN+bSax6ib5
        UzJX+DqFxP+Y9tzlZUGjfJwfohV0B18=
X-Google-Smtp-Source: ABdhPJxU4o6d12HlS+cwJHR6AnNPMTg+5NGTOavt5pmb+N5rymKdGyajtqzZmyUeSPjQs3h26Wf1GyDGFoA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:dcf:b0:319:e022:ad6c with SMTP id
 m15-20020a0566380dcf00b00319e022ad6cmr1001835jaj.143.1647020474006; Fri, 11
 Mar 2022 09:41:14 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:59 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-14-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 13/15] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
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

Setting a vCPU's MP state to KVM_MP_STATE_STOPPED has the effect of
powering off the vCPU. Rather than using the vCPU init feature flag, use
the KVM_SET_MP_STATE ioctl to power off the target vCPU.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 8c998f0b802c..fe1d5d343a2f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -60,6 +60,15 @@ static void guest_main(uint64_t target_cpu)
 	GUEST_DONE();
 }
 
+static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_STOPPED,
+	};
+
+	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+}
+
 int main(void)
 {
 	uint64_t target_mpidr, obs_pc, obs_x0;
@@ -75,12 +84,12 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
 	/*
 	 * make sure the target is already off when executing the test.
 	 */
-	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+	vcpu_power_off(vm, VCPU_ID_TARGET);
 
 	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-- 
2.35.1.723.g4982287a31-goog

