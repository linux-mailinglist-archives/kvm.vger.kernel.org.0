Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB21447FAD
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbhKHMsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239680AbhKHMrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:51 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C9AC061570;
        Mon,  8 Nov 2021 04:45:07 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m26so15895652pff.3;
        Mon, 08 Nov 2021 04:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SwT7uyweM/6H8d06K/3A14sKRVp4dNL6BHRY2Yy/FP4=;
        b=Nv5XZq7JeTOHeffsZV/2wKloiGtmx0O40yZLK2N0R1m0TTEcD9+WElywK4Dq9R6OFp
         O0m7IJieV1kWqJyLmLTi5GwypbS09sBPeRRDaPxePGRYFQqenfsF8xz/46iVlUsbHRV3
         8YiZu6pRVGYIJNjWRbp3jRpP2A27PHiaiBzFebNMPewnoYqvBkDU2zoIv3W6U9umArHx
         KrfUo8je9N+B4g0pTwB+nkOcLaLDTAE/scpOS8++vuof8x8Yzaj3s/z/KL4p5nUB2Q+g
         T21Nve8jt4zlKP904IYyv6fzuPZlksZB1tZq1nSu78bXdmfjmnNvKCY8FVWGYiJChpJ2
         QN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SwT7uyweM/6H8d06K/3A14sKRVp4dNL6BHRY2Yy/FP4=;
        b=Yqscm4vA17W4LNsHIWiHVs/o7mY27B3hjcGhlN4dYh6olpl4B7vcGYFnDJY2pUQVic
         fGCUmBkAUuGNexEZEhIcnZl2sUmubE2XiCVHEY/Rx3hGqSdMKWm1uqwh76kgcWTix+JX
         mPBdncCKNIeq7puW7XjXm1evr7BAGRPDehscmx3UBgFo7RcE/GwRVl+T6iiSy6sQZY0t
         cPevBQ3m7Ki//ToWJ+5lbm6BLJ403siso9ZSHqMLM1uRCmpxWCPPMtGFSNO+vFq1EowT
         B+gHKaKdwjYwwvaMlac+8DNIaM79NcdcPeQc9xS+kqX/UjKBqN+zDisbxLtnXSt6a1S1
         vLbw==
X-Gm-Message-State: AOAM530KznUwWbEKj7uPkBMjARNw9fVv+MfkzameQVyiu584GBXk4Knb
        zF/AAKtIjxrSKcVYxP5zu+cdJBrTv2E=
X-Google-Smtp-Source: ABdhPJwI0hM8F6x840FJ7BWuQEoQ0aC1YyGV0LGxeJf7wt6kVJiy33evxlFOD+dVtYrq7lX/rG1IMw==
X-Received: by 2002:a63:2aca:: with SMTP id q193mr60804765pgq.211.1636375506400;
        Mon, 08 Nov 2021 04:45:06 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id i6sm4905360pfu.173.2021.11.08.04.45.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:06 -0800 (PST)
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
Subject: [PATCH 10/15] KVM: X86: Mark CR3 dirty when vcpu->arch.cr3 is changed
Date:   Mon,  8 Nov 2021 20:44:02 +0800
Message-Id: <20211108124407.12187-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When vcpu->arch.cr3 is changed, it should be marked dirty unless it
is being updated to the value of the architecture guest CR3 (i.e.
VMX.GUEST_CR3 or vmcb->save.cr3 when tdp is enabled).

This patch has no functionality changed because
kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3) is superset of
kvm_register_mark_available(vcpu, VCPU_EXREG_CR3) with additional
change to vcpu->arch.regs_dirty, but no code uses regs_dirty for
VCPU_EXREG_CR3.  (vmx_load_mmu_pgd() uses vcpu->arch.regs_avail instead
to test if VCPU_EXREG_CR3 dirty which means current code (ab)uses
regs_avail for VCPU_EXREG_CR3 dirty information.)

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/x86.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dc0e5f80715d..ee5a68c2ea3a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1134,7 +1134,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		kvm_mmu_new_pgd(vcpu, cr3);
 
 	vcpu->arch.cr3 = cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5f5042d4842..6ca19cac4aff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1159,7 +1159,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		kvm_mmu_new_pgd(vcpu, cr3);
 
 	vcpu->arch.cr3 = cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 
 handle_tlb_flush:
 	/*
@@ -10591,7 +10591,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	vcpu->arch.cr2 = sregs->cr2;
 	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
 	vcpu->arch.cr3 = sregs->cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-- 
2.19.1.6.gb485710b

