Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04695B2A50
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiIHX1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiIHX1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:27:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC7F115CC3;
        Thu,  8 Sep 2022 16:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679583; x=1694215583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IDO9vgRZGN9o4PRsD59O3z85CBSphz3E60aJtgsIp8c=;
  b=Jl1KRZ6aMhsDufaPPdWvxK5t+jPr/n4+ZFia8nNyQXja0JrDzTUjmc2l
   BWSQo9uZBjn0WHga3zwKAlnBIiGEz99EBb4cga6XZk1PGBMkvAL2VALsr
   kMl0AoosWcMmNkwq3YQxQnKqLxrlMyj0KG0Y4+fl3oJtJKU2PQx04033s
   DzXeuT4CQZRKhqNJlqSmB2Lp4y6C1otgYT4pglRBhpm9+tBK5h4DvyuJ3
   qB32N5Io4+y+yyJD853oNmhK9zr7RGzRLpQ6llzA0x5P8PkY38qpuvHJZ
   Ak4YbXl2BD7KqGm1y2MVfZyskXCPBClVRQ99e9YnZ3PBQe1Zkl217BjsM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687039"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687039"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863274"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:15 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 22/26] KVM: x86: Make x86 processor compat check callback empty
Date:   Thu,  8 Sep 2022 16:25:38 -0700
Message-Id: <fc3c8c0a3bb5a5aa38a8c261e992ac636de4da3c.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/x86.c | 47 +++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c9d965859c6..9dd90f0521c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -129,6 +129,8 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
+static int kvm_check_processor_compatibility(void);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -11911,21 +11913,8 @@ int kvm_arch_del_vm(int usage_count)
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
 
@@ -11933,7 +11922,7 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
+	ret = kvm_check_processor_compatibility();
 	if (ret)
 		return ret;
 
@@ -11997,7 +11986,7 @@ void kvm_arch_resume(int usage_count)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	if (kvm_arch_check_processor_compat())
+	if (kvm_check_processor_compatibility())
 		return; /* FIXME: disable KVM. */
 
 	if (!usage_count)
@@ -12103,6 +12092,24 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
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
@@ -12143,7 +12150,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	}
 	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
 	kvm_init_msr_list();
-	return 0;
+
+	return kvm_check_processor_compatibility_all();
 }
 
 void kvm_arch_hardware_unsetup(void)
@@ -12155,7 +12163,7 @@ void kvm_arch_hardware_unsetup(void)
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-int kvm_arch_check_processor_compat(void)
+static int kvm_check_processor_compatibility(void)
 {
 	int cpu = smp_processor_id();
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -12175,6 +12183,11 @@ int kvm_arch_check_processor_compat(void)
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

