Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A36B1159D2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLFX5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:55585 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfLFX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530375"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] KVM: x86/mmu: WARN if root_hpa is invalid when handling a page fault
Date:   Fri,  6 Dec 2019 15:57:29 -0800
Message-Id: <20191206235729.29263-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if root_hpa is invalid when handling a page fault.  The check on
root_hpa exists for historical reasons that no longer apply to the
current KVM code base.

Remove an equivalent debug-only warning in direct_page_fault(), whose
existence more or less confirms that root_hpa should always be valid
when handling a page fault.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 88fd1022731f..32534ea1efd0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4168,8 +4168,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	kvm_pfn_t pfn;
 	int level, r;
 
-	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
-
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
@@ -5459,7 +5457,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	int r, emulation_type = 0;
 	bool direct = vcpu->arch.mmu->direct_map;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
 	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
-- 
2.24.0

