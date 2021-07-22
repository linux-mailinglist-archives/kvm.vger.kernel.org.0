Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746363D230E
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 14:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhGVLVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:21:32 -0400
Received: from 8bytes.org ([81.169.241.247]:44266 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhGVLVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 07:21:31 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1043E3D0; Thu, 22 Jul 2021 14:02:04 +0200 (CEST)
Date:   Thu, 22 Jul 2021 14:01:56 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v2.1 3/4] KVM: SVM: Add support for Hypervisor Feature
 support MSR protocol
Message-ID: <YPleNFvmsEi3kBZk@8bytes.org>
References: <20210722115245.16084-1-joro@8bytes.org>
 <20210722115245.16084-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722115245.16084-4-joro@8bytes.org>
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
 arch/x86/kvm/svm/sev.c          | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index efa969325ede..fbb6f8d27a80 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -108,6 +108,7 @@
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
+#define SVM_VMGEXIT_HV_FT			0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a32ef011025f..4565c360d87d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2180,6 +2180,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FT:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2361,6 +2362,16 @@ static void set_ghcb_msr_ap_rst_resp(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
 }
 
+static void set_ghcb_msr_hv_feat_resp(struct vcpu_svm *svm, u64 value)
+{
+	u64 msr;
+
+	msr  = GHCB_MSR_HV_FT_RESP;
+	msr |= (value << GHCB_DATA_LOW);
+
+	svm->vmcb->control.ghcb_gpa = msr;
+}
+
 static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 {
 	svm->vmcb->control.ghcb_gpa = value;
@@ -2425,6 +2436,10 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_hv_feat_resp(svm, GHCB_HV_FT_SUPPORTED);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2537,6 +2552,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FT: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7e2090752d8f..9cafeba3340e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -550,6 +550,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.31.1

