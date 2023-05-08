Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26146FB43B
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjEHPry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbjEHPrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A37A25F
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-50bd87539c2so7479746a12.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560845; x=1686152845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XACjbBOAT3WTujlADfwySgVeuYdWzCzKnAbBojJJLuw=;
        b=m7nGtVjV2YeIOSfS3Jjm4gpCaMSLaErxADIokVRVlHjAiPwnRRl6L2jg/UsbB2Me2K
         jJcZl2nsCtSmDJpYZI9Uv0a5E3zYHY2vwo1Ht2ChJkVtX/iCe41QtRIFbuv0Ar73VrID
         sTCFVqBLMx7HPoG7tXhL/EgXaHaXt9GanXQ7pib7qDUtHCniLsejZi02HHA/rU98aOYd
         2qlVtW6aNMR8z27i0vK53ii2Cg6+hFtcQh53L/Al7Q56B/ixzlDhtkok1UzK2mbqIXZa
         zVjUcz9MYmIzjJPN6pxiUHYlto8Nu0Ey95VFPo43TQR9HqURz2pZYae054PQjU9kzo0U
         El9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560845; x=1686152845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XACjbBOAT3WTujlADfwySgVeuYdWzCzKnAbBojJJLuw=;
        b=kmltnC59YRJLuPrSs74v+pLvyB2UfE7PnI0iAExRWuP6dZCW9TckShh1V0IVTnD4Ce
         GnrMfEZrgKIBAypG9/bk1Ltb+QirfCJI8i2NlNSi8LEt3wWgO+me/QTkdY6yq0OVNdyJ
         XE3qYJyaBBuxD/vAZf5dsH25yFuOV/J7/imhYjSApo3cBl6v/KQ4dYvyW+rngPWHZSkw
         AGIQONi1J1nBKy1kL7VGOMTE8PYDVUKpdOHuLtewOeI4/w0FxIri6knDXDpSRpPS4izB
         E9Ud0Iqq/1QcNJaXvUWad/pyW1HMsoNmzPNrmvMZBf3na7zeJPd0L+A2fd15OWCZBL6c
         7eqg==
X-Gm-Message-State: AC+VfDwzOyMnPQiRbtZyHHGqgcPbUhv/LMwrxBdCRRFHOWK0S6NR8Dhp
        9W/0G50IjTxvzvy0ejscwkuYPA==
X-Google-Smtp-Source: ACHHUZ63TaqJofUXKI+zdSUTTIvLT5pVplgiYOGyW9hpQdis6FbkN7Ux8zdhRTtehvfqI/ituU6ZiQ==
X-Received: by 2002:a17:907:a01:b0:94a:5d5c:fe6f with SMTP id bb1-20020a1709070a0100b0094a5d5cfe6fmr8602857ejc.47.1683560844851;
        Mon, 08 May 2023 08:47:24 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:24 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.15 7/8] KVM: x86/mmu: Reconstruct shadow page root if the guest PDPTEs is changed
Date:   Mon,  8 May 2023 17:47:08 +0200
Message-Id: <20230508154709.30043-8-minipli@grsecurity.net>
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

[ Upstream commit 6b123c3a89a90ac6418e4d64b1e23f09d458a77d ]

For shadow paging, the page table needs to be reconstructed before the
coming VMENTER if the guest PDPTEs is changed.

But not all paths that call load_pdptrs() will cause the page tables to be
reconstructed. Normally, kvm_mmu_reset_context() and kvm_mmu_free_roots()
are used to launch later reconstruction.

The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
load_pdptrs() when rewriting the CR3 with the same value.

The commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Guests like linux would keep the PDPTEs unchanged for every instance of
pagetable, so this missing reconstruction has no problem for linux
guests.

Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211216021938.11752-3-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea3bdc4f2284..a9f80a544ff1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -865,6 +865,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	}
 	ret = 1;
 
+	/*
+	 * Marking VCPU_EXREG_PDPTR dirty doesn't work for !tdp_enabled.
+	 * Shadow page roots need to be reconstructed instead.
+	 */
+	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
+		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
+
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
-- 
2.39.2

