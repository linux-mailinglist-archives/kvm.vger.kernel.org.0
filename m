Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB1D3CE535
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbhGSPsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350273AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5118C0ABCAB
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h1-20020a255f410000b02905585436b530so25891058ybm.21
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XfYC7GtwCzce6ZhnFCXG3Bv02gpIIg+CxJPXUjvg7WQ=;
        b=bwTUJXGbHV60w2p6YQDBqFUvMzTRBOK+o/sNpUyXJPuo36SWYZtj2M/HxMZnK0kpa7
         af+PYMfDDtHVfTR7GZ7Zfj222Uws1N4VH9Tsbs+tcEr0ZNXC25MNmf1vwIdmPnZ7xUhY
         SlhnRt11MfFxPGlpenEuUxGJGZCJmyrZKvI4atxKugAQmrGPak5VHcCypKFwVvGtPb0Y
         R1N1rD+zSc2NRQprUU89+vNC3BEYv2REpidOs7XCBq6YvcBqC78huig7Dser2AX4eMlA
         1lLiZoEjV+GtacstdLDjpwQ5ID+mzhLUMXrnY6L2K/EmYewOXZQCwUWUCVsdhnxgCagG
         P6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XfYC7GtwCzce6ZhnFCXG3Bv02gpIIg+CxJPXUjvg7WQ=;
        b=JijJU4xLZJo1sKsZDoNdoETudSe8HOdT4hH5fH7G8qdZtTfU5vvdGPLKFczJu0xo7Z
         KJwhdjINwlyLfgXMUxDkhL6WJmgkBAy7zOY6u9N9AVmfVTVn5Ud0X7eecVoPSc1ipd7/
         YY5CGVjmdLbBe33KaSGZ1BlERc2I2CuKikJkEv3DIErGd8P4vOVwLtLgzfBe905z7CPq
         7kZezUdAqTJV16NZuizjhYCH488wbj2qsJk12ikPISg+aBZsEDyd6WGOwQlTsqvepESb
         fN7lvM76xFBQWjv2bqe7mgNcafoUTb9sPL7qtwnT8xx704RQrBLpPuj4SIfzY6ULnOcY
         W4bg==
X-Gm-Message-State: AOAM530X/bTXLTVv0HH7a5JDvqMCMksk5qVUreb8zXZkm2VSXwPEru4o
        GUQa91ISovnUiEy7GlkpgeKa2Kxptg==
X-Google-Smtp-Source: ABdhPJz+V2mbnO0SPesWcZxOnZ7G22wvyRqCMG269fKYfL4HphjBW2ENB0OeZ0xD5198USCahPcX6YInPg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:d88a:: with SMTP id p132mr34391631ybg.409.1626710657055;
 Mon, 19 Jul 2021 09:04:17 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:45 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-15-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
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

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8431f1514280..f09343e15a80 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -23,6 +23,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs might not be allowed to run in AArch32. The check below
+	 * is based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
+			       PVM_ID_AA64PFR0_ALLOW) <
+			     ID_AA64PFR0_ELx_32BIT_64BIT &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.402.g57bb445576-goog

