Return-Path: <kvm+bounces-26877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAE6978BAC
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4712F1F23A17
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 23:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BBD185939;
	Fri, 13 Sep 2024 23:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HREQxMe2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692441714C3
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 23:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726268711; cv=none; b=Or9zwc1aZSV2w3jAh/Q+Qr5CDQlHGmgfpM7ajphtT7jtw+w4niNO2nk/WtDwZM6EsQMiSKr8EW+HJgcKaLJw2wy3XMzA7O/1nYONXbU6zb1UaMePovFVYZEkYFKhX/qiDr6YnFVpRU9WL7KexxGeYzAW9nx0peClX+vmiEv1Eo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726268711; c=relaxed/simple;
	bh=A4KpB9cU5hA2OJrw24+7NbE/kxvP7sQ4WJUyXP+ET/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NtOlx+VVVKOEghHYNHpQx81fY6X9/jswcvpVek/+tWtrnh7XEt0wn6Jdpoh0OnTmIAQx3dNZcxGK/JFp1afRkvL+NYzCUUoHPHcECAAfF108drtu2Ct90ijuovR77LOXxApVKTnQgc9QiV0ni0djOrUKsrW4Cz1iHH/gH+rdcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HREQxMe2; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a045f08fd6so85485ab.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 16:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726268708; x=1726873508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/LLgDbhHhmWqLgtuLx+Is8IFl8BXUmoR6QEBZPHG94=;
        b=HREQxMe2YOvL7dGOrCkuWizKLHRdEVXJ5jyN9hTBxlYJdfG1SbD17lJBC3HYaCLNEi
         RPrC2Hp97HV0Udz6LN1NAcbX7ahZZ1t4wqtnbrrEomZotUiNrNWi94Wcr89ijl8Zp8TX
         /CNKv7bQXlX+OIIf6Tu7FjYROQRypk/iUH73J7H69HanfpaibYE5wrBHUbMEPCJM7mkM
         QWosV7QUEYFg0yCKBQHDv0i2tIx9RzW2hEhXNIfM8JrCAg0eXGnewi7eDDm4AXoyU3VF
         4hfIfVOMo3YsRKJFWctaidCW4KgiXQALHB+M0YQOxtd0vhKowvbu0vIURwEaX4fyxZCk
         f9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726268708; x=1726873508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/LLgDbhHhmWqLgtuLx+Is8IFl8BXUmoR6QEBZPHG94=;
        b=fZiDiHPSuPH4oZzid42suP8ueyBJk7WUoV3fi+WQdaixg790GGaDwgYxaAZz4tOrLD
         HESAEYd7e/m+L1t1fl3XWtyHCrqcUJLC/XvreNB/khzJ0jrQLPYOzv1tWT/tfpnCBIpn
         kx3LoaWKsGCA9SsJKQ9wwCVFqOW0ZSvPEEwxjoPfpx80qK4h8GYg/Gk7G8AYbzCAU8Ay
         GUbk/Y2dXWXmI3QkbrpyHMUV8UnjKsbM4Hj1gry6LkbsiAcMHzqLF2iOW84vXRkhT0CS
         PX2lTLaXNm9nuu/IlCrsoejR7NgrgSL3lN8WUH/VP6hMLRMa4o2HjHnBeAopXJPPX9xQ
         h/BA==
X-Forwarded-Encrypted: i=1; AJvYcCVg4T2UVphu7JWo2gwSNIw75HB1B6Fb/9AbMhtlIM7Yo5/ZUiWojkpIuJiLn/z71BIqufw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHTjE9RVI3efVjIJDYpZgp5tVVGnwimBDhR7hXLvsMY1hWfrLO
	AM69e73IW1AS9oSjXmtBmzQN9h6dGo6TiItlXBRQS5xcpyTrRAg6HrThto58rXdX7mTmX5+dRfR
	MSMee76KmUGqX0O3cg5zXJLJwt0vd49TFpgrW
X-Google-Smtp-Source: AGHT+IEIleSuC9f4gGuWQyJzHvX9+AYom/k5UJhlK6XKH0GPjZ6+sUYNxj5lfl0DNvWlKL7g+sgn2iA8tR8lTWVs9go=
X-Received: by 2002:a05:6e02:214b:b0:3a0:44d1:dca4 with SMTP id
 e9e14a558f8ab-3a084702e91mr11603665ab.6.1726268708090; Fri, 13 Sep 2024
 16:05:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912141156.231429-1-jon@nutanix.com> <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com> <20240912162440.be23sgv5v5ojtf3q@desk>
 <ZuPNmOLJPJsPlufA@intel.com> <CALMp9eRDtcYKsxqW=z6m=OqF+kB6=GiL-XaWrVrhVQ_2uQz_nA@mail.gmail.com>
In-Reply-To: <CALMp9eRDtcYKsxqW=z6m=OqF+kB6=GiL-XaWrVrhVQ_2uQz_nA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Sep 2024 16:04:56 -0700
Message-ID: <CALMp9eTQUznmXKAGYpes=A0b1BMbyKaCa+QAYTwwftMN3kufLA@mail.gmail.com>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for 'spectre_bhi=vmexit'
To: Chao Gao <chao.gao@intel.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Jon Kohler <jon@nutanix.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, 
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 11:39=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
>
> On Thu, Sep 12, 2024 at 10:29=E2=80=AFPM Chao Gao <chao.gao@intel.com> wr=
ote:
> >
> > On Thu, Sep 12, 2024 at 09:24:40AM -0700, Pawan Gupta wrote:
> > >On Thu, Sep 12, 2024 at 03:44:38PM +0000, Jon Kohler wrote:
> > >> > It is only worth implementing the long sequence in VMEXIT_ONLY mod=
e if it is
> > >> > significantly better than toggling the MSR.
> > >>
> > >> Thanks for the pointer! I hadn=E2=80=99t seen that second sequence. =
I=E2=80=99ll do measurements on
> > >> three cases and come back with data from an SPR system.
> > >> 1. as-is (wrmsr on entry and exit)
> > >> 2. Short sequence (as a baseline)
> > >> 3. Long sequence
> > >
> > >I wonder if virtual SPEC_CTRL feature introduced in below series can
> > >provide speedup, as it can replace the MSR toggling with faster VMCS
> > >operations:
> >
> > "virtual SPEC_CTRL" won't provide speedup. the wrmsr on entry/exit is s=
till
> > need if guest's (effective) value and host's value are different.
>
> I believe that is the case here. The guest's effective value is 1025.
> If the guest knew about BHI_DIS_S, it would actually set it to 1025,
> but older guests set it to 1.
>
> The IA32_SPEC_CTRL mask and shadow fields should be perfect for this.

In fact, this is the guidance given in
https://www.intel.com/content/www/us/en/developer/articles/technical/softwa=
re-security-guidance/technical-documentation/branch-history-injection.html:

The VMM should use the =E2=80=9Cvirtualize IA32_SPEC_CTRL=E2=80=9D VM-execu=
tion
control to cause BHI_DIS_S to be set (see the VMM Support for
BHB-clearing Software Sequences section) whenever:
o The VMM is running on a processor for which the short software
sequence may not be effective:
  - Specifically, it does not enumerate BHI_NO, but does enumerate
BHI_DIS_S, and is not an Atom-only processor.

In other words, the VMM should set bit 10 in the IA32_SPEC_CTRL mask
on SPR. As long as the *effective* guest IA32_SPEC_CTRL value matches
the host value, there is no need to write the MSR on VM-{entry,exit}.

There is no need to disable BHI_DIS_S on the host and use the TSX
abort sequence in its place.

Besides, with the TSX abort approach, what are you going to do about
guests that *do* set BHI_DIS_S? If that bit is clear on the host,
they'll suffer the overhead of writing the MSR on VM-{entry,exit}.

> > "virtual SPEC_CTRL" just prevents guests from toggling some bits. It do=
esn't
> > switch the MSR between guest value and host value on entry/exit. so, KV=
M has
> > to do the switching with wrmsr/rdmsr instructions. A new feature, "load
> > IA32_SPEC_CTRL" VMX control (refer to Chapter 15 in ISE spec[*]), can h=
elp but
> > it isn't supported on SPR.
> >
> > [*]: https://cdrdv2.intel.com/v1/dl/getContent/671368
> >
> > >
> > >  https://lore.kernel.org/kvm/20240410143446.797262-1-chao.gao@intel.c=
om/
> > >
> > >Adding Chao for their opinion.
> >

