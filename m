Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6686FB453
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbjEHPtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbjEHPtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:10 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0344AAD24
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:49 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so49954457a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560904; x=1686152904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGW2wQyLJ67fs/5qGW2WH8IEaw+NRLWt7EKBadrjIl8=;
        b=fBTaMUaNejreatVUVmw0r6csLNrr6+MtSBMDNyt1uAIziWsFu6/WBwmUiAkwXZN+Df
         gAW7ZS74qG6tQYzBprPSr2wZUWd7nNyP+x/mcJMc1xrSzpWzam/vRbaQxmF0LDWA7UPr
         YBlOnMkfWub0pfzKr1ekb/Z0/jls8AqfD79YYiW4I6Ebh16HnPKAZDx1CticLRsOkq9n
         GXmqV6awsu00+9Ysw4kk+6rkIZU2ODfeRJvUTvy1RE9tAA5RVxAT9CIY3k9PqopymP9r
         q3l6DdFUaU/qWnRwN6oBHyDmfboc8xmAfR1UOyW/FFoSLdjFs8lHE2Va3CLPFPb7PbgE
         Vmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560904; x=1686152904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGW2wQyLJ67fs/5qGW2WH8IEaw+NRLWt7EKBadrjIl8=;
        b=C4IWPzDHZzhDFWftWQGEzWfjHHoJUs099w8r69N/vpRELHFYC9F0nyJF4DfwX9YIUt
         WOFzTJ2Q3/MzQkTYc5G7a2tszM/AJ93bFYDEJETBaTj2rsYvZPX0ikuvH8K1h1oyB/CR
         mr6Ez9t3eKPsn8pbvQmkqNCfUpV8ix0NQT7xI9onap4jbsHaHbza4hYZuddfrGCGq4Az
         bPvB8EMQxQTvdrEg9BymiIUtQF2dNx9oYt8/PxCNLK+q42wmSl6+sDZk4wraK+k46ErW
         49ZZX0jRUFL59D8XRl1YZUgAdOPE3YOcyxrZM4FB8TC9MxVkFnp3052WrqBSCIl0Fhke
         woGQ==
X-Gm-Message-State: AC+VfDxLSd2fSN3glNH5pA4e+MTCc48SzwkC3s28VlK6rF3wWIr6JYdL
        Uksgug8TrwuYntch14YKzZRK4g==
X-Google-Smtp-Source: ACHHUZ79BdzbT4/7hAGhtlOQ2G2J17ka5CQW7H7/kLtWXuOeFiPbUsVUCRCt0PaIqJLYWHLIP2HAjA==
X-Received: by 2002:a17:907:3f9c:b0:966:1bf2:2af5 with SMTP id hr28-20020a1709073f9c00b009661bf22af5mr6317313ejc.22.1683560903850;
        Mon, 08 May 2023 08:48:23 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:23 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.10 07/10] KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
Date:   Mon,  8 May 2023 17:48:01 +0200
Message-Id: <20230508154804.30078-8-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit a91a7c7096005113d8e749fd8dfdd3e1eecee263 ]

X86_CR4_PGE doesn't participate in kvm_mmu_role, so the mmu context
doesn't need to be reset.  It is only required to flush all the guest
tlb.

It is also inconsistent that X86_CR4_PGE is in KVM_MMU_CR4_ROLE_BITS
while kvm_mmu_role doesn't use X86_CR4_PGE.  So X86_CR4_PGE is also
removed from KVM_MMU_CR4_ROLE_BITS.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210919024246.89230-3-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
- no kvm_post_set_cr4() in this kernel yet, it's part of kvm_set_cr4()

 arch/x86/kvm/mmu.h | 5 ++---
 arch/x86/kvm/x86.c | 3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0d73e8b45642..a77f6acb46f6 100644
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
index 952281f18987..b2378ec80305 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1044,7 +1044,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
-	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+	else if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
+		 (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 
 	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-- 
2.39.2

