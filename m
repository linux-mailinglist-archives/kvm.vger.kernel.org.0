Return-Path: <kvm+bounces-17194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDC58C2855
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09EBD1C23009
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341C017278D;
	Fri, 10 May 2024 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GGrQgTA0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F82171E69
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715356753; cv=none; b=RwdP7FUdubsQPxiQ8bRemQfBjQdP8cPmSY+5owHBacGcZOgf3AcF+ojVYTzzEhln6JHp0VcQFzk7sDr8C15Q04O4RFCR2DmbYwXyHOwzGA94qSMuEGCeYIBfNPUyTrQC+FxtrYQEbPGt45XEBk9WHgb4+4Np7//iiGfiDe46S+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715356753; c=relaxed/simple;
	bh=wOvswIgcj7A85/iWWRMpGp1HmKr+2AtLRKfC8hiX6pE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GkR6ANFiuRNKdC6C2WJV/7HYPa3KcQPtlmGb4C6uk6q4KykHmZHvbHfajUjXelSq8LzgDhXOqIcJWlZkNxg+F+9dfP0jp4KUYunjkd+rOfZN+Oc6Jf/2Ocn1v3MbQsP4P0WyjrPx2JdPvltoVZ6g6QiLJu3w8wqFpE1DmHay5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GGrQgTA0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be621bd84so35450507b3.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715356751; x=1715961551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u5ISVPYL6PmEyuY/FQRwjKLZdHccDsXxGbSGsjEmQJk=;
        b=GGrQgTA0UokjBsx21Vr1X12GgMRrPPoQuIS8yL8EuO4JT0Sm/qISP7XrbN/VmB72eM
         BvlMClqH9p/cCjGOrw86v//5cjMgPcWsECWnorwcbAxsu/JxBSDa185rowjTR6orz5vj
         TfV9TYwJsJnhDfWEW9jHfpK26T2Ir1sXEpmZMGvMxS/ZujB3zmu+n18L3EjqYJQZfL/A
         rH/pdGoFM5iVv2fvIAlh3mrhPRGHmGzN//YM2e8g0OFY76PLjjTWisdaWwc/wqtVs8Po
         otRzkX8KZqNUDTcQQsLV/oDmqf3yYq7G4L+SSRsXhrWX30D9s9T9WxWhNiJ68Bbq49y2
         xHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715356751; x=1715961551;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u5ISVPYL6PmEyuY/FQRwjKLZdHccDsXxGbSGsjEmQJk=;
        b=EKucmOcccoKzSbzOmB4fMA7lSv+u1AGw+snFYlNcyPyuk7NPsbVAMC29gp7gd4AUba
         nvg8F38ARqur5lrQDVaNO14t31hgPmFPASxc1LYPDJ8V4UZHoKgiT9XJ4SkqrRSaED5x
         ndnKw1/kJVHUXG8M5ZWZZZU5T2lIzBISyrY3xV4qT9uX553aT+QBZXRROijpD3xwXBSZ
         1+mVcygZY/vLxkzZJJ3iiq3o2nQ/PIUyKBNwV5BxewmfJ0a/w7I6xbTHWP49DNs+iw2A
         WYRbfTEygGbp8xb+rm7ns1s360EcjeO5dUENfp1MpZV4AmgyX6bAiIp6LNRCf2+7+pH2
         HuUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwzKPwQqpzw3bUuhb9QDr8VWyemZfgyvpSviYUhCTotTzRaMBlEKMVO3nJ3mPwaBVd3iwyjSFAg0czxtXn8IDCwbwt
X-Gm-Message-State: AOJu0YwKMFqaCMJoSro+9u1+JgDynrWXIZxlEdauUMEXcgQBR7Sy6VL5
	Psej00BVlVNBgXDoPrMTTU7eInpRG18DI3xMmYtgc3TednpBL57+t/v7DSAgx8ne1PrTlprsJ63
	ZuQ==
X-Google-Smtp-Source: AGHT+IEX/OuQG0ZhfJrRj7k8BAEO/RM7nxjVnIQb2HXfQAss9M//0E1w+F9Y0UfoI1zSWZuVX2x+Zkq5Z94=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1006:b0:dc6:c94e:fb85 with SMTP id
 3f1490d57ef6-dee4f1b1019mr242036276.2.1715356750717; Fri, 10 May 2024
 08:59:10 -0700 (PDT)
Date: Fri, 10 May 2024 08:59:09 -0700
In-Reply-To: <20240510152744.ejdy4jqawc2zd2dt@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <Zj4lebCMsRvGn7ws@google.com>
 <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com> <20240510152744.ejdy4jqawc2zd2dt@amd.com>
Message-ID: <Zj5ETYPTUo9T4Nuf@google.com>
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private memslots
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024, Michael Roth wrote:
> On Fri, May 10, 2024 at 03:50:26PM +0200, Paolo Bonzini wrote:
> > On Fri, May 10, 2024 at 3:47=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > > +      * Since software-protected VMs don't have a notion of a shar=
ed vs.
> > > > +      * private that's separate from what KVM is tracking, the abo=
ve
> > > > +      * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid t=
he
> > > > +      * special handling for that case for now.
> > >
> > > Very technically, it can occur if userspace _just_ modified the attri=
butes.  And
> > > as I've said multiple times, at least for now, I want to avoid specia=
l casing
> > > SW-protected VMs unless it is *absolutely* necessary, because their s=
ole purpose
> > > is to allow testing flows that are impossible to excercise without SN=
P/TDX hardware.
> >=20
> > Yep, it is not like they have to be optimized.
>=20
> Ok, I thought there were maybe some future plans to use sw-protected VMs
> to get some added protections from userspace. But even then there'd
> probably still be extra considerations for how to handle access tracking
> so white-listing them probably isn't right anyway.
>=20
> I was also partly tempted to take this route because it would cover this
> TDX patch as well:
>=20
>   https://lore.kernel.org/lkml/91c797997b57056224571e22362321a23947172f.1=
705965635.git.isaku.yamahata@intel.com/

Hmm, I'm pretty sure that patch is trying to fix the exact same issue you a=
re
fixing, just in a less precise way.  S-EPT entries only support RWX=3D0 and=
 RWX=3D111b,
i.e. it should be impossible to have a write-fault to a present S-EPT entry=
.

And if TDX is running afoul of this code:

	if (!fault->present)
		return !kvm_ad_enabled();

then KVM should do the sane thing and require A/D support be enabled for TD=
X.

And if it's something else entirely, that changelog has some explaining to =
do.

> and avoid any weirdness about checking kvm_mem_is_private() without
> checking mmu_invalidate_seq, but I think those cases all end up
> resolving themselves eventually and added some comments around that.

Yep, checking state that is protected by mmu_invalidate_seq outside of mmu_=
lock
is definitely allowed, e.g. the entire fast page fault path operates outsid=
e of
mmu_lock and thus outside of mmu_invalidate_seq's purview.

It's a-ok because the SPTE are done with an atomic CMPXCHG, and so KVM only=
 needs
to ensure its page tables aren't outright _freed_.  If the zap triggered by=
 the
attributes change "wins", then the fast #PF path will fail the CMPXCHG and =
be an
expensive NOP.  If the fast #PF wins, the zap will pave over the fast #PF f=
ix,
and the IPI+flush that is needed for all zaps, to ensure vCPUs don't have s=
tale
references, does the rest.

And if there's an attributes race that causes the fast #PF to bail early, t=
he vCPU
will see the correct state on the next page fault.

