Return-Path: <kvm+bounces-11105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A15A9872E6B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 06:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35ADA289EF6
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 05:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8711BDD3;
	Wed,  6 Mar 2024 05:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1dv+Wcd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38117BCC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 05:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703151; cv=none; b=lnt6tz0BmVjCxjXRIu42hcM69Te3rP1gENQhkOiDQZa/P6dwvtoX0MUrSaU8wgMWEOmiRiVPqOWJy9a+ar+bgVfC3ZcUrzJ4/RGBX9+KhlSZwHBjboYGgKwO1giRyQ3Bd+uN3tpWZDQIJ7vaY2Ef/czQyZHpO22+fWF0nrFjmIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703151; c=relaxed/simple;
	bh=TU6enkAGhxLVo9zYShsbcBwAQaBFKNnqNn+vF6qWndE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jH/dk5vtIcI8WpTKz8JUxP0lpr9uiSXunjK/kr6xskLEyjF5c9zhABO25oZaJGGdlvG/yJIFPdffeiaHEETueD2boZ8Udjv6FZlWCWUsv7b92CPyLTx+htyGOMRHfNwAHfVCY8NbunEXuiNUeLgyBibeGD1J5lZtwtdLwKY8zU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1dv+Wcd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709703148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TU6enkAGhxLVo9zYShsbcBwAQaBFKNnqNn+vF6qWndE=;
	b=T1dv+WcdWYKcByo0uJmYOsN4AmmTeXH7YGC3F0ki0PFx+Xc3mpEfRwAe8jSvTCqcrjWw7i
	dbPZy9vfhwAvHSvIp3hfYcNxVHpvgeUrQCOKMSbagSyzvkKPHQd5qB/9COAHF8/hRlViXP
	hNuXvaH39HUOZQ/MUIeoYJWT+hlGUJ0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-AyFwCJL4P3iOx_BFPXNV7Q-1; Wed, 06 Mar 2024 00:32:27 -0500
X-MC-Unique: AyFwCJL4P3iOx_BFPXNV7Q-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dd01e6a1beso41227995ad.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 21:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709703146; x=1710307946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TU6enkAGhxLVo9zYShsbcBwAQaBFKNnqNn+vF6qWndE=;
        b=Fngw7F+lQaUIdXGEts/363Dyi2r80spNv7xNNLSZ3MSn+LXVoajFmVsPbE8Oq0zZO2
         BmQJv04gEzJG2DkfnXNIXuyd2OgvML6hpjPwgPgaA68PGOfbZgY0BFBtdaw0Tip90FwW
         lTJDAIvD1NL5qKU+rI35ozGa9oiG4gvNYnccV6b8zt2X8PjBYPvw2ItPRNsF8qMHBfIK
         7othfSxdneGWZKQWs/SzR8nDQjPogQAjnw1mwxotqLrNixzjlBJK1GpeCE87a6GNhFY2
         LrsJHeSNNDSsPFlipZFVCPIBrMoTt2j5bWKa0k1tqhH8Al09bKPNP1mSuK1K802+QVX9
         f2Mw==
X-Forwarded-Encrypted: i=1; AJvYcCUBDErfKfrAq6S18Uqf2RJkdY9u6Y7ZPCoIgiNLjNmltXoaykXpvXvOeAh9BuSU55rvXigvD3DftxkHiMhfjCLZ4Ipo
X-Gm-Message-State: AOJu0YzoSrqBtAe+wLowD5uSimjcGb9tBfwM6NQAtGE2cd81XzQW6VXg
	qxODjvU/JiXzrHl8e62uXvoBDjPaPo7VCkgw6QCpu59YW2Q6TRndZ/yvieCS9gPetqhqfFJaVwQ
	znNCjJfFzZwk3aA+2x39Z3frkB5lhL9BYULylwj8E3iYomhXw5j9gjIDLYYMHvjK8YxVruGBi4l
	t5sdb5tkf9sg/RnrIOIbVk3Qw6
X-Received: by 2002:a17:90a:d24f:b0:29a:e097:50be with SMTP id o15-20020a17090ad24f00b0029ae09750bemr11686569pjw.31.1709703146442;
        Tue, 05 Mar 2024 21:32:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFevY310UVbmpQFlUk/kqBWvaY92fb2a59CmZ2Hx22y1HnOSHWpHQhrAOQOaJV/YvhnP8j2q2riF5z5dzcbMWs=
X-Received: by 2002:a17:90a:d24f:b0:29a:e097:50be with SMTP id
 o15-20020a17090ad24f00b0029ae09750bemr11686548pjw.31.1709703146152; Tue, 05
 Mar 2024 21:32:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <ZeHiBm/frFvioIIt@boxer> <65e2212e66769_158220294f@willemb.c.googlers.com.notmuch>
In-Reply-To: <65e2212e66769_158220294f@willemb.c.googlers.com.notmuch>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 6 Mar 2024 13:32:14 +0800
Message-ID: <CACGkMEsd4icR3EDHS-4DjmKMeez41r2SnNP4j70gAdzq8O=w=w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com, 
	kuba@kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com, 
	jonathan.lemon@gmail.com, davem@davemloft.net, bpf@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, xudingke@huawei.com, liwei395@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 2:40=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Maciej Fijalkowski wrote:
> > On Wed, Feb 28, 2024 at 07:05:56PM +0800, Yunjian Wang wrote:
> > > This patch set allows TUN to support the AF_XDP Tx zero-copy feature,
> > > which can significantly reduce CPU utilization for XDP programs.
> >
> > Why no Rx ZC support though? What will happen if I try rxdrop xdpsock
> > against tun with this patch? You clearly allow for that.
>
> This is AF_XDP receive zerocopy, right?
>
> The naming is always confusing with tun, but even though from a tun
> PoV this happens on ndo_start_xmit, it is the AF_XDP equivalent to
> tun_put_user.
>
> So the implementation is more like other device's Rx ZC.
>
> I would have preferred that name, but I think Jason asked for this
> and given tun's weird status, there is something bo said for either.
>

From the the view of the AF_XDP userspace program, it's the TX path,
and as you said it happens on the TUN xmit path as well. When using
with a VM, it's the RX path.

So TX seems better.

Thanks


