Return-Path: <kvm+bounces-23791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFE294D7A6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52735282A13
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECCA19A2A3;
	Fri,  9 Aug 2024 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQP9GjY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C193199EA1
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232653; cv=none; b=NNISY1D7AFeY4wvJf7uRKsUUd03EE0+a1qc6s5BadSkMVNWPfGmCCcSsEPSThLlljkE4aGbzW2XDwsxkX9xRA+Ga7T3tdx2s5eBa/vEcCVFh5Nt0WMq2BQtV6mknE76FOKUI7CguoGd/l1Uz439vTwzUr7O+spjyA/2WdDiN2ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232653; c=relaxed/simple;
	bh=aE+XjLSYWb149BZo4fuwEt6PAsJA4S1vOO2cjFVxeZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnY2466ezqSad8keXSE0bJVR+PQcrDnx0mXFR2G0YJDqq/lcnTQVGxsXzJGab3zQT80NFg/MwrDDHcnjqW0/rkWvmn7uYFatlXJYhJJHXv3wp4ZJ/NIZbDIHPegUvfMwVtKceqlkF/1bAXw7gGvhvpXhxL67SpiG8gTOpP1avzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QQP9GjY+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66890dbb7b8so55878077b3.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232650; x=1723837450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GD7gycGsmp7NjONVo+Jkt5X+cTf6SoGnpMVjud9Ddns=;
        b=QQP9GjY+WoiTj2kofWBAusfKONlPvEtPCxIeJuyN4ZihH7zFfe/XPLtryV2o8qn8mx
         R+rLn7JG10drMi/oFbfw/jQvdNNEaW+8M01e8GKin1KUWnDNUUCvogIGH4tkPYZu/yGO
         Ireh6K9jYRkb0mX+4rQVqNlhMz7vORYY300xEEPEU5KRkjeaJbgMskmxBOGMYHd9bxTS
         jlaHKa1+ves/F9zIqeFLSxWG8KzoX6NBNuQS0n3jCCPok6ulpT6zZMHEqzbxPdKwVUGA
         MTnv0imu4dlp45J7CsWYPuDA8Fn4di3vWDbWWV4y5h2lH2aCjFyMUK5EuA/4O34EnXph
         KZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232650; x=1723837450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GD7gycGsmp7NjONVo+Jkt5X+cTf6SoGnpMVjud9Ddns=;
        b=lJHZRVyEC/ahU84DUHpak/RmFC9GISejML2Ati047hu/MMN8uaIj04eZFJvjdq62yY
         +CYcuhYsZJ1nRAvrSrZyedjRU1HGMranSnXa/MBUj2k5VzNYmbh+0AgspzmaiBgG/hWA
         BGeB3v/A9nxCsWONR5dr+fxqIVAui11y0361TB0alC8cJW+LEw/9PkNyvx0UB4c3Pbk5
         OiIADiDIikdjS8f4VEXNitkAwpPnQ3o99xZs6WZHEZ4BZmnDx2WMSeLaXSRDrinSADqR
         zAxRXzqi9KCFVxxcmjzm+qOp+i8XQAjfZDSHZmHYzpELdl6yFonv5FQkNxPPuzw5SrDk
         YNJw==
X-Gm-Message-State: AOJu0YzSAUekg37BrFAey1XN30qfWDnbrjWQkm/ccasdw/1jJYfMsKZp
	PGMfG/iBTok7KS/73pWkBSKOudNzSw6eCc08/SewaLa8UpfAmRLZSEDJafdk+rKRQ6oHKPiBuOY
	rUw==
X-Google-Smtp-Source: AGHT+IG5SwO0DcW0swDPhRWsKN2wuZhEs3mbWTMQ2R+czhdomrVn6Ywvmw+UK+vkinS9d2PnRXVcF1Gcbp4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:290f:b0:615:32e1:d82c with SMTP id
 00721157ae682-69ec8d85594mr560077b3.6.1723232650446; Fri, 09 Aug 2024
 12:44:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:28 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-17-seanjc@google.com>
Subject: [PATCH 16/22] KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded
 '1' and '1ul' literals
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace all of the open coded '1' literals used to mark a PTE list as
having many/multiple entries with a proper define.  It's hard enough to
read the code with one magic bit, and a future patch to support "locking"
a single rmap will add another.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c536a069d6b9..73569979130d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -912,6 +912,7 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
  * pte_list_desc containing more mappings.
  */
+#define KVM_RMAP_MANY	BIT(0)
 
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
@@ -924,16 +925,16 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 
 	if (!rmap_head->val) {
 		rmap_head->val = (unsigned long)spte;
-	} else if (!(rmap_head->val & 1)) {
+	} else if (!(rmap_head->val & KVM_RMAP_MANY)) {
 		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
 		desc->tail_count = 0;
-		rmap_head->val = (unsigned long)desc | 1;
+		rmap_head->val = (unsigned long)desc | KVM_RMAP_MANY;
 		++count;
 	} else {
-		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 		count = desc->tail_count + desc->spte_count;
 
 		/*
@@ -942,10 +943,10 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		 */
 		if (desc->spte_count == PTE_LIST_EXT) {
 			desc = kvm_mmu_memory_cache_alloc(cache);
-			desc->more = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+			desc->more = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 			desc->spte_count = 0;
 			desc->tail_count = count;
-			rmap_head->val = (unsigned long)desc | 1;
+			rmap_head->val = (unsigned long)desc | KVM_RMAP_MANY;
 		}
 		desc->sptes[desc->spte_count++] = spte;
 	}
@@ -956,7 +957,7 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
 				       struct kvm_rmap_head *rmap_head,
 				       struct pte_list_desc *desc, int i)
 {
-	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 	int j = head_desc->spte_count - 1;
 
 	/*
@@ -985,7 +986,7 @@ static void pte_list_desc_remove_entry(struct kvm *kvm,
 	if (!head_desc->more)
 		rmap_head->val = 0;
 	else
-		rmap_head->val = (unsigned long)head_desc->more | 1;
+		rmap_head->val = (unsigned long)head_desc->more | KVM_RMAP_MANY;
 	mmu_free_pte_list_desc(head_desc);
 }
 
@@ -998,13 +999,13 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_head->val, kvm))
 		return;
 
-	if (!(rmap_head->val & 1)) {
+	if (!(rmap_head->val & KVM_RMAP_MANY)) {
 		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_head->val != spte, kvm))
 			return;
 
 		rmap_head->val = 0;
 	} else {
-		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
@@ -1037,12 +1038,12 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	if (!rmap_head->val)
 		return false;
 
-	if (!(rmap_head->val & 1)) {
+	if (!(rmap_head->val & KVM_RMAP_MANY)) {
 		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
 		goto out;
 	}
 
-	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 
 	for (; desc; desc = next) {
 		for (i = 0; i < desc->spte_count; i++)
@@ -1062,10 +1063,10 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 
 	if (!rmap_head->val)
 		return 0;
-	else if (!(rmap_head->val & 1))
+	else if (!(rmap_head->val & KVM_RMAP_MANY))
 		return 1;
 
-	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 	return desc->tail_count + desc->spte_count;
 }
 
@@ -1127,13 +1128,13 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 	if (!rmap_head->val)
 		return NULL;
 
-	if (!(rmap_head->val & 1)) {
+	if (!(rmap_head->val & KVM_RMAP_MANY)) {
 		iter->desc = NULL;
 		sptep = (u64 *)rmap_head->val;
 		goto out;
 	}
 
-	iter->desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	iter->desc = (struct pte_list_desc *)(rmap_head->val & ~KVM_RMAP_MANY);
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-- 
2.46.0.76.ge559c4bf1a-goog


