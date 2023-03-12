Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC176B6454
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjCLJyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLJyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213C837540
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614886; x=1710150886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pum5ht4wFQz5gpFrCHLc9S3C2HDayp8IWg8ja4c9HZM=;
  b=J/L3IUqYvdnx8Z1+8B46P1My6NlAD5Yi9UvPX99CePxipX//yAeYxAVA
   kl5HDVL0BrpQ7dwOaAUSQgocd1CUgx0bPPJ5JdOohhywqRUb6gEGZhzOV
   aOEXR/9xwGJ1Zu4D+YLcW9xTwR+gwNdwF5EpD1dY2qJzPMQnRvZlIeKKh
   hTUiJ3xVQWN6IjoIKpb+OuOWxRG9bAHuRD8QU5rDURFAqTHI4uehN842d
   XqOvX6A4h4L7Fz6N9mBktV4obq8Wi5hWvCspWTp+cS1n6uMMdzJsRyDsO
   8/F6K3FoFzRHLO/0HibjBKXFcbQ5Hqi1+tDV3EpXbvxjBEzYCBZ//5vZt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622897"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622897"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408961"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408961"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:22 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 04/17] pkvm: x86: Add pCPU env setup
Date:   Mon, 13 Mar 2023 02:00:59 +0800
Message-Id: <20230312180112.1778254-5-jason.cj.chen@intel.com>
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

Introduce pkvm_pcpu data structure, and pKVM can support up to
CONFIG_NR_CPUS pCPUs.

The pkvm_pcpu contains necessary environment fields to run a physical
CPU, like stack, GDT/IDT/TSS and cr3. As pKVM is isolated from host OS,
it needs its own running environment for each physical CPU.

Initialize dedicated GDT/IDT/TSS for pKVM pCPU. The GDT/TSS setting is
referred from host Linux, while the IDT is configured to jump to
noop_handler for all exceptions as no exception support in pKVM (NMI
is another story which will be added in the future).

At this moment, the pKVM still shares MMU page table with host Linux,
so setup its CR3 from host setting. In the future, pKVM shall create
its own MMU page table.

The pkvm_pcpu data entry is allocated according to current cpu number
system running, during the new added pcpu setup logic within pkvm_init.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/include/pkvm.h | 17 ++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 91 +++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index cda599194588..3adcebd31ca6 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -8,13 +8,30 @@
 
 #include <vmx/vmx.h>
 
+#define STACK_SIZE SZ_16K
+
+struct idt_page {
+	gate_desc idt[IDT_ENTRIES];
+} __aligned(PAGE_SIZE);
+
+struct pkvm_pcpu {
+	u8 stack[STACK_SIZE] __aligned(16);
+	unsigned long cr3;
+	struct gdt_page gdt_page;
+	struct idt_page idt_page;
+	struct tss_struct tss;
+};
+
 struct pkvm_hyp {
 	int num_cpus;
 
 	struct vmx_capability vmx_cap;
 	struct vmcs_config vmcs_config;
+
+	struct pkvm_pcpu *pcpus[CONFIG_NR_CPUS];
 };
 
 #define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
+#define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 8fd31360faf8..a076f023c582 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -5,6 +5,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <asm/trapnr.h>
 
 #include <pkvm.h>
 
@@ -12,6 +13,14 @@ MODULE_LICENSE("GPL");
 
 static struct pkvm_hyp *pkvm;
 
+/* only need GDT entries for KERNEL_CS & KERNEL_DS as pKVM only use these two */
+static struct gdt_page pkvm_gdt_page = {
+	.gdt = {
+		[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xa09b, 0, 0xfffff),
+		[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc093, 0, 0xfffff),
+	},
+};
+
 static void *pkvm_early_alloc_contig(int pages)
 {
 	return alloc_pages_exact(pages << PAGE_SHIFT, GFP_KERNEL | __GFP_ZERO);
@@ -75,9 +84,76 @@ static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 	return ret;
 }
 
+static __init void init_gdt(struct pkvm_pcpu *pcpu)
+{
+	pcpu->gdt_page = pkvm_gdt_page;
+}
+
+void noop_handler(void)
+{
+	/* To be added */
+}
+
+static __init void init_idt(struct pkvm_pcpu *pcpu)
+{
+	gate_desc *idt = pcpu->idt_page.idt;
+	struct idt_data d = {
+		.segment = __KERNEL_CS,
+		.bits.ist = 0,
+		.bits.zero = 0,
+		.bits.type = GATE_INTERRUPT,
+		.bits.dpl = 0,
+		.bits.p = 1,
+	};
+	gate_desc desc;
+	int i;
+
+	for (i = 0; i <= X86_TRAP_IRET; i++) {
+		d.vector = i;
+		d.bits.ist = 0;
+		d.addr = (const void *)noop_handler;
+		idt_init_desc(&desc, &d);
+		write_idt_entry(idt, i, &desc);
+	}
+}
+
+static __init void init_tss(struct pkvm_pcpu *pcpu)
+{
+	struct desc_struct *d = pcpu->gdt_page.gdt;
+	tss_desc tss;
+
+	set_tssldt_descriptor(&tss, (unsigned long)&pcpu->tss, DESC_TSS,
+			__KERNEL_TSS_LIMIT);
+
+	write_gdt_entry(d, GDT_ENTRY_TSS, &tss, DESC_TSS);
+}
+
+static __init int pkvm_setup_pcpu(struct pkvm_hyp *pkvm, int cpu)
+{
+	struct pkvm_pcpu *pcpu;
+
+	if (cpu >= CONFIG_NR_CPUS)
+		return -ENOMEM;
+
+	pcpu = pkvm_early_alloc_contig(PKVM_PCPU_PAGES);
+	if (!pcpu)
+		return -ENOMEM;
+
+	/* tmp use host cr3, switch to pkvm owned cr3 after de-privilege */
+	pcpu->cr3 = __read_cr3();
+
+	init_gdt(pcpu);
+	init_idt(pcpu);
+	init_tss(pcpu);
+
+	pkvm->pcpus[cpu] = pcpu;
+
+	return 0;
+}
+
 __init int pkvm_init(void)
 {
-	int ret = 0;
+	int ret = 0, cpu;
 
 	pkvm = pkvm_early_alloc_contig(PKVM_PAGES);
 	if (!pkvm) {
@@ -89,10 +165,23 @@ __init int pkvm_init(void)
 	if (ret)
 		goto out_free_pkvm;
 
+	for_each_possible_cpu(cpu) {
+		ret = pkvm_setup_pcpu(pkvm, cpu);
+		if (ret)
+			goto out_free_cpu;
+	}
+
 	pkvm->num_cpus = num_possible_cpus();
 
 	return 0;
 
+out_free_cpu:
+	for_each_possible_cpu(cpu) {
+		if (pkvm->pcpus[cpu]) {
+			pkvm_early_free(pkvm->pcpus[cpu], PKVM_PCPU_PAGES);
+			pkvm->pcpus[cpu] = NULL;
+		}
+	}
 out_free_pkvm:
 	pkvm_early_free(pkvm, PKVM_PAGES);
 out:
-- 
2.25.1

