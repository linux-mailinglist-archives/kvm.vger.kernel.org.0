Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10283C6D95
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhGMJiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbhGMJip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 05:38:45 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA503C0613DD;
        Tue, 13 Jul 2021 02:35:54 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 69BB14D4;
        Tue, 13 Jul 2021 11:35:48 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/3] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Tue, 13 Jul 2021 11:35:44 +0200
Message-Id: <20210713093546.7467-2-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210713093546.7467-1-joro@8bytes.org>
References: <20210713093546.7467-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/kvm/svm/sev.c            | 51 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 2cef6c5a52c2..dda34ecac5c0 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -11,6 +11,7 @@
 #define GHCB_MSR_INFO_POS		0
 #define GHCB_DATA_LOW			12
 #define GHCB_MSR_INFO_MASK		(BIT_ULL(GHCB_DATA_LOW) - 1)
+#define GHCB_DATA_MASK			GENMASK_ULL(51, 0)
 
 #define GHCB_DATA(v)			\
 	(((unsigned long)(v) & ~GHCB_MSR_INFO_MASK) >> GHCB_DATA_LOW)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 62926f1a5f7b..0ec88b349799 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,10 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2208,6 +2212,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2413,6 +2420,20 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ: {
+		svm->ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0, GHCB_DATA_MASK, GHCB_DATA_LOW);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2500,6 +2521,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -2637,13 +2659,26 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1, GHCB_DATA_MASK, GHCB_DATA_LOW);
 
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f89b623bb591..b21b9df54121 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -187,6 +187,7 @@ struct vcpu_svm {
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-- 
2.31.1

