Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C4955CB9B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbiF0V6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241301AbiF0V4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:56:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C52186CA;
        Mon, 27 Jun 2022 14:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366910; x=1687902910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AF6mPQp9GNBElxNBQ/Xqf0SjR2tlL8B1BcfJgWVWiM8=;
  b=dEXZd3Ul02g4iEJdcPMbByF0ipt4/zowpZA2y2GPsGgHJ5MjMqlUBu8C
   CEuv8CovyVmp1EeAq3oeIguFNbyy0j3WdiHdXFfp8TZ1jWoLWDDrMufi9
   VPguRv6T/wdDnYHuAepkCiOrXqn/PBsNfNnrtAu8KvAjCPszQegFLLT0B
   wzvHuJBk6FcOprhNXn0w9TsiT44fd3zVtwD6weYXmZ6doQDKRoAQZLuoM
   qysg7VaE35KXuX9DKzFMH36sJVw1adtDcMtVjYH7FazJBF6lS3i542Sg8
   cYDbj+cpuYVhkyPx5QzM1yW3MGqE9DDIznjK9TcG/ArnzqJLAgkY9c017
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116148"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116148"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863761"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 096/102] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Mon, 27 Jun 2022 14:54:28 -0700
Message-Id: <86da659dba9490f7b5b9b0cf1facb6e059d79720.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 00baecbb62ff..d4ac573d9db3 100644
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

