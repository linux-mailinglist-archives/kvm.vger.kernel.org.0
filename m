Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37370279353
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgIYVYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgIYVX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF016C0613D6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t128so134946pgb.23
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=qdut5f7Gn8gtFAtWyzdbgJG1DGusgtNnyf9bk1NcfOU=;
        b=n75SNZmXp+ycob3LZ9+327WCtH9N9zGtSq+mKW0Q3r75hy61EtZRYo6aZvdyEz1o+d
         dvJmZNWRlk+ad9Sxq1VUpAeP4FPlR4sdTYyd0ExIzO3tKxyASj3UubfDR75DF7Aph+Og
         SEdioV9D1Wk+dAQH2y54qCXohE4CIHysUtcsBTJ8KFYJ/WZNGTkyVhaCzGXcFOVuYsHv
         iaASSwpGPExonjwlRSGDzLG36gReqtihq4j2Nps9JC7BKLM000waKIiAlud/Y/+dvFgR
         IhHXF+cR3J21Vf7RWjoGfatlnVnpGoCl/bWF2mCiwuQMBYH77iujutnGJ1iNqFPY4f/i
         1cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qdut5f7Gn8gtFAtWyzdbgJG1DGusgtNnyf9bk1NcfOU=;
        b=ivxD6oFVRPJ0hPBaNhc/zWdaIC+7lNZKnJnWidutqegS+TNXdCfHgfAybYVCV9SWHa
         QEho98rVNhBGZ1QafHrMM02URbGZl+/EoIrGfv4NJhKUeSUhAqmllRRfOxECdk4rWf/x
         StJeEpyLoHjjlzrRkq2kAl6gsaXTS7FsndaY05QqQeUPcOcgdOVR17vXRt2kxIe0QREH
         RmLoLOR+xtgi7Sbh78612cMkf0NL+PqZe2J5TmiPTqMa76rc2TQ3iVxcRXq7Hf1G9s+j
         hKdy+A5vbaw15KO66pxH16d0AUj1Fh/VVwuCGiKLFK9CKgQ0BcK9mmoyG8NfRrRcQmlx
         eC8g==
X-Gm-Message-State: AOAM533/NOhgbAHU6wLcBsRdaPd06Hq6Q1v1FxDT8mqFC7jSgFnotm6U
        NpXOup+MlHsWQ7mvB8KwBAFGsj1rsl8H
X-Google-Smtp-Source: ABdhPJyEegOo4xGdxZTPvHQvTOHItCy4eaaDeJsRP6IK53GOW1QTD5m2g4papmcyOQKHh1LuccKZxxgHTQiC
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a62:cd49:0:b029:150:7742:c6c8 with SMTP id
 o70-20020a62cd490000b02901507742c6c8mr1001560pfg.61.1601069008209; Fri, 25
 Sep 2020 14:23:28 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:51 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-12-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 11/22] kvm: mmu: Factor out allocating a new tdp_mmu_page
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code to allocate a struct kvm_mmu_page for the TDP MMU out of the
root allocation code to support allocating a struct kvm_mmu_page for every
page of page table memory used by the TDP MMU, in the next commit.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 59 ++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 37bdebc2592ea..a3bcee6bf30e8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -123,27 +123,50 @@ static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
 	return NULL;
 }
 
-static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
-					       union kvm_mmu_page_role role)
+static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
+						   int level)
+{
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = vcpu->arch.mmu->shadow_root_level;
+	role.direct = true;
+	role.gpte_is_8_bytes = true;
+	role.access = ACC_ALL;
+
+	return role;
+}
+
+static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					       int level)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	sp->role.word = page_role_for_level(vcpu, level).word;
+	sp->gfn = gfn;
+	sp->tdp_mmu_page = true;
+
+	return sp;
+}
+
+static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *new_root;
 	struct kvm_mmu_page *root;
 
-	new_root = kvm_mmu_memory_cache_alloc(
-			&vcpu->arch.mmu_page_header_cache);
-	new_root->spt = kvm_mmu_memory_cache_alloc(
-			&vcpu->arch.mmu_shadow_page_cache);
-	set_page_private(virt_to_page(new_root->spt), (unsigned long)new_root);
-
-	new_root->role.word = role.word;
+	new_root = alloc_tdp_mmu_page(vcpu, 0,
+				      vcpu->arch.mmu->shadow_root_level);
 	new_root->root_count = 1;
-	new_root->gfn = 0;
-	new_root->tdp_mmu_page = true;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
 	/* Check that no matching root exists before adding this one. */
-	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
+	root = find_tdp_mmu_root_with_role(vcpu->kvm,
+		page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level));
 	if (root) {
 		get_tdp_mmu_root(vcpu->kvm, root);
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -161,18 +184,12 @@ static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
 static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *root;
-	union kvm_mmu_page_role role;
-
-	role = vcpu->arch.mmu->mmu_role.base;
-	role.level = vcpu->arch.mmu->shadow_root_level;
-	role.direct = true;
-	role.gpte_is_8_bytes = true;
-	role.access = ACC_ALL;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
 	/* Search for an already allocated root with the same role. */
-	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
+	root = find_tdp_mmu_root_with_role(vcpu->kvm,
+		page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level));
 	if (root) {
 		get_tdp_mmu_root(vcpu->kvm, root);
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -182,7 +199,7 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	/* If there is no appropriate root, allocate one. */
-	root = alloc_tdp_mmu_root(vcpu, role);
+	root = alloc_tdp_mmu_root(vcpu);
 
 	return root;
 }
-- 
2.28.0.709.gb0816b6eb0-goog

