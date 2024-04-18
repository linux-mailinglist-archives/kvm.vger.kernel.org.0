Return-Path: <kvm+bounces-15171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C398AA4A9
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 043E62819C3
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D3B194C96;
	Thu, 18 Apr 2024 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m0Fe3erW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3132F30
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713475285; cv=none; b=VGvzJEQ+ySJ+JgctDlNWH8GcoPqqGoGej4bCLm+4RD6BoocIa9k0Tc7upknE+yzrIevkta7cz0V6mH5D5vdVy8lr67R/r39j8eF6Kgg0MTjnXe71U0JpRDARjAdeQZEtskED1uFqUgVvJc0AfJcDhO+IAVfMeyEk0JWGE2z1syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713475285; c=relaxed/simple;
	bh=y2QgvTIQc5YxNGACMLJ77qipzbYe9QndhuNBBIXYMJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtq0PXQUeMJCeS84ZPl7o7UPSYJs3eyDG5xHjwdXqGZ50SKFVgkbGJ6gibG3RU3LdiDlizJuvhdaYFarXB6wibojGTeplctgyzAE/5tLaTzqofo+w+UGzsbqsd7oGLse89ZusRJy93HFOh0F6YS7s+AI3uuseli7qeSLBIdgLoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m0Fe3erW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e853131a9cso9099575ad.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713475284; x=1714080084; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5sgNP1y4Gb7YIm3QO4qpq0MpsRY6PlbBal0iGG5g8TU=;
        b=m0Fe3erW80A0CZwax3+DZGtrz17LHgBCbAF3txTrP0Mp+hUTAyi28mDkbR3ZwgTYuu
         2zpZJp+DWq9V/9gQS55SPHJtB3d+m3pkATKeQoATbOyqVOrD5CejTJnBRx4au/u0PybW
         60r3Mwrohm1pJ15h2nPfR7ZQE4NjnK/PlIO9AD23WqML7lj6fk0Zgcqsw4J/K+eIcUBI
         JmUvRuFES2nMRnLyMo8lCyQTNb5xv9i+pkUgutzfLj/oji8LN6OEmmZ+MapcGSy7G5GM
         5z0GXL3ihzmz7EpK4BnG+whlkQwBaZWnsi1VtlSvqH8nKDyg9VDKOZXczQCvyEnf95qm
         xmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713475284; x=1714080084;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sgNP1y4Gb7YIm3QO4qpq0MpsRY6PlbBal0iGG5g8TU=;
        b=WOmngkb8KLIrwsqIh+6yMoVhL3mJlaLrJ2ugTjADpB66A3+8XU/+m7XsMZ4mFS124f
         +5HaHr1rbucayMDHK9Ea3nHp3TmMvihkpPCdIzHIS+CGc3TI1DKGISyvHQxNcoJkaHSn
         sQjCn01jXEoqmNtr+j0hoKlLskDSyvyIp60mlhyd7nIwsDGKk/r3FDnZBoYH6LjbiX+H
         h/T2G55+GQn4mvpMeBvKvrambW9YCnYdUBwE3wu8eJrpRTge+TeWR9Pwha7MgG46jBsK
         aDpQ6m9RInJ9j/LiHq9beE+EnTziXw+nv2NMIdJsn46bz8DEcn7QX4LYyG7KeoaoEkCH
         /FdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLBIIGWSYebpBbTc8/+od4VyRZR6CIldFANCg7zLika7mS6zgX6HV84lTxPNxCAR1NrYkksejIBfmvCyOiEG7bPA1v
X-Gm-Message-State: AOJu0YxhWXIDFXbZjtckvoxxlPUGU2wCrKEqe4vyMnHmf51mqaMMh6FG
	GeVudnzfXTogcsmnmzLtNPg7r524GjBiC97/6EBzV9C/AoDxfBXJ7xzUKDVIDQ==
X-Google-Smtp-Source: AGHT+IGX5dXWK+/OuDV3SnGTkiNhOLMg+CP/zOhDyYHin5mNvqs8Y6muo/1+IDVrLzHgXecxX918Dw==
X-Received: by 2002:a17:902:6b42:b0:1e4:4ade:f504 with SMTP id g2-20020a1709026b4200b001e44adef504mr248052plt.46.1713475283392;
        Thu, 18 Apr 2024 14:21:23 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b001e79072ee58sm2028346pla.62.2024.04.18.14.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 14:21:22 -0700 (PDT)
Date: Thu, 18 Apr 2024 21:21:18 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
	jmattson@google.com, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of
 PMU state for Intel CPU
Message-ID: <ZiGOzkLhQm57EPlx@google.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zh1mKoHJcj22rKy8@google.com>

On Mon, Apr 15, 2024, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> > On Mon, Apr 15, 2024 at 3:04 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
> > > On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> > > > On Fri, Apr 12, 2024 at 9:25 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
> > > >>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed counters.
> > > >>>> Considering this case, Guest uses GP counter 2, but Host doesn't use it. So
> > > >>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be enabled
> > > >>>> unexpectedly on host later since Host perf always enable all validate bits
> > > >>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> > > >>>>
> > > >>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
> > > >>>>
> > > >>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
> > > >>> values to the host? NO. Not in cloud usage.
> > > >> No, this place is clearing the guest counter value instead of host
> > > >> counter value. Host always has method to see guest value in a normal VM
> > > >> if he want. I don't see its necessity, it's just a overkill and
> > > >> introduce extra overhead to write MSRs.
> > > >>
> > > > I am curious how the perf subsystem solves the problem? Does perf
> > > > subsystem in the host only scrubbing the selector but not the counter
> > > > value when doing the context switch?
> > >
> > > When context switch happens, perf code would schedule out the old events
> > > and schedule in the new events. When scheduling out, the ENABLE bit of
> > > EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
> > > and PMCx MSRs would be overwritten with new event's attr.config and
> > > sample_period separately.  Of course, these is only for the case when
> > > there are new events to be programmed on the PMC. If no new events, the
> > > PMCx MSR would keep stall value and won't be cleared.
> > >
> > > Anyway, I don't see any reason that PMCx MSR must be cleared.
> > >
> > 
> > I don't have a strong opinion on the upstream version. But since both
> > the mediated vPMU and perf are clients of PMU HW, leaving PMC values
> > uncleared when transition out of the vPMU boundary is leaking info
> > technically.
> 
> I'm not objecting to ensuring guest PMCs can't be read by any entity that's not
> in the guest's TCB, which is what I would consider a true leak.  I'm objecting
> to blindly clearing all PMCs, and more specifically objecting to *KVM* clearing
> PMCs when saving guest state without coordinating with perf in any way.

Agree. blindly clearing PMCs is the basic implementation. I am thinking
about what coordination between perf and KVM as well.

> 
> I am ok if we start with (or default to) a "safe" implementation that zeroes all
> PMCs when switching to host context, but I want KVM and perf to work together to
> do the context switches, e.g. so that we don't end up with code where KVM writes
> to all PMC MSRs and that perf also immediately writes to all PMC MSRs.

Sure. Point taken.
> 
> One my biggest complaints with the current vPMU code is that the roles and
> responsibilities between KVM and perf are poorly defined, which leads to suboptimal
> and hard to maintain code.

Right.
> 
> Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak guest
> state to userspace processes that have RDPMC permissions, as the PMCs might not
> be dirty from perf's perspective (see perf_clear_dirty_counters()).
> 

ah. This is a good point.

		switch_mm_irqs_off() =>
		cr4_update_pce_mm() =>
		/*
		 * Clear the existing dirty counters to
		 * prevent the leak for an RDPMC task.
		 */
		perf_clear_dirty_counters()

So perf does clear dirty counter values on process context switch. This
is nice to know.

perf_clear_dirty_counters() clear the counter values according to
cpuc->dirty except for those assigned counters.

> Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes the
> overall code brittle because it's not clear whether KVM _needs_ to clear PMCs,
> or if KVM is just being paranoid.

There is a difference between KVM and perf subsystem on PMU context
switch. The latter has the notion of "perf_events", while the former
currently does not. It is quite hard for KVM to know which counters are
really "in use".

Another point I want to raise up to you is that, KVM PMU context switch
and Perf PMU context switch happens at different timing:

 - The former is a context switch between guest/host state of the same
   process, happening at VM-enter/exit boundary.
 - The latter is a context switch beteen two host-level processes.
 - The former happens before the latter.
 - Current design has no PMC partitioning between host/guest due to
   arch limitation.

From the above, I feel that it might be impossible to combine them or to
add coordination? Unless we do the KVM PMU context switch at vcpu loop
boundary...

Thanks.
-Mingwei

