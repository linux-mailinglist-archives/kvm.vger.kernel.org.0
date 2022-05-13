Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4B526B57
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384381AbiEMU3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384312AbiEMU3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB2778900
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f6-20020a170902ab8600b0015f186a69e7so4865541plr.2
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lgtnhvy7+1BCZ2eFCe2s9WzklomHzRT131Cc2B3t8Gs=;
        b=nlPBmMlvFaiiHIxBMCrdBviz09aO2UJ3P4BQKD5zdeS25QzxpRCDfJttzo3xnUZ3Zs
         Woc893zPTgCcikXTcx871Qn4AldyKgfNp5bhRfkB5aTHiWuKhD/2hlwkDGQG+bdtSfCJ
         htizOAEaEMSFrbCyY8nQEcTm+sBtLwKgpm0M1SnltyfsLkatXQvqOzXVLhssiby5a9uA
         nCGOh5FXrAGdfj5Gi01e06xx6gcqb9lxybyoHb0Ra8A20IDSft8W4ZT923y2E/L1w1Jn
         8JQ+rvf4CFTSsJ1aFmJndTHh1Mk5kLvigrQojP9i4rbS7D9XblX3FX2aqFNyzr3FsSV+
         9BmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lgtnhvy7+1BCZ2eFCe2s9WzklomHzRT131Cc2B3t8Gs=;
        b=xu4f+pCnAghRl/5Ulh4BlM0cifxCak0bpGg/6g9ce6KFtyPQ0yxgHmN4S9IjMs+bmG
         5B0lNFJm57tGjQ5cpU5G1xAI9vx+EOHyGuk//Pnwyn4IVJfOglY6186LmoR2bc2Z2T9k
         adDSRPdgwY6XSJ/wFZn2IeCVogYYUuH8c4fQks/DxwxpAATSgAEtW2VOiZaOSncx7nwf
         VOU7jBPuoycMD1K6Ogp1eemfLyo/e9Ai1H/V5u02zDa0uFf5T6rS3G6/xNr5T2DPefnT
         qelXH1TvKD2vQmrC+gegAvXRKnMDC3Mt9JwXHeKd7+6d/X6r3kVoVWPCMAq06hTqyCff
         z+jw==
X-Gm-Message-State: AOAM533eXts19sOFjba8ZYqQI8wzt7ElCUReZuMUqByr6D0bIm6AuYWO
        W2ccvB6NH6WYEK7sSXvoSMZrnPH4awQIKA==
X-Google-Smtp-Source: ABdhPJwTCP7I8XFt//8SoYQKhPgP4tZAxj29bs/HtPYVJcnz6pLypD536V2k28Bo91JrBLRkEwYnsf8a77QRUg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1251:b0:1d7:f7ae:9f1 with SMTP id
 gx17-20020a17090b125100b001d7f7ae09f1mr17935511pjb.65.1652473731863; Fri, 13
 May 2022 13:28:51 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:10 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 12/21] KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
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
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow @vcpu to be NULL in kvm_mmu_find_shadow_page() (and its only
caller __kvm_mmu_get_shadow_page()). @vcpu is only required to sync
indirect shadow pages, so it's safe to pass in NULL when looking up
direct shadow pages.

This will be used for doing eager page splitting, which allocates direct
shadow pages from the context of a VM ioctl without access to a vCPU
pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cf27c5de9dc0..bc66029d837f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1850,6 +1850,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+
 	return ret;
 }
 
@@ -2001,6 +2002,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
@@ -2039,6 +2041,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			goto out;
 
 		if (sp->unsync) {
+			/*
+			 * A vCPU pointer should always be provided when finding
+			 * indirect shadow pages, as that shadow page may
+			 * already exist and need to be synced using the vCPU
+			 * pointer. Direct shadow pages are never unsync and
+			 * thus do not require a vCPU pointer.
+			 */
+			if (KVM_BUG_ON(!vcpu, kvm))
+				break;
+
 			/*
 			 * The page is good, but is stale.  kvm_sync_page does
 			 * get the latest guest state, but (unlike mmu_unsync_children)
@@ -2116,6 +2128,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
-- 
2.36.0.550.gb090851708-goog

