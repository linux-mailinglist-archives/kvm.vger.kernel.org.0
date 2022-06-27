Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5894F55DE45
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbiF0Vy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240942AbiF0Vyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86FE6263;
        Mon, 27 Jun 2022 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366889; x=1687902889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pJ9tvLsAfdeU/ZCRyVdBo/dzzhl6SC3Ni3vJMWSlgKQ=;
  b=DvkxLxFkbnhAdt9tnz/VplsU33nnKOy+Q2g+r4S65dsbC/GJp1px5Kdw
   b/Key3ypcew1lrkxob3PDGSguiurm63pkdUy4HxnmrsxNqzeOC4PohB2I
   9t1vb2hFK1NSTjSQ0TcYJN6IRUQeNoWDdH3d7+zeCW6/PNe4lE7yHGMO8
   cJnmL2CzKHwtkQaI5KQ078wxkGvX2xSjDPxUa/QW6Va5c0rDAn4gJ0WVL
   4WHdtrbc+iN3l0PH912k0NMO+/Q6Bj6fSb3Ew5QPBjqwNNxm/NH8RodyP
   sd2MedpkYLSlLBjV5vqwWExlS/6WQkq/jzrcRJPyPd1a01kNg2Spvj6vL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282662708"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282662708"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863433"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH v7 002/102] Partially revert "KVM: Pass kvm_init()'s opaque param to additional arch funcs"
Date:   Mon, 27 Jun 2022 14:52:54 -0700
Message-Id: <4566737e3c57c5ab17c0bc29d6f4758744b6eed1.1656366337.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
param to additional arch funcs") remove opaque from
kvm_arch_check_processor_compat because no one uses this opaque now.
Address conflicts for ARM (due to file movement) and manually handle RISC-V
which comes after the commit.

And changes about kvm_arch_hardware_setup() in original commit are still
needed so they are not reverted.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Anup Patel <anup@brainfault.org>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220216031528.92558-3-chao.gao@intel.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/arm64/kvm/arm.c       |  2 +-
 arch/mips/kvm/mips.c       |  2 +-
 arch/powerpc/kvm/powerpc.c |  2 +-
 arch/riscv/kvm/main.c      |  2 +-
 arch/s390/kvm/kvm-s390.c   |  2 +-
 arch/x86/kvm/x86.c         |  2 +-
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/kvm_main.c        | 16 +++-------------
 8 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0188144a122..7588efbac6be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -68,7 +68,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return 0;
 }
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..092d09fb6a7e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -140,7 +140,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return 0;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 191992fcb2c2..ca8ef51092c6 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -446,7 +446,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return kvmppc_core_check_processor_compat();
 }
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 1549205fe5fe..f8d6372d208f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -20,7 +20,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -EINVAL;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return 0;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 72bd5c9b9617..a05493f1cacf 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -251,7 +251,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d9dbaf9828f..30af2bd0b4d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11799,7 +11799,7 @@ void kvm_arch_hardware_unsetup(void)
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c20f2d55840c..d4f130a9f5c8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1442,7 +1442,7 @@ int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void *opaque);
+int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a67e996cbf7f..a5bada53f1fe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5697,22 +5697,14 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-struct kvm_cpu_compat_check {
-	void *opaque;
-	int *ret;
-};
-
-static void check_processor_compat(void *data)
+static void check_processor_compat(void *rtn)
 {
-	struct kvm_cpu_compat_check *c = data;
-
-	*c->ret = kvm_arch_check_processor_compat(c->opaque);
+	*(int *)rtn = kvm_arch_check_processor_compat();
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
-	struct kvm_cpu_compat_check c;
 	int r;
 	int cpu;
 
@@ -5740,10 +5732,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	c.ret = &r;
-	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &c, 1);
+		smp_call_function_single(cpu, check_processor_compat, &r, 1);
 		if (r < 0)
 			goto out_free_2;
 	}
-- 
2.25.1

