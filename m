Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307E450C3EF
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiDVWPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiDVWPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2C318301
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id bj12-20020a056a02018c00b003a9eebaad34so5645591pgb.10
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qj35gLZCMYjMIw6N9BxxV9K4UpqK4GN2xsPfew8h1po=;
        b=LTYqvOe8H4iYkeYGOiGGp+LDxFbJSGMgHCPdJvbGalGaPgV3owbywuxQA0M8i8kMli
         t/WctQkFGEtSGNyrmrWxpv5mmqWyVa4wrq1adnpyg3vwj+FKN/VPw3KcEn3QJa2ZaGHy
         amM1QtGztXc2MDapK4PoKtaSTSm70EXfzTBk3Csg2naDWW9xYIpxsvf8WYA8+v7loTUu
         NnIHT0jtnMCxnU6HycnCKiBJrjPG2aerN3qK3rpmiu76/NwCsJBxh2JDyki3YE13TFHW
         3RLMUsQr0W5n6/yb7Ukb8NM/9EncuYcYny9iID3dOJgijVtv6WEuioZKjMYNbf1nRhCf
         hf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qj35gLZCMYjMIw6N9BxxV9K4UpqK4GN2xsPfew8h1po=;
        b=X0DPK1l0TPUaV7pwvRvU/1jt6QRSYiJxAdHNJjoDPS5HdIcXig9ST9hF2ZmsP7YCb2
         kG6xiHblWM6++wwVTmWiyLBVImp3oaezkYjerBIFC7Krw7GhcRmF/Or5sOR+8O0W0Pup
         mpHMFb2j0Zvqs1aSpOD5ViVQEGbQLpA1HRcSn+7H1wA5dTQqqfjQ5j/AyuRQbwmLyPy+
         6i4Hl6cD8PwosqLiz2gM9FitqXjUGUIh4CtSITpBA1hTHXAP47VEWF9NlFRIqDsdBUaf
         f/IY3OksxADc64GOAc4K/WkDawRqGRYa9IR8qFNB8S8j83nelq+DIiP+XCNdf0iSD4OG
         tx+Q==
X-Gm-Message-State: AOAM531vskfU+UqXcF1UOFNfUqRp5NjjOF9HoO6+cwa4o8owVu2rDYYI
        S1oXi0fV7nrG/I/cmobYVqVpN0R7muKKgA==
X-Google-Smtp-Source: ABdhPJz9+I2RcqkgbBc37x1EPNWRxfFKvB0IAHvRY78mXJGJY+nNWbIdU+DbOHi9vy5UgEQ9XRpwIo7McSbuHQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:aa4b:b0:15a:44e6:4efb with SMTP
 id c11-20020a170902aa4b00b0015a44e64efbmr6443542plr.64.1650661555076; Fri, 22
 Apr 2022 14:05:55 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:30 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 04/20] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4249a771818b..5582badf4947 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2021,16 +2021,16 @@ static void clear_sp_write_flooding_count(u64 *spte)
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
@@ -2055,7 +2055,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		/* unsync and write-flooding only apply to indirect SPs. */
 		if (sp->role.direct)
-			goto trace_get_page;
+			goto out;
 
 		if (sp->unsync) {
 			/*
@@ -2081,14 +2081,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
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
@@ -2098,12 +2110,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
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
2.36.0.rc2.479.g8af0fa9b8e-goog

