Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B327637B
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIWWE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:04:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:60138 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIWWE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:04:27 -0400
IronPort-SDR: HCkiFL994AJgx9QLXALbkZ5AgYfnufIBXaawc2y/RJHkKjNqGUA6LeDmcNXfAup3UH5Rb2RlYm
 jztZqyNoeZvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158381353"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158381353"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:04:27 -0700
IronPort-SDR: K4DfiKyLQdALLCoB5Hl497nNrC04Vo4uv5lmqIg3t7FX5LGOIkdVfp2+WUH6JBUJKKa+Y06MuU
 bQmVDgoMSvyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335647645"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:04:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 2/4] KVM: x86/mmu: Invert RET_PF_* check when falling through to emulation
Date:   Wed, 23 Sep 2020 15:04:23 -0700
Message-Id: <20200923220425.18402-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923220425.18402-1-sean.j.christopherson@intel.com>
References: <20200923220425.18402-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check for RET_PF_EMULATE instead of implicitly doing the same
by checking for !RET_PF_RETRY (RET_PF_INVALID is handled earlier).  This
will adding new RET_PF_ types in future patches without breaking the
emulation path.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a2a8f67a8f7..0b27c4caf5e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5454,10 +5454,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 			return -EIO;
 	}
 
-	if (r == RET_PF_RETRY)
-		return 1;
 	if (r < 0)
 		return r;
+	if (r != RET_PF_EMULATE)
+		return 1;
 
 	/*
 	 * Before emulating the instruction, check if the error code
-- 
2.28.0

