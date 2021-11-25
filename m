Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9FE45D1A5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352928AbhKYAYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:32622 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352749AbhKYAYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281285"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281285"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:05 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042126"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:05 -0800
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
Subject: [RFC PATCH v3 12/59] KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot by default
Date:   Wed, 24 Nov 2021 16:19:55 -0800
Message-Id: <2d195882a4f834256c319aaf669ab933cbe6688a.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Zap only leaf SPTEs when deleting/moving a memslot by default, and add a
module param to allow reverting to the old behavior of zapping all SPTEs
at all levels and memslots when any memslot is updated.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33794379949e..1e11b14f4f82 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -91,6 +91,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+static bool __read_mostly memslot_update_zap_all;
+module_param(memslot_update_zap_all, bool, 0444);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -5681,11 +5684,27 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
+static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	/*
+	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+	 * case scenario we'll have unused shadow pages lying around until they
+	 * are recycled due to age or when the VM is destroyed.
+	 */
+	write_lock(&kvm->mmu_lock);
+	slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
+			  KVM_MAX_HUGEPAGE_LEVEL, true);
+	write_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (memslot_update_zap_all)
+		kvm_mmu_zap_all_fast(kvm);
+	else
+		kvm_mmu_zap_memslot(kvm, slot);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.25.1

