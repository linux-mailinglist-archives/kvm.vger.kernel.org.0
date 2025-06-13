Return-Path: <kvm+bounces-49516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADB6AD962E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AB79178FD8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9409255F26;
	Fri, 13 Jun 2025 20:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DI7O/op7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C32E2475E8
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846201; cv=none; b=H9Vp5+Ac70vk1nuehpG7RRQrrNrGT9oj4uYYDmzaq65cOUbFmiy4vVr8U+zqDzRr8PK9NL8q6cxctrsccRsp3Uu/gc97gXaEOrZK1qC72Ca4CgHyXLJGVASGQijRfqNZ8270YYAwh5X5oFPe9Jek6fMEbetJ3cVcCDwadkqcOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846201; c=relaxed/simple;
	bh=/C++yCmsyoQoAQ/JFzedGKuseM7Tk6mR7YxlYpQd9Z4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E85Npf2VBF2hYqguBmHn6NN7IzI6Oy5JhaVa8ZDClDxCJorxaqqCJD4d7UTJ1HqXgr8qK/IyVOfpGjRqLa+80vqB4+QovioNtd7ngPdfZfVkQYxZiCHy1zsYtJzvjp/qjI1x76GIcLE73tXJMwWJM3tEs5iGycYguW6qdvO7pbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DI7O/op7; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4e7037aeccbso298674137.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846199; x=1750450999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qYYxlJUSy6v2zDI8TzsrBHHnn7rC00X6zn+VLpi9Eg=;
        b=DI7O/op7sJjmj4UgMKY+hqp50fD6y+yELUDSegFrlN9qVyfEZfmdCL6hYrQfz8Sed2
         fmwULYVQvcIKMQTUHzjWNgBe2s1rlSyx3TthyGsZJpADqtS9epQMkfSacSDCUjqM83CY
         Ag+JBDnBnuaFCBpGXZPpQkEaDOLvr8OkPxdF+wS6nOxvd5DRvsqBZyRW71DkjJX04sE2
         ZKEw24bsj3fKmXTvE/Iglv6uzQ85LOtYYwXek8uuc/T4XySMDbCdfyIuQD/D/aGd5yoc
         /Je0VXioyz1csfrJlJ5dycq2+c/dfU7xhrWK3Z8PFO3pCgIMCmuxwyHVxTr4OQyfryIb
         RroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846199; x=1750450999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3qYYxlJUSy6v2zDI8TzsrBHHnn7rC00X6zn+VLpi9Eg=;
        b=AtSfBYUgiTdM1V38V1oTKG4u6IO8/OKDf7ZvcirDx0qtV20nXt9FsPq73QNRgCv+uY
         oRmNER4/WBa4J8a2Fydt1upKkzO6oOZb+0WqZ3jpW1n3YSeD1bMqPvhdnD2+lE+82wgg
         qaNlThFNLpsCmQNLEOlEFzoKFvDOs8LnlAj6UnyRPWdIhqJpZ/283DY/OzDKF4QyELyx
         GWpbuSaJLMcHX9oULTezri9Oymu/ujE9NmR02L/CLJon/JhZYXrcC6R5zdHN5OA1HCEg
         1aSXiJ3YeyFojdiY50IARxw5q6A4br53qNoVR5tn4uUaAaC/fO94DQHSQB7naRFQv3cS
         JhwA==
X-Forwarded-Encrypted: i=1; AJvYcCVUwz+m07eLcAmL2FiBFEADSUbo6PaB6YTFEFSEQ4l/lSWd/zJZc2UuIvEQ6RgE0eaYLoo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9OrixWfunNpxDDcL0q3StWxT1XlfPQyMgh527Z1/+sj7CynmT
	f+jGVitn2k02HqThtInTnz6hR5PCMXmWR0BxhsQ4sag6MO1FEvr8xek9H7oyuWZutgm2HEZP1Df
	VKyl89+XWoyAwpAVpJaFXMQ==
X-Google-Smtp-Source: AGHT+IFVJjORcfffmUQKREgb2IlI7UakEaV5K18PSnlHkSke00VMT7vSvDgcnELg5b1l3wOKG9x8pR03ScjPXHET
X-Received: from vsbia14.prod.google.com ([2002:a05:6102:4b0e:b0:4e7:edf6:29b2])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:370c:b0:4df:8259:eab with SMTP id ada2fe7eead31-4e7f63c60ebmr1243215137.19.1749846199123;
 Fri, 13 Jun 2025 13:23:19 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:09 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-3-jthoughton@google.com>
Subject: [PATCH v4 2/7] KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better
 indicate its purpose
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Vipin Sharma <vipinsh@google.com>

kvm_tdp_mmu_zap_sp() is only used for NX huge page recovery, so rename
it to kvm_tdp_mmu_zap_possible_nx_huge_page(). In a future commit, this
function will be changed to include logic specific to NX huge page
recovery.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f44d7f3acc179..b074f7bb5cc58 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7607,7 +7607,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 		if (slot && kvm_slot_dirty_track_enabled(slot))
 			unaccount_nx_huge_page(kvm, sp);
 		else if (mmu_type == KVM_TDP_MMU)
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
+			flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 48b070f9f4e13..19907eb04a9c4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -925,7 +925,8 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_unlock();
 }
 
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp)
 {
 	u64 old_spte;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a00..bd62977c9199e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,7 +64,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 }
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_tdp_mmu_root_types root_types);
-- 
2.50.0.rc2.692.g299adb8693-goog


