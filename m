Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9142F18DA63
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCTV2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:48429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCTV2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:45 -0400
IronPort-SDR: 0ipUewx6+zIQBPiXVQD1qgMqrFy4zt+4IqsFRdj4uDwsAj3vZLitDYTaBTWWiFGWzdGQ05pW5E
 BMu6P2a1CFfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:44 -0700
IronPort-SDR: fOUdOCVPOd9Y/euvkM9selB/KqaDxpYao/cv4Z0YvWhCl4SeisZogmRTBqP1Ulxhv10c1yj8lc
 R0/JyD6v6XOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224409"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:44 -0700
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
Subject: [PATCH v3 04/37] KVM: nVMX: Invalidate all roots when emulating INVVPID without EPT
Date:   Fri, 20 Mar 2020 14:28:00 -0700
Message-Id: <20200320212833.3507-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

Free all roots when emulating INVVPID for L1 and EPT is disabled, as
outstanding changes to the page tables managed by L1 need to be
recognized.  Because L1 and L2 share an MMU when EPT is disabled, and
because VPID is not tracked by the MMU role, all roots in the current
MMU (root_mmu) need to be freed, otherwise a future nested VM-Enter or
VM-Exit could do a fast CR3 switch (without a flush/sync) and consume
stale SPTEs.

Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
Signed-off-by: Junaid Shahid <junaids@google.com>
[sean: ported to upstream KVM, reworded the comment and changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9624cea4ed9f..bc74fbbf33c6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5250,6 +5250,20 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return kvm_skip_emulated_instruction(vcpu);
 	}
 
+	/*
+	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
+	 * linear mappings for L2 (tagged with L2's VPID).  Free all roots as
+	 * VPIDs are not tracked in the MMU role.
+	 *
+	 * Note, this operates on root_mmu, not guest_mmu, as L1 and L2 share
+	 * an MMU when EPT is disabled.
+	 *
+	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
+	 */
+	if (!enable_ept)
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu,
+				   KVM_MMU_ROOTS_ALL);
+
 	return nested_vmx_succeed(vcpu);
 }
 
-- 
2.24.1

