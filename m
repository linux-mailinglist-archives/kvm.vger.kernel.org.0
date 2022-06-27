Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E44D55C820
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241257AbiF0Vyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiF0Vyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935DA625E;
        Mon, 27 Jun 2022 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366888; x=1687902888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5BqaMvNZqMpHCHM9lfZC+yP1raq0KNki8VQ/Pk5gbs=;
  b=MGWLBb5hN57HzYJ1EJKM4FqLJS6pw6DEO3/TxzpvFqcq3QXG3qvqtpvj
   yi5R/S5Q0dcjYjuEDnYs0N/NvUdpIpT4tVJSULqoDhPAkmTBpuYdgVRLO
   WYJwy/3Sz9mRWikmJv1qtr7bHyp2EbNw3PCaD3Z/R1TJkpn2SZcVm6PJW
   9I9i454xaxaHvJcRSQzuw6wWZHtT/GcvqYxlI+uNRdRzlSGFID2o8+xs9
   Ptwta3R6dYeegC34lITEObuHhEV+8N+bo6jGfXOvdBhFFL7omeBWx1yAa
   jc5poJLw78dD2tnvd9wLaX7PhTzNIAFqHs+HAcSlU0AJqnKPIM0CEuKzo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="261983018"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="261983018"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863449"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 007/102] KVM: Enable hardware before doing arch VM initialization
Date:   Mon, 27 Jun 2022 14:52:59 -0700
Message-Id: <e3ccffe3a46f994779037e4965313e7df9980ddc.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Swap the order of hardware_enable_all() and kvm_arch_init_vm() to
accommodate Intel's TDX, which needs VMX to be enabled during VM init in
order to make SEAMCALLs.

This also provides consistent ordering between kvm_create_vm() and
kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
hardware_disable_all().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cee799265ce6..0acb0b6d1f82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1138,19 +1138,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		rcu_assign_pointer(kvm->buses[i],
 			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
 		if (!kvm->buses[i])
-			goto out_err_no_arch_destroy_vm;
+			goto out_err_no_disable;
 	}
 
 	kvm->max_halt_poll_ns = halt_poll_ns;
 
-	r = kvm_arch_init_vm(kvm, type);
-	if (r)
-		goto out_err_no_arch_destroy_vm;
-
 	r = hardware_enable_all();
 	if (r)
 		goto out_err_no_disable;
 
+	r = kvm_arch_init_vm(kvm, type);
+	if (r)
+		goto out_err_no_arch_destroy_vm;
+
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
@@ -1188,10 +1188,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
-out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
+	hardware_disable_all();
+out_err_no_disable:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
-- 
2.25.1

