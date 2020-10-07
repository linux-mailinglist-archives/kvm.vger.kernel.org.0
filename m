Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239AD285674
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgJGBor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:7792 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbgJGBoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:20 -0400
IronPort-SDR: Au1hPQApfOCzEuH3sxeuJdUITPOj/7Z8dPsFrIscKp74Vs1NaullLInJN26nnJ0GUYSRYUW2lz
 2PQsXaDGm3rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914600"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:18 -0700
IronPort-SDR: SHL5sLPz2PGABQSabKsQ23HJaX9Pd5X8W0q1U7vvh4HGnHy9Gb2ThVzIbVPDxifOgP6aFejoIl
 CFNfEFoldAsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410303"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 3/6] KVM: SVM: Drop VMXE check from svm_set_cr4()
Date:   Tue,  6 Oct 2020 18:44:14 -0700
Message-Id: <20201007014417.29276-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop svm_set_cr4()'s explicit check CR4.VMXE now that common x86 handles
the check by incorporating VMXE into the CR4 reserved bits, via
kvm_cpu_caps.  SVM obviously does not set X86_FEATURE_VMX.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4f401fc6a05d..f92a19b77da3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1684,9 +1684,6 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
 
-	if (cr4 & X86_CR4_VMXE)
-		return 1;
-
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
 		svm_flush_tlb(vcpu);
 
-- 
2.28.0

