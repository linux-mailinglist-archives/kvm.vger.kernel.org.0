Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F0E6A3D36
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjB0Iby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjB0I33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8C1D93D;
        Mon, 27 Feb 2023 00:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486361; x=1709022361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Y94LCoLS6sZG9ihodBSXz/QYH5KARFcUZtH+ByNpEg=;
  b=AG+wpJTGktEt2RMytXOxRAq4fuqVTSXvh5PpCZ8eScb36YlGRyikv2bO
   gJsfqYxcY8R5arultj+77ZL1iIIWqDEb9hzqRVQAVaZNRTo1ZyxFEmKM7
   uX3JQ+PZ9v9fgOiM9Om7oELtGjcmwXP7iY5gsoPSq/ZRBD1kzdDaV0pTQ
   HCOf3QLKmsH0doMgnqQ+upsbdGb+s9sc/JKb+Yk5pJbTNUaOzsE8sE6wy
   +ct0bKqfiapPBzfNAppnz60LKxu7d3PAweKvbYiGeYPbDjwkV4X65+R2M
   CiN9Q5Ugpx1krZPZPcRhH3iFvWTtMBXI6xDChN5t4jo0etRxgKkSjE2Lr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609040"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609040"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242383"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242383"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 084/106] KVM: TDX: Handle TDX PV CPUID hypercall
Date:   Mon, 27 Feb 2023 00:23:23 -0800
Message-Id: <eaf8e469752c1d0a35b322a6c3163b152a96bebf.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV CPUID hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7d806aab9598..5add38cfd9f9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -967,12 +967,34 @@ static int tdx_vp_vmcall_to_user(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdvmcall_a0_read(vcpu);
+	ecx = tdvmcall_a1_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+
+	tdvmcall_a0_write(vcpu, eax);
+	tdvmcall_a1_write(vcpu, ebx);
+	tdvmcall_a2_write(vcpu, ecx);
+	tdvmcall_a3_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
 		return tdx_emulate_vmcall(vcpu);
 
 	switch (tdvmcall_leaf(vcpu)) {
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

