Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF29454168
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhKQG4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhKQG4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3119DC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:39 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u12-20020a25f80c000000b005dd97d128f7so2541864ybd.6
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wz9t+E+VXiepJL6MLtAC0LvVnUdPh/IHUgmRsgArlcE=;
        b=HvmUEQUJKrrfy7KQn+cPJTS8uyt5JY8g+FZ1ZhWzbq0B0GZkYE8v1oNob9IbqThMf5
         eIVgxeUWlrp58vNANslC25kMYjxXao1OoVVlwkeRdIQBFhpsxv1TvPOC2f7M5KZhw+37
         noAnmBOzEfni+Dz99DJpIx33CHG82FTQtENK+hjXje3ELzg0H/eOgdamlud+8hob8s/n
         d8TeP3wjd8FQ7MzygsQQiCs3/erA2mIHvazIYJTKNSdQxR9t4VI0XVvGS8E0HirEZClb
         c4ryR9AUVbcrH8j7FbGB2L7qnbJQcHQVRsWNS94rrM31RTtDfzmSJIvR8mqT25wutC/n
         BobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wz9t+E+VXiepJL6MLtAC0LvVnUdPh/IHUgmRsgArlcE=;
        b=0+1AJR2TEoRT3aAtu1qBWK+xTlgo9yxbXHcUH/Mk4KUqZ+Ly4hQAUh8j4NbA6J84rM
         xNWvmPSdAPbdlqe3TkvXM1FMB61UFojlyUE+7y3DL2RhyJ8S1xeelMzKgPws6QdADYo0
         3or3I7ZuHRHx5axkoNJfB/5cpTGWVhUkS1lBAtyagIV+ZV3MZK5MsEGN94WZK/FGaphH
         2GRqiG4SNnZPgwz9FV8TUHA6zd7s0lv3tAGhwi5i/+w9xY8dFlrBV/ICMB8O2WbdFlSF
         mY1sjcK9b+t4hmG2suVwMjVywpXx0QWGp1wpHlS6cFFp0UcCC1RWyh6TBMzc2k9FF6Dy
         /xOw==
X-Gm-Message-State: AOAM532ts21oJ/X17yrBEtTlV/jKqry51p80srl11UuJTI5cn+J6hQge
        iQcu7+YGml9dmXUAfpk3CoS6BKB2seY=
X-Google-Smtp-Source: ABdhPJyjCsGmjtTxCxe1Vx5kKC6qmnUVUhpi3G5rKbLKiwo+hm36IOcGaCTCDHDDH8Ex13kOFhhfD90EqIo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:d68e:: with SMTP id n136mr15514402ybg.59.1637132018496;
 Tue, 16 Nov 2021 22:53:38 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:49 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-20-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 19/29] KVM: arm64: Use vcpu->arch cptr_el2 to track
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
index a39fcf318c77..c1e0e1202f30 100644
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
index a54579e7ac91..aa4aff2588b8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1128,7 +1128,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
index 5a2cb5d9bc4b..0c3f0bf3fbf2 100644
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
2.34.0.rc1.387.gb447b232ab-goog

