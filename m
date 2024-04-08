Return-Path: <kvm+bounces-13879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 563A989BE47
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114E02829F2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 11:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1086A02E;
	Mon,  8 Apr 2024 11:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="h0ErTczH"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4976769DF5;
	Mon,  8 Apr 2024 11:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712576726; cv=none; b=rI9sD6GSZZjmPHMB7/V+piQP9ggjZw89UBx5AI2g0M5DbVrVhvrCdcSD3HezLiwj/K6MSjj9R2zh7/ubBPVOYn5vk3eoExaho/721opaVlfNmVIzaPHnPmhocDOom8NwhzoSjsVzuS++88Y7u3Fjq22hKWbZP5NhNK4DrAuqvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712576726; c=relaxed/simple;
	bh=Lvr4Q9WQMTuj4LqkHya0HKL9JodxZNBHVeLenTpYopw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EDXwRu52Sy9oXr+MuO/StmrzEo+2LLChmj2Uql18uwMhNSV33XlQ9cAv9nmcOoQjH8xfj2W9i0v9G7Hf+u7pzCYevQzbvTBDPz3aZV3LeBUuXR/aNTddr9wR5jtRUcKxHD7jSV5h2SJYSM0u5/SdsicfQB9UkXvEwYwzx0KOQJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=h0ErTczH; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1712576721;
	bh=taqzyuzUm+h1dAr9up1EmBlmxQ7Pw3TT7Dqle3r+vfk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=h0ErTczH+J8eOKMVXpItrHYKRUMh+pxxcV6/0CoHG40VtMk6SjHBicTMij8g0QPcl
	 DqWHMNnSfi+fwP5HiCdifsYmHpkp4Xn+DbOgdxU7qWixZBXfw3jqmo2Mf9TSyh+dfR
	 6VbzGd3EpRZksCPRiEZyrpuPnkVP77GEek1dnGxxPTCQfwlANrE42GRZMWo8lTHAps
	 +9qTuFxiU3mHHBuAnio0EBxVUDdvEu22B/D31hrzTZyHyg754PmZ251qNdGHU6OTRk
	 8cDtgXORRLDOqu5a0FunAuYei0U3LrNTqxk35BBWQCXaFVALq9JB3md16kAgiWqViN
	 5wPghIA4bJBwA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VCnMf3rffz4wcF;
	Mon,  8 Apr 2024 21:45:18 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin
 <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra
 <atishp@atishpatra.org>, Sean Christopherson <seanjc@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
In-Reply-To: <20240405115815.3226315-2-pbonzini@redhat.com>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
Date: Mon, 08 Apr 2024 21:45:18 +1000
Message-ID: <87h6gcaxip.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:
> The .change_pte() MMU notifier callback was intended as an
> optimization. The original point of it was that KSM could tell KVM to flip
> its secondary PTE to a new location without having to first zap it. At
> the time there was also an .invalidate_page() callback; both of them were
> *not* bracketed by calls to mmu_notifier_invalidate_range_{start,end}(),
> and .invalidate_page() also doubled as a fallback implementation of
> .change_pte().
>
> Later on, however, both callbacks were changed to occur within an
> invalidate_range_start/end() block.
>
> In the case of .change_pte(), commit 6bdb913f0a70 ("mm: wrap calls to
> set_pte_at_notify with invalidate_range_start and invalidate_range_end",
> 2012-10-09) did so to remove the fallback from .invalidate_page() to
> .change_pte() and allow sleepable .invalidate_page() hooks.
>
> This however made KVM's usage of the .change_pte() callback completely
> moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> and therefore .change_pte() has no hope of finding a sPTE to change.
> Drop the generic KVM code that dispatches to kvm_set_spte_gfn(), as
> well as all the architecture specific implementations.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/mmu.c                  | 34 -----------------
>  arch/loongarch/include/asm/kvm_host.h |  1 -
>  arch/loongarch/kvm/mmu.c              | 32 ----------------
>  arch/mips/kvm/mmu.c                   | 30 ---------------
>  arch/powerpc/include/asm/kvm_ppc.h    |  1 -
>  arch/powerpc/kvm/book3s.c             |  5 ---
>  arch/powerpc/kvm/book3s.h             |  1 -
>  arch/powerpc/kvm/book3s_64_mmu_hv.c   | 12 ------
>  arch/powerpc/kvm/book3s_hv.c          |  1 -
>  arch/powerpc/kvm/book3s_pr.c          |  7 ----
>  arch/powerpc/kvm/e500_mmu_host.c      |  6 ---

LGTM.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

