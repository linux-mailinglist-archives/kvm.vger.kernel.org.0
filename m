Return-Path: <kvm+bounces-55440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02803B30A06
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 02:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1818E3A2B9C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F6E4C81;
	Fri, 22 Aug 2025 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OGn+aToK"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A7F1BF58
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755820937; cv=none; b=rc/Dvz1zKpWWRe1AwAOhvqFrdZt63TFX4UuwwI/3mTYi/FkRxXDQYI+yKlde8dx5iP9LwFuieH4sH4ZQNaHUJJQA9IXCt8MisLqVz6d6Tfp67hZAyr/fnvGBBjxilZn4yheLKrAhI8nYx/EA+hr2uYnEqq7PO/ns0o6tRRsvtFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755820937; c=relaxed/simple;
	bh=sB2kd2IaQcw0g1s75bnvdgvxVgOn/b5tYJ5GTBFylKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jk09UsWxMf31ciqUvX08AvxWVh8qrEEg8EA4jG61+0/X5Q1yTD/q13bVkVkMBfmGabrdRSbP4PE6UCIZkG15T9W+q5HWCCi2n4gfiLgkCFZ889YypIpl4gqeIweTU4of2namSwVtVW3ZXnKgdIX1yzBPzkpcOYvpDzSPuvmu4rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OGn+aToK; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755820933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUrDaGrlbnJZ+oxdBPVH9aUM2aDAG/pXEN+zcLc/AKw=;
	b=OGn+aToKUF9886Yb2+U4Tf4NouYzRT+l0M8RBeJjCeLgRpw/Fg7v7pIWjH8xuOxNXujSre
	vgZxqRSelB7SwT30XZBByV7+Pkd8uDKRe2KYir6r6sXfvWWm5QSsGIROsD5Vij6NSvnqGj
	oh3k3Bh3d4B/2G8UaLzDmtNLOdDTI48=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
Date: Thu, 21 Aug 2025 17:02:00 -0700
Message-Id: <175582091313.1266576.4329884314263043118.b4-ty@linux.dev>
In-Reply-To: <20250820162242.2624752-1-rananta@google.com>
References: <20250820162242.2624752-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 20 Aug 2025 16:22:40 +0000, Raghavendra Rao Ananta wrote:
> When destroying a fully-mapped 128G VM abruptly, the following scheduler
> warning is observed:
> 
>   sched: CPU 0 need_resched set for > 100018840 ns (100 ticks) without schedule
>   CPU: 0 UID: 0 PID: 9617 Comm: kvm_page_table_ Tainted: G O 6.16.0-smp-DEV #3 NONE
>   Tainted: [O]=OOT_MODULE
>   Call trace:
>       show_stack+0x20/0x38 (C)
>       dump_stack_lvl+0x3c/0xb8
>       dump_stack+0x18/0x30
>       resched_latency_warn+0x7c/0x88
>       sched_tick+0x1c4/0x268
>       update_process_times+0xa8/0xd8
>       tick_nohz_handler+0xc8/0x168
>       __hrtimer_run_queues+0x11c/0x338
>       hrtimer_interrupt+0x104/0x308
>       arch_timer_handler_phys+0x40/0x58
>       handle_percpu_devid_irq+0x8c/0x1b0
>       generic_handle_domain_irq+0x48/0x78
>       gic_handle_irq+0x1b8/0x408
>       call_on_irq_stack+0x24/0x30
>       do_interrupt_handler+0x54/0x78
>       el1_interrupt+0x44/0x88
>       el1h_64_irq_handler+0x18/0x28
>       el1h_64_irq+0x84/0x88
>       stage2_free_walker+0x30/0xa0 (P)
>       __kvm_pgtable_walk+0x11c/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       kvm_pgtable_walk+0xc4/0x140
>       kvm_pgtable_stage2_destroy+0x5c/0xf0
>       kvm_free_stage2_pgd+0x6c/0xe8
>       kvm_uninit_stage2_mmu+0x24/0x48
>       kvm_arch_flush_shadow_all+0x80/0xa0
>       kvm_mmu_notifier_release+0x38/0x78
>       __mmu_notifier_release+0x15c/0x250
>       exit_mmap+0x68/0x400
>       __mmput+0x38/0x1c8
>       mmput+0x30/0x68
>       exit_mm+0xd4/0x198
>       do_exit+0x1a4/0xb00
>       do_group_exit+0x8c/0x120
>       get_signal+0x6d4/0x778
>       do_signal+0x90/0x718
>       do_notify_resume+0x70/0x170
>       el0_svc+0x74/0xd8
>       el0t_64_sync_handler+0x60/0xc8
>       el0t_64_sync+0x1b0/0x1b8
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
      https://git.kernel.org/kvmarm/kvmarm/c/0e89ca13ee5f
[2/2] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
      https://git.kernel.org/kvmarm/kvmarm/c/e9abe311f356

--
Best,
Oliver

