Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25779732FF0
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343627AbjFPLfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343558AbjFPLe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:34:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC422720;
        Fri, 16 Jun 2023 04:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686915298; x=1718451298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LkXyR9UDa+UGMlpZj+eHWARNTjsTp0DLc/JaBM9s1As=;
  b=Zwc/+Pe+8ezjeQiRy3n7FnTeufjh6Gz/DDutmFtr+5ebTs9Piv7rezHD
   UI1CJVj1Kp7fyQHBNnkrcZg3Mka5+abpis+mv15zSBMrBUZUZpHpg/5j+
   KBTtnlmY7eTui1DqecNlccV4xrD6Qp0Sd1wR1Kr/Prybzj9WMn8jRQEbd
   8EZFoIDy0AVm+UNvSOsGYShnOwJXG82OAPodxQwbyZOL9hUhTd2S++kHS
   DMCI1sywNv663iRAssvoTNTUuwnsi1rHcKL10xgWEVmaFThqIiH3lDEUc
   jkv82IUjXcziv3QuNM6ysPBptFXsar6B5PKxHl3pJAFewwugTnQYT9EEZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445574778"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445574778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782872303"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782872303"
Received: from youzhiji-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.249.173.213])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:55 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 2/4] KVM: VMX/pmu: Save host debugctlmsr just before vm entry
Date:   Fri, 16 Jun 2023 19:33:51 +0800
Message-Id: <20230616113353.45202-3-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230616113353.45202-1-xiong.y.zhang@intel.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perf defines four types of perf event: per cpu pinned event, per process
pinned event, per cpu event, per process event, their prioirity are from
high to low. vLBR event is per process pinned event. So durng vm exit
handler, if vLBR event preempts perf low priority LBR event, perf will
disable LBR and let guest control LBR, or if vLBR event is preempted by
perf high priority LBR event, perf will enable LBR. In a word LBR status
may be changed during vm exit handler.

MSR_IA32_DEBUGCTLMSR[0] controls LBR enabling, kvm saves its value into
vmx->host_debugctlmsr in vcpu_load(), and kvm restores its value from
vmx->host_debugctlmsr after vm exit immediately. Since
MSR_IA32_DEBUGCTLMSR[0] could be changed during vm exit handler, the
saved value vmx->host_debugctlmsr could be wrong. So this commit saves
MSR_IA32_DEBUGCTLMSR into vmx->host_debugctlmsr just before vm entry to
reflect the real hardware value.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..5ca61a26d0d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1459,13 +1459,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  */
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
-
-	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -7273,6 +7269,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	atomic_switch_perf_msrs(vmx);
 	if (intel_pmu_lbr_is_enabled(vcpu))
 		vmx_passthrough_lbr_msrs(vcpu);
+	vmx->host_debugctlmsr = get_debugctlmsr();
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
-- 
2.25.1

