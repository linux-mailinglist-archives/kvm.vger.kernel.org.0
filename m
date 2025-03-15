Return-Path: <kvm+bounces-41134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D691A624C8
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2091421934
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D19919258C;
	Sat, 15 Mar 2025 02:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKh5F7OZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEBC18DB29
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006419; cv=none; b=pGvsQR+5hslOdfX9bY2as7eUsqwMeGV2udmgGaaw6nsKKwG1jEHcdY+F5XgtT1aBaG6yRGPXTx+pv2/d3F1Ve1/ll5tpJfrW6rXa2XilYdS0woxOH7nrvnlS0Z1fzfX/0BxNLzhobNs2E5yV1ydKrVh0BJjcMpjpFlbKaK15JIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006419; c=relaxed/simple;
	bh=csXcvVUGODyh39WQeJCJvvBrtei4rk6c+z8kvW6MpJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gV6DhlfpeEMmxrHF6sqURLl5g+jFpkKpcezlGtjhA0/XBlcC0rvmeAmY75x3G+oZTsqyk4SLKpaL3rTrFuLDAErUBgT7JSKZbcjoX3ppeMu0EGQWoUnMWtQnYKSUsZMALTy7+aKx9GQ5r8Uhhh0W0MDysOLLB3S/fPnKjJSg+uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKh5F7OZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8340d547so496259a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006417; x=1742611217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sy3DZMUWr7rSQ3fTWMshpO7vJyF2FiO+hW5xt0RQaio=;
        b=NKh5F7OZDDAXwedLK+UNsDYfqXSvmn07JTm0jfMyFG7y107zu7l/2Zm51EVBI7xDoe
         R4+lcZnGSGbrR5lBw9fe+qDpqLOSgIF7Lm0mmwir8LHXje7A2K1i72TSXYLLHevWROEA
         wR53lByQ+fCj8eHMcOwAAe9GgO9B9HqfmDVQCnRpQO+CpRJT0L1ZmgTghT0oI6x+ggm+
         DJd7pRPhy6TnHVtYKm4TfDJCN+sSS7Sgd0Yseh2d94Mx8IpdsISuYwKO8oXewZNsd87F
         KHFPt5mzJlAaaqF9597rOCGrq7Jiv8O/fAIWm4WmcZbFaolEqfpicPkJ03GIgyPQvd5b
         Nybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006417; x=1742611217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sy3DZMUWr7rSQ3fTWMshpO7vJyF2FiO+hW5xt0RQaio=;
        b=bKNazgUO2cHBCrvDZijzsKUD0298qnVp2bI3Xw2eCiw0e/+wJ95Z4xGoFx6hvJLg7f
         mPQorCcslh0gwE+Oedqw/789VHOPJZ/fUwho2QsJ2L42b+g4nyfTrLg6/HLdd3hw5lDA
         Or1EA0VKK4CK18fWssDnb/U200Dvcd4vZpyyiRR3d+SD0kuAr8D+hEJmM0cjp2QXNumO
         yVyZ/XWSgpBdNyphSzS4atxSfiUIVB/LoTWk/ZYVBTqsXtIiiHgMTFqfPn7Fidill26O
         NkQJ/1zywHpIFG353LOL9hN1Ki6vao9gJ84bfyGSGwuyti8P11UORIOpYFqeav4cVOTa
         2cEg==
X-Gm-Message-State: AOJu0YyBhOgTdnTCcpVzbJIqSGbUzAtjHrmqAs1koaKkDEmaE0gzYETd
	2O5HrAjPU2oOpqgdJEIDd4P5cf+tuUp97PNbcZxxKftJ9b1on/OBi2aiQAfkOq3bPybGN9gq34V
	PRQ==
X-Google-Smtp-Source: AGHT+IG+EY2vHoY9F8/B8pXlSFd1fbS2p5geTEG1LvjxFKSZnZyvPp3RwszbiRtlmWwsDlNu/jnAcshVEQg=
X-Received: from pjbph6.prod.google.com ([2002:a17:90b:3bc6:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180f:b0:2ee:f22a:61dd
 with SMTP id 98e67ed59e1d1-30151dd2784mr5391135a91.32.1742006417396; Fri, 14
 Mar 2025 19:40:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:40:10 -0700
In-Reply-To: <20250315024010.2360884-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315024010.2360884-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024010.2360884-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When the TDP MMU is enabled, i.e. when the shadow MMU isn't used until a
nested TDP VM is run, defer allocation of the array of hashed lists used
to track shadow MMU pages until the first shadow root is allocated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b878f2e89dec..3765d7abc2cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1982,14 +1982,25 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 	return true;
 }
 
+static __ro_after_init HLIST_HEAD(empty_page_hash);
+
+static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
+{
+	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
+
+	if (!page_hash)
+		return &empty_page_hash;
+
+	return &page_hash[kvm_page_table_hashfn(gfn)];
+}
+
 #define for_each_valid_sp(_kvm, _sp, _list)				\
 	hlist_for_each_entry(_sp, _list, hash_link)			\
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
 #define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
-	for_each_valid_sp(_kvm, _sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
+	for_each_valid_sp(_kvm, _sp, kvm_get_mmu_page_hash(_kvm, _gfn))	\
 		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
 static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
@@ -2357,6 +2368,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
+	BUG_ON(!kvm->arch.mmu_page_hash);
 	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
 	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
@@ -3884,11 +3896,14 @@ static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
 {
 	typeof(kvm->arch.mmu_page_hash) h;
 
+	if (kvm->arch.mmu_page_hash)
+		return 0;
+
 	h = kcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
 	if (!h)
 		return -ENOMEM;
 
-	kvm->arch.mmu_page_hash = h;
+	WRITE_ONCE(kvm->arch.mmu_page_hash, h);
 	return 0;
 }
 
@@ -3911,9 +3926,13 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	if (kvm_shadow_root_allocated(kvm))
 		goto out_unlock;
 
+	r = kvm_mmu_alloc_page_hash(kvm);
+	if (r)
+		goto out_unlock;
+
 	/*
-	 * Check if anything actually needs to be allocated, e.g. all metadata
-	 * will be allocated upfront if TDP is disabled.
+	 * Check if memslot metadata actually needs to be allocated, e.g. all
+	 * metadata will be allocated upfront if TDP is disabled.
 	 */
 	if (kvm_memslots_have_rmaps(kvm) &&
 	    kvm_page_track_write_tracking_enabled(kvm))
-- 
2.49.0.rc1.451.g8f38331e32-goog


