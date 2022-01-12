Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7EC48CE1F
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 22:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiALV6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 16:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiALV6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 16:58:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63335C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:58:07 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id k93-20020a17090a3ee600b001b32ec86e10so4378286pjc.3
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jds4qDhtV7B5pRTnfx8zNLMUxNbRQcfFUwzuns0Zxls=;
        b=Pv2r0o5i0bnuRKx9bnBXlVgFTqtM/kj3CugCNBQPK8xV1ghT6wZkJvBhbIFK6LpyUS
         t6koXD47MYeN9WUN+3ndiwGHbV2NfXPyc/Cq1Ue35+pEd78Cr0uLjt4UaHKKTwLXDmUz
         tswmE8iSKvf1l1MHP2uFCGUlX2aqPECcOonShjGLMXlXTXTsoID/4xHE0rn6ePkJja7N
         O+stvEifxcG1RSiw5MWkx/fB8krlTJCfny+Ew+6H5QWDMoVz6ZIYXtIVmjGlQIwCdLus
         Wvsdur9JBO8+nBgpyuNk92ugsNgxhJODjpakbAJjtVfD0k9gUiSvcKgcrNFaiXM/ExXM
         PyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Jds4qDhtV7B5pRTnfx8zNLMUxNbRQcfFUwzuns0Zxls=;
        b=tRenbqI05Z3yptH8qBe21RZm+5589KJVsT844tFd4mQx598FgvbVmYOagl6XjGtntB
         EycvbmFI/C+7Z+bZ33TftOv+rj64iCw4hq+LIf7FGxQHTwcS9+wWr70G/bJFKUP2GIKD
         HI9sz2JIa2qDqlg0tlgjgqFO3Z7beU7E7oCAAFlkcFc2gKYRWum+wvcUdvcJANwaC+QZ
         NCS4o8eioxl+qvHE4cdv1Vk6hRn0BX+bh3MSbTZbAXDuZ7UmjG7UxsDME2oPy2hMFnh8
         BQP5ueUFRePjc4deedL3EFzipOGNuDW826Fj1qypc3IO+GSZcNERRT9zrjleAshKN3jR
         p7ig==
X-Gm-Message-State: AOAM533XB6kpdUy02ld69VXWgey9T9PBQ2HOuBZJHel9O7Fyy1vR9+HF
        HJKCSFE3plWcsAMDMcCQ6DS/lCwL9iQfeQ==
X-Google-Smtp-Source: ABdhPJxHRg8u2N0FOvRq1EmUvBeztSe69foPp9fHWYjzjhNv72+OlmkzLakxl7Jpi9qLHG207/KSlJWydc+n1A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:98c:b0:4be:c059:8e3 with SMTP id
 u12-20020a056a00098c00b004bec05908e3mr1382137pfg.10.1642024686911; Wed, 12
 Jan 2022 13:58:06 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:58:01 +0000
In-Reply-To: <20220112215801.3502286-1-dmatlack@google.com>
Message-Id: <20220112215801.3502286-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Improve comment about TLB flush semantics
 for write-protection
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rewrite the comment in kvm_mmu_slot_remove_write_access() that explains
why it is safe to flush TLBs outside of the MMU lock after
write-protecting SPTEs for dirty logging. The current comment is a long
run-on sentance that was difficult to undertsand. In addition it was
specific to the shadow MMU (mentioning mmu_spte_update()) when the TDP
MMU has to handle this as well.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d76b5..33f550b3be8f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5825,15 +5825,26 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	}
 
 	/*
-	 * We can flush all the TLBs out of the mmu lock without TLB
-	 * corruption since we just change the spte from writable to
-	 * readonly so that we only need to care the case of changing
-	 * spte from present to present (changing the spte from present
-	 * to nonpresent will flush all the TLBs immediately), in other
-	 * words, the only case we care is mmu_spte_update() where we
-	 * have checked Host-writable | MMU-writable instead of
-	 * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
-	 * anymore.
+	 * It is safe to flush TLBs outside of the MMU lock since SPTEs are only
+	 * being changed from writable to read-only (i.e. the mapping to host
+	 * PFNs is not changing). All we care about is that CPUs start using the
+	 * read-only mappings from this point forward to ensure the dirty bitmap
+	 * gets updated, but that does not need to run under the MMU lock.
+	 *
+	 * Note that there are other reasons why SPTEs can be write-protected
+	 * besides dirty logging: (1) to intercept guest page table
+	 * modifications when doing shadow paging and (2) to protecting guest
+	 * memory that is not host-writable. Both of these usecases require
+	 * flushing the TLB under the MMU lock to ensure CPUs are not running
+	 * with writable SPTEs in their TLB. The tricky part is knowing when it
+	 * is safe to skip a TLB flush if an SPTE is already write-protected,
+	 * since it could have been write-protected for dirty-logging which does
+	 * not flush under the lock.
+	 *
+	 * To handle this each SPTE has an MMU-writable bit and a Host-writable
+	 * bit (KVM-specific bits that are not used by hardware). These bits
+	 * allow KVM to deduce *why* a given SPTE is currently write-protected,
+	 * so that it knows when it needs to flush TLBs under the MMU lock.
 	 */
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.34.1.703.g22d0c6ccf7-goog

