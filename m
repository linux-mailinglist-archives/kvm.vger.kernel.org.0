Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A371615C3F
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKBGYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKBGYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:24:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C025EB8;
        Tue,  1 Nov 2022 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667370262; x=1698906262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hNotXspumrnx35AzALaMaKY1rG2NnMLZH3HRDC+yCBw=;
  b=LwDIJLJQE8BhJVR1li/x4OIHu4/uUFKfu037mpH4/H8Fabv39ozea0EP
   ZXTs7XcYI1tEAmfHk31ef4XzldR8/gxEk6mQyZROJ6Unog/y0/OzPxcoo
   sU7xTH/uaegv8NKZ2dDTGyhwMqadmmGgaV1+bzJwTrBai30JduKuXRjdT
   /VOc2xnEVZ0C5AW0PSgOtP4Q8ujNSFMiTIFedHnimNNJsQ2x9x0w4G/vm
   82GEHaXq0jjrMAOMjsakSMr7ExVYcbZW8XAh9rQwg5rJwn192w18AbXQS
   9jC9z9mIf+Tj83BNJqFdk1fK4s05xcOlCYrBoAmlh1VhP4HCzdwJD2nvs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="296765005"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="296765005"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="703146396"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="703146396"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH 1/4] KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
Date:   Tue,  1 Nov 2022 23:24:08 -0700
Message-Id: <439b5f7115c5df3e1440fe694269badb19390d55.1667369456.git.isaku.yamahata@intel.com>
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

hardware_enable/disable_nolock() check if the hardware is already
enabled/disabled and work as nop when they are called multiple times. Also
kvm_usage_count tracks the number of the existing VMs.

When VM is created/destroyed by kvm_create/destroy_vm(),
hardware_enable/disable_all() and module_get/put() are called.  It means
when kvm module is removed, it's guaranteed that there is no vm
(kvm_usage_count = 0) and that hardware_disable_nolock() was called on each
cpus.

Although the module exit function, kvm_exit(), calls
on_each_cpu(hardware_disable_nolock), it's essentially nop.  Eliminate nop
call in kvm_exit() and add WARN_ON(kvm_usage_count) to prove that there is
no remaining VMs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1376a47fedee..a8c4e62b29ca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5945,6 +5945,8 @@ void kvm_exit(void)
 {
 	int cpu;
 
+	WARN_ON(kvm_usage_count);
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
 	for_each_possible_cpu(cpu)
@@ -5954,7 +5956,6 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	kvm_irqfd_exit();
-- 
2.25.1

