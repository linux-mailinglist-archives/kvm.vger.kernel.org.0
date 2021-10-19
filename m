Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0092D433BFC
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhJSQYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 12:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhJSQYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 12:24:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A049C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:22:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j22-20020a62b616000000b0044d091c3999so213339pff.16
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L4yVHgikzDElyFY7TNwsQ5Dm/gZ+cmTLoOsmdWNx03Q=;
        b=aoXMjZ980AD+ylhjlg8P2H0St1UJRq1NoGGOrvZb95GDGfuj5VdTEW/gFW0f10yyRw
         0bSRCEhMVzNpJw5T/+h44l7DybmDayc//cQOkwU8k2BqdGcEKcYOrbUJJHBy48PX80gU
         QfVOR7dTCVgv2ETYghwv/9W9WXktGx9hOsMNyBz8+TDfxx5gfP+nA2XPX7xyMdT4yROP
         9rFaT6b8aYkDt4+ormjnF5Iqu2jMfIp8jaHTOu7lyDS2JaV6tBTLse8cyHvnsWHFrF59
         3FppUw1aUu30phlNYAxV3TLK/5yapqUwynZ1MNZs4av0DGzsVdxAWJSOiD3wZMEkDKwr
         gg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L4yVHgikzDElyFY7TNwsQ5Dm/gZ+cmTLoOsmdWNx03Q=;
        b=ZTnuA+BbI3e4Q6jdaObojy2Kzdu0xGe7jFVRhbUdSfATaFGtDIZfSoUDoeBLWkObgF
         C8wqs6JvkFkoy0vpuC3Q1PKSjR43jSd5IudvuHFABT+Ju8Bcv5KpTolF2BLLuSZbmR7E
         Kz+sB3IKg0LYQW58uIchRy5HE+hnD/nGtUzMaBUp7vEhSnfoJ0wnO1rQzjNU45Oeosiq
         DV3mkYYsKpruwhLeg20I7Q0sLPl8BCqmUnPaKLB3OgH/0Ricpk1kDGB5Fmwbxlr53SjQ
         DxB5l3eMWTHIudqZ5lPd858VvLdMiURueZuQoFrr6tZ9gvVFtTNykQk0stvBQU4zGasH
         +zfg==
X-Gm-Message-State: AOAM530keoN28tIIQh/VvDQiRdPvxxHoU4EYdonyq1DVzJW15lL+jC6b
        YmHfD1nAYt7eHPUea07qnGSFP36BE+kmBQ==
X-Google-Smtp-Source: ABdhPJzNMGzZlMAulTGu8uFg4ygJNj3hXyiv6hCw7QH2UiDdTeeLUlt0coSArBXUBOHskxv3dr0qJuzb9T0yWQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:3ee4:: with SMTP id
 k91mr85591pjc.1.1634660552602; Tue, 19 Oct 2021 09:22:32 -0700 (PDT)
Date:   Tue, 19 Oct 2021 16:22:23 +0000
Message-Id: <20211019162223.3935109-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
whereas "leaf" is used to describe any valid terminal SPTE (4K or
large page). Rename slot_handle_leaf to slot_handle_level_4k to
avoid confusion.

Making this change makes it more obvious there is a benign discrepency
between the legacy MMU and the TDP MMU when it comes to dirty logging.
The legacy MMU only iterates through 4K SPTEs when zapping for
collapsing and when clearing D-bits. The TDP MMU, on the other hand,
iterates through SPTEs on all levels.

The TDP MMU behavior of zapping SPTEs at all levels is technically
overkill for its current dirty logging implementation, which always
demotes to 4k SPTES, but both the TDP MMU and legacy MMU zap if and only
if the SPTE can be replaced by a larger page, i.e. will not spuriously
zap 2m (or larger) SPTEs. Opportunistically add comments to explain this
discrepency in the code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
v1: https://lore.kernel.org/kvm/20211011204418.162846-1-dmatlack@google.com/
- Clarified that the TDP MMU does not perform spurious zaps in commit
  message [Sean, Ben]
- Use "legacy MMU" instead of "KVM" in comments to avoid comments
  becoming stale in the future if the TDP MMU gets support for 2m dirty
  logging [Sean]

 arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..fa918289c9e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5382,8 +5382,8 @@ slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 }
 
 static __always_inline bool
-slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		 slot_level_handler fn, bool flush_on_yield)
+slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
+		     slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
 				 PG_LEVEL_4K, flush_on_yield);
@@ -5772,7 +5772,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+		/*
+		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
+		 * logging at a 4k granularity and never creates collapsible
+		 * 2m SPTEs during dirty logging.
+		 */
+		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
 		if (flush)
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
@@ -5809,8 +5814,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
-					 false);
+		/*
+		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
+		 * support dirty logging at a 4k granularity.
+		 */
+		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.33.0.1079.g6e70778dc9-goog

