Return-Path: <kvm+bounces-20496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 009C3916F7F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 19:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FB991C22455
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 17:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C5A176AD1;
	Tue, 25 Jun 2024 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5VJy50U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F0716C866;
	Tue, 25 Jun 2024 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719337486; cv=none; b=W8syD3XYHD9sNYng7FdbvrurGcmXgqDU/XuGJqH1CwZxP4zAZ9NcfV68nsx6PsUY828PZjk8CJj6l7chqsL3baZvukMydR13C3PvVYo+qTsNIaI8BKrq2zNsoFh+Ys5zRiqJjKKvdaFa1R4CXK42qa4d7J7ZSxu+J01fMc6D0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719337486; c=relaxed/simple;
	bh=yMA6UE6weehFHS2vhpCm6pr6A4vLSml8kZ5bPa6RH+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ogtah5bAqeDPYbwH1HFcqRYxfKNpiFZubhMByG02JLGvcVAD5DTNGl3vFnbtmEMMFlvDDnQ3ps2j6rGTHluDMS9mMQF7XiScZAx0tQldDfx2DCBNAJ4I1BefGafpJ5BLKKegrv/kZDQtQ0RLq/YQn6y5pgOBDJU7bRCHJu6w8n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5VJy50U; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52cf4ca8904so725010e87.3;
        Tue, 25 Jun 2024 10:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719337482; x=1719942282; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAC2o+wo388yK5rwpnKsBafa76gLqC7NxDi/njKmEYk=;
        b=g5VJy50UZB+0jNNM4A7kM3Jin3xavhs91nvX0ECZRMh79/hXWx28eWiw3SlgzGGIDy
         I2Avw9eucESLH/hpoGu9oNvBWAUCRzj5f2NPvm6HSr8mInTGnPYGXhwhw1BdZDTFjy9/
         6apRLU0SvyiB61ub+WUfffk8/XHkdMIfeCmXJiGMs2eHU3I52ewmR0HUO9iIZCVGl4m9
         VsjqjhiO+2eksW2WPodm3l5tivNy4FZqRcnsLUrD0NrG5rVGsWvkLsCIvSaqXt/FlvDm
         m8KPtrCSej8Z719hmGOMxA7urzgSINAzmn535e59tIOU418NqIVOltilA88Mb7xw7tQE
         QJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719337482; x=1719942282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAC2o+wo388yK5rwpnKsBafa76gLqC7NxDi/njKmEYk=;
        b=VeWlFlm9d7r69BX9SwdT0PooRAB+l1IB9rQHms69/hn4B1Lli8v9mX87hPwHpoIyzZ
         DQnfW01AtDFusNVp18iQ3Kht3any4a+n5PYq/Y4zJGAnME2levHLGqG5/cFxaZDK3QlB
         zh0qvlUzfznuva8rkSEe+iL2Uan0mVwWc1UhRIVKOvjg+d7ntMchxco15gZ9329JGLfZ
         GT5iu5WwsfBdUgVfCSlMK3DBWThj7TRnfVH2bFpVggT0HZbnq+yDQBGMDByMHYDEhC8h
         EEPm59scZopUCIANN8aiaLwD/Mb4pFvemB+4jNHkN5OAd/nEbiteq3S3LXGgcIgPqp3L
         c4eg==
X-Forwarded-Encrypted: i=1; AJvYcCXWWBtrA7PBnalGw1y9eQm1TxJ0hEzbc+L3s8ypsaLxX0Z2Ywbg85kB1685zz6aB5hI2WYgz+vhArlq0IBQSXde2tTIS3NQzye/VbrGr6bGjQQDEG7a5JF8wrOa
X-Gm-Message-State: AOJu0YykPV+aBsi8m4wBuNknDaPl614419TWtgFhb7NptV8WKTnO/mFQ
	caYKM//cqxU22b6Gua0Ou7dvI7VnLTWxvt/JjHQIiTRPqdMqcOcueqCs2S5InC4dCFwJ+3n5IKS
	K1wP5QW7zBEPXzLdj5Y1hqArekBM=
X-Google-Smtp-Source: AGHT+IEqK0IgdrEEupBY2bIgxT3Ga6NtkBVHoj/WUSUZdXM/ZmJIKxvQvNg1rRDFcyfz9VhEaZNStJy71RAKP7jU6tM=
X-Received: by 2002:a05:6512:12c3:b0:52c:82fa:ef7b with SMTP id
 2adb3069b0e04-52ce067270amr6326648e87.44.1719337482097; Tue, 25 Jun 2024
 10:44:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com> <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com> <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
 <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com> <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
In-Reply-To: <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Tue, 25 Jun 2024 23:44:30 +0600
Message-ID: <CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com>
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Stefano,

On Wed, May 29, 2024 at 4:56=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Wed, May 29, 2024 at 12:43:57PM GMT, Alexander Graf wrote:
> >
> >On 29.05.24 10:04, Stefano Garzarella wrote:
> >>
> >>On Tue, May 28, 2024 at 06:38:24PM GMT, Paolo Bonzini wrote:
> >>>On Tue, May 28, 2024 at 5:53=E2=80=AFPM Stefano Garzarella
> >>><sgarzare@redhat.com> wrote:
> >>>>
> >>>>On Tue, May 28, 2024 at 05:49:32PM GMT, Paolo Bonzini wrote:
> >>>>>On Tue, May 28, 2024 at 5:41=E2=80=AFPM Stefano Garzarella
> >>>><sgarzare@redhat.com> wrote:
> >>>>>> >I think it's either that or implementing virtio-vsock in userspac=
e
> >>>>>> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c5=
0999979@redhat.com/,
> >>>>>> >search for "To connect host<->guest").
> >>>>>>
> >>>>>> For in this case AF_VSOCK can't be used in the host, right?
> >>>>>> So it's similar to vhost-user-vsock.
> >>>>>
> >>>>>Not sure if I understand but in this case QEMU knows which CIDs are
> >>>>>forwarded to the host (either listen on vsock and connect to the hos=
t,
> >>>>>or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
> >>>>>involved.
> >>>>
> >>>>I meant that the application in the host that wants to connect to the
> >>>>guest cannot use AF_VSOCK in the host, but must use the one where QEM=
U
> >>>>is listening (e.g. AF_INET, AF_UNIX), right?
> >>>>
> >>>>I think one of Alex's requirements was that the application in the ho=
st
> >>>>continue to use AF_VSOCK as in their environment.
> >>>
> >>>Can the host use VMADDR_CID_LOCAL for host-to-host communication?
> >>
> >>Yep!
> >>
> >>>If
> >>>so, the proposed "-object vsock-forward" syntax can connect to it and
> >>>it should work as long as the application on the host does not assume
> >>>that it is on CID 3.
> >>
> >>Right, good point!
> >>We can also support something similar in vhost-user-vsock, where instea=
d
> >>of using AF_UNIX and firecracker's hybrid vsock, we can redirect
> >>everything to VMADDR_CID_LOCAL.
> >>
> >>Alex what do you think? That would simplify things a lot to do.
> >>The only difference is that the application in the host has to talk to
> >>VMADDR_CID_LOCAL (1).
> >
> >
> >The application in the host would see an incoming connection from CID
> >1 (which is probably fine) and would still be able to establish
> >outgoing connections to the actual VM's CID as long as the Enclave
> >doesn't check for the peer CID (I haven't seen anyone check yet). So
> >yes, indeed, this should work.
> >
> >The only case where I can see it breaking is when you run multiple
> >Enclave VMs in parallel. In that case, each would try to listen to CID
> >3 and the second that does would fail. But it's a well solvable
> >problem: We could (in addition to the simple in-QEMU case) build an
> >external daemon that does the proxying and hence owns CID3.
>
> Well, we can modify vhost-user-vsock for that. It's already a daemon,
> already supports different VMs per single daemon but as of now they have
> to have different CIDs.
>
> >
> >So the immediate plan would be to:
> >
> >  1) Build a new vhost-vsock-forward object model that connects to
> >vhost as CID 3 and then forwards every packet from CID 1 to the
> >Enclave-CID and every packet that arrives on to CID 3 to CID 2.
>
> This though requires writing completely from scratch the virtio-vsock
> emulation in QEMU. If you have time that would be great, otherwise if
> you want to do a PoC, my advice is to start with vhost-user-vsock which
> is already there.
>

Can you give me some more details about how I can implement the
daemon? I would appreciate some pointers to code too.

Right now, the "nitro-enclave" machine type (wip) in QEMU
automatically spawns a VHOST_VSOCK device with the CID equal to the
"guest-cid" machine option. I think this is equivalent to using the
"-device vhost-vsock-device,guest-cid=3DN" option explicitly. Does that
need any change? I guess instead of "vhost-vsock-device", the
vhost-vsock device needs to be equivalent to "-device
vhost-user-vsock-device,guest-cid=3DN"?

The applications inside the nitro-enclave VM will still connect and
talk to CID 3. So on the daemon side, do we need to spawn a device
that has CID 3 and then forward everything this device receives to CID
1 (VMADDR_CID_LOCAL) same port and everything it receives from CID 1
to the "guest-cid"? The applications that will be running in the host
need to be changed so that instead of connecting to the "guest-cid" of
the nitro-enclave VM, they will instead connect to VMADDR_CID_LOCAL.
Is my understanding correct?

BTW is there anything related to the "VMADDR_FLAG_TO_HOST" flag that
needs to be checked? I remember some discussion about it.

It would be great if you could give me some details about how I can
achieve the CID 3 <-> CID 2 communication using the vhost-user-vsock.
Is this https://github.com/stefano-garzarella/vhost-user-vsock where I
would need to add support for forwarding everything to
VMADDR_CID_LOCAL via an option maybe?

Thanks and Regards,
Dorjoy

