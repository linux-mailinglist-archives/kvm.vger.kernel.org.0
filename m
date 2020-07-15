Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA055220330
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgGOEGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgGOEGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:05 -0400
IronPort-SDR: C9m4PEjapDzBOeeY73VOPll7FvKsPzobKdxHRvLxGyxm+lu+WrL3lLJx0lwYBliOkuWE1t6juq
 k2lXhtbm4ciw==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167487"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167487"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:03 -0700
IronPort-SDR: MbssNKGmOLgp4+iuIgCJlNq0VZ+9/tKannUVxw9XEwu6VhjIpFgjRdcSJz0g0FAfzNliXDLnS5
 xuqrdcl2Zjjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587033"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 7/7] KVM: nVMX: WARN on attempt to switch the currently loaded VMCS
Date:   Tue, 14 Jul 2020 21:05:57 -0700
Message-Id: <20200715040557.5889-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 66ed449f0d59f..023055e636d61 100644
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
2.26.0

