Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D533EBD75
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhHMUfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhHMUfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7044EC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:13 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y3-20020a17090a8b03b02901787416b139so8499574pjn.4
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JoeBI2FWWe8+qtj8allmUyPT7N7MOZEnV3MUTpN3vLM=;
        b=pBhQYrihngUQP1L2fJ7Wglg4jHdFlfk+6L3x2kncyyoRo3a9grH7FR1mn6yBaiQuDS
         iI45yTVsI62kzygM+2HIpQt2vE/dI3tKrtQ5zXSWtzj3AhbmumX3Jh6KkKnEZuf/qEQ2
         iVWJwg/e+0BQg944RKLzfmcvGjHnLJPrYc0BHFxnQF3jGSQZa7qazZZoO2bfmobHQ4kY
         S4vhQdlIzA1nNuQBXvEJ/YpBKcqJu8u7M5QF6kBObg03RLLrh8W9Y8Iqiw/eI41Pz3dA
         wp4RwBeldb6Y6fPn1VbSkjv+Cea/3G0TvJqLzf/MNInCODFuvpzVdjUTHy1pZuTW8c3u
         UVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JoeBI2FWWe8+qtj8allmUyPT7N7MOZEnV3MUTpN3vLM=;
        b=ICxznzTqrnwaaT7nhLD4ThSprmWZaSgj6LFyfoaEd0PBIrGvFB5RRG8E6d1pdfJm9b
         pbYV8cIfq7wzFyLqNEuLdbhk095vWdmB4ZxpmQbe+GX6yCkYS9R7A7G41yvifAgsVa0F
         HlIbkuB/YxXPSR09aG6W1KekfJushcY5HZWc/KvHGzdDITaP8U7EwTPYmmQO4gKpxbD8
         GMqKZ0KiT2h1uV9q7nDjZxCsCr/O3d3jY4eyPa3JPosaVlGI0QBa/leDY2AE8rq9WEZ4
         VhxRu5NSSUKGAS0VTXrXZBUHmH4Iji16DkLwtb2+UxKc5IWbfJcfwUizx5tv62i2q46S
         bHVQ==
X-Gm-Message-State: AOAM530HPeX10yPKLwGXjtsc/ognEclhdBY96UK+m3XoXDsWRaHZ0eq1
        x7by340rmO3xax4LwBHjhwOTZ001erk3XQ==
X-Google-Smtp-Source: ABdhPJy58eOU/sxqw96lvJaFBQ9WAqpU1n295RHWNSRZPgrhq+mQqlSQ36yp9bBOEJqVgAyPMsALz+Bg0Fl/oQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:1243:b029:107:eca4:d5bf with SMTP
 id u3-20020a1709031243b0290107eca4d5bfmr3426333plh.15.1628886912960; Fri, 13
 Aug 2021 13:35:12 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:35:02 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 4/6] KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_page_fault has a pointer to the memslot it can be passed
down to the page tracking code to avoid a redundant slot lookup.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  2 ++
 arch/x86/kvm/mmu/mmu.c                |  2 +-
 arch/x86/kvm/mmu/page_track.c         | 20 +++++++++++++-------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..8766adb52a73 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -61,6 +61,8 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     enum kvm_page_track_mode mode);
 bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      enum kvm_page_track_mode mode);
+bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
+				   enum kvm_page_track_mode mode);
 
 void
 kvm_page_track_register_notifier(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fb2c95e8df00..c148d481e9b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3776,7 +3776,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_page_track_is_active(vcpu, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 269f11f92fd0..a9e2e02f2f4f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -136,19 +136,14 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode)
+bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
+				   enum kvm_page_track_mode mode)
 {
-	struct kvm_memory_slot *slot;
 	int index;
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot)
 		return false;
 
@@ -156,6 +151,17 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
+/*
+ * check if the corresponding access on the specified guest page is tracked.
+ */
+bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
+			      enum kvm_page_track_mode mode)
+{
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+
+	return kvm_slot_page_track_is_active(slot, gfn, mode);
+}
+
 void kvm_page_track_cleanup(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

