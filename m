Return-Path: <kvm+bounces-17248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 251318C2F70
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 05:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D613C284EA6
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 03:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116F73F8F7;
	Sat, 11 May 2024 03:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="IkF1OcpO"
X-Original-To: kvm@vger.kernel.org
Received: from out0-212.mail.aliyun.com (out0-212.mail.aliyun.com [140.205.0.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC941843;
	Sat, 11 May 2024 03:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715399206; cv=none; b=gOt08WsRbWbxINGExO+q4ooGF6KThYcZ/EsYYffQ8DWOJ0FiST87UvZ4Np2T8WI8c0Q8LQjQSrUWJu9miZvpP0fPTuZi9kn6orfaxG7A7jfOWF0iZ47yUFH/X/PORLJlTgBZTUzESiidR2wh1s94HG5FXO79mjaPPWEbpldGOqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715399206; c=relaxed/simple;
	bh=hZ03FoXZ1F+HCTHSptsV5XuAZGqY5U010SnORP5VsWg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AM3XBXVWly+PPgp1i0k06f7t2Iye+Ail4tTnMtYn7vVaG1Af8uHBERJlm3kj27ZKkKshCOiqWEVy0J97zJTwX57BVajNLYcYQAvuPsQFgQVpIeDbMP/h7yKryKuQJCPJCeYi2py5sgYcmgSrz0j0DddWibidBC7jdQybsHswzAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=IkF1OcpO; arc=none smtp.client-ip=140.205.0.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1715399199; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=/oQPtMgHD8rA3njQCT4IplE8E+0JmO4poKrpVU3HxCw=;
	b=IkF1OcpOqrZOX8gHWEO4Ay8znEZHzAnY+dLaEd3Y6LbM3jWMasIFN0RRhY0o+BeA/kY/b8s+a6u6rlgqlMulbxWcCW1s6u/vS5u9EuSPHLR+meeEgl9+B+/WBGM50FZmiY/5jdw6ItPYHthFVAurHxE1tnGJfeHFqKivsUX2/7Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047205;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.XYYlGFt_1715399198;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.XYYlGFt_1715399198)
          by smtp.aliyun-inc.com;
          Sat, 11 May 2024 11:46:39 +0800
From: "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
  "Sean Christopherson" <seanjc@google.com>,
  "Paolo Bonzini" <pbonzini@redhat.com>,
  "Thomas Gleixner" <tglx@linutronix.de>,
  "Ingo Molnar" <mingo@redhat.com>,
  "Borislav Petkov" <bp@alien8.de>,
  "Dave Hansen" <dave.hansen@linux.intel.com>,
   <x86@kernel.org>,
  "H. Peter Anvin" <hpa@zytor.com>,
   <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: x86/mmu: Only allocate shadowed translation cache for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
Date: Sat, 11 May 2024 11:46:37 +0800
Message-Id: <5b0cda8a7456cda476b14fca36414a56f921dd52.1715398655.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the indirect SP with sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL might
have leaf gptes, so allocation of shadowed translation cache is needed
only for it. Then, it can use sp->shadowed_translation to determine
whether to use the information in the shadowed translation cache or not.
Also, extend the WARN in FNAME(sync_spte)() to ensure that this won't
break shadow_mmu_get_sp_for_split().

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
v1->v2:
- Remove the order change in kvm_mmu_page_get_gfn() to keep smallest
  diff.
- Drop the helper.
- Extend the WARN in FNAME(sync_spte).

 arch/x86/kvm/mmu/mmu.c         | 11 +++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fc3b59b59ee1..dc6f6a272e98 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -719,7 +719,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 	if (sp->role.passthrough)
 		return sp->gfn;

-	if (!sp->role.direct)
+	if (sp->shadowed_translation)
 		return sp->shadowed_translation[index] >> PAGE_SHIFT;

 	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
@@ -733,7 +733,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
  */
 static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 {
-	if (sp_has_gptes(sp))
+	if (sp->shadowed_translation)
 		return sp->shadowed_translation[index] & ACC_ALL;

 	/*
@@ -754,7 +754,7 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
 					 gfn_t gfn, unsigned int access)
 {
-	if (sp_has_gptes(sp)) {
+	if (sp->shadowed_translation) {
 		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
 		return;
 	}
@@ -1697,8 +1697,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
-		free_page((unsigned long)sp->shadowed_translation);
+	free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }

@@ -2199,7 +2198,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,

 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
-	if (!role.direct)
+	if (!role.direct && role.level <= KVM_MAX_HUGEPAGE_LEVEL)
 		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);

 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7a87097cb45b..89b5d73e9e3c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -911,7 +911,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	gpa_t pte_gpa;
 	gfn_t gfn;

-	if (WARN_ON_ONCE(!sp->spt[i]))
+	if (WARN_ON_ONCE(!sp->spt[i] || !sp->shadowed_translation))
 		return 0;

 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
--
2.31.1


