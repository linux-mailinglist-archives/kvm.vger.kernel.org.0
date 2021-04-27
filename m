Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E371C36CEA0
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbhD0Whc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbhD0Whc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BFC061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n11-20020a25808b0000b02904d9818b80e8so39100700ybk.14
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y8ULK4WwYoTcErFzD8U7DpN6B10FYVsEEpVfzScuJlc=;
        b=WVq8MsDkNtUfNVyp+bs9PvhqgqX5BckvCjwHHBkHNrInXaqfhVhtQlDrok6zJDcxqS
         BIFhZthAH4c5PsSuIrwti22XDPVQ0XMZfWL0MFTTWhoxaQnSl3MTMi74B3LoCzVXYv3P
         5L72cEW9AXTQwtZM2Jd9ymLgJ6Yz7MCYLHGJ0C9AqodJBXPxs8u0aUtB3VAWqtkXxAc/
         xUaYCf8RcFRwbv+CRFR5LxxCcFwEnt9I1C+migtuAz+IPPimNaMkgBwmO0gRfFmtn4CU
         TnWKorqPYTR4FTCqSsYIpsMzlHl5D/wiDJTsnN4qG8xzQRpnZLygFO7kV+6CDccdOFWh
         6fWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y8ULK4WwYoTcErFzD8U7DpN6B10FYVsEEpVfzScuJlc=;
        b=OTYad9jbswYeFgWwqGVQWOGV9kcyXLNLIxpouXRSXg1HwuRVTleqGw9rz5dCbahjMH
         sjiLe6SUdd5scfoM8CMsq9HbG6olE5I12UJJNWx9id2yB+SgqgCEVAkf+NQjvozWYw2O
         r6euf2FdZESCZGEpJo3VKgT/akLgP6u7WQaULjfVUGzAhVQEXRlJK9+obyyISFpJMZ2r
         ijjs2tDD1FbTKVxND5J/D/sOPDY5nsgh+YysNSBgDmngd2JboVALFqhe3YQB17VTb32x
         5iG7zAs9EklonrPZCO9XG2hSm0QO6NUSTBi4RcXoWMUpeRjPeM1r8HhoVS/zFoWFcBVW
         oDRw==
X-Gm-Message-State: AOAM530ycRqg3ni88sWiYvQn7zVGQ7bx7ZrKfjeUZA+TYdny5IcYYJwv
        9cj4p2xJC8Rc7sGcEFhDJa5m6weVDhsx
X-Google-Smtp-Source: ABdhPJzIv6KiFuFYaHtzUXidZsSKOm+bQHFRyYycbWtur/Sruv8TBwpKwk7zPfLyKzen5CndaH0iIhEoF/Af
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:a25:5d1:: with SMTP id 200mr17623998ybf.251.1619563006048;
 Tue, 27 Apr 2021 15:36:46 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:32 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 3/6] KVM: x86/mmu: Deduplicate rmap freeing in allocate_memslot_rmap
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

Small code deduplication. No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf3b67679cf0..5bcf07465c47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10818,17 +10818,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+static void free_memslot_rmap(struct kvm_memory_slot *slot)
 {
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.rmap[i]);
 		slot->arch.rmap[i] = NULL;
+	}
+}
 
-		if (i == 0)
-			continue;
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	int i;
+
+	free_memslot_rmap(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
@@ -10894,12 +10900,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	return 0;
 
 out_free:
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.rmap[i]);
-		slot->arch.rmap[i] = NULL;
-		if (i == 0)
-			continue;
+	free_memslot_rmap(slot);
 
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
-- 
2.31.1.498.g6c1eba8ee3d-goog

