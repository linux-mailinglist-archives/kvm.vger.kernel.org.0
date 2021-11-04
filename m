Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A987444C7E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhKDAav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbhKDA3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:24 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE430C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id r2-20020a627602000000b00480f8ce37abso2349707pfc.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eDJLgTwa4Mq+pfIoYabE+ramu2f6Q5nSW9TL6LbQQsI=;
        b=AwZyd1OGNd2jGC9KPlXvy0oV+JkIiHs9n78p1LAJEXYu3abpzCJ4C2qjD9WEdimC8h
         /U06PEKK8296gAr9y+mGJ7YU/AYB7mMLshQmjbfJT2JjYIs1QGfBkPinN0rTDsM0mJ8v
         y1VXf6q7OT9SnMxtkJVPvG6qnljmv27pg/hk28jYo+otmvhiKA+XTi2uKknvqQboocCi
         bNfT4/DvRM5KrXSU8LLRMexndgtLytkukMKS+6YJqn2ZlSHrKvNjmLuH6tB44y+OnCgy
         GssafhzFt1xigLvtK4LdQ29M/UL2+eLN8sYzUERpdj2aCM8q7wJx2XZ+IzRmu3TIf4VS
         eNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eDJLgTwa4Mq+pfIoYabE+ramu2f6Q5nSW9TL6LbQQsI=;
        b=tJOBwJvVu4gWB3heVeDFZs1YvU5wgYJz4mmdOiYzHE0sACFKQ24LeHnlHreNlfzuzO
         Gksl1LpOfww9p7hlLxIhDr0+m3xQK0Th2+TbHDBrcngTF0+1/sl8UiH1V9Ov+K1hICcU
         FJ55+M9U+6TIHuA1gscaDaQgtWCFct/mx2KeMYlYkRWG4CLhR7TUKPtlDRFR34iY+BDm
         rs85lEkAgRBbzLu5CEyF5p/iHAPcenIzzLETI5XV0RbbZRdcVr0QpTMJ120JRJ7ieDlA
         ZwvOZDZ1oRkY862/UGrAip626oPNWPK6U3UPeX1UAIoCQFj8wXm3ZCwOxDlsaCUqaQMq
         kyQQ==
X-Gm-Message-State: AOAM530fHQbosZMzCzJ+dHVN0MTCZW921vxuYtNRae9wBCGZzuNgJo/D
        yyhHIqM4GAB7SD8d/hTjMgK5OYV0Ck4=
X-Google-Smtp-Source: ABdhPJyj4rUoqs2915nhSyoqX9YGWRaiikX568lnB/vn8bpIGUoxqu2M9ISziOOEMnXgiMyENpFmkaA/Mco=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id
 ij16-20020a170902ab5000b0013f4c709322mr41332797plb.89.1635985607093; Wed, 03
 Nov 2021 17:26:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:29 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 28/30] KVM: Optimize overlapping memslots check
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

Do a quick lookup for possibly overlapping gfns when creating or moving
a memslot instead of performing a linear scan of the whole memslot set.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: tweaked params to avoid churn in future cleanup]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 46 +++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d095e01838bf..d22e40225703 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1800,6 +1800,29 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return 0;
 }
 
+static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
+				      gfn_t start, gfn_t end)
+{
+	int idx = slots->node_idx;
+	struct rb_node *node;
+
+	kvm_for_each_memslot_in_gfn_range(node, slots, start, end) {
+		struct kvm_memory_slot *cslot;
+		gfn_t cend;
+
+		cslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		cend = cslot->base_gfn + cslot->npages;
+		if (cslot->id == id)
+			continue;
+
+		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
+		if (cend > start)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1811,8 +1834,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot *old, *tmp;
+	struct kvm_memory_slot *old;
 	struct kvm_memory_slot new;
+	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
 	int as_id, id;
 	int r;
@@ -1841,11 +1865,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
 
+	slots = __kvm_memslots(kvm, as_id);
+
 	/*
 	 * Note, the old memslot (and the pointer itself!) may be invalidated
 	 * and/or destroyed by kvm_set_memslot().
 	 */
-	old = id_to_memslot(__kvm_memslots(kvm, as_id), id);
+	old = id_to_memslot(slots, id);
 
 	if (!mem->memory_size) {
 		if (!old || !old->npages)
@@ -1894,18 +1920,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return 0;
 	}
 
-	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
-		int bkt;
-
-		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, bkt, __kvm_memslots(kvm, as_id)) {
-			if (tmp->id == id)
-				continue;
-			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
-			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
-				return -EEXIST;
-		}
-	}
+	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
+	    kvm_check_memslot_overlap(slots, id, new.base_gfn,
+				      new.base_gfn + new.npages))
+		return -EEXIST;
 
 	return kvm_set_memslot(kvm, old, &new, change);
 }
-- 
2.33.1.1089.g2158813163f-goog

