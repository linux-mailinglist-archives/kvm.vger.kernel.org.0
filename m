Return-Path: <kvm+bounces-36876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D97A222D0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54D101882FC9
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21A41E25E1;
	Wed, 29 Jan 2025 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y8jDWUB6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447781E200E
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171420; cv=none; b=iKCSNesl/hN7CcVgivb23zNw70/mbeN7nm1+ZSOUOwJTUgE9gpyUprD9AkPPjrUUqvK+AjamyeYMAO+hdpQFs1mcSegmsQuWTvW8MvTDTPy/U4gxBaLpEsNuEz/qqWBTKJRG2zmiFBCn+ymE3H97NWSEsIB5ntE069UtpGarGQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171420; c=relaxed/simple;
	bh=XPNmo/FlP/BRMBwZNSeXSnV0XlcjcPy5hRJg1uWWx+w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tziPD8a+aF9ldc5OuoQAcL2X1wDmpk0vkiPf2UObyfIUdXQNK/LeDH8kZWXjMctRkHEgfs66Kv43Mz0B2hGyGO26N8zzOE2UuNtMDFAHOEB54KbL5cFOxi30ez7ITj96m4zLreqWTLGyadfOREf5QtP5Qbi65KjX54hCfKpJ9uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y8jDWUB6; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43624b08181so5264765e9.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171418; x=1738776218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clAA2pQ0aAsHHtJcPdsprveMf7sd3Qr2fHuajtMaEDo=;
        b=Y8jDWUB6sY/iEROUdJnpioESNF3mbq2PNNMitNm3C7lNGDK4dg2dE/Zd6w+OygB60j
         SA578ItYOuY12ZWCylbBrPRsAU3VEO0p4Irf81rfYw2vgk7FBIDB+S5kECOkQgoBpvIH
         wfI3PqN9O6WtUCFW9LCIz6g9VDeo9KtW3wa98x1AQ7m48thuRgUF93EOQeKRCByL+Dtp
         SKAzJDhv/gPhWoghiEu4IocOgo4jmZ9U8OQxvSo2Gwz74bo1sG7mE69Y16zNqgUGBsSk
         WOfkgWAXS75huRWifQW2/DBiAR1Z6wZujvP/iz6VXtAl5lPi4eYQX/t3cpIhPegAal/C
         s6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171418; x=1738776218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clAA2pQ0aAsHHtJcPdsprveMf7sd3Qr2fHuajtMaEDo=;
        b=e6FubCy03gWHAOoWHPjIdOgxqiOOJxH/N/W/r6LhbEUWZU2Q/GzGj4GwiNlt1Gk8/t
         xpt8pG3rS0y9DrE4sUPQkuapPE68Yhb3Q4Tkk13epPUZeYOspA+A//e3zNie+brS2uto
         I5xr5Uw9r/8bxbTNYcqas1Yf6mOorAA3msOCoh9QLxjpTWzSLQNhSg/lFsR1oFOxkB5D
         VjagnkVJ+57sNLuA98xkkHSQaWSI1Jdg38YTlwKXRLW43KroH3t30/g+PUyFuDTZbw6l
         VMq+mEto9FgrcMGtBLPHVVhV+rgrOPvCMZDpLXS+bUZ8opWUrd1iKpdv+BuzRBuQ/rqK
         zVrw==
X-Gm-Message-State: AOJu0YzzRWdsdvprgwEfzr+DpaWwbmnKk9AcNGXKi64MDTjHqDB6zXNJ
	mm4GleSngPee5Jaz5C8/F6niPLubeuQbXRH4oOe/pH4vPky8c/33uajgF61wn7aRYG7At60pqtv
	634EE+uNTWV+ldIhoWi2s8hZxakjDh/NzCAJ/779vLZxwH/RD4phlktRwgaXqZBiosOMUpJV8KQ
	KA2vkxoYipIX10J3OWPBSGE+w=
X-Google-Smtp-Source: AGHT+IH4Z/w8m7ect4Xjx7d6nFW4rotWrjkyMgHYG1tUIFYfo/owBhkDUsni5QfNbmeYmc7O93FGA8qkJQ==
X-Received: from wmd22.prod.google.com ([2002:a05:600c:6056:b0:435:dde5:2c3b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b8d:b0:436:1b77:b5aa
 with SMTP id 5b1f17b1804b1-438e15e8307mr1177165e9.8.1738171417631; Wed, 29
 Jan 2025 09:23:37 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:16 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-8-tabba@google.com>
Subject: [RFC PATCH v2 07/11] KVM: arm64: Refactor user_mem_abort()
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
index c9d46ad57e52..1ec362d0d093 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1436,7 +1436,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1448,6 +1448,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active;
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1493,12 +1494,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
2.48.1.262.g85cc9f2d1e-goog


