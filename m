Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E36E473838
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbhLMW7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244112AbhLMW7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:41 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A049C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso10790035pjb.2
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VdGaN5L7OJ2U0UndQcZO7SPHQBeyLglC8eNYzsCUojk=;
        b=WwCQ6wfjwENs0PeaEtri9xJS77rN0uifxOv5MLSbmdJv5Bdh9V8Gd8i3Sv071LoFym
         mVNO5j78asLUedsxb0P7D3tlYmTmstqTEd0XYh0Xqeo91EJUb3c0UiXXyn2ElZGh1Gm7
         ZfVO2Vbo+ZYMQYbyXBfCTu0N0hPOH4lLVlH6OJ0A3nee2DZdY+EMw5vgYkEvBePyEImj
         XTN4RowSCy3C8/+Yx4tHSZWc+LwwlBhmuzr6BmQ0j9x4hH8eQRjGqBUPpLy8fEI++oQA
         /1kR62t7jDgCkqtAfoO1eu6ELEPW7TNxtzk0S0izLZdruR/YMJSIBd2M9nDMOr8+DpQd
         Cqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VdGaN5L7OJ2U0UndQcZO7SPHQBeyLglC8eNYzsCUojk=;
        b=QeLyDldtuSGuwl0J07xuKphSvrD5IFME+XSqK4DeKSPLY/LCM+SCXFgDSDGoIhcWHn
         34t70259dy6I1qo9IzZFJnyEThHEcCs1fyotq3WQNF+g1XMEfnUanKQs0X3C9RyEmPQR
         4ONGSkTjqxUV61DmDdiKOP0D6MAUN9MZMwmUMcSPJn42NGplL1nhkCwyXy9s2T5mcS7n
         Y6tEm0BGFEaR2T5Q+PrY7sn1B8GJTlN5ZARnWhA7s7aysen35cvoCx9d+HVhea3hmwSP
         TN7wfjoJwJbJrauZTq2Rin+xwlftbwE4zW4D2TQEPAc3AO4tDvPaICOKLj5Rng09WVlr
         aabw==
X-Gm-Message-State: AOAM533GdUdM4Y3n5jHKVwmADSbZOPuA/UmTJ+ER2+IJymsmbNwB1s5Q
        K5mDw+bIC7Iiux0czFk72YtunxIXjV7pAw==
X-Google-Smtp-Source: ABdhPJwMeVajrFBE90cPxlJ/0DxK5HsgOXuYwfYm0L1wrQtN9xwxAt6wYplA6UhkNc0vp3gnVuKh9mpBnQy3/g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:6703:: with SMTP id
 b3mr1178490pgc.18.1639436380650; Mon, 13 Dec 2021 14:59:40 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:17 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge pages
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

Add a tracepoint that records whenever KVM eagerly splits a huge page.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index de5e8e4e1aa7..4feabf773387 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -416,6 +416,26 @@ TRACE_EVENT(
 	)
 );
 
+TRACE_EVENT(
+	kvm_mmu_split_huge_page,
+	TP_PROTO(u64 gfn, u64 spte, int level),
+	TP_ARGS(gfn, spte, level),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, spte)
+		__field(int, level)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->spte = spte;
+		__entry->level = level;
+	),
+
+	TP_printk("gfn %llx spte %llx level %d", __entry->gfn, __entry->spte, __entry->level)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index be5eb74ac053..e6910b9b5c12 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1325,6 +1325,8 @@ tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter, struct kv
 	u64 child_spte;
 	int i;
 
+	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level);
+
 	init_child_tdp_mmu_page(sp, iter);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-- 
2.34.1.173.g76aa8bc2d0-goog

