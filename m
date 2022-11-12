Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63249626815
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiKLIRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKLIRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:32 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EF15BD5F
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:32 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-370624ca2e8so63661177b3.16
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RSyLO/J2OZ8IR7rCygIEQwqWF34HE/cmjvAFbCy9UCk=;
        b=XbNV/sOYK22JdWgiTH2gTYZIZ2JAdMLBk35z3CQYb9CTn32I5GDB7F2rCRA/X8mLqw
         hH3HU3TvXgNkR/bnpfpu2xp6vtr7lVL3bn9y1FtnzGCPsCxDYpfzSX0KpT5zMfrzBvnY
         MK9M3SBR81XIYkfchgW8VkXotC21Tf5BmVzIfh6qF9tjayEV1QQiaWYoxaHXShhM3W9a
         ZtA4yi5lV73TrxL75et+sWVbmdDdPGmHgYhLGiQqaxlNGq/N9YpYbdSQ1km43Ko86JXl
         fqYEOvtyvPKXP/TJ0YAuWW0VmMtXNAwuZ16w3/1bB30kWBhrPswOXP6F2LdSVkCzxiq7
         /k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSyLO/J2OZ8IR7rCygIEQwqWF34HE/cmjvAFbCy9UCk=;
        b=mSaSbWLzMwYZp0+lNDiEvFCF1WXpHXVxDltzal+sZwpPJptqXTSh5aX45Og4ucXkvr
         PNc32o+Hx+WhU68Jmqh1VAMI9U/9DOlNF8u+r/cI/lc74BAAg9VsbnNKsFK3Xb1i+R9m
         xb1ChA6SByuhxcl0MtCTARiOYTYnIfnkReFvsUMLBq7zTfsDylCCvT2WSmFpbCj2n7ee
         ipADy21R4+B0/C+oOFJ/+AYM5rGnhfLB2pd/S/bl88rc2evqk3NJeLDZhmjtim3mfz8o
         3eDw7gYnrVCCCq8L6vfQwx3rvwhTqfU17eW5iESrIbPVb2u9L2+FbdfKb0rxq6ratm5t
         ejwQ==
X-Gm-Message-State: ANoB5pnID3bUbHr9ucj9mM9VSLBC1y4ow/ZnvLRBihwr2HJ9MgVM/fjh
        mq9AiSf2Fxp7nX0bWM/2FstfYjDW778TsQ==
X-Google-Smtp-Source: AA0mqf4ZMSd0IbLoI1AkRzAZK/OQcoH6q02SDUxTYBq2QG+Ba1y2BEB32tCAZcmlr2OLtCGGticIz09bJ4TPjw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:55d4:0:b0:6ca:363a:9a1b with SMTP id
 j203-20020a2555d4000000b006ca363a9a1bmr5130852ybb.1.1668241051339; Sat, 12
 Nov 2022 00:17:31 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:10 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-9-ricarkol@google.com>
Subject: [RFC PATCH 08/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
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

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd()
into it. A future commit will add some more things to do
inside of kvm_uninit_stage2_mmu().

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
index 6599a45eebf5..94865c5ce181 100644
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
@@ -1869,7 +1874,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.38.1.431.g37b22c650d-goog

