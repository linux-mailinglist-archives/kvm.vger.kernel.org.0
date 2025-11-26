Return-Path: <kvm+bounces-64610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C8CC88355
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0865535332F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8955B316188;
	Wed, 26 Nov 2025 06:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EWPCF2nS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HmYgamMT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A852DF146
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764137081; cv=none; b=tRp9AxO7R56dR/s97ngalDddOoqLhk3PtRFN3NUIE8CefrpRifdFMpM0tsbooFTyQid0yvmeyQNauwjfGy3qOC9B4AtZFwQJcAlLnmXs+Y7G/gKZkAOy3qUFOunfzcC5wPVSwd2KMptVg7WCkO3h0mG5/VFN45Hx/OLq5Fwm0H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764137081; c=relaxed/simple;
	bh=6S/I0aqRZ/F7+hnivrbJxw1X0W/1DAFC2mRV55eaujE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z4hOGF9TkR8nrd+1gx8KMbdPY0uDijtMd0MrMVAraSU1hIO2IWOvYZpwWFY9GzCQRIRSO/Docg94QKV9afdROnWKjtnig5Yg2KRrJqfnJygUhV5js6twGTSAYUbgjE7L2WvnbKOnesL80Y42MSY06KHYeI/ipyx0NqetdIC3l/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EWPCF2nS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HmYgamMT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764137078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OaB2KVWRNAbMaNATIpxj7yIi4zwUBMB8DFcAl65yplo=;
	b=EWPCF2nSh8XAKm2Jxb1Tm74/y854P8dSIIKXh2ut+BUsbo+3IwYdZUQL5U3jXiDMst8YeA
	naP65Hcju0DXLjVLwzLMLnzG7qsgeevZTYYYaD33osz7sVmIVfXhdKeBOD605RduUZhuao
	2vLAk58GAe5CMqeAoLVhd2987DphYdI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-jyH8oLkSMsS_qKOdkK-pVA-1; Wed, 26 Nov 2025 01:04:37 -0500
X-MC-Unique: jyH8oLkSMsS_qKOdkK-pVA-1
X-Mimecast-MFC-AGG-ID: jyH8oLkSMsS_qKOdkK-pVA_1764137076
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso6733164a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764137076; x=1764741876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OaB2KVWRNAbMaNATIpxj7yIi4zwUBMB8DFcAl65yplo=;
        b=HmYgamMTT59pr5qvbw4uByk2H31nxir5JVJANcUewxLqGb9CoGvmVufMQ3C56HWIt9
         v3EMlFKgL0txijfkMIJrqlcvzfoNd2tw/NvYjGy8ffZSCYi6r6o2jKBNUZHGPzvJszRs
         xoRZlfO75IDXhkc+NAqWPrA2sqZz/4icv3t7jWAUgBNSAuC8Pj8wbsiu1mvDaXkWkkr3
         pozlRWQu7D0xp5asLx8xLankf82fSMDxBMe1QWlUziuaoT6Qka0nQxWdzqQB9XQ5LqaR
         IFFk4+d5E2JrunngzAZV2Er6XMkZ3ggxkW5tU/VqTYCMgqj8Rj0WyTtI6uDx9KNC2su5
         7eqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764137076; x=1764741876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OaB2KVWRNAbMaNATIpxj7yIi4zwUBMB8DFcAl65yplo=;
        b=goToyIwkPLPdEwYdHJFoaobdtNNNLiugoEN3xEm8L0L7KbCbw+Zp7oGH9SLnN63MpT
         Lcw2qBwGwVrmPoJIcEBnMVDA8DN3N/Q6aeUDa8O6uKf4DuG9w+aowOLcgaq2hp5uMa1I
         JZQ2gQBd0G3pYP9gIw0Win2wJjE0oQvuUfV2mDB59f27pxOwnK03JAptrArB4S7KesH1
         GQ5V6MXvsXFaB5VRLtfnGhxHNI5ETHTTD8KfkGEZUOSAUIjkFrCoXr7m895faNAxViTw
         TyBk+WcT4kC22JtkxlnL5QRVFv3X3n1C8dyaXwRc0F8a8yow74otiIgtwF5OcvxvB0Vv
         ZcqA==
X-Forwarded-Encrypted: i=1; AJvYcCUrydf//uYsbh1i4P7D1p9n8wftV+sYFM+1JLks2dsDB8IzuijRUfB9m18rA8bAtsxtoZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBg/Fw5pDNMd6HOR1UI0QrnROx+GMDxaZBkZ/FTl7xIzlwXWlg
	GYStuomvXxSno8AKoYGnxW+Z0Y4f5hg9HNCyijgn4wsNc04o4uzvtIJW9RW/JeBaDQ99mOAF88n
	nTHlnoZN8l2W6aJj91v3ZUDEwItacYHMs2rf5z13YlflupEs8E307VMSQRZ6BYpLlbSclmYAJ9z
	jUKZ3Xi/NshrY1Bgxu/0qg3B3V31a/
X-Gm-Gg: ASbGncvaAfnuwNMyobICLx/rSGJ6QxhpYe7ajDvyDhdB5hbiK8SOaTMzV+oGxpn6pAC
	B8xuQhQm8mBfMNRvwk7UgB98waw8jXSvh/z8Ac+LHhdhKRfVEPRFOogMuJclmd1Nf09bK/7GfGB
	Tg59KUCsxWRkeEBHc1hJSuAXHczLmSJHBCN88uU85l5n6rUSUr7XTiyd/9uKPNTzP+j1w=
X-Received: by 2002:a17:90b:3a81:b0:343:684c:f8ac with SMTP id 98e67ed59e1d1-34733e4c8fdmr16172939a91.8.1764137075883;
        Tue, 25 Nov 2025 22:04:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMgyGfGhHuIXlnMSRmydbJ73Umy+/ihi3Es7MfZVsIvdOL46Du5q/FBIP1Zh+sAGvjoTwtO6cxu9UWM/LPP4s=
X-Received: by 2002:a17:90b:3a81:b0:343:684c:f8ac with SMTP id
 98e67ed59e1d1-34733e4c8fdmr16172898a91.8.1764137075386; Tue, 25 Nov 2025
 22:04:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com> <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com> <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
In-Reply-To: <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Nov 2025 14:04:21 +0800
X-Gm-Features: AWmQ_bmSzNmtLXzsLUvLhgWB8dvqy0Qa5CQPOMXfuQ7SoDSN1_7LIgv1Nc8s6u4
Message-ID: <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, krzk@kernel.org, 
	alexandre.belloni@bootlin.com, Linus Walleij <linus.walleij@linaro.org>, 
	fustini@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 3:45=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Nov 19, 2025, at 8:57=E2=80=AFPM, Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > On Tue, Nov 18, 2025 at 1:35=E2=80=AFAM Jon Kohler <jon@nutanix.com> wr=
ote:
> >>
> >>
> >>> On Nov 16, 2025, at 11:32=E2=80=AFPM, Jason Wang <jasowang@redhat.com=
> wrote:
> >>>
> >>> On Fri, Nov 14, 2025 at 10:53=E2=80=AFPM Jon Kohler <jon@nutanix.com>=
 wrote:
> >>>>
> >>>>
> >>>>> On Nov 12, 2025, at 8:09=E2=80=AFPM, Jason Wang <jasowang@redhat.co=
m> wrote:
> >>>>>
> >>>>> On Thu, Nov 13, 2025 at 8:14=E2=80=AFAM Jon Kohler <jon@nutanix.com=
> wrote:
> >>>>>>
> >>>>>> vhost_get_user and vhost_put_user leverage __get_user and __put_us=
er,
> >>>>>> respectively, which were both added in 2016 by commit 6b1e6cc7855b
> >>>>>> ("vhost: new device IOTLB API").
> >>>>>
> >>>>> It has been used even before this commit.
> >>>>
> >>>> Ah, thanks for the pointer. I=E2=80=99d have to go dig to find its g=
enesis, but
> >>>> its more to say, this existed prior to the LFENCE commit.
> >>>>
> >>>>>
> >>>>>> In a heavy UDP transmit workload on a
> >>>>>> vhost-net backed tap device, these functions showed up as ~11.6% o=
f
> >>>>>> samples in a flamegraph of the underlying vhost worker thread.
> >>>>>>
> >>>>>> Quoting Linus from [1]:
> >>>>>>  Anyway, every single __get_user() call I looked at looked like
> >>>>>>  historical garbage. [...] End result: I get the feeling that we
> >>>>>>  should just do a global search-and-replace of the __get_user/
> >>>>>>  __put_user users, replace them with plain get_user/put_user inste=
ad,
> >>>>>>  and then fix up any fallout (eg the coco code).
> >>>>>>
> >>>>>> Switch to plain get_user/put_user in vhost, which results in a sli=
ght
> >>>>>> throughput speedup. get_user now about ~8.4% of samples in flamegr=
aph.
> >>>>>>
> >>>>>> Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
> >>>>>> TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
> >>>>>> RX: taskset -c 2 iperf3 -s -p 5200 -D
> >>>>>> Before: 6.08 Gbits/sec
> >>>>>> After:  6.32 Gbits/sec
> >>>>>
> >>>>> I wonder if we need to test on archs like ARM.
> >>>>
> >>>> Are you thinking from a performance perspective? Or a correctness on=
e?
> >>>
> >>> Performance, I think the patch is correct.
> >>>
> >>> Thanks
> >>>
> >>
> >> Ok gotcha. If anyone has an ARM system stuffed in their
> >> front pocket and can give this a poke, I=E2=80=99d appreciate it, as
> >> I don=E2=80=99t have ready access to one personally.
> >>
> >> That said, I think this might end up in =E2=80=9Cwell, it is what it i=
s=E2=80=9D
> >> territory as Linus was alluding to, i.e. if performance dips on
> >> ARM for vhost, then thats a compelling point to optimize whatever
> >> ends up being the culprit for get/put user?
> >>
> >> Said another way, would ARM perf testing (or any other arch) be a
> >> blocker to taking this change?
> >
> > Not a must but at least we need to explain the implication for other
> > archs as the discussion you quoted are all for x86.
> >
> > Thanks
>
> I=E2=80=99ll admit my ARM muscle is weak, but here=E2=80=99s my best take=
 on this:
>
> Looking at arch/arm/include/asm/uaccess.h, the biggest thing that I
> noticed is the CONFIG_CPU_SPECTRE ifdef, which already remaps
> __get_user() to get_user(), so anyone running that in their kconfig
> will already practically have the behavior implemented by this patch
> by way of commit b1cd0a148063 ("ARM: spectre-v1: use get_user() for
> __get_user()=E2=80=9D).
>
> Same deal goes for __put_user() vs put_user by way of commit
> e3aa6243434f ("ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()=
=E2=80=9D)
>
> Looking at arch/arm/mm/Kconfig, there are a variety of scenarios
> where CONFIG_CPU_SPECTRE will be enabled automagically. Looking at
> commit 252309adc81f ("ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 imple=
mentations")
> it says that "ARMv8 is a superset of ARMv7", so I=E2=80=99d guess that ju=
st
> about everything ARM would include this by default?
>
> If so, that mean at least for a non-zero population of ARM=E2=80=99ers,
> they wouldn=E2=80=99t notice anything from this patch, yea?

Adding ARM maintainers for more thought.

Thanks

>
> Happy to learn otherwise if that read is incorrect!
>
> Thanks all,
> Jon


