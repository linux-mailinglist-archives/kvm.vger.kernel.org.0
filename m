Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED26FFD9C
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 02:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbjELAAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 20:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbjEKX74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:59:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130A09004
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5308f5d8ac9so359228a12.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683849575; x=1686441575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YdFQws+BbDv+q0XQd6XpddAlUZcDBYqpJC7jJhm9HZU=;
        b=VR7/YRmc0kUdtZZeXAJk/oybb3UJiNq99DF6W3kZr5MdmwNZsDFKQHw32c7BCB0Ac0
         Pj3x7OapMux0TWLexQNp6Ms+tCPJOo2GQ0S9nkhqgnS4jfigZ7GxS69/icextMSVKSDw
         jKNBr8JiAzV2N+5vMvvXDyJIgaZDwlVCQhF+oD/im38Dlti4nMJkyWOV3DbWzdRbRC2Z
         S1xRUZCMG548+ISQRwU4pcge0PbiN/nvsve6YuJRDpnnvSMJ+1ZBs4TYshhEPEIEUHLH
         QN964Mm4Q+yzpBrqvBm0HS/0w62xwIeTMkv9Vq3MecaWzIlVwSO7rfJ+aZq4GTxDLJtj
         FOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849575; x=1686441575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YdFQws+BbDv+q0XQd6XpddAlUZcDBYqpJC7jJhm9HZU=;
        b=kNWpa556RXOiDijEYoX4i8B3TK5siS2SUjK4lxaLfAQO+1+26uspv3rfOHsfnY96si
         fDvIMUpgNk6z8wR3mB6w26gn5q0zKDb9D5ldNmCYm+RgDrfbRvBSNjDPDetIjLDVyVlL
         fJYekjhU42+nGxc46/e+mbH9tr4k/oG2hQFd4fRZxOEoH2HP+cIiox3042yHuJGxmkwF
         8s64gdMGfWzt5rgoqC6PQYIED7CjidKrLE8CEVP0c2lWx7LyDv4mpogjBmLbNImOf/s5
         kXNS7w/xfPncnS3BKaeFRhq6jOLK6naKFP2oVDuspeWWLcFWBKGYp0YN1paEKBdCwwHC
         ADGQ==
X-Gm-Message-State: AC+VfDxxmn0C+Iyh5O1/WyoT2dpy5+aufD2TcJga+zNvGMMzb60h7VbO
        5zS6VJRP4ZPiw1NI5kqaP6tqoiPcbzQ=
X-Google-Smtp-Source: ACHHUZ4jZDMm52zcA1xq6SxE1K9rdws7Jb9q4u5mzF0NVgByBQqTqnizNeMIXfpLdnTLtyFXEjaQa4k55G0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2a09:0:b0:530:3a44:1581 with SMTP id
 q9-20020a632a09000000b005303a441581mr3118668pgq.9.1683849575375; Thu, 11 May
 2023 16:59:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:59:17 -0700
In-Reply-To: <20230511235917.639770-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511235917.639770-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: x86/mmu: BUG() in rmap helpers iff CONFIG_BUG_ON_DATA_CORRUPTION=y
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce KVM_BUG_ON_DATA_CORRUPTION() and use it in the low-level rmap
helpers to convert the existing BUG()s to WARN_ON_ONCE() when the kernel
is built with CONFIG_BUG_ON_DATA_CORRUPTION=n, i.e. does NOT want to BUG()
on corruption of host kernel data structures.  Environments that don't
have infrastructure to automatically capture crash dumps, i.e. aren't
likely to enable CONFIG_BUG_ON_DATA_CORRUPTION=y, are typically better
served overall by WARN-and-continue behavior (for the kernel, the VM is
dead regardless), as a BUG() while holding mmu_lock all but guarantees
the _best_ case scenario is a panic().

Make the BUG()s conditional instead of removing/replacing them entirely as
there's a non-zero chance (though by no means a guarantee) that the damage
isn't contained to the target VM, e.g. if no rmap is found for a SPTE then
KVM may be double-zapping the SPTE, i.e. has already freed the memory the
SPTE pointed at and thus KVM is reading/writing memory that KVM no longer
owns.

Link: https://lore.kernel.org/all/20221129191237.31447-1-mizhang@google.com
Suggested-by: Mingwei Zhang <mizhang@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 21 ++++++++++-----------
 include/linux/kvm_host.h | 19 +++++++++++++++++++
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a8adeaa7dd7..5ee1ee201441 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -974,7 +974,7 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
 	 * when adding an entry and the previous head is full, and heads are
 	 * removed (this flow) when they become empty.
 	 */
-	BUG_ON(j < 0);
+	KVM_BUG_ON_DATA_CORRUPTION(j < 0, kvm);
 
 	/*
 	 * Replace the to-be-freed SPTE with the last valid entry from the head
@@ -1005,14 +1005,13 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	struct pte_list_desc *desc;
 	int i;
 
-	if (!rmap_head->val) {
-		pr_err("%s: %p 0->BUG\n", __func__, spte);
-		BUG();
-	} else if (!(rmap_head->val & 1)) {
-		if ((u64 *)rmap_head->val != spte) {
-			pr_err("%s:  %p 1->BUG\n", __func__, spte);
-			BUG();
-		}
+	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_head->val, kvm))
+		return;
+
+	if (!(rmap_head->val & 1)) {
+		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_head->val != spte, kvm))
+			return;
+
 		rmap_head->val = 0;
 	} else {
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
@@ -1026,8 +1025,8 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 			}
 			desc = desc->more;
 		}
-		pr_err("%s: %p many->many\n", __func__, spte);
-		BUG();
+
+		KVM_BUG_ON_DATA_CORRUPTION(true, kvm);
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9696c2fb30e9..2f06222f44e6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -864,6 +864,25 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 	unlikely(__ret);					\
 })
 
+/*
+ * Note, "data corruption" refers to corruption of host kernel data structures,
+ * not guest data.  Guest data corruption, suspected or confirmed, that is tied
+ * and contained to a single VM should *never* BUG() and potentially panic the
+ * host, i.e. use this variant of KVM_BUG() if and only if a KVM data structure
+ * is corrupted and that corruption can have a cascading effect to other parts
+ * of the hosts and/or to other VMs.
+ */
+#define KVM_BUG_ON_DATA_CORRUPTION(cond, kvm)			\
+({								\
+	bool __ret = !!(cond);					\
+								\
+	if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION))		\
+		BUG_ON(__ret);					\
+	else if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))	\
+		kvm_vm_bugged(kvm);				\
+	unlikely(__ret);					\
+})
+
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_PROVE_RCU
-- 
2.40.1.606.ga4b1b128d6-goog

