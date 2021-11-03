Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7435443D3D
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhKCGbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhKCGbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BB3C061227
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m26-20020a62a21a000000b0041361973ba7so821931pff.15
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EdHJWCMm4NV+zJRBLh5gcwFmb5wMlFeWAuDD1adtoYc=;
        b=HSIF6NAUdvPrgANSGhYIWgwF1jUyd5ydPLTE79DZ9GKwqdi036Iq+H7of25JO5e6QO
         umAl6yAgnerVr6PWB6ELJ4/bNlbhFTPmq+769yQkggLo2BDo4rY4IcgwqzPw5hx0OgWo
         V3iAXr6tcodFhfG1PFdOabRJ4EXdUoj/4ooYpZnAFCRHQ1XioG7JGWBmnWlF0N6JYooe
         h9IwcEfMH8qHkHGXf4DHyysQEvkHDkbVKvlQ7nXFWVIA9IXR2Ckbl99aKRXB2z6ASgBy
         WmOSDDwfDj9BFFVvgyAtiRUFgkjGfi8VjzYnUYx22kef6omdekETv0DAvl8JL0KQT3w5
         hctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EdHJWCMm4NV+zJRBLh5gcwFmb5wMlFeWAuDD1adtoYc=;
        b=YteCAltsLXiF5T7liSHbBGN35kNMlowrcRPrklydFuCTPEUgc1br7luEHzZ1DtRXyA
         XWqg7h+luNZpQ1dzT+rORScBRd8akOtpjZXHzOloqZZbqgVEK037Z+M2vifuQX8y3Nud
         doL69q4tHlf12rOaHvox/tcWFfNe+yciYoe9eLVJAQZOA5IAAE8FjNmWHtojjJq4q7gh
         Tw3XiNJEbPxvSCWLQOCnJZYbqT39pRNqHZe8xKZDMkff0vm03N0+VNIxkTPSlSS8WP3i
         yitco3sMfkdAmYtH6RWLuhA68LEYPKeEycjQtlWWipGK5WPQT1tw6EPVuChLgDEV8+mS
         uiIQ==
X-Gm-Message-State: AOAM531T90r1r9R9I/Wbr/i44nwldIsBWOc3eNm63AUHRoOLKEQh6sWu
        dZJ4HZRvIVgkd3LQ0ApAhjBzrgPUEiQ=
X-Google-Smtp-Source: ABdhPJy425WLxwtQdf0ugi+KRB/vHRkkXwn77RmTJo/tV5q3EUWFYunH8uYLN9iDLTTqEDRgvoHtud2mw8I=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:aa7:848a:0:b0:47f:d648:2df4 with SMTP id
 u10-20020aa7848a000000b0047fd6482df4mr30111827pfn.63.1635920907782; Tue, 02
 Nov 2021 23:28:27 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:12 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-21-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 20/28] KVM: arm64: Use vcpu->arch.mdcr_el2 to track
 value of mdcr_el2
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

Track the baseline guest value for mdcr_el2 in struct kvm_vcpu_arch.
Use this value when setting mdcr_el2 for the guest.

Currently this value is unchanged, but the following patches will set
trapping bits based on features supported for the guest.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/debug.c           | 13 ++++---------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index f11ba1b6699d..e560e5549472 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -332,6 +332,22 @@
 				 BIT(18) |		\
 				 GENMASK(16, 15))
 
+/*
+ * The default value for the guest below also clears MDCR_EL2_E2PB_MASK
+ * and MDCR_EL2_E2TB_MASK to disable guest access to the profiling and
+ * trace buffers.
+ */
+#define MDCR_GUEST_FLAGS_DEFAULT				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
+
+/* Bits that are copied from vcpu->arch.mdcr_el2 to set mdcr_el2 for guest. */
+#define MDCR_GUEST_FLAGS_TRACKED_MASK				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA |	\
+	 (MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT))
+
+
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
 #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 37e1e07a19eb..afc49d2faa9a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1109,6 +1109,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu->arch.mdcr_el2 = MDCR_GUEST_FLAGS_DEFAULT;
 	if (has_vhe())
 		vcpu->arch.cptr_el2 = CPTR_EL2_VHE_GUEST_DEFAULT;
 	else
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index db9361338b2a..83330968a411 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -84,16 +84,11 @@ void kvm_arm_init_debug(void)
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
-	 * to disable guest access to the profiling and trace buffers
+	 * Keep the vcpu->arch.mdcr_el2 bits that are specified by
+	 * MDCR_GUEST_FLAGS_TRACKED_MASK.
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	vcpu->arch.mdcr_el2 &= MDCR_GUEST_FLAGS_TRACKED_MASK;
+	vcpu->arch.mdcr_el2 |= __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
-- 
2.33.1.1089.g2158813163f-goog

