Return-Path: <kvm+bounces-42559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E77F5A79FC0
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AB3B1715AA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 09:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB85124394F;
	Thu,  3 Apr 2025 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R7PPy4Pz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C28423F406
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 09:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743671535; cv=none; b=Xw+tKL0YdXCUC5J8bxQPw2HkIf495abX/KSwnoRk4PKObABTPTCknkrUmEjq07V8adKCjHbL8zz7VI61vsI/VaylCwAxU5rabp0nNv3ijvUm9EYpQyC4IwD/SHzayLlFipRINtg8k4ppLFqVII0wsjjuw1tp0bcNEARnboEnrCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743671535; c=relaxed/simple;
	bh=4I+t3ED2JlxRgHqOSJQ0g9j54xiswy965vMM34XaE0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LEvI+wGAYT5Fz9BZ3IcQ4sy5+wQJRwB+fdTehx523iIcTfLvC3YhscwEp4Gh6+G7P3FyircqaMXQ2Epj0LA08iTlXt1tgWnJO1ChwpFSB2g44RknY1KISYaxBOSYMdWRZNQiCiyREvHr6hEK3x/bWA/L57PGqJOfPDGhp1c3umo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R7PPy4Pz; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47681dba807so445361cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 02:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743671532; x=1744276332; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1rELpBSWL93L3Qmf+liKQ1Tp2n48zGMk1GGe66iVP+M=;
        b=R7PPy4PzS+5Xmo9khu43PLZJf4oAN+bq8lBjEcRZruy01etYcx1uxsv5HN40MyfUoi
         8wzA0cHE1tcdtBz8LBEmSRoA/rmr5tZdAtfxi23jWpNiuoHvQZ0z8j2cIpPImyNqG+mA
         XOZeOlBnGB8plpHR54/dmmdx8Z/RmJ82TboWpB5hGPX9F4CqRX39wlnJn8GqvaPcPGZG
         T3oMqNX1hxFF2RFQDSpT2BXY1AauC/mxGHWKYfJ/uS/NiobxfkppvheBwND9zF6xRL74
         aUswnfLQUQiMfyKnVzG+Ns6phIguMuWH9V010+wnjetqxXmR7LTif0z2HCN3P3a80JOy
         w7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743671532; x=1744276332;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1rELpBSWL93L3Qmf+liKQ1Tp2n48zGMk1GGe66iVP+M=;
        b=KXL72AQd26ro7sJFt2KSlVm6b3JJP0GfQtmqxrFmp7DGZ1ZRJ8Rt4bYeTITsbXTb28
         EQyMPCeerkqosCZZo40x57Xeb7l6UJEBBA4NrrbWarQYRwuauKrsqDE6Ft9qLscpqR1T
         CEurPU15H1g6joF0+DAuz4XGMI8qDF0Oz4XxVxw4kgZaudmlBzRDHY5Z/EFlC2ZC/Ul+
         VK8XZwIWt0XyZIfmSzIzLtLczYotALMKCkHEJqsP8kijgZx+6gc39k//eNJQMSG2gfZs
         VvYe+wrm0rHzVORfJcSjeweiXoDDft74u+SpaLrLw8w4YuHomzkPupP5RiaV5dUbkgdP
         OptQ==
X-Gm-Message-State: AOJu0YxkaaCkj18k9ArywHCroVvhmxIZXM8sDmW5KmaKjIlBZMadJjn5
	SQV+O7qy1lgyvZ0E1Wjq1PfJkZ3ZA0YyL7T/erzB0snYjBABHVT7UGZv+ovdzS5rW3DS++Gw5/f
	uLyWo3N1bh1Joa7ZpywLqhoBIqNPUueRnZoT2
X-Gm-Gg: ASbGncsrYCoxXRRs6vhdGukSZEHa+WBfYPMqP8f3BRsazMMQMZx5Sp5HGN4B+rJ1WQ5
	nqAP2kDwj9yAJ5VwttmIMjofi3pgBKt1V4Nd7mPLwNUQof2UxHe5C/4sZOUQ+idH8cOmIYAVUaV
	D8lHsAzRKV/HZMizZNHdmSZ6nqiQ==
X-Google-Smtp-Source: AGHT+IF4kB/s8i4c362AwdMhGDuPZE+D+p2vRBRf7BHqtiFd9OfQwqafmM0EeecgzM5iuPWsFOuwMPvjcSoPhbtGT8I=
X-Received: by 2002:ac8:5a42:0:b0:477:635f:5947 with SMTP id
 d75a77b69052e-479173d0113mr4311361cf.12.1743671531715; Thu, 03 Apr 2025
 02:12:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com> <20250328153133.3504118-5-tabba@google.com>
 <Z-3UGmcCwJtaP-yF@google.com>
In-Reply-To: <Z-3UGmcCwJtaP-yF@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 3 Apr 2025 10:11:34 +0100
X-Gm-Features: ATxdqUG7hBVR0ezJ2edx0j_xRZWbit9EU8tds0KDQYa61k5NbMo-Btr_n-OwScA
Message-ID: <CA+EHjTzSe_TMENtx3DXamgYba-TV1ww+vtm8j8H=x4=1EHaaRA@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and
 functions that manage their transition
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Thu, 3 Apr 2025 at 01:19, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Mar 28, 2025, Fuad Tabba wrote:
> > @@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
> >  }
> >
> >  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > -static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > +/*
> > + * An enum of the valid folio sharing states:
> > + * Bit 0: set if not shared with the guest (guest cannot fault it in)
> > + * Bit 1: set if not shared with the host (host cannot fault it in)
> > + */
> > +enum folio_shareability {
> > +     KVM_GMEM_ALL_SHARED     = 0b00, /* Shared with the host and the guest. */
> > +     KVM_GMEM_GUEST_SHARED   = 0b10, /* Shared only with the guest. */
> > +     KVM_GMEM_NONE_SHARED    = 0b11, /* Not shared, transient state. */
>
> Absolutely not.  The proper way to define bitmasks is to use BIT(xxx).  Based on
> past discussions, I suspect you went this route so that the most common value
> is '0' to avoid extra, but that should be an implementation detail buried deep
> in the low level xarray handling, not a
>
> The name is also bizarre and confusing.  To map memory into the guest as private,
> it needs to be in KVM_GMEM_GUEST_SHARED.  That's completely unworkable.
> Of course, it's not at all obvious that you're actually trying to create a bitmask.
> The above looks like an inverted bitmask, but then it's used as if the values don't
> matter.
>
>         return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);

Ack.

> Given that I can't think of a sane use case for allowing guest_memfd to be mapped
> into the host but not the guest (modulo temporary demand paging scenarios), I
> think all we need is:
>
>         KVM_GMEM_SHARED           = BIT(0),
>         KVM_GMEM_INVALID          = BIT(1),

We need the third state for the transient case, i.e., when a page is
transitioning from being shared with the host to going back to
private, in order to ensure that neither the guest nor the host can
install a mapping/fault it in. But I see your point.

> As for optimizing xarray storage, assuming it's actually a bitmask, simply let
> KVM specify which bits to invert when storing/loading to/from the xarray so that
> KVM can optimize storage for the most common value (which is presumably
> KVM_GEM_SHARED on arm64?).
>
> If KVM_GMEM_SHARED is the desired "default", invert bit 0, otherwise dont.  If
> for some reason we get to a state where the default value is multiple bits, the
> inversion trick still works.  E.g. if KVM_GMEM_SHARED where a composite value,
> then invert bits 0 and 1.  The polarity shenanigans should be easy to hide in two
> low level macros/helpers.

Ack.


> > +/*
> > + * Returns true if the folio is shared with the host and the guest.
>
> This is a superfluous comment.  Simple predicates should be self-explanatory
> based on function name alone.
>
> > + *
> > + * Must be called with the offsets_lock lock held.
>
> Drop these types of comments and document through code, i.e. via lockdep
> assertions (which you already have).

Ack.

> > + */
> > +static bool kvm_gmem_offset_is_shared(struct inode *inode, pgoff_t index)
> > +{
> > +     struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     unsigned long r;
> > +
> > +     lockdep_assert_held(offsets_lock);
> >
> > -     /* For now, VMs that support shared memory share all their memory. */
> > -     return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> > +     r = xa_to_value(xa_load(shared_offsets, index));
> > +
> > +     return r == KVM_GMEM_ALL_SHARED;
> > +}
> > +
> > +/*
> > + * Returns true if the folio is shared with the guest (not transitioning).
> > + *
> > + * Must be called with the offsets_lock lock held.
>
> See above.

Ack.

> >  static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>
> This should be something like kvm_gmem_fault_shared() make it abundantly clear
> what's being done.  Because it too me a few looks to realize this is faulting
> memory into host userspace, not into the guest.

Ack.

Thanks!


/fuad

