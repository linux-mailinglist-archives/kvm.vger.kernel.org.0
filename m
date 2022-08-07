Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1405B58BDD9
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiHGWJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbiHGWHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B28BC1F;
        Sun,  7 Aug 2022 15:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909798; x=1691445798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dvY2QnLjVWunU4LZDJI5aPV8I0z/fE/3rogtYgCrynw=;
  b=BoLRWhlxEXmQZ4CG3u3X3dPfelVi5HJIDloNSBy9PshRUBxtArrtFLbo
   3Mj9/F6ckc7gNZ3xkK7ICJ3aXA6pCSZf8x/pYWKFyHboW1D1C1ThFphWF
   UaF4l/mNHmPnH/JvKkjdbtZ7kNPysuLjxV8jcUsobtN9LzRq80GX7vsY3
   XpoObOXOOYJO0Y6eWVNWPPzgzl/WB80xVzDM02cxz/jGc//PH4k1K+Wwy
   s7Sivr4dToOzeKq4aa0hKsNESW/vCU4VeJj//weiE37pG7PXlw6Hp15Bt
   FxdD7Q3bpKOekgi5xAjEPuzH0PDLAMFo3h476x4D5lZ12DuftryJgudIV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240402"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240402"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682740"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:43 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 090/103] KVM: TDX: Handle TDX PV CPUID hypercall
Date:   Sun,  7 Aug 2022 15:02:15 -0700
Message-Id: <6d9a5ec5e267162383160ff7f6889ea8ce906257.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 849bae37246a..93c4ef209a73 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -934,12 +934,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return 1;
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

