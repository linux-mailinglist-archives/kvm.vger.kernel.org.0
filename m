Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80F5AA58C
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiIBCSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiIBCSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF49A6B14C;
        Thu,  1 Sep 2022 19:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085092; x=1693621092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=89g46DoJQlIZCYsVV2TcHWb0ssHw4Av0kj/FFzFyeAk=;
  b=LpOH1zR0hiAN5xq7wt+Qkw0Iw9ioYvPYwDTR9MYOjYqB8d/q62Qd2FiG
   XzgBlcJWHW7VIx5AdBVN1bi2g6hA6Moumjif4g0OME0EevvhU4DQJmRVs
   7zP7vfRMhuzWwPXOOYibwkGH3DJx2c57ZB4sIv0k5ejjOiqWa0ihKWOts
   cB47TuhSyb4Gdt3FmbPxffrLZYeY50a+HzE4nTacaxoES+/TRaJC7VIsV
   WAeBBn0EMM8iYwhlGYI+tIllrnlxJoTZnowAX3mDIccZW/4Zt3gdIwV5y
   4GrAlpc2vJE1jztOl9WSRsmtVDk7+ReDLCupl5jClelTKn+Ku8leEgzpy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157835"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157835"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835604"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:12 -0700
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
Subject: [PATCH v3 05/22] KVM: Provide more information in kernel log if hardware enabling fails
Date:   Thu,  1 Sep 2022 19:17:40 -0700
Message-Id: <5f659936255837f77e821011bb9445a98322e3ae.1662084396.git.isaku.yamahata@intel.com>
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

