Return-Path: <kvm+bounces-35819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A7AA15458
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 526887A3763
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698261A23AD;
	Fri, 17 Jan 2025 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdBtD6tJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099271A23B5
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131432; cv=none; b=GssaQsU9UtH7zZjLGi1Ie8T4X2STHckvDoikCp4fIsU6RbZNr1EGzyBpfvSClC5gWd15V3YGGtL8Qc/m9P2x5bQX5atuEvo0d1TOvzyK7wtZWO/S052d0XRnWULSQP3n2cKv9CtmcOqRzOlaAj6cND07ORqPgQuWW7zIbNAjuXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131432; c=relaxed/simple;
	bh=AZIZbGt3cG7dsQD7VkDSL1oTcXw0BOhbINqYhNgXLqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uuHh/sErmo2VZvHdL9zxXZ/ZmLMrhdJEqovuxEtkcZHugwkzRaXC7CZy0fDHK/Ig2GRWJTtfFczpH9ddW/Lat7AjxtvLOMdaRq6Q+Ku3s798sEX80ouHgIzExZRiCsomxmsDO/n66usukSxfPIfyMvJCII3KXi3E/m0e2TW5ns4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdBtD6tJ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43621907030so18987435e9.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131429; x=1737736229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=shrLyHvMMRQKlPtYXYDSAaDe6YKxFfwFxlxNmwxqD3g=;
        b=fdBtD6tJvbqU+dJRhDaomElrki+iE75rSY4iSqEQOvCkz2PQ8L57v7IB5z2ITajm/U
         WNQ3ZpcJAngnAIUOrVaqQCyONYnBwn6LEGq8Zwur+pXSSdfoxqxkpz+xXP6NopAKf70y
         dh+NeDwQEHmtiRtRM769g8HqaN1J6ppT/W5BCAJarCTjZb5H1CzCFvc9HssIQXufTC5I
         i9UlKYKbDjetC4ItLpsOW9cRg+VKI8btj6zJLQxRCssm/iPHF5pLXOiqaFEefxwTBC2d
         OIcGR/lTBFM3JVGo0zV+D4omP1c94cbU01I6XpmTytshWVYHlm2xzsPSY5V3gEe06HRg
         UarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131429; x=1737736229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shrLyHvMMRQKlPtYXYDSAaDe6YKxFfwFxlxNmwxqD3g=;
        b=Z5O8pA1r4ciKPlCVmxB1xwBois2sVsjfGtyS4quk7jed/VuBRH4jSZsPae729AVJzH
         TOHgDsBn7egKt/NPLlURNTFdKWUMRBFOU3n6SN4evyvf8ouN51lABfbLS4MFAwSzjb13
         jiVe+Rh75rGh1dTgeUTTJrPP8JRFS0K8LTjp2dJgmULypE6Vumn5wj0MaAh3br105qt3
         oakwiTvOoWKbM3DoW9ySrRCLSErb7PKZlzfwtJLoT9Ul1i/MGGTIXBhir+zrmbfeRw8V
         n+HAzt/UiuOvL/hGhENrnzhOipWEmschPkf9nkORFGpVGFXgaAr/MlDzpdqLrunc7ph1
         h83g==
X-Gm-Message-State: AOJu0YzUHQafgKxwtm7og3Fju+SQ/lik5pbfXsspjmSIC9GORg1t/mFY
	eAFIiO2zBSHdImxGw45iu/1Jti9KptSJVSXnrVCN/bi2yCgccm4vDlA84XpzfKXJkW0PlixyGR0
	RGKmhILGsg7zfzF+QBcSjAi498W+MQ9rtfEccJ0YLaiIF+M67BDlBhT1mwRD8V11nrmqRiMogdN
	gx3Gyq9+i8qF9YY4rQ9QgfJxA=
X-Google-Smtp-Source: AGHT+IE3/c1HcXzGSPchtf4vKV9TLTAsRjAq6kyeRfhWxPrR5PiskpFVLxhd84Kq6MdjNi2BKyWHIITf2g==
X-Received: from wmsp9.prod.google.com ([2002:a05:600c:1d89:b0:434:9da4:2fa5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c3:b0:434:f131:1e71
 with SMTP id 5b1f17b1804b1-438913cf2e0mr36260775e9.8.1737131429376; Fri, 17
 Jan 2025 08:30:29 -0800 (PST)
Date: Fri, 17 Jan 2025 16:29:58 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-13-tabba@google.com>
Subject: [RFC PATCH v5 12/15] KVM: arm64: Skip VMA checks for slots without
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


