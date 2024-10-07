Return-Path: <kvm+bounces-28072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 141419931EE
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE4E81F23680
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6BC1DACB0;
	Mon,  7 Oct 2024 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gset2AdH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6A1D95BA
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728316033; cv=none; b=BxZ8TSNH0WweZhHxXFWNr3WGAPsB70m1eDdipxlRAdbhJZhGqVwXaiv0Sqp53cbYFWFY5Piin95Lxqj+CeVmXxEfWghfia2pgPFYScQW4bk+XT6UiwL6vL8xdvwNYkmUeHppwaa5bk0KyvfuW6OX/Xy/WIKPv1u/DCMMW3Np3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728316033; c=relaxed/simple;
	bh=DQZCNIJ48pE5/m76HV8ZC97oJTUUoycjro9TNIIqwwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuMAT7ur9BoJ0rxZ6Glrb2ojhBPjjXQJfJnAo2riy/lisiHQcswq6IyQ0PmIDgTF1mSw3X58Arnr34BvlEdM8DSIdlWEhpqlO5rHV95SUNtMtBWrp9FNqvPXG8oB/l+8Obw7ksyDa1tDJiyFhJZseGZ58w5+EftmAwPahGPKYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gset2AdH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728316031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/qSM1gi+xzbWol0GgR9iU7ZEDf5izrAUc1BvVzk/UM=;
	b=gset2AdHW3G7CNgu3YRex9lVmKwCC8IwvtP/WOSic/5A7d530JEO5b/49ySfk2M6QfmcCn
	Dm8ASKrAhsOiefdsA7zF94Y0ACbIdWl4g/MegATC1l9KRh+ljM8Q492hMGjxkVDaMz0/Qq
	/hHAAupzlJmmBUcmhYfB4VIv0YV/TcE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-XzQjk5nWPs23chF31j7tSQ-1; Mon, 07 Oct 2024 11:47:10 -0400
X-MC-Unique: XzQjk5nWPs23chF31j7tSQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5398863cdfeso3461949e87.3
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 08:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728316028; x=1728920828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/qSM1gi+xzbWol0GgR9iU7ZEDf5izrAUc1BvVzk/UM=;
        b=CNlNINMaq7Jx8kHImpUm76xYbwNKnAcd6RYIs6Rf+E3zL9gX88LxHzbrLVQF7Jl07p
         qLwxI9gWaO9GaP09Me+eP6Bd0PpMSshY9hS1iRWwLS9uYN0Z64HUEa6FCTSI6BzRbTux
         Gh8tx9PUqt3DPq3bFDaFzonX18vDhN8+YTfRlHviTCzgz2TWSVLkXeu/o6gwgI8UUG/K
         ldiG2d+z/2E3GKMlV1fuwhnSE9YbWeCmGiHT9Uf/+8KVwvUrZeWp39A2a9I4IWgdwmaZ
         rL76OuoTzXRcvddbnLEuYMl9Jj1vwXmtOC6rIwr6qlI91oe9Mm3DrUxKj82X9qnDworn
         SQ5w==
X-Forwarded-Encrypted: i=1; AJvYcCUgBre+MCDUmpwNsUZWQFMk2z4lsYikvUTN++aYGH0Uln2ESdkWeEJ8PruIeSX2HPHqbr8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya+qY3kVdbhYQDkYFBNGP7h2DK990o/hwcOZp2pFEagQvDwGKW
	OAYDlP6HoxvwlIvJXtH0FAVJTdWQPwFsuIbQr9UahcX+7MC0YujYoArkNC/l3pErbZAiaQ+THRr
	phfL/F++V7DnD4rqHcej0QRzGsk2DIZU8U3YZb4jgG92epd6ANhThnJIVtg==
X-Received: by 2002:a05:6512:3b20:b0:52c:dbe7:cfd5 with SMTP id 2adb3069b0e04-539ab88ad63mr5809840e87.32.1728316028358;
        Mon, 07 Oct 2024 08:47:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI5CdxaS7NGjXGnhFpfvKBPg6dFQrE1IAMYDLqlZB8GcB73cj72b1bEGAmRYzgtVhZ1Lo4Kw==
X-Received: by 2002:a05:6512:3b20:b0:52c:dbe7:cfd5 with SMTP id 2adb3069b0e04-539ab88ad63mr5809803e87.32.1728316027827;
        Mon, 07 Oct 2024 08:47:07 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:8906:45ec:feb4:98e4:6184])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-539aff1d13bsm890443e87.139.2024.10.07.08.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:47:07 -0700 (PDT)
Date: Mon, 7 Oct 2024 11:46:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <luigi.leonardi@outlook.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Marco Pinna <marco.pinn95@gmail.com>,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Message-ID: <20241007114637-mutt-send-email-mst@kernel.org>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
 <20241007083920.185578a7@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007083920.185578a7@kernel.org>

On Mon, Oct 07, 2024 at 08:39:20AM -0700, Jakub Kicinski wrote:
> On Wed, 2 Oct 2024 09:41:42 -0400 Michael S. Tsirkin wrote:
> > virtio_transport_send_pkt in now called on transport fast path,
> > under RCU read lock. In that case, we have a bug: virtio_add_sgs
> > is called with GFP_KERNEL, and might sleep.
> > 
> > Pass the gfp flags as an argument, and use GFP_ATOMIC on
> > the fast path.
> 
> Hi Michael! The To: linux-kernel@vger.kernel.org doesn't give much info
> on who you expect to apply this ;) Please let us know if you plan to
> take it via your own tree, otherwise we'll ship it to Linus on Thu.

Hi!
It's in my tree, was in the process of sending a pull request actually.


