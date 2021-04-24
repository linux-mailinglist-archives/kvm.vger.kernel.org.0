Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC369369DED
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbhDXAr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244169AbhDXArt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2228C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n11-20020a25808b0000b02904d9818b80e8so26105569ybk.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eLXITIaRSuUPT8nfK0P77aCKjNJeDULPyebo6963mgA=;
        b=D01Z2nQvrqvPGM2+TMi1fDQ40FrBs4SoH9NdPjhrjuAk39IioVMxoDDE8TIoyEfPty
         ZC4AXMSXhuDPcIQSSiD7a2b3FZz4MZHmLyygGcs7fxOIJyDI4Pj8zQuJ3Y1zhh+Ry4KD
         CFS60tnES5yM1Qi02DdBwBZDKSh7wbviijj648HM2ATHBO5vCKcoMc85THK32jgAaO5w
         19f7NAhS94vaL3rdmyC0i5tBcQ13w0abEnJ5oSLx+ixsSbgiIggrZcpFiaU+W9JL8kET
         jqdVrgvoMMKpiiuMo5VecgzQAIcNplDmDi6y6rNeYzcRXdlCVxdV/ZHN/bdOu+1XG69A
         GV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eLXITIaRSuUPT8nfK0P77aCKjNJeDULPyebo6963mgA=;
        b=LD4tVeksxeF6qA7SLbCGbsjGbA4UlKfnbM+UHBl3wlIn4AhcMtkDiEqBla4vS2DNyH
         wGPj16drtB6mEnIDOpLd62nBJkPgW5IBbi5iFJAmUDHaPrlN9FlzeSwH+BDe/4Wn96xo
         6PT6LMDMNu0j1lA0cZ7brxNUFLLdxWV+Nkz5bO/v//ZxYglbjrg7stZOY1ZYGH2o2UPg
         g/q6okpcHCZZT+3xcupqmzrJz5m1wYE9s0DlGIB45JslKr+V5HR1FMMi5/dBVWuU6Bvb
         d4Id/iAAyXat0jkzQG+G5mEsyushSPobS1fOJ8j4Ueu2mWUPCb/Y0rwbUZNeJaLTJ8ng
         RipA==
X-Gm-Message-State: AOAM532+4BliMs902wCwF5zFHnPg7vV4oi+HuPTPZbYHal1Ji8J2xIbm
        bjB1HKWckaLaWdIh65J4S+ykpryLeiQ=
X-Google-Smtp-Source: ABdhPJygFq/wAwVEmmGyNGHD6tEd0pB/Sve3VonZlYrccyTtdRzzfTv52tPrSXGNwozvRoNleeRkSmZptgY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a5b:ed2:: with SMTP id a18mr9410758ybs.466.1619225231008;
 Fri, 23 Apr 2021 17:47:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:07 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 05/43] KVM: x86: Split out CR0/CR4 MMU role change detectors
 to separate helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out the post-CR0/CR4 MMU role change detectors to separate helpers,
they will be used during vCPU RESET/INIT to conditionally reset the MMU
in a future patch.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba5f2bb..0bc783fc6c9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -823,16 +823,21 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+static bool kvm_cr0_mmu_role_changed(unsigned long old_cr0, unsigned long cr0)
+{
+	unsigned long mmu_role_bits = X86_CR0_PG | X86_CR0_WP;
+
+	return (cr0 ^ old_cr0) & mmu_role_bits;
+}
+
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
-	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
-
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
 	}
 
-	if ((cr0 ^ old_cr0) & update_bits)
+	if (kvm_cr0_mmu_role_changed(old_cr0, cr0))
 		kvm_mmu_reset_context(vcpu);
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
@@ -1009,13 +1014,18 @@ bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
-void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
+static bool kvm_cr4_mmu_role_changed(unsigned long old_cr4, unsigned long cr4)
 {
 	unsigned long mmu_role_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				      X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
 
-	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+	return (((cr4 ^ old_cr4) & mmu_role_bits) ||
+	       (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)));
+}
+
+void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
+{
+	if (kvm_cr4_mmu_role_changed(old_cr4, cr4))
 		kvm_mmu_reset_context(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
-- 
2.31.1.498.g6c1eba8ee3d-goog

