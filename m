Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8FC55A4CE
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFXX16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiFXX1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:27:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26E587D64
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pq3-20020a17090b3d8300b001ecc27ddc0bso3366234pjb.1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+2sBtkyKsLNu0zC2SazGiR7uBsQuxEV5revLo+Poakg=;
        b=qhERotaBVV5h1AOQXBXcOi/awndAEk2PfCFQzLEDw/FsiKdvkeHJnm936S/KUZ6J/F
         ixxFjwLTALWsLQe/b4gVfrvN1BrB1KMsqCaZMIDtOFAkV6dqmNYAUBGuH8zD3l2JAJzt
         w+2JqB05tBDTkcJEWVxrRdQ/XuzEDLS2442hbPVyvjdnRKlUxpFqupA5daLunh8U+XzX
         KUiAJbiZ3M5z2fF7hs74dEDzlXcWCJBi64FpnSPLWGtccipLZqN96ojcxuhshfeOvEAX
         4rZTknMfIOZiegutb14+UBbfTYEzQd+Ba+yQJdCZasV5eqS/h3vu5UIePbpjxk0o7IjT
         ji7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+2sBtkyKsLNu0zC2SazGiR7uBsQuxEV5revLo+Poakg=;
        b=3Q3jPakSJMI1EMDNaDRSUSQkQyIP5eMOZN9R0oleA98WVMxCAR/vhyqJl3jS9IOz28
         hW4QKJzZogbi9WvKpylAR3j+wEoucPXFqx+KnStiyNtMTUp5HrOejmzNMPribMObn6pA
         qLqJn2VT9ZmXQQVwyfiVTDH4LHoJZxCprVmaZBvLFksjNtPaG4rOFMlbDBJNLSZnzLMC
         +uK83bnkaonwBi7GFscWXgJ401fwSOnKssYsJWiVkZGUL4H+qqNT0Tg3mEQFr2CkAsF1
         3EeQ0isZfyCuQuEhPdPgk/lcEww8zQqhv2b2rjPOmgykNU2VgYbKpG/sDy9X02t4S29m
         Olag==
X-Gm-Message-State: AJIora8spDC9uBj3VdGEbbzBKa45E/2vjDgO76iJ8372GHqdMdEkd7Y1
        7bNhA4B64gEvTTO0CR/a/fvU452tx1k=
X-Google-Smtp-Source: AGRyM1uG+tgKFwJ5HC+l1ITPdC/3wn0M/dvdLXUcLHn+XB9ye2sqK4PP4Pv5+ZT2JNAdNqLxwbJl6pPe3UU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:428c:b0:1ec:b866:c38e with SMTP id
 p12-20020a17090a428c00b001ecb866c38emr6751357pjg.117.1656113264499; Fri, 24
 Jun 2022 16:27:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 23:27:35 +0000
In-Reply-To: <20220624232735.3090056-1-seanjc@google.com>
Message-Id: <20220624232735.3090056-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220624232735.3090056-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 4/4] KVM: x86/mmu: Topup pte_list_desc cache iff VM is using rmaps
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
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

Topup the per-vCPU pte_list_desc caches if and only if the VM is using
rmaps, i.e. KVM is not using the TDP MMU or KVM is shadowing a nested TDP
MMU.  This avoids wasting 1280 bytes per vCPU when KVM is using the TDP
MMU and L1 is not utilizing nested TDP.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2db328d28b7b..fcbdd780075f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -646,11 +646,13 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
 
-	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
-	if (r)
-		return r;
+	if (kvm_memslots_have_rmaps(vcpu->kvm)) {
+		/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+					       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+		if (r)
+			return r;
+	}
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
-- 
2.37.0.rc0.161.g10f37bed90-goog

