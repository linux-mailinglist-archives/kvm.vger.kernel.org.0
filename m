Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0176A4CDD88
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiCDT7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D33240DD7;
        Fri,  4 Mar 2022 11:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423448; x=1677959448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n7MzOGa6UXc/+Sfx7p2znrkBFunb0WZIIFqqHTxl8jI=;
  b=RUpy3bLVesSjbtj3FG/kzLcsaOQ2EF3SzskuZd0xa9jTxsLBYbRFtCyz
   UNlfZDt41YO0KOPoWvm2kl1Ncq0zZz733ju9xu2gdPv0FyL+jrNoKetZG
   ivVr7T4fZv1SRp3CjS3Ycf/umuq5fxjp2g4n64Tnqs+5qJZXoy01Jj4Ir
   lMmpNPWz2GLUCg+IZ8DFKqRvxB5EKCgbAL2U59zPX962qFIstZQ5vGY+0
   xB/JmDmsueVD+QM6/bWywlcgdOK5m6AsN3ja+GRmrV18jueb4pBbwiUvN
   yh1G3Symz3NygjQM6dxiyjxmQGCbZzvlbt89ry6nmO0VA48AXUfUNAR+P
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779663"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779663"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344609"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:47 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 099/104] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Fri,  4 Mar 2022 11:49:55 -0800
Message-Id: <a97b16eb1b495f46070c7023f1b596bdba034f4a.1646422845.git.isaku.yamahata@intel.com>
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

Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 59 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4d668a6c7dc9..e5eccec0e24d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1166,6 +1166,63 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa = tdvmcall_p1_read(vcpu);
+	gpa_t size = tdvmcall_p2_read(vcpu);
+	gpa_t end = gpa + size;
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
+		end < gpa ||
+		end > kvm_gfn_stolen_mask(kvm) << (PAGE_SHIFT + 1) ||
+		kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end))
+		return 1;
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+#define TDX_MAP_GPA_SIZE_MAX   (16 * 1024 * 1024)
+	while (gpa < end) {
+		gfn_t s = gpa_to_gfn(gpa);
+		gfn_t e = gpa_to_gfn(
+			min(roundup(gpa + 1, TDX_MAP_GPA_SIZE_MAX), end));
+		int ret = kvm_mmu_map_gpa(vcpu, &s, e);
+
+		if (ret == -EAGAIN)
+			e = s;
+		else if (ret) {
+			tdvmcall_set_return_code(vcpu,
+						TDG_VP_VMCALL_INVALID_OPERAND);
+			break;
+		}
+
+		gpa = gfn_to_gpa(e);
+
+		/*
+		 * TODO:
+		 * Interrupt this hypercall invocation to return remaining
+		 * region to the guest and let the guest to resume the
+		 * hypercall.
+		 *
+		 * The TDX Guest-Hypervisor Communication Interface(GHCI)
+		 * specification and guest implementation need to be updated.
+		 *
+		 * if (gpa < end && need_resched()) {
+		 *	size = end - gpa;
+		 *	kvm_r12_write(vcpu, gpa);
+		 *	kvm_r13_write(vcpu, size);
+		 *	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INTERRUPTED_RESUME);
+		 *	break;
+		 * }
+		 */
+		if (gpa < end && need_resched())
+			cond_resched();
+	}
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1191,6 +1248,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_wrmsr(vcpu);
 	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
+	case TDG_VP_VMCALL_MAP_GPA:
+		return tdx_map_gpa(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

