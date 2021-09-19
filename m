Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ECE410958
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 04:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhISCoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Sep 2021 22:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbhISCoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Sep 2021 22:44:10 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0C7C061574;
        Sat, 18 Sep 2021 19:42:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id n18so13794728pgm.12;
        Sat, 18 Sep 2021 19:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dsz4Z/SkO2CSryCRKr5MSIJu/NNw2pPVGkiWVqjErc4=;
        b=oKpVs0a3smWd0PWPYWNA4OKpFtq5OLYDnnEv2hWVG/7R7df/N+KB9BIRcwd4F/Dbb5
         djuYb+J3z/b38llbxRrPZ5PJUFx0GIKR/CRixoyKI0ndnkX5JPRqctCocx3swEdUCGTe
         e2veqMF3SxvFluTmEgtdsH3lXeN/ZNQ0OxEi49kIuzKFQQrQvzerK+S1EmN/t6ohCRtg
         I6BiDI1G8tvmFP1T6mf4zDCSHVbHC794YXMmZ1vS2gM7cgXSwV6xtYQ92BuEIyLhQA4G
         1+hgLFZu4DcWKihr8llBV4WgTVaVdq/W0+wbiNxbRzzZY4kTzUjywCSrDFEeTmSciZS+
         RPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dsz4Z/SkO2CSryCRKr5MSIJu/NNw2pPVGkiWVqjErc4=;
        b=mpj3CSQfTtg+eKR2MS5R2jaNrdIsvqOWGsM3FvB0y5itbI2n/FTnwIdvjCkLmT/DoC
         zw3C7iyFyNLszeXQ3FAbNg23SDlpNtXEGXuAtwp+PBpL3o3HN4vd36rIZE0prsMJnczi
         ClyL5OoUeTa8SgvYxI5r6QyP2WnwA7kE8LJYLfvStDkQBTQp7a7+aGV4Fc6yrO45LdQn
         qEWGeUoRFe/n/wN0KnZeNJmXL36GmjGZfvQg5o4nYa5BW7NoRIzkklnFjeizJtVsCAoU
         HEsDYXKEHvbI6IDDOz/75P5Vj5iEbI0BmqQs2Ezi/+TSy+8914iHNuHokTuqj9Ws2Vgx
         hF8Q==
X-Gm-Message-State: AOAM533DT1jEAmBzmNZUn5yDrMY48IAr0deDdszQ1ymEtE7GriRBW46a
        1mbgLbizUabsWL+aMUQU9D/XWIGTlsaZwg==
X-Google-Smtp-Source: ABdhPJz2L3APjUj3CIQM0mOnw8LR1v4bDJipvf1pVBQTj9HGRqeUQ9M0F5yPG6X3PYqRDGqjx39gJw==
X-Received: by 2002:a62:4ecb:0:b0:447:a583:ce8f with SMTP id c194-20020a624ecb000000b00447a583ce8fmr1033540pfb.59.1632019365212;
        Sat, 18 Sep 2021 19:42:45 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id g140sm9757959pfb.100.2021.09.18.19.42.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Sep 2021 19:42:44 -0700 (PDT)
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
Subject: [PATCH 1/2] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
Date:   Sun, 19 Sep 2021 10:42:45 +0800
Message-Id: <20210919024246.89230-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210919024246.89230-1-jiangshanlai@gmail.com>
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
doesn't need to be reset.  It is only required to flush all the guest
tlb.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..7494ea0e7922 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -116,6 +116,7 @@ static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
+static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
 
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
@@ -1042,9 +1043,10 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
-	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
+	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+		kvm_vcpu_flush_tlb_guest(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 
-- 
2.19.1.6.gb485710b

