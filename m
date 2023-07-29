Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3745E767A29
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjG2AuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbjG2Ati (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CBA4EE1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:49:10 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-686c06b9338so2227407b3a.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591666; x=1691196466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LOrLJZZ+Gkhi9DkbaZIQBIYsMHKPcX3CcfpaZ/5IaME=;
        b=wJPC2MvJipPsQhRwbozBA3HvDrT0a5QCegS41zV5HxoUZ0Y6ijfEwm+l6nci1rioY8
         hJvaIEMoKCVJicvr9/kZ/an8mz77VT84yBHhpPuT8o84KkzdLNC7eeOpFUjugL86uoN8
         RbH4OMwhrRolWZ53p5VBH1t+MNMyrzktWrZPoM891QxOvYGn3A45JjlLbhrqePQO2emM
         /DQ4Ltj+KKkKQaoXChzdo08lSUNXUEJWG/vBjKQEXf66jFhqn1A9yHDuiRHichM4as62
         nWjotbjNiYZvO1RMYdMKmOj2y9Gh1m3SvGyZIHBp6m+07bn1x6JGJA/cTeBoKTkH2mz1
         CZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591666; x=1691196466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOrLJZZ+Gkhi9DkbaZIQBIYsMHKPcX3CcfpaZ/5IaME=;
        b=ccyiE1f7x4mAT7R0Mm5DkCozmDjEt+b0TKyaKox8FhsNuDs5xj0dQbtjHHDQEHk3Im
         agy8fK8lxiDHTk9ZKQB3pZn88wJdZpUt0SleKMuEzWMWwVxvwV243u1JCafjL3pjZLdE
         LyN/Yl+Q5KY2vQEiMhS2QGY9jWQp3c45MwBLh2gheLkkSbKtNyhJPduw0oitMqz8rF+U
         PMTZSAOSV2ozLXuR6HnP6QjLhylZ94X8HaCrsYbD3Ne47lJ0u7aE1sm2l0Pi4Hg4rCfi
         Ien+X6t3SbCuD9mxfYHVPS5XQw7F4+bd4gB/RxyAMOzk6IIA+E86Hja48tr9MjImgyWt
         G1rA==
X-Gm-Message-State: ABy/qLb9j3ws3ADioejb+ICwpyt34Xt0hSaqHpYavAjqkQXlTDlOp+Kk
        KrUTLGAOvpGuyv6P+BYPcaxUMf43Nn8=
X-Google-Smtp-Source: APBJJlEGkkxWtk+pcvT/+v29DD26kZ4dbFB9hQthIe8G8eEYJoAiBrTNxlCrGTM/KOXSKaYkEC6utENJqnU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1382:b0:686:6234:5537 with SMTP id
 t2-20020a056a00138200b0068662345537mr22082pfg.1.1690591666681; Fri, 28 Jul
 2023 17:47:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:22 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-13-seanjc@google.com>
Subject: [PATCH v3 12/12] KVM: x86/mmu: BUG() in rmap helpers iff CONFIG_BUG_ON_DATA_CORRUPTION=y
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 21 ++++++++++-----------
 include/linux/kvm_host.h | 19 +++++++++++++++++++
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 67a25c957a16..92a3f40a6bb3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -977,7 +977,7 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
 	 * when adding an entry and the previous head is full, and heads are
 	 * removed (this flow) when they become empty.
 	 */
-	BUG_ON(j < 0);
+	KVM_BUG_ON_DATA_CORRUPTION(j < 0, kvm);
 
 	/*
 	 * Replace the to-be-freed SPTE with the last valid entry from the head
@@ -1008,14 +1008,13 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
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
@@ -1029,8 +1028,8 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
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
index 9d3ac7720da9..cb86108c624d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -865,6 +865,25 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
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
2.41.0.487.g6d72f3e995-goog

