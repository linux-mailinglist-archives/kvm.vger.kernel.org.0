Return-Path: <kvm+bounces-68084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7EDD211CF
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 20:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FE193014114
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 19:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA70934FF7C;
	Wed, 14 Jan 2026 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V52sGZ2w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7325346E71
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 19:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768420562; cv=none; b=QPN7lgcV8klXQdaTih1JSc4XAlBKqR+WaRYwcyoHMn/k4STYNTt72jgMIXQZ7GqXR3Qt4cEjimGO72fZMf4cVZhe3FHaO6+R4znmHXMdrVJRPf39mDQMKC5tU9BSKS32ylEC7cyJKRvHuHq177uc6UJpU4Qn/0W77xipJ35E5uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768420562; c=relaxed/simple;
	bh=ITOZWtROnLbhLGuMgFlQT6mJjKapDB8oEz6l2MloVnU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p6Kw8SQLdz4dNZaPQY0zbY1sIXep7oh4NOvT2yx/aK5kmxJLOpBIt40R6sNUkOuVTUD8uErkJM+h9PaWr7lsQkv4Azi6omjn5+sOy+0v3P3W1+Hr2p7BGBExDJbduB3UJ1FYwlPipLGvYcAHHuNwFOaErQfDJ+QFYbmiDNlmHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V52sGZ2w; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6097ca315bso371168a12.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768420559; x=1769025359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q2pNZ7EUA6FBNzmbYTfm/56k+uNcWtNr2zIQHp64DWQ=;
        b=V52sGZ2wF3JVYwyHzRpzGZZUgC/cmz4gmMdOSca48FwdaHzpgXaYNuMjUzCNwVu3aC
         Vv/5iXc0zO+/OCL7SF0zcttXSB+k79srXTLE0cTysjm10xnkXELiPccUgNhe+mLoxjLm
         eT4yPJwxm90FaqdlN1R13EK4RTTr3jIso6MExB0jICXJZS8OlwZBrjUCHu05DANQ2fmF
         AhvwAJBVx9zEMP8goe6PDX4KX972oBYF5bL/WnDxR2IxUM1+cS1MKslEAi8ZMM2aMpfo
         /8YbvzLrQhZoWi4yMx0En5UkMTWwmHjoKGciqkfoKTdCCT6elrS03+41bg/4qFFpKg96
         Vq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768420559; x=1769025359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q2pNZ7EUA6FBNzmbYTfm/56k+uNcWtNr2zIQHp64DWQ=;
        b=ofJAMxI/h8Meh4PtMizyFBXCplyKkQc+0VpLpCQOBVrfjVMcmvBQ7jYAYQuRM45cgG
         iTQZgmoukSg0NLZvr/NEibj3bnH0ngu+pECiAWXJB3qf2dzOuTJGDkBsnIyVZvPkalEx
         O8rvrQqB9uFBuVdWZyIpA4COkFiq6svZdgIONfgxjTpf/3ZpxuW7dDEeYNBM36+EmCus
         wSdSgU99n0skmykLJ22KDFU+uEzPTZGypUSG4RKvK+wm2TbjqzNzHTV5vDcDj80pZazr
         TcWk1BNVW4OuecimTB/TDQ3hVBAdZSoVBWgChS66Sgc/bvfVV+t7MvfXEm+Isq7L0YkJ
         N6QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVV2ron08vCETBNayPi/WalOeIqH01AaIDDjqDxEFcyBH6XCC6caDI4tyFgqip3glr1YM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVlWWGDvsuOdG/4ZZNWuSADGBKWC/oIBboZ6o+y32OOgdyyeAQ
	R4y9iRAfOOdGXsyPDSxFqnJp3wtscUivrIbKud/vYZHHefqdfcx4R1ezA7HOVHcC4C+0N/pOArw
	4q3SorA==
X-Received: from pjpo9.prod.google.com ([2002:a17:90a:9f89:b0:34e:6306:8cc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:218f:b0:342:a261:e2bc
 with SMTP id adf61e73a8af0-38befa93a22mr3281993637.10.1768420559060; Wed, 14
 Jan 2026 11:55:59 -0800 (PST)
Date: Wed, 14 Jan 2026 11:55:57 -0800
In-Reply-To: <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752819570.git.naveen@kernel.org> <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
Message-ID: <aWf0zQ6vA0Hmon2r@google.com>
Subject: Re: [RFC PATCH 2/3] KVM: SVM: Fix IRQ window inhibit handling across
 multiple vCPUs
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

Finally mustered up the brainpower to land this series :-)

On Fri, Jul 18, 2025, Naveen N Rao (AMD) wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..b781b4f1d304 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1395,6 +1395,10 @@ struct kvm_arch {
>  	struct kvm_pit *vpit;
>  #endif
>  	atomic_t vapics_in_nmi_mode;
> +
> +	/* Keep this in a cacheline separate from apicv_update_lock */

A comment won't suffice.  To isolate what we want to isolate, tag things with
__aligned().  Ideally we would use __cacheline_aligned_in_smp, but AFAIK that
can't be used within a struct as it uses .section tags, :-(

And revisiting your analysis from
https://lore.kernel.org/all/evszbck4u7afiu7lkafwcu3rs6a7io2zkv53rygrgz544op4ur@m2bugote2wdl:

 : Also, note that introducing apicv_irq_window after apicv_inhibit_reasons 
 : is degrading performance in the AVIC disabled case too. So, it is likely 
 : that some other cacheline below apicv_inhibit_reasons in kvm_arch may 
 : also be contributing to this.

I strongly suspect past-you were correct: the problem isn't that apicv_nr_irq_window_req
is in the same cacheline with apicv_update_lock, it's that apicv_nr_irq_window_req
landed in the same cachline as _other_ stuff.

Looking at the struct layout from kvm-x86-next-2025.01.14, putting apicv_irq_window
after apicv_inhibit_reasons _did_ put it on a separate cacheline from
apicv_update_lock:

	/* --- cacheline 517 boundary (33088 bytes) was 24 bytes ago --- */
	struct kvm_apic_map *      apic_map;             /* 33112     8 */
	atomic_t                   apic_map_dirty;       /* 33120     4 */
	bool                       apic_access_memslot_enabled; /* 33124     1 */
	bool                       apic_access_memslot_inhibited; /* 33125     1 */

	/* XXX 2 bytes hole, try to pack */

	struct rw_semaphore        apicv_update_lock;    /* 33128   152 */

	/* XXX last struct has 1 hole */

	/* --- cacheline 520 boundary (33280 bytes) --- */
	unsigned long              apicv_inhibit_reasons; /* 33280     8 */
	atomic_t                   apicv_irq_window;     /* 33288     4 */

	/* XXX 4 bytes hole, try to pack */

	gpa_t                      wall_clock;           /* 33296     8 */
	bool                       mwait_in_guest;       /* 33304     1 */
	bool                       hlt_in_guest;         /* 33305     1 */
	bool                       pause_in_guest;       /* 33306     1 */
	bool                       cstate_in_guest;      /* 33307     1 */

	/* XXX 4 bytes hole, try to pack */

	unsigned long              irq_sources_bitmap;   /* 33312     8 */
	s64                        kvmclock_offset;      /* 33320     8 */
	raw_spinlock_t             tsc_write_lock;       /* 33328    64 */
	/* --- cacheline 521 boundary (33344 bytes) was 48 bytes ago --- */


Which fits with my reaction that the irq_window counter being in the same cachline
as apicv_update_lock shouldn't be problematic, because the counter is only ever
written while holding the lock.  I.e. the counter is written only when the lock
cacheline is likely already pulled in in an exclusive state.

What appears to be problematic is that the counter is in the same cacheline as
several relatively hot read-mostly fields:

  apicv_inhibit_reasons - read by every vCPU on every VM-Enter
  xxx_in_guest (now disabled_exits) - read on page faults, if a vCPU takes a 
                                      PAUSE exit, if a vCPU is scheduled out, etc.
  kvmclock_offset - read every time a vCPU needs to refresh kvmclock

So I actually think we want apicv_update_lock and apicv_nr_irq_window_req to
_share_ a cacheline, and then isolate that cacheline from everything else.  Because
those two fields are effectively write-mostly, whereas most things in kvm-arch are
read-mostly.  I.e. end up with this:

	/*
	 * Protects apicv_inhibit_reasons and apicv_nr_irq_window_req (with an
	 * asterisk, see kvm_inc_or_dec_irq_window_inhibit() for details).
	 *
	 * Force apicv_update_lock and apicv_nr_irq_window_req to reside in a
	 * dedicated cacheline.  They are write-mostly, whereas most everything
	 * else in kvm_arch is read-mostly.
	 */
	struct rw_semaphore apicv_update_lock __aligned(L1_CACHE_BYTES);
	atomic_t apicv_nr_irq_window_req;

	/*
	 * As above, isolate apicv_update_lock and apicv_nr_irq_window_req on
	 * their own cacheline.  Note that apicv_inhibit_reasons is read-mostly
	 * even though it's protected by apicv_update_lock (toggling VM-wide
	 * inhibits is rare; _checking_ for inhibits is common).
	 */
	unsigned long apicv_inhibit_reasons __aligned(L1_CACHE_BYTES);

I also want to land the optimization separately, so that it can be properly
documented, justified, and analyzed by others.

I pushed a rebased version (compile-tested only at this time) with the above change to:

  https://github.com/sean-jc/linux.git svm/avic_irq_window

Can you run you perf tests to see if that aproach also eliminates the degredation
relative to avic=0 that you observed?

Thanks!

