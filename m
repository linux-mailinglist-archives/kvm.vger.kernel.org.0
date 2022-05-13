Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E234B526ABD
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383934AbiEMTuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383912AbiEMTuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:50:07 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B92AC60
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:05 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y2-20020a17090a474200b001dead634389so4789067pjg.9
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=f7yzhfisk2h8SeZqMk+S4T8cT4lhDdnwCiG3Dpdd8fo=;
        b=pDK8cgIt+nRNbSGx8CFEQTj3ejYbBQrgiRGoeUNz3MJMNd1xbE9rZnQrT9/55ZuyRU
         ZXWBpxSXylg+TutIljZ3z4P6vfOS8tHOdWC9H20Rqxni7xPlBMrvE1e3khOO0biZrPMA
         6KuRRwULLCi5v3071KvZdVd/ieraSJ5BpCHv8clwiWSXw5BQ1QJTl6WJFEKrnKdna8os
         zGN+3NPeY4ROds4c5WuGUIXxSxShCDiHwk0TC9FtijtVaE5cPHrpUfvNRsPj83cPMtxE
         gCSNU9hV5KwLmm+QJmh1ZrBSOKIM9Roc3qXbV9z++ME/AQCBSPiD/0OF/8gw+/7rg2Fn
         vFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=f7yzhfisk2h8SeZqMk+S4T8cT4lhDdnwCiG3Dpdd8fo=;
        b=2fPqoZibXBcYMugxXKcv/xBoFYVJlHqyvkHBkN6QlhGEBi/dLVw4NDyvVTMC0vL1GT
         DMaJRTNIOmpvadYezm7NqgIxRzZRgAzPTOnU8/g0gDH9SF8RN3YQqIxEPBLONQCbvpbR
         /pfy3N8UP5b54s7mduKDJpi9OPs8KmQSyQP3VU8ggePuztLJVVdRegRrpVnfSrzl/gfp
         DY0gWnVJrN8q1H/hr0qJrbrqztcjtnp9t0Qe6AKuYmc8Iisx+1Pth4orfvKYqFEdDp9v
         gkL6T5DPeHdfJi23z0aW4Aya+Pe0L7Fx3+2ufMZbaSXdEgXBkXfU/53lkS8RbGNH/7vF
         sgTg==
X-Gm-Message-State: AOAM530dgZMVwp3eE5nernT1vnCqQpj7vNmG0aylUDnhY3z7FzDc9wcR
        i2bNrhSdKuZ7CVEBRGqlcZmbNi6NAgE=
X-Google-Smtp-Source: ABdhPJwNEM4TQVDfcOqfwwqUCYDS33CTgnArS4Jj/reH2CsvjHdpUejF2aXDoe6kftMyC+K6GXs99QiHEGE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b703:b0:15e:ea16:2c6e with SMTP id
 d3-20020a170902b70300b0015eea162c6emr6043987pls.100.1652471405059; Fri, 13
 May 2022 12:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 13 May 2022 19:49:59 +0000
In-Reply-To: <20220513195000.99371-1-seanjc@google.com>
Message-Id: <20220513195000.99371-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220513195000.99371-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

Drop SPTEs whose new protections will yield a RWX=0 SPTE, i.e. a SPTE
that is marked shadow-present but is not-present in the page tables.  If
EPT with execute-only support is in use by L1, KVM can create a RWX=0
SPTE can be created for an EPTE if the upper level combined permissions
are R (or RW) and the leaf EPTE is changed from R (or RW) to X.  Because
the EPTE is considered present when viewed in isolation, and no reserved
bits are set, FNAME(prefetch_invalid_gpte) will consider the GPTE valid.

Creating a not-present SPTE isn't fatal as the SPTE is "correct" in the
sense that the guest translation is inaccesible (the combined protections
of all levels yield RWX=0), i.e. the guest won't get stuck in an infinite
loop.  If EPT A/D bits are disabled, KVM can mistake the SPTE for an
access-tracked SPTE.  But again, such confusion isn't fatal as the "saved"
protections are also RWX=0.

Add a WARN in make_spte() to detect creation of SPTEs that will result in
RWX=0 protections, which is the real motivation for fixing ept_sync_page().
Creating a useless SPTE means KVM messed up _something_, even if whatever
goof occurred doesn't manifest as a functional bug.

Fixes: d95c55687e11 ("kvm: mmu: track read permission explicitly for shadow EPT page tables")
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 ++++++++-
 arch/x86/kvm/mmu/spte.c        | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b025decf610d..d9f98f9ed4a0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1052,7 +1052,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		/*
+		 * Drop the SPTE if the new protections would result in a RWX=0
+		 * SPTE or if the gfn is changing.  The RWX=0 case only affects
+		 * EPT with execute-only support, i.e. EPT without an effective
+		 * "present" bit, as all other paging modes will create a
+		 * read-only SPTE if pte_access is zero.
+		 */
+		if ((!pte_access && !shadow_present_mask) || gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c9e87d446a..9ad60662beac 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -101,6 +101,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
+	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
-- 
2.36.0.550.gb090851708-goog

