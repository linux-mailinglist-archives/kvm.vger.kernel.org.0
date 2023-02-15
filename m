Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448E5698265
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBORlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjBORlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:41:03 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA2E39B90
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:00 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4c11ae6ab25so225122207b3.8
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aQfWdKPXuFG6NSbYocOUPq5yC9G6Tl83wDoUvzVHnI=;
        b=Ua5IO7vGngB3DNTztZZETtTDciYiE4ZSiNpD2944my3OwRFQUckvrgPt2B78tyOqXi
         F5kKqBAoj6U1HKy1VTJEhvlYGW3FWgCNy4cvKT9FHRcMvJ8MHnHbjozdlzOln7nl9oyg
         JRgPMkCocBqDVJTgdXR/qsVvybn4hlHa1C7dOwtMVjOGWyj9O6BBdiYwnsaSH4EMjiEV
         jllLlMJozi4joV+FdfhpVn2jSts0h8cnkwTnWayt7Lsoj3eUqLy1i0CczBm48omZvZoK
         z7ebDlIWrmJBod1cOC40C4r+VfkG6cyJNX8DgPgLiy4QiEKKoE0Oc9WE/2rBp1QnS8hz
         Zr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aQfWdKPXuFG6NSbYocOUPq5yC9G6Tl83wDoUvzVHnI=;
        b=UATIG4rMByvcbn2zsuq4vMyA5byIhQdEH/MK+q42fGGnaHHJk2pMIC92YTAajsED1L
         IOx+mYvdJefTW9eCiyz/FCzeV5SNJTCNgxPp2t1z/qgyxTlQ+9Dgiq4k7lldjMbR7sI4
         hG8QGwSa5qvWaI8yllRRCdtZjbKdIbEVa2geIZWQKw34rWUJBgGooxQvqLdS++/6+sQw
         HToljgQGIXXbScJpWWNRhuTQPF3I0mYdTxdDah85DWYdBGWf4swCxLZ/L3KBnKXbF5eK
         GgMNp/oucIvyN7agehNTU42acyH2dKrokSEO8goFXBuMo8nuKsX3NU3369jajenURpNg
         vLiA==
X-Gm-Message-State: AO0yUKUv0YlXA0fwiu1fVA6T2RSu2B1vgF9bXHOr/uASrmFJRy1OyXoN
        MweLJlEeEKM4KiZWvwvOTJPIBO0hHs4hsA==
X-Google-Smtp-Source: AK7set9UpWTD9Hf0MbU51HmGeZZNYgY6nfTTY6vNSaQoP2nvyZ6+CLZ7Rwm9HKLf3iyzgtqf832vzhg6ZxuPMg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:dfcf:0:b0:886:23d6:1b4f with SMTP id
 w198-20020a25dfcf000000b0088623d61b4fmr347924ybg.115.1676482860031; Wed, 15
 Feb 2023 09:41:00 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:40 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-7-ricarkol@google.com>
Subject: [PATCH v3 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
2.39.1.637.g21b0678d19-goog

