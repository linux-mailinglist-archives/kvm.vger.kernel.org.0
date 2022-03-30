Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500B74EC57F
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345901AbiC3NXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbiC3NXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:23:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29761488AB;
        Wed, 30 Mar 2022 06:21:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z16so18682698pfh.3;
        Wed, 30 Mar 2022 06:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tD3lBLMBPhXyTx2fpA17/l0uIt12wjZgqNVRbnBMosg=;
        b=ANjPMfRYL5pCiGqbGnRfShBvM6miknLRiWivXIBBlgRMQs8eqpq7q0/qE1mYsRbj+4
         f3AA4HjKTLVxD319VqhbA37UA0rQl9e7JYMOQS+0xAD9NH57qaSltvMCiZN2DQFMWj0U
         6ST7YfM2hxMN/E77q3EXWoRUV+yRVfGgwDtycXXhtIxeEyDtWa0cIfn0DKTpVw7kz5Z9
         6M+/DVE+iMj6MloHxoo1tSp0f1mSkYjgfwOf3NazDEIGR9+cdWB4xEhiPd+xAMVFsevu
         VU1UQRNkztNlxXJsqyljSJqFSUL7P6KCmLSnWzx+QYji1GaSUrkOOYmT3DWtRVKpv0On
         jhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tD3lBLMBPhXyTx2fpA17/l0uIt12wjZgqNVRbnBMosg=;
        b=COCzK88AgUWxvRkdMEEbpofv0DsNpW67nSmQaLF7KlfdzChwUH33lX2PRYosvYkfyc
         hbXB8rbl+PTp6YHRkKQ1lUTVBV5uH5EArNLe6dzG2zpJOieQOguAVvSLZC61PhzemYdl
         /rA+t5x27hfVZRZuP35beYMP/ZpyTaFkDraxtn17rjEfJHVWfl6jeG3VYdXWXHYppRwc
         qj+qGhF8uwa75pnyEwLw9MpENZk8v/PaKqvoRovDAb40TA2ambCuggXmn/sIQAUbf35m
         ipaNeqJ5VEhIaIhkmL1ZY443E9VadZcuzt8f9xWj9sHvbG8RfkOPLGTso2nCmeQvs+St
         UbYA==
X-Gm-Message-State: AOAM531HrcuWzi1kVkjbYboUtajDRH4HOlnCTKTsA05ZNNlr11J3VxKE
        x2D4PdaIaJQ6kkv0J8WTlL5EwZo36C0=
X-Google-Smtp-Source: ABdhPJx3NfPW7EjuGG+gAR5EnXmejzeLt6pF1BUn7snRg9HaaoNwo+hjKLSdfaF6r7571Ymc4BeJQw==
X-Received: by 2002:a63:2b8f:0:b0:398:a43d:dfd9 with SMTP id r137-20020a632b8f000000b00398a43ddfd9mr3329766pgr.478.1648646473251;
        Wed, 30 Mar 2022 06:21:13 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id j70-20020a638b49000000b003985b5ddaa1sm8685955pge.49.2022.03.30.06.21.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Mar 2022 06:21:12 -0700 (PDT)
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
Subject: [RFC PATCH V3 1/4] KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
Date:   Wed, 30 Mar 2022 21:21:49 +0800
Message-Id: <20220330132152.4568-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220330132152.4568-1-jiangshanlai@gmail.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
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

kvm_mmu_alloc_page() will access to more bits of the role.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..02eae110cbe1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1706,13 +1706,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					       union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!direct)
+	if (!role.direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -1724,6 +1725,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->gfn = gfn;
+	sp->role = role;
 	return sp;
 }
 
@@ -2107,10 +2110,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
-
-	sp->gfn = gfn;
-	sp->role = role;
+	sp = kvm_mmu_alloc_page(vcpu, gfn, role);
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-- 
2.19.1.6.gb485710b

