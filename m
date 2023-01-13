Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8F3668A6A
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbjAMDuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjAMDuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:11 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA28612D3C
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:10 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id k127-20020a628485000000b0058029fb70a3so9550773pfd.19
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59+3RpyO/YTzkZC7kIC3ThLSoyfPtBgDOXegbo4OhfY=;
        b=bzNVzkNXtnTnahSLZkUEXB8tjP1blOh4M71aPnfiSROYzEkijWOQSg/o8bEsRpISoL
         IGZpGSYPfkIfFiOLuqYktNZfww01RF6+kCg9lJnQ1QwxbhHMhARNfh7tLWgh+bBVXHAt
         nvk9hMg1V/+lZ/rRL3ZJkcfqeLMSGtCuDUuAZPYorZFwjAv3eNeb85y878hTsfYlJ46j
         ClSyOuEfyi/rmURelRK4AMw3mSJnL4UM9p0qogq5ZoZya5petTYU4JNcIBvvRWx8ObqT
         EESysOg1CmDz34AfcByaXrN3h2d7sRytwcz7sXzP19mwSSmh0vMR21X/0SEfUz0+DB7f
         K2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59+3RpyO/YTzkZC7kIC3ThLSoyfPtBgDOXegbo4OhfY=;
        b=PviiHODv0Wo9cagM3PHwwPBZ+k9DlGbDRY/Jw7LJC342oQflt8wzYIMGlQzuMnfFAp
         GcvlXpTwLHzGF7xy0akOtgnDp8cdMRWfjF2b7AuKOVe50QRUwcnZeIOEYNgckkRAGdaZ
         EI0VwH5QFSj5lGwgnCu+OXvdx/FIV6dxUpB1N4SSl1sCzy+40ICw7d1jXjVuZVUr3LeB
         m+CNsQW+bl26MT6sopahlNRGdkgGceePtj2XNBcBNILEUdYLtajnjfoV8/cHPDGx3OGo
         jNwo4rYe+Tmx/IRh1x5FWLkhMXsHSAe/manvZ0lbwAtopTzFdVYrYmEHGSVESyATxtv5
         t9/Q==
X-Gm-Message-State: AFqh2kp+/q5KHkvZL4kFVdz+kgwWihNOTPBbfcYdHUpEHLvtqbj4tHWF
        mo/YSbT7ufjqxNFNX8ZNfouEO+FtbPV7Hg==
X-Google-Smtp-Source: AMrXdXtCfy1jIMLXxGdkB1qRX4MoYXpbEzTbjEnEa1WpelHoYyJ+3tvm/1Xz/D7sg2og6hJcnmq08VBe0DG8Ug==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:22d2:b0:58b:a1bd:6aae with SMTP
 id f18-20020a056a0022d200b0058ba1bd6aaemr425501pfj.25.1673581810284; Thu, 12
 Jan 2023 19:50:10 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:56 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-6-ricarkol@google.com>
Subject: [PATCH 5/9] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
index dbcd5d9bc260..700c5774b50d 100644
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
@@ -1852,7 +1857,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.39.0.314.g84b9a713c41-goog

