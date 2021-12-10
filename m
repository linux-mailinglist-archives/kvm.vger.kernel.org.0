Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE94346FDAA
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbhLJJ2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhLJJ2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:47 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B41C061746;
        Fri, 10 Dec 2021 01:25:12 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g16so7584010pgi.1;
        Fri, 10 Dec 2021 01:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jvyh985iWE+52Vh0gYXmI7swXmsP4Ob31Ssk6jo1Jmo=;
        b=JeGYCb8anqRLCaVkwzFfsIaUqPabj6B0+QdcghkTTh6b4A2Dgxh1I24AJvHlRMJ6W6
         FIqm4n5zCxmUIpPM2VCIaxeVgB/xZedPLYJ2fi3KTcDmdZscIXuBmUlCbPCJiK/c9ttk
         f5TOOvos8z6l2tz4ZYa2pe8pYGFQG72vpWyycPqtwcuWukegtQgsf6JgaMcoat5MFEXB
         4jqu453lGNYWr8Z3wko/8aNvZ+dqa7m6T5Y13xpWDSBlzBaHGQ08iz7wxGRU4dVmWM7S
         cuoFHYXnyQuUnygz1vsctl42d3hxRsdT9PqAKnMfPvuhzJ3y9nhx6jDK5bMRh3BxQoJH
         kXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jvyh985iWE+52Vh0gYXmI7swXmsP4Ob31Ssk6jo1Jmo=;
        b=gb2vYVzzqpkNjHroRCnBP8xjllmlaCEuzOI0C4/ZeO3Pjw2MRXlUQOradlNLWrjcB2
         8VgwZghlWUbDvWS9JbbHgdz69SE0wNoRqsotRIJepK0xNnl2vuXBG20YyynBMTz9j8jF
         uV2FghpgrAUPpooVulDHNjkjjZwDpFbux5WPGzkLNnl0cAR2DEX4/p88aP3aumnIEq6I
         P9Y1Al7+Amyi/03OKyolK/FOxvHk1cgbnS29O+da0pzOd6NYk4lzxbLfzU8B8kI7C17s
         nKeS4IrgsQE0IDXYyluWcXXuqxaehodPSchcvK/6yVjPhj6NSoX+H7spcLUMXubI7aMe
         E+Sw==
X-Gm-Message-State: AOAM531nIHRM/EXTa57k1IuqpZNvX15a89RVVg6EV58mYpynpwRCMFcG
        5WObZHYWV2rVDZekKzYY63r04lXgbmo=
X-Google-Smtp-Source: ABdhPJy40TqoGqMn7su0neDQlDJO8kt3xEmiY0vgHBohqtDu8HrhV6VFlxJNBQQsg08CSoeJmcwGmQ==
X-Received: by 2002:aa7:98dd:0:b0:49f:bab8:3b67 with SMTP id e29-20020aa798dd000000b0049fbab83b67mr16922004pfm.86.1639128311996;
        Fri, 10 Dec 2021 01:25:11 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id rm10sm2616421pjb.29.2021.12.10.01.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:25:11 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 3/6] KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
Date:   Fri, 10 Dec 2021 17:25:05 +0800
Message-Id: <20211210092508.7185-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

kvm_mmu_alloc_page() will access to more bits of the role.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 846a2e426e0b..54e7cbc15380 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1734,13 +1734,13 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn, union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!direct)
+	if (!role.direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -1752,6 +1752,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->gfn = gfn;
+	sp->role = role;
 	return sp;
 }
 
@@ -2138,10 +2140,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
-
-	sp->gfn = gfn;
-	sp->role = role;
+	sp = kvm_mmu_alloc_page(vcpu, gfn, role);
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-- 
2.19.1.6.gb485710b

