Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A5B40930E
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbhIMORT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:17:19 -0400
Received: from 8bytes.org ([81.169.241.247]:56654 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343938AbhIMOPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:15 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0627F2A5;
        Mon, 13 Sep 2021 16:13:57 +0200 (CEST)
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
Subject: [PATCH v3 3/4] KVM: SVM: Add support for Hypervisor Feature support MSR protocol
Date:   Mon, 13 Sep 2021 16:13:44 +0200
Message-Id: <20210913141345.27175-4-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913141345.27175-1-joro@8bytes.org>
References: <20210913141345.27175-1-joro@8bytes.org>
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
 arch/x86/kvm/svm/sev.c          | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 3 files changed, 21 insertions(+)

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
index 8cd1e4ebb4a8..b3fdfccf0499 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2184,6 +2184,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2365,6 +2366,16 @@ static u64 ghcb_msr_ap_rst_resp(u64 value)
 	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
 }
 
+static u64 ghcb_msr_hv_feat_resp(u64 value)
+{
+	u64 msr;
+
+	msr  = GHCB_MSR_HV_FT_RESP;
+	msr |= (value << GHCB_DATA_LOW);
+
+	return msr;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2422,6 +2433,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		 */
 		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
 
+		break;
+	case GHCB_MSR_HV_FT_REQ:
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_hv_feat_resp(GHCB_HV_FT_SUPPORTED);
 		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
@@ -2535,6 +2549,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 524d943f3efc..f019da28ff06 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -542,6 +542,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.33.0

