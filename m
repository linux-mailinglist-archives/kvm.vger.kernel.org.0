Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC3F426E31
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhJHQAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHQAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:33 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D56C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:38 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id r21-20020adfa155000000b001608162e16dso7641194wrr.15
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AF4eoE9nmTsCT0Js3LBGybKDMs//CEnYD1ixUfZLO5A=;
        b=HrX/tXZNkaeFiS/Yr9pl1oq1+0zeuOqeAHJGn2qe8JO4G/wLuWNBfMYAYIKenUyhFF
         kuwgap7uYGwB9lbgRTrrzFvBRfc5GTp6gDn2p2ZkQg4OQQ6CbUVYhINNQTUbE6CG1x+u
         VgtL9rvo7JkyvdIWsWzR64tUymk331Q9gHfbuO+LMpGfDgMnY4iwRqJrNDC5yB2Pp0B/
         6USPoZ3qlRxMFyOYzTijyqhdDGEZRlbjdUHyXukJsF38lLpIl0EUCHe51fzZMHYzQueY
         SIHL+z8spXeDqMeZlzE955t3JhWu1va8sSstpC0nHZ44ivcmnYXON/3XDDBtTNoBf7V+
         dVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AF4eoE9nmTsCT0Js3LBGybKDMs//CEnYD1ixUfZLO5A=;
        b=sLTOZED6CNm/PqSwu++sAWzOlvsL/xQrLw6ylWFnfWNoJ5e2ZFmgn4JUs0hLG4bHLj
         XVwFWfJDT2DmBQHm7+NdnXg/iHOY4txVKuIuvEo7TA7fJL+ICRZbBxL/RYIqYr2LiXpg
         L1AbETOt5kQhT33GeBB8x5tb73F4FVsObwl0ExENMAq6hFBwUvnJQbbhMl6UIn6ierZa
         vM/fsAIWteFVQkOgWRB8i1QPnA+vxGLG7IkN7Mcuuj5r9SRELFn1kWjUYA1xhCwDd0na
         JyoYmyIwwWZ9wMX8zLvfqV8C4vgCr5/LtM/KNFmcSp8de7Ply9ZJqHSxe6DqiHOhCIHF
         xlbg==
X-Gm-Message-State: AOAM532y7XFii/gNbtkvcX093WJS6yzG7SwUQ3tdjH+TGRkiqukBcjQp
        R/9qRg5WsAO0MYzc6d+1949mbAruFQ==
X-Google-Smtp-Source: ABdhPJw3j88fx7mXkHrzClQzYUDvVzNXlo/iyFzAMOjG+H/NnjBAl4bNhcg6VI+X9rIoncK+E3JLXUWlyw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:1911:: with SMTP id
 j17mr4361730wmq.149.1633708716599; Fri, 08 Oct 2021 08:58:36 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:22 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-2-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 01/11] KVM: arm64: Move __get_fault_info() and co into
 their own include file
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

In order to avoid including the whole of the switching helpers
in unrelated files, move the __get_fault_info() and related helpers
into their own include file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/fault.h  | 75 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 61 +-------------------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 3 files changed, 77 insertions(+), 61 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h

diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
new file mode 100644
index 000000000000..1b8a2dcd712f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_FAULT_H__
+#define __ARM64_KVM_HYP_FAULT_H__
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
+{
+	u64 par, tmp;
+
+	/*
+	 * Resolve the IPA the hard way using the guest VA.
+	 *
+	 * Stage-1 translation already validated the memory access
+	 * rights. As such, we can use the EL1 translation regime, and
+	 * don't have to distinguish between EL0 and EL1 access.
+	 *
+	 * We do need to save/restore PAR_EL1 though, as we haven't
+	 * saved the guest context yet, and we may return early...
+	 */
+	par = read_sysreg_par();
+	if (!__kvm_at("s1e1r", far))
+		tmp = read_sysreg_par();
+	else
+		tmp = SYS_PAR_EL1_F; /* back to the guest */
+	write_sysreg(par, par_el1);
+
+	if (unlikely(tmp & SYS_PAR_EL1_F))
+		return false; /* Translation failed, back to guest */
+
+	/* Convert PAR to HPFAR format */
+	*hpfar = PAR_TO_HPFAR(tmp);
+	return true;
+}
+
+static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
+{
+	u64 hpfar, far;
+
+	far = read_sysreg_el2(SYS_FAR);
+
+	/*
+	 * The HPFAR can be invalid if the stage 2 fault did not
+	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
+	 * bit is clear) and one of the two following cases are true:
+	 *   1. The fault was due to a permission fault
+	 *   2. The processor carries errata 834220
+	 *
+	 * Therefore, for all non S1PTW faults where we either have a
+	 * permission fault or the errata workaround is enabled, we
+	 * resolve the IPA using the AT instruction.
+	 */
+	if (!(esr & ESR_ELx_S1PTW) &&
+	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
+	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
+		if (!__translate_far_to_hpfar(far, &hpfar))
+			return false;
+	} else {
+		hpfar = read_sysreg(hpfar_el2);
+	}
+
+	fault->far_el2 = far;
+	fault->hpfar_el2 = hpfar;
+	return true;
+}
+
+#endif
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..54abc8298ec3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -8,6 +8,7 @@
 #define __ARM64_KVM_HYP_SWITCH_H__
 
 #include <hyp/adjust_pc.h>
+#include <hyp/fault.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
@@ -133,66 +134,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
-{
-	u64 par, tmp;
-
-	/*
-	 * Resolve the IPA the hard way using the guest VA.
-	 *
-	 * Stage-1 translation already validated the memory access
-	 * rights. As such, we can use the EL1 translation regime, and
-	 * don't have to distinguish between EL0 and EL1 access.
-	 *
-	 * We do need to save/restore PAR_EL1 though, as we haven't
-	 * saved the guest context yet, and we may return early...
-	 */
-	par = read_sysreg_par();
-	if (!__kvm_at("s1e1r", far))
-		tmp = read_sysreg_par();
-	else
-		tmp = SYS_PAR_EL1_F; /* back to the guest */
-	write_sysreg(par, par_el1);
-
-	if (unlikely(tmp & SYS_PAR_EL1_F))
-		return false; /* Translation failed, back to guest */
-
-	/* Convert PAR to HPFAR format */
-	*hpfar = PAR_TO_HPFAR(tmp);
-	return true;
-}
-
-static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
-{
-	u64 hpfar, far;
-
-	far = read_sysreg_el2(SYS_FAR);
-
-	/*
-	 * The HPFAR can be invalid if the stage 2 fault did not
-	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
-	 * bit is clear) and one of the two following cases are true:
-	 *   1. The fault was due to a permission fault
-	 *   2. The processor carries errata 834220
-	 *
-	 * Therefore, for all non S1PTW faults where we either have a
-	 * permission fault or the errata workaround is enabled, we
-	 * resolve the IPA using the AT instruction.
-	 */
-	if (!(esr & ESR_ELx_S1PTW) &&
-	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
-	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
-			return false;
-	} else {
-		hpfar = read_sysreg(hpfar_el2);
-	}
-
-	fault->far_el2 = far;
-	fault->hpfar_el2 = hpfar;
-	return true;
-}
-
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 {
 	u8 ec;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..2a07d63b8498 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -11,7 +11,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-#include <hyp/switch.h>
+#include <hyp/fault.h>
 
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
-- 
2.33.0.882.g93a45727a2-goog

