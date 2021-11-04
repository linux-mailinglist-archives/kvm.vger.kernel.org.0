Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D8444C71
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhKDAag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbhKDA3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D6C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m74-20020a633f4d000000b0029fed7e61f9so2362648pga.16
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h7EfkSVswSL3FymMNglXt58S7Vc0tx9NzVk9JdibdVk=;
        b=DBOeGcjhrXQwhK0FDOBounT9evoR1Uijermfpo2pBeH9R90xNB6NiKKYfJXt4+tgd/
         IJ6jypcgRe3jOg4zlXWx5eC1V32MNn6vaqHSQr5smH43RoADVpNyl0gwCePpvloc8Ypr
         F1pfRhWLlrBnkA1hdX3ERXkuM/PO79U9BEXqecoo3QkL6YdP7YHLNYC5NWI2JUA/rUmh
         xU//wrDCCMLfmQuyamdw2hMfy0zAoUq6wowZ4aj1Y2drElfwl5AaFtyY1b2PFE88cjJE
         QyDIm2njMA5AFpQT4XPba1500YCHFs+L2URKin8PC+/TgGc7BaLAMkj9Nt+raQ950oUC
         96+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h7EfkSVswSL3FymMNglXt58S7Vc0tx9NzVk9JdibdVk=;
        b=keYuRLwEfdG5eIJ5EwTYyn8DXaJRWhYK0j5wxjHxRCVsi5YzBkhOh+1wRVigkZ9Rvb
         vZvUPRt/z9/nWcVWOWOWpeLCQufqms67Oc3e/l6BV/3DAVcyDWxIlKYIOeNDFrkb1phq
         nZbbwQvPSU8eJ/e20VTJqW6AqvFjl7/3Do1DYuaofYFQIVCSN1c++5hl+DpT/AFcGHsR
         kKeynK6KcAIR5k/WdMFv6cSd++g7rpGs/J9fUIE7Oz0ULlaGF7p0aLUjFiSw03Wfnkba
         4pAmt8j/xI+X5NZ132Ulq5sRy4W+mFHFRbcE4TlPuGOMEa1TRrXZGO2vaHNavklbXRvO
         2Asw==
X-Gm-Message-State: AOAM531+IWv7Q17OAnDikQC+/Xuryf6ryLZEFT5zEakHWIVfSZcPWMk4
        RYipuLTpYxt1PQGd991qaJd9+V1xR+Q=
X-Google-Smtp-Source: ABdhPJxsxHfihcUwqJ9+RVNX21hbTOai5CGcJvQmgGN1uIZFdZGoK7dZESQoRGdygHMeGrtUc4zbFpEoUSY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:83c2:: with SMTP id h185mr20757080pge.146.1635985592609;
 Wed, 03 Nov 2021 17:26:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:21 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid traversing
 the memslots array
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

There is no point in recalculating from scratch the total number of pages
in all memslots each time a memslot is created or deleted.  Use KVM's
cached nr_memslot_pages to compute the default max number of MMU pages.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: use common KVM field and rework changelog accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..3fe155ece015 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1582,7 +1582,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..564781585fd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6141,30 +6141,6 @@ int kvm_mmu_module_init(void)
 	return ret;
 }
 
-/*
- * Calculate mmu pages needed for kvm.
- */
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
-{
-	unsigned long nr_mmu_pages;
-	unsigned long nr_pages = 0;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-
-		kvm_for_each_memslot(memslot, slots)
-			nr_pages += memslot->npages;
-	}
-
-	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-
-	return nr_mmu_pages;
-}
-
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b0cb7390902..9a0440e22ede 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (!kvm->arch.n_requested_mmu_pages &&
-	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
-		kvm_mmu_change_mmu_pages(kvm,
-				kvm_mmu_calculate_default_mmu_pages(kvm));
+	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
+		unsigned long nr_mmu_pages;
+
+		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
+		nr_mmu_pages /= 1000;
+		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);
 
-- 
2.33.1.1089.g2158813163f-goog

