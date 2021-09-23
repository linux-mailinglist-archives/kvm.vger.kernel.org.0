Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97CB4165D8
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242884AbhIWTR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242905AbhIWTR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836BDC061760
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b5-20020a251b05000000b005b575f23711so299297ybb.4
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U2ldqwBk17qF8sMmjm/VY0u4QjSaXwIWBiVrOhl2aZs=;
        b=aEtYZFNlk3fZGcGLyul66+37tVVs2OtdlmTMOFzR2aXZyttrz3WoXvPMSl5r59JVyr
         lIofk16aP6VLef+gS0F9CkKgZ7hABCK+Rh/V2Q+sWPWMS+M9XxMjtl7tcNtzpH/L+9Ga
         kGqqY7A9jcOtnmWYAO7yMEtvU5mkYU18D5imyfI12VJ7u3J0LuQ00migBbwJ2pCVXJYl
         5nB5RpbcYqwQw63BrLFwNwTf77KzNWCJfFpdtlHyTeTJ2WGrfUIHUxaTI7SKZ9auWh5z
         rH7CwUiKVqJwjr35Q8nYg2SrDlg2hIQxRq5uu25QIr15QI4z7yYrQyG5ITq+tTcqrKIP
         ogNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U2ldqwBk17qF8sMmjm/VY0u4QjSaXwIWBiVrOhl2aZs=;
        b=YBhtSjxOZAqb+C7zXfxHY0LA7/NoVJV05khbxO/76pCU9lpkhe89yTGP/dxjBumbgO
         flVIIrzRt8ld3V8ek2LbqJdpt0fzAxJAGetfxupmTYyK5NoCxAxfdkQ0Fra4NRwUQtLC
         afy134mktT5ncF9GH4azciKajB2FbAVvoyEBxUE0RH5G282d9IA5fStu5wRNMckQnBKR
         oCwkkkjZ48og4wizBfiv8LlGPFiXYcjWvP7KlWeJz5Y+8MJmqhWEhWNyTJd84w1Jpe/p
         8yBa7wBRM9ojZYpn4UUOFf92j61exlv01DDQBF2FSj1UBmz6l2aXfUMn+yhq/dMvXOuM
         +z0A==
X-Gm-Message-State: AOAM530WYzL7V9eD+KZSBox+1PasNfoIa18BfGjx24pvHj3GNOdU7uzN
        UjLIL6iDMkwHJclszStlFT/n+2PNJ78=
X-Google-Smtp-Source: ABdhPJyqHXosu+dqAJLT4LzmBg3B50Oe9S3R7psdBVQf0KyXF99CbnJiJj78oOxsVMiagI2g5lP3Ar5SRqI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:c753:: with SMTP id w80mr7792105ybe.245.1632424585769;
 Thu, 23 Sep 2021 12:16:25 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:08 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-10-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 09/11] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
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
index cebea7356e5a..8d043e12b137 100644
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
 
 	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-- 
2.33.0.685.g46640cef36-goog

