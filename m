Return-Path: <kvm+bounces-33752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C47559F12DE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A73D016013C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013AC1F4293;
	Fri, 13 Dec 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oxQX6XTL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945CA1F3D33
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108522; cv=none; b=llMEFzoUWOSZPR4CkL5CNuCL0HmbZaXp+zFsUalxGHPc9ADsvBh7psy2EC6NakZ3CKljGmoID4iE2uoQV1hJCII3tE396cUUdVKiwVuvrhOyZwJL2fKRi/+iCGBLqj04ge7uXCwHEbNN7ZbdxiKzhu5ozwycTQOkoB1mgonreSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108522; c=relaxed/simple;
	bh=esAEXl56ZCqm0IdQI+nLRQfWrCMPvhXiPaUVVWHNr00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XX2hPbUK15gL+ZUwgO40rsHyzhjAM1OGYIg2DofEW/mg0HQBQ5hATXHQcgcIzDeKlh3odlPnGNpgWKOhEbuajh0rZALDfOOvZffP+Mx7Z9+Vh1tKLKaZqmFd+yRLmqood/22DB9keuX4UGuxF8e/aAgyLLgRAWAeHJVrv158Iq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oxQX6XTL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-436328fcfeeso5166435e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108519; x=1734713319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2VJIq0JFQ/ZqzbxK3We3Qf3gNhX7/2qVuXpD8D4O2A=;
        b=oxQX6XTLWaumP6mCSMj3e5weBWC0t1DivJub/2HUvt95swYiTYkYDV9dQmeS6oXWYt
         aUEXJgHc/20a7dxHjVi3j0A0eFVCE2pVojVEf2FBFln/PJBFWnm5rDmZkBoYN6SVWaVl
         9+usi40x2TxWVKRVOaodi6bl0FgRLIIEB3eeuKE1f45Ii2y23sfWCziMwIHe5jqYWc2A
         2FP3wQYfx8Pit89AFRvP+whZyfgSSQ6qGy6iXpZXHDKJLa3HcfXie41SfQcZhf0o9LYt
         SvNUKzaYLJaPCgEei5rNvjAUYKDUSZBFIO78v1psc/dZvniiqg4Be996Wh3fKESjgiId
         NRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108519; x=1734713319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2VJIq0JFQ/ZqzbxK3We3Qf3gNhX7/2qVuXpD8D4O2A=;
        b=d6r9/5nJhVGE8wB+UUQw3TvPu1s0BfRLDVzqwZuDqGl486gertI65NYwRJT1gpUdxN
         rsSv8JaS5ANEFmeqaq19eF/GlFpBApMCZBstAZ1TLqXWK+Pgy7A7nx5OqG/i6EUnNl4B
         T357sEkCGDeJTSdX/ACNql9MibXiQZBvhIST0OGxiWITICir/njO0Xp2lKhITzymfP5q
         T8HJhjmDUm95UeUJHngNP8wNQ4uCDsmMCRs+fWLzWKyDhfvIkT3epoXZShrqCtohxVJj
         QqjYoWhfzyj1bs4JVTRtB6EwwwfMeGm1AKpnVxoM1Xj0q8FUWXht3MT4Yj0/yle4bo9s
         3j7Q==
X-Gm-Message-State: AOJu0YyFlP7PVNVhR7exIKf4aEzx+zZP7mpmulhXq7/un3GrlZjXPGvS
	Dwku7fw/2y1I/ESPnlBoggyjqsrMkx3xP455tFgpK0wuDNa1k/nXbcP3gDXqos0HguHlr4UtIzQ
	pJ5AywWjWOgXHp90Ix/Z1+Lf85S/RYQp50WYGhGRxI/kz5Le0LkA5Hu9SviIiHw0xliutnzK5lu
	16n3VRitMA1PDUjkocEUhnTBY=
X-Google-Smtp-Source: AGHT+IEHYbi0erAT5PMhFOWMD98RX6BEQ5VdWuD/tN2fh0Tz16i8Z/iaZQVtS7R87H/i8b+meXfFpU9LHw==
X-Received: from wmsn8.prod.google.com ([2002:a05:600c:3b88:b0:434:f018:dd30])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34c2:b0:434:fddf:5c0a
 with SMTP id 5b1f17b1804b1-4362aa156a5mr33549795e9.3.1734108519019; Fri, 13
 Dec 2024 08:48:39 -0800 (PST)
Date: Fri, 13 Dec 2024 16:48:08 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-13-tabba@google.com>
Subject: [RFC PATCH v4 12/14] KVM: arm64: Skip VMA checks for slots without
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
2.47.1.613.gc27f4b7a9f-goog


