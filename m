Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD613526B3E
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384199AbiEMU2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384181AbiEMU2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926411116A
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x9-20020a056a000bc900b0050d919e9c9bso4477746pfu.1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
        b=lIVEL9NlTTvEk0jvQdHGYdcqrkD4LzOGT+wWlx67gTGwgZCjTYYlZT0CXziIbqm805
         xEKGjNBHceio2qKgjjTz8s9D5VtcH+dahCCFdmRcTqau/OYncXoMwZfNVfZijldNuv9t
         x/H0ytTC9mY//Xnze7OLPh7PnqyEe8fMWdiFNyA0LYDukR0MWxkuWuz89LLmeMUnb3Oe
         v0KP285xw0HkbLpInenTzibDOT9o6C/Gd0WhPdssg4N88symfMODlZ+JGY+RaQNZ+zOR
         A+TvhwsKTkkv6Ipa2LjdGJ7/AkMXZWaOORe18arUxR6aWUMglTc9tXO4XNDRNYNitv9G
         4f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
        b=MqqRttMSDZ1oBRAxP8dd5oh+hXtfwmGpRu226gfthisIWx1L2/6DNLqxdBqk7JNwwV
         QHB+LPKQKIFqPeyZvJ7FtUerQjtEg0O4rbwZ01ptciUwim9lOIB4Xp7sFpWnOnCQ7uNT
         jtW1yd93cVyOoq7eBF3zxTyFW2VxYhq7MH4XaD33AjPd5lzgr8hZKRzVXIEYmlbPbHhX
         ppGjHjvH8e/NVgz8PpAOH6lA2BVBPonmNN3KC8Fbh539Zo4LdDQm+g0PrLthmzFWyinT
         RVGKbhQ1ftuHsfaBur4AF7hVbrAPxvYvFNnv1lxW9KOf9zFfIVzIwu/kp3AAyIJQiUHl
         p1fA==
X-Gm-Message-State: AOAM5313jVe0nnvfKny9v2gI1Zw1qqqk5BMFc+wP+ShsNi6H3Z0PuzSE
        qlJta+/68JgWrfZv8LyTCDs5HIOr7ao/bw==
X-Google-Smtp-Source: ABdhPJxPNMW3m8DWDbKR8Cxzp87MsHzpapuqXK0x8Mkd7Lb+oA/CXzKK6BuuZIvN94SWRy5m3PsmasidYIIY8g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr250707pjy.0.1652473708906; Fri, 13
 May 2022 13:28:28 -0700 (PDT)
Date:   Fri, 13 May 2022 20:27:59 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 01/21] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
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

Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
fully direct MMUs") skipped the unsync checks and write flood clearing
for full direct MMUs. We can extend this further to skip the checks for
all direct shadow pages. Direct shadow pages in indirect MMUs (i.e.
shadow paging) are used when shadowing a guest huge page with smaller
pages. Such direct shadow pages, like their counterparts in fully direct
MMUs, are never marked unsynced or have a non-zero write-flooding count.

Checking sp->role.direct also generates better code than checking
direct_map because, due to register pressure, direct_map has to get
shoved onto the stack and then pulled back off.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..774810d8a2ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2026,7 +2026,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->root_role.direct;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2070,7 +2069,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {
-- 
2.36.0.550.gb090851708-goog

