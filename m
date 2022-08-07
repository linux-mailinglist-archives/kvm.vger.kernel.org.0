Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7058BD9B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiHGWKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbiHGWJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:09:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA49ABE38;
        Sun,  7 Aug 2022 15:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909809; x=1691445809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cJI1s3Vuc5aCICtzXw49h+6EHisgt0Ocvb3uwxgxGBQ=;
  b=cWNI76cdKMG0rCz3a9a3pR+wdmBmMNYaeq/ulGPaSgKVo3K2GPX1xaGD
   2YXfIqbTygk6tC74/YBz0p9YCE20RIAhiFTTHuQVKXlu2rstg5EWwYI4o
   ngOul0ffpYWMjUvF5CMQVJYmGPqo/VSDi9ZDFgXF5aBHW9KVZqG6lxGih
   zlumr4ZeDkIOce6Y7DJqbH6CksoscSqwID5px/E4qbXLTClGVrXUaPgMx
   YvL9Rgtx0kG/qqX08p4tLI4WfIHDtUifwE32sRtwk0Z8fMmwSxaY2ddwB
   4+2Bp39lSeKhsdh5JLdJeQw3mcLsZUmtQmtR2FoCTAvGCw+8nEOW21KJU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240416"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240416"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682764"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 097/103] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Sun,  7 Aug 2022 15:02:22 -0700
Message-Id: <45db7173c1f02d8be7129f9bea0624e7127ab55a.1659854791.git.isaku.yamahata@intel.com>
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

Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6131be42c721..47b3e5e591f4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1210,6 +1210,37 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
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
@@ -1230,6 +1261,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

