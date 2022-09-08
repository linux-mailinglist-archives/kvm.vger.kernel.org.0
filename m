Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC9B5B2A30
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiIHX0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiIHX0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE5EE6BA1;
        Thu,  8 Sep 2022 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679567; x=1694215567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xg0WmMFTfA/g4jLjPGWiDRFU62B4P5RAx9DcjKdahlo=;
  b=jt4+vvg8LDXTn8uaQYUggCjemcXodlms/P9fsBReVjICUauvcgnJfOjX
   RkZnu+6W9sNZwP1TC5Ez5zQNFrMZA1tI5+GNFspUe11+l9rRWr/61fggW
   uNAO1hG3WmMKO0qr0ARrf5Z3KRtRxxXIs6rPVIWjvbSeMZNVgDsM1zhWW
   wHX44Cdy/MWxX0hlHvT+WcGGTK77F9ZzKfCXMhnLEqdD8tHPjLhz7/M/H
   gdOnLONYLxdixDAcf40I5gbFl+YkMPik7K25uMROjyEII/Pbxxl6RXHLd
   e9o+xrDrOmXkDBqsuelBaccZzUSo3tnHrOfLGBWT+BzJbxtcSLX+kwKj9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298686983"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298686983"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:05 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863164"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:05 -0700
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
        Huacai Chen <chenhuacai@kernel.org>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v4 05/26] KVM: Provide more information in kernel log if hardware enabling fails
Date:   Thu,  8 Sep 2022 16:25:21 -0700
Message-Id: <a9815cc25a79dca6a1953e2de8e321c88bd30db4.1662679124.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Provide the name of the calling function to hardware_enable_nolock() and
include it in the error message to provide additional information on
exactly what path failed.

Opportunistically bump the pr_info() to pr_warn(), failure to enable
virtualization support is warn-worthy as _something_ is wrong with the
system.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20220216031528.92558-4-chao.gao@intel.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4243a9541543..278eb6cc7cbe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4991,7 +4991,7 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static void hardware_enable_nolock(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -5006,7 +5006,8 @@ static void hardware_enable_nolock(void *junk)
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
 	}
 }
 
@@ -5014,7 +5015,7 @@ static int kvm_starting_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	raw_spin_unlock(&kvm_count_lock);
 	return 0;
 }
@@ -5063,7 +5064,7 @@ static int hardware_enable_all(void)
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
 
 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -5686,7 +5687,7 @@ static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
 		lockdep_assert_not_held(&kvm_count_lock);
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	}
 }
 
-- 
2.25.1

