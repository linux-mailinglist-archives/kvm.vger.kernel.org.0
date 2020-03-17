Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0CF1878AE
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgCQExs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:34131 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgCQExY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:24 -0400
IronPort-SDR: +JSWsUICKsl6/AKPBDGKLnIgH1Ulcrl2HKGkKC8w7Bv7xsU405n+uDcWQDETxDniNbEGJr4iaz
 aZGrCjTOtXkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:24 -0700
IronPort-SDR: NIrdoSL3jMIyoyOLcZJa5qTTYZLECPl7SKdmnTrl3iEV/anxYGEINOYA/oeVIyucvLNW9wxflW
 yuD7UiFLzOmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252835"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:23 -0700
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
Subject: [PATCH v2 30/32] KVM: x86/mmu: Add module param to force TLB flush on root reuse
Date:   Mon, 16 Mar 2020 21:52:36 -0700
Message-Id: <20200317045238.30434-31-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a module param, flush_on_reuse, to override skip_tlb_flush when
performing a so called "fast cr3 switch", i.e. when reusing a cached
root.  The primary motiviation for the control is to provide a fallback
mechanism in the event that TLB flushing bugs are exposed/introduced by
upcoming changes to stop unconditionally flushing on nested VMX
transitions.

Suggested-by: Jim Mattson <jmattson@google.com>
Suggested-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 97d906a42e81..b98482b60748 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -78,6 +78,9 @@ module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
 		&nx_huge_pages_recovery_ratio, 0644);
 __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
 
+static bool __read_mostly force_tlb_flush_on_reuse;
+module_param_named(flush_on_reuse, force_tlb_flush_on_reuse, bool, 0644);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -4340,6 +4343,9 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			      union kvm_mmu_page_role new_role,
 			      bool skip_tlb_flush)
 {
+	if (force_tlb_flush_on_reuse)
+		skip_tlb_flush = false;
+
 	if (!fast_cr3_switch(vcpu, new_cr3, new_role, skip_tlb_flush))
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu,
 				   KVM_MMU_ROOT_CURRENT);
-- 
2.24.1

