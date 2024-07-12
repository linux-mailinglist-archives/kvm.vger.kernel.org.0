Return-Path: <kvm+bounces-21535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4577C92FEB2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE4991F21F6F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEAD17625D;
	Fri, 12 Jul 2024 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UP/wGOZn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAF91DFD2
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720802395; cv=none; b=Cmh/lwyaw8TuuGpj9jiyxr+mfJfN3lS/jZGdSd8bFXJ1+ub57RA2sgOtcUNLbLjnP7xjGHvX6yGfYwoV4MMP8SMnhBaCfLIh9btfkbanSeuQN6C52AM298QSPS4XWMORH4iJ9a1POruBsNv/wkY+c1k1l3rpXN1hvb+4dwWi3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720802395; c=relaxed/simple;
	bh=NyiSbcM1rTexBAEnny3Rf9lt6i7KHOMibVfbUQWL4T8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mg4hvO6N6czjA/xAo1+6LSGRwcll6Gd0CKuvs58x3UYUD/HMfcHoILrWwfnf5eo1VQ1UxLXNy6AgW1hpetBjIiQDtPWRtvG2zq38gHmMKSKryYsgodJHB3Ld/AEgaLJj+Z3PV0rA1mxO60MZvacDrqK0hdWfoN/O8dHgUuo2MWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UP/wGOZn; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-71cdcb122e8so1631300a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720802394; x=1721407194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VOpJsgkd3hcFqJUFGnNriyibA3tO4cNVay9D3pRzbAo=;
        b=UP/wGOZnkuNa6Y7PsWltfflgUTFLu7bMWEB49kYpwpzdrs9TaVPaOAcGcCTlkZ1rSQ
         2UsQNFYo62IuUvQtRrTgY1bIPa6roH1wF4YDvm/H1jHLwu4k7v+dr5501DAmtErpyrDS
         s5h4jkGfm32WerXW/0LHgnOWAd+ArdKT+vaaND4tRojnK6AAnHp10bqYYTvz2dVljO/e
         5D7HMJFW3yE8iv0tLCd+JicwAI3bACEXgxPnGrQrH6WNGRyvJ1yNr6753v6BD1kUL9GF
         v42WUt77EU4rPIfg+I9ENtEWvaIOKmU6GBxdrkEnD19a/h5zfCZMHXmgXwRlmstFxXrG
         cERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720802394; x=1721407194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VOpJsgkd3hcFqJUFGnNriyibA3tO4cNVay9D3pRzbAo=;
        b=XO6f+U7EVK1+5Mjx1NFiSsWxi7sY603l9RNzzffgE4Y/j/+LGe22jJ5KFzj9Gm2Vit
         +g97FgGsFAVK+JWmDQ71fmPnTA2QtXTxJ/yMkmQ82BbVfFzQ0YzcvHSyraknZmhKz6yL
         MSEyCRfK1v0EVP1c0PvdAzxohiPYTXLdfYh/iDdfuk3prLrt/4HoSA7XzKBrpx6M7ldj
         HixFxqWCrkbYJPPYd9g0jcz0KR70UYU/Rdkyz7rBzXMB8+Eo9GnlEFO90qWxnqCmZWVg
         P/qQxp+HfTPmVNJtco430fZIHCVO2FYFphGPuQNwsya/lgrh3IGWJG/UUwJi5MqjqfzK
         lS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW60OyCFtEEKAukCi243lHlctQ+xejrsd/EvgLCBnc0REZ7G/LjosRheXkQJnv3Cjed6nDZtjr+sTl9sSlRZeaHyKR0
X-Gm-Message-State: AOJu0YxclDrEndWIuOFHzvxtwkY33QSB8MsFJeA//hWlmZ+SHqIVIvu/
	SkJK+vx+AzqiYds/vpgVuf0CHi4ErdMr6wqQojmBgXTwWDVE7Y/LyFki8ZZ2gaikefKoJPZZR1W
	12w==
X-Google-Smtp-Source: AGHT+IFxX57sH+caCD2BoexXTa4tIQrGtEuX2fO1g8bcR/ViSOg8bApfeyrGePNyAltf6poECpZMgXRM2aE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:495:b0:5dc:2d1c:43c6 with SMTP id
 41be03b00d2f7-77dbd49a35fmr29061a12.9.1720802393570; Fri, 12 Jul 2024
 09:39:53 -0700 (PDT)
Date: Fri, 12 Jul 2024 09:39:52 -0700
In-Reply-To: <20240712123019.7e18c67a@rorschach.local.home>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <ZpFCKrRKluacu58x@google.com> <01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
 <20240712123019.7e18c67a@rorschach.local.home>
Message-ID: <ZpFcWPMwEOQchvCB@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	graf@amazon.com, drjunior.org@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, Steven Rostedt wrote:
> On Fri, 12 Jul 2024 11:32:30 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > >>> I was looking at the rseq on request from the KVM call, however it does not
> > >>> make sense to me yet how to expose the rseq area via the Guest VA to the host
> > >>> kernel.  rseq is for userspace to kernel, not VM to kernel.  
> > > 
> > > Any memory that is exposed to host userspace can be exposed to the guest.  Things
> > > like this are implemented via "overlay" pages, where the guest asks host userspace
> > > to map the magic page (rseq in this case) at GPA 'x'.  Userspace then creates a
> > > memslot that overlays guest RAM to map GPA 'x' to host VA 'y', where 'y' is the
> > > address of the page containing the rseq structure associated with the vCPU (in
> > > pretty much every modern VMM, each vCPU has a dedicated task/thread).
> > > 
> > > A that point, the vCPU can read/write the rseq structure directly.  
> 
> So basically, the vCPU thread can just create a virtio device that
> exposes the rseq memory to the guest kernel?
> 
> One other issue we need to worry about is that IIUC rseq memory is
> allocated by the guest/user, not the host kernel. This means it can be
> swapped out. The code that handles this needs to be able to handle user
> page faults.

This is a non-issue, it will Just Work, same as any other memory that is exposed
to the guest and can be reclaimed/swapped/migrated..

If the host swaps out the rseq page, mmu_notifiers will call into KVM and KVM will
unmap the page from the guest.  If/when the page is accessed by the guest, KVM
will fault the page back into the host's primary MMU, and then map the new pfn
into the guest.

