Return-Path: <kvm+bounces-58617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E34B988F4
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 09:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A4B4A47DB
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0EC727FB1F;
	Wed, 24 Sep 2025 07:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EiVlP46Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142E127BF93
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 07:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758699206; cv=none; b=Q4xlKeboEVBwK8oxZI7yuESWdmxdGtB6WtuO3YVkFMitR6o9CEm3BHk5JzvWmRPziVAml7CPkb7T9SqIQUJatABqNp133rw7RdgipE7Q/EUnB4HxGAEk5LRhTr0PWLHXjK87RkgjAoOoU5JoNTIJLFvI6EVjaS6AhK27l1qqseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758699206; c=relaxed/simple;
	bh=b6wRV+hU0qQluBXkA/BkhIVUgI+95DTwLYGQyvNsXeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aA7+5CN04oxSIMQX+5TzTg4++Bdnf8OOdr10USEiW+/AHfPmdi2vyBtG23bHtfjeVcNRxMWcMUSP8Bri6RKCaKru1vC6HuXfRYHg353UyDfZNxKiQIg3NOHr234+rUX/LOKtRRgxm7091cB+6zHzMBI/m89Y1t5h6mkghuQkCZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EiVlP46Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758699204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b6wRV+hU0qQluBXkA/BkhIVUgI+95DTwLYGQyvNsXeM=;
	b=EiVlP46YDyp/B5aKUv3gQZndp6q+iTovqUqHhUQL16R6tL3dF4fCCehimOvpV6txQlkqgr
	Wvvsb3jgMRPimfOqJqE/pyyhPVtY6/YbV8UQ4D+ouOgrjH84RWNugjByHVH3gIPOdMc8M0
	q+IKMUSe2p1+l1ktXZSmqvGRgl/w+xI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-MoL8TUK8MeGwuKMhLt8S0Q-1; Wed, 24 Sep 2025 03:33:22 -0400
X-MC-Unique: MoL8TUK8MeGwuKMhLt8S0Q-1
X-Mimecast-MFC-AGG-ID: MoL8TUK8MeGwuKMhLt8S0Q_1758699201
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-277f0ea6ee6so33687935ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758699201; x=1759304001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6wRV+hU0qQluBXkA/BkhIVUgI+95DTwLYGQyvNsXeM=;
        b=BNAWIq9gAZBA9WaqKyjtVE+GCqcbg0OzvR+ZP/gvk0Yaf1PIpFSOeB1J/0KeTDHu92
         HZM3W4iljz9YC5HTuDnl79yGzs5aouWmfgjA8S0T0vAY6KyU4ZmZE6wNjnRBglqhhfN2
         SVMs2JLdU41liJ//CSsqBW68JGn8j2XMRZIfFnoX9ggG2fuv9yP1EFFwf+T+GfIA/j6C
         /MCBb/M7CCJkLmznE5aSBbIvKJwaseFyJi9QxKeWuYu6MGGhTCHIH8/2/e7uhOWXGoDM
         qW+QB0WYBP7/S5W3CXQfq5NVYfjglTq+tnnzmIRCOBgauW83tPhrM9TGupUerhKlDOoC
         BOVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6SiyzsdCGireFvyxYrMt00bXPPGAENxnoMM8CVUSNayOwCSYoTkmEgaLVGL8ORisQxAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxncRPGTGCYDa7qfESNKWHTyp3g2eUyJwe/B0qarNrnMNF864R/
	rfei3uRvfFX5FFKeyXfhQ8Z0Y5V5YniDSxyB+8M9JIPzRglhst5ugOMpGPqQX7AhQB5eF+OnSxR
	LPSLARmeRrNbx96Jg0y5syswV74D0JpzqOSktzEaVjEYIe7sPglYDe5pJIs1jbWFIaM11XF6MAq
	MQyJ6E6NQLsbtPRhDCK+TJ+s6AvZOX
X-Gm-Gg: ASbGncsIY+UPeZW36gN/KcEeHcT8nMFRq1bW5dCfuKWMFWJbB6uzBZMC6lTMAMpFDCV
	NKtt9IWW3yzU/MySPUbEls1KsDQHv0aemeXObetwLLSXYnOS33wRnwE7gX/oPFGP3zqkdy5PKD6
	h4+7Gva1KyCzHtl/wmLg==
X-Received: by 2002:a17:903:190:b0:265:a159:2bab with SMTP id d9443c01a7336-27cbaf0e24amr61534925ad.0.1758699200942;
        Wed, 24 Sep 2025 00:33:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+14SJa59MjbvP9DJUdCwTBFSU+ad1kkLu/Xoi0kve8FMkca56Fj+oIDkby//sq4cwlX8+6BEG+AYJCQZEwnA=
X-Received: by 2002:a17:903:190:b0:265:a159:2bab with SMTP id
 d9443c01a7336-27cbaf0e24amr61534425ad.0.1758699200205; Wed, 24 Sep 2025
 00:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de> <20250924031105-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250924031105-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 24 Sep 2025 15:33:08 +0800
X-Gm-Features: AS18NWBSU_1fvQZUvaWmku_qO0_MGvBZjZq20karT9w3KYqASj9gmSz5-R3j6Bg
Message-ID: <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, willemdebruijn.kernel@gmail.com, 
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 3:18=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > This patch series deals with TUN, TAP and vhost_net which drop incoming
> > SKBs whenever their internal ptr_ring buffer is full. Instead, with thi=
s
> > patch series, the associated netdev queue is stopped before this happen=
s.
> > This allows the connected qdisc to function correctly as reported by [1=
]
> > and improves application-layer performance, see our paper [2]. Meanwhil=
e
> > the theoretical performance differs only slightly:
>
>
> About this whole approach.
> What if userspace is not consuming packets?
> Won't the watchdog warnings appear?
> Is it safe to allow userspace to block a tx queue
> indefinitely?

I think it's safe as it's a userspace device, there's no way to
guarantee the userspace can process the packet in time (so no watchdog
for TUN).

Thanks

>
> --
> MST
>


