Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B792D49B63A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbiAYO10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578343AbiAYOSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:18:49 -0500
X-Greylist: delayed 134 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Jan 2022 06:18:48 PST
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4DBC061759;
        Tue, 25 Jan 2022 06:18:48 -0800 (PST)
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 23C58870;
        Tue, 25 Jan 2022 15:16:34 +0100 (CET)
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
Subject: [PATCH v6 6/7] KVM: SVM: Add support for Hypervisor Feature support MSR protocol
Date:   Tue, 25 Jan 2022 15:16:25 +0100
Message-Id: <20220125141626.16008-7-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
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
 arch/x86/kvm/svm/sev.c          | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

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
index 1219c1771895..403f24498020 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2452,6 +2452,7 @@ static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2689,6 +2690,19 @@ static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, u64 hold_type)
 				  KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
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
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2738,6 +2752,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	case GHCB_MSR_AP_RESET_HOLD_REQ:
 		ret = sev_emulate_ap_reset_hold(svm, GHCB_MSR_AP_RESET_HOLD_REQ);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_hv_feat_resp();
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2851,6 +2868,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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
2.34.1

