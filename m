Return-Path: <kvm+bounces-41601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6E5A6AF8E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC3ED981C73
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 21:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FA922A7E3;
	Thu, 20 Mar 2025 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4hQz/hC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB621BD01D;
	Thu, 20 Mar 2025 21:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742504744; cv=none; b=B5UzY11c3DFs4O8rpVva3l8p+Z1gVpFYZkQxHJIGl6Ou7HXqmQZBKTs96eQVQfUYu4bl/Yj0iLoKZI0hzno3X94so3IiVUNMfsTuoWYLuEOPvENqocD9Zw57xnJiMyMMWntxAEEbmmcymiuzDMguh1HCHeqfLemcr1SXgr8o234=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742504744; c=relaxed/simple;
	bh=YgdpRvORfQrJXyGjouHiXsPKxSh1pKbm6IQi0Z4fEqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUk2qYyZJ7mlvIrLD99CUFjnA9huYt8WKC+h4M4vj+WhrqOn4quQtLkC7WumW6GcBTHYopPOyIwUd0hJtweSt4BIum1ZJ8K1vr+PxT4OS4HSHwhSnIVxNNQSnLYoUJ3iFdmQJV6lo76RB3O96jBbVetGC88rlGQk6qFADMKgrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4hQz/hC; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223fb0f619dso26686065ad.1;
        Thu, 20 Mar 2025 14:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742504741; x=1743109541; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jPDdAZsU2RRMMAuFebBCueBYeGg/JKuNefmjD9nyKY=;
        b=f4hQz/hCoDzmcVqX69VzFkchC9WiShFUEsaTUZoSlXwWS2Cgi7rDvgzKeFY6vkAK1J
         eSI9eb7+VlQzuxFEZ9KXV4aZj0lo96pMTTzyKr8oysl+B6sa1IwnotwTvki80bGvmKUQ
         6QsKaqYfMNTJalmlfEqW+d6fwDHynj1VW3Qc+FCpQFr3br79eGkLGvw4WwPx55XFyaUX
         Y7PrsrF2CVyjmmC1k7UsaORhOy/PXO/V0iYPhwTB4lmGVHKgT/fTJIeRUjDanvygbtS6
         q5HZLqJPtRuVwzCaEXMM3I0XQ+zHsU0Gsh3WVdiY/xp6O+PFyK6llhfotXSodICrNpCE
         BGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742504741; x=1743109541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jPDdAZsU2RRMMAuFebBCueBYeGg/JKuNefmjD9nyKY=;
        b=T9+Se1v/TXMjkDn+dgaokaxf2eY6PRKKWlyo+YWP4TPf8PngOi2QxTJRe9f/Dht22f
         OMyGluEvRc/IKP9DWQILpZz40pHaCivGtNrdmudXXbx3tfTSG6h2S0jlbKIdZ9WweI1G
         /YWz7eEvzStj72hKRVvVuBkofyGaOTGHA+2H5/BNWicCMa27Gc8O9dxwmsr4n/K6SMdx
         43RYYWDdBZ+g3yzWD7laXiTA3PJuUcifU4E4rOgDxhe8aeXUoFbyr9XBbXmqa2zKqr+p
         ebz5gN9Cy/8HprXBDvcXUs6HFPP+8aZas2Tha7J6juZQvL4A0QCq5ijexqGfDHXe47/T
         DMJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg/8t8XZBWS4RRRzPWxUubAL6PbGIIwbsyZQ7wTYYoGpWSQTxtuekFBd1BX4lWCaNzIHOowlyL@vger.kernel.org, AJvYcCVPuGR2HOTnttZz/iSvDg5OhODi9hSmsUGpyy/0dpsmUQrj0RUreVLJ8pJox9s7PtYRe8V62Gu81mjBHAf5@vger.kernel.org, AJvYcCVVdxJSR+YV6ugk70K+6HiL4KgULCfxUBrr62Cl4dvKU4n8H2iRsd6Phs4qMSIdyJgOP9g=@vger.kernel.org, AJvYcCWhRis8wexgLlWAMuKtce7lFZTHM98OZJaUxAhtE3fNPuV7AgCv/by1M8hepHEx8boSvs/Q5zRLPHKJK38r@vger.kernel.org
X-Gm-Message-State: AOJu0YwL9RdsZjQ3geDm7+7Xap9RjKxF0EVm5VB8/J/YawUZWp33x+Z4
	2eCKv2MgonsmHQh2IMgHx4rVAs24rhCVOf2B819kUFZmzZVtLsdc
X-Gm-Gg: ASbGnctKQmgAnIyYMyi/ezzmnuqwML+jB6z7cVNo1/uNJV7UiMeTc5o+x03P7u1Shmo
	ngu7aFjFchGvF+edZWVPYEDYvVKB3sI8shNcPmJrOPxpgZuvwNM1OpQ4VyHogv2YC28ma8wi8a3
	z39fkMnFnXSE7nSYIV1KpNqKvDLv0rrfE5kN28ONFiiJ9jEoxho4LPTKBbYJjwOkMIGCnxmIRmR
	1xk+B5cqH5xDqzBhUpFn6te4jM3iLiIp3yX9Mrd9i2kZ8vUZi45pGqZW19MF7Hsnf4jEvSRV2Zd
	FiDeXL+FRAKihhGFXboFnd8cktZ0FNHqq9Sq7d1ZaUb/lmfWkeQXJwYPL0JGkcxQCQ==
X-Google-Smtp-Source: AGHT+IGByHBrbBgXXk1MNKK8PoOJzGBZqACnvtAZVXwzJ5Mt98hUmINKtxNrRQVVmQU2iZkin8qKTA==
X-Received: by 2002:a17:903:182:b0:223:653e:eb09 with SMTP id d9443c01a7336-22780c50a59mr11694335ad.7.1742504740770;
        Thu, 20 Mar 2025 14:05:40 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2278120981fsm2458075ad.250.2025.03.20.14.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 14:05:40 -0700 (PDT)
Date: Thu, 20 Mar 2025 14:05:38 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
 <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>

On Thu, Mar 20, 2025 at 10:08:02AM +0100, Stefano Garzarella wrote:
> On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
> > On 3/12/25 9:59 PM, Bobby Eshleman wrote:
> > > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> > >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
> > > 
> > >  	vhost_dev_cleanup(&vsock->dev);
> > > +	if (vsock->net)
> > > +		put_net(vsock->net);
> > 
> > put_net() is a deprecated API, you should use put_net_track() instead.
> > 
> > >  	kfree(vsock->dev.vqs);
> > >  	vhost_vsock_free(vsock);
> > >  	return 0;
> > 
> > Also series introducing new features should also include the related
> > self-tests.
> 
> Yes, I was thinking about testing as well, but to test this I think we need
> to run QEMU with Linux in it, is this feasible in self-tests?
> 
> We should start looking at that, because for now I have my own ansible
> script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to
> test both host (vhost-vsock) and guest (virtio-vsock).
> 

Maybe as a baseline we could follow the model of
tools/testing/selftests/bpf/vmtest.sh and start by reusing your
vsock_test parameters from your Ansible script?

I don't mind writing the patches.

Best,
Bobby

