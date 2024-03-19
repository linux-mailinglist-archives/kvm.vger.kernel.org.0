Return-Path: <kvm+bounces-12177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C102880558
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 20:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA405283DCC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E27939FFE;
	Tue, 19 Mar 2024 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZe70Yz7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0839FC1
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710876282; cv=none; b=KtOlKZ9RukTHEFR1ot2Qumr56CN6TB7EUHsd/6LJ3Ol7mr+loUoLQofk5MfCf3f6dlDSyJGosNio5SbJQI8RK3cg29zWnkN+bbuPTo2ZpSOVXBOvTXmHJ1ym1oEsdqkh60CyjtTAGjniN3sMeMyTvBcCgX52zSjCg3avlNWBtqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710876282; c=relaxed/simple;
	bh=SPOcqFOa4IEJC4nSqQwjCzcE1cmOqlod9iEJDt4l1Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7GjqSY/Zb+wpEUoJYsJwavaUOz2e9emGs5nUbFYHD/xzlB1FrHDsYOpLd8gMwXTyWvyOeUysDGLlQAXANiI6i9F4jBBWowluBbupPNI6A2f+KIWjg8GFeyaytuWOCo7RempyW4pAHmKOFJG3oFrzqfxgJQyD/KGpRvtROcVEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZe70Yz7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710876279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=054PSwUxcEoyTTyT0YXDp5Ih5pKTqj1jctjnvFZE9RA=;
	b=PZe70Yz7POOFOTaicoaaPjvQmXajtstRibO8+6qqDwpGZ/qoF3BH9xNv4FyhzIN/kKKj/i
	ROrF83qYX5wOUboYDxgd6LNQYLT8zjKC1cB6ykXH1ytPmoFgjc9ZRAfHOmxBP+SYk9+sSn
	4WVoRoHj1nXqRrSn91pvaTwrxy1C7ck=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-ajv8IHgKOKqmbY8Fs0tW_A-1; Tue, 19 Mar 2024 15:24:38 -0400
X-MC-Unique: ajv8IHgKOKqmbY8Fs0tW_A-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3416632aeffso1537239f8f.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 12:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710876277; x=1711481077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=054PSwUxcEoyTTyT0YXDp5Ih5pKTqj1jctjnvFZE9RA=;
        b=jB/Y0IbnXXgF9xwxQqLYQS6El8pZz8c7SUinEeWNSmo899Jzztgu9PBuU/YR2OH9+0
         P0fuq6rRCGr2SZRdHEEJXClCCM7GElP2Q0Egn6ePBDBbFDx+9fKEqamfwkNUhHNp0aIi
         DH1I3gEUWQR3dAj6WWT4X+CAe/09YphoGm7aguE4rImkMlCPkvwgUkBS/Bk/O+RhMC+w
         quQ0AezVGAmFfMBOVHJcv3sABqtHdI/5aY9JRaKkdvjA196IR5EF6mq2C14N85Orcq2o
         QZK/jZziL8g2cx87zqLFztov/jitRty8w3rLjEeJA4kERkldvw+IucgMUb8ob5IEdRdy
         ccMA==
X-Gm-Message-State: AOJu0YyfSOyN42gK1qWB2GvofDLQPlyLLJNe96/nnHtHnq5yLq54XdeM
	4Y+pMzTeMg6k+CSunhOGFI6VmNeMw/8jbpVvf6PgsjNYs6TEJvaYV+MRsovqd9O+jvNjCKoVQU7
	/NsW9w1Ccz6ihgnHP2e4I85k7KBQNbjdsMDgwh81ATvH12NQJVg==
X-Received: by 2002:a05:6000:104e:b0:33e:d1fa:6627 with SMTP id c14-20020a056000104e00b0033ed1fa6627mr7835983wrx.50.1710876277023;
        Tue, 19 Mar 2024 12:24:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQZid9lWxUAfX9KUhv4EBBJ2gUziSxS4M3VUS2nzuzhpo41M0C+zkRsiu9Q7+Z7XgReUIshA==
X-Received: by 2002:a05:6000:104e:b0:33e:d1fa:6627 with SMTP id c14-20020a056000104e00b0033ed1fa6627mr7835957wrx.50.1710876276421;
        Tue, 19 Mar 2024 12:24:36 -0700 (PDT)
Received: from redhat.com ([2.52.6.254])
        by smtp.gmail.com with ESMTPSA id v3-20020adfe4c3000000b0033e052be14fsm12994886wrm.98.2024.03.19.12.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 12:24:35 -0700 (PDT)
Date: Tue, 19 Mar 2024 15:24:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, andrew@daynix.com, david@redhat.com,
	dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com,
	gregkh@linuxfoundation.org, jasowang@redhat.com,
	jean-philippe@linaro.org, jonah.palmer@oracle.com,
	leiyang@redhat.com, lingshan.zhu@intel.com,
	maxime.coquelin@redhat.com, ricardo@marliere.net,
	shannon.nelson@amd.com, stable@kernel.org,
	steven.sistare@oracle.com, suzuki.poulose@arm.com,
	xuanzhuo@linux.alibaba.com, yishaih@nvidia.com
Subject: Re: [GIT PULL] virtio: features, fixes
Message-ID: <20240319152109-mutt-send-email-mst@kernel.org>
References: <20240319034143-mutt-send-email-mst@kernel.org>
 <CAHk-=wi363CLXBm=jB=eAtJQ18E-h4Vwrgmd6_7Q=DN+9u8z6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi363CLXBm=jB=eAtJQ18E-h4Vwrgmd6_7Q=DN+9u8z6w@mail.gmail.com>

On Tue, Mar 19, 2024 at 11:03:44AM -0700, Linus Torvalds wrote:
> On Tue, 19 Mar 2024 at 00:41, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > virtio: features, fixes
> >
> > Per vq sizes in vdpa.
> > Info query for block devices support in vdpa.
> > DMA sync callbacks in vduse.
> >
> > Fixes, cleanups.
> 
> Grr. I thought the merge message was a bit too terse, but I let it slide.
> 
> But only after pushing it out do I notice that not only was the pull
> request message overly terse, you had also rebased this all just
> moments before sending the pull request and didn't even give a hit of
> a reason for that.
> 
> So I missed that, and the merge is out now, but this was NOT OK.
> 
> Yes, rebasing happens. But last-minute rebasing needs to be explained,
> not some kind of nasty surprise after-the-fact.
> 
> And that pull request explanation was really borderline even *without*
> that issue.
> 
>                 Linus

OK thanks Linus and sorry. I did that rebase for testing then I thought
hey history looks much nicer now why don't I switch to that.  Just goes
to show not to do this thing past midnight, I write better merge
messages at sane hours, too.

-- 
MST


