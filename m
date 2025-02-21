Return-Path: <kvm+bounces-38822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DDFA3E9BD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7978C172CC0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D2E4A3C;
	Fri, 21 Feb 2025 01:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0o4AW0S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BBE84D2B
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740100513; cv=none; b=ej1D5JtcmHWnisqMjLrq70EbA6fB5PL3T0bpRpMBFwp3EddU85VZHPeoU3D9u9StiKLDN/eTvQ2FYe80sv9vjDKVDxrFaX2yuIoR95geGOT9eIHdD0uqFD2AKrAYx/KR6fDVwgGl1b02euJWkXFlu8uMcuBMVSCSfRWvLkk9eo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740100513; c=relaxed/simple;
	bh=/bGiavS8jq7e1a/UcoH9zlpN1YkLl+PW6P8a+yl2sIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qN6+beNP7DdBIeImGXcIA6/R5pBYAvbUcR5dsC6ow+bthvcnJGxJu1vzTVh0aM7s16+/oRGW1AXaGOlxhsQamAeS9Zrl1yEqWJwxZ/8FPvwE9ymp+sjwxrFhNHzJwedioIXPvKzYVDFreVfWK15A4rjHD6Hn2v+wCulGiBiwhbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O0o4AW0S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740100510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/bGiavS8jq7e1a/UcoH9zlpN1YkLl+PW6P8a+yl2sIA=;
	b=O0o4AW0S4KF4+1E1qQeOtCSp2vnpW40WlgKXQMJhSXp3bg0QIKJXbPSOAq9abp8GrjmZuE
	kuWSpIZwxH3rHfGeuadNJ/MYs9oDmap3VGg0sC5SyiXxgGcyge6fGqoRar3vRx7WKswtci
	auH4iWwP1TuLpGulNsdYEKkNT+W4S4Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-gnoFzHNgPoiAe5OwuFsX3g-1; Thu, 20 Feb 2025 20:15:09 -0500
X-MC-Unique: gnoFzHNgPoiAe5OwuFsX3g-1
X-Mimecast-MFC-AGG-ID: gnoFzHNgPoiAe5OwuFsX3g_1740100508
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2217b4a48a4so31555355ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740100508; x=1740705308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bGiavS8jq7e1a/UcoH9zlpN1YkLl+PW6P8a+yl2sIA=;
        b=hna7idHy/s/c/UjalU94w2A6qOURmju/KXLTrpX4nNXtPKUMHlzV6cZwECIVIqFjK+
         481gsNXZtuW7Qe096Ue1ezXi+tMj9xCd8Biv7bedfFdyh+5dBDUBX6gesZfmn5/ZRQi6
         AWOrHO9d2+5i0D68Mpeu2dfck7sjLzRSdqm6QOy8ohBtLnTUZKafPTUoXZQdlo5pbYDb
         8uh5wlocGUfjiVl9tTv3mZVd9LKz+kHgxRTtqdA9SaPVpEOaVSMzc1YsjyFEO6dUDi/F
         50805hf2+dAjPKBFfaixdOe1cRSrtYKGPE3BAoJ6wdKhX6LigMAuQnDiZRjBjdQ7dcH3
         92iA==
X-Forwarded-Encrypted: i=1; AJvYcCVMf7bCfDmTALAh9QGLDckZ/BS/0/QleznILZfR9FCySdwoTeOLpzyXs1QKvUmqKfsKykc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRQOVJqIzLXsz/fn9nAMUiwn5wei8QA4mHBHm/s7obKeObJaF6
	aSU/5PUbStGgKYXiROxofuexmtqNGevdZcjHAxCW/hDi0D/A7VHsjr/yG26UPfdOxT6rEZw7cX6
	GOg35yz4Ws8BpInW8qsTsD+gw8FaPRpPjhy4y/+upGrIjOMC7XxJc/zLUGdijZN6aF/8/AjM9Oq
	Txw4EaqZqMwVJagZjote8As+et
X-Gm-Gg: ASbGncu5aWBfBiLgrBuFc4TwXT6XwJklaIQl0qQKZPOK3oHXf1r7aUHicuKDrMVFxRU
	biyu2q1GgN+qlLmvQlomc+Fp92hYkEIwJQiuwTdALZGmBa/QFqVlqZodxVpb3WB8fadgpDrIL2Q
	==
X-Received: by 2002:a17:902:fc44:b0:215:bb50:6a05 with SMTP id d9443c01a7336-221a0ec944cmr13551815ad.9.1740100508433;
        Thu, 20 Feb 2025 17:15:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNUoAtdLLCDrmQ4E0KhxP1/v8E8OjE3hwAErurd7Thltd/lsB3alr0YyGDAyw/Vnr52MolQRVxcb5jecipEJY=
X-Received: by 2002:a17:902:fc44:b0:215:bb50:6a05 with SMTP id
 d9443c01a7336-221a0ec944cmr13551285ad.9.1740100507900; Thu, 20 Feb 2025
 17:15:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250215-buffers-v2-1-1fbc6aaf8ad6@daynix.com>
 <d4b7f8a0-db50-4b48-b5a3-f60eab76e96b@redhat.com> <20250220034042-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250220034042-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 21 Feb 2025 09:14:56 +0800
X-Gm-Features: AWEUYZk12eKYMoRdAhOr_VqKFdK71rl0l2JCQtxsCVicbAIDmOs5Fp4sSGUmfl4
Message-ID: <CACGkMEtN1K7jRVmZwxah1vET=p5k_Nd0cpov=R0B8sP=bjC-sA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: Pad virtio headers
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, 
	Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 4:45=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Feb 20, 2025 at 08:58:38AM +0100, Paolo Abeni wrote:
> > Hi,
> >
> > On 2/15/25 7:04 AM, Akihiko Odaki wrote:
> > > tun simply advances iov_iter when it needs to pad virtio header,
> > > which leaves the garbage in the buffer as is. This will become
> > > especially problematic when tun starts to allow enabling the hash
> > > reporting feature; even if the feature is enabled, the packet may lac=
k a
> > > hash value and may contain a hole in the virtio header because the
> > > packet arrived before the feature gets enabled or does not contain th=
e
> > > header fields to be hashed. If the hole is not filled with zero, it i=
s
> > > impossible to tell if the packet lacks a hash value.
> >
> > Should virtio starting sending packets only after feature negotiation?
> > In other words, can the above happen without another bug somewhere else=
?
>
>
> Not if this is connected with a guest with the standard virtio driver, no=
.
> The issue is that tun has no concept of feature negotiation,
> and we don't know who uses the vnet header feature, or why.
>
> > I guess the following question is mostly for Jason and Michael: could b=
e
> > possible (/would it make any sense) to use a virtio_net_hdr `flags` bit
> > to explicitly signal the hash fields presence? i.e. making the actual
> > virtio_net_hdr size 'dynamic'.
>
> But it is dynamic - that is why we have TUNSETVNETHDRSZ.

Yes, tun currently only recognizes a subset of the whole virtio-net header.

Thanks


