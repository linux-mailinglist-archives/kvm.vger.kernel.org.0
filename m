Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2762441095A
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 04:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhISCoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Sep 2021 22:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbhISCoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Sep 2021 22:44:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AED1C061574;
        Sat, 18 Sep 2021 19:42:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23-20020a17090a591700b001976d2db364so10206458pji.2;
        Sat, 18 Sep 2021 19:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fz3Dg8ANWjwbm87N+aD2ACzPe3MP9bGNtGAl5p9KClk=;
        b=YeI+KpvcdX5xyRlg0CgsG5JwjXUByuZQHG1LWBKllSDkyh6Yja4xzhPnmtQ/tk0CwD
         zxiCqXiYO0wU74qqRhIissbgsAS9HHwv1yeig36iPgZMOpj5pxbGEOsrYDSK/pVlshjt
         5qv79lzqqB6vPG4lXXFWy+Awg3qHgzl6R3lN7Vxb6GiL+p8R9zERDxoGMyDIfwNjHpJS
         CAeyshqLx/i9mxnojMLGMTRTciT3DvrKFPCItf8dkSTWSxCDiHL5jRpGhMY8XC7x76Vv
         I5At/p+q2phCBgZEarT9hPyCnrVKTTNMoymw7ALKAW8euqxqqgkQRjdytiwSaVn9f3v9
         iCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fz3Dg8ANWjwbm87N+aD2ACzPe3MP9bGNtGAl5p9KClk=;
        b=Kreal0/W8/Ay5M6bmPxTr5nouHu3pt88Cx+M5swbo5K06a296aOj4U1lpw+WdjkCGf
         s/mXy7L7Enf9Q7BcaxlfjYQrAlMP+JyCSxiTRK/Bc73/bp5lo/HUMsiOpMYE4ILm1Gox
         iLzA/EgoGkX8ye7yV8TAZSbA/M6sRdxbTeJt//6kVCOEpnXoHaQ4y5oo70rAIh+22lOn
         LL0EwuT0QcwdhpkaescyGfZ7yiuMWfimlGXIdJZRS0WGFyumBBcA8XN0RRVAiZTyYoG4
         wXjUmHU0BtANCzKajjw946dUH4NHBitndLrIea/Qo0JCEVjoRBdQ0ZWzemgTxfJKt7aV
         1Sug==
X-Gm-Message-State: AOAM530wP6hz91QIDmSN2d2RBe3dz/DF29Tq4jSUp2KnAlhHN5pNGYKk
        eCu4Wcsvi9srihvnreTglYFwZlxsu+/6Ag==
X-Google-Smtp-Source: ABdhPJxJyA9ekbXcrsgCWnaP/lOFwltpVmetzNyOS80wTpOAmpLBxXBbkGMTFDrs3Jyn81GJnybKlA==
X-Received: by 2002:a17:903:120e:b0:138:d732:3b01 with SMTP id l14-20020a170903120e00b00138d7323b01mr16470531plh.21.1632019370951;
        Sat, 18 Sep 2021 19:42:50 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id m7sm11025008pgn.32.2021.09.18.19.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Sep 2021 19:42:50 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
Date:   Sun, 19 Sep 2021 10:42:46 +0800
Message-Id: <20210919024246.89230-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210919024246.89230-1-jiangshanlai@gmail.com>
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

X86_CR4_PGE doesn't participate in kvm_mmu_role, so the mmu context
doesn't need to be reset.  It is only required to flush all the guest
tlb.

It is also inconsistent that X86_CR4_PGE is in KVM_MMU_CR4_ROLE_BITS
while kvm_mmu_role doesn't use X86_CR4_PGE.  So X86_CR4_PGE is also
removed from KVM_MMU_CR4_ROLE_BITS.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu.h | 5 ++---
 arch/x86/kvm/x86.c | 3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 75367af1a6d3..e53ef2ae958f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -44,9 +44,8 @@
 #define PT32_ROOT_LEVEL 2
 #define PT32E_ROOT_LEVEL 3
 
-#define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE | \
-			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE | \
-			       X86_CR4_LA57)
+#define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PSE | X86_CR4_PAE | X86_CR4_LA57 | \
+			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7494ea0e7922..97772e37e8ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1045,7 +1045,8 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 {
 	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
-	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+	else if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
+		 (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_vcpu_flush_tlb_guest(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
-- 
2.19.1.6.gb485710b

