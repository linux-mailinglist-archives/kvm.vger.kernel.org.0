Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6F24CDDA7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiCDUAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37441240DC7;
        Fri,  4 Mar 2022 11:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423444; x=1677959444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Sz+O1NWDHrENlYKq+VQPWSvpi45g862SSVY1VpD5I8=;
  b=mzsJWTydMo+aO8V8kznZCX/T/4ToKSwdagEBF/wWzLi4X9/PoIjWW9zn
   eEYXDV7hpHMbXg8+eKBqfqaz89yEVWGClqiZuScR2z9JeZCQjDG+bZUqI
   pR3S07VqxdFmtQkZTK0vbxSp8kw3Ap2ikZiRXjlajvFdXqzJ21lLc9v/x
   KsG0ZTdRRm0EELNOcTPIBxbKsAhnxsx2n9rKOIGbDuN1XbEtv3ldzthD/
   ixhOOKOckKqUmsupgeP2uI3E9gk8FGNQaeNREdq1CpxaDINbDGei7obQX
   r4TVYInONAIbKiFdubOms3QEBIkucA+V92inGpu+9GsOmOva6nGfpXNSQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779646"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779646"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:42 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344540"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:42 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 088/104] KVM: TDX: Add TDG.VP.VMCALL accessors to access guest vcpu registers
Date:   Fri,  4 Mar 2022 11:49:44 -0800
Message-Id: <e490d6b5d26bc431684110dcca068a8b759b97aa.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX defines ABI for the TDX guest to call hypercall with TDG.VP.VMCALL API.
To get hypercall arguments and to set return values, add accessors to guest
vcpu registers.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dc83414cb72a..8695836ce796 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -88,6 +88,41 @@ static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
 	return kvm_r9_read(vcpu);
 }
 
+#define BUILD_TDVMCALL_ACCESSORS(param, gpr)					\
+static __always_inline								\
+unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)			\
+{										\
+	return kvm_##gpr##_read(vcpu);						\
+}										\
+static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu,	\
+						     unsigned long val)		\
+{										\
+	kvm_##gpr##_write(vcpu, val);						\
+}
+BUILD_TDVMCALL_ACCESSORS(p1, r12);
+BUILD_TDVMCALL_ACCESSORS(p2, r13);
+BUILD_TDVMCALL_ACCESSORS(p3, r14);
+BUILD_TDVMCALL_ACCESSORS(p4, r15);
+
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return kvm_r10_read(vcpu);
+}
+static __always_inline unsigned long tdvmcall_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return kvm_r11_read(vcpu);
+}
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	kvm_r10_write(vcpu, val);
+}
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	kvm_r11_write(vcpu, val);
+}
+
 static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
 {
 	return tdx->tdvpr.added;
-- 
2.25.1

