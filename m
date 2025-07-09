Return-Path: <kvm+bounces-51920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0641BAFE6CB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D69964E5EC0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582BE28DF14;
	Wed,  9 Jul 2025 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UzomPL/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF59291C0D
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 11:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058819; cv=none; b=GHLdiYZtzOIc2iSUmZyCNhBB0MVCwwUz01zlbIufybTHl8NhEO07N8vmDOfkdvf4BW1jZ2KABPHpEg6U/DDihTsiLvcPeQwDQl+Ibv8OUfv2BxLcngP4so2WPYxliTQ9PcZLiAWEfdqT2f+vJbKFAF2yjqiJRdNt6S+LnVoT3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058819; c=relaxed/simple;
	bh=Ng2OnRI9T1yqGSHhwkdj3eHMpNrupGn33LATU65cqFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0zvdylDgilcql3x9pPETSm1CuI504MWb4HX+dn7w/ned8Yx0tlLuRKQkJxg3f8lGx+5gs9Np7c1QFsDac6PToFyOHRHbRgwWbIbeXom9XsvZBdlcjTaDTri3/2bSsRH8msShhWopv9vvADUCywnD0ex0Im0AgM6BFlR1MuofBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UzomPL/X; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450df53d461so42527165e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 04:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058816; x=1752663616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtWvM4D5LyGRaCThwRmNrNlLHpmXl4WBXByPYLdFVE=;
        b=UzomPL/XBxCpGzn4IEgtQT0cOMKbUEjg36shnLwcNf8aFRKv1rDBCZJsuGHvojNKjl
         HB6u6Nx/1FWovtWfLNsvGLvhiF/T6LpJv1vWTVXxfhzdQXv1fYfHk71sWiiT/IWrKFNu
         cTUOxxrc4tzOCObBg1gQ5Lglb3geFhiEmJvllOBl6EXoYlIBQle61QUuWDsg59yCjCfn
         fTSPsQuVsTamnoBwkvdr395LAjvj93X9D9kzBcvpvJ3cD5F+bI3mZWVaNx2cn4eeHcxK
         D2lbPvnmUq8N87DEbBKgn3ZLCN5okCbQtPAX0kY/Xn1L7P3lgt/0bnPrHlsVaYaeQh/h
         Pd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058816; x=1752663616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtWvM4D5LyGRaCThwRmNrNlLHpmXl4WBXByPYLdFVE=;
        b=cXyNmWlaKRI3AtoE7uwEt5aDDBqVQZyW4bnoA56lLDc9yuKrjNZRrUb8/VpOADXoOJ
         ZNnYCXC3azvPEFpIFEuIQaOzzX11vu4Qk1wNMhdn4Pf4qA5VjLEf3wu7Cm5hflps2avU
         0QLgBM3B3JDFg9ZePnH+F0DlReD8Nx+aj4hHJoSw4z57XLb+Cj4ZrtzxZomtOOMJndlJ
         q2AX5yM1kPnvWPH3fo5/Gld4188EoAb+LvAfzUqmztVe4AaWzUgWTAMPJTlYWIzNaUKn
         Ykd6G1XpR9AgGjTYo4O8DHmtRRF2z7OFFMoJUWoSwnD0KcCEHzHliaywpx6ulj7derSY
         lOfg==
X-Gm-Message-State: AOJu0Ywk14l2LOi/zkkpJhQ4W5lKruT99JOrNPfwBVcOQWyriPCJIvHi
	zHlFqSkaeg8uZ4tJo1OJsnj5InyyF0SvwF3Z3pvjC16B+6sBddY9yAJ0tjk2rP2fT0lH9IRQxbg
	v9R7zgabI3/+s9q9uBLjaTCwwqrT6qooRe1gHR45ZDTHyPXSOIqVuG2cS6a0quC6NR0iChtLDSz
	GF5yyFZ71fMVyejTrDFCtvNP4F11U=
X-Google-Smtp-Source: AGHT+IGbecgOoimuhgq7GBsyMfiouaKkyce/B8FWdopk44Xy71H+G8NRPUx2Bg44d+1+Ni1BCYWnqV0plA==
X-Received: from wmbbi11.prod.google.com ([2002:a05:600c:3d8b:b0:44a:ebc5:9921])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:37cf:b0:450:d01f:de6f
 with SMTP id 5b1f17b1804b1-454d53087f8mr22468195e9.15.1752058816177; Wed, 09
 Jul 2025 04:00:16 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:39 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-14-tabba@google.com>
Subject: [PATCH v13 13/20] KVM: x86/mmu: Handle guest page faults for
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
index 6d997063f76f..cc4cdfea343b 100644
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
 
@@ -4537,13 +4537,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
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


