Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1555AA596
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiIBCS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiIBCS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F46AA4F8;
        Thu,  1 Sep 2022 19:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085100; x=1693621100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cY/sye/eqDIWklur2ePtwjCoskK1QiS6z4F30oQEG7U=;
  b=fXhW9n8UXhYJrLV5MCrjeIVOotFLaQKT3Bl4jmi2ou12JnWPX/Tcf3UT
   WeGCfqYebHJoegCi/s9jqGqbH6RAI7zYcm4sp0ITnS2OsPc/1pZvp26mz
   n+0r7RfpoeUGiBWTaS1xIkzHaHuJ0dupbPv6MMrDP11iNQFubNJS03FfN
   NP2KimrROyQZPDRRAb3GxnSs6V+tJPx1la9s7zP4QSOwfxQ7BlqdGZUwh
   r83R1xZq/fIZLjU0NO0Wl4+I91+nAg/TzOzsBe80Iiwv0YDaEuDrdIcNu
   d426gfpbKkY1R8XF2ctcifV64C8rMcatL8K0pYhaJ6DHmK7KvN/mLYjMy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157863"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157863"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835665"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:19 -0700
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
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 18/22] KVM: Eliminate kvm_arch_post_init_vm()
Date:   Thu,  1 Sep 2022 19:17:53 -0700
Message-Id: <0adf5268ef7b09876acab9098acd28d198b03b38.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662084396.git.isaku.yamahata@intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
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

Now kvm_arch_post_init_vm() is used only by x86 kvm_arch_add_vm().  Other
arch doesn't define it. Merge x86 kvm_arch_post_init_vm() int x86
kvm_arch_add_vm() and eliminate kvm_arch_post_init_vm().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c       |  7 +------
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_arch.c      | 12 +-----------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a28eb5fbb76..fa68bea655f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11847,11 +11847,6 @@ void kvm_arch_hardware_disable(void)
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static int __hardware_enable(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
@@ -11915,7 +11910,7 @@ int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		goto err;
 	}
 
-	r = kvm_arch_post_init_vm(kvm);
+	r = kvm_mmu_post_init_vm(kvm);
 err:
 	if (r)
 		on_each_cpu(hardware_disable, NULL, 1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60f4ae9d6f48..8abbf7a1773b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1445,7 +1445,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int kvm_arch_post_init_vm(struct kvm *kvm);
 int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
 int kvm_arch_del_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index f7dcde842eb5..bcd82b75fa17 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -14,11 +14,6 @@
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-__weak int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 static int __hardware_enable(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
@@ -79,13 +74,8 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 
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

