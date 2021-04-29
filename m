Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5EE36F1DF
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 23:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhD2VTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 17:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbhD2VTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 17:19:45 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93634C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:18:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v15-20020a05620a090fb02902e4d7d50ae2so7137675qkv.19
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V/i9JLKn2bODnum9/FR/aKnhuikAVXFu3BpBHLyrfLg=;
        b=I9jyJqDzeQ9s48jJcFT9qziZLErEBCH11Qi47JBM9REY7FJl3TRaDRh686S2S0LIZm
         0ryfFDQdWCmESL7K3WFI2F8Bvvfqc872VR+LFCip039aSna3fcOw+08XHdeCV5iAruU7
         Mm/r1KmyO438ITRn1YuzUvLJlFzIOM9MxiyFIdxKJTcCQ+evKkQxTpNMjbElj6Whi0Ss
         g7/EoWAAIwU43ifUhHvg0oN8RgAuH6IeaBmQGDY5CHemIbOhzGQ2X8ZdTq1fRbQuEhHJ
         nuWv/On0GGu4QyS5FY/+NL9Znd6yD44zp05zyNrgV6O9DPJrN3k11MoFICA32im5ACKj
         EclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V/i9JLKn2bODnum9/FR/aKnhuikAVXFu3BpBHLyrfLg=;
        b=IMxXsXEOYkNrTfPsfUdtDmaRYqqz/qgOdvQaHoSQIKmEHxaD+0W/SI+vcgzmGoVX99
         lljMglDdy43B/A12ElChsNAG4NMUEvZJ4aZGx5US15inhb9NLn2Tp0ERL3NZ6kObhOoC
         s6cnFTHlWVSCsKas4UnBM711XSODfbDl6eVH2b9+48aeoqlUjzKmK1Cm9r+RO31X/nz1
         z62G2fjnBIrTllD2m/qVmdI7CRzgem6wMHtR3jluMUjnkOucD+ekTyWnPhyZ+/H1EAAp
         fabw+kdMhwSOY49cTCEMr+h0fFeR8/j34eRvmtaxUHJPufLqPbKFDSHXG2R2USh37axG
         zTrw==
X-Gm-Message-State: AOAM531AKjgkOz7wMjFgoCWx2e+oa/1CZD4+sYGM8vpxnq5agtTy9XqX
        MuAbGfdDoN6KC60smG2bxVyIe6lnGp0K
X-Google-Smtp-Source: ABdhPJxek7EoJFLQCq2VFF2SvgbuPWfNa8YiGHrso7Hyqp+gn4CW1qGlf3Ii9UWik9Ydi47ZbF1cYzuB0thw
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:1a18:9719:a02:56fb])
 (user=bgardon job=sendgmr) by 2002:ad4:518a:: with SMTP id
 b10mr1895601qvp.19.1619731137789; Thu, 29 Apr 2021 14:18:57 -0700 (PDT)
Date:   Thu, 29 Apr 2021 14:18:30 -0700
In-Reply-To: <20210429211833.3361994-1-bgardon@google.com>
Message-Id: <20210429211833.3361994-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 4/7] KVM: x86/mmu: Factor out allocating memslot rmap
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small refactor to facilitate allocating rmaps for all memslots at once.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bcf07465c47..fc32a7dbe4c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10842,10 +10842,37 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
+static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
+			      unsigned long npages)
+{
+	int i;
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + npages - 1,
+				      slot->base_gfn, level) + 1;
+
+		slot->arch.rmap[i] =
+			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+				 GFP_KERNEL_ACCOUNT);
+		if (!slot->arch.rmap[i])
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	free_memslot_rmap(slot);
+	return -ENOMEM;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
+	int r;
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
@@ -10854,7 +10881,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+	r = alloc_memslot_rmap(slot, npages);
+	if (r)
+		return r;
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
 		unsigned long ugfn;
 		int lpages;
@@ -10863,14 +10894,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
-		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-				 GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.rmap[i])
-			goto out_free;
-		if (i == 0)
-			continue;
-
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
-- 
2.31.1.527.g47e6f16901-goog

