Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BC49B604
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578458AbiAYOTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:19:38 -0500
Received: from 8bytes.org ([81.169.241.247]:46322 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1453062AbiAYOQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:16:53 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 992BF5BF;
        Tue, 25 Jan 2022 15:16:32 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v6 2/7] KVM: SVM: Add helper to generate GHCB MSR verson info, and drop macro
Date:   Tue, 25 Jan 2022 15:16:21 +0100
Message-Id: <20220125141626.16008-3-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Convert the GHCB_MSR_SEV_INFO macro into a helper function, and have the
helper hardcode the min/max versions instead of relying on the caller to
do the same.  Under no circumstance should different pieces of KVM define
different min/max versions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sev-common.h |  9 ---------
 arch/x86/kvm/svm/sev.c            | 28 ++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h            |  5 -----
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index d49ebec1252a..5d6b7114d8ba 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -19,15 +19,6 @@
 #define GHCB_MSR_SEV_INFO_RESP		0x001
 #define GHCB_MSR_SEV_INFO_REQ		0x002
 
-#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)	\
-	/* GHCBData[63:48] */			\
-	((((_max) & 0xffff) << 48) |		\
-	 /* GHCBData[47:32] */			\
-	 (((_min) & 0xffff) << 32) |		\
-	 /* GHCBData[31:24] */			\
-	 (((_cbit) & 0xff)  << 24) |		\
-	 GHCB_MSR_SEV_INFO_RESP)
-
 #define GHCB_MSR_INFO(v)		((v) & 0xfffUL)
 #define GHCB_MSR_PROTO_MAX(v)		(((v) >> 48) & 0xffff)
 #define GHCB_MSR_PROTO_MIN(v)		(((v) >> 32) & 0xffff)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7632fc463458..d6147137a7da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2636,6 +2636,26 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 	return msr;
 }
 
+/* The min/max GHCB version supported by KVM. */
+#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MIN	1ULL
+
+static u64 ghcb_msr_version_info(void)
+{
+	u64 msr;
+
+	/* GHCBData[63:48] */
+	msr  = (GHCB_VERSION_MAX & 0xffff) << 48;
+	/* GHCBData[47:32] */
+	msr |= (GHCB_VERSION_MIN & 0xffff) << 32;
+	/* GHCBData[31:24] */
+	msr |= (sev_enc_bit      &   0xff) << 24;
+
+	msr |= GHCB_MSR_SEV_INFO_RESP;
+
+	return msr;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2650,9 +2670,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-								GHCB_VERSION_MIN,
-								sev_enc_bit);
+		control->ghcb_gpa = ghcb_msr_version_info();
 		break;
 	case GHCB_MSR_CPUID_REQ: {
 		u64 cpuid_fn, cpuid_reg, cpuid_value;
@@ -2880,9 +2898,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-							GHCB_VERSION_MIN,
-							sev_enc_bit);
+	svm->vmcb->control.ghcb_gpa = ghcb_msr_version_info();
 }
 
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..776be8ff9e50 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -596,11 +596,6 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
-
-#define GHCB_VERSION_MAX	1ULL
-#define GHCB_VERSION_MIN	1ULL
-
-
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
-- 
2.34.1

