Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF90218DA6D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgCTVbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:31:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:48428 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgCTV2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:44 -0400
IronPort-SDR: tnL6tuAWNevl0qJiqtU2E0A/1l2fWbHkkfUUlzqhF9mIyBhT3csFq2t6n7gBbVepIpm6f8xqxd
 Ba18/J4IOfDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:44 -0700
IronPort-SDR: GgzhgFJ4XUl5noxICaWa2SN0uxpcn1W6h3igoCoQQ8L+cl+A/zk9pac6Qip3Q1JpBZux4IzanA
 0YvTWbv4RuWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224402"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:43 -0700
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
Subject: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when emulating INVEPT for L1
Date:   Fri, 20 Mar 2020 14:27:59 -0700
Message-Id: <20200320212833.3507-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
changes to the EPT tables managed by L1 need to be recognized, and
relying on KVM to always flush L2's EPTP context on nested VM-Enter is
dangerous.

Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
TLB flush if necessary, e.g. if L1 has never entered L2 then there is
nothing to be done.

Nuking all L2 roots is overkill for the single-context variant, but it's
the safe and easy bet.  A more precise zap mechanism will be added in
the future.  Add a TODO to call out that KVM only needs to invalidate
affected contexts.

Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f3774cef4fd4..9624cea4ed9f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5160,12 +5160,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+		/* TODO: sync only the target EPTP context. */
 		fallthrough;
 	case VMX_EPT_EXTENT_GLOBAL:
-	/*
-	 * TODO: Sync the necessary shadow EPT roots here, rather than
-	 * at the next emulated VM-entry.
-	 */
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
+				   KVM_MMU_ROOTS_ALL);
 		break;
 	default:
 		BUG_ON(1);
-- 
2.24.1

