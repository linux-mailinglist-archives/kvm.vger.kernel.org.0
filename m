Return-Path: <kvm+bounces-63756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A810EC7149E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 23:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E1C1F2E075
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 22:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB4131619A;
	Wed, 19 Nov 2025 22:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rt0Vg+lz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266EE30DEDE;
	Wed, 19 Nov 2025 22:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763591732; cv=none; b=D3hA5THzKN8ZiCh0goe1KAZIUDGJo3NjRyCXLIygm5XWUXM+9JVyHz5sSHYHQI2nRcP7Gvg7x8DyTZBwyJ6qh7AMS6FiH8q4KgfkP8w4yEF7f9cj7ZDcDoRwobeOnq0w2+COhcz5dQjlPchKTwjxckAV/w71CpnCkSA9JMuvaow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763591732; c=relaxed/simple;
	bh=sDyW89qPXT3xdQtj10GxlHLo6uAfus5uHKYULC7hRl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntZ0xjekzDtv4jllJ/dH069Y9gSVqJgLGdIQnkFmXKkNmlG09dnWIA34cUMt2LgtmjKHhytyITicEFhKyDnD2EOtUHS4kYO44zc5j/vCF7laSxfiGftBaPAa1VZ9VV0VrnBZJA896C8EWP7THVUp0sMYePrxcRx+MQnTrP+uYwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rt0Vg+lz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8992C19421;
	Wed, 19 Nov 2025 22:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763591731;
	bh=sDyW89qPXT3xdQtj10GxlHLo6uAfus5uHKYULC7hRl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt0Vg+lzXkk7T3RVTZNY/ZGYbm7HWy7YYAeYDktDAgzB4DG+fqhFxJ5KVxgemCpAx
	 uLpKJ9LFrcVGvOxsgPcurh4KAT+/qHiy1K/4LKT2Dm9uDQ/ighMwPkz/pGOPsnspTh
	 4lYlwLHJ7xsi4KdUReKoML5WaUtgAWxtxo3zO80+zHLqltFeUAimDZrIpa/z9GStJv
	 xk1CUYTjSbP1YqQm5+RTWnvx4hDWT0j1wtZ4JRAv82Pm3mMtdzPbapGNA62yOdODBb
	 sxqkZ05AoP+HlPlYAsYdtCMW7wcf32HmiJcY36JRkjy0tHFD9w+MpEg5fiSC4AxWL+
	 L4S0oZ1e+P/FA==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
Date: Wed, 19 Nov 2025 14:35:28 -0800
Message-ID: <176359161125.183996.17801262311162275177.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113052452.975081-1-rananta@google.com>
References: <20251113052452.975081-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Nov 2025 05:24:49 +0000, Raghavendra Rao Ananta wrote:
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

Applied to next, thanks!

[1/3] KVM: arm64: Only drop references on empty tables in stage2_free_walker
      https://git.kernel.org/kvmarm/kvmarm/c/156f70afcfec
[2/3] KVM: arm64: Split kvm_pgtable_stage2_destroy()
      https://git.kernel.org/kvmarm/kvmarm/c/d68d66e57e2b
[3/3] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
      https://git.kernel.org/kvmarm/kvmarm/c/4ddfab5436b6

--
Best,
Oliver

