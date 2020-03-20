Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CB618DA49
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgCTVaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:30:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:37251 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbgCTV27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:59 -0400
IronPort-SDR: GzgNy01gPejU1zTTonjKkci2cOF+7IXgbVS9yE65lSkS3Smxx2oHEOQ5mk4jJg2Iw7qzSCAgto
 qgqaJTizPDFg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:58 -0700
IronPort-SDR: 6nE6bqaZEH8j/3rTTJseTyhKrzwLo7vnlYgsVnPiDvtCkBv9fTlPy+LEu4J1Bh7f9A61vNGRuJ
 gmuPirrIpfqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224508"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:57 -0700
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
Subject: [PATCH v3 29/37] KVM: VMX: Don't reload APIC access page if its control is disabled
Date:   Fri, 20 Mar 2020 14:28:25 -0700
Message-Id: <20200320212833.3507-30-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't reload the APIC access page if its control is disabled, e.g. if
the guest is running with x2APIC (likely) or with the local APIC
disabled (unlikely), to avoid unnecessary TLB flushes and VMWRITEs.
Unconditionally reload the APIC access page and flush the TLB when
the guest's virtual APIC transitions to "xAPIC enabled", as any
changes to the APIC access page's mapping will not be recorded while
the guest's virtual APIC is disabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8d409b50afd..d49d2a1ddf03 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6122,7 +6122,15 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 		if (flexpriority_enabled) {
 			sec_exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-			vmx_flush_tlb_current(vcpu);
+			kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
+
+			/*
+			 * Flush the TLB, reloading the APIC access page will
+			 * only do so if its physical address has changed, but
+			 * the guest may have inserted a non-APIC mapping into
+			 * the TLB while the APIC access page was disabled.
+			 */
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 		break;
 	case LAPIC_MODE_X2APIC:
@@ -6146,6 +6154,10 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	if (!(secondary_exec_controls_get(to_vmx(vcpu)) &
+	    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+		return;
+
 	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page))
 		return;
-- 
2.24.1

