Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9B41C8C7
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbhI2PzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:55:20 -0400
Received: from 8bytes.org ([81.169.241.247]:41266 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245740AbhI2PzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:55:19 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id BAFAAFC5;
        Wed, 29 Sep 2021 17:53:36 +0200 (CEST)
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
Subject: [PATCH v4 2/5] KVM: SVM: Add helper to generate GHCB MSR version info, and drop macro
Date:   Wed, 29 Sep 2021 17:53:27 +0200
Message-Id: <20210929155330.5597-3-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155330.5597-1-joro@8bytes.org>
References: <20210929155330.5597-1-joro@8bytes.org>
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
 arch/x86/include/asm/sev-common.h |  5 -----
 arch/x86/kvm/svm/sev.c            | 24 ++++++++++++++++++------
 arch/x86/kvm/svm/svm.h            |  5 -----
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 8540972cad04..886c36f0cb16 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -24,11 +24,6 @@
 #define GHCB_MSR_VER_MIN_MASK		0xffff
 #define GHCB_MSR_CBIT_POS		24
 #define GHCB_MSR_CBIT_MASK		0xff
-#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
-	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
-	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
-	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
-	 GHCB_MSR_SEV_INFO_RESP)
 #define GHCB_MSR_INFO(v)		((v) & 0xfffUL)
 #define GHCB_MSR_PROTO_MAX(v)		(((v) >> GHCB_MSR_VER_MAX_POS) & GHCB_MSR_VER_MAX_MASK)
 #define GHCB_MSR_PROTO_MIN(v)		(((v) >> GHCB_MSR_VER_MIN_POS) & GHCB_MSR_VER_MIN_MASK)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7aa6ad4c3118..159b22bb74e4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2389,6 +2389,22 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
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
+	msr  = GHCB_MSR_SEV_INFO_RESP;
+	msr |= GHCB_VERSION_MAX << GHCB_MSR_VER_MAX_POS;
+	msr |= GHCB_VERSION_MIN << GHCB_MSR_VER_MIN_POS;
+	msr |= sev_enc_bit << GHCB_MSR_CBIT_POS;
+
+	return msr;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2403,9 +2419,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-								GHCB_VERSION_MIN,
-								sev_enc_bit);
+		control->ghcb_gpa = ghcb_msr_version_info();
 		break;
 	case GHCB_MSR_CPUID_REQ: {
 		u64 cpuid_fn, cpuid_reg, cpuid_value;
@@ -2621,9 +2635,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
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
index 0d7bbe548ac3..68e5f16a0554 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -544,11 +544,6 @@ void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
-
-#define GHCB_VERSION_MAX	1ULL
-#define GHCB_VERSION_MIN	1ULL
-
-
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
-- 
2.33.0

