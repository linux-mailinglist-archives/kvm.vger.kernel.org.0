Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB7473833
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbhLMW7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244090AbhLMW7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:35 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B87C0613F8
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:35 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id d2-20020a656202000000b00325603f7d0bso9698751pgv.12
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vq4mbu6fz8Ow9uMLnS6d9eLKMx/rjEnAVHjxQnrA+mQ=;
        b=QVTLQGpenttmwWwLZqpjBqB4eIk5+PzIhwr/0o9M/0ICD/6rRAo5JU07SrrCfFeSbv
         tnR5WHNWfbmewJDwtXgrA7jNwOzOGYn0Ls0SsNHaZy6d0hEDohe2DHrMiOzNOr7XrJeH
         BUXTaXt5B5ya8PN/b5adRlX1xUv25QmWNIIBt6PSsFA5PiiIqQ6uGydRq1ogo1CicDmF
         1oPkvNrGDXwiJqYwE6DcAxZMQStXncjz0mSDJwCuRnhGhtUd2VNBOjDGnBDH1NqJaAb2
         lWMfwjGcXccAGoPMuyZ80ETfOGkp5i/GbIJasldz5WblzE4fyPa6BN6ffL3Isa7jVPmn
         GAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vq4mbu6fz8Ow9uMLnS6d9eLKMx/rjEnAVHjxQnrA+mQ=;
        b=rQTa1PrcDUM3YNdVI7RIyBcAGyF/DDAJs1ehshTk7y/jpg0N/iymreJ9REtGDzCjMp
         bpor2CmoTRog9sFizaTL0M0w1/slv5oKa3ptVcT0tD0eXJ1BZwo8W2AtepWaqjOc+n00
         wQzqYCxZDkug5Gzuhoqle7up0qVjGVSn76Gbb6IYLzt49kUaVCmCjOMUm2XBrlDPbvGn
         pGImf648zKeqidc8MZCUFOd6YTEGw148n4+jq1SMqHB6rDYL0yG3cmYCXOMmm3zWZGPf
         VGCFKwBmiAyGsIV4WW/fBQz3GWDxwV+H142HGmXrsLGXXlwJwi1wn9qcMtIQ1ErbdVFX
         lM/A==
X-Gm-Message-State: AOAM533fLAGrZbdKhF6tXV7ETmcoVAwJ8nbgQfoz8OgcFndSvwRrQYdU
        BGhiBsdCtLZpk+GwkfTobbowfc3UtE3UDA==
X-Google-Smtp-Source: ABdhPJwwNB2Z/LMLffQBlfS70bMPPswHXuWQk7NnsUDg9E95Wx8FFAyJTpwkjjyh9SS87Epffnb3Q+4yW6OuxA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e8d4:b0:143:88c2:e2c9 with SMTP
 id v20-20020a170902e8d400b0014388c2e2c9mr1235324plg.12.1639436374670; Mon, 13
 Dec 2021 14:59:34 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:13 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page initialization
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the allocation of child pages from the initialization. This is
in preparation for doing page splitting outside of the vCPU fault
context which requires a different allocation mechanism.

No functional changed intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 582d9a798899..a8354d8578f1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -157,13 +157,18 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					       union kvm_mmu_page_role role)
+static struct kvm_mmu_page *alloc_tdp_mmu_page_from_caches(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+
+	return sp;
+}
+
+static void init_tdp_mmu_page(struct kvm_mmu_page *sp, gfn_t gfn, union kvm_mmu_page_role role)
+{
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
@@ -171,11 +176,9 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
-
-	return sp;
 }
 
-static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
+static void init_child_tdp_mmu_page(struct kvm_mmu_page *child_sp, struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *parent_sp;
 	union kvm_mmu_page_role role;
@@ -185,7 +188,17 @@ static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, stru
 	role = parent_sp->role;
 	role.level--;
 
-	return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
+	init_tdp_mmu_page(child_sp, iter->gfn, role);
+}
+
+static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
+{
+	struct kvm_mmu_page *child_sp;
+
+	child_sp = alloc_tdp_mmu_page_from_caches(vcpu);
+	init_child_tdp_mmu_page(child_sp, iter);
+
+	return child_sp;
 }
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
@@ -210,7 +223,10 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, role);
+	root = alloc_tdp_mmu_page_from_caches(vcpu);
+
+	init_tdp_mmu_page(root, 0, role);
+
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-- 
2.34.1.173.g76aa8bc2d0-goog

