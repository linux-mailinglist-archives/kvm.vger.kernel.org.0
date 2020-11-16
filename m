Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1132B4F92
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbgKPS17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:27:59 -0500
Received: from mga06.intel.com ([134.134.136.31]:20621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732621AbgKPS1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:55 -0500
IronPort-SDR: Ef39cl+7K/sBivZoXQzoqo2Y8a2qkqtAsK0a5CbW1uRbCjilqMSODI9enmJnoXjzqmMTIoKKTU
 p9Wj4yvRf7Jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232409997"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232409997"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:54 -0800
IronPort-SDR: 0czBnyECJbUX4m1eupE8CDltQXeiaxg3VkZEFTw5wQCagIEbyVdUhRY7xrVbDbdchOg63dnitr
 /kt4xkvsB3cg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527777"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:54 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 05/67] KVM: Enable hardware before doing arch VM initialization
Date:   Mon, 16 Nov 2020 10:25:50 -0800
Message-Id: <59f40d4844dbdedf42632a3a9e82b86f68060204.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
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
---
 virt/kvm/kvm_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 65e1737c4354..11166e901582 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -764,7 +764,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
 		if (!slots)
-			goto out_err_no_arch_destroy_vm;
+			goto out_err_no_disable;
 		/* Generations must be different for each address space. */
 		slots->generation = i;
 		rcu_assign_pointer(kvm->memslots[i], slots);
@@ -774,19 +774,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
@@ -813,10 +813,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
2.17.1

