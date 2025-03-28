Return-Path: <kvm+bounces-42184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC37A74E7C
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2526A7A2F03
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106961DC9BA;
	Fri, 28 Mar 2025 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SW/XGle3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCA6C2FA
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743178798; cv=none; b=ig8+xydScFmVQO+pl04yQvzlOncP1ZxAK0cR/MokvURqusxQqL4DyOqS7J7aKwv4l7UUaEOQP/QRG1WGMPouDt+uRL85YZ1UXkrYQIvDzpwMSXaArsaBec46LSJzpOusPb+Qi76/OxZDCZbLGe2+kCGAz/SvnT3mr2CwhQ7SjY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743178798; c=relaxed/simple;
	bh=Whw68NHJ0hBotbZLWHPLaLlBo9SwCWGnXSqmyMoyaU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bO/e6ynR31Da2lHGEhF/iF/itm2DCfaiE42V81wcZ5YNnv+pI11c1qVp6bPAT55NqCKwLU/Hv86abR2htzlxCdRDEpo+wmWFxK7HOF5dIhdRvMXlkfSbaqm9QPLlczyBuoZNvfj3ekNWYLFQPdQHEFPM+N17xHfv5gzS6ClaATg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SW/XGle3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743178795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1bv4vSlZ+ZgT91/khCHsXspSBzkGUyxwvtb8olODOX8=;
	b=SW/XGle3CRYeCfWjB90Ajg4BN/h20F66CokTFQOBtI4dR2bJ1cyYRDjXiwYjm5y/ScGSlm
	B59pemoLfkq/NQyKhjfnr0lbMRVnXPh458rNtkswrlYSg89PLGg5vccwxTxUQJKXn8DQvm
	4xkkAfYXl3wx9PocJHiJXxaEqhfCwIQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-wEpPKVlZNhS9AbgJPqxt1w-1; Fri, 28 Mar 2025 12:19:52 -0400
X-MC-Unique: wEpPKVlZNhS9AbgJPqxt1w-1
X-Mimecast-MFC-AGG-ID: wEpPKVlZNhS9AbgJPqxt1w_1743178792
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac3d3cd9accso186125066b.3
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 09:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743178792; x=1743783592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bv4vSlZ+ZgT91/khCHsXspSBzkGUyxwvtb8olODOX8=;
        b=m93h/d8kufuqToLzpHy5ZYyKwuJfgZmQSvNNQUM++JQR5U8vCBcqR/CDflSpIdSQN4
         04RJiwe8V0jXLXYhwVeYLi3GwME/ZGLGM0dsigi58qL3GmYkKcpMLf9KHz7qhE8ykn4y
         e8OiHv6VIpJHhfGk8I9ystsyirbvGTyaBJxgGo5GtsjKK6nB2zCGY1IVkx8Q+mS7xQwe
         jTgbDPRgBYLE7PWmwAkA3d/Z337eUb7N5HPO3mQzRjXErLy5fWjHrGhwvf36tncrj22C
         tJ/B9bTWsP3DG0fTwlj+QAPDmaJkT75wewP9RnMTnpkEMw6YoPtFfrik6rfu+gkHKKV+
         inog==
X-Forwarded-Encrypted: i=1; AJvYcCVdbR/ssQ9t/GzDfY3bumaw9UmBn36DDGm1GiD14sTK2CHwT8BmY+JgEjGa+EYU46Z4XXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV4gpcJJ3dKTRQPlHfHQ9rIcMCiDD5Xw/g9tQnr/4qRUrXNd6y
	7G82SuUVmDMcCgKGfam9j9rP/uWtHtbKVG7ec+JAPCxEA6edh7+qAVJla93NYjkkGptNDKmsGXr
	vdWir0SRUzrEDYQKgXnhXtvlA6QQCwomIROb/EZUWHLFAPpPC7A==
X-Gm-Gg: ASbGncsXlO2v8k0D4q9ho/TWNQSl7GjzxJxr7M/J+gjpD7TZuqJPTv8WO6xRhSAjWwn
	GAhd5vHJiUA4vevNXIEbp+hla5wyQ0wTtX+Db/VWagox15sP3VRtAD0c56La+XCPqucE5nYuVgB
	U4os3XOyrO8jUeJYKK3f866c0QfggsQYL4Tas7Gw07SglbNfvlIzKTa/8+xoQtEa2PLHwmSd2B3
	JIFVGoGu7HLt4ZfmaGgVGNvjjKVUwmFQ2JarxBVHOA8W5wAqs6Jmx5l0Xvytr9a4Zu8W+Ucgc51
	XBk2gqngLdVyLFhkcHwwQxD1V+Y6NCjje0sBt3Dx4jV4Ko4WpEFcPEpnzhky03xv
X-Received: by 2002:a17:906:f5a4:b0:ac3:b50c:c95b with SMTP id a640c23a62f3a-ac6fb15674amr880697966b.56.1743178791604;
        Fri, 28 Mar 2025 09:19:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOVwDFv2G5whldI68ZF2fstheYGaVbwdj4Strjz0nJgWz5XlzWG1eNLgBEm3hj5FiuUFxS2g==
X-Received: by 2002:a17:906:f5a4:b0:ac3:b50c:c95b with SMTP id a640c23a62f3a-ac6fb15674amr880694966b.56.1743178790938;
        Fri, 28 Mar 2025 09:19:50 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71971b700sm180408966b.181.2025.03.28.09.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 09:19:50 -0700 (PDT)
Date: Fri, 28 Mar 2025 17:19:44 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <3qjjlbwyso22n4ziylbeunfwpc7gl3rcin6v5qsr2npjfkbfjh@c745sejq6rig>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
 <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
 <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>
 <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>
 <Z+NGRX7g2CgV9ODM@devvm6277.cco0.facebook.com>
 <apvz23rzbbk3vnxfv6n4qcqmofzhb4llas27ygrrvxcsggavnh@rnxprw7erxs3>
 <Z+bJOsG457Vg/cUu@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Z+bJOsG457Vg/cUu@devvm6277.cco0.facebook.com>

On Fri, Mar 28, 2025 at 09:07:22AM -0700, Bobby Eshleman wrote:
>On Thu, Mar 27, 2025 at 10:14:59AM +0100, Stefano Garzarella wrote:
>> On Tue, Mar 25, 2025 at 05:11:49PM -0700, Bobby Eshleman wrote:
>> > On Fri, Mar 21, 2025 at 11:02:34AM +0100, Stefano Garzarella wrote:
>> > > On Thu, Mar 20, 2025 at 02:05:38PM -0700, Bobby Eshleman wrote:
>> > > > On Thu, Mar 20, 2025 at 10:08:02AM +0100, Stefano Garzarella wrote:
>> > > > > On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
>> > > > > > On 3/12/25 9:59 PM, Bobby Eshleman wrote:
>> > > > > > > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>> > > > > > >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>> > > > > > >
>> > > > > > >  	vhost_dev_cleanup(&vsock->dev);
>> > > > > > > +	if (vsock->net)
>> > > > > > > +		put_net(vsock->net);
>> > > > > >
>> > > > > > put_net() is a deprecated API, you should use put_net_track() instead.
>> > > > > >
>> > > > > > >  	kfree(vsock->dev.vqs);
>> > > > > > >  	vhost_vsock_free(vsock);
>> > > > > > >  	return 0;
>> > > > > >
>> > > > > > Also series introducing new features should also include the related
>> > > > > > self-tests.
>> > > > >
>> > > > > Yes, I was thinking about testing as well, but to test this I think we need
>> > > > > to run QEMU with Linux in it, is this feasible in self-tests?
>> > > > >
>> > > > > We should start looking at that, because for now I have my own ansible
>> > > > > script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to
>> > > > > test both host (vhost-vsock) and guest (virtio-vsock).
>> > > > >
>> > > >
>> > > > Maybe as a baseline we could follow the model of
>> > > > tools/testing/selftests/bpf/vmtest.sh and start by reusing your
>> > > > vsock_test parameters from your Ansible script?
>> > >
>> > > Yeah, my playbooks are here:
>> > > https://github.com/stefano-garzarella/ansible-vsock
>> > >
>> > > Note: they are heavily customized on my env, I wrote some notes on how to
>> > > change various wired path.
>> > >
>> > > >
>> > > > I don't mind writing the patches.
>> > >
>> > > That would be great and very much appreciated.
>> > > Maybe you can do it in a separate series and then here add just the
>> > > configuration we need.
>> > >
>> > > Thanks,
>> > > Stefano
>> > >
>> >
>> > Hey Stefano,
>> >
>> > I noticed that bpf/vmtest.sh uses images hosted from libbpf's CI/CD. I
>> > wonder if you have any thoughts on a good repo we may use to pull our
>> > qcow image(s)? Or a preferred way to host some images, if no repo
>> > exists?
>>
>> Good question!
>>
>> I created this group/repo mainily to keep trak of work, not sure if we can
>> reuse: https://gitlab.com/vsock/
>>
>> I can add you there if you need to create new repo, etc.
>>
>> But I'm also open to other solutions.
>>
>
>Sounds good to me. I also was considering using virtme-ng, which would
>avoid the need, at the cost of the dependency. What are your thoughts on
>that route?

I just saw that Paolo had proposed the same, but his response was 
off-list by mistake!

So I would say it is an explorable path. I have no experience with it, 
but it looks like it could do the job!

Thanks,
Stefano


