Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E836CEA2
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhD0Whf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239075AbhD0Whe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346A7C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:49 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h22-20020aa786d60000b029027d0956e914so85707pfo.23
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dtfxclLFIBm6xVbo9OSqpPdh4KZCVh7xSZdF1u0sKXc=;
        b=eTO7SN1Gt4G354q/wrJKcHjRQS9pdTQywJzItPU2gesfRRbz0NV1NLuLguHnL54ljX
         VQwKBJ+WMYwKFZz7quFU1558YIGkHdw+ODQ/LAWrSNlxbd8Txsg5FR+Cjad3SoSM2WbV
         lpjXQDRYn6oDIKe1hfvdcxhqFkQjeCWmid8tS7oqOxqEZhbv8UFvEi2sHouTLgm9dHSq
         aoXTY/wxRPoi3Vin2stzZkptZC6pAZRHfwODV1YNU0U/Um2nYcUnDZjFoVA0T7Corg9W
         LYwoKgPdKmaUZ18xF5XsOMzPW5qSTetg4CbYD3iuN9tkMkl79iuVXq1va9vho25oVFmI
         mnoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dtfxclLFIBm6xVbo9OSqpPdh4KZCVh7xSZdF1u0sKXc=;
        b=e3Po9kytKHNPHGUggVMh+y5lrF/ceebsOPJza1O2Do+LzdNeaoP7lPQ1WMCHd9AD4C
         B4cJ+DJWSqadx/S88M9MQl/QQN1LpRS7F/2amlde+cDf0SuqSUjiu7TloRdqA408ikbO
         fxI99MhN0nXX1tNr4Ne5z9g6xNhW9PQOFgHxP2AHF4mW+MYJkivSLFQGs7efWhhdk9c0
         vYOTkB+jj+ZiHnuIuOnWoeGYOpucPxULtRAO5hitpsvfB4qvUBVh/95uDxX4q5XuuLaw
         K+rEJAwe8IRyMXup3EN9hNm2k47X9Q3S1H+dvgk2jeY9sGj7T43ELF1n09Z8YsRX+zVw
         tzjQ==
X-Gm-Message-State: AOAM5314gM5LlbLiM1nSVmDWKO6bxzTAI7ACmmxIRSvVBKz6R+TegazG
        ppzBt8Out52qoAjwr+HLfDah/o30Drrj
X-Google-Smtp-Source: ABdhPJwkKEJR2YImyKXGXiLxtnPy1zYqJmYxDX+MkuJ+PbPovvbvJVTuQikpN4iWhxlo+YFxHFyUrNaLNAhF
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:a62:1b4d:0:b029:253:ccef:409d with SMTP id
 b74-20020a621b4d0000b0290253ccef409dmr25212067pfb.4.1619563008656; Tue, 27
 Apr 2021 15:36:48 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:33 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 4/6] KVM: x86/mmu: Factor out allocating memslot rmap
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
2.31.1.498.g6c1eba8ee3d-goog

