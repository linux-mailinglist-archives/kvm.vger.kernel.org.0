Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811106B645F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCLJzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCLJy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D6939BA7
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614893; x=1710150893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PlG6ejFDc2x6ZVdj69pypdWCfVNiUM9MJIjikMwLcUo=;
  b=cDyNa+xnF1evjG7E14ouUQ+yB2hjMvExYREgiBJtadGgVHmPNNq0JRI/
   SMwNdTj7ELxD2OeT0N36ZSv3brLvxr18iKlwxVcocMOOdEMpdpwj6hVG1
   TX6Gb4Ku8BcBG+KBcnAwvQ+mBbDL/Je5aCsA2aaEkpnS9L+K5tKOnxMUo
   2lLjasjFgAukoCKdtJ/EVBf8VBN0HL8jkDr58pXQfJ+3b1a9KAwQrddCL
   BqISZCLPSFD/+TZl/mtHYxS2Yp51gPjlfGAOkH486fX7Zyq0JNENpEtMt
   mI/Cb2F+z7AZqv4E9uOtFa66djLW6Y2pN0BzBDSnvCjDhwTqVQubxgzIW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622956"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622956"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409046"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409046"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:39 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 16/17] pkvm: x86: Deprivilege host OS
Date:   Mon, 13 Mar 2023 02:01:11 +0800
Message-Id: <20230312180112.1778254-17-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finally make CPUs running in host OS deprivieged to VMX non-root mode.

Add function pkvm_host_run_vcpu() to prepare host vcpu context and finally
run into pkvm_main by entering the loop of vmenter to host VM and vmexit
handling in pKVM.

Call pkvm_host_deprivilege_cpus() in pkvm_init to make the deprivilege
take effect.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  1 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 91 +++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 86a8f5870108..59ef09230700 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -49,5 +49,6 @@ struct pkvm_hyp {
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
 PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
+PKVM_DECLARE(int, pkvm_main(struct kvm_vcpu *vcpu));
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 8aaacc56734e..1fa273396b9b 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -538,6 +538,84 @@ static inline void enable_feature_control(void)
 		wrmsrl(MSR_IA32_FEAT_CTL, old | test_bits);
 }
 
+#define savegpr(gpr, value) 		\
+	asm("mov %%" #gpr ",%0":"=r" (value) : : "memory")
+
+static noinline int pkvm_host_run_vcpu(struct pkvm_host_vcpu *vcpu)
+{
+	u64 host_rsp;
+	unsigned long *regs = vcpu->vmx.vcpu.arch.regs;
+	volatile int ret = 0;
+
+	/*
+	 * prepare to RUN vcpu:
+	 *
+	 * - record gprs in vcpu.arch.regs[]:
+	 *
+	 * - record below guest vmcs fields:
+	 * 	GUSET_RFLAGS - read from native
+	 *
+	 * - record below guest vmcs fields:
+	 * 	GUSET_RFLAGS - read from native
+	 * 	GUEST_RIP - vmentry_point
+	 * 	GUEST_RSP - read from native
+	 *
+	 * - switch RSP to host_rsp
+	 * - push guest_rsp to host stack
+	 */
+	savegpr(rax, regs[__VCPU_REGS_RAX]);
+	savegpr(rcx, regs[__VCPU_REGS_RCX]);
+	savegpr(rdx, regs[__VCPU_REGS_RDX]);
+	savegpr(rbx, regs[__VCPU_REGS_RBX]);
+	savegpr(rbp, regs[__VCPU_REGS_RBP]);
+	savegpr(rsi, regs[__VCPU_REGS_RSI]);
+	savegpr(rdi, regs[__VCPU_REGS_RDI]);
+	savegpr(r8, regs[__VCPU_REGS_R8]);
+	savegpr(r9, regs[__VCPU_REGS_R9]);
+	savegpr(r10, regs[__VCPU_REGS_R10]);
+	savegpr(r11, regs[__VCPU_REGS_R11]);
+	savegpr(r12, regs[__VCPU_REGS_R12]);
+	savegpr(r13, regs[__VCPU_REGS_R13]);
+	savegpr(r14, regs[__VCPU_REGS_R14]);
+	savegpr(r15, regs[__VCPU_REGS_R15]);
+	host_rsp = (u64)vcpu->pcpu->stack + STACK_SIZE;
+	asm volatile(
+		"pushfq\n"
+		"popq %%rax\n"
+		"movq %0, %%rdx\n"
+		"vmwrite %%rax, %%rdx\n"
+		"movq $vmentry_point, %%rax\n"
+		"movq %1, %%rdx\n"
+		"vmwrite %%rax, %%rdx\n"
+		"movq %%rsp, %%rax\n"
+		"movq %2, %%rdx\n"
+		"vmwrite %%rax, %%rdx\n"
+		"movq %3, %%rsp\n"
+		"pushq %%rax\n"
+		:
+		: "i"(GUEST_RFLAGS), "i"(GUEST_RIP), "i"(GUEST_RSP), "m"(host_rsp)
+		: "rax", "rdx", "memory");
+
+	/*
+	 * call pkvm_main to do vmlaunch.
+	 *
+	 * if pkvm_main return - vmlaunch fail:
+	 *     pop back guest_rsp, ret = -EINVAL
+	 * if pkvm_main not return - vmlaunch success:
+	 *     guest ret to vmentry_point, ret = 0
+	 */
+	pkvm_sym(pkvm_main)(&vcpu->vmx.vcpu);
+	asm volatile(
+			"popq %%rdx\n"
+			"movq %%rdx, %%rsp\n"
+			"movq %1, %%rdx\n"
+			"movq %%rdx, %0\n"
+			"vmentry_point:\n"
+			: "=m"(ret) : "i"(-EINVAL) : "rdx", "memory");
+
+	return ret;
+}
+
 static __init void pkvm_host_deprivilege_cpu(void *data)
 {
 	struct pkvm_deprivilege_param *p = data;
@@ -556,13 +634,18 @@ static __init void pkvm_host_deprivilege_cpu(void *data)
 		goto out;
 	}
 
-	/* TODO:KICK to RUN vcpu. let's directly go with out(return failure) now */
+	ret = pkvm_host_run_vcpu(vcpu);
+	if (ret == 0) {
+		pr_info("%s: CPU%d in guest mode\n", __func__, cpu);
+		goto ok;
+	}
 
 out:
-	p->ret = -ENOTSUPP;
+	p->ret = ret;
 	pkvm_host_deinit_vmx(vcpu);
 	pr_err("%s: failed to deprivilege CPU%d\n", __func__, cpu);
 
+ok:
 	local_irq_restore(flags);
 
 	put_cpu();
@@ -619,6 +702,10 @@ __init int pkvm_init(void)
 			goto out_free_cpu;
 	}
 
+	ret = pkvm_host_deprivilege_cpus(pkvm);
+	if (ret)
+		goto out_free_cpu;
+
 	pkvm->num_cpus = num_possible_cpus();
 
 	return 0;
-- 
2.25.1

