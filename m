Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C0443D3B
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhKCGbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKCGbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06CDC061220
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y125-20020a25dc83000000b005c2326bf744so2633444ybe.21
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IlnnjjxcxTrjMcB8yaJXHdEazmlLXcchfy7IakmUdZE=;
        b=lEBh0vzvOlg1yr5SMNuPf3yBIYSLDFvr1+EhJDIadybQX+1BavYADneMp+UbZDfKsT
         tDPsBoGaE4kyOUe/JIe67Ksbi+weqOPFfbtyfHVxSYKGdGcksQlY3dnWhQYd1hiGjHPG
         QihaOhYE+Yo95wwBLm4eNb7CZ5VFRYkk3X49wCCgsrP/AZ3nrKt+4OyMd5xoaYtofZNB
         ajFywJ1SApAGz1A7JqrmSMnA6QwV1OMcmtLp8YIo3m/HnGubXt2oFhz+uRsKghNKaL/Y
         vuhuosSxAuArRsnX6D/7btRUWlFtcQRaD2wrvvrZCNg6KmjmQaR0AxIBHlUiPshtz796
         xj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IlnnjjxcxTrjMcB8yaJXHdEazmlLXcchfy7IakmUdZE=;
        b=0yebLUP3D8EY2toutAnV6gYbF2v+ehrnOBmq78RcTOZqdTYqwsvPKw6amP6czcR0pi
         pOzG2Qqkw4f0l001QTJTdJwfX4ChtLMuEDsjqVu5Be6DPuEwSYsh/WLl6HKsfDxOQrZd
         4jsLyS4M4VctAODhDVmBMnl0dbjTMWp3ycP5+OsHwuZ4SWh+ZVZjUyzPiYUZ1E8303QD
         XN6XbW+tg1UpJ8qXyPnUceBl9RxqZg4z5wS2B55iryAMbfY6iu2ZaBIr8ZRsxgBxTU8n
         gOflgKYq1HCgd/Ee6BLXm/kDvYw3GiAJ4/ityMQUEvKTvF9gteNKRg0uCHvwCfw/IKnl
         5f3w==
X-Gm-Message-State: AOAM533rhfZMHMieAI4Ig2szyHQYzDOe826lbGFt3FHBaYdIsDWQ4VTa
        xjzG3h0yBnRDKABb3fKXKXxVieGWrVg=
X-Google-Smtp-Source: ABdhPJxgJ+HzJWMr3mZLEymaTOFsSPvpEYoeWmz+ySBuR2iPwDl/R17Ye21Yh4kCJ8QQZzyP3Hjs7R3utuo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6902:114c:: with SMTP id
 p12mr51484992ybu.408.1635920906196; Tue, 02 Nov 2021 23:28:26 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:11 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-20-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 19/28] KVM: arm64: Use vcpu->arch cptr_el2 to track
 value of cptr_el2 for VHE
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
index 87b8432f5719..37e1e07a19eb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1109,7 +1109,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
2.33.1.1089.g2158813163f-goog

