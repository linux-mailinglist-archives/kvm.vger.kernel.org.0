Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6627845C44C
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348510AbhKXNrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbhKXNpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436FC04A4FA;
        Wed, 24 Nov 2021 04:21:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so4891232pjc.4;
        Wed, 24 Nov 2021 04:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wd98xQLQ/pXf9ib4u6bLtTjsr2IvaHY/2gqbkIzN0/4=;
        b=nDw17EGrKlKzgCNbqTAO4qrT4BcO03O3lXSTZZgQiTsbRqo8xhfSlNWM1850aAgT05
         0r9DGKtSvIWT9wVb9O2SGj4drBh7nxh5tZk1UCf85gTPNwBwjwv9aNEbJNbt15SLKyi5
         mOh0SWwcFtOfvzaSavVcBGzOUqorZmnM4szZgWu2pX2ri0QL9fuZbiOyLcSO2jDoh/yK
         gNh9Z1ZsW/YPvG/MbwGskz/UWgvtU6hcDfISO89e9yV5aZY2H7RZOhMrdAFqlqtfosWU
         TascdGCwJh/e81igDb3JbEM0ZTr8KB38xNOKRAT16R1hMX9/7aPcRmgmIqvmGcjUgFUh
         S1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wd98xQLQ/pXf9ib4u6bLtTjsr2IvaHY/2gqbkIzN0/4=;
        b=WK/o95BINfeqNYHE4LBE5t1M6fjsZig2kJvZhyfdQtQL5mV1wxXP/gplIZEb/TZ5EA
         Nd5SE7xGTes3FoVVcZbnjZbS9XUZLVAKtitbORp6RBRytXVpOH4E6XEb7YuWg77qX0UP
         yi0iR1FAzQJcnZG4jM8eHaWsduEihjiJWNgIBMqR5wQq7SX+3cicm0fTnRKQzRKAgXdP
         n7IyiZLuMA48hlh4C3l+czoai0owhkzdu2tfAniWsXF8b7iNbv4Nym4avrzAhQtGd04z
         5jaUM0CaSOyJwd/hWWTkZl5NX4vhGATRNexilWhA27uia+8xwe55AMYW1KJHYLQYUk25
         QNHw==
X-Gm-Message-State: AOAM532n6VuZ1F90odMnXicig0ZUKAnQeqT0nc6wqgQaediLb0kEO4Yc
        vojpaKD5QvT8A7EhDcZVt9zg3QIMsww=
X-Google-Smtp-Source: ABdhPJzOeUthB7SJFTxs0C6WTTdaax8E5IuqrJa5n3HsbzyKcEvbOYSslpfKJ/M20wTS7LoXauXWtA==
X-Received: by 2002:a17:902:9684:b0:143:cc70:6472 with SMTP id n4-20020a170902968400b00143cc706472mr17766695plp.70.1637756514834;
        Wed, 24 Nov 2021 04:21:54 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id na13sm5293204pjb.11.2021.11.24.04.21.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:54 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: [PATCH 09/12] KVM: X86: Rename gpte_is_8_bytes to has_4_byte_gpte and invert the direction
Date:   Wed, 24 Nov 2021 20:20:51 +0800
Message-Id: <20211124122055.64424-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It's a bit more confusing to make gpte_is_8_bytes=1 if there are no
guest PTEs at all.  And has_4_byte_gpte is only changed to be only set
when there are guest PTEs and the guest PTE size is 4 bytes.  So when
nonpaping, the value is not inverted, it is still false.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 Documentation/virt/kvm/mmu.rst  |  8 ++++----
 arch/x86/include/asm/kvm_host.h |  8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++------
 arch/x86/kvm/mmu/mmutrace.h     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index f60f5488e121..5b1ebad24c77 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -161,7 +161,7 @@ Shadow pages contain the following information:
     If clear, this page corresponds to a guest page table denoted by the gfn
     field.
   role.quadrant:
-    When role.gpte_is_8_bytes=0, the guest uses 32-bit gptes while the host uses 64-bit
+    When role.has_4_byte_gpte=1, the guest uses 32-bit gptes while the host uses 64-bit
     sptes.  That means a guest page table contains more ptes than the host,
     so multiple shadow pages are needed to shadow one guest page.
     For first-level shadow pages, role.quadrant can be 0 or 1 and denotes the
@@ -177,9 +177,9 @@ Shadow pages contain the following information:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
     unpinned it will be destroyed.
-  role.gpte_is_8_bytes:
-    Reflects the size of the guest PTE for which the page is valid, i.e. '1'
-    if 64-bit gptes are in use, '0' if 32-bit gptes are in use.
+  role.has_4_byte_gpte:
+    Reflects the size of the guest PTE for which the page is valid, i.e. '0'
+    if direct map or 64-bit gptes are in use, '1' if 32-bit gptes are in use.
   role.efer_nx:
     Contains the value of efer.nx for which the page is valid.
   role.cr0_wp:
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e382596baa1d..01e50703c878 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -296,14 +296,14 @@ struct kvm_kernel_irq_routing_entry;
  *
  *   - invalid shadow pages are not accounted, so the bits are effectively 18
  *
- *   - quadrant will only be used if gpte_is_8_bytes=0 (non-PAE paging);
+ *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has
- *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
+ *     has_4_byte_gpte=0.  Therefore, 2 bits are always unused.
  *
  *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
  *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
  *     paging has exactly one upper level, making level completely redundant
- *     when gpte_is_8_bytes=0.
+ *     when has_4_byte_gpte=1.
  *
  *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
@@ -315,7 +315,7 @@ union kvm_mmu_page_role {
 	u32 word;
 	struct {
 		unsigned level:4;
-		unsigned gpte_is_8_bytes:1;
+		unsigned has_4_byte_gpte:1;
 		unsigned quadrant:2;
 		unsigned direct:1;
 		unsigned access:3;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f5a1da112daf..9fb9927264d8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2077,7 +2077,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
-	if (!direct_mmu && !role.gpte_is_8_bytes) {
+	if (role.has_4_byte_gpte) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -4727,7 +4727,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
-	role.base.gpte_is_8_bytes = true;
+	role.base.has_4_byte_gpte = false;
 
 	return role;
 }
@@ -4772,7 +4772,7 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
 	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
-	role.base.gpte_is_8_bytes = ____is_cr0_pg(regs) && ____is_cr4_pae(regs);
+	role.base.has_4_byte_gpte = ____is_cr0_pg(regs) && !____is_cr4_pae(regs);
 
 	return role;
 }
@@ -4871,7 +4871,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.smm = vcpu->arch.root_mmu.mmu_role.base.smm;
 
 	role.base.level = level;
-	role.base.gpte_is_8_bytes = true;
+	role.base.has_4_byte_gpte = false;
 	role.base.direct = false;
 	role.base.ad_disabled = !accessed_dirty;
 	role.base.guest_mode = true;
@@ -5155,7 +5155,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 		 gpa, bytes, sp->role.word);
 
 	offset = offset_in_page(gpa);
-	pte_size = sp->role.gpte_is_8_bytes ? 8 : 4;
+	pte_size = sp->role.has_4_byte_gpte ? 4 : 8;
 
 	/*
 	 * Sometimes, the OS only writes the last one bytes to update status
@@ -5179,7 +5179,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	page_offset = offset_in_page(gpa);
 	level = sp->role.level;
 	*nspte = 1;
-	if (!sp->role.gpte_is_8_bytes) {
+	if (sp->role.has_4_byte_gpte) {
 		page_offset <<= 1;	/* 32->64 */
 		/*
 		 * A 32-bit pde maps 4MB while the shadow pdes map
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index b8151bbca36a..de5e8e4e1aa7 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -35,7 +35,7 @@
 			 " %snxe %sad root %u %s%c",			\
 			 __entry->mmu_valid_gen,			\
 			 __entry->gfn, role.level,			\
-			 role.gpte_is_8_bytes ? 8 : 4,			\
+			 role.has_4_byte_gpte ? 4 : 8,			\
 			 role.quadrant,					\
 			 role.direct ? " direct" : "",			\
 			 access_str[role.access],			\
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 377a96718a2e..fb602c025d9d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -165,7 +165,7 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 	role = vcpu->arch.mmu->mmu_role.base;
 	role.level = level;
 	role.direct = true;
-	role.gpte_is_8_bytes = true;
+	role.has_4_byte_gpte = false;
 	role.access = ACC_ALL;
 	role.ad_disabled = !shadow_accessed_mask;
 
-- 
2.19.1.6.gb485710b

