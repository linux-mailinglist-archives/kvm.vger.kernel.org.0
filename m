Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8389E43344B
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 13:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbhJSLE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbhJSLEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 07:04:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74811C061745;
        Tue, 19 Oct 2021 04:02:10 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v8so13153780pfu.11;
        Tue, 19 Oct 2021 04:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqMhy1gFJqYHe4rVLAgrJaAnwOJLwZUqxNuxtFFoDtY=;
        b=UfVdgalT6/QdEQX8d/jg9GOqRzrWKnhsINKmRQVWsuZRfTK8VGqWFvWQwr/I4ys8X4
         nRVaO0MR5dQEum0WRUnG00e0+FcsMfVuVhnB+1nx2Cz9UCDRDNfkvDBrnCUlQr/fbVuQ
         AGXaNkahbdOQB8iizt/Vin5skU1SW1ktLJlK3VTweiI57dl02DBnNuDE4FJiX6IoKDE7
         BTnFc+rwQs9Bi6j3Re+kPEekpR0QnfR3gJZPWdsMUGHgrio14vSmzt3d4xT6HHlmAgoP
         Rxk7UcOjFV+UVL4R4yK6pOCjDneAbrn2zACH7wtbAWkJHTj2ZT/NlXsUJ2cM4u2gQn1I
         Ox7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqMhy1gFJqYHe4rVLAgrJaAnwOJLwZUqxNuxtFFoDtY=;
        b=buaETJcOcpTwLkkJP9UJZvhIUsVbRPw06MJBLK32sPeUn41Byji0zCXQPpV7KbAg6C
         QdQzMnDEyBRxhTfF5AP5or6tdf6eYQMQAtFzL/AJj9XecsjUP/wyYdAQUoobwPn9x8ek
         Qngy5Vn4Sxp+9LUt/VANvC3K1yS/AzNETp7akLWvcooB3BiD2FfCixNwbrJ0CIMcH2uA
         ehQzDZ9+zfpyjjV0+DGj3s8bJHQ/owr1X+cDk6knuw7p3VQZnmZrlmJrXPIS4nOx9/Kg
         kklJEQeRQZ85qs6d+wwlgjpbUi+hRILn1hFzgIgFs+OV0w136Rhkh2yhMgu+4t0uLSGV
         ALug==
X-Gm-Message-State: AOAM530SM5D00cH9cQz7u+IAvBxM5dQbjrSi2k/FZb6khtFXnz7qmkwz
        f7dNKldNy1NwaXrtdwdrLOES4ISyqh8=
X-Google-Smtp-Source: ABdhPJxgmyjoIGNkqJVbpW1c/q3fQdhlt0cooRb7ZJMmscHjxZfKh9syTYb1chwx5+jboX2ZTULJRA==
X-Received: by 2002:a63:b50d:: with SMTP id y13mr28040336pge.286.1634641329694;
        Tue, 19 Oct 2021 04:02:09 -0700 (PDT)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id mu11sm3038559pjb.20.2021.10.19.04.02.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:02:09 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] KVM: X86: Use smp_rmb() to pair with smp_wmb() in mmu_try_to_unsync_pages()
Date:   Tue, 19 Oct 2021 19:01:53 +0800
Message-Id: <20211019110154.4091-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211019110154.4091-1-jiangshanlai@gmail.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The commit 578e1c4db2213 ("kvm: x86: Avoid taking MMU lock in
kvm_mmu_sync_roots if no sync is needed") added smp_wmb() in
mmu_try_to_unsync_pages(), but the corresponding smp_load_acquire()
isn't used on the load of SPTE.W which is impossible since the load of
SPTE.W is performed in the CPU's pagetable walking.

This patch changes to use smp_rmb() instead.  This patch fixes nothing
but just comments since smp_rmb() is NOP and compiler barrier() is not
required since the load of SPTE.W is before VMEXIT.

Cc: Junaid Shahid <junaids@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 47 +++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ddb042b281..900c7a157c99 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2665,8 +2665,9 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	 *     (sp->unsync = true)
 	 *
 	 * The write barrier below ensures that 1.1 happens before 1.2 and thus
-	 * the situation in 2.4 does not arise. The implicit barrier in 2.2
-	 * pairs with this write barrier.
+	 * the situation in 2.4 does not arise.  The implicit read barrier
+	 * between 2.1's load of SPTE.W and 2.3 (as in is_unsync_root()) pairs
+	 * with this write barrier.
 	 */
 	smp_wmb();
 
@@ -3629,6 +3630,35 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static bool is_unsync_root(hpa_t root)
+{
+	struct kvm_mmu_page *sp;
+
+	/*
+	 * Even if another CPU was marking the SP as unsync-ed simultaneously,
+	 * any guest page table changes are not guaranteed to be visible anyway
+	 * until this VCPU issues a TLB flush strictly after those changes are
+	 * made.  We only need to ensure that the other CPU sets these flags
+	 * before any actual changes to the page tables are made.  The comments
+	 * in mmu_try_to_unsync_pages() describe what could go wrong if this
+	 * requirement isn't satisfied.
+	 *
+	 * To pair with the smp_wmb() in mmu_try_to_unsync_pages() between the
+	 * write to sp->unsync[_children] and the write to SPTE.W, a read
+	 * barrier is needed after the CPU reads SPTE.W (or the read itself is
+	 * an acquire operation) while doing page table walk and before the
+	 * checks of sp->unsync[_children] here.  The CPU has already provided
+	 * the needed semantic, but an NOP smp_rmb() here can provide symmetric
+	 * pairing and richer information.
+	 */
+	smp_rmb();
+	sp = to_shadow_page(root);
+	if (sp->unsync || sp->unsync_children)
+		return true;
+
+	return false;
+}
+
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -3646,18 +3676,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu->root_hpa;
 		sp = to_shadow_page(root);
 
-		/*
-		 * Even if another CPU was marking the SP as unsync-ed
-		 * simultaneously, any guest page table changes are not
-		 * guaranteed to be visible anyway until this VCPU issues a TLB
-		 * flush strictly after those changes are made. We only need to
-		 * ensure that the other CPU sets these flags before any actual
-		 * changes to the page tables are made. The comments in
-		 * mmu_try_to_unsync_pages() describe what could go wrong if
-		 * this requirement isn't satisfied.
-		 */
-		if (!smp_load_acquire(&sp->unsync) &&
-		    !smp_load_acquire(&sp->unsync_children))
+		if (!is_unsync_root(root))
 			return;
 
 		write_lock(&vcpu->kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

