Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508A341C8D0
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbhI2Pzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:55:32 -0400
Received: from 8bytes.org ([81.169.241.247]:41290 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343850AbhI2PzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:55:20 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 8522A100E;
        Wed, 29 Sep 2021 17:53:37 +0200 (CEST)
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
Subject: [PATCH v4 4/5] KVM: SVM: Add support for Hypervisor Feature support MSR protocol
Date:   Wed, 29 Sep 2021 17:53:29 +0200
Message-Id: <20210929155330.5597-5-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155330.5597-1-joro@8bytes.org>
References: <20210929155330.5597-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of
supported Hypervisor SEV features. This request is required to support
a the GHCB version 2 protocol.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index efa969325ede..67cf153fe580 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -108,6 +108,7 @@
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
+#define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 69653d7838e3..22523ec08a7b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2216,6 +2216,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2413,6 +2414,20 @@ static u64 ghcb_msr_ap_rst_resp(u64 value)
 	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
 }
 
+/* Hypervisor GHCB Features supported by KVM */
+#define KVM_SUPPORTED_GHCB_HV_FEATURES		0UL
+
+static u64 ghcb_msr_hv_feat_resp(void)
+{
+	u64 msr;
+
+	msr  = GHCB_MSR_HV_FT_RESP;
+	msr |= (KVM_SUPPORTED_GHCB_HV_FEATURES << GHCB_DATA_LOW);
+
+	return msr;
+}
+
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2468,6 +2483,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		 */
 		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
 
+		break;
+	case GHCB_MSR_HV_FT_REQ:
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_hv_feat_resp();
 		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
@@ -2581,6 +2599,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
+		ghcb_set_sw_exit_info_2(ghcb, KVM_SUPPORTED_GHCB_HV_FEATURES);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.33.0

