Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD03494392
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357685AbiASXJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiASXHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:50 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D549BC06174E
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:49 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c23-20020aa78817000000b004be3f452a95so2423094pfo.19
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f0uwr62rbAHNSLgeo8auSREOnsbQjdEp+C2AD/si1YA=;
        b=CjI2dMMJIv+A3zoVcQPFWjDCrtC3xjc3ypT1b1yN0YnnNqq1eBKDZG2jNJDaigWYE0
         /I/STWQ9Ldv4WQiQpaIy9kJSQsr1Zknmd89NWR2BPEdAk00QM7N7PTe+JVLOR3XT2Cy+
         wn8c1eS9pQAigk6coGRgFDzi9/XMGg+pboe3M5OgfOntrsFaYmQSrmdnZRNO41s/yBw9
         3qCfyJk+x9dSzXVf8kQoCiYmzcPjkdyIMm5X1hpZbz6bBtLFaiJa0KL6wpzsBarx4vFr
         2/gwtIJvveCA4swVfLhiUEfwF1iXauYA3KNJiERFr6KkvEnx5UYDECSw5n4SXJaQaUL8
         DIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f0uwr62rbAHNSLgeo8auSREOnsbQjdEp+C2AD/si1YA=;
        b=c8S4CyEIzeVWk8Qlm+3IDBeaWxoK4zp3bp0Nt3O5+jgIyVIS/kw7Y34Sf82u7tShxv
         Hg3Xzz0parlXU+nsuR4KyAeGNM9LxoGgGH52Q+Y+gy+CUUXT2CCMnT7XhEqH+yr6Xz58
         2zrdYlO6C9tAaI5fnwf+q+nUJdWDzki7DSRflVtPQx2hHQ97+B4FvbdhvhF6H16VSKrr
         WCEHW1+Nqdz9R33n2sslCQoe4vO3I74aKDtBuev1EdEWM+DD4MS761RO9VOVMeB6/kNw
         8GGT86uAOhQKXeeadqdfqtKJn7cmGJXgiiaBMbOW2hURygUQ7j71aYXIp1vZyrIap/6p
         y29g==
X-Gm-Message-State: AOAM531Ak0lFLKIlmkdl1qiYzlQc6RtK/TIsBQb9fLppBnWnF1DqXwJo
        v7WG2xIiu6XZdUxxK7KiD/yyyxNd846hkA==
X-Google-Smtp-Source: ABdhPJwb25CSinPWl5zCagVYhNF6QLlZuGdWkoCnfltU123tFBbwwNnT4H0K4OfAcVQDJdhkSYtqenbTUkhzLA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:5996:: with SMTP id
 l22mr7048761pji.27.1642633669310; Wed, 19 Jan 2022 15:07:49 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:22 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 01/18] KVM: x86/mmu: Rename rmap_write_protect() to kvm_vcpu_write_protect_gfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rmap_write_protect() is a poor name because it also write-protects SPTEs
in the TDP MMU, not just SPTEs in the rmap. It is also confusing that
rmap_write_protect() is not a simple wrapper around
__rmap_write_protect(), since that is the common pattern for functions
with double-underscore names.

Rename rmap_write_protect() to kvm_vcpu_write_protect_gfn() to convey
that KVM is write-protecting a specific gfn in the context of a vCPU.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8ed2b42a7aa3..b541683c29c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1421,7 +1421,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
-static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
+static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 
@@ -2024,7 +2024,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 		bool protected = false;
 
 		for_each_sp(pages, sp, parents, i)
-			protected |= rmap_write_protect(vcpu, sp->gfn);
+			protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
 
 		if (protected) {
 			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, true);
@@ -2149,7 +2149,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
+		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
 	trace_kvm_mmu_get_page(sp, true);

base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.35.0.rc0.227.g00780c9af4-goog

