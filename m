Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8124318DA43
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCTV2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:20436 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgCTV2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:54 -0400
IronPort-SDR: CbqLyTRo98r3jKpQNJLTHwZuJVz1Hrjmkp258mdghZc+IdKvarD1mZHvoH/0xo/NRsq6zE+xp5
 zR2y8Nrfn5Gg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:53 -0700
IronPort-SDR: BkBF0tHYPDCTwd2a7FDUBKw3S0tTNYfbPk5bZEHVzitfptS0V2oO5v+YSyGqnzx95FsprkH+y5
 K1aCAFzHJK/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224476"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 20/37] KVM: VMX: Introduce vmx_flush_tlb_current()
Date:   Fri, 20 Mar 2020 14:28:16 -0700
Message-Id: <20200320212833.3507-21-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to flush TLB entries only for the current EPTP/VPID context
and use it for the existing direct invocations of vmx_flush_tlb().  TLB
flushes that are specific to the current vCPU state do not need to flush
other contexts.

Note, both converted call sites happen to be related to the APIC access
page, this is purely coincidental.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6affaaef138..2d0a8c7654d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2874,6 +2874,22 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	u64 root_hpa = vcpu->arch.mmu->root_hpa;
+
+	/* No flush required if the current context is invalid. */
+	if (!VALID_PAGE(root_hpa))
+		return;
+
+	if (enable_ept)
+		ept_sync_context(construct_eptp(vcpu, root_hpa));
+	else if (!is_guest_mode(vcpu))
+		vpid_sync_context(to_vmx(vcpu)->vpid);
+	else
+		vpid_sync_context(nested_get_vpid02(vcpu));
+}
+
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
@@ -6104,7 +6120,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 		if (flexpriority_enabled) {
 			sec_exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-			vmx_flush_tlb(vcpu);
+			vmx_flush_tlb_current(vcpu);
 		}
 		break;
 	case LAPIC_MODE_X2APIC:
@@ -6122,7 +6138,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
 {
 	if (!is_guest_mode(vcpu)) {
 		vmcs_write64(APIC_ACCESS_ADDR, hpa);
-		vmx_flush_tlb(vcpu);
+		vmx_flush_tlb_current(vcpu);
 	}
 }
 
-- 
2.24.1

