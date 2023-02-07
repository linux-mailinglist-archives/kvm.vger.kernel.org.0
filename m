Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D34668DD6B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjBGP4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjBGP41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:56:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221F1DBA5;
        Tue,  7 Feb 2023 07:56:26 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so15417736pjb.1;
        Tue, 07 Feb 2023 07:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00EnWk3ZcvlWSt+eqRLR8f7k4INrMYq7M/LxOj8BTmY=;
        b=i/WILB2TOMxVYBBVBjuXsmnKJfVb94zgDGMBL/RIvs5DS7GLZ6hwhtC9t1FDjk6yoQ
         QVr/kftMtd8RQiTodOpfr9biP801XloUaScWN3RbR+H3FEZsYdRn3fTr0ckdERqbiCzy
         tl9yVOBkG7ddLgufjWNX1QbJtxqF9R4W6Hr7RC6l5t9tPReTUwhmFCW4h0XiLgAkbHUy
         JlP64Bqz0X0SueJz0UBQekkqQKe090jaE7aKyRj20Qyz1Bs1G9ly1Uvk8vHtaVcS1mCa
         1vKqIHGDpROAZlUu8weoM63rekXJAP7xpzaHDMYSOxGyCulzcQ/WV91GGzt8d2nU7W4A
         XGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=00EnWk3ZcvlWSt+eqRLR8f7k4INrMYq7M/LxOj8BTmY=;
        b=HWiKWgiCvxoX+tenH3B8oJLHj36FO2k4jN8LWa0LvdPljS+9/ByDKEK4owqGTxP/Gg
         m1GQnFM8GQNgqOUeP7QBU4/oXEvJGtmi78Of4CUH64iyyCopxk12dFpiLdeMtQin2811
         yrumXQsDNxcHayiCtcXsIGrMfPcyiL7wR3AvsiMbGhZ1oHWtzKZOM5OA9tqlDXhf6lts
         LnG7LQcEvIHEfJDqeCFEoMIPm6xYmvJa8yVGfrYmPldx1EsJQ9tKbJqJF82o6R2+WhFT
         UQuOLVBK4PZKBxej+++dlRO/dVpnEL/QXEJmKP7ksSPifB7eN3Y5O+TnpTsO+0l0aPeD
         iHHg==
X-Gm-Message-State: AO0yUKWxhO06Pdo56WPbje9yXlGcZ6veEEmYqykvtD5NCkUBiG6j7iDT
        DAgiVk1qp0732S+sbbDDTLsAYmTFy2I=
X-Google-Smtp-Source: AK7set+sZsv0dwA6ObpBEtm4xzK/yk9gog3oSWr78QTFaDILZO3EgaAPT8ppnTJPSLlcktYUvUcW/A==
X-Received: by 2002:a05:6a21:980b:b0:be:db40:634f with SMTP id ue11-20020a056a21980b00b000bedb40634fmr2933632pzb.55.1675785385858;
        Tue, 07 Feb 2023 07:56:25 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0019339f3368asm1713221plj.3.2023.02.07.07.56.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:25 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 2/8] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in kvm_mmu_invpcid_gva()
Date:   Tue,  7 Feb 2023 23:57:28 +0800
Message-Id: <20230207155735.2845-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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

Use kvm_mmu_invalidate_gva() instead open calls to mmu->invlpg().

No functional change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 958e8eb977ed..8563b52b8bb7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5757,27 +5757,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool tlb_flush = false;
+	unsigned long roots = 0;
 	uint i;
 
-	if (pcid == kvm_get_active_pcid(vcpu)) {
-		if (mmu->invlpg)
-			mmu->invlpg(vcpu, gva, mmu->root.hpa);
-		tlb_flush = true;
-	}
+	if (pcid == kvm_get_active_pcid(vcpu))
+		roots |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
-		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			if (mmu->invlpg)
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
-			tlb_flush = true;
-		}
+		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd))
+			roots |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-	if (tlb_flush)
-		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
-
+	if (roots)
+		kvm_mmu_invalidate_gva(vcpu, mmu, gva, roots);
 	++vcpu->stat.invlpg;
 
 	/*
-- 
2.19.1.6.gb485710b

