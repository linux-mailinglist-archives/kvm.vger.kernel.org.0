Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F97C47E95A
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350662AbhLWWYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350477AbhLWWXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:55 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9C2C06175A
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t7-20020a17090a5d8700b001a7604b85f5so4024043pji.8
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cBF5OK3OFSDwub1dlVAqrTIj8KZrSkeas4HxldxyG2U=;
        b=TLf5tBuDqLRcIFVQFfDb6uV/HMlwQlGQb4qRYPHmVkJLRl8aHqeDSO2sXi4vEwJvoR
         /aqESeuhQF+AcaTBTarCLB9tpKxJdLjK+Zxyg7RGbKu28YTtim/Efk9y0bXlTCL1AUcg
         dk1Jux03qvlXIMR7+sUlTvBUivPkQYP3GIjhKf0AxLp8TtfB5u3VS2yRiY/tIyd+fp6L
         T0wbTq0/y8EQu3Jklm3itVEfMgqAzqv8T2feiZR41DESCU56m3eloHruYSq5bm+Wp/BB
         xwAgCzmeY7Cjikn/+K+AFpJu0L9kiMbuUT+HRNCuolZr4OlyP5jLJEwgdadZhr9HM7/c
         c0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cBF5OK3OFSDwub1dlVAqrTIj8KZrSkeas4HxldxyG2U=;
        b=BtRwBEDPsYo7dmSq5JRmZuDz6xDOdUH8Loq6ZE/YevXvwKCK2hgtZpFxHGAJ9ZPNja
         rFY/Zs6WTbx5LcEnj/I+cV4gd0apdfEw2RMS4QMvIXUmlgYGnCWt/Li4pdlIG6xTq+Jw
         nnhD9m4/n9lg/BBfPxFDDIDL/B30OkZNY5xeX+1l2Z4Vm34blm15cmjQdB33tPl/VRF7
         /TItz2RSPY/Gc3nTnxhA+h2q5Yt61QQVMXZCVjc4BEZBeDsLEWInZJ22CjK/yfc9uoFJ
         1eflnK+g3fvZSkHBR7sT6fW/Dw+54zIGpJWlgx+cEA1LwrC+gjnckrpXLeIW+gKmoVpC
         PmDw==
X-Gm-Message-State: AOAM532GtSS2eIKW+0hanpI2C5zLtz9gxZsKyVwvKPnA9H5J08MrHuFK
        rnL4OHCDxPymFWkJnyrGjQi3Do1pzD0=
X-Google-Smtp-Source: ABdhPJzugLke9FkvgxxgSQ+09nGN4pAmXPvlEe1oTl20wsMFlwtYzirQ5F8h7APJb64Aj2880xUWr9DMwe0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cc7:b0:4bb:1511:8401 with SMTP id
 b7-20020a056a000cc700b004bb15118401mr4405550pfv.44.1640298233370; Thu, 23 Dec
 2021 14:23:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:55 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 07/30] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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
index 94590bc97a67..6549c13e89d9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5100,6 +5100,14 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
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
index 4f5c8e7380a9..66b75c197c94 100644
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
2.34.1.448.ga2b2bfdf31-goog

