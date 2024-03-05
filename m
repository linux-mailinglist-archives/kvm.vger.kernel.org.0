Return-Path: <kvm+bounces-11014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83399872300
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E16DAB24784
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 15:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F407127B56;
	Tue,  5 Mar 2024 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jlZu5C6k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E671272CB
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709653191; cv=none; b=VbZH0AIg8GLCyfSdZoH4wjWPQUhEV5MIIa+VG59G/zo0612rwdNmItmEVVcs3xfubzioCOhYwSawu9UKGDWl2Qr5RAWhtP4fwNVpLlqVJ6fBABmoRjTjdwCjZ+hG0IhgPjk8Ng3WHK/y0alKcB8W4OLhcHZ2jlsyFKle8TUFeXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709653191; c=relaxed/simple;
	bh=SOPn+LGQ9aR4zkLvr2256Iz/ahqbcnZ+Gq/iOGSyy2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MenLt+yzLNgjl0RPjyna9rnrVdYF74USXv33GO1WxTNWiRAzLgmBlxkbkJL0unnBnBXJoRuFbaGX5YjpYCW42nsmOMNXvdwXYJg3ePlbtc4ROgq7PgUWaxatXJi1urMTHoTYtmcJD4E61lapWPYmt80vLF8vuqzXGE+V4l4UyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jlZu5C6k; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e4d0e28cd1so4540350b3a.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 07:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709653187; x=1710257987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y2+QNZsGB7vBwDONJtQuDYHORz8pvCTwyrAobu/LpG4=;
        b=jlZu5C6k5LxtyLnNTSTKymf8mcYdyMWflQMoQUBoBMD2hoVgd7eCZJ4pL4TB5FuAXm
         aqdZ3VessrMYhLlJSdMHC/qunSzSIC5w0YXVV5h1oFF7tuALUT2dVrRg+LhNndYvLM+s
         SO5HH7Gf1FqTS8vFGBioJDXbLU9Rgqb5NU6iYp6sJJbS9f+iSIWAphBILwonL+wdux6m
         Kf/6CyIfes7oLmwj8pIrbwI0W7CGFh6E0XMbkhVePHct7eLlPXUPJxcZCtGDpdGSr88m
         YjXsauu6LZMlH3Szf2jR59L5ybEote6/wPz2CdTYWYihYJapQRUUmhK4AaZDOUKrSSPO
         DliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709653187; x=1710257987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y2+QNZsGB7vBwDONJtQuDYHORz8pvCTwyrAobu/LpG4=;
        b=jwaga6yUsonzSfTy9Tj08POyxEMmoPd2mK5tT8qol0dZAKRmLUHYkFgx3Lgnzd9OgG
         WIG1PE0zrIp/U0akfSLe0PfyyeMf4e6KaQldExdS/lRIyBsNhbYNFWQb+gVqMdD4V01y
         0K6z7Zn5+MaUaXEuzK0c6JuKrXGISYylRzrv2oJfEHssecTF7aqy+vKa+9G66UOCCKwa
         JJ63mJf/BNL3HYYuYssGOZX1elFVqfKRFF47Sip6GKNfdyacgZgc5SuNN3ne8OCHz+j+
         PCrQySy4Raax2ckPa9m0jDdmmvSN0UeOlVL2K+7ADXqyW+ErCjLWAMPxlK5vu+gg2G2S
         Oybg==
X-Forwarded-Encrypted: i=1; AJvYcCULDcRuCldQasll1qLeN1tb7ia2Atl38wIjei+cMp+qKSwPPv1yQaKHDNLsQPTS8yRt18qWFoqDrACJPSdUwuGeh5o+
X-Gm-Message-State: AOJu0YxG93SX7sYRliOYtzyJPRqdE1FOcnPrWkuTrgbD5zXm8RXmQNVr
	+cvgjztqY1a853bsOV4cqIQ3kqtXiNhhP6sEXAKTiqcWg27MwpuzXkB8ZTFxBjZPCurRGnnLWW8
	xlA==
X-Google-Smtp-Source: AGHT+IEWf/wnSiieRPHpf8VMzJDEgUGq3r1WyDXmi+v8L/+r4DjFPQtsJOt6QRXW5vzBjW64rgvLCTl6NVQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8d1:b0:6e5:d02:6162 with SMTP id
 s17-20020a056a0008d100b006e50d026162mr95902pfu.0.1709653187173; Tue, 05 Mar
 2024 07:39:47 -0800 (PST)
Date: Tue, 5 Mar 2024 07:39:45 -0800
In-Reply-To: <ZeZu9D3Ic_1O5CIO@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev> <ZeYqt86yVmCu5lKP@linux.dev> <ZeYv86atkVpVMa2S@google.com>
 <ZeY3P8Za5Q6pkkQV@linux.dev> <ZeZP4xOMk7LUnNt2@google.com> <ZeZu9D3Ic_1O5CIO@linux.dev>
Message-ID: <Zec8stHiFS3KOOPt@google.com>
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Oliver Upton wrote:
> On Mon, Mar 04, 2024 at 02:49:07PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > The presense of MTE stuff shouldn't affect the fundamental access information,
> 
>   "When FEAT_MTE is implemented, for a synchronous Data Abort on an
>   instruction that directly accesses Allocation Tags, ISV is 0."
> 
> If there is no instruction syndrome, there's insufficient fault context
> to determine if the guest was doing a read or a write.
> 
> > e.g. if the guest was attempting to write, then KVM should set KVM_MEMORY_EXIT_FLAG_WRITE
> > irrespective of whether or not MTE is in play.
> 
> When the MMU generates such an abort, it *is not* read, write, or execute.
> It is a NoTagAccess fault. There is no sane way to describe this in
> terms of RWX.

RWX=0, with KVM_MEMORY_EXIT_FLAG_MTE seems like a reasonable way to communicate
that, no?

> > > > E.g. on the x86 side, KVM intentionally sets reserved bits in SPTEs for
> > > > "caching" emulated MMIO accesses, and the resulting fault captures the
> > > > "reserved bits set" information in register state.  But that's purely an
> > > > (optional) imlementation detail of KVM that should never be exposed to
> > > > userspace.
> > > 
> > > MMIO accesses would show up elsewhere though, right?
> > 
> > Yes, but I don't see how that's relevant.  Maybe I'm just misunderstanding what
> > you're saying/asking.
> 
> If "reserved" EPT violations found their way to userspace via the
> "memory fault" exit structure then that'd likely be due to a KVM bug.

Heh, sadly no.  Userspace can convert a GFN to private at any time, and the
TDX and SNP specs allow for implicit converstion "requests" from the guest, i.e.
KVM isn't allowed to kill the guest if the guest accesses a GFN with the "wrong"
private/shared attribute.

This particular case would likely be hit only if there's a userspace and/or guest
bug, but whether the setup is broken or just unique isn't KVM's call to make.

> The only expected flows in the near term are this and CoCo crap.
> 
> > > Either way, I have no issues whatsoever if the direction for x86 is to
> > > provide abstracted fault information.
> > 
> > I don't understand how ARM can get away with NOT providing a layer of abstraction.
> > Copying fault state verbatim to userspace will bleed KVM implementation details
> > into userspace,
> 
> The memslot flag already bleeds KVM implementation detail into userspace
> to a degree. The event we're trying to let userspace handle is at the
> intersection of a specific hardware/software state.

Yes, but IMO there's a huge difference between userspace knowing that KVM uses gup()
and memslots to translate gfn=>hva=>pfn, or even knowing that KVM plays games with
reserved stage-2 PTE bits, and userspace knowing exactly how KVM configures stage-2
PTEs.

Another example would be dirty logging on Intel CPUs.  The *admin* can decide
whether to use a write-protection scheme or page-modification logging, but KVM's
ABI with userspace provides a layer of abstraction (dirty ring or bitmap) so that
the userspace VMM doesn't need to do X for write-protection and Y for PML.

> > Abstracting gory hardware details from userspace is one of the main roles of the
> > kernel.
> 
> Where it can be accomplished without a loss (or misrepresentation) of
> information, agreed. But KVM UAPI is so architecture-specific that it
> seems arbitrary to draw the line here.

I don't think it's arbitrary.  KVM's existing uAPI for mapping memory into the
guest is almost entirely arch-neutral, and I want to preserve that for related
functionality unless it's literally impossible to do so.

> > A concrete example of hardware throwing a wrench in things is AMD's upcoming
> > "encrypted" flag (in the stage-2 page fault error code), which is set by SNP-capable
> > CPUs for *any* VM that supports guest-controlled encrypted memory.  If KVM reported
> > the page fault error code directly to userspace, then running the same VM on
> > different hardware generations, e.g. after live migration, would generate different
> > error codes.
> >  
> > Are we talking past each other?  I'm genuinely confused by the pushback on
> > capturing RWX information.  Yes, the RWX info may be insufficient in some cases,
> > but its existence doesn't preclude KVM from providing more information as needed.
> 
> My pushback isn't exactly on RWX (even though I noted the MTE quirk
> above). What I'm poking at here is the general infrastructure for
> reflecting faults into userspace, which is aggressively becoming more
> relevant.

But the purpose of memory_fault isn't to reflect faults into userspace, it's to
alert userspace that KVM has encountered a memory fault that requires userspace
action to resolve.

That distinction matters because there are and will be MMU features that KVM
supports, and that can generate novel faults, but such faults won't be punted to
userspace unless KVM provides a way for userspace to explicitly control the MMU
feature.

And if KVM lets userspace control a feature, then KVM needs new uAPI to expose
the controls.  Which means that we should always have an opportunity to expand
memory_fault, e.g. with new flags, to support such features.

