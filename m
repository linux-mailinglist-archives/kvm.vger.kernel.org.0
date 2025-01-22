Return-Path: <kvm+bounces-36260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D38AA1952D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7FA9188D357
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C480214A72;
	Wed, 22 Jan 2025 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iUVfoERM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33621481F
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559672; cv=none; b=lUvnb6TzDI1wDifUo15pSWZ1LyoXjAxWa4xl1JO9qP36KRkksNGngxW8OF3hJahVMZqrKsKUGKR9210mW59v3DMxxXHcnT3sDayCvkr94ty4ObidZplI/XzwKKS9NcTJWV+6PMIT9bzUeaiiZJbWPxadkp5Y/wK96Lo7C2GUBDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559672; c=relaxed/simple;
	bh=AZIZbGt3cG7dsQD7VkDSL1oTcXw0BOhbINqYhNgXLqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FWQr5GgByqjAfYqkW5uT//0hTQ8KJ7XBx5v7jIdsxl+g9dnlMaxlfTkKtu/D79eMnoyLEfcAU3Xmsl27sQm04C32XEFc26wiL9TmA2ZcNoMUwG4zL330QTHQnIICWt5dGsZcBfF08RYN7QjDWMDaUAYGPLaz3srYh0tiFtNbRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iUVfoERM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43626224274so39004705e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559669; x=1738164469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=shrLyHvMMRQKlPtYXYDSAaDe6YKxFfwFxlxNmwxqD3g=;
        b=iUVfoERMeIlQBBxcy8V1/QzTu0kIljJbMKFKoXRr8w9qECzKM8vHKneweSzVrlsiWL
         +BYphtSp2Zu2ioCsLWVXWRsp5XTJDRJxf6kRdJMmgAQ4FPLPOHfnBdZcwjzeV58yt0+b
         1GFSxDgT8jyJb3dUT1wCpLQA3fRhXJm5fmycJGD19/0WKywwDDCEwcuMGaxomSMTVy/o
         huj5zd5Id/fN5pzyZjpVZjh47gE3ym1etp54mhTTfTQxeZDAcXyqOG2wjszX7l/HuR/G
         Hx/QhAwYysfjKLmJnFwkpG7kfmR3DzyTEFreUim9Y501UAraSqlpeen1QVXDBN8XX3gg
         9tZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559669; x=1738164469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shrLyHvMMRQKlPtYXYDSAaDe6YKxFfwFxlxNmwxqD3g=;
        b=lOdgeCN6LvKmWuT6yE3k4pk+CP41WI5VtncJ+mIeaakYC70x/yqWxjP/U+6x8x+eEv
         DlUtqByGF8y1o3fdlI39MtKJqj6RvYpIgi32LKaKCPr2NV/R8qnSPsacE8Pa7xmBO4CA
         piwOQXZr+vesuHrpiv3RxOVcr6MSTEp5xyS02X9DSw+voGOxD4tmk+5MFAqVgkwAdTlk
         4VwWR+/upXYg+IS8eVaXxsm4NrU4OPlyla9StMMGcKnoUqhm0YdtZfluJ7Y1yMQiRjLn
         KHYcxCFsMploKW+i/DoxGAoj3YwvVsMNCSlIsxfhTTNVKyxb5c6rMUqTF/gh+Lx295B0
         ZfJw==
X-Gm-Message-State: AOJu0YwQ6or98LA4ZypgWmDyOBaEt5oJTTGPjt8/4li4uMIdtdTyEUMk
	fHA9Xxpob/ZCQdBezTYKw3vZkfrvbXbUhPPu5EgrbT4KnBoq6n67+7w1TsErGHS4Qc6/IYUt1IR
	hm2xR15MiUdkwBo/H+zLyNTchLAYlbRwL640X+y3aonvmQ7wtYwXSU/GJ4gz6qxNIGmAxZrwB1p
	rfEz19l8l1jGVxgI4gi71aPDA=
X-Google-Smtp-Source: AGHT+IHTlIkTn1+cn775KydFPeyXeNoykYbZ6JOdiKLvBv9T8k9MPGDx/xX8UX12ynhVUVVwAikKzSjQIA==
X-Received: from wmee10.prod.google.com ([2002:a05:600c:218a:b0:434:f1d0:7dc9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3585:b0:434:f297:8e85
 with SMTP id 5b1f17b1804b1-438913d5da1mr237493785e9.10.1737559669276; Wed, 22
 Jan 2025 07:27:49 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:33 +0000
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-5-tabba@google.com>
Subject: [RFC PATCH v1 4/9] KVM: arm64: Skip VMA checks for slots without
 userspace address
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

Memory slots backed by guest memory might be created with no
intention of being mapped by the host. These are recognized by
not having a userspace address in the memory slot.

VMA checks are neither possible nor necessary for this kind of
slot, so skip them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..342a9bd3848f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -988,6 +988,10 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	phys_addr_t size = PAGE_SIZE * memslot->npages;
 	hva_t reg_end = hva + size;
 
+	/* Host will not map this private memory without a userspace address. */
+	if (kvm_slot_can_be_private(memslot) && !hva)
+		return;
+
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we should
@@ -2133,6 +2137,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
+	/* Host will not map this private memory without a userspace address. */
+	if ((kvm_slot_can_be_private(new)) && !hva)
+		return 0;
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-- 
2.48.0.rc2.279.g1de40edade-goog


