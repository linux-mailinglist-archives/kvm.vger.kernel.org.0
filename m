Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C997A7545CA
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 02:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjGOAy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjGOAyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 20:54:21 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E03AA4
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:54:18 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3a4261fc598so4149894b6e.2
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382458; x=1689987258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4OZjoW9BqjNxcy4RlxY9pkc5PoIDGveDxU+kXtMBcc=;
        b=KKRWmCcpJXud3QITKn5f94EERCBvnHfPo2Jd+ekvTDvit1ZKtL2At/rqLvkk4EbxYh
         bmv7L5z/I6o+5NvucbGQ3K/kzCTqCMksln5zbsw+MH51Mq23uoECcPykuMVuXgs/PZud
         5lgv/htkcYPoczACz2XxnIE0lYxBwMph7p2vFFTX1Bbj2MJhQ9+vg3FCoV+ZWqWxc0Fs
         8w/rrCxOr/GEutoHZlF+pVrS1gEqAxig3LcGCszVXObyi6SOjyH9F0QOp4wPuHsmLJot
         viR1y/i87qN0pJZ1fI3ZxyhwcGyqozylSHVo1vzB+ZQbxgU2/o0DLNIpJ0px4eAfctld
         qWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382458; x=1689987258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4OZjoW9BqjNxcy4RlxY9pkc5PoIDGveDxU+kXtMBcc=;
        b=eNKr086wfk18WvSMiNopUuA19R99r5WreREdwRbiwMAmdFCP2xydTxsWZIY5I4FD76
         Y74f78Msb+JAGdGZv/DPXtcuTrml4MRDtONJHwhJe8U1HJb7kRrhNMX782hYi8F7QURN
         LYQC+5HWxh2rct7Hs8CvWO55z+HjLXsTxYHUm3tFqXNE4OxUgKkk9l2wv7v0h9mYVgqj
         Hp039g+jVbJMWAr264/AsVSzEvCKESBnBKogcZ0rv9mI88ClA3bpwBCUD+e/lQdhxKzn
         AC5YIdmxMk/NzPinuRuQ6W5YHJggNqP6/s1g+A/CLtrvBUjCngstNzmy07cqVfUINEDq
         MPkg==
X-Gm-Message-State: ABy/qLYUAcJH0CsCrATv8Dy1ypvB7L0uW1l3sk0Bef6wCZZJKgfPdyXQ
        oGBqlHq0qylK6NlnMfWtnnoLjX/iZVNJ
X-Google-Smtp-Source: APBJJlHuS8cIctisxFR2eCx11We7uRlijX+IqW5kBp1R23rbpuDDG4OLeHpdRXsyz6OpKgpcWVQKaGIlx/8R
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:d4f:b0:3a4:26e5:8b24 with SMTP id
 w15-20020a0568080d4f00b003a426e58b24mr7748513oik.9.1689382458208; Fri, 14 Jul
 2023 17:54:18 -0700 (PDT)
Date:   Sat, 15 Jul 2023 00:54:01 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-8-rananta@google.com>
Subject: [PATCH v6 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the helper kvm_tlb_flush_vmid_range() that acts
as a wrapper for range-based TLB invalidations. For the
given VMID, use the range-based TLBI instructions to do
the job or fallback to invalidating all the TLB entries.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8294a9a7e566..5e8b1ff07854 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
  *	   kvm_pgtable_prot format.
  */
 enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
+
+/**
+ * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
+ *
+ * @mmu:	Stage-2 KVM MMU struct
+ * @addr:	The base Intermediate physical address from which to invalidate
+ * @size:	Size of the range from the base to invalidate
+ */
+void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t addr, size_t size);
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index aa740a974e02..5d14d5d5819a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
 	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
 }
 
+void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t addr, size_t size)
+{
+	unsigned long pages, inval_pages;
+
+	if (!system_supports_tlb_range()) {
+		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		return;
+	}
+
+	pages = size >> PAGE_SHIFT;
+	while (pages > 0) {
+		inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
+
+		addr += inval_pages << PAGE_SHIFT;
+		pages -= inval_pages;
+	}
+}
+
 #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
 
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
-- 
2.41.0.455.g037347b96a-goog

