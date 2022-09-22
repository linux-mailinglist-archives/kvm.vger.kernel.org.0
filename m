Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2855E6AC8
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiIVSXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiIVSXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9110B585;
        Thu, 22 Sep 2022 11:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870932; x=1695406932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JEMsGnsZUhYCBVZocJG3MEHANA4O9MZIjmnjwfXxTVU=;
  b=lGEJPom6f8fi4vbIJ1Wg5rt7OsCYAe28LCGD2C9fVI9v3tVIhjR/E43C
   WL/Yuh+fWYxOFK9/htJzHTHhjq45IT6+UxA02OjIoY/XLOk3Ne1g6KzY8
   pShDio7eJi7tRhyu7KI+2PMbyBeCPo8uCJulSnV5u5nV2ed6FXKkdjycL
   6KD/2bAfkrxKF31dEEFusi+7E70wJOIcPSqN90U0splM9ye/Ee4X+NIiM
   76v8poTMI/MEDc/Cc+Y/HDhQ2YIKcEkF+GNrVQnqftCYv2iqgjs6JwyQW
   wnPQnW3nyE0fqgh//DHm24WsqstbYlOzwoafGGQW0Uf6oYTTvArWsJxoj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712925"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712925"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086838"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:25 -0700
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
Subject: [PATCH v5 23/30] KVM: Eliminate kvm_arch_post_init_vm()
Date:   Thu, 22 Sep 2022 11:20:52 -0700
Message-Id: <7ea322131782fdeb8df0122c5f4a3b75fcb360b2.1663869838.git.isaku.yamahata@intel.com>
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

Now kvm_arch_post_init_vm() is used only by x86 kvm_arch_add_vm().  Other
arch doesn't define it. Merge x86 kvm_arch_post_init_vm() into x86
kvm_arch_add_vm() and eliminate kvm_arch_post_init_vm().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c       |  7 +------
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_arch.c      | 16 +---------------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d49396bb6c2e..bf8d3b901725 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11969,11 +11969,6 @@ void kvm_arch_hardware_disable(void)
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -12032,7 +12027,7 @@ int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		goto err;
 	}
 
-	r = kvm_arch_post_init_vm(kvm);
+	r = kvm_mmu_post_init_vm(kvm);
 err:
 	if (r)
 		on_each_cpu(hardware_disable, NULL, 1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c5ca8741ca5..8dfa212b4543 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1451,7 +1451,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int kvm_arch_post_init_vm(struct kvm *kvm);
 int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
 int kvm_arch_del_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 87ee84c09634..2509c2777a49 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -14,15 +14,6 @@
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-/*
- * Called after the VM is otherwise initialized, but just before adding it to
- * the vm_list.
- */
-int __weak kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -77,13 +68,8 @@ int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 
 	if (atomic_read(&failed)) {
 		r = -EBUSY;
-		goto err;
-	}
-
-	r = kvm_arch_post_init_vm(kvm);
-err:
-	if (r)
 		on_each_cpu(hardware_disable, NULL, 1);
+	}
 	return r;
 }
 
-- 
2.25.1

