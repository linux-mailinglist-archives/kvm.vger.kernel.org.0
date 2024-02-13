Return-Path: <kvm+bounces-8634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32308853AFA
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5613D1C23D1F
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 19:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDFA60879;
	Tue, 13 Feb 2024 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jon8VBr0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D267604C9
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852753; cv=none; b=qHyoTgs/CMEMiIVAAkrAmjTYS9qYXvQmLkpHHcFhKDQZ/H/qRncBbW4l6BicZjtxp/AkUFiHshQnF56cDNpAVfZNnzqhS3NyfP+3kNl+6amz/fjopAkSvqjHP96J4T66rJZ7ZB6eeacBE7oTLjeF4lQS9V2y6lIyJ8Y9E9zEzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852753; c=relaxed/simple;
	bh=t3pGuIMAeZfDG+Nm+EbDi25ksSmaX2ngcVn9XDu9vc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eh2xR/Leb7gwul8yBW5PEr/UqRGQ7pexfQlthkfRpuR+ZWOq4CZCGBasKX6l8d9DIpIoKFNQS65Tg9OXvY0lgM7rkpFYFSfHYtPpesa8BjhTV78ZufsN7oNDysbz6XFvTHq8CEdhOq2No28v3VAGrU0lXFDdPipw71vg5ZVF3JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jon8VBr0; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5986d902ae6so2587597eaf.3
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 11:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707852750; x=1708457550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rymEGgxm+55ne6xbo9ccaE33zwysrx5gpeBPKrQKGdo=;
        b=Jon8VBr0D6ju45gTv6XMepJF/4uvhaXJFN4QH7qdemSPI8KmcMK5IuCRTLNyays/tJ
         9AFTAXQT1qGBPccP66akBXjjgBeKl0UeU5pdl0nletZLRQ0ei6QAWs1eryZ0hNef5ePy
         NKh8ZQCrCoMJyT6A1LUohs6AQo6jkfv15hRovL/RxaZhYFBN3g9gOcrD0cwJUvXmRxR6
         M8/Xm3EFH5wCqA7ZEOk54ny0WoErixLYQjFeLnUFepTHEOrKm5r6IAIr+CmA41OE2pRl
         Z2h3Md9XQyHCZ6IBMw9BY+XtLZEK4Mjt2VaesN9JEB9obK2yI4sKSaIkNSdn2/q8hl0x
         9nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852750; x=1708457550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rymEGgxm+55ne6xbo9ccaE33zwysrx5gpeBPKrQKGdo=;
        b=rz+1h9Z920zN92X5v1pElA9iQ5Hk1fV2agGxA18jOD7pl9KAvvo/2n5v7MEKmvtB+L
         5f/GSipJEhon/TaBKXIZaUe3qEz9Oj1wR4PuLN4GNffpWambFt5joRSQyWw7crjhzxcc
         x6TWnxyu1k1521R0iVup14NUSqIHKZrLcPpi4E7ETxaF3V+mfpPrFejcIdmfECI6NhxJ
         mVzBs400QwMbL0T570riyqjxnk9gImBd2FChsPJHm08ZLFMjNWu17M1qmH9nyAkAYCjR
         O52exjfcfyBIvciYJ6zO7MWKKC/52CUK6d+0CrW1n1iC8ppz+toy/WB301qtMIVQ2PsM
         rZFA==
X-Forwarded-Encrypted: i=1; AJvYcCW7cMgDRmP2Gspp650lyJmpP/KJOYCITeCNDskZ5FwbLxK6RgDjL1/LHAHEXWKGNDmhtiDpXn/vepuJ/7UY2qOiOOf8
X-Gm-Message-State: AOJu0YyY060ke7Nbn8Fm5Gsg2cdK+vgt8moQztP1YiJLaT+OqVn2B3mN
	maopmn3cBZ9V/HEHy/b17NE0h9oC+Fr8UrgmTnNh1rhl7J46Xu0bCMSK9v1oPbf+yPgfsH0npzW
	0nMzAzic7U45K4FdjMS4x0Vmru0vuVlcYoeuw
X-Google-Smtp-Source: AGHT+IEp5DLRKl4WmMWFKz448wdqBHqEkoU9rO21Ie/NNxREpveSx1dNQrQHhbxeUkU/xxk6YvLS5sKAohRXRmJrsWE=
X-Received: by 2002:a4a:e615:0:b0:59d:d416:3372 with SMTP id
 f21-20020a4ae615000000b0059dd4163372mr582997oot.0.1707852750038; Tue, 13 Feb
 2024 11:32:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206153405.489531-1-avagin@google.com> <ZcujIJemLxhjnjfN@google.com>
In-Reply-To: <ZcujIJemLxhjnjfN@google.com>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 13 Feb 2024 11:32:18 -0800
Message-ID: <CAEWA0a78GhJ1FUmk7JX-kCKTCD2vjvzNoBbFODV6BJeu=1mKLg@mail.gmail.com>
Subject: Re: [PATCH v2] kvm/x86: allocate the write-tracking metadata on-demand
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 9:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 06, 2024, Andrei Vagin wrote:
> > The write-track is used externally only by the gpu/drm/i915 driver.
> > Currently, it is always enabled, if a kernel has been compiled with thi=
s
> > driver.
> >
> > Enabling the write-track mechanism adds a two-byte overhead per page ac=
ross
> > all memory slots. It isn't significant for regular VMs. However in gVis=
or,
> > where the entire process virtual address space is mapped into the VM, e=
ven
> > with a 39-bit address space, the overhead amounts to 256MB.
> >
> > This change rework the write-tracking mechanism to enable it on-demand
> > in kvm_page_track_register_notifier.
>
> Don't use "this change", "this patch", or any other variant of "this blah=
" that
> you come up with.  :-)  Simply phrase the changelog as a command.

ok:)

>
> > Here is Sean's comment about the locking scheme:
> >
> > The only potential hiccup would be if taking slots_arch_lock would
> > deadlock, but it should be impossible for slots_arch_lock to be taken i=
n
> > any other path that involves VFIO and/or KVMGT *and* can be coincident.
> > Except for kvm_arch_destroy_vm() (which deletes KVM's internal
> > memslots), slots_arch_lock is taken only through KVM ioctls(), and the
> > caller of kvm_page_track_register_notifier() *must* hold a reference to
> > the VM.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Andrei Vagin <avagin@google.com>
> > ---
> > v1: https://lore.kernel.org/lkml/ZcErs9rPqT09nNge@google.com/T/
> > v2: allocate the write-tracking metadata on-demand
> >
> >  arch/x86/include/asm/kvm_host.h |  2 +
> >  arch/x86/kvm/mmu/mmu.c          | 24 +++++------
> >  arch/x86/kvm/mmu/page_track.c   | 74 ++++++++++++++++++++++++++++-----
> >  arch/x86/kvm/mmu/page_track.h   |  3 +-
> >  4 files changed, 78 insertions(+), 25 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index d271ba20a0b2..c35641add93c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1503,6 +1503,8 @@ struct kvm_arch {
> >        */
> >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >       struct kvm_mmu_memory_cache split_desc_cache;
> > +
> > +     bool page_write_tracking_enabled;
>
> Rather than a generic page_write_tracking_enabled, I think it makes sense=
 to
> explicitly track if there are *external* write tracking users.  One could=
 argue
> it makes the total tracking *too* fine grained, but I think it would be h=
elpful
> for readers to when KVM itself is using write tracking (shadow paging) ve=
rsus
> when KVM has write tracking enabled, but has not allocated rmaps (externa=
l write
> tracking user).
>
> That way, kernels with CONFIG_KVM_EXTERNAL_WRITE_TRACKING=3Dn don't need =
to check
> the bool (though they'll still check kvm_shadow_root_allocated()).  And a=
s a
> bonus, the diff is quite a bit smaller.
>

Your patch looks good to me. I ran kvm and gvisor tests and didn't
find any issues. I sent it as v3:
https://lkml.org/lkml/2024/2/13/1181

I didn't do any changes, so feel free to change the author.

Thanks for the help.

