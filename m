Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EE13CE53B
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346813AbhGSPsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhGSPps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:48 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25C6C0ABCAD
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:37 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id h15-20020adffd4f0000b0290137e68ed637so8909846wrs.22
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wr4M5V9fqDifu4W3yqELoDlyD/QsVKGAaDZe0uH90bk=;
        b=h91JnRYTdlcPoijWgxxAfjtdJIrm6H6BOcmFAhwd9pay0PJJ4cC6n1M9vbvnZ6znbT
         nS/1gN8idExqyOnrE/Bmz/LLcTPnhqFfeS+t1mMiO1wdPBzQPExNqThRPzw01XZUA+H7
         gdwMr0REM1mgF7ETdQ3FRIuAdUu2tv277ykNrgB5DnSPRjpGP76y9D0y5p/veJSbXPaC
         4CPTxA7GU2+sLTqJORcgVZ7s3n6pyJ/1grd2vbUGVhIssCG9VpF9EJsTsBHAfdzO6UJm
         4rntEOyEpDDnjgVG6RdAynoK+s7ZurB1veuHFd8Ap9cmHCr6tOSp+897JO54o+IABZLh
         QPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wr4M5V9fqDifu4W3yqELoDlyD/QsVKGAaDZe0uH90bk=;
        b=FvZAsUJ/R5D3Tvc5TgBBMBOj/CN7xqYqQ3foySteb9F9IO5/GwlJj/zF6vO8v6n3Di
         yDokCA/juysfGnlSvkzh/Yp/ghHwafijWmvYCADllM+jvAayf930lKqqBSizFd+mJN13
         Ui8NWlfxFQxjJH5iufcCjsR6xIxzpxvtnn04l2Xteqlzw5D7nhiVgx+Itrl5+bSdgDlF
         UEMU52RYeIMb0nKc0QpB4jRH3kACr51pxbAQdY2WtRGvgu3XQyUhQCzZYn+ZiDj5ZfEK
         31kpcGBhLbJAh4ZmdaiTrLxzHgHS8sdvRYIUTdrpgPkynJeuoiN10hJWhWc63Wkkgynu
         laGQ==
X-Gm-Message-State: AOAM533YDrz1cUDQguXApakVq8tE9n3MUjj08Cw0YJ7RiiDLPwpozMi/
        cRCfI+aEu/mKOoNhmuesG2JZWsj2ag==
X-Google-Smtp-Source: ABdhPJzzYFHkSS+rg5cJ0eIx8EjkgLZ9WyOnX41eM+jzRisgCK/ewgy3OonzA0LHza8N9WIoUOHe3/73yw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:530c:: with SMTP id e12mr29810469wrv.130.1626710659125;
 Mon, 19 Jul 2021 09:04:19 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:46 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-16-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 15/15] KVM: arm64: Restrict protected VM capabilities
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict protected VM capabilities based on the
fixed-configuration for protected VMs.

No functional change intended in current KVM-supported modes
(nVHE, VHE).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_fixed_config.h | 10 ++++
 arch/arm64/kvm/arm.c                      | 63 ++++++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                     | 30 +++++++++++
 3 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/include/asm/kvm_fixed_config.h
index b39a5de2c4b9..14310b035bf7 100644
--- a/arch/arm64/include/asm/kvm_fixed_config.h
+++ b/arch/arm64/include/asm/kvm_fixed_config.h
@@ -175,4 +175,14 @@
  */
 #define PVM_ID_AA64ISAR1_ALLOW (~0ULL)
 
+/*
+ * Returns the maximum number of breakpoints supported for protected VMs.
+ */
+int kvm_arm_pkvm_get_max_brps(void);
+
+/*
+ * Returns the maximum number of watchpoints supported for protected VMs.
+ */
+int kvm_arm_pkvm_get_max_wrps(void);
+
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3f28549aff0d..bc41e3b71fab 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -34,6 +34,7 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
@@ -188,9 +189,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	atomic_set(&kvm->online_vcpus, 0);
 }
 
-int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+static int kvm_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
@@ -281,6 +283,65 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+		r = kvm_cap;
+		break;
+	case KVM_CAP_ARM_EL1_32BIT:
+		r = kvm_cap &&
+		    (FIELD_GET(FEATURE(ID_AA64PFR0_EL1), PVM_ID_AA64PFR0_ALLOW) >=
+		     ID_AA64PFR0_ELx_32BIT_64BIT);
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r = min(kvm_cap, kvm_arm_pkvm_get_max_brps());
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r = min(kvm_cap, kvm_arm_pkvm_get_max_wrps());
+		break;
+	case KVM_CAP_ARM_PMU_V3:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), PVM_ID_AA64DFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64PFR0_SVE), PVM_ID_AA64PFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_API), PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_APA), PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_GPA), PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r = kvm_check_extension(kvm, ext);
+
+	if (unlikely(kvm && kvm_vm_is_protected(kvm)))
+		r = pkvm_check_extension(kvm, ext, r);
+
+	return r;
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b8430b3d97af..d41553594d08 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -181,3 +181,33 @@ void kvm_init_protected_traps(struct kvm_vcpu *vcpu)
 	pvm_init_traps_aa64mmfr0(vcpu);
 	pvm_init_traps_aa64mmfr1(vcpu);
 }
+
+int kvm_arm_pkvm_get_max_brps(void)
+{
+	int num = FIELD_GET(FEATURE(ID_AA64DFR0_BRPS), PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	if (num)
+		return 1 + num;
+	else
+		return 0;
+}
+
+int kvm_arm_pkvm_get_max_wrps(void)
+{
+	int num = FIELD_GET(FEATURE(ID_AA64DFR0_WRPS), PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	if (num)
+		return 1 + num;
+	else
+		return 0;
+}
-- 
2.32.0.402.g57bb445576-goog

