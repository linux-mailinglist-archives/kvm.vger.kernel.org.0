Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C199F2B4FD1
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbgKPSdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:20621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732864AbgKPS16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:58 -0500
IronPort-SDR: 3c+WGq8pk3bTJWOoDYpqaMYDYw56CyewhRndKju6aYmUM/l1b9P/WJaBMlmok5AbGVlTpzmswb
 XG6QWoS1o7CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410009"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410009"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:58 -0800
IronPort-SDR: qrZNCQIOXrUCKSEqnCxF0rlIYJl9oGoBc04p+nOQrxBdlUDjDRMU23f5pErQKLXXwdZmZLv5Ie
 sjDeg+7ZM6Kg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527850"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:57 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 12/67] KVM: x86/mmu: Mark VM as bugged if page fault returns RET_PF_INVALID
Date:   Mon, 16 Nov 2020 10:25:57 -0800
Message-Id: <d625c5ca20be0bba4b099c1bae65da8bdc09f554.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c7e43e12513..bebd2b6ebcad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5059,7 +5059,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (r == RET_PF_INVALID) {
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
 					  lower_32_bits(error_code), false);
-		if (WARN_ON_ONCE(r == RET_PF_INVALID))
+		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
 
-- 
2.17.1

