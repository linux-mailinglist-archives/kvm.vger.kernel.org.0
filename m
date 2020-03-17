Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4272E1878B1
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgCQExz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:34131 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgCQExX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:23 -0400
IronPort-SDR: MHYBoN4vHnsEx22GNkr7Erp4NU/68NEpzKMsatHEQS53hO9PUi9i1UN0BLbL6E22E4WXVU0eOu
 4VHII5TA0Rfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:23 -0700
IronPort-SDR: i5ieWGSyHvcJNxu4jL7DiJMsGZTgrxQJKH3AWff+68oxaCuYkRNAY/XqiWtbhm9vYLp8V2xjxi
 K8ImlLWTptsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252831"
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
Subject: [PATCH v2 29/32] KVM: VMX: Don't reload APIC access page if its control is disabled
Date:   Mon, 16 Mar 2020 21:52:35 -0700
Message-Id: <20200317045238.30434-30-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
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

