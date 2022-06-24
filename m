Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C13559F80
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiFXRSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiFXRSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56EE27160
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:12 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 15-20020a63020f000000b003fca9ebc5cbso1293992pgc.22
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CBtIzxEoZSe5ZhTRzhioItUnVf0Zv/fodY+348BL4Jk=;
        b=Nu3uofCe/nsxNpAK3LBgbcjdVEltyZKKt3N7HLTLXFAFRIqm/QveKnmGET0TxyIyk2
         yEnJDAQ59PTTV6sDafSSRs2PXbH/U0VohcUa2kZtCM9vIpvPrWQl4bQvtNEX5feFJ2F8
         zvvQtBwHve08Av1w8A2roYvTscwiqmdi80QUuqch2JSNQg52LGLkXZNIkt+5Blw+wHPA
         T4v96O1SdfjJ00Nd5ojyzWfG5dwT0dLXjm5lUWJA/EoR9ncjwVK/yCLjRsC22rxpmEDt
         FH0U5GocdK1IkIwWxPUBf3kkp7uxR2v4Sxd1oQ6DMTXAzTqgXou77PvmtTZXbx/AEeN2
         Kocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CBtIzxEoZSe5ZhTRzhioItUnVf0Zv/fodY+348BL4Jk=;
        b=4Cu/65HQEMc92ch74BuEHC631bEm4vmSJJ76qy7qQCKuDYR9RZOmeBYFIrQNGLzTdW
         3wLG+sXgponx7maHcnwje4HwoeqkxTPMoRuk+/Yrn+rOxSGGzTc9MmVAlJ6QvHbdAiTB
         YAXsQiePmoNC63Cl6bXEB89PdCcPTANHEq2kidwIB/WQ6Cc2HYL5s0ItUDEiFdJPpD/d
         6RoBr5kFbuQkgqreq27g6vywJIxznM9eyBuBWzBicRdqCQqicrT7u23o5GnmsGMCXzW0
         bYONLRk6gBhyJgmhz0j3wzzGhs3HkFdJ6a0U/4QIkNJPzDwB9fNrE7dJrfSyo6ClzStb
         EtTQ==
X-Gm-Message-State: AJIora/4IwCtfdUVuvjc6RWCEU0qzeocLYopE8LhDoy+JpFGF++Fil56
        pIXOIyJ3COKdF24wKnIlIVoRnG0wMl4=
X-Google-Smtp-Source: AGRyM1tXCF2QtzsGdPyn+Gb0ah7/CkbTQW6bD6Mw7MjgOtmuS15VDq1XYcJZiMQa+ZGp0mKF1UbLe4uDy4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3c4:b0:1ec:aa3f:8dc3 with SMTP id
 go4-20020a17090b03c400b001ecaa3f8dc3mr24086pjb.130.1656091092353; Fri, 24 Jun
 2022 10:18:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 17:18:06 +0000
In-Reply-To: <20220624171808.2845941-1-seanjc@google.com>
Message-Id: <20220624171808.2845941-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220624171808.2845941-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 1/3] KVM: x86/mmu: Avoid subtle pointer arithmetic in kvm_mmu_child_role()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When computing the quadrant (really the semicircle) for pages that shadow
4-byte guest Page Tables, grab the least significant bit of the PDE index
by using @sptep as if it were an index into an array, which it more or
less is.  Computing the PDE index using pointer arithmetic is subtle as
it relies on the pointer being a "u64 *", and is more expensive as the
compiler must perform the subtraction since the compiler doesn't know
that sptep and parent_sp->spt are tightly coupled.  Using only the value
of sptep allows the compiler to encode the computation as a SHR+AND.

Opportunstically update the comment to explicitly call out how and why
KVM uses role.quadrant to consume gPTE bits, and wrap an unnecessarily
long line.

No functional change intended.

Link: https://lore.kernel.org/all/YqvWvBv27fYzOFdE@google.com
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd74a287b54a..07dfed427d5b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2168,7 +2168,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }
 
-static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
+						  unsigned int access)
 {
 	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
 	union kvm_mmu_page_role role;
@@ -2195,13 +2196,19 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsig
 	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
 	 * @role.quadrant encodes which half of the region they map.
 	 *
-	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
-	 * assigned in mmu_alloc_root(). So only page tables need to be handled
-	 * here.
+	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
+	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
+	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
+	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
+	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
+	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
+	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
+	 * covers bit 21 (see above), thus the quadrant is calculated from the
+	 * _least_ significant bit of the PDE index.
 	 */
 	if (role.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-		role.quadrant = (sptep - parent_sp->spt) % 2;
+		role.quadrant = ((unsigned long)sptep / sizeof(*sptep)) & 1;
 	}
 
 	return role;
-- 
2.37.0.rc0.161.g10f37bed90-goog

