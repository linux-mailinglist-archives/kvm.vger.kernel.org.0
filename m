Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7759B27604B
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIWSpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:45:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:14510 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgIWSo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:56 -0400
IronPort-SDR: 0cYw9OYCf+6zlqPkwLqvWwvdGxaKTq0yHAhWzSAboqTvXaXUUoFs4tNkeKPPNc4INHuLWU239C
 l18iXaHHXTAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124482"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:55 -0700
IronPort-SDR: nBFUT/ClqmT7X9z4IaAId7lj3ZBhyGA+jG+t8fWea2uO7jw1PqrAKy/7uyw9MDFLcdC974eTpW
 ohTPvmS1Jgnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457664"
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
Subject: [PATCH v2 5/7] KVM: nVMX: Ensure vmcs01 is the loaded VMCS when freeing nested state
Date:   Wed, 23 Sep 2020 11:44:50 -0700
Message-Id: <20200923184452.980-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a WARN in free_nested() to ensure vmcs01 is loaded prior to freeing
vmcs02 and friends, and explicitly switch to vmcs01 if it's not.  KVM is
supposed to keep is_guest_mode() and loaded_vmcs==vmcs02 synchronized,
but bugs happen and freeing vmcs02 while it's in use will escalate a KVM
error to a use-after-free and potentially crash the kernel.

Do the WARN and switch even in the !vmxon case to help detect latent
bugs.  free_nested() is not a hot path, and the check is cheap.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 03dddf1b6009..3e6cc0d7090e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -279,6 +279,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
+		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
-- 
2.28.0

