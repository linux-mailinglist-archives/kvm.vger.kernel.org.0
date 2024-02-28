Return-Path: <kvm+bounces-10198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5EB86A6C8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25CBF287F4A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E9F200B1;
	Wed, 28 Feb 2024 02:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xp+mI7Zi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF241AAC9
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088135; cv=none; b=inCq70xopBMsNjBnpA0dRwiOHo/H98wTOLfWmj1iJrrnTEbe9wwCxcJRKqlyJ9bfQjRXKY2TfYDPrn/wjFSKWz+GNE7IjbVCWaHEWiAKAX/fSWwALtIy6zQCAPiKxu/sqWv3tBTHi5n1o1vMe4dAFPFP9D53CmOwnHTKkysK5p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088135; c=relaxed/simple;
	bh=cV79rJWoCeFTUkciMMwroGk4yVBIOpdWOSpTM312CWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MapzSNlb2Y9e/Zd9V/UqHK2m/mHfaQUhL89UgEakc2dtpggLaCIHcfADytbtMz2B25WehAqTNUHBpxl7vo74qv+WHYj47W2kyE9/rWpX9PNxt8dqLjdZfykHxKX0AIGqvwq1SBTeVFSqRVGCEgaD+pra22JjMvZ78aJN3sOXhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xp+mI7Zi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2993efc802dso2200123a91.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088133; x=1709692933; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dJc2s9t1awM79/Fy1pb8zawduPtJBJNE9uUwyg5GGwY=;
        b=xp+mI7ZiWfjE3IFH4YwD9lyAfW7sd1lMUxvyRB40HLiqXdbsQtw11iZ4Wzd5MotUfT
         JLhiaibdTS57YLVP19C4BrPT1nT+hGOEhJaN0m2kHIq/qO7zHq3+L4Z9ao/LNNvF8w0N
         I1kNTKBcddmnw3zCLcxuBdUTeTDHWZxz8gs69fWF7gUaRviaiO+Jz5qUu2I3uiWYEjYW
         qarlBaS/jpbSVeP+MmOo1WFL8TDOrv8RCECpLRTnyd5Er9DL1UVZqUZTxH+X7BEUJk8W
         8mADb1cjVVEooZG9VYutd1Jyot9GgQHbng8BjQ6LFGth2y2kixRgZq8RkTVtXRJYej3M
         9i7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088133; x=1709692933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJc2s9t1awM79/Fy1pb8zawduPtJBJNE9uUwyg5GGwY=;
        b=Wr4CNMP7GLkIV9LUfvwFR5f8r3sc84Qw+1zOOj+217unlsROBEjqEENWLXlSqCXmSw
         PchjT6URWb3fR+6qQ423Du0v8I6cyoCOml203/lWUarc2RJkKb+DxKkroDLMsJmLy+E6
         ttT1w7ysq1XNXDRyduHTs89aKv5s29OlCBThYn5MYbXxlQH8nWeehcxUa+AANFt1E6Ou
         t7pDLUQzqmQMeCRHxt9DxUFPn5XzGWJboz76eBqN0XJJkKiWpkXeqh7cmUM/UhUfWWel
         DJZr+UDIgyPRVyuoN/7wsARxfWVNxCT5+0vBFatJ1/f5+LgmUuWW+4/TGcAqupoUR82y
         8Elg==
X-Gm-Message-State: AOJu0YyWxJHXSmL8w3I5GLxBHmPdAHAs1QI2P2HvQwgPohk242p2A2et
	G03ghC90WgRFi8A+315JZJhzSeV3qTbyZLixE0p2HlClfXWgRaab+9fw4NxTANmy/IEHSlrdNbE
	o4A==
X-Google-Smtp-Source: AGHT+IEQrtR9z7mv6fKO+/I7F2jfZx7cwviWFpuAmB0BUMFbXR6LBdfKH1SzjUSCUVSMy+xt/hWaCnTFa+A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3cc4:b0:299:979c:27e6 with SMTP id
 qd4-20020a17090b3cc400b00299979c27e6mr37082pjb.4.1709088132789; Tue, 27 Feb
 2024 18:42:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:43 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-13-seanjc@google.com>
Subject: [PATCH 12/16] KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn()
 to kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the checks related to the validity of an access to a memslot from the
inner __kvm_faultin_pfn() to its sole caller, kvm_faultin_pfn().  This
allows emulating accesses to the APIC access page, which don't need to
resolve a pfn, even if there is a relevant in-progress mmu_notifier
invalidation.  Ditto for accesses to KVM internal memslots from L2, which
KVM also treats as emulated MMIO.

More importantly, this will allow for future cleanup by having the
"no memslot" case bail from kvm_faultin_pfn() very early on.

Go to rather extreme and gross lengths to make the change a glorified
nop, e.g. call into __kvm_faultin_pfn() even when there is no slot, as the
related code is very subtle.  E.g. fault->slot can be nullified if it
points at the APIC access page, some flows in KVM x86 expect fault->pfn
to be KVM_PFN_NOSLOT, while others check only fault->slot, etc.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 105 +++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ebdb3fcce3dc..8aa957f0a717 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4340,9 +4340,59 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
+	if (fault->is_private)
+		return kvm_faultin_pfn_private(vcpu, fault);
+
+	async = false;
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false,
+					  &async, fault->write,
+					  &fault->map_writable, &fault->hva);
+	if (!async)
+		return RET_PF_CONTINUE; /* *pfn has correct page already */
+
+	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
+		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
+		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
+			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
+			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+			return RET_PF_RETRY;
+		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
+			return RET_PF_RETRY;
+		}
+	}
+
+	/*
+	 * Allow gup to bail on pending non-fatal signals when it's also allowed
+	 * to wait for IO.  Note, gup always bails if it is unable to quickly
+	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
+	 */
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
+					  NULL, fault->write,
+					  &fault->map_writable, &fault->hva);
+	return RET_PF_CONTINUE;
+}
+
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   unsigned int access)
+{
+	struct kvm_memory_slot *slot = fault->slot;
+	int ret;
+
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	/*
+	 * Check for a private vs. shared mismatch *after* taking a snapshot of
+	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
+	 * invalidation notifier.
+	 */
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -4367,7 +4417,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
-			return RET_PF_CONTINUE;
+			goto faultin_done;
 		}
 		/*
 		 * If the APIC access page exists but is disabled, go directly
@@ -4379,56 +4429,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private)
-		return kvm_faultin_pfn_private(vcpu, fault);
-
-	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
-
-	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
-		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
-			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
-			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
-			return RET_PF_RETRY;
-		}
-	}
-
-	/*
-	 * Allow gup to bail on pending non-fatal signals when it's also allowed
-	 * to wait for IO.  Note, gup always bails if it is unable to quickly
-	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
-	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	return RET_PF_CONTINUE;
-}
-
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			   unsigned int access)
-{
-	int ret;
-
-	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
-	/*
-	 * Check for a private vs. shared mismatch *after* taking a snapshot of
-	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
-	 * invalidation notifier.
-	 */
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-		return -EFAULT;
-	}
-
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
@@ -4458,6 +4458,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
+faultin_done:
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-- 
2.44.0.278.ge034bb2e1d-goog


