Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB74EC578
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345885AbiC3NXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345969AbiC3NXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:23:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED1488AB;
        Wed, 30 Mar 2022 06:21:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g9-20020a17090ace8900b001c7cce3c0aeso2086679pju.2;
        Wed, 30 Mar 2022 06:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+K9A9T1MT5Pu4zwSaAayliqn5gty12AfuascxX8vj4=;
        b=nEtLG65GgDBD2ThZgHCDsZSsWRfepUZEr5TeRQW+HtYt93+fIBsLwgJEoJ+SrOVbsx
         I3DpuEUxZPrVmRiHyTmTZ3k2yh+BkJ57O3gLmdc0LtMWpE9Q+uUco6nio+wdSFHbMBHt
         D4/hR/62epIpkTU7rrMrS1WhkTGD8MYRXv0IMGIsd53JvKVUXkF4fYMMGcWEevaH7M/8
         k306OdR8OwTQs9qkiHnjwTXmYDuJenGzIvsOxBfB+f+o+b4moEVER02SmAwgPju/EP1c
         NcKiUJ24zRt6c/SZMteODK5UJZKGBwpbApoi1ZhFEf3FMAYSA5bpdNr1DOuB1ZSTy9aX
         GjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+K9A9T1MT5Pu4zwSaAayliqn5gty12AfuascxX8vj4=;
        b=pG6gjLl4bhH01L6PqU6C16WXi9ivhyXBrAuDkBfv7EluGg4F1Mey+/SQB0kfodow56
         cXohSU3tsUF7rawrIRydAHtKy9SWMDqn7wLYQiud5Qb6LcldQqCcs62q9Ky4c9NWZvMQ
         hD/Qkk45qAFxjFuy2Q/QjI0yPHGITt18/IRvwNX9Js6xpaZpd6sKTGyIfgSpnC80rb4m
         XH8OAHMwAi9nPtnaGIgEEefZU3y5evfS7Jf5cDMVHHgO8pk+CMt6ekW+y+/UdbO8S5Rz
         GHxw3afy+G5pCSFeuW59fK8uR9c7IWJgQw4szjo61sXsQpfpuBJgOSQ5cv6pYi/NsONS
         I/VQ==
X-Gm-Message-State: AOAM532lUfXpoB+UJc9n0bkOrqk0bLkuoDigiCD2fMW7k6U/9OXC6K0A
        7mwkFeboGqFNmw8rg/4cU70uSNfwlEc=
X-Google-Smtp-Source: ABdhPJyH4MR2bW42j1R3tqij52APbZ6yL1b9+zWFJQj/5rP4QGk3QtQkM5+iX50/sGAz6Uus6QIn4Q==
X-Received: by 2002:a17:90a:1548:b0:1c9:8181:9e70 with SMTP id y8-20020a17090a154800b001c981819e70mr5089434pja.78.1648646479563;
        Wed, 30 Mar 2022 06:21:19 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm23525250pfj.128.2022.03.30.06.21.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Mar 2022 06:21:19 -0700 (PDT)
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
Subject: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level expanded pagetable
Date:   Wed, 30 Mar 2022 21:21:50 +0800
Message-Id: <20220330132152.4568-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220330132152.4568-1-jiangshanlai@gmail.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
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

This patch adds role.glevel to address the two problems.
With the new role.glevel, passthrough sp can be created for expanded
shadow pagetable: 0 < role.glevel < role.level.

An alternative way to fix the problem of case4 is that: also using the
special root pml5_root for it.  But it would required to change many
other places because it is assumption that special roots is only used
for 32bit guests.

This patch also paves the way to use passthrough shadow page for
case1-3, but that requires the special handling or PAE paging, so the
extensive usage of it is in later patches.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 Documentation/virt/kvm/mmu.rst  |  7 +++++++
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 5b1ebad24c77..dee0e96d694a 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -202,6 +202,13 @@ Shadow pages contain the following information:
     Is 1 if the MMU instance cannot use A/D bits.  EPT did not have A/D
     bits before Haswell; shadow EPT page tables also cannot use A/D bits
     if the L1 hypervisor does not enable them.
+  role.glevel:
+    The level in guest pagetable if the sp is indirect.  Is 0 if the sp
+    is direct without corresponding guest pagetable, like TDP or !CR0.PG.
+    When role.level > guest paging level, indirect sp is created on the
+    top with role.glevel = guest paging level and acks as passthrough sp
+    and its contents are specially installed rather than the translations
+    of the corresponding guest pagetable.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..67e1bccaf472 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -314,7 +314,7 @@ struct kvm_kernel_irq_routing_entry;
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
  * Therefore, the maximum number of possible upper-level shadow pages for a
- * single gfn is a bit less than 2^13.
+ * single gfn is a bit less than 2^15.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -331,7 +331,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned glevel:4;
+		unsigned :2;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02eae110cbe1..d53037df8177 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -737,8 +737,12 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
-	if (!sp->role.direct)
+	if (!sp->role.direct) {
+		if (unlikely(sp->role.glevel < sp->role.level))
+			return sp->gfn;
+
 		return sp->gfns[index];
+	}
 
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
@@ -746,6 +750,11 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
 {
 	if (!sp->role.direct) {
+		if (unlikely(sp->role.glevel < sp->role.level)) {
+			WARN_ON_ONCE(gfn != sp->gfn);
+			return;
+		}
+
 		sp->gfns[index] = gfn;
 		return;
 	}
@@ -1674,8 +1683,7 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+	free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1713,7 +1721,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!role.direct)
+	if (role.glevel == role.level)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -2054,6 +2062,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
+	if (level < role.glevel)
+		role.glevel = level;
 
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
@@ -4817,6 +4827,7 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
 	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
 	role.base.has_4_byte_gpte = ____is_cr0_pg(regs) && !____is_cr4_pae(regs);
+	role.base.glevel = role_regs_to_root_level(regs);
 
 	return role;
 }
@@ -5312,6 +5323,8 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	++vcpu->kvm->stat.mmu_pte_write;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
+		if (sp->role.glevel < sp->role.level)
+			continue;
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8621188b46df..67489a060eba 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1042,6 +1042,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		.level = 0xf,
 		.access = 0x7,
 		.quadrant = 0x3,
+		.glevel = 0xf,
 	};
 
 	/*
-- 
2.19.1.6.gb485710b

