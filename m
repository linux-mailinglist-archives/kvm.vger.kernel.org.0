Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2501650C415
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiDVWQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiDVWP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9403165C2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f6-20020a170902ab8600b0015895212d23so5390019plr.6
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zNWYQ7iy7Yr89sIEde3cCb/Lt3WEldLKJ8vXDlDeSiQ=;
        b=Ppu58rFHVoI6iW5s1gyFZJw/q+6CTvIq3bwkrX6Bfha1v9ELmxlhB6kBdaxuhU8ALA
         oZJOS2zzPK79Cbz2PaFtDvWjGOXqa3Vag3MWGfOPw2XmGt9fNogG4PyBnIzfzwu0Cr2Z
         Z9Yd3xVeeD1MsLLmQbE33yT6gDJNnLmzjIhiqgCNEusUBTkk2ljA7jNZeivTms/fsolS
         8ruvMsny7ijFMPJnejhTGx2b5qhO8OcB3N+OLEFjJPIKmS4RB11u8nQzg8mef19nDz4C
         hY7FnXWyO5/aoBz1LUQ06kXu09Mes4okVgaK01vet3BEhu0IBB9fZXiQPVzHWDrd/mUO
         dnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zNWYQ7iy7Yr89sIEde3cCb/Lt3WEldLKJ8vXDlDeSiQ=;
        b=uanpurC2naGxEx3nteTLzXbf3y20OpWKASq+koizF5yDRkOYXE2s1FtnbzaPhm20Ku
         Rf3m1ZF6aUF9NMcwR9p+XoIOsxHARCj9kg+YblJ8ampZEpcIP3A0PdXQapt6S29ptksQ
         hIepUeaDdF0igh0YIwr86kz5lI0HJTMsqTGyGEQHf+DytPhExpJrLqhD0zO51e/GXAhq
         8RPV9CE3KOnuntpBvtK9llmNNt16JQVUO3S9DHfu9Vyg+fajepZBtunB92fMLV1JQ41Z
         wg9FGiok/8AqInWq8a6SDilhqI5E7PdciN8CYW9fCE6tJJVR85Y41z5u4Hhsva/uOowL
         StOA==
X-Gm-Message-State: AOAM531L5qB2XNonXD0bEpDSO9BR9ohflgMnJoVgBNyKXte98jF7pYXc
        MaeZstsgEDXsb+xZFATz6shBN8ZMD6kL6w==
X-Google-Smtp-Source: ABdhPJyWKXLx2/uwe0ElKVg7hOGiMwOVxhtzWi1NrbfYjD0XJGhsQ6VUWZmhsGO7iXcdNSRimP+xg/0T9I02hg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:18f:b0:15a:d3e:1e47 with SMTP id
 z15-20020a170903018f00b0015a0d3e1e47mr6631600plg.54.1650661551615; Fri, 22
 Apr 2022 14:05:51 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:28 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 02/20] KVM: x86/mmu: Use a bool for direct
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3de4cce317e4..dc20eccd6a77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1703,7 +1703,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2025,7 +2025,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

