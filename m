Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3370F6FB43A
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbjEHPrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbjEHPrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0331BE5
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50be0d835aaso8592499a12.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560844; x=1686152844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZhxwX5YJmwh3Xb5Pl4fKRR45KPDMOBgNGiklYWsEI0=;
        b=oZynVFASdBKAgYyOG49mPvnYjqQSeNV4wMohU0REK+FMcD8WGiPgcjLMPs2eAGQ064
         dc1QygcLHggCd+KzNEHvccDTgGDEtn96BD6nvR9mrscA3+4sYLeuUv8RpTYxkK2wvYlZ
         D+C/XNnVrIhH53qaEMos3PpbRzQ5OlIn9vKHge2O2h6A1O15qAS4QyXxSp2YRXwNUDuW
         FFW2QDm5o+gBK0C555Xy6Gk0Z/1pVZkDM5K9RgdWsJM2+Uiuj/ozFDxGmJ7xzURyMtOO
         NDggZpm8gRWMkjhip2lUICJ67yY0y7THRHLmY7AWBOXzNSxRx/siRaeyI1avOs3Sf6uv
         w0UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560844; x=1686152844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZhxwX5YJmwh3Xb5Pl4fKRR45KPDMOBgNGiklYWsEI0=;
        b=NFfmxzbMsQXD35zdzYlucVeRgpW8fOM8uxvl9pEMghtnuLCcN23jeo1JJIs4b1Ctai
         gyzIC0ylRyh8IZ/p0AsHA/eHFRz9KBB8p1iczIAAClf/lxMNqH4H7h0tZX6QUtwpovd4
         BtXbSmivqfKboTqa8sOO4ZxFJoEbY+grbyC0/TBLboCoMWVIqDWnLL2ee1pDO4ej2JMR
         3O2GkSRGaRksj/Ds28g3BNUu00Woj/Yr3EYsL16qzksVkM9thzTl+9deR8L7+O/l4048
         v3Mg0+LULIc+LLGjthGYOaSk2txZxTA3Whlsi8lweI4pfntX1huqJa7TrZttzkCBf6cS
         vjAg==
X-Gm-Message-State: AC+VfDzfjcMDrWE6151UPTcezOgnD8UOl9oVMnBWJFovDDs734Kxgtq/
        9gloUqfZQX6vuJ4MAOujOqyi/qlvIqLFPFE21tlyGw==
X-Google-Smtp-Source: ACHHUZ7jRf5X6LPF8KMEFLEm2MTP5YhZaRBxEQCBPsfU8Vbbnma77M/DqG3AdqvmB9K/0uHX2MZMMQ==
X-Received: by 2002:a17:906:58c9:b0:94f:6218:191d with SMTP id e9-20020a17090658c900b0094f6218191dmr10485675ejs.32.1683560843813;
        Mon, 08 May 2023 08:47:23 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:23 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.15 6/8] KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
Date:   Mon,  8 May 2023 17:47:07 +0200
Message-Id: <20230508154709.30043-7-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/mmu.h | 5 ++---
 arch/x86/kvm/x86.c | 3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index baafc5d8bb9e..03a9e37e446a 100644
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
 #define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 515033d01b12..ea3bdc4f2284 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1083,7 +1083,8 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 {
 	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
-	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+	else if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
+		 (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
-- 
2.39.2

