Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CDE75D8A9
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 03:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjGVBYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 21:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjGVBYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 21:24:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299A535AD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:24:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d07cb52a768so227115276.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689989039; x=1690593839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=um0JUlmUESKdJimio+8DNUJWds66RsQougy5ghLTK+M=;
        b=jA6SOzCZ5JV7gpezuMZaywqy77akcRhAVmKuF6oqtso7tzhrR5MVVK0jfJGHg7rfJb
         FaPJ742hNwflKbWuQ22IMhyWTrBH4002LLDcFa1S87vsGhPwjHQnYseUqYK6KJ7g2RMc
         XUGtCCZRZWaTSAPtYDlqRaGN7Dx4oGErykWf4zUhs9BZ46uJlFZh46ZN8QN1Up7cpWj0
         W9zo7aSE/D5zytti/7d1f1srapwfpt/aGgQUKvId1yAi0P2UPz1QopjoYVUiZDViSRUZ
         kOqhG40It9Hg+4Hbnogmc7L/jM3hweiBdcpjXezcVzs4ENU0p4nyRFqVvowFX1ru6cuC
         TEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689989039; x=1690593839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um0JUlmUESKdJimio+8DNUJWds66RsQougy5ghLTK+M=;
        b=Pw6IrjYQjZl/z3vrY3fgEaXQTFIu/z/VBSiEfu1D6UvsxPkpQwpkb+0fLJnLmTXW8b
         TEeDXtVwCBtwc+4NamXCwIxqP7mlD3fncudlmfsrYuEVYNfVuO4wgaEy3icXyFliOuqa
         FFtv+VrTviMb2L4Tg3TJDghoLutGkb8hSE+ACir1jmGF57yBVZgjMkMHO/U47gmzuTit
         F+0C5Kc2gxBjsh5uLmcqJRTSFCr2xL6lWHZhRnTRo2iBudqUzsy0hvIm4xDRzPxH7bBQ
         7J7/Yt9MBPeB/MYJ2aGwHducG6prVnXXM1f1+YjdrbwI/lHbatFVpXaQUwfwfsC3T9QO
         XN3A==
X-Gm-Message-State: ABy/qLbkBWtkfhYch5EJco2lne9h6a6JBrehaLIocWm8vdwRoGnqz+t6
        xc1uDTTaWMC+hy2M7TgbXlYP9mnfIrE=
X-Google-Smtp-Source: APBJJlG4F4EQ9uhDHw6m55eaN7Vbz04oCDG10G4GfxVA/IFa2UOJj0VpL0Cn2kNZlQv8CFDewvS1yPBgAsA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d6ce:0:b0:c6d:a342:99f1 with SMTP id
 n197-20020a25d6ce000000b00c6da34299f1mr21928ybg.13.1689989039471; Fri, 21 Jul
 2023 18:23:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 18:23:49 -0700
In-Reply-To: <20230722012350.2371049-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230722012350.2371049-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722012350.2371049-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86/mmu: Disallow guest from using !visible slots
 for page tables
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly inject a page fault if guest attempts to use a !visible gfn
as a page table.  kvm_vcpu_gfn_to_hva_prot() will naturally handle the
case where there is no memslot, but doesn't catch the scenario where the
gfn points at a KVM-internal memslot.

Letting the guest backdoor its way into accessing KVM-internal memslots
isn't dangerous on its own, e.g. at worst the guest can crash itself, but
disallowing the behavior will simplify fixing how KVM handles !visible
guest root gfns (immediately synthesizing a triple fault when loading the
root is architecturally wrong).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..122bfc0124d3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -351,6 +351,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	++walker->level;
 
 	do {
+		struct kvm_memory_slot *slot;
 		unsigned long host_addr;
 
 		pt_access = pte_access;
@@ -381,7 +382,11 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		if (unlikely(real_gpa == INVALID_GPA))
 			return 0;
 
-		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(real_gpa));
+		if (!kvm_is_visible_memslot(slot))
+			goto error;
+
+		host_addr = gfn_to_hva_memslot_prot(slot, gpa_to_gfn(real_gpa),
 					    &walker->pte_writable[walker->level - 1]);
 		if (unlikely(kvm_is_error_hva(host_addr)))
 			goto error;
-- 
2.41.0.487.g6d72f3e995-goog

