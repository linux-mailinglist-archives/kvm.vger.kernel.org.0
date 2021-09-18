Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FFE410279
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbhIRA6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243791AbhIRA63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A25C061574;
        Fri, 17 Sep 2021 17:57:07 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y4so9201429pfe.5;
        Fri, 17 Sep 2021 17:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcT9myNkcQ8lo8kKG4vlWc7FUWKKPEuPnBaujt5wbLs=;
        b=VuzmkhwIsHD/1cQVkVnlRvVa6wszyuxvL1bAyDYGt6mLm+I3+hoQbvNOnGahOckyiq
         TmowLVn6bdjEhDlrDAGWVCQjD7GR49pNHgiCfFpkg+zVSQJwa7CfrIABwADQrdyHCvKB
         OetrAqslCDAuuEybEY/AakpsOMaQwMbZEPBeniGtWLf7uYoPeAcaNBBcwjEdOxJxI3w3
         qBUyLK7p77O+wM9xaSE+nsEBJTRkIZVsSgfj5befOE/m50b24Kh3FkQCHEjFWYxsjSDn
         MacZKzl0aaGrTfQ54Zdx8ZfVS4lhmdmvlwW11kFKwts/AuY48JaOhj8/lc1fN5dA5852
         XzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcT9myNkcQ8lo8kKG4vlWc7FUWKKPEuPnBaujt5wbLs=;
        b=2Bp9jDbsf3DM3Ld7xoFpkeI1Xx6UgYTm7I+BPG4FtUT+V9yQBmXXyuSoAH95U5glMP
         GLRI2eEnJACfBbWvjOKZR47ekDo42njcd0EmUpuiZKYDM1t5Cq+NsQwHm2AIlmdmC8SG
         ybjZ4dJwNmz3ei1VBkduSFVXQZo5O2+JAwYtMaGu/SMfMlqIuqpvxgUKmJ7j6/ikxuQ7
         HZ7mAvvjXvGb6Uj4bBGY2YCALgB4h7gFNhsrYEypA2U4wImZxsAhZvdcN6TaLWcxJp01
         Iw5TxOqpJ/SHFFL3gs3WnXCAYeSI6yn6riCm5bBLxqeJObrrlhtkoJ0bxnN/iUNqlmvi
         GvOg==
X-Gm-Message-State: AOAM531ByMdLIH6GW4GRUDVsgP7DPvFLoXq0st9MsSPBmzq1YZV7qwDG
        9zuUisRlE/yXF+yMUyFWAz9zYBIz9n8=
X-Google-Smtp-Source: ABdhPJwqogZYI7b4iUZKjlhEYWR/WIcLhVdmgJob+S6PI9w6FFvb99yJWPRRDRm6L5ssfehs0Qt34g==
X-Received: by 2002:a62:84d7:0:b0:438:af8:87ac with SMTP id k206-20020a6284d7000000b004380af887acmr13700360pfd.56.1631926626407;
        Fri, 17 Sep 2021 17:57:06 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id t68sm7504330pgc.59.2021.09.17.17.57.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:06 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 05/10] KVM: X86: Remove kvm_mmu_flush_or_zap()
Date:   Sat, 18 Sep 2021 08:56:31 +0800
Message-Id: <20210918005636.3675-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Because local_flush is useless, kvm_mmu_flush_or_zap() can be removed
and kvm_mmu_remote_flush_or_zap is used instead.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f40087ee2704..9aba5d93a747 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1928,14 +1928,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 	return true;
 }
 
-static void kvm_mmu_flush_or_zap(struct kvm_vcpu *vcpu,
-				 struct list_head *invalid_list,
-				 bool remote_flush, bool local_flush)
-{
-	if (kvm_mmu_remote_flush_or_zap(vcpu->kvm, invalid_list, remote_flush))
-		return;
-}
-
 #ifdef CONFIG_KVM_MMU_AUDIT
 #include "mmu_audit.c"
 #else
@@ -2029,7 +2021,6 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
 	LIST_HEAD(invalid_list);
-	bool flush = false;
 
 	while (mmu_unsync_walk(parent, &pages)) {
 		bool protected = false;
@@ -2039,25 +2030,23 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 
 		if (protected) {
 			kvm_flush_remote_tlbs(vcpu->kvm);
-			flush = false;
 		}
 
 		for_each_sp(pages, sp, parents, i) {
 			kvm_unlink_unsync_page(vcpu->kvm, sp);
-			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
+			kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
-			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, false);
 			if (!can_yield)
 				return -EINTR;
 
 			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
-			flush = false;
 		}
 	}
 
-	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+	kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, false);
 	return 0;
 }
 
@@ -5146,7 +5135,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	int npte;
-	bool remote_flush, local_flush;
+	bool flush = false;
 
 	/*
 	 * If we don't have indirect shadow pages, it means no page is
@@ -5155,8 +5144,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
 		return;
 
-	remote_flush = local_flush = false;
-
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
 	/*
@@ -5185,18 +5172,17 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		if (!spte)
 			continue;
 
-		local_flush = true;
 		while (npte--) {
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
 			if (gentry && sp->role.level != PG_LEVEL_4K)
 				++vcpu->kvm->stat.mmu_pde_zapped;
 			if (need_remote_flush(entry, *spte))
-				remote_flush = true;
+				flush = true;
 			++spte;
 		}
 	}
-	kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, local_flush);
+	kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, flush);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
-- 
2.19.1.6.gb485710b

