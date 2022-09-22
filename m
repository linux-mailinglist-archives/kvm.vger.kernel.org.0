Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2D35E6ACC
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiIVSYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiIVSXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617AF10C7AB;
        Thu, 22 Sep 2022 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870943; x=1695406943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K9aaefQYUfoduQuXfrOa7CqsIFkvX11RqK1UcOrUa/c=;
  b=N74Jol8cPa83oDa53rDXdNb8zcE/mMbTiYcCNaiL6hd1kzuD9B7tuKxT
   Falx2YSyoabjq+sOPs3nct6r9KIWIUNJsEbnd4XtUIO5Fsjp6FqaX1o4h
   Vme6NXkGir0bO4P0ETmhkfL+FG6ebUGgYtaHndWWIUjSWBPWEwVAx+VTy
   vtnYxMIb+e4yuIbQDRJtF6kZ0WIcRj88EhL8/3Px8rqxzcY5a/O7erqnF
   /HTKECNMbCrKHVlsTyM/Y4blklFjUE5gSZFjJEg732P3aXQULpv7jWa/c
   uzN/t09kM/+Zj+NemVHAwjXd7BYkqyrW3jlisvMCU7mqesRWVilGdUXi1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712936"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712936"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086887"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:27 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 26/30] KVM: x86: Make x86 processor compat check callback empty
Date:   Thu, 22 Sep 2022 11:20:55 -0700
Message-Id: <51853ef700087241e624fc531cd79e41972d51aa.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Move processor compatibility check on all processors into
kvm_arch_hardware_setup() and make kvm_arch_check_processor_compat{,_all}()
empty.  This is a preparation step to eliminate them.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa6594de1fc1..00cc74276819 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -129,6 +129,8 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
+static int kvm_check_processor_compatibility(void);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -12033,21 +12035,8 @@ int kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
-static void check_processor_compat(void *rtn)
-{
-	*(int *)rtn = kvm_arch_check_processor_compat();
-}
-
 int kvm_arch_check_processor_compat_all(void)
 {
-	int cpu;
-	int r;
-
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			return r;
-	}
 	return 0;
 }
 
@@ -12055,7 +12044,7 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
+	ret = kvm_check_processor_compatibility();
 	if (ret)
 		return ret;
 
@@ -12125,6 +12114,24 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 	kvm_pmu_ops_update(ops->pmu_ops);
 }
 
+static void check_processor_compat(void *rtn)
+{
+	*(int *)rtn = kvm_check_processor_compatibility();
+}
+
+static int kvm_check_processor_compatibility_all(void)
+{
+	int cpu;
+	int r;
+
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, check_processor_compat, &r, 1);
+		if (r < 0)
+			return r;
+	}
+	return 0;
+}
+
 int kvm_arch_hardware_setup(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
@@ -12165,7 +12172,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	}
 	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
 	kvm_init_msr_list();
-	return 0;
+
+	return kvm_check_processor_compatibility_all();
 }
 
 void kvm_arch_hardware_unsetup(void)
@@ -12175,7 +12183,7 @@ void kvm_arch_hardware_unsetup(void)
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-int kvm_arch_check_processor_compat(void)
+static int kvm_check_processor_compatibility(void)
 {
 	int cpu = smp_processor_id();
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -12195,6 +12203,11 @@ int kvm_arch_check_processor_compat(void)
 	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
+int kvm_arch_check_processor_compat(void)
+{
+	return 0;
+}
+
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
-- 
2.25.1

