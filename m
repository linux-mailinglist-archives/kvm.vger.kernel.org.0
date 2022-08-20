Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFE59AB97
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245470AbiHTGBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbiHTGAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A99A2237;
        Fri, 19 Aug 2022 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975251; x=1692511251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3nRzOljyClKkdxyoueQO+Gp/x0PfqUJfsGG+3EL3avA=;
  b=lRSMnJKxvlX4T+hOnzkrowS04Z4BqqICbY+0YJnti1n/uJV134cH8eW2
   aBQ/jXzsjum0i3HlW3YQG+Cck3FGu5qXTgIwQAoyhpn2SpYNGu9BsH0Rs
   EG7L8/UDbMKtHivFESYlP+EDA1Q3mRqw5dZGW9lTPS344B23FjWo6Jt46
   bFgx1QloSfIUCZqi2ckJczH6hYkOFA6kxdQrb+9NYRK2Jvxxr0Y7kgUaD
   2hrazAEBTtk0KDHaMJluVGCFOUKfD3Bpn7qBvmupQ5HT5Lq/KWFWKCsv7
   583dgcpIupjYIyvFP1XcR5sWYzBaUROVGDPr/L326jX3Ajtg/whlsmVpw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448978"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448978"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857544"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [RFC PATCH 11/18] Partially revert "KVM: Pass kvm_init()'s opaque param to additional arch funcs"
Date:   Fri, 19 Aug 2022 23:00:17 -0700
Message-Id: <ce000ec9f648e6c8c86a7a1f1f42f08566920ceb.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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

From: Chao Gao <chao.gao@intel.com>

This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
param to additional arch funcs") remove opaque from
kvm_arch_check_processor_compat because no one uses this opaque now.
Address conflicts for ARM (due to file movement) and manually handle RISC-V
which comes after the commit.  The change about kvm_arch_hardware_setup()
in original commit are still needed so they are not reverted.

The current implementation enables hardware (e.g. enable VMX on all CPUs),
arch-specific initialization for VM creation, and disables hardware (in
x86, disable VMX on all CPUs) for last VM destruction.

TDX requires its initialization on loading KVM module with VMX enabled on
all available CPUs. It needs to enable/disable hardware on module
initialization.  To reuse the same logic, one way is to pass around the
unused opaque argument, another way is to remove the unused opaque
argument.  This patch is a preparation for the latter by removing the
argument.

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
index 986cee6fbc7f..e66dacfe7f74 100644
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
index fb1490761c87..7b56d6ccfdfb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -447,7 +447,7 @@ int kvm_arch_hardware_setup(void *opaque)
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
index edfd4bbd0cba..e26d4dd85668 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -254,7 +254,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 890985c284be..0b112cd7de58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11999,7 +11999,7 @@ void kvm_arch_hardware_unsetup(void)
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-int kvm_arch_check_processor_compat(void *opaque)
+int kvm_arch_check_processor_compat(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fdde9c59756d..9584500eb4fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1439,7 +1439,7 @@ void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void *opaque);
+int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b8e8addd1e5..9d917e3e47a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5741,22 +5741,14 @@ void kvm_unregister_perf_callbacks(void)
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
 
@@ -5779,10 +5771,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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

