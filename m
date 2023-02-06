Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4B68C408
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBFQ7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjBFQ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A2229E20
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:05 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id lx10-20020a17090b4b0a00b00230b26a46b6so2220274pjb.6
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ned5ZH8F69GPFdj4cuN6WK5vFKhDB+aqB56zYhL8gAM=;
        b=V5/nDwgUHHF6CWVuMNYTpzf9GNUV0/IEDAjTALBiNrylNWFmIPY5WFXEJ3yqe4n1q4
         PZP25IJMjYJRup8+5Tdgp6vitrhxT2tTiNjHi3YMp5/Q2T8ezkBUgYh5ixbzSyofSJOf
         h4mkHAOplb1MwZE/F5dNAxniXBuX/xolqd4SBRIPRx5x7Uu2rMw/VrZA/XH+8btGS0Aa
         aXvMadlh/D+Wyx+khVqbAVPVYU6aWRaMDVCZtQ9wdmazIb/jJV3rDc+eDsv59MlERKwm
         9s+gPXnoA8Wt2yUBhHToh/6iflaIrX13sJaHyVLyVBLxoc6xNwVWTfS/dQ/Du74cDZO1
         Ddrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ned5ZH8F69GPFdj4cuN6WK5vFKhDB+aqB56zYhL8gAM=;
        b=4n6YIUPf8yLfALT5lWfJKZyaxDvrdDfoDvQu8kWJPuS3cbH4FuO9AY+zjE8b/VRzac
         CkYyM0Hj05vLa5o4dliGMcMaDG8Y98l/cLUhRo6jSxZQFzgN8K0bNkxOUdgqZDUVB/uh
         iUY0hQuHF8xY0ufhKBqrjRgyJlf0D+tSKMFc8hpkTO64IcrXk4k1E+fJ4X3uyeGMSjp0
         CP3H4V58jUYfp3R08U5k3gqHzvUhwMvljevLv+Ng8zYpAFO2GI4lTO1jgjo5pzPK3mQc
         qufjOhjAbo5UwsoCofi51q42wecn4iSD/b80nZDBM8ZaP3e0J865Uv9e7qXirJWnIvSz
         6t4A==
X-Gm-Message-State: AO0yUKVmIz4/54LKfgg+MEMmUuHTOlG32xJcg/G03grDUbuxvicYSbLo
        xuX1l8fDBnNmYlYneL5blm6YgRQqlIkDdQ==
X-Google-Smtp-Source: AK7set9fNVVKWi71d4Mx5UI1FkBgjOML5W4imqZGeHvkXnc95/ruYP//2mmjpRMKpD7hf/wYCKXhTBjf6u6VnQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1a:b0:592:4daf:20d6 with SMTP id
 h26-20020a056a00001a00b005924daf20d6mr7056pfk.43.1675702744554; Mon, 06 Feb
 2023 08:59:04 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:45 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-7-ricarkol@google.com>
Subject: [PATCH v2 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
2.39.1.519.gcb327c4b5f-goog

