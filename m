Return-Path: <kvm+bounces-52479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D810B0568A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 442483A4C4C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87892DA759;
	Tue, 15 Jul 2025 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RPW3m2fB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237942D9ED1
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572058; cv=none; b=rypNetArqoExLJWwGnafHSxnM+O7ZwvShqWh806B2flNFbT+EHupc5hMMs1RgKst0MSmifIB+BAx4FuShs8zJ+9wM0ChLcuaYNJYaKmXNuL+TSX/1AGtj+xY+EcXkOZAt8uZpqp2RI2Dg4rWGxTpXtUlVoi6cQhIF9tW3F/vgdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572058; c=relaxed/simple;
	bh=5SFcmIaZT18BqEoeZQIYRV1Aqypru/hVXQDtZkdpxP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MLmyze9bdx8FTf43DkDnLRGOBftlqp2QaedQcMKBibu0VImdbXN0rsemTUmEQ8BY/8H23TACrlCSGJ64zivFtDVREZPXWv+Sn57tafKwZCBUfAyk6JDPyUCKr2vvBs5CeBo+zK1yZyoVz7U0k8y3Q+0//79Gm7yJMd8dhqQLo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RPW3m2fB; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-60995aa5417so4372870a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572055; x=1753176855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NswHrgkdcqxmOhQmg+I1ZftODzAqq/smUBNc/8jSsg0=;
        b=RPW3m2fBzSZtxB0J60H9AxPxtWjVFVEO74IHZ/kl2va8+WbU1+rMS4iTx5xaEKtfKI
         KHps8ja+lTRYvft86HkStdA4LDB51dhgxBOL6KUxBYE0rW+7TfvfVc8jH5o78kT5j4bE
         LU0Kh7Dukmeov7HBtpolJQ5i8ryOVZWmNnxYo/PysXrrGpuB1QrjlC332KdVcV77Fapz
         R3elF7FvLWbJURtCzHwFpsn5/S17LgD56tejLiaMRo+dNgNUCwoYgzgQQ8i10SP+wBdN
         wcmBjYogvmVeZJRTZh4luGyDO/Vtw//WzIOLMPBQYISlzXDfsz5uJ9dLfR5m0psnrk0K
         tpqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572055; x=1753176855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NswHrgkdcqxmOhQmg+I1ZftODzAqq/smUBNc/8jSsg0=;
        b=u+sNYoO4BOiGPIg1skwVt2iTIUaSzX8X4awAoCVEtBtX+qrgV1JpIPY1U0ADUr52n4
         X8FADCPbX+LiSTc5nGdLHjSFyrI5ocLSAlqwKlIh8OuXhIrTH9AwKXH+FeGola1rmAOt
         eDddyojmKlLwDm1C3jBS+LIIqKDoLpuPcnOt4xmfOH7I4W6MMcJE0L4oXT8N5HucK/zw
         PcZbI+i/f+e5pd7ZiQKXlzPqUM88LdX9uo8QbW9q550pEpXxXn1QbLc9iJ9cB76AUbVz
         wDSrRo2K6N6VVWMYJ4zvOhms9FbwYTWcFh81a32EpQn+7KUD74YN6ZgRSIU52v8hKqYN
         EszA==
X-Gm-Message-State: AOJu0YyOFriYNU0OBF+bQBSFbKNGyuNF+HhjGQP/j6KRAae3obh7ys2h
	b+CkGGEc+5CdgnUHkAHveua9RTP078OnxLsES+OhY74hywzkuRF/lT7b3uov6Y++MpFcM+Md6AZ
	fH0C4yXkIwHxA2/EwK1nV1FtjhVCcrT2g6Lzk0/8hPrEDsjAT4daRiUm+6nfHY4Q7WCkUIgmGPI
	D3+6KDyCfEmNtArEu7smH8C/xoKI4=
X-Google-Smtp-Source: AGHT+IEDLe189qOiRgDedu5bKfhg6mmUJkhqiiy6MmhlJTVyAYMWtzw6N/Xpnr+zd4xHJ/TAYV4yM5jmtg==
X-Received: from edbev26.prod.google.com ([2002:a05:6402:541a:b0:609:287d:ce97])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:22ba:b0:607:7de4:598b
 with SMTP id 4fb4d7f45d1cf-611e7636978mr9326687a12.9.1752572055050; Tue, 15
 Jul 2025 02:34:15 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:40 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-12-tabba@google.com>
Subject: [PATCH v14 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
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

Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
pointer and rename it to kvm_gmem_max_mapping_level().

The max_mapping_level x86 operation (previously private_max_mapping_level)
is designed to potentially be called without an active page fault, for
instance, when kvm_mmu_max_mapping_level() is determining the maximum
mapping level for a gfn proactively.

Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
safely handle a NULL fault argument. This aligns its interface with the
kvm_x86_ops.max_mapping_level operation it wraps, which can also be
called with NULL.

Rename function to kvm_gmem_max_mapping_level(): This reinforces that
the function's scope is for guest_memfd-backed memory, which can be
either private or non-private, removing any remaining "private"
connotation from its name.

Optimize max_level checks: Introduce a check in the caller to skip
querying for max_mapping_level if the current max_level is already
PG_LEVEL_4K, as no further reduction is possible.

Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bb925994cbc5..6bd28fda0fd3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm,
-					struct kvm_page_fault *fault,
-					int gmem_order)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
+				     struct kvm_page_fault *fault)
 {
-	u8 max_level = fault->max_level;
 	u8 req_max_level;
+	u8 max_level;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	max_level = kvm_max_level_for_order(order);
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
@@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
+	if (fault->max_level >= PG_LEVEL_4K)
+		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
+							      max_order, fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog


