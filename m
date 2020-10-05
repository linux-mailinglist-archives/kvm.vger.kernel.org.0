Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD0283FE9
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 21:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgJETzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 15:55:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:42023 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgJETzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 15:55:52 -0400
IronPort-SDR: PcqCs+WCA38lv1njoTZGWKkjJPcX2ca6RnholZCh8/AELOwOC1JzY/liz8yPAfJobq66zY+Yt0
 fSm4sLescFeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="181660128"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="181660128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 12:55:37 -0700
IronPort-SDR: DbCMeOUhst1V5ODW4G0ihEwi7ZnnQ0aARCr7wK7vaGF+RFPiaUir8bElz/dTo4u2gU2TqX6Jkk
 ZnjIIuAyZG8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="353550110"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2020 12:55:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 1/2] KVM: VMX: Fix x2APIC MSR intercept handling on !APICV platforms
Date:   Mon,  5 Oct 2020 12:55:31 -0700
Message-Id: <20201005195532.8674-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005195532.8674-1-sean.j.christopherson@intel.com>
References: <20201005195532.8674-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Fix an inverted flag for intercepting x2APIC MSRs and intercept writes
by default, even when APICV is enabled.

Fixes: 3eb900173c71 ("KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied")
Not-signed-off-by: Peter Xu <peterx@redhat.com>
[sean: added changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..25ef0b22ac9e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3787,9 +3787,10 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
 	int msr;
 
 	for (msr = 0x800; msr <= 0x8ff; msr++) {
-		bool intercepted = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
+		bool apicv = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
 
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_RW, intercepted);
+		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, !apicv);
+		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, true);
 	}
 
 	if (mode & MSR_BITMAP_MODE_X2APIC) {
-- 
2.28.0

