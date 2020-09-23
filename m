Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05E127637C
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgIWWE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:04:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:60138 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgIWWE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:04:27 -0400
IronPort-SDR: Pxa2msn0HgXxbOjOSsLDpVb7w1Q1OTTMnVzQW+98LI/QqpP/no1l20/ya2g8XnzA99k2zCEdrj
 FUfl3GOx8pUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158381352"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158381352"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:04:27 -0700
IronPort-SDR: cXwlLqEh1bEo2PO09WKC4xrYeHG0+Hz9T19Ugysv9fhWb1+nEOoVF494RC+gQTNUEL3LKJL2Sg
 Iyjte0gvyB1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335647638"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:04:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 1/4] KVM: x86/mmu: Return -EIO if page fault returns RET_PF_INVALID
Date:   Wed, 23 Sep 2020 15:04:22 -0700
Message-Id: <20200923220425.18402-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923220425.18402-1-sean.j.christopherson@intel.com>
References: <20200923220425.18402-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace with an error if the MMU is buggy and returns
RET_PF_INVALID when servicing a page fault.  This will allow a future
patch to invert the emulation path, i.e. emulate only on RET_PF_EMULATE
instead of emulating on anything but RET_PF_RETRY.  This technically
means that KVM will exit to userspace instead of emulating on
RET_PF_INVALID, but practically speaking it's a nop as the MMU never
returns RET_PF_INVALID.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..4a2a8f67a8f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5450,7 +5450,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (r == RET_PF_INVALID) {
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
 					  lower_32_bits(error_code), false);
-		WARN_ON(r == RET_PF_INVALID);
+		if (WARN_ON_ONCE(r == RET_PF_INVALID))
+			return -EIO;
 	}
 
 	if (r == RET_PF_RETRY)
-- 
2.28.0

