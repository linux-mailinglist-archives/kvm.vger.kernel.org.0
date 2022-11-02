Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC9615C42
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiKBGY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKBGYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:24:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602EB26109;
        Tue,  1 Nov 2022 23:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667370263; x=1698906263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0CO9zqn5QJQYlgV3XsYpGa3hDmGaoRGtQlVPOneiyEU=;
  b=EMK7UqWRLUMlJcDHWL1iOIwEoJE8MBwjpf9d1Tu9twfJz9MrPLS+F4vn
   Bs+isjbLzs870MU8zdquEfMmEPtJW+00DAbvP39lLZn/Ijj3MwG4gNCwX
   oUJ0GWV0XYfGKGWdmXDYEkV5ZU6S4Rj7Zf8V5sayW/Z7gVi2OgL6IZMQ5
   ceB9mjgmENJvE9ULx60SYXObdjY+oQTpgc9MZYTo+g10Gsm+kv8xA0rxc
   kvBEnO/D20Lrs/H6fwN0Yes2L1hdHZ/2tSA5lFLXh5FYJ2Kbah1v/WRJJ
   qm7EuHnGfyjnmXcK+Xl9amcE5ZYK+4nNFW9oZb6LVs4WyxIVDMdeBwcBh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="296765013"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="296765013"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:22 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="703146406"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="703146406"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH 3/4] KVM: kvm_main.c: Remove a global variable, hardware_enable_failed
Date:   Tue,  1 Nov 2022 23:24:10 -0700
Message-Id: <0836ee2f6c40091907092fc07fd50e64a499e6d1.1667369456.git.isaku.yamahata@intel.com>
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

A global variable hardware_enable_failed in kvm_main.c is used only by
hardware_enable_all() and hardware_enable_nolock().  It doesn't have to be
a global variable.  Make it function local.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1a21b21ba326..ac24fef2c818 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,7 +105,6 @@ LIST_HEAD(vm_list);
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -5007,30 +5006,36 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static int __hardware_enable_nolock(void)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
 
-	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return;
-
-	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+	if (cpumask_test_and_set_cpu(cpu, &cpus_hardware_enabled))
+		return 0;
 
 	r = kvm_arch_hardware_enable();
 
 	if (r) {
 		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
-		atomic_inc(&hardware_enable_failed);
 		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
 	}
+	return r;
+}
+
+static void hardware_enable_nolock(void *arg)
+{
+	atomic_t *failed = arg;
+
+	if (__hardware_enable_nolock())
+		atomic_inc(failed);
 }
 
 static int kvm_starting_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		(void)__hardware_enable_nolock();
 	raw_spin_unlock(&kvm_count_lock);
 	return 0;
 }
@@ -5072,16 +5077,16 @@ static void hardware_disable_all(void)
 
 static int hardware_enable_all(void)
 {
+	atomic_t failed = ATOMIC_INIT(0);
 	int r = 0;
 
 	raw_spin_lock(&kvm_count_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, &failed, 1);
 
-		if (atomic_read(&hardware_enable_failed)) {
+		if (atomic_read(&failed)) {
 			hardware_disable_all_nolock();
 			r = -EBUSY;
 		}
@@ -5702,7 +5707,7 @@ static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
 		lockdep_assert_not_held(&kvm_count_lock);
-		hardware_enable_nolock(NULL);
+		(void)__hardware_enable_nolock();
 	}
 }
 
-- 
2.25.1

