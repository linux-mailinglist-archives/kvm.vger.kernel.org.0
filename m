Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079CA3E862B
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbhHJWq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbhHJWq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 18:46:26 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EF1C061799
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:46:02 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u16-20020a05622a14d0b029028ca201eab9so263687qtx.21
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eqBNVNpWIIpSq+pfV6uCStvlMjvi00zLA50LkoAPgV0=;
        b=Dvi7ew9FQNfrSvdH1mhLdjatlydl9KSAldsi6lVVnJHMwiWuvkgF7VWvZIR+MWMDoF
         30WiHh9yT5l6Seq2QX7gC7XFItIES0zk7MVZIzyS7gs6MjPTbfy218XHcVGoM5WR2zzi
         8rS3vYrb9B7gViBuNnY5moNk5PCNewG3hxlMOuSl7x8SFgxynELmziyV73QQsJJkHdP5
         mOUoosIx0LNMfWRRGbT9U10oXAtEpu+jHsgc9omJjPVsVe99uvhJWWaZrznBNEr0Cn9t
         VWzlhiTefbmk8e8wH8LVqEQ7sWesiP6zcvrK75c3iXVrBrLDwsrfZ4sLRSih9NTyUdNA
         2/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eqBNVNpWIIpSq+pfV6uCStvlMjvi00zLA50LkoAPgV0=;
        b=nFEanRW7OSE8IJTdfNi+xVhLsTZQNGb8nvnTHq7VAXIoCm4Ci4TEGylEGthwR+1WPW
         lfoL6xgUdOkeVGYeC/zBCx0tPeSBmfiQA9ueMo80mr01c4s7Tw/n33kRfroHRw5rSFRX
         kMYctiwChtmqelQh1alHf+RBXWO7f8wJRVVXSH4Lp3xQJ4uBljuhGtIjp3UJxjBGjCow
         4SJk+GAWHHpsPCEILLmzpx3GVH9ZXfANsZxrcm+H7Fr4joCFIEzuDc5gz5yFvODTTcSj
         jb6sr7js1RggL6dW7EWcKUqDCMmy9bSIlM+301yPr//Hy9rq4OqEPFg4kD3mDXzX4oED
         ByYg==
X-Gm-Message-State: AOAM531ChWJy45b+hUUdf+nZxWSi20uPhEz4xnXplFI+dhyBxsRJghLd
        4R2N/uM8rY2Re9Lq/PeYA5HziKP5xrQ=
X-Google-Smtp-Source: ABdhPJxLku6SMROxZvTFWQNsc+G3H5PkOpVxGh+EMykrSJBYJIJl2qQiec+kJCkhkVaR3/RUMncogL+Dxs0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:1c47:622e:7a2a:372d])
 (user=seanjc job=sendgmr) by 2002:a05:6214:10e6:: with SMTP id
 q6mr31789808qvt.11.1628635562042; Tue, 10 Aug 2021 15:46:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 15:45:54 -0700
In-Reply-To: <20210810224554.2978735-1-seanjc@google.com>
Message-Id: <20210810224554.2978735-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210810224554.2978735-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Drop 'shared' param from tdp_mmu_link_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @shared from tdp_mmu_link_page() and hardcode it to work for
mmu_lock being held for read.  The helper has exactly one caller and
in all likelihood will only ever have exactly one caller.  Even if KVM
adds a path to install translations without an initiating page fault,
odds are very, very good that the path will just be a wrapper to the
"page fault" handler (both SNP and TDX RFCs propose patches to do
exactly that).

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d99e064d366f..c5b901744d15 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -257,26 +257,17 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
  *
  * @kvm: kvm instance
  * @sp: the new page
- * @shared: This operation may not be running under the exclusive use of
- *	    the MMU lock and the operation must synchronize with other
- *	    threads that might be adding or removing pages.
  * @account_nx: This page replaces a NX large page and should be marked for
  *		eventual reclaim.
  */
 static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool shared, bool account_nx)
+			      bool account_nx)
 {
-	if (shared)
-		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	else
-		lockdep_assert_held_write(&kvm->mmu_lock);
-
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
-
-	if (shared)
-		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -1062,7 +1053,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 						     !shadow_accessed_mask);
 
 			if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp, true,
+				tdp_mmu_link_page(vcpu->kvm, sp,
 						  huge_page_disallowed &&
 						  req_level >= iter.level);
 
-- 
2.32.0.605.g8dce9f2422-goog

