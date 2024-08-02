Return-Path: <kvm+bounces-23150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C46829464A5
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58E6B28301D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E695139CF2;
	Fri,  2 Aug 2024 20:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WXiTJZE9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C99136326
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631815; cv=none; b=n0vwVui1UpKPTwlU6vVunLLLDu2hxPmAJHTpT1LbnsDWBl1irXa6SuroqFpNVEnD2FUwlF+gOTZ6RLNYo6en+GmrLHM0DiT3Ea2LSVzEXTuSzgq3/hI43elMAkJsPTu0VIiGBtpgux2ixnsNR6191NeAWHzp+TwpQLB5sv61Ipk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631815; c=relaxed/simple;
	bh=gCqaKijnA/XXSCKJJY3H14sUdvU41wCk5WOtCSYXq78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bk8xonw4Rn/5G0AaTPWwVJMgH25gFNQ1DZuN048+Irt7zCyfXkPrOtDsHVx9z0zIU+sMOu0Hh9GxVOeyTh17qmOrubExJ071YiR93qxjTG0oaHQG3Q935KtIjdp4lN0mnXnwnQkuzLJ51Flp7LK4kBRvchaIqpz6UVTaOwpIsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WXiTJZE9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7b04199911bso3496321a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631813; x=1723236613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c5Nq/OFr3yVwVK6otXPmP+p3Am8dAjZp5v9yRhPUjYo=;
        b=WXiTJZE9B7GKNKQc/dtGTvDxiROqAkt3qJFVuM3EitWEs8TW3mwQbBcQaVQp22ah55
         XIDH5jZWugny4n9kftF9iUZ8GZYOoGs9I4UH8OuLikx9tukjFZPPRneV/Z9bDd79KfGA
         7ylVmvulze1fHy1N+xmfaogsNpgIo6pNDR6EzdBY6gdRHo3KJYns63TRA/Riqrb0ziYz
         WSieyEFvgnXbBDQSKkffmXV7o5Jq3kZUMp23WFqg3O3aAqRRzVNNRnsH96I01q/T7qe/
         r7IHzNeNvLX8o6BIGNMqDPMG/TZarnjMj/FAxic6cXNCzdRWtiBm2dGEEGyTDkm35qGt
         cI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631813; x=1723236613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5Nq/OFr3yVwVK6otXPmP+p3Am8dAjZp5v9yRhPUjYo=;
        b=B8kmntFbOQn0S0UWlASsAfNr/ISMaWQQ7ne6TZM4ycPX1ElZ5E27ZPOU169eF73+vI
         5AbeW/iyUWSDrMBzv0ofO9z73rnnhvLPV/DnTaZJ/O/xB56CS+BqJOOqXoXUkTeCtT0P
         dCwDxel42J3pwSkoaoRdQXl/jlbSG0lG8jP9Z94/TQyuQYekWQBCC97pOd1PJVRO+Tym
         mLqTzPQSKIv17CkgKJmXfZ78kzfwBh7uUCqAoPG5Zl2iw56YwvqjwpTwHXiGsGkgfxwt
         gB0WrtJtAgWoU9Ckt2j/OiE1lyZNhHvCjWr6bQW5cPj+CNNyqL3Lf9loB/vkN2I9YpCL
         0RMQ==
X-Gm-Message-State: AOJu0YxFTngw4SxQq6scJ+p4VgA5LMFdgfGGc3/EXOTI/SxOHX6o/Yq9
	wqWewB1NRpkO7U/ou1VhizRVH6ozbvjxJTDFrxocFUwREbOZcmmUH+NxMdzJhKANHA4E9xYvPG8
	vmw==
X-Google-Smtp-Source: AGHT+IFCCb4cjN7vw4l+DdM80k46FcB95ke4PJ/4aZuNN0SLLSK30zfFovXw2fZA2crCh5pBwalD0Ra5Fa8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a617:b0:2c5:2b19:4218 with SMTP id
 98e67ed59e1d1-2cffa2728a2mr37588a91.3.1722631813176; Fri, 02 Aug 2024
 13:50:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:50:01 -0700
In-Reply-To: <20240802205003.353672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86: Drop double-underscores from __kvm_set_memory_region()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that there's no outer wrapper for __kvm_set_memory_region() and it's
static, drop its double-underscore prefix.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77949fee13f7..bd365fb8ab6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12895,7 +12895,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
-	 * old arrays will be freed by __kvm_set_memory_region() if installing
+	 * old arrays will be freed by kvm_set_memory_region() if installing
 	 * the new memslot is successful.
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cefa274c0852..b5c048858fc4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1170,7 +1170,7 @@ static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter, gfn_
  *   -- just change its flags
  *
  * Since flags can be changed by some of these operations, the following
- * differentiation is the best we can do for __kvm_set_memory_region():
+ * differentiation is the best we can do for kvm_set_memory_region():
  */
 enum kvm_mr_change {
 	KVM_MR_CREATE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63b43644ed9f..42ec817d6a7e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1973,8 +1973,8 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-static int __kvm_set_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region2 *mem)
+static int kvm_set_memory_region(struct kvm *kvm,
+				 const struct kvm_userspace_memory_region2 *mem)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -2104,7 +2104,7 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
 		return -EINVAL;
 
-	return  __kvm_set_memory_region(kvm, mem);
+	return  kvm_set_memory_region(kvm, mem);
 }
 EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
 
@@ -2115,7 +2115,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	guard(mutex)(&kvm->slots_lock);
-	return  __kvm_set_memory_region(kvm, mem);
+	return  kvm_set_memory_region(kvm, mem);
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.46.0.rc2.264.g509ed76dc8-goog


