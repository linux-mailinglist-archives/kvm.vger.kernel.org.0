Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F476A75E9
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCAVJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCAVJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:43 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7154C6C9
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:42 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a10-20020a056a000c8a00b005fc6b117942so4535771pfv.2
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FD7uNwpEYF9RsVYatisVMtB7W3/05QCRhc5pQD1utdg=;
        b=GKbeHEhd81x4RT0NRiaNegia/D4yGXeprV1zo45q3lUMhN8Jd0I5JPlSf0CNvA0/+e
         XBbcwBZiGpFyfRO88xezpgSDQzv1xFoV6nXnPYjkBOHhGox/VP2VPJkn1S9XYhf6d52P
         nz3VuQCoHgfWyD+YD8NffwGbJRhosrREg0eRLtc6DgoR3C+EWBi6LGrEsTgA11q0L/CG
         xRHJHbXfg67Sc9Sp0OFyUoKPaeqtXDtK8zQE2OVXSldXJnGaPNPXIzDm7BMv+9TKgg1d
         mcprn81G4KfeaX08Uthza5kJIwnmIUGcuozOci+gMx9fix/o98HhRJux7SLwShphnMSt
         hLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FD7uNwpEYF9RsVYatisVMtB7W3/05QCRhc5pQD1utdg=;
        b=4bl8q0XqZbXpvobGoJaU7aGW+pOMwtqSlxjbk29XAdrSN4kyxqxuhkPzkHaVGkZyeD
         pRC2+rDQgowVm9CG7Z2wVQ3G6tyxkFoc/pDYrXC8MiA6zSQ/tm88K2bYhkFcb/N08HSO
         B71P72yusrBYMtx8aEHqLaeweh8jQeqU5rS6Y/Exlyvmu88Ct+sAbC/lNv5AtD+EuUUJ
         3zptN3po34RsbQ/zmLQa8KdkxKBBUnuVfsJvgk4qpgP2xVMvDe+TjVAn8rXa73IdvosY
         nPbvI8oO8dkjw47qyLSr6IevoKcxi7bbJz7hCb6AznBhx5JDgRaK2bcX3jjWmagg3ApD
         Lhjg==
X-Gm-Message-State: AO0yUKXOaoDXuv+8Z1z89AjLfhYNfzMWgW1aQZcGcfmHnZdD/hBWZVXA
        dbIF9wGuO+/Wjbw8Ycr31ibhU68dCtqcYw==
X-Google-Smtp-Source: AK7set8BFQJrdcP7LxWyeTBzLMdsUZBctkkgkT8+/5jkqM87wF7FFCh3sVs/KW+w4RyY6le5Sdo6CkLY3bMq2A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:381d:0:b0:503:7c81:4599 with SMTP id
 f29-20020a63381d000000b005037c814599mr2229087pga.11.1677704981897; Wed, 01
 Mar 2023 13:09:41 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:22 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-7-ricarkol@google.com>
Subject: [PATCH v5 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
2.39.2.722.g9855ee24e9-goog

