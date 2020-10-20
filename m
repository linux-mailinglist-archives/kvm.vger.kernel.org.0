Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3602944CE
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438833AbgJTV4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:61050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392476AbgJTV4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:16 -0400
IronPort-SDR: V11oMn/zLBjIkPDMJ4PSCyDefQnh4FsSaKzbfzwoP6+uoG5G2fvd39IQr1QNTCruAmV37dyJLP
 /IYbqkcsAMYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576324"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576324"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:15 -0700
IronPort-SDR: /3u1ANp75pizzhzNZXNb1oQHcCF+T1JqO8o4BFaAhy1F6ryM2G9cN9oH+bEEm9Vk2lcGEpbdzQ
 LqHXlk8Ey7RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827725"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB flush
Date:   Tue, 20 Oct 2020 14:56:05 -0700
Message-Id: <20201020215613.8972-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture kvm_vmx in a local variable instead of polluting
hv_remote_flush_tlb_with_range() with to_kvm_vmx(kvm).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d53bcc4a1a9..6d41c99c70c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -516,26 +516,27 @@ static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range)
 {
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
 
-	spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (to_kvm_vmx(kvm)->ept_pointers_match == EPT_POINTERS_CHECK)
+	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
 		check_ept_pointer_match(kvm);
 
-	if (to_kvm_vmx(kvm)->ept_pointers_match != EPT_POINTERS_MATCH) {
+	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			/* If ept_pointer is invalid pointer, bypass flush request. */
 			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
 				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
 							    range);
 		}
-	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
-		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);
+	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
 
-	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_unlock(&kvm_vmx->ept_pointer_lock);
 	return ret;
 }
 static int hv_remote_flush_tlb(struct kvm *kvm)
-- 
2.28.0

