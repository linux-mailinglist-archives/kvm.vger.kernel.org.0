Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D037A21E565
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 03:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGNB5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 21:57:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:24486 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNB5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 21:57:34 -0400
IronPort-SDR: R4Tp2NX0R6+OCjQD1BEERhXhQtpoLAo5yAg8M1A+nzGkADw5dDP4FcOS2NoqErlYHC4hwGy85U
 Y2eveZtY7kCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147905455"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="147905455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 18:57:33 -0700
IronPort-SDR: 71eSYM25ykw/jOPCA7O/DMLEvwPLrpRSDX+xrnEOdBZFL3wjyP/ejX2oMXO+mw+/WirUYCm/fl
 O7CxzvWmGL5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="307681797"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jul 2020 18:57:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode is enabled
Date:   Mon, 13 Jul 2020 18:57:32 -0700
Message-Id: <20200714015732.32426-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't attempt to load PDPTRs if EFER.LME=1, i.e. if 64-bit mode is
enabled.  A recent change to reload the PDTPRs when CR0.CD or CR0.NW is
toggled botched the EFER.LME handling and sends KVM down the PDTPR path
when is_paging() is true, i.e. when the guest toggles CD/NW in 64-bit
mode.

Split the CR0 checks for 64-bit vs. 32-bit PAE into separate paths.  The
64-bit path is specifically checking state when paging is toggled on,
i.e. CR0.PG transititions from 0->1.  The PDPTR path now needs to run if
the new CR0 state has paging enabled, irrespective of whether paging was
already enabled.  Trying to shave a few cycles to make the PDPTR path an
"else if" case is a mess.

Fixes: d42e3fae6faed ("kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes")
Cc: Jim Mattson <jmattson@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

The other way to fix this, with a much smaller diff stat, is to simply
move the !is_page(vcpu) check inside (vcpu->arch.efer & EFER_LME).  But
that results in a ridiculous amount of nested conditionals for what is a
very straightforward check e.g.

	if (cr0 & X86_CR0_PG) {
		if (vcpu->arch.efer & EFER_LME) }
			if (!is_paging(vcpu)) {
				...
			}
		}
	}

Since this doesn't need to be backported anywhere, I didn't see any value
in having an intermediate step.

 arch/x86/kvm/x86.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95ef629228691..5f526d94c33f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -819,22 +819,22 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
 		return 1;
 
-	if (cr0 & X86_CR0_PG) {
 #ifdef CONFIG_X86_64
-		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
-			int cs_db, cs_l;
+	if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
+	    (cr0 & X86_CR0_PG)) {
+		int cs_db, cs_l;
 
-			if (!is_pae(vcpu))
-				return 1;
-			kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
-			if (cs_l)
-				return 1;
-		} else
-#endif
-		if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
-		    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
+		if (!is_pae(vcpu))
+			return 1;
+		kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+		if (cs_l)
 			return 1;
 	}
+#endif
+	if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
+	    is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
+	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
+		return 1;
 
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
-- 
2.26.0

