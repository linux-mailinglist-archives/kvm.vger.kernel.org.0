Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56874EB0C5
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbiC2PhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 11:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbiC2PhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 11:37:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D29C25514C;
        Tue, 29 Mar 2022 08:35:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v4so17858278pjh.2;
        Tue, 29 Mar 2022 08:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJoiV/BDnKM8S0dlkNbqY02WyI79kKm9a6oF1D+VZjQ=;
        b=UrCaRCfqodS38TgZBTOsVU5UhhrzbNBrSxUDrKKDh7JXN/xiZhruQzxh2syrGKHg5Q
         c52Uk7aWKy9IK9KApxF7iqD2M14Sy4XrFuSUlen3UTtgIopEJAaGeUghoO++Es2mFFYQ
         qdUM0LX+bSqi9nKx2IT1Bt3Xqtyp/9xwjZhDPX0f3E3jWAPwGU6oLCPlKWsnGjLuZN1e
         fiWhQVRn11x7D34YyyvtrCEuvHAazd6zUtx+5TK/TrE63YiTDdEUXmpWVpA8tXm+ywEo
         G++rZZ0JvX0tTGwy2OtmvbUBc1djwRMsPDJDV0TdltXqf0duaFGFF76jgRq/Lzv/3d91
         KuzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJoiV/BDnKM8S0dlkNbqY02WyI79kKm9a6oF1D+VZjQ=;
        b=T6q1uCsrb6ZVJlJ3pDsu4zmkzxZ8LMZQ0NRhOQkGtat0gKvxS0j93+IGf53DRHwucL
         4+jJqJpi2Cw1ZXxL+STRGNSy0f3GK+TcsB7zyjuAmkUdJbiWB7mOWueQU5igCwFOMaNe
         6XJnu6L7ESpJsBriEQtug9cFoKwv5GCOfbp/TZsRCirqkqdqr8b/w/WzSdSIOPE47d0z
         w2P5TeVGWKCdXFhqcaVqIe+25jrXZChxilzzdaowU53rHfvYs+ayFBBTaFo+HTySctH2
         GPgDzwSr1H12aTPKq3EPop1JqmowJZjVECjn7AYH/ITIex2hndWfA1uWAK9Co9t3eYZt
         XNgw==
X-Gm-Message-State: AOAM531+hiLVEqFlCLqCqA/1JBomoBW8CXgMGJwsmzESiBEplOL/VY37
        BToXy9jQ5oSJK+fQ1dBGoBsjjdTziR0=
X-Google-Smtp-Source: ABdhPJx9GgUl+CMMmUAJQRuIAr/zeL3tXlL0PgMjjmyjpzecsTU9ObGOoLFvD5kkDaSUCi6zoU6BoQ==
X-Received: by 2002:a17:902:e40a:b0:155:d894:79a3 with SMTP id m10-20020a170902e40a00b00155d89479a3mr21715995ple.73.1648568135557;
        Tue, 29 Mar 2022 08:35:35 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm2618230pge.44.2022.03.29.08.35.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Mar 2022 08:35:35 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: [RFC PATCH V2 2/4] KVM: X86: Introduce role.passthrough for level expanded pagetable
Date:   Tue, 29 Mar 2022 23:36:02 +0800
Message-Id: <20220329153604.507475-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220329153604.507475-1-jiangshanlai@gmail.com>
References: <20220329153604.507475-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Level expansion occurs when mmu->shadow_root_level > mmu->root_level.

There are several cases that can cuase level expansion:

shadow mmu (shadow paging for 32 bit guest):
	case1:	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0

shadow nested NPT (for 32bit L1 hypervisor):
	case2:	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
	case3:	gCR0_PG=1,gEFER_LMA=0,hEFER_LMA=1

shadow nested NPT (for 64bit L1 hypervisor):
	case4:	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1

When level expansion occurs (32bit guest, case1-3), special roots are
often used.  But case4 is not using special roots.  It uses shadow page
without fully aware of the specialty.  It might work accidentally:
	1) The root_page (root_sp->spt) is allocated with level = 5,
	   and root_sp->spt[0] is allocated with the same gfn and the
	   same role except role.level = 4.  Luckly that they are
	   different shadow pages.
	2) FNAME(walk_addr_generic) sets walker->table_gfn[4] and
	   walker->pt_access[4], which are normally unused when
	   mmu->shadow_root_level == mmu->root_level == 4, so that
	   FNAME(fetch) can use them to allocate shadow page for
	   root_sp->spt[0] and link them when shadow_root_level == 5.

But it has problems.
If the guest switches from gCR4_LA57=0 to gCR4_LA57=1 (or vice verse)
and uses the same gfn as the root for the nNPT before and after
switching gCR4_LA57.  The host (hCR4_LA57=1) wold use the same root_sp
for guest even guest switches gCR4_LA57.  The guest will see unexpected
page mapped and L2 can hurts L1.  It is lucky the the problem can't
hurt L0.

The root_sp should be like role.direct=1 sometimes: its contents are
not backed by gptes, root_sp->gfns is meaningless.  For a normal high
level sp, sp->gfns is often unused and kept zero, but it could be
relevant and meaningful when sp->gfns is used because they are back
by concret gptes.  For expanded root_sp described before, root_sp
is just a portal to contribute root_sp->spt[0], and root_sp should not
have root_sp->gfns and root_sp->spt[0] should not be dropped if gpte[0]
of the root gfn is changed.

This patch adds role.passthrough to address the two problems.
role.passthrough is set for expanded shadow pagetable:
role.level > gMMU.level.

An alternative way to fix the problem of case4 is that: also using the
special root pml5_root for it.  But it would required to change many
other places because it is assumption that special roots is only used
for 32bit guests.

This patch also paves the way to use passthrough shadow page for
case1-3, but that requires the special handling or PAE paging, so the
extensive usage of it is in later patches.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 Documentation/virt/kvm/mmu.rst  |  5 +++++
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++++++++---
 arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 5b1ebad24c77..60c4057ef625 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -202,6 +202,11 @@ Shadow pages contain the following information:
     Is 1 if the MMU instance cannot use A/D bits.  EPT did not have A/D
     bits before Haswell; shadow EPT page tables also cannot use A/D bits
     if the L1 hypervisor does not enable them.
+  role.passthrough:
+    Is 1 if role.level > guest paging level when shadow paging level is
+    larger than guest paging level; passthrough shadow page tables must
+    be created on the top. Like when role.has_4_byte_gpte or shadow NPT
+    for 32 bit L1 or 5-level shadow NPT for 4-level NPT L1.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..1e6bf563b939 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -314,7 +314,7 @@ struct kvm_kernel_irq_routing_entry;
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
  * Therefore, the maximum number of possible upper-level shadow pages for a
- * single gfn is a bit less than 2^13.
+ * single gfn is a bit less than 2^14.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -331,7 +331,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned passthrough:1;
+		unsigned :5;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8449ae089593..54c7db7c9608 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -737,6 +737,9 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
+	if (sp->role.passthrough)
+		return sp->gfn;
+
 	if (!sp->role.direct)
 		return sp->gfns[index];
 
@@ -745,6 +748,11 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
 {
+	if (sp->role.passthrough) {
+		WARN_ON_ONCE(gfn != sp->gfn);
+		return;
+	}
+
 	if (!sp->role.direct) {
 		sp->gfns[index] = gfn;
 		return;
@@ -1674,8 +1682,7 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+	free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1713,7 +1720,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!role.direct)
+	if (!role.direct && !role.passthrough)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -2054,6 +2061,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
+	if (level <= vcpu->arch.mmu->root_level)
+		role.passthrough = 0;
 
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
@@ -4882,6 +4891,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 
 	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
+	if (role.base.level > role_regs_to_root_level(regs))
+		role.base.passthrough = 1;
 
 	return role;
 }
@@ -5312,6 +5323,8 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	++vcpu->kvm->stat.mmu_pte_write;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
+		if (sp->role.passthrough)
+			continue;
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8621188b46df..c1b975fb85a2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1042,6 +1042,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		.level = 0xf,
 		.access = 0x7,
 		.quadrant = 0x3,
+		.passthrough = 0x1,
 	};
 
 	/*
-- 
2.19.1.6.gb485710b

