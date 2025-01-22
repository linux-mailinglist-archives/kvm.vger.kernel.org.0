Return-Path: <kvm+bounces-36296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6217AA19A18
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F9D616A55A
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 21:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9641F1C5D53;
	Wed, 22 Jan 2025 21:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtHVe9Yt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4EC1C3BE6
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 21:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737579748; cv=none; b=IOtWdKsyMzPof44EG7kBj+6trLwinP8n7c/sfygG26v7rZ1mYc97nmRUh6izcInjmXs3Gqev/OoFX7oK9b/mdTiC1Kj1pfe5aiOIz+r7p3rw4clB6qbeMCIfKfgdaX9MGfbJ1edrkbE6snW/aRyzLR9CVDOkk5Ss5vPGBwtM4dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737579748; c=relaxed/simple;
	bh=pLJ/MLuvuagw10c9IniFm4CuSVxD8IIYNjKXFFggoho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GDdenC01xxbbMV+KYmSNcbwtX3MtXpU9sYhO00z5VVEvDoIaOxrvF3gBVAx69j1Qm7n/tn47HLNB/4VPK0wXrWLthRSJplevwLtpN4hAqrqfLXCMxsIJwJv/Pw7xlE3MNGml/4UeJ9KH1gT9p8SfVj4yOy6h22jueSudYTqIVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtHVe9Yt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166855029eso2889325ad.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 13:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737579747; x=1738184547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DicZYtp/EHieoQvK3C/2OykVBIHxoy6pTrroBeARA8Q=;
        b=gtHVe9YtN8b7knBUeVk6zy/So2vQc6v0rQUJp6m6Ne+VmmIyB+Q99Ns0BsQUPgOedc
         +dISGnKuRdC3owI8jRZyN3loRV0hf4/G9ctxaZi77sgv1f7T8b+epKZEp6ZWBtjzhcxt
         lPATKzS7vwDv/Ep1QDdgnoEyN6wWXChtcyBN8A1VAzn9b0cbrB9cf83xc88FvUqWO78i
         7QEfR+V39VSrPBAUGWUrNAFYgM6xvCHeQGThYJEYU1+0JpW8qIZN0k3Cex7ZxX+TsuEI
         Bs9AYJLN9d/3hxukkTOoGra2h2m6ns4o822umqayexFHK41UdlLFfyrIgwRADvN3woFz
         scFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737579747; x=1738184547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DicZYtp/EHieoQvK3C/2OykVBIHxoy6pTrroBeARA8Q=;
        b=xBjE2gzKtFzJieoFYYJjO7pcpoAL7m0LtlDOb0l2Heu872jeSbhbovBcN0rd3+HDt3
         kMKpCcQmZFkzC3u5kl2hUQpaF2gwrkwu8JUYtZMfUqt4pw1ruMixSOgDfY/rcwTnsbWR
         UN60lP55J1KTOCQEBimuI0SSzW1jPHSeG/MqgfPFMqeUsTH87qMnQubbuaeA/8cCi4Ez
         KoCetL89mylnvZLE961LUbUcz7Tc0kGb/RMavCvYH0apP8G2oXaLTH9jBFUSqIOG/PbI
         yuhnU2RKPPXYGP9vdNwnlkYZ8aelI3SlCgfljg/a4w60A97Najn7JN1hGqJVeQOshfCG
         jwvw==
X-Gm-Message-State: AOJu0Yy4RIRq+lOPx1VAMpkB7Udqw6r3p9B8K+yFfpsRn0ZFzMvLDha1
	I2hXPL4CQ8i4LXCuwrYAhnIFKrvDFUgQRaD5NdN/GBqOQfgVmnnezudjOHS/3hrMo8T6I4CWXY7
	xvQ==
X-Google-Smtp-Source: AGHT+IHM2QebG58cNXyhzFMVNZ1kenC/xYWAhyilKflk6S5aKuHiubU8xjxlTDSIV8gXkbMieHxUCIPeVME=
X-Received: from pgbck6.prod.google.com ([2002:a05:6a02:906:b0:8ae:4cf4:372])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:789a:b0:1e6:51d2:c8e3
 with SMTP id adf61e73a8af0-1eb215f52a7mr44525602637.35.1737579746710; Wed, 22
 Jan 2025 13:02:26 -0800 (PST)
Date: Wed, 22 Jan 2025 13:02:25 -0800
In-Reply-To: <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
 <Zx-z5sRKCXAXysqv@google.com> <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
 <Z5BDr2mm57F0vfax@google.com> <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
Message-ID: <Z5Fc4d5bVf5oVlOk@google.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only LBRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 22, 2025, Maxim Levitsky wrote:
> On Tue, 2025-01-21 at 17:02 -0800, Sean Christopherson wrote:
> > On Sun, Nov 03, 2024, Maxim Levitsky wrote:
> > > On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > > > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > > > 
> > > > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> > 
> > ...
> > 
> > > When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update,
> > > although TOS does seem to be stuck at one value, but it does change
> > > sometimes, and it's non zero.
> > > 
> > > The FROM/TO do show healthy amount of updates 
> > > 
> > > Note that I read all msrs using 'rdmsr' userspace tool.
> > 
> > I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
> > assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
> > down to confirm (the code I see on inspecition is gated on at least one perf
> > event using LBRs).  My guess is that there's a software bug somewhere in the
> > perf/KVM exchange.
> > 
> > I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
> > to read/write all LBRs during initialization works with LBRs disabled.
> 
> Hi,
> 
> OK, this is a very good piece of the puzzle.
> 
> I didn't expect context switch to interfere with this because I thought that
> perf code won't touch LBRs if they are not in use. 
> rdmsr/wrmsr programs don't do much except doing the instruction in the kernel space.
> 
> Is it then possible that the the fact that LBRs were left enabled by BIOS is the
> culprit of the problem?
> 
> This particular test never enables LBRs, not anything in the system does this,

Ugh, but it does.  On writes to any LBR, including LBR_TOS, KVM creates a "virtual"
LBR perf event.  KVM then relies on perf to context switch LBR MSRs, i.e. relies
on perf to load the guest's values into hardware.  At least, I think that's what
is supposed to happen.  AFAIK, the perf-based LBR support has never been properly
document[*].

Anyways, my understanding of intel_pmu_handle_lbr_msrs_access() is that if the
vCPU's LBR perf event is scheduled out or can't be created, the guest's value is
effectively lost.  Again, I don't know the "rules" for the LBR perf event, but
it wouldn't suprise me if your CI fails because something in the host conflicts
with KVM's LBR perf event.

[*] https://lore.kernel.org/all/Y9RUOvJ5dkCU9J8C@google.com

