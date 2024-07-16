Return-Path: <kvm+bounces-21739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 595DC933444
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 00:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CEC01C220AF
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 22:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4EA14386E;
	Tue, 16 Jul 2024 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mWIAAXVD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809097581D
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721169375; cv=none; b=IrCzbwAFrD4ge/5iw/6WIaPBYyAlB1anaA8b/yFdSfrmAq6yHpeMhvet0HmBZ4yIPDoVaX1IN4E57Fz//3kVEsMLQI3DKDXSwOSP1eLtKrjUt7FOsVyVBAlSC3r/7Lt/J1xxncA47rxC8eQZk0t0EnJ+NZTC9gOD6HH/GW2NZOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721169375; c=relaxed/simple;
	bh=zqTZu32QXN381eF2EXvGL2ywKpU4EioF0+pMA9whoCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oFgrzAAZ8TmUV57fFiletg41sE3yEWznngaKV2Mpy9Rpp9wN18tw+wKfdGZK0LPir9M/00tfuBcNMOkzwTBHeDVJ+TW4obC9zhZPr8kbXN2dT4yteEr6zUJ697QQC6lTwTEfQW1Fiog1iqmbd+PGagTrzohVds5zWgpYGZ/XvEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mWIAAXVD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0335450936so11679905276.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721169372; x=1721774172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6eWXs3z6b+9NSb4Ic7sSWzsLfXZane5NyKc2hSTtR2Q=;
        b=mWIAAXVDA85+j4Y8+QlaeTU0e2sLe7tyt7w9xtVZieIxIasBKD0JFXa5qdLpHrfel7
         EhoSgmqxrwMWqNGIbNr/gY4/18ci/552RIezKv0fKOjmTsZVnKjajr3B4ttuTVEhSqqI
         yu7q37k4PmR7SKSt7YOqglKs8vThlq2MRBTt5UIvmjeY765JKJNlNXVtYwKtMoWVz5gt
         ramWhk0Us3/8Fur6p/LeZwAL4h2lLBo/Nyk1hIUjIfP903yUD74FsElsoVVKlaMIc/t+
         J5HyEo83LUnw5hYCR2bV9muTE7j7Qdec76pLcVnQQUR5KfCh94Q4siIQo20FRYH+wpnu
         X4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721169372; x=1721774172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6eWXs3z6b+9NSb4Ic7sSWzsLfXZane5NyKc2hSTtR2Q=;
        b=QcazjUL5eUcEV0ADbJjF9kWC3fqPoWtgKRAqD83EmK1aonopKMZuHffi974EMtAf40
         2Q6vF84HPyhZ4fgVC+rLxGyepV+rgmxwc51sFbydoOLhsH/vP3VqWxXK3XlpLzjrYYOj
         4zQhYL4/juYHXMTGAdC6YtDgP15eHzRxp13LxR+SoZvxDf9VsREcX/A4u4OK6B5rtMhM
         /T4f6ijHWPUyYfeTh4+Ytvjftvb4NQ53hRdgyuRGkULOkdBvLZo/cu+TBHllW7q5l9eh
         ZUuFOUBdCxuRgzRLbaMV8iz3jFkaiecuFEZWutnzg9gK2UcvwESC8WG4RVt3yc4ykXvp
         zQZg==
X-Gm-Message-State: AOJu0Yx6qEyw2GJ3r3nXeCKN775se0IMFZEkxvbAoSnvDwNKnA+7Vr2W
	cBMLdF35gov9r7ugViGqSnD/B75EabKQwQDzD/3vA+1CjbY5GxnZWwOWGavCaf5ab+Y3/P77/IR
	TEg==
X-Google-Smtp-Source: AGHT+IHNefrgBmTcHKeT33Kds1JOiySYeJA9EAuLooxQygT8+6NXMEow7nFCWlJVAdiiNkTRCVbt/ahSqC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:e03:5312:c053 with SMTP id
 3f1490d57ef6-e05d56c7498mr6635276.7.1721169372469; Tue, 16 Jul 2024 15:36:12
 -0700 (PDT)
Date: Tue, 16 Jul 2024 15:36:11 -0700
In-Reply-To: <20240716022014.240960-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240716022014.240960-1-mlevitsk@redhat.com> <20240716022014.240960-3-mlevitsk@redhat.com>
Message-ID: <Zpb127FsRoLdlaBb@google.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: disable preemption when touching segment fields
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 15, 2024, Maxim Levitsky wrote:
> VMX code uses segment cache to avoid reading guest segment fields.
> 
> The cache is reset each time a segment's field (e.g base/access rights/etc)
> is written, and then a new value of this field is written.
> 
> However if the vCPU is preempted between these two events, and this
> segment field is read (e.g kvm reads SS's access rights to check
> if the vCPU is in kernel mode), then old field value will get
> cached and never updated.

It'be super helpful to include the gory details about how kvm_arch_vcpu_put()
reads stale data.  Without that information, it's very hard to figure out how
getting preempted is problematic.

  vmx_vcpu_reset resets the segment cache bitmask and then initializes
  the segments in the vmcs, however if the vcpus is preempted in the
  middle of this code, the kvm_arch_vcpu_put is called which
  reads SS's AR bytes to determine if the vCPU is in the kernel mode,
  which caches the old value.

> Usually a lock is required to avoid such race but since vCPU segments
> are only accessed by its vCPU thread, we can avoid a lock and
> only disable preemption, in places where the segment cache
> is invalidated and segment fields are updated.

This doesn't fully fix the problem.  It's not just kvm_sched_out() => kvm_arch_vcpu_put()
that's problematic, it's any path that executes KVM code in interrupt context.
And it's not just limited to segment registers, any register that is conditionally
cached via arch.regs_avail is susceptible to races.

Specifically, kvm_guest_state() and kvm_guest_get_ip() will read SS.AR_bytes and
RIP in NMI and/or IRQ context when handling a PMI.

A few possible ideas.

 1. Force reads from IRQ/NMI context to skip the cache and go to the VMCS.

 2. Same thing as #1, but focus it specifically on kvm_arch_vcpu_in_kernel()
    and kvm_arch_vcpu_get_ip(), and WARN if kvm_register_is_available() or
    vmx_segment_cache_test_set() is invoked from IRQ or NMI context.

 3. Force caching of SS.AR_bytes, CS.AR_bytes, and RIP prior to kvm_after_interrupt(),
    rename preempted_in_kernel to something like "exited_in_kernel" and snapshot
    it before kvm_after_interrupt(), and add the same hardening as #2.

    This is doable because kvm_guest_state() should never read guest state for
    PMIs that occur between VM-Exit and kvm_after_interrupt(), nor should KVM
    write guest state in that window.  And the intent of the "preempted in kernel"
    check is to query vCPU state at the time of exit.

 5. Do a combination of #3 and patch 02 (#3 fixes PMIs, patch 02 fixes preemption).

My vote is probably for #2 or #4.  I definitely think we need WARNs in the caching
code, and in general kvm_arch_vcpu_put() shouldn't be reading cacheable state, i.e.
I am fairly confident we can restrict it to checking CPL.

I don't hate this patch by any means, but I don't love disabling preemption in a
bunch of flows just so that the preempted_in_kernel logic works.

