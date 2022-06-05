Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9B53DA7C
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349656AbiFEGdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349634AbiFEGdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B443937BF6;
        Sat,  4 Jun 2022 23:33:31 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s12so9887536plp.0;
        Sat, 04 Jun 2022 23:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OlGYpcHVQA/YlW9Cm4xx1uTyQMaz0Myd/TiCIy2nB3o=;
        b=Zu/NphAdZBNIcPKZDnWHx5b7dDhCuefgQIOMBrqvWI+2e7pvQNAsguZF7ApPtV2+dW
         B1EmZX7/ZoyDKyG+G5nQEHSJGsScNOGHnzJ0gduKci63yRKSdEyYS5oE2m79fznuxXMp
         J5mn9qvVAgsVq9fG3uSxZPwIjnIk1tIjrVWiajKs6hf4oWT4jOdJ6dcsNqwB6tp2iPA+
         GbSEdnuec6TBrK+k+EQfzdZiopbltqzld49NqzpTX0UwVz+qASp7YwgsHHKTlvdoH78Z
         62uxaD6a1kPxy9Fi+t+S7tYurElMTU1mtowAscHtHsxr5S+Ws+dOVHekVYtreNTL6tSR
         aRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OlGYpcHVQA/YlW9Cm4xx1uTyQMaz0Myd/TiCIy2nB3o=;
        b=sZsX41+YZ6V5Lz2B+4Pnf259BJETb4V1vSkiFhHUTtefZwyC0OygBuCkAuoEnUEzh2
         J+Nqm9WDva9larg756ynm5lytspr/LQrq37abMdKrtST2MXLvtgiQ0uDmdPuTc1YShQp
         RBOryQnEWzOzFEW9U1/gFJZtqaBqwez28MvjkJupKpRzl1iijdX8NbCQXPwqiU7UBP8s
         INxAv+xKuIYgTTRSuSpOWksg7uMNvvYz+Meq72fopq3hHqdcTgUBt7csbISwZwcBiA0M
         LAA8bWug18e6X7ifI+qkiYZIms7/De3qjTRwVf/0Zxh3c+BvQYUFddXXFNQ0D/5p/AGl
         EvOw==
X-Gm-Message-State: AOAM533f9+Gir59oflAYOA1clGRW9o11m63td8ZSVc+X6mmNh+zungAp
        IWA9qqNy0/dwrMwd7WUnp/9LYtbDayA=
X-Google-Smtp-Source: ABdhPJyTzCmtKgk+nWl3bf17obTxv0KIw4TYKHX19NXXEAGpUtiJZh6bYiik18vWk5o/oTWOE8VsSg==
X-Received: by 2002:a17:90a:c981:b0:1e6:75f0:d4ea with SMTP id w1-20020a17090ac98100b001e675f0d4eamr21018524pjt.37.1654410810897;
        Sat, 04 Jun 2022 23:33:30 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id u128-20020a626086000000b005184d1e838dsm8530423pfb.12.2022.06.04.23.33.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:30 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 1/6] KVM: X86/MMU: Remove unused macros from paging_tmpl.h
Date:   Sun,  5 Jun 2022 14:34:12 +0800
Message-Id: <20220605063417.308311-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Remove unused PT_BASE_ADDR_MASK, PT_LEVEL_BITS, and CMPXCHG.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index db80f7ccaa4e..2375bd5fd9f4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -24,17 +24,14 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
-	#define CMPXCHG "cmpxchgq"
 	#else
 	#define PT_MAX_FULL_LEVELS 2
 	#endif
@@ -42,30 +39,24 @@
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
-	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
-	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
-	#define CMPXCHG "cmpxchgl"
 #elif PTTYPE == PTTYPE_EPT
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
 	#ifdef CONFIG_X86_64
-	#define CMPXCHG "cmpxchgq"
 	#endif
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
@@ -1076,15 +1067,12 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef pt_element_t
 #undef guest_walker
 #undef FNAME
-#undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
 #undef PT_LVL_ADDR_MASK
 #undef PT_LVL_OFFSET_MASK
-#undef PT_LEVEL_BITS
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
 #undef gpte_to_gfn_lvl
-#undef CMPXCHG
 #undef PT_GUEST_ACCESSED_MASK
 #undef PT_GUEST_DIRTY_MASK
 #undef PT_GUEST_DIRTY_SHIFT
-- 
2.19.1.6.gb485710b

