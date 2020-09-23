Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55889276046
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgIWSpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:45:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:14513 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgIWSpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:45:06 -0400
IronPort-SDR: oAnOQPo+fGVnoEnZ1VDWJmPmPGWYGsc6dKeDHgOR2xC2Q9yDG4kpLIXK8gVa3xkAnHroqP66dR
 zsL2C6aWj96g==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124487"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124487"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:56 -0700
IronPort-SDR: ipvuSnANJBxVJaIKiu7lfImqITPAsyeQbfSTm8wv0FKyqCo7QM5RGpGzPBHHrNx2kvb6l8rLFr
 w5lMmwPllLDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457677"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 7/7] KVM: nVMX: WARN on attempt to switch the currently loaded VMCS
Date:   Wed, 23 Sep 2020 11:44:52 -0700
Message-Id: <20200923184452.980-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if KVM attempts to switch to the currently loaded VMCS.  Now that
nested_vmx_free_vcpu() doesn't blindly call vmx_switch_vmcs(), all paths
that lead to vmx_switch_vmcs() are implicitly guarded by guest vs. host
mode, e.g. KVM should never emulate VMX instructions when guest mode is
active, and nested_vmx_vmexit() should never be called when host mode is
active.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 63550dcf6b9f..4bddda078370 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -258,7 +258,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	struct loaded_vmcs *prev;
 	int cpu;
 
-	if (vmx->loaded_vmcs == vmcs)
+	if (WARN_ON_ONCE(vmx->loaded_vmcs == vmcs))
 		return;
 
 	cpu = get_cpu();
-- 
2.28.0

