Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D201668BE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBTUoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgBTUoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237110"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:44:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] KVM: VMX: Clean up vmx_flush_tlb_gva()
Date:   Thu, 20 Feb 2020 12:43:53 -0800
Message-Id: <20200220204356.8837-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5372a93e1727..906e9d9aa09e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2824,15 +2824,11 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
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

