Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03A5B2A59
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiIHX21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiIHX12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:27:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8793EE7FBF;
        Thu,  8 Sep 2022 16:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679593; x=1694215593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDmooBBcQHAZpR/dmiB8srIZ93JcteMYX0hXY6qhrTQ=;
  b=AH3WNSbLpImV4jEyIAAvTiRYGQAvNMb4MWZSUvJD2oq2WyUxdg2Lr01o
   IuQPfw4SfADy2WUrCo4rnW/HphNLm38aRXNVyRy0p3PJ5Ai7OwYHTkNnX
   jlPPDAZZP9zK1xXUaBcV894DhODvwRdqPiibTEqsfOokJelVCTaeW7y7M
   kh9v+W3sGtI9yH9vj/GanzeG79ECwa/9mTBhSek416J6Pfmx0oqh5IU7I
   ngzi13zCmjakmoOqO3JV2zujjsAL0WIfEVJv5prTje0Dn0XQPBeu0OvJp
   SbBSv2YTuWDvmkG14/xNpSptxGopaJbhTXjUPS9Q7uvVWHeUWS7IJE28J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687050"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687050"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863285"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:16 -0700
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
Subject: [PATCH v4 24/26] KVM: Eliminate kvm_arch_check_processor_compat()
Date:   Thu,  8 Sep 2022 16:25:40 -0700
Message-Id: <4d73ea052cfed118d1766cf039c2f1d27c6c7833.1662679124.git.isaku.yamahata@intel.com>
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

Now all arch has "return 0" implementation.  Eliminate it.  If feature
compatibility check is needed, it should be done in
kvm_arch_hardware_setup(), kvm_arch_online_cpu(), and kvm_arch_resume().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/arm64/kvm/arm.c       |  5 -----
 arch/mips/kvm/mips.c       |  5 -----
 arch/powerpc/kvm/powerpc.c |  5 -----
 arch/riscv/kvm/main.c      |  5 -----
 arch/s390/kvm/kvm-s390.c   |  5 -----
 arch/x86/kvm/x86.c         | 10 ----------
 include/linux/kvm_host.h   |  2 --
 virt/kvm/kvm_arch.c        | 29 -----------------------------
 virt/kvm/kvm_main.c        |  4 ----
 9 files changed, 70 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7e83498b83aa..de0397bd7b18 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -68,11 +68,6 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 092d09fb6a7e..f4feae89075c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -140,11 +140,6 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 extern void kvm_init_loongson_ipi(struct kvm *kvm);
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7e3a6659f107..d840f6d498eb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -456,11 +456,6 @@ int kvm_arch_hardware_setup(void *opaque)
 	return kvmppc_core_check_processor_compat();
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	struct kvmppc_ops *kvm_ops = NULL;
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index f8d6372d208f..ebabcb3dfb8c 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -20,11 +20,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -EINVAL;
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e26d4dd85668..9c5d3e4b464f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -254,11 +254,6 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 /* forward declarations */
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9dd90f0521c3..84cc459575e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11913,11 +11913,6 @@ int kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat_all(void)
-{
-	return 0;
-}
-
 int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
@@ -12183,11 +12178,6 @@ static int kvm_check_processor_compatibility(void)
 	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
-int kvm_arch_check_processor_compat(void)
-{
-	return 0;
-}
-
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5f4d6f641b03..2cd835c8bc1b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1444,8 +1444,6 @@ void kvm_arch_hardware_disable(void);
 
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
-int kvm_arch_check_processor_compat_all(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 9bf7b3920c44..68fb679d71f2 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -88,32 +88,10 @@ __weak int kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
-static void check_processor_compat(void *rtn)
-{
-	*(int *)rtn = kvm_arch_check_processor_compat();
-}
-
-__weak int kvm_arch_check_processor_compat_all(void)
-{
-	int cpu;
-	int r;
-
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			return r;
-	}
-	return 0;
-}
-
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
-	if (ret)
-		return ret;
-
 	if (!usage_count)
 		return 0;
 
@@ -167,13 +145,6 @@ __weak int kvm_arch_suspend(int usage_count)
 
 __weak void kvm_arch_resume(int usage_count)
 {
-	if (kvm_arch_check_processor_compat())
-		/*
-		 * No warning here because kvm_arch_check_processor_compat()
-		 * would have warned with more information.
-		 */
-		return; /* FIXME: disable KVM */
-
 	if (usage_count) {
 		preempt_disable();
 		(void)__hardware_enable((void *)__func__);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 51315d454dc2..3f82162c8441 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5777,10 +5777,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	r = kvm_arch_check_processor_compat_all();
-	if (r < 0)
-		goto out_free_2;
-
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
-- 
2.25.1

