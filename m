Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DEB4D59F9
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240945AbiCKEuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346474AbiCKEuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:07 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8DB1AC280
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 64-20020a621743000000b004f778ce34eeso1972412pfx.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1OjK12i8EHB/xwmjswIl10AW6opGSFSXfAnin19ncrs=;
        b=Tdy0kI2iOENeYBXZpnjdLxKm/NPobNxKkPJR9u/6q42CzYhQZEaE/LQc/5FRsQ3FfG
         ojeXDADTFgC8S8KFlBe/K02Y6o5Byrfy9ta14+clKCipnKNi/fezer13gf4ZqtnGW79f
         tQJXvO22EdVEL9lz3gTA5pNvXZ/AlfGLHG3v2+PEtGUFEMU9j/6EvuzOrnK80WvJSmKp
         S60X842JGTTlJs/1/myvyVspgbxKE+t+CO6r7Ld/qWojdNI2V6fLiCC0iheIfup1T+/7
         mlAyd8Y8YOGikoxV4P24cz0jvIL03rl/pI5kltxUzJZVay8x0/qyIY5Uhb3S4/ZJHmw9
         VcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1OjK12i8EHB/xwmjswIl10AW6opGSFSXfAnin19ncrs=;
        b=rq7hxasTnj8Rga6lDYGbt++StCRz5k9hWLr4z7FdXmp1mWHsPoQihf4p0QettJpGHX
         Y0XW9krwA3SfTRN/jzY2WiiRs3wd/z1Mbcp14JAAHUhJxVtCKgsA3iLmPZELOYaS1Ghn
         20FEkVT0ff+Zh3Y5frs0SBCAC5wj/fe/x7SNqHjsWTeK9zDEVMZOYmwYUBXpm3TfXiDq
         8H6gpmHExszZD8qOsS79Fy9Zlyqi4rwnUotOUxc74Ho2uFtZ1AR/s4jYHlmivQYsVFvV
         GLUA3Pq0EUC8jcGMXEtl9oRgCbqiJ18zC/M5MZ/l9d5+5tCX7Pnk5Fad7aMmyrDWidbF
         LNcA==
X-Gm-Message-State: AOAM532ouN/oFSvIDcM/lo7LfaJ1tFJZ3xVvuYidUBE6smG008MH0TbG
        mcAoFXLdtu3M+TIyw14eXZucmWuFbmo=
X-Google-Smtp-Source: ABdhPJwcy43pnB6CMBNwp379nzYspjgrnPnrO7sxcJb9fAltkiOVzV8VIs9j+AIeZj6u7qs/OCe8irdFCCg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP id
 pg16-20020a17090b1e1000b001bf6c7854a9mr434960pjb.1.1646974139406; Thu, 10 Mar
 2022 20:48:59 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:03 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-18-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 17/25] KVM: arm64: Use vcpu->arch.mdcr_el2 to track value
 of mdcr_el2
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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
index 8ab6ea038721..4b2ac9e32a36 100644
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
index 7bb744bb23ce..ce7229010a78 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1182,6 +1182,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
2.35.1.723.g4982287a31-goog

