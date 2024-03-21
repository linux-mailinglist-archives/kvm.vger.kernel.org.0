Return-Path: <kvm+bounces-12361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C558856A8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 10:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C1F01F21AA8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 09:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E4C53361;
	Thu, 21 Mar 2024 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="SrLB9TdI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A28E446DC
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 09:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711014257; cv=none; b=HCkQvshgG4wY9CnYExjJbuf3rQNoJmGi6NDWfg69vAZ+i/eAjp9F23DEZeYUjbqjUBN6Sb37BUBolNKuTh9AGNnKrFG7fOE+6pjKXXFE5pm7aOpFPIGBgVsigQIdkdOn7SqKac3Oq8MfHzCehtOKK2fFmJt04ppfuVtJoeILQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711014257; c=relaxed/simple;
	bh=+BddkWmVb2KxQclyW5gI/MMg+/38KCLwOvq0RB+zoRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiZSO0wXeU8tdflmGgs4DLv6HWsDWm3GPsSNestD3Ih8QcPFuWe+bse5a0NKHFPiB40RGJeb03lR4Vt15qt/6EXlZQuJfF2IH2LqOMtwW028/HWFwPm4/kRp+sOcGdUXHcyl6YpELStfT9GR9u1aZNlpcS5mtuc/i73GgIciXZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=SrLB9TdI; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d28051376eso15546281fa.0
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 02:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1711014253; x=1711619053; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bnysIZLRHuJugMNjksHZ7KgXRP8kfnV+ELbUklK0tQ=;
        b=SrLB9TdIyj9HcCaj0X+Zn/aLZYsDDZf7O0uwLhSDuVfyjGTFcYh1O7x7oVh5zrZ0GB
         2ZyeDI30c4f4vGNiSYHExKSEE/UIOdWA2gc/PgVXaROnsB/Afu2v+Mk6TXKa4TMYal1L
         1KEq/waaaGrDznKytiA2CHOZMSsHZyl7YL6Mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711014253; x=1711619053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bnysIZLRHuJugMNjksHZ7KgXRP8kfnV+ELbUklK0tQ=;
        b=xM8PLRQqJpxIltcNBkHjvo7Q+nHXRi9k97vT0NKIGGwTkp3CG1D+c4ZyX6jGiQnGqz
         PBkovOEx9LXNKn3yIPJeVpJ4cXyve3unJdszfFC+78DM3ojG6wQjzC+rQ+6Q8gjsPmPS
         eynODKYhw8W0DGTynZ7/NQxugOhTA99KWMymvonKxkKvqrJyqLTOuUn45YEbw+/V2ns5
         1+mlyr0i0G51IKcbZNPUo9a0AVYoK6mGrwbzisTXlRxz/fYmeJjB4+m4wn7Bf+A1d1E5
         CUBOVrKo74oXyRXXvHY9l+HgsaPTYYMWEUT3IFfmQofPExbD7bfF/2qMaX+CO9d6eW8f
         7ULw==
X-Forwarded-Encrypted: i=1; AJvYcCVwpXzk131zZkl68rNTEJPKNYK33chShbUFT10uv9409p9zMV/jRMUJkcIHgOBWZ2656ctJk/ITwHdT2x3F4/jmguea
X-Gm-Message-State: AOJu0Yy6V7DCdfDsEyFobgIKp6+2tq4zXKaAyuTGMKfbnTivv7Pg1KRA
	Wv2Z6+X8dM2hua9+oZD2wnIs7vJdHYjwoSMuTAkKXtQdD7SGauG07gB6LO/UhnHdBlEnYpFcA1P
	npHkX0KswU2ov+2hrJ3XS+/xFgScj+G9aX6Sk
X-Google-Smtp-Source: AGHT+IEuiJ3gPiBp0utLLCSVFQZk+rtPf3Lsyn4LSIs5SyTRd+I+8Eds85ZIqUIGPgvT//dxXReBQprBN392uYZNzpA=
X-Received: by 2002:a05:651c:3cf:b0:2d4:132b:9f21 with SMTP id
 f15-20020a05651c03cf00b002d4132b9f21mr1205215ljp.6.1711014253330; Thu, 21 Mar
 2024 02:44:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <20240319131207.GB1096131@fedora> <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
 <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
In-Reply-To: <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
From: Igor Raits <igor@gooddata.com>
Date: Thu, 21 Mar 2024 10:44:01 +0100
Message-ID: <CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Jason & others,

On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@gooddata.com> wr=
ote:
> >
> > Hello Stefan,
> >
> > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > > Hello,
> > > >
> > > > We have started to observe kernel crashes on 6.7.y kernels (atm we
> > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> > > > have nodes of cluster it looks stable. Please see stacktrace below.=
 If
> > > > you need more information please let me know.
> > > >
> > > > We do not have a consistent reproducer but when we put some bigger
> > > > network load on a VM, the hypervisor's kernel crashes.
> > > >
> > > > Help is much appreciated! We are happy to test any patches.
> > >
> > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > >
> > > >
> > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > >
> > > Are there any patches in this kernel?
> >
> > Only one, unrelated to this part. Removal of pr_err("EEVDF scheduling
> > fail, picking leftmost\n"); line (reported somewhere few months ago
> > and it was suggested workaround until proper solution comes).
>
> Btw, a bisection would help as well.

In the end it seems like we don't really have "stable" setup, so
bisection looks to be useless but we did find few things meantime:

1. On 6.6.9 it crashes either with unexpected GSO type or usercopy:
Kernel memory exposure attempt detected from SLUB object
'skbuff_head_cache'
2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
0010:skb_release_data+0xb8/0x1e0
3. It does NOT crash on 6.8.1 when VM does not have multi-queue setup

Looks like the multi-queue setup (we have 2 interfaces =C3=97 3 virtio
queues for each) is causing problems as if we set only one queue for
each interface the issue is gone.
Maybe there is some race condition in __pfx_vhost_task_fn+0x10/0x10 or
somewhere around? We have noticed that there are 3 of such functions
in the stacktrace that gave us hints about what we could try=E2=80=A6

>
> Thanks
>

Thank you!

