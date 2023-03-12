Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A196B6457
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCLJzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCLJyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D07937542
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614889; x=1710150889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QRp4FmOa6gsz7wIpyduk4OWQNm6k9Glt1u6m9eKXC6I=;
  b=F/uwVRJ/XC1Tx9s525DpkKl2Qde4uZyHENFNFKOSrEmp2ltJbPKkWx2n
   UbLw7emMnbUDyNOxWKut3OqW+Y56nhyzE1ch20KVzR/sNIjMWN6dJbxo1
   Q4r0lz9IyU03LQpcq91x6tOpsZoDGiYO5+Zakwd4+9UylnEy6iAqZ5+0X
   w8YolCSmjhtNNlulNmYJemW41yN7bwgt5Q20hpT4JX/2NRUn6VfNVpRyz
   KzQTjRtfIR43HRJbNfKsQWd63fcG2pFni0OEExAzr0WdmgIdCKI3/NZl0
   qxi4lEYnFwCQ6I8OM4zuJ9j6XtuS08rgxiJsvgtius04MbyrpZGG+jMwv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622916"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408998"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408998"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:28 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 08/17] pkvm: x86: Initailize vmcs guest state area for host vcpu
Date:   Mon, 13 Mar 2023 02:01:03 +0800
Message-Id: <20230312180112.1778254-9-jason.cj.chen@intel.com>
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

After deprivilege, host OS shall continue running with the state at that
point, therefore the CPU just deprivileges its context from VMX root
mode to non-root mode. The VMCS guest state of host vcpu is just current
state of physical CPU, so directly initialize the state from native.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/pkvm_host.c | 114 +++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 272205977e1e..5ed64ed2a801 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -136,7 +136,112 @@ static __init int pkvm_enable_vmx(struct pkvm_host_vcpu *vcpu)
 	return pkvm_cpu_vmxon(phys_addr);
 }
 
-static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu)
+static inline u32 get_ar(u16 sel)
+{
+	u32 access_rights;
+
+	if (sel == 0) {
+		access_rights = 0x10000;
+	} else {
+		asm ("lar %%ax, %%rax\n"
+				: "=a"(access_rights) : "a"(sel));
+		access_rights = access_rights >> 8;
+		access_rights = access_rights & 0xf0ff;
+	}
+
+	return access_rights;
+}
+
+#define init_guestsegment(seg, SEG, base, limit)		\
+	do  {							\
+		u16 sel;					\
+		u32 ar;						\
+								\
+		savesegment(seg, sel);				\
+		ar = get_ar(sel);				\
+		vmcs_write16(GUEST_##SEG##_SELECTOR, sel);	\
+		vmcs_write32(GUEST_##SEG##_AR_BYTES, ar);	\
+		vmcs_writel(GUEST_##SEG##_BASE, base);		\
+		vmcs_write32(GUEST_##SEG##_LIMIT, limit);	\
+	} while (0)
+
+static __init void init_guest_state_area_from_native(int cpu)
+{
+	u16 ldtr;
+	struct desc_ptr dt;
+	unsigned long msrl;
+	u32 high, low;
+
+	/* load CR regiesters */
+	vmcs_writel(GUEST_CR0, read_cr0() & ~X86_CR0_TS);
+	vmcs_writel(GUEST_CR3, __read_cr3());
+	vmcs_writel(GUEST_CR4, native_read_cr4());
+
+	/* load cs/ss/ds/es */
+	init_guestsegment(cs, CS, 0x0, 0xffffffff);
+	init_guestsegment(ss, SS, 0x0, 0xffffffff);
+	init_guestsegment(ds, DS, 0x0, 0xffffffff);
+	init_guestsegment(es, ES, 0x0, 0xffffffff);
+
+	/* load fs/gs */
+	rdmsrl(MSR_FS_BASE, msrl);
+	init_guestsegment(fs, FS, msrl, 0xffffffff);
+	rdmsrl(MSR_GS_BASE, msrl);
+	init_guestsegment(gs, GS, msrl, 0xffffffff);
+
+	/* load GDTR */
+	native_store_gdt(&dt);
+	vmcs_writel(GUEST_GDTR_BASE, dt.address);
+	vmcs_write32(GUEST_GDTR_LIMIT, dt.size);
+
+	/* load TR */
+	vmcs_write16(GUEST_TR_SELECTOR, GDT_ENTRY_TSS*8);
+	vmcs_write32(GUEST_TR_AR_BYTES, get_ar(GDT_ENTRY_TSS*8));
+	vmcs_writel(GUEST_TR_BASE, (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
+	vmcs_write32(GUEST_TR_LIMIT, __KERNEL_TSS_LIMIT);
+
+	/* load LDTR */
+	store_ldt(ldtr);
+	vmcs_write16(GUEST_LDTR_SELECTOR, ldtr);
+	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x10000);
+	vmcs_writel(GUEST_LDTR_BASE, 0x0);
+	vmcs_write32(GUEST_LDTR_LIMIT, 0xffffffff);
+
+	store_idt(&dt);
+	vmcs_writel(GUEST_IDTR_BASE, dt.address);
+	vmcs_write32(GUEST_IDTR_LIMIT, dt.size);
+
+	/* set MSRs */
+	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	rdmsr(MSR_IA32_SYSENTER_CS, low, high);
+	vmcs_write32(GUEST_SYSENTER_CS, low);
+
+	rdmsrl(MSR_IA32_SYSENTER_ESP, msrl);
+	vmcs_writel(GUEST_SYSENTER_ESP, msrl);
+
+	rdmsrl(MSR_IA32_SYSENTER_EIP, msrl);
+	vmcs_writel(GUEST_SYSENTER_EIP, msrl);
+
+	rdmsrl(MSR_EFER, msrl);
+	vmcs_write64(GUEST_IA32_EFER, msrl);
+
+	rdmsrl(MSR_IA32_CR_PAT, msrl);
+	vmcs_write64(GUEST_IA32_PAT, msrl);
+}
+
+static __init void init_guest_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
+{
+	init_guest_state_area_from_native(cpu);
+
+	/*Guest non register state*/
+	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
+	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
+	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
+	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+}
+
+static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = &vcpu->vmx;
 	int ret;
@@ -156,6 +261,11 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu)
 		return -ENOMEM;
 	}
 
+	vmx->loaded_vmcs = &vmx->vmcs01;
+	vmcs_load(vmx->loaded_vmcs->vmcs);
+
+	init_guest_state_area(vcpu, cpu);
+
 	return ret;
 }
 
@@ -339,7 +449,7 @@ static __init void pkvm_host_deprivilege_cpu(void *data)
 
 	enable_feature_control();
 
-	ret = pkvm_host_init_vmx(vcpu);
+	ret = pkvm_host_init_vmx(vcpu, cpu);
 	if (ret) {
 		pr_err("%s: init vmx failed\n", __func__);
 		goto out;
-- 
2.25.1

