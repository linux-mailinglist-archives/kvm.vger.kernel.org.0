Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C65D59AB8E
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245495AbiHTGBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244516AbiHTGAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B07A260F;
        Fri, 19 Aug 2022 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975253; x=1692511253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XOa/Zkdq2+BEEU85FVBPfCIeeCZZ/VaM1Oss3PEpGzE=;
  b=UMloBvlnEcmZlkR5O7EZ4lbdUsyc9xcgf7oAeuMvWqcCJilE1KH5RGIk
   hAu0f5mqlJuXRfrRlIxWZO3HGUpdvD1H8WGYMTIBLacMHy+ZT9LGN3fji
   w8+YLGdOxw4TqOy4ahXGBldYujz/O65hKLNrpi4VGesf3iRE3Er4pEKgo
   ar/VPGzPdPgb6k9rQpoW5yw6HVR25kfA7CVX+Bfo1HHtA54NS1HOFG0vw
   Jt+0B/ebB80J63z7vIrhBCuS2hsd8EOZS3/c4X4P+YgZro/LKAhHil2p0
   rG5dyn/Ll1VG9qRJcFb72yRCqjUHDytrk9M2QeiydX5Z6V7bplfZjqtIu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448981"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448981"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857555"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 14/18] KVM: Eliminate kvm_arch_post_init_vm()
Date:   Fri, 19 Aug 2022 23:00:20 -0700
Message-Id: <efde8ff8e65bb396363dce6a27de2bf4789ad617.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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
index 71e90d0f0da9..a1e8d15aa6b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11843,11 +11843,6 @@ void kvm_arch_hardware_disable(void)
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -11910,7 +11905,7 @@ int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		goto err;
 	}
 
-	r = kvm_arch_post_init_vm(kvm);
+	r = kvm_mmu_post_init_vm(kvm);
 err:
 	if (r && usage_count == 1)
 		on_each_cpu(hardware_disable, NULL, 1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9584500eb4fa..7983744addbf 100644
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
index 20971f43df95..94dd57bbc8bd 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -14,11 +14,6 @@
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
-__weak int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -78,13 +73,8 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 
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

