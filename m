Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580274FAA69
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiDISsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbiDISsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:09 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D89D22B25
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:02 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id l8-20020a056e020dc800b002ca4c433357so7600403ilj.23
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GrTuEsowgjSLSh5SPFZtOIzYck4sIL1A+AsuQBdb1R4=;
        b=ZEKDnqh1E68l3QyvAwE5py+QjZMcctkJAsooLeFVX+b3t24hnB1aJN+oIh6gCVrXml
         cRpXGP3e2CkDJugK+ETgdNu5r/nuHLmgDAvgQxtuc0CY57lba5ChcNaAGtYqB8qBnNeU
         elaRjDfxj+EW1CVaH0QZnJI+T+xmw69neU3WhJU2JbtPNbrcKPybZgzDRQRwqBd40HU4
         o82y67LH/WWG77pZSLlcykW607i6/EZYZmXjitv2C1BbjNYLGR0AC+he0cLCSKCebrsv
         KtroytYnfn8t/GA8eLiIEoV3EHLcGjNsoUPxnge+zp4QQLP0NSYqtAhpZQ3ItwBsCduO
         56+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GrTuEsowgjSLSh5SPFZtOIzYck4sIL1A+AsuQBdb1R4=;
        b=yxxK/K2X9fv7mrER74IBhnUBuGxfDHXeBAGKsswLw/7NCUUZ1d3l0OIrL+mZj8lBAj
         oU3sGhzbsIt4naw5ebmBHCxpmP3h2lsQsBKanxqLXXdZF2kcfoZcxvsVg08TWHNTeUo/
         MtCPWHlc0zy6VnDFpF1izaG0vStHwqp9KUI3CxAnizj1o2x09Xj4eIYOGOZkrKJW3W8y
         8seB+rIKZzl+mK8ass0kXuJlOfB/bsi4MhWwk02Fm8MP+qd221iASxfUMkikN+xH3H7a
         tGnYyyFHZyZQcKMOuUxRVNxu6OrhvbLlOIVxuoMNiydqnk5F1mA3NU5uklRBnQKqpmg0
         T9qw==
X-Gm-Message-State: AOAM531CHEI/z5mgN48zassY0rl9ZqkKglis8YoGDX72IjWlibM7EHP6
        J1+0YXTJ2jEujtVYJ9XSB5qhBxaplPo=
X-Google-Smtp-Source: ABdhPJwE27yromTM7IHeD35r5yOQuHh5y0AoUWsUzU99gkjTTiS0e8E0ysBofkG6VXxzu+eSD3Fqgn3yTIA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:174e:b0:2ca:1fda:85b with SMTP id
 y14-20020a056e02174e00b002ca1fda085bmr11371943ill.85.1649529961465; Sat, 09
 Apr 2022 11:46:01 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:38 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-3-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 02/13] KVM: arm64: Dedupe vCPU power off helpers
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

vcpu_power_off() and kvm_psci_vcpu_off() are equivalent; rename the
former and replace all callsites to the latter.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  6 +++---
 arch/arm64/kvm/psci.c             | 11 ++---------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..490cd7f3a905 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -841,4 +841,6 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..28c83c6ddbae 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -432,7 +432,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void vcpu_power_off(struct kvm_vcpu *vcpu)
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
@@ -460,7 +460,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1124,7 +1124,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3d43350ffb07..cdc0609c1135 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -51,13 +51,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_SLEEP, vcpu);
-	kvm_vcpu_kick(vcpu);
-}
-
 static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
 					   unsigned long affinity)
 {
@@ -244,7 +237,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -378,7 +371,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.35.1.1178.g4f1659d476-goog

