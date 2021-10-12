Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED3A429CA5
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhJLEjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhJLEiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:51 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D542C06176A
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nv1-20020a17090b1b4100b001a04861d474so1224000pjb.5
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O80RXxKd8P9hs8Tp3F97VMD6XsGe17hQTC/zrEZsizQ=;
        b=SvA0l3zedVEdqzURZ8w9+HdGYvSxtHH6R+4rarSwRZVDbUeoUP7+itvF+pPbZmYxgp
         tqNXFiiEQ5XcrfsIcKB6HF+9e09nLcJgmuiDt3NTbbJlZjUESi9d7BU974p5vaR+BlDA
         D9zX1ejs2fPDzhQ1c07zTov6Ee4fQgeyY1eS/hXiVWLnMGH1n0LDkoxFk1+GQ17XweAr
         8n3dBIyuW+4zyleYH6+CkBWwJgTBP5/rZxU9XOGR6SyX1JAZY1ZTXePq7LM46/q8wX15
         OUtenXDhvJfEUo+DWJ32JbW7Z8W1KVGCaY5QiXWiKuiqIaPPh6l3IQQrwUEzR9jW1X/c
         rbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O80RXxKd8P9hs8Tp3F97VMD6XsGe17hQTC/zrEZsizQ=;
        b=ZLimbo3acR4MS0WMhhdQm7LUR7NrWBF3DNJLcSUgAW7goSbWN5aVKGH7Jte3UbVk57
         MoxFr9oDlZRpqrtb4bJv0DOuxfdcSvVcv6GfA/S5B3fx0jMAMdDxIyme3Ru1E3G8kEcz
         kZRw7sYDolZ+rmZ0eXBopzJIKkmm/FSLv8zrhIdEE95eHd00YltghxECnSL+CHLMfneX
         o3VnG2C56fvlUf/CRTGPQETCjuXDsGpn9heWD5555slkUSHMmomHnToQhKlsP/I/PDw3
         5jFkqIrxwT3nxTAcc72XN1NexF4h26TEybn88pv4cE2JP6c+KSh7st90l3vTxeMbvvsP
         tHMg==
X-Gm-Message-State: AOAM532US4WrcZQi6IscbdeTDlxDEWaA4QajiPDRDJ9C1rKmGo/q/9zF
        cxPrxwa5tWVnf7PkuT4EAbDqaYpPAM4=
X-Google-Smtp-Source: ABdhPJyCqIvdNbnd9WwEvKh4oT9+MR9jl6x5aWloqmAyIa7gGMLPXWot1OgqE3Gfyb3ZJKtfcyeA94G0bQQ=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:902:b111:b0:13f:48e1:9bc4 with SMTP id
 q17-20020a170902b11100b0013f48e19bc4mr5211016plr.53.1634013403885; Mon, 11
 Oct 2021 21:36:43 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:26 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-17-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 16/25] KVM: arm64: Use vcpu->arch cptr_el2 to track value
 of cptr_el2 for VHE
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the baseline guest value for cptr_el2 in struct kvm_vcpu_arch
for VHE.  Use this value when setting cptr_el2 for the guest.

Currently this value is unchanged, but the following patches will set
trapping bits based on features supported for the guest.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c             |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  | 14 ++------------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..f11ba1b6699d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -288,6 +288,22 @@
 				 GENMASK(19, 14) |	\
 				 BIT(11))
 
+/*
+ * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
+ * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
+ * except for some missing controls, such as TAM.
+ * In this case, CPTR_EL2.TAM has the same position with or without
+ * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
+ * shift value for trapping the AMU accesses.
+ */
+#define CPTR_EL2_VHE_GUEST_DEFAULT	(CPACR_EL1_TTA | CPTR_EL2_TAM)
+
+/*
+ * Bits that are copied from vcpu->arch.cptr_el2 to set cptr_el2 for
+ * guest with VHE.
+ */
+#define CPTR_EL2_VHE_GUEST_TRACKED_MASK	(CPACR_EL1_TTA | CPTR_EL2_TAM)
+
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 29c13a32dd21..32fd6edbd9e1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1108,7 +1108,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
+	if (has_vhe())
+		vcpu->arch.cptr_el2 = CPTR_EL2_VHE_GUEST_DEFAULT;
+	else
+		vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ded2c66675f0..b924e9d5e6fa 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -38,20 +38,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 
 	val = read_sysreg(cpacr_el1);
-	val |= CPACR_EL1_TTA;
+	val &= ~CPTR_EL2_VHE_GUEST_TRACKED_MASK;
+	val |= (vcpu->arch.cptr_el2 & CPTR_EL2_VHE_GUEST_TRACKED_MASK);
 	val &= ~CPACR_EL1_ZEN;
 
-	/*
-	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
-	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
-	 * except for some missing controls, such as TAM.
-	 * In this case, CPTR_EL2.TAM has the same position with or without
-	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
-	 * shift value for trapping the AMU accesses.
-	 */
-
-	val |= CPTR_EL2_TAM;
-
 	if (update_fp_enabled(vcpu)) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
-- 
2.33.0.882.g93a45727a2-goog

