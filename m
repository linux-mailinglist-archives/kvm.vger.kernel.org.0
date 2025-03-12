Return-Path: <kvm+bounces-40845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B736A5E34B
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1B6189D643
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32E7258CF1;
	Wed, 12 Mar 2025 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0zEue3g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E43258CCB
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802323; cv=none; b=ezScjh0VLGJ49AqBcGFwbLTDPfOQ3r+EtXU4H3TFy3HPvO/Zgzt83Q7+YpJuizP1lU76Z4ADcGP03jIssZM9DuSD9Ajb/qxxTQ/3YifulbHCnh1yx7QLObB6bbDHoMhak14c2QdRWXbXqEgv5crUe8T6CyfrgJwwpVctDB+WJBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802323; c=relaxed/simple;
	bh=VybER0/fqEB9tPzYLKG2iDPLQp0h2XcPiWdpbCfTdBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IQbeoSn4FVhjyYkDtl/Y4guCni8hS7V3Z7cycg5PFmo9MY8s0J0h7s4N4Mb5ou7aFCOkyn5B8yrmYBubQkraVeppLnOlYpSaIWEqOlN0F2gYRbynwKsEZHj5W6n8SIiX9R+0aAf56UeuQQmv8HzsFjm1kK6+wEXfGWB02lsWP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0zEue3g; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso296325e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802320; x=1742407120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Awd1f7IbYeX5crgm51oNRh01M9SxrhzmMhHWchIyiT8=;
        b=s0zEue3g1XjN+sWCOprDzcIcvGKAaMOL4qWn2gNd1TYeH98rQ4u7wZYKRXUqFop5ll
         ACpk/IroTUd279roJZyV7SXf+y9xuvTfDwf8fGZORtqMnS8XG4SG06u4m0iiz6F0ifvW
         j7s/lliNRrQJjgsV1m7HXfmxpR3yO+yMFOJHjDagMj3XG5BsLtCWO1l1FDe7AzvWNK4p
         urqdxstfCLcv0G7xdUdwtpgdFgFVlFKfyLTpALeDsE379gRfuuoBEs7hs0JGWcLBHR7/
         dcB7pr0WiH+b+bGghbgaF+zmSLHlS8CQu83B4NR5yfJM3KJ4hRQ/lNUC+ILc6aAjJgKJ
         ZLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802320; x=1742407120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Awd1f7IbYeX5crgm51oNRh01M9SxrhzmMhHWchIyiT8=;
        b=VgH6w0Arv7fIX3p30P9FnNN3Uwi2By8iSUosiht7qHJNgnY9JTCjfc2H76fM7Q4TQS
         izJ04x2lW9a48FYqOAZ7QjvFc4bWTNZ9ZQMUfUgLpqaQ48AO3PeNewTDWLy2xZqmYvWc
         LAIr0A/3jJN5C2fVAdtwbLJkKR1CBer3d2efNOWBKwthpecQjArq+kJepx9eUVFF8ZtA
         ebK57fdNfwWB+z1yTPJGoZmXlTYrQtgKiN0ptBy5a5A6cp7/EtfOCVQURC7UCD2A20Hn
         LbeLdcx8u9zs8513wPdoE9QoIaBsiJG2Ur2YPP9kK6FLe2ijEqayudfVfR9aE32DdfuC
         /dyA==
X-Gm-Message-State: AOJu0YxQXR5YYiPxvB3x6I5iTmo/B+a09G3s5N8gHRxIr2AKovjf+fiQ
	bWpEbRiXFeu9U4dbZWxNQ6wYiMGtM7QtPKdi16NVqrOdITube3UHElR2oj3uWjUr4kd000nVqyt
	WUP4lSfyFzx4vVhTmV4dg+A3mA5nwomlG8wnW4wmV0doM9PrgMDPv5IwCDa82UzZliNe+EK7QJn
	uOkLvanPbrYVGCamZkS30MXIA=
X-Google-Smtp-Source: AGHT+IHj9tfnXDE4zwGrzMtBNQTrEX37Nr1SjsVHZdIiFflWByxQ+d97M9AkHPF0ggQs0Ylalb5/M39WuQ==
X-Received: from wmbbh12.prod.google.com ([2002:a05:600c:3d0c:b0:43c:e9df:2ecd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4751:b0:43c:fffc:7886
 with SMTP id 5b1f17b1804b1-43cfffc7ca2mr104991245e9.8.1741802319732; Wed, 12
 Mar 2025 10:58:39 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:20 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-8-tabba@google.com>
Subject: [PATCH v6 07/10] KVM: arm64: Refactor user_mem_abort() calculation of force_pte
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
2.49.0.rc0.332.g42c0ae87b1-goog


