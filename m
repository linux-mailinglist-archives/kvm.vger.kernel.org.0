Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D501878DF
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCQExM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgCQExL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:11 -0400
IronPort-SDR: xnTIaWNCS9EybYkw8SjA5uMJaI18PJ7S5aDzuQ6DXfl63rB/hgnet4MSboqzHhsAYElcGg3/Ww
 fHPQY+dsuwLA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:10 -0700
IronPort-SDR: tgYOwLO76Po8JG5m0M3/2vdAKqYmKv5GzwKf3hCWb++LSc8WHWNGBq9BgPHaPAoXUUxR5vz5Hl
 54nVbcMnc13w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252745"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:10 -0700
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
Subject: [PATCH v2 04/32] KVM: nVMX: Invalidate all L2 roots when emulating INVVPID without EPT
Date:   Mon, 16 Mar 2020 21:52:10 -0700
Message-Id: <20200317045238.30434-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

Free all L2 (guest_mmu) roots when emulating INVVPID for L1 and EPT is
disabled, as outstanding changes to the page tables managed by L1 need
to be recognized.

Similar to handle_invpcid() and handle_invept(), rely on
kvm_mmu_free_roots() to do a remote TLB flush if necessary, e.g. if L1
has never entered L2 then there is nothing to be done.

Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
Signed-off-by: Junaid Shahid <junaids@google.com>
[sean: ported to upstream KVM, reworded the comment and changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9624cea4ed9f..50bb7d8862aa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5250,6 +5250,17 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return kvm_skip_emulated_instruction(vcpu);
 	}
 
+	/*
+	 * Sync L2's shadow page tables if EPT is disabled, L1 is effectively
+	 * invalidating linear mappings for L2 (tagged with L2's VPID).  Sync
+	 * all roots as VPIDs are not tracked in the MMU role.
+	 *
+	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
+	 */
+	if (!enable_ept)
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
+				   KVM_MMU_ROOTS_ALL);
+
 	return nested_vmx_succeed(vcpu);
 }
 
-- 
2.24.1

