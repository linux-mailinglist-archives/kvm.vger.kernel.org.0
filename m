Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2903C6D94
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhGMJip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 05:38:45 -0400
Received: from 8bytes.org ([81.169.241.247]:36902 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235149AbhGMJio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 05:38:44 -0400
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 1BB2750F;
        Tue, 13 Jul 2021 11:35:49 +0200 (CEST)
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
Subject: [PATCH 2/3] KVM: SVM: Add support for Hypervisor Feature support MSR protocol
Date:   Tue, 13 Jul 2021 11:35:45 +0200
Message-Id: <20210713093546.7467-3-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210713093546.7467-1-joro@8bytes.org>
References: <20210713093546.7467-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-common.h |  4 ++++
 arch/x86/include/uapi/asm/svm.h   |  1 +
 arch/x86/kvm/svm/sev.c            | 12 ++++++++++++
 arch/x86/kvm/svm/svm.h            |  1 +
 4 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index dda34ecac5c0..0374f5687fc0 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -60,6 +60,10 @@
 #define GHCB_MSR_HV_FT_REQ			0x080
 #define GHCB_MSR_HV_FT_RESP			0x081
 
+/* GHCB Hypervisor Feature Request/Response */
+#define GHCB_MSR_HV_FT_REQ			0x080
+#define GHCB_MSR_HV_FT_RESP			0x081
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
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
index 0ec88b349799..8121b335651c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2182,6 +2182,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FT:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2434,6 +2435,11 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED, GHCB_DATA_MASK, GHCB_DATA_LOW);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2549,6 +2555,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index b21b9df54121..77379e1442cc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -546,6 +546,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.31.1

