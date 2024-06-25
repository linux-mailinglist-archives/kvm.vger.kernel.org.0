Return-Path: <kvm+bounces-20465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFD0916557
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 12:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B4D12826DC
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 10:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA5114A4E9;
	Tue, 25 Jun 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="UeeRG0da"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F1145B32
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719311889; cv=none; b=WZduW87It7e5umOpyoP7w9L/vzoHX0roTZ7LRhY4sSCREzSyLrhR1vU8YV6mesIc4a4REFi3XchkHLEzCvpajhsI1ILZVIiW7N53oKKkaBHd3kLHFKzooIMyqYB55b1sTxSzg5HEqdYbIl/wVoye0b4KynoVLjXpdE3LANIN1kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719311889; c=relaxed/simple;
	bh=Dt10cvcOpgsb0/P0osWcNRM2YJE61QCIjA1sJzVnVpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JXiAOVhSeW4LXfgNK+Itvm6c2fU4D5+n54X+o/tx0d6B6MH5aNF43OZbDVuxdvf51f8wDEHH78esCOuVE5W9konvbEeDvcAQeUwBVmUm9ihcpSM55KwVMprq+V9W2KRIv+zgWFjbuxHO/Pa7Pz5sB27JHr6K+VMCbO5ugak2cPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=UeeRG0da; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57cb9a370ddso6073340a12.1
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 03:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719311885; x=1719916685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgACs1Zq8zO5lFcqRU3bBruH/XX+msPS49ZLh765+hU=;
        b=UeeRG0daNJVDG3izlV6tDo+PGKIdXxCb0kflmPj4goLO2YuvmzzkxbUBfcjZ4WzTQ9
         TXKdzNdHc4SMru3PlT7TEyt4wnUxkNUtxvKdXen/rYbjTaFrZa/k4Q7v0fmRNHmeP5aY
         NTAlBX+sA4vbeTxXOrq+WNlHaRxcdtb0t0oZ0ru3vWGbQKCAgTNQDNwFnoI+79/T85W3
         uIlm9QTzcGIp0PCjegku6f7XgNslxhN6ILbRD2qCirwujakqenb24CX8V/kJGjgYBUCV
         IxkL3dsFeRcGcR91ufEEiWnvWXgsAXDI1ZQpuPyi76gofeQ78T1EogzzR8q0LRXFCAF3
         VMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719311885; x=1719916685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgACs1Zq8zO5lFcqRU3bBruH/XX+msPS49ZLh765+hU=;
        b=QG40sm87vlZ66SosyLX21Yn7eA4Onm8KgYXA8R+PwXPRhsm1buhSHi3GmZq3Q57ITN
         ouq67+oWHdkeMe6+IPAs0OThuHANeuwd/1+QS+f+U0s1+E0NIN2KJgALtcPWLsurwXUr
         6j+J10n9YumqKgSRM4weE0QKbR+i82pTkX0uYSJneEQ4n/lZk5B3lIqRvQzydgC2tMQ0
         RYHZ+7FZM0g6Q5mdgwDO7jotDEWZnqloJkFGjLQOErV/gAqqLxJSMq00lrlNXeH9dTm0
         0kj1n2Tp2QKuU4N4UPkoz95bgzH7Sxc/+DyT2WBCfPm1YOau4N3Y1QxHtG9J2git/nlg
         A91g==
X-Forwarded-Encrypted: i=1; AJvYcCUOZjQstTZFef/nlhkrnxHM5ZMZWtLpn58hqinQ9p+Y21fyn5Di8k3pEf7QUfb0vgiRe7foTHINSHG4s0s2jPhTPUqe
X-Gm-Message-State: AOJu0YwTOcrrT8HagtVL8Td7tqNHBfIRSJ2bWBuHrVBXmzKAvCcuYzTh
	MiJ274ouvbtq8dW+gRGa6lgpV121QfUXnyxz3CQNvl+wZR/C9cMfdMQnzxqIeJ1XshT3HYYY/Ym
	TEeOwe75q0DXbN5HNDn/RKpxW33BOPpLvLfgLWw==
X-Google-Smtp-Source: AGHT+IEOGwcd6y/gx12jEq+6dGlJLUlszkJPcbr1MdpHUe7LAywiaX+cvkxEPjNM34TUSpxkVh5v/jOigUd5w64NKMg=
X-Received: by 2002:a50:d716:0:b0:57c:9ccd:c626 with SMTP id
 4fb4d7f45d1cf-57d4bddfbfbmr4573117a12.39.1719311885379; Tue, 25 Jun 2024
 03:38:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com> <20240621-d1b77d43adacaa34337238c2@orel>
 <20240621-nutty-penknife-ca541ee5108d@wendy> <20240621-b22a7c677a8d61c26feaa75b@orel>
 <20240621-pushpin-exclude-1b4f38ae7e8d@wendy> <20240621-a69c8f97e566ebd3a82654c1@orel>
In-Reply-To: <20240621-a69c8f97e566ebd3a82654c1@orel>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Tue, 25 Jun 2024 18:37:53 +0800
Message-ID: <CAMWQL2jWPD77f2gz_N8HM+YdKev-8RvOCOUgm5-uxq-5VTvCXw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Conor Dooley <conor.dooley@microchip.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>, 
	Samuel Ortiz <sameo@rivosinc.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Leonardo Bras <leobras@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Conor, Andrew and Alexandre,

On Fri, Jun 21, 2024 at 8:06=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, Jun 21, 2024 at 12:00:32PM GMT, Conor Dooley wrote:
> > On Fri, Jun 21, 2024 at 12:42:32PM +0200, Andrew Jones wrote:
> > > On Fri, Jun 21, 2024 at 11:24:19AM GMT, Conor Dooley wrote:
> > > > On Fri, Jun 21, 2024 at 10:43:58AM +0200, Andrew Jones wrote:
> ...
> > > > > It's hard to guess what is, or will be, more likely to be the cor=
rect
> > > > > choice of call between the _unlikely and _likely variants. But, w=
hile we
> > > > > assume svade is most prevalent right now, it's actually quite unl=
ikely
> > > > > that 'svade' will be in the DT, since DTs haven't been putting it=
 there
> > > > > yet. Anyway, it doesn't really matter much and maybe the _unlikel=
y vs.
> > > > > _likely variants are better for documenting expectations than for
> > > > > performance.
> > > >
> > > > binding hat off, and kernel hat on, what do we actually do if there=
's
> > > > neither Svadu or Svade in the firmware's description of the hardwar=
e?
> > > > Do we just arbitrarily turn on Svade, like we already do for some
> > > > extensions:
> > > >   /*
> > > >    * These ones were as they were part of the base ISA when the
> > > >    * port & dt-bindings were upstreamed, and so can be set
> > > >    * unconditionally where `i` is in riscv,isa on DT systems.
> > > >    */
> > > >   if (acpi_disabled) {
> > > >           set_bit(RISCV_ISA_EXT_ZICSR, isainfo->isa);
> > > >           set_bit(RISCV_ISA_EXT_ZIFENCEI, isainfo->isa);
> > > >           set_bit(RISCV_ISA_EXT_ZICNTR, isainfo->isa);
> > > >           set_bit(RISCV_ISA_EXT_ZIHPM, isainfo->isa);
> > > >   }
> > > >
> > >
> > > Yes, I think that's reasonable, assuming we do it in the final "pass"=
,
> > > where we're sure svadu isn't present.
> >
> > I haven't thought about specifically when to do it, but does it need to
> > be in the final pass? If we were to, on each CPU, enable it if Svadu
> > isn't there, we'd either end up with a system that I suspect we're not
> > going to be supporting or the correct result. Or am I misunderstanding,
> > and it will be valid to have a subset of CPUs that have Svadu enabled
> > from the bootloader?
> >
> > Note that it would not be problematic to have 3 CPUs with Svade + Svadu
> > and a 4th with only Svade in the DT because we would just not use the
> > FWFT mechanism to enable Svadu. It's just the Svadu in isolation case
> > that I'm asking about.
>
> I wasn't thinking about the potential of mixmatched A/D udpating. I'm
> pretty sure this will be one of those things that is all or none. I
> was more concerned with getting the result right and I had just been
> too lazy to double check that the block of code you pointed out is
> in the right place to be sure there's no svadu. Now that I look, I
> believe it is.
>
> >
> > > Doing this is a good idea since
> > > we'll be able to simplify conditions, as we can just use 'if (svade)'
> > > since !svade would imply svadu. With FWFT and both, we'll want to rem=
ove
> > > svade from the isa bitmap when enabling svadu.
> >
> > Right I would like to move the various extension stuff in this
> > direction, where they have a bit more intelligence to them, and don't
> > just reflect the state in DT/ACPI directly.
> > I've got some patches in mind once Clement's Zca etc patchset
> > is merged, think I posted one or two as replies to conversations on
> > the list already. An example would be disabling the vector crypto
> > extensions if we've had to disable vector, or as you suggest here,
> > dropping Svade if we have turned on Svadu using FWFT. I think that make=
s
> > the APIs more understandable to developers and more useful than they ar=
e
> > at the moment, where to use vector crypto you also need to check vector
> > itself for the code to be correct. If I call
> > riscv_isa_extension_available(), and it returns true, the extension
> > should be usable IMO.

Thank you all very much! I will update the code so that
riscv_isa_extension_available()
can reflect the platform's behavior.

Regards,
Yong-Xuan

>
> Sounds good to me.
>
> Thanks,
> drew

