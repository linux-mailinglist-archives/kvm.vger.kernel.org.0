Return-Path: <kvm+bounces-9414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EA485FDC5
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F1CCB26761
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E73155A30;
	Thu, 22 Feb 2024 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2K5gDuy0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7529415531F
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618297; cv=none; b=JCy9XlUDU2mV5v8TbiDh5zNk1DpKQ3IZvRwqI5QQu6M3yVxTK5g9x1H8JhAyR3EiKS1WnQ0folRrvj0tB5qhDVOVmumkKPlgORchcsOfpgtnCpgO0fiaswqdjV/z7KLTm+QsROW5A63e4bN46h2zvPPY56QLWerohUWU+ebzTaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618297; c=relaxed/simple;
	bh=JOV+TEixxBnW38RYNc8zuei4nTFOo/1GSbfRHcogFxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WtSn0FuH7Uyyr0Q7FwTQnnWT27GNOUhD5QuvwWUpxJpm7tkDMyJigCtIT+07PfwIijkll4QzvY5TiZhcmxO1GEqcPqSufoKcRGus2gnx8bektcR1BTb4y9tK85IHJE3nRtJxEhuAfba3qDl1hjsGZ8FE6M/94fNyDu3LpxxXCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2K5gDuy0; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33d36736772so2117030f8f.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618294; x=1709223094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vD9o5ECbAgPC1ivE6LlVq7cfQ2iwgRwXzAnUeOE4gIQ=;
        b=2K5gDuy09vbFhveL2s4zV70DIqWiUC77SoTFtwKmtkxi8mqagpdA5Hmar4w9GG0+VR
         ftc7QDO4Cu7v44zBUBcXFL9GwNhRf3hypTvyw772oUOuEsbqjZvC5wV4aWGz9Jrz225p
         2Cg+fsoQpNDtdIRTgG57Y6C+GX7GQ1I7wx9ri9i9VGNeJUBd7jSiRnxWG2/AHMF4ugvB
         tDsUmagZsnLcYlfnELeVKHuoKYGfH/VW3YkNxVPnzQ1n3w7havqRyTasjZYGKx4vQz6S
         TQQMncni+eih6LPL6U5PiUlQRIJzaeo4CSz0mowQigrZ/d/W8HF2XNZLSEG2gl74RN9v
         G+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618294; x=1709223094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vD9o5ECbAgPC1ivE6LlVq7cfQ2iwgRwXzAnUeOE4gIQ=;
        b=C1lvAwqaB2C7E1f542c0Kx3g3DH0u4KQlsWLn17PTlRhzN8Z+NiZioEMuqNmC2oRaB
         O0JjpVrSBOvYNcz+BbzO8JNjSkqhz1p/v10VwrFuEVPGyGSIdeQU3SiJfOV/YD3kZmhO
         z7BdJO3l+RlYhDx+qrL51xFnEkWM0rjPsA7tQYb/ftU2AGgs264oAclf8LOKJ4Eq0X+0
         S1ymUzR4uSHrGCG/EgMyShQ0XkOP0JmTkAFlvQVZOauAOD80P515bjtlAIfntqlr2u42
         doCrJ8LjgAJAA6VUyLuPqpEouT7Ty21efIAvPkaVVrBSozjoAPUvko/GyXzjZgCTlMV3
         zMhw==
X-Gm-Message-State: AOJu0YwU+lRJys67zlMbOr6Y4SxUaJdcxZ8hrS3r43MzS5m3FhF2KzoS
	A/uxcROK9nUE2zYz3ZDcSfkqcVgQlAKAuq3ArezawFRtmcsGjpfoHD2y8BuTtNBoIPsJvUYYJFj
	SYy5al2lJ63SiMeAHoOJW6geJa7KwcXpetIGNEd1T/ICkgi5KrWLCp23a+mpVJcqwzE+QRXvpcS
	/R9YowjI2W1t5tL33yoats0Rw=
X-Google-Smtp-Source: AGHT+IFjuzbek5MC2iMiGgTGZbnIVe892XN4fprFxq4qMMBT6/xXDjSro1ZNWROfqjD/CCRCrpUqesTMRw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:a0f:b0:33d:3ad2:67b1 with SMTP id
 co15-20020a0560000a0f00b0033d3ad267b1mr32305wrb.4.1708618293417; Thu, 22 Feb
 2024 08:11:33 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:39 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-19-tabba@google.com>
Subject: [RFC PATCH v1 18/26] KVM: arm64: Skip VMA checks for slots without
 userspace address
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
	tabba@google.com
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
index 4d2881648b58..6ad79390b15c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -973,6 +973,10 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	phys_addr_t size = PAGE_SIZE * memslot->npages;
 	hva_t reg_end = hva + size;
 
+	/* Host will not map this private memory without a userspace address. */
+	if (kvm_slot_can_be_private(memslot) && !hva)
+		return;
+
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we should
@@ -2176,6 +2180,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
2.44.0.rc1.240.g4c46232300-goog


