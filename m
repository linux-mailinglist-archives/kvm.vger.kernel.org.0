Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D408444C7C
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhKDAat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhKDA3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00392C061205
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:45 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e4-20020a630f04000000b002cc40fe16afso2343384pgl.23
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WFKHlikOkpZJpdiLsH4aJihxblDmBHivJrGM8NlUt9c=;
        b=CRXCwBEqUdB8xBBWvbn9rvEyj5xPoJz0Yiq4O9bYP8Cnw9QN2e+/rU9Z5zno6u5DVK
         hNycH7Nu/XPtuVsGfPUbSSTGueoe3SJ6D/+uQvX8yXVdBR6JZwONNcY2XuE+tNblfPrg
         DzYe3VWSE9iz+kLrReWCKtPXc8mvDFxOyEZwsrJmqEqT2dddKgFB7DSFo4206QBqUe3l
         k94nG8IGw8Qk397gTW+mXweZuq2D9/OlhQu3qaAukGk74Ifow4G0x6SSEWRb7kyDOXHM
         mtFt8FUjKSwLn45cNEc6CmGXWE+Jks8EonoUKThzOIBSyaz6+hVlcyMpoJKcO82sckqF
         5Fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WFKHlikOkpZJpdiLsH4aJihxblDmBHivJrGM8NlUt9c=;
        b=zA4+QvJfqGdWK0j9lvbH5c4wyBYHua5iCjOtjzTbKRMAd2rsDK23vSEutNc1x5qa55
         fdTN2gjpGyoKFS+V26eFREAZwn0C9Wx7dpnju6VaN5BzHn5P+aQAdTZqwzV4AkBTE4YW
         Ny5M/5n0v0vAtrSCQpFRSsupIx+8pMssfZZnU99zWh7LBQP/EMAK93s7O55Lzfy7GuDk
         BvxxmfETA4Cr714UndZvagQ8oEoHuUXCaIkSmFOMI7b6hi0l+tQL+byHkuICaR230Qes
         5er1epTC45w50Ut/MCInaHHULlVOA+pOZftZVcZQpdB8m+47SJV+WimwLcmSLNMDrfN0
         tc2g==
X-Gm-Message-State: AOAM530qykx9uvLZrMiZsbwn8zjpy/WSE8XGcLfYuT6TDgzwGopp8SF0
        IqFaPWtVRy6/pxCdMV0zdLs30ATYGUE=
X-Google-Smtp-Source: ABdhPJxoDZvqdkusy2MitxT+1dAwOu5YXFxH0crl6GBFlwKLx55yi8xQIaLV4Wu5oujGScgLca++ESEBh4I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1994:b0:47e:64e5:a1b3 with SMTP id
 d20-20020a056a00199400b0047e64e5a1b3mr42939171pfl.64.1635985605387; Wed, 03
 Nov 2021 17:26:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:28 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 27/30] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Introduce a memslots gfn upper bound operation and use it to optimize
kvm_zap_gfn_range().
This way this handler can do a quick lookup for intersecting gfns and won't
have to do a linear scan of the whole memslot set.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 11 +++++--
 include/linux/kvm_host.h | 69 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09ff0ccaa203..14e41278c069 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5714,16 +5714,20 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
+	struct rb_node *node;
 	bool flush = false;
 	gfn_t start, end;
-	int i, bkt;
+	int i, idx;
 
 	if (!kvm_memslots_have_rmaps(kvm))
 		return flush;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, bkt, slots) {
+		idx = slots->node_idx;
+
+		kvm_for_each_memslot_in_gfn_range(node, slots, gfn_start, gfn_end) {
+			memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
 			start = max(gfn_start, memslot->base_gfn);
 			end = min(gfn_end, memslot->base_gfn + memslot->npages);
 			if (start >= end)
@@ -5747,6 +5751,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	bool flush;
 	int i;
 
+	if (WARN_ON_ONCE(gfn_end <= gfn_start))
+		return;
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6888f3c2e04b..810a5b958697 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -832,6 +832,75 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
+static inline
+struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
+{
+	int idx = slots->node_idx;
+	struct rb_node *node, *result = NULL;
+
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		struct kvm_memory_slot *slot;
+
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		if (gfn < slot->base_gfn) {
+			result = node;
+			node = node->rb_left;
+		} else
+			node = node->rb_right;
+	}
+
+	return result;
+}
+
+static inline
+struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
+{
+	struct rb_node *node;
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the range, so we'll ideally have slot start <= range start
+	 */
+	node = kvm_memslots_gfn_upper_bound(slots, start);
+	if (node) {
+		struct rb_node *pnode;
+
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > range start.
+		 */
+		pnode = rb_prev(node);
+		if (pnode)
+			node = pnode;
+	} else {
+		/* a NULL node below means no slots */
+		node = rb_last(&slots->gfn_tree);
+	}
+
+	return node;
+}
+
+static inline
+bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
+{
+	struct kvm_memory_slot *memslot;
+
+	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
+
+	/*
+	 * If this slot starts beyond or at the end of the range so does
+	 * every next one
+	 */
+	return memslot->base_gfn >= end;
+}
+
+/* Iterate over each memslot *possibly* intersecting [start, end) range */
+#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
+	for (node = kvm_for_each_in_gfn_first(slots, start);		\
+	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
+	     node = rb_next(node))					\
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
-- 
2.33.1.1089.g2158813163f-goog

