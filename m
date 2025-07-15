Return-Path: <kvm+bounces-52482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59664B05695
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1ECC189B5B1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8913E2DCBF3;
	Tue, 15 Jul 2025 09:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g/OKzO5z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875582DAFCD
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572066; cv=none; b=eqQAf7ZY9svzOzzLo0wvxxwcWOYa5RBFeUPTtaTWPvRTsBhSNXiUoto4TliSyDdKa3h8H/SXBD5g3hY9QP3XFM33m7Kv5q7dbuZjufpJiwSkoSTVq9leP4pkdvMnztuJTSj3tW2ZpRUElAsSe1lCpcMPETq9oFXGTyhAv5u5mTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572066; c=relaxed/simple;
	bh=WCxjveG85jEEirX3+ZEjjVpqxosxj2gmLmYBllHeBRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FMQn/oYIjxyDRyxR2kOhbF3oyqr54PQJVwNjIVgm1NX8Oar/sYz4SW+ZgyXpwcklv25LKpa/YaGlsRtf2Ssf1XELYC/vJnYcT2/pcxQcx0rzGNGhct2iRTOkGDFVR6Zx0MjiY05avHQ2ja3G+YZk87ofCAVmco++ojyoGVIRVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g/OKzO5z; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a52bfda108so2586658f8f.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572060; x=1753176860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=g/OKzO5zETT5qHvMWKUq8QUV7dPLwgN4Tbdc9Plnrp8bma+5x8rWCZLHracTQmbnat
         Z9Szh2ADHenOl0iJ+FpPUX7jWUv7fIaIQ+noQlH3Otp/o9dWHlc6wS360ApaiCG7/PkS
         Ks8icUfCRtQ4OM6KyeAyh3sfdpgNJ2SQ9hAkkKXWL5w3FwBi8Iaal/bF4n87DajSSLzQ
         GYKr2kMEKMBBnC8M3/Cr+c3zpHfpioN+ri8sm8T4x0e+XmGAq2j+Bx00M4IS52EqiT3L
         Iziu+5sUJs7+VcG156NeaPSaAJffWKvmuAXEJm5iHW15aUAegBKfIZlZ63ssEJY5xIrE
         suJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572060; x=1753176860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=biCHgDfH1b5vvCppb9zUw957zT+gRaLwyNY6wIVFPQ3HTgBWI4XjWYAt0n5ELrOvD5
         Sj0MMDRDWQVEp6E1DVELyGxaEzaMK+k3D4NEBE/f9yqlzJ4XREEWwZKv5/DLExQhAcuI
         1vcEvSXm5Z58uwsF1uApX+bEr3Gr7EabNSTeYTManR0BwzaMmQq6rC9piAwwpTBrbKCr
         GgiBbOVdzpsH82k/zVUoSs/p/VhvV5MXmHFJJxlaqgrFSTLS7+1vMXT+qf7a4AZnY491
         uek7WQCsuXyUG7V/K7lnhUISpH80inHUfuKhEaEqBZhXA/lwSVrbs0qaXdIkoxsXiqAw
         bvSA==
X-Gm-Message-State: AOJu0YzLYUQfJUIRmnJqNf1IR3HDwYOiVmbMeBwuqi6oj1JM+CmX4W+I
	NCBzx26Wr40qI7yuhM1ukmL5knQxMeGmJUw7s6cu1vi8eI4dLHT2bFBGJKtDKh/He3J+gDI9DwI
	TJ/dbl6mF8/pYnCRY61crIZAeK/3CkFjfW2gdIxLcFBpwa/ZfNiC98yRqaGr2xvqnGMMC30m+qM
	WvV2z79uEFh29FwPRv2VPiMvWWpaE=
X-Google-Smtp-Source: AGHT+IFT79H0JMSPNQLJqFCm8BSQjlOEJfCNJpa0mFxk/CyYzTNiLJDi9MX2K2oWjDCLOvzRxItf7JYjLQ==
X-Received: from wmtk7.prod.google.com ([2002:a05:600c:c4a7:b0:455:9043:a274])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:400f:b0:3a5:2653:7322
 with SMTP id ffacd0b85a97d-3b5f351d846mr12559005f8f.3.1752572059375; Tue, 15
 Jul 2025 02:34:19 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:42 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-14-tabba@google.com>
Subject: [PATCH v14 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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

From: Ackerley Tng <ackerleytng@google.com>

Update the KVM MMU fault handler to service guest page faults
for memory slots backed by guest_memfd with mmap support. For such
slots, the MMU must always fault in pages directly from guest_memfd,
bypassing the host's userspace_addr.

This ensures that guest_memfd-backed memory is always handled through
the guest_memfd specific faulting path, regardless of whether it's for
private or non-private (shared) use cases.

Additionally, rename kvm_mmu_faultin_pfn_private() to
kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
pages from guest_memfd for both private and non-private memory,
accommodating the new use cases.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94be15cde6da..ad5f337b496c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
 
@@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
+static bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
+}
+
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault_from_gmem(fault))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
-- 
2.50.0.727.gbf7dc18ff4-goog


