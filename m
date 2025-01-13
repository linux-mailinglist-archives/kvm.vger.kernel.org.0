Return-Path: <kvm+bounces-35265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81761A0ADBB
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 04:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B0283A6E62
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3F2146D53;
	Mon, 13 Jan 2025 03:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fsc7244g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D731386C9
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 03:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737483; cv=none; b=mUecPz1dvd66Ec5laAlPEFsFjoQanb4HDpL3wfPBMTWwULtGuxGUHh9yrvXegZKzRnHr6fkD1w9MPVWPUQgifw6Z3Lad0YSfEZrCb9QGUnPT817D6i/lO4EEhREROCUfi7393rkLd8YjePTF45zO1UuojSiRJId9j4IANjFwAgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737483; c=relaxed/simple;
	bh=yRJfycwjDy0VxrwiaDvig/uV5jBkPvBFTkhNp60TiSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmcgqRwh62kTxr7wA67Y47kCyK0DglU844HuC7kRyVgGLNPjEAGgIf2iiqdWXA0kihkIGcn0ikwO6mMzZrIfuC9WS+I76/5z06MesFwkLF9Hb4kei9cZ39lnSwiWaVnEqw0sqMpYi5jCZ8pgqAKisD5Cuj46f1XI3XUvJ1+ziXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fsc7244g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736737480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRJfycwjDy0VxrwiaDvig/uV5jBkPvBFTkhNp60TiSo=;
	b=fsc7244gYUZDhj+ctReourSip5yMk+1Uz2+zQDmrftqhxD+iqGSPcxdNp1EBwePaqv5UxX
	QakNeR4NZJa56Q/rFvfv/uW8PrjEav/Q8EF6UazGEifxqrpI2rAqeQnU+vTKm0bhwOZh90
	bIywpt8P+nRNGd7QYZjg0y8azGzFYaw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-VIPh-xF9NBe9795LwzUGFg-1; Sun, 12 Jan 2025 22:04:37 -0500
X-MC-Unique: VIPh-xF9NBe9795LwzUGFg-1
X-Mimecast-MFC-AGG-ID: VIPh-xF9NBe9795LwzUGFg
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ef91d5c863so6890935a91.2
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 19:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736737476; x=1737342276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRJfycwjDy0VxrwiaDvig/uV5jBkPvBFTkhNp60TiSo=;
        b=Nbhwsu8f/kgcg1hERFL6SM+lOz+scGfc3pQbcrV26ErOESvp747i62A2KgW+lOMumM
         QKxsEksIYH09k7UAOFKe7/pxO0O5dagCN7z0wCUJD25qD2pdoSK9aN0WL/nK15EONcwb
         MAl/cSv76oRhkwV3vE8Y6iJgPDTKY9DYD74it/mNlwysJRCXJqYYTTW9/mnf3ZLaYg/t
         C+AqMPeawSj8PuGOddUCj3lzJFgJS3LKwlhRnS6yetitmTaU/BPltSielZjlEh3MGOtM
         cMyH6JhZKSJdWZWdwAaBjHQkJ8smULgAsdONsZbx0QA7YYJykbaCNSV05PXLOpTHU+UF
         FBZA==
X-Forwarded-Encrypted: i=1; AJvYcCVh/LowOxzWY2duVt/hGBNd0IMFmD2Hne1NVk7+ZE1EUdTc1psnt2RwR4Y1mXFfmxu7WIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQzRr2kQeoVp9M7vItVQgAlzA5PmHHv5Hh2lAbi5qvvXBBt7BZ
	CLfc5hF1Y4ea8fsaWHBtZMQN/ZI4YyQyjZJWTKmvRk2n0CAMR6TylWEaGYSkTjD1wLQK3NmkJ5y
	u6taspwX1+KCbryNqoXdIPDR/9I5RtgLJcKI6NM8KTkvnnqgolfNV9IkRztjff6KusQIPaHg72t
	mmJ0IEQ/aO4pC6kcZTx1fyyQZJ
X-Gm-Gg: ASbGnct8B7wF4vNq7x+jqCws+xMK6bl4FcKGUxN7BASPpKQ6vGIg7AJg8imjzL9v+1W
	JmSPypHiTCC+c/WFXAYsWS2txKKAwDOXcahUJayM=
X-Received: by 2002:a17:90b:5145:b0:2ea:37b4:5373 with SMTP id 98e67ed59e1d1-2f548eac588mr28389805a91.10.1736737476516;
        Sun, 12 Jan 2025 19:04:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3vQ4vRdPBx0guyoTg5ZpyZUQ/sA/eheHAAs75pTrkZhjd2AbRMvv82RBzJBTsua8lQjGaRuJEc2TbijFE4yM=
X-Received: by 2002:a17:90b:5145:b0:2ea:37b4:5373 with SMTP id
 98e67ed59e1d1-2f548eac588mr28389757a91.10.1736737476052; Sun, 12 Jan 2025
 19:04:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
 <20250110052246-mutt-send-email-mst@kernel.org> <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
In-Reply-To: <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 13 Jan 2025 11:04:24 +0800
X-Gm-Features: AbW1kvZHQU9iIwkWwKeABYuwHLZExY2G4KWx_BvVBrd2ec7v_BAcbnTLlgvVmZE
Message-ID: <CACGkMEuiyfH-QitiiKJ__-8NiTjoOfc8Nx5BwLM-GOfPpVEitA@mail.gmail.com>
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

On Fri, Jan 10, 2025 at 7:12=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> On 2025/01/10 19:23, Michael S. Tsirkin wrote:
> > On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
> >> On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odaki@da=
ynix.com> wrote:
> >>>
> >>> The specification says the device MUST set num_buffers to 1 if
> >>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> >>
> >> Have we agreed on how to fix the spec or not?
> >>
> >> As I replied in the spec patch, if we just remove this "MUST", it
> >> looks like we are all fine?
> >>
> >> Thanks
> >
> > We should replace MUST with SHOULD but it is not all fine,
> > ignoring SHOULD is a quality of implementation issue.
> >

So is this something that the driver should notice?

>
> Should we really replace it? It would mean that a driver conformant with
> the current specification may not be compatible with a device conformant
> with the future specification.

I don't get this. We are talking about devices and we want to relax so
it should compatibile.

>
> We are going to fix all implementations known to buggy (QEMU and Linux)
> anyway so I think it's just fine to leave that part of specification as i=
s.

I don't think we can fix it all.

Thanks

>


