Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B796B6458
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCLJzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjCLJyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E9F37F0C
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614889; x=1710150889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SexQxjZxRUvNgue4VL+mv5epGuLJd+jSoIWs690STV4=;
  b=guVfqw0vaYI1/Dn6wFawgPvCfgUVORhBpQtjlIaf94uxNFz0JstKMr8V
   hvasl2HB7OL5pdYbLj3BtFVge8IHgrt/IPagOploKI5QANHef9mH4MOq8
   ybcN6Fr3WQ6CxaOWbrcfKFWAEP5I2jXvPSJJMxXfXkOfiMnOuWCSpgNwI
   htpYhwNWiaxtyXh6TgfJsPH8soprPVqEar3NseyphTTSv0JIQ0BlXUw3q
   ASvGl99+d8BjyCN4XxHEEvOTpioehzl/KQPEgDCk5h5FKXPHPMg8/+V0D
   gPpOFquwA3gShPFygd+hYv8xwTNoF8opEv9oGwdvgNVmc0gSRhi0y2MKr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622921"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622921"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409004"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409004"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:29 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 09/17] pkvm: x86: Initialize vmcs host state area for host vcpu
Date:   Mon, 13 Mar 2023 02:01:04 +0800
Message-Id: <20230312180112.1778254-10-jason.cj.chen@intel.com>
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

The VMCS host state shall keep the pKVM running state before switch
to guest (host VM for now). Most of such states are setup by pKVM init
code and can get from predefined value (e.g. CS/SS etc.) or pkvm_pcpu data
structure (e.g. GDT/IDT/TSS & cr3), a few states are initialized directly
from host native as they can just follow host Linux setting (e.g. EFER,
PAT, CR0).

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/pkvm_host.c | 40 +++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 5ed64ed2a801..9634bbccfbdd 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -241,6 +241,45 @@ static __init void init_guest_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 }
 
+static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
+{
+	unsigned long a;
+
+	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);
+	vmcs_writel(HOST_CR3, pcpu->cr3);
+	vmcs_writel(HOST_CR4, native_read_cr4());
+
+	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);
+	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);
+	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);
+	vmcs_write16(HOST_ES_SELECTOR, 0);
+	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
+	vmcs_write16(HOST_FS_SELECTOR, 0);
+	vmcs_write16(HOST_GS_SELECTOR, 0);
+	vmcs_writel(HOST_FS_BASE, 0);
+	vmcs_writel(HOST_GS_BASE, 0);
+
+	vmcs_writel(HOST_TR_BASE, (unsigned long)&pcpu->tss);
+	vmcs_writel(HOST_GDTR_BASE, (unsigned long)(&pcpu->gdt_page));
+	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
+
+	/* MSR area */
+	rdmsrl(MSR_EFER, a);
+	vmcs_write64(HOST_IA32_EFER, a);
+
+	rdmsrl(MSR_IA32_CR_PAT, a);
+	vmcs_write64(HOST_IA32_PAT, a);
+}
+
+static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu)
+{
+	struct pkvm_pcpu *pcpu = vcpu->pcpu;
+
+	_init_host_state_area(pcpu);
+
+	/*TODO: add HOST_RIP */
+}
+
 static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = &vcpu->vmx;
@@ -265,6 +304,7 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 
 	init_guest_state_area(vcpu, cpu);
+	init_host_state_area(vcpu);
 
 	return ret;
 }
-- 
2.25.1

