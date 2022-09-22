Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD6C5E6AC6
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiIVSXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiIVSW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:22:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE8109621;
        Thu, 22 Sep 2022 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870925; x=1695406925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Voi8WuLjLcB8mdNn0W+tygmrtXDvZpUlJiE4WnwNggM=;
  b=H+ZPxMDCVZlKKgfK1EZaWIzETPbhPcrT5ueg46ntGoDOc7u6vyQ5zZdW
   itOP+Z4jk5T3ze6ZvAVFJejHwIF+z5TBW1iQW4onuX5AhPKwoyFxoJ84Z
   EE9PnErkPU8dyqnI9lGaSr1+Vt0lvd1aZKaRVJozcbexikTlc3uduuxG4
   gjnvTRBQVFC5EXSuhZ4PQt5Wnkyh9f/hQktDRpEdD5Qejb4wMVom/Yo+R
   Xv+DHjNcwLShgZQBWs61D8o/omeWiNiwuP8iewaPGG91NMkMJpgkiZb7O
   5TTGG8Rlib/Xyo0tIOfeYEHuyj1ePeu2PNDvH4jJvQaQlsVr1OBE1y1YX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712908"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712908"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086797"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:24 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 20/30] KVM: Introduce an arch wrapper to check all processor compatibility
Date:   Thu, 22 Sep 2022 11:20:49 -0700
Message-Id: <b756481f1a6efa1a64b13dc1b9c8c308e40863a9.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce an arch wrapper to check all processor compatibility and define
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_arch.c      | 18 ++++++++++++++++++
 virt/kvm/kvm_main.c      | 13 +++----------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3a79d55ca8c..2c5ca8741ca5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1445,6 +1445,7 @@ void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
+int kvm_arch_check_processor_compat_all(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 10fd29bdd6e1..87ee84c09634 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -96,6 +96,24 @@ int __weak kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
+static void check_processor_compat(void *rtn)
+{
+	*(int *)rtn = kvm_arch_check_processor_compat();
+}
+
+int __weak kvm_arch_check_processor_compat_all(void)
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
 int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	int ret;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1a09d2d5982..d5f882fb9e0c 100644
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

