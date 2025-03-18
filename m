Return-Path: <kvm+bounces-41403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B10A8A67912
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C64FD1899CAA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B04D211A0A;
	Tue, 18 Mar 2025 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFnh9HHL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C112116FB
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314721; cv=none; b=Fo+LmdStHSM6uA5h6v0QnqYWTMDSzmxcyKldb4S85sbS53oOvcfClELApbTQ46oQHqL60jSpz47vjk4jkMK760MXkIVvCLenWOjWqM+V0vnfyJvIDlIYksLnErNYckbIBuPqVIYe8XyUlsugTczwK2oBttpyYvFiCfPq1ZZW3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314721; c=relaxed/simple;
	bh=umxu8C2NoBOTv0LQ/dw87xuKmoh149PdPjPT+CmuSyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W8rwWl96YdDpanJYC09g/e0U2EXVfwywDtXZQ5jyAvKXVlsvQ/v4N/jjfqXMwNBTpu3fUxIvIxmw6GAIA5Ze6pLduf56Au6dDQEJ3Maf9kw88SWgOTJPxf9ObyYuUKNUfbhpvFFPXB1KoYvfxXTbrtZDErCiOyxwj2CZdEWhl78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFnh9HHL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf3168b87so19547265e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314717; x=1742919517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DD7dn7Ly/beG6AZrtqzXuPgQ+MQFh8NjMZMFS4hSOZA=;
        b=NFnh9HHLyxmcPb8PFVAoBQDN785yhgj8FBNeHV/C2p4/bnIFl/+1dX9qvZ5iEmAWU6
         TUEFamdjiHtVt2GNNVOq87eAg3F97sgNssoR8AKwqSwzRSdTR1T3u8DDabU4+0k0jr53
         e6tRPXoYMSPVpn0FzYsuzNntokUahVMFufIAG60+LfBw1521e8cY5XEEqjhmQXtf/LUS
         HKXtORdXcgfc7J+7yhdklQxrIobaLPqTIOFNzHWd1g7Ch0WFQtlmlu4hAfURI+gRty68
         qIgR/lsAf5ueopfnpW2R0IrOVMnVVjgmOJY0cdYL09qRBIqDT3AEPIWS7/iSgFm8+UWx
         FADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314717; x=1742919517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DD7dn7Ly/beG6AZrtqzXuPgQ+MQFh8NjMZMFS4hSOZA=;
        b=p1aMtFgxiQhxqz9uCt+qUqiGUzgUROt48mw8mUb0UMHAZVBAiuI6mpcLthiu6Lyv3v
         gPLXjP8P4nZCVhA+yo/JYEVpPXsmDA50ZJhj+5BnuHOS5lqAal6Jm2AKuwQxezRmnNgA
         f+rxsAD29Bmb17SueCLZzLgvJzqKRA1X5aDwT3lfDPhtaXvf06ij1I9+QRQxUohyLldY
         rvcOAomDBXUBjaLy8k0XOHDzoJJKGv6k8wu0awwknfjkTbftx3fwLgeT5puGKPNJ4Epx
         hLzNSJW/7hABURIfITq6R1b1brKKPMTRxFObfKNpyXzbDaUTIO/Uq2gQOETDpz0Vzut3
         vmZg==
X-Gm-Message-State: AOJu0YzJOSh4c8fIJV3TjVC3tFHlUJCPJLkJdwNAryp5zQhU7UcD45EY
	8uh01jmIself/3NkRSaJYjibJ5biueW+ox2IoghS48Ere6/y0VO/vS6yMdoOPcYLs/sVNlgNwev
	0epHPhiF6rsUX9IZSiEZF3P0jNwasaN4zTd+nYjAQ3GhgY885MKnVGxBT8Yl6CArjuvHw4BTMcE
	Q5bZ4rikKXVTPoaRnAn8rq4mE=
X-Google-Smtp-Source: AGHT+IE7EIJMDoVEqpxWR587eRp2r8+Ir2MgzNO4zB8DTw78LEPUQteJjG5XQUYQcTjpzPemxYUdDq36BA==
X-Received: from wmcn4.prod.google.com ([2002:a05:600c:c0c4:b0:43c:fae1:8125])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310e:b0:43c:e478:889
 with SMTP id 5b1f17b1804b1-43d3b7c9e1bmr28562425e9.0.1742314716949; Tue, 18
 Mar 2025 09:18:36 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:20 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-7-tabba@google.com>
Subject: [PATCH v7 6/9] KVM: arm64: Refactor user_mem_abort() calculation of force_pte
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To simplify the code and to make the assumptions clearer,
refactor user_mem_abort() by immediately setting force_pte to
true if the conditions are met. Also, remove the comment about
logging_active being guaranteed to never be true for VM_PFNMAP
memslots, since it's not technically correct right now.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..887ffa1f5b14 100644
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
@@ -1521,16 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
2.49.0.rc1.451.g8f38331e32-goog


