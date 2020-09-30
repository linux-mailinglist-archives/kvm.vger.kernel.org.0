Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB63527DF44
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgI3ERZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:60793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI3ERE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:04 -0400
IronPort-SDR: gl2AOKhkJHDqFR7o1JCGt4cMKTUaB2Ux8Vm53khrb3N1v6AehR3vS50vjL68RqXOE5oPgZbmrp
 Bfu2XYVbDONQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137451"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:03 -0700
IronPort-SDR: uPY+seaTO4OX809oX8Mx0xF2xvSVpfJtDPXENLeD0pUqSvkJFd1RTb02vIG8exrD6ekTWRtq8C
 QrFaUzqtaUuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607868"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2020 21:17:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 4/5] KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault
Date:   Tue, 29 Sep 2020 21:16:58 -0700
Message-Id: <20200930041659.28181-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercept CR4 bits that are guest reserved so that KVM correctly injects
a #GP fault if the guest attempts to set a reserved bit.  If a feature
is supported by the CPU but is not exposed to the guest, and its
associated CR4 bit is not intercepted by KVM by default, then KVM will
fail to inject a #GP if the guest sets the CR4 bit without triggering
an exit, e.g. by toggling only the bit in question.

Note, KVM doesn't give the guest direct access to any CR4 bits that are
also dependent on guest CPUID.  Yet.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 223e070c48b2..4ff440e7518e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4037,13 +4037,16 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 {
-	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+
+	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
+					  ~vcpu->arch.cr4_guest_rsvd_bits;
 	if (!enable_ept)
-		vmx->vcpu.arch.cr4_guest_owned_bits &= ~X86_CR4_PGE;
+		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PGE;
 	if (is_guest_mode(&vmx->vcpu))
-		vmx->vcpu.arch.cr4_guest_owned_bits &=
-			~get_vmcs12(&vmx->vcpu)->cr4_guest_host_mask;
-	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
+		vcpu->arch.cr4_guest_owned_bits &=
+			~get_vmcs12(vcpu)->cr4_guest_host_mask;
+	vmcs_writel(CR4_GUEST_HOST_MASK, ~vcpu->arch.cr4_guest_owned_bits);
 }
 
 u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
@@ -7233,6 +7236,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	set_cr4_guest_host_mask(vmx);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	update_exception_bitmap(vcpu);
 }
-- 
2.28.0

