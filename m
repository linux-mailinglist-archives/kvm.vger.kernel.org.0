Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E809450C3CE
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiDVWP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiDVWPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:34 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C58E222913
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 64-20020a630843000000b0039d909676d5so5634962pgi.16
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EZ6lXuaS+fWlhXKNn5Z8JpVAcYLp2zeP1jB8K8WPgIo=;
        b=c9IZvAf9/lbIbolLkPnD9B93ep9zv/hzix3WCn+e74Fmjb2P/4TE+CBLjJ8hDC2Mq9
         cDB//hDlGC6hZ4KlHcTLpYqfZG1xGE+cd+VRxeSUJu6Hm7Aiuxb3wdIRPkUGu/gMv3uE
         YDQlVgY4NqfyftIukn7TVeVdRCf9XNubptM2eOgvVPOXcUX4+v/ynPLsVe4mBj96Unad
         JW9x5rF/GyAlRqRU9p5r5qy7//mNfVEJdH4cH5thRpqGPtRs5FWt/YtMEViwXxugkbSl
         c/r6R21ZsBPm04eZkSMBQ3truwm/JD9O31lNnAaIXX3xIG/vUJTk+FM8rq6d+8Xc1mWI
         XtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EZ6lXuaS+fWlhXKNn5Z8JpVAcYLp2zeP1jB8K8WPgIo=;
        b=KobFPl41RaDeGwW7+neVx1XMvKt4y2zaeiMulyr+og+NzJ4SdxRG8KKQHHdEVRNYZ1
         WlIX0bzzcSN6yhnSEgRiChorqD/Vp4ew5q82W+WVD7Emy9M2T5Z5xRFc34aeZ+BGd8HA
         +3SgTH0LbwRNSiyNBozGNOaoMZlUVmv1DfljE0aDKoHR/AnmBiG0uNk5SZ+hO1nbUVbp
         wS4YtF8yr1FLX/C/kpX+3v5AaFBL39+BaRFKRZYe3po5TtQ7BNm6gi1tq2UaF2BRLaYg
         rfF6TOqmMCwH8t5Wt+JCMqxLfiOTS79qNipE0ZRZwbo0BYCbZEdlKmjPFN+7abhZb93v
         4Mdw==
X-Gm-Message-State: AOAM531eFaa7kdzwhVUvyWJakbXRXdZt/ZmRo7DX/zw94tFfVFarlkCS
        Je165WkMBbpCgOeSdIawrdiLteBSuBTC+w==
X-Google-Smtp-Source: ABdhPJzeRPLDKYvrDf1cDSUjbw4PRRYcM20/mlPk3ZQsllbTvdzlIbLo6Pq0AisuhgcyHRC442gDS2XxX07z5w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1a05:b0:50c:f9b5:6c7e with SMTP
 id g5-20020a056a001a0500b0050cf9b56c7emr2359480pfv.55.1650661559952; Fri, 22
 Apr 2022 14:05:59 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:33 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
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

Move the code that write-protects newly-shadowed guest page tables into
account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
more logical place for this code to live. But most importantly, this
reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
kvm_vcpu pointer, which will be necessary when creating new shadow pages
during VM ioctls for eager page splitting.

Note, it is safe to drop the role.level == PG_LEVEL_4K check since
account_shadowed() returns early if role.level > PG_LEVEL_4K.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa7846760887..4f894db88bbf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (!role.direct) {
+
+	if (!role.direct)
 		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
 
 	return sp;
 }
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

