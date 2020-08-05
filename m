Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3790A23CEDB
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgHETID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgHETGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 15:06:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC3D22D73;
        Wed,  5 Aug 2020 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652003;
        bh=HDfhNkWPcDg4yb6ZfEZHbpNJ1PhiaXFGjxxBQhpPKS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpRld2kBTPvyJnrEnmkKjLqk/j/44FeEN66K3d2NCLyaqI3DTnuYM/uU1ut096EsF
         tQfEL0gf+Foj2AHwpV48Emb3L92q1puaba+rALckMSRaYs7ser9b/hEXHv16Vvy6/6
         PcxwsvsEo6M0nEpxv1YNejyNUQTD3Jt+v0ka8moA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfQ-0004w9-MA; Wed, 05 Aug 2020 18:57:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 17/56] KVM: arm64: Handle calls to prefixed hyp functions
Date:   Wed,  5 Aug 2020 18:56:21 +0100
Message-Id: <20200805175700.62775-18-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Scull <ascull@google.com>

Once hyp functions are moved to a hyp object, they will have prefixed symbols.
This change declares and gets the address of the prefixed version for calls to
the hyp functions.

To aid migration, the hyp functions that have not yet moved have their prefixed
versions aliased to their non-prefixed version. This begins with all the hyp
functions being listed and will reduce to none of them once the migration is
complete.

Signed-off-by: Andrew Scull <ascull@google.com>

[David: Extracted kvm_call_hyp nVHE branches into own helper macros, added
        comments around symbol aliases.]

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-6-dbrazdil@google.com
---
 arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h | 17 ++++++++++++++---
 arch/arm64/kernel/image-vars.h    | 26 ++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 352aaebf4198..6a682d66a640 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -42,6 +42,24 @@
 
 #include <linux/mm.h>
 
+/*
+ * Translate name of a symbol defined in nVHE hyp to the name seen
+ * by kernel proper. All nVHE symbols are prefixed by the build system
+ * to avoid clashes with the VHE variants.
+ */
+#define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+
+#define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
+#define DECLARE_KVM_NVHE_SYM(sym)	extern char kvm_nvhe_sym(sym)[]
+
+/*
+ * Define a pair of symbols sharing the same name but one defined in
+ * VHE and the other in nVHE hyp implementations.
+ */
+#define DECLARE_KVM_HYP_SYM(sym)		\
+	DECLARE_KVM_VHE_SYM(sym);		\
+	DECLARE_KVM_NVHE_SYM(sym)
+
 /* Translate a kernel address of @sym into its equivalent linear mapping */
 #define kvm_ksym_ref(sym)						\
 	({								\
@@ -50,6 +68,7 @@
 			val = lm_alias(&sym);				\
 		val;							\
 	 })
+#define kvm_ksym_ref_nvhe(sym)	kvm_ksym_ref(kvm_nvhe_sym(sym))
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..49d1a5cd8f8f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -448,6 +448,18 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
 
+#define kvm_call_hyp_nvhe(f, ...)					\
+	do {								\
+		DECLARE_KVM_NVHE_SYM(f);				\
+		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
+	} while(0)
+
+#define kvm_call_hyp_nvhe_ret(f, ...)					\
+	({								\
+		DECLARE_KVM_NVHE_SYM(f);				\
+		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
+	})
+
 /*
  * The couple of isb() below are there to guarantee the same behaviour
  * on VHE as on !VHE, where the eret to EL1 acts as a context
@@ -459,7 +471,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			f(__VA_ARGS__);					\
 			isb();						\
 		} else {						\
-			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
+			kvm_call_hyp_nvhe(f, ##__VA_ARGS__);		\
 		}							\
 	} while(0)
 
@@ -471,8 +483,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			ret = f(__VA_ARGS__);				\
 			isb();						\
 		} else {						\
-			ret = __kvm_call_hyp(kvm_ksym_ref(f),		\
-					     ##__VA_ARGS__);		\
+			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
 		}							\
 									\
 		ret;							\
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 3dc27da47712..36444bac6a05 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -63,6 +63,32 @@ __efistub__ctype		= _ctype;
 
 #define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
 
+/* Symbols defined in debug-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_get_mdcr_el2);
+
+/* Symbols defined in switch.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_vcpu_run_nvhe);
+
+/* Symbols defined in sysreg-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_enable_ssbs);
+
+/* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
+
+/* Symbols defined in tlb.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_flush_vm_context);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_local_vmid);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid_ipa);
+
+/* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
+KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
+KVM_NVHE_ALIAS(__vgic_v3_read_vmcr);
+KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
+KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
+KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
-- 
2.27.0

