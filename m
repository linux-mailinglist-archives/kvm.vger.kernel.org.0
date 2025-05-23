Return-Path: <kvm+bounces-47513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4431DAC1991
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35211677CA
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9432080C4;
	Fri, 23 May 2025 01:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MjKaOVui"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035B2DCC04
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963085; cv=none; b=huxlM1Oc5lhsntA3vanz+JxSwKsluxy0nEDpWUNhGDtrqlrvrUeWEEVJZDk5ukhTxVCqIprCEMpsAdjF0GK2UGbnkFdVPYvMmoh4voj6UZzEFcfmbqIumz0MMiRp2qIV36wdAcs7cmLn73JLEKsp+GPEUvYpR8e2hHOCMgqpVpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963085; c=relaxed/simple;
	bh=IYjWllSf1O8tGVaK5iCgFM0YX8YjXb0UCSJCL+k4n68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X57vJzthcJTsH51xZHUcgAws2k0IUimF9HSTNPN5cJwzq0ujXOiucsu7NMAhEAUde7RgnKSYq/As6aPkLtVood+qRUecPRvZpa4OvQ6urJr4jRMgj/Jjq6tj5FLAByLjVAv5iYxoIPzKjcsRzOnbfnEBTGqzwKJCwHIVqrPegU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MjKaOVui; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742b01ad1a5so9623324b3a.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747963083; x=1748567883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qTLufNJ/dvcL77EPEmmugmyvzPgpujC1/Gy6ospWm2I=;
        b=MjKaOVuiQwzJuqprDH/qTe1WyxIo6olIPKfs6m/q0WxI4mb/J/j5auf00amipwcrhq
         aNS1z6of9c2zYSpZcYsuSF2loe97Qn7+z/xbU/gNsV638VBcveJwGIXZu0JUp3gUhLS7
         pb1YGRPVVARLSgce5smUM6NiyW4v2IoOD2NUmymzXIOkLMTstyygjRl8pZOCLrXjonvb
         iiZWw1ajPoSuVK20kqinQd/J4/C1MIO61gW91byQwRX4pUkuM54MZajmwjEr1/bkbvPP
         pcyQ3cxNUlbFUoYMqRcWyBkAI/Nx7RdFPDDoWBZCZs5KalIDDaEtXl8OuOU7WL9OxT5l
         lUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747963083; x=1748567883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qTLufNJ/dvcL77EPEmmugmyvzPgpujC1/Gy6ospWm2I=;
        b=hHiEOWoE3XHUlRXTVHo/kzFc241nxYu2IQ9Rt+r4L+C7gr8vMG7cMnLCLKfD3zulba
         zjR+FVvZYEgp8K7uW1e6JNSbC5p1CtXjTI3nxC4kv97X06afTwyM3o1xhVHTyvx45aTt
         68wfETgh1hnP/gNNOJji18HkR+FgSpBWxrxZAH7IvdomwxnCdtOB3cahPAw7RIv92JF5
         5nIV6PLKVyLu8RuqTPYzNOr16E8HWBbh1sBpS2erkd7+a3IV/Y0EHLcF4o0Tyd6wrBP4
         taBSpojSFVOuS2Slc29RCRwEpi+KvZUhYJcwj48OGeG0LRYvB4UMefkuMD688sX4m9B6
         w9nA==
X-Gm-Message-State: AOJu0Yy0mSn7Ngnf7jcy+Nh/Bam9Y7J1NBrM+I70ySJJGMV12nj8o3MJ
	PmRXzn8XbBn3r/PaaRF/SFb0SIz5oQTk7Wg3anXPVq1PMfF1bX+XIAaejpGBtTmVfo6X0sa+h1e
	VAfDHJQ==
X-Google-Smtp-Source: AGHT+IGSpyjSGm+MgA+g3xXjWNrM165HUil7dCrm1uZ6rDDoZjKKJ55Uqf1PAPwBWmntbiHC/fsKAvwDTxc=
X-Received: from pfxa7.prod.google.com ([2002:a05:6a00:1d07:b0:742:a97f:55eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4106:b0:740:9c57:3907
 with SMTP id d2e1a72fcca58-742acd50f3amr37465447b3a.19.1747963083329; Thu, 22
 May 2025 18:18:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:17:53 -0700
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523011756.3243624-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86/mmu: Locally cache whether a PFN is host MMIO
 when making a SPTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When making a SPTE, cache whether or not the target PFN is host MMIO in
order to avoid multiple rounds of the slow path of kvm_is_mmio_pfn(), e.g.
hitting pat_pfn_immune_to_uc_mtrr() in particular can be problematic.  KVM
currently avoids multiple calls by virtue of the two users being mutually
exclusive (.get_mt_mask() is Intel-only, shadow_me_value is AMD-only), but
that won't hold true if/when KVM needs to detect host MMIO mappings for
other reasons, e.g. for mitigating the MMIO Stale Data vulnerability.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index f262c380f40e..3f16c91aa042 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -104,7 +104,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	return spte;
 }
 
-static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
+static bool __kvm_is_mmio_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
@@ -125,6 +125,19 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
+static bool kvm_is_mmio_pfn(kvm_pfn_t pfn, int *is_host_mmio)
+{
+	/*
+	 * Determining if a PFN is host MMIO is relative expensive.  Cache the
+	 * result locally (in the sole caller) to avoid doing the full query
+	 * multiple times when creating a single SPTE.
+	 */
+	if (*is_host_mmio < 0)
+		*is_host_mmio = __kvm_is_mmio_pfn(pfn);
+
+	return *is_host_mmio;
+}
+
 /*
  * Returns true if the SPTE needs to be updated atomically due to having bits
  * that may be changed without holding mmu_lock, and for which KVM must not
@@ -162,6 +175,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
+	int is_host_mmio = -1;
 	bool wrprot = false;
 
 	/*
@@ -210,14 +224,14 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= PT_PAGE_SIZE_MASK;
 
 	if (kvm_x86_ops.get_mt_mask)
-		spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn, kvm_is_mmio_pfn(pfn));
-
+		spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn,
+						  kvm_is_mmio_pfn(pfn, &is_host_mmio));
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
 		pte_access &= ~ACC_WRITE_MASK;
 
-	if (shadow_me_value && !kvm_is_mmio_pfn(pfn))
+	if (shadow_me_value && !kvm_is_mmio_pfn(pfn, &is_host_mmio))
 		spte |= shadow_me_value;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
-- 
2.49.0.1151.ga128411c76-goog


