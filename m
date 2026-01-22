Return-Path: <kvm+bounces-68900-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNMyDjpIcmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68900-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:54:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EF94669491
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4C0137CC231
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6A734FF75;
	Thu, 22 Jan 2026 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGybcmTY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08B130BB83;
	Thu, 22 Jan 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769093636; cv=none; b=VT3Rbvcra1Qya2FYnk6wMxA+t8arkCTt8cwPtZW2ZbCLlghMez0zOvwYkAVxb8WnBfPtiNzhQKwIFtif5kjI3Mms+Rme/qF6gUOeLm49/37Y94aGtEp8SOQwpcFY0jflpk7NuKhS//CWuqkORHqYkgs7dbi0Zzbo9LA835UOFW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769093636; c=relaxed/simple;
	bh=H6gTOF+DyDj27GbSd5bl3JAxET7cibneMu2y65c/FqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIQPbjLBB5a4qONmRO825OFKGT5sqTnFI7v8Fb+6PjzywjVUmyAdfHhgp1wzfhPuWxOak3MKy6LXW255acvn6VDoGgqfi4IJIRtFqn9NBn2j4DfzVNvYblkI+pBOSiU2F7ge4xFXa9TVtHH74seXa3XEzfgDCMfxQS+tKR5QbIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGybcmTY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03277C116C6;
	Thu, 22 Jan 2026 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769093636;
	bh=H6gTOF+DyDj27GbSd5bl3JAxET7cibneMu2y65c/FqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BGybcmTY925gF+7wqr9qE8CUyFtb6tQpxGNFDS9dM8dwTOeAceLBUtBh+cWt/9x4H
	 BkmCpC/Vg9UcwjwriAnyLxalX1R+EOqRBrwsUvzTv9/tNVJpQUh8olv3v72E0oe8cX
	 BOGt4VtyM/UmwMhX9nI9FJ2jExU6btOOEbHh8L1UzLdNwKTSVog8Td9BXb8BlnZF8E
	 gOaQajl4BiYd9a5vnA/XBOU47NN/9yrMQvE7e6/TjOG9IVjlVMb8Ckz9rptyYKfMaZ
	 o/pRcjAM5s+I91LS6V1a4ZBy88Mg1aD3W0/VeGOs1EuhoJ5SPoxUtlzoX/DJ6b1Q9C
	 1f7mmJ/BrGVZA==
Date: Thu, 22 Jan 2026 20:19:30 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH 2/3] KVM: SVM: Fix IRQ window inhibit handling across
 multiple vCPUs
Message-ID: <aXI1EAolDjVbp_9W@blrnaveerao1>
References: <cover.1752819570.git.naveen@kernel.org>
 <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
 <aWf0zQ6vA0Hmon2r@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWf0zQ6vA0Hmon2r@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-68900-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: EF94669491
X-Rspamd-Action: no action

On Wed, Jan 14, 2026 at 11:55:57AM -0800, Sean Christopherson wrote:
> Finally mustered up the brainpower to land this series :-)

Yay! :)

> 
> On Fri, Jul 18, 2025, Naveen N Rao (AMD) wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f19a76d3ca0e..b781b4f1d304 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1395,6 +1395,10 @@ struct kvm_arch {
> >  	struct kvm_pit *vpit;
> >  #endif
> >  	atomic_t vapics_in_nmi_mode;
> > +
> > +	/* Keep this in a cacheline separate from apicv_update_lock */
> 
> A comment won't suffice.  To isolate what we want to isolate, tag things with
> __aligned().  Ideally we would use __cacheline_aligned_in_smp, but AFAIK that
> can't be used within a struct as it uses .section tags, :-(
> 
> And revisiting your analysis from
> https://lore.kernel.org/all/evszbck4u7afiu7lkafwcu3rs6a7io2zkv53rygrgz544op4ur@m2bugote2wdl:
> 
>  : Also, note that introducing apicv_irq_window after apicv_inhibit_reasons 
>  : is degrading performance in the AVIC disabled case too. So, it is likely 
>  : that some other cacheline below apicv_inhibit_reasons in kvm_arch may 
>  : also be contributing to this.
> 
> I strongly suspect past-you were correct: the problem isn't that apicv_nr_irq_window_req
> is in the same cacheline with apicv_update_lock, it's that apicv_nr_irq_window_req
> landed in the same cachline as _other_ stuff.
> 
> Looking at the struct layout from kvm-x86-next-2025.01.14, putting apicv_irq_window
> after apicv_inhibit_reasons _did_ put it on a separate cacheline from
> apicv_update_lock:

I suppose you meant kvm-x86-next-2026.01.14 (2026 and not 2025). I'm 
fairly certain that when I tested this, all three of apicv_update_lock, 
apicv_inhibit_reasons and the irq_window count were ending up in the 
same cacheline. I specifically tested moving each of those out to a 
separate cacheline (including apicv_inhibit_reasons), but as far as I 
remember, the only time I noticed a difference was when moving the 
irq_window count elsewhere.
> 
> 	/* --- cacheline 517 boundary (33088 bytes) was 24 bytes ago --- */
> 	struct kvm_apic_map *      apic_map;             /* 33112     8 */
> 	atomic_t                   apic_map_dirty;       /* 33120     4 */
> 	bool                       apic_access_memslot_enabled; /* 33124     1 */
> 	bool                       apic_access_memslot_inhibited; /* 33125     1 */
> 
> 	/* XXX 2 bytes hole, try to pack */
> 
> 	struct rw_semaphore        apicv_update_lock;    /* 33128   152 */
> 
> 	/* XXX last struct has 1 hole */
> 
> 	/* --- cacheline 520 boundary (33280 bytes) --- */
> 	unsigned long              apicv_inhibit_reasons; /* 33280     8 */
> 	atomic_t                   apicv_irq_window;     /* 33288     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	gpa_t                      wall_clock;           /* 33296     8 */
> 	bool                       mwait_in_guest;       /* 33304     1 */
> 	bool                       hlt_in_guest;         /* 33305     1 */
> 	bool                       pause_in_guest;       /* 33306     1 
> 	*/
> 	bool                       cstate_in_guest;      /* 33307     1 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	unsigned long              irq_sources_bitmap;   /* 33312     8 */
> 	s64                        kvmclock_offset;      /* 33320     8 */
> 	raw_spinlock_t             tsc_write_lock;       /* 33328    64 */
> 	/* --- cacheline 521 boundary (33344 bytes) was 48 bytes ago --- */
> 
> 
> Which fits with my reaction that the irq_window counter being in the same cachline
> as apicv_update_lock shouldn't be problematic, because the counter is only ever
> written while holding the lock.  I.e. the counter is written only when the lock
> cacheline is likely already pulled in in an exclusive state.

Indeed.

> 
> What appears to be problematic is that the counter is in the same cacheline as
> several relatively hot read-mostly fields:
> 
>   apicv_inhibit_reasons - read by every vCPU on every VM-Enter
>   xxx_in_guest (now disabled_exits) - read on page faults, if a vCPU 
>   takes a PAUSE exit, if a vCPU is scheduled out, etc.
>   kvmclock_offset - read every time a vCPU needs to refresh kvmclock
> 
> So I actually think we want apicv_update_lock and apicv_nr_irq_window_req to
> _share_ a cacheline, and then isolate that cacheline from everything else.  Because
> those two fields are effectively write-mostly, whereas most things in kvm-arch are
> read-mostly.  I.e. end up with this:
> 
> 	/*
> 	 * Protects apicv_inhibit_reasons and apicv_nr_irq_window_req (with an
> 	 * asterisk, see kvm_inc_or_dec_irq_window_inhibit() for details).
> 	 *
> 	 * Force apicv_update_lock and apicv_nr_irq_window_req to reside in a
> 	 * dedicated cacheline.  They are write-mostly, whereas most everything
> 	 * else in kvm_arch is read-mostly.
> 	 */
> 	struct rw_semaphore apicv_update_lock __aligned(L1_CACHE_BYTES);
> 	atomic_t apicv_nr_irq_window_req;
> 
> 	/*
> 	 * As above, isolate apicv_update_lock and apicv_nr_irq_window_req on
> 	 * their own cacheline.  Note that apicv_inhibit_reasons is read-mostly
> 	 * even though it's protected by apicv_update_lock (toggling VM-wide
> 	 * inhibits is rare; _checking_ for inhibits is common).
> 	 */
> 	unsigned long apicv_inhibit_reasons __aligned(L1_CACHE_BYTES);

Nice, isolating those in a separate cacheline looks to be helping.

> 
> I also want to land the optimization separately, so that it can be properly
> documented, justified, and analyzed by others.
> 
> I pushed a rebased version (compile-tested only at this time) with the above change to:
> 
>   https://github.com/sean-jc/linux.git svm/avic_irq_window
> 
> Can you run you perf tests to see if that aproach also eliminates the degredation
> relative to avic=0 that you observed?

Yes, this definitely seems to be helping get rid of that odd performance 
drop I was seeing earlier. I'll run a couple more tests and report back 
by next week if I see anything off. Otherwise, this is looking good to 
me and if you want to apply this to -next, I'm fine with that:
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>


Thanks for all your help with this (and Paolo)!


- Naveen


