Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D08358BD08
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiHGWCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiHGWCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C44164CB;
        Sun,  7 Aug 2022 15:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909752; x=1691445752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=evDQD18fOKVcdFJsESYzbP5FQjreCHuRm2hX2i0RYKU=;
  b=KGlsBHE849hf2XBSnom5Ze3cTfKh0gu2YadX1qN5wydEhz/JSr1iNeP3
   S4lZvVqH314+gNTUwfJwnrJnrqedSTiyaCAdzpCQSj/6GOyqpIlzpxtmu
   aL9zlty1KEd8A+LSpH8jdu7jYwpeKlngw9/UvEslHNpwTn1CTfi43ZSPq
   dotDEATgdszBOXZwG7Sbi7fI5F7LhshI32iKErQmYhSfpTGcHhR+ZYKvc
   QnzTzFNfJ50UlKTLC+o/U4oV9cE5Zx6mtZlx1RV9uVCBEjkEFrYD0aJXe
   sSqUH/HUXTrYhWVCHs0JpJW2SeN1YIFUIpmGd32AQsissX9fIAxvGWfBd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224051"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224051"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682454"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 006/103] KVM: Enable hardware before doing arch VM initialization
Date:   Sun,  7 Aug 2022 15:00:51 -0700
Message-Id: <277c579eb2074617eb2157c4b1810562d2f30ed7.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 virt/kvm/kvm_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a43fdbfaede2..8a36844b423c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1182,19 +1182,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
@@ -1232,10 +1232,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
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

