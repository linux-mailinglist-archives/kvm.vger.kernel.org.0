Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE6464086
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbhK3VrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:47:01 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56400 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344343AbhK3Vqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:46:46 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAtz-00064r-LS; Tue, 30 Nov 2021 22:43:03 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/29] KVM: x86: Don't assume old/new memslots are non-NULL at memslot commit
Date:   Tue, 30 Nov 2021 22:41:27 +0100
Message-Id: <ed4cc6958f789236ed7ce5ca53542aa011325957.1638304316.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Play nice with a NULL @old or @new when handling memslot updates so that
common KVM can pass NULL for one or the other in CREATE and DELETE cases
instead of having to synthesize a dummy memslot.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/x86.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a598b0c3e36..f25d224d21d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11758,13 +11758,15 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
-	bool log_dirty_pages = new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)
+	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
 		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
@@ -11782,7 +11784,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * MOVE/DELETE: The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot().
 	 */
-	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
+	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
 	/*
@@ -11790,7 +11792,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
 	 * logging isn't being toggled on or off.
 	 */
-	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
+	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
 		return;
 
 	if (!log_dirty_pages) {
