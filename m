Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89C35195F2
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344273AbiEDD3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344373AbiEDD3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:29:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4D827B32
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:25:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id g12-20020a170902740c00b0015d243ff163so134285pll.19
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vC3V+2CBJIc1C3R9s0y8nQnpmWBf83eXJD/GXiFHTxk=;
        b=i8yg46C8ANIA2EeY47SlTmObZ07geosP5go76P5bWKcOMH+uyUCxbwt2Kk168LIZHI
         LCNQZ3JxYIR6TmH+z2dqzuWIzq9GEKZ9n8W3JhDZXCRzh9m6SY2QF49N9xrhjOKjwHCg
         WIQDqZfNFaPw/Cod7ereFSUKrvtslwg2TmcmogERVoq2xsGKHFhX5xqeexzxnHIIyIGL
         BgPIoNlIoFuoWxdieMBrNc8F3m5kh9R9WSQifwTdGoUmhuZ7v86yEkdFWi0q9n88CFVd
         +i1Hw4yEvtj2vHYZ7/sgTOgNDW6jj2KLz2QNUJ/FSbyJkqgusc+FLhyoyF6Fquf/kbfR
         cXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vC3V+2CBJIc1C3R9s0y8nQnpmWBf83eXJD/GXiFHTxk=;
        b=DHFFvZZlANOZcRhMMwj+YocqIdrk0/Kis1czzXWCJGDYMtqyfYUeH615Clyt/Owjq5
         UmqsFcoty3Hy+ufDmGcSjKOOlaJjP2XUXhQ0CSC2Qjcsne9MWZF32RxHdqgUu9nb7z+s
         1aA8FRFkiYs8wg4K0CP4YqsPyGRamV3Ani+yexSJG8I+adyhOAcgkrFZi+fGxxjCfWjW
         Na4CAY4tKq9LPJl6Eyw/Y9WP/IF8yMmXHus9OCo1v+7lIj+TGcc0LjSQdCOeJMqh3vmR
         kT9ovOlcG/2yPWZvGvAtwUgYtSgmXgbCZf/sFJxi6vFthZLl79k9uWZ/BJr2pESpLRJA
         saBQ==
X-Gm-Message-State: AOAM532whRh6dVFP1l1mWxAnjibwyrTAfgC9XF0iXmFTmOAUCzxQr9X0
        SPydmmQ+ypANvFFGGu8JEhwJO/T9yrc=
X-Google-Smtp-Source: ABdhPJym7VaWlC5x9ioDgbuAXxdKjWGCuRNU6ZzBqtt+v8vwKT5s0AloQM3OscjKyqjYn0lPOfjYJrrWKWI=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr8262744pjv.23.1651634709842; Tue, 03 May
 2022 20:25:09 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:44 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-11-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 10/12] selftests: KVM: Use KVM_SET_MP_STATE to power off
 vCPU in psci_test
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
2.36.0.464.gb9c8b46e94-goog

