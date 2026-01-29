Return-Path: <kvm+bounces-69487-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFoGGj23emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69487-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D79AFAAB63
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FFD630F05E8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D7F374189;
	Thu, 29 Jan 2026 01:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhqDFrpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C4A326943
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649398; cv=none; b=M34BLDpG1Rzb/c6LYpziVIgE1O/F0o+73auuact45jkMBPz55We+ie1WHKuP/ub3BF7pVJPxNM/cGUbBXwX6PFz6L1JLHuUJM/9ebKQZ9FuGJnoj98iiRvHUijcGzJ8JuQAh32/aPO/O4Ara3IIEdUFJuBuhIWtymD2ZrtRKNj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649398; c=relaxed/simple;
	bh=ZA7lO6Iqcxv2nIH6jvLo0wih4TGT7nAoCV3mCXKZU8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ebuD3JM/MxWV0Gg3YP0L80pLKo2puuLKl+zcOfijFqPx1oJ0ZaFlBE+mEc40PzEGJwCSg59xkdmDUCIEvs/5h5An2CHhpRVDBeoUNFc23dlD6BaYU8sjZi0nnS6Ka7u9BIPaGrL2oHnqVoAADUhVPfXaIMW6gfH+SGu4zx+B2/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nhqDFrpt; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso216515a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649396; x=1770254196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yjclvkjmE1zw/GHq/jW5Y/EQUpO3A2fBpqR5d3bbX+8=;
        b=nhqDFrptFZSlTjl5ZcbC29HI4IjTrLVEH06tZSxjzl9PrBFvmlrkxxiF8cbIl1Im1X
         eTh72iMiNYC/MAcrzvZ0sCehqpIj94BMP4k/fZIFTr34s+Co8LArZO6xMjr8rNLyEnnH
         upoyXiPxcvxyHFRi0wUL4ZovSaf2gSOq4ei4mQUvoJkqqlWR1V37Hv8QIMacC9T3VV5b
         pRSlssFfjakI+Sn6hWWA7EFKuMH4Dq0TbmfSX0uGz3rsuWjH3JyXAFzlZvcaAim1tpLc
         TsNBN9u0IJue1UJtuJHgDgWf06h9o0BaegCbrPQKAdkii2qkufZyIvoav7vpqFnUBHk2
         L17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649396; x=1770254196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yjclvkjmE1zw/GHq/jW5Y/EQUpO3A2fBpqR5d3bbX+8=;
        b=Q85N5SOOvJzOA+Z+0483/S5W9utcRZqp7Vliui+hbA1wzy0iSAV+MBnz64JVfE0KQV
         67zwGKjCZTZYuDCGv+8TeVSlTkKmEebO+HVcKKSbZJSq6laYthk/qTQqKJ6vOsSgR8Oa
         ZGAr3e2KGXzv/Duo+i+9PAWaYXoctSrbGr4W6dBljaKfr6oA5hjOLfYAh8FMuyY3P4tN
         7lOJ8deH0eeCe/4PoT+ALlJEZQqou/qtRQb81QOJFvUoIqKpuXIVZz8Cttc+M1PTU398
         8uvIFflvHeIEvJSHZ7gIlZ/ldajjpJt4/+uoJU+Gr1Y0yvdjCTTm+YEP34ivYYK+oAZy
         dXOA==
X-Forwarded-Encrypted: i=1; AJvYcCV5WXXYJCDEPJfsx5hWib4AmGIcCEiNkqttJ3YvgrXTVy9h6exn2yRqNwDYgpbx3kPeBVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSRvlLUo7DU4xyzHGSVVP7QFjlEL6Q6oLIKpnMzQ2Nj+/skNNW
	hb0ckUuqSJ6PlEICG6zwC37Wn0zXpZu2O8qxcODLol1HcHaBylM6wklSB4WFaSVU9ofRcJKwC2y
	PrhPUDA==
X-Received: from pjof4.prod.google.com ([2002:a17:90a:8e84:b0:34c:cb46:dad7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7484:b0:366:14af:9bbb
 with SMTP id adf61e73a8af0-38ec65898bfmr7510420637.69.1769649396157; Wed, 28
 Jan 2026 17:16:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:08 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-37-seanjc@google.com>
Subject: [RFC PATCH v5 36/45] KVM: TDX: Move S-EPT page demotion TODO to tdx_sept_set_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69487-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D79AFAAB63
X-Rspamd-Action: no action

Now that handle_changed_spte() can handles all mirror SPTE updates, move
the TDP MMU's assertion that it doesn't replace a shadow-present mirror
SPTE with another shadow-present SPTE into TDX, in the form of a TODO
that calls out that KVM needs to add support for splitting/demoting
hugepage.

Drop the "!is_leaf" condition so that an unexpected/unsupported update to
a shadow-present S-EPT triggers a KVM_BUG_ON(), versus being silently
ignored (well, silent until it causes explosions in the future).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +--------
 arch/x86/kvm/vmx/tdx.c     | 5 ++++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d49aecba18d8..3b0da898824a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -572,7 +572,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
+	else if (was_leaf && is_mirror_sptep(sptep))
 		KVM_BUG_ON(kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
 							   new_spte, level), kvm);
 }
@@ -704,13 +704,6 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	handle_changed_spte(kvm, as_id, sptep, gfn, old_spte, new_spte, level, false);
 
-	/*
-	 * Users that do non-atomic setting of PTEs don't operate on mirror
-	 * roots.  Bug the VM as this path doesn't propagate such writes to the
-	 * external page tables.
-	 */
-	KVM_BUG_ON(is_mirror_sptep(sptep) && is_shadow_present_pte(new_spte), kvm);
-
 	return old_spte;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e6ac4aca8114..59b7ba36d3d9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1850,7 +1850,10 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				     u64 new_spte, enum pg_level level)
 {
-	if (is_shadow_present_pte(old_spte))
+	/* TODO: Support replacing huge SPTE with non-leaf SPTE. (a.k.a. demotion). */
+	if (KVM_BUG_ON(is_shadow_present_pte(old_spte) && is_shadow_present_pte(new_spte), kvm))
+		return -EIO;
+	else if (is_shadow_present_pte(old_spte))
 		return tdx_sept_remove_private_spte(kvm, gfn, old_spte, level);
 
 	if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
-- 
2.53.0.rc1.217.geba53bf80e-goog


