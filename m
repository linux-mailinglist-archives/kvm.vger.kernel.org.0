Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75C349F8E
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhCZCUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhCZCUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC321C0613DF
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:20 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id y22so5198936qkb.23
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VHU0N9D6gGMpxInyb7jHcZ3k9rh6QrJlzBumSAqwO8c=;
        b=KYqLsSM1DKlBrG0n9fQu+QMpt6MzQ+SF1jMhC3bYjxbl9xg4rj1BheBGS3DzK7UmeZ
         lEiUMH+TeBdSLBPrIvxR3WM8v0OjxY1qKJaVm29X0psiCjFVMfGvfr9a6gzWD5VEwqyZ
         PTrYiDzsZw/v2/D39aFUEmHMnVwwN61npU9LP0PYtwpLM4aTVEN8sgSgy2zcL1SLjU+s
         cNlLWLnvWQOuO9HWx+Er8e6OJdhijecdyBbriyZu1Is1pGK2S2+5wuqQOFlxCFoM/xsU
         eQR71XOtqIazbUL52wALyTWqjz+bTXi58NvjtGUL28QVGyfYAPq06SdoWnsvNDwuuaFo
         szxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VHU0N9D6gGMpxInyb7jHcZ3k9rh6QrJlzBumSAqwO8c=;
        b=rRaQjTGyot6Z2IK/rxQSH9wJpXTjjjXE3QxSPLe9BB2sMdXuN7X68UURFIxPlGlNVz
         YB+7m1AuAMXuAnmbJNUmpIuQZN1oql2+qK6gBDE5/Urt3OZATzpe3ZEcTZrUAnYKTaSY
         9nwAXJj4ceGjvpZDIWDD6U6n5/M9akcuw2BmBL0wJ5mz5l3/eVvRXoThFVGXbVUG0laT
         LmMRbUeDj2xxGbgsiCT1IJJjcM9NXv3182AFjZqb5GdZ2zjo4JAIXi6ocE6xTAWnggNS
         J1A/1dRdANTnSSOQgc8NYJCsAU/L1XnHQxOX3EwnaoFFhsiQIiEp3xAl6NzT7CyBbQ6w
         gxVw==
X-Gm-Message-State: AOAM530zaEID1pjegEHo8gZizOrGFMuxV9KMydWDu3qKuZCjscEMQqJr
        Fzv8fnlAT+aNnXJcj5NnBFPSZTISuPw=
X-Google-Smtp-Source: ABdhPJy0HL2v9roIhKh4ewViQpaZol5eRjI0NnfVDZGOKQXEnK2GcjlR+0ZiLbksT/yFSNKZXmeXIxYd4GQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a05:6214:176e:: with SMTP id
 et14mr11147707qvb.35.1616725219917; Thu, 25 Mar 2021 19:20:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:43 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 04/18] KVM: x86/mmu: Coalesce TLB flushes across address
 spaces for gfn range zap
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gather pending TLB flushes across both address spaces when zapping a
given gfn range.  This requires feeding "flush" back into subsequent
calls, but on the plus side sets the stage for further batching
between the legacy MMU and TDP MMU.  It also allows refactoring the
address space iteration to cover the legacy and TDP MMUs without
introducing truly ugly code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37e2432c78ca..e6e02360ef67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5227,10 +5227,10 @@ typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, int start_level, int end_level,
-			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield)
+			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield,
+			bool flush)
 {
 	struct slot_rmap_walk_iterator iterator;
-	bool flush = false;
 
 	for_each_slot_rmap_range(memslot, start_level, end_level, start_gfn,
 			end_gfn, &iterator) {
@@ -5259,7 +5259,7 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return slot_handle_level_range(kvm, memslot, fn, start_level,
 			end_level, memslot->base_gfn,
 			memslot->base_gfn + memslot->npages - 1,
-			flush_on_yield);
+			flush_on_yield, false);
 }
 
 static __always_inline bool
@@ -5490,7 +5490,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
-	bool flush;
+	bool flush = false;
 
 	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -5506,14 +5506,13 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
 							PG_LEVEL_4K,
 							KVM_MAX_HUGEPAGE_LEVEL,
-							start, end - 1, true);
-
-			if (flush)
-				kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-								   gfn_end);
+							start, end - 1, true, flush);
 		}
 	}
 
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+
 	if (is_tdp_mmu_enabled(kvm)) {
 		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 		if (flush)
-- 
2.31.0.291.g576ba9dcdaf-goog

