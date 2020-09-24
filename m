Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1435E27798F
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgIXTnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:43:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:31793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgIXTm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:57 -0400
IronPort-SDR: ohw5qSIGv1JOtoD33b4wdLdDQEOD2xDrYBW+dXDkoJWz7Kvc/3lVIZ/vxQdx1wUHF7tuL8JdUT
 xMUycXakq+nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076396"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076396"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:53 -0700
IronPort-SDR: sphcFmOIPr8ZyE0rndpU52g9haCu2iElE9atdGqEklsDjD4YMe5fSZ4uDvFw+nShMxWcT6YPTo
 SDhoNzVh6JeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953060"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] KVM: VMX: Use "illegal GPA" helper for PT/RTIT output base check
Date:   Thu, 24 Sep 2020 12:42:50 -0700
Message-Id: <20200924194250.19137-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_vcpu_is_illegal_gpa() to check for a legal GPA when validating a
PT output base instead of open coding a clever, but difficult to read,
variant.  Code readability is far more important than shaving a few uops
in a slow path.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7987de212057..8f1eb5dca794 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1037,7 +1037,7 @@ static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
 static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
 {
 	/* The base must be 128-byte aligned and a legal physical address. */
-	return !(base & (~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f));
+	return !kvm_vcpu_is_illegal_gpa(vcpu, base) && !(base & 0x7f);
 }
 
 static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
-- 
2.28.0

