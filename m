Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5068DD7A
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjBGP5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjBGP5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:57:20 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A4D3D904;
        Tue,  7 Feb 2023 07:57:04 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id ea13so1791513pfb.13;
        Tue, 07 Feb 2023 07:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W618oeFBR26jFkCOGW2ktI8DuH0UezwdqqlJmNvjLzY=;
        b=TdKwZwkTOw4aMzgL/pQ0BVKPf9xEXoQKqCpxIoxZga4Nn4zeI5+YQCE1q/M2q6uDjL
         pOHM1tow2f8f5GA7trx3Ub+6E71/0Cn0TN1zKluzTbLlDG7zC2H/51b/inJ8niNs+lh0
         JoGNLdT4Mg45NTXKBEg1IH02+KT5/mjwd+jaByFgEqm825G3o5kd5hgZSvh4d5NxPwVF
         hnDbL0j9PK9MLXsF2+ErYM0N7037mWcxkVeEbXXk9jZpCg4rSXFD6w1znQ0mI6SYIbd9
         N5Ui+sWmB0Oo38neAjwfLR3/VQixI0b3fzEdM3Bc6nDW1QL/v553rwAVvG40Ea4TV5XF
         R8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W618oeFBR26jFkCOGW2ktI8DuH0UezwdqqlJmNvjLzY=;
        b=ZHB0kC+CjU6PNChEkD5Irow0uZ8s5IKsZdEMf7W2UmtKCnoDpiqkGgjnwK1h535LsT
         XOySj6EK9WHw947EBP2EUTsh/u0eMTUYLMin48KUgAHrL+WEaE4XZu0wz+UBpTB/YpmY
         td73hHs/blpY3iI0E69VhpYmjvPfDnrnx1WUvZqUTfNZ8ms9rYR8k3uX2DkJEdP312B+
         wLlHedFPz9pnyUE9xL9xwk0WxeGjcTnnHnQ4igA6XAxuAczIVEicG3Ro+DCKZleotrzI
         8Cvql5zWNnis4TiCUXW1Dm7dBvqlntnum6kNF39Q8pvCbUpxxA0BHE/h+7zJNRXt1m8C
         Ys0w==
X-Gm-Message-State: AO0yUKVSeSSNlJxWpAFRIa0E1Pel33MordlJ8qRrSFni/YVi2WktbNft
        DV1vxnqWQX7lncV8+1xkkttdapxgKpM=
X-Google-Smtp-Source: AK7set9yQ3QONY05PNePbYqJFdpCTCpxdbeX01ePwGmNeDpYmNE68460R+df1pwHjYKj7+YpF3jukg==
X-Received: by 2002:aa7:94b3:0:b0:594:2e35:594e with SMTP id a19-20020aa794b3000000b005942e35594emr3496773pfl.20.1675785412562;
        Tue, 07 Feb 2023 07:56:52 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id 12-20020aa7924c000000b0058bb0fb6295sm1824940pfp.26.2023.02.07.07.56.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:52 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 8/8] kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
Date:   Tue,  7 Feb 2023 23:57:34 +0800
Message-Id: <20230207155735.2845-9-jiangshanlai@gmail.com>
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

FNAME(prefetch_gpte) is always called with @no_dirty_log=true.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fca5ce349d9d..e04950015dc4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -519,7 +519,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
+		     u64 *spte, pt_element_t gpte)
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
@@ -535,8 +535,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
-			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MASK);
 	if (!slot)
 		return false;
 
@@ -605,7 +604,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		if (is_shadow_present_pte(*spte))
 			continue;
 
-		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true))
+		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i]))
 			break;
 	}
 }
-- 
2.19.1.6.gb485710b

