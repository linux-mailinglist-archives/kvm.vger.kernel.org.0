Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D147F75BE68
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjGUGJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjGUGI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E671BC1;
        Thu, 20 Jul 2023 23:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919738; x=1721455738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZuQcR6f3jO1a6bdidmK1FklkJlTVOpSvErOUbLlFv04=;
  b=k9m0WLhjqsAqF0PVN7K204DL4rJ3TC+wmh/AoXSGaNOERuyTMzxpaYxR
   d2T99XnMmLy9v2+oI7Z8dwZNdThEBFLrpTNs8T6b2PKEHEUB4+1vGfCJP
   LZA9p0j4rBb8eLoySs6viGJIYJl6xWMSNtPuLniL4kNrfhp2E3B0YIJbI
   +NErzUo1/vMVaaF4CXJJVosNnZcw/BUP2XVInYzCYzcNc6Chc/XUgdtT/
   jUcDDH0hkTvMv39OVvneIf03yp+KJ+JTL3irxN1+tVTUA+FA+feuzFtWT
   /FeIKTvLt+UYCZyjgnjs1BEjV7bVKSYZHATL+O9Of8SWHWdkrsx4AbVmp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547603"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547603"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721983"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721983"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 15/20] KVM:VMX: Save host MSR_IA32_S_CET to VMCS field
Date:   Thu, 20 Jul 2023 23:03:47 -0400
Message-Id: <20230721030352.72414-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save host MSR_IA32_S_CET to VMCS field as host constant state.
Kernel IBT is supported now and the setting in MSR_IA32_S_CET
is static after post-boot except in BIOS call case, but vCPU
won't execute such BIOS call path currently, so it's safe to
make the MSR as host constant.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d0abee35d7ba..b1883f6c08eb 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85cb7e748a89..cba24acf1a7a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -109,6 +109,8 @@ module_param(enable_apicv, bool, S_IRUGO);
 bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
 
+static u64 __read_mostly host_s_cet;
+
 /*
  * If nested=1, nested virtualization is supported, i.e., guests may use
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
@@ -4355,6 +4357,9 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, host_efer);
+
+	if (cpu_has_load_cet_ctrl())
+		vmcs_writel(HOST_S_CET, host_s_cet);
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
@@ -8633,6 +8638,9 @@ static __init int hardware_setup(void)
 			return r;
 	}
 
+	if (cpu_has_load_cet_ctrl())
+		rdmsrl_safe(MSR_IA32_S_CET, &host_s_cet);
+
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
-- 
2.27.0

