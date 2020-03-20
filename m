Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899D418DA5C
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgCTVa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:30:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:50326 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbgCTV2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:54 -0400
IronPort-SDR: /kuIdTdmHK0W78jbJB/kWpOuVNzEPVCNXQfDUklPbuREYdtK7PspdE//sN34BJWs9L7AiKqACB
 EopBhWxfQBpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:52 -0700
IronPort-SDR: y6q7PUNENAxs6RaNS+olhJMTwtaovz/vmFxTzZmxVSltJJKLLjBB+KuE2lIfLTe5/Zpm6bvJkr
 cHb9YAxSA6Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224459"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:50 -0700
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
Subject: [PATCH v3 15/37] KVM: VMX: Clean up vmx_flush_tlb_gva()
Date:   Fri, 20 Mar 2020 14:28:11 -0700
Message-Id: <20200320212833.3507-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor vmx_flush_tlb_gva() to remove a superfluous local variable and
clean up its comment, which is oddly located below the code it is
commenting.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57c1cee58d18..43c0d4706f9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2851,15 +2851,11 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
-	int vpid = to_vmx(vcpu)->vpid;
-
-	vpid_sync_vcpu_addr(vpid, addr);
-
 	/*
-	 * If VPIDs are not supported or enabled, then the above is a no-op.
-	 * But we don't really need a TLB flush in that case anyway, because
-	 * each VM entry/exit includes an implicit flush when VPID is 0.
+	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
+	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
 	 */
+	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
 }
 
 static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
-- 
2.24.1

