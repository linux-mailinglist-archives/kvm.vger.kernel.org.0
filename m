Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5245E1878A9
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCQExZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:34139 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgCQExZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:25 -0400
IronPort-SDR: u1KrTjENEGeuZ4xqPPpVfjPBzbf8howVSfC+ThJZ5euKvlcP+DUAxLATQpOOBra9wogqz2ui4C
 W7VNAPfSnrPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:24 -0700
IronPort-SDR: e1paSdrLwyX5WHmjwUrsciracoyoch8vl+lX1dyRrpgEJd2U5xeZOT4Nzqv760TfTlnHWQCBMx
 qXpc57MawNgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252839"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:24 -0700
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
Subject: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM transition with EPT enabled
Date:   Mon, 16 Mar 2020 21:52:37 -0700
Message-Id: <20200317045238.30434-32-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't flush the TLB if a cached EPTP root can be reused for nested
VM-Enter/VM-Exit.  Each unique EPTP constitutes a different ASID,
cached roots are invalidated on eviction, and KVM invalidates all EPTP
contexts on global events, e.g. mmu_notifier invalidate or memslot
updates.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c    | 2 +-
 arch/x86/kvm/vmx/nested.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b98482b60748..de2bd07bad7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5047,7 +5047,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false);
+	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, true);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d816f1366943..a77eab5b0e8a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1123,7 +1123,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	}
 
 	if (!nested_ept)
-		kvm_mmu_new_cr3(vcpu, cr3, false);
+		kvm_mmu_new_cr3(vcpu, cr3, enable_ept);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-- 
2.24.1

