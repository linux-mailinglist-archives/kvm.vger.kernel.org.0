Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEFC4FAA6A
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243144AbiDISs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243136AbiDISsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:19 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE6424959
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:11 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id o17-20020a92c691000000b002c2c04aebe7so7643756ilg.8
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MMbJ8GPbxLd/QjbYzRi47+OsTy08VP9GXDUZhFt58o8=;
        b=UmbfA4iSxMPA8fk6qLLzD609587uXylxPvsJyjpO+zhYDsmK1Cc9jUcA/aAaWZRxCu
         tHA/r1//CW2+0IOUUQzAc1M+GSndHUAVcLcHEyWzIre8CytvdvXZQ5lzzX5pStECTyAD
         AKceZSRfgjd0ctaY+wtM8gqfEtoHvyI6hWHmdgOMXnRxlWFFZI7sAbL+xR5l8KbSPYI2
         oA/hxbNHLk18KnkaMdrRE4XFrFJ+BpwfQqp8YUf0b85zV8WdFPSOrW9J3TzBZUYo+rkg
         gs33Ks3C5NmgZ5zo5dPhEMcQG+itPRxbJT6gVqkXeRzo5kg2MY8SPKC2wHLeJR9UtFF2
         D8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MMbJ8GPbxLd/QjbYzRi47+OsTy08VP9GXDUZhFt58o8=;
        b=pUapzwq4+VOZTNJQ6grc75OAXzyhZJqimHLfxd95xVFv4Eha5zLaIVpJCDbGUN7PWh
         EHg738WZb5raGsf/KnpZjYz2Um3EEPeIyBa+sF8BeXXMEriprxZpLdCEettGm/HosnmJ
         rqQrBdgW0aI+VLbogvln4tbp+161f4SDvJw2yxoR0YhybCf5dgTR8W3Gg6PUTY0XYSDt
         Tm1PokmvYvXKQMGVBqcO9L4J8RAackR4RzEXresUYuybZW+5ie7gUA2fMN6peF55u/zd
         H5NiDcelE4d+GOzQ14oUUtFYZ+6zWEqzkMOIhrnXXyvGho0d5zaKoE6h9nn5AnpVoLg/
         zkxQ==
X-Gm-Message-State: AOAM531+mz2372QwSCGsqQy/JTyPi2uqvrcnGWNaPXkXAsfj4slClJCc
        jaqYcBym5uXba0OceJeQQZ2yxwSFP0Y=
X-Google-Smtp-Source: ABdhPJxlH14Og43qv+kMIjC03b6Q3ltqRhEMdMCiQzsvYUfxJs6dhn0LzpS3eneC9kFiQWN4ueXFk59kq8Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2b04:b0:645:102d:2f86 with SMTP id
 p4-20020a0566022b0400b00645102d2f86mr10947073iov.153.1649529970585; Sat, 09
 Apr 2022 11:46:10 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:47 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-12-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 11/13] selftests: KVM: Use KVM_SET_MP_STATE to power off
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
2.35.1.1178.g4f1659d476-goog

