Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C97526B46
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384250AbiEMU2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384206AbiEMU2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ADA980B9
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 66-20020a630545000000b003db7de758adso2459788pgf.20
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+Sv7kNyPL5ertkNdZxFciYA9vcaUcEJcKSOobOrADMc=;
        b=KF23WTkiI+zBOEBWpicHYNDifapajdcg9QdtJGa0p0hr2oVTJ15KwXLosodDzzIb2o
         Oyi3tLlTSNWU6vVZuopOLg6cqAgsKcoFykFCURldL1C+O2x3mhWkTpQVm+TXngV/OoV9
         Gz7VOrWz6MUFxqhds+p2IhVXCMXVURJFBQ3uBjsXcRX3bCsnTz1ztDOm4n4AsXWLJRq3
         wxbpDX0gXUuuqqmNel4WwcDfNEe3UVhZnkjnlvFgJymorYcYGaLeERjf4odNh6rvTNog
         akSAVTRrMrWLtbRFRez6tyvAD8TgkJ0HvxdJGTP7q5VgBwdN//pZk2ppTOUUSQEe1mSM
         siDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+Sv7kNyPL5ertkNdZxFciYA9vcaUcEJcKSOobOrADMc=;
        b=HIFuekq8C47p64GvjY+ucVwCCsn4dubd2ypDEf9ufLeIufdsOS9t84zTXjaNZYUP2S
         +DzClS7MVlQ2TKbhYqEAjRrMwbw3rFqjKgiZO4lSjMB8J2Lc2wXAFYAj2M+GNd3dpkyL
         H7MRZ6zGPJ11HGRqwZDtyJKE/pHh1Z8mzV1XhsGacqp41rBOLczPFr5Z9JTJNDAQ5+HX
         1r12d9Y6VWnQCqOMHbUVNisEdNXKQ91N4PYDcNkoM7AzutstL/Nq9jV6Vb4yniNLuo8U
         5Pi8j6UR7vJVcWBPikpQD/U6uMJkcT/urFVYzEzDTqzS+jubWtY4ajy31KvM+XqeT/eF
         GVkA==
X-Gm-Message-State: AOAM533NQYtWZqmVJTxVzCr0HjfgUnrJyPRD3xY5erv7wDBQetd3U6O6
        ZN8LD+YbVba6cpwLw5apFDszgXfGCyk6VQ==
X-Google-Smtp-Source: ABdhPJxwhDppDshguB1v/xVRglyKO+xBcau3ctqNCObYm1B3k+tEQ83O8U/DbxoBw0VUkiEwWTds+WnO8qnY9w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr250783pjo.1.1652473718175; Fri, 13
 May 2022 13:28:38 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:03 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 05/21] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
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

Decompose kvm_mmu_get_page() into separate helper functions to increase
readability and prepare for allocating shadow pages without a vcpu
pointer.

Specifically, pull the guts of kvm_mmu_get_page() into 2 helper
functions:

kvm_mmu_find_shadow_page() -
  Walks the page hash checking for any existing mmu pages that match the
  given gfn and role.

kvm_mmu_alloc_shadow_page()
  Allocates and initializes an entirely new kvm_mmu_page. This currently
  requries a vcpu pointer for allocation and looking up the memslot but
  that will be removed in a future commit.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 34786244ebad..ce334eaeef22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2019,16 +2019,16 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+						     gfn_t gfn,
+						     struct hlist_head *sp_list,
+						     union kvm_mmu_page_role role)
 {
-	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
 	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
@@ -2053,7 +2053,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		/* unsync and write-flooding only apply to indirect SPs. */
 		if (sp->role.direct)
-			goto trace_get_page;
+			goto out;
 
 		if (sp->unsync) {
 			/*
@@ -2079,14 +2079,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		__clear_sp_write_flooding_count(sp);
 
-trace_get_page:
-		trace_kvm_mmu_get_page(sp, false);
 		goto out;
 	}
 
+	sp = NULL;
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+out:
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
+	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
+		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      gfn_t gfn,
+						      struct hlist_head *sp_list,
+						      union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
 
 	sp->gfn = gfn;
 	sp->role = role;
@@ -2096,12 +2108,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
-	trace_kvm_mmu_get_page(sp, true);
-out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
+{
+	struct hlist_head *sp_list;
+	struct kvm_mmu_page *sp;
+	bool created = false;
+
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+
+	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
+	if (!sp) {
+		created = true;
+		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, sp_list, role);
+	}
+
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
-- 
2.36.0.550.gb090851708-goog

