Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CB75E6AD1
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiIVSYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiIVSXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5C109603;
        Thu, 22 Sep 2022 11:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870951; x=1695406951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OXolcTNJkMpWfAxfM3a0npQERQkANrv/gXnofXUpGHE=;
  b=X6KZmNuFUEnCdpQfnH43Nz42/8rGnUkcaKfy6jc+9kBzFhZ9UJC+LqVU
   sbJI5OAEOLNEjcXmadhKki8hdr+asaicszMPP1dRTHl4a4K0PBmkOCzqo
   d9S+qLlWadHd72n5qYtMUp67xQm4TpBMplMXPMmYwqRxYoJblnvzCqu+e
   e3vQmEwKBV/Bi4ZLRvnS2D6JDc/7KUbwjMdsU0Sr4EVyhucb//M2U4M7p
   /txfMjMIHcUvDg2iowT2/veJGMf3sfQg35bBW+zApTABdXemkhM50uqu/
   oHYLQc1NicmrRElAW3CGyj9LWOrnZI35UjYhBe4usuX1c37kneGi9mMcV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712946"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712946"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086928"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:29 -0700
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
Subject: [PATCH v5 28/30] KVM: Eliminate kvm_arch_check_processor_compat()
Date:   Thu, 22 Sep 2022 11:20:57 -0700
Message-Id: <4f920489411a21e99dd0e20d011286f73254afa8.1663869838.git.isaku.yamahata@intel.com>
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
 virt/kvm/kvm_arch.c        | 22 ----------------------
 virt/kvm/kvm_main.c        |  4 ----
 9 files changed, 63 deletions(-)

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
index 31dc4f231e9d..546ebbe16bfe 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -447,11 +447,6 @@ int kvm_arch_hardware_setup(void *opaque)
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
index 00cc74276819..1f791c93391b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12035,11 +12035,6 @@ int kvm_arch_del_vm(int usage_count)
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
@@ -12203,11 +12198,6 @@ static int kvm_check_processor_compatibility(void)
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
index 7efc4792ff5f..87d4f42f3ff9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1447,8 +1447,6 @@ void kvm_arch_hardware_disable(void);
 
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
-int kvm_arch_check_processor_compat_all(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 2509c2777a49..076a55d59988 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -82,32 +82,10 @@ int __weak kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
-static void check_processor_compat(void *rtn)
-{
-	*(int *)rtn = kvm_arch_check_processor_compat();
-}
-
-int __weak kvm_arch_check_processor_compat_all(void)
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
 int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
-	if (ret)
-		return ret;
-
 	if (!usage_count)
 		return 0;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d5f882fb9e0c..1c1a2b0630bc 100644
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

