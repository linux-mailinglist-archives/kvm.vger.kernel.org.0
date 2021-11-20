Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7B5457B97
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbhKTE4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbhKTEyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:41 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434FDC0613FC
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:04 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso5036122pgv.22
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=W1e821S10dA3tRu3JubnOlDRoE4gbxm/s9ZQHPdVYw4=;
        b=UyITxBU0Krx8apy36Y7bQ6lNj4T5yT0O7gdc0rC+T5bY6Blwo2Aw036vTYjkPbLki1
         pGI2K85dQZgT26KA7n44a7UlZ0A+kf0gziBFiqH1M58ksTP6lfVfZ9/rjGYMuYUyIOq6
         yEWAZZKuSgFmVfFqMAcUDxmUPWbukLj8b3Mr9yByTeowzWSSOHXuEbS9KFBiZNUV0BOj
         VhCGojxAOiufs3IfaNf+Hd0axzhI60cWBz57UMKQVlmViNP/OHsLsIgCeD6qx0cv79Eg
         STU0dTop70Fdy13JXwwMD7bO7gu8OqhLMpOnPzajiKnbJeVqcVadpKea4r8323BLf5C7
         xZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=W1e821S10dA3tRu3JubnOlDRoE4gbxm/s9ZQHPdVYw4=;
        b=s9C0z1XDr22aTnE9FeOdVn52ln678/UvscBm91VozjTJZ0m5CVk8mNWgXzD5h/3SZR
         cqs31EVTdGUgx5k+rGAqmRyC7cYsmj/yctJIDd27SHz8wFZjna5cGW/aTjGrsC17attF
         6KfmGe79K9jYzcpJF+9deyBxDBAWh/wSVEH0uCgXY/gTB1g5SvD8kfWQ6itmmzYJ31is
         0J9QWjP4JyumKRi8OWHLEJ+qGVlGUJtHOx9uq7o/K1/kYF1W/i04fdhFyg2yPRkMc3Mh
         cohNhABzA2CJtv1kZDS3Swqa5jfim5DJTVDyWawoDNehY1kfcNlVxzzxs11EuNJrbwr5
         S89w==
X-Gm-Message-State: AOAM530lzYFLuG6HHcsgDPqTH6C/TRTYScqyeyd9CZAZ7VFx6Iu3vXI/
        oiwFuH25MkqOINu14mTV8eFwuh2ir2A=
X-Google-Smtp-Source: ABdhPJzWuYAKHnLFRaaNUkFfvrawyTy5XLrpWlJBgVpJwPZZ0ajQql9OMVp+X/oKIaBYqLxqLH7zY/BrFio=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1308:b0:4a2:75cd:883a with SMTP id
 j8-20020a056a00130800b004a275cd883amr60686150pfu.84.1637383863797; Fri, 19
 Nov 2021 20:51:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:24 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 06/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly ignore the result of zap_gfn_range() when putting the last
reference to a TDP MMU root, and add a pile of comments to formalize the
TDP MMU's behavior of deferring TLB flushes to alloc/reuse.  Note, this
only affects the !shared case, as zap_gfn_range() subtly never returns
true for "flush" as the flush is handled by tdp_mmu_zap_spte_atomic().

Putting the root without a flush is ok because even if there are stale
references to the root in the TLB, they are unreachable because KVM will
not run the guest with the same ASID without first flushing (where ASID
in this context refers to both SVM's explicit ASID and Intel's implicit
ASID that is constructed from VPID+PCID+EPT4A+etc...).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 ++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31ce913efe37..3adac2630c4c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5098,6 +5098,14 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_mmu_sync_roots(vcpu);
 
 	kvm_mmu_load_pgd(vcpu);
+
+	/*
+	 * Flush any TLB entries for the new root, the provenance of the root
+	 * is unknown.  In theory, even if KVM ensures there are no stale TLB
+	 * entries for a freed root, in theory, an out-of-tree hypervisor could
+	 * have left stale entries.  Flushing on alloc also allows KVM to skip
+	 * the TLB flush when freeing a root (see kvm_tdp_mmu_put_root()).
+	 */
 	static_call(kvm_x86_tlb_flush_current)(vcpu);
 out:
 	return r;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c575df121b19..981fb0517384 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
+	/*
+	 * A TLB flush is not necessary as KVM performs a local TLB flush when
+	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
+	 * to a different pCPU.  Note, the local TLB flush on reuse also
+	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
+	 * intermediate paging structures, that may be zapped, as such entries
+	 * are associated with the ASID on both VMX and SVM.
+	 */
+	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

