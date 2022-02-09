Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC334AEB51
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 08:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiBIHmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 02:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiBIHmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 02:42:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA6C05CB86;
        Tue,  8 Feb 2022 23:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644392542; x=1675928542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jx4r8Rhlcqajoe9geL7BjqQBljriUmOSEo4bcI4SAQQ=;
  b=iceayps0QV+ra7YriKUvrrvwZKR8D1WwV3F+uvNyu2XDGkZaiCagzWcv
   eVCLmqo/nZHvnGp5k5rCAGEVxAcoWKRFTBf0iJVm44VNjCiPMyO5Dh7q/
   hjGXQ+v56gVdXTD60IHVjzBIDFJ4ZVZMeZyV+l3CuVU6YKY8A2Qm4l7DT
   OUseY8EHsES3+G78nG3sd6E+88VaG7W9D2V5x2RAZxzTXYMzEAPSJKYwh
   /gevMT7TIx/lL+cveLaLCAbPwP6YDB+EtwiTPUSOnKeG8dm0SJ6Ooykht
   nooyRrvYIguuoHZi4FVAOQLSgaI/OW756mci1chBvflJhkoxJ8JMRUtwm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="248907305"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="248907305"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:41:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="540984684"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:41:51 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] KVM: Provide more information in kernel log if hardware enabling fails
Date:   Wed,  9 Feb 2022 15:41:04 +0800
Message-Id: <20220209074109.453116-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209074109.453116-1-chao.gao@intel.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Provide the name of the calling function to hardware_enable_nolock() and
include it in the error message to provide additional information on
exactly what path failed.

Opportunistically bump the pr_info() to pr_warn(), failure to enable
virtualization support is warn-worthy as _something_ is wrong with the
system.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be614a6325e4..23481fd746aa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4833,7 +4833,7 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static void hardware_enable_nolock(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -4848,7 +4848,8 @@ static void hardware_enable_nolock(void *junk)
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
 	}
 }
 
@@ -4856,7 +4857,7 @@ static int kvm_starting_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	raw_spin_unlock(&kvm_count_lock);
 	return 0;
 }
@@ -4905,7 +4906,7 @@ static int hardware_enable_all(void)
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
 
 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -5530,7 +5531,7 @@ static void kvm_resume(void)
 #ifdef CONFIG_LOCKDEP
 		WARN_ON(lockdep_is_held(&kvm_count_lock));
 #endif
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	}
 }
 
-- 
2.25.1

