Return-Path: <kvm+bounces-32325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 837989D5477
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 22:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D675B22570
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4C61D0400;
	Thu, 21 Nov 2024 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x8/WOB1N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DF01C304F
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 21:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732223134; cv=none; b=ky35XfI2Nma1NrxX+0vb2E5iarW09cRkqcm6115LpxmWQaO0SL8WJEufn4In0Xayz9QK7wNIxkesghIEZ5fo3xv1pIscmb+1GHYvk868Liq1/5EPVDk2Nop3IG9k+Av0b/zUVAUztF4YbZOuipY0oTbbkh8feQQNe6wQOvkeCRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732223134; c=relaxed/simple;
	bh=vyjd2G/poPUNHJ7AgfmFwVQ4NgJflJ0Gzqnpxwe2gcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XWx1ptTphIPJZX2Pzh6IwbjvIZM5ljp+/Q07ot4Kp3v+ZegopwOt1szNNH/Sbhv2IZY2pmSVhboF1LUXaAfLw9A4j0ap9ee3/JuoASSnNEwmjvjteW133E0fS1PjUIKnWVHWaRqYN1GHOaRFk+uKzDVZNBLoVQuKYs1gh2ZD/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x8/WOB1N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e479829c8so1502868b3a.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 13:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732223132; x=1732827932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MVK84h+cRkKm7y5j10sbeKMXM6R17PysvQBrN7p5PNc=;
        b=x8/WOB1NHCZ7zRQUcb/LFI5nwstEWasp+R0mWXaFc39GvYOoAM4IS5+2If3oXMCALe
         bVj2zfZ5dsqLIh/XM/7xtHES8y60CmUerJxceDz3Oq+Op4x74gwu3+WxcND12xeRwTI4
         lycW9J2wP4KD+Sql14qgZvEAoe29AOS0Wd2YfWCKJ4n7pBXdCHmh7vHQDgRIaVIY4JAP
         ivvbXPRx/r+F9daUhkYsG9PiDGHgKeuZx04AucxWyiO/G4tUpNTWbHqfx/goVxYTO886
         3M43lPt4YkbDTqihzJkjviLTbBLnZX5ccRjqgIOatgPpzPEn4UTLaIFCgyUR0xqkkNpc
         fc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732223132; x=1732827932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MVK84h+cRkKm7y5j10sbeKMXM6R17PysvQBrN7p5PNc=;
        b=dZnQdHAQ29Sf0kmK3sWv5K7OrV7WWIio4EGtjzZwB3SFnGdU7vCHhCU9tOSUpXlrvj
         NEAThhS+45RzaST7FW8ayS8UUM6OIBoRioOl3PXUCyQxG1a8HFRcYPQb169I3SwbQfr9
         MP/XthBRC+s6XBYGa6x0G2CaaxFOhkkFknPIIjtfTpSTUnx3Ub8hjxtmdhoXyb0afe8f
         96PFo8cspkPAYTkuNLlHdc/RrfTdWVBKEnY/rodKEmrEs98cGiuN+4CA3rh+8t187EOo
         L4+0qY5KXEHHb65D8NvjHoVu9R58MY3WwLnYlSdnBf5xXT1KVvdC7QGT//T7YFRnMfuo
         atMA==
X-Forwarded-Encrypted: i=1; AJvYcCUCcQFwXowcx98qZkPVEzIeM3pj4SeSOfvQv3MkyaLhKB3rlb8TdxE4v8gBP/lJkDP57rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRB6WKXwNk/xyTFEPPpM2aUAARIPlyQ/qw2kdptefN9vMoIBSc
	3GfljFEFBYByyc8+k9TCj1X/a0D9un9hUzSYVJTJxCdwN5ks6GvdroZVJfzKUZdPH2t+R9eBway
	CpQ==
X-Google-Smtp-Source: AGHT+IEZJHOQOby4QohXqqy90JcclwkUdaYqwtd1ld+r6QqFqDnTGy4TzDHLisEZ5MjJRibuGnXEc0/0VMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cb0b:b0:2ea:1a5a:dacd with SMTP id
 98e67ed59e1d1-2eb0e020087mr179a91.1.1732223131841; Thu, 21 Nov 2024 13:05:31
 -0800 (PST)
Date: Thu, 21 Nov 2024 13:05:30 -0800
In-Reply-To: <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118130403.23184-1-kalyazin@amazon.com> <ZzyRcQmxA3SiEHXT@google.com>
 <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com>
Message-ID: <Zz-gmpMvNm_292BC@google.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, peterx@redhat.com, 
	oleg@redhat.com, vkuznets@redhat.com, gshan@redhat.com, graf@amazon.de, 
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es, 
	xmarcalx@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Nikita Kalyazin wrote:
> On 19/11/2024 13:24, Sean Christopherson wrote:
> > None of this justifies breaking host-side, non-paravirt async page faults.  If a
> > vCPU hits a missing page, KVM can schedule out the vCPU and let something else
> > run on the pCPU, or enter idle and let the SMT sibling get more cycles, or maybe
> > even enter a low enough sleep state to let other cores turbo a wee bit.
> > 
> > I have no objection to disabling host async page faults, e.g. it's probably a net
> > negative for 1:1 vCPU:pCPU pinned setups, but such disabling needs an opt-in from
> > userspace.
> 
> That's a good point, I didn't think about it.  The async work would still
> need to execute somewhere in that case (or sleep in GUP until the page is
> available).

The "async work" is often an I/O operation, e.g. to pull in the page from disk,
or over the network from the source.  The *CPU* doesn't need to actively do
anything for those operations.  The I/O is initiated, so the CPU can do something
else, or go idle if there's no other work to be done.

> If processing the fault synchronously, the vCPU thread can also sleep in the
> same way freeing the pCPU for something else,

If and only if the vCPU can handle a PV async #PF.  E.g. if the guest kernel flat
out doesn't support PV async #PF, or the fault happened while the guest was in an
incompatible mode, etc.

If KVM doesn't do async #PFs of any kind, the vCPU will spin on the fault until
the I/O completes and the page is ready.

> so the amount of work to be done looks equivalent (please correct me
> otherwise).  What's the net gain of moving that to an async work in the host
> async fault case? "while allowing interrupt delivery into the guest." -- is
> this the main advantage?

