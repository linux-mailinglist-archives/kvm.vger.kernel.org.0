Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826ED45D19E
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352938AbhKYAYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:25 -0500
Received: from mga18.intel.com ([134.134.136.126]:32622 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352723AbhKYAYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281279"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281279"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:04 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042112"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:03 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 09/59] KVM: Enable hardware before doing arch VM initialization
Date:   Wed, 24 Nov 2021 16:19:52 -0800
Message-Id: <0763173807466be61a823cd30c2c334adecb0a95.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 virt/kvm/kvm_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8e799eeef8d..8544e92db2da 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1065,7 +1065,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
 		if (!slots)
-			goto out_err_no_arch_destroy_vm;
+			goto out_err_no_disable;
 		/* Generations must be different for each address space. */
 		slots->generation = i;
 		rcu_assign_pointer(kvm->memslots[i], slots);
@@ -1075,19 +1075,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
@@ -1115,10 +1115,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
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

