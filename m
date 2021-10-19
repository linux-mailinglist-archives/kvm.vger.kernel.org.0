Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65F1433449
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 13:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhJSLES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 07:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhJSLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 07:04:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C52C061746;
        Tue, 19 Oct 2021 04:02:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2382330pjb.0;
        Tue, 19 Oct 2021 04:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gl8VPcoMln3e3DT8GeJsd1LdLDZ2R76jpOIONXiyUnI=;
        b=OWNJZfD3eYQxMq4xtu6UH4+Tvk6SyZaWfVW3PepY6Q6cQM9UsL+hegB/bDac0/OF7V
         DNO3hnO22ApGNALcHa44Pc7huffLx0LHvDfBncRO2A0nRm7E5R8fmp8877mO6QTlRt5D
         b7wiaMUpYbTa319LH7hUrK1gZbd+BbQogglLiR7nf33Yi2GJyJ5LRCr+HprAWThw7ODy
         nd4MIeKbMU78uNZWhDVCVd6qCLe4rPrYckdIKQ7kUHMiy9nQS4NyUXz6Qpkn42o4EPq2
         UNozWRFb2TbULKoQQNSGMEsvd5nX8rhmBvHQBR2wvzwymGBHZWmHiFlR79mUWSeCg2hU
         RyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gl8VPcoMln3e3DT8GeJsd1LdLDZ2R76jpOIONXiyUnI=;
        b=AjUvyO0NzC+TuEGNEsRzhjcInVvf/YLs92n43YzOOaAb0XmlQuZakXsE1DWLuH3iHf
         +hTuDIn87G7gQvlI+A0OaKSf4v+ug7iQvbv2UACu7zvyHT0F+SAPHUhKPGGjqe0ThKM6
         Dm1tIg0DJzEBBfFEy4iJb+0rcEwvSS9qfDSg5VXVvhGXAZwxwvzMDYqfEOge+/IS+vrq
         rcPnJCMsBYWoMvPp93krxwud/dXTcF+fg8fQbv0boAlWWjSVsntAeAmD7xbG19lt0xxi
         NpDOv60Kr020oRl8QugCcpe1lN+v+Fbdf73k5ijL1HizWeVUtITg4Y9qwsiQWZnx1m7w
         JSpw==
X-Gm-Message-State: AOAM530tmfcjvJqEjc2txI9DqnLC107X/hP8IfwEStbK7gXEz/WzVTlt
        UOpzvoDfoxwOFtonNv/Uf63XaWbJZxU=
X-Google-Smtp-Source: ABdhPJwxmqB2ZKQOr2OdCNeT0ZdndX8q9PZ7KEGuwdPT7gFjdPpFAv970zHMAVYJYA3mawl7jaWiIQ==
X-Received: by 2002:a17:90b:4b89:: with SMTP id lr9mr5775280pjb.11.1634641323340;
        Tue, 19 Oct 2021 04:02:03 -0700 (PDT)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id m11sm10360837pgv.84.2021.10.19.04.02.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:02:02 -0700 (PDT)
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
Subject: [PATCH 2/4] KVM: X86: Cache CR3 in prev_roots when PCID is disabled
Date:   Tue, 19 Oct 2021 19:01:52 +0800
Message-Id: <20211019110154.4091-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211019110154.4091-1-jiangshanlai@gmail.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The commit 21823fbda5522 ("KVM: x86: Invalidate all PGDs for the
current PCID on MOV CR3 w/ flush") invalidates all PGDs for the specific
PCID and in the case of PCID is disabled, it includes all PGDs in the
prev_roots and the commit made prev_roots totally unused in this case.

Not using prev_roots fixes a problem when CR4.PCIDE is changed 0 -> 1
before the said commit:
	(CR4.PCIDE=0, CR3=cr3_a, the page for the guest
	 kernel is global, cr3_b is cached in prev_roots)

	modify the user part of cr3_b
		the shadow root of cr3_b is unsync in kvm
	INVPCID single context
		the guest expects the TLB is clean for PCID=0
	change CR4.PCIDE 0 -> 1
	switch to cr3_b with PCID=0,NOFLUSH=1
		No sync in kvm, cr3_b is still unsync in kvm
	return to the user part (of cr3_b)
		the user accesses to wrong page

It is a very unlikely case, but it shows that virtualizing guest TLB in
prev_roots is not safe in this case and the said commit did fix the
problem.

But the said commit also disabled caching CR3 in prev_roots when PCID
is disabled and NOT all CPUs have PCID, especially the PCID support
for AMD CPUs is kind of recent.  To restore the original optimization,
we have to enable caching CR3 without re-introducing problems.

Actually, in short, the said commit just ensures prev_roots not part of
the virtualized TLB.  So this change caches CR3 in prev_roots, and
ensures prev_roots not part of the virtualized TLB by always flushing
the virtualized TLB when CR3 is switched from prev_roots to current
(it is already the current behavior) and by freeing prev_roots when
CR4.PCIDE is changed 0 -> 1.

Anyway:
PCID enabled: vTLB includes root_hpa, prev_roots and hardware TLB.
PCID disabled: vTLB includes root_hpa and hardware TLB, no prev_roots.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06169ed08db0..13df3ca88e09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1022,10 +1022,29 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
+	/*
+	 * If any role bit is changed, the MMU needs to be reset.
+	 *
+	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the guest
+	 * TLB per SDM, but the virtualized TLB doesn't include prev_roots when
+	 * CR4.PCIDE is 0, so the prev_roots has to be freed to avoid later
+	 * resuing without explicit flushing.
+	 * If CR4.PCIDE is changed 1 -> 0, there is required to flush the guest
+	 * TLB and KVM_REQ_MMU_RELOAD is fit for the both cases.  Although
+	 * KVM_REQ_MMU_RELOAD is slow, changing CR4.PCIDE is a rare case.
+	 *
+	 * If CR4.PGE is changed, there is required to just flush the guest TLB.
+	 *
+	 * Note: reseting MMU covers KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_RELOAD
+	 * covers KVM_REQ_TLB_FLUSH_GUEST, so "else if" is used here and the
+	 * check for later cases are skipped if the check for the preceding
+	 * case is matched.
+	 */
 	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
-	else if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
-		 (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
@@ -1093,6 +1112,15 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
 
+	/*
+	 * If PCID is disabled, there is no need to free prev_roots even the
+	 * PCIDs for them are also 0.  The prev_roots are just not included
+	 * in the "clean" virtualized TLB and a resync will happen anyway
+	 * before switching to any other CR3.
+	 */
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
+		return;
+
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
-- 
2.19.1.6.gb485710b

