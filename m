Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A805D6B64AC
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCLKBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCLKAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F18E28EAF
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615192; x=1710151192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q8QVjWWt854rblm3zWPTeHz5o8Bkc/A/EBwkze1NAhU=;
  b=U9E/Zj8V0pjLlkC8Dy/0WErSLXBr1CYr7djoEY28t6KNHQZiOXSvFk9B
   qCHlzn6yIsyyr1WS01+20up3JM3F+Wi4G/jguH+K8wHa/N905Aj/K0ZUb
   pcGbL2BoeB/7R0XfV4MZ0Jg+RK+TJVL1j+J+p5aPVq0ovxk+TcxzyTtLO
   VoYI2SC+ROF8aPvj6+ewogz2O8vhctA4oWTvIx8clPDV7UCQ2rf40brZ9
   frYIvp4S2Z127e/KaGcilbqeW3ETIeOC0+3h6Lk+4inCYeEMmLA2QwWVn
   A9fjLiWlO5/855488yIqJfy8WtOp6gCJUWHYfixdnkixH6jImZKRR1Wne
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344758"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344758"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627540"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627540"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:29 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-7 08/12] pkvm: x86: Donate shadow vm & vcpu pages to hypervisor
Date:   Mon, 13 Mar 2023 02:04:11 +0800
Message-Id: <20230312180415.1778669-9-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

The shadow vm/vcpu pages are allocated in KVM-high, and then be managed by
pKVM hypervisor, so such page's ownership shall be moved from host VM to
pKVM hypervisor by __pkvm_host_donate_hyp.

Above is done when doing shadow vm/vcpu initialization, while in shadow
vm/vcpu teardown, those pages shall return to host VM, by
__pkvm_hyp_donate_host.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c     | 50 ++++++++++++++++++++++++----
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |  6 ++++
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index 63004ed6e90e..8a7305e9a68b 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -96,6 +96,7 @@ int __pkvm_init_shadow_vm(unsigned long kvm_va,
 			  size_t shadow_size)
 {
 	struct pkvm_shadow_vm *vm;
+	int shadow_vm_handle;
 
 	if (!PAGE_ALIGNED(shadow_pa) ||
 		!PAGE_ALIGNED(shadow_size) ||
@@ -103,29 +104,48 @@ int __pkvm_init_shadow_vm(unsigned long kvm_va,
 					   + pkvm_shadow_vcpu_array_size())))
 		return -EINVAL;
 
+	if (__pkvm_host_donate_hyp(shadow_pa, shadow_size))
+		return -EINVAL;
+
 	vm = pkvm_phys_to_virt(shadow_pa);
 
 	memset(vm, 0, shadow_size);
 	pkvm_spin_lock_init(&vm->lock);
 
 	vm->host_kvm_va = kvm_va;
+	vm->shadow_size = shadow_size;
 
 	if (pkvm_shadow_ept_init(&vm->sept_desc))
-		return -EINVAL;
+		goto undonate;
+
+	shadow_vm_handle = allocate_shadow_vm_handle(vm);
+	if (shadow_vm_handle < 0)
+		goto deinit_shadow_ept;
+
+	return shadow_vm_handle;
 
-	return allocate_shadow_vm_handle(vm);
+deinit_shadow_ept:
+	pkvm_shadow_ept_deinit(&vm->sept_desc);
+undonate:
+	memset(vm, 0, shadow_size);
+	__pkvm_hyp_donate_host(shadow_pa, shadow_size);
+	return -EINVAL;
 }
 
 unsigned long __pkvm_teardown_shadow_vm(int shadow_vm_handle)
 {
 	struct pkvm_shadow_vm *vm = free_shadow_vm_handle(shadow_vm_handle);
+	unsigned long shadow_size;
 
 	if (!vm)
 		return 0;
 
 	pkvm_shadow_ept_deinit(&vm->sept_desc);
 
-	memset(vm, 0, sizeof(struct pkvm_shadow_vm) + pkvm_shadow_vcpu_array_size());
+	shadow_size = vm->shadow_size;
+	memset(vm, 0, shadow_size);
+
+	WARN_ON(__pkvm_hyp_donate_host(pkvm_virt_to_phys(vm), shadow_size));
 
 	return pkvm_virt_to_phys(vm);
 }
@@ -321,32 +341,44 @@ s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
 		(pkvm_hyp->vmcs_config.size > PAGE_SIZE))
 		return -EINVAL;
 
+	if (__pkvm_host_donate_hyp(shadow_pa, shadow_size))
+		return -EINVAL;
+
 	shadow_vcpu = pkvm_phys_to_virt(shadow_pa);
 	memset(shadow_vcpu, 0, shadow_size);
+	shadow_vcpu->shadow_size = shadow_size;
 
 	ret = read_gva(hvcpu, vcpu_va, &shadow_vcpu->vmx, sizeof(struct vcpu_vmx), &e);
 	if (ret < 0)
-		return -EINVAL;
+		goto undonate;
 
 	vmcs12_va = (unsigned long)shadow_vcpu->vmx.vmcs01.vmcs;
 	if (gva2gpa(hvcpu, vmcs12_va, (gpa_t *)&shadow_vcpu->vmcs12_pa, 0, &e))
-		return -EINVAL;
+		goto undonate;
 
 	vm = get_shadow_vm(shadow_vm_handle);
 	if (!vm)
-		return -EINVAL;
+		goto undonate;
 
 	shadow_vcpu_handle = attach_shadow_vcpu_to_vm(vm, shadow_vcpu);
 
 	put_shadow_vm(shadow_vm_handle);
 
+	if (shadow_vcpu_handle < 0)
+		goto undonate;
+
 	return shadow_vcpu_handle;
+undonate:
+	memset(shadow_vcpu, 0, shadow_size);
+	__pkvm_hyp_donate_host(shadow_pa, shadow_size);
+	return -EINVAL;
 }
 
 unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle)
 {
 	int shadow_vm_handle = to_shadow_vm_handle(shadow_vcpu_handle);
 	struct shadow_vcpu_state *shadow_vcpu;
+	unsigned long shadow_size;
 	struct pkvm_shadow_vm *vm = get_shadow_vm(shadow_vm_handle);
 
 	if (!vm)
@@ -359,7 +391,11 @@ unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle)
 	if (!shadow_vcpu)
 		return 0;
 
-	memset(shadow_vcpu, 0, sizeof(struct shadow_vcpu_state));
+	shadow_size = shadow_vcpu->shadow_size;
+	memset(shadow_vcpu, 0, shadow_size);
+	WARN_ON(__pkvm_hyp_donate_host(pkvm_virt_to_phys(shadow_vcpu),
+				       shadow_size));
+
 	return pkvm_virt_to_phys(shadow_vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index bf5719eefa0e..0a57c19ce4a5 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -38,6 +38,9 @@ struct shadow_vcpu_state {
 
 	struct pkvm_shadow_vm *vm;
 
+	/* The donated size of shadow_vcpu. */
+	unsigned long shadow_size;
+
 	struct hlist_node hnode;
 	unsigned long vmcs12_pa;
 	bool vmcs02_inited;
@@ -93,6 +96,9 @@ struct pkvm_shadow_vm {
 	/* The host's kvm va. */
 	unsigned long host_kvm_va;
 
+	/* The donated size of shadow_vm. */
+	unsigned long shadow_size;
+
 	/*
 	 * VM's shadow EPT. All vCPU shares one mapping.
 	 * FIXME: a potential security issue if some vCPUs are
-- 
2.25.1

