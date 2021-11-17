Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9308E45416A
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhKQG4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbhKQG4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:38 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346BCC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:40 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so853178pjl.5
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bVvTx2BZnkE8y36lnLN4c9tpmfEY262vaHDUdbxg7yo=;
        b=chhFom6QinoNu6eS6p07QKazNwcXw2TGfQ+sgoSXzF+gknBuTEybuqRv6xwEX6VFfY
         1co6CwLMeyDC1nMRrTU0BYtd94bnobsm16nyqYHJ7Af1HNWKh28bWeHGA6TEDPU0Bjxb
         nAepiDzHTcZYTo92Px+bpbDmsCXkvGTHQfWeXPa0GuGzP/yTDpGYHNMsZL+4q5BWPtJM
         Ze1RrftZ6XrT4KUpEjVNUkGKxz5XWKxVU/91mkxgyqnBDAiPUJxgBQw7ULIeE87amsqP
         +tJVS84pe3nU2oQd2CdDCc9y4iBQZliw2b21XSD9jNvZCVgiXE0i+CbHYwplT3f9gKe7
         mcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bVvTx2BZnkE8y36lnLN4c9tpmfEY262vaHDUdbxg7yo=;
        b=5ws6dEZmQ1xYCn0h/J2AL8u0D/qc4g13fA7cbOMDwfttW7gZidyDYM/jOKMfi/xImN
         1E8wmHGA4hx7Qd+pYXNiNwzkh7lWbsWkXr5dMGgPUQJ4czLrecV0cL8d7ev2yzdUpkJe
         zP7xWwWgNuIuFyU9QF6VhsaUmDlmZQY5E/dfPYaOf6ICsgH5pbEurNCPGkvgovsgwmzH
         h/wxbAX3F7TRBe2LVwc8tVMfepwpKqmMv8ArSJa/zyWbysUxO2UXWHd0SwfrCY9boY9L
         Dx/fNX5QPM3MtQT4DiNHu3fY3Wn7HJ1KHBCwjcBEXbmrkgu4RUNDz4JH+00Q3XAe6xI2
         0leQ==
X-Gm-Message-State: AOAM531OHAWLNIZZWMz+1J9vgzSmY0FEU61jzVrZvgOI4VRSiavJpK3P
        YmA56ZeA3IPjdT+nivi/jVzCuAViUIY=
X-Google-Smtp-Source: ABdhPJzMYgs7BRw3Qvd8VMWzmCaGHXPCN7+Z05SQBHE9IY6dw1vxa7sU188j1XsJMhABUy7JyUt3ZP21i/o=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2296:b0:49f:feb4:6457 with SMTP id
 f22-20020a056a00229600b0049ffeb46457mr5087645pfe.58.1637132019739; Tue, 16
 Nov 2021 22:53:39 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:50 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-21-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 20/29] KVM: arm64: Use vcpu->arch.mdcr_el2 to track
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
index c1e0e1202f30..e81f21995314 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,22 @@
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
index aa4aff2588b8..64b104ebee73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1128,6 +1128,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
2.34.0.rc1.387.gb447b232ab-goog

