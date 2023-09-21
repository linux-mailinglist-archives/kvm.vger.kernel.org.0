Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5583F7A995D
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjIUSOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjIUSNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:13:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9819ECE
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318598; x=1726854598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=efkQc+tbxzsdrsFs8ZgvsaNPhMb65ZoGq5/udoaz3jU=;
  b=O+6v8IHqYDXaX0Lra6pj8KqVTu3AjvKL1H/e6ipKM5v5EpGNbXLx9GJr
   B/QJgEHYbJG8G+ZImNuoPhihtqHITzSE+aZ6OA+1tQAlFAz4bN7CZZprh
   SaRPdEi1Vp3Jocl882vO9otfpu849H38Q0UWRyuhmV2ZjVcD+vEK6SXMo
   YOtm4tozBSyYlASsGYTMki38DJWhf4GGqEOnko5zkp2fXKrs4KCKKjTX+
   PtJeyCOW016dPOmGFMZ1tScW56m9SpsbvG9iA19EtM+r4mHq1yF2q+REY
   eVrvOdGZpgREp0d3Y4n7cxakYl1x4McZbB5GfpE8Qy29zXnWQXMp0+qs+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841322"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841322"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001019"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001019"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:48 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 1/9] KVM: x86/PMU: Delay vLBR release to the vcpu next sched-in
Date:   Thu, 21 Sep 2023 16:29:49 +0800
Message-Id: <20230921082957.44628-2-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921082957.44628-1-xiong.y.zhang@intel.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest LBR is disabled at vCPU sched-in time, the vLBR event will be
released, then the following guest LBR MSRs accessing will be trapped,
and cause KVM to create new vLBR event. If this new vLBR event is the
only user of host LBR facility, host LBR driver will reset LBR facility
at vLBR creation. So guest LBR content may be changed during vCPU
sched-out and sched-in.

Considering this serial:
1. Guest disables LBR.
2. Guest reads LBR MSRs, but it doesn't finish.
3. vCPU is sched-out, later sched-in, vLBR event is released.
4. Guest continue reading LBR MSRs, KVM creates vLBR event again,
if this vLBR event is the only LBR user on host now, host LBR driver
will reset HW LBR facility at vLBR creataion.
5. Guest gets the remain LBR MSRs with reset state.
So gueest LBR MSRs reading before vCPU sched-out is correct, while
guest LBR MSRs reading after vCPU sched-out is wrong and is in
reset state. Similarly guest LBR MSRs writing before vCPU sched-out
is lost and is in reset state, while guest LBR MSRs writing after
vCPU sched-out is correct.

This is a bug that guest LBR content is changed as vCPU's scheduling.
This can happen when guest LBR MSRs accessing spans vCPU's scheduling,
usually guest access LBR MSRs at guest task switch and PMI handler.

Two options could be used to fixed this bug:
a. Save guest LBR snapshot at vLBR release in step 3, then restore
guest LBR after vLBR creation in step 4. But the number of LBR
MSRs is near 100, this means 100 MSRs reading and 100s writing are
needed for each vLBR release, the overhead is too heavy.
b. Defer vLBR release in step 3.

This commit choose the option b. Guest LBR MSRs accessing is
passthrough, so the interceptable guest DEBUGCTLMSR_LBR bit is used to
predict guest LBR usage. If guest LBR is disabled in a whole vCPU shced
time slice, KVM will predict guest LBR won't be used recently, then vLBR
will be released in next vCPU sched-in. Guest LBR MSRs accessing should
be finished in two vCPU sched time slice, otherwise it is maybe a guest
LBR driver bug and can not be supported by this commit.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++--
 arch/x86/kvm/vmx/vmx.c       | 12 +++++++++---
 arch/x86/kvm/vmx/vmx.h       |  2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f2efa0bf7ae8..76d7bd8e4fc6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -628,6 +628,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
+	lbr_desc->in_use = FALSE;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -761,8 +762,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
-		intel_pmu_release_guest_lbr_event(vcpu);
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)) {
+		if (!lbr_desc->in_use)
+			intel_pmu_release_guest_lbr_event(vcpu);
+		lbr_desc->in_use = false;
+	}
 }
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..4056e19266b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2238,9 +2238,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
-		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
-		    (data & DEBUGCTLMSR_LBR))
-			intel_pmu_create_guest_lbr_event(vcpu);
+
+		if (intel_pmu_lbr_is_enabled(vcpu) && (data & DEBUGCTLMSR_LBR)) {
+			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+			lbr_desc->in_use = true;
+			if (!lbr_desc->event)
+				intel_pmu_create_guest_lbr_event(vcpu);
+		}
+
 		return 0;
 	}
 	case MSR_IA32_BNDCFGS:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..547edeb52d09 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -107,6 +107,8 @@ struct lbr_desc {
 
 	/* True if LBRs are marked as not intercepted in the MSR bitmap */
 	bool msr_passthrough;
+
+	bool in_use;
 };
 
 /*
-- 
2.34.1

