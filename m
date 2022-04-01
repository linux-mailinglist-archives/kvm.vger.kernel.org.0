Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3704EF945
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350667AbiDAR6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350645AbiDAR6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE041834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:13 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ml1-20020a17090b360100b001ca140b56ffso1925645pjb.7
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T6MU8k6cQbf3TkeoEFiVrn7xHGx6m7+aDUnGVn3gY9A=;
        b=psRoNjQx06GKBw5vk1GEEdr6zd56BqsU6L5ZB+rOQfu2XH6HJb+EMCsMZX4hnwAonC
         2qG5EnZHZ6vyxBjGbdz8b1ylt6lv4n/XYVsWPs5pHj7JFPfkrX1V4OyHPShUpqfk7GLA
         d911moNr53YYCdp3FNox0tSzlA0Fh25LgD83E572TTJFC+Gdm06EViMmGs2KvtC8wZ6W
         x17XSyEP01m5bqVgtCZ+WxHNdlHXdwqVUZvyOmLgdiN5Hlznx1jD+fC30Tj0tHOgwdXd
         rQUzG3elXhJ5R145vXnIyE5klI/0eFbeDgab/AtBOOlKGNWRf4G056rfgCyinO9LPkIZ
         +xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T6MU8k6cQbf3TkeoEFiVrn7xHGx6m7+aDUnGVn3gY9A=;
        b=GgmYn3Px9hsxtfppfpNjd8ko6PO3aCLxdGKv9vubsWWnqsSozNfkOIj4UldQU9RyQN
         rUunQJEuweT+pzlIfScIcw2LMcNHDfpZmgmFlOmURU0JJTAVLavXkitU6E3cOdT0w+0o
         w8O2HgVS3xnJ5Ky0lmYu/jQyGIwF1enWlC6bQqpRLFoxzxMgHmiNxpbRPqw/pURKFIsD
         Wt8cXNs3J8kautnJ9F0tTcHgkn46IdcUi98pjX7ZN7JVD31J32ilZ7RjVUdsL24udf/X
         GLtKwbBMjqRyt9WNE7E7VRbXTmZU6hxSEE4i4nut0qevQqXA9BV+ntYiaFPhSvMfDTki
         GJRw==
X-Gm-Message-State: AOAM530WePRmpDvmO5lrR656na0bh0tJNTbr+Y/bG6F1Sbw8C3YYbx2N
        K5pd9WVrJ9Rd4uo9P5HN4ZjVqFi7Sr/hxw==
X-Google-Smtp-Source: ABdhPJxpf4Ryvjy4Xf0xw/2qrejO1ASWA3zDiH/Rc6IEicNMwrszz8mQR+qiF4YjulK0xOMtMCMyzDcI70BvKg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:995:b0:4fb:607d:444c with SMTP
 id u21-20020a056a00099500b004fb607d444cmr12098520pfg.69.1648835772682; Fri,
 01 Apr 2022 10:56:12 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:38 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 07/23] KVM: x86/mmu: Separate shadow MMU sp allocation from initialization
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the code that allocates a new shadow page from the vCPU caches
from the code that initializes it. This is in preparation for creating
new shadow pages from VM ioctls for eager page splitting, where we do
not have access to the vCPU caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index abfb3e5d1372..421fcbc97f9e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2123,27 +2116,31 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
-						    struct kvm_memory_slot *slot,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp;
 	struct hlist_head *sp_list;
 
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, 1);
+
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, slot, sp);
-
-	return sp;
+		account_shadowed(kvm, slot, sp);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
@@ -2158,7 +2155,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	if (!sp) {
 		created = true;
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
+		init_shadow_page(vcpu->kvm, sp, slot, gfn, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.1094.g7c7d902a7c-goog

