Return-Path: <kvm+bounces-41780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D89A6D399
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 05:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B188D3B2413
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 04:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C794E18DB04;
	Mon, 24 Mar 2025 04:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrrwpSHJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6421C1519A6
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 04:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742791241; cv=none; b=pkbuLfuihWqBNxz6iMXPkCgLp3x/skidMr/am2goWJS9TjrHcCTkGPgosRuv0OzQVc5z1RuTjkzcWgF4jU98sjGc74LmOABfrZJzrwxeNdJrzujVyAQTdjOO/oomheJD0ZSsCf8TYSBLHbEESCySCxTgeN6+XzJ5mKOK97bIkKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742791241; c=relaxed/simple;
	bh=p0p6Kv56StngZB+sGWIODdmffopgR9h2NgL9pNiuCYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uf/38FhbnxxQyRDR3zsJchCLoc49mKTXFIhxsNZ9tgOW48zrOmNqMkuQrd+WL38Zfh/zZh/qegkjNdzHovQprA1bSWnAbhSdLUep5YFX07WpyI9QJQvYHvgqloGpSlDuPJbCM68bs6EHAC9zb54r/nPRwkOVrjovVGkw/T3ZiSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PrrwpSHJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742791237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kztnGEqidLf+m7+JoTMcNyVnEgdSXdn5cQC/W/h/7E=;
	b=PrrwpSHJMBi8L/VoNS5xkpM53UAw/fYKO7Kt0gJOxtWWiThB/bI685I0qRKZkZoIEoNSGR
	TvnPe96o4bjVQrz89LJ6iWummG0BtdLqeKBzveWw6j7hl8emh2cc5xlhhm82YnQV6MdbPw
	M5zSIyFT2zoj/u9n6culLV0iwLyf4pE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-GA_VpjtSM9WimBFWodtqaA-1; Mon, 24 Mar 2025 00:40:35 -0400
X-MC-Unique: GA_VpjtSM9WimBFWodtqaA-1
X-Mimecast-MFC-AGG-ID: GA_VpjtSM9WimBFWodtqaA_1742791235
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff5296726fso11574617a91.0
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 21:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742791234; x=1743396034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kztnGEqidLf+m7+JoTMcNyVnEgdSXdn5cQC/W/h/7E=;
        b=YCE/zUl1te4/LtCbsAIxyesRl2T9h2cpvYxrKKiuDPGNB59gmuZGFzT0stmRAUgZYI
         MYropoPoOuY+0LsUfNNgRKGdq4wR/XIjupxCldc3ixqjM6pzwm4ngLqCr213qNEcoNW5
         Mrl/7LUrp3fOR5zzdWEglfVftJQvBuGbD3tubaehoLYFmOsqxlJD0pj+wnNzX1t6dN8d
         sKmwdlFadIa78tE+CV36U/EV7vzcAK16WyY6l7VTL1kEE6owu9kHZ/hhGLDdaBUSW7ou
         HY/Sh8mBWO+RnJ0wcngg/MsFid2YCSJCyOPwSDkzO4rU0WTfYufyJe3o6Myqh8mO/I67
         ZyZg==
X-Forwarded-Encrypted: i=1; AJvYcCUQsm8HASuMj9MBMXoktqU3ikbln7U/Rx3CZk08mu1g0hoz5q33+bkGUy2+X+79ecZlvNI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvyB7wceOfWbGetIj8qXhM7kadPYlGvqPayCDrBynty/qf7qDG
	CSp9I72oeqyD7PVPyo4XreGN92rFE5xM6YD64fm1e30G24y27xNxnVmLG8K2S3xtR3kvyOIEzmS
	9HnWIrPkOqRIx46PQVIZk5dz0vI4b2JXtXEvntsE4i4ScfAz1WkR+gPg4qOx3PrcUEIZgOf5PC1
	Ae/bMJJPI9Y+YA9SZHlSWZsO8x
X-Gm-Gg: ASbGncvnqye7AEcYAq3ZQmW3REEoimpr649Xqvvio3idqr9JoBWDGGvQbbPrAGPHe1F
	w4qOFhKTU/GProwI5iWH4h0/dJY5uQlWs14+kiv3TdOD0glevHHAioPsgxPlHKThjOqGyY7A=
X-Received: by 2002:a17:90b:51cf:b0:2fe:b174:31fe with SMTP id 98e67ed59e1d1-3030fe85625mr21033361a91.2.1742791233849;
        Sun, 23 Mar 2025 21:40:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH16knE9N6eswDkZZYjcMKvBg8QmBVYIJJzxdu+Pzbvj8tWYOrs/b3q5lqIuJLeB5UlE0+MR79LQ+P26Sj/hBg=
X-Received: by 2002:a17:90b:51cf:b0:2fe:b174:31fe with SMTP id
 98e67ed59e1d1-3030fe85625mr21033303a91.2.1742791233100; Sun, 23 Mar 2025
 21:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307-rss-v9-0-df76624025eb@daynix.com> <CACGkMEsNHba=PY5UQoH1zdGQRiHC8FugMG1nkXqOj1TBdOQrww@mail.gmail.com>
 <7978dfd5-8499-44f3-9c30-e53a01449281@daynix.com> <CACGkMEsR4_RreDbYQSEk5Cr29_26WNUYheWCQBjyMNUn=1eS2Q@mail.gmail.com>
 <edf41317-2191-458f-a315-87d5af42a264@daynix.com> <CACGkMEta3k_JOhKv44XiBXZb=WuS=KbSeJNpYxCdeiAgRY2azg@mail.gmail.com>
 <ff7916cf-8a9c-4c27-baaf-ca408817c063@daynix.com> <CACGkMEsVgbJPhz2d2ATm5fr3M2uSEoSXWW7tXZ_FrkQtmmu1wA@mail.gmail.com>
 <73250942-9ab9-4ee4-9bbe-e0a155a61f51@daynix.com> <CACGkMEud0Ki8p=z299Q7b4qEDONpYDzbVqhHxCNVk_vo-KdP9A@mail.gmail.com>
 <1f06b4b6-267a-4091-a3ba-e7b9dafae918@daynix.com> <CACGkMEsACb5S4rv-bWeBadDmnCcwFfnNp4MN7_4RQGB0MUWrzQ@mail.gmail.com>
 <20c34c80-7549-43e1-8bec-f7210a90f94e@daynix.com> <CACGkMEs8DyrusOsLPXSwhBvr3mKerzfNBQD3mLNfzLXhbCpR5A@mail.gmail.com>
 <ed72ad97-4ca7-40ba-ac47-9e776a07df64@daynix.com> <CACGkMEt-Y5E11qhE=vJP95fV+JAtLA+BW9P1jFUoocxysQ=W_g@mail.gmail.com>
 <a0f2676c-742e-4ba5-a233-9fc1f955d3df@daynix.com>
In-Reply-To: <a0f2676c-742e-4ba5-a233-9fc1f955d3df@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 24 Mar 2025 12:40:20 +0800
X-Gm-Features: AQ5f1Jrh1g2zh7qAWltVO4Q2ECw-iot4URkIO3uRAQGITo0tYYoFggRx9yfOYR0
Message-ID: <CACGkMEu_Qe6X1DyVt2qbpc1-iYDz874OX9wn=-uNsAkajY_ypg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/6] tun: Introduce virtio-net hash feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 1:57=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> On 2025/03/21 10:13, Jason Wang wrote:
> > On Thu, Mar 20, 2025 at 1:33=E2=80=AFPM Akihiko Odaki <akihiko.odaki@da=
ynix.com> wrote:
> >>
> >> On 2025/03/20 10:31, Jason Wang wrote:
> >>> On Wed, Mar 19, 2025 at 1:29=E2=80=AFPM Akihiko Odaki <akihiko.odaki@=
daynix.com> wrote:
> >>>>
> >>>> On 2025/03/19 9:58, Jason Wang wrote:
> >>>>> On Tue, Mar 18, 2025 at 6:10=E2=80=AFPM Akihiko Odaki <akihiko.odak=
i@daynix.com> wrote:
> >>>>>>
> >>>>>> On 2025/03/18 9:15, Jason Wang wrote:
> >>>>>>> On Mon, Mar 17, 2025 at 3:07=E2=80=AFPM Akihiko Odaki <akihiko.od=
aki@daynix.com> wrote:
> >>>>>>>>
> >>>>>>>> On 2025/03/17 10:12, Jason Wang wrote:
> >>>>>>>>> On Wed, Mar 12, 2025 at 1:03=E2=80=AFPM Akihiko Odaki <akihiko.=
odaki@daynix.com> wrote:
> >>>>>>>>>>
> >>>>>>>>>> On 2025/03/12 11:35, Jason Wang wrote:
> >>>>>>>>>>> On Tue, Mar 11, 2025 at 2:11=E2=80=AFPM Akihiko Odaki <akihik=
o.odaki@daynix.com> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 2025/03/11 9:38, Jason Wang wrote:
> >>>>>>>>>>>>> On Mon, Mar 10, 2025 at 3:45=E2=80=AFPM Akihiko Odaki <akih=
iko.odaki@daynix.com> wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 2025/03/10 12:55, Jason Wang wrote:
> >>>>>>>>>>>>>>> On Fri, Mar 7, 2025 at 7:01=E2=80=AFPM Akihiko Odaki <aki=
hiko.odaki@daynix.com> wrote:
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Hash reporting
> >>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Allow the guest to reuse the hash value to make receive =
steering
> >>>>>>>>>>>>>>>> consistent between the host and guest, and to save hash =
computation.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> RSS
> >>>>>>>>>>>>>>>> =3D=3D=3D
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> RSS is a receive steering algorithm that can be negotiat=
ed to use with
> >>>>>>>>>>>>>>>> virtio_net. Conventionally the hash calculation was done=
 by the VMM.
> >>>>>>>>>>>>>>>> However, computing the hash after the queue was chosen d=
efeats the
> >>>>>>>>>>>>>>>> purpose of RSS.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Another approach is to use eBPF steering program. This a=
pproach has
> >>>>>>>>>>>>>>>> another downside: it cannot report the calculated hash d=
ue to the
> >>>>>>>>>>>>>>>> restrictive nature of eBPF steering program.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Introduce the code to perform RSS to the kernel in order=
 to overcome
> >>>>>>>>>>>>>>>> thse challenges. An alternative solution is to extend th=
e eBPF steering
> >>>>>>>>>>>>>>>> program so that it will be able to report to the userspa=
ce, but I didn't
> >>>>>>>>>>>>>>>> opt for it because extending the current mechanism of eB=
PF steering
> >>>>>>>>>>>>>>>> program as is because it relies on legacy context rewrit=
ing, and
> >>>>>>>>>>>>>>>> introducing kfunc-based eBPF will result in non-UAPI dep=
endency while
> >>>>>>>>>>>>>>>> the other relevant virtualization APIs such as KVM and v=
host_net are
> >>>>>>>>>>>>>>>> UAPIs.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> >>>>>>>>>>>>>>>> Tested-by: Lei Yang <leiyang@redhat.com>
> >>>>>>>>>>>>>>>> ---

[...]

> >
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>> What's more, we've already had virito-net uAPI. Why not simply =
reusing them?
> >>>>>>>>
> >>>>>>>> See the above.
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>>> RSS and hash reporting must share
> >>>>>>>>>>>> this parameter when both are enabled at the same time; other=
wise RSS may
> >>>>>>>>>>>> compute hash values that are not suited for hash reporting.
> >>>>>>>>>>>
> >>>>>>>>>>> Is this mandated by the spec? If yes, we can add a check. If =
not,
> >>>>>>>>>>> userspace risk themselves as a mis-configuration which we don=
't need
> >>>>>>>>>>> to bother.
> >>>>>>>>>>
> >>>>>>>>>> Yes, it is mandated. 5.1.6.4.3 Hash calculation for incoming p=
ackets says:
> >>>>>>>>>>       > A device attempts to calculate a per-packet hash in th=
e following
> >>>>>>>>>>       > cases:
> >>>>>>>>>>       >
> >>>>>>>>>>       >   - The feature VIRTIO_NET_F_RSS was negotiated. The d=
evice uses the
> >>>>>>>>>>       >     hash to determine the receive virtqueue to place i=
ncoming packets.
> >>>>>>>>>>       >   - The feature VIRTIO_NET_F_HASH_REPORT was negotiate=
d. The device
> >>>>>>>>>>       >     reports the hash value and the hash type with the =
packet.
> >>>>>>>>>>       >
> >>>>>>>>>>       > If the feature VIRTIO_NET_F_RSS was negotiated:
> >>>>>>>>>>       >
> >>>>>>>>>>       >   - The device uses hash_types of the virtio_net_rss_c=
onfig structure
> >>>>>>>>>>       >     as =E2=80=99Enabled hash types=E2=80=99 bitmask.
> >>>>>>>>>>       >   - The device uses a key as defined in hash_key_data =
and
> >>>>>>>>>>             hash_key_length of the virtio_net_rss_config struc=
ture (see
> >>>>>>>>>>       >      5.1.6.5.7.1).
> >>>>>>>>>>       >
> >>>>>>>>>>       > If the feature VIRTIO_NET_F_RSS was not negotiated:
> >>>>>>>>>>       >
> >>>>>>>>>>       >   - The device uses hash_types of the virtio_net_hash_=
config structure
> >>>>>>>>>>       >     as =E2=80=99Enabled hash types=E2=80=99 bitmask.
> >>>>>>>>>>       >   - The device uses a key as defined in hash_key_data =
and
> >>>>>>>>>>       >     hash_key_length of the virtio_net_hash_config stru=
cture (see
> >>>>>>>>>>       >      .1.6.5.6.4).
> >>>>>>>>>>
> >>>>>>>>>> So when both VIRTIO_NET_F_RSS and VIRTIO_NET_F_HASH_REPORT are
> >>>>>>>>>> negotiated, virtio_net_rss_config not only controls RSS but al=
so the
> >>>>>>>>>> reported hash values and types. They cannot be divergent.
> >>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> Note that spec use different commands for hash_report and rss=
.
> >>>>>>>>>>
> >>>>>>>>>> TUNSETVNETHASH is different from these commands in terms that =
it also
> >>>>>>>>>> negotiates VIRTIO_NET_F_HASH_REPORT and VIRTIO_NET_F_RSS.
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> There Are different "issues" here:
> >>>>>>>>>
> >>>>>>>>> 1) Whether or not we need to use a unified API for negotiating =
RSS and
> >>>>>>>>> HASH_REPORT features
> >>>>>>>>> 2) Whether or not we need to sue a unified API for setting RSS =
and
> >>>>>>>>> HASH_REPORT configuration
> >>>>>>>>>
> >>>>>>>>> What I want to say is point 2. But what you raise is point 1.
> >>>>>>>>>
> >>>>>>>>> For simplicity, it looks to me like it's a call for having sepa=
rated
> >>>>>>>>> ioctls for feature negotiation (for example via TUNSETIFF). You=
 may
> >>>>>>>>> argue that either RSS or HASH_REPORT requires configurations, w=
e can
> >>>>>>>>> just follow what spec defines or not (e.g what happens if
> >>>>>>>>> RSS/HASH_REPORT were negotiated but no configurations were set)=
.
> >>>>>>>>
> >>>>>>>> Unfortunately TUNSETIFF does not fit in this use case. The flags=
 set
> >>>>>>>> with TUNSETIFF are fixed, but the guest can request a different =
feature
> >>>>>>>> set anytime by resetting the device.
> >>>>>>>
> >>>>>>> TUNSETIFF, enables the device to be able to handle RSS/HASREPORT.
> >>>>>>> TUNSETHASH/RSS. dealing with RSS/HASH command from userspace.
> >>>>>>
> >>>>>> We also needs to be able to disable them at runtime so that we can
> >>>>>> handle resets.
> >>>>>
> >>>>> Via TUNSETHASH/RSS? I think it should have a way to accept paramete=
rs
> >>>>> that disable RSS or hash report.
> >>>>
> >>>> That's what this patch implements. TUNSETVNETHASH accepts parameters=
 to
> >>>> choose what features to be enabled.
> >>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>> This is the way we used to do for multi queue and vnet header.
> >>>>>>> TUNSETIFF requires CAP_NET_ADMIN, this could be an extra safe gua=
rd
> >>>>>>> for unprivileged userspace.
> >>>>>>
> >>>>>> I intend to allow using this feature without privilege. A VMM is u=
sually
> >>>>>> unprivileged and requiring a privilege to configure tuntap is too
> >>>>>> prohibitive.
> >>>>>
> >>>>> For safety, tun is not allowed to be created by unprivileged users.
> >>>>> And it's not to configure the tuntap dynamically, it's about tellin=
g
> >>>>> the function that tuntap can have (not necessarily enabled though) =
.
> >>>>
> >>>> I don't think we need another barrier for the new functions. Once an
> >>>> unprivileged user get a file descriptor of tuntap from a privileged
> >>>> user, they are free to enable RSS and/or hash reporting.
> >>>
> >>> Only if such a feature is allowed by the privileged user.
> >>
> >> I don't see a reason not to allow the feature to unprivileged users. I=
t
> >> only complicates the setup.
> >
> > For safety, e.g reduce the chance for unprivileged user to explore
> > part of the kernel codes.
>
> It indeed reduces the attack surface, but it's fine without the
> reduction I guess? It's not a feature so complicated;

I don't know how to define complicated things here but simplicity
doesn't necessarily mean safety.

> I saw there were
> complicated changes like namespaces and io_uring that caused controversy
> when exposing them to unprivilged users, but this feature is not like
> them, I suppose.

We limit feature setting through tun_set_iff in the past. Instead of
trying to argue if RSS is safe to be enabled without TUNSETIFF,
following what has been used in the past is always simpler and easier.

>
> >
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>>      > >> In the virtio-net specification, it is not defined wha=
t would
> >>>>>>>> happen if
> >>>>>>>>>> these features are negotiated but the VIRTIO_NET_CTRL_MQ_RSS_C=
ONFIG or
> >>>>>>>>>> VIRTIO_NET_CTRL_MQ_HASH_CONFIG commands are not sent. There is=
 no such
> >>>>>>>>>> ambiguity with TUNSETVNETHASH.
> >>>>>>>>>
> >>>>>>>>> So I don't see advantages of unifying hash reports and rss into=
 a
> >>>>>>>>> single ioctl. Let's just follow what has been done in the spec =
that
> >>>>>>>>> uses separated commands. Tuntap is not a good place to debate w=
hether
> >>>>>>>>> those commands could be unified or not. We need to move it to t=
he spec
> >>>>>>>>> but assuming spec has been done, it might be too late or too fe=
w
> >>>>>>>>> advantages for having another design.
> >>>>>>>>
> >>>>>>>> It makes sense for the spec to reuse the generic feature negotia=
tion
> >>>>>>>> mechanism, but the situation is different for tuntap; we cannot =
use
> >>>>>>>> TUNSETIFF and need to define another. Then why don't we exploit =
this
> >>>>>>>> opportunity to have an interface with well-defined semantics?
> >>>>>>>
> >>>>>>> That's perfectly fine, but it needs to be done in virtio-net's uA=
PI
> >>>>>>> not tun's. What's more, if you think two commands are not
> >>>>>>> well-defined, let's fix that in the virtio spec first.
> >>>>>>>
> >>>>>>>> The virtio
> >>>>>>>> spec does its best as an interface between the host and guest an=
d tuntap
> >>>>>>>> does its best as an UAPI.
> >>>>>>>
> >>>>>>> See above, let's fix the uAPI first. We don't want DPDK to use tu=
n's
> >>>>>>> uAPI for RSS
> >>>>>>
> >>>>>> virtio-net's UAPI is for the virtio spec which has a capable gener=
ic
> >>>>>> feature negotiation mechanism. tuntap needs its own feature negoti=
ation
> >>>>>> and it's nothing to do with virtio-net's UAPI.
> >>>>>
> >>>>> Well, I don't mean the part of the feature negotiation. I mean the
> >>>>> part for rss and hash report configuration.
> >>>>
> >>>> The feature negotiation still matters when deciding the granularity =
of
> >>>> ioctls. We need one ioctl for a feature negotiation, and to avoid ha=
ving
> >>>> an intermediate state,
> >>>
> >>> I don't understand this. For example, driver can choose to
> >>>
> >>> 1) negotiate RSS
> >>> 2) do something else.
> >>> 3) configure RSS
> >>>
> >>> Spec doesn't require those two to be configured at the same time, so
> >>> "intermediate state" is allowed.
> >>
> >> The spec doesn't define what should happen in the intermediate state e=
ither.
> >
> > Yes but my point is that in the uAPI layer we don't need to care about
> > the intermediate state. It can just work as other features, e.g having
> > a default state after feature negotiation is more than enough. This is
> > the way we deal with other features like vnet header etc.
>  > >>
> >> For a hardware implementation I think it's fine whatever the
> >> implementation defines as the intermediate state. But for the UAPI, it=
's
> >> better avoiding having such a definition to keep the interface minimal
> >> and maximize the UAPI stability.
> >
> > Well, even if you think there's an issue:
> >
> > 1) I don't see how we can avoid the intermediate state consider guest
> > have such state
> > 2) We need to "fix" virtio spec and virito-net first, tuntap is not
> > the right place to workaround virtio specific issues
>
> Let me summarize my points that support having one ioctl to negotiate
> features and configuration:
>
> The virtio spec has a generic feature negotiation mechanism and reusing
> it resulted in having an intermediate state between the feature
> negotiation and configuration. There is nothing wrong about that so we
> don't need to "fix" the virtio spec.

Good to know that.

>
> tuntap can also perform feature negotitaion with TUNSETIFF, but
> TUNSETIFF have a few problems:

TUNSETIFF is not feature negotiation, it's about device or queue
provisioning as well as the features. From the view of the virtio, it
is used to provision the device_features. For example, qemu only calls
TUNSETIFF when it tries to open the tap fd.

>
> 1. It requires a privilege. One can argue that it reduces the attack
> surface and it indeed does, but it's fine without the reduction I guess?
> It's not a feature so complicated; I saw there were complicated changes
> like namespaces and io_uring that caused controversy when exposing them
> to unprivilged users, but this feature is not like them.

I'm not asking to invent something new, but just reuse the security
stuff that has been already used for more than a decade. It would be
always easier to relax the check instead of enforce the check which
may break uAPI. I can imagine it would not take a lot of codes to
achieve this.

>
> 2. It cannot change the enabled feature set at runtime. The virtio spec
> allows changing it by resetting.

RSS is not the first feature of those requirements. TUN has
implemented various virtio specific features in the past.

>
> So we need to design a set of new ioctls for both feature negotiation
> and configuration. When doing so, eliminating the intermediate state is
> a good principle to determine the optimal size of ioctls.

As discussed, having a default state after TUNSETIFF is more than
enough. That is how a multi queue/vnet header works:

1) for multiqueue, when IFF_MULTIQUEUE is set, starting with 1 queue
2) for vnet header, vnet header will be zero unless TUNSETVETHDR is called

I don't see how RSS makes anything different.

For intermediate states, with your proposal, it still requires the
userspace to assume a default state when doing TUNSETVETRSS etc.

>
> In theory, it is possible to have small ioctls that set only one scalar
> value or even one bit, but that doesn't make sense. This principle helps
> determine the optimal size of ioctls; it minimizes the complexity of
> both the userspace and the kernel.

Well the complexity is not measured by the number of ioctls or
structures. I basically meant:

1) IF_RSS to provision the device with the RSS features, this could be
fetched from TUNGETIFF
2) Having a default state implemented in TUN that complies with the spec
3) TUNSETVET/GETHASH to send and receive RSS configuration

>
> >
> >>
> >>>
> >>>> the ioctl should also do the configuration. Hence
> >>>> that one ioctl should do all of the feature negotiation and configur=
ation.
> >>>>
> >>>>>
> >>>>>>
> >>>>>> The structures for two commands have unused or redundant fields an=
d a
> >>>>>> flexible array in the middle of the structure, but they are ABIs s=
o we
> >>>>>> can't change it.
> >>>>>>
> >>>>>> DPDK is another reason to define tuntap's own UAPIs. They don't ca=
re
> >>>>>> unused or redundant fields and a flexible array in middle that are
> >>>>>> present in the virtio spec. It will also not want to deal with the
> >>>>>> requirement of little endian. Constructing struct virtio_net_rss_c=
onfig
> >>>>>> is an extra burden for DPDK.
> >>>>>
> >>>>> I meant for vhost-user implementation in DPDK, it needs to use
> >>>>> virtio-net uAPI not tuntap's for example.
> >>>>
> >>>> The vhost-user implementation will use tuntap's UAPIs for its ethern=
et
> >>>> device backend.
> >>>
> >>> That sounds pretty weird, vhost-user has nothing related to tuntap.
> >>
> >> My expression in the last email was weird. More precisely, the etherne=
t
> >> backend of tuntap will use the UAPIs, and the vhost-user will use the
> >> ethernet backend in turn.
> >
> > I don't understand what "ethernet backend" means here.
>
> It is a driver that serves the Ethernet Device API, which is agnostic on
> application and driver. The Ethernet Device API, including RSS
> configuration is documented at:
> https://doc.dpdk.org/api/rte__ethdev_8h.html
>
> The Ethernet API are not bound to the virtio spec since they are not
> specific to the vhost application or the tuntap driver. Hence they
> operate in native endian and do not have extra fields, and tuntap's
> structures are more suited to the ethernet backend than the virtio ones.

vhost-user is the device implementation not an ethernet driver. Why
did it use tuntap's uAPI and do the useless endian conversion twice?

>
> >
> >>
> >>>
> >>>> It uses the generic interface of ethernet device so for
> >>>> RSS it will use functions like rte_eth_dev_rss_hash_update() for
> >>>> example. tuntap's UAPIs are more suited to implement these interface=
s as
> >>>> they operate in native endian and don't have extra fields.
> >>>
> >>> Nope, for example it needs to use le for virtio_net_hdr if a modern
> >>> device is used. But it needs a "native" endian according to the guest
> >>> endian via TUNSETVNETLE/BE. We don't have a choice as virtio-net hdr
> >>> support in tuntap is much earlier than modern devices.
> >>>
> >>> Let's don't do the same thing (native endian) for tuntap as RSS
> >>> depends on modern, so we know it must be le.
> >>
> >> virtio_net_hdr is the data path while the current discussion is about
> >> the control path. All configuration knobs of tuntap operates in the
> >> native endian.
> >
> > Because they are not directly related to virtio specification.  We
> > don't want to duplicate virtio-net with our own version every time E.g
> > once RSSv2 or aRFS were implemented. Or I would even introduce a
> > single uAPI to transport possible cvq commands then we can avoid
> > inventing new ioctls that just transport cvq commands.
> >
> >>
> >> So I think we should stick to the little endian for the data path whil=
e
> >> we should stick to the native endian for the control path to maximize
> >> the consistency.
> >
> > I don't see a reason to differ datapath from control path. Virtio-net
> > uAPI has been reused by tuntap for more than a decade.
>
> tuntap's control path all operate in the native endian.

It's just a description of the current status, people can easily say
tuntap's data path all operate in the native endian before the support
of version 1.0.

> They never used
> the endian of the data path in the control path.

Once virtio uAPI can be reused, we need to do that.

>
> >
> >>
> >>>
> >>>
> >>>>
> >>>> DPDk applications other than vhost-user also matter; they do not car=
e
> >>>> what virtio does at all.
> >>>>
> >>>>    > >>
> >>>>>> On the other hand, Constructing tuntap-specific structures is not =
that
> >>>>>> complicated for VMMs.
> >>>>>
> >>>>> Not complicated but redundant.
> >>>>>
> >>>>>> A VMM will need to inspect struct
> >>>>>> virtio_net_rss_config anyway to handle migration and check its siz=
e so
> >>>>>> it can store the values it inspected to struct tun_vnet_hash and s=
truct
> >>>>>> tun_vnet_hash_rss and pass them to the kernel.
> >>>>>
> >>>>> I don't see how rss and hash reports differ from what we have now.
> >>>>> Those inspections must be done anyhow for compatibility for example
> >>>>> the check of offloading features. Such steps could not be eliminate=
d
> >>>>> no matter how we design the uAPI.
> >>>>
> >>>> I explained the difference between the virtio and tuntap UAPIs, not
> >>>> between RSS and hash reporting.
> >>>
> >>> See above.
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>> The overall userspace implementation will be simpler by having
> >>>>>> structures specifically tailored for the communication between the
> >>>>>> userspace and kernel.
> >>>>>
> >>>>> This is exactly how a good uAPI should behave. If uAPI in virtio-ne=
t
> >>>>> can't do this, I don't understand why uAPI in tuntap can solve it.
> >>>>
> >>>> The UAPI in virtio-net cannot do it because it's already fixed and i=
t
> >>>> also needs to perform endian conversion for the VM use case. tuntap
> >>>> doesn't have these restrictions.
> >>>
> >>> Same here.
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>> I don't think there is an advantage to split ioctls to follow th=
e spec
> >>>>>>>> after all. It makes sense if we can pass-through virtio commands=
 to
> >>>>>>>> tuntap, but it is not possible as ioctl operation codes are diff=
erent
> >>>>>>>> from virtio commands.
> >>>>>>>
> >>>>>>> I don't see a connection with the operation code. For example, we=
 can
> >>>>>>> add new uAPIs in virtio-net which could be something like:
> >>>>>>>
> >>>>>>>      struct virtio_net_rss_config_header {
> >>>>>>>           __le32 hash_types;
> >>>>>>>           __le16 indirection_table_mask;
> >>>>>>>           __le16 unclassified_queue;
> >>>>>>>           __le16 indirection_table[];
> >>>>>>> }
> >>>>>>>
> >>>>>>> struct virtio_net_rss_config_tailer {
> >>>>>>>           __le16 max_tx_vq;
> >>>>>>>           u8 hash_key_length;
> >>>>>>>           u8 hash_key_data[];
> >>>>>>> }
> >>>>>>>
> >>>>>>> These two are used by TUNSETVNETRSS. And simply reuse the
> >>>>>>> virtio_net_hash_config for TUNSETVETHASH.
> >>>>>>     > > With this, we can tweak the virtio-net driver with this ne=
w uAPI. Then
> >>>>>>> tap* can reuse this.
> >>>>>>
> >>>>>> I implemented a UAPI and driver change accordingly:
> >>>>>> https://lore.kernel.org/r/20250318-virtio-v1-0-344caf336ddd@daynix=
.com
> >>>>>>
> >>>>>> This is a nice improvement for the driver, but I still don't think=
 it is
> >>>>>> suited for the UAPI of tuntap.
> >>>>>
> >>>>> Any reason for this? It should work like virtio_net_hdr.
> >>>>>
> >>>>>> The requirements of extra fields and
> >>>>>> little endian cannot be removed from the virtio spec but they are
> >>>>>> irrelevant for tuntap.
> >>>>>
> >>>>> I don't understand this part. What fields are "extra" and need to b=
e
> >>>>> removed from the spec?
> >>>>
> >>>> All fields not included in struct tun_vnet_hash and struct
> >>>> tun_vnet_hash_rss. Namely, for struct virtio_net_hash_config:
> >>>> - reserved
> >>>> - hash_key_length
> >>>> - hash_key_data
> >>>>
> >>>> For struct virtio_net_rss_config:
> >>>> - max_tx_vq
> >>>> - hash_key_length
> >>>
> >>> See my above reply, and I basically meant
> >>>
> >>> TUNSETVETHASH accept struct virtio_net_hash_config;
> >>> TUNSETVETRSS accept struct virtio_net_rss_config_hdr + struct
> >>> virtio_net_rss_config_trailer;
> >>
> >> That still bring the extra fields I noted in the last email.
> >
> > I don't know how to define "extra" here. Let's summarize here:
> >
> > Method A:
> >
> > 1) virtio specification use separate commands for has_report and rss
> > 2) hash_port ans rss doesn't depend on each other
> > 3) reuse virtio-net uAPI
> >
> > Method B:
> >
> > 1) trying to define and remove the "extra" fields in tuntap, and
> > redefine it in TUNTAP
> >
> > It would always be much easier to start from simply reusing the
> > virtio-net uAPI. Method B makes both the implementation and reviewing
> > harder, as we need to
> >
> > 1) revisit the design of the virtio spec, this needs to be done in the
> > virtio community not here
> > 2) audit the difference between virtio spec and TUN/TAP, that's why we
> > have a very long discussion here
> >
> > For example, the root cause of why you think the max_tx_vq is "extra" i=
s:
> >
> > 1) The spec defines VIRTIO_NET_F_RSS and VIRTIO_NET_F_MQ as independent=
 features
> > 2) Your code tries to re-use IFF_MULTI_QUEUE for both VIRTIO_NET_F_RSS
> > and VIRTIO_NET_F_MQ, this would have a lot of implications, e.g
> > automatic steering might be applied when only RSS is negotiated etc
> >
> > The correct way to implement this is:
> >
> > 1) Introduce IFF_RSS and only set it during TUNSETIFF when device only
> > offers RSS
>
> Please see the summary of "my points that support having one ioctl to
> negotiate features and configuration" I wrote the above.
>
> > 2) reuse virtio-net uAPI and accept max_tx_vq and use that to change
> > the queue(or queue paris) if necessary
>
> I don't think it's possible; we need file descriptors associated with
> queues, which is something you cannot express with the virtio-net
> structures.

So:

1) Provisioning queues were still done via TUNSETIFF
2) We just need to hook max_tx_vq (the helpers were already there) to
the helpers to enable and disable a queue instead of depending on the
TUNSETQUEUE

>
> Regards,
> Akihiko Odaki

Thanks


