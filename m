Return-Path: <kvm+bounces-43330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1097FA89567
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D05F0177A75
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 07:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB1427F727;
	Tue, 15 Apr 2025 07:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q4JPAz/b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634F72741D2;
	Tue, 15 Apr 2025 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744702940; cv=none; b=OyCoGr5Q0VvlK5CLXdWnIsGvgOgNiBTJI0TEVzd/agtmR/fAtS3Q2zwkahWyk2+HJaJRHId9l8Yl0UDL1psofKILup7qmlYAezeUfh3d7FzefwwKd0J59aAAQviKj7ghwVYktrugubnBXuGsASsQHZDfyjg/cVa565XfknhVWCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744702940; c=relaxed/simple;
	bh=2ghFJ/WoNNJtx50ePbwntOjD68huaKDwuNVZLJOMKkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4fcqVGJEpDzbBnAQh0ESVxI1ZQaPGRH/AXfS+s8aKzo8ZG0pdvcGaNiddZCSeU2hlUpdROyzFdUqrNS01hn2Hrdn11wnVsJ/nSmrmuv9AF+/7ryoYJQ3XcejB4vynDt70xWIn8v0sk49OAa2qRzW1naSRq0euhHRf1WwJprzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q4JPAz/b; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30c416cdcc0so46690411fa.2;
        Tue, 15 Apr 2025 00:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744702936; x=1745307736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58EGUTXtUxIy6cjRPhm4Aku8724XI9vW76TExXikKn0=;
        b=Q4JPAz/b+0iSs7uRpEigR5sV+xhPAcJ3XKQxwcJf3AM1SmTU9D1qCQvEpxkQSd4GrN
         ehnYQScs8xv28ONpr9+iOU+WNkVOJ8G4Wf9U/XdCkmU9EyVfKsweAJUAcwRh/OuSiaKj
         XSIKyeS1/Zgv9psRSUmYkWj8Sg4Qfv1xWc4OtZCGCdmd0bQW0CaiqkR6BR5nYNnPnYSg
         zX0DulEJuznod0lZsG6Yz5n50E8he/N0PeIkEYGw2PFF4oItRZrzSpiXtGcmbdGT/to3
         r4Hm/fkApd+RkDdDG8GOLmgsxTTTFGwGZCjzCKYzIp1Lqm5Sox2Fn+NooeaJQV0ssQuP
         K/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744702936; x=1745307736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58EGUTXtUxIy6cjRPhm4Aku8724XI9vW76TExXikKn0=;
        b=tUW5LXfSVx5AWOxBoWamsVAfCI0cN5BCgP+OXw1k5s7/Lmf4q9knphBj2xJ1Kp5tx9
         s7P5GtfFdOTDepdtauSACnnJSKfhhrfssuLEgK+7C7BAq0v9C3oCKSEzhAESjzsQ12PG
         WQD8SN8F7QGB3jwtlRB/oeP1hGquLaRbLxRmDKqKDm3ffe2n0V0HjM8X7MaB83+FyvUh
         CZAn0Xt+mHnaTl6qT+wzf2kh3GEHs/UtUv4oD0/vupc++P+ftBnVpP/VxQ5cnoAXMUoE
         cSaJ3map51HdVkvH9yqOys2R0bV1e4cOQPVUGDc8Hun9zsnpRmCMO1svlWfK4P6qvbHC
         aoKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWATbN9hadiG+7wBLXUXXJ1HN9E8yIZCkEZRLeX3epIB0xNblDtrJDLpYG2+rNj/M4iNf14gv4B7Be27qk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiVTfxkCENzzuvJn4kfzntwifCxoLXRnjmv+Tv9hFee0TbAGr1
	6jKvcowMye+oRa39Ou4uy6WowPp6BYGQT0gw+kw066HUav1TOJr1fjkMUHvDrmOAKCKeb9NKuaW
	neVtEh/luoWP0F3aOM2sECxlHEXU=
X-Gm-Gg: ASbGnctKqdyEPwB/O6o5s73JEWmad1d2v/lvoiCSIrtchp9kFiME2eWy+rUMpNzuvOE
	KiSa2W1RFNDyWY/BdJmXuqfWOK2VNfLBKYlJ2EDaE6Wt/Kc9nyryAmEhDG0yNX8fyeqC24IeZpo
	ySctwzdYPKEsZvdTKnQJ178g==
X-Google-Smtp-Source: AGHT+IFqY2Ai6W20JnTL0J8N86I8549zpNUihb226F0nRPPDMlA56u8QLiP98AvL2JxttrEV2EWptz6FoxXQQSG+a78=
X-Received: by 2002:a2e:a908:0:b0:30c:3099:13db with SMTP id
 38308e7fff4ca-310499f92e8mr40275881fa.14.1744702936159; Tue, 15 Apr 2025
 00:42:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414081131.97374-1-ubizjak@gmail.com> <20250414081131.97374-2-ubizjak@gmail.com>
 <Z_2w7XJ0LI65qo0i@google.com>
In-Reply-To: <Z_2w7XJ0LI65qo0i@google.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 15 Apr 2025 09:42:03 +0200
X-Gm-Features: ATxdqUGEjkAZMYpBZa78JeCKlM_WaZfMUf7VqCOpDC_-0YmnSnUCybmBVKcILT0
Message-ID: <CAFULd4argBdTBM7m7U1Q-RMJdyYtAfOD08ukGn+JsT-v4Z6NrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Use LEAVE in vmx_do_interrupt_irqoff()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2025 at 3:05=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Apr 14, 2025, Uros Bizjak wrote:
> > Micro-optimize vmx_do_interrupt_irqoff() by substituting
> > MOV %RBP,%RSP; POP %RBP instruction sequence with equivalent
> > LEAVE instruction. GCC compiler does this by default for
> > a generic tuning and for all modern processors:
>
> Out of curisoity, is LEAVE actually a performance win, or is the benefit =
essentially
> just the few code bytes saves?

It is hard to say for out-of-order execution cores, especially when
the stack engine is thrown to the mix (these two instructions, plus
following RET, all update %rsp).

The pragmatic solution was to do what the compiler does and use the
compiler's choice, based on the tuning below.

> > DEF_TUNE (X86_TUNE_USE_LEAVE, "use_leave",
> >         m_386 | m_CORE_ALL | m_K6_GEODE | m_AMD_MULTIPLE | m_ZHAOXIN
> >         | m_TREMONT | m_CORE_HYBRID | m_CORE_ATOM | m_GENERIC)

The tuning is updated when a new target is introduced to the compiler
and is based on various measurements by the processor manufacturer.
The above covers the majority of recent processors (plus generic
tuning), so I guess we won't fail by following the suit. OTOH, any
performance difference will be negligible.

> > The new code also saves a couple of bytes, from:
> >
> >   27: 48 89 ec                mov    %rbp,%rsp
> >   2a: 5d                      pop    %rbp
> >
> > to:
> >
> >   27: c9                      leave

Thanks,
Uros.

