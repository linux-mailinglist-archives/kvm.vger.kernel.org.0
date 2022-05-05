Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B1C51C714
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383471AbiEESVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383279AbiEESTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF8B5DA77;
        Thu,  5 May 2022 11:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774559; x=1683310559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9xf32HW6EXdJYgTdtxGZYvnAhMF+g9xyTE0/Qzb0fQY=;
  b=fm/4zcFIiAb2tOb1iky810vaJDmoUXk7fUmQ7gDrQrIxGopAm54959wI
   sMEnpJpmPmNOODxTPvN+KUJVkX07jlihUoGQu4WzvqX5KpNmo1RqKYCnX
   9PB85MsDkiIugc+glyro5snmgAgmji8buFJuDyCncpkFnxne9hklOQUnF
   7BCYLFb6sPBJeYB3tqeQU/+RjywQeF90Lf6LcAN6ZiGzeOKg3UXgy5o+P
   6tce8ahBwbCrfzmTgQ1JHdigQyNAZT0cZJ5m3UEyEJo3QC9Nak1MDZ1rl
   pOIwvAykvmsM3ZONiSWNSxVfig/yGXugOsOOVgS/w4NvNwP/CxkrtUrCP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268097120"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268097120"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083494"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 097/104] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Thu,  5 May 2022 11:15:31 -0700
Message-Id: <ef10b38a868fb411c848fe05cc27961426a0f2e4.1651774251.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ee83539d5228..d5bb5f1cbd21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1221,6 +1221,64 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa = tdvmcall_a0_read(vcpu);
+	gpa_t size = tdvmcall_a1_read(vcpu);
+	gpa_t end = gpa + size;
+	bool allow_private = kvm_is_private_gpa(kvm, gpa);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
+		end < gpa ||
+		end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
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
+		int ret = kvm_mmu_map_gpa(vcpu, &s, e, allow_private);
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
+		 *	tdvmcall_a0_write(vcpu, gpa);
+		 *	tdvmcall_a1_write(vcpu, size);
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
 	if (tdvmcall_exit_type(vcpu))
@@ -1241,6 +1299,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

