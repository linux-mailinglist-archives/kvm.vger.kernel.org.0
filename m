Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42B3BA55F
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhGBWH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:51169 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhGBWHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951897"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951897"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814720"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:21 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 16/69] KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot by default
Date:   Fri,  2 Jul 2021 15:04:22 -0700
Message-Id: <78d02fee3a21741cc26f6b6b2fba258cd52f2c3c.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index 8d5876dfc6b7..5b8a640f8042 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -85,6 +85,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+static bool __read_mostly memslot_update_zap_all;
+module_param(memslot_update_zap_all, bool, 0444);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -5480,11 +5483,27 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
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

