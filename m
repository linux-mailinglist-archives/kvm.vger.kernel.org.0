Return-Path: <kvm+bounces-59452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FBCBB5E34
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 06:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D66B43B56BD
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 04:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6A11DDA18;
	Fri,  3 Oct 2025 04:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0D0OdrM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC413B5AE
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 04:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759464663; cv=none; b=rTCsuJyvhsFt/7jLYVqI6G5XQe39AOE7j+8mLxnmg1M160LHbRI/fXgb8jdXry6JAVUZifQNyAAt7Wa9JNwuEhRbzESigKT/g87LpLPVUpMRySacAFU+GxhgL1P2xG0jzX9oGvkRkUjw3juY7Hl5GlB93zbRK2uk555VuAcPioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759464663; c=relaxed/simple;
	bh=eVBkbicYfUS69zmXZwGScVgBjkX4ywDap9nKzw7qfn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRM0PcKc8j4nvynyXc9xg195STOXHudnquYcMO9sl8ZDcMLa4sjpAUldYA0xKQCFE8x+W3phL9awGrgfinqGk4T5dmAQRKwi0X+prnwq2fj3bBEi2567StxhLoN+tYn4ZXyqpJEaNW/9YW2bDTgkZlJQjvfxDsdAnI7dcTkckQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0D0OdrM1; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2731ff54949so66575ad.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 21:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759464661; x=1760069461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHileCyWFvqrnsJtGJmQTYrzCSDzQ+tsFRyGMq0mpjI=;
        b=0D0OdrM1a/997bk14sb3f3bP21VvD+SYdWraTCKiPjbLZjGsDSXVBuXqNWOcv+nDKm
         WN8Od3hJtOmyDBukRGJXm99UZVOeeRR+X+2bR3jBEM/RtQ0ulSvtJRtT5m0O4J0GwmYX
         FdYYBI7yGotDE9HXSO833YHhMo+FEBsf4r5tAwTcj3ZU1+P4AEqsm1UtSqYkXfWaX/7H
         5zbB8sUw9fk1TFKys/zmJarnT2SFxtNxiUP3UjGVcuDwWKgoV8T8IYYCpmNesqemWaKJ
         bqZ9hhNoK97qSx9EEFwLRk6BGF9FwFReG3yBe/u0ZvvgxdGLGDfD7UZ8rNABCGfWH9BF
         LE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759464661; x=1760069461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHileCyWFvqrnsJtGJmQTYrzCSDzQ+tsFRyGMq0mpjI=;
        b=lILs2UkrKgUyg+RV6wrxL1ccHBTUICYKq/h+ZVzVCoSjZq+4bPsIENf4lPl4r9CD4G
         Ya7uP9DorG5y0niiwkYtURjvSMqrGhHs0APTAjmSgyQwXvB9AagNptbq/3sGeZe3XsSD
         bLree9bj62gkuFzD9omuXv/BH070OSS0EATCT+XKMWgsgO3M20g2fSl/KekopExvNOT8
         NAslH4n5fzn5TpfP1BnRCS7xR7ONgl3nJLZc/0e9YpAsQewauqDdiWvIpGyEvDxkdMUX
         gs6JW5Wi+ez/ztzm6ZQeRi4xlUqUTCR5k9rzxnoMIrRmkgs7PpNFCLfxhd4a/V48Rpy/
         zklQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZYiopNUdnQps84PfD/9djCa1eYBwKjnLIf4xF8ZggLUs7PE3B5RU5EeXCLarnJB/OOMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHoQaxI3Cck3UArxwmX1fcysoZ+VFlCUIgoVEaHu6grCqW3oYE
	jwGkyaT2ESyxjVP7OddFq6Biw+QhXNdPWm5uj7nRwbeec5ARn1P5Q/mUS353rQPrU1POqcdzbep
	9ubAa05BfQJdQbfZSyGU9yhEZ0AdOJrmhXM9sk1jj
X-Gm-Gg: ASbGnctpAlCKlAH1x/edik9VqwVd+KkWXgRQLq6qYR39CwVWDE6MFr2BCs4fCb8Ddmw
	a/zSK/UkVgBL1TXHWRDQzweB3S4LF3MnhLd1hUhOw4/yKZhYh52qwP93KBFDF3D/6vySPo2dChv
	f28d0s7tKsBnH2anzc8HSK3LOkBbmG2rAyWRaSk9keHIXoCFrp4fZrMTnylhf16WlqSCnVgDqOs
	DilcX+5L6wd7iEZLMcXVyKi8+G37ZckmWv/ne4zQqp6BK/gAPfl7uLgGlGhdxKvIbllgpa7acsr
	5eidDamDR7T/6PW2
X-Google-Smtp-Source: AGHT+IHPipI7f7+0LmbKbo0br5cLROhYyCuwYa8jxFK9Utg+UC8bSHsA2NvxO345vgpNxAFol02yZNP34RoqslUvDYo=
X-Received: by 2002:a17:902:fc47:b0:25b:fba3:afb5 with SMTP id
 d9443c01a7336-28e9b6652afmr1597195ad.11.1759464660289; Thu, 02 Oct 2025
 21:11:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqz4isl351g.fsf@google.com> <aNq6Hz8U0BtjlgQn@google.com>
 <aNshILzpjAS-bUL5@google.com> <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com> <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
 <aN3BhKZkCC4-iphM@google.com> <CAGtprH_evo=nyk1B6ZRdKJXX2s7g1W8dhwJhEPJkG=o2ORU48g@mail.gmail.com>
 <aN8U2c8KMXTy6h9Q@google.com>
In-Reply-To: <aN8U2c8KMXTy6h9Q@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 2 Oct 2025 21:10:47 -0700
X-Gm-Features: AS18NWBjHqxZe1m6JZGxiteyrQIhhisQfpcPLSI4NNl0brqgjW-7yIA5_fBP6VU
Message-ID: <CAGtprH9N=974HZiqfdaO9DK9nycDD9NeiPeHC49P-DkgTaWtTw@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, Shivank Garg <shivankg@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 2, 2025, 5:12=E2=80=AFPM Sean Christopherson <seanjc@google.com=
> wrote:
>
> > >
> > > If the _only_ user-visible asset that is added is a KVM_CREATE_GUEST_=
MEMFD flag,
> > > a CAP is gross overkill.  Even if there are other assets that accompa=
ny the new
> > > flag, there's no reason we couldn't say "this feature exist if XYZ fl=
ag is
> > > supported".
> > >
> > > E.g. it's functionally no different than KVM_CAP_VM_TYPES reporting s=
upport for
> > > KVM_X86_TDX_VM also effectively reporting support for a _huge_ number=
 of things
> > > far beyond being able to create a VM of type KVM_X86_TDX_VM.
> > >
> >
> > What's your opinion about having KVM_CAP_GUEST_MEMFD_MMAP part of
> > KVM_CAP_GUEST_MEMFD_CAPS i.e. having a KVM cap covering all features
> > of guest_memfd?
>
> I'd much prefer to have both.  Describing flags for an ioctl via a bitmas=
k that
> doesn't *exactly* match the flags is asking for problems.  At best, it wi=
ll be
> confusing.  E.g. we'll probably end up with code like this:
>
>         gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
>
>         if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
>                 gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
>         if (gmem_caps & KVM_CAP_GUEST_MEMFD_INIT_SHARED)
>                 gmem_flags |=3D KVM_CAP_GUEST_MEMFD_INIT_SHARED;
>

No, I actually meant the userspace can just rely on the cap to assume
right flags to be available (not necessarily the same flags as cap
bits).

i.e. Userspace will do something like:
gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);

if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
        gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB)
        gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB | GUEST_MEMFD_FLAG_HUGETLB=
_2MB;

Userspace has to anyways assume flag values, userspace just needs to
know if a particular feature is available.

> ...
> Another issue is that, while unlikely, we could run out of KVM_CAP_GUEST_=
MEMFD_CAPS
> bits before we run out of flags.

I would say that's unlikely as I know of at least one feature that
needs multiple flag bits.

>
> And if we use memory attributes, we're also guaranteed to have at least o=
ne gmem
> capability that returns a bitmask separately from a dedicated one-size-fi=
ts-all
> cap, e.g.
>
>         case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>                 if (vm_memory_attributes)
>                         return 0;
>
>                 return kvm_supported_mem_attributes(kvm);

For this one, we need a separate dedicated cap.

>
> Side topic, looking at this, I don't think we need KVM_CAP_GUEST_MEMFD_CA=
PS, I'm
> pretty sure we can simply extend KVM_CAP_GUEST_MEMFD.  E.g.
>
> #define KVM_GUEST_MEMFD_FEAT_BASIC              (1ULL << 0)
> #define KVM_GUEST_MEMFD_FEAT_FANCY              (1ULL << 1)
>
>         case KVM_CAP_GUEST_MEMFD:
>                 return KVM_GUEST_MEMFD_FEAT_BASIC |
>                        KVM_GUEST_MEMFD_FEAT_FANCY;

This scheme seems ok to me.

>
> > That seems more consistent to me in order for userspace to deduce the
> > supported features and assume flags/ioctls/...  associated with the fea=
ture
> > as a group.
>
> If we add a feature that comes with a flag, we could always add both, i.e=
. a
> feature flag for KVM_CAP_GUEST_MEMFD along with the natural enumeration f=
or
> KVM_CAP_GUEST_MEMFD_FLAGS.  That certainly wouldn't be my first choice, b=
ut it's
> a possibility, e.g. if it really is the most intuitive solution.  But tha=
t's
> getting quite hypothetical.

