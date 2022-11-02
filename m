Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7464615C40
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKBGY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKBGYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:24:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CCC25EB6;
        Tue,  1 Nov 2022 23:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667370263; x=1698906263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jWp6ZFqy1nSM5l64HCAa0km73/KG59GZikmLmohQJK4=;
  b=XNbr6MZkS3Hpi/ZXOw+82HBFWUFgAE5SaDJmxkHVRMdtX2AXo9eS5fEQ
   CEVpC5lgxuqEByXqBJB3Cj23PpnBupD3PkUzOQAK4o04f/hv0UvsdPAZz
   KhGRQsFF8ybMTzetbtRxbwMCOZFokHmmnuJrfH4AhP1scgKs1nlZDbv4k
   KX4v0zZM0Vh3KM+PRtlgzqdqLDYWUiuFJ78xtuwCwiPL2wScxVHUN4Lh1
   YMKnZZ/MiCj39CpTlLaJN7UqjaARiZSKfknfdtzZtd/2vJdtxvRCRkjj/
   WWks1Kz3Er/DOTYQv40622Ocpv96gqBEZRyggzdCBbHFwtZMinUVCq8+l
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="296765009"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="296765009"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="703146402"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="703146402"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH 2/4] KVM: Make cpus_hardware_enabled cpumask_t instead of cpumask_var_t
Date:   Tue,  1 Nov 2022 23:24:09 -0700
Message-Id: <0b08309d04f1703b2d94b65f138d93554ce9e82c.1667369456.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667369456.git.isaku.yamahata@intel.com>
References: <cover.1667369456.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

On kvm module initialization, it dynamically allocates cpumask_var_t.
Remove dynamic allocation by making it cpumask_t as static allocation. It
simplifies module init and exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a8c4e62b29ca..1a21b21ba326 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,7 +103,7 @@ DEFINE_MUTEX(kvm_lock);
 static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_var_t cpus_hardware_enabled;
+static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
 
@@ -5012,15 +5012,15 @@ static void hardware_enable_nolock(void *junk)
 	int cpu = raw_smp_processor_id();
 	int r;
 
-	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
+	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return;
 
-	cpumask_set_cpu(cpu, cpus_hardware_enabled);
+	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
 
 	r = kvm_arch_hardware_enable();
 
 	if (r) {
-		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
+		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
 		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
 	}
@@ -5039,9 +5039,9 @@ static void hardware_disable_nolock(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
+	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return;
-	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
+	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
 	kvm_arch_hardware_disable();
 }
 
@@ -5849,11 +5849,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_irqfd;
 
-	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
-		r = -ENOMEM;
-		goto out_free_0;
-	}
-
 	r = kvm_arch_hardware_setup(opaque);
 	if (r < 0)
 		goto out_free_1;
@@ -5931,8 +5926,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
-	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
 	kvm_irqfd_exit();
 out_irqfd:
 	kvm_arch_exit();
@@ -5959,7 +5952,6 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	kvm_irqfd_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.25.1

