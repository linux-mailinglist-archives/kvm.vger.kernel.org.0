Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749CA59AB8F
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbiHTGBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbiHTGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A6CA260A;
        Fri, 19 Aug 2022 23:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975251; x=1692511251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a+b7bWmrpg+akx27e5IPdnpc7BaBJM21hcXB7NFDQzI=;
  b=n0NZrU0PR/YN6KO+NrNplcgMqa1r9no09XuGxgFTGBL5wpSUx0iPVzgc
   f2qtEbW9VqFShHcR0NSV/HB98louruBPPQ4ALEgSQOmfRdhWIWpFnlzZE
   L6F4tyItpKqoZhzQ+XYq2Zzrw1ZkYyQnl0WA5Ktt1NTh2uXCYums26EqA
   /XajkWpa4HafmvZ9YPF4ASlRIugtHfjs3MXc3k1IZxTt63crqrW3dgbQM
   JJOPKpbY3qgmjcDMWvwcWzBsqAp5H6YAlMCmu5c6OVcoT0atQi+c9tJIW
   TMuh2uZxFG44TrmHWqv7oXXIj4jRNiJJOQ3mUSBqSsHN/W2W4IiteCo5A
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448974"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448974"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857535"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 08/18] KVM: kvm_arch.c: Remove _nolock post fix
Date:   Fri, 19 Aug 2022 23:00:14 -0700
Message-Id: <d357c81da2145d1ea7498b440f24b6a15683b976.1660974106.git.isaku.yamahata@intel.com>
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

Now all related callbacks are called under kvm_lock, no point for _nolock
post fix.  Remove _nolock post fix for short function name.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index d593610edb0a..8a5d88b02aab 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -20,7 +20,7 @@ __weak int kvm_arch_post_init_vm(struct kvm *kvm)
 	return 0;
 }
 
-static void hardware_enable_nolock(void *junk)
+static void hardware_enable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -41,7 +41,7 @@ static void hardware_enable_nolock(void *junk)
 	}
 }
 
-static void hardware_disable_nolock(void *junk)
+static void hardware_disable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
@@ -55,7 +55,7 @@ static void hardware_disable_nolock(void *junk)
 
 __weak void kvm_arch_pre_hardware_unsetup(void)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 }
 
 /*
@@ -70,7 +70,7 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		return 0;
 
 	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable_nolock, NULL, 1);
+	on_each_cpu(hardware_enable, NULL, 1);
 
 	if (atomic_read(&hardware_enable_failed)) {
 		r = -EBUSY;
@@ -80,7 +80,7 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 	r = kvm_arch_post_init_vm(kvm);
 err:
 	if (r)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
+		on_each_cpu(hardware_disable, NULL, 1);
 	return r;
 }
 
@@ -89,39 +89,39 @@ __weak int kvm_arch_del_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return 0;
 }
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
 	if (usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable(NULL);
 	return 0;
 }
 
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 {
 	if (usage_count)
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 	return 0;
 }
 
 __weak int kvm_arch_reboot(int val)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 
 __weak int kvm_arch_suspend(int usage_count)
 {
 	if (usage_count)
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 	return 0;
 }
 
 __weak void kvm_arch_resume(int usage_count)
 {
 	if (usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable(NULL);
 }
-- 
2.25.1

