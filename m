Return-Path: <kvm+bounces-23283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC69948618
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 522A21C21FAD
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE3B170A3B;
	Mon,  5 Aug 2024 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AgfY0iJf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFBC16F908
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900688; cv=none; b=OZ4cjjYcevAvPeOj5C0hjCoc5ISASdx58jWM4fWHyHHTZP8+ReLdENWD94cyCqtULAm4VGrJJ9VGvoPD0LVsp6uLhKp4uZoOhTxsuncRIcR1QVL+MBFNJeVgxNQf+U1jsK1pcAqInKMZkoqDQs7fF/S4+k1TbgghcEmg2+FGtZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900688; c=relaxed/simple;
	bh=d5cSeUOtBkn+8CWRq66OLV/SdNt/opIkb5HC4NekoSk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AVVFzQG1o+3wDTmn+e7OQU85Q9ZIHMWGKgXYG+oCZGgWVWBNCLnRKJp+xGx43L4y6Gpgsfg04/KmZMQPgvjtUTlJMksKTy0V+YU8mccP0LZlaLe3fOxjNo7fm5yapw6MV1f3/Kd3s7hkdlDvdgRPWIpT0voLKgrcJXtTK886RDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AgfY0iJf; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-666010fb35cso5010407b3.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900686; x=1723505486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=egp86X5rm0dkr32bM6IyMRoOHcUMKLaRskZtRCsJ9Xo=;
        b=AgfY0iJfumuxy8OkTPoKNciehoz0JncYEhQ+IE6JOWgR0w5wGOswkGrJGdwz+AvazU
         Xzg6v5xbRxEZn1X0qFBPMeOHTjmWeQ+jGAZvOuGGEXbBVp/wG9BFUEzY+q2z/n44+CoH
         SmlFeDp5hevcEDQCYK76U1Oi4J8xxG/PerM6Sl4Qm+cQOJW6s/Ffkl0coqcbR6z+4T+q
         c+LrYl5BmsdyFnTcH+V5tAIITZhwYcsOMOg7ODM+FIj1VtzpHCXTsIWLS3o6/m0kqte6
         E23XdUB3G5dLB1FD+2lY7AkXvTG0M2cMBmilbHiG/4zLz5gqZYmA2o8Y8R/mfuG/fRuA
         kUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900686; x=1723505486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egp86X5rm0dkr32bM6IyMRoOHcUMKLaRskZtRCsJ9Xo=;
        b=ulKd3xc1jbWkXr5ktM/09R+N1BpEdb4as4t8tZANQzeXLK65kMabaCMPczYakKt62j
         XtNZSaNAv9KPBUdOIvVMEEqgSTeAL2iC0WPsxBnYIrnesb4prcp3HyUV0O3nsmA/hNgq
         TZoMFdqke1jpMfFD1V33eKEjRe7jmwp4rOFEtjnYdtoO7+NUAH4ponF5XHDGFkkvowdf
         E/se3xWQBQ/VE5PlF4+ndyGPkvg3sE0a3QUPfh0GIPGOYG0qtR2uFNo3x/efwuqocZlG
         yTXcGATwomLEp11/aaueNxD3Ih5sWjXyktYV17ICu9OvCpXgAMqces7r6n/Ef3m9G4HK
         4How==
X-Gm-Message-State: AOJu0YwXKnwuVRd0n9ijTJtusmq5df+C0j082Ay76FMlJ0TABLdcqxAO
	rgAAh84o3tbWpXPdPYPkS+9P162a8VvwwZeMq5a7JxExIw6R1Jghgf7FtGQtQLxcQCXAVX6jJbS
	tdeym5kHgGg==
X-Google-Smtp-Source: AGHT+IHMPMfBa8ipSgkSi+Jkkkhx4dtrHeqWVmB9zKhr7LQVybrCF+feXixABH9uFEe1v3OZ9Ihp9M9lY2r3EA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:d82:b0:68e:8de6:617c with SMTP
 id 00721157ae682-68e8de68517mr3937097b3.5.1722900685792; Mon, 05 Aug 2024
 16:31:25 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:12 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-6-dmatlack@google.com>
Subject: [PATCH 5/7] KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename make_huge_page_split_spte() to make_small_spte(). This ensures
that the usage of "small_spte" and "huge_spte" are consistent between
make_huge_spte() and make_small_spte().

This should also reduce some confusion as make_huge_page_split_spte()
almost reads like it will create a huge SPTE, when in fact it is
creating a small SPTE to split the huge SPTE.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/spte.c    | 4 ++--
 arch/x86/kvm/mmu/spte.h    | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 34e59210d94e..3610896cd9d6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6706,7 +6706,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 			continue;
 		}
 
-		spte = make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
+		spte = make_small_spte(kvm, huge_spte, sp->role, index);
 		mmu_spte_set(sptep, spte);
 		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 979387d4ebfa..5b38b8c5ba51 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -300,8 +300,8 @@ static u64 make_spte_nonexecutable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
-			      union kvm_mmu_page_role role, int index)
+u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
+		    union kvm_mmu_page_role role, int index)
 {
 	u64 child_spte = huge_spte;
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 498c30b6ba71..515d7e801f5e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -501,8 +501,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
-		      	      union kvm_mmu_page_role role, int index);
+u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
+		    union kvm_mmu_page_role role, int index);
 u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3f2d7343194e..9da319fd840e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1328,7 +1328,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
+		sp->spt[i] = make_small_spte(kvm, huge_spte, sp->role, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.46.0.rc2.264.g509ed76dc8-goog


