Return-Path: <kvm+bounces-12491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E00886EB0
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 15:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D1E2285963
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 14:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02748481C2;
	Fri, 22 Mar 2024 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K+YiBeQK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7D947A57
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711118082; cv=none; b=jjoL5XgUtbdrkFJhkaUq6oLDOMd/Kll3GCVGEU4w9x9GpZ97AqVW8TbIONx/SWhy2I03sWgRwUY64uD84WxjFDMA+YKzA44G0tMARg49Ujvv65IYn9xH9iPvFq9kyZRqSMS5i8VZ2bsJ+ozaM9DgIPsbGf9BtsgTR55BuOi4I2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711118082; c=relaxed/simple;
	bh=oQUQ9KkHO+Cn50yZmTu0a39sPxYSY6quGUNWqBxBzKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci4GPyGnp+EAl4aNKMLdmXcIczvliKYTzbeIjdFoJ7n7c3Jz48mEt3JxHEchGNboJnUw6e8rgJjoCnVm2RzTEiTVyL068TaVU86jr31TAYUxlCG1RQ8CvZ1bkMbDLJvNx70XzFfeytT6nlVL8yvthO1FS3z68SPTOQg5+seV3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K+YiBeQK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a46cc947929so309802266b.1
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711118079; x=1711722879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HazYimjF8xR0j5uiuwvoaW7vTpuUwkSCXCP6Apf2dQs=;
        b=K+YiBeQKyX/jE92E46+liK3A4VjlkS15PcoyQtQG5K/amsMQAu/xkQD66YNy3SMuj6
         ouGPu55wh8xDG9pw0AhGa8cuQLfiLSOhMBfclFrtygdk5zWKo0L2c/jqlxIttwNQRa0E
         G7Bu+MXaPy+PnyMjU11SjDIQBT2esNc0N4Apj46lzMMWiHbA3fxB9cabni7QGAZV0Zt7
         a4wWr38kajRBsxKLEzUy86HWqLj4yvnbRJkWoZzwzhZrCtlyMO6nEu1SG13EcKcWFr5+
         wRskfCMTEUw5tr/+8FwgIHjL4IuG83iEKKPXR8SJfb82I0yrTZXbiJCsMOABO5jEUbP8
         zMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711118079; x=1711722879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HazYimjF8xR0j5uiuwvoaW7vTpuUwkSCXCP6Apf2dQs=;
        b=aMqoxG9bV0aFSsNQxs2XnOoY3L+fc3eQrro33KyUW92tXmtBXcuT6lHNzLKqorGSOa
         c87/lIv1ogwwVqYS5LgfbxNVOGM2tYzGtJzAhC6puEequa4D3Jr7FBzf1J4fXfJpMzi9
         PggkuMSHG9/GwpbHluwTQXZSWFn746ZiOaDRvlf8s4MrG90PFab8vu9HnevE0GrjvERI
         D2Gy93C8o2tbNAm9GzSxAHwDTSz/W5rG3cyLI8H90cOQj2ZUR5FbrspHypBRiX/EPyS4
         9NYOHaD1KonpH4jwaDp4LHrLDWnCtFOsC+mubwDSSZCZonlyo5xHj0cP+RIosoMq6iRf
         i3uA==
X-Gm-Message-State: AOJu0YzgqFULrJqBp4BU300vdrlwNf6em4M6BtoLd8WDQPzWNpxY4gDy
	dlzcRGYKUeL6ecv6IKdxmCLE5Nh4Yf07U5cEZT+IaI4cYe6HXfI2K7aAcXGmrA==
X-Google-Smtp-Source: AGHT+IGtReWAu4dOxnsh6dGzLvOkCiUJGth6MQj6uX9nKBz1cC9kFCHUfNkyYYI2Y/RW7tLAF1EQiw==
X-Received: by 2002:a17:907:8690:b0:a47:365f:647c with SMTP id qa16-20020a170907869000b00a47365f647cmr1103902ejc.0.1711118078581;
        Fri, 22 Mar 2024 07:34:38 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id jg4-20020a170907970400b00a4652efd795sm1085122ejc.83.2024.03.22.07.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 07:34:37 -0700 (PDT)
Date: Fri, 22 Mar 2024 14:34:35 +0000
From: Quentin Perret <qperret@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
Message-ID: <Zf2W-8duBlCk5LVm@google.com>
References: <20240319164341.1674863-1-coltonlewis@google.com>
 <Zf2Uo1l0JgBEKRAL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf2Uo1l0JgBEKRAL@google.com>

On Friday 22 Mar 2024 at 14:24:35 (+0000), Quentin Perret wrote:
> On Tuesday 19 Mar 2024 at 16:43:41 (+0000), Colton Lewis wrote:
> > Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
> > runqueue depth. This is so they can be passed through if the runqueue
> > is shallow or the CPU has support for direct interrupt injection. They
> > may be always trapped by setting this value to 0. Technically this
> > means traps will be cleared when the runqueue depth is 0, but that
> > implies nothing is running anyway so there is no reason to care. The
> > default value is 1 to preserve previous behavior before adding this
> > option.
> 
> I recently discovered that this was enabled by default, but it's not
> obvious to me everyone will want this enabled, so I'm in favour of
> figuring out a way to turn it off (in fact we might want to make this
> feature opt in as the status quo used to be to always trap).
> 
> There are a few potential issues I see with having this enabled:
> 
>  - a lone vcpu thread on a CPU will completely screw up the host
>    scheduler's load tracking metrics if the vCPU actually spends a
>    significant amount of time in WFI (the PELT signal will no longer
>    be a good proxy for "how much CPU time does this task need");
> 
>  - the scheduler's decision will impact massively the behaviour of the
>    vcpu task itself. Co-scheduling a task with a vcpu task (or not) will
>    impact massively the perceived behaviour of the vcpu task in a way
>    that is entirely unpredictable to the scheduler;
> 
>  - while the above problems might be OK for some users, I don't think
>    this will always be true, e.g. when running on big.LITTLE systems the
>    above sounds nightmare-ish;
> 
>  - the guest spending long periods of time in WFI prevents the host from
>    being able to enter deeper idle states, which will impact power very
>    negatively;
> 
> And probably a whole bunch of other things.
> 
> > Think about his option as a threshold. The instruction will be trapped
> > if the runqueue depth is higher than the threshold.
> 
> So talking about the exact interface, I'm not sure exposing this to
> userspace is really appropriate. The current rq depth is next to
> impossible for userspace to control well.
> 
> My gut feeling tells me we might want to gate all of this on
> PREEMPT_FULL instead, since PREEMPT_FULL is pretty much a way to say
> "I'm willing to give up scheduler tracking accuracy to gain throughput
> when I've got a task running alone on a CPU". Thoughts?

And obviously I meant s/PREEMPT_FULL/NOHZ_FULL, but hopefully that was
clear :-)

