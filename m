Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39911878B2
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgCQExX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:34127 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgCQExX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:23 -0400
IronPort-SDR: 4S1QgyQNoxvgkEDWKXgbpL0Cu/BF81ynclIdunEt3rjIOsl3v71nAQIZI7MqYjSqs8/3TPxyhx
 Yp9kLhPaJrqA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:22 -0700
IronPort-SDR: OoVw0F+1w+mMxqupFNoOWLQqbXu94VN7KU50wOWphTxPS4LAAtBdk4CYjI8i4zSMXeG06LeG+P
 wKlF9YSFojsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252820"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:21 -0700
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
Subject: [PATCH v2 26/32] KVM: nVMX: Selectively use TLB_FLUSH_CURRENT for nested VM-Enter/VM-Exit
Date:   Mon, 16 Mar 2020 21:52:32 -0700
Message-Id: <20200317045238.30434-27-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush only the current context, as opposed to all contexts, when
requesting a TLB flush to handle the scenario where a L1 does not expect
a TLB flush, but one is required because L1 and L2 shared an ASID.  This
occurs if EPT is disabled (no per-EPTP tag), VPID is enabled (hardware
doesn't flush unconditionally) and vmcs02 does not have its own VPID due
to exhaustion of available VPIDs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 19600d4b3344..04cdf7ded1d3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1167,16 +1167,19 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	 *
 	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
 	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
-	 * a VPID for L2, flush the TLB as the effective ASID is common to both
-	 * L1 and L2.
+	 * a VPID for L2, flush the current context as the effective ASID is
+	 * common to both L1 and L2.
 	 *
 	 * Defer the flush so that it runs after vmcs02.EPTP has been set by
 	 * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
 	 * redundant flushes further down the nested pipeline.
 	 */
-	if (enable_vpid &&
-	    (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)))
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	if (enable_vpid) {
+		if (!nested_cpu_has_vpid(vmcs12))
+			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		else if (!nested_has_guest_tlb_tag(vcpu))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
 }
 
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
-- 
2.24.1

