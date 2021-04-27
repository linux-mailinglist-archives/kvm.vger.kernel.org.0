Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31E536CD4E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbhD0Uz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:55:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35628 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbhD0Uzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 16:55:50 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2FBA220B8004;
        Tue, 27 Apr 2021 13:55:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2FBA220B8004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619556906;
        bh=3GvVKs98S/mI0qIXyqkLp0F4ZBwpHP8zV+oE4wjTNHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvI2Ija06dEh47Zj52gAW9Ewy9dr8xcuAaZyJHSa7prieZwcwWwK/aMiPHMdNn9ha
         16V2I1ct5jHooC42CAXZ79+r0+fUtCqnCaEDtAWatz25cURd/r6oxao9thwBxWTUlz
         cxCQkkgB8LIlbdJCykGQ+gbfWuOHACIzPeI+dzeo=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v4 4/7] KVM: SVM: Software reserved fields
Date:   Tue, 27 Apr 2021 20:54:53 +0000
Message-Id: <f887ccfb82374b98058b7b3e265af0b4b6052b8a.1619556430.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619556430.git.viremana@linux.microsoft.com>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM added support for certain reserved fields to be used by
software or hypervisor. Add the following reserved fields:
  - VMCB offset 0x3e0 - 0x3ff
  - Clean bit 31
  - SVM intercept exit code 0xf0000000

Later patches will make use of this for supporting Hyper-V
nested virtualization enhancements.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/include/asm/svm.h      |  9 +++++++--
 arch/x86/include/uapi/asm/svm.h |  3 +++
 arch/x86/kvm/svm/svm.h          | 17 +++++++++++++++--
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..8dac318bd6f9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -156,6 +156,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
+	u8 reserved_8[720];
+	/*
+	 * Offset 0x3e0, 32 bytes reserved
+	 * for use by hypervisor/software.
+	 */
+	u8 reserved_sw[32];
 };
 
 
@@ -312,7 +318,7 @@ struct ghcb {
 
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		1032
-#define EXPECTED_VMCB_CONTROL_AREA_SIZE		272
+#define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
 static inline void __unused_size_checks(void)
@@ -324,7 +330,6 @@ static inline void __unused_size_checks(void)
 
 struct vmcb {
 	struct vmcb_control_area control;
-	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
 	struct vmcb_save_area save;
 } __packed;
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 554f75fe013c..efa969325ede 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -110,6 +110,9 @@
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
+/* Exit code reserved for hypervisor/software use */
+#define SVM_EXIT_SW				0xf0000000
+
 #define SVM_EXIT_ERR           -1
 
 #define SVM_EXIT_REASONS \
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..4e073b88c8cb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -33,6 +33,11 @@ static const u32 host_save_user_msrs[] = {
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 
+/*
+ * Clean bits in VMCB.
+ * VMCB_ALL_CLEAN_MASK might also need to
+ * be updated if this enum is modified.
+ */
 enum {
 	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
 			    pause filter count */
@@ -50,9 +55,17 @@ enum {
 			  * AVIC PHYSICAL_TABLE pointer,
 			  * AVIC LOGICAL_TABLE pointer
 			  */
-	VMCB_DIRTY_MAX,
+	VMCB_SW = 31,    /* Reserved for hypervisor/software use */
 };
 
+#define VMCB_ALL_CLEAN_MASK (					\
+	(1U << VMCB_INTERCEPTS) | (1U << VMCB_PERM_MAP) |	\
+	(1U << VMCB_ASID) | (1U << VMCB_INTR) |			\
+	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
+	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
+	(1U << VMCB_LBR) | (1U << VMCB_AVIC) |			\
+	(1U << VMCB_SW))
+
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
@@ -230,7 +243,7 @@ static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 
 static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 {
-	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
+	vmcb->control.clean = VMCB_ALL_CLEAN_MASK
 			       & ~VMCB_ALWAYS_DIRTY_MASK;
 }
 
-- 
2.25.1

