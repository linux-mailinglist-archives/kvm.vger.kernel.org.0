Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CB96DBEE3
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjDIGaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDIGaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:17 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA45459EE
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gt19-20020a17090af2d300b002465835c3d0so1270487pjb.1
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021815; x=1683613815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1I0qN+j3qFL2imk4GAvstB9QkebvP0/XiCYPzHn1INg=;
        b=HNOJL+66yf/bP7wwCyPoau5OKtvop6LsWi/F7VDfjHL6WHG4tXRMvp55R5eF13eOCf
         LV3xQVWL16bfH3sfIiPzJ4nQY0nHusxPk0EDrU53sWuxSzFqLVQQI04jlAL9A86sLbwH
         7Wdr4Y/8drCTasNLIWjeqVPMfD/2emxEaeb7KMPS1t4Inp6Ema4KBHo8m8x3sbvqYkzg
         Mg0fUIbv07Oouxx8Shd0BQaxso893CF4/vSu+IvnA8FaLCNtJ9/Jr7obii3kvy8KNW4y
         xbn6Od5dbdZ7qYwsfYSAmdmPIrJnTXqA4jZx/dAIXPYepFw7T5xMD3BojzbLTPMYNB64
         smIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021815; x=1683613815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1I0qN+j3qFL2imk4GAvstB9QkebvP0/XiCYPzHn1INg=;
        b=BtuKBQNvD403pXZHJy8ytnCSh4DR8pU95CQ3lIkXyBt+RXcoAhGtjjdk1Swk00XYPU
         Q4JWZCkjiESVIj3YSJRfYyFRGvQpV3TIFPS+lHT1GdX56xuAWLU0m/p+rjCF8jmynX9U
         Gd6WtWZ22LxIpvOXc9d14nIltapf8u4LVWUE3WwFdbwf+/yLZCWDnqZPxWv7D5M+5wRn
         8TMbOOXHVCow03FmbVCw3Op+m9tC4gz/4glyKaxh+cXmPVbjWr20a7u8M8Lt1aRf89BP
         pBE+niwOmBc5/0cBUu0qeNBagJbZJI6IXeGqPdnu5HviuJ8d1Oc0HGwoovid/1Ax474o
         NIeg==
X-Gm-Message-State: AAQBX9eo01JxTuKoCgmzcWF76rIOHQTd5KIynkrYFEZAjXQ5EQOlX6QL
        dDm2MDS/26IYrXIW35hNracv1bbuVLlnJA==
X-Google-Smtp-Source: AKy350ZcYA5zcM2WU/yvBVYd6XWlLEBWkwbeWGFnJ4AGDD/0B+opvbdZpKjKSMq8iya2EoHUyGiIiCDWImLP4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:2c4c:0:b0:513:90ed:3c22 with SMTP id
 s73-20020a632c4c000000b0051390ed3c22mr1695193pgs.2.1681021815334; Sat, 08 Apr
 2023 23:30:15 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:54 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-8-ricarkol@google.com>
Subject: [PATCH v7 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 083cc47dca086..7d173da5bd51c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,7 @@ void __init free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 37d7d2aa472ab..a2800e5c42712 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -767,6 +767,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.40.0.577.gac1e443424-goog

