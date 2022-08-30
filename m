Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CC5A62CB
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiH3MCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiH3MCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87FFEE48F;
        Tue, 30 Aug 2022 05:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860923; x=1693396923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9TGZpPYVEQBXmvcE4fwjJD774pKDGLk/k27m38LhX3M=;
  b=UwtqOZVEdZFNShF+2h8j0NeQFtoR3FyrPfkoobxzFDtFqbmEsXuoSoIf
   At5DURQ8l9h+HBrj2AVaA/UBlghff3rqMYIYCOUT2XSsIcC0fv0tbrHff
   GSr/k/FTnHYuPcTBOQIPq7Wwd8P8Cyi31OAJSeTHbpRy70R8KXE9TzABj
   X8G+YBoSPPI52uocWViUg8/RtrwGvL8rXF3AaOK+XylBqpmsbqwqcXbUL
   jk6SlJICqa5GR6Eg/O4oP0X/GPRwA9BCaikFf9ierJEWyE69xaS9DspU+
   NOtBoayzXoy65IMLCG0Ze6ONXxfDG9uxWdNPXFtpeNgPgRZjKx7lzBc3Y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870993"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870993"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469658"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 15/19] KVM: Eliminate kvm_arch_post_init_vm()
Date:   Tue, 30 Aug 2022 05:01:30 -0700
Message-Id: <bdaa47cba614372f1d9d69fecce365840d0ebb8d.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
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
index 2485f3d792b2..e5f066138ee9 100644
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
index e440d4a99c8a..8f2d920a2a8f 100644
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

