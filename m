Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE65C6B6455
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCLJy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCLJyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F6F38035
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614887; x=1710150887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vxdvgjDG5stqnpD7Op/BnaEIaRHvkRShqGPs4j24feE=;
  b=ZIvwCN17WeQiZ3h5LiBciZoG1DZAr2k1UkAk7gDQSQch/Y30M2NwWZNr
   NMlONpuQbevePzoLh5fDRY65WSio+0rDj2eka4muLBmwS5+rGkFsQW0WI
   U3zOQDAIv0JCOpM0I71WHPmqTbwHciwc88th1bmy98tcUL/eJysA4HQsx
   Gq7uIBj35lXMPapvu55u1j32SA+okpSqgsNH2tJ+nXs7HEqOrnwm/cUR7
   /a551FN1JDkLeoRyF1E8sQbDRd5QCdmjkKOed9ebv0/CU/1ykh5wy5GLW
   OtNk6RyqLvdiAa+FSOQTAD6jFTeTWW59JVvOYyfW3muWuMOKo3FB+wI4Z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622906"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622906"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408986"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408986"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:25 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 06/17] pkvm: x86: Introduce pkvm_host_deprivilege_cpus
Date:   Mon, 13 Mar 2023 02:01:01 +0800
Message-Id: <20230312180112.1778254-7-jason.cj.chen@intel.com>
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

After platform power on, the host Linux is running at VMX root mode at
beginning, and finally it needs putting into VMX non-root mode while pKVM
shall keep running at VMX root mode, to ensure pKVM's capability of
isolating the protected guests from host OS. The process of putting host
OS from VMX root mode to non-root mode is called deprivilege.

The deprivilege is triggered by pKVM's initializing code through new
introduced function - pkvm_host_deprivilege_cpus(). In this function,
VMX operation environment is setup for each CPU, which includes entering
VMX operation by executing VMXON instruction, initializing VMCS fields
for guest state, host state & vmexit/vmentry controls, setting up vmexit
handlers and finally launch & run host OS as a VM through VMX instructions
VMLAUNCH/VMRESUME (VMXON is done in this patch, others will be added in
the following patches).

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |   1 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 163 +++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 73d2c235557a..486e631f4254 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -25,6 +25,7 @@ struct pkvm_pcpu {
 struct pkvm_host_vcpu {
 	struct vcpu_vmx vmx;
 	struct pkvm_pcpu *pcpu;
+	struct vmcs *vmxarea;
 };
 
 struct pkvm_host_vm {
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index c437cb965771..6b937192e901 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -13,6 +13,14 @@ MODULE_LICENSE("GPL");
 
 static struct pkvm_hyp *pkvm;
 
+struct pkvm_deprivilege_param {
+	struct pkvm_hyp *pkvm;
+	int ret;
+};
+
+#define is_aligned(POINTER, BYTE_COUNT) \
+		(((uintptr_t)(const void *)(POINTER)) % (BYTE_COUNT) == 0)
+
 /* only need GDT entries for KERNEL_CS & KERNEL_DS as pKVM only use these two */
 static struct gdt_page pkvm_gdt_page = {
 	.gdt = {
@@ -31,6 +39,91 @@ static void pkvm_early_free(void *ptr, int pages)
 	free_pages_exact(ptr, pages << PAGE_SHIFT);
 }
 
+static inline void vmxon_setup_revid(void *vmxon_region)
+{
+	u32 rev_id = 0;
+	u32 msr_high_value = 0;
+
+	rdmsr(MSR_IA32_VMX_BASIC, rev_id, msr_high_value);
+
+	memcpy(vmxon_region, &rev_id, 4);
+}
+
+static inline void cr4_set_vmxe(void)
+{
+	unsigned long cr4_value;
+
+	cr4_value = __read_cr4();
+	__write_cr4(cr4_value | X86_CR4_VMXE);
+}
+
+static inline void cr4_clear_vmxe(void)
+{
+	unsigned long cr4_value;
+
+	cr4_value = __read_cr4();
+	__write_cr4(cr4_value & ~(X86_CR4_VMXE));
+}
+
+static __init int pkvm_cpu_vmxon(u64 vmxon_pointer)
+{
+	u64 msr;
+
+	cr4_set_vmxe();
+	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	cr4_clear_vmxe();
+	return -EFAULT;
+}
+
+static __init int pkvm_cpu_vmxoff(void)
+{
+	asm_volatile_goto("1: vmxoff\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  ::: "cc", "memory" : fault);
+	cr4_clear_vmxe();
+	return 0;
+
+fault:
+	cr4_clear_vmxe();
+	return -EFAULT;
+}
+
+static __init int pkvm_enable_vmx(struct pkvm_host_vcpu *vcpu)
+{
+	u64 phys_addr;
+
+	vcpu->vmxarea = pkvm_early_alloc_contig(1);
+	if (!vcpu->vmxarea)
+		return -ENOMEM;
+
+	phys_addr = __pa(vcpu->vmxarea);
+	if (!is_aligned(phys_addr, PAGE_SIZE))
+		return -ENOMEM;
+
+	/*setup revision id in vmxon region*/
+	vmxon_setup_revid(vcpu->vmxarea);
+
+	return pkvm_cpu_vmxon(phys_addr);
+}
+
+static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu)
+{
+	return pkvm_enable_vmx(vcpu);
+}
+
+static __init void pkvm_host_deinit_vmx(struct pkvm_host_vcpu *vcpu)
+{
+	pkvm_cpu_vmxoff();
+}
+
 static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 {
 	struct vmcs_config *vmcs_config = &pkvm->vmcs_config;
@@ -170,6 +263,76 @@ static __init int pkvm_host_setup_vcpu(struct pkvm_hyp *pkvm, int cpu)
 	return 0;
 }
 
+static inline void enable_feature_control(void)
+{
+	u64 old, test_bits;
+
+	rdmsrl(MSR_IA32_FEAT_CTL, old);
+	test_bits = FEAT_CTL_LOCKED;
+	test_bits |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
+
+	if ((old & test_bits) != test_bits)
+		wrmsrl(MSR_IA32_FEAT_CTL, old | test_bits);
+}
+
+static __init void pkvm_host_deprivilege_cpu(void *data)
+{
+	struct pkvm_deprivilege_param *p = data;
+	unsigned long flags;
+	int cpu = get_cpu(), ret;
+	struct pkvm_host_vcpu *vcpu =
+		p->pkvm->host_vm.host_vcpus[cpu];
+
+	local_irq_save(flags);
+
+	enable_feature_control();
+
+	ret = pkvm_host_init_vmx(vcpu);
+	if (ret) {
+		pr_err("%s: init vmx failed\n", __func__);
+		goto out;
+	}
+
+	/* TODO:KICK to RUN vcpu. let's directly go with out(return failure) now */
+
+out:
+	p->ret = -ENOTSUPP;
+	pkvm_host_deinit_vmx(vcpu);
+	pr_err("%s: failed to deprivilege CPU%d\n", __func__, cpu);
+
+	local_irq_restore(flags);
+
+	put_cpu();
+}
+
+/*
+ * Used in root mode to deprivilege CPUs
+ */
+static __init int pkvm_host_deprivilege_cpus(struct pkvm_hyp *pkvm)
+{
+	struct pkvm_deprivilege_param p = {
+		.pkvm = pkvm,
+		.ret = 0,
+	};
+
+	on_each_cpu(pkvm_host_deprivilege_cpu, &p, 1);
+	if (p.ret) {
+		/*
+		 * TODO:
+		 * We are here because some CPUs failed to be deprivileged, so
+		 * the failed CPU will stay in root mode. But the others already
+		 * in the non-root mode. In this case, we should let non-root mode
+		 * CPUs go back to root mode, then the system can still run natively
+		 * without pKVM enabled.
+		 */
+		pr_err("%s: WARNING - failed to deprivilege all CPUs!\n", __func__);
+	} else {
+		pr_info("%s: all cpus are in guest mode!\n", __func__);
+	}
+
+	return p.ret;
+}
+
 __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
-- 
2.25.1

