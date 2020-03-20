Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8808618DA4E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCTVa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:30:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:50332 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgCTV25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:57 -0400
IronPort-SDR: lyJ2L8D2kYpAqugzD61VCAoa9TnLaQ4t+j1SmHgFtpRocGjtwFx9LJiOpLhrbS4D87/WkZ/ku7
 M5a9SdIXQlrQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:56 -0700
IronPort-SDR: TUCzLKSjia/w8YYfBwXwe/vr0Jo5I7jQq1sFOtolSDJNkfFJXdrlHgXsw51FRrHrIqtAQrTwcB
 zStKffSZlxbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224495"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:55 -0700
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
Subject: [PATCH v3 25/37] KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes
Date:   Fri, 20 Mar 2020 14:28:21 -0700
Message-Id: <20200320212833.3507-26-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush only the current ASID/context when requesting a TLB flush due to a
change in the current vCPU's MMU to avoid blasting away TLB entries
associated with other ASIDs/contexts, e.g. entries cached for L1 when
a change in L2's MMU requires a flush.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c357cc79f0f3..97d906a42e81 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2313,7 +2313,7 @@ static void kvm_mmu_flush_or_zap(struct kvm_vcpu *vcpu,
 		return;
 
 	if (local_flush)
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 #ifdef CONFIG_KVM_MMU_AUDIT
@@ -2520,11 +2520,11 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 
 		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 
 		__clear_sp_write_flooding_count(sp);
 		trace_kvm_mmu_get_page(sp, false);
@@ -3125,7 +3125,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (write_fault)
 			ret = RET_PF_EMULATE;
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
 
 	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH || flush)
@@ -4314,7 +4314,7 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 			if (!skip_tlb_flush) {
 				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-				kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 			}
 
 			/*
@@ -5177,7 +5177,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	kvm_mmu_load_pgd(vcpu);
-	kvm_x86_ops->tlb_flush_all(vcpu);
+	kvm_x86_ops->tlb_flush_current(vcpu);
 out:
 	return r;
 }
-- 
2.24.1

