Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECB276049
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgIWSpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:45:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:14513 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgIWSo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:56 -0400
IronPort-SDR: K+es5OCSxHlIVZRqBnUIEbvXIZe0yVh8RBUACVsqMfp/9fp73Fj4lWl2DRdkxyZbY7mMIpVbnn
 o/cqCrR6T3yg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124485"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124485"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:56 -0700
IronPort-SDR: LJmfUAh3YJ/mUEf5ifh8x++CzfEJN3+5Xz6IPpLqHG4SnupQ83mqwCwZLWnltROZYuX52UiM60
 gwdRfu0hCAow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457671"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 6/7] KVM: nVMX: Drop redundant VMCS switch and free_nested() call
Date:   Wed, 23 Sep 2020 11:44:51 -0700
Message-Id: <20200923184452.980-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit switch to vmcs01 and the call to free_nested() in
nested_vmx_free_vcpu().  free_nested(), which is called unconditionally
by vmx_leave_nested(), ensures vmcs01 is loaded prior to freeing vmcs02
and friends.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3e6cc0d7090e..63550dcf6b9f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -326,8 +326,6 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
 	vmx_leave_nested(vcpu);
-	vmx_switch_vmcs(vcpu, &to_vmx(vcpu)->vmcs01);
-	free_nested(vcpu);
 	vcpu_put(vcpu);
 }
 
-- 
2.28.0

