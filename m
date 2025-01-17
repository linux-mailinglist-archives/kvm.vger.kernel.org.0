Return-Path: <kvm+bounces-35820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F976A1545A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FC40167899
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32F81A264A;
	Fri, 17 Jan 2025 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lolf1plq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EC1A2545
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131435; cv=none; b=UKG4a6ipZXjEhilEIL/bjXyinBmp1qHrtQQPb1Jw+5gqvVuCqyzVpD07gPKXaz4rYia3Doy0PvHuAUawWkPevNdk2cdIOTj6YQyn8qfRjoQPl9YpDYCeExEqTLC205usZeDqQXI7qHLNO1zI8uE8s4wKYwFlkflAPYemnmLbRvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131435; c=relaxed/simple;
	bh=Ob6kypo+rDvvEe1SpVMk9She7l8fCRqMuFfEC3q0tDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SLvcf7mZuXPQnB+fcbeBX0vm8g7yFw7nDO4Rw4Mi/fsaj+b5Gu30eKVnp7Lm/g7qrf2/2C3LhobA/mUHQ5t5Y8hrL+ytC2VtrMTZ6XovdTI6vvmJo+92YKr9nF6pZAzxkTY4zEjD/WHS6xSduWfs6hZCNTfviWQwsmU/MW6HQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lolf1plq; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so17266065e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131431; x=1737736231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3HB24ys9olZtoFbzLvLFGPKqOLdaE1YgibZ0bUHAkc0=;
        b=Lolf1plq2h++fYHdbFqA1Nfeb5bHhNBHF8exVcpCKKfxAu/MYpUsuyq07MjtFP1dju
         us/dmVj1dD2mUAY2pf7wl3ofI+IzaL3wFC7XEnaxqnNtL9yJsQ9u6vRasAAWO/fRuBEB
         neWRlQ/HfqbIU1NOtDmj6cVrMSUpidGQPLn4cFR+q8cWx5aXAn/zbJ1Dd68PmBIwXZk4
         JkrWZ08CdJiTvPFneuJgBGBE74E50rRHb3/0KzdlwfkVmJxIJpwAE1SERVYC06z+tzuS
         SrpX5d7mRs7/wK3PObBsNZiyQvyuksgQ+mxSG5r07V4L8OZkO3lmNuOAVV6sNdTh1iiy
         z6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131431; x=1737736231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3HB24ys9olZtoFbzLvLFGPKqOLdaE1YgibZ0bUHAkc0=;
        b=EeZc3pUTWIoLWwqayaotSt5VEFhzkivpCEV+wtGuMmeeMQJXQUYY+sEeJTtgwG7lIe
         Uktl7pyf3s2L322ixvRYGO0GuSjWI5X7V1mplgWsZMpm2aXUdSDFwV08luGLU7q317U1
         zuY12pAQOZdQIslAe/7B8acS99QURM9Kel+6bDLOOPrdT138jSuGxo17LNMQ7RcgRIve
         b/rK7a/Di1hh4CVtukR0vpbMIsU36L9hcf7bzhJgyXUGcwo5yOQgcwglH+UvAvfnBTj2
         Ky8h6aV/qRePSuWMzHCTDX1HVKn3mUsD577aHAafN7gj3iATVPujitkHj22aS5CR8Bro
         w2Aw==
X-Gm-Message-State: AOJu0YzsR9dPolLH2na0JOhEyNq80LWE5E18GnJdE3rQzZQGPtaxDuW4
	wMaRASJKAn2fUyVsVORwSL7VfqluhUZvVIQSBjN4LXChVjOyYdZ5im/93zGhL2+1PoktwxyAxH4
	/Wr5Y9BB3flqClG8F+vQcHWC7U7E7ANWP/AbK44/Bn/ZRP5M6u92QxKIYZQ1Mc0/EZ40shvLqBT
	gdzKwkgOSMXtARnNN+G37o8eQ=
X-Google-Smtp-Source: AGHT+IGXpNihxZ+huy1r8urGkN90UYrt/W0V/muXsXaxH9j2ly0sDzEqcBhbyJ7KDudMWMW1llJmatLXLw==
X-Received: from wmsd5.prod.google.com ([2002:a05:600c:3ac5:b0:436:e660:a347])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3ba7:b0:435:21a1:b109
 with SMTP id 5b1f17b1804b1-438913bdcc7mr32672145e9.2.1737131431466; Fri, 17
 Jan 2025 08:30:31 -0800 (PST)
Date: Fri, 17 Jan 2025 16:29:59 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-14-tabba@google.com>
Subject: [RFC PATCH v5 13/15] KVM: arm64: Refactor user_mem_abort()
 calculation of force_pte
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To simplify the code and to make the assumptions clearer,
refactor user_mem_abort() by immediately setting force_pte to
true if logging_active is true. Also, add a check to ensure that
the assumption that logging_active is guaranteed to never be true
for VM_PFNMAP memslot is true.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 342a9bd3848f..9b1921c1a1a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1440,7 +1440,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1452,6 +1452,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active;
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1497,12 +1498,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
-		force_pte = true;
+	if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
+		return -EFAULT;
+
+	if (force_pte)
 		vma_shift = PAGE_SHIFT;
-	} else {
+	else
 		vma_shift = get_vma_page_shift(vma, hva);
-	}
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
-- 
2.48.0.rc2.279.g1de40edade-goog


