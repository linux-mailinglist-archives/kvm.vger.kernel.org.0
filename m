Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D60F5A3263
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345427AbiHZXMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345394AbiHZXMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6D9E116D
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:40 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-340862314d9so32339897b3.3
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=eGJLCnwjODhnjhv2zAcr4ml0oV6QsKT15HaCTsjDd4Q=;
        b=WQ1RxM3AI/PQhuLFMbbYDftuVij1c/dOxuz2zfRr7OwgvLfK8ovFdnFDBFOcmNP4Yu
         tXqYb7fUt9CO/2VtGskkaJTGf4sk4/IcopL6EdUCFAvd4SBEpOrgf6321ho88K1QyXYm
         gByFrUGzyv8Q+r1DFkANIvow3SIllFJwm93ilr0j2N/AJ2uwmfa714IqbwCfwNH6EuCv
         edoX+tvVDxpWyQxkGXufFgu7Zon0daHBlYLcSb+cBYT1AVmD26pBTgPN9Id4OBrk4MlX
         Tvp6PeNQ9i8rhPeCzkBzIK8nvofzb0CjAWCMVLwcb1viRkxzLtlmy3JI3Cjs2H5XJpC9
         Ur5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=eGJLCnwjODhnjhv2zAcr4ml0oV6QsKT15HaCTsjDd4Q=;
        b=KCir0m+ZOFEUBcfWOWuJpWXAufWfw5pUn6izUgnjlpmF9oBJYEmLAbDef5cgxPCXMN
         aTI0m+/v0ntmgq48ME0ETuVC6FwvE3B1nwGHRd9vrDXGtdgnqHxPwXjHBPie87OdQh9Z
         Mxzk5dvscx5Zgt1fagsb9fYPSwp//k9FOK0TIbS+pn5CAq23p4xAOUcvRB+5I3WV28yc
         LFhNB+IqH+W/ALxvPLOgcvXeXxaQfQzMJ3k6ZXK7GOI48pxJmj74VBQqaG4n9akA8tVg
         Th8sx6GTJkTkU6X1VTFOeTJYU/U8PCdOxQl/sFZILFR0e8iP1s3pGSsPcCI+5xHZl7Nw
         n7UA==
X-Gm-Message-State: ACgBeo3GcPVszaCVP9+gC6mIyXGdC3joGdDC5BYO+ln9i6q7EHigDfV+
        zUhz07oFuacwyfaEnbqxg9pdF0609soxCg==
X-Google-Smtp-Source: AA6agR6WtAXquEKDfd/xwbohmWk7T+APzoRAyShNZdmwOjMl0pVNqoPblKAjvcgGfVGgkBTr2cZTE/KHJ1eUkA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:b71c:0:b0:340:bb98:fb38 with SMTP id
 v28-20020a81b71c000000b00340bb98fb38mr173433ywh.428.1661555559408; Fri, 26
 Aug 2022 16:12:39 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:21 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-5-dmatlack@google.com>
Subject: [PATCH v2 04/10] KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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

Handle error PFNs in kvm_faultin_pfn() rather than relying on the caller
to invoke handle_abnormal_pfn() after kvm_faultin_pfn().
Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
to make it more consistent with is_error_pfn().

This commit moves KVM closer to being able to drop
handle_abnormal_pfn(), which will reduce the amount of duplicate code in
the various page fault handlers.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 49dbe274c709..273e1771965c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3144,7 +3144,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
@@ -3165,10 +3165,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
-	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
-
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
@@ -4185,15 +4181,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
+
 	return RET_PF_CONTINUE;
 }
 
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	int ret;
+
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	return __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault);
+	if (ret != RET_PF_CONTINUE)
+		return ret;
+
+	if (unlikely(is_error_pfn(fault->pfn)))
+		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+
+	return RET_PF_CONTINUE;
 }
 
 /*
-- 
2.37.2.672.g94769d06f0-goog

