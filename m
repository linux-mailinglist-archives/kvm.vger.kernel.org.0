Return-Path: <kvm+bounces-42009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63897A70E19
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 01:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 893C77A533C
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 00:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7B72BAF9;
	Wed, 26 Mar 2025 00:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWjbrOoI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C50046BF;
	Wed, 26 Mar 2025 00:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742947914; cv=none; b=BIE9i47+f94Qr7K2cOuz1zctz1EU71zBocf1qqIKsqgXxSwfiha6arIjKoZoyGQcQRpl8deHC1bAUfri8BvHJObGBAj138KGsmGeU7rJDK9D7uXmQWi8DS4E4sJ2WfXhK01ozip81FQeW5qKau/UO8Q9cmyDqMO7WrmTEV4ARz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742947914; c=relaxed/simple;
	bh=Ds5elK0EiYSgBbG1o5wtpaJmT1vD/nl22PdcXN437WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mak/FPWX+TefDV2gBa99z4IZxXMN4N1cJoSiJMt8ci12oP2DidNlv3m69jlxQbXrUzVAJ7Ae7+EvbT54sM8kWTVkzg3ZuwWnF8jw3sDXZHSRy3V+BFN59asnxm5qeNh7mn+w8Xq1TSiwbXcOmy3jZz4kdQ6wj0gwQtLGAmVyc7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWjbrOoI; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22580c9ee0aso128083715ad.2;
        Tue, 25 Mar 2025 17:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742947912; x=1743552712; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CY8eIyZm61ckxiaVzTuPDCRXGNO6HtSN1mJX9W6zGQQ=;
        b=OWjbrOoIwKJw2PMhyNl8Aed5JtKyt7PpilTzzyAyQy1NYsmBqoOwM5O8ajazIAWDpy
         Lyf92+Iel+3/zgIAAhpnJ7UI8MwqXNHp1uuGYZHbzzubo9Q7F32tmmrp6TVS6UxIfhW4
         1jxtpDgnDy6WjjO52onyadpNwcmOFUVopRFMHu/K64ZkZzODleyotFKJnbJQkzczbFe6
         W+sSPpQNnGVUO6+1IVsygG85yK6jiGP+npE9dOb+lakD0OedIJ7GmvqKjrYTGLudnhke
         Lk4Zgxf4olyOTl1c4+a7Yg3k2ApHv796wpAM9Lv0o2bY0AWgEdp9E6x6CccpSd2ZoZKb
         /a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742947912; x=1743552712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CY8eIyZm61ckxiaVzTuPDCRXGNO6HtSN1mJX9W6zGQQ=;
        b=Ji7Vx8Yp2B+yptMbM6GXiU53WRdN4dlFbVgV5zfpYdhajIGP81w1orfmDmHfK/Z9ed
         D2uamK3yM1Rim9eK/oAhfEfON7N5s/wWPhhhlVBXqWaStxhm/gek9/9f+aKtHS6HDAFj
         vwAg5c/pAI4NUS4vk8Wy4j51sqXSGyl/Sd9ZUImwj+pUpOQDbSdyawW8wunCw3ZpSoV7
         Gv2rKyQ5JhonOBwzeZVfAKnB9dCAtohH+4h2UJxskDjtvlYNtHcEi/xUSQ8ylDPxjc5B
         KAkW5aMvb2JvUuTvENTG/sfwrdhtR3/ptfF3JzTeu/qWxVlXVM1vmIAvkKFbPCArTaMS
         wbrA==
X-Forwarded-Encrypted: i=1; AJvYcCUDDixAYhmR9Xf50VY6mplwfx4bMSIBVQePY4NMYgzVJKg7DBqTbeGjnuHfUhxaorX8M06xLUn3@vger.kernel.org, AJvYcCVd4KRGVv29IKZCkdWKo5Y0Z58/hV1THo0Nc/gqG0z0M2fy/UCSWtbYIDiefa4woahZe84=@vger.kernel.org, AJvYcCWlho2IIr/FxL3Kp5F6i4P0jIn5OkrTiBnASYGuzoh0NWkDEBMP683kt2yri6HxqoYmnsBCncsA5VmqMyQC@vger.kernel.org, AJvYcCWlkLPzEl5tPxodAyvwpw5B95f8QQwrFyH+O6pGE+orGjKXShhCoypMbGf1TUDvwM5WPjkH0e36Ir4BRRGv@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKsvjoCiGK+qhHkGDbdwyH2A12Sa1OgHmuuUFiayjClIGHnY1
	qZk5h3WqJBoHPgXM9tEwqidUGjWt3dfWSaunGDXwLGesLFxM55kH
X-Gm-Gg: ASbGncvKbpBAhQy1FsV0eXD0JTy03T+X71sUtG9eU3CiUIvxtSChIJJZEWi9HInUQ81
	GBS5XWIK+mVNAY0jEtDvkQ21nYF/seZJUti7ZXDRQw8VO9pfvptBoRhfFQpZJINLh+cEDvXf9KM
	u1z/EOIxxL5csEfoLgLMCYYcREKHy/OvBfH1Yxawuvoa0MGudr9wLaDBFFX2mwgKdJLwwAZC6q9
	qFarNzeYHcYr1fZpkXuABb9iJviTZfUkOQDOlLSiD84BOlX2WLXAQrRCGOoSK3Epq1dtLLENe/p
	0DSh9wxaAcAGZlqmPtzqh0gP7WJmJJFD0CyhLJA4bnMFIHsDjTsZs1gIBQzen/50wg==
X-Google-Smtp-Source: AGHT+IHxY4Vgr8ATi1uVdyopW2+f/aLhWWNzfk7UHIfMOoRiFLbmaJkjO523spjjVjgNAJSnkFxkQQ==
X-Received: by 2002:a05:6a21:339a:b0:1f5:51d5:9ef3 with SMTP id adf61e73a8af0-1fe42f995edmr26069754637.20.1742947912351;
        Tue, 25 Mar 2025 17:11:52 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:8::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a280e572sm9690206a12.32.2025.03.25.17.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 17:11:51 -0700 (PDT)
Date: Tue, 25 Mar 2025 17:11:49 -0700
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
Message-ID: <Z+NGRX7g2CgV9ODM@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
 <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
 <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>
 <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>

On Fri, Mar 21, 2025 at 11:02:34AM +0100, Stefano Garzarella wrote:
> On Thu, Mar 20, 2025 at 02:05:38PM -0700, Bobby Eshleman wrote:
> > On Thu, Mar 20, 2025 at 10:08:02AM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
> > > > On 3/12/25 9:59 PM, Bobby Eshleman wrote:
> > > > > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> > > > >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
> > > > >
> > > > >  	vhost_dev_cleanup(&vsock->dev);
> > > > > +	if (vsock->net)
> > > > > +		put_net(vsock->net);
> > > >
> > > > put_net() is a deprecated API, you should use put_net_track() instead.
> > > >
> > > > >  	kfree(vsock->dev.vqs);
> > > > >  	vhost_vsock_free(vsock);
> > > > >  	return 0;
> > > >
> > > > Also series introducing new features should also include the related
> > > > self-tests.
> > > 
> > > Yes, I was thinking about testing as well, but to test this I think we need
> > > to run QEMU with Linux in it, is this feasible in self-tests?
> > > 
> > > We should start looking at that, because for now I have my own ansible
> > > script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to
> > > test both host (vhost-vsock) and guest (virtio-vsock).
> > > 
> > 
> > Maybe as a baseline we could follow the model of
> > tools/testing/selftests/bpf/vmtest.sh and start by reusing your
> > vsock_test parameters from your Ansible script?
> 
> Yeah, my playbooks are here:
> https://github.com/stefano-garzarella/ansible-vsock
> 
> Note: they are heavily customized on my env, I wrote some notes on how to
> change various wired path.
> 
> > 
> > I don't mind writing the patches.
> 
> That would be great and very much appreciated.
> Maybe you can do it in a separate series and then here add just the
> configuration we need.
> 
> Thanks,
> Stefano
> 

Hey Stefano,

I noticed that bpf/vmtest.sh uses images hosted from libbpf's CI/CD. I
wonder if you have any thoughts on a good repo we may use to pull our
qcow image(s)? Or a preferred way to host some images, if no repo
exists?

Thanks,
Bobby

