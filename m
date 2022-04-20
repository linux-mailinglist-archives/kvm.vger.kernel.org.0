Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE47D50893C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378978AbiDTN20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379013AbiDTN2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124C215821;
        Wed, 20 Apr 2022 06:25:37 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v12so1773647plv.4;
        Wed, 20 Apr 2022 06:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aM5VvG/5vt6DPB1ntifwoIFjKJCDD8XHdmfREnmCM5o=;
        b=ULYKQfaainTU65ZIyY4HBMpf1Cd7NEPF+gJfyd7ql1S+TwEHsEIfyqqFyQqKYgVGBy
         BCyq/iyjMigMyOkbKMDLU+HIzwKwe0OTBqanQc8/LfSP7BtxScCb/L/bY/JFqsMnUCOa
         Di9gB964ZAOmMclEGUxYnGmLxzHqDnOQVYUWWVAEMaVi9DvU8XHfayrWUin8/+bhLFlS
         77S5hAIBy6aw8zoD+yiZ+BpJuQO2RCtWFgETMFsibKoPFxelZ07V/eUKsaK7yakQcnnf
         FdaS5fvvd1pcqnxSYj2UvWSzHGdral5UhjSP0sZ25ngM5iH4hg3fMinCo8fa/6HHJaeB
         GoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aM5VvG/5vt6DPB1ntifwoIFjKJCDD8XHdmfREnmCM5o=;
        b=Twl4gLQ5BWMAsftfs+O9IrdTYvTRFkhBzW4uBEWYH1FJcUVEr1xuK2x8/SmFT4rJI7
         V7M1+hHOaM+RSW8ztnmytc7y1m222ceLagbUooe/gD0W40gqzF5vuttkiDnHNc22yuFb
         rL4ayt4QbFMWrJ2Y8k/dzW8VbbRd5n4cB9uDwWcbL8LjavXi/hxxeyQKjrbIH5hAe3OC
         IGUANf3RdmK14/UvPYJZkP1O3DH01sBJeVc1kRbY2N/82V04iaglxA6PQf6uY2C30rFx
         K59yktmpJgGA4N9w98IpffyWkWGk6ag/tx2PEMZg9kJoF223TRYphXlY3JBooq9yzo0e
         2FAA==
X-Gm-Message-State: AOAM533yljgmNb68VRLQfKGlFcbLwBBotkZZr0cPn6Ya28o1PwQodiP/
        giE0TGPOLCvkfsGpNibOSUB/AfPf5tM=
X-Google-Smtp-Source: ABdhPJy9XhL8LjcMH3c8M0tWPDF7f/8cabUadjoEVmK3SDwLVs+xYectF0HU1x0ExcLOICupnaiuRw==
X-Received: by 2002:a17:902:e8c6:b0:158:f809:311f with SMTP id v6-20020a170902e8c600b00158f809311fmr16346169plg.4.1650461136433;
        Wed, 20 Apr 2022 06:25:36 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004fae885424dsm21276868pfx.72.2022.04.20.06.25.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:36 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/7] KVM: X86/MMU: Link PAE root pagetable with its children
Date:   Wed, 20 Apr 2022 21:26:01 +0800
Message-Id: <20220420132605.3813-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
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

When special shadow pages are activated, link_shadow_page() might link
a special shadow pages which is the PAE root for PAE paging with its
children.

Add make_pae_pdpte() to handle it.

The code is not activated since special shadow pages are not activated
yet.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c  | 6 +++++-
 arch/x86/kvm/mmu/spte.c | 7 +++++++
 arch/x86/kvm/mmu/spte.h | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f6eee1a2b1d6..eefe1528f91e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2280,7 +2280,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+	if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
+		     vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL))
+		spte = make_pae_pdpte(sp->spt);
+	else
+		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..0d3aedd2f0c7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -250,6 +250,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 	return child_spte;
 }
 
+u64 make_pae_pdpte(u64 *child_pt)
+{
+	/* The only ignore bits in PDPTE are 11:9. */
+	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
+	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
+		shadow_me_mask;
+}
 
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..b2d14b3f9ff6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -416,6 +416,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_pae_pdpte(u64 *child_pt);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
-- 
2.19.1.6.gb485710b

