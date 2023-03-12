Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC956B6453
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCLJyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCLJyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C637B7F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614886; x=1710150886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GeXTk9g4BNIyQlPx7Hv9KbcP3Ejo93Go3hBg5JF2JT8=;
  b=mWXzWwQEgBuburkcB8GHsILsvr40+YpGgmPWzJYrmY9d5S2f0nshvV7M
   bcZmtnX1i0Mp7kIiVTQ6R8xQtezqgNmLeVXx6eRIMulV/qhiVXVg+wzMn
   XVVQjxD8V02nr/aCTz1GbtsLT2x8IBC1HWbRz0vzYCdNUhWApIt7Z2tVP
   yRrjw3AnVft/Pgf0aV2obgntRCa9s1iCwYl271MWnQBlezbsBOId3z3mC
   Hd07bia8zqlWFyawrQ/n9Jm47yCuJMgXDlUN9hovoCWX6BTX/jMNcvNTt
   iFGekaMM3brRhRjvt5s8ILckvkOIRoZJERizOcisVaS43IgtXz1CpBgaj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622902"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622902"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408966"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408966"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:24 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 05/17] pkvm: x86: Add basic setup for host vcpu
Date:   Mon, 13 Mar 2023 02:01:00 +0800
Message-Id: <20230312180112.1778254-6-jason.cj.chen@intel.com>
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

Introduce pkvm_host_vm and pkvm_host_vcpu data structure. The pKVM
supports one host vm with up to CONFIG_NR_CPUS host vcpus.

The pkvm_host_vcpu is the key data entry to assist running vcpu of host VM.
Struct vcpu_vmx is used as its major part to allow pKVM easily sharing
code logic from KVM VMX.

The pkvm_host_vcpu data entry is allocated according to the real cpu
number system running, during the new added vcpu setup logic within
pkvm_init.

NOTE: the vcpu of host VM is 1:1 mapping to pCPU.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/include/pkvm.h | 12 ++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 3adcebd31ca6..73d2c235557a 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -22,6 +22,15 @@ struct pkvm_pcpu {
 	struct tss_struct tss;
 };
 
+struct pkvm_host_vcpu {
+	struct vcpu_vmx vmx;
+	struct pkvm_pcpu *pcpu;
+};
+
+struct pkvm_host_vm {
+	struct pkvm_host_vcpu *host_vcpus[CONFIG_NR_CPUS];
+};
+
 struct pkvm_hyp {
 	int num_cpus;
 
@@ -29,9 +38,12 @@ struct pkvm_hyp {
 	struct vmcs_config vmcs_config;
 
 	struct pkvm_pcpu *pcpus[CONFIG_NR_CPUS];
+
+	struct pkvm_host_vm host_vm;
 };
 
 #define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
+#define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index a076f023c582..c437cb965771 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -151,6 +151,25 @@ static __init int pkvm_setup_pcpu(struct pkvm_hyp *pkvm, int cpu)
 	return 0;
 }
 
+static __init int pkvm_host_setup_vcpu(struct pkvm_hyp *pkvm, int cpu)
+{
+	struct pkvm_host_vcpu *pkvm_host_vcpu;
+
+	if (cpu >= CONFIG_NR_CPUS)
+		return -ENOMEM;
+
+	pkvm_host_vcpu = pkvm_early_alloc_contig(PKVM_HOST_VCPU_PAGES);
+	if (!pkvm_host_vcpu)
+		return -ENOMEM;
+
+	pkvm_host_vcpu->pcpu = pkvm->pcpus[cpu];
+	pkvm_host_vcpu->vmx.vcpu.cpu = cpu;
+
+	pkvm->host_vm.host_vcpus[cpu] = pkvm_host_vcpu;
+
+	return 0;
+}
+
 __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
@@ -169,6 +188,9 @@ __init int pkvm_init(void)
 		ret = pkvm_setup_pcpu(pkvm, cpu);
 		if (ret)
 			goto out_free_cpu;
+		ret = pkvm_host_setup_vcpu(pkvm, cpu);
+		if (ret)
+			goto out_free_cpu;
 	}
 
 	pkvm->num_cpus = num_possible_cpus();
@@ -177,6 +199,10 @@ __init int pkvm_init(void)
 
 out_free_cpu:
 	for_each_possible_cpu(cpu) {
+		if (pkvm->host_vm.host_vcpus[cpu]) {
+			pkvm_early_free(pkvm->host_vm.host_vcpus[cpu], PKVM_HOST_VCPU_PAGES);
+			pkvm->host_vm.host_vcpus[cpu] = NULL;
+		}
 		if (pkvm->pcpus[cpu]) {
 			pkvm_early_free(pkvm->pcpus[cpu], PKVM_PCPU_PAGES);
 			pkvm->pcpus[cpu] = NULL;
-- 
2.25.1

