Return-Path: <kvm+bounces-35611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37ECA13078
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 02:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 445167A249C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 01:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F269728382;
	Thu, 16 Jan 2025 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OE3ZqqWY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D44322098
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736989630; cv=none; b=XB6W4tU2BuvTGR1Hze7+F8NlncdGJ/gLM8KaVABFs0AhpEJwhoyP0jiY3HA5ftPPd+sFezV9WpmDoSDTcsj2DA2y5DksX5nr3TI2eMHrYUbkO3cBMMec434uQ07Klp53Egzm2JSGxBDt4dq5obIDoGSlBOT8oo/ZP3NQ5MAMKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736989630; c=relaxed/simple;
	bh=wlj81as0MSR+2QoKMzymAk7Z0bJsw6YvCNC5UATgJPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHjrHQqu1Gs10dbF7fE6yxJuJY65wtIdKT4t3chUzivcX9wqGIzJoQ+PISaJmpuqoo7IN6PAIG4HEQsD2x4df5Y3mEaJpuAPwYP3O0QZ6xDBO2woETPtYG1S6c6BMZMU+n/MlwpcVu2PUy9BVvqRu0fgkEtPTARPlVoNE4UrNFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OE3ZqqWY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736989627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlj81as0MSR+2QoKMzymAk7Z0bJsw6YvCNC5UATgJPE=;
	b=OE3ZqqWYdzUo9+pSRk0ipVvvLEEdgBgRlq4uulUTWi2EaDEjAoIMQAchpw00g8RtfgjIdx
	Oilhaiq0+DAukJP/cwx9ySAs2KkLrO5l+y5hoECY0SC7qUJnSeCiTsoNYEEmqZc4GUcXb/
	E0Yt3dRuQRmcyHHf5WuRLnv4PH3FFho=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-xEj08yH6Nz-sEyaerjqzIQ-1; Wed, 15 Jan 2025 20:07:06 -0500
X-MC-Unique: xEj08yH6Nz-sEyaerjqzIQ-1
X-Mimecast-MFC-AGG-ID: xEj08yH6Nz-sEyaerjqzIQ
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ee6dccd3c9so845338a91.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 17:07:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736989624; x=1737594424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlj81as0MSR+2QoKMzymAk7Z0bJsw6YvCNC5UATgJPE=;
        b=U52DSaODL9Il7IlPU5O3M3RnOjrBG5Y8LpkOG84R3bWi3/DampGzkSRCzjscmeWL0H
         5picu4Bqgfdi8P1Kr420egHRJg/nFdiO6WlLzp9RaNhOcttUXJFkOSvtaVNOMVn0Tia7
         PPrA8eIfJPNELUJ1ZrA4Rd9ymMA4q77kWdVivGYgC9bnG8YEBEHBL3SHrG+22Wkh9WdO
         tusJGhxqHX7ESOnJFcEUzDXqrX+DyDvfpcqWOCIfAFw+I/5y5f3szFfSaSL1dLNrlHsm
         id3caRmPt/cnPD6YkLr9rdX+cm1p0hYc0njnsxgUoqTXE7/yPaePeyM62O1+1Jb9Gs3x
         1JSw==
X-Forwarded-Encrypted: i=1; AJvYcCVFhOO0i52WQVOvtLj/hvfQOYmb5WDFIh/o8i5LosjQ8lq8qdR8gZEGzzInQI7KkkQu2Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCKrWinyh5TQn1qjvOL2yY9YD+0MT58kWlcY/fbL9cVC2Cga7x
	4BC5ObnLUWRip/g2/mCY2w9VafrDbAUfG9vaKHsbdYFDSYMbnteSRP4n6bKa4TNA12jfWVouvNb
	0M8+1f/N4JqdvV7nBr1cn71n6OiHdxAN5KWTKs8PvUCuMESnT6JvjVXAxU+/67QwSYTDYbfgNVC
	opLGuCGwIgQJNSDQHjXCK67YneYMkLotNxek9v/w==
X-Gm-Gg: ASbGncvsC0ZaP4RmKectUy/x62ozQFW/88jNxUOJNff7V6gbC8KYOtHqCo8Ms7Jo5fW
	U7PfoWPazPSloIHCSQYEq96PQqvi5kI0dKG+q0Sc=
X-Received: by 2002:a17:90b:51cb:b0:2ef:3192:d280 with SMTP id 98e67ed59e1d1-2f548f162acmr41742264a91.5.1736989624168;
        Wed, 15 Jan 2025 17:07:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXTlxUYfojfThpUlYe1bY0TrNIHeZ7wOATIqqDywvf5ON2WLv7gIgxHZLXiKaVB1ytp3colHV+0p05xw+gzAU=
X-Received: by 2002:a17:90b:51cb:b0:2ef:3192:d280 with SMTP id
 98e67ed59e1d1-2f548f162acmr41742236a91.5.1736989623732; Wed, 15 Jan 2025
 17:07:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
 <20250110052246-mutt-send-email-mst@kernel.org> <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
 <CACGkMEuiyfH-QitiiKJ__-8NiTjoOfc8Nx5BwLM-GOfPpVEitA@mail.gmail.com> <fcb301e8-c808-4e20-92dd-2e3b83998d18@daynix.com>
In-Reply-To: <fcb301e8-c808-4e20-92dd-2e3b83998d18@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 16 Jan 2025 09:06:52 +0800
X-Gm-Features: AbW1kvY854xB4UWOJdJLBydWl06vsh4taL7pE63yt9P1_IVO_L6kO5WvWI7S_B8
Message-ID: <CACGkMEvBU3mLbW+-nOscriR-SeDvPSm1mtwwgznYFOocuao5MQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 1:07=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> On 2025/01/13 12:04, Jason Wang wrote:
> > On Fri, Jan 10, 2025 at 7:12=E2=80=AFPM Akihiko Odaki <akihiko.odaki@da=
ynix.com> wrote:
> >>
> >> On 2025/01/10 19:23, Michael S. Tsirkin wrote:
> >>> On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
> >>>> On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odaki@=
daynix.com> wrote:
> >>>>>
> >>>>> The specification says the device MUST set num_buffers to 1 if
> >>>>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> >>>>
> >>>> Have we agreed on how to fix the spec or not?
> >>>>
> >>>> As I replied in the spec patch, if we just remove this "MUST", it
> >>>> looks like we are all fine?
> >>>>
> >>>> Thanks
> >>>
> >>> We should replace MUST with SHOULD but it is not all fine,
> >>> ignoring SHOULD is a quality of implementation issue.
> >>>
> >
> > So is this something that the driver should notice?
> >
> >>
> >> Should we really replace it? It would mean that a driver conformant wi=
th
> >> the current specification may not be compatible with a device conforma=
nt
> >> with the future specification.
> >
> > I don't get this. We are talking about devices and we want to relax so
> > it should compatibile.
>
>
> The problem is:
> 1) On the device side, the num_buffers can be left uninitialized due to b=
ugs
> 2) On the driver side, the specification allows assuming the num_buffers
> is set to one.
>
> Relaxing the device requirement will replace "due to bugs" with
> "according to the specification" in 1). It still contradicts with 2) so
> does not fix compatibility.

Just to clarify I meant we can simply remove the following:

"""
The device MUST use only a single descriptor if VIRTIO_NET_F_MRG_RXBUF
was not negotiated. Note: This means that num_buffers will always be 1
if VIRTIO_NET_F_MRG_RXBUF is not negotiated.
"""

And

"""
If VIRTIO_NET_F_MRG_RXBUF has not been negotiated, the device MUST set
num_buffers to 1.
"""

This seems easier as it reflects the fact where some devices don't set
it. And it eases the transitional device as it doesn't need to have
any special care.

Then we don't need any driver normative so I don't see any conflict.

Michael suggests we use "SHOULD", but if this is something that the
driver needs to be aware of I don't know how "SHOULD" can help a lot
or not.

>
> Instead, we should make the driver requirement stricter to change 2).
> That is what "[PATCH v3] virtio-net: Ignore num_buffers when unused" does=
:
> https://lore.kernel.org/r/20250110-reserved-v3-1-2ade0a5d2090@daynix.com
>
> >
> >>
> >> We are going to fix all implementations known to buggy (QEMU and Linux=
)
> >> anyway so I think it's just fine to leave that part of specification a=
s is.
> >
> > I don't think we can fix it all.
>
> It essentially only requires storing 16 bits. There are details we need
> to work out, but it should be possible to fix.

I meant it's not realistic to fix all the hypervisors. Note that
modern devices have been implemented for about a decade so we may have
too many versions of various hypervisors. (E.g DPDK seems to stick
with the same behaviour of the current kernel).

>
> Regards,
> Akihiko Odaki
>

Thanks


