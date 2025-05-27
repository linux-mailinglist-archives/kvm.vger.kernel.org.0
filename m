Return-Path: <kvm+bounces-47817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EC8AC59D2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C573BD5CE
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A2D28643A;
	Tue, 27 May 2025 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bt/VbfNj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9175280A5C
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368995; cv=none; b=Yir14FAdvcqKmNFQfJeQCQM3FdMCxlPCEigkKP8AgRDBn8bGf+RYiXEwFD3ri5PsxSkHKRPkZoP1AeHaiTHCT3bnZZPwOJgQ8OcGlVeunSNfhZacmOm1Z/2Jd5MsCcCAJvSMr5qS8qPq2+Q8D2V+OujbEJMuDVujD1UtBVHzJVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368995; c=relaxed/simple;
	bh=7rh9zHe9AHahelF9NuSt3/K+8lnfoR+09S3klGg3nGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fosqtk0GCAKkDdSjzEejCtaGcWm/KttnV6fQVwagP0AqKz8MCfRU2wSe9XvxQ9sMr0QQj5+N1xjtmaJyv2m56inQ+Fj7PY32UUN7VR2/lgpgcmcQ3VqeCE72mZCqVuEk9YCGjtYXp+2PxRgwt/f66pTmFzlFsbi0r8TcYKJdngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bt/VbfNj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-441d438a9b7so352375e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368992; x=1748973792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ALrz1sRb+zGk6S8awUKMjvdNktsAjzmIkhXrUj3xTdE=;
        b=Bt/VbfNjXQB6zEvLlhfeqhGOBpU9dT5eeAG1CIgzWg5uZzVOubQx+qHgIJFeLbAGQY
         VlO4KgnOj7Vn2xoQcGs+t+yAthuaJquN03rdrWHGF2rX7YgM4Czas99UR2AhMpPZ0v7d
         +w+NDKokrE1FTh0fFXkDgWuZMPXT9nYslNcJVYplrj/x3VCRB7dLO79TMhW0jxxgHP2G
         H0brHKSsmwzcuqG4qxXbwyAF/436ze+ZjFFsHCJkjnP18LSe9w1jioAwcnFgNfqgbSKU
         yTiDxAjggMRBvw9dp/vPkbLR/mySMlGa+sw0GTBQ+odpa06urzlq8tNjkvw4YjmnXheD
         vadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368992; x=1748973792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALrz1sRb+zGk6S8awUKMjvdNktsAjzmIkhXrUj3xTdE=;
        b=EPiSkOaJ96qLSw4r17hOgvMxHaayh4agPGm8E+68OOEaUy7eVJyxttH6jj6Ot4raTV
         oMDxUt9ylaFSV3trZtbZPfpOcy1TzjJ9P5McVB7wwotq2blDwuPWAJ+PCO5tkS+oQldg
         330qcFT9Mi/LHiHW/LC7WXNPuIKGBjrDytERiB+E3GzNnxTaE93gLjH90Ji7CGuUegXD
         DDZJQsANL7Vl4J39QCpV7FtbX9VPR2Y7amgC93JOo+Vy3bxhamWsLHYWq8rd59Ksb39u
         Vx3ocJQPpVo8wvVJbvgvgiZ/sps0gNvKabBGNerkHvok2DkkzZ0pLqrUOSTGy/CP13OK
         EJyg==
X-Gm-Message-State: AOJu0YyJziG7Wrw6npzxqTD4oV2f+RdpN8f+Go24PZw8jDwIHkRn6j1t
	/hNOqnkyM8qDqN5uNdHu6RWBKKh+2IDNS3xv6TwfdClzVX3H+mcj6DVp0gBxCXhyID+M5K0UWmG
	KRfxnu4PIyEEXmrFbYweN8U/xO5akoYpBCU2Y5ktX96t0u1Gq4fK4fkPbMa17NzwTdkoEt+R8ZH
	ud1rx6CU5OcK2TXr8IvsXT4fb32O8=
X-Google-Smtp-Source: AGHT+IEodZ07aGUSN9lzHx1HTAUjm24ip1XDGKBVDKeoRhMm1kFvEgr3NfTUnNAICPpNgKbsF/l/u8jzeg==
X-Received: from wmcn17-n2.prod.google.com ([2002:a05:600c:c0d1:20b0:44a:3354:5dfd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64ce:0:b0:3a3:76e2:ccb7
 with SMTP id ffacd0b85a97d-3a4e5e447eemr1432544f8f.5.1748368991350; Tue, 27
 May 2025 11:03:11 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:41 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-13-tabba@google.com>
Subject: [PATCH v10 12/16] KVM: arm64: Refactor user_mem_abort() calculation
 of force_pte
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To simplify the code and to make the assumptions clearer,
refactor user_mem_abort() by immediately setting force_pte to
true if the conditions are met. Also, remove the comment about
logging_active being guaranteed to never be true for VM_PFNMAP
memslots, since it's not actually correct.

No functional change intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index eeda92330ade..9865ada04a81 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1472,7 +1472,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1484,6 +1484,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active || is_protected_kvm_enabled();
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1536,16 +1537,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (logging_active || is_protected_kvm_enabled()) {
-		force_pte = true;
+	if (force_pte)
 		vma_shift = PAGE_SHIFT;
-	} else {
+	else
 		vma_shift = get_vma_page_shift(vma, hva);
-	}
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
-- 
2.49.0.1164.gab81da1b16-goog


