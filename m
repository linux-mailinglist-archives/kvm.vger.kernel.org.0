Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97532447FA5
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhKHMre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbhKHMr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA4C061570;
        Mon,  8 Nov 2021 04:44:44 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id j9so15057599pgh.1;
        Mon, 08 Nov 2021 04:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2tXLnqLipCcf0m6Gd15LojCTNxV/qmLP6IND4hBwMk=;
        b=n89igtCe8rKdP4DlzWpC/GwRUOo4rOAudhUb1xRyBnCHqeZlNZnpPffyuvfIuwiNbE
         Q+LqEEd3IKK749c3/7Gs4RpTtujWXIs4Q8G9tamHGuRHhJ9h9L6FBjTAXnY70P2i7cv7
         ZK6KEVErdku8GfnNJzaKC6wR7bJpiWrdEwrmDD0TMWMhzDZ7aNBA5cwrAzEsyFv/w940
         +TWlbvygQQDD7W0jtKQXzf7pzXtp1kYJv7u+lNFdP74Wc3wLaZuLISTiUiNL/oVh+fdH
         kyRhH2sc9SaD8UsNEQEaz6TJ4eGc0fudF+ZPVwJvTDU74QaqhPXYHb3zHPm4QjCcy9pK
         3IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2tXLnqLipCcf0m6Gd15LojCTNxV/qmLP6IND4hBwMk=;
        b=eKvLGlb4EccwftIMT+ZNo+yJmbQmAWZNmF6M1D3fFs32Xpto+/7W3ysd1ck8sZefd5
         Dk6S5/+j7GROp3xVlzDjMtIug1oIN9UKz+J0BV2kJ+JUgvaCynQNrkWcTrCd0WdV0Pwo
         mT7//ZCbLfo6wK/kYAjPQDwE42X1lOkoPeec24XkwjALWrpfOnftTtlTwPJiUULOPqFv
         GG3fc/3j1qJzu3hMVNgicqhWv7x9hrdRzx6NNy8cm33FhLKHwvNHB67aLI2NAaf7VXu3
         cqNZaBN5TYQ2J8gePUHoIIkYvzFe710ejnGB7DSnwuy2wPRkWDKxKcrSzu1wnQkq2LEc
         THAA==
X-Gm-Message-State: AOAM533Nf8o2qqi1Ymjm5vhglFEVACW47dXgaal6KYjcfOUSPQZlQ1m7
        DPsTSvbyk11XmQ4tiW3lVJVHaPGnOOo=
X-Google-Smtp-Source: ABdhPJy7Z/wzb4pgRW9UhzhdAeUyDr7OnVliaRjbQhQ0oYHUodD+Du7YWHR6EK+4GE2NbX6mKOB+sw==
X-Received: by 2002:a63:cf48:: with SMTP id b8mr39346848pgj.434.1636375483771;
        Mon, 08 Nov 2021 04:44:43 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id f20sm12461464pfj.219.2021.11.08.04.44.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:43 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/15] KVM: X86: Move CR0 pdptr_bits into header file as X86_CR0_PDPTR_BITS
Date:   Mon,  8 Nov 2021 20:43:58 +0800
Message-Id: <20211108124407.12187-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Not functionality changed.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 3 +++
 arch/x86/kvm/x86.c            | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 592f9eb9753b..54a996adb18d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,9 +9,12 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
+#define X86_CR0_PDPTR_BITS (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
 #define X86_CR4_TLB_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
 #define X86_CR4_PDPTR_BITS (X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_SMEP)
 
+static_assert(!(KVM_POSSIBLE_CR0_GUEST_BITS & X86_CR0_PDPTR_BITS));
+
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
 {									      \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b92d4241b4d9..e5f5042d4842 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -858,7 +858,6 @@ EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
-	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
 
 	cr0 |= X86_CR0_ET;
 
@@ -888,7 +887,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 	if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
-	    is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
+	    is_pae(vcpu) && ((cr0 ^ old_cr0) & X86_CR0_PDPTR_BITS) &&
 	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
 		return 1;
 
-- 
2.19.1.6.gb485710b

