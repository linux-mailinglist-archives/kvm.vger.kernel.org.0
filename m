Return-Path: <kvm+bounces-34396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5D69FD506
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 14:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42727161AF2
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 13:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD5B1F4269;
	Fri, 27 Dec 2024 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRzyLXVm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79D1F3D2A
	for <kvm@vger.kernel.org>; Fri, 27 Dec 2024 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735307065; cv=none; b=MmVOKKt10vupANcNcX5HzegAVVVDY2scPSwcFz2BIyLuJ4bn7O3sSyq16JL6beOTolyMRnqveh5s5xIrM5kRcW4jRJSwroLHMCvbjdnjOkZZsNfbY2IbCS7xQ98izaevs54GFDYuwy3QL9VFP+ugsxcntzZl1YsZkrz1I5tIYE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735307065; c=relaxed/simple;
	bh=4zzYeNm0G4x5an1ENK8T8ax8KmpB59TZG1+p2SFmR4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYjtKatAmyDHuCDflrv88k3KGHGtH740xWRtl13t0cYoBX2v297VC0JrzNRWrEVxLYQ6obiwkfbxRqiBiebt4FwJmxc6mANHx6B8kwPHGKqRyGmKgqbnCzUewmUybZbpn4ZsnayxUt2Q1mlg+ROV5boBsaqjhIDfXB8nzit+L8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DRzyLXVm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735307062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkRABZZKzYakdwICymJuZ/C6pfybaqvIa9Xu1kFl1Eo=;
	b=DRzyLXVm9nHJ1cWKWQ3XH+Nkvoo1BsvpzNFGfmGzAdeNtCcVvI5V/6auBefCkDVERWvmpb
	KrYe0St3udSRaOLoLOtRHhiee8AvjTvs4BTtfL3B4Cp4t6Ad9dsv7V1yKfWcXBGoEBMEV6
	r0oBd26GvU+sSK3WSZc48lH8aWlVvGs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-ZzlUp7kJNbiMX0ShLeq-Ag-1; Fri, 27 Dec 2024 08:44:21 -0500
X-MC-Unique: ZzlUp7kJNbiMX0ShLeq-Ag-1
X-Mimecast-MFC-AGG-ID: ZzlUp7kJNbiMX0ShLeq-Ag
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436723db6c4so37116845e9.3
        for <kvm@vger.kernel.org>; Fri, 27 Dec 2024 05:44:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735307060; x=1735911860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pkRABZZKzYakdwICymJuZ/C6pfybaqvIa9Xu1kFl1Eo=;
        b=u2Hq4mmBUEX2IwbCRgKA1y8Ehql9LA/XE4zEVHE3gSEJkYFpJzNKdqR+nlBUn/yOkF
         poo0Pi6qqLwigUFxbsSlwSKsWpVt+1ImlTOsTLC6abbfUsCtiPUAilH4PPocTJC0iTCT
         M561O/TdOg4RsfRHCIU3MOw/KB+Nzs5jPmrTqJUWX5k/oJxIV4+GnbsoSv3U3dWYYQ+/
         v/ujIb2jQ2FkLptPlcoFbjf9AzvS0qGOsqP7Hnm49R6AJL7HO3lV68wk9V09SlaXtyvt
         iEdVdTKZ38fYzmX+gNbpzSYYt0rMDRwYZCd32uR/Irqv7+9bhc53rexcskzQRQtEXBlu
         2p5w==
X-Forwarded-Encrypted: i=1; AJvYcCWI28jcy+1AIguUDGK4f1H+Zn/M3TRgRU2W2qP1OFGq2NMF+hCb6DkA1+YhhbqGqLN0LhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpCUbMsz9YvAUuUJyxe1KL5TKr5PVN93dx3MCqJvVGzbNK384f
	xVCw6IgRCgj5W34/a5xBNHhuEcgsLyBKCgATVk/JygaEn4ZCBNHqcEr7x472ZVPmYV9KT/0bhGr
	uSUudALxmEfBJIWtpVmDenQkmkrevtifJm7hKAtrrXI2syRvBog==
X-Gm-Gg: ASbGnctlqoD/sTHF87gc33bYGlTl7UT1xlr5PktaBJpph8mOh6vlhAy3QKsNkD8PbRn
	wMgiG2OSE7PkE/FJUK9RldJndDzoJ2Te9ZccfeR7BtEq/HakugmjtoFyZrE21bjyuSO5WN23wY9
	yR0sielQ/VgAagEg07VtXZhBCm+7Y7nmsXx45CwDAtozOCpAVBtxezO6+v4teDf+Nzc29jG07B6
	LrQVlkTOXq6zYKsmLpnSAaEtiqoMmWyORNkS8IsVWVwIFYYTZA=
X-Received: by 2002:a05:600c:350c:b0:434:a5d1:9905 with SMTP id 5b1f17b1804b1-43668b78641mr208446355e9.26.1735307059837;
        Fri, 27 Dec 2024 05:44:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMBCH5XUAoqBvte6a9jZzUG4oYDe/byrgsu79u/bNlDM1cNL3Mq9Ew3V/u/ELxCrULVT1bWQ==
X-Received: by 2002:a05:600c:350c:b0:434:a5d1:9905 with SMTP id 5b1f17b1804b1-43668b78641mr208446135e9.26.1735307059443;
        Fri, 27 Dec 2024 05:44:19 -0800 (PST)
Received: from redhat.com ([2a02:14f:1ef:ad82:417b:4826:408d:ef87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366127c4d7sm265112715e9.34.2024.12.27.05.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2024 05:44:18 -0800 (PST)
Date: Fri, 27 Dec 2024 08:44:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/net: Set num_buffers for virtio 1.0
Message-ID: <20241227084256-mutt-send-email-mst@kernel.org>
References: <20240915-v1-v1-1-f10d2cb5e759@daynix.com>
 <20241106035029-mutt-send-email-mst@kernel.org>
 <CACGkMEt0spn59oLyoCwcJDdLeYUEibePF7gppxdVX1YvmAr72Q@mail.gmail.com>
 <20241226064215-mutt-send-email-mst@kernel.org>
 <CACGkMEug-83KTBQjJBEKuYsVY86-mCSMpuGgj-BfcL=m2VFfvA@mail.gmail.com>
 <cd4a2384-33e9-4efd-915a-dd6fee752638@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd4a2384-33e9-4efd-915a-dd6fee752638@daynix.com>

On Fri, Dec 27, 2024 at 01:34:10PM +0900, Akihiko Odaki wrote:
> On 2024/12/27 10:29, Jason Wang wrote:
> > 
> > 
> > On Thu, Dec 26, 2024 at 7:54 PM Michael S. Tsirkin <mst@redhat.com
> > <mailto:mst@redhat.com>> wrote:
> > 
> >     On Mon, Nov 11, 2024 at 09:27:45AM +0800, Jason Wang wrote:
> >      > On Wed, Nov 6, 2024 at 4:54 PM Michael S. Tsirkin <mst@redhat.com
> >     <mailto:mst@redhat.com>> wrote:
> >      > >
> >      > > On Sun, Sep 15, 2024 at 10:35:53AM +0900, Akihiko Odaki wrote:
> >      > > > The specification says the device MUST set num_buffers to 1 if
> >      > > > VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> >      > > >
> >      > > > Fixes: 41e3e42108bc ("vhost/net: enable virtio 1.0")
> >      > > > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com
> >     <mailto:akihiko.odaki@daynix.com>>
> >      > >
> >      > > True, this is out of spec. But, qemu is also out of spec :(
> >      > >
> >      > > Given how many years this was out there, I wonder whether
> >      > > we should just fix the spec, instead of changing now.
> >      > >
> >      > > Jason, what's your take?
> >      >
> >      > Fixing the spec (if you mean release the requirement) seems to be
> >     less risky.
> >      >
> >      > Thanks
> > 
> >     I looked at the latest spec patch.
> >     Issue is, if we relax the requirement in the spec,
> >     it just might break some drivers.
> > 
> >     Something I did not realize at the time.
> > 
> >     Also, vhost just leaves it uninitialized so there really is no chance
> >     some driver using vhost looks at it and assumes 0.
> > >
> > So it also has no chance to assume it for anything specific value.
> 
> Theoretically, there could be a driver written according to the
> specification and tested with other device implementations that set
> num_buffers to one.
> 
> Practically, I will be surprised if there is such a driver in reality.
> 
> But I also see few reasons to relax the device requirement now; if we used
> to say it should be set to one and there is no better alternative value, why
> don't stick to one?
> 
> I sent v2 for the virtio-spec change that retains the device requirement so
> please tell me what you think about it:
> https://lore.kernel.org/virtio-comment/20241227-reserved-v2-1-de9f9b0a808d@daynix.com/T/#u
> 
> > 
> > 
> >     There is another thing out of spec with vhost at the moment:
> >     it is actually leaving this field in the buffer
> >     uninitialized. Which is out of spec, length supplied by device
> >     must be initialized by device.
> > 
> > 
> > What do you mean by "length" here?
> > 
> > 
> > 
> >     We generally just ask everyone to follow spec.
> > 
> > 
> > Spec can't cover all the behaviour, so there would be some leftovers.
> > 
> >        So now I'm inclined to fix
> >     it, and make a corresponding qemu change.
> > 
> > 
> >     Now, about how to fix it - besides a risk to non-VM workloads, I dislike
> >     doing an extra copy to user into buffer. So maybe we should add an ioctl
> >     to teach tun to set num bufs to 1.
> >     This way userspace has control.
> > 
> > 
> > I'm not sure I will get here. TUN has no knowledge of the mergeable
> > buffers if I understand it correctly.
> 
> I rather want QEMU and other vhost_net users automatically fixed instead of
> opting-in the fix.

qemu can be automatic. kernel I am not sure.

> The extra copy overhead can be almost eliminated if we initialize the field
> in TUN/TAP; they already writes other part of the header so we can simply
> add two bytes there. But I wonder if it's worthwhile.

Try?

> Regards,
> Akihiko Odaki


