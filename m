Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1DD3B0BF2
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhFVSAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhFVSAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:17 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A60C061760
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:01 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id s20-20020a0ce3140000b0290268773fc36bso14758128qvl.10
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b8Wsppq/GlcuesoRfm0KDojivDbmhCEZ9n9fv6tGG5k=;
        b=AWYu9f26z3jKRqUE7jiaFlhFDSjABP4CPw3I3Vzhe+qwtHtjccPXgq8r8NmgoqAu7m
         OqHWPQKBUtkaepQAkat0UJXKQTO20t8/6H84ef+60CgVRMRra8M/rpPf3rArZRcRYPqD
         8QwPeGIb7zKHiO0yNOG4PLo4Bq/5NRpKHPjqe6WfoVXV0zMHcGIYEavgVq8vKya0IuuZ
         hBaSENEPjArSrATfe7GuFq86FYXPaoBbZaDvZuHVigF+zdH/K3l5FMVNe8NAy1yNAjK1
         nrykdz3nbzOZ2lGYWmUNrmm7uwJTl0mqVkm7d1pXhPjOnBdTceEd8XkW3IeUD7tm7044
         UyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b8Wsppq/GlcuesoRfm0KDojivDbmhCEZ9n9fv6tGG5k=;
        b=cmyJMqsfxuXkIi8qyXmsN2gspBxBgXwgdKRi6cqJuT1u+SLN64RSwOUaOJEn12/TEq
         5YhsJmrARcr8JqURyAeV6k+V5De/b4ZjvBmb1hyLMsIzFAPCR8iUGuex7R6HBOcQuMwD
         ANuS+s3x+vpfrVX6DZFJBkbI03QTU1ud65bt/8wKQwYQUKysnYUA2XuglsS74pDzikQJ
         g0e/K84+OMQd6ULyq9LSmbS3GwnLal1uOZEe8qLgD0n2SG6D3yskN1H9BvsKlhB2t/Hn
         HwNGEI8lMX+FmRelSgc8B2L3M6IRkXtne5k42TXT5/8dNPhcWtk48iWFZ8++6+Qe0Tuz
         CAFA==
X-Gm-Message-State: AOAM530lVrpSvz9D+Egq5n1/7YkyFUMN+08H3TLPM2FbihlLotpe4eqF
        5Lw2g4X8qMFsSHqiGZuaKJxDLwB15F0=
X-Google-Smtp-Source: ABdhPJyUTlf/be84pRPgY61j10K1EzMREnMDny0lC0z2MBJhCHlWp1zgredc417gfI5VsuJUaj8X+7ULyKI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:cac4:: with SMTP id a187mr6161796ybg.423.1624384680514;
 Tue, 22 Jun 2021 10:58:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:47 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 02/54] KVM: x86/mmu: Treat NX as used (not reserved) for all
 !TDP shadow MMUs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark NX as being used for all non-nested shadow MMUs, as KVM will set the
NX bit for huge SPTEs if the iTLB mutli-hit mitigation is enabled.
Checking the mitigation itself is not sufficient as it can be toggled on
at any time and KVM doesn't reset MMU contexts when that happens.  KVM
could reset the contexts, but that would require purging all SPTEs in all
MMUs, for no real benefit.  And, KVM already forces EFER.NX=1 when TDP is
disabled (for WP=0, SMEP=1, NX=0), so technically NX is never reserved
for shadow MMUs.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84d48a33e38b..0db12f461c9d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4221,7 +4221,15 @@ static inline u64 reserved_hpa_bits(void)
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx ||
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
 		context->mmu_role.base.smep_andnot_wp;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
-- 
2.32.0.288.g62a8d224e6-goog

