Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D726A6B1D
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCAKzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCAKzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:55:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D7199C5;
        Wed,  1 Mar 2023 02:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677668119; x=1709204119;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cQW3UjoZ8STk4EBpGWCDdeDbUKoQsyy3x1sFBtGhWTU=;
  b=a96fGpogU0YAb7PEWYReceOJBPua+YLmi60AQleOA3BBRAoEOmJz2TPS
   liTi1aLSen/kOJoerliwer2gn7gnsRyWImgJhFEhstVb+CxLKt7bWjyzd
   8TuVp2l0cBiHWy/GAO488yvndMErwZvELIlh4BejzJLnucCKnBMj8pbfX
   0S4q0ToZ2+bMZnxJ1TklIdsjskQFzhkBxCuQFGgUhgsUApR037iIFp6l9
   RozMSDyekam98iNoswMooVyaQfwDHMIKZB0upMDGEWYhdROBZfquR3bA6
   VVp7ROKoKjGwN9u45mqyUDO23+Xis43UTh3hgZFdfYPVZMB/yX915E0RN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="331857912"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="331857912"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 02:55:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="674523710"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="674523710"
Received: from rtuppadd-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.188.82])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 02:55:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Date:   Wed,  1 Mar 2023 23:54:38 +1300
Message-Id: <20230301105438.599196-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make setup_vmcs_config() preemption disabled so it always performs on
the same local cpu.

During module loading time, KVM intends to call setup_vmcs_config() to
set up the global VMCS configurations on _one_ cpu in hardware_setup(),
and then calls setup_vmcs_config() on all other online cpus via sending
IPI to perform VMX compatibility check.  Further more, KVM has CPU
hotplug callback to call setup_vmcs_config() to do compatibility check
on the "new-online" cpu to make sure it is compatible too.

setup_vmcs_config() is supposed to be done on the same cpu.  This is
true in the compatibility check code path as setup_vmcs_config() is
called either via IPI or in per-cpu CPU hotplug thread.  However, the
first call from hardware_setup() isn't as it is called when preemption
is enabled.

Change the existing setup_vmcs_config() to __setup_vmcs_config() and
call the latter directly in the compatibility check code path.  Change
setup_vmcs_config() to call __setup_vmcs_config() with preemption
disabled so __setup_vmcs_config() is always done on the same cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33614ee2cd67..dfbc0e9095ec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2578,8 +2578,8 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
-static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-			     struct vmx_capability *vmx_cap)
+static int __setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			       struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
@@ -2745,6 +2745,18 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
+static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			     struct vmx_capability *vmx_cap)
+{
+	int ret;
+
+	preempt_disable();
+	ret = __setup_vmcs_config(vmcs_conf, vmx_cap);
+	preempt_enable();
+
+	return ret;
+}
+
 static bool kvm_is_vmx_supported(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -2772,7 +2784,7 @@ static int vmx_check_processor_compat(void)
 	if (!kvm_is_vmx_supported())
 		return -EIO;
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+	if (__setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
 		pr_err("Failed to setup VMCS config on CPU %d\n", cpu);
 		return -EIO;
 	}

base-commit: 93827a0a36396f2fd6368a54a020f420c8916e9b
-- 
2.39.1

