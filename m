Return-Path: <kvm+bounces-53206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DD7B0F045
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCDE8177D65
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBA02DECBB;
	Wed, 23 Jul 2025 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="liU4V5a4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571F28134C
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267646; cv=none; b=UVyvZCiqQkrceOnV0DWUgmoYEwU7nAEb8MU53XYlp1P5RKOdIMyUQVJLIyukJiUX5NrTgCKzcFZnOdayDVl9M5ODuXdny/J5CREbwWHmHIPFPnjuXxHSaoDG/dFVGecXPFWjg3uu55BAH0zqW4Ty35K3Ut+ULlTxW3Ps3lDps6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267646; c=relaxed/simple;
	bh=KZ7kqW7WvlgvVKw/xfxfioYYfD44i99u6AqHghZDBzk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pfsAcAdT8eqJ0hdBAnjv9XLzcLGgdOriZ6NT1lOQQ8euo4A/KZoKCxYqpOGcKq0/xcfVXMSLnDx158fc3XdTihLjt7uXcBZYji+DsvLX9+BdWgOTMsDkqc5Tl2L7vELqwbin1/2jHWG/yi6Sgn8fG+gi331nQu5BiDMVdeaFDnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=liU4V5a4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-456106b7c4aso3893225e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267643; x=1753872443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=liU4V5a4yGA2nPTKPpmVj39EFuImkSZ81m853T9lyNUt/svvuDV4qS4r8K8nm37s4q
         focRRFcEeONG1du1a5R4r+x+jNg1BFg8nkzSX1bzrO15xYXm+EZy65GQmuHJBhgm11m+
         BUprE2W2419LYHAQPiUOEi/ARZl8oeBAnWsCpPBZDAVb6WaXpS2Ji2N1xD8nkSUuXy4x
         TCXHL+FaksSfkmJA4uKk7zeV5I02NBkoMaxh6Bp2Ky+a+pSjDr4fQ7Gwg3QnapFhTfGJ
         +v8CfcLo9tpZUkoYSxCfIzqtOvq9/8pirTmX12/n1277H2TBWeOR0Qz8w6YE0dXAEbkc
         AfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267643; x=1753872443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=eEQrvDhJTUdvly0A5pBVpqPwqfI4pXLtS6+WEpqZ//jD1gpdHDK4fyB9/hoX3OthOP
         Dp3ZcjrrPTCEDVfwb8BBGX0ZNt9uvCmG7TOduL1ruE2L/ugET0agaDEAbuT7o7WXpMNL
         XQJ527tksgbXFnGtyLxLzK1rLapx29lPHoCGyMFP4pRHnAuqt8XLsweJ36sZOrMpalHV
         h08SEE7xtDOOADEp4Rwkg8a4GmbWhqAnhojEKqTfxU0QJC3NmiKzC9QOiV4aXtHjJGQ0
         lYfCxIx4PO64k9wqcVzKdXkJRN+Br6rJ7mBXL3oZdpyPIQl+LmkBfZ+VmvCRVtSk0v+m
         VIUA==
X-Gm-Message-State: AOJu0YwXcqNTJbs9SJb5+LItJzD9r87jADDJi0asehkyoFoKSPb0mm7I
	9/c2h2PV8VwzK640/Gza0LgrtixvqmzEyO6MPcU/q6Pkoxq18vxa2YNs8ptcpAQnAgwSoFbLI1A
	XhFhVgm/UNyvsnlu+PfcWaVGtiM4ug7vYsp/LK+KUmmd9uK0wosWqjtOKBvbu62TndWHMQdbNiq
	LMa1BG4XudPw3/Uc/RjQbhVjNSExM=
X-Google-Smtp-Source: AGHT+IEHW8UPxyP3e+Y7vaygayrdzupiZRH2UQB8NKUanjQQg40Gzi7ntNOEJQk5x0u5UdSIscP/yEby6w==
X-Received: from wrae21.prod.google.com ([2002:adf:a455:0:b0:3a5:7aac:4306])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:188b:b0:3a4:f7dd:6fad
 with SMTP id ffacd0b85a97d-3b7694dfebcmr2129935f8f.14.1753267642329; Wed, 23
 Jul 2025 03:47:22 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:59 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-8-tabba@google.com>
Subject: [PATCH v16 07/22] KVM: Fix comments that refer to slots_lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c5e0a898652..5c25b03d3d50 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25a94eed75fd..aa86dfd757db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.1.470.g6ba607880d-goog


