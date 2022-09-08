Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF61A5B2A43
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiIHX1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiIHX0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F51098C5;
        Thu,  8 Sep 2022 16:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679576; x=1694215576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=grUPy5igLiLP2txiwvePj0au0Jj6sSvLtTxS5GMrsGE=;
  b=GhB2VPTMStyBpiGTtoFnLx0sqFn0CYupQI3lo1AC0LD4Fu8KjMXoIaem
   NylB9i1xSUUej/8/k2h9pxBDtjOIr5XHKBFN+vjNrYknqSEn7hhnoWmOZ
   l0qFaea0JpCvnfYHJ7Gs3ihpmV5tMKZ4FAFFzQ62sAWxuYf18xwzw5Ovm
   /vtwxDGAVtBcbfdFDqUjToug3POGKpesi/Ec/YjnTWPEkQCTaaqbRsfEm
   H4YQh6NPG8DTLAqWInR6Hjj0s9f/00sFrJLtEm4CinaYKxiY/g87fhoDt
   Dcc+JGi93os5Jk2wqZdENOe23xWmDj0Rz3EtL3XrRa4Fux6ARK1vRgWcw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687020"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687020"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863250"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:12 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 17/26] KVM: Introduce a arch wrapper to check all processor compatibility
Date:   Thu,  8 Sep 2022 16:25:33 -0700
Message-Id: <bf667e324f45609c7ff6d06b49ca6bf767f77ae6.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a arch wrapper to check all processor compatibility and define
default implementation as weak symbol to keep the current logic.

The hardware feature compatibility check is arch dependent, only x86 KVM
does cpu feature check on all processors.  It doesn't make much sense to
enforce the current implementation to invoke check function on each
processors.  Introduce a arch callback,
kvm_arch_check_processor_compat_all(), so that arch code can override it.

Eventually feature check should be pushed down into arch callback,
(kvm_arch_hardware_setup(), kvm_arch_online_cpu(), and kvm_arch_resume()),
the two compatibility check, kvm_arch_check_processor_compat{,_all}(), will
be eliminated.  This is a transitional step for it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_arch.c      | 18 ++++++++++++++++++
 virt/kvm/kvm_main.c      | 13 +++----------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60f4ae9d6f48..74cae99fbf09 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1440,6 +1440,7 @@ int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
+int kvm_arch_check_processor_compat_all(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index ad23537ebe3b..9476c500d571 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -98,6 +98,24 @@ __weak int kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
+static void check_processor_compat(void *rtn)
+{
+	*(int *)rtn = kvm_arch_check_processor_compat();
+}
+
+__weak int kvm_arch_check_processor_compat_all(void)
+{
+	int cpu;
+	int r;
+
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, check_processor_compat, &r, 1);
+		if (r < 0)
+			return r;
+	}
+	return 0;
+}
+
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5373127dcdb6..51315d454dc2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5752,11 +5752,6 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
-{
-	*(int *)rtn = kvm_arch_check_processor_compat();
-}
-
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -5782,11 +5777,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			goto out_free_2;
-	}
+	r = kvm_arch_check_processor_compat_all();
+	if (r < 0)
+		goto out_free_2;
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 				      kvm_online_cpu, kvm_offline_cpu);
-- 
2.25.1

