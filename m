Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B713223D4
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 02:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhBWBsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 20:48:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:61191 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhBWBsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 20:48:50 -0500
IronPort-SDR: ECLckI/qQMMEdpjkKLYnopUp+JvIc6qYnzNFHQrzpoc4+wehv0gCy7vtFtAFgiboxdBVxfJmsw
 x4m7DT8WBC9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="204074441"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="204074441"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 17:47:05 -0800
IronPort-SDR: Kzaw0ckMg7nf1MZuYneVHUCT7frutpZl9RQCVFTSnNTarhPJo+cTV5gofd1DBdvKcP2najIqH5
 eW3n/7hgxkSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="423349306"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga004.fm.intel.com with ESMTP; 22 Feb 2021 17:47:02 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: vmx/pmu: Clear DEBUGCTLMSR_LBR bit on the debug breakpoint event
Date:   Tue, 23 Feb 2021 09:39:58 +0800
Message-Id: <20210223013958.1280444-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210223013958.1280444-1-like.xu@linux.intel.com>
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the processor that support model-specific LBR generates a debug
breakpoint event, it automatically clears the LBR flag. This action
does not clear previously stored LBR stack MSRs. (Intel SDM 17.4.2)

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0a3a9be654b..4951b535eb7f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4795,6 +4795,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, rip, dr6;
 	u32 vect_info;
+	u64 lbr_ctl;
 
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx_get_intr_info(vcpu);
@@ -4886,6 +4887,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		rip = kvm_rip_read(vcpu);
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
+		/* On the debug breakpoint event, the LBREn bit is cleared. */
+		lbr_ctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		if (lbr_ctl & DEBUGCTLMSR_LBR)
+			vmcs_write64(GUEST_IA32_DEBUGCTL, lbr_ctl & ~DEBUGCTLMSR_LBR);
 		break;
 	case AC_VECTOR:
 		if (guest_inject_ac(vcpu)) {
-- 
2.29.2

