Return-Path: <kvm+bounces-51809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3516AFD78A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 21:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67A041C26C2C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 19:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19CF23A9BD;
	Tue,  8 Jul 2025 19:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acaZgnYj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EB21CC5A
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752004216; cv=none; b=rhjzUweLV9FD4jtpQ4P9FcQ6PzWLolbdh6nx4u2z4s3j5B1TizABHqvCiGDCUpQs/70jhZOUziIUit2h3xMR4kykvusLlVqdpvgKWgpDbSAxSduCVH1LonFDocjP+kiDwvFK8GaOJB1f3cUrDbQRLP9nniRBnvJpCVv3H1ngetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752004216; c=relaxed/simple;
	bh=Y0iXoUqOLs0llj8Kqny8AlCcLxbD6abRir5vykfWqaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqS847ZLZ9HjGCbCTN0w5MO13YAk9mG2HROsBThtE1G9g3hgaPInd3QE6ot6uHw6CUU7UUo5rV9xx7Or4h3cVtjvDCrtwQy2kcrOlIY6jdiBNi0A5vUFl5Ov02sWR4FqutAkzPeZ24BczRFRiuRJTqkOaInMyuERJP3Xhpl/Rrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acaZgnYj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752004213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LikuVg883RBnSofMj2iv/RfyoEWwYa7j+D9dFy02hRA=;
	b=acaZgnYjSQYldoe0kl+GmPtgv9mVlZkx07qTAiHqHZQfDA90f9DsyG4BZuYDNmOKGXeG2q
	a3VDhYBUVsbTVY4N6s5yxH3VwSjye0s9R6EhDTI16HBh5Xh+Whpq3i38yAbTjUJ7mfv3es
	HCGc1byXU6BHluZM9hpEuhT4bpeuLNg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-acwgP8WdO5qE5eWHkq2_BQ-1; Tue, 08 Jul 2025 15:50:10 -0400
X-MC-Unique: acwgP8WdO5qE5eWHkq2_BQ-1
X-Mimecast-MFC-AGG-ID: acwgP8WdO5qE5eWHkq2_BQ_1752004210
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4e713e05bso2004449f8f.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 12:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752004209; x=1752609009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LikuVg883RBnSofMj2iv/RfyoEWwYa7j+D9dFy02hRA=;
        b=oE/I66IU9zGDgfhjjbOxPmOhUsZImbJIQI1v1KQP07/m6Sp/N14hfD1kjmTC0/Viys
         eVlRNG9UhI4w9YtRgCKiZsiTAE8WUg2NBhCvQZRvmvw6XRLrH6dlVW6rPx33Jyevi+AK
         0vvkZOLH9rATMJ/ecra9TsardbmDby7HpQz8oBahjnC/agW83vdpqxunCj88BOS28lDE
         +0IPmrt2IXByutIfOs+J+Znos4kd5we/kILx+Oy/iw3LGwkFmW0gJuEfjhnOrobCoOqq
         UEmuY+iKcJd+a+NpisO6uadSW8lq63ZOZzNxR+k2mJy+2LME2jl5qxqvV3vKcf6BcBin
         N+rw==
X-Forwarded-Encrypted: i=1; AJvYcCX6BLbLAC4hAV7lioAp7fB0WaGpBn2d/sJE9CYIDxHJU9WgrKu6We1HS3EZFbfxhIcIEsM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoHSFnQGGCEpovkiVou6Cd4K6HHJPb4W44DIdw/7WgnoYdhl9h
	6TLp9yHbaK9ObXVjvpcg7o5mSzHl1u1lpfyg2kGwe2X/nXn/p6iVTUIpFZjfBqETI00kgxLsrMJ
	QVUT3zRsjhZKBDx3cF9Evo5W0aoiNLzkSyHUiVB7ne3g6XNwb/V4f2w==
X-Gm-Gg: ASbGncsvzoKXY+f5L10f1FqurADWocApsfHrPQo4GNbOdCi0buKwdUfXBPTKRZSE84W
	Hvk3RSo4PdsV7rAFb4A0QzEAE0LlP+ryZ3YGNoRU0YlGQ75MLzEbUFA6jLxuLWcPEeNqmMiPI1P
	PvdSTpXSP71pLseddj0BMd4wquD3yEJ8uUh0v07tKpoyrjzKX2XNd+Lgw4ll05t9e999KZ73w0M
	GChYwhvbRFkvWYMLmaE8Yz9pIYkThkca5F30O2ZdkVzIuP2JTMEW65pUFcd34aXqRxbdbb5LZp7
	zlKzHQ8CDF3WDxA=
X-Received: by 2002:a5d:5d0e:0:b0:3a4:f35b:d016 with SMTP id ffacd0b85a97d-3b497011a15mr15320226f8f.11.1752004209400;
        Tue, 08 Jul 2025 12:50:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1jBraagOsk3QI107z1D1hHowlYV/qp00H/NJFxbB801oXkh53Lpf4M+P4ApVMlSTE/u2Aig==
X-Received: by 2002:a5d:5d0e:0:b0:3a4:f35b:d016 with SMTP id ffacd0b85a97d-3b497011a15mr15320197f8f.11.1752004208849;
        Tue, 08 Jul 2025 12:50:08 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cd49e64dsm30477795e9.34.2025.07.08.12.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 12:50:07 -0700 (PDT)
Date: Tue, 8 Jul 2025 15:50:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
Message-ID: <20250708154718-mutt-send-email-mst@kernel.org>
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
 <20250708120014-mutt-send-email-mst@kernel.org>
 <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
 <ef9864e5-3198-4e85-81eb-a491dfbda0d2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef9864e5-3198-4e85-81eb-a491dfbda0d2@redhat.com>

On Tue, Jul 08, 2025 at 07:00:19PM +0200, Paolo Abeni wrote:
> On 7/8/25 6:43 PM, Paolo Abeni wrote:
> > On 7/8/25 6:00 PM, Michael S. Tsirkin wrote:
> >> On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
> >>> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
> >>>>> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
> >>>>>
> >>>>> The first 5 patches in this series, that is, the virtio features
> >>>>> extension bits are also available at [2]:
> >>>>>
> >>>>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> >>>>>
> >>>>> Ideally the virtio features extension bit should go via the virtio tree
> >>>>> and the virtio_net/tun patches via the net-next tree. The latter have
> >>>>> a dependency in the first and will cause conflicts if merged via the
> >>>>> virtio tree, both when applied and at merge window time - inside Linus
> >>>>> tree.
> >>>>>
> >>>>> To avoid such conflicts and duplicate commits I think the net-next
> >>>>> could pull from [1], while the virtio tree could pull from [2].  
> >>>>
> >>>> Or I could just merge all of this in my tree, if that's ok
> >>>> with others?
> >>>
> >>> No strong preference here. My first choice would be a branch based
> >>> on v6.16-rc5 so we can all pull in and resolve the conflicts that
> >>> already exist. But I haven't looked how bad the conflicts would 
> >>> be for virtio if we did that. On net-next side they look manageable.
> >>
> >> OK, let's do it the way Paolo wants then.
> > 
> > I actually messed a bit with my proposal, as I forgot I need to use a
> > common ancestor for the branches I shared.
> > 
> > git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> > 
> > is based on current net-next and pulling from such tag will take a lot
> > of unwanted stuff into the vhost tree.
> > 
> > @Michael: AFAICS the current vhost devel tree is based on top of
> > v6.15-rc7, am I correct?
> 
> Which in turn means that you rebase your tree (before sending the PR to
> Linus), am I correct? If so we can't have stable hashes shared between
> net-next and vhost.
> 
> /P

We can, I can merge your tree after rebasing. It's a hassle if I rebase
repeatedly but I've been known to do it.

If this is what you want, pls just base on some recent RC by Linus.

-- 
MST


