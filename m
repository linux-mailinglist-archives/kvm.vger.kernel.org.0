Return-Path: <kvm+bounces-9330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F3A85E2FB
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5584284E49
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35E982870;
	Wed, 21 Feb 2024 16:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+PEwRBI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA7081AA8
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708532673; cv=none; b=LWEXJ4j8U204pZEd4v/3BnDS8B/dEoqhGY88QcG3IZdsMfG+lGbiExqU0jZpCGRLH/cZCluz3DDsD1HN2gXXw1JfBeAaB9SoneObQBU8UTbH77lb+pF1VB9QQ8QYI/XFD1Gp7ZWDTUyPAMsyMT2HZ904A5x1bOr5bCbdF46iDDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708532673; c=relaxed/simple;
	bh=/RBZWvPXtN1/7NIi9aR11iDMtHIEuqOwwU2C8g+ij2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VMhbBegxzxE6HIMDM8x2k2ZbzzZxfiES9nmbuzPHlDcZhZrqGnDoLLH38TKgQ9GLNv1Fkgb5jN7VYXlP9WdJbZxV164mWtMTYNLMi/P7qB1qYqKtonE+VzjtpxPbGve5V1xZ2OpHv9mb7+3T+2curJ3m3gsuooDnOQchU/zfSOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+PEwRBI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso5500977a12.2
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 08:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708532670; x=1709137470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI6vMXicCnQj/Rt2p/mimi/5sLiPfMX4BJ5d2OzSXvM=;
        b=P+PEwRBIFPXkItj94mmz2wUsUjs4hlehXfxy5J36D6EJAQ1T90hynJkD41jLovAR0I
         ye143SDyEmd5n40sMUESfXqUToiU1dsDIj9fUUaqlCiN/F8GanMAoC9JXLDwWBbAPDiY
         Wr6Z+cb4saw/z8gw2uHJvmKVdzypz3jIE730ucJ+5TsdOIhNTVFOrwrwtjAjc/x4z2H2
         yoFveBq0d+HYqdMsY6u7zb4VKr+r089Vcl976EVWBBfC5QjmxVhfElV09OL6CR8/NbmU
         ydKMvUx5RJR0Z4VueyTNIfv35HwnBgSDryN2at4ZH4YEPy4v3bzgfJfc3PlOtbs82YYi
         6W2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708532670; x=1709137470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI6vMXicCnQj/Rt2p/mimi/5sLiPfMX4BJ5d2OzSXvM=;
        b=uoWHsjuzYdlropeLybnIEw/McLpmRy4vGuCcPZoaejglujDh1ybreZK9sYImnI+C2b
         LuOZdyAwV9kqFuacRsi3stj6+wlkvC3rkmrZdchW1+9R658B/9AsupS+mUkKrrIUVHbF
         FjmolZebempRL4go8XoZR0OUwqdbRGoPwZdA76f6LjOGVcFfMAMkhB9DnJCDN5tLfmiq
         mS/JuKqG5qtg5TyCvA5vdWqiIxXQmdng8KGYxyfC0MpxPvIyTOKra80QUIBR7/ZZu/bo
         YRa2CERwWNHDYkjbZC0YSynuL0OXUR3B84nm0YjYVCpoobydfsyqiQE6jZ1K7ik1UVN6
         VYXA==
X-Forwarded-Encrypted: i=1; AJvYcCUUmHmGmsaEHysbuUui5DnHbiOfzj4xmKpIzCNoET0snBcFhgGCBkNlTo8ErtW1ZeC7yId6yhkH5ihqIGfTyaukDHOV
X-Gm-Message-State: AOJu0Yx1rgBK3IwoEx9lxRqv6a5nF4Zh70lKWqt8RzqMYEzrU+63nXnE
	H9UtrUm9VZPOtRrY1TYjdHNuxLk0tCiZ9G+1TBLkOmzB5psAGh4yYgSaHgOeeccJZmFkiM+5sV4
	7ag==
X-Google-Smtp-Source: AGHT+IFYMwRhYvyeI8/KrVTwRAW8Pe1VljLQv60wXHBzxHMomElDNKIkYz0jGY9j+Vb7sPHZlBIZEnw2PUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:68d0:0:b0:5dc:af76:f57d with SMTP id
 k16-20020a6568d0000000b005dcaf76f57dmr93817pgt.7.1708532669953; Wed, 21 Feb
 2024 08:24:29 -0800 (PST)
Date: Wed, 21 Feb 2024 08:24:28 -0800
In-Reply-To: <CZA43Y64EK8R.1M8J5Q6L39LFB@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219175735.33171-1-nsaenz@amazon.com> <ZdTQyb23KJEYqbcw@google.com>
 <CZA43Y64EK8R.1M8J5Q6L39LFB@amazon.com>
Message-ID: <ZdYjvBItrl20oHXC@google.com>
Subject: Re: [RFC] cputime: Introduce option to force full dynticks accounting
 on NOHZ & NOHZ_IDLE CPUs
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: frederic@kernel.org, paulmck@kernel.org, jalliste@amazon.co.uk, 
	mhiramat@kernel.org, akpm@linux-foundation.org, pmladek@suse.com, 
	rdunlap@infradead.org, tsi@tuyoix.net, nphamcs@gmail.com, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 20, 2024, Nicolas Saenz Julienne wrote:
> Hi Sean,
> 
> On Tue Feb 20, 2024 at 4:18 PM UTC, Sean Christopherson wrote:
> > On Mon, Feb 19, 2024, Nicolas Saenz Julienne wrote:
> > > Under certain extreme conditions, the tick-based cputime accounting may
> > > produce inaccurate data. For instance, guest CPU usage is sensitive to
> > > interrupts firing right before the tick's expiration.

Ah, this confused me.  The "right before" is a bit misleading.  It's more like
"shortly before", because if the interrupt that occurs due to the guest's tick
arrives _right_ before the host tick expires, then commit 160457140187 should
avoid horrific accounting.

> > > This forces the guest into kernel context, and has that time slice
> > > wrongly accounted as system time. This issue is exacerbated if the
> > > interrupt source is in sync with the tick,

It's worth calling out why this can happen, to make it clear that getting into
such syncopation can happen quite naturally.  E.g. something like:

      interrupt source is in sync with the tick, e.g. if the guest's tick
      is configured to run at the same frequency as the host tick, and the
      guest tick is every so slightly ahead of the host tick.

> > > significantly skewing usage metrics towards system time.
> >
> > ...
> >
> > > NOTE: This wasn't tested in depth, and it's mostly intended to highlight
> > > the issue we're trying to solve. Also ccing KVM folks, since it's
> > > relevant to guest CPU usage accounting.
> >
> > How bad is the synchronization issue on upstream kernels?  We tried to address
> > that in commit 160457140187 ("KVM: x86: Defer vtime accounting 'til after IRQ handling").
> >
> > I don't expect it to be foolproof, but it'd be good to know if there's a blatant
> > flaw and/or easily closed hole.
> 
> The issue is not really about the interrupts themselves, but their side
> effects.
> 
> For instance, let's say the guest sets up an Hyper-V stimer that
> consistently fires 1 us before the preemption tick. The preemption tick
> will expire while the vCPU thread is running with !PF_VCPU (maybe inside
> kvm_hv_process_stimers() for ex.). As long as they both keep in sync,
> you'll get a 100% system usage. I was able to reproduce this one through
> kvm-unit-tests, but the race window is too small to keep the interrupts
> in sync for long periods of time, yet still capable of producing random
> system usage bursts (which unacceptable for some use-cases).
> 
> Other use-cases have bigger race windows and managed to maintain high
> system CPU usage over long periods of time. For example, with user-space
> HPET emulation, or KVM+Xen (don't know the fine details on these, but
> VIRT_CPU_ACCOUNTING_GEN fixes the mis-accounting). It all comes down to
> the same situation. Something triggers an exit, and the vCPU thread goes
> past 'vtime_account_guest_exit()' just in time for the tick interrupt to
> show up.

I suspect the common "problem" with those flows is that emulating the guest timer
interrupt is (a) slow, relatively speaking and (b) done with interrupts enabled.

E.g. on VMX, the TSC deadline timer is emulated via VMX preemption timer, and both
the programming of the guest's TSC deadline timer and the handling of the expiration
interrupt is done in the VM-Exit fastpath with IRQs disabled.  As a result, even
if the host tick interrupt is a hair behind the guest tick, it doesn't affect
accounting because the host tick interrupt will never be delivered while KVM is
emulating the guest's periodic tick.

I'm guessing that if you tested on SVM (or a guest that doesn't use the APIC timer
in deadline mode), which doesn't utilize the fastpath since KVM needs to bounce
through hrtimers, then you'd see similar accounting problems even without using
any of the problematic "slow" timer sources.

