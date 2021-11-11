Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5844D886
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhKKOtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhKKOtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 09:49:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACE4C061766;
        Thu, 11 Nov 2021 06:46:27 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so4190124pjj.0;
        Thu, 11 Nov 2021 06:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRIZhEJSC5CLQX6HTzAaA6f+WmYf2hQfxbDd38/dBig=;
        b=iVj5d/aqJVXFZjT5mEWOEg0AVSZ86JeMFrApiyvai8PrimFgwfAAT4Wxc3jdG/0vnA
         +Z3n6PvyKqjP6/nDu70n3dEhLNnerbO0/M5A65IKgLRjKr0Vxdpiif5aRCRh5sRpFrC5
         dZqEcvHFE5GPbMFGpWq77VvEMzNDDCvF0JcLSoobOW13DoXW81sdaQ794Xft+3d177EY
         URkAIZ7BCeLa3YeNa1Q0x3hTkrZr1oQ/k9B/Nqv5xNGTnqEp4PwtX7uSY5DolHQnj5MQ
         up96Vp8C1QxMQMBWYHeOiWkOx4q6Rh91sgDrPxx7oa28VILvLqYAjMYbi7bYGSDCXqiS
         TeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRIZhEJSC5CLQX6HTzAaA6f+WmYf2hQfxbDd38/dBig=;
        b=c1cbMDokld12F1xmC9CAuj9H2QRrP1GPFfRYawWnPKDh5N4oV6KX7FNzTZuQUmXtzL
         gh+/ixV6A3qRb/UPa1Y/8P8vkb0AuQ1gXt4HOH9aM+VRVWax2FzzUmb2/FANyYG3vaRw
         BcMytIyF+UtbkULs8V6Cz/xw9uzqLiMpRDQWcBKpIPQDiHUb1Sq2E2j/ZCFA6t+945yA
         DCs+Ba5+jVT0fktRYgSvTzhTD3/Eji7BSHIVA7DXUp3xNsgVmuJnT6U3+H1gfUEu6aq9
         GzvxROQk6nn8cEepf4jXSGd9d556ZtNzp4N0Psz3FxR9Z874Hz54pIv9trM4vxbvsnUx
         a34w==
X-Gm-Message-State: AOAM530N7wMuBL2POBpFSap4Lg5zTZ+6XAsJwxgK3rJ9XnQQoC2Q3gZC
        ridi7DPwTW9PwEhRXJAlNW6TQ1j8RTA=
X-Google-Smtp-Source: ABdhPJyYRCFRSloNwuNIXl3Hp9JTYXsSB6oRo4rEr2iZWQYuRPVtIJhPDTdLSoxqi4D9AZQojGoD4Q==
X-Received: by 2002:a17:90b:4b90:: with SMTP id lr16mr27177912pjb.57.1636641987180;
        Thu, 11 Nov 2021 06:46:27 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id a8sm2570103pgh.84.2021.11.11.06.46.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Nov 2021 06:46:26 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for shadow paging if the guest PDPTEs is changed
Date:   Thu, 11 Nov 2021 22:46:34 +0800
Message-Id: <20211111144634.88972-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

For shadow paging, the pae_root needs to be reconstructed before the
coming VMENTER if the guest PDPTEs is changed.

But not all paths that call load_pdptrs() will cause the pae_root to be
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

Normally, the guest doesn't change the PDPTEs before doing only the
above operation without touching other bits that can force pae_root to
be reconstructed.  Guests like linux would keep the PDPTEs unchaged
for every instance of pagetable.

Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0176eaa86a35..cfba337e46ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
 		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
-		/* Ensure the dirty PDPTEs to be loaded. */
-		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+		/*
+		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
+		 * enabled or pae_root to be reconstructed for shadow paging.
+		 */
+		if (tdp_enabled)
+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+		else
+			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
 	}
 	vcpu->arch.pdptrs_from_userspace = false;
 
-- 
2.19.1.6.gb485710b

