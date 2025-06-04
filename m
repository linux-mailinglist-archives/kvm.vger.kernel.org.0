Return-Path: <kvm+bounces-48446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFB8ACE54B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 21:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52630189B4DD
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 19:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C940921127E;
	Wed,  4 Jun 2025 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ex9WFUgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EED1F1306
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749066119; cv=none; b=JWO2fN27zcGWOTUQMUFrH+CF25UM8wYEDu1XfXSgPZX+FNSoV/CF2TPqy0eJwESDzKM6kmpfRmGKzpILoYct0WmmS0LndY7rAzVRFoR4x7C5OB25EBUCxcb0r/bbwq29+Fr6RI1KZgiyErt78xWdxsZAX2Y4Mg9CcXzldp3ZX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749066119; c=relaxed/simple;
	bh=t3wSXYBkjlehkX5lWu8cJOqFYjeaQGOpLs2AS4zGdbM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rP0posoWxQrAFj1BHJNDbAZig5Kbt+uMU8DQFREKU9L52hRsqgVfbmt0ttVOkd6y2WBfemdEEn/jCZ4UTCSF8rc1s3fg/d95WTDebnLSr/KoN2RCY2zm8w8RJ6f5Vzbs6njpWhJsHuXFnDk7CK9M4RGrQGtsjw9cEXm/egIbszc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ex9WFUgC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2323bd7f873so1323325ad.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 12:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749066117; x=1749670917; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3diDbLbvr/LUz49hBfYHo+54bP4JvSURlF5GHPdQ8y0=;
        b=Ex9WFUgCzUoM1NY7aaWPsSb3AItgj9qgdGRsCFEUoG8OYW3GOf0pKnYIzFIJEDLrJy
         DoVHCqnt1TFAnnB2V0VnDyCQcsx+L4kilFr5c1IxAXh/wijtZ8osdJyXufrbbEEes1Cf
         7aDRYTtfSsANdPAb9Hp1Ecs5lWXcCCdElSz+TAcbMlBRaZPzPBBVnTc7EDYEM4W16P9B
         kG5yW/oe8B1zFY9JwUB5I4DziRBjmoriqA/BdJvBzLg+XE7cqiLT0AvV/Gjrk4ffrAg0
         VKDgtRbYiJCtS0xP/7PQltSje5TZ8GaIue9h6I3f7ARbdMZrpXveTt0rV9pTfVoMO3jR
         Uf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749066117; x=1749670917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3diDbLbvr/LUz49hBfYHo+54bP4JvSURlF5GHPdQ8y0=;
        b=MQWEk33ooPKK+JVh/rb7y4xbwhNcyMjbdHhmWYwLYp/kEXGj1BcDLiITO2ECyr2W5m
         2ahBjwCgMZckhKFRqx76qrUc6Ts7sWaLkeYvZInhZr3FfvMERTBxOjtwdIn5NwQquQlO
         u/z/LdneYQWdPxDNc97G04LHB1az1j2Fvm/d1Yi+CZr33H5XoY5iQUeockFCVJrcZZ21
         wV+ISU+D6gipHY7GXj8vaux5smDLVvmBd1j8WSz8lirBq9nlXGpHIA+e/9mtPvvQ7ZX+
         cTG2p4KnFkHpUnfXyOwJoE89mOKrnb6qmIDWrIWZ6D0WsAsYBglFxAZP8UgHAIE7vtgG
         q7gw==
X-Forwarded-Encrypted: i=1; AJvYcCUjIk4wdN1AQYD3HoDQRZCw8SEg4wKpjj1CjGsShJKp6VjT+jEb1Undzc6iDvsf87rEpy0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7PVoP1GNN1/d011QuAwLIg3g6VSSIonivfiXM+pBn4fJ4nxln
	VA1lOrB2+uEApBqFiDUeGexvYQhGHkx0KRg6xjDW+GBinxyXUTmv3xabhuWQIH3QeI33IVDGNcG
	Z4GHUjg==
X-Google-Smtp-Source: AGHT+IFW8yLlA8p2DrXdU2JHIH6NqaBjRlFhs7ymyfC+op+u+0gr9J70yXiW6GcVSRpI4WyvcqOubZElkvM=
X-Received: from plps1.prod.google.com ([2002:a17:902:9881:b0:234:b3fc:8229])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:6c7:b0:235:e76c:4353
 with SMTP id d9443c01a7336-235e76c45bamr27063665ad.51.1749066116846; Wed, 04
 Jun 2025 12:41:56 -0700 (PDT)
Date: Wed, 4 Jun 2025 12:41:55 -0700
In-Reply-To: <917b478e-14f3-437f-a748-0fdf423e9db7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523090848.16133-1-chenyi.qiang@intel.com>
 <aD-DNn6ZnAAK4TmH@google.com> <917b478e-14f3-437f-a748-0fdf423e9db7@intel.com>
Message-ID: <aEChg7jMQKG3Zm6-@google.com>
Subject: Re: [kvm-unit-tests PATCH] nVMX: Fix testing failure for canonical
 checks when forced emulation is not available
From: Sean Christopherson <seanjc@google.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 04, 2025, Chenyi Qiang wrote:
> 
> 
> On 6/4/2025 7:20 AM, Sean Christopherson wrote:
> > On Fri, May 23, 2025, Chenyi Qiang wrote:
> >> Use the _safe() variant instead of _fep_safe() to avoid failure if the
> >> forced emulated is not available.
> >>
> >> Fixes: 05fbb364b5b2 ("nVMX: add a test for canonical checks of various host state vmcs12 fields")
> >> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> >> ---
> >>  x86/vmx_tests.c | 5 ++---
> >>  1 file changed, 2 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> >> index 2f178227..01a15b7c 100644
> >> --- a/x86/vmx_tests.c
> >> +++ b/x86/vmx_tests.c
> >> @@ -10881,12 +10881,11 @@ static int set_host_value(u64 vmcs_field, u64 value)
> >>  	case HOST_BASE_GDTR:
> >>  		sgdt(&dt_ptr);
> >>  		dt_ptr.base = value;
> >> -		lgdt(&dt_ptr);
> >> -		return lgdt_fep_safe(&dt_ptr);
> >> +		return lgdt_safe(&dt_ptr);
> >>  	case HOST_BASE_IDTR:
> >>  		sidt(&dt_ptr);
> >>  		dt_ptr.base = value;
> >> -		return lidt_fep_safe(&dt_ptr);
> >> +		return lidt_safe(&dt_ptr);
> > 
> > Hmm, the main purpose of this particular test is to verify KVM's emulation of the
> > canonical checks, so it probably makes sense to force emulation when possible.
> > 
> > It's not the most performant approach, but how about this?
> > 
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index 2f178227..fe53e989 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -10881,12 +10881,13 @@ static int set_host_value(u64 vmcs_field, u64 value)
> >         case HOST_BASE_GDTR:
> >                 sgdt(&dt_ptr);
> >                 dt_ptr.base = value;
> > -               lgdt(&dt_ptr);
> > -               return lgdt_fep_safe(&dt_ptr);
> > +               return is_fep_available() ? lgdt_fep_safe(&dt_ptr) :
> > +                                           lgdt_safe(&dt_ptr);
> >         case HOST_BASE_IDTR:
> >                 sidt(&dt_ptr);
> >                 dt_ptr.base = value;
> > -               return lidt_fep_safe(&dt_ptr);
> > +               return is_fep_available() ? lidt_fep_safe(&dt_ptr) :
> > +                                           lidt_safe(&dt_ptr);
> >         case HOST_BASE_TR:
> >                 /* Set the base and clear the busy bit */
> >                 set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);
> 
> The call of is_fep_available() itself will trigger the #UD exception:

Huh.  The #UD is expected, but KUT should handle the #UD

Gah, I thought it was working on my end, but it's not.  I just got a triple fault
instead of a nice error report, and didn't notice the return code (was running
manually).

Oh, duh.  Invoking is_fep_available() when restoring the original host value for
the IDT will triple fault due to IDT.base being 0xff55555555000000.

Hmm, that doesn't explain how you managed to get a stack trace though.  Can you
test the series I cc'd you on?  If it still fails, then something entirely
different is going on.

> Unhandled cpu exception 6 #UD at ip 000000000040efb5
> error_code=0000      rflags=00010097      cs=00000008
> rax=0000000000000000 rcx=00000000c0000101 rdx=000000000042d220
> rbx=0000000000006c0c
> rbp=000000000073bed0 rsi=ff45454545000000 rdi=0000000000000006
>  r8=000000000043836e  r9=00000000000003f8 r10=000000000000000d
> r11=00000000000071ba
> r12=0000000000436daa r13=0000000000006c0c r14=000000000042d220
> r15=0000000000420078
> cr0=0000000080010031 cr2=ffffffffffffb000 cr3=0000000001007000
> cr4=0000000000042020
> cr8=0000000000000000
>         STACK: @40efb5 40f0e9 40ff56 402039 403f11 4001bd
> 
> Maybe the result of is_fep_available() needs to be passed in from main()
> function in some way instead of checking it in guest code.

Ya, it's past time we give KUT the same treatment as KVM selftests and cache the
information during test setup.  setup_idt() is the obvious choice.  I already
posted a series (I meant to send this first, but got distracted).

Nit, this isn't guest code per se, because these writes are all in the "host",
i.e. in L1 (which is obviously _a_ guest, but not _the_ guest from these test's
perspective).

