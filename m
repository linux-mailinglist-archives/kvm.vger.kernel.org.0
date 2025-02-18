Return-Path: <kvm+bounces-38468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7F0A3A442
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C02A3B4EF8
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B0026FD82;
	Tue, 18 Feb 2025 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MMH2ePXo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFBC26FDAD
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899521; cv=none; b=tiAx+ppMQySBSxU0Hnr5BvKjpPc4b1NyvhnLedktzVGgOpbsqdNbtEP3jVVryrW8GM66Uy/0PqEPD5RGEOZ5a2cOymG5h9daV8I8Jj8Nv32Yyb+L4oQDV3Ig+LV4r4FZwuBCZeoMUxwDPkMYg+xtmoTAz2diN9qyu7bRlmZeAbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899521; c=relaxed/simple;
	bh=n4puc9fJmKfWIWCeHx3xFeFZ8ulIS+XxAcYR41Q1stA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lme3YOTIVJM2WHAU0J75DFjoxrZMBqFV85M0Xaiab+74CjiisnokvXiIl8UrXT0JWPMnIekwdk/kZbLeWzE9P6b3pZUilF/IN65J4Q4VHbTdPaHUm68qwpAKQUhefwEH10M2nbtU+7Tmc0jJO/hVq4Af2b6Kepj1VMynQ+DElIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MMH2ePXo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43988b9ecfbso10903485e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899517; x=1740504317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+1jJ542FIUn0Rr8Fjhsk4rNdZzsZ79ixZS3qAefs1s=;
        b=MMH2ePXopB/ZpJoutVslgjGQbvkC+D11JL6MF+hknYRXPUnU3+Zo/uIFnT7NT9ij0s
         wLkV4q3OtbfiqvSHG8CBqUsp0lFZHfbb80ULSD7cn8JKRgIF5jbENnw9VV39CE0KQI01
         0fQ21NdsGZWNqBIhx7wL80s1dG25m8B3gbK589217y7YNaWGqlr8sklXwYKn5R2bPfzd
         uYv1ZRekt9nOq8jnLR5nk5Tas+UJ+/WtGiFdr2X3Z5jWDAhKZWdyUUlY89Om4Y5PtUZA
         k2JFfq+NbqiePaA+IKOt1tK1VXk/IaxD23GSJog1MbJIASowkWTH6tFpEsEBQ2twJ1/l
         72Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899517; x=1740504317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+1jJ542FIUn0Rr8Fjhsk4rNdZzsZ79ixZS3qAefs1s=;
        b=W5ZP3Ahj/An4d4R7MnYyUvHpTrOFoJtVkJdhAHz5XBfDbfvtVux4a70Ck63ZV2Ziyw
         sfrqqn0a9oi3rwctE+uuhNeyAGC/3TPtEhnWfEce5qfqrFZ1apE8Iv3IQhNmXx6Dzlmi
         utxXzgU0tsjt7zuYNt85UgjbSXULkHVkWjIiNkCAe84kYx+Gbro/XaqD5KBKwlubytCB
         2cnAJZZa2XGXoG737Y68xzmKCPXI+S2wNHrAMmtx/Ma24L9n19+/slidX+4hbKZ5tMZA
         jFmaCrEjjK2DnmcgZmiteTFWWzwySA5Sr1ZTnruz4X1jCoMqW8v0iAj75AczNKUPz1tD
         YN9g==
X-Gm-Message-State: AOJu0YxqtCfKJU+zDnSV8kvxoqYgD7AfbDRwy+W+vkndPj/BFsu0Sfji
	aFvWYpVsbMUbI5M8DJjqEml/ASaibPPAv2PIGWOYReQC+mtTJJNsS7MeihBCxQ5DZSWj3pomdvg
	HrifxnnTUlygcWGsP5Rvye5t1V02unHy3Ih6ygqKyVfYOOpV1Dp9w6t3bnI/mhPmMg9+5bG1y/5
	xGoFCQDlmuJvl6vY1iKWNgHu8=
X-Google-Smtp-Source: AGHT+IEomX75wSUKcjYlPTL8ccxKDoIA0hN0/nqjvlvYP7OWhi/yQq6R2XsnyWNa2w6ZlekuJlp64UeMTg==
X-Received: from wmbfl27.prod.google.com ([2002:a05:600c:b9b:b0:439:848f:2fc7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ecc:b0:439:685e:d4c8
 with SMTP id 5b1f17b1804b1-43999daff2bmr5080855e9.15.1739899517280; Tue, 18
 Feb 2025 09:25:17 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:57 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-8-tabba@google.com>
Subject: [PATCH v4 07/10] KVM: arm64: Refactor user_mem_abort() calculation of force_pte
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To simplify the code and to make the assumptions clearer,
refactor user_mem_abort() by immediately setting force_pte to
true if the conditions are met. Also, add a check to ensure that
the assumption that logging_active is guaranteed to never be true
for VM_PFNMAP memslot is true.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..b6c0acb2311c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1460,7 +1460,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1472,6 +1472,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active || is_protected_kvm_enabled();
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1525,12 +1526,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
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
2.48.1.601.g30ceb7b040-goog


