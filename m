Return-Path: <kvm+bounces-69147-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKmPCZORd2m9hgEAu9opvQ
	(envelope-from <kvm+bounces-69147-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 17:08:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B40578A7EC
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 17:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AC3C43008D5D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 16:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A1A2D7810;
	Mon, 26 Jan 2026 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLJuCO/x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7BF2D248D
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769443715; cv=none; b=ouW3R9oLn/5g3+zdmRcUjy5lvQIY/ObotRVBxUDPg2iz+1qS1Ta2rwZ/yeAmHRmoBgQ3UsllJ9VP3dEvvTVQkP/A50R02Pj9zIGkYCX/d4yZ5PgzN+Zrz0EhX51fBysJBlg6m82j+vgUJN5wHy+NPs0RcJhJZScJ0jbcXutNJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769443715; c=relaxed/simple;
	bh=i0/13UOjqh0H3hZJeMeCEeSDxzFDhYSRZibCgyJD3Mg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3BFD1vXWgH8n3d+a7LqLQnrZ1Hl+YND8FUB3KleitI9VXnWOFwdbT+4BI7pPuYBxnv5qOs9QIvkqd3nUIOhhpPqs4dfsoaJxeDWLYmkvZjhYpokpj6MI4zUUYe7A/vn7X73MXaXxImnn32QY15XMj7I7A+3G/BRophNjnGi0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLJuCO/x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so40709135ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 08:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769443713; x=1770048513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=alAqfZOV4sw1YlCowUnVJaN2ywOCmoZakqxs5MHjFzo=;
        b=WLJuCO/xm3vJQ9x4Xp78aMC8+8F58hufBFu7vHBSfO/HarDorOmEvJMMi6i2a9N9bk
         nfpASEkgcz0MEICEKRmtzOjdXhaTrk6/58tnvtOIleRs+OiurNxwIlLk4346pDFvvg/r
         nQCNB42aMvPw2tIbmR3x/6Eu1qWnoZOYCOmPmpfAAPKzqlduC84N+gvxl5RKLxvLZdHu
         GStF1IiEdlwWW4LOC0Le979Kt9z5Gz9gBHAJ0FJbyx00up2M9JXLmrNm15owAdk0dIeB
         /zJvbLsBvRJ65f0R+0hWEf43qi90aJp1GiuRC9WsGv/QV0t6/mNvYSast/ibUNqH5T6Q
         es/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769443713; x=1770048513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=alAqfZOV4sw1YlCowUnVJaN2ywOCmoZakqxs5MHjFzo=;
        b=MJxfaT81K8q7ov1+CN2hR3ob2pTHQY8JM/Fz8ZDMznDyynNIOifIqjb15aKXKNwCEh
         FqLMWpFe1rwCAyOE28loCF5y7UYf66gV5bPRFTaOxx2Oh9ssrPeF0NpXx77ggt8NjPq8
         0UoYYyvPb8NWxp9oQur/UaKxzeF2w4LhEHSAiEmFiRrvNl3zjXcme7vDgM+5jbTz2OE1
         nMZOcRL5d0hY+27e2b0uYhcUbR5oBPYAsVaM1DYF20xGOeMZZaJSSaZYZ4dvBmm1p1/L
         q66vDW5rsjGJX2ZkyOlvyZGiwgsc2qrWKy8ph8Sj1j+8HaL3ZHsR/ZfxQga7lQ+u2GJI
         9+uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjQgy99aY4cXOHRtyMfG+4BF9OinVg2/1eoDpm+t/O1CnC07zT9z/AgE597E3WnvPr3aw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwetfvpWCFn6eBzcKrMIteOLbFz8pgx1MlTkvnxC0+LrwNbA/41
	CBwt5HbDVrrYbMrQHo9qIEH8+FinoocmV0UYWmdAQvNKS773cfS7/Ex+/Qo0ihpj0Lvmxkw3KJd
	XLKunqg==
X-Received: from pgcv7.prod.google.com ([2002:a05:6a02:5307:b0:c63:4c04:8201])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2443:b0:38d:ef23:12d1
 with SMTP id adf61e73a8af0-38e9f2470efmr4284684637.74.1769443713399; Mon, 26
 Jan 2026 08:08:33 -0800 (PST)
Date: Mon, 26 Jan 2026 08:08:31 -0800
In-Reply-To: <aWnuwb/2TrPAOrbu@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102024.25023-1-yan.y.zhao@intel.com>
 <aWlvF2rld0Nz3nRz@google.com> <aWnuwb/2TrPAOrbu@yzhao56-desk.sh.intel.com>
Message-ID: <aXeRf4Jw6-Sl1JCe@google.com>
Subject: Re: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69147-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,kernel.org,intel.com,google.com,amd.com,suse.cz,suse.com,gmail.com,linux.intel.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: B40578A7EC
X-Rspamd-Action: no action

On Fri, Jan 16, 2026, Yan Zhao wrote:
> Hi Sean,
> Thanks for the review!
> 
> On Thu, Jan 15, 2026 at 02:49:59PM -0800, Sean Christopherson wrote:
> > On Tue, Jan 06, 2026, Yan Zhao wrote:
> > > From: Rick P Edgecombe <rick.p.edgecombe@intel.com>
> > > 
> > > Disallow page merging (huge page adjustment) for the mirror root by
> > > utilizing disallowed_hugepage_adjust().
> > 
> > Why?  What is this actually doing?  The below explains "how" but I'm baffled as
> > to the purpose.  I'm guessing there are hints in the surrounding patches, but I
> > haven't read them in depth, and shouldn't need to in order to understand the
> > primary reason behind a change.
> Sorry for missing the background. I will explain the "why" in the patch log in
> the next version.
> 
> The reason for introducing this patch is to disallow page merging for TDX. I
> explained the reasons to disallow page merging in the cover letter:
> 
> "
> 7. Page merging (page promotion)
> 
>    Promotion is disallowed, because:
> 
>    - The current TDX module requires all 4KB leafs to be either all PENDING
>      or all ACCEPTED before a successful promotion to 2MB. This requirement
>      prevents successful page merging after partially converting a 2MB
>      range from private to shared and then back to private, which is the
>      primary scenario necessitating page promotion.
> 
>    - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
>      TDX module. Consequently, handling BUSY errors is complex, as page
>      merging typically occurs in the fault path under shared mmu_lock.
> 
>    - Limited amount of initial private memory (typically ~4MB) means the
>      need for page merging during TD build time is minimal.
> "

> However, we currently don't support page merging yet. Specifically for the above
> scenariol, the purpose is to avoid handling the error from
> tdh_mem_page_promote(), which SEAMCALL currently needs to be preceded by
> tdh_mem_range_block(). To handle the promotion error (e.g., due to busy) under
> read mmu_lock, we may need to introduce several spinlocks and guarantees from
> the guest to ensure the success of tdh_mem_range_unblock() to restore the S-EPT
> status. 
> 
> Therefore, we introduced this patch for simplicity, and because the promotion
> scenario is not common.

Say that in the changelog!  Describing the "how" in detail is completely unnecessary,
or at least it should be.  Because I strongly disagree with Rick's opinion from
the RFC that kvm_tdp_mmu_map() should check kvm_has_mirrored_tdp()[*].

 : I think part of the thing that is bugging me is that
 : nx_huge_page_workaround_enabled is not conceptually about whether the specific
 : fault/level needs to disallow huge page adjustments, it's whether it needs to
 : check if it does. Then disallowed_hugepage_adjust() does the actual specific
 : checking. But for the mirror logic the check is the same for both. It's
 : asymmetric with NX huge pages, and just sort of jammed in. It would be easier to
 : follow if the kvm_tdp_mmu_map() conditional checked wither mirror TDP was
 : "active", rather than the mirror role.

[*] http://lore.kernel.org/all/eea0bf7925c3b9c16573be8e144ddcc77b54cc92.camel@intel.com

If the changelog explains _why_, and the code is actually commented, then calling
into disallowed_hugepage_adjust() for all faults in a VM with mirrored roots is
nonsensical, because the code won't match the comment.

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Date: Tue, 22 Apr 2025 10:21:12 +0800
Subject: [PATCH] KVM: x86/mmu: Prevent hugepage promotion for mirror roots in
 fault path

Disallow hugepage promotion in the TDP MMU for mirror roots as KVM doesn't
currently support promoting S-EPT entries due to the complexity incurred
by the TDX-Module's rules for hugepage promotion.

 - The current TDX-Module requires all 4KB leafs to be either all PENDING
   or all ACCEPTED before a successful promotion to 2MB. This requirement
   prevents successful page merging after partially converting a 2MB
   range from private to shared and then back to private, which is the
   primary scenario necessitating page promotion.

 - The TDX-Module effectively requires a break-before-make sequence (to
   satisfy its TLB flushing rules), i.e. creates a window of time where a
   different vCPU can encounter faults on a SPTE that KVM is trying to
   promote to a hugepage.  To avoid unexpected BUSY errors, KVM would need
   to FREEZE the non-leaf SPTE before replacing it with a huge SPTE.

Disable hugepage promotion for all map() operations, as supporting page
promotion when building the initial image is still non-trivial, and the
vast majority of images are ~4MB or less, i.e. the benefit of creating
hugepages during TD build time is minimal.

Signed-off-by: Edgecombe, Rick P <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: check root, add comment, rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4ecbf216d96f..45650f70eeab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3419,7 +3419,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte) &&
-	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
+	    ((spte_to_child_sp(spte)->nx_huge_page_disallowed) ||
+	     is_mirror_sp(spte_to_child_sp(spte)))) {
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch),
 		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 321dbde77d3f..0fe3be41594f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1232,7 +1232,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		/*
+		 * Don't replace a page table (non-leaf) SPTE with a huge SPTE
+		 * (a.k.a. hugepage promotion) if the NX hugepage workaround is
+		 * enabled, as doing so will cause significant thrashing if one
+		 * or more leaf SPTEs needs to be executable.
+		 *
+		 * Disallow hugepage promotion for mirror roots as KVM doesn't
+		 * (yet) support promoting S-EPT entries while holding mmu_lock
+		 * for read (due to complexity induced by the TDX-Module APIs).
+		 */
+		if (fault->nx_huge_page_workaround_enabled || is_mirror_sp(root))
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		/*

base-commit: 914ea33c797e95e5fa7a0803e44b621a9e70a90f
-- 

