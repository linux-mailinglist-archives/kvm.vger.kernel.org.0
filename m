Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3279D4BCA37
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiBSSuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiBSSuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:15 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB7F6C1DF;
        Sat, 19 Feb 2022 10:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296596; x=1676832596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pSGimKmw4/tAptvI173g3ddT2zZr/OGCg82dU+zyAnw=;
  b=fUWR/7lVRD+moBodXa9QRp7gskrv6jTKmdpZxCzKof/haap4XF7fzq1B
   y45bxsq5jOuPtWIcnNDjgzZf+WBYGQmDYnYoTj41MQTargdwpVckkpmFJ
   ooqzmsDiOSMAUzi5gRB+fy48IZQFBjM2udD/7SWj4ysmt7QOC/K93UpDp
   fjpyyxZR2sKiF8G4RE5Giyo8Gk1/WRiy82B/pDlm0qu6LNTJbgcEVruDq
   zMM+/jUoaq7LKAhv6jeMsjlVNq0SDlSLo5/uoU40SLDkBUAqitDldrUS7
   pZiaz+3ymR4BB5vsrH1HmwqvfUnok7SMYBNZb4ynhCLPaf/Az5H1F4aXD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312058995"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312058995"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137030"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:55 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 3/8] KVM: Enable hardware before doing arch VM initialization
Date:   Sat, 19 Feb 2022 10:49:48 -0800
Message-Id: <810b87625099d17efb98f7a1b9a85ffe8542f727.1645266955.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645266955.git.isaku.yamahata@intel.com>
References: <cover.1645266955.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 virt/kvm/kvm_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58d31da8a2f7..4adc4dafce93 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1105,19 +1105,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
@@ -1145,10 +1145,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
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

