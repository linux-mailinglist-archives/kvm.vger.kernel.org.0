Return-Path: <kvm+bounces-69482-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLwLKZ23emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69482-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B94AABDB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9134D308DF17
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED55331234;
	Thu, 29 Jan 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r5sWMCqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A07361DC4
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649388; cv=none; b=Vbr3RqJ87ecuJDE3HVkddEynWQ7QlwY6l00XVJGc2SHpFG1bLCbxFMNvgB+2KR2r7jj1Q4xggrd+xGAwEUmw2Yhos9gIFEWtUNLWXTapEaaAz3JHJmFgT4MViCFHpvw49/QoBsU3V4cG/ww8hFo8/z09MFjbbA+v3NgMQyz6NJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649388; c=relaxed/simple;
	bh=MXrNqxIppqNsimK8K/2l7kp6YfDuyBgadcQDGD92Gkc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SOLwhkKgSnNmM3qSIH4aPE37EypgdwL6ABpfJxOr0PaV3QUSfWTmT7VdSbCf6EKFpTRHqXGl9Wt+U5dBlKCOcOBDlNwXZMR8I3w36YoK8EogmQkQ3kqZ5bjpy1VYDPq6M51YkkOBkFuLH1dnqT1/egIz5hrNfZqWNum1f/n5n9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r5sWMCqF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so331730a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649386; x=1770254186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XitJqErgB2rpX72/d+fDj8zwONic1fb7Um6zwnCWul0=;
        b=r5sWMCqFwdDaw7KulBji2YBerR0rUuIxkCrLr87M2VIx+TpQoe6kLPfk7qhwijc/+Y
         JIC+fMLuys3HAGQrlLmHzEqOHS9nCNIFPup14L6XrfV2FhhN8lqHQXdgwHZFwjsFPIEe
         y83zUBohwKR2HGBgGo1MbmuumMXGnp2vobiZSfTsgYFZEe8JZEkgEF52nW31ryuqb1jg
         okeAhNEsJbSHTQRA6vlbntfx/nEpyLT5TaN/Y9M5ECx6nxb0zETH5ShKybOShszDWISF
         +XSKP5hNEj8dGOuSENKfF1TuFC5km90VZZ+j9rxp9d76Y0OTZD2O/b0r5ZsFv9s/9Emk
         ytvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649386; x=1770254186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XitJqErgB2rpX72/d+fDj8zwONic1fb7Um6zwnCWul0=;
        b=nJcGyBMiHECJdR60S/8RbSKE0T+xXyC2gJFFtwW5Z0ptDzsXh5Sp2JxiHUtmmOqWr8
         OZutf2INTr07WiPxhUcy7n/fogIg/H5wUMiWx2a5z/+iWx5mq2SIiZ0yTf9PUSAQORjM
         MZHE+4lfg7PVSuPSyerlsyS4B3onUGU/LLlLai5vWVhq8NGoiVsEF27ZTbHW1n6f2JpU
         BawTSSJjy3lwG+Ozsa/8JlAUp7loNNvDCYVdebgOL/a0PdQibfJEkf7pK1krp6MZ4pjM
         uhjs66E03yLAw5E69fwnJdM20ZWIRPgvy9+NM+he8/UhS1MM0/zBeCDQ8wuv745wDaVV
         Uddg==
X-Forwarded-Encrypted: i=1; AJvYcCUiAwdsxPAFMDH4lIQ5vRCNrEy1kDZBKt7IYfoyEPwxPOcfJtR4cQn7hv0a+D3jEMzuS4E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/gVkuMC2kEKJqh8OvkD0gShL+W+xX3y67BhhPnOFc1LNGLoW+
	edhbrkYcKGgFX86jBsvV568hzao5yusHgW93jeD2ZdzS4xWKWuM0BXiy9GiRGpa8Z31dg65j1U4
	7MGMIjw==
X-Received: from pjbbf7.prod.google.com ([2002:a17:90b:b07:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:538f:b0:34c:6108:bf32
 with SMTP id 98e67ed59e1d1-353fedb94b1mr6266892a91.34.1769649386237; Wed, 28
 Jan 2026 17:16:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:03 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-32-seanjc@google.com>
Subject: [RFC PATCH v5 31/45] KVM: x86/mmu: Prevent hugepage promotion for
 mirror roots in fault path
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69482-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 44B94AABDB
X-Rspamd-Action: no action

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

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

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
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
index 01e3e4f4baa5..f8ebdd0c6114 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1222,7 +1222,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
-- 
2.53.0.rc1.217.geba53bf80e-goog


