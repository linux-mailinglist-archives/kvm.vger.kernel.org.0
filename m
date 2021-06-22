Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C853B0C51
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhFVSF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhFVSFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:12 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10AEC0698D8
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:40 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z4-20020ac87f840000b02902488809b6d6so82383qtj.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k+Hy19n7FuHwFcs3JayYH/6a6QV1H82GfzCUZvXtG9E=;
        b=kc43GkOoFjhxBlR2WnQizL7y/R6T20mYKUPc4GWABbmYOlM+hIYTLQly6uwfypaxcN
         hbqSMfJGPmbRYC0pc6LMOeCo2Q5wyUWTehdI26c7fwa28fuVht/I8l3tCycOpeMhGbqR
         HIvG+LqzkKzq7y2iEHXyjiW9wyKm8/017obkkSMOpK2yDqz5mgxc2qFkFiXJhgcfhzo3
         2KbnRJCbw3z50LzyZ34L258jbdmuFgi1ZkZmbxDLohfETk33DzmzjwwyCqqcQKhXOlBg
         NZgkGjCSNYK/y0II5mcoczplHqFfr+fZarq5qcPGjZkgL+sqE8I1sTaUrBOMCKxLcYex
         Qn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k+Hy19n7FuHwFcs3JayYH/6a6QV1H82GfzCUZvXtG9E=;
        b=Syha37GmNt98Ejegl4zj7HlcblmYNxYeezK99tr6N9MD2Bos1V5PbZE4MrMcGpbsTb
         AwxXVxQlwAbYJy+Fwn2uoujCl7Z9FBX+Jk5JCcZWhR/NbM0Mq13z+eVzLPxa3V50bYzJ
         wCaToWmaSREgtV3tV9r50MQbh4Yp4XoveiaOTvACpNCyTHabjPMnlw7iwkExxQR0zE0D
         2MWCEgCQDEBm3oIZ/SpsrlrNiosMkKfYaVt7xUiyA8l5Hmv8XuPLNYF7xLJ9iDCS9rnr
         3TmCfk43Sl8P+5j7zNnpHn3BJu01PnfkK1iHc+eEVLq1UtWdfChkZwKs8YJRZgkB6UXJ
         9aew==
X-Gm-Message-State: AOAM533SZUOgRokierwWCY5vfiWfBdjaCEXrUA4pXIr/IArSx8D9kSAu
        KbWqsxAoL1Dspst6HlZZJucIOfBJ1SM=
X-Google-Smtp-Source: ABdhPJzDV7t+Mio030wqwE3ZWqwSFDniRvJIygSpTKs4WI9yL6JICXgMf3/orZizQZF8JOXx/lMAOkL+95U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:ca10:: with SMTP id a16mr6601987ybg.172.1624384780054;
 Tue, 22 Jun 2021 10:59:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:30 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-46-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 45/54] KVM: x86/mmu: Collapse 32-bit PAE and 64-bit statements
 for helpers
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

Skip paging32E_init_context() and paging64_init_context_common() and go
directly to paging64_init_context() (was the common version) now that
the relevant flows don't need to distinguish between 64-bit PAE and
32-bit PAE for other reasons.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b83fd635e1f2..4e11cb284006 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4531,9 +4531,8 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 	update_last_nonleaf_level(mmu);
 }
 
-static void paging64_init_context_common(struct kvm_mmu *context)
+static void paging64_init_context(struct kvm_mmu *context)
 {
-	WARN_ON_ONCE(!is_cr4_pae(context));
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
@@ -4541,11 +4540,6 @@ static void paging64_init_context_common(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
-static void paging64_init_context(struct kvm_mmu *context)
-{
-	paging64_init_context_common(context);
-}
-
 static void paging32_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging32_page_fault;
@@ -4555,11 +4549,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
-static void paging32E_init_context(struct kvm_mmu *context)
-{
-	paging64_init_context_common(context);
-}
-
 static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 							 struct kvm_mmu_role_regs *regs)
 {
@@ -4650,8 +4639,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 	if (!is_paging(vcpu))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
-	else if (is_long_mode(vcpu))
-		context->gva_to_gpa = paging64_gva_to_gpa;
 	else if (is_pae(vcpu))
 		context->gva_to_gpa = paging64_gva_to_gpa;
 	else
@@ -4704,10 +4691,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 
 	if (!____is_cr0_pg(regs))
 		nonpaging_init_context(context);
-	else if (____is_efer_lma(regs))
+	else if (____is_cr4_pae(regs))
 		paging64_init_context(context);
-	else if (____is_cr4_pae(regs))
-		paging32E_init_context(context);
 	else
 		paging32_init_context(context);
 	context->root_level = role_regs_to_root_level(regs);
-- 
2.32.0.288.g62a8d224e6-goog

