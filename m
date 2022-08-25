Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687865A0BF9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 10:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiHYI4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 04:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiHYI4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 04:56:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EC6A895D;
        Thu, 25 Aug 2022 01:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661417797; x=1692953797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zNKMrn0ocm4C3ekDPQvN7ou5Bn4K35RLPaE4whp4PAc=;
  b=KRBWBb11oFjgm/7CU7q7EV+2lOh6ezTBg/ZK/OS9s6SAMeqFgBwI1MK9
   h5Uw6Ui8eSVcpybir5Wk+BQPdwF7d27WdsUv8CGHADYtIlgfJUAwQl0qD
   LhLb1BiRIlTizvRw/YXjfLOGQHU9pQId04gXR+mdDfpdX++1in5ds5Bjt
   CQHaJsDKk/AzK7RrR2BK049iu6LrgNcwX1FnQUPOoQJcawYp70mXNjB7h
   e7cKTap+Fwi0//8D8IhH3i2Z8CN2tj+CUF9JGJW1iKp4ri/IsM0t/b0TA
   GGZtGXyb8mTALtHGVqU6T2bbgOBCt5jibJFz7tJ50Vbr7i6xkv9hktLMu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="291756607"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="291756607"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 01:56:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="639505184"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2022 01:56:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: VMX: Stop/resume host PT before/after VM entry when PT_MODE_HOST_GUEST
Date:   Thu, 25 Aug 2022 16:56:25 +0800
Message-Id: <20220825085625.867763-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220825085625.867763-1-xiaoyao.li@intel.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation in pt_guest_enter() has two issues when pt mode
is PT_MODE_HOST_GUEST.

1. It relies on VM_ENTRY_LOAD_IA32_RTIT_CTL to disable host's Intel PT
   for the case that host's RTIT_CTL_TRACEEN is 1 while guest's is 0.

   However, it causes VM entry failure due to violating the requirement
   stated in SDM "VM-Execution Control Fields"

   If the logical processor is operating with Intel PT enabled (if
   IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
   IA32_RTIT_CTL" VM-entry control must be 0.

2. In the case both host and guest enable Intel PT, it disables host's
   Intel PT by manually clearing MSR_IA32_RTIT_CTL for the purpose to
   context switch host and guest's PT configurations.

   However, PT PMI can be delivered later and before VM entry. In the PT
   PMI handler, it will a) update the host PT MSRs which leads to what KVM
   stores in vmx->pt_desc.host becomes stale, and b) re-enable Intel PT
   which leads to VM entry failure as #1.

To fix the above two issues, call intel_pt_stop() exposed by Intel PT
driver to disable Intel PT of host unconditionally, it can ensure
MSR_IA32_RTIT_CTL.TraceEn is 0 and following PT PMI does nothing.

As paired, call intel_pt_resume() after VM exit.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..3e9ce8f600d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -38,6 +38,7 @@
 #include <asm/fpu/api.h>
 #include <asm/fpu/xstate.h>
 #include <asm/idtentry.h>
+#include <asm/intel_pt.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
 #include <asm/kexec.h>
@@ -1128,13 +1129,19 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	if (vmx_pt_mode_is_system())
 		return;
 
+	/*
+	 * Stop Intel PT on host to avoid vm-entry failure since
+	 * VM_ENTRY_LOAD_IA32_RTIT_CTL is set
+	 */
+	intel_pt_stop();
+
 	/*
 	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
 	 * Save host state before VM entry.
 	 */
 	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-		wrmsrl(MSR_IA32_RTIT_CTL, 0);
+		/* intel_pt_stop() ensures RTIT_CTL.TraceEn is zero */
 		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
 		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
 	}
@@ -1156,6 +1163,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	 */
 	if (vmx->pt_desc.host.ctl)
 		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+
+	intel_pt_resume();
 }
 
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
-- 
2.27.0

