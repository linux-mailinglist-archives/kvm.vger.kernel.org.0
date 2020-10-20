Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B9A2944D5
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438936AbgJTV4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:61050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438820AbgJTV4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:16 -0400
IronPort-SDR: A3MH9SmZ1W65ZAjizwh7YYK8LeMTKUFz7TAq6O3wnrYu1s8T+CaveBdY/Z400zNu7qoypmjpF+
 1BzP22yii8xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576326"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:16 -0700
IronPort-SDR: nNIeGbCmm3h2LoVehp2hmoI+eJyD8rZ6DdSQ4/zqJKGu7P3/fmKe8R2ymUj1CzI3VsHLshoguh
 7sSR9g/ZJmwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827736"
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
Subject: [PATCH v2 04/10] KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
Date:   Tue, 20 Oct 2020 14:56:07 -0700
Message-Id: <20201020215613.8972-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Combine the for-loops for Hyper-V TLB EPTP checking and flushing, and in
doing so skip flushes for vCPUs whose EPTP matches the target EPTP.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bba6d91f1fe1..52cb9eec1db3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -502,31 +502,23 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
+	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
 		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp))
+			if (!VALID_PAGE(tmp_eptp) ||
+			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
-			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
+			else
 				kvm_vmx->ept_pointers_match
 					= EPT_POINTERS_MISMATCH;
-				break;
-			}
-		}
-	}
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			/* If ept_pointer is invalid pointer, bypass flush request. */
-			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
-							    range);
+			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
 	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
-- 
2.28.0

