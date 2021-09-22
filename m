Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93390414977
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhIVMsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbhIVMsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:40 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF2C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:09 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 70-20020aed20cc000000b002a69b3ea30aso8645005qtb.15
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8HufL+ywsGIDKOrokk6Iy8lrW4K6FhnOg3XWK/L1Z7I=;
        b=AKoItvs5G1Irmr9FftGFI8y5wIfg/Vj0slTcX7S8Hl+TEisu7ntGUaknkWjRPr/SHr
         4Wyup6YVc1mKURvD5CTf8K/xDPp+KIXKCdp6jIbkmxl6v1Zv00B2VCkRwTN71+A51yV1
         etgf5mHDPHB3i6MRufJhiFkPed0Xf8rAK4QCLh85/j8OB0xHoJMsmsaakvElo53Jrb8x
         bsl+pdAdbYN5um0hvoIIFh4iZirMejGZTYJ04iZ2W3mLAxRw8HrWg2XbF9XfAmlqTCQn
         5ME0FLaXjhzXFjxKdLhxGTj1WmZD8HrpWdFkgGEce5/jUQoop7PQhH+sDysZftIMrTs9
         KjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8HufL+ywsGIDKOrokk6Iy8lrW4K6FhnOg3XWK/L1Z7I=;
        b=1c80tiSBJCHE0QAhZNDNGdq2DFbVBLJgl55PpOXegMsi4dLCZapphV+GcbfVPSsU7E
         F6mj1teaug4oEN82UJPMRIOJ244iOhsRCFNqNga1jVN3CLCTzTP1rBIIbTs/T+y/6Jq0
         DUxN3YXqal5u9dEef6t2Yw0O258IpeLHlCwtkVcIOatiqdhz94+7QRkN54iH3SF+1en7
         pvHfkD+9AWAaF/9HAHfc3gIEyMaitmfx494el4RVqU97nRSSIQF8KCOSV2qSUS3IQWWN
         JJasXVD6Ji7ejje8VwI+7YpzzL6XJuHt7zaLofPZfugffpMyCcuQDkyshwfKCT42rh/5
         b1dg==
X-Gm-Message-State: AOAM533JPNcs1sm2n36fFqsoNr7DL0tK/aS/pCkxVhTC8mSz35f43JOg
        P84xkcKsEfQAKpwrIgqXRB8wS8o3EQ==
X-Google-Smtp-Source: ABdhPJw3buv19fqH13VbQQgNA4MdU3C7vJmxElcvlCQdh9FVVRYMLcnwm/sfhAVRavjbgoLpN+vC3TKzmQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1233:: with SMTP id
 p19mr34061372qvv.20.1632314828877; Wed, 22 Sep 2021 05:47:08 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:53 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-2-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 01/12] KVM: arm64: Move __get_fault_info() and co into
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
2.33.0.464.g1972c5931b-goog

