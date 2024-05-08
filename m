Return-Path: <kvm+bounces-16955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C328BF4E5
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 05:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D71F01F24D90
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 03:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7861427E;
	Wed,  8 May 2024 03:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="qs3G3HLZ"
X-Original-To: kvm@vger.kernel.org
Received: from out0-193.mail.aliyun.com (out0-193.mail.aliyun.com [140.205.0.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1110A31;
	Wed,  8 May 2024 03:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715138336; cv=none; b=d4KeCbgaAC0WBq7Oyzh666VXDtLx7NAW4S1AdgWokwHyKldwwsMIn4vbR+llZ9K4dXYFT5dKJAn0xUWaekMMU2rijvhWlS1LGUSQHMwEgC2hFTpE5FDW1Ttl87lQsvADKoAFHvT+0o2S/bW/zUVhAppKMFJ+rG0ceXvZIGciAAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715138336; c=relaxed/simple;
	bh=XLuR9VxXVV1Ku8DVWVb7b2tLdtBtCxg3+Z+626HBzJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BcJu4cKohEzCTI1ENLDjGSgD25LsrTZlHuY4X4qx1JvIbo1uxNTGMJYP34CSQ/WlKhhM+U7Bx1xQsWfzk8u3TXXwZXSCt6vGXOGDKH3nN4uQenUTUerMc7w8I/PGEHp/3EBSGspxps0sKizdLXCuLDu0BUXvJK1XWD9D6d07n+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=qs3G3HLZ; arc=none smtp.client-ip=140.205.0.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1715138325; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=DnAX2XxWMmT4hYoRUEoVeoZJUWhjhnceF4d+AxQfu6I=;
	b=qs3G3HLZuWzK77mam8IvxbBqK3JADd/OxmQyBoXfPlTnNBUA99zKZMChDTRBWS8SY6Mlds2WTeeCaPAFZOktL6bTj67/Jeo1gBEyBz08YMau1LbfMmmaLp+9uDRIVQJ6Wfqwsnz/tO3wZYOE3kzvEx4keBWVEBfvFzBtjvWexAc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047205;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.XV8fOaO_1715138323;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.XV8fOaO_1715138323)
          by smtp.aliyun-inc.com;
          Wed, 08 May 2024 11:18:44 +0800
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
Subject: [PATCH] KVM: x86/mmu: Only allocate shadowed translation cache for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
Date: Wed, 08 May 2024 11:18:42 +0800
Message-Id: <bf08a06675ed97d2456f7dcd9b0b2ef92f4602be.1715137643.git.houwenlong.hwl@antgroup.com>
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
only for it. Additionally, use sp->shadowed_translation to determine
whether to use the information in shadowed translation cache or not.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fc3b59b59ee1..8be987d0f05e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -716,12 +716,12 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp);
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
+	if (sp->shadowed_translation)
+		return sp->shadowed_translation[index] >> PAGE_SHIFT;
+
 	if (sp->role.passthrough)
 		return sp->gfn;
 
-	if (!sp->role.direct)
-		return sp->shadowed_translation[index] >> PAGE_SHIFT;
-
 	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
 }
 
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
@@ -1697,7 +1697,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
+	if (sp->shadowed_translation)
 		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -1850,6 +1850,17 @@ static bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
+static bool sp_might_have_leaf_gptes(struct kvm_mmu_page *sp)
+{
+	if (sp->role.direct)
+		return false;
+
+	if (sp->role.level > KVM_MAX_HUGEPAGE_LEVEL)
+		return false;
+
+	return true;
+}
+
 static bool sp_has_gptes(struct kvm_mmu_page *sp)
 {
 	if (sp->role.direct)
@@ -2199,7 +2210,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
-	if (!role.direct)
+	sp->role = role;
+	if (sp_might_have_leaf_gptes(sp))
 		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -2216,7 +2228,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	kvm_account_mmu_page(kvm, sp);
 
 	sp->gfn = gfn;
-	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (sp_has_gptes(sp))
 		account_shadowed(kvm, sp);
-- 
2.31.1


