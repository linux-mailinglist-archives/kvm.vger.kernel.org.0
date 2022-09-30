Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EE15F0916
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiI3K1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiI3KZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:25:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8B236405;
        Fri, 30 Sep 2022 03:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533200; x=1696069200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CEku3Y+5uD95iizZnUIZvdPui7y5N0fIpv5aBviNf2w=;
  b=Ab01ajwDbNhkdhb1llHFTlOs4fpcibA4IptKRdH+aQq+4dEfIX5rXaUT
   b6yGUPVeg7FI966LSnY+M+PncA8JmsJENuX6ingEr2h2/i2K2rZ8TWj1S
   hWvlub94utUL6OWdIAvktT3xJo4Ppv0F4t/VOrcyuJBKxdMC3nj8dPnRd
   j8E1vpXvNmucqhe5gDrgC1/F+A3NNQa/P/IcU8nrhrTQ9zduJ6wE8fnhF
   Cf1+SLFg8Zjv89HzZrKN8Xizaz/Tnpjztj4m42Z8dwyuVC83nCZ0nUu4c
   bUyhORQyPwslCE2jrr4BZKe+CCw3/C0h2t8r3hjtsHP67WTOsGRl0KHkO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540179"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540179"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807830"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807830"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 098/105] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Fri, 30 Sep 2022 03:18:32 -0700
Message-Id: <a85b1723ceaab24b00c29be054c80b4596f3f45f.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a7cf08d60744..6318c0c09c0d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1078,6 +1078,37 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa = tdvmcall_a0_read(vcpu);
+	gpa_t size = tdvmcall_a1_read(vcpu);
+	gpa_t end = gpa + size;
+	gfn_t s = gpa_to_gfn(gpa) & ~kvm_gfn_shared_mask(kvm);
+	gfn_t e = gpa_to_gfn(end) & ~kvm_gfn_shared_mask(kvm);
+	bool map_private = kvm_is_private_gpa(kvm, gpa);
+	int ret;
+
+	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
+	    end < gpa ||
+	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
+	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	ret = kvm_mmu_map_gpa(vcpu, &s, e, map_private);
+	if (ret == -EAGAIN) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_RETRY);
+		tdvmcall_set_return_val(vcpu, gfn_to_gpa(s));
+	} else if (ret)
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	else
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1098,6 +1129,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

