Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3769A2AF
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 00:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjBPXwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 18:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPXwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 18:52:54 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E9B5970D;
        Thu, 16 Feb 2023 15:52:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i15so1038328plr.8;
        Thu, 16 Feb 2023 15:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLM5HhVSLORC9QXIXio42MzhLCn6tcOUYAlcgLOohjE=;
        b=CwuGdG5qrLoCiTVuB8/g669w8n8HJJv/ppoCvYESz6x/zamB4/vLZBEzYtxva3CP8n
         SpLY04olKZ0EmyUpwcIxs/gzGTxWff/GW3yMGDYUXkMz3m+WaEET9OOTjD+yIUqrfqu7
         cso3RmiKt11vuYCvCPTJjAK3wXGm2EE6L2MUfdm230nFEQgmHFM2n3mkTLwCCFzgIZdv
         r36yzKarJUnWN3h6eq6ogFnz2Kw96r/Olms9G78YLjYl7cDUTp926o6eyP5HZUbwvTtE
         qhqlGTLusMMr0TtZARRVPaWH09ugR5BTD5OjspfmjakC+B9XgLV29TwrJTdImrQR8b9h
         H1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLM5HhVSLORC9QXIXio42MzhLCn6tcOUYAlcgLOohjE=;
        b=blgPl9Pk4eNOuF5w7wnOzWbml68ly7Mxx+MeQDtN2mIhsqF2V1oA0AkSeFidKVxwCZ
         zEDplfj4Qzf7ak2LrrZzckZphSpZX8oXaGu4dxJf/hbLmN87USFXX1HZbparvDBiJI+6
         +XNs1wfoIiRoK9X3rxQz/c+gFeg40qecb9VwLV7pREkKAQBNnix8KRi1gbMpz8LZ/J+3
         JUgYB3U1YRrSPCA4T8R3sty/bUVCp9+k4VKjZt875N6+AHuIeOdndhNZ/34nBE2XrHn+
         trQFMBBMMbLjMaPZ1fcR4VnST8ZWhivnBXE7Xm+xJ9YBaX1RcAOOGM8AS1/2/+gwJySX
         X2PQ==
X-Gm-Message-State: AO0yUKUEmD/jauVsHBcZ2kSUPSVDVnmKKvwUm6wsZf/0+pPi/F3LbLhi
        5RM2vSr2WXIMyeC9VRthxWfp/A/i+fs=
X-Google-Smtp-Source: AK7set8tYnq25kNntr8Qv9CceC5v6kP+DR0WONO33vmNOMgOJwgq6YTbvYirDi0SG5Kaz2fY0DS5Xg==
X-Received: by 2002:a17:902:e74a:b0:19a:90ed:af6f with SMTP id p10-20020a170902e74a00b0019a90edaf6fmr8210649plf.60.1676591561059;
        Thu, 16 Feb 2023 15:52:41 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id bi12-20020a170902bf0c00b00194c1281ca9sm1839329plb.166.2023.02.16.15.52.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:52:40 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 14/14] kvm: x86/mmu: Skip calling mmu->sync_spte() when the spte is 0
Date:   Fri, 17 Feb 2023 07:53:21 +0800
Message-Id: <20230216235321.735214-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216235321.735214-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
 <20230216235321.735214-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Sync the spte only when the spte is set and avoid the indirect branch.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8ac37d51287..cd8c38463c97 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1942,7 +1942,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		return -1;
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-		int ret = vcpu->arch.mmu->sync_spte(vcpu, sp, i);
+		int ret = sp->spt[i] ? vcpu->arch.mmu->sync_spte(vcpu, sp, i) : 0;
 
 		if (ret < -1)
 			return -1;
@@ -5764,7 +5764,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
 	for_each_shadow_entry_using_root(vcpu, root_hpa, addr, iterator) {
 		struct kvm_mmu_page *sp = sptep_to_sp(iterator.sptep);
 
-		if (sp->unsync) {
+		if (sp->unsync && *iterator.sptep) {
 			/*
 			 * Get the gfn beforehand for later flushing.
 			 * Although mmu->sync_spte() doesn't change it, but just
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e04950015dc4..3373d6705634 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -933,7 +933,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	gpa_t pte_gpa;
 	gfn_t gfn;
 
-	if (!sp->spt[i])
+	if (WARN_ON_ONCE(!sp->spt[i]))
 		return 0;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
-- 
2.19.1.6.gb485710b

