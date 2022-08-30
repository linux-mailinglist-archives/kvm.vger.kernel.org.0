Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339CD5A62BB
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiH3MCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiH3MCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7ADE9270;
        Tue, 30 Aug 2022 05:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860921; x=1693396921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=acOpBp0TwBzAoRqBKx4NbGM0ZNJfNy50Nx4gx4/JIVM=;
  b=iyrRPUhSW86ZS93avhRpdCAyOVLznH6MMI/VrAIhOwlUcwDNCV2mYPTW
   20MtM8hcLxkrYE7040NZ8BsK4UwSovvT2Hq46UQxS2Owh1neK0CavlgsZ
   wkVAzAf8BZ5evLbTnGtCE3EYKO+1oNnLgapD+oWavojLOVVD/g0XV+IUt
   GOVwVge8cPjUBVO44htF3r1NS3Nrd7Ctb1NVMj9in8P327rMM3v9mUV6Y
   pJ+R8MpOAmcdzB/fF1m/OdwiK4HP7koxONgsAnG2gXgx9myJpBe5xJMIs
   uN5xECCibUkPKfDT2UCIe3EOjuoLFSUOowRKmk1xrDGiD2jQS0KmP/g0z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870982"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870982"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469644"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 11/19] KVM: kvm_arch.c: Remove _nolock post fix
Date:   Tue, 30 Aug 2022 05:01:26 -0700
Message-Id: <284273dc6c1310812681c1de901c552788ab2897.1661860550.git.isaku.yamahata@intel.com>
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

Now all related callbacks are called under kvm_lock, no point for _nolock
post fix.  Remove _nolock post fix for short function name.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 51c6e9f03ed5..491e92ef9e3d 100644
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
 
@@ -89,7 +89,7 @@ __weak int kvm_arch_del_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return 0;
 }
 
@@ -105,7 +105,7 @@ __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 	if (usage_count) {
 		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
 
-		hardware_enable_nolock(NULL);
+		hardware_enable(NULL);
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
@@ -117,25 +117,25 @@ __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
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

