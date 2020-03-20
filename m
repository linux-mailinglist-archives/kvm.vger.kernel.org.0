Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB56818DA35
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgCTV3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:37248 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgCTV3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:29:02 -0400
IronPort-SDR: JS5pgH6HeZ8tVZKdcxtcanStZ+Q2wWnECXE8dHxt5ri23p33JlECTtJmXp6qdhoMH8Rg7aJQoW
 Qn83VctAot/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:29:01 -0700
IronPort-SDR: gl4xcI5Quwj/T3m+RSsym7vw+sozdnbXskihwRnY6aVF1ObxFZRWDZpTuF2sQ2RZrLeFdLR+3i
 XvCVKSEbDTfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224536"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:29:01 -0700
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
Subject: [PATCH v3 37/37] KVM: VMX: Clean cr3/pgd handling in vmx_load_mmu_pgd()
Date:   Fri, 20 Mar 2020 14:28:33 -0700
Message-Id: <20200320212833.3507-38-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename @cr3 to @pgd in vmx_load_mmu_pgd() to reflect that it will be
loaded into vmcs.EPT_POINTER and not vmcs.GUEST_CR3 when EPT is enabled.
Similarly, load guest_cr3 with @pgd if and only if EPT is disabled.

This fixes one of the last, if not _the_ last, cases in KVM where a
variable that is not strictly a cr3 value uses "cr3" isntead of "pgd".

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 53fea2d38590..b7ca11d4766c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3045,16 +3045,15 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
 	return eptp;
 }
 
-void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
+void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
 
-	guest_cr3 = cr3;
 	if (enable_ept) {
-		eptp = construct_eptp(vcpu, cr3);
+		eptp = construct_eptp(vcpu, pgd);
 		vmcs_write64(EPT_POINTER, eptp);
 
 		if (kvm_x86_ops->tlb_remote_flush) {
@@ -3075,6 +3074,8 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
 		else /* vmcs01.GUEST_CR3 is already up-to-date. */
 			update_guest_cr3 = false;
 		ept_load_pdptrs(vcpu);
+	} else {
+		guest_cr3 = pgd;
 	}
 
 	if (update_guest_cr3)
-- 
2.24.1

