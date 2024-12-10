Return-Path: <kvm+bounces-33370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 769119EA437
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52D5E1887FA3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDFB54740;
	Tue, 10 Dec 2024 01:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="huspuAkJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF00F3F9FB
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 01:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733793742; cv=none; b=h8OEQlDvuVagBbPonge3d1dnjXoBcKEwYGhaFaIRTG22wrLppHhHW2mwjArycyuRvj1hF31nTI+sQzeFNwTh8b+sIeZrCClPSYQ2GnNt/v/i7ltZqjRKYXwPoNuhJxe6gZlDgYVn7dQ9uxN7Q7K3Ps81KFd178PymUB7bu3KJPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733793742; c=relaxed/simple;
	bh=lxG2QyrapZjqgJix8u3VBwGfnxzj8vXaDcTkuvsWz5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ai+p9H2BZlVmQ31cjSQHfJOsVH3J7BVcJocknyaQoGJDyiE7IFFE1hqtK6SBPUxhzfAyisLatT2KBc9ariozgYvuIFM+6xLx1QZYHZNH2Huo65yLv9x2OCcfibZ35EMSKKZnBk+6ousZkzBodMLmPw2W62KSmbjmbRqrVHEESi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=huspuAkJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fd481e3c0bso1278634a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 17:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733793740; x=1734398540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PvPgnHw7fmZqS+sVNqU04Ny1MosXcQz6Y/SiWDOXiDw=;
        b=huspuAkJpyYdyyL6K3LqVkOrtZKEUd7kzZEjPRzZNeXrjNwPA3HBAEPsm5GZqNt/6v
         1pg2KZdakn3+QZDml3P+xCF306elfCiyc5dD7D+GuAQzP9dFnqz6IA8dn6thFtTAgLNl
         +Z5WqKGa3D9jT9Y9+5pSpA6fpSdFD2rqfcdAC6gSvij0Ufy+C1DHWUzA5OuDlkuG3lYs
         kLMU+QZykQsn1TW8pr280b3jSZUy6Tdy0pNBqyxldpY+9ArcDrQvqMxGVIycSC6RA5Qf
         v3Kjg1Mj8QJTIec/nhqTB9lSKuBm4Syq0KwR0i3d+8nZi1iKtGr+E7A/ka1rwhhyUw4m
         +TzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733793740; x=1734398540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PvPgnHw7fmZqS+sVNqU04Ny1MosXcQz6Y/SiWDOXiDw=;
        b=bQqHA17WN4jGFHifYbrYS4qqnq/zWdJoYh5+WjgovY0BVZ0iS9aUw2tJFtbQU4M35s
         KqomiSGZXMEScVTXvC7cK65+fWU/Ul/1XFFJjsCMxLxuC+5ewssNiV+bD4KvdObsOd0+
         +pKPY7T8vKwCBDdX3dAQWPc3F2C5hN/PAaHzZY99gH8gTF34jQ660AHEn7a3ckDzsY6b
         QIe/Q0xbMLXqJKR5p9fTeQC8BMobm0E+H0fM7wDb1Jn0v22tXVUFqisQ1DukdWZw/9bK
         dHTrMb7Cs7dbHlYQsvMmERYTNN+snn7aX3KYdBnAwkbiiJ132WmJ6FtEKYEP6Hyo3pVP
         XC/w==
X-Gm-Message-State: AOJu0YwaTql5f8LorAMTdXdpADbDWSR88LnQeiz2yNSfAlOEVkclUHU/
	3JlOBCsGDe6j9bsiayMwwFBn4PqqJm2J1NZhhRiWfDG0ZUs5wePEPAs1Ax64jXKaJ0X/e9TGFS1
	8xA==
X-Google-Smtp-Source: AGHT+IHBoBT+mzwpMwV/3SyXl6ldyb+0qw7zvzpd0dwCKBffEvPllTLm59C2NH+b/3ZaJJvwv+ix2fAO0bg=
X-Received: from plblm15.prod.google.com ([2002:a17:903:298f:b0:216:2fcc:4084])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da89:b0:215:19ae:77bf
 with SMTP id d9443c01a7336-21669fe13e4mr33754085ad.19.1733793740102; Mon, 09
 Dec 2024 17:22:20 -0800 (PST)
Date: Mon, 9 Dec 2024 17:22:18 -0800
In-Reply-To: <20241021102321.665060-1-bk@alpico.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241021102321.665060-1-bk@alpico.io>
Message-ID: <Z1eXyv2VVsFiw_0i@google.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 21, 2024, Bernhard Kauer wrote:
> It used a static key to avoid loading the lapic pointer from
> the vcpu->arch structure.  However, in the common case the load
> is from a hot cacheline and the CPU should be able to perfectly
> predict it. Thus there is no upside of this premature optimization.
> 
> The downside is that code patching including an IPI to all CPUs
> is required whenever the first VM without an lapic is created or
> the last is destroyed.
> 
> Signed-off-by: Bernhard Kauer <bk@alpico.io>
> ---
> 
> V1->V2: remove spillover from other patch and fix style
> 
>  arch/x86/kvm/lapic.c | 10 ++--------
>  arch/x86/kvm/lapic.h |  6 +-----
>  arch/x86/kvm/x86.c   |  6 ------
>  3 files changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 2098dc689088..287a43fae041 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -135,8 +135,6 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
>  	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>  }
>  
> -__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> -EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
>  
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);

I'm on the fence, slightly leaning towards removing all three of these static keys.

If we remove kvm_has_noapic_vcpu to avoid the text patching, then we should
definitely drop apic_sw_disabled, as vCPUs are practically guaranteed to toggle
the S/W enable bit, e.g. it starts out '0' at RESET.  And if we drop apic_sw_disabled,
then keeping apic_hw_disabled seems rather pointless.

Removing all three keys is measurable, but the impact is so tiny that I have a
hard time believing anyone would notice in practice.

To measure, I tweaked KVM to handle CPUID exits in the fastpath and then ran the
KVM-Unit-Test CPUID microbenchmark (with some minor modifications).  Handling
CPUID in the fastpath makes the kvm_lapic_enabled() call in the innermost run loop
stick out (that helpers checks all three keys/conditions).

	for (;;) {
		/*
		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
		 * update must kick and wait for all vCPUs before toggling the
		 * per-VM state, and responding vCPUs must wait for the update
		 * to complete before servicing KVM_REQ_APICV_UPDATE.
		 */
		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));

		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu,
						       req_immediate_exit);
		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
			break;

		if (kvm_lapic_enabled(vcpu))
			kvm_x86_call(sync_pir_to_irr)(vcpu);

		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
			break;
		}

		/* Note, VM-Exits that go down the "slow" path are accounted below. */
		++vcpu->stat.exits;
	}

With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
(mostly laziness), the average latency goes from 1034 => 1053.

Other flows that check multiple vCPUs, e.g. kvm_irq_delivery_to_apic(), might be
more affected?  The optimized APIC map should help for common cases, but KVM does
still check if APICs are enabled multiple times when delivering interrupts.  And
that's really my only hesitation: there are checks *everywhere* in KVM.

On the other hand, we lose gobs and gobs of cycles with far less thought.  E.g.
with mitigations on, the latency for a single vCPU jumps all the way to 1600+ cycles.

And while the diff stats are quite nice, the relevant code is low maintenance.

 arch/x86/kvm/lapic.c | 41 ++---------------------------------------
 arch/x86/kvm/lapic.h | 19 +++----------------
 arch/x86/kvm/x86.c   |  4 +---
 3 files changed, 6 insertions(+), 58 deletions(-)

Paolo or anyone else... thoughts?

