Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25CA69B7EA
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBRDXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBRDX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:28 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F3A63BCC
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o14-20020a25810e000000b0095d2ada3d26so2133566ybk.5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GBUZ1MvoHSzPOlntwcFWNJ7NDg9kNgKK6wVJ4q5z3So=;
        b=Pg7rxK6++ZYeD8KtaidJr0Wlm3ceogsYfwldGjTjvNz1HwY9odkMb5eIjO74WA6uF6
         q0aVxvuXklbDuKZF6u60OW8A97f/zWkg/cmBUzNHuOvkxwXhjall/kirQzn7IKrGS1Ib
         ztKTTjRT7Rgo/vYTI4A2YLDV9FjX0PeD2ZJMdXZwfXCcvam5YDHgtYFp0UA7JuQ8wq8k
         uYubfSdMLjySUAx4uKzh9UrLkIaN/vhK163zYJ8tUTKOgfDIniJFB2x8/SlYbcFJkNwy
         TQSKB/MxzkMyL9YJ6Won8+r4yWNQsLLj/UMUAVjUN6hRgwDwZ3w+G1fqBHAJYcj+gz1G
         aCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBUZ1MvoHSzPOlntwcFWNJ7NDg9kNgKK6wVJ4q5z3So=;
        b=F7vuOC0BaTh3+TjZKHWz97bqJPAfZ3L2bLtohKEwSm7lx64njeCpk/rYvWS8fGddms
         /s91LcPvg12pxNKTHzClTJVG0mGh6WIOf3bvqbRbstO1YG1XYaGTrpG/fms6fLJowWkZ
         8rLIegMZHY+VroQb6yFQ3b3ZL3Q03VWLMuVkxj4DVhKunQ2QdkQ25MTGJXL4MnG3hpps
         ZGXwLzNHcWtv8JZTXDfGMC9MoLSSofn0OPpSyTyJnPT6Hl0VRR5cU6xAt6RjwDTANYB3
         /cc30Wjwne5Nj4o/ZOAVamF0GUXsaEoMH3GMMP3JoEB9727iw1XIfKJEGY0Vlb4ySrfG
         HUOA==
X-Gm-Message-State: AO0yUKVPaVTQJDDOvAp0HccPGz2wd4U/9GeitPDRyKX1xfonI2pDTFMc
        CiETwRdUIYrgK9p3LgKQU6yj0qUzZYdXOw==
X-Google-Smtp-Source: AK7set988k9/1hvcxfifUIiwdm6LLPOaqIcWDkdvnEu0U/xKw1bqb0HuinJzSTR6CuyoTY6y5/u56D+2UWFkGQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9341:0:b0:8bb:dfe8:a33b with SMTP id
 g1-20020a259341000000b008bbdfe8a33bmr216446ybo.9.1676690606409; Fri, 17 Feb
 2023 19:23:26 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:08 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-7-ricarkol@google.com>
Subject: [PATCH v4 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4a7e6369499..058f3ae5bc26 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -167,6 +167,7 @@ void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d2c5e6992459..812633a75e74 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -766,6 +766,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
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
2.39.2.637.g21b0678d19-goog

